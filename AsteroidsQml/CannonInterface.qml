import QtQuick

// Interface needs to be provided by every canno to allow the game engine to handle bullet creation etc
QtObject {
    id: root

    // Maybe the cannon needs power and cannot fire
    property bool cannonPoweredUp: false

    // relative position to the ship (+ clockwise to ship centerline)
    property real r_x: 0
    property real r_y: 0
    property real r_angle: 0

    // This is used to draw the bullets etc (delegate chooser)
    property string cannonType: "bullet"

    property real cannonDamage: 1
}
