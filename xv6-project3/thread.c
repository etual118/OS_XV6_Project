#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"


extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
}ptable;
extern int nextpid;
extern void forkret(void);
extern void trapret(void);

struct spinlock pdlock;

static struct proc*
allocthread(struct proc *master)
{
  struct proc *p;
  char *sp;

  int i;
  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
  p->parent = p->tinfo.master = master;
  p->pgdir = master->pgdir;
  for(i = 0; i < NTHREAD; i++){
    if(master->threads[i] == 0)
      break;
  }
  if(i == NTHREAD){
  	return 0;
  }
  master->threads[i] = p;
  p->tinfo.tid = i;
  master->cnt_t++;
  return p;
}

int
allocstack(struct proc *master, struct proc *new){

	acquire(&pdlock);
	for(int i = 0; i < NTHREAD; i++){
		if(master->dealloc[i] != 0){
			if((new->sz = allocuvm(master->pgdir, master->dealloc[i],
			 master->dealloc[i] + 2*PGSIZE)) == 0){
			 	release(&pdlock);
				return -1;
			}
			master->dealloc[i] = 0;
			goto fin;
		}
	}
	if((new->sz = allocuvm(master->pgdir, master->sz, master->sz + 2*PGSIZE)) == 0){
		release(&pdlock);
		return -1;
	}
	master->sz = new->sz;
fin:
	clearpteu(master->pgdir, (char*)(new->sz - 2*PGSIZE));
	release(&pdlock);
	return 0;
}

int
deallocstack(struct proc *join){

	acquire(&pdlock);
	kfree(join->kstack);
	for(int i = 0; i < NTHREAD; i++){
		if(join->tinfo.master->dealloc[i] == 0){
			if((join->tinfo.master->dealloc[i] = deallocuvm(join->pgdir, 
				join->sz, join->sz - 2*PGSIZE)) == 0){
				release(&pdlock);
				return -1;
			}else{
				release(&pdlock);
				return 0;
			}
		}
	}
	release(&pdlock);
	return -1;

}

int 
thread_create(thread_t * thread, void * (*start_routine)(void *), void *arg){
	
	struct proc *thd;
	struct proc *master = myproc();
	uint t_ustack[3];
	uint sp;
	if(master->tinfo.master != 0){
		master = master->tinfo.master;
	}
	if((thd = allocthread(master) == 0)){
		cprintf("case 1 : cannot thread allocating\n");
		return -1;
	}

	if(allocstack(master, thd) < 0){
		cprintf("case 2 : cannot thread allocating\n");
		return -1;
	}

	*thd->tf = *master->tf;
	thd->tf->eip = (uint)start_routine;
	sp = thd->sz;
	// void ptr를 어떻게 처리해야하나?
	t_ustack[0] = 0xffffffff;
	t_ustack[1] = (uint)arg;
	t_ustack[2] = 0;
	sp -= sizeof(t_ustack);
	
	if(copyout(master->pgdir, sp, t_ustack, sizeof(t_ustack)) < 0)
		return -1;
	
	thd->tf->esp = sp;
	*thread = thd->tinfo;

	acquire(&ptable.lock);
	thd->state = RUNNABLE;
	release(&ptable.lock);
	return 0;
}

int
thread_join(thread_t thread, void **retval){

	struct proc *join;
	acquire(&ptable.lock);
	for(join = ptable.proc; join < &ptable.proc[NPROC]; join++){
		if(join->tinfo.master == thread.master 
			&& join->tinfo.tid == thread.tid){
			goto thdjoin;
		}
	}
	release(&ptable.lock);
	return -1;

thdjoin:
	
	while(join->state != ZOMBIE)
		sleep(thread.master, &ptable.lock);

	
	if(deallocstack(join) < 0){
		release(&ptable.lock);
		return -1;
	}
	
	if(retval != 0){
		*retval = thread.master->ret[join->tinfo.tid];
	}
	release(&ptable.lock);
	thread.master->threads[thread.tid] = 0;
	memset(join, 0, sizeof(struct proc));
	return 0;
}

void
thread_exit(void *retval){

	struct proc *curproc = myproc();
	struct proc *p;

  if(curproc == initproc)
    panic("init exiting");

  if(curproc->tinfo.master == 0)
  	exit(); // 예외처리 이렇게 해도되나?
  	

	acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->tinfo.master);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  curproc->tinfo.master->ret[curproc->tinfo.tid] = retval;
  curproc->state = ZOMBIE; //How to atomic??
  curproc->tinfo.master->cnt_t--;
  sched();
  panic("zombie exit");
}

struct proc*
thread_RR(struct proc* master){

	if(master->cnt_t == 0)
		return master;
	int i = master->recent;
	do{
		i = (i + 1) % NTHREAD;
		if(master->threads[i] != 0 && master->threads[i]->state == RUNNABLE){
			master->recent = i;
			return master->threads[i];
		}
	}while(i != master.recent);
	
	return master;
}

struct proc*
call_master(void){
	struct proc* p = myproc();
	if(p->tinfo.master != 0)
		p = p->tinfo.master;
	return p;
}









