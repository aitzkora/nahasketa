module fred
    implicit none
    contains
    subroutine blogs(istat)
        integer, intent(out) :: istat
        istat = 42
    end subroutine blogs
end module fred

program main
    !use fred, only: blogs
    implicit none(type, external)
    integer         :: istat
    call blogs( istat )
    print *, istat
end
