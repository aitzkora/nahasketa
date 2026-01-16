module m_scalar
  type :: scalar
    real :: x
  contains
     procedure, pass(self) :: norm => norm_x
     procedure, pass(self) :: init => init_x
  end type scalar
  contains
     real function norm_x(self) result(res)
      class(scalar), intent(in) :: self
      res = self%x*self%x
    end function norm_x

    subroutine init_x(self) 
      class(scalar), intent(out) :: self
      call random_number(self%x)
    end subroutine init_x

end module m_scalar

module m_vector
  use m_scalar, scalar_mix => scalar, & 
                  norm_mix => norm_x, &
                  init_mix => init_x

  type, extends(scalar_mix) :: vector
     real :: y
     real :: z
  contains
     procedure, pass(self) :: norm => norm_vec
     procedure, pass(self) :: init => init_vec
  end type vector
  contains
     real function norm_vec(self) result(res)
      class(vector), intent(in) :: self 
      res = self%x * self%x + self%y*self%y + self%z * self%z
    end function norm_vec

    subroutine init_vec(self) 
      class(vector), intent(out) :: self
      call random_number(self%x)
      call random_number(self%y)
      call random_number(self%z)
    end subroutine init_vec

end module m_vector

module m_state
  !use m_scalar, state => scalar
  use m_vector, state => vector
end module m_state
   
program test
   use m_state
   implicit none
   integer :: i, m
   real :: s
   type(state), allocatable :: state_array(:) 
   m= 3
   allocate(state_array(m))
   do i =1, m 
     call state_array(i)%init()
   end do
   s = 0
   do i=1, m
     s =  s +  state_array(i)%norm()
   end do
   print *, s
end program test

