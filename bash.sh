#!/bin/bash
mpif90 -o application.xex ./Fortran/first2last_last2first.f90
mpirun -np 4 application.xex