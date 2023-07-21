import QtQuick
import QtQuick.Controls

Item {
    id: control
    readonly property string gameOverText: "Game Over"
    readonly property var gameOverParts: [
        {s:"G", pos:0},{s:"a", pos:1},{s:"m", pos:2},{s:"e ", pos:3},
        {s:"O", pos:5},{s:"v", pos:6},{s:"e", pos:7},{s:"r", pos:8}]
    readonly property int timeoutMs: 10000
    visible: false

    signal gameOverScreenClosed

    // Close the splashscreen and emit the signal
    function closeGameOverScreen()
    {
        console.log("Game Over closed...")
        control.visible = false
        gameOverScreenClosed();
    }
    function showGameOverScreen()
    {
        console.log("Game Over opened...")
        control.visible = true;
        internal.currentCharIndex = 0;
        timerId.restart();
        //timerCharId.restart();
    }

    QtObject {
        id: internal
        property int currentCharIndex: 0
        readonly property int numChars: gameOverText.length
        readonly property int numParts: gameOverParts.length
        property string displayText: ""
        property real gameAreaWidth: control.width
        property real gameAreaHeight: control.height
        property real letterWidth: textMeasurementId.contentWidth/numChars
        property real messageWidth: textMeasurementId.contentWidth
    }

    FontLoader {
        id: fontResource
        source: "Fonts/Vectorb.ttf"
    }

    Text {
        id: textMeasurementId
        font.family: fontResource.font.family
        font.weight: 1000 // 400 default (range 1 to 1000)
        //font.letterSpacing:
        font.pixelSize: 80
        anchors.centerIn: parent
        text: gameOverText
        color: "yellow"
        visible: false
    }

    //Text {
    //    id: textId
    //    font.family: fontResource.font.family
    //    font.weight: 1000 // 400 default (range 1 to 1000)
    //    //font.letterSpacing:
    //    font.pixelSize: 80
    //    anchors.centerIn: parent
    //    text: internal.displayText
    //    color: "yellow"
    //}

    Repeater {
        id: flyingText
        model: control.visible ? internal.numParts : 0
        Text {
            id: textLetter

            property int letterIndex: index
            property string letter: gameOverParts[index].s
            property real letterPos: gameOverParts[index].pos * internal.letterWidth
            property real textXoffsetAnim: 100
            property real textYoffsetAnim: 100

            x: textXoffsetAnim/100 * internal.gameAreaWidth
               + internal.gameAreaWidth/2 - internal.messageWidth/2 + letterPos
            y: internal.gameAreaHeight/2 - 80
               + textYoffsetAnim/100 * internal.gameAreaHeight

            font.family: fontResource.font.family
            font.weight: 1000 // 400 default (range 1 to 1000)
            //font.letterSpacing:
            font.pixelSize: 80
            text: letter
            color: "yellow"

            state: "init"
            states: [
                State {
                    name: "init"
                },
                State {
                    name: "flyin"
                }
            ]
            transitions: [
                Transition {
                    to: "flyin"
                    SequentialAnimation {
                        PauseAnimation {
                            duration: index * 200
                        }
                        ParallelAnimation {
                            PropertyAnimation {
                                target: textLetter
                                properties: "textXoffsetAnim"
                                duration: 1200
                                easing.type: Easing.Linear
                                from: 100
                                to: 0
                            }
                            PropertyAnimation {
                                target: textLetter
                                properties: "textYoffsetAnim"
                                duration: 1200
                                easing.type: Easing.OutBounce
                                from: 100
                                to: 0
                            }
                        }
                        PauseAnimation {
                            duration: 3000
                        }
                        PropertyAnimation {
                            target: textLetter
                            properties: "textXoffsetAnim,textYoffsetAnim"
                            duration: 600
                            easing.type: Easing.Linear
                            from: 0
                            to: -100
                        }
                    }
                }
            ]
            Component.onCompleted: {
                console.log(letter + " - init state: " + state + " index: " + index)
                letterIndex = index
                state = "flyin";
            }
        }
    }

    Timer {
        id: timerId
        interval: timeoutMs
        running: false
        repeat: false
        onTriggered: {
            closeGameOverScreen();
        }
    }

//    Timer {
//        id: timerCharId
//        interval: 250
//        running: false
//        repeat: true
//        onTriggered: {
//            if (internal.currentCharIndex < internal.numChars)
//            {
//                internal.currentCharIndex++;
//                internal.displayText = gameOverText.substring(0,internal.currentCharIndex)
//            }
//            else
//            {
//                running = false;
//            }
//        }
//    }
}
