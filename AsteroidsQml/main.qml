import QtQuick
import QtQuick.Controls
import QtQuick.Window

Window {

    id: asteroidsGameQml

    width: Screen.width
    height: Screen.height
    visible: true
    visibility: Window.FullScreen

    // Ensure all players get the same display
    // Assume 16:9 ratio for now
    property real newWidth: 1920
    property real newHeight: 1032
    property real scaleWidth: width / newWidth
    property real scaleHeight: height / newHeight

    onWidthChanged: logScreenSettings()
    onHeightChanged: logScreenSettings()

    OuterSpace
    {
        id: asteroidsQml

        // Ensure the game works on all mobile device screen sizes
        // and browser windows etc
        width: newWidth
        height: newHeight
        transform: Scale {
            xScale: scaleWidth
            yScale: scaleHeight
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
