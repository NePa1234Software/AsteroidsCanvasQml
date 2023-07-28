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
    signal pauseGameRequest;

    function updateGameStatus(gameover: bool, pause: bool, level: int, lives: int, score: int)
    {
        scoreText.text = "Score: " + score;
        gameOverText.visible = gameover;
        gameLevelText.text = (pause ? "PAUSE " : " ") + "Level: " + level + " - Lives remaining : " + lives;
        pauseButton.text = pause ? "Continue":"Pause";
        aboutQt.visible = pause; // reviel the button only when paused
    }

    RowLayout
    {
        spacing: 10
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter

        Button {
            id: exitButton

            Layout.leftMargin: 10
            Layout.rightMargin: 10

            text: "Exit"
            font.pixelSize: toolBar.textPixelSize
            onClicked: Qt.quit();
        }

        Button {
            id: newGameButton
            text: "New Game"
            font.pixelSize: toolBar.textPixelSize
            onClicked: {
                console.log("New game requested")
                newGameRequest();
            }
        }
        Button {
            id: pauseButton
            text: "Pause"
            font.pixelSize: toolBar.textPixelSize
            onClicked: {
                console.log("Pause requested")
                pauseGameRequest();
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
            visible: false
            Layout.rightMargin: 10
            font.pixelSize: toolBar.textPixelSize
            onClicked: Qt.openUrlExternally("https://www.qt.io/licensing/");
        }
    }
}
