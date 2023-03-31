module find_cell
  implicit none
  integer, parameter :: fp = kind(1.d0)
  private
  public:: find_triangle_classic, fp

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


  subroutine find_triangle_classic(coo,cell,x_node,cell_node,nb_cell)
    real(fp), intent(in) :: coo(2)
    integer, intent(out) :: cell
    real(fp), intent(in) :: x_node(:,:)
    integer, intent(in) :: cell_node(:,:)
    integer, intent(in) :: nb_cell
    logical                 ,allocatable :: flag_in (:)
    real   (kind=8)         ,allocatable :: xtri    (:,:)
    integer :: i_cell, nb_edge, k, node
    nb_edge = 3
    cell = 0
    allocate(flag_in(nb_edge))
    allocate(xtri(2, nb_edge))
    !xtri = spread([0.d0, 0.d0], 1 , nb_edge)
    do i_cell=1,nb_cell  
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
      if(all(flag_in)) then
        cell = i_cell
        exit
      end if
    end do
    deallocate(flag_in)
    deallocate(xtri)

    return

  end subroutine find_triangle_classic


  subroutine compute_barycenters(coo, xtri, theta)
    real(fp), intent(in) :: coo(2)
    real(fp), intent(in) :: xtri(2,3)
    real(fp), intent(out) :: theta(3)
    real(fp) :: denom, a, b, c, d

    a = xtri(1,2)-xtri(1,3) 
    b = xtri(2,3)-xtri(2,2) 
    denom = a * (xtri(1,1)-xtri(1,3)) + b * (xtri(2,1)-xtri(2,3))

    if (abs(denom) < 1e-10) then
       print *, "pb in compute_barycenters"
       stop -1
    endif

    c = coo(1) - xtri(1, 3)
    d = coo(2) - xtri(2, 3)

    theta(1) = (a * c + b *d) / denom
    theta(2) = ((xtri(2,3) - xtri(2,1)) * c + &
                (xtri(1,1) - xtri(1,3)) * d) / denom
    theta(3) = 1.d0 - theta(1) - theta(2)

  end subroutine compute_barycenters


  subroutine find_triangle_walk(coo, cell, x_node, cell_node, neighbors, nb_cell, cell_0)
    real(fp), intent(in) :: coo(2)
    integer, intent(out) :: cell
    real(fp), intent(in) :: x_node(:,:)
    integer, intent(in) :: cell_node(:,:)
    integer, intent(in) :: neighbors(:,:)
    integer, intent(in) :: nb_cell
    integer, optional :: cell_0
    logical :: find
    real(fp) :: theta(3)
    integer :: chg
    if (present(cell_0)) then 
      cell = cell_0
    else
      cell = 1
    end if

    find = .false.
    do 
      if (find) exit
      call compute_barycenters(coo, x_node(:,cell_node(:,cell)), theta)
      if (all(theta > 0)) then
        find = .true.
      else
        chg = maxloc(abs(theta), 1, theta <= 0)  
        
      end if
    end do

  end subroutine find_triangle_walk

end  module find_cell

program test_find_cell
    use find_cell
    implicit none
    integer :: sx, cell, nb_cells, nb_nodes, nb_neighbors
    real(fp), allocatable :: x_node(:,:)
    integer, allocatable:: cell_node(:,:), neighbors(:,:)
    real(fp), allocatable :: coo(:)
    
    ! read nodes
    open(22, file='x_node.txt')
    read(22,*) sx, nb_nodes
    allocate(x_node(sx,nb_nodes))
    read(22,*) x_node
    close(22)
    print "(a,i0)", "nb_nodes = ", nb_nodes

    ! read cells
    open(22, file='cell_node.txt')
    read(22,*) sx, nb_cells 
    allocate(cell_node(sx, nb_cells))
    read(22,*) cell_node
    close(22)
    print "(a,i0)", "nb_cells = ", nb_cells

   ! read neighbours
    open(22, file='neigh.txt')
    read(22,*) sx, nb_neighbors
    allocate(neighbors(sx, nb_neighbors))
    read(22,*) neighbors
    close(22)
    print "(a,i0)", "nb_neighbors = ", nb_neighbors

    coo = [0.d0, 0.d0]
    call find_triangle_classic(coo, cell, x_node, cell_node, nb_cells)
    print '(a,2(f6.3,1x),a,i0)', 'cell containing (', coo, ') -> ', cell
    
    call find_triangle_walk(coo, cell, x_node, cell_node, neighbors, nb_cells)
    print '(a,2(f6.3,1x),a,i0)', 'cell containing (', coo, ') -> ', cell

end program test_find_cell


