pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

Item {
    id: control
    visible: false

    signal gameOverScreenClosed

    // Close the splashscreen and emit the signal
    function closeGameOverScreen()
    {
        console.log("Game Over closed...")
        control.visible = false
        control.gameOverScreenClosed();
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
        readonly property string gameOverText: "Game Over"
        readonly property var gameOverParts: [
            {s:"G", pos:0},{s:"a", pos:1},{s:"m", pos:2},{s:"e ", pos:3},
            {s:"O", pos:5},{s:"v", pos:6},{s:"e", pos:7},{s:"r", pos:8}]
        readonly property int timeoutMs: 15000
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
        text: internal.gameOverText
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
            required property int index
            property int letterIndex: index
            property string letter: internal.gameOverParts[index].s
            property real letterPos: internal.gameOverParts[index].pos * internal.letterWidth
            property point startPos: Qt.point(internal.gameAreaWidth, 0)
            property point middlePos: Qt.point(internal.gameAreaWidth/2 - internal.messageWidth/2 + letterPos, internal.gameAreaHeight/2 - 80)
            property point endPos: Qt.point(0 - internal.letterWidth, 0)
            property real flyAwayAngle: Math.random() * 360.0
            property real flyAwayTime: 3000 + Math.random() * 2000
            x: textLetter.endPos.x
            y: textLetter.endPos.y
            font.family: fontResource.font.family
            font.weight: 1000 // 400 default (range 1 to 1000)
            //font.letterSpacing:
            font.pixelSize: 80
            text: textLetter.letter
            color: "yellow"

            state: "init"
            states: [
                State {
                    name: "init"
                    PropertyChanges {
                        textLetter.x: textLetter.startPos.x
                        textLetter.y: textLetter.startPos.y
                    }
                },
                State {
                    name: "flyin"
                    PropertyChanges {
                        textLetter.x: textLetter.middlePos.x
                        textLetter.y: textLetter.middlePos.y
                    }
                },
                State {
                    name: "flyout"
                    PropertyChanges {
                        textLetter.x: textLetter.endPos.x
                        textLetter.y: textLetter.endPos.y
                    }
                }
            ]
            transitions: [
                Transition {
                    to: "flyin"
                    SequentialAnimation {
                        PauseAnimation {
                            duration: 2000 + textLetter.letterIndex * 100
                        }
                        ScriptAction {
                            script: {
                                console.log(textLetter.letter + " - Starting gameover flying anim: ", textLetter.startPos.toString(), textLetter.middlePos.toString(), textLetter.endPos.toString())
                            }
                        }
                        ParallelAnimation {
                            PropertyAnimation {
                                id: animFlyinX
                                target: textLetter
                                properties: "x"
                                duration: 1200
                                easing.type: Easing.Linear
                                from: textLetter.startPos.x
                                to: textLetter.middlePos.x
                            }
                            PropertyAnimation {
                                target: textLetter
                                properties: "y"
                                duration: 1200
                                easing.type: Easing.OutBounce
                                from: textLetter.startPos.y
                                to: textLetter.middlePos.y
                            }
                        }
                    }
                },
                Transition {
                    to: "flyout"
                    ScriptAction {
                        script: {
                            console.log(textLetter.letter + " - Starting gameover flyout angle/time: " + textLetter.flyAwayAngle, textLetter.flyAwayTime)
                        }
                    }
                    ParallelAnimation {
                        PropertyAnimation {
                            target: textLetter
                            properties: "x"
                            duration: textLetter.flyAwayTime
                            easing.type: Easing.OutQuad
                            from: textLetter.middlePos.x
                            to: textLetter.middlePos.x + internal.gameAreaWidth * Math.cos(textLetter.flyAwayAngle * 2*Math.PI / 360.0)
                        }
                        PropertyAnimation {
                            target: textLetter
                            properties: "y"
                            duration: textLetter.flyAwayTime
                            easing.type: Easing.OutQuad
                            from: textLetter.middlePos.y
                            to: textLetter.middlePos.y - internal.gameAreaWidth * Math.sin(textLetter.flyAwayAngle * 2*Math.PI / 360.0)
                        }
                        RotationAnimation {
                            target: textLetter
                            duration: textLetter.flyAwayTime
                            from: 0
                            to: Math.random() > 0.5 ? 720 : -720
                        }
                    }
                }
            ]
            Timer {
                id: timerHalfId
                interval: internal.timeoutMs/2
                running: false
                repeat: false
                onTriggered: {
                    textLetter.state = "flyout";
                }
            }

            Component.onCompleted: {
                console.log(letter + " - init state: " + state + " index: " + index)
                textLetter.letterIndex = index;
                state = "flyin";

                // Ensure flyout is synchronous for all letters
                timerHalfId.start();
            }
        }
    }

    Timer {
        id: timerId
        interval: internal.timeoutMs
        running: false
        repeat: false
        onTriggered: {
            control.closeGameOverScreen();
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
//                internal.displayText = internal.gameOverText.substring(0,internal.currentCharIndex)
//            }
//            else
//            {
//                running = false;
//            }
//        }
//    }
}
