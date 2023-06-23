import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: toolBar
    implicitWidth: 500
    implicitHeight: 84
    color: activePalette.window

    property int textPixelSize: 46

    SystemPalette { id: activePalette }

    signal newGameRequest;

    function updateGameStatus(gameover: bool, pause: bool, level: int, lives: int, score: int)
    {
        scoreText.text = "Score: " + score;
        gameOverText.visible = gameover;
        gameLevelText.text = (pause ? "PAUSE " : " ") + "Level: " + level + " - Lives remaining : " + lives;
    }

    RowLayout
    {
        spacing: 10
        width: parent.width

        Button {
            id: exitButton
            Layout.leftMargin: 10
            text: "Exit"
            font.pixelSize: toolBar.textPixelSize
            onClicked: Qt.quit();
        }

        Button {
            text: "New Game"
            font.pixelSize: toolBar.textPixelSize
            onClicked: {
                console.log("New game requested")
                newGameRequest();
            }
        }

        Item {
            // spacer
            Layout.fillWidth: true
        }

        Text {
            id: gameOverText
            text: "GAME OVER"
            visible: false
            font.pixelSize: toolBar.textPixelSize
        }
        Text {
            id: gameLevelText
            text: "Wave: "
            visible: !gameOverText.visible
            font.pixelSize: toolBar.textPixelSize
        }

        Item {
            // spacer
            Layout.fillWidth: true
        }

        Text {
            id: scoreText
            text: "Score: "
            font.pixelSize: toolBar.textPixelSize
        }

        Button {
            id: aboutQt
            text: "Qt"
            Layout.rightMargin: 10
            font.pixelSize: toolBar.textPixelSize
            onClicked: Qt.openUrlExternally("https://www.qt.io/licensing/");
        }
    }
}
