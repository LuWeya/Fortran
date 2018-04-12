program main
include 'mpif.h'
character* (MPI_MAX_PROCESSOR_NAME)processor_name
integer myid, numprocs, namelen, rc, ierr
integer:: count_send,tag, mydata(2),node

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

count_send=2  ! the number of data you send
tag=99        ! tag

if(myid==0) then
    write(*,*)'Hello test from all to all.'
end if 
do node=0,numprocs-1   ! send to each one (except itself)
    if(node/=myid) then
        mydata(1)=node
        mydata(2)=myid
        call MPI_SEND(mydata(1),count_send,MPI_INTEGER,node,tag,MPI_COMM_WORLD,ierr)
        write(*,*) myid,' send hello to ',node
        call MPI_RECV(mydata(2),count_send,MPI_INTEGER,node,tag,MPI_COMM_WORLD,iSTATUS,ierr)
        write(*,*) myid,' receive hello form',node
        if((mydata(1)/=node).or.(mydata(2)/=myid)) then
            write(*,*)'error!'
        end if 
    end if
end do 

write(*,*) myid,'  data is ',mydata

!--------------------------------------------------
call MPI_FINALIZE()
end program
