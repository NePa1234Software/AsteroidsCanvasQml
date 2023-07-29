// Copyright (C) 2023 Neil Parker

import QtQuick
import QtQuick.Controls
import "gameEngine.js" as GameEngine
import "gameAsteroids.js" as Game

Rectangle {
    id: outerspace

    implicitWidth: 600
    implicitHeight: 400
    property int controlTextPixelSize: 46

    //signal newGameStarting
    property bool gameOver: true
    property bool gamePaused: false
    property alias ultimateWeaponStatus: statusUlti
    property string statistics: "Statistics:"

    onGameOverChanged: {
        if (gameOver) {
            gameOverText.showGameOverScreen();
        }
    }

    // Start the movement and game controlling
    function beginGame()
    {
        //newGameStarting();
        Game.newGameRequest(gamearea);
        gamearea.focus = true;
        timer.running = true;


        // Reset the ulti and start charging
        console.log("Ulti: charge");
        ultimateWeaponStatus.charge = true;
        ultimateWeaponStatus.percentFull = 0;

        splash.closeSplashScreen();
    }

    function togglePauseGame() {
        Game.pause = !Game.pause;
        outerspace.gamePaused = Game.pause;
        gamearea.focus = true;
    }

    // Start the movement and game controlling
    function initGame()
    {
        Game.setGameArea(gamearea.width, gamearea.height)
        Game.initGameRequest(gamearea);
        gamearea.focus = true;
        timer.running = true;

        //TEST gameOverText.showGameOverScreen();
        splash.showSplashScreen();
    }

    function doUpdateStatistics()
    {
        statusBar.updateGameStatus(Game.gameOver, Game.pause, Game.level, Game.lives, Game.score);
        gameOver = Game.gameOver;
        ultimateWeaponStatus.paused = Game.pause;
        statistics = Game.getStatistics();
    }

    // Status bar at the top
    PlayerStatusBar {
        id: statusBar
        anchors.top: outerspace.top
        anchors.left: outerspace.left
        width: outerspace.width
        onNewGameRequest: {
            outerspace.beginGame();
        }
        onPauseGameRequest: {
            outerspace.togglePauseGame();
        }
    }

    Rectangle {
        id: gamearea

        width: parent.width
        anchors.top: statusBar.bottom;
        anchors.bottom: outerspace.bottom
        color: "black"

        // Important that this stays true to allow game control
        focus: true
        onFocusChanged: console.log("gamearea: focus changed - " + focus)

        onWidthChanged: Game.setGameArea(width, height);
        onHeightChanged: Game.setGameArea(width, height);

        TestArea  {}

        FontLoader {
            id: fontResource
            source: "Fonts/Vectorb.ttf"
        }

        Label
        {
            id: statisticsLabel
            text: outerspace.statistics
            color: "yellow"
            anchors.top: gamearea.top
            anchors.margins: 10
            anchors.left: gamearea.left
        }

        ControlButton {
            id: roundButtonLeft
            anchors.left: gamearea.left
            anchors.leftMargin: 100
            anchors.bottom: gamearea.bottom
            anchors.bottomMargin: 100
            icon.source: "Icons/arrow_back.svg"
            onPressed: {
                Game.keyLeft = true;
            }
            onReleased: {
                Game.keyLeft = false;
                gamearea.focus = true;
            }
        }
        ControlButton {
            id: roundButtonRight
            anchors.left: roundButtonLeft.right
            anchors.leftMargin: 50
            anchors.bottom: gamearea.bottom
            anchors.bottomMargin: 100
            icon.source: "Icons/arrow_forward.svg"
            onPressed: {
                Game.keyRight = true;
            }
            onReleased: {
                Game.keyRight = false;
                gamearea.focus = true;
            }
        }
        ControlButton {
            id: roundButtonShoot
            anchors.right: gamearea.right
            anchors.rightMargin: 50
            anchors.bottom: gamearea.bottom
            anchors.bottomMargin: 150
            icon.source: "Icons/destruction.svg"
            focus: false
            onPressed: {
                Game.requestShoot = true;
            }
            onReleased: {
                gamearea.focus = true;
            }
        }
        ControlButton {
            id: roundButtonThrust
            anchors.right: roundButtonShoot.left
            anchors.rightMargin: 50
            anchors.bottom: gamearea.bottom
            anchors.bottomMargin: 100
            icon.source: "Icons/stat_3.svg"
            onPressed: {
                Game.keyUp = true;
            }
            onReleased: {
                Game.keyUp = false;
                gamearea.focus = true;
            }
        }
        ControlButton {
            id: roundButtonHyperspace
            anchors.bottom: roundButtonShoot.top
            anchors.bottomMargin: 100
            anchors.left: roundButtonShoot.left
            icon.source: "Icons/open_with.svg"
            onPressed: {
                Game.requestHyperjump = true;
            }
            onReleased: {
                gamearea.focus = true;
            }
        }
        ControlButton {
            id: roundButtonUlti
            visible: statusUlti.fullyCharged
            anchors.bottom: roundButtonThrust.top
            anchors.bottomMargin: 100
            anchors.left: roundButtonThrust.left
            icon.source: "Icons/star.svg"
            onPressed: {
                statusUlti.activateUlti();
            }
            onReleased: {
                gamearea.focus = true;
            }
        }
    }

    Timer {
        id: timer
        interval: 16
        repeat: true
        running: false
        onTriggered: {
            Game.doFastTimerLoop()
            outerspace.doUpdateStatistics();
        }
    }

    UltiStatus {
        id: statusUlti
        anchors.top: gamearea.top
        anchors.right: gamearea.right
        anchors.margins: 20
        paused: outerspace.gamePaused
        onActivatedChanged: {
            Game.doUltiActivation(activated);
        }
    }

    Keys.onPressed: (event)=>
                    {
                        if (event.key === Qt.Key_P) {
                            Game.pause = !Game.pause;
                            outerspace.gamePaused = Game.pause;
                        }
                        if (event.key === Qt.Key_Left) {
                            Game.keyLeft = true;
                            event.accepted = true;
                        }
                        if (event.key === Qt.Key_Right) {
                            Game.keyRight = true;
                            event.accepted = true;
                        }
                        if (event.key === Qt.Key_Up) {
                            Game.keyUp = true;
                            event.accepted = true;
                        }
                        if (event.key === Qt.Key_Space) {
                            if (!Game.keySpace && !event.isAutoRepeat)
                            {
                                Game.requestShoot = true;
                            }
                            Game.keySpace = true
                            event.accepted = true;
                        }
                        if (event.key === Qt.Key_Down) {
                            if (!event.isAutoRepeat)
                            {
                                Game.requestHyperjump = true;
                            }
                            event.accepted = true;
                        }
                        if (event.key === Qt.Key_Shift) {
                            if (statusUlti.fullyCharged)
                            {
                                statusUlti.activateUlti();
                            }
                            event.accepted = true;
                        }
                    }
    Keys.onReleased: (event)=>
                     {
                         if (event.key === Qt.Key_Left) {
                             Game.keyLeft = false;
                             event.accepted = true;
                         }
                         if (event.key === Qt.Key_Right) {
                             Game.keyRight = false;
                             event.accepted = true;
                         }
                         if (event.key === Qt.Key_Up) {
                             Game.keyUp = false;
                             event.accepted = true;
                         }
                         if (event.key === Qt.Key_Space) {
                             Game.keySpace = false
                             event.accepted = true;
                         }
                     }

    AsteroidsSplashScreen {
        id: splash
        timeoutMs: 0
        anchors.centerIn: parent
        //onSplashScreenClosed: asteroidsQml.beginGame();
    }

    GameOver {
        id: gameOverText
        anchors.centerIn: parent
        anchors.fill: parent
        onGameOverScreenClosed: {
            splash.showSplashScreen();
        }
    }

    Component.onCompleted: {
        initGame();
    }

}
