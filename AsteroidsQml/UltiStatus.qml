import QtQuick

Item {
    id: root

    property int percentFull: 0
    property int chargeTimeMs: 20000
    property int dischargeTimeMs: 5000
    property int innerMargin: 2
    property bool paused: false
    onPausedChanged: console.log("Ulti: Paused")
    property bool charge: false

    readonly property bool activated: internal.activated
    readonly property bool fullyCharged: state === "FULL"
    readonly property bool fullyEmpty: root.percentFull === 0

    QtObject
    {
        id: internal
        property bool activated: false
        property int  textXoffset: 0
    }

    onFullyEmptyChanged: {
        if (fullyEmpty) internal.activated = false;
    }

    onActivatedChanged: console.log("Ulti: activation changed :" + activated)
    onChargeChanged: console.log("Ulti: charge status :" + charge)

    implicitHeight: 50
    implicitWidth: 200
    state: "EMPTY"
    onStateChanged: console.log("Ulti: state changed :" + state)

    function activateUlti()
    {
        if (!root.fullyCharged) return;
        if (root.paused) return;
        internal.activated = true;
    }

    Rectangle
    {
        id: border
        anchors.fill: parent
        border.color: "lightblue"
        border.width: 2
        color: "transparent"
        opacity: 0.5

        Text {
            id: statusText
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: internal.textXoffset
            font.pixelSize: 24
            font.bold: root.fullyCharged
            color: "yellow"
            text: root.state
            visible: true
        }

        Rectangle
        {
            id: fillRect
            anchors.left: border.left
            anchors.leftMargin: root.innerMargin
            anchors.verticalCenter: border.verticalCenter
            width: Math.max(10, (border.width - (2 * root.innerMargin)) * root.percentFull / 100)
            height: border.height - (2 * root.innerMargin)
            opacity: 0.7
            color: "red"
        }
    }

    states: [
        State {
            name: "PAUSED"
            when: root.paused
            PropertyChanges { target: fillRect; color: "transparent"}
            PropertyChanges { target: root; percentFull: 0}
        },
        State {
            name: "CHARGING"
            when: root.charge && !root.activated && (root.percentFull < 100)
            PropertyChanges { target: fillRect; color: "yellow"}
        },
        State {
            name: "EMPTY"
            when: root.percentFull == 0
            PropertyChanges { target: fillRect; color: "red"}
        },
        State {
            name: "DISCHARGING"
            when: !root.charge
            PropertyChanges { target: fillRect; color: "yellow"}
        },
        State {
            name: "FULL"
            when: root.charge && !root.activated && (root.percentFull == 100)
            PropertyChanges { target: fillRect; color: "green"}
        },
        State {
            name: "ACTIVATED"
            when: root.charge && root.activated && (root.percentFull > 0)
            PropertyChanges { target: fillRect; color: "orange"}
        }
    ]
    transitions: [
        Transition {
            to: "CHARGING"
            NumberAnimation {
                target: root
                properties: "percentFull"
                duration: root.chargeTimeMs
                to: 100
            }
        },
        Transition {
            to: "DISCHARGING"
            NumberAnimation {
                target: root
                properties: "percentFull"
                duration: root.dischargeTimeMs
                to: 0
            }
        },
        Transition {
            to: "ACTIVATED"
            NumberAnimation {
                target: root
                properties: "percentFull"
                duration: root.dischargeTimeMs
                to: 0
            }
            PropertyAnimation {
                target: statusText
                property: "opacity"
                duration: 500
                from: 0
                to: 1
                loops: Animation.Infinite
            }
        },
        Transition {
            to: "PAUSED"
            SequentialAnimation {
                loops: Animation.Infinite
                PropertyAnimation {
                    target: internal
                    property: "textXoffset"
                    duration: 500
                    from: -10
                    to: 10
                    easing: Easing.InOutQuad
                }
                PropertyAnimation {
                    target: internal
                    property: "textXoffset"
                    duration: 500
                    from: 10
                    to: -10
                    easing: Easing.InOutQuad
                }
            }
        }
    ]
}
