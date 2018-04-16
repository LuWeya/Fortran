program Hello_world
use mpi
implicit none
!include '/opt/software/mpich2-intel/include/mpif.h'
!include 'mpif.h'
character(LEN=MPI_MAX_PROCESSOR_NAME):: processor_name
integer:: myid, numprocs, namelen, rc, ierr,status(MPI_STATUS_SIZE),value

call MPI_INIT(ierr)
call MPI_COMM_RANK(MPI_COMM_WORLD,myid,ierr)
call MPI_COMM_SIZE(MPI_COMM_WORLD,numprocs,ierr)
call MPI_GET_PROCESSOR_NAME(processor_name,namelen,ierr)

! first to last
if (myid.eq.0)then
    print *,'Please give a new number:'
    read '(I4)',value
    call MPI_SEND(value,1,MPI_INTEGER,myid+1,99,MPI_COMM_WORLD,ierr)
else
    call MPI_RECV(value,1,MPI_INTEGER,myid-1,99,MPI_COMM_WORLD,status,ierr)
    print '(A10,1X,I4,1X,A20,1X,I4,1X,A10,1X,I4)','I am proc',myid,'I just received', value,'from proc',myid-1

    if (myid.lt.numprocs-1)then
        call MPI_SEND(value,1,MPI_INTEGER,myid+1,99,MPI_COMM_WORLD,ierr)
    endif
endif
call MPI_BARRIER(MPI_COMM_WORLD,ierr)

! last to first 
if (myid.eq.numprocs-1)then
    call MPI_SEND(value,1,MPI_INTEGER,myid-1,99,MPI_COMM_WORLD,ierr)
else  
    call MPI_RECV(value,1,MPI_INTEGER,myid+1,99,MPI_COMM_WORLD,status,ierr)
    print '(A10,1X,I4,1X,A20,1X,I4,1X,A10,1X,I4)','I am proc',myid,'I just received', value,'from proc',myid+1
    if (myid.gt.0)then
        call MPI_SEND(value,1,MPI_INTEGER,myid-1,99,MPI_COMM_WORLD,ierr)
    endif
endif


call MPI_BARRIER(MPI_COMM_WORLD,ierr)

call MPI_FINALIZE(rc)

endprogram Hello_world      
