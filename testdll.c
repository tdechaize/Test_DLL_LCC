//*********************    File : testdll.c (main test of dll)    *****************
#include <windows.h>
#include <stdio.h>
#include "testdll.h"

int main(int argc, char** argv)
{
  int a = 42;
  int b = 7;
  int result=0;
  
  hello();
  result = add(a, b);
  printf("Le resultat de l'addition de %i plus %i vaut : %i\n", a, b, result);
  result = substract (a, b);
  printf("Le resultat de la soustraction de %i moins %i vaut : %i\n", a, b, result);
  result = multiply (a, b);
  printf("Le resultat de la multiplication de %i par %i vaut : %i\n", a, b, result);

}
//**************************    End file : testdll.c   *****************************
 