import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Item {
    id: control

    property alias text: contentText.text
    property alias font: contentText.font
    property color color: "yellow"
    property real margins: 12

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
        border.width: 3
        color: "transparent"
        onActiveFocusChanged: console.log("MenuButton activeFocus changed ! : " + activeFocus)

        FontLoader {
            id: fontResource
            source: "Fonts/Vectorb.ttf"
        }

        Text {
            id: contentText
            font.family: fontResource.font.family
            font.weight: 1000 // 400 default (range 1 to 1000)
            font.letterSpacing: 1
            font.pixelSize: 48
            anchors.centerIn: parent
            color: control.color
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent

            onPressed: {
                // console.log("Menu Button - pressed")
                control.pressed()
            }
            onReleased: {
                // console.log("Menu Button - released")
                control.released()
                control.clicked()
            }
        }
    }
}
