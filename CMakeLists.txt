cmake_minimum_required(VERSION 3.16)

project(AsteroidsCanvasQml VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick Qml REQUIRED)

qt_add_executable(appAsteroidsQml
    main.cpp
)

add_subdirectory(modules)

set_target_properties(appAsteroidsQml PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appAsteroidsQml
    PRIVATE Qt6::Quick Qt6::Qml moduleAsteroidsQmlplugin)

install(TARGETS appAsteroidsQml
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
