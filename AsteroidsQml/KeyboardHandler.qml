import QtQuick

Item {
    id: keyHandler

    property bool gamePaused: false

    signal ultiActivationRequest

    focus: true
    onActiveFocusChanged: console.log("KeyHandler activeFocus changed ! : " + activeFocus)

    // ALL keyboard activity is captured here and not forwarded to any focused item
    Keys.onPressed: (event)=> {
        //console.log("KeyHandler - Key pressed: " + event.key)
        handleKeyPressed(event);
        event.accepted = true;
    }
    Keys.onReleased: (event)=> {
        //console.log("KeyHandler - Key released: " + event.key)
        handleKeyReleased(event);
        event.accepted = true;
    }

    function togglePauseGame() {
        GameEngine.togglePaused();
        gamePaused = GameEngine.paused();
        console.log("KeyHandler - Pause: " + gamePaused)
    }

    function handleKeyPressed(event) {
        if (event.key === Qt.Key_P && !event.isAutoRepeat) {
            togglePauseGame();
        }
        if (event.key === Qt.Key_Left) {
            GameEngine.rotateLeft(true);
        }
        if (event.key === Qt.Key_Right) {
            GameEngine.rotateRight(true);
        }
        if (event.key === Qt.Key_Up) {
            GameEngine.requestThrust(true);
        }
        if (event.key === Qt.Key_Space && !event.isAutoRepeat) {
            GameEngine.requestShoot();
        }
        if (event.key === Qt.Key_Down && !event.isAutoRepeat) {
            console.log("KeyHandler - Hyperjump request")
            GameEngine.requestHyperjump();
        }
        if (event.key === Qt.Key_Shift && !event.isAutoRepeat) {
            console.log("KeyHandler - Ulti request")
            ultiActivationRequest();
        }
    }
    function handleKeyReleased(event) {
        if (event.key === Qt.Key_Left) {
            GameEngine.rotateLeft(false);
        }
        if (event.key === Qt.Key_Right) {
            GameEngine.rotateRight(false);
        }
        if (event.key === Qt.Key_Up) {
            GameEngine.requestThrust(false);
        }
    }
}
