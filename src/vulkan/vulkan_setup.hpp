#ifndef VULKAN_SETUP
#define VULKAN_SETUP


#define GLFW_INCLUDE_VULKAN
#include <GLFW/glfw3.h>
#include <vulkan/vulkan.h>


class VulkanSetup {

	public:
		VulkanSetup();
		~VulkanSetup();

		void initVulkan();

	private:
		void cleanup();
		void createInstance();

		VkInstance _instance;

		// Not clear about following setup
		// static const std::vector<const char*> validationLayers;

		// #ifdef NDEBUG
		// 	static const bool enableValidationLayers = false;
		// #else
		// 	static const bool enableValidationLayers = true;
		// #endif
};

#endif
