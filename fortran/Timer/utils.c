#include <sys/types.h>
#include <unistd.h>
#include <sys/time.h>

double clockget () {
  struct timeval tv2;
  double dt;
  gettimeofday(&tv2, (struct timezone*)0);
  dt = ((tv2).tv_sec  + 0.000001*(tv2).tv_usec);
  return (dt);
}
