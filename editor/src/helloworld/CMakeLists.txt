project(helloworld)

file(GLOB_RECURSE SOURCE_FILES *.cpp)

set(CMAKE_INCLUDE_CURRENT_DIR on)
set(CMAKE_AUTOMOC on)
find_package(Qt5Widgets REQUIRED)

add_executable(${PROJECT_NAME} ${SOURCE_FILES})
add_dependencies(${PROJECT_NAME} enet)

ExternalProject_Get_Property(enet install_dir)
include_directories(SYSTEM ${install_dir}/include)
target_link_libraries(${PROJECT_NAME} Qt5::Widgets ${install_dir}/lib/libenet.a)
install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)
