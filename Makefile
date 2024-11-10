# Makefile 

# Define profiling flags
PROFILE_FLAGS = -pg

# Pass the profile flag to each subdirectory make command
all: user_build_options
	@echo "Building in src directory with profiling flags..."
	(cd src; make FCFLAGS="$(PROFILE_FLAGS)")
	@echo "Building in bmi directory with profiling flags..."
	(cd bmi; make FCFLAGS="$(PROFILE_FLAGS)")
	@echo "Building in driver directory with profiling flags..."
	(cd driver; make FCFLAGS="$(PROFILE_FLAGS)")
	@echo "Building in run directory with profiling flags..."
	(cd run; make FCFLAGS="$(PROFILE_FLAGS)")

clean:
	@echo "Cleaning up in src directory..."
	(cd src; make clean)
	@echo "Cleaning up in bmi directory..."
	(cd bmi; make clean)
	@echo "Cleaning up in driver directory..."
	(cd driver; make clean)
	@echo "Cleaning up in run directory..."
	(cd run; make clean)

testBMI:
	@echo "Testing BMI in src directory..."
	(cd src; make FCFLAGS="$(PROFILE_FLAGS)")
	@echo "Testing BMI in bmi directory..."
	(cd bmi; make FCFLAGS="$(PROFILE_FLAGS)")
	@echo "Testing BMI in driver directory..."
	(cd driver; make FCFLAGS="$(PROFILE_FLAGS)")
	@echo "Testing BMI in test directory..."
	(cd test; make FCFLAGS="$(PROFILE_FLAGS)")

testBMI_clean:
	@echo "Cleaning BMI test files in src directory..."
	(cd src; make clean)
	@echo "Cleaning BMI test files in bmi directory..."
	(cd bmi; make clean)
	@echo "Cleaning BMI test files in driver directory..."
	(cd driver; make clean)
	@echo "Cleaning BMI test files in test directory..."
	(cd test; make clean)
