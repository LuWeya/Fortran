program main
include 'mpif.h'
character* (MPI_MAX_PROCESSOR_NAME)processor_name
integer myid, numprocs, namelen, rc, ierr
integer data1, data2,count_send,count_recv,tag,iSTATUS(MPI_STATUS_SIZE)
	call MPI_INIT(ierr)  
	call MPI_COMM_RANK(MPI_COMM_WORLD,myid,ierr)  
	call MPI_COMM_SIZE(MPI_COMM_WORLD,numprocs,ierr)
	call MPI_GET_PROCESSOR_NAME(processor_name,namelen,ierr)
!------------------正文部分------------------------
data1=2
data2=0
count_send=1
count_recfv=1
tag=99
write(*,'(i3,a3,i3,a4,a10)') myid,'of', numprocs,'on ', processor_name
if (myid==0) then
	if (numprocs>1)then
		call MPI_SEND(data1,count_send,MPI_INTEGER,myid+1,tag,MPI_COMM_WORLD,ierr)
		write(*,*) myid, 'send', data1,'to',myid+1
	else 
		call MPI_ABORT(MPI_COMM_WORLD,1,ierr)
	endif
elseif(myid<numprocs) then
	call MPI_RECV(data2,count_recv,MPI_INTEGER,myid-1,tag,MPI_COMM_WORLD,iSTATUS,ierr)
	write(*,*) myid,'receive',data2,'from',myid-1
	if(myid/=numprocs-1)then 
		data2=data2+1
		call MPI_SEND(data2,count_send,MPI_INTEGER,myid+1,tag,MPI_COMM_WORLD,ierr)
		write(*,*) myid, 'send', data2,'to',myid+1
	end if
endif
!--------------------------------------------------
call MPI_FINALIZE()
end

