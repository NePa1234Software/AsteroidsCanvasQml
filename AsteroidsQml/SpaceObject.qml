import QtQuick
import QtQml

Item {
    id: object
    property real  objectPosX: 0
    property real  objectPosY: 0
    property real  objectSpeedX: 0
    property real  objectSpeedY: 0
    property real  objectSpeedRotation: 0
    property real  objectBearing: 0.0
    property int   objectSizePixel: 80
    property int   objectScale: 1
    property int   objectSizeMultiplier: 1
    property bool  objectDestroy: false
    property bool  objectInitialised: false
    property bool  objectHidden: false
    property int   objectLifetimeMs: 0    // Can be used for selfdestructing objects
    visible: !objectHidden

    // Usefull values not used internally
    readonly property int objectSizePixelScaled: objectSizePixel * objectSizeMultiplier * objectScale

    property color objectColor: "blue"

    // Overwrite these two objects to draw a specific object
    property string objectType: "base"

    // Base canvas object
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
        objectInitialised = true;
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
        target.objectSpeedX = objectSpeedX;
        target.objectSpeedY = objectSpeedY;
        target.objectSpeedRotation = objectSpeedRotation;
        target.objectBearing = objectBearing;
        target.objectColor = objectColor;
        target.objectSizePixel = objectSizePixel;
        target.objectScale = objectScale;
        target.objectSizeMultiplier = objectSizeMultiplier;
        target.objectPosX = objectPosX;
        target.objectPosY = objectPosY;
        target.visible = visible;
        target.objectHidden = objectHidden;
        target.objectInitialised = objectInitialised;
    }

    // This is called to clone the dynamic properties that change during game
    // overwrite this fpr specific properties
    function copyDynamicProperties(target)
    {
        copyDynamicPropertiesBase(target);
    }
    function copyDynamicPropertiesBase(target)
    {
        target.objectSpeedX = objectSpeedX;
        target.objectSpeedY = objectSpeedY;
        target.objectSpeedRotation = objectSpeedRotation;
        target.objectBearing = objectBearing;
    }

    // Now we use the objectImageBase.rotation property
    // onObjectBearingChanged: doRedraw()

    // The image needs to be drawn specifically using the onDrawObjectSignal
    Canvas {
        id: objectImageBase
        rotation: objectBearing
        scale: objectScale
        visible: true // objectType === "base"
        width:  (objectSizePixel*objectSizeMultiplier) * 2
        height: (objectSizePixel*objectSizeMultiplier) * 2
        x: objectPosX - (objectSizePixel*objectSizeMultiplier)
        y: objectPosY - (objectSizePixel*objectSizeMultiplier)
        antialiasing: true

        onPaint: {
            if (!objectInitialised) {
                doInit();
            }

            //console.log("onPaint called")
            var ctx = getContext('2d');

            ctx.save();
            ctx.clearRect(0, 0, width, height);

            // Default coloring and line width for all spaceObject
            ctx.strokeStyle = objectColor;
            ctx.fillStyle = objectColor;
            ctx.lineWidth = 2;

            // Origin is the middle of the canvas
            ctx.translate(objectSizePixel*objectSizeMultiplier,objectSizePixel*objectSizeMultiplier);

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
