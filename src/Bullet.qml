import QtQuick
import QtQml

SpaceObject {

    id: bullet

    // Override the object image
    objectType: "bullet"
    objectSizePixel: 2
    objectColor: "yellow"

    property int bulletSpeed: 1000

    // Specific object drawing after translation to center and rotation has occured
    // Save and restore of drawing context is done before and after this call
    // line coloring and width is already set
    onDrawObjectSignal: (ctx)=> {

        // Bullet is just a dot (or like a lazer shot)
        ctx.fillRect(-objectSizePixel, -objectSizePixel * objectSizeMultiplier / 2,
                      objectSizePixel,  objectSizePixel * objectSizeMultiplier / 2);
    }

    Timer {
        id: timerId
        repeat: false
        interval: bullet.objectLifetimeMs
        running: bullet.objectLifetimeMs > 0
        onTriggered: {
            bullet.objectDestroy = true;
        }
    }
}
