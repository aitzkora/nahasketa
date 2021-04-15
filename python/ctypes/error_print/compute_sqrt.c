#include <math.h>

extern void errorPrint(const char * str);

double compute_sqrt(double x)
{
  if (x < 0) {
     errorPrint("Caramba");
  }
  return x;
}
