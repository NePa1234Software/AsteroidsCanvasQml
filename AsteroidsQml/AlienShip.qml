import QtQuick
import QtQml

SpaceObject {

    id: spaceShip

    // Specialize the object state
    objectState.objectType: "alienShip"
    objectState.objectSizePixel: 60
    objectState.objectColor: "yellow"

    property WeaponInterface weapons: weaponImplBasic

    // Specific object drawing after translation to center and rotation has occured
    // Save and restore of drawing context is done before and after this call
    // line coloring and width is already set
    onDrawObjectSignal: (ctx)=> {

        var k = objectState.objectHalfWidth;

        // Alien Ship
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

    // This is an object needed by the game engine to fire bullets
    WeaponInterface
    {
        id: weaponImplBasic
        weaponType: "basic"
        cannonList: [
            CannonInterface {
                cannonDamage: 1
                cannonPoweredUp: true
            }
        ]
    }

}
