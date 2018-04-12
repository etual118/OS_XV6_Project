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
<<<<<<< HEAD
=======

	if(pid == 0) { //0이면 자식 프로세스
		printf(1, "parent\n");
		exit();
	} else { //부모프로세스
		printf(1, "child\n");
		exit();
>>>>>>> 291335925149fc98ac10c7492d9a604d1d0e9568
	}
	return 0;
}

