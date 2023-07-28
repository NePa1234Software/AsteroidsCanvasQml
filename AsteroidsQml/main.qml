import QtQuick
import QtQuick.Controls
import QtQuick.Window

Window {

    id: asteroidsGameQml

    // Ensure all players get the same display
    // Assume 16:9 ratio
    width: Screen.width
    height: Screen.height
    visible: true
    visibility: Window.FullScreen
    //title: qsTr("Neils Asteroids QML (Canvas Based)")

    property int newWidth: 1920
    property int newHeight: 1032

    OuterSpace
    {
        id: asteroidsQml
        anchors.fill: parent
        //width: asteroidsGameQml.newWidth
        //height: asteroidsGameQml.newHeight

        //transform: Scale {
        //    xScale: Screen.width / newWidth
        //    yScale: Screen.height / newHeight
        //}

        onGameOverChanged: {
            if (gameOver) {
                gameOverText.showGameOverScreen();
            }
        }

        onNewGameStarting: {
            splash.closeSplashScreen();
        }
        Component.onCompleted: {
            initGame();
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
        console.log("Screen width:  " + Screen.width);
        console.log("Screen height: " + Screen.height);
        console.log("Screen desktopAvailableWidth: " + Screen.desktopAvailableWidth);    // All screen - taskbar
        console.log("Screen desktopAvailableHeight:  " + Screen.desktopAvailableHeight );// All screen - taskbar
        console.log("Screen virtualX: " + Screen.virtualX);
        console.log("Screen virtualY :  " + Screen.virtualY  );
        console.log("App width:  " + asteroidsGameQml.width);
        console.log("App height: " + asteroidsGameQml.height);
        //gameOverText.showGameOverScreen();
        splash.showSplashScreen();
    }
}
