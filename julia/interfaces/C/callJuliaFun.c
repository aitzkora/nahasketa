#include <inttypes.h>

double apply_f(double (*fun)(double), int64_t x_n , double *x, double * y)
{
  int64_t i;
  for(i = 0; i < x_n; ++i)
      i[y] = (*fun)(i[x]);
}
