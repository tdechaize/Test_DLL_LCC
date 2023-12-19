@echo off
REM Compile and link an example of DLL, and after, compile and link program test of DLL with LCC 64 bits
SET PATHINIT=%PATH%
set PATH=C:\lcc64\bin;%PATH%
del dllcore64.dll dllcore64.lib testdll64.exe
lcc64 -O -A dllcore.c -o dllcore64.obj -IC:\lcc64\include64
lcclnk64.exe dllcore64.obj dllcore64.def -dll -entry LibMain -subsystem windows -o dllcore64.dll -LC:\lcc64\lib64
lcclib64 dllcore64.lib dllcore64.obj
pedump /EXP dllcore64.obj
pedump /EXP dllcore64.dll
pedump /EXP dllcore64.lib
lcc64 -O -A testdll.c -o testdll64.obj -IC:\lcc64\include64
lcclnk64.exe testdll64.obj dllcore64.lib -subsystem console -o testdll64.exe -LC:\lcc64\lib64
testdll64.exe
%PYTHON64% test_add_stdcall.py dllcore64.dll
SET PATH=%PATHINIT%
