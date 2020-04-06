module dummy
    public :: retrieve_ints
contains
    function retrieve_ints(filename) result(res)
   
     character(255) :: filename

     !integer :: unit
     integer, allocatable :: res(:)
     integer :: buffer(256) = 0

     namelist /alire/buffer
     open(file=filename,unit=12)

     read(12, nml=alire)

     close(unit=12)
     res = pack(buffer, buffer /= 0)

    end function retrieve_ints
end module dummy
program test_namelist
    use iso_fortran_env
    use dummy

    implicit none

    character(266) :: filename
    integer, allocatable :: x(:)
  
   call get_command_argument(1, filename)

   x = retrieve_ints(filename)
    
   print *,x   
end program test_namelist
