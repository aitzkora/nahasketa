MODULE test
   TYPE T_TYPE1
      INTEGER :: a = 1111
   CONTAINS
      FINAL :: DESTROY_TYPE1
   END TYPE T_TYPE1

   INTERFACE t_type1
      MODULE PROCEDURE NEW_TYPE1
   END INTERFACE t_type1

CONTAINS

   FUNCTION NEW_TYPE1(a) RESULT(self)
      IMPLICIT NONE
      INTEGER :: a
      TYPE(T_TYPE1) :: self
      self%a = a
      WRITE(*,'(A,I0)') "Constructing type1: ", self%a
   END FUNCTION NEW_TYPE1

   SUBROUTINE DESTROY_TYPE1(self)
      TYPE(t_type1) :: self
      WRITE(*,'(A,I0)') "Finalizing type1: ", self%a
   END SUBROUTINE DESTROY_TYPE1


END MODULE test

PROGRAM testprog
  USE test
  INTEGER :: i
  TYPE(t_type1), ALLOCATABLE :: type1

  ALLOCATE(type1)
  WRITE(*,'(A,I0)') "Content (plain allocation): ", type1%a
  type1 = T_TYPE1(2)
  WRITE(*,'(A,I0)') "Content (explicit construction): ", type1%a
  DEALLOCATE(type1)

END PROGRAM testprog
