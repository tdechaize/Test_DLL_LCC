# Wedit Makefile for project testdll
SRCDIR=c:\src\lcc\testdll\src
CFLAGS=-I"C:\lcc64\include64" -DBUILD_DLL  -dll
CC=$(LCCROOT)\bin\lcc64.exe
LINKER=$(LCCROOT)\bin\lcclnk64.exe
OBJS=\

LIBS=dll_core64.lib
EXE=testdll.dll

$(EXE):	$(OBJS) Makefile
	$(LINKER)  -s -dll -LC:\lcc64\lib64 -entry LibMain -o c:\src\lcc\testdll\\testdll.dll $(OBJS) $(LIBS)

link:
	$(LINKER)  -s -dll -LC:\lcc64\lib64 -entry LibMain -o c:\src\lcc\testdll\\testdll.dll $(OBJS) $(LIBS)

clean:
	del $(OBJS) testdll.dll
