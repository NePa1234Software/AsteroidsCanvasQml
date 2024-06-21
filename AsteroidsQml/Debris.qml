import QtQuick
import QtQml

SpaceObject {

    id: spaceShipDebris

    // Specialize the object state
    objectState.objectType: "debris"
    objectState.objectSizePixel: 1
    objectState.objectColor: "orange"
    objectState.objectFillColor: "red"
    objectState.objectLifetimeMs: 8000

    // Function is overwritten from base
    function copyDynamicProperties(target : Debris)
    {
        copyDynamicPropertiesBase(target);
    }

    // Specific object drawing after translation to center and rotation has occured
    // Save and restore of drawing context is done before and after this call
    // line coloring and width is already set
    onDrawObjectSignal: (ctx)=> {

        // Ship Debris
        ctx.beginPath();
        ctx.moveTo(0, -objectState.objectHalfWidth);
        ctx.lineTo(0,  objectState.objectHalfWidth);
        ctx.closePath();
        ctx.stroke();
    }

    Timer {
        id: timerId
        repeat: false
        interval: spaceShipDebris.objectState.objectLifetimeMs
        running: spaceShipDebris.objectState.objectLifetimeMs > 0
        onTriggered: {
            spaceShipDebris.objectState.objectDestroy = true;
        }
    }
}
