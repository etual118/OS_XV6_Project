#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

// s_cand is stride candidate
// Stride scheduler round this array
// for searching min-pass
struct stride s_cand[NPROC];

// MLFQ table is for run MLFQ scheduler
struct FQ MLFQ_table[3];
// use for priority boost
int MLFQ_ticks;
struct spinlock gticklock;
extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
}ptable;

// Push process into feedback queue
// It needs queue level to push
int
push_MLFQ(int prior, struct proc* p)
{
	if(prior < 0 || prior > 2)
		return -1;
	int i;
	for(i = 0; i < NPROC; i++){
		if(MLFQ_table[prior].wait[i] == 0){
			MLFQ_table[prior].wait[i] = p;
			p->prior = prior;
			p->pticks = 0;
			p->myst = s_cand;
			MLFQ_table[prior].total++;
			return 0;
		}
	}
	return -1;
}

// Pop process from feedback queue
int
pop_MLFQ(struct proc* p)
{
	int prior = p->prior;
	int i;
	for(i = 0; i < NPROC; i++){
		if(MLFQ_table[prior].wait[i] == p){
			MLFQ_table[prior].wait[i] = 0;
			p->pticks = 0;
			MLFQ_table[prior].total--;
			return 0;
		}
	}
	return -1;
}

// Pop process from one feedback queue
// Then push it to new level
int
move_MLFQ_prior(int prior, struct proc* p)
{
	int ret = pop_MLFQ(p);
	if(ret == -1)
		return ret;
	return push_MLFQ(prior, p);
}

// It picks process from MLFQ
struct proc*
pick_MLFQ(void)
{

	int i, j;

	for(i = 0; i < 3; i++){
		if(MLFQ_table[i].total == 0){
			continue; // no process in feedback queue
		}
		j = MLFQ_table[i].recent; // like rear in queue structure
		do{
			j = (j + 1) % NPROC; // pick next to recently picked proc
			if(MLFQ_table[i].wait[j] != 0 && 
				(MLFQ_table[i].wait[j]->state == RUNNABLE || 
					MLFQ_table[i].wait[j]->cnt_t > 0)){ // master thread waits for thread
				MLFQ_table[i].recent = j;
				return MLFQ_table[i].wait[j];
			}
		}while(j != MLFQ_table[i].recent);
	}
	
	return 0; // There are no process in MLFQ
}


// MLFQ scheduler boost priority of all
// process in MLFQ for process executed periodically
void 
prior_boost(void)
{
  	struct proc* p;
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
		if(p->prior == 0 || p->prior == 1|| p->prior == 2) { 
			move_MLFQ_prior(0, p);
		}
	}
	acquire(&gticklock);
    MLFQ_ticks = 0;
    release(&gticklock);
	
	
}

// Stride schduler
// pick min_pass stride structure
struct proc*
pick_pass(void)
{
	struct stride* pick = s_cand;
	struct stride* s;
	// round stride structure for finding min_pass
	for(s = s_cand; s < &s_cand[NPROC]; s++){
		// if stride structure not yet used
		if(s->valid == 0){
			continue;
		}
		if(s->proc->cnt_t > 0)
			goto master;
		if(s->proc->state != RUNNABLE){
			// in case not runnable
			continue;
		}
master:
		if(s->pass < pick->pass)
			pick = s;
	}
	// case 1 : min_pass structure is MLFQ
	// so, MLFQ runs under Stride scheduler
	if(pick == s_cand){
		struct proc* mlfq_proc = pick_MLFQ();
		// there are no runnable process in MLFQ
		// find secondly min stride structure
		if(mlfq_proc == 0){
			uint min = 400000000;
			for(s = &s_cand[1]; s < &s_cand[NPROC]; s++){
				if(s->valid == 0)
					continue;
				if(s->proc->state != RUNNABLE)
					continue;
				
				if(s->pass < min){
					min = s->pass;
					pick = s;
				}
			}
			// return secondly min pass process
			return thread_RR(pick->proc);
		}
		return thread_RR(mlfq_proc);
	}
	return thread_RR(pick->proc);
}
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run by Stride scheduler
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.


