import QtQuick

QtObject {
    id: root

    property bool  objectInitialised: false // For lazy initialization

    property real  objectPosX: 0            // Object center position
    property real  objectPosY: 0            // (Y downward is positive = Qt coordinates)
    property real  objectBearing: 0.0       // Bearing North is 0 degrees and clockwise is plus

    property real  x: objectPosX            // x and y are usefull for Qt.vector2d calculations and GameEngine
    property real  y: objectPosY
    property real  bearing: objectBearing

    property real  objectSpeedX: 0          // pixels per second (GameEngine will move the object regulary at this speed)
    property real  objectSpeedY: 0          // pixels per second (GameEngine will move the object regulary at this speed)
    property real  objectSpeedRotation: 0   // turns per second (GameEngine will rotated the object (turns per second)

    property int   objectSizePixel: 80      // Width and heigh of object. NOTE. canvas drawing you need more space due to rotation
    property int   objectScale: 1           // This will scale up the image and must be considered for collision detection
    property int   objectSizeMultiplier: 1
    property int   objectLifetimeMs: 0      // Can be used for selfdestructing objects (0 infinate)

    // Usefull values used for colision detection (do not write to these)
    property int  objectSizePixelMultiplied: objectSizePixel * objectSizeMultiplier
    property real objectSizePixelScaled: objectSizePixel * objectSizeMultiplier * objectScale
    property real objectRadius: objectSizePixelMultiplied/2
    property real objectHalfWidth: objectSizePixelMultiplied/2
    property real objectColisionRadius: objectSizePixelScaled/2

    property color objectColor: "blue"              // Wire frame draw color
    property color objectFillColor: "lightblue"     // Fill draw color

    property bool  objectHidden: false    // Mapped to visible flag
    property bool  objectDestroy: false   // Garbage collection will destroy this object

    // Overwrite this object to draw a specific object (delegate)
    property string objectType: "base"

    function copyInitialStateProperties(target)
    {
        console.assert(target !== null)
        console.assert(target.objectState == undefined) // ensure we do not pass the parent
        console.assert(target.objectType != undefined)
        console.assert(target.objectType == objectType)

        target.objectInitialised = objectInitialised;

        target.objectPosX = objectPosX;
        target.objectPosY = objectPosY;
        target.objectBearing = objectBearing;

        target.objectSpeedX = objectSpeedX;
        target.objectSpeedY = objectSpeedY;
        target.objectSpeedRotation = objectSpeedRotation;

        target.objectSizePixel = objectSizePixel;
        target.objectScale = objectScale;
        target.objectSizeMultiplier = objectSizeMultiplier;

        target.objectColor = objectColor;
        target.objectFillColor = objectFillColor;

        target.objectHidden = objectHidden;
        target.objectDestroy = objectDestroy;
        //target.objectType = objectType;
    }
    function copySpeedBearingStateProperties(target)
    {
        console.assert(target !== null)
        console.assert(target.objectState == undefined) // ensure we do not pass the parent
        console.assert(target.objectType != undefined)
        console.assert(target.objectType == objectType)
        target.objectSpeedX = objectSpeedX;
        target.objectSpeedY = objectSpeedY;
        target.objectSpeedRotation = objectSpeedRotation;
        target.objectBearing = objectBearing;
    }
}
