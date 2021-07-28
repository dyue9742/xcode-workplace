//
//  shadio.cpp
//  GoOpenGL
//
//  Created by Yue Dai on 2021-07-16.
//

#include "shadio.hpp"

std::string read_shader(std::string filename, std::string fileloca) {
    std::string data = "";
    
    std::string line = "";
    std::ifstream shad;
    shad.open(fileloca + filename);
    if (!shad.is_open()) return "";
    while (shad) {
        std::getline(shad, line);
        data += line;
    }
    shad.close();
    return data;
}
