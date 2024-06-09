import QtQuick

import QtQuick
import QtQml

SpaceObject {

    id: ultiCannons

    property WeaponInterface weapons: weaponImplUlti
    property bool ultiActivated: false

    // Specialization of base object
    objectState.objectType: "ultiCannons"
    objectState.objectSizePixel: 40
    objectState.objectColor: "white"
    objectState.objectFillColor: "lightgrey"

    // Specific object drawing after translation to center and rotation has occured
    // Save and restore of drawing context is done before and after this call
    // line coloring and width is already set
    onDrawObjectSignal: (ctx)=>
    {
        var h = ultiCannons.objectState.objectHalfWidth;
        var w = h/2;

        // ulti
        //ctx.translate(120,0);
        ctx.beginPath();
        ctx.moveTo(0,10);
        ctx.lineTo(w,10);
        ctx.lineTo(w,-h);
        ctx.lineTo(w+10,-h)
        ctx.lineTo(w+10,h-5);

        ctx.lineTo(-w-10,h-5);
        ctx.lineTo(-w-10,-h)
        ctx.lineTo(-w,-h);
        ctx.lineTo(-w,10);

        ctx.closePath();
        ctx.stroke();
        ctx.fill();

        ctx.fillRect(w+2,-h, 6, -10);
        ctx.rect(w+2,-h, 5, -10);
        ctx.stroke();
        ctx.fillRect(-w-2,-h, -5, -10);
        ctx.rect(-w-2,-h, -5, -10);
        ctx.stroke();

        ctx.fillRect(w+2,h+5, 6, -10);
        ctx.rect(w+2,h+5, 5, -10);
        ctx.stroke();
        ctx.fillRect(-w-2,h+5, -5, -10);
        ctx.rect(-w-2,h+5, -5, -10);
        ctx.stroke();
    }

    // This is an object needed by the game engine to fire bullets
    WeaponInterface
    {
        id: weaponImplUlti
        weaponType: "ultiCannons"
        cannonList: [
            CannonInterface {
                r_y: 0
                r_x: ultiCannons.objectState.objectHalfWidth/2 + 5
                r_angle: 2
                cannonDamage: 2
                cannonPoweredUp: ultiCannons.ultiActivated
            },
            CannonInterface {
                r_y: 0
                r_x: -ultiCannons.objectState.objectHalfWidth/2 - 5
                r_angle: -2
                cannonDamage: 2
                cannonPoweredUp: ultiCannons.ultiActivated
            },
            CannonInterface {
                r_y: ultiCannons.objectState.objectHalfWidth
                r_x: ultiCannons.objectState.objectHalfWidth/2 +5
                r_angle: 178
                cannonDamage: 1
                cannonPoweredUp: ultiCannons.ultiActivated
            },
            CannonInterface {
                r_y: ultiCannons.objectState.objectHalfWidth
                r_x: -ultiCannons.objectState.objectHalfWidth/2 -5
                r_angle: 182
                cannonDamage: 1
                cannonPoweredUp: ultiCannons.ultiActivated
            }
        ]
    }
}
