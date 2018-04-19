#Project 2

 새로운 스케줄러의 구현은 sched.c에 정의되어있으며, 이외에도 trap.c, proc.h, proc.c에서도 다소 수정된 내용이 있습니다. 코드에서 새롭게 추가되거나 수정된 부분에 대해서는 코드 내에 전부 주석을 달았습니다. 자세한 line by line에 대한 설명은 주석에 있으며, wiki에는 전체적인 스케줄러의 운영방식에 대해서 설명하겠습니다.



#Scheduler Design

Implements new scheduler combines MLFQ and Stride scheduler.



## Scheduler Mechanism

`scheduler()` 함수가 호출되는 경우는 timer interrupt 혹은 운영체제 내부에서 호출할 때 입니다. `scheduler()` 함수가 호출되었다면, `pick_pass()` 함수를 호출하여 가장 적은 pass를 가진 stride 구조체를 찾습니다. stride 구조체는 s_cand라는 이름의 배열로 선언되어있으며, 각자의 stride와 pass 값, 그리고 자신이 가리키는 프로세스의 포인터를 가지고있습니다. s_cand 배열의 0번 인덱스는 MLFQ를 의미합니다. 

*즉, 프로세스가 가리키는 stride 구조체의 s_cand 인덱스가 0이라면 이는 MLFQ 스케줄러 아래에서 돌아감을 뜻합니다.*



![mage-20180419114306](/var/folders/nz/t32dtylx1rjdzqk01zvhs0gc0000gn/T/abnerworks.Typora/image-201804191143062.png)

즉 전체적으로, 위의 그림과 같이 스케줄러가 동작하게 됩니다. 처음에는 s_cand 배열을 순회하면서 가장 작은 pass를 찾습니다. 프로세스를 가리키는 stride 구조체가 선택된다면, stride 구조체가 가리키는 프로세스가 cpu로 올라갑니다. 만일 MLFQ(s_cand[0])가 선택된다면, MLFQ 스케줄러를 호출해서 맞는 프로세스를 가져옵니다. 

  

프로세스의 myst 포인터를 참조하면, 이 프로세스가 MLFQ에서 돌고있는지, 아니면 stride에서 돌고있는지 알 수 있습니다. MLFQ(s_cand[0])를 제외한 stride 구조체와 ptable의 프로세스는 서로를 가리키고 있으므로 각자를 참조할 수 있습니다.





###MLFQ (Multi-level feedback queue) scheduling

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

​     

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



 ## Stride scheduling

> • If a process wants to get a certain amount of CPU share, then it invokes a new system call to set the amount of CPU share.

  

`set_cpu_share()` 함수에 구현되어 있습니다. 전체 ticket을 100으로 관리하고, share 요청이 들어온만큼 할당을 해줌으로써 각 stride 구조체에 stride를 할당을 해주고, pass를 통해 전체적인 비율이 맞도록 관리해줍니다.



> • When a process is newly created, it initially enters MLFQ. The process will be managed by the stride scheduler only if the set_cpu_share() system call has been invoked.

  

`allocproc()` 함수에는 프로세스가 새로 생성될 때 반드시 거쳐가야합니다. 프로세스가 새로 생성되었을 때, `push_MLFQ()` 함수를 통해 MLFQ의 prior lever 0인 queue에 새로 삽입해줍니다. 이후 프로세스가 MLFQ에서 빠지는 경우는 `exit()` 이 호출되거나, `set_cpu_share()` 함수가 호출되어 stride 스케줄러로 넘어갈 때입니다.

  

> • The total sum of CPU share requested from processes in the stride queue can not exceed 80% of CPU time. Exception handling needs to be properly implemented to handle oversubscribed requests.

  

위의 MLFQ에 20% 이상을 할당해줄 수 없다는 부분을 보면 됩니다.



## Scheduling scenario

### Given test case

1. 스스로 yield를 call하지 않는 MLFQ 프로세스가 4개 동시에 도는 경우

![ᅳ크린샷 2018-04-18 오후 9.58.0](/Users/junkyu/Desktop/스크린샷 2018-04-18 오후 9.58.02.png)

각 레벨에서의 time allotment가 5, 10이므로, MLFQ 프로세스가 동시에 4개 돌 경우에는 각자 레벨 0, 1, 2에서 5, 10, 10씩 돌면 boosting이 일어날 것으로 생각할 수 있습니다(boosting 주기가 100이므로). 위의 결과는 어느정도 거기에 부합함을 보이고 있습니다.

2. 스스로 yield를 call하는 프로세스 2개와 call하지 않는 프로세스 2개가 MLFQ 스케줄러에서 도는 경우

![ᅳ크린샷 2018-04-18 오후 9.59.2](/Users/junkyu/Desktop/스크린샷 2018-04-18 오후 9.59.22.png)

