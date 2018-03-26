#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#define MAX 1000 //maximum input command is 1000

char input[MAX]; //input is global variable could be used by Interactive and Batch Function

void Interactive(void);
void Batch(char input_file[]);
void Parser(void);

/*
	This is main function for Interactive and Batch functions
	argc should be 1 or 2, Interactive and Batch mode
	if argc is larger than 2, then it prints err message
*/
int main(int argc, char** argv){

	if(argc > 3){
		printf("Interactive and Batch mode only\n");
		return -1;
	}
	else if (argc == 1)
		Interactive();
	else if (argc == 2)
		Batch(argv[1]);
	else 
		return -1;
	return 0;
}

void Interactive(void){

	while(1){
		printf("prompt> ");
		if(fgets(input, sizeof(input), stdin) == NULL)
			exit(0); //ctrl + D is EOF, so if return value of fgets function is NULL, then exit the process

		input[strlen(input)-1] = 0;		

		if(strcmp(input, "quit") == 0){
			exit(0); //exit by quit command
		}
		Parser();
	}
}

void Batch(char input_file[]){

	FILE *cmd_file = fopen(input_file, "r"); //open file by file pointer and fopen function

	while(1){

		if(fgets(input, sizeof(input), cmd_file) == NULL)
			exit(0);//when end of the file exit the process

		input[strlen(input)-1] = 0;
		puts(input);
		
		if(strcmp(input, "quit") == 0){
			exit(0);
		}
		Parser();
	}
}

/*
	Both Interactive and Batch Function use Parser for executing command
	Parser() uses global variable input[], and parses it by using strtok function
	and execute it by using fork and execvp function
*/

void Parser(){

	char* checkpoint[50]; //it makes checkpoint which means start address of each command seperated by ;
	int check = 0; //this variable means the number of commands
	int i = 0;
	/*
		now it uses strtok function and parsed all commands
		when strtok operated, then check increases
		separator variable is used for save temporarily strtok return value
	*/
	char *separator = strtok(input, ";");

	while(separator != NULL){
		checkpoint[i++] = separator;
		check++;
		separator = strtok(NULL, ";");
	}

	char** input_cmd[50];//this variable is for saving command so the number of commands should be less then 50

	for(i = 0; i < check; i ++){
		input_cmd[i] = (char**)malloc(sizeof(char*)*100);//dynamic allocate for saving each input commmands
	}

	for(i = 0; i < check; i++){
		int j = 0;
		separator = strtok(checkpoint[i], " ");//seperate each checkpoint by space for save option seperately(like ls -al)
		while(separator != NULL){
			input_cmd[i][j++] = separator;
			separator = strtok(NULL, " ");
		}
		input_cmd[i][j] = separator;//it should be NULL value for using execvp function
	}
	
	pid_t pid[check];//now make process structure for using wait

	for(i = 0; i < check; i++){
		if(*input_cmd[i] == NULL)//kill the process if command is not found
			break;
		if((strcmp(*input_cmd[i], "quit")) == 0){
			for(int k = 0; k < i; k++){
				waitpid(pid[k], NULL, 0);
			}
			exit(0);
		}//if command is quit then quit after waiting other processes
		if((pid[i] = fork()) < 0){//this is error case
			exit(0);
		}else if(pid[i] == 0){//if child process
			if(execvp(*input_cmd[i], input_cmd[i]) < 0)//use execvp function
				kill(getpid(), SIGINT);//kill if command is not found
			break;
		}else{
			continue;
		}
	}
	for(i = 0; i < check; i++){
		waitpid(pid[i], NULL, 0);//and wait other process
	}
}

