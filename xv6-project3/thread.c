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

static struct proc*
allocthread(void)
{
  struct proc *p;
  char *sp;
  struct proc *master = myproc();
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
  p->parent = p->tinfo->master = master;
  p->pgdir = master->pgdir;
  for(i = 0; i < NTHREAD; i++){
    if(master->threads[i] == 0)
      break;
  }
  p->tinfo->tid = i;
  master->cnt_t++;
  return p;
}

int 
thread_create(thread_t * thread, void * (*start_routine)(void *), void *arg){
	
	struct proc *thd = allocthread();
	*thread = *thd->tinfo;
	return 0;
}


