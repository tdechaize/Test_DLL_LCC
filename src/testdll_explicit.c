//*******************       File : testdll_explicit.c (main test of dll with load explicit)        *****************
#include <windows.h> 
#include <stdio.h> 
#include "dll_share.h"

typedef int (APIENTRY *pfnHello)(); 
typedef int (APIENTRY *pfnAddint)(int,int); 
typedef int (APIENTRY *pfnSubint)(int,int); 
typedef int (APIENTRY *pfnMultint)(int,int); 
typedef int (APIENTRY *pfnDivint)(int,int); 
typedef int (APIENTRY *pfnSquarint)(int); 
typedef double (APIENTRY *pfnAdddbl)(double,double); 
typedef double (APIENTRY *pfnSubdbl)(double,double); 
typedef double (APIENTRY *pfnMultdbl)(double,double); 
typedef double (APIENTRY *pfnDivdbl)(double,double); 
typedef double (APIENTRY *pfnSquardbl)(double);  

int main(int argc,char *argv[])
{

  int a = 42;
  int b = 7;
  int result = 0;
  double a1 = 16.9;
  double b1 = 7.3;
  double result1 = 0.0;
  
  pfnHello HelloFunc;
  pfnAddint AddintFunc; 
  pfnSubint SubintFunc; 
  pfnMultint MultintFunc; 
  pfnDivint DivintFunc; 
  pfnSquarint SquarintFunc;
  pfnAdddbl AdddblFunc; 
  pfnSubdbl SubdblFunc; 
  pfnMultdbl MultdblFunc;
  pfnDivdbl DivdblFunc; 
  pfnSquardbl SquardblFunc; 
  
#if defined(__LCC64__)	
  HANDLE dllHandle = LoadLibrary("dll_core64.dll");
#else
  HANDLE dllHandle = LoadLibrary("dll_core.dll");	
#endif
 
  if (dllHandle == INVALID_HANDLE_VALUE) { 
#if defined(__LCC64__)	
     printf("Impossible to load the dll : dll_core64.dll\n");
#else
     printf("Impossible to load the dll : dll_core.dll\n");
#endif
     exit(0);
  }
  HelloFunc = (pfnHello)GetProcAddress(dllHandle,"Hello");
  if (HelloFunc == NULL) {
     printf("Impossible to find the procedure Hello\n");
     exit(1);
  }
  else HelloFunc();
  
  printf("----------------------       Lancement des operations arithmetiques avec des entiers        -----------------------\n");	  
  AddintFunc = (pfnAddint)GetProcAddress(dllHandle,"Addint");
  if (AddintFunc == NULL) {
      printf("Impossible to find the procedure Addint\n");
      exit(1);
  }
  else {
	  result = AddintFunc(a,b);
	  printf("La somme de %i plus %i vaut %i.\t\t (from application with explicit load of DLL %s)\n", a,b,result,argv[0]);
  }
 
  SubintFunc = (pfnSubint)GetProcAddress(dllHandle,"Subint");
  if (SubintFunc == NULL) {
      printf("Impossible to find the procedure Subint\n");
      exit(1);
  }
  else {
	  result = SubintFunc(a,b);
	  printf("La soustraction de %i moins %i vaut %i.   (from application with explicit load of DLL %s)\n", a,b,result,argv[0]);
  } 
 
  MultintFunc = (pfnMultint)GetProcAddress(dllHandle,"Multint");
  if (MultintFunc == NULL) {
      printf("Impossible to find the procedure Multint\n");
      exit(1);
  }
  else {
	  result = MultintFunc(a,b);
	  printf("La multiplication de %i par %i vaut %i.  (from application with explicit load of DLL %s)\n", a,b,result,argv[0]);
  } 
  
  DivintFunc = (pfnDivint)GetProcAddress(dllHandle,"Divint");
  if (DivintFunc == NULL) {
      printf("Impossible to find the procedure Divint\n");
      exit(1);
  }
  else {
	  result = DivintFunc(a,b);
	  printf("La division de %i par %i vaut %i.\t         (from application with explicit load of DLL %s)\n", a,b,result,argv[0]);
  } 
 
  SquarintFunc = (pfnSquarint)GetProcAddress(dllHandle,"Squarint");
  if (SquarintFunc == NULL) {
      printf("Impossible to find the procedure Squarint\n");
      exit(1);
  }
  else {
	  result = SquarintFunc(b);
	  printf("Le carre de %i par %i vaut %i. \t\t (from application with explicit load of DLL %s)\n", b,b,result,argv[0]);
  } 
  
  printf("----------------------   Lancement des operations arithmetiques avec des doubles flottants   -----------------------\n");	 
  AdddblFunc = (pfnAdddbl)GetProcAddress(dllHandle,"Adddbl");
  if (AdddblFunc == NULL) {
      printf("Impossible to find the procedure Adddbl\n");
      exit(1);
  }
  else {
	  result1 = AdddblFunc(a1,b1);
	  printf("La somme de %.1f plus %.1f vaut %.2f.\t       (from application with explicit load of DLL %s)\n", a1,b1,result1,argv[0]);
  }
 
  SubdblFunc = (pfnSubdbl)GetProcAddress(dllHandle,"Subdbl");
  if (SubdblFunc == NULL) {
      printf("Impossible to find the procedure Subdbl\n");
      exit(1);
  }
  else {
	  result1 = SubdblFunc(a1,b1);
	  printf("La soustraction de %.1f moins %.1f vaut %.2f.   (from application with explicit load of DLL %s)\n", a1,b1,result1,argv[0]);
  } 
 
  MultdblFunc = (pfnMultdbl)GetProcAddress(dllHandle,"Multdbl");
  if (MultdblFunc == NULL) {
      printf("Impossible to find the procedure Multdbl\n");
      exit(1);
  }
  else {
	  result1 = MultdblFunc(a1,b1);
	  printf("La multiplication de %.1f par %.1f vaut %.2f. (from application with explicit load of DLL %s)\n", a1,b1,result1,argv[0]);
  } 
 
  DivdblFunc = (pfnDivdbl)GetProcAddress(dllHandle,"Divdbl");
  if (DivdblFunc == NULL) {
      printf("Impossible to find the procedure Divdbl\n");
      exit(1);
  }
  else {
	  result1 = DivdblFunc(a1,b1);
	  printf("La division de %.1f par %.1f vaut %.5f.         (from application with explicit load of DLL %s)\n", a1,b1,result1,argv[0]);
  } 
  
  SquardblFunc = (pfnSquardbl)GetProcAddress(dllHandle,"Squardbl");
  if (SquardblFunc == NULL) {
      printf("Impossible to find the procedure Squardbl\n");
      exit(1);
  }
  else {
	  result1 = SquardblFunc(b1);
	  printf("Le carre de %.1f par %.1f vaut %.2f.\t       (from application with explicit load of DLL %s)\n", b1,b1,result1,argv[0]);
  }
  
  return 0;
}
//******************************    End file : testdll_explicit.c   *********************************
