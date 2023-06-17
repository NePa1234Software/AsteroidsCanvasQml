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

    property int newWidth: 800
    property int newHeight: 450

    Scale {
        xScale: Screen.width / newWidth
    }

    OuterSpace
    {
        id: asteroidsQml
        anchors.fill: parent
        //width: asteroidsGameQml.newWidth
        //height: asteroidsGameQml.newHeight

        onGameOverChanged: {
            if (gameOver) {
                splash.showSplashScreen();
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
        //onSplashScreenClosed: asteroidsQml.beginGame();
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
    }
}
