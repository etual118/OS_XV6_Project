/**
 *  This program runs child test programs concurrently.
 */

#include "types.h"
#include "stat.h"
#include "user.h"

// Number of child programs
<<<<<<< HEAD
#define CNT_CHILD           4
=======
#define CNT_CHILD           40
>>>>>>> 34faf4755e28edd2632c96779588f5c123496b70

// Name of child test program that tests Stride scheduler
#define NAME_CHILD_STRIDE   "test_stride"
// Name of child test program that tests MLFQ scheduler
#define NAME_CHILD_MLFQ     "test_mlfq"

char *child_argv[CNT_CHILD][3] = {
  // Process scheduled by Stride scheduler, use 10% of CPU resources
  {NAME_CHILD_STRIDE, "1", 0},
  // Process scheduled by Stride scheduler, use 40% of CPU resources
<<<<<<< HEAD
  {NAME_CHILD_STRIDE, "40", 0},
=======
  {NAME_CHILD_STRIDE, "3", 0},
>>>>>>> 34faf4755e28edd2632c96779588f5c123496b70
  // Process scheduled by MLFQ scheduler, does not yield() itself
  {NAME_CHILD_MLFQ, "0", 0},
  // Process scheduled by MLFQ scheduler, frequently yield()
  {NAME_CHILD_MLFQ, "1", 0},
};

int
main(int argc, char *argv[])
{
  int pid;
  int i;

  for (i = 0; i < CNT_CHILD; i++) {
    pid = fork();
    if (pid > 0) {
      // parent
      continue;
    } else if (pid == 0) {
      // child
<<<<<<< HEAD
      int p = i;
=======
      int p = i % 4;
>>>>>>> 34faf4755e28edd2632c96779588f5c123496b70
      exec(child_argv[p][0], child_argv[p]);
      printf(1, "exec failed!!\n");
      exit();
    } else {
      printf(1, "fork failed!!\n");
      exit();
    }
  }
  
  for (i = 0; i < CNT_CHILD; i++) {
    wait();
  }

  exit();
}
