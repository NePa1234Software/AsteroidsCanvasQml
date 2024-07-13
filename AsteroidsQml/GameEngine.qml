pragma Singleton

import QtQuick

import "gameEngine.js" as GameEngine
import "gameAsteroids.js" as Game

Item {
    id: gameEngine

    property SpaceParticalSystem spaceParticalSystem

    function gameOver() : bool { return Game.isGameOver() }
    function paused() : bool { return Game.pause }
    function togglePaused() { Game.pause = !Game.pause }
    function level() : int { return Game.level }
    function lives() : int { return Game.lives }
    function score() : int { return Game.score }
    function getStatistics() : string { return Game.getStatistics() }
    function doFastTimerLoop() { Game.doFastTimerLoop() }

    function rotateLeft(val : bool) { Game.keyLeft = val }
    function rotateRight(val : bool) { Game.keyRight = val }
    function requestShoot() { Game.requestShoot = true }
    function requestThrust(val : bool) { Game.keyUp = val }
    function requestHyperjump() { Game.requestHyperjump = true }
    function doUltiActivation(val : bool) { Game.doUltiActivation(val) }

    function newGameRequest(owner : Item) { Game.newGameRequest(owner); }
    function setGameArea(w : real, h : real) { Game.setGameArea(w, h); }

    QtObject {
        id: internal
    }

    Component.onCompleted: {
        console.log("GAME: Init game request ...");
        Game.initGameRequest(gameEngine);
    }
}
