program main
use mpi 
implicit none

character* (MPI_MAX_PROCESSOR_NAME)processor_name
integer myid, numprocs, namelen, rc, ierr
!  totalsize 全局规模（行数x列数） step 迭代次数

integer totalsize,mysize,step
parameter (totalsize=16)
parameter (mysize=totalsize/4,step=10) !
real a(totalsize,mysize+2),b(totalsize,mysize+2)  
!a，b每个进程下 行数和全局相等，列数加2，
!  begin_col 起止列
integer begin_col,end_col
integer status(MPI_STATUS_SIZE)
integer i,j,n
	call MPI_INIT(ierr)  
	call MPI_COMM_RANK(MPI_COMM_WORLD,myid,ierr)  
	call MPI_COMM_SIZE(MPI_COMM_WORLD,numprocs,ierr)
	call MPI_GET_PROCESSOR_NAME(processor_name,namelen,ierr)
write(*,10) myid,numprocs,processor_name
10 FORMAT('Hello,World!Process',I2,' of ',I1,' on ',10A)
!------------------------------------------

do j=1,mysize+2
    do i=1,totalsize
        a(i,j)=0.0
    end do 
end do
if ( myid==0) then
    do i=1,totalsize
        a(i,2)=8.0
    end do
end if 
if ( myid==3 )then
    do i=1,totalsize
        a(i,mysize+1)=8.0
    end do
end if 
do j=1,mysize+2
    a(1,j)=8.0
    a(totalsize,j)=8.0
end do
! jocabi  
do n=1,step
    ! send to left
    
    if (myid.lt.3) then
        call MPI_RECV(a(1,mysize+2),totalsize,MPI_REAL,myid+1,99,MPI_COMM_WORLD,status,ierr)
    end if
    if (myid.gt.0) then
        call MPI_SEND(a(1,2),totalsize,MPI_REAL,myid-1,00,MPI_COMM_WORLD,ierr)
    end if
    !send to right
    if (myid.lt.3) then
        call MPI_send(a(1,mysize+1),totalsize,MPI_REAL,myid+1,98,MPI_COMM_WORLD,ierr)
    end if
    if (myid.gt.0) then
        call MPI_RECV(a(1,1),totalsize,MPI_REAL,myid-1,98,MPI_COMM_WORLD,status,ierr)
    end if
    begin_col=2
    end_col=mysize+1
    if (myid==0)then
        begin_col=3
    end if
    if (myid==numprocs-1)then
        end_col=mysize
    end if
    ! 略过四周的边
    do j=begin_col,end_col
        do i=2,totalsize-1
            b(i,j)=(a(i,j+1)+a(i,j-1)+a(i+1,j)+a(i-1,j))*0.25
        end do
    end do
    do j=begin_col,end_col
        do i=2,totalsize-1
            
            a(i,j)=b(i,j)
        end do
    end do
end do

do i=2,totalsize-1
    print *, myid,(a(i,j),j=begin_col,end_col)
end do



!--------------------------------------------------
call MPI_FINALIZE(rc)
end
