#!/usr/bin/env python
# coding=utf-8

# Generate OpenGL header for Lua FFI binding
# OpenGL functions and constants lose their gl/GL prefix in Lua.
# See this post regarding renaming functions with LuaJIT FFI.
# http://lua-users.org/lists/lua-l/2011-07/msg00484.html

# This file is based on gl3w_eng.py from the gl3w library
# hosted at https://github.com/skaslev/gl3w

# Allow Python 2.6+ to use the print() function
from __future__ import print_function

import re
import sys,os
import argparse

parser = argparse.ArgumentParser()

parser.add_argument('-a', '--all', action='store_true',
    help="Generate Lua binding for all OpenGL functions and constants")

args = parser.parse_args()

# Path to search for OpenGL occurrences
src_paths = [ './lua', './tests/lua' ]

used_functions = []
used_defines = []
# OpenGL functions regex. Word prefixed with `gl.` or `bind.` and followed with some whitespace and a round bracket.
p1 = re.compile(r'(gl\.|bind\.)(\w+)\s*\(')
# OpenGL constants (aka define) regex. Only uppercase word prefixed with `gl.` or `bind.`
p2 = re.compile(r'(gl\.|bind\.)([A-Z0-9_]+)')

if not args.all:
    for src_path in src_paths:
        for path, dirs, files in os.walk(src_path):
            for filename in files:
                if not os.path.splitext(filename)[1] == '.lua':
                    continue
                fullpath = os.path.join(path, filename)
                print(fullpath)
                with open(fullpath, 'r') as f:
                    for line in f:
                        m1 = p1.findall(line)
                        for m in m1:
                            if not m[1].startswith('glfw'):
                                used_functions.append(m[1])
                        m2 = p2.findall(line)
                        for m in m2:
                            used_defines.append(m[1])

    used_functions = list(set(used_functions))
    used_functions.sort()
    for function in used_functions:
        print(function)

    used_defines = list(set(used_defines))
    used_defines.sort()
    for define in used_defines:
        print(define)

ignored_functions = ['glDebugMessageCallback']
# GL_TIMEOUT_IGNORED is defined with the value 0xFFFFFFFFFFFFFFFFull which
# crashes (Segmentation fault) in the LuaJIT FFI cdef function
# Note that GL_INVALID_INDEX is defined with 0xFFFFFFFFu and will be defined with 0xFFFFFFFF
# TODO find a workaround for GL_TIMEOUT_IGNORED
ignored_defines = ['GL_TIMEOUT_IGNORED']
ignored_typdefs = ['APIENTRYP', 'APIENTRY']

# Set the first character of the string to lowercase
downcase = lambda s: s[:1].lower() + s[1:] if s else ''

procs = []      # List of functions
enums = []      # List of defines (will be converted into enum in Lua FFI)
typedefs = []   # List ot typedef

# Split a regular expression into
def func_t(m):
    t = { 'rt': m.group(1),                  # Return type
          'name': downcase(m.group(2)[2:]),  # Strip function name (without the `gl` prefix)
          'cname': m.group(2),               # Canonical function name (as in the C API)
          'param': m.group(3) }              # Function parameter list (including the brackets)

    if any(f == t['cname'] for f in ignored_functions):
        return

    if not args.all and all(f != t['name'] for f in used_functions):
        return

    procs.append(t)

def def_t(m):
    t = { 'name': m.group(1)[3:],            # The `GL_` prefix is removed from the OpenGL define name
          'cname': m.group(1),               # Canonical OpenGL define name
          'value': m.group(2) }

    if any(f == t['cname'] for f in ignored_defines):
        return

    if not args.all and all(f != t['name'] for f in used_defines):
        return

    enums.append(t)

def typedef_t(m):
    t = { 'name': m.group(2),
          'type': m.group(1) }

    if any(f in m.group(0) for f in ignored_typdefs):
        return

    typedefs.append(t)

# Regular expressions for functions, defines and typdefs
p = [ [ re.compile(r'GLAPI\s(.*)\sAPIENTRY\s(\w+)\s(.*);'), func_t ],
      [ re.compile(r'#define\s*(GL_\w+)\s*(0x[0-9a-fA-F]+)'), def_t ],
      [ re.compile(r'typedef(.*)(GL.*);'), typedef_t] ]

# Parse function names, defines and typedefs from glcorearb.h
print('Parsing glcorearb.h header...')
with open('lib/gl3w/include/GL/glcorearb.h', 'r') as f:
    for line in f:
        for _p in p:
            m = _p[0].match(line)
            if m:
                _p[1](m)
                continue

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
    for t in typedefs:
        f.write('typedef {0[type]} {0[name]};\n'.format(t).encode('utf-8'))
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
    for e in enums:
        f.write('{0[name]} = {0[value]},\n'.format(e).encode('utf-8'))
    f.write('''
};
/* OpenGL functions */
''')

    for p in procs:
        f.write('{0[rt]} {0[name]}{0[param]} asm("{0[cname]}");\n'.format(p).encode('utf-8'))
    f.write(b']]\n')
