#include <inttypes.h>
double mysum(int64_t m, int64_t n, double *x)
{
   double s = 0.;
   int i,j;
   for(i = 0; i < m; ++i)
       for(j = 0; j < n; ++j)
            s += x[i * n + j];
   return s;
}
