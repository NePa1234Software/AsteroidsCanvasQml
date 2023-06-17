// Copyright (C) 2023 Neil Parker

import QtQuick
import QtQuick.Controls 2.15
import "gameEngine.js" as GameEngine
import "gameAsteroids.js" as Game

Rectangle {
    id: outerspace

    implicitWidth: 600
    implicitHeight: 400

    signal newGameStarting
    property bool gameOver: true

    // Start the movement and game controlling
    function beginGame()
    {
        newGameStarting();
        Game.newGameRequest(gamearea);
        gamearea.focus = true;
        timer.running = true;
    }

    // Start the movement and game controlling
    function initGame()
    {
        Game.setGameArea(gamearea.width, gamearea.height)
        Game.initGameRequest(gamearea);
        gamearea.focus = true;
        timer.running = true;
    }

    function doUpdateStatistics()
    {
        statusBar.updateGameStatus(Game.gameOver, Game.pause, Game.level, Game.lives, Game.score);
        gameOver = Game.gameOver
    }

    Rectangle {
        id: gamearea

        width: parent.width
        anchors.top: parent.top;
        anchors.bottom: statusBar.top
        color: "black"
        focus: true

        onWidthChanged: Game.setGameArea(width, height);
        onHeightChanged: Game.setGameArea(width, height);

        // Reference objects for finding load errors
        //AlienShip
        //{
        //    id: spaceObject
        //    objectPosX: 100
        //    objectPosY: 200
        //    objectBearing: 45
        //    visible: true
        //}
        //Bullet {
        //    id : myBullet
        //}
        //Asteroid {
        //    id : myAsteroid
        //}

        // Reference "dot" at the center of the screen
        //Rectangle {
        //    id: screenCenter
        //    visible: false
        //    anchors.centerIn: parent
        //    width: 2
        //    height: 2
        //    color:"blue"
        //    Component.onCompleted: {
        //        console.log("Screen center is x/y: " + x + "/" + y);
        //    }
        //}
    }

    Timer {
        id: timer
        interval: 10
        repeat: true
        running: false
        onTriggered: {
            Game.doFastTimerLoop()
            outerspace.doUpdateStatistics();
        }
    }

    PlayerStatusBar {
        id: statusBar
        anchors.bottom: outerspace.bottom
        width: outerspace.width
        onNewGameRequest: {
            Game.newGameRequest(gamearea);
            gamearea.focus = true;
            outerspace.newGameStarting();
        }
    }

    Keys.onPressed: (event)=>
                    {
                        if (event.key === Qt.Key_P) {
                            Game.pause = !Game.pause;
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
                            Game.keySpace = true
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

}
