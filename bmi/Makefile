# Makefile in bmi directory

# Set F90FLAGS and FCFLAGS to include PROFILE_FLAGS if provided
F90FLAGS := -cpp $(F90FLAGS) $(PROFILE_FLAGS)
FCFLAGS := $(FCFLAGS) $(PROFILE_FLAGS)

OBJS = bmi_noahowp.o \
       bmi.o

all: $(OBJS)

.f90.o:
	$(COMPILERF90) -c $(F90FLAGS) $(FREESOURCE) -I../src  $(*).f90

clean:
	rm -f *.o *.mod

# Dependencies
bmi_noahowp.o: bmi.o \
               ../src/RunModule.o
