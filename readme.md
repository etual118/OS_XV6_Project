# Project 1

Simple Shell
----------------------------------------------------------------------------------------------
Assignment 1 is making simple shell. This shell uses execvp() system call for executing command. Details will be described below.

Basic Operation
-------------------------
The command line should be under 1000 characters. It could be changed by changing defined number MAX.
It has two modes for operation. Difference between Interactive mode and Batch mode is parsing input command. After parse input command they use Parser function to execute command by command.
If there is no input file that argv[1], then it is executed as Interactive mode. But if give input file, then it is executed as Batch mode. If you want end the all process, enter ```Ctrl+D``` or ```quit```.
The output is not ordered as typed. Because it forks all command simultaneously so Operating System's Scheduler executes forked process. 

Parser
---------------------------
In this function, it parses all commands. It uses array of double pointer, because of using execvp() system call. The second argument of execvp() function is additional options. For exception handling, it checks the input command which space is tokenized to NULL. So if command is just space or having right space or left space, it could be cut well. If command is NULL then it doesn't operate. When finish all command lines, then it executes each command by fork new process per each command. 
```
for(i = 0; i < check; i++){
		if(*input_cmd[i] == NULL)
		//kill the process if command is not found
			continue;
		if((strcmp(*input_cmd[i], "quit")) == 0){
			for(int k = 0; k < i; k++){
				waitpid(pid[k], NULL, 0);
			}
			exit(0);
		}//if command is quit then quit after waiting other processes
		if((pid[i] = fork()) < 0){
		//this is error case
			exit(0);
		}else if(pid[i] == 0){
		//if child process
			if(execvp(*input_cmd[i], input_cmd[i]) < 0)
			//use execvp function
				kill(getpid(), SIGINT);
				//kill if command is not found
			break;
		}else{
			continue;
		}
```

Child process executes when return value of execvp is 0. If return value is -1 which means command is not effective.



# Project 2

새로운 스케줄러의 구현은 sched.c에 정의되어있으며, 이외에도 trap.c, proc.h, proc.c에서도 다소 수정된 내용이 있습니다. 코드에서 새롭게 추가되거나 수정된 부분에 대해서는 코드 내에 전부 주석을 달았습니다. 자세한 line by line에 대한 설명은 주석에 있으며, wiki에는 전체적인 스케줄러의 운영방식에 대해서 설명하겠습니다.

## Scheduler Design

Implements new scheduler combines MLFQ and Stride scheduler.

### Scheduler Mechanism

`scheduler()` 함수가 호출되는 경우는 timer interrupt 혹은 운영체제 내부에서 호출할 때 입니다. `scheduler()` 함수가 호출되었다면, `pick_pass()` 함수를 호출하여 가장 적은 pass를 가진 stride 구조체를 찾습니다. stride 구조체는 s_cand라는 이름의 배열로 선언되어있으며, 각자의 stride와 pass 값, 그리고 자신이 가리키는 프로세스의 포인터를 가지고있습니다. s_cand 배열의 0번 인덱스는 MLFQ를 의미합니다. 

*즉, 프로세스가 가리키는 stride 구조체의 s_cand 인덱스가 0이라면 이는 MLFQ 스케줄러 아래에서 돌아감을 뜻합니다.*

