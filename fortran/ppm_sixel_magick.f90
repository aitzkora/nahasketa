program ppm_sixel
  integer, parameter :: nx = 400, ny = 200
  integer :: i, j
  type :: rgb
    real :: v(3)
  end type
  type(rgb) :: fb(nx, ny)
  do j=1, ny
    do i=1, nx
      fb(i, j)%v(1) = real(i) / nx
      fb(i, j)%v(2) = real(j) / ny
      fb(i, j)%v(3) = 0.2
    end do 
  end do
  call display(fb)
contains

     subroutine write_rgb_file(rgb_array, filename)
       type(rgb), intent(in) :: rgb_array(:,:)
       character(*), intent(in) :: filename
       integer :: i, j
       open(unit=22, file=filename, action='write')
       write(22,'(a2)') 'P3'
       write(22,'(i0,1x,i0)') size(rgb_array, 1), size(rgb_array, 2)
       write(22,'(i0)') 255
       do j=size(rgb_array, 2), 1, -1  
         do i=1, size(rgb_array, 1)
           write(22, '(3(1x,i3))') int(255*rgb_array(i,j)%v)
         end do 
       end do
       close(22)
     end subroutine write_rgb_file

     subroutine display(rgb_array, geom_arg) 
       type(rgb), intent(in) :: rgb_array(:,:)
       integer, optional :: geom_arg(2)
       integer :: geom(2)
       character(:), allocatable :: filename
       character(len=10) :: geom_str
       filename = "sortie.ppm"
       if (present(geom_arg)) then
         geom = geom_arg
       else
         geom = [640, 480]
       end if   
       write(geom_str,'(i0,a,i0)') geom(1), "x", geom(2)
       call write_rgb_file(rgb_array, filename)
       call execute_command_line("magick "// filename // " -geometry " // trim(geom_str) //  " sixel:-")
     end subroutine

end program ppm_sixel
