import QtQuick

QtObject {
    id: root

    property bool  objectInitialised: false // For lazy initialization

    property real  objectPosX: 0            // Object center position
    property real  objectPosY: 0            // (Y downward is positive = Qt coordinates)
    property real  objectBearing: 0.0       // Bearing North is 0 degrees and clockwise is plus

    property real  x: root.objectPosX       // x and y are usefull for Qt.vector2d calculations and GameEngine
    property real  y: root.objectPosY
    property real  bearing: root.objectBearing

    property real  objectSpeedX: 0          // pixels per second (GameEngine will move the object regulary at this speed)
    property real  objectSpeedY: 0          // pixels per second (GameEngine will move the object regulary at this speed)
    property real  objectSpeedRotation: 0   // turns per second (GameEngine will rotated the object (turns per second)

    property int   objectSizePixel: 80      // Width and heigh of object. NOTE. canvas drawing you need more space due to rotation
    property int   objectScale: 1           // This will scale up the image and must be considered for collision detection
    property int   objectSizeMultiplier: 1
    property int   objectLifetimeMs: 0      // Can be used for selfdestructing objects (0 infinate)

    // Usefull values used for colision detection (do not write to these)
    readonly property int  objectSizePixelMultiplied: root.objectSizePixel * root.objectSizeMultiplier
    readonly property real objectSizePixelScaled: root.objectSizePixel * root.objectSizeMultiplier * root.objectScale
    readonly property real objectRadius: root.objectSizePixelMultiplied/2
    readonly property real objectHalfWidth: root.objectSizePixelMultiplied/2
    readonly property real objectColisionRadius: root.objectSizePixelScaled/2

    property color objectColor: "blue"              // Wire frame draw color
    property color objectFillColor: "lightblue"     // Fill draw color

    property bool  objectHidden: false    // Mapped to visible flag
    property bool  objectDestroy: false   // Garbage collection will destroy this object

    // Overwrite this object to draw a specific object (delegate)
    property string objectType: "base"

    function copyInitialStateProperties(target : ObjectState)
    {
        if (!target ) {
            console.error("target is null")
            return;
        }

        target.objectInitialised = root.objectInitialised;

        target.objectPosX = root.objectPosX;
        target.objectPosY = root.objectPosY;
        target.objectBearing = root.objectBearing;

        target.objectSpeedX = root.objectSpeedX;
        target.objectSpeedY = root.objectSpeedY;
        target.objectSpeedRotation = root.objectSpeedRotation;

        target.objectSizePixel = root.objectSizePixel;
        target.objectScale = root.objectScale;
        target.objectSizeMultiplier = root.objectSizeMultiplier;

        target.objectColor = root.objectColor;
        target.objectFillColor = root.objectFillColor;

        target.objectHidden = root.objectHidden;
        target.objectDestroy = root.objectDestroy;
        //target.objectType = root.objectType;
    }
    function copySpeedBearingStateProperties(target : ObjectState)
    {
        if (!target ) {
            console.error("target is null")
            return;
        }
        target.objectSpeedX = root.objectSpeedX;
        target.objectSpeedY = root.objectSpeedY;
        target.objectSpeedRotation = root.objectSpeedRotation;
        target.objectBearing = root.objectBearing;
    }
}
