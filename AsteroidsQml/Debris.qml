import QtQuick
import QtQml

SpaceObject {

    id: spaceShipDebris

    // Override the object image
    //objectImage: objectImageShip
    objectType: "alienShip"
    objectSizePixel: 1
    objectColor: "orange"
    objectLifetimeMs: 8000
    objectHidden: false

    // Function is overwritten from base
    function copyDynamicProperties(target)
    {
        copyDynamicPropertiesBase(target);
    }

    // Specific object drawing after translation to center and rotation has occured
    // Save and restore of drawing context is done before and after this call
    // line coloring and width is already set
    onDrawObjectSignal: (ctx)=> {

        // Ship Debris
        ctx.beginPath();
        ctx.moveTo(0, -objectSizePixel * objectSizeMultiplier / 2);
        ctx.lineTo(0,  objectSizePixel * objectSizeMultiplier / 2);
        ctx.closePath();
        ctx.stroke();
    }

    Timer {
        id: timerId
        repeat: false
        interval: spaceShipDebris.objectLifetimeMs
        running: spaceShipDebris.objectLifetimeMs > 0
        onTriggered: {
            spaceShipDebris.objectDestroy = true;
        }
    }
}
