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
	}
	return 0;
}
