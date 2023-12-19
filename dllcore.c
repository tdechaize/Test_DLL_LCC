//*********************       File : dll_core.c (main core of dll)       *****************
// #define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdio.h>

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

int hello( void )
 {
    printf( "Hello from a DLL!\n" );
    return( 0 );
 }

int add(int i1, int i2)
 {
	return  i1 + i2;
 }

int substract(int i1, int i2)
 {
	return i1 - i2;
 }

int multiply (int i1, int i2)
 { 
   return i1 * i2 ;
 }
//******************************    End file : dll_core.c   *********************************
 