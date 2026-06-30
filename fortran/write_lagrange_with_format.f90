module test_lagrange_basis
  use m_basis_functions,        only: basis_construct, &
                                      t_basis
  use m_set_critic,             only: set_critic
  use m_raise_error,            only: t_error
  use m_define_precision,       only: dp, i4
  use m_polynomial,             only: t_polynomial_precomput
  implicit none
  ! MAX_ORDER for polynomes
  integer(i4), parameter :: MAX_ORDER=10

contains

  subroutine test_lagrange_1d
    type(t_error) :: ctx_err
    type(t_basis) :: bases(MAX_ORDER)
    integer(i4)   :: i, k
    open(22, file='basis_check_1d.f90')
    do i=1,MAX_ORDER
      call basis_construct(1, i, bases(i), ctx_err)
      do k=1,i+1
        write (22, '(a,i0,a,i0,a)') "base_check(", i,")(",k,")=[&" 
        write (22, '(es24.17,:,",",es24.17,",&")', advance="no") bases(i)%pol(k)%coeff_pol
        write (22, '(a)') ']'
      end do
    end do
    close(22)

  end subroutine test_lagrange_1d

end module test_lagrange_basis
