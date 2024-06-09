import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: toolBar
    implicitWidth: 500
    implicitHeight: rowId.implicitHeight

    property color color: "yellow"
    property int textPixelSize: 24
    property real margins: 10

    signal newGameRequest;
    signal pauseGameRequest;

    function updateGameStatus(gameover: bool, pause: bool, level: int, lives: int, score: int)
    {
        scoreText.text = "Score: " + score;
        gameOverText.visible = gameover;
        gameLevelText.text = (pause ? "PAUSE " : " ") + "Level: " + level + " - Lives : " + lives;
        pauseButton.text = pause ? "Continue":"Pause";
        aboutQt.visible = pause; // reviel the button only when paused
    }

    Rectangle {
        id: background
        color: "black"
        anchors.fill: parent
    }

    FontLoader {
        id: fontResource
        source: "Fonts/Vectorb.ttf"
    }

    RowLayout
    {
        id: rowId
        spacing: 10
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter

        MenuButton {
            id: exitButton
            Layout.margins: toolBar.margins
            text: "Exit"
            font.pixelSize: toolBar.textPixelSize
            color: toolBar.color
            onClicked: Qt.quit();
        }

        MenuButton {
            id: newGameButton
            Layout.margins: toolBar.margins
            text: "New Game"
            font.pixelSize: toolBar.textPixelSize
            color: toolBar.color
            onClicked: {
                console.log("New game requested")
                toolBar.newGameRequest();
            }
        }
        MenuButton {
            id: pauseButton
            Layout.margins: toolBar.margins
            text: "Pause"
            font.pixelSize: toolBar.textPixelSize
            color: toolBar.color
            onClicked: {
                console.log("Pause requested")
                toolBar.pauseGameRequest();
            }
        }

        Item {
            // spacer
            Layout.fillWidth: true
        }

        Text {
            id: gameOverText
            Layout.margins: toolBar.margins
            text: "GAME OVER"
            visible: false
            color: toolBar.color
            font.family: fontResource.font.family
            font.letterSpacing: 2
            font.weight: 1000 // 400 default (range 1 to 1000)
            font.pixelSize: toolBar.textPixelSize
        }
        Text {
            id: gameLevelText
            Layout.margins: toolBar.margins
            text: "Wave: "
            visible: !gameOverText.visible
            color: toolBar.color
            font.family: fontResource.font.family
            font.letterSpacing: 2
            font.weight: 1000 // 400 default (range 1 to 1000)
            font.pixelSize: toolBar.textPixelSize
        }

        Item {
            // spacer
            Layout.fillWidth: true
        }

        Text {
            id: scoreText
            Layout.margins: toolBar.margins
            text: "Score: "
            color: toolBar.color
            font.family: fontResource.font.family
            font.letterSpacing: 2
            font.weight: 1000 // 400 default (range 1 to 1000)
            font.pixelSize: toolBar.textPixelSize
        }

        MenuButton {
            id: aboutQt
            Layout.margins: toolBar.margins
            text: "Qt"
            visible: false
            color: toolBar.color
            Layout.rightMargin: 10
            font.family: fontResource.font.family
            font.weight: 1000 // 400 default (range 1 to 1000)
            font.pixelSize: toolBar.textPixelSize
            onClicked: Qt.openUrlExternally("https://www.qt.io/licensing/");
        }
    }
}
