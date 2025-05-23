program test_isnan
  use ieee_arithmetic
  logical  :: erreur
  real :: x 
  x = 1 / 0.0000000000000000000000000000000000000000001 
  erreur = ieee_is_nan(x)
  print *, erreur
end program test_isnan
