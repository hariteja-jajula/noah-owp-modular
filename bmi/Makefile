# Makefile in bmi directory

.SUFFIXES:
.SUFFIXES: .o .f90

include ../user_build_options

F90FLAGS := -cpp ${F90FLAGS}

OBJS = bmi_noahowp.o \
       bmi.o

all: $(OBJS)
	@echo "Finished building all objects in bmi."

.f90.o:
	@echo "Compiling $(*).f90 with profiling flags..."
	$(COMPILERF90) -c $(F90FLAGS) $(FREESOURCE) -I../src  $(*).f90

clean:
	@echo "Cleaning up in bmi directory..."
	rm -f *.o *.mod
