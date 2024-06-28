# Qml module

qt_add_library(moduleAsteroidsQml STATIC)

target_link_libraries(moduleAsteroidsQml PRIVATE Qt6::Gui Qt6::Quick)

if(EMSCRIPTEN)
    target_link_options(moduleAsteroidsQml PUBLIC -sASYNCIFY -Os)
endif()

set_target_properties(moduleAsteroidsQml PROPERTIES
    QT_QMLCACHEGEN_ARGUMENTS "--verbose"
)

set_source_files_properties(GameEngine.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)
qt_add_qml_module(moduleAsteroidsQml
    URI AsteroidsQml
    VERSION 1.0

    QML_FILES
    main.qml GameEngine.qml OuterSpace.qml TestArea.qml
    Asteroid.qml AsteroidsSplashScreen.qml PlayerStatusBar.qml GameOver.qml
    SpaceShip.qml Debris.qml Bullet.qml SpaceObject.qml ObjectState.qml
    AlienShip.qml UltiStatus.qml UltiCannons.qml WeaponInterface.qml CannonInterface.qml
    gameEngine.js gameAsteroids.js ControlButton.qml
    MenuButton.qml KeyboardHandler.qml SpaceParticalSystem.qml

    RESOURCES
    Fonts/Vectorb.ttf
    Icons/arrow_back.svg
    Icons/arrow_forward.svg
    Icons/stat_3.svg
    Icons/destruction.svg
    Icons/open_with.svg
    Icons/star.svg
)
