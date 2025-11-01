
#include <iostream>
#include <stdexcept>
#include <cstdlib>

#include "video_controller.hpp"

int main() {
    VideoContoller controller;

    try {
        controller.run();
    } catch (const std::exception& e) {
        std::cerr << e.what() << std::endl;
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
