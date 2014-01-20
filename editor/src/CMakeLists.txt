cmake_minimum_required(VERSION 2.8.11)

# If no install prefix specified, default to top level directory.
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX ../install CACHE PATH "Install prefix" FORCE)
endif(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)

# Homebrew: Why ship working packages when you can ship broken ones?
if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    list(APPEND CMAKE_PREFIX_PATH "/usr/local/Cellar/qt5/5.2.0/lib/cmake")
endif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")

# Enable C++11.
set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} -std=c++11)

add_subdirectory(enet)
add_subdirectory(helloworld)
