//*********************    File : dll_core64.c (main core of dll)    *****************
// #define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdio.h>
#include "dll_share64.h"

/*------------------------------------------------------------------------
 Procedure:     LibMain
 Purpose:       Dll entry point. Called when a dll is loaded or
                unloaded by a process, and when new threads are
                created or destroyed.
 Input:         hDllInst: 		Instance handle of the dll
                fdwReason: 		event: attach/detach
                lpvReserved: 	not used
 Output:        The return value is used only when the fdwReason is
                DLL_PROCESS_ATTACH. True means that the dll has
                sucesfully loaded, False means that the dll is unable
                to initialize and should be unloaded immediately.
 Errors:
------------------------------------------------------------------------*/

BOOL WINAPI LibMain(void 		  *hinstDll,
					unsigned long dwReason,
					void 		  *reserved)
{
    switch( dwReason ) {
    case DLL_PROCESS_ATTACH:
        printf( "DLL attaching to process...\n" );
        break;
    case DLL_PROCESS_DETACH:
        printf( "DLL detaching from process...\n" );
        break;
		// The attached process creates a new thread.
	case DLL_THREAD_ATTACH:
		printf("The attached process creating a new thread...\n");
		break;
		// The thread of the attached process terminates.
	case DLL_THREAD_DETACH:
		printf("The thread of the attached process terminates...\n");
		break;
	default:
		printf("Reason called not matched, error if any : %ld...\n", GetLastError());
		break;
    }
    return( 1 );    /* Indicate success */
}

/*------------------------------------------------------------------------

 Another instructions : 		list of exported functions of DLL. 
 
 All functions must be declared in dll_share.h, but instancied here
 with body described all instructions to execute "really" that for 
 which each function is defined. Noted prefix FUNCAPI valued at :
		__declspec(dllexport) when generate DLL
		__declspec(dllimport) when use DLL
 
------------------------------------------------------------------------*/

int Hello(void)
 {
    printf( "Hello from a DLL!\n" );
    return( 0 );
 }

int Addint(int i1, int i2)
 {
	return i1 + i2;
 }
 
int Subint(int i1, int i2)
 {
	return i1 - i2;
 }

int Multint(int i1, int i2)
 { 
   return i1 * i2;
 }

int Divint(int i1, int i2) 
 {
  if (i2 == 0) { 
     printf("La division par zero n'est pas autorisee, le retour vaut 1 par défaut.\n");
     return(1);
  } else { 
	  return (i1/i2);
  }
 }
  
int Squarint(int i)
 { 
   return i * i;
 }

double Adddbl(double i1, double i2)
 {
	return i1 + i2;
 }
 
double Subdbl(double i1, double i2)
 {
	return i1 - i2;
 }

double Multdbl(double i1, double i2)
 { 
   return i1 * i2;
 }
 
double Divdbl(double i1, double i2) 
 {
  if (i2 == 0.0) { 
     printf("La division par zero n'est pas autorisee, le retour vaut 1 par défaut.\n");
     return(1.0);
  } else   {
	  return (i1/i2);
  }
 }
  
double Squardbl(double i)
 { 
   return i * i;
 }
 //******************************    End file : dll_core64.c   *********************************
 