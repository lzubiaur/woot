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
    char *path = NULL, *dir = NULL, *buf = NULL;
    if ((path = get_exec_path()) == NULL) goto error;
    if ((buf = dirname(path)) == NULL) {
        perror("get_app_dir");
        goto error;
    }
    free(path);
    if ((dir = (char*)malloc(strlen(buf) + 1)) == NULL) {
        fprintf(stderr, "insufficient memory\n");
        goto error;
    }
    strcpy(dir,buf);
    return dir;

error:
    free(path);
    free(dir);
    return NULL;
}

/*
 * http://stackoverflow.com/questions/1023306/finding-current-executables-path-without-proc-self-exe
 */
char *get_exec_path()
{
    char *full_path = NULL, *buf = NULL;
#ifdef __APPLE__
    uint32_t size = 0;
    /* First call to get the buffer required size */
    _NSGetExecutablePath(NULL, &size);
    if ((buf = (char *)malloc(size)) == NULL) {
        fprintf(stderr, "insufficient memory\n");
        goto error;
    }
    /* Second call to actually get the exec path */
    if (_NSGetExecutablePath(buf, &size) != 0) {
        fprintf(stderr, "Can't get executable path\n");
        goto error;
    }
#elif defined(__linux__)
    size_t r;
    if ((buf = (char *)malloc(PATH_MAX)) == NULL) {
        fprintf(stderr, "insufficient memory\n");
        goto error;
    }
    if ((r = readlink("/proc/self/exe",buf,PATH_MAX)) < 0 ) {
        perror("get_exec_path");
        goto error;
    }
    buf[r] = '\0';
#endif
    /* Get the real absolute path. */
    if ((full_path = realpath(buf, NULL)) == NULL) {
        perror("get_exec_path");
        goto error;
    }
    free(buf);
    return full_path;

error:
    free(buf);
    free(full_path);
    return NULL;
}
