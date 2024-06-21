import QtQuick

FocusScope {
    id: keyHandler

    property bool gamePaused: false

    signal ultiActivationRequest

    QtObject {
        id: internal
        // because isAutoRepeat doesnt work for wasm multi-threaded )-: !!
        property bool requestShoot: false
    }

    focus: true
    // onActiveFocusChanged: console.log("KeyHandler activeFocus changed ! : " + activeFocus)

    // ALL keyboard activity is captured here and not forwarded to any focused item
    Keys.onPressed: (event)=> {
        // console.log("KeyHandler - Key pressed: " + event.key, event.isAutoRepeat )
        handleKeyPressed(event);
        event.accepted = true;
    }
    Keys.onReleased: (event)=> {
        // console.log("KeyHandler - Key released: " + event.key, event.isAutoRepeat)
        handleKeyReleased(event);
        event.accepted = true;
    }

    function togglePauseGame() {
        GameEngine.togglePaused();
        gamePaused = GameEngine.paused();
        console.log("KeyHandler - Pause: " + gamePaused)
    }

    function handleKeyPressed(event) {
        if (event.key === Qt.Key_Left) {
            GameEngine.rotateLeft(true);
        }
        if (event.key === Qt.Key_Right) {
            GameEngine.rotateRight(true);
        }
        if (event.key === Qt.Key_Up) {
            GameEngine.requestThrust(true);
        }

        // NOTE this doesnt work for wasm multi-threaded )-: !!
        if(event.isAutoRepeat) return;

        if (event.key === Qt.Key_P) {
            togglePauseGame();
        }
        if (event.key === Qt.Key_Space && !internal.requestShoot) {
            GameEngine.requestShoot();
            internal.requestShoot = true;
        }
        if (event.key === Qt.Key_Down) {
            // console.log("KeyHandler - Hyperjump request")
            GameEngine.requestHyperjump();
        }
        if (event.key === Qt.Key_Shift) {
            // console.log("KeyHandler - Ulti request")
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

        if (event.key === Qt.Key_Space) {
            internal.requestShoot = false;
        }
    }
    Component.onCompleted: {
        // console.log("KeyHandler activeFocus init ! : " + activeFocus)
        forceActiveFocus();
        // console.log("KeyHandler activeFocus init2 ! : " + activeFocus)
    }
}
