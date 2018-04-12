#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct stride s_cand[NPROC];
struct proc* recent_MLFQ;
struct FQ MLFQ_table[3];
int global_ticks = 0;
extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
}ptable;


int
push_MLFQ(int prior, struct proc* p)
{
	if(prior < 0 || prior > 2)
		return -1;

	for(int i = 0; i < NPROC; i++){
		if(MLFQ_table[prior].wait[i] == 0){
			MLFQ_table[prior].wait[i] = p;
			p->prior = prior;
			p->pticks = 0;
			MLFQ_table[prior].total++;
			return 0;
		}
	}
	return -1;
}

int
pop_MLFQ(struct proc* p)
{
	int prior = p->prior;
	for(int i = 0; i < NPROC; i++){
		if(MLFQ_table[prior].wait[i] == p){
			MLFQ_table[prior].wait[i] = 0;
			p->pticks = 0;
			MLFQ_table[prior].total--;
			return 0;
		}
	}
	return -1;
}

int
move_MLFQ_prior(int prior, struct proc* p)
{
	int ret = pop_MLFQ(p);
	if(ret == -1)
		return ret;
	return push_MLFQ(prior, p);
}

struct proc*
pick_MLFQ(void)
{
	int j;
	for(int i = 0; i < 3; i++){
		if(MLFQ_table[i].total == 0)
			continue;
		do{
			j = (MLFQ_table[i].recent + 1) % NPROC;
			if(MLFQ_table[i].wait[j] != 0 && 
				MLFQ_table[i].wait[j]->state == RUNNABLE){
				MLFQ_table[i].recent = j;
				return MLFQ_table[i].wait[j];
			}
		}while(j != MLFQ_table[i].recent);
	}
	return 0;
}

void 
prior_boost(void)
{
	global_ticks = 0;

	acquire(&ptable.lock);
  struct proc* p;
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
		if(p->prior == 0 || p->prior == 1|| p->prior == 2) { 
			move_MLFQ_prior(0, p);
		}
	}
	release(&ptable.lock);
}

struct proc*
pick_pass(void)
{
	///제일 짧은 패스를 고른다.
	///MLFQ가 뽑혔다면, MLFQ에 의해서 다시 뽑아준다.
	struct stride* pick = s_cand;
	struct stride* s;
	for(s = s_cand; s < &s_cand[NPROC]; s++){
		if(s->valid == 0)
			continue;
		if(s->proc->state != RUNNABLE)
			continue;

		if(s->pass < pick->pass)
			pick = s;
	}
	if(pick == s_cand)
		return pick_MLFQ();
	return pick->proc;
}
//어떻게 mlfq를 0에????
void
scheduler(void)
{
  struct proc *p;
  struct proc *win;
  struct cpu *c = mycpu();
  c->proc = 0;
  struct stride* s;
	
	for(s = s_cand; s < &s_cand[NPROC]; s++){
		s->valid = 0;
	}
	s_cand[0].valid = 1;

	for(int i = 0; i < 3; i++){
		MLFQ_table[i].total = 0;
		MLFQ_table[i].recent = 0;
		for(int j = 0; j < NPROC; j++){
			MLFQ_table[i].wait[j] = 0;
		}
	}

  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;


      ///패스에 의해서 하나를 뽑아야함
      win = pick_pass();

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = win;
      switchuvm(win);
      win->state = RUNNING;

      swtch(&(c->scheduler), win->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);

  }
}

int
set_cpu_share(int inquire)
{	

	if(inquire <= 0)
		return -1;

	struct stride* s;
	int min_pass = 0;
	int sum = inquire;
	for(s = s_cand; s < &s_cand[NPROC]; s++){
		if(s->valid == 1){
			sum += s->share;
			if(min_pass > s->pass)
				min_pass = s->pass;
		}
	}
	sum -= s_cand[0].share;
	if(sum > 80)
		return -1;

	s_cand[0].share = (100 - sum);
	s_cand[0].stride = 100000 / s_cand[0].share;
	

	for(s = s_cand; s < &s_cand[NPROC]; s++){
		if(s->valid == 0)
			break;
	}
	s->share = inquire;
	s->stride = 100000 / inquire;
	s->pass = min_pass;
	struct proc* p = myproc();
	s->proc = p;
	p->myst = s;
	pop_MLFQ(p);
	p->prior = 3;
	s->valid = 1;
	return 0;
}

void
stride_adder(int step)
{
	struct stride* s = myproc()->myst;
	for(int i = 0; i < step; i++){
		s->pass += s->stride;
	}
}

int
MLFQ_tick_adder(void)
{

	struct proc* p = myproc();
	if(p->prior ==3)
		return 1;
	if(++global_ticks >= 100)
		prior_boost();
	
	p->pticks++;
	int quantum = p->pticks;

	switch(p->prior){
		case 0:
			if(quantum >= 5){
				move_MLFQ_prior(1, p);
			}
			return 1;
			break;

		case 1:
			if(quantum >= 10){
				move_MLFQ_prior(2, p);
			}
			if((quantum % 2) == 0){
				return 2;
			}else{
				return 0;
			}
			break;
		case 2:
			if((quantum % 4) == 0){
				return 4;
			}else{
				return 0;
			}
			break;
		default:
			return -1;
	}		
	
}
