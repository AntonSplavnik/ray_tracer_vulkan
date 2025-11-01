#ifndef GLFG_SETUP
#define GLFG_SETUP

#include <GLFW/glfw3.h>

#define WIDTH 800
#define HEIGHT 600

class GlfwSetup{

	public:
		GlfwSetup();
		~GlfwSetup();

		void initWindow();
		void cleanup();
		GLFWwindow& getWindow() const;
	private:
		GLFWwindow*	_window;


};

#endif
