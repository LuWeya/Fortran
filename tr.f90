program main
include 'mpif.h'
!use mpi
character* (MPI_MAX_PROCESSOR_NAME)processor_name
integer myid, numprocs, namelen, rc, ierr
integer data1, data2,count_send,count_recv,tag,iSTATUS(100)
integer n
	call MPI_INIT(ierr)  
	call MPI_COMM_RANK(MPI_COMM_WORLD,myid,ierr)  
	call MPI_COMM_SIZE(MPI_COMM_WORLD,numprocs,ierr)
	call MPI_GET_PROCESSOR_NAME(processor_name,namelen,ierr)
!wrte(*,10) myid,numprocs,processor_name
!10 FORMAT('Hello,World!Process',I2,' of ',I1,' on ',10A)
!------------------------------------------
data1=2
data2=0
count_send=1
count_recfv=1
tag=22
write(*,*) myid, numprocs, processor_name
if (myid==0) then
	if (numprocs>1)then
		do n=1,numprocs-1
			call MPI_SEND(data1,count_send,MPI_INTEGER,n,tag,MPI_COMM_WORLD,ierr)
			write(*,*) myid, '1111111111', data1
		end do
	endif
elseif(myid<numprocs) then
	call MPI_RECV(data2,1,MPI_INTEGER,0,tag,MPI_COMM_WORLD,iSTATUS,ierr)
	write(*,*) myid,'iiiiiiiiiii',data2
endif
!--------------------------------------------------
call MPI_FINALIZE()
end

