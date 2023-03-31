module find_cell
  implicit none
  integer, parameter :: fp = kind(1.d0)
  private
  public:: find_cell_classic, fp

contains

   subroutine on_side_2d(test1,test2,ref1,ref2,flag)
    real   (kind=8),  intent(in)    :: test1(2)
    real   (kind=8),  intent(in)    :: test2(2)
    real   (kind=8),  intent(in)    :: ref1 (2)
    real   (kind=8),  intent(in)    :: ref2 (2)
    logical        ,  intent(out)   :: flag
    !! local
    real   (kind=8) :: vector_1(2)
    real   (kind=8) :: vector_2(2)
    real   (kind=8) :: vector_3(2)
    real   (kind=8) :: testval
    
    vector_1 = ref2  - ref1
    vector_2 = test1 - ref1
    vector_3 = test2 - ref1
    !! compute produc
    testval=(dble(vector_1(1)*vector_2(2)) - dble(vector_1(2)*vector_2(1))) * &
            (dble(vector_1(1)*vector_3(2)) - dble(vector_1(2)*vector_3(1)))
    if(testval .ge. 0.) then
      flag=.true.
    else
      flag=.false.
    end if
    
    return
    
  end subroutine on_side_2d


  subroutine find_cell_classic(coo,cell,x_node, cell_node,nb_cell)
    real(fp), intent(in) :: coo(2)
    integer, intent(out) :: cell
    real(fp), intent(in) :: x_node(:,:)
    integer, intent(in) :: cell_node(:,:)
    integer, intent(in) :: nb_cell
    logical                 ,allocatable :: flag_in (:)
    real   (kind=8)         ,allocatable :: xtri    (:,:)
    integer :: i_cell, nb_edge, k, node
    nb_edge = 2
    cell = 0
    allocate(flag_in(nb_edge))
    allocate(xtri(2, nb_edge))
    !xtri = spread([0.d0, 0.d0], 1 , nb_edge)
    do i_cell=1,nb_cell  
      print *, "i_cell =", i_cell
      !if(cell .ne. 0) cycle !! for omp
      !! get coordinates of the nodes of the cell
      do k=1,nb_edge
        node      =  cell_node(k,i_cell)
        xtri(:,k) = dble(x_node(:,node))
      end do

      !! It is in the cell if coo_input and node(k) are on the same side
      !! of the line node(i)--node(j) for all k where i != j != k
      !! ---------------------------------------------------------------
      flag_in(:) = .false.
      call on_side_2d(coo,xtri(:,1),xtri(:,2),xtri(:,3),flag_in(1))
      call on_side_2d(coo,xtri(:,2),xtri(:,1),xtri(:,3),flag_in(2))
      call on_side_2d(coo,xtri(:,3),xtri(:,1),xtri(:,2),flag_in(3))
      if(flag_in(1) .and. flag_in(2) .and. flag_in(3)) then
        cell = i_cell
        exit
      end if
    end do
    deallocate(flag_in)
    deallocate(xtri)

    return

  end subroutine find_cell_classic

end module find_cell

program test_find_cell
    use find_cell
    implicit none
    integer :: sx, sy, cell, nb_cell
    real(fp), allocatable :: x_node(:,:)
    integer, allocatable:: cell_node(:,:)
    real(fp), allocatable :: coo(:)
    
    ! read nodes
    open(22, file='x_node.txt')
    read(22,*) sx, sy
    allocate(x_node(sx,sy))
    read(22,*) x_node
    close(22)
    !print *, sx, sy
    ! read cells
    open(22, file='cell_node.txt')
    read(22,*) sx, sy
    allocate(cell_node(sx,sy))
    read(22,*) cell_node
    close(22)
    !print *, sx, sy

    coo = [0.d0, 0.d0]
    nb_cell = 8202 
    call find_cell_classic(coo, cell, x_node, cell_node, nb_cell)
    print *, 'cell containing (', coo, ') : ', cell

end program test_find_cell


