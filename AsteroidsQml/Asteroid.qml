import QtQuick
import QtQml

SpaceObject {

    id: asteroid

    // Specialize the object state
    objectState.objectType: "asteroid"
    objectState.objectSizePixel: 20
    objectState.objectColor: "yellow"

    // Largest size is 8, then 4, then 2 then they can be killed
    objectState.objectSizeMultiplier: 8

    // TODO make this QtObject
    property int numPoints : 12
    property var points : null

    // Called after object creation
    function doInit() {
        doInitBase();
        createAsteroid();
    }

    // This is called just once to clone the object
    function copyInitialProperties(target)
    {
        copyInitialPropertiesBase(target);
        target.points = null;
        target.points = new Array(numPoints);
        for (var ii = 0; ii < numPoints; ii++)
        {
            target.points[ii] = points[ii];
        }
    }

    // This is called just once to clone the object
    function copyDynamicProperties(target)
    {
        copyDynamicPropertiesBase(target);
    }

    function createAsteroid()
    {
        if (points !== null)
        {
            console.log("This mustn't happen!!!");
            return;
        }

        var k = objectState.objectHalfWidth;

        points = new Array(numPoints);
        for (var ii = 0; ii < numPoints; ii++) {
            var radius2 = k - Math.random() * k/2;
            var angleRadians = Math.PI * (ii/numPoints) * 360 / 180
            points[ii] = { x: radius2 * Math.cos(angleRadians),
                           y: radius2 * Math.sin(angleRadians) };
        }
    }

    // Specific object drawing after translation to center and rotation has occured
    // Save and restore of drawing context is done before and after this call
    // line coloring and width is already set
    onDrawObjectSignal: (ctx)=> {

        // Asteroid
        ctx.beginPath();
        ctx.moveTo(points[0].x, points[0].y);
        for (var ii = 1; ii < numPoints; ii++)
        {
          ctx.lineTo(points[ii].x,points[ii].y);
        }
        ctx.closePath();
        ctx.stroke();
        //ctx.fill();
    }
}
