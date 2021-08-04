//
//  shadimpl.hpp
//  GoOpenGL
//
//  Created by Yue Dai on 2021-07-17.
//

#ifndef shadimpl_hpp
#define shadimpl_hpp

#include <glad/glad.h>
#include <GLFW/glfw3.h>

#include <iostream>
#include <string>

class ShadImpl {
private:
    std::string fileloca;
    std::string filename;
    
public:
    ShadImpl();
    ~ShadImpl();
};

#endif /* shadimpl_hpp */
