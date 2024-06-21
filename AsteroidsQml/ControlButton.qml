import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Item {
    id: control

    property alias icon: contentIcon
    property color color: "orange"

    implicitWidth: contentButton.implicitWidth
    implicitHeight: contentButton.implicitHeight

    signal pressed
    signal released

    Rectangle
    {
        id: contentButton
        anchors.fill: parent
        implicitWidth: 140
        implicitHeight: 140
        radius: width/2
        border.color: control.color
        border.width: 1
        color: "transparent"

        Image {
            id: contentIcon
            width: 96
            height: 96
            anchors.centerIn: parent
            antialiasing: true
        }
        ColorOverlay{
            anchors.fill: contentIcon
            source:contentIcon
            color: control.color
            antialiasing: true
        }

        PointHandler {
            margin: -20
            onActiveChanged: {
                if (active) {
                    // console.log("Control Button - pressed")
                    control.pressed()
                } else {
                    // console.log("Control Button - released")
                    control.released()
                }
            }
        }

    }
}
