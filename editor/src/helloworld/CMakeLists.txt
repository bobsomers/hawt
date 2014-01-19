project(helloworld)

set(CMAKE_INCLUDE_CURRENT_DIR on)
set(CMAKE_AUTOMOC on)

find_package(Qt5Widgets REQUIRED)

file(GLOB_RECURSE SOURCE_FILES *.cpp)

add_executable(${CMAKE_PROJECT_NAME} ${SOURCE_FILES})
target_link_libraries(${CMAKE_PROJECT_NAME} Qt5::Widgets)

install(TARGETS ${CMAKE_PROJECT_NAME} RUNTIME DESTINATION bin)
