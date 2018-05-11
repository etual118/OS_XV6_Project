#include "syscall.h"
#include "types.h"
#include "user.h"

int main(int argc, char** argv){
    int pid, ppid;
    pid = getpid();
    ppid = getppid();
    printf(1,"my pid is %d\n", pid);
    printf(1,"my ppid is %d\n", ppid);
    exit();
}
