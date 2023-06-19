# Qml module

qt_add_library(moduleAsteroidsQml STATIC)

target_link_libraries(moduleAsteroidsQml PRIVATE Qt6::Gui Qt6::Quick)

qt_add_qml_module(moduleAsteroidsQml
    URI AsteroidsQml
    VERSION 1.0
    QML_FILES
    main.qml OuterSpace.qml
    Asteroid.qml AsteroidsSplashScreen.qml PlayerStatusBar.qml
    SpaceShip.qml Debris.qml Bullet.qml SpaceObject.qml
    AlienShip.qml
    gameEngine.js gameAsteroids.js
)
