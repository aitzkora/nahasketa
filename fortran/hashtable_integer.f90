module hashtable
  implicit none

  integer, parameter :: hash_prime = 37

  type :: hash_int
   integer :: size
   integer :: mask
   integer :: fill
   integer, allocatable :: tab(:)

  end type hash_int
contains 
  subroutine hash_print(hash)
    type(hash_int), intent(in) :: hash
    print *, "["
    do i=1, hash % size
      if (hash % tab /= -1) then
        print '(i0,1x)', hash % tab(i)
      else
        exit 
    end do
    print *, "]"
  end subroutine hash_print

  subroutine hash_create(hash, size)
    type(hash_int), intent(inout) :: hash
    integer, optional, intent(in):: size
    if (present(size)) then 
      hash%size = size
    else
      hash%size = 4
    end if
    allocate(hash(hash % size))
    hash%tab = -1
    hash%mask = size - 1
    hash%fill = 0 

  end subroutine hash_create

  subroutine hash_resize(hash)
    type(hash_int), intent(inout) :: hash
    integer, allocatable :: new_tab(:)
    integer :: io, i
    integer :: new_mask, new_hash, new_size
    integer :: old_idx, new_idx
    new_size = ishift(size, 1)
    new_mask = new_size - 1
    allocate(new_tab(new_size))
    new_tab = -1
    do io=1, hash%size
      if (hash%tab[io] == -1) cycle
      hash_num = iand( hashtab[io] * hash_prime, new_mask)
      HASH_COMPUTE: do
        if (new_tab[hash_num] /= -1) exit
        hash_num = iand( hash_num + 1, new_mask)
      end do HASH_COMPUTE
    end do
    move_alloc(new_tab, hash%tab)
    hash%size = new_size
    hash%mask = new_mask
  end subroutine hash_resize


end module hashtable

