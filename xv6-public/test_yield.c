#include "types.h"
#include "user.h"
#include "stat.h"

int
main(int argc, char *argv[])
{
	int pid=fork();
	while(1){
	if(pid < 0) {
		printf(1,"ERROR\n");
	} else if( pid == 0 ) {
			printf(1,"Child\n");
			yield();
	} else {
			printf(1,"Paren\n");
			yield();
	}

	if(pid == 0) { //0이면 자식 프로세스
		printf(1, "parent\n");
		exit();
	} else { //부모프로세스
		printf(1, "child\n");
		exit();
<<<<<<< HEAD
	
        }
        }
=======
	}
>>>>>>> 9911877b946faad769f21adb8f8d8effa3ac0dfb
	return 0;
}

