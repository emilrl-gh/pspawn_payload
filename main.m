//
//  main.m
//  fishook
//
//  Created by Emil Rose Levy on 26/12/2021.
//
#import <dlfcn.h>
#import "fishhook.h"
#include <spawn.h>
#include <stdio.h>

extern char **environ;
typedef int (*pspawn_t)(pid_t *pid,
                        const char *path,
                        const posix_spawn_file_actions_t *file_actions,
                        posix_spawnattr_t *attrp,
                        const char *argv[],
                        const char *envp[]);

pspawn_t old_pspawn, old_pspawnp;

int fake_posix_spawn_common(pid_t *pid,
                            const char *path,
                            const posix_spawn_file_actions_t *file_actions,
                            posix_spawnattr_t *attrp,
                            const char *argv[],
                            const char *envp[],
                            pspawn_t old) {
    printf("hey from the dylib ;). i'm Calling %s with argv: %s just for u ;) BUT BEFORE i need to sign it !\n",path, argv[0]);    
    pid_t pd;
    char *args[] = {"ldid", "-Ksigncert.p12","-Sent.xml",path, NULL};
    int stat;
    printf("Run command: %s\n", path);
    stat = old(&pd, "ldid", NULL, NULL, args, environ);
    int origret = old(pid, path, file_actions, attrp, argv, envp);
    return origret;
}

int fake_posix_spawn(pid_t *pid,
                      const char *file,
                      const posix_spawn_file_actions_t *file_actions,
                      posix_spawnattr_t *attrp,
                      const char *argv[],
                      const char *envp[]) {
     return fake_posix_spawn_common(pid, file, file_actions, attrp, argv, envp, old_pspawn);
 }

 int fake_posix_spawnp(pid_t *pid,
                       const char *file,
                       const posix_spawn_file_actions_t *file_actions,
                       posix_spawnattr_t *attrp,
                       const char *argv[],
                       const char *envp[]) {
     return fake_posix_spawn_common(pid, file, file_actions, attrp, argv, envp, old_pspawnp);
 }

void rebind_pspawns(void) {
    struct rebinding rebindings[] = {
        {"posix_spawn", (void *)fake_posix_spawn, (void **)&old_pspawn},
        {"posix_spawnp", (void *)fake_posix_spawnp, (void **)&old_pspawnp},
    };
    
    rebind_symbols(rebindings, 2);
}

void* thd_func(void* arg){
    printf("In a new thread!");
    rebind_pspawns();
    return NULL;
}

__attribute__ ((constructor))
static void ctor(void) {
    rebind_pspawns();
}
