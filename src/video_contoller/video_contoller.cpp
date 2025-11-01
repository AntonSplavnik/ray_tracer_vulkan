#include "video_controller.hpp"
#include "glfw_setup.hpp"
#include "vulkan_setup.hpp"

VideoContoller::VideoContoller() {}
VideoContoller::~VideoContoller() {}

void VideoContoller::run() {

	GlfwSetup window;
	window.initWindow();

	VulkanSetup vulkan;
	vulkan.initVulkan();

	mainLoop(&window.getWindow());

	window.cleanup();
}

void VideoContoller::mainLoop(GLFWwindow* window) {
	while (!glfwWindowShouldClose(window)) {
		glfwPollEvents();
	}
}
