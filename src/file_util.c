#include "file_util.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>     /* malloc, free, realpath */

#ifdef __APPLE__
/* For _NSGetExecutablePath */
#include <mach-o/dyld.h>
#endif

#ifdef __linux__
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <limits.h> /* realpath */
#endif

#include <libgen.h>

#ifdef _WIN32
#endif

char *get_app_dir()
{
    char *path = NULL;
    char *dir = NULL;
    if ((path = get_exec_path()) == NULL) {
        return NULL;
    }
    char * buf = dirname(path);
    free(path);
    if ((dir = (char*)malloc(strlen(buf) + 1)) == NULL) {
        return NULL;
    }
    strcpy(dir,buf);
    return dir;
}

/*
 * http://stackoverflow.com/questions/1023306/finding-current-executables-path-without-proc-self-exe
 */
char *get_exec_path()
{
    char * full_path = NULL;
    char *buf = NULL;
#ifdef __APPLE__
    uint32_t size = 0;
    /* First call to get the buffer required size */
    _NSGetExecutablePath(NULL, &size);
    buf = (char *)malloc(size);
    /* Second call to actually get the exec path */
    _NSGetExecutablePath(buf, &size);
    /* Get the real absolute path. */
    full_path = realpath(buf, NULL);
    free(buf);
#elif defined(__linux__)
    size_t r;
    if ((buf = (char *)malloc(PATH_MAX)) == NULL) {
        fprintf(stderr, "insufficient memory\n");
	exit(EXIT_FAILURE);
    }
    r = readlink("/proc/self/exe",buf,PATH_MAX);
    if (r < 0) {
        perror("get_exec_path");
        exit(EXIT_FAILURE);
    }
    buf[r] = '\0';
    full_path = realpath(buf, NULL);
    free(buf);
#endif
    return full_path;
}
