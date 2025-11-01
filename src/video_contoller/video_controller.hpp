#ifndef VIDEO_CONTROLLER
#define VIDEO_CONTROLLER
#include <GLFW/glfw3.h>

class VideoContoller {

    public:
        VideoContoller();
        ~VideoContoller();

       void run();

    private:
        void mainLoop(GLFWwindow* window);

};

#endif
