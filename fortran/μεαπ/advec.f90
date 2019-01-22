program advec
   use iso_fortran_env, only: int32, real32, output_unit
   implicit none
   integer(int32), parameter :: x_s = 12 ! size of space grid
   integer(int32), parameter :: t_s = 100 ! number of time steps
   real(real32), parameter :: dt = 0.1 ! time step [s] 
   real(real32), parameter :: dx = 0.1! grid spacing [m]
   real(real32), parameter :: c = 1! speed [m/s]
   real(real32), parameter :: decay = 0.02
   integer(real32), parameter :: ipos = 25
   integer(int32) :: i, j
   real(real32) :: u(x_s) ! solution
   real(real32) :: du(x_s-1) ! derivative of solution

   ! initialisation
   do concurrent (i=1:x_s)
      u(i) = exp( -decay * (i - ipos)**2 )
   end do

   time_loop : do i = 1, t_s

      du(1) = u(1) - u(x_s)

      grad : do concurrent(j = 2:x_s)
          du(j) = u(j) - u(j-1)
      end do grad

      advect : do concurrent(j = 1:x_s)
          u(j) = u(j) - c * du(j) / dx * dt
      end do advect

      write(output_unit, *) i, u
   end do time_loop
end program advec
