#ifndef VULKAN_SETUP
#define VULKAN_SETUP

#define GLFW_INCLUDE_VULKAN
#include <GLFW/glfw3.h>
#include <vulkan/vulkan.h>
#include <vector>
#include <iostream>


class VulkanSetup {

	public:
		VulkanSetup();
		~VulkanSetup();

		void initVulkan();

	private:
		void cleanup();
		void createInstance();
		bool checkValidationLayerSupport();
		void pickPhysicalDevice();
		bool isDeviceSuitable(VkPhysicalDevice device);
		std::vector<const char*> extentionGather();

		VkInstance _instance;

		const std::vector<const char*> _validationLayers;

		#ifdef NDEBUG
			static const bool enableValidationLayers = false;
		#else
			static const bool enableValidationLayers = true;
		#endif
};

#endif
