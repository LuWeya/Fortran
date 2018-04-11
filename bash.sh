#!/bin/bash
mpif90 -o eee test.f90
mpirun -np 4 ./eee
