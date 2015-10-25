#!/usr/bin/env python

# Generate OpenGL header for Lua FFI binding

# This file is based on gl3w_eng.py from the gl3w library
# hosted at https://github.com/skaslev/gl3w

# Allow Python 2.6+ to use the print() function
from __future__ import print_function

import re
import os

# Rename C functions in Lua FFI
# http://lua-users.org/lists/lua-l/2011-07/msg00484.html

ignored_functions = ['glDebugMessageCallback']
# GL_TIMEOUT_IGNORED is defined with the value 0xFFFFFFFFFFFFFFFFull which
# crashes (Segmentation fault) in the LuaJIT FFI cdef function
# Note that GL_INVALID_INDEX is defined with 0xFFFFFFFFu and will be defined with 0xFFFFFFFF
# TODO find a workaround for GL_TIMEOUT_IGNORED
ignored_defines = ['GL_TIMEOUT_IGNORED']
ignored_typdefs = ['APIENTRYP', 'APIENTRY']

downcase = lambda s: s[:1].lower() + s[1:] if s else ''

# Parse function names from glcorearb.h
print('Parsing glcorearb.h header...')
procs = []
enums = []
typedefs = []
p1 = re.compile(r'GLAPI\s(.*)\sAPIENTRY\s(\w+)\s(.*);')
p2 = re.compile(r'#define\s(GL_.*)\s(0x[0-9a-fA-F]+)')
p3 = re.compile(r'typedef(.*)(GL.*);')
with open('lib/gl3w/include/GL/glcorearb.h', 'r') as f:
    for line in f:
        m1 = p1.match(line)
        m2 = p2.match(line)
        m3 = p3.match(line)
        if m1:
            if all(f not in m1.group(2) for f in ignored_functions):
                procs.append(m1.group(1) + ' ' + downcase(m1.group(2)[2:]) + ' ' + m1.group(3) + ' asm("' + m1.group(2) + '");')
        if m2:
            if all(f not in m2.group(1) for f in ignored_defines):
                enums.append(m2.group(1)[3:] + ' = ' + m2.group(2) + ',')
        if m3:
            if all(f not in m3.group(0) for f in ignored_typdefs):
                typedefs.append(m3.group(0))
procs.sort()
enums.sort()
# Remove duplicates
# typedefs = list(set(typedefs))
typedefs.sort()

# Generate gen_h.lua
print('Generating gl_h.lua in lua/engine...')
with open('lua/engine/gl_h.lua', 'wb') as f:
    f.write('''local ffi = require 'ffi'
ffi.cdef [[
/* OpenGL typedef */
''')
    for typedef in typedefs:
        f.write(typedef + '\n')
    f.write('''
/* OpenGL defines */
enum {
FALSE    = 0,
TRUE     = 1,
ZERO     = 0,
ONE      = 1,
NONE     = 0,
NO_ERROR = 0,
''')
    for enum in enums:
        f.write(enum + '\n')
    f.write('''
};
/* OpenGL functions */
''')

    for proc in procs:
        f.write(proc + '\n')
    f.write(b']]\n')
