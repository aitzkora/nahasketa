module person
   type :: individual
      character(len=20):: name = ''
      integer:: age
   contains
      procedure, pass(self) :: salut
   end type individual
contains
   impure elemental subroutine salut(self)
   class(individual), intent(in) :: self
    print '(2ai0a)', trim(self % name) , " has ", self % age, " years"
end subroutine salut
end module person

program test_person
   use person
   type(individual), allocatable :: a(:)
   a = [(individual(char(48+i),i),i=1,10)]
   call a % salut()
end program test_person
