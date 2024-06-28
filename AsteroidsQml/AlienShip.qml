import QtQuick
import QtQml
import QtQuick.Particles

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

    ParticleSystem { id: sys }

    ImageParticle {
        system: sys
        groups: ["effects"]
        source: "qrc:///particleresources/fuzzydot.png"
        color: objectState.objectColor
        colorVariation: 0.3
        entryEffect: ImageParticle.None
        z: spaceShip.z - 2
    }

    Emitter {
        system: sys
        enabled: spaceShip.visible
        group: "effects"
        transform: [
            Translate {
                x: objectState.objectHalfWidth - 2
                y: 2
            },
            Rotation {
                angle: spaceShip.objectState.objectBearing
            },
            Translate {
                x: spaceShip.objectState.objectPosX
                y: spaceShip.objectState.objectPosY
            }
        ]
        NumberAnimation on emitRate { from: 0; to: 500; duration: 2000; loops: Animation.Infinite }
        lifeSpan: 200
        lifeSpanVariation: 200
        size: 10
        endSize: 5
        velocity: AngleDirection {
            angle: 0
            angleVariation: 15;
            magnitude: 150
            magnitudeVariation: 100
        }
    }
}
