//
//  main.cpp
//  GoOpenGL
//
//  Created by Yue Dai on 2021-07-16.
//

#include "gltols.hpp"
#include "shadio.hpp"

#include <iostream>

const int WIDTH = 800;
const int HEIGH = 600;

const std::string vrtx = read_shader("vrtx", "./shad/");

int main(int argc, const char* argv[]) {
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
#ifdef __APPLE__
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
#endif
    
    GLFWwindow* mainWindow = glfwCreateWindow(WIDTH, HEIGH, "ItsTheMotherfuckinOpenGL", NULL, NULL);
    if (mainWindow == NULL) {
        std::cout << "Failed to create GLFW window." << std::endl;
        glfwTerminate();
        return EXIT_SUCCESS;
    }
    
    glfwMakeContextCurrent(mainWindow);
    glfwSetFramebufferSizeCallback(mainWindow, framebuffer_size_callback);
    
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
        std::cout << "Failed to initialize GLAD." << std::endl;
        return EXIT_SUCCESS;
    }
    
    while (!glfwWindowShouldClose(mainWindow)) {
        process_input(mainWindow);
        
        glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        
        glfwSwapBuffers(mainWindow);
        glfwPollEvents();
    }
    
    glfwTerminate();
    return EXIT_SUCCESS;
}
