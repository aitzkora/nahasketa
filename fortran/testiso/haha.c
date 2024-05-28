#include <stdlib.h>
void f(int ** x, int n)
{
  *x = malloc(n*sizeof(int));
  {
  int * w = *x;
   for (int i =0; i < n ; i ++)
   {
     w[i] = 2*i + 1;
   }
  }
}
