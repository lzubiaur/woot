#include "file_util.h"

#include <stdlib.h>     /* malloc, free, realpath */

#if defined(__APPLE__)
/* For _NSGetExecutablePath */
#include <mach-o/dyld.h>
#endif

#ifdef __linux__
#endif

#ifdef _WIN32
#endif

char * get_exec_path()
{
    uint32_t size = 0;
    char * full_path = NULL;
    char *buf = NULL;
    /* First call to get the buffer required size */
    _NSGetExecutablePath(NULL, &size);
    buf = (char *)malloc(size);
    /* Second call to actually get the exec path */
    _NSGetExecutablePath(buf, &size);
    /* Get the real absolute path. realpath will allocate */
    full_path = realpath(buf, NULL);
    free(buf);
    return full_path;
}
