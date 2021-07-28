//
//  gltols.cpp
//  GoOpenGL
//
//  Created by Yue Dai on 2021-07-16.
//

#include "gltols.hpp"


void framebuffer_size_callback(GLFWwindow* window, int width, int heigh) {
    glViewport(0, 0, width, heigh);
}

void process_input(GLFWwindow* window) {
    if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
        glfwSetWindowShouldClose(window, true);
}

