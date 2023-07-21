# Qml module

qt_add_library(moduleAsteroidsQml STATIC)

target_link_libraries(moduleAsteroidsQml PRIVATE Qt6::Gui Qt6::Quick)

qt_add_qml_module(moduleAsteroidsQml
    URI AsteroidsQml
    VERSION 1.0
    # OUTPUT_DIRECTORY /AsteroidsQml
    QML_FILES
    main.qml OuterSpace.qml TestArea.qml
    Asteroid.qml AsteroidsSplashScreen.qml PlayerStatusBar.qml GameOver.qml
    SpaceShip.qml Debris.qml Bullet.qml SpaceObject.qml ObjectState.qml
    AlienShip.qml UltiStatus.qml UltiCannons.qml WeaponInterface.qml CannonInterface.qml
    gameEngine.js gameAsteroids.js

    RESOURCES
    Fonts/Vectorb.ttf
)
