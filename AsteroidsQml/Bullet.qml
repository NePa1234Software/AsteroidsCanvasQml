import QtQuick
import QtQml

SpaceObject {

    id: bullet

    // Specialize the object state
    objectState.objectType: "bullet"
    objectState.objectSizePixel: 2
    objectState.objectColor: "yellow"
    objectState.objectFillColor: "red"

    // Specific object drawing after translation to center and rotation has occured
    // Save and restore of drawing context is done before and after this call
    // line coloring and width is already set
    onDrawObjectSignal: (ctx)=> {

        // Bullet is just a dot (or like a lazer shot)
        ctx.fillRect(-objectState.objectSizePixel, -objectState.objectHalfWidth,
                      objectState.objectSizePixel,  objectState.objectHalfWidth);
    }

    Timer {
        id: timerId
        repeat: false
        interval: bullet.objectState.objectLifetimeMs
        running: bullet.objectState.objectLifetimeMs > 0
        onTriggered: {
            bullet.objectState.objectDestroy = true;
        }
    }
}
