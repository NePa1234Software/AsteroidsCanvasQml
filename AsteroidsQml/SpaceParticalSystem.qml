import QtQuick
import QtQuick.Particles

ParticleSystem {
    id: control

    ImageParticle {
        groups: ["stars"]
        anchors.fill: parent
        source: "qrc:///particleresources/star.png"
    }

    Emitter {
        group: "stars"
        anchors.fill: parent
        emitRate: 10
        lifeSpan: 15000
        lifeSpanVariation: 5000
        startTime: 10000
        size: 10
        endSize: 30
        sizeVariation: 20
    }

    Emitter {
        group: "stars"
        anchors.fill: parent
        emitRate: 0.2
        lifeSpan: 2000
        lifeSpanVariation: 1000
        size: 30
        sizeVariation: 10
        velocity: AngleDirection {
            angleVariation: 360;
            magnitude: 400
            magnitudeVariation: 50
        }
    }

    Component.onCompleted: {
        GameEngine.spaceParticalSystem = control
    }
}
