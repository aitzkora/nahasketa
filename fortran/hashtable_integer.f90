module hashtable
  use iso_fortran_env
  implicit none
  integer, parameter :: debug = 1
  integer, parameter :: HASH_PRIME = 37

  type :: hash_int
    integer :: mask
    integer :: fill
    integer, allocatable :: tab(:)
  contains 
    procedure, pass(hash) :: print =>  hash_print
    procedure, pass(hash) :: resize => hash_resize
    procedure, pass(hash) :: insert => hash_insert
    procedure, pass(hash) :: has_key
  end type hash_int

  interface hash_int
    module procedure :: hash_create
  end interface hash_int

contains 

  type(hash_int) function hash_create(size) result(this)
    integer, optional, intent(in):: size
    integer :: new_size
    if (present(size)) then 
      new_size = size
    else
      new_size = 4
    end if
    allocate(this%tab(new_size))
    this%tab = -1
    this%mask = new_size - 1
    this%fill = 0 
  end function hash_create

  subroutine hash_print(hash)
    class(hash_int), intent(in) :: hash
    integer :: i
    write (output_unit, "(a)", advance="no") "["
    do i=1, size(hash%tab)
      if (hash%tab(i) /= -1) then
        write (output_unit,'(i0,1x)', advance="no") hash%tab(i)
      end if
    end do
    write(output_unit, "(a)") "]"
  end subroutine hash_print

  subroutine hash_resize(hash, ierr)
    class(hash_int), intent(inout) :: hash
    integer, intent(out) :: ierr
    integer, allocatable :: new_tab(:)
    integer :: io
    integer :: new_mask, new_size, hash_num
    new_size = ishft(size(hash%tab), 1)
    new_mask = new_size - 1
    allocate(new_tab(new_size), stat=ierr)
    if (ierr > 0) return
    new_tab = -1
    do io=1, size(hash%tab)
      if (hash%tab(io) == -1) cycle 
      hash_num = iand( hash%tab(io) * HASH_PRIME, new_mask)
      HASH_COMPUTE: do
        if (new_tab(hash_num) /= -1) exit ! new slot is not empty
        hash_num = iand( hash_num + 1, new_mask)
      end do HASH_COMPUTE
      new_tab(hash_num) = hash%tab(hash_num)
    end do
    call move_alloc(from=new_tab, to=hash%tab)
    hash%mask = new_mask
  end subroutine hash_resize


  logical function has_key(hash, key)
    class(hash_int), intent(in) :: hash  
    integer, intent(in) :: key
    integer :: hash_num, val
    has_key = .false.
    hash_num = iand(key * HASH_PRIME, hash%mask)
    has_key = .false.
    do
      val = hash%tab(hash_num)
      if (val == -1) then
         return
      end if
      if (val == key) then
         has_key = .true.
         return
      end if
      hash_num = iand(hash_num + 1, hash%mask)
    end do
    has_key =  val == key 
  end function has_key  

  subroutine hash_insert(hash, key, ierr)
    class(hash_int), intent(inout) :: hash  
    integer, intent(in) :: key
    integer, intent(out) :: ierr
    integer :: hash_num, val
    hash_num = iand(key * HASH_PRIME, hash%mask)
    ierr = 0
    FIND_SLOT : do 
      val = hash%tab(hash_num)
      if (val /= -1) then
        if (val == key) exit ! -> the key exist
      else ! insert in that position
        hash%tab(hash_num) = key
        hash%fill = hash%fill + 1
        if (hash%fill > int(0.75 * size(hash%tab))) then
          call hash%resize(ierr)
          if (ierr > 0) return
        end if 
        exit
      end if
      hash_num = iand(hash_num+1, hash%mask)
    end do FIND_SLOT
  end subroutine hash_insert

end module hashtable

program test_hash
  use hashtable
  implicit none
  integer, allocatable :: numbers(:), tests(:)
  type(hash_int) :: hm
  integer :: i, ierr

  numbers = [1, 37, 2, 3, 37, 12 , 124, 32, 18, 12, 5]
  tests = [37, 5, 29]
 
  hm = hash_int(16)

  do i =1, size(numbers)
    call hm%insert(numbers(i), ierr)
    if (ierr /=0) then
      print *, "cannot insert ", numbers(i)
    end if
  end do

  call hm%print()

  do i =1, size(tests)
    if (hm%has_key(tests(i))) then
      print *,  tests(i), "is in "
    else
      print *,  tests(i), "is not in "
    end if
  end do

end program test_hash
