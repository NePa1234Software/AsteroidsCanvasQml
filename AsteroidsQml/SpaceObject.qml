import QtQuick
import QtQml

Item {
    id: object

    // Common states for all object
    property alias objectState: objectStateBase

    visible: !objectState.objectHidden

    // Base canvas object can be read but not overwritten
    readonly property alias objectImage: objectImageBase

    // Implement this to draw the specific object
    // Save and restore of drawing context is done before and after this call
    // line coloring and width is already set
    signal drawObjectSignal(var ctx);

    // Called after object creation - overwritten by specialized object
    function doInit() {
        doInitBase();
    }

    function doInitBase() {
        objectState.objectInitialised = true;
    }

    // Called after doInit and when a redraw is to be forced
    function doRedraw() {
        objectImageBase.requestPaint()
    }

    // This is called just once to clone the object
    function copyInitialProperties(target)
    {
        copyInitialPropertiesBase(target);
    }

    function copyInitialPropertiesBase(target)
    {
        object.objectState.copyInitialStateProperties(target.objectState)
    }

    // This is called to clone the dynamic properties that change during game
    // overwrite this fpr specific properties
    function copyDynamicProperties(target)
    {
        object.objectState.copySpeedBearingStateProperties(target.objectState);
    }
    function copyDynamicPropertiesBase(target)
    {
        object.objectState.copySpeedBearingStateProperties(target.objectState)
    }

    ObjectState { id: objectStateBase }

    // The image needs to be drawn specifically using the onDrawObjectSignal
    Canvas {
        id: objectImageBase
        rotation: objectState.objectBearing
        scale: objectState.objectScale
        visible: true // objectType === "base"
        width:  (objectState.objectSizePixelMultiplied) * 2
        height: (objectState.objectSizePixelMultiplied) * 2
        x: objectState.objectPosX - (objectState.objectSizePixelMultiplied)
        y: objectState.objectPosY - (objectState.objectSizePixelMultiplied)
        antialiasing: true

        onPaint: {
            if (!objectState.objectInitialised) {
                doInit();
            }

            //console.log("onPaint called")
            var ctx = getContext('2d');

            ctx.save();
            ctx.clearRect(0, 0, width, height);

            // Default coloring and line width for all spaceObject
            ctx.strokeStyle = objectState.objectColor;
            ctx.fillStyle = objectState.objectFillColor;
            ctx.lineWidth = 2;

            // Origin is the middle of the canvas
            ctx.translate(objectState.objectSizePixelMultiplied,
                          objectState.objectSizePixelMultiplied);

            // Visualize the center for testing
            //ctx.fillRect(-2,-2,4,4);

            // Draw the specific object
            drawObjectSignal(ctx);

            ctx.restore();
        }
        onContextChanged: {
            //console.log("object canvas has changed ... " + context)
        }
        onAvailableChanged: {
            //console.log("object available ... " + available)
        }
    }
}
