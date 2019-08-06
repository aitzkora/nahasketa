#include "acb.h"
#include  "acb_hypgeom.h"
#include "arb.h"
#include "arf.h"
#include <math.h>
#include <assert.h>

void compute_U(const int m, const int n, const double z_x, const double z_y, double * res_x, double *res_y, slong prec)
{
    acb_t m_c, n_c, z, res;
    arb_t res_re, res_imag;
    arf_t tmp_x, tmp_y;

    /* initialisation */
    acb_init(m_c); 
    acb_init(n_c);
    acb_init(z);
    acb_init(res);
   
    arb_init(res_re);
    arb_init(res_imag);

    arf_init(tmp_x);
    arf_init(tmp_y);

    /* z <- z_x + i * z_y
     * m_c <- m + i * 0
     * n_c <- n + i * 0
     */
    acb_set_d_d(z, z_x, z_y);
    acb_set_d_d(m_c, (double) m, 0.);
    acb_set_d_d(n_c, (double) n, 0.);
    
    /* computes the U(m, n, z) function */
    acb_hypgeom_u(res, m_c, n_c, z, prec);

    /* retrieve real and imaginary parts of the result */
    acb_get_real(res_re, res);
    acb_get_imag(res_imag, res);

    /* pass from real balls to arbitrary-precision floating-point numbers */
    arb_get_ubound_arf(tmp_x, res_re, prec);
    arb_get_ubound_arf(tmp_y, res_imag, prec);

    /* rounding to double */
    *res_x = arf_get_d(tmp_x, ARF_RND_NEAR);
    *res_y = arf_get_d(tmp_y, ARF_RND_NEAR);

    /* cleaning */  
    acb_clear(m_c); 
    acb_clear(n_c);
    acb_clear(z);
    acb_clear(res);

    arb_clear(res_re); 
    arb_clear(res_imag);

    arf_clear(tmp_x);
    arf_clear(tmp_y);
    flint_cleanup();
}

int main()
{

  slong prec_arb = 256;
  double prec = 1e-12;
  double res_x_check, res_y_check;
  double res_x, res_y;
  /* first test : real case */
  res_x_check = 0.416940305395154; // taken from sage hypergeometric_U(12,20,3.) 
  compute_U(12, 20, 3., 0., &res_x, &res_y, prec_arb);
  printf("%e\n",fabs(res_x-res_x_check));
  assert(fabs(res_x-res_x_check) < prec);
  /* second case : complex case */
  res_x_check = -0.00646612339420241; 
  res_y_check  = 0.0112751987320501;
  compute_U(12, 20, 3., 2., &res_x, &res_y, prec_arb); //taken from hypergeometric_U(12, 20, 3.+2.*I)
  printf("%e\n",hypot(res_x-res_x_check, res_y-res_y_check));
  assert(hypot(res_x-res_x_check, res_y-res_y_check) < prec);
  return 0;
}
