#include <stdio.h>
#include <math.h>
#include <assert.h>

extern void compute_U(const double m, const double n, const double z_x, const double z_y, double * res_x, double *res_y);

int main()
{
  double prec = 1e-12;
  double res_x_check, res_y_check;
  double res_x, res_y;
  /* first test : real case */
  res_x_check = 0.416940305395154; // taken from sage hypergeometric_U(12,20,3.) 
  compute_U(12, 20, 3., 0., &res_x, &res_y);
  printf("%e\n",fabs(res_x-res_x_check));
  assert(fabs(res_x-res_x_check) < prec);
  /* second case : complex case */
  res_x_check = -0.00646612339420241; 
  res_y_check  = 0.0112751987320501;
  compute_U(12, 20, 3., 2., &res_x, &res_y); //taken from hypergeometric_U(12, 20, 3.+2.*I)
  printf("%e\n",hypot(res_x-res_x_check, res_y-res_y_check));
  assert(hypot(res_x-res_x_check, res_y-res_y_check) < prec);
  return 0;
}