void
scheduler(void)
{
  struct proc *p;
  struct proc *win;
  struct cpu *c = mycpu();
  c->proc = 0;

	
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
    	// find process by Stride scheduler
      win = pick_pass();
      if(win == 0){
      	cprintf("fatal pick\n");
      	win = p;
      }
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = win;
      switchuvm(win);
      win->state = RUNNING;

      swtch(&(c->scheduler), win->context);
      //myproc()->pticks++;
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);

  }
}

// Call OS for share CPU share
int
set_cpu_share(int inquire)
{	
	struct proc* p = myproc();
	if(p->tinfo.master != 0)
		p = p->tinfo.master;
	// share should be over 0
	if(inquire <= 0)
		return -1;
	// already call this function
	if(p->myst != s_cand){
		return -1;
	}
	struct stride* s;
	uint min_pass = 400000000;
	// count all share
	int sum = inquire;
	for(s = s_cand; s < &s_cand[NPROC]; s++){
		if(s->valid == 1){
			sum += s->share;
			if(min_pass > s->pass)
				min_pass = s->pass;
		}
	}
	sum -= s_cand[0].share;
	// already over max share
	if(sum > 80)
		return -1;
	// set share for MLFQ(min 20)
	s_cand[0].share = (100 - sum);
	s_cand[0].stride = 10000000 / s_cand[0].share;
	
	// find stride structure
	for(s = s_cand; s < &s_cand[NPROC]; s++){
		if(s->valid == 0)
			break;
	}
	s->share = inquire;
	s->stride = 10000000 / inquire;
	s->pass = min_pass;
	// stride structure and process structure
	// points each other
	s->proc = p;
	p->myst = s;
	// it runs on stride scheduler
	pop_MLFQ(p);
	p->prior = 3;
	s->valid = 1;
	return 0;
}

// add stride to pass
void
stride_adder(struct stride *s)
{
	s->pass += s->stride;
	// for prevent overflow
	if(s->pass > 300000000){
		for(s = s_cand; s < &s_cand[NPROC]; s++){
			s->pass = 0;
		}
	}
}

// it checks MLFQ_ticks for move level
// and prior boost
// function is called by every timer interrupt
// and sys_yield()
// return value determine process yield or not
// for guarantee time quantum
int
MLFQ_tick_adder(void)
{
	acquire(&ptable.lock);
	struct proc* p = call_master();
	struct stride *s = p->myst;
	// check stride per ticks
	stride_adder(s);
	// case 1 : run on stride scheduler process
	if(p->prior ==3){
		release(&ptable.lock);
		return 1;
	}
	// case 2 : run on MLFQ scheduler process
	acquire(&gticklock);
  MLFQ_ticks++;
  release(&gticklock);
	
        int quantum = ++p->pticks;
	// when time quantum all consumed
	// then return value is 1
	// which mean prior boost and yield
	// could evoke
	switch(p->prior){
		case 0:
			if(quantum >= 5){
				move_MLFQ_prior(1, p);
			}
			if(MLFQ_ticks > 100){	
				prior_boost();
			}
			release(&ptable.lock);
			return 1;
			break;

		case 1:
			if(quantum >= 10){
				move_MLFQ_prior(2, p);
			}
			if((quantum % 2) == 0){
				if(MLFQ_ticks > 100){	
					prior_boost();
				}
				release(&ptable.lock);
				return 1;
			}else{
				release(&ptable.lock);
				return 0;
			}
			break;

		case 2:
			if((quantum % 4) == 0){
				if(MLFQ_ticks > 100){
					prior_boost();
				}
				release(&ptable.lock);
				return 1;
			}else{
				release(&ptable.lock);
				return 0;
			}
			break;
		default:
			release(&ptable.lock);
			return -1;
	}	
}
