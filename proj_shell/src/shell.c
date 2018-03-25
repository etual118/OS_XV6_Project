#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#define MAX 100

char input[MAX];

void Interactive(void){

	while(1){

		printf("prompt> ");
		if(fgets(input, sizeof(input), stdin) == NULL)
			exit(0);

		input[strlen(input)-1] = 0;
			char* separator;
		
		if(strcmp(input, "quit") == 0){
			exit(0);
		}
		char* checkpoint[50];
		int check = 0;
		int i = 0;
		separator = strtok(input, ";");

		while(separator != NULL){
			checkpoint[i++] = separator;
			check++;
			separator = strtok(NULL, ";");
		}

		char** input_cmd[50];

		for(i = 0; i < check; i ++){
			input_cmd[i] = (char**)malloc(sizeof(char*)*10);
		}

		for(i = 0; i < check; i++){
			int j = 0;
			separator = strtok(checkpoint[i], " ");
			while(separator != NULL){
				input_cmd[i][j++] = separator;
				separator = strtok(NULL, " ");
			}
			input_cmd[i][j] = separator;
		}
		
		pid_t pid[check];

		for(i = 0; i < check; i++){
			if((strcmp(*input_cmd[i], "quit")) == 0){
				for(int k = 0; k < i; k++){
					waitpid(pid[k], NULL, 0);
				}
				exit(0);
			}
			if((pid[i] = fork()) < 0){
				exit(0);
			}else if(pid[i] == 0){
				if(execvp(*input_cmd[i], input_cmd[i]) < 0)
					exit(0);
				break;
			}else{
				continue;
			}
		}
		for(i = 0; i < check; i++){
			waitpid(pid[i], NULL, 0);
		}

	}


}

void Batch(char input_file[]){

	FILE *cmd_file = fopen(input_file, "r");

	while(1){

		if(fgets(input, sizeof(input), cmd_file) == NULL)
			exit(0);

		input[strlen(input)-1] = 0;
		puts(input);
		char* separator;
		
		if(strcmp(input, "quit") == 0){
			exit(0);
		}
		char* checkpoint[50];
		int check = 0;
		int i = 0;
		separator = strtok(input, ";");

		while(separator != NULL){
			checkpoint[i++] = separator;
			check++;
			separator = strtok(NULL, ";");
		}

		char** input_cmd[50];

		for(i = 0; i < check; i ++){
			input_cmd[i] = (char**)malloc(sizeof(char*)*10);
		}

		for(i = 0; i < check; i++){
			int j = 0;
			separator = strtok(checkpoint[i], " ");
			while(separator != NULL){
				input_cmd[i][j++] = separator;
				separator = strtok(NULL, " ");
			}
			input_cmd[i][j] = separator;
		}
		
		pid_t pid[check];

		for(i = 0; i < check; i++){
			if((strcmp(*input_cmd[i], "quit")) == 0){
				for(int k = 0; k < i; k++){
					waitpid(pid[k], NULL, 0);
				}
				exit(0);
			}
			if((pid[i] = fork()) < 0){
				exit(0);
			}else if(pid[i] == 0){
				if(execvp(*input_cmd[i], input_cmd[i]) < 0)
					exit(0);
				break;
			}else{
				continue;
			}
		}
		for(i = 0; i < check; i++){
			waitpid(pid[i], NULL, 0);
		}
	}

}

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

