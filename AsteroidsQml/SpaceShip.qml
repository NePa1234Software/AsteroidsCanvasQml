import QtQuick
import QtQml

SpaceObject {

    id: spaceShip

    readonly property real shipTurnSpeed: 0.5    // full turns per second
    readonly property real shipAcceleration: 1000.0
    property bool shipThrust: false
    property bool ultiActivated: false
    property string ultiType: "bigcannons"

    property WeaponInterface weapons: ultiActivated ? weaponImplUlti : weaponImplBasic

    onShipThrustChanged: doRedraw()

    // Specialization of base object
    objectState.objectType: "spaceShip"
    objectState.objectSizePixel: 40
    objectState.objectColor: "white"
    objectState.objectFillColor: "grey"

    // Function is overwritten from base
    function copyDynamicProperties(target)
    {
        copyDynamicPropertiesBase(target);
        target.shipThrust = shipThrust;
        target.ultiActivated = ultiActivated;
        target.ultiType = ultiType;
    }

    // Specific object drawing after translation to center and rotation has occured
    // Save and restore of drawing context is done before and after this call
    // line coloring and width is already set
    onDrawObjectSignal: (ctx)=> {

        var k = objectState.objectHalfWidth;

        // Ship
        ctx.beginPath();
        ctx.moveTo(0, -k);
        ctx.lineTo(k/2, k);
        ctx.lineTo(-k/2, k);
        ctx.lineTo(0, -k);
        ctx.lineTo(0, -k + k/5);  // Mini cannon at front
        ctx.closePath();
        ctx.stroke();

        // Rear thrust
        if (shipThrust) {
            ctx.fillStyle = "red";
            ctx.fillRect(-10,k,20,20);
        }
    }

    // This is an object needed by the game engine to fire bullets
    WeaponInterface
    {
        id: weaponImplBasic
        weaponType: "basic"
        cannonList: [
            CannonInterface {
                r_y: -objectState.objectHalfWidth
                cannonDamage: 1
                cannonPoweredUp: true
            }
        ]
    }
    WeaponInterface
    {
        id: weaponImplUlti
        weaponType: "ulticannon"
        cannonList: [
            CannonInterface {
                r_y: -objectState.objectHalfWidth
                cannonDamage: 1
                cannonPoweredUp: true
            },
            CannonInterface {
                r_y: 0
                r_x: objectState.objectHalfWidth/2
                r_angle: 5
                cannonDamage: 2
                cannonPoweredUp: ultiActivated
            },
            CannonInterface {
                r_y: 0
                r_x: -objectState.objectHalfWidth/2
                r_angle: -5
                cannonDamage: 2
                cannonPoweredUp: ultiActivated
            },
            CannonInterface {
                r_y: objectState.objectHalfWidth
                r_x: objectState.objectHalfWidth/2
                r_angle: 175
                cannonDamage: 1
                cannonPoweredUp: ultiActivated
            },
            CannonInterface {
                r_y: objectState.objectHalfWidth
                r_x: -objectState.objectHalfWidth/2
                r_angle: 185
                cannonDamage: 2
                cannonPoweredUp: ultiActivated
            }
        ]
    }
}
