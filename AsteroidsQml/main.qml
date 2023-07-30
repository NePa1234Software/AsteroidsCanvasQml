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
    //visibility: Window.FullScreen
    //title: qsTr("Neils Asteroids QML (Canvas Based)")

    property real newWidth: 1920
    property real newHeight: 1032
    property real scaleWidth: width / newWidth
    property real scaleHeight: height / newHeight

    onWidthChanged: logScreenSettings()
    onHeightChanged: logScreenSettings()

    // ALL keyboard activity is captured here and not forwarded to any focused item
    // TODO This doesnt work - I want to receive ALL keyboard activity even w/o focus
    //Keys.onPressed: (event)=> {
    //    console.log("Window - Key pressed: " + event)
    //    asteroidsQml.handleKeyPressed(event);
    //    event.accepted = true;
    //}
    //Keys.onReleased: (event)=> {
    //    console.log("Window - Key released: " + event)
    //    asteroidsQml.handleKeyReleased(event);
    //    event.accepted = true;
    //}

    OuterSpace
    {
        id: asteroidsQml
        width: newWidth
        height: newHeight
        focus: true

        // Ensure the game works on all mobile devices
        transform: Scale {
            xScale: scaleWidth
            yScale: scaleHeight
        }

        // ALL keyboard activity is captured here and not forwarded to any focused item
        Keys.onPressed: (event)=> {
            //console.log("Key pressed: " + event)
            asteroidsQml.handleKeyPressed(event);
            event.accepted = true;
        }
        Keys.onReleased: (event)=> {
            //console.log("Key released: " + event)
            asteroidsQml.handleKeyReleased(event);
            event.accepted = true;
        }
    }

    function logScreenSettings()
    {
        console.log("====== Screen size changed =======");
        console.log("Screen width:  " + Screen.width);
        console.log("Screen height: " + Screen.height);
        console.log("Screen desktopAvailableWidth: " + Screen.desktopAvailableWidth);    // All screen - taskbar
        console.log("Screen desktopAvailableHeight:  " + Screen.desktopAvailableHeight );// All screen - taskbar
        console.log("Screen virtualX: " + Screen.virtualX);
        console.log("Screen virtualY :  " + Screen.virtualY  );
        console.log("App width:  " + asteroidsGameQml.width);
        console.log("App height: " + asteroidsGameQml.height);
        console.log("Scale width:  " + asteroidsGameQml.scaleWidth);
        console.log("Scale height: " + asteroidsGameQml.scaleHeight);
    }

    Component.onCompleted: {
        logScreenSettings();
    }
}
