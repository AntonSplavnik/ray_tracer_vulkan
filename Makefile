# Vulkan Ray Tracer Makefile

# Project name
PROJECT_NAME = vulkan_ray_tracer

# Compiler and flags
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -O2
DEBUGFLAGS = -g -O0 -DDEBUG

# Directories
SRC_DIR = src
INC_DIR = include
OBJ_DIR = obj
BIN_DIR = bin
SHADER_DIR = shaders
SHADER_BIN_DIR = $(BIN_DIR)/shaders

# Vulkan SDK (adjust if needed)
VULKAN_SDK_PATH = $(VULKAN_SDK)
VULKAN_INCLUDE = $(VULKAN_SDK_PATH)/include
VULKAN_LIB = $(VULKAN_SDK_PATH)/lib

# Platform-specific settings
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    # macOS with MoltenVK
    LDFLAGS = -L$(VULKAN_LIB) -lvulkan -lglfw -L/opt/homebrew/lib -I/opt/homebrew/include -Wl,-rpath,$(VULKAN_LIB)
    CXXFLAGS += -I$(VULKAN_INCLUDE)
else ifeq ($(UNAME_S),Linux)
    # Linux
    LDFLAGS = -L$(VULKAN_LIB) -lvulkan -lglfw -ldl -lpthread -lX11 -lXxf86vm -lXrandr -lXi
    CXXFLAGS += -I$(VULKAN_INCLUDE)
else
    # Windows (MinGW)
    LDFLAGS = -L$(VULKAN_LIB) -lvulkan-1 -lglfw3 -lgdi32
    CXXFLAGS += -I$(VULKAN_INCLUDE)
endif

# Include directories
INCLUDES = -I$(INC_DIR)

# Source files
SOURCES = $(wildcard $(SRC_DIR)/*.cpp) $(wildcard $(SRC_DIR)/**/*.cpp)
OBJECTS = $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SOURCES))

# Shader files
VERT_SHADERS = $(wildcard $(SHADER_DIR)/*.vert)
FRAG_SHADERS = $(wildcard $(SHADER_DIR)/*.frag)
COMP_SHADERS = $(wildcard $(SHADER_DIR)/*.comp)
RGEN_SHADERS = $(wildcard $(SHADER_DIR)/*.rgen)
RCHIT_SHADERS = $(wildcard $(SHADER_DIR)/*.rchit)
RMISS_SHADERS = $(wildcard $(SHADER_DIR)/*.rmiss)

ALL_SHADERS = $(VERT_SHADERS) $(FRAG_SHADERS) $(COMP_SHADERS) $(RGEN_SHADERS) $(RCHIT_SHADERS) $(RMISS_SHADERS)
SHADER_BINS = $(patsubst $(SHADER_DIR)/%,$(SHADER_BIN_DIR)/%.spv,$(notdir $(ALL_SHADERS)))

# Shader compiler
GLSLC = glslc

# Target executable
TARGET = $(BIN_DIR)/$(PROJECT_NAME)

# Default target
.PHONY: all
all: directories $(TARGET) shaders

# Debug build
.PHONY: debug
debug: CXXFLAGS += $(DEBUGFLAGS)
debug: clean all

# Release build
.PHONY: release
release: CXXFLAGS += -O3 -DNDEBUG
release: clean all

# Create necessary directories
.PHONY: directories
directories:
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(BIN_DIR)
	@mkdir -p $(SHADER_BIN_DIR)
	@mkdir -p $(SRC_DIR)
	@mkdir -p $(INC_DIR)
	@mkdir -p $(SHADER_DIR)

# Link object files to create executable
$(TARGET): $(OBJECTS)
	@echo "Linking $@..."
	@$(CXX) $(OBJECTS) -o $@ $(LDFLAGS)
	@echo "Build complete: $@"

# Compile source files to object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(dir $@)
	@echo "Compiling $<..."
	@$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Compile shaders
.PHONY: shaders
shaders: directories $(SHADER_BINS)

$(SHADER_BIN_DIR)/%.vert.spv: $(SHADER_DIR)/%.vert
	@echo "Compiling vertex shader $<..."
	@$(GLSLC) $< -o $@

$(SHADER_BIN_DIR)/%.frag.spv: $(SHADER_DIR)/%.frag
	@echo "Compiling fragment shader $<..."
	@$(GLSLC) $< -o $@

$(SHADER_BIN_DIR)/%.comp.spv: $(SHADER_DIR)/%.comp
	@echo "Compiling compute shader $<..."
	@$(GLSLC) $< -o $@

$(SHADER_BIN_DIR)/%.rgen.spv: $(SHADER_DIR)/%.rgen
	@echo "Compiling ray generation shader $<..."
	@$(GLSLC) --target-env=vulkan1.2 $< -o $@

$(SHADER_BIN_DIR)/%.rchit.spv: $(SHADER_DIR)/%.rchit
	@echo "Compiling closest hit shader $<..."
	@$(GLSLC) --target-env=vulkan1.2 $< -o $@

$(SHADER_BIN_DIR)/%.rmiss.spv: $(SHADER_DIR)/%.rmiss
	@echo "Compiling miss shader $<..."
	@$(GLSLC) --target-env=vulkan1.2 $< -o $@

# Run the application
.PHONY: run
run: all
	@echo "Running $(TARGET)..."
	@cd $(BIN_DIR) && ./$(PROJECT_NAME)

# Clean build artifacts
.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(OBJ_DIR)
	@rm -rf $(BIN_DIR)
	@echo "Clean complete."

# Clean and rebuild
.PHONY: rebuild
rebuild: clean all

# Install dependencies (macOS with Homebrew)
.PHONY: install-deps
install-deps:
ifeq ($(UNAME_S),Darwin)
	@echo "Installing dependencies for macOS..."
	brew install glfw vulkan-headers vulkan-loader molten-vk glslang
else ifeq ($(UNAME_S),Linux)
	@echo "Please install: vulkan-sdk, glfw, and glslang manually"
else
	@echo "Please install Vulkan SDK, GLFW, and glslang manually"
endif

# Show build variables (for debugging Makefile)
.PHONY: info
info:
	@echo "Project: $(PROJECT_NAME)"
	@echo "Platform: $(UNAME_S)"
	@echo "Compiler: $(CXX)"
	@echo "Flags: $(CXXFLAGS)"
	@echo "Sources: $(SOURCES)"
	@echo "Objects: $(OBJECTS)"
	@echo "Shaders: $(ALL_SHADERS)"
	@echo "Target: $(TARGET)"
	@echo "Vulkan SDK: $(VULKAN_SDK_PATH)"

# Help target
.PHONY: help
help:
	@echo "Vulkan Ray Tracer Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  all          - Build the project (default)"
	@echo "  debug        - Build with debug symbols"
	@echo "  release      - Build optimized release version"
	@echo "  shaders      - Compile all shaders"
	@echo "  run          - Build and run the application"
	@echo "  clean        - Remove build artifacts"
	@echo "  rebuild      - Clean and rebuild"
	@echo "  install-deps - Install dependencies (macOS)"
	@echo "  info         - Show build configuration"
	@echo "  help         - Show this help message"
