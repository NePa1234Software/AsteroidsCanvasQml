// Copyright (C) 2023 Neil Parker

import QtQuick
import QtQuick.Controls

Rectangle {
    id: outerspace

    implicitWidth: 600
    implicitHeight: 400
    property int controlTextPixelSize: 46

    property bool gameOver: true
    property alias gamePaused: keyHandler.gamePaused
    property alias ultimateWeaponStatus: statusUlti
    property string statistics: "Statistics:"

    focus: true
    onFocusChanged: console.log("Outerspace focus changed ! : " + focus)
    onActiveFocusChanged: console.log("Outerspace activeFocus changed ! : " + activeFocus)
    Keys.forwardTo: [keyHandler,gamearea,statusBar]

    KeyboardHandler {
        id: keyHandler
        gamePaused: false
        onUltiActivationRequest: {
            statusUlti.activateUlti();
        }
    }

    onGameOverChanged: {
        if (gameOver) {
            gameOverText.showGameOverScreen();
        }
    }

    // Start the movement and game controlling
    function beginGame()
    {
        //newGameStarting();
        GameEngine.newGameRequest(gamearea);
        timer.running = true;

        // Reset the ulti and start charging
        console.log("Ulti: charge");
        ultimateWeaponStatus.charge = true;
        ultimateWeaponStatus.percentFull = 0;

        splash.closeSplashScreen();
    }

    // Start the movement and game controlling
    function initGame()
    {
        GameEngine.initGameRequest(gamearea);
        GameEngine.setGameArea(gamearea.width, gamearea.height);
        timer.running = true;

        //TEST gameOverText.showGameOverScreen();
        splash.showSplashScreen();
    }

    function doUpdateStatistics()
    {
        statusBar.updateGameStatus(GameEngine.gameOver(), GameEngine.paused(), GameEngine.level(), GameEngine.lives(), GameEngine.score());
        gameOver = GameEngine.gameOver();
        ultimateWeaponStatus.paused = GameEngine.paused();
        statistics = GameEngine.getStatistics();
    }

    // Status bar at the top
    PlayerStatusBar {
        id: statusBar
        anchors.top: outerspace.top
        anchors.left: outerspace.left
        width: outerspace.width
        onActiveFocusChanged: console.log("PlayerStatusBar activeFocus changed ! : " + activeFocus)
        onNewGameRequest: {
            outerspace.beginGame();
        }
        onPauseGameRequest: {
            keyHandler.togglePauseGame();
        }
    }

    Rectangle {
        id: gamearea

        width: parent.width
        anchors.top: statusBar.bottom;
        anchors.bottom: outerspace.bottom
        color: "black"

        onFocusChanged: console.log("gamearea focus changed ! : " + focus)

        onWidthChanged: GameEngine.setGameArea(width, height);
        onHeightChanged: GameEngine.setGameArea(width, height);

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
                GameEngine.rotateLeft(true);
            }
            onReleased: {
                GameEngine.rotateLeft(false);
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
                GameEngine.rotateRight(true);
            }
            onReleased: {
                GameEngine.rotateRight(false);
            }
        }
        ControlButton {
            id: roundButtonShoot
            anchors.right: gamearea.right
            anchors.rightMargin: 50
            anchors.bottom: gamearea.bottom
            anchors.bottomMargin: 150
            icon.source: "Icons/destruction.svg"
            onPressed: {
                GameEngine.requestShoot();
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
                GameEngine.requestThrust(true);
            }
            onReleased: {
                GameEngine.requestThrust(false);
            }
        }
        ControlButton {
            id: roundButtonHyperspace
            anchors.bottom: roundButtonShoot.top
            anchors.bottomMargin: 100
            anchors.left: roundButtonShoot.left
            icon.source: "Icons/open_with.svg"
            onPressed: {
                GameEngine.requestHyperjump();
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
        }
    }

    Timer {
        id: timer
        interval: 16
        repeat: true
        running: false
        onTriggered: {
            GameEngine.doFastTimerLoop();
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
            GameEngine.doUltiActivation(activated);
        }
    }

    AsteroidsSplashScreen {
        id: splash
        timeoutMs: 0
        anchors.centerIn: parent
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
