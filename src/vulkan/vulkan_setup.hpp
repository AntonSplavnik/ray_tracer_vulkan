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
		void createInstance();

		VkInstance _instance;
};

#endif
