import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Item {
    id: control

    property alias text: contentText.text
    property alias font: contentText.font
    property color color: "yellow"
    property real margins: 10

    implicitWidth: contentButton.implicitWidth
    implicitHeight: contentButton.implicitHeight

    signal pressed
    signal released
    signal clicked

    Rectangle
    {
        id: contentButton
        implicitWidth: contentText.contentWidth + 2 * control.margins
        implicitHeight: contentText.contentHeight + 2 * control.margins
        radius: control.margins
        border.color: control.color
        border.width: 2
        color: "transparent"

        FontLoader {
            id: fontResource
            source: "Fonts/Vectorb.ttf"
        }

        Text {
            id: contentText
            font.family: fontResource.font.family
            font.weight: 1000 // 400 default (range 1 to 1000)
            font.letterSpacing: 1
            font.pixelSize: 24
            anchors.centerIn: parent
            color: control.color
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent

            onPressed: {
                control.pressed()
            }
            onReleased: {
                control.released()
                control.clicked()
            }
        }
    }
}
