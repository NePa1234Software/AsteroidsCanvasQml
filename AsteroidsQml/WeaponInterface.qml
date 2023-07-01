import QtQuick

// Interface needs to be provided by every weapon to allow the game engine to handle bullet creation etc
// using the propert weapons
QtObject {
    id: root

    // relative position to the ship
    property real r_x: 0
    property real r_y: 0
    property real r_angle: 0

    // This is used to draw the weapon (delegate chooser)
    property string weaponType: "basiccannon"

    // Cannon information should be overwritten
    property list<CannonInterface> cannonList
}
