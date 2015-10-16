# JPEG 9b
# CMake configuration to build a shared library so libjpeg can be used as 3rd
# party library in another project. No examples or command-line tools are build.
cmake_minimum_required(VERSION 3.3. FATAL_ERROR)

# List of source files to build the library from makefile.ansi
set(LIB_SRC
   jaricom.c jcapimin.c jcapistd.c jcarith.c jccoefct.c jccolor.c
   jcdctmgr.c jchuff.c jcinit.c jcmainct.c jcmarker.c jcmaster.c
   jcomapi.c jcparam.c jcprepct.c jcsample.c jctrans.c jdapimin.c
   jdapistd.c jdarith.c jdatadst.c jdatasrc.c jdcoefct.c jdcolor.c
   jddctmgr.c jdhuff.c jdinput.c jdmainct.c jdmarker.c jdmaster.c
   jdmerge.c jdpostct.c jdsample.c jdtrans.c jerror.c jfdctflt.c
   jfdctfst.c jfdctint.c jidctflt.c jidctfst.c jidctint.c jquant1.c
   jquant2.c jutils.c jmemmgr.c
   )
# Memory managner back end. Compile only one of these into a working library. See install.txt
set(SYS_DEP_SRC
    jmemnobs.c
    # jmemansi.c
    # jmemname.c
    # jmemdos.c
    # jmemmac.c
    )
# files included by source files
set(JPEG_INCLUDES
   jdct.h jerror.h jinclude.h jmemsys.h jmorecfg.h jpegint.h
   jpeglib.h jversion.h cdjpeg.h cderror.h transupp.h
   )

# Configure JPEG (jconfig.h). See http://www.vtk.org/Wiki/CMake:How_To_Write_Platform_Checks
include(CheckIncludeFile)
check_include_file(stdlib.h HAVE_STDLIB_H)
check_include_file(stddef.h HAVE_STDDEF_H)

configure_file(jconfig.cmake.in ${PROJECT_BINARY_DIR}/jconfig.h)

include_directories(${JPEG_INCLUDES} ${PROJECT_BINARY_DIR})
add_library(jpeg SHARED ${LIB_SRC} ${SYS_DEP_SRC})
# target_include_directories(jpeg "${PROJECT_BINARY_DIR}/jconfig.h")

