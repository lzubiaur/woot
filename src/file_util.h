/*
 * Copyright (c) 2015 Laurent Zubiaur - voodoocactus.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#ifndef FILE_UTIL_H
#define FILE_UTIL_H

#ifdef _WIN32
#define chdir(p) (_chdir(p))
#endif

#ifdef __cplusplus
extern "C" {
#endif

/* Get the directory absolute path of the executable.
 * The path string must be freed by the caller.
 */
char *get_app_dir();
/* Get the executable absolute path (no symbolic link, /./ or /../ components are resolved).
 * The string is dynamically allocated and must be freed by the caller.
 */
char *get_exec_path();

#ifdef __cplusplus
}
#endif

#endif /* FILE_UTIL_H */
