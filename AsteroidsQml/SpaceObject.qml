import QtQuick
import QtQml

Item {
    id: object

    // Common states for all object
    property alias objectState: objectStateBase

    visible: !object.objectState.objectHidden

    // Base canvas object can be read but not overwritten
    readonly property alias objectImage: objectImageBase

    // Implement this to draw the specific object
    // Save and restore of drawing context is done before and after this call
    // line coloring and width is already set
    signal drawObjectSignal(var ctx);

    // Called after object creation - overwritten by specialized object
    function doInit() {
        object.doInitBase();
    }

    function doInitBase() {
        object.objectState.objectInitialised = true;
    }

    // Called after doInit and when a redraw is to be forced
    function doRedraw() {
        objectImageBase.requestPaint()
    }

    // This is called just once to clone the object
    function copyInitialProperties(target : SpaceObject)
    {
        copyInitialPropertiesBase(target);
    }

    function copyInitialPropertiesBase(target : SpaceObject)
    {
        object.objectState.copyInitialStateProperties(target.objectState)
    }

    // This is called to clone the dynamic properties that change during game
    // overwrite this fpr specific properties
    function copyDynamicProperties(target : SpaceObject)
    {
        object.objectState.copySpeedBearingStateProperties(target.objectState);
    }
    function copyDynamicPropertiesBase(target : SpaceObject)
    {
        object.objectState.copySpeedBearingStateProperties(target.objectState)
    }

    ObjectState { id: objectStateBase }

    // The image needs to be drawn specifically using the onDrawObjectSignal
    Canvas {
        id: objectImageBase
        rotation: object.objectState.objectBearing
        scale: object.objectState.objectScale
        visible: true // objectType === "base"
        width:  (object.objectState.objectSizePixelMultiplied) * 2
        height: (object.objectState.objectSizePixelMultiplied) * 2
        x: object.objectState.objectPosX - (object.objectState.objectSizePixelMultiplied)
        y: object.objectState.objectPosY - (object.objectState.objectSizePixelMultiplied)
        antialiasing: true

        onPaint: {
            if (!object.objectState.objectInitialised) {
                object.doInit();
            }

            //console.log("onPaint called")
            var ctx = getContext('2d');

            ctx.save();
            ctx.clearRect(0, 0, width, height);

            // Default coloring and line width for all spaceObject
            ctx.strokeStyle = object.objectState.objectColor;
            ctx.fillStyle = object.objectState.objectFillColor;
            ctx.lineWidth = 2;

            // Origin is the middle of the canvas
            ctx.translate(object.objectState.objectSizePixelMultiplied,
                          object.objectState.objectSizePixelMultiplied);

            // Visualize the center for testing
            //ctx.fillRect(-2,-2,4,4);

            // Draw the specific object
            object.drawObjectSignal(ctx);

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
