import QtQuick
import QtQuick.Controls
import QtQuick.Window

Window {

    id: asteroidsGameQml

    //width: Screen.desktopAvailableWidth
    //height: Screen.desktopAvailableHeight
    visible: true
    visibility: Window.FullScreen

    // Ensure all players get the same display (1600x800)
    property real correctionFactorWidth: Screen.width / (Screen.desktopAvailableWidth+1)
    property real correctionFactorHeight: Screen.height / (Screen.desktopAvailableHeight+1)
    property real newWidth: 1600  // Phone is 873 * 2,75 = 2400 (rounded) 2.2222:1
    property real newHeight: 800  // Phone is 393 * 2,75 = 1080 (rounded)
    property real scaleWidth: Screen.width / (newWidth * correctionFactorWidth)
    property real scaleHeight: Screen.height / (newHeight * correctionFactorHeight)

    onWidthChanged: logScreenSettings()
    onHeightChanged: logScreenSettings()

    OuterSpace
    {
        id: asteroidsQml

        // Ensure the game works on all mobile device screen sizes
        // and browser windows etc
        width: asteroidsGameQml.newWidth
        height: asteroidsGameQml.newHeight
        transform: Scale {
            xScale: asteroidsGameQml.scaleWidth
            yScale: asteroidsGameQml.scaleHeight
        }
    }

    function logScreenSettings()
    {
        console.log("====== Screen size changed =======");
        console.log("Screen width:  " + Screen.width);
        console.log("Screen height: " + Screen.height);
        console.log("Screen devicePixelRatio: " + Screen.devicePixelRatio);
        console.log("Screen desktopAvailableWidth: " + Screen.desktopAvailableWidth);    // All screen - taskbar
        console.log("Screen desktopAvailableHeight:  " + Screen.desktopAvailableHeight );// All screen - taskbar
        console.log("Screen virtualX: " + Screen.virtualX);
        console.log("Screen virtualY :  " + Screen.virtualY  );
        console.log("App width:  " + asteroidsGameQml.width);
        console.log("App height: " + asteroidsGameQml.height);
        console.log("Scale width: ", asteroidsGameQml.width, asteroidsGameQml.newWidth, asteroidsGameQml.scaleWidth);
        console.log("Scale height: ", asteroidsGameQml.height, asteroidsGameQml.newHeight, asteroidsGameQml.scaleHeight);
    }

    Component.onCompleted: {
        logScreenSettings();
    }
}
