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

// In case of multithreading, pgdir can
// under race condition.
struct spinlock pdlock;

// Makes basic structure of thread.
static struct proc*
allocthread(struct proc *master)
{
  struct proc *p;
  char *sp;

  int i;
	// thread is light weight process, so it is allocated
	// one of ptable's proc structure.
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
  p->parent = master->parent;
  // Master thread is saved in proc structure
  // thread can easily points master thread.
  p->tinfo.master = master;
  // Threads share the pgdir
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

// Allocate user stack to new thread.
int
allocstack(struct proc *master, struct proc *new){

	acquire(&pdlock);
	int i;
	// case 1 : find sz dealloc array
	// in dealloc array, has sz exit thread returned.
	for(i = 0; i < NTHREAD; i++){
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
	// case 2 : there are no size in dealloc array
	// allocate new uvm, which grows sz of mem both master and new threads.
	if((new->sz = allocuvm(master->pgdir, master->sz, master->sz + 2*PGSIZE)) == 0){
		release(&pdlock);
		return -1;
	}
	master->sz = new->sz;
fin:
	// Set guard page.
	clearpteu(master->pgdir, (char*)(new->sz - 2*PGSIZE));
	release(&pdlock);
	return 0;
}

// Collect exit thread's kstack and ustack.
int
deallocstack(struct proc *join){

	acquire(&pdlock);
	// Free kstack.
	kfree(join->kstack);
	int i;
	// Save exit thread's sz in dealloc array
	// for can be used later allocating.
	for(i = 0; i < NTHREAD; i++){
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

// Create new threads.
int 
thread_create(thread_t * thread, void * (*start_routine)(void *), void *arg){
	
	struct proc *thd;
	struct proc *master = call_master();
	uint t_ustack[3];
	uint sp;
	// Allocate kstack and ustack for newly created thread.
	if((thd = allocthread(master)) == 0)
		return -1;
	
	if(allocstack(master, thd) < 0)
		return -1;
	// Set file and i/o chan.
	int i;
  for(i = 0; i < NOFILE; i++)
    if(master->ofile[i])
        thd->ofile[i] = filedup(master->ofile[i]);
  thd->cwd = idup(master->cwd);
    
  safestrcpy(thd->name, master->name, sizeof(master->name));
    
  // Change thread's tf.
  // eip should be changed to function ptr.
	*thd->tf = *master->tf;
	thd->tf->eip = (uint)start_routine;
	sp = thd->sz;
	// Save arg for start routine can use.
	t_ustack[0] = 0xffffffff;
	t_ustack[1] = (uint)arg;
	t_ustack[2] = 0;
	sp -= sizeof(t_ustack);
	// Set ustack finish. 
	if(copyout(master->pgdir, sp, t_ustack, sizeof(t_ustack)) < 0)
		return -1;
	
	thd->tf->esp = sp;
	*thread = thd;

	acquire(&ptable.lock);
	thd->state = RUNNABLE;
	release(&ptable.lock);
	return 0;
}


// Clean up the resources allocated to the thread.
int
thread_join(thread_t thread, void **retval){

	struct proc *join = thread;
	acquire(&ptable.lock);
	// Master thread sleep while thread running.
	while(join->state != ZOMBIE)
		sleep(thread->tinfo.master, &ptable.lock);
	

	// Dealloc ustack and kstack.
	if(deallocstack(join) < 0){
		release(&ptable.lock);
		return -1;
	}
	// If ptr is not NULL, then set retval.
	if(retval != 0)
		*retval = thread->tinfo.master->ret[join->tinfo.tid];
	
	
	thread->tinfo.master->threads[thread->tinfo.tid] = 0;
	thread->state = UNUSED;
	thread->kstack = 0;
  thread->name[0] = 0;
  thread->killed = 0;
  release(&ptable.lock);
	return 0;
}

/*
	Thread exit function is in proc.c
 */

// Only master thread could in scheduler.
// But schduling unit is thread we return thread by RR algorithm
// if master thread picked by scheduler
struct proc*
thread_RR(struct proc* master){

	if(master->cnt_t == 0)
		return master;
	int i = master->recent;
	do{
		i = (i + 1) % (NTHREAD+ 1);
		if(i == NTHREAD){
			if(master->state == RUNNABLE){
				master->recent = i;
				return master;
			}else{
				continue;
			}
		}
		if(master->threads[i] != 0 && master->threads[i]->state == RUNNABLE){
			master->recent = i;
			return master->threads[i];
		}
	}while(i != master->recent);
	
	return master;
}

// Return master thread.
struct proc*
call_master(void){
	struct proc* p = myproc();
	if(p->tinfo.master != 0)
		p = p->tinfo.master;
	return p;
}









