module find_cell
  use iso_fortran_env
  implicit none
  integer, parameter :: fp = kind(1.d0)
  private
  public:: find_triangle_classic, fp, find_triangle_walk

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
    real   (kind=8)         :: xmin, xmax, zmin,zmax
    integer :: i_cell, nb_edge, k, node
    nb_edge = 3
    cell = 0
    xmin=dble(minval(x_node(1,:)))
    xmax=dble(maxval(x_node(1,:)))
    zmin=dble(minval(x_node(2,:)))
    zmax=dble(maxval(x_node(2,:)))
    !! if not we leave 
    if(coo(1) < xmin .or. coo(1) > xmax .or. &
       coo(2) < zmin .or. coo(2) > zmax) then
       print *, "hors bornes"
       return
    end if
    !! otherwize we look for the cell.

!! loop over all cell using OMP 
    !$OMP PARALLEL DEFAULT(shared) PRIVATE(i_cell,k,node,xtri,flag_in)
    allocate(flag_in   (nb_edge))
    allocate(xtri    (2,nb_edge))
    !$OMP DO
    do i_cell=1,nb_cell  
      if(cell .ne. 0) cycle !! for omp
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
      end if
    end do
    !$OMP END DO
    deallocate(flag_in)
    deallocate(xtri)
    !$OMP END PARALLEL

  end subroutine find_triangle_classic


  subroutine compute_barycenters(coo, xtri, theta)
    real(fp), intent(in) :: coo(2)
    real(fp), intent(in) :: xtri(2,3)
    real(fp), intent(out) :: theta(3)
    real(fp) :: denom, a, b, c, d, rhs(2)

    a = xtri(1,1) - xtri(1,3) 
    b = xtri(1,2) - xtri(1,3) 
    c = xtri(2,1) - xtri(2,3) 
    d = xtri(2,2) - xtri(2,3) 

    denom = a * d - b * c

    if (abs(denom) < 1e-10 * sqrt(sum(xtri**2))) then
       print *, "pb in compute_barycenters"
       stop -1
    endif

    rhs = coo(1) - xtri(:, 3)

    theta(1) = (rhs(1) * d - rhs(2) * b) / denom
    theta(2) = (rhs(2) * a - rhs(1) * c) /denom
    theta(3) = 1.d0 - theta(1) - theta(2)

  end subroutine compute_barycenters

  !> subroutine to locate a triangle in a triangular mesh using coordinates
  !> taken from article "Efficient implementation of characteristic-based schemes 
  !> on unstructured triangular grids" by S. Cacace and R. Ferretti
  !> @note : compared to the brute force algorithm we need the neigbor array
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
        chg = maxloc(abs(theta), 1, theta <= 0 .and. neighbors(:, cell) /= -1)
        if (chg /= 0) then
           cell = neighbors(chg, cell)
        else    
           write (error_unit, *) "walk blocked on the boundary"
           cell = 0
           exit
        end if
      end if
    end do

  end subroutine find_triangle_walk

end  module find_cell

program test_find_cell
    use find_cell
    implicit none
    integer :: sx, nb_cells, nb_nodes, nb_neighbors, nb_finds, i
    real(fp), allocatable :: x_node(:,:)
    integer, allocatable:: cell_node(:,:), neighbors(:,:), res_clas(:), res_walk(:)
    real(fp), allocatable ::  x_min(:), x_max(:), coo(:,:), alea(:,:)
    real :: start_time, stop_time
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

    x_min = [0.,0.]
    x_max = x_min
    x_min = minval(x_node, dim=2)
    x_max = maxval(x_node, dim=2)

    nb_finds = 30
    alea = reshape(spread(0.d0, 1, nb_finds*2), [2, nb_finds])
    call random_number(alea)
    !coo(1,:) = coo(1,:) * (x_max(1)-x_min(1)) + x_min(1)
    !coo(2,:) = coo(2,:) * (x_max(2)-x_min(2)) + x_min(2)
    allocate(coo(2, nb_finds))

    coo(1,:) = alea(2,:) * cos(4.d0*atan(1.d0) * alea(1,:))
    coo(2,:) = alea(2,:) * sin(4.d0*atan(1.d0) * alea(1,:))

    call cpu_time(start_time)
        
    res_clas = spread(0, 1, nb_finds)
    do i=1,nb_finds
      call find_triangle_classic(coo(:,i), res_clas(i), x_node, cell_node, nb_cells)
    end do
    call cpu_time(stop_time)
    print *, "tps cpu classique", stop_time-start_time

    call cpu_time(start_time)
    res_walk = spread(0, 1, nb_finds)
    do i=1,nb_finds
      call find_triangle_walk(coo(:,i), res_walk(i), x_node, cell_node, neighbors, nb_cells)
    end do
    call cpu_time(stop_time)
    print *, "tps cpu barycentric", stop_time-start_time
   
    CHECK: if (all(res_walk == res_clas)) then
      print *, "**************** SUCCESS *************************"
    else
      print *, "XXXXXXXXXXXXXXXX ERROR XXXXXXXXXXXXXXXXXXXXXXXXXXX"
      print *, sum(pack(spread(1,1,nb_finds), (res_walk /= res_clas))), " distinct results" 
    end if CHECK

end program test_find_cell


