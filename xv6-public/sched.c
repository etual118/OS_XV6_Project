#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct stride s_cand[NPROC];
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

	int i, j;

	for(i = 0; i < 3; i++){
		if(MLFQ_table[i].total == 0){
			continue;
		}
		j = MLFQ_table[i].recent;
		do{
			j = (j + 1) % NPROC;
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
	cprintf("[do boosting!]\n");
}

struct proc*
pick_pass(void)
{
	///제일 짧은 패스를 고른다.
	///MLFQ가 뽑혔다면, MLFQ에 의해서 다시 뽑아준다.
	struct stride* pick = s_cand;
	struct stride* s;
	int i = 0;
	for(s = s_cand; s < &s_cand[NPROC]; s++){
		//cprintf("%d -> ", i++);
		if(s->valid == 0){
			//cprintf(" c1 ");
			continue;
		}
		if(s->proc->state != RUNNABLE){
			//cprintf(" c2 ");
			continue;
		}
		//cprintf("stride : %d pass : %d\t",s->stride, s->pass);
		i++;
		if(s->pass < pick->pass)
			pick = s;
	}
	//cprintf("\n");
	//if(i == 0) cprintf("no valid stride!\n");
	if(pick == s_cand){
		struct proc* mlfq_proc = pick_MLFQ();

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
			//cprintf("case 1 : stride = %d, pass = %d\n", pick->stride, pick->pass);
			return pick->proc;
		}

		//cprintf("case 3 : stride = %d, pass = %d, pri = %d\n", s_cand[0].stride, s_cand[0].pass, mlfq_proc->prior);
		return mlfq_proc;
	}
	//cprintf("case 2 : stride = %d, pass = %d\n", pick->stride, pick->pass);
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

	
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      
      ///패스에 의해서 하나를 뽑아야함
      //cprintf("pick_pass called\n");
      win = pick_pass();
      if(win == 0){
      	cprintf("fatal pick\n");
      	win = p;
      }
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      //cprintf("%d : %s (pid:%d, ticks:%d, state:%d, level:%d)\n", ticks, win->name, win->pid, win->pticks, win->state, win->prior);
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
	uint min_pass = 400000000;
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
	int i;
	for(i = 0; i < step; i++){
		s->pass += s->stride;
	}
	if(s->pass > 300000000){
		for(s = s_cand; s < &s_cand[NPROC]; s++){
			s->pass = 0;
		}
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
	//cprintf("now %d and qunt %d\n", p->prior, quantum);
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
