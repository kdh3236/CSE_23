# Compiler
CXX = g++

# Compiler flags
CXXFLAGS = -Wall -Wextra -O2

# Debugging ALU
SRC = main.cpp ALU.cpp
OBJ = $(SRC:.cpp=.o)

# Executable names
TARGET = alu

# Default rule: compile everything
all: $(TARGET)

# Linking CPU simulation
$(TARGET): $(OBJ)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(OBJ)

# Compile C++ files into object files
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Clean generated files
clean:
	rm -f $(OBJ) $(TARGET) *.mem

# Run the CPU simulation
all: $(TARGET)

# Phony targets (not actual files)
.PHONY: all clean alu
