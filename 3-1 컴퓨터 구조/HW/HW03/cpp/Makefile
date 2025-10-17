# Compiler
CXX = g++

# Compiler flags
CXXFLAGS = -Wall -Wextra -O2

# Source and Object files
SRC = main.cpp CPU.cpp ALU.cpp RF.cpp MEM.cpp CTRL.cpp
OBJ = $(SRC:.cpp=.o)

# Executable names
TARGET = cpu

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
run: $(TARGET)

# Phony targets (not actual files)
.PHONY: all clean run

