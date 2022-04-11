// gcc -I~/configs/scotch6.1.1/include -L~/configs/scotch6.1.1/lib -lscotch get_size.c
#include <stdio.h>
#include <inttypes.h>
#include "scotch.h"

int main()
{
  printf("intsize = %d\n", SCOTCH_numSizeof());
  return 0;
}
