#include "glfw_setup.hpp"

GlfwSetup::GlfwSetup(){}
GlfwSetup::~GlfwSetup(){}


void GlfwSetup::initWindow() {

	glfwInit();

	glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
	glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE);

	_window = glfwCreateWindow(WIDTH, HEIGHT, "vulkan ray tracer", nullptr, nullptr);
}

void GlfwSetup::cleanup() {
	glfwDestroyWindow(_window);
	glfwTerminate();
}

GLFWwindow& GlfwSetup::getWindow() const {return *_window;}
