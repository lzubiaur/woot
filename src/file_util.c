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
    if ((path = get_exec_path()) == NULL) goto end;
    if ((buf = dirname(path)) == NULL) {
        perror("get_app_dir");
        goto end;
    }
    if ((dir = (char*)malloc(strlen(buf) + 1)) == NULL) {
        fprintf(stderr, "insufficient memory\n");
        goto end;
    }
    strcpy(dir,buf);

end:
    free(path);
    return dir;
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
        goto end;
    }
    /* Second call to actually get the exec path */
    if (_NSGetExecutablePath(buf, &size) != 0) {
        fprintf(stderr, "Can't get executable path\n");
        goto end;
    }
#elif defined(__linux__)
    size_t r;
    if ((buf = (char *)malloc(PATH_MAX)) == NULL) {
        fprintf(stderr, "insufficient memory\n");
        goto end;
    }
    if ((r = readlink("/proc/self/exe",buf,PATH_MAX)) < 0 ) {
        perror("get_exec_path");
        goto end;
    }
    buf[r] = '\0';
#endif
    /* Get the real absolute path. */
    if ((full_path = realpath(buf, NULL)) == NULL) {
        perror("get_exec_path");
        goto end;
    }

    /* TODO Windows */
    /* Windows: GetModuleFileName() with hModule = NULL */

end:
    free(buf);
    return full_path;
}
