import QtQuick
import QtQml

SpaceObject {

    id: spaceShip

    readonly property real shipTurnSpeed: 0.5    // full turns per second
    readonly property real shipAcceleration: 1000.0
    property bool shipThrust: false

    property bool ultiActivated: false
    property string ultiType: "bigcannons"

    property WeaponInterface weapons: weaponImplBasic
    property WeaponInterface weaponsUlti: ultiCannons.weapons

    onShipThrustChanged: doRedraw()

    // Specialization of base object
    objectState.objectType: "spaceShip"
    objectState.objectSizePixel: 40
    objectState.objectColor: "white"
    objectState.objectFillColor: "lightgrey"

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

        var h = objectState.objectHalfWidth;
        var w = h/2;
        var r = 2;
        var j = 2;

        ctx.globalCompositeOperation = "copy";

        // Rear thrust
        if (shipThrust) {
            ctx.fillStyle = "red";
            ctx.fillRect(-10,h-10,20,20);
        }

        // Ship
        ctx.fillStyle = objectState.objectFillColor;
        ctx.beginPath();
        ctx.moveTo(0,-h);
        ctx.lineTo(w,h-j);
        ctx.arcTo(w,h, w-j,h, r);
        ctx.lineTo(w-j, h);
        ctx.arcTo(0,h-j, -w+j,h, r);
        ctx.lineTo(-w+j,h);
        ctx.arcTo(-w,h, -w,h-j, r);
        ctx.lineTo(-w,h-j);
        ctx.closePath();
        ctx.stroke();
        ctx.fill();

        // Windows
        ctx.clearRect(-3,  3, 6, 6);
        ctx.clearRect(-3, 10, 6, 6);

        // Canon
        ctx.clearRect(-3,-h-6, 6, h+1);
        ctx.fillRect(-2,-h-5, 4,h);
        //ctx.strokeRect(-3,-h-6, 6,h+1);
    }

    // This is an object needed by the game engine to fire bullets
    WeaponInterface
    {
        id: weaponImplBasic
        weaponType: "basic"
        cannonList: [
            CannonInterface {
                r_y: -spaceShip.objectState.objectHalfWidth
                cannonDamage: 1
                cannonPoweredUp: true
            }
        ]
    }

    // TODO - make this a loader, depending on the Ulti type (when we have more than 1)
    UltiCannons
    {
        id: ultiCannons
        objectState.objectPosX: spaceShip.objectState.objectPosX
        objectState.objectPosY: spaceShip.objectState.objectPosY
        objectState.objectBearing: spaceShip.objectState.objectBearing
        objectState.objectHidden: spaceShip.objectState.objectHidden || !spaceShip.ultiActivated
        ultiActivated: spaceShip.ultiActivated
        z: spaceShip.z - 1
    }
}
