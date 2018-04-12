#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
	int pid; //pid_t 선언

	pid = fork(); //fork 발생
	if(pid == -1) { //-1 이면 fork생성 에러
		//printf("can't fork, erro\n");
		exit();
	}

	if(pid == 0) { //0이면 자식 프로세스
		printf(1, "parent\n");
		exit();
	} else { //부모프로세스
		printf(1, "child\n");
		exit();
	}
 	exit();
}