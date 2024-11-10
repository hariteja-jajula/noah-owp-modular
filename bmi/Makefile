# Makefile for Profiling with gprof

.SUFFIXES:
.SUFFIXES: .o .f90

include ../user_build_options

# Add -pg flag for profiling
F90FLAGS := -cpp -pg ${F90FLAGS}

OBJS = bmi_noahowp.o \
       bmi.o

all: $(OBJS)

# Compile with profiling
.f90.o:
	$(COMPILERF90) -c $(F90FLAGS) $(FREESOURCE) -I../src  $(*).f90

# Linking step (if necessary, adjust if linking is done elsewhere)
bmi_noahowp: $(OBJS)
	$(COMPILERF90) -o bmi_noahowp $(OBJS) $(F90FLAGS)

# Clean up object and module files
clean:
	rm -f *.o *.mod

# Dependencies
bmi_noahowp.o: bmi.o \
              ../src/RunModule.o
