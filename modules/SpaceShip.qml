import QtQuick
import QtQml

SpaceObject {

    id: spaceShip

    property real shipTurnSpeed: 0.5    // full turns per second
    property real shipAcceleration: 1000.0
    property bool shipThrust: false

    onShipThrustChanged: doRedraw()

    objectType: "spaceShip"
    objectSizePixel: 40
    objectColor: "silver"

    // Function is overwritten from base
    function copyDynamicProperties(target)
    {
        copyDynamicPropertiesBase(target);
        target.shipThrust = shipThrust;
    }

    // Specific object drawing after translation to center and rotation has occured
    // Save and restore of drawing context is done before and after this call
    // line coloring and width is already set
    onDrawObjectSignal: (ctx)=> {

        // Ship
        ctx.beginPath();
        ctx.moveTo(0, -objectSizePixel/2);
        ctx.lineTo(objectSizePixel/4,objectSizePixel/2);
        ctx.lineTo(-objectSizePixel/4,objectSizePixel/2);
        ctx.lineTo(0, -objectSizePixel/2);
        ctx.lineTo(0, -objectSizePixel/2 + objectSizePixel/10);  // Gun at front
        ctx.closePath();
        ctx.stroke();

        // Rear thrust
        if (shipThrust) {
            ctx.fillStyle = "red";
            ctx.fillRect(-10,objectSizePixel/2,20,20);
        }
    }
}
