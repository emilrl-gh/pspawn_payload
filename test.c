#include <stdio.h>
#include <spawn.h>

extern char **environ;

int main(int argc, char *argv[]){
	if(argc == 2){
		pid_t pid;
       	 	const char *args[] = {argv[1], NULL};
        	int ret = posix_spawn(&pid, argv[1], NULL, NULL, (char* const*)args, environ);
        	printf("ret from binary: %d\n",ret);
		return 0;
	} else {
		printf("Usage: ./test <binary-path>\n");
		printf("Example: ./test /usr/bin/wget\n");
		return 0;
	}
	return -1;
}
