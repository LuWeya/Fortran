program main
include 'mpif.h'
character* (MPI_MAX_PROCESSOR_NAME)processor_name
integer myid, numprocs, namelen, rc, ierr
	call MPI_INIT(ierr)  
	call MPI_COMM_RANK(MPI_COMM_WORLD,myid,ierr)  
	call MPI_COMM_SIZE(MPI_COMM_WORLD,numprocs,ierr)
	call MPI_GET_PROCESSOR_NAME(processor_name,namelen,ierr)
write(*,10) myid,numprocs,processor_name
10 FORMAT('Hello,World!Process',I2,' of ',I1,' on ',10A)
call MPI_Barrier(MPI_COMM_WORLD,ierr)
!--------------------------------------------------
! judge if number of processors is less than 2
if(numprocs<2) then
    write(*,*)'The number of processor is less than 2.'
    call MPI_Abort(MPI_COMM_WORLD,1,ierr)
endif

call hello()

!--------------------------------------------------
call MPI_FINALIZE()
end

! send hello to everyone and receive hello from everyone.
subroutine hello()
implicit none
integer:: rank, nproc,ierr,node,count_send,tag,data1,data2
integer::iSTATUS(MPI_STATUS_SIZE)
call MPI_COMM_RANK(MPI_COMM_WORLD,rank,ierr)
call MPI_COMM_SIZE(MPI_COMM_WORLD,nproc,ierr)
count_send=1  ! the number of data you send
tag=99        ! tag
data1=1
data2=0
if(rank==0) then
    write(*,*)'Hello test from all to all.'
end if 
do node=0,nproc-1   ! send to each one (except itself)
    if(node/=rank) then
        call MPI_SEND(data1,count_send,MPI_INTEGER,node,tag,MPI_COMM_WORLD,ierr)
        call MPI_SEND(data2,count_send,MPI_INTEGER,node,tag,MPI_COMM_WORLD,iSTATUS,ierr)
        write(*,*) rank,' receive hellon form',node
    end if
end do 
end subroutine hello