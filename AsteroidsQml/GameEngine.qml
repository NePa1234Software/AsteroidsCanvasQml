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

    function rotateLeft(val) { Game.keyLeft = val }
    function rotateRight(val) { Game.keyRight = val }
    function requestShoot() { Game.requestShoot = true }
    function requestThrust(val) { Game.keyUp = val }
    function requestHyperjump() { Game.requestHyperjump = true }
    function doUltiActivation(val) { Game.doUltiActivation(val) }

    function newGameRequest(owner : Item) { Game.newGameRequest(owner); }
    function setGameArea(w, h) { Game.setGameArea(w, h); }

    function initGameRequest(owner) {
        console.log("GAME: Init game request ...");
        Game.initGameRequest(owner);
    }

    QtObject {
        id: internal
    }
}
