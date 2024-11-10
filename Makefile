# Makefile 
#

# Define profiling flags
PROFILE_FLAGS = -pg

# Pass the profile flag to each subdirectory make command
all: user_build_options
	(cd src;        make FCFLAGS="$(PROFILE_FLAGS)")
	(cd bmi;        make FCFLAGS="$(PROFILE_FLAGS)")
	(cd driver;     make FCFLAGS="$(PROFILE_FLAGS)")
	(cd run;        make FCFLAGS="$(PROFILE_FLAGS)")

clean:
	(cd src;        make clean)
	(cd bmi;        make clean)
	(cd driver;     make clean)
	(cd run;        make clean)

testBMI:
	(cd src;        make FCFLAGS="$(PROFILE_FLAGS)")
	(cd bmi;        make FCFLAGS="$(PROFILE_FLAGS)")
	(cd driver;     make FCFLAGS="$(PROFILE_FLAGS)")
	(cd test;       make FCFLAGS="$(PROFILE_FLAGS)")

testBMI_clean:
	(cd src;        make clean)
	(cd bmi;        make clean)
	(cd driver;     make clean)
	(cd test;       make clean)
