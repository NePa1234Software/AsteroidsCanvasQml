pragma Singleton

import QtQuick

import "gameEngine.js" as GameEngine
import "gameAsteroids.js" as Game

Item {
    id: gameEngine

    function gameOver() { return Game.gameOver }
    function paused() { return Game.pause }
    function togglePaused() { Game.pause = !Game.pause }
    function level() { return Game.level }
    function lives() { return Game.lives }
    function score() { return Game.score }
    function getStatistics() { return Game.getStatistics() }
    function doFastTimerLoop() { Game.doFastTimerLoop() }

    function rotateLeft(val) { Game.keyLeft = val }
    function rotateRight(val) { Game.keyRight = val }
    function requestShoot() { Game.requestShoot = true }
    function requestThrust(val) { Game.keyUp = val }
    function requestHyperjump() { Game.requestHyperjump = true }
    function doUltiActivation(val) { Game.doUltiActivation(val) }

    function newGameRequest(owner) { Game.newGameRequest(owner); }
    function setGameArea(w, h) { Game.setGameArea(w, h); }

    function initGameRequest(owner) { Game.initGameRequest(owner); }
}
