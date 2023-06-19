import QtQuick
import QtQml

SpaceObject {

    id: spaceShip

    objectType: "alienShip"
    objectSizePixel: 60
    objectColor: "yellow"

    // Specific object drawing after translation to center and rotation has occured
    // Save and restore of drawing context is done before and after this call
    // line coloring and width is already set
    onDrawObjectSignal: (ctx)=> {

        // Alien Ship
        var k = objectSizePixel/2;
        ctx.beginPath();
        ctx.moveTo(-k, 0);
        ctx.lineTo(-k + k/3, - k/2);
        ctx.lineTo( k - k/3, - k/2);
        ctx.lineTo( k, 0);
        ctx.closePath();
        ctx.stroke();

        ctx.beginPath();
        ctx.moveTo(-k, 0);
        ctx.lineTo(-k + k/2, + k/2);
        ctx.lineTo( k - k/3, + k/2);
        ctx.lineTo( k, 0);
        ctx.closePath();
        ctx.stroke();

        ctx.beginPath();
        ctx.moveTo(-k/2, -k/2);
        ctx.lineTo(-k/4, -k);
        ctx.lineTo(+k/4, -k);
        ctx.lineTo(+k/2, -k/2);
        ctx.closePath();
        ctx.stroke();
    }
}