![image-20190909194850149](https://hconnect.hanyang.ac.kr/2018_ELE3021_12783/2018_ELE3021_2014004248/uploads/8436562b5981715d08690d1b149e30c7/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2018-04-19_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_1.55.10.png)즉 전체적으로, 위의 그림과 같이 스케줄러가 동작하게 됩니다. 처음에는 s_cand 배열을 순회하면서 가장 작은 pass를 찾습니다. 프로세스를 가리키는 stride 구조체가 선택된다면, stride 구조체가 가리키는 프로세스가 cpu로 올라갑니다. 만일 MLFQ(s_cand[0])가 선택된다면, MLFQ 스케줄러를 호출해서 맞는 프로세스를 가져옵니다. 

프로세스의 myst 포인터를 참조하면, 이 프로세스가 MLFQ에서 돌고있는지, 아니면 stride에서 돌고있는지 알 수 있습니다. MLFQ(s_cand[0])를 제외한 stride 구조체와 ptable의 프로세스는 서로를 가리키고 있으므로 각자를 참조할 수 있습니다.



### MLFQ (Multi-level feedback queue) scheduling

> • MLFQ consists of three queues with each queue applying the round robin scheduling.

```
struct FQ {
  int total;
  int recent;
  struct proc* wait[NPROC];
};
```

MLFQ를 위해서 각 lev별로 FQ 구조체 하나가 할당됩니다. FQ 구조체에는 현재 레벨의 프로세스 총 갯수, circular queue와 비슷하게 동작하기 위한 recent index, 그리고 프로세스 구조체 포인터의 배열로 구성되어 있습니다.

Round-robin 동작 방식은 `MLFQ_tick_adder()` 함수에 구현되어 있습니다.

> • The scheduler chooses a next ready process from MLFQ. If any process is found in the higher priority queue, a process in the lower queue cannot be selected until the upper level queue becomes empty.

 `pick_MLFQ()` 함수에서 보면, 가장 높은 레벨에 있는 프로세스의 갯수(total 변수)가 0이 되기 전까지는 아래 큐를 순환하지 않습니다.

> • Each level of queue adopts Round Robin policy with different time quantum.

> – The highest priority queue: 1 tick

> – Middle priority queue: 2 ticks

> – The lowest priority queue: 4 ticks  

`trap.c` 에서 timer interrupt가 발생할 때마다 yield를 호출하여 mode switch가 되지 않고, quantum을 다 썼는지 체크한 후에 `yield()` 를 호출합니다.



> • Each queue has different time allotment.

> – The highest priority queue: 5 ticks

> – Middle priority queue: 10 ticks



`MLFQ_tick_adder()` 함수에서 틱을 조정한 후, allotment 이상을 다 사용했다면, `move_MLFQ_prior()` 함수를 호출해서 prior level을 재조정해줍니다.

   

> • To prevent starvation, priority boosting needs to be performed periodically.

> – The priority boosting is the only way to move the process upward.

> – Frequency of the priority boosting: 100 ticks



MLFQ 스케줄러를 위한 MLFQ_ticks 변수가 따로 있습니다. 이는 timer interrupt가 들어오거나, 아니면 sys_yield가 호출 됐을 때 tick이 오릅니다. `MLFQ_tick_adder()` 함수에 보면 MLFQ_ticks가 100보다 크다면, `prior_boost()` 함수를 호출합니다.

   

> • MLFQ should always occupy at least 20% of CPU share.

  

`set_cpu_share()` 함수를 보면 내부의 조건문에서 요청된 share를 할당시 MLFQ scheduler에 20% 이상의 share를 할당할 수 없다면, -1을 return하도록 되어있습니다.


### Stride scheduling

> • If a process wants to get a certain amount of CPU share, then it invokes a new system call to set the amount of CPU share.

  

`set_cpu_share()` 함수에 구현되어 있습니다. 전체 ticket을 100으로 관리하고, share 요청이 들어온만큼 할당을 해줌으로써 각 stride 구조체에 stride를 할당을 해주고, pass를 통해 전체적인 비율이 맞도록 관리해줍니다.



> • When a process is newly created, it initially enters MLFQ. The process will be managed by the stride scheduler only if the set_cpu_share() system call has been invoked.

  

`allocproc()` 함수에는 프로세스가 새로 생성될 때 반드시 거쳐가야합니다. 프로세스가 새로 생성되었을 때, `push_MLFQ()` 함수를 통해 MLFQ의 prior lever 0인 queue에 새로 삽입해줍니다. 이후 프로세스가 MLFQ에서 빠지는 경우는 `exit()` 이 호출되거나, `set_cpu_share()` 함수가 호출되어 stride 스케줄러로 넘어갈 때입니다.

  

> • The total sum of CPU share requested from processes in the stride queue can not exceed 80% of CPU time. Exception handling needs to be properly implemented to handle oversubscribed requests.

  

위의 MLFQ에 20% 이상을 할당해줄 수 없다는 부분을 보면 됩니다.



## Scheduling scenario

### Given test case

####  스스로 yield를 call하지 않는 MLFQ 프로세스가 4개 동시에 도는 경우

![test2](https://hconnect.hanyang.ac.kr/2018_ELE3021_12783/2018_ELE3021_2014004248/uploads/07cbb010148fe9e49c59feb0a91fdf45/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2018-04-18_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.58.02.png)

각 레벨에서의 time allotment가 5, 10이므로, MLFQ 프로세스가 동시에 4개 돌 경우에는 각자 레벨 0, 1, 2에서 5, 10, 10씩 돌면 boosting이 일어날 것으로 생각할 수 있습니다(boosting 주기가 100이므로). 위의 결과는 어느정도 거기에 부합함을 보이고 있습니다.


#### 스스로 yield를 call하는 프로세스 2개와 call하지 않는 프로세스 2개가 MLFQ 스케줄러에서 도는 경우

![스크린샷_2018-04-18_오후_9.59.22](https://hconnect.hanyang.ac.kr/2018_ELE3021_12783/2018_ELE3021_2014004248/uploads/49b5e8c19db82764e3cbc823b5ce7089/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2018-04-18_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.59.22.png)

현재 저의 스케줄러에서는 1 tick을 단위로 스트라이드의 패스를 증가시키고, mlfq의 각 프로세스별 tick과 mlfq 전체의 tick을 올립니다. 만일 1tick이 되기 전에 system call인 mlfq를 호출한다면, 전체 스케줄러를 game할 우려가 있습니다. 이를 막기 위해서 sys_yield에서 2분의 1의 확률로 전체 tick을 올립니다. 

**생길 수 있는 문제**

- 0.5 tick보다 작은 주기로 yield를 호출하면 실제로 프로세스가 돈 시간보다 더 많이 돈 것으로 스케줄러는 체크합니다. 그렇게되면 위의 결과에서 볼 수 있는 것처럼 실제로 보장받은 time quantum만큼 돌지 못하는 경우가 발생할 수 있습니다. 하지만 스케줄러를 game하는 것을 방지하기 위한 trade-off로 판단하여 이렇게 디자인 하였습니다. 또한, 전체 boosting 주기가 짧아지는 효과를 낳으므로 compute로 실행된 프로세스들도 lev 2에 비해서 0과 1에 좀 더 오래 머무르게 됩니다.
- 0.5 tick보다 큰 주기로 yield를 호출하는 경우에도 scheduler를 game하지 못하게 운영체제의 tick으로 판단하게 했습니다.

####  MLFQ 프로세스 8개 중 4개는 compute, 4개는 yield일 때

![스크린샷_2018-04-18_오후_10.07.15](https://hconnect.hanyang.ac.kr/2018_ELE3021_12783/2018_ELE3021_2014004248/uploads/b5513f3d26083bbc3ce211058435b61d/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2018-04-18_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10.07.15.png)

부스팅 주기가 실제 시간보다 빨라지게 되므로, compute하는 경우 level 1에서 대부분의 boosting이 일어나게 됩니다.

####  MLFQ와 Stride가 복합적으로 돌아갈 때

![스크린샷_2018-04-18_오후_10.04.54](https://hconnect.hanyang.ac.kr/2018_ELE3021_12783/2018_ELE3021_2014004248/uploads/c92939f4ed4abcf3a66e205afd017e8a/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2018-04-18_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10.04.54.png)

stride의 비율은 정상적인 수치를 보여주고있습니다. yield를 하는 프로세스의 경우, 위에서 상술한 문제가 다시 나타나고 있습니다. 

**생길 수 있는 문제**

- MLFQ와 마찬가지로, Stride도 스스로 yield를 호출하는 경우에는 자신이 보장받은 stride만큼 진행되지 않아도 pass를 진행한 것으로 처리될 수 있습니다. 이 역시 스케줄러를 game하게 하지 못하기 위한 trade-off입니다.

#### Basic test

![스크린샷_2018-04-18_오후_10.14.38](https://hconnect.hanyang.ac.kr/2018_ELE3021_12783/2018_ELE3021_2014004248/uploads/7bdbc44e0ea75603f48565a0c36d964c/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2018-04-18_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10.14.38.png)



**생길 수 있는 문제**

- boosting 주기가 짧아지거나, 이전에 돌았던 MLFQ로 인하여 자신이 돈지 얼마되지 않아 부스팅이 빠르게 이루어진 경우, 위처럼 값이 한 번씩 엉킬 수 있으나, 이는 어쩔 수 없는 문제라고 판단하였습니다. 대안으로 부스팅과 부스팅 사이에 새로 MLFQ에 들어온 프로세스들은 부스팅을 받지 않게하는 방법도 있지만, 손해가 더 크다고 판단해서 사용하지 않았습니다.



### function call in proc.c

문제의 원인은 idle 프로세스가 따로 없다는 점입니다. idle 프로세스는 점유율이 딱 할당된 만큼만 cpu를 점유할 수 있게함으로서, 전체 cpu를 game하는 상황을 막아줄 수 있으나, 그만큼 cpu가 놀게된다는 단점도 있습니다. 따라서, 이번 과제에서는 별도의 idle 프로세스를 세팅하지않고, 할당된 점유율의 비율이 다소 깨지더라도 돌 수 있게 보장해주었습니다. 아래는 할당된 점유율이 깨질 수 있는 상황입니다.

1. `sleep()`을 호출 시, MLFQ의 경우에는 상관이 없으나, stride의 경우에는 다른 프로세스들이 실제로 할당된 비율 이상으로 돌아가는 문제가 발생합니다. 또한, 잠들어있는 동안에는 pass가 증가하지 않으므로 깨어났을 때 한동안 cpu를 독점적으로 사용할 우려가 있습니다. *이를 위해서 잠에서 깨어났을 때 만일 stride 스케줄러에서 돌아가고있는 프로세스라면, 현재의 min pass값으로 다시 세팅해줍니다. 이는 sleep 후 일어나서 cpu를 독점하는 것을 막아주기 위함입니다.*
2. `exit()`을 호출하면, stride에서 할당된 티켓을 우선적으로 MLFQ에게 재할당해줍니다. idle 프로세스가 있었다면 해결될 수 있는 문제입니다.
3. `set_cpu_share()` 를 요청한 함수가 return값이 -1이면 다시 MLFQ로 들어가거나, 실행파일에 따라 종료됩니다. 이 경우 대기열을 만들어 대기열에 삽입하게하는 방법도 있을 수 있지만, 적체 현상이 발생할 수 있어 실행파일이 주기적으로 요청하게하는 편이 낫다고 판단했습니다.

# Project 3

## Thread

스레드는 운영체제의 기본적인 스케줄링 단위이다. 즉, 어떠한 프로그램 내에서, 특히 프로세스 내에서 실행되는 흐름의 단위를 말한다. 
![스크린샷_2018-05-12_오후_2.45.31](https://hconnect.hanyang.ac.kr/2018_ELE3021_12783/2018_ELE3021_2014004248/uploads/7d6014cfa018ca581b972f071b89fd0c/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2018-05-12_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_2.45.31.png)

멀티프로세스에서 각 프로세스는 독립적으로 실행되며 각각 별개의 메모리를 차지하고 있는 것과 달리 멀티스레드는 프로세스 내의 메모리를 공유해 사용할 수 있다. 또한 프로세스 간의 전환 속도보다 스레드 간의 전환 속도가 빠르다. 멀티스레드의 단점에는 각각의 스레드 중 어떤 것이 먼저 실행될지 그 순서를 알 수 없다는 것이 있다. 이는 race condition의 원인이 되기도 한다. 
![스크린샷_2018-05-12_오후_2.49.26](https://hconnect.hanyang.ac.kr/2018_ELE3021_12783/2018_ELE3021_2014004248/uploads/e1feea8a46451e1a06b536e143df6fc4/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2018-05-12_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_2.49.26.png)
![스크린샷_2018-05-12_오후_2.49.39](https://hconnect.hanyang.ac.kr/2018_ELE3021_12783/2018_ELE3021_2014004248/uploads/e2b1a00c6aa5bfb915c4b90d1d331928/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2018-05-12_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_2.49.39.png)
즉 위의 상황과 같이, 두 개의 스레드에 의해서 메모리 사이클이 interleved되는 상황이 발생한다면, 두 스레드는 동시에 메모리에 접근하게 되고 이는 우리가 기대하는 i 값의 정확성을 보장해줄 수 없다. 따라서 lock을 사용해서 이러한 race condition을 방지해주어야한다.

## Thread in POSIX

POSIX 스레드는  `int pthread_create(pthread_t *thread, const pthread_attr_t *attr, void *(*start_routine)(void *), void *arg)` 를 호출하는 것으로 생성된다.
새로운 스레드가 생성되었을 때 이 스레드는

1.  `pthread_exit(void *ret_val)` 호출
2.  return from start_routine
3.  master thread return in main

의 경우에 종료되고, 3번 조건의 경우는 특히 스레드의 return 값을 받거나 start_routine이 끝까지 실행되는 것을 보장하기 위해서 `int pthread_join(pthread_t thread, void **ret_val)` 함수를 이용해야하는 이유가 된다.

## Thread operation Design

더 자세한 설명은 코드에 주석으로 달아두었으며, 여기서는 기본적인 동작 논리를 중심으로 적는다. 한 프로세스가 생성할 수 있는 스레드의 최대 갯수는 NTHREAD에 달려있으며, default는 20으로 지정되어있다.

## Newly added variable in process structure

- `thread_t` : 스레드 자신의 `struct proc*`를 의미한다.

### For all threads

- `struct thread` : `struct proc *master` 와 `int tid`를 가지고 있다. Master 스레드의 포인터를 가지고 있음으로서 join이나 기타 master를 참조해야할 때 접근할 수 있으며, 만일 `master`가 0이라면 이는 자신이 마스터 스레드임을 뜻한다. `tid`는 master 스레드 내의 하위 스레드들의 배열의 인덱스를 가진다.

### For master thread

 - `struct proc* threads[NTHREAD]` : 자신의 하위 스레드들의 포인터들을 저장한다. 하위 스레드의 tid를 바탕으로 하위 스레드를 참조할 수 있다.
 - `void* ret[NTHREAD]` : 자신의 하위 스레드가 `thread_exit()`을 호출했을 때, ret_val을 넘겨받아서 저장한 후, `thread_join()`에서 사용한다. 하위 스레드의 tid를 인덱스로 사용해 저장한다. 
 - `int dealloc[NTHREAD]` : 어떤 한 스레드가 종료되었다면, ustack의 크기만큼 memory chunk가 발생한다. 이를 다른 스레드가 새로 할당될 때 재활용하기 위해서 chunk의 시작주소를 저장한다.
 - `int cnt_t` : 자신의 하위 스레드의 갯수를 저장한다.
 - `int recent` : 스케줄링을 위해서 사용한다. Round Robin 방식을 사용하여 스레드들을 return한다.



## Function for thread operation

- `int thread_create(thread_t * thread, void * (*start_routine)(void *), void *arg)`
  - 스레드를 생성할 때는, 새로운 pgdir를 생성할 필요가 없다. 다만, 스레드는 자신만의 kstack과 ustack을 필요로 하므로, 이를 할당해주는 함수이다. 
  - 우선, `allocthread()`를 호출하여 새로운 커널 스택을 할당받는다. pgdir는 부모 스레드의 pgdir를 그대로 받아오고, 자신만의 kstack을 생성한다.
  - `allocstack()`을 호출하여 자신만의 유저스택을 할당받는다. 유저스택의 크기는 한 페이지로 고정되어있으며, 페이지 두 개의 크기만큼을 할당받아 한 페이지는 유저스택, 한 페이지는 guard page로 사용한다.
  - 그 후, 파일 시스템과 i/o 채널을 열어준다.
  - trapframe은 우선 부모의 trapframe을 받아오되, `esp`와 `eip`값에 변경이 필요하다.
  - 스레드는 자신의 `start_routine()`으로 이동해서 시작되므로, `eip`에는 `start_routine`을 저장한다.
  - `start_routine()`에서는 `void* arg`를 parameter로 받아오므로 이를 내가 ustack에 저장하는 작업을 해준 후, `esp`에 새로운 `sp`를 저장한다.
  - Master 스레드의 cnt_t를 1 증가시킨다.
  - 마지막으로 스레드의 상태를 `RUNNABLE`로 바꿔준다. 
  - 성공적으로 종료되었다면, 0을 return한다.


- `void thread_exit(void *retval)` 
  - 열려있는 file들을 전부 닫아준다. 
  - Master thread를 깨워주고, `thread_join()`을 이용하여 retval을 수거할 수 있도록 한다.
  - retval을 master 스레드 내에 저장하고, 스레드 자신의 상태를 `ZOMBIE`로 바꾼다.
  - 현재의 DESIGN에서는 스레드가 fork를 호출한 경우에 child는 worker 스레드를 부모로 가진다. 이는 wait의 작동 방식을 맞춰주기 위함이며, POSIX 구현과 다소 다른 부분이다.
  - master 스레드의 `cnt_t`값을 1 낮춰준다.


- `int thread_join(thread_t thread, void **retval)`
  - 여기서 스레드에 할당되었던 자원들을 전부 수거한다.
  - `thread_exit()`에서 `ZOMBIE`상태로 바뀌었던 스레드들을 여기서 `UNUSED`로 바꿔서 재활용할 수 있게한다.
  - `deallocstack()`함수를 불러 할당되었던 kstack과 ustack을 수거하고, ustack을 재활용할 수 있게 master thread에 저장해둔다. 
  - `void **retval`이 NULL로 들어올 수 있으므로, 그 때에 대해서 예외처리를 해준다.
  - 성공적으로 다 진행되었다면, 0을 return한다.
  - *이외에도, 만일 마스터 스레드 이외의 프로세스가 `thread_join()`을 호출한 경우에는 0을 리턴하지만, detach하는 작업을 취하지 않는다. 이는 POSIX 구현을 따른 것이다.*


## Change in System Call

- `exit()` 
   - 어느 한 스레드가 `exit()`을 호출하면, 모든 스레드들이 전부 종료되어야한다. 
   - 따라서, 기존의 `exit()`에 모든 스레드에 대해서 종료하는 부분이 추가되었다.
   - `exit()`이 호출된 이상, master와 worker 여부에 상관없이 전부 종료되어야한다. 따라서 이 구현에 맞추어 모든 프로세스의 작업 단위를 정리한다.
   - 모든 스레드들의 파일을 닫아주고, 입출력을 꺼준다. 이후에 메모리를 detach하는 작업은 부모 프로세스의 `wait()`에서 처리한다.
   - 그 후, 모든 스레드들의 상태를 `ZOMBIE`로 바꾸고, 나중에 `wait()`에서 자원을 수거한다.
- `wait()`
   - 사용자가 `thread_join()` 함수를 call하지 않을 것을 생각해, 예외처리를 해주어야한다.
   - 따라서 아래와 같은 흐름도를 가진다.

![스크린샷_2018-05-13_오후_12.59.27](https://hconnect.hanyang.ac.kr/2018_ELE3021_12783/2018_ELE3021_2014004248/uploads/5384d0005c84db67beb1c8341cc3c58a/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2018-05-13_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_12.59.27.png)

     * 우선 master thread를 찾습니다. 그 후 종속된 worker thread들을 전부 memory detach한 후에 마지막으로 main thread의 memory를 detach합니다.

- `fork()` 

   - `fork()`는 두 가지 경우로 나누어 생각할 수 있습니다.
    1. master thread가 call하는 경우 : 메모리의 구조는 그대로 복사해가지만, 서로 다른 physical mem으로 mapping되므로 부모 프로세스가 생성한 스레드들을 참조할 수 없습니다. 따라서 만일 자식 프로세스가 `thread_join()` 등의 함수를 호출한다면, return value는 성공적인 것처럼 보이지만, 실제로는 memory detach나 return value를 받아오는 기능 등은 전혀 하지 못합니다.
    2. worker thread가 call하는 경우 : child 프로세스는 worker thread를 부모로 가집니다. 따라서 `thread_exit()`에서도 현재 자신의 child를 initproc으로 넘겨주는 부분이 추가되어 있습니다. 

- `exec()`

   - 어느 한 프로세스가 `exec()`을 호출하면, 다른 모든 스레드를 죽인 후 진행된다.
     1. master thread가 call하는 경우 : 원래의 logic을 그대로 가져갑니다. 다만, 현재 자신이 가지고 있는 worker thread들의 자원을 전부 수거합니다.
     2. worker thread가 call하는 경우 : 다른 logic을 적용합니다. 현재 자신을 제외한 모든 worker thread를 죽이고, 스케줄러에 현재 들어있는 master thread의 위치에 자신을 집어넣은 후 스스로가 master thread가 됩니다. 이 과정이 모두 종료되면, master thread의 자원을 수거합니다.
  - 위의 과정은 전부 `thread_clear()`함수를 이용하여 진행됩니다.

- `sbrk()`

   - `growproc()` 함수에서 master 스레드의 `sz`를 키워줍니다. 
   - Heap은 모든 스레드가 공유하는 공간이기 때문에, 공유하여 사용할 수 있습니다.
   - USER는 addr로 return받은 공간만큼만 주의하여 사용해야합니다.


- `scheduler()`
  - `MLFQ`이든 `Stride`이든 모든 스케줄러는 전부 마스터 스레드만을 처리한다. 이는 스레드는 단순히 작업의 단위이기 때문에, 결국 master thread의 할당받은 작업량만큼을 사용하게하는 것이 맞는 구현이라고 판단되어서이다. 따라서 사실상 모든 스레드들은 현재 프로세스의 stride, lev, time quantum 등을 공유하며 동작한다. 
  
## Test Result

 테스트 코드에서 중점적으로 분석했던 부분은 exec, fork, exit이었습니다. exec의 경우에는 현재 자신이 가지고있는 모든 스레드들을 죽이고 이를 UNUSED까지로 바꿔주는 작업이 필요합니다. 왜냐하면 만일 ZOMBIE 상태로 계속 들고가다보면, exec된 프로세스가 끝나기 전까지는 너무 많은 ZOMBIE들이 ptable을 점유하게되고, 이는 추후에 많은 프로세스들이 생겨나려할 때 문제의 원인이 될 수 있습니다. 
 그 다음으로 주목한 테스트는 exit이었습니다. 정식적인 스레드의 사용방법은, *user가 `threrad_create()`, `thread_exit()`, `thread_join()`을 모두 사용하여 프로그래밍하는 것입니다.* 그러나 user가 `thread_join()`등을 call하지 않을 가능성 역시 내포하고있습니다. 따라서 운영체제는 그러한 user들에 대해서도 예외처리를 전부 해주어야하며, 이를 위해 `wait()`에서 마스터 스레드의 자원을 수거하기 전에 하위 스레드들을 다시 한 번 점검합니다.
 마지막으로, fork에서는 POSIX의 구현과 다르게 worker thread가 프로세스의 부모가 될 수 있도록 변경하였습니다. *따라서 user는 fork된 프로세스를 기다리고싶다면, 스레드의 `start_routine()`에서 `wait()`을 실행하여야할 것입니다.*
이외의 test는 다른 test의 응용이거나, 기대하고있는 바가 명확히 보여서 따로 서술하지 않았습니다. 위의 스레드 설명에서 상술한대로 racingtest에서는 같은 공간의 값에 대해서 race condition이 발생하여 lock을 잡지 않으면 원하지 않는 값이 보임을 알 수 있습니다.
## Reference

1. Advanced Programming in the UNIX Environment, 3rd Edition, *W. Richard Stevens*
2. https://en.wikipedia.org/wiki/Threads

# Project 4

-----
Big File System을 구현한다. 기존의 xv6에서는 inode(파일 하나)에 data block을 가리키는 addr 변수를 13개 가지고있습니다. 그러나 12개의 direct, 1개의 indirect로는 총 12 + 128개의 block만을 가리킬 수 있고, 따라서 최대 파일 크기는 약 70kb입니다. 이를 해결하기 위해서 double indirect, triple indirect를 구현하여 Big File을 운영체제가 다룰 수 있도록 합니다. direct로 가리키던 addr 변수 두개를 각각 double indirect, triple indirect 용으로 바꿔주고, ( 10 + 128 + 128^2 + 128^3 )개의 data block을 가질 수 있게 함으로써 약 1gb의 파일까지 커버할 수 있도록 해줍니다.

## Change in header file
----
### param.h
FSSIZE를 40000으로 설정해줍니다. 이를 통해서 40000 * 512만큼의 file을 커버할 수 있으며, 파일의 최대 크기를 더 늘릴 필요가 있다면 더 크게해주면 됩니다.

### file.h

inode 구조체에서 direct 숫자를 10으로 바꾸고, indirect용으로 2개 더 할당해줍니다.

### fs.h

dinode에서는 inode와 같은 작업을 해주었습니다. 또한 double과 triple이 가질 수 있는 block의 갯수를 정하는 상수를 새롭게 정의해주고, 이에 따라서 max file size 또한 늘려주었습니다.

`#define NINDIRECT (BSIZE / sizeof(uint))`


`#define NDINDIRECT (NINDIRECT*NINDIRECT)`


`#define NTINDIRECT (NINDIRECT*NINDIRECT*NINDIRECT)`


`#define MAXFILE (NDIRECT + NINDIRECT + NDINDIRECT + NTINDIRECT)`

## Change in function
-----
### static uint bmap(struct inode *ip, uint bn)

bn을 바탕으로 새로 할당될 데이터 블럭이 direct일지, single indirect일지, double indirect, triple indirect 여부를 판단합니다. 이하의 로직은 기존의 코드와 동일하며, 주석으로 설명해두었습니다.

### static void itrunc(struct inode *ip)

link를 단계별로 해제하게됩니다. 중간에 링크가 끊기더라도 가장 끝부분을 삭제한 이후부터 차례로 indirect의 링크를 끊어줌으로 인해 최종적으로 삭제될 것을 보장해줄 수 있습니다. 

## Milestone 2

`pread`와 `pwrite`를 구현한다. 기존의 `write`와 `read`는 file descriptor를 통해 저장된 offset의 위치에서부터 읽기 시작했다. POSIX에서는 이를 `lseek`을 통해서 offset의 위치를 조정한 후, 다시 `read`와 `write`를 호출한다. 이를 한 번에 통합하여 사용하는 것이 `pread`와 `pwrite`이다. 실제로 리눅스의 manpage에서 `pread`와 `pwrite`의 코드를 보면, old offset을 저장한 후에, `lseek`을 통해서 offset을 조정한 후에 write를 마친 후 offset을 다시 old offset으로 교체한다. 상세한 코드는 아래에 있다.
```
ssize_t
__libc_pread (int fd, void *buf, size_t nbyte, off_t offset)
{
  /* Since we must not change the file pointer preserve the value so that
     we can restore it later.  */
  int save_errno;
  ssize_t result;
  off_t old_offset = __libc_lseek (fd, 0, SEEK_CUR);
  if (old_offset == (off_t) -1)
    return -1;
  /* Set to wanted position.  */
  if (__libc_lseek (fd, offset, SEEK_SET) == (off_t) -1)
    return -1;
  /* Write out the data.  */
  result = __libc_read (fd, buf, nbyte);
  /* Now we have to restore the position.  If this fails we have to
     return this as an error.  But if the writing also failed we
     return this error.  */
  save_errno = errno;
  if (__libc_lseek (fd, old_offset, SEEK_SET) == (off_t) -1)
    {
      if (result == -1)
        __set_errno (save_errno);
      return -1;
    }
  __set_errno (save_errno);
  return result;
}
```

## Newly added function in Milestone 2
* int pwrite(int fd, void* addr, int n, int off):
off의 위치부터 write한다. 기존에 저장되어있던 offset은 그대로 보존한다. 이는 POSIX의 구현을 적용한 것이다. 
* int pread(int fd, void* addr, int n, int off):
off의 위치부터 read한다. 기존에 저장되어있던 offset은 그대로 보존한다. 이는 POSIX의 구현을 적용한 것이다. 


**int filepread(struct file *f, char *addr, int n, int off):**

기존의 offset을 보존하기 위해 따로 함수를 생성했다. 기존의 함수와는 차이가 있다. 아래를 보면
```
ilock(f->ip);
*Different from fileread(), it do not change offset value*
r = readi(f->ip, addr, off, n);
```
와 같이 offset를 변경하는 부분이 없어, 기존의 offset으로 유지된다.

**int filepwrite(struct file *f, char *addr, int n, int off):**

기존의 offset을 보존하기 위해 따로 함수를 생성했다. 기존의 함수와 다른 점은,
```
begin_op();
ilock(f->ip);
*Different from filewrite(), it do not change offset value*
r = writei(f->ip, addr + i, off, n1);
iunlock(f->ip);
end_op();
```
처럼 offset을 변경하는 부분을 빼주었다.

## Caution
기존의 `writei` 함수 내부의 변경점이 있다. 스레드가 나누어 파일을 쓰면, file의 size보다 큰 부분부터 write를 시작할 수 있다. 따라서 중간에 인터럽트가 나거나 하면 파일의 중간에 hole이 생기게되고, 이는 정상적으로 read되지 않는다. 따라서 사용자는 중간에 hole이 생기지 않도록 주의하여 코드를 작성해야한다.
즉, `off > ip->size` 조건을 더 이상 체크하지 않는 것이다. 이를 해결하기 위해서는 미리 map 해두는 방식이 있지만, hole로 파일이 채워질 경우 디스크의 공간을 낭비할 수 있는 단점이 있기에, 채택하지 않고 사용자가 알아서 코드를 제대로 작성하는 것으로 가정하였다. 

