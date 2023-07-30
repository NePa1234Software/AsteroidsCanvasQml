import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Item {
    id: control

    property alias icon: contentIcon
    property color color: "yellow"

    implicitWidth: contentButton.implicitWidth
    implicitHeight: contentButton.implicitHeight

    signal pressed
    signal released

    Rectangle
    {
        id: contentButton
        implicitWidth: 120
        implicitHeight: 120
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

        MouseArea {
            id: mouseArea
            anchors.fill: parent

            onPressed: {
                control.pressed()
            }
            onReleased: {
                control.released()
            }
        }
    }
}
