import QtQuick
import QtQuick.Controls

Item {
    id: control
    visible: false
    property alias splashText: content.text
    property int timeoutMs: 5000

    signal splashScreenClosed

    // Close the splashscreen and emit the signal
    function closeSplashScreen()
    {
        console.log("Splash closed...")
        control.visible = false
        splashScreenClosed();
    }
    function showSplashScreen()
    {
        console.log("Splash opened...")
        control.visible = true
    }

    Rectangle {
        id: splash
        anchors.centerIn: parent
        width: content.width +100
        height: content.height + 100
        radius: 50
        opacity: 0.8
        //visible: true
        color: "lightgreen"
        Text {
            id: content
            anchors.centerIn: parent
            text:
                  "<h1><b>AsteroidsCanvasQML (V 1.5) </b></h1>" +
                  "<h1><b> Author: Neil Parker</b></h1>" +
                  "<br>" +
                  "<h1>Welcome to my very first QML Game !!!</h1>\n" +
                  "<h1> This game is build purely with the QML Framework (QtQuick)</h1>" +
                  "<h1><i> Powered by the AMAZING Qt Framework</i></h1>" +
                  "<h1><i> (https://www.qt.io/)</i></h1>" +
                  "<br>" +
                  "<h2> Controls: UP to thrust, LEFT, RIGHT, SPACE to Fire</h2>" +
                  "<h2> DOWN to hyperjump, SHIFT to activate the ulti, P to pause</h2>"
            color: "black"
        }
    }
    Timer {
        interval: control.timeoutMs
        running: control.timeoutMs != 0
        triggeredOnStart: true
        repeat: false
        onTriggered: {
            control.closeSplashScreen();
        }
    }
}