현재 저의 스케줄러에서는 1 tick을 단위로 스트라이드의 패스를 증가시키고, mlfq의 각 프로세스별 tick과 mlfq 전체의 tick을 올립니다. 만일 1tick이 되기 전에 system call인 mlfq를 호출한다면, 전체 스케줄러를 game할 우려가 있습니다. 이를 막기 위해서 sys_yield에서 2분의 1의 확률로 전체 tick을 올립니다. 

**생길 수 있는 문제**

- 0.5 tick보다 작은 주기로 yield를 호출하면 실제로 프로세스가 돈 시간보다 더 많이 돈 것으로 스케줄러는 체크합니다. 그렇게되면 위의 결과에서 볼 수 있는 것처럼 실제로 보장받은 time quantum만큼 돌지 못하는 경우가 발생할 수 있습니다. 하지만 스케줄러를 game하는 것을 방지하기 위한 trade-off로 판단하여 이렇게 디자인 하였습니다. 또한, 전체 boosting 주기가 짧아지는 효과를 낳으므로 compute로 실행된 프로세스들도 lev 2에 비해서 0과 1에 좀 더 오래 머무르게 됩니다.
- 0.5 tick보다 큰 주기로 yield를 호출하는 경우에도 scheduler를 game하지 못하게 운영체제의 tick으로 판단하게 했습니다.

3. MLFQ 프로세스 8개 중 4개는 compute, 4개는 yield일 때

![ᅳ크린샷 2018-04-18 오후 10.07.1](/Users/junkyu/Desktop/스크린샷 2018-04-18 오후 10.07.15.png)

부스팅 주기가 실제 시간보다 빨라지게 되므로, compute하는 경우 level 1에서 대부분의 boosting이 일어나게 됩니다.

4. MLFQ와 Stride가 복합적으로 돌아갈 때

![ᅳ크린샷 2018-04-18 오후 10.04.5](/Users/junkyu/Desktop/스크린샷 2018-04-18 오후 10.04.54.png)

stride의 비율은 정상적인 수치를 보여주고있습니다. yield를 하는 프로세스의 경우, 위에서 상술한 문제가 다시 나타나고 있습니다. 

**생길 수 있는 문제**

- MLFQ와 마찬가지로, Stride도 스스로 yield를 호출하는 경우에는 자신이 보장받은 stride만큼 진행되지 않아도 pass를 진행한 것으로 처리될 수 있습니다. 이 역시 스케줄러를 game하게 하지 못하기 위한 trade-off입니다.

5. Basic test

![ᅳ크린샷 2018-04-18 오후 10.14.3](/Users/junkyu/Desktop/스크린샷 2018-04-18 오후 10.14.38.png)



**생길 수 있는 문제**

- boosting 주기가 짧아지거나, 이전에 돌았던 MLFQ로 인하여 자신이 돈지 얼마되지 않아 부스팅이 빠르게 이루어진 경우, 위처럼 값이 한 번씩 엉킬 수 있으나, 이는 어쩔 수 없는 문제라고 판단하였습니다. 대안으로 부스팅과 부스팅 사이에 새로 MLFQ에 들어온 프로세스들은 부스팅을 받지 않게하는 방법도 있지만, 손해가 더 크다고 판단해서 사용하지 않았습니다.



### function call in proc.c

문제의 원인은 idle 프로세스가 따로 없다는 점입니다. idle 프로세스는 점유율이 딱 할당된 만큼만 cpu를 점유할 수 있게함으로서, 전체 cpu를 game하는 상황을 막아줄 수 있으나, 그만큼 cpu가 놀게된다는 단점도 있습니다. 따라서, 이번 과제에서는 별도의 idle 프로세스를 세팅하지않고, 할당된 점유율의 비율이 다소 깨지더라도 돌 수 있게 보장해주었습니다. 아래는 할당된 점유율이 깨질 수 있는 상황입니다.

1. `sleep()`을 호출 시, MLFQ의 경우에는 상관이 없으나, stride의 경우에는 다른 프로세스들이 실제로 할당된 비율 이상으로 돌아가는 문제가 발생합니다.
2. `exit()`을 호출하면, stride에서 할당된 티켓을 우선적으로 MLFQ에게 재할당해줍니다. idle 프로세스가 있었다면 해결될 수 있는 문제입니다.
3. `set_cpu_share()` 를 요청한 함수가 return값이 -1이면 다시 MLFQ로 들어가거나, 실행파일에 따라 종료됩니다. 이 경우 대기열을 만들어 대기열에 삽입하게하는 방법도 있을 수 있지만, 적체 현상이 발생할 수 있어 실행파일이 주기적으로 요청하게하는 편이 낫다고 판단했습니다.