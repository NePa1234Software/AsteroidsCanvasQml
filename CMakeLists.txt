cmake_minimum_required(VERSION 3.24)

project(AsteroidsCanvasQml VERSION 1.0 LANGUAGES CXX)

find_package(Qt6 COMPONENTS Quick Qml Core REQUIRED)

qt_standard_project_setup()
qt_add_executable(appAsteroidsQml main.cpp)

add_subdirectory(AsteroidsQml)

set_target_properties(appAsteroidsQml PROPERTIES WIN32_EXECUTABLE TRUE)

target_link_libraries(appAsteroidsQml PRIVATE Qt6::Quick Qt6::Qml moduleAsteroidsQmlplugin)

# -----------------------------------------------------------
# installation using windeployqt
# cd <build folder>
# C:\Qt\Tools\CMake_64\bin\cmake --install . --config Release --prefix %CD%\portable
# -----------------------------------------------------------
if(WIN32)
    qt_generate_deploy_qml_app_script(
        TARGET appAsteroidsQml
        OUTPUT_SCRIPT deploy_script # from qt 6.5
        #FILENAME_VARIABLE deploy_script depricated
    )
endif()

install(TARGETS appAsteroidsQml
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

if(WIN32)
    install(SCRIPT ${deploy_script})
endif()
