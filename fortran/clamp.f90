program tst_clamp 
  implicit none

  print *, clamp(-1., 2., 3.)
  print *, clamp(-1., 2., 1.)
  print *, clamp(-1., 2., -4.)

contains

  pure real(4) function clamp(mi,ma,v) result(res)
    real(4), intent(in) :: mi, ma, v
    if (v < mi) then
      res = mi
    elseif (v > ma) then
      res = ma
    else
      res = v 
    end if
  end function clamp

end program tst_clamp
