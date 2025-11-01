#define GLFW_INCLUDE_VULKAN
#include "GLFW/glfw3.h"
#include <glm/vec4.hpp>
#include <iostream>

int main() {
    glfwInit();

    glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
    GLFWwindow * window = glfwCreateWindow(400, 400, "vulkan raytracer window", nullptr, nullptr);

    while (!glfwWindowShouldClose(window)) {
        glfwPollEvents();
    }

    glfwDestroyWindow(window);
    glfwTerminate();

    return EXIT_SUCCESS;
}
#include <iostream>
#include <string>

int main(){
	std::cout << "Hello world" << std::endl;
	return 0;
}

