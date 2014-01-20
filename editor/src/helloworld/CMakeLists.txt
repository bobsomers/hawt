project(helloworld)

file(GLOB_RECURSE SOURCE_FILES *.cpp)

set(CMAKE_INCLUDE_CURRENT_DIR on)
set(CMAKE_AUTOMOC on)
find_package(Qt5Widgets REQUIRED)

add_executable(${PROJECT_NAME} ${SOURCE_FILES})
target_link_libraries(${PROJECT_NAME} Qt5::Widgets)
install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)
