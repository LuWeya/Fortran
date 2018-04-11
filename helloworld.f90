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
!----------------------正文部分--------------------


!--------------------------------------------------
call MPI_FINALIZE()
end

