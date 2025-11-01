#include "vulkan_setup.hpp"
#include <stdexcept>
#include <vector>
#include <iostream>

// const std::vector<const char*> validationLayers = {
//     "VK_LAYER_KHRONOS_validation"
// };

// #ifdef NDEBUG
//     const bool enableValidationLayers = false;
// #else
//     const bool enableValidationLayers = true;
// #endif

VulkanSetup::VulkanSetup()
	: _instance(nullptr){}
VulkanSetup::~VulkanSetup(){
	cleanup();
}

void VulkanSetup::cleanup() {
    vkDestroyInstance(_instance, nullptr);
	std::cout << "Vulkan has been destroyed" << std::endl;
}

void VulkanSetup::initVulkan() {
	createInstance();
}

void VulkanSetup::createInstance() {
	VkApplicationInfo appInfo = {
	    .sType = VK_STRUCTURE_TYPE_APPLICATION_INFO,
	    .pApplicationName = "Hello Triangle",
	    .applicationVersion = VK_MAKE_VERSION(1, 0, 0),
	    .pEngineName = "No Engine",
	    .engineVersion = VK_MAKE_VERSION(1, 0, 0),
	    .apiVersion = VK_API_VERSION_1_0,
	};

	VkInstanceCreateInfo createInfo = {
	    .sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
	    .pApplicationInfo = &appInfo,
		.enabledLayerCount = 0,
	};

	uint32_t glfwExtensionCount = 0;
	const char** glfwExtensions;

	glfwExtensions = glfwGetRequiredInstanceExtensions(&glfwExtensionCount);

	createInfo.enabledExtensionCount = glfwExtensionCount;
	createInfo.ppEnabledExtensionNames = glfwExtensions;

	std::vector<const char*> requiredExtensions;

    for(uint32_t i = 0; i < glfwExtensionCount; i++) {
        requiredExtensions.emplace_back(glfwExtensions[i]);
    }

    requiredExtensions.emplace_back(VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME);

    createInfo.flags |= VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR;

    createInfo.enabledExtensionCount = (uint32_t) requiredExtensions.size();
    createInfo.ppEnabledExtensionNames = requiredExtensions.data();

	if (vkCreateInstance(&createInfo, nullptr, &_instance) != VK_SUCCESS) {
		throw std::runtime_error("failed to create instance!");
	}
}


