@echo off
REM Compile and link an example of DLL, and after, compile and link program test of DLL with LCC 32 bits
SET PATHINIT=%PATH%
set PATH=C:\lcc\bin;%PATH%
del dllcore.dll dllcore.lib testdll.exe
lcc -O -g2 dllcore.c -o dllcore.obj
lcclnk.exe dllcore.obj dllcore.def -dll -entry LibMain -subsystem windows -o dllcore.dll
lcclib dllcore.lib dllcore.obj
pedump /EXP dllcore.obj
pedump /EXP dllcore.dll
pedump /EXP dllcore.lib
lcc -O -g2 testdll.c
lcclnk.exe testdll.obj dllcore.lib -subsystem console
testdll.exe
%PYTHON32% test_add_stdcall.py dllcore.dll
SET PATH=%PATHINIT%
