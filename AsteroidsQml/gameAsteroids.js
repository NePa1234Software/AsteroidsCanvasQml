//import * as GameEngine from "gameEngine.js";

// Space Objects
var spaceShip = null;
var spaceShipWrap = null;
var alienShip = null;
var alienShipWrap = null;
var alienShipNextActionMs = null;
var alienShipNextShootMs = null;
var asteroids = [];
var asteroidsWrap = [];
var bullets = [];
var alienbullets = [];
var debris = [];

// Wrap Space
var gameParent = null;
var gameAreaMaxX = 0;
var gameAreaMaxY = 0;

// Key press status
var keyLeft = false;
var keyRight = false;
var keyUp = false;
var keySpace = false;
var requestShoot = false;
var requestHyperjump = false;

// Game level and score
var level = 1;
var score = 0;
var lives = 3;
var gameOver = true
var pause = false

var gameTimeStampMs = 0;

////////////////////////////////////////////////////////////////////////////////////////////////
// Init
////////////////////////////////////////////////////////////////////////////////////////////////

function initGameRequest(parent)
{
    gameParent = parent;

    gameTimeStampMs = Date.now();

    console.log("Init game request ...");

    // Init containers and create a start screen with a few asteroids
    createBulletsContainer();
    createDebrisContainer();
    createAsteroidsContainer();
    createAsteroids(1, 32);
    createAsteroids(1, 16);
    createAsteroids(1, 8);
    createAsteroids(1, 4);
    createAsteroids(1, 2);
    createAsteroids(1, 1);
}

////////////////////////////////////////////////////////////////////////////////////////////////
// Game control
////////////////////////////////////////////////////////////////////////////////////////////////

function newGameRequest(parent)
{
    gameParent = parent;
    console.log("New game request ...");
    level = 1;
    lives = 3;
    score = 0;
    gameOver = false;
    pause = false;

    // Init containers
    createBulletsContainer();
    createDebrisContainer();

    // Initiate game play
    resetLevel();
}

function resetLevel()
{
    // Destroy all object correctly
    destroyShips();
    destroyAsteroids();

    // Create the game objects
    createShips();
    createAsteroids( Math.min(10, 2 + (2 * level)), 4);
}

function increaseScore(object)
{
    var prevScore = score;
    console.log(object.objectType + " hit - size " + object.objectSizeMultiplier);
    if (object.objectType === "asteroid")
    {
        switch(object.objectSizeMultiplier)
        {
        case 8:
            score += 10;
            break;
        case 4:
            score += 20;
            break;
        case 2:
            score += 50;
            break;
        case 1:
            score += 100;
            break;
        default:
            console.log("Unexpected size!!!");
            break;
        }
    }
    else if (object.objectType === "alienShip")
    {
        // Ship gets bettwe each level, so the reward is higher
        score += 200 * level;
    }
    else
    {
        score += 100;
    }
    // New life every 10000
    if ((score % 10000) < (prevScore % 10000))
    {
        lives++;
    }
}

function doGameLevelHandling()
{
    if (gameOver) return;  // Wait for manual reset of game

    // Ship destroyed?
    if (spaceShip.objectHidden)
    {
        // Wait for debris to leave the screen
        if (debris.length == 0 && bullets.length == 0 && alienbullets.length == 0)
        {
            resetLevel();
        }
    }
    else
    {
        // Level complete?
        if (asteroids.length === 0)
        {
            level++;
            resetLevel();
        }
    }
}

function doHyperjump()
{
    if (spaceShip === null) return;
    spaceShip.objectHidden = true;
    spaceShip.objectPosX = GameEngine.getRandomValue(0 + spaceShip.objectSizePixelScaled/2,
                                                     gameAreaMaxX - spaceShip.objectSizePixelScaled/2);
    spaceShip.objectPosY = GameEngine.getRandomValue(0 + spaceShip.objectSizePixelScaled/2,
                                                     gameAreaMaxY - spaceShip.objectSizePixelScaled/2);
    spaceShip.objectSpeedX = 0;
    spaceShip.objectSpeedY = 0;
    spaceShip.objectHidden = false;
}

////////////////////////////////////////////////////////////////////////////////////////////////

function setGameArea(x,y)
{
    gameAreaMaxX = x;
    gameAreaMaxY = y;
    console.log("Screen size (gamearea): x/y : " + x + "/" + y);
}

////////////////////////////////////////////////////////////////////////////////////////////////
// Object creation
////////////////////////////////////////////////////////////////////////////////////////////////

function createShips()
{
    // Create the wrappable spaceShip
    spaceShip = GameEngine.createSpaceObject(gameParent, "SpaceShip.qml");
    GameEngine.doResetObjectPositionToCenter(spaceShip, gameAreaMaxX, gameAreaMaxY);
    spaceShip.objectBearing = 45;
    spaceShip.doInit();
    spaceShip.doRedraw();
    spaceShipWrap = GameEngine.createWrapObject(spaceShip, "SpaceShip.qml");

    // Create the wrappable alienShip
    alienShip = GameEngine.createSpaceObject(gameParent, "AlienShip.qml");
    GameEngine.doResetObjectPositionToCenter(alienShip, gameAreaMaxX, gameAreaMaxY);
    alienShip.objectPosX += 100;
    alienShip.objectHidden = true;
    alienShip.objectHidden = true;
    alienShip.doInit();
    alienShip.doRedraw();
    alienShipWrap = GameEngine.createWrapObject(alienShip, "AlienShip.qml");
}
function destroyShips()
{
    if (spaceShip !== null)
    {
        spaceShip.destroy();
        spaceShip = null;
    }
    if (spaceShipWrap !== null)
    {
        spaceShipWrap.destroy();
        spaceShipWrap = null;
    }
    if (alienShip !== null)
    {
        alienShip.destroy();
        alienShip = null;
    }
    if (alienShipWrap !== null)
    {
        alienShipWrap.destroy();
        alienShipWrap = null;
    }
}

function createAsteroidsContainer()
{
    if (asteroids === null)
    {
      asteroids = new Array(count);
    }
    if (asteroidsWrap === null)
    {
        asteroidsWrap = new Array(count);
    }
}

function createAsteroids(count, sizeFactor)
{
    for (var ii = 0; ii < count; ii++)
    {
        // Create the wrappable asteroid
        var index = asteroids.length
        asteroids[index] = GameEngine.createSpaceObject(gameParent, "Asteroid.qml");
        GameEngine.doResetObjectPositionToRandomPosition(asteroids[index], gameAreaMaxX, gameAreaMaxY);
        var speedXY = 5 * (Math.min(level,3) - 1) + (8 - sizeFactor) * 2.5;
        asteroids[index].objectSpeedX = GameEngine.getRandomSpeed(30, 100 + speedXY);
        asteroids[index].objectSpeedY = GameEngine.getRandomSpeed(0.3, 100 + speedXY);
        asteroids[index].objectSpeedRotation = GameEngine.getRandomSpeed(10, 30);
        asteroids[index].objectSizeMultiplier = sizeFactor;
        asteroids[index].doInit();
        asteroids[index].doRedraw();
        asteroidsWrap[index] = GameEngine.createWrapObject(asteroids[index], "Asteroid.qml");
    }
}
function destroyAsteroids()
{
    asteroidsWrap.forEach( element => element.destroy() );
    asteroidsWrap = [];
    asteroids.forEach( element => element.destroy() );
    asteroids = [];
}

function createBulletsContainer()
{
    if (bullets === null) {
        bullets = new Array(0);
    }
    if (alienbullets === null) {
        alienbullets = new Array(0);
    }
}

function createBullet()
{
    var bullet = GameEngine.createSpaceObject(gameParent, "Bullet.qml");
    bullet.objectPosX = spaceShip.objectPosX;
    bullet.objectPosY = spaceShip.objectPosY;
    bullet.objectBearing = spaceShip.objectBearing;
    bullet.objectSpeedX =  1000 * Math.sin(bullet.objectBearing * Math.PI/180);
    bullet.objectSpeedY = -1000 * Math.cos(bullet.objectBearing * Math.PI/180);
    bullet.objectSizeMultiplier = 50;
    //console.log(bullet.objectType + bullets.length + " created: " + bullet.objectSpeedX + "/" + bullet.objectSpeedY);
    bullet.doInit();
    bullet.doRedraw();
    bullets[bullets.length] = bullet;
}

function createDebrisContainer()
{
    if (debris === null) {
        debris = new Array(0);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////
// Object Garbage Collection - when objects are marked for destruction
////////////////////////////////////////////////////////////////////////////////////////////////

function cleanUpDestroyedWrappedObjects( objects, objectsWrap )
{
    // NOTE - we expect arraw lengths to be equal
    var ii = 0;
    while ( ii < objects.length )
    {
        if (objects[ii].objectDestroy)
        {
            objects[ii].destroy();
            objects.splice(ii, 1);
            objectsWrap[ii].destroy();
            objectsWrap.splice(ii, 1);
        }
        else
        {
            ii++;
        }
    }
}

function cleanUpDestroyedObjects( objects )
{
    var ii = 0;
    while ( ii < objects.length )
    {
        if (objects[ii].objectDestroy)
        {
            objects[ii].destroy();
            objects.splice(ii, 1);
        }
        else
        {
            ii++;
        }
    }
}
function cleanUpDestroyedObject( object )
{
    // ToDo - what to do if this is the ship
    if (object.objectDestroy)
    {
        object.destroy();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////
// Collision detection
////////////////////////////////////////////////////////////////////////////////////////////////

function doCollisionDetection()
{
    bullets.forEach( source => asteroids.forEach( target => doCollisionDetectionGeneric(source,target,onBulletHits,onAsteroidCollision) ) );
    bullets.forEach( source => doCollisionDetectionGeneric(source,alienShip,onBulletHits,onAlienShipCollision) );
    asteroids.forEach( source => doCollisionDetectionGeneric(source,spaceShip,onAsteroidCollision,onShipCollision) );
    alienbullets.forEach( source => doCollisionDetectionGeneric(source, spaceShip, onBulletHits, onShipCollision) );
    doCollisionDetectionGeneric(spaceShip,alienShip,onShipCollision,onAlienShipCollision);
}

function doCollisionDetectionGeneric(source, target, sourcefunc, targetfunc)
{
    if (source === null) return;
    if (target === null) return;
    if (source.objectHidden === true) return;
    if (source.objectDesroyed === true) return;
    if (target.objectHidden === true) return;
    if (target.objectDesroyed === true) return;

    if ( GameEngine.isPointInsideCircle( source.objectPosX, source.objectPosY,
                                         source.objectSizePixelScaled/2 + target.objectSizePixelScaled/2,
                                         target.objectPosX, target.objectPosY))
    {
      // For additional effect, we do collision of the asteroid as well
      if (sourcefunc !== null) sourcefunc(source);
      if (targetfunc !== null) targetfunc(target);
      return;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////
// Collision handling
////////////////////////////////////////////////////////////////////////////////////////////////

function onAsteroidCollision(element)
{
    element.objectDestroy = true;
    if (element.objectSizeMultiplier > 1)
    {
        spawnNewAsteroids(element);
    }
    spawnAsteroidDebris(element);
    increaseScore(element);
}

function onShipCollision(not_used)
{
    console.log("Ship destroyed ....");

    // Nice effect of ship being destroyed
    spawnShipDebris(spaceShip);

    if (lives <= 1)
    {
        gameOver = true;
        spaceShip.objectHidden = true;
        spaceShipWrap.objectHidden = true;
        spaceShip.objectDestroy = true;
        spaceShipWrap.objectDestroy = true;
    }
    else
    {
        spaceShip.objectHidden = true;
        spaceShipWrap.objectHidden = true;
        lives--;
    }
}

function onAlienShipCollision(not_used)
{
    console.log("Alien Ship destroyed ....");

    // Nice effect of ship being destroyed
    spawnAsteroidDebris(alienShip);

    alienShip.objectHidden = true;
    alienShipWrap.objectHidden = true;
    resetTimerNextAlienShipVisibility();

    increaseScore(alienShip);
}

function onBulletHits(bullet)
{
    bullet.objectDestroy = true;
}

////////////////////////////////////////////////////////////////////////////////////////////////
// Object movement over time
////////////////////////////////////////////////////////////////////////////////////////////////

function doPositionAdjust(object, objectWrap, millis)
{
    if (object === null) return;
    object.objectPosX += object.objectSpeedX * millis / 1000;
    object.objectPosY += object.objectSpeedY * millis / 1000;
    object.objectBearing += object.objectSpeedRotation * millis / 1000;

    // Wrap coordinates
    if ( objectWrap !== null)
    {
        GameEngine.doWrapCoordinates(object, objectWrap, gameAreaMaxX, gameAreaMaxY);
    }
    else
    {
        // If no wrap object exist, the object is to be destroyed when it goes off the screen
        if (object.objectPosX < 0 || object.objectPosX > gameAreaMaxX ||
            object.objectPosY < 0 || object.objectPosY > gameAreaMaxY)
        {
            object.objectDestroy = true;
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////
// Spawning
////////////////////////////////////////////////////////////////////////////////////////////////

function spawnNewAsteroids(asteroid)
{
    for (var ii = 0; ii < 2; ii++)
    {
        var index = asteroids.length;
        asteroids[index] = GameEngine.createSpaceObject(gameParent, "Asteroid.qml");
        var speedXY = 50 * (level - 1);
        asteroids[index].objectPosX = asteroid.objectPosX;
        asteroids[index].objectPosY = asteroid.objectPosY;
        asteroids[index].objectSpeedX = GameEngine.getRandomSpeed(50, 100 + speedXY);
        asteroids[index].objectSpeedY = GameEngine.getRandomSpeed(50, 100 + speedXY);
        asteroids[index].objectSpeedRotation = GameEngine.getRandomSpeed(0.1 * level, 0.2 * level);
        asteroids[index].objectSizeMultiplier = asteroid.objectSizeMultiplier/2;
        asteroids[index].doInit();
        asteroids[index].doRedraw();
        asteroidsWrap[index] = GameEngine.createWrapObject(asteroids[index], "Asteroid.qml");
    }
}

function spawnAsteroidDebris(asteroid)
{
    for (var ii = 1; ii <= 20; ii++)
    {
        var index = debris.length;
        debris[index] = GameEngine.createSpaceObject(gameParent, "Debris.qml");
        debris[index].objectSpeedX = GameEngine.getRandomSpeed(20, 50);
        debris[index].objectSpeedY = GameEngine.getRandomSpeed(20, 50);
        debris[index].objectPosX = asteroid.objectPosX;
        debris[index].objectPosY = asteroid.objectPosY;
        debris[index].objectSizeMultiplier = 1;
        debris[index].objectColor = asteroid.objectColor;
        debris[index].objectLifetimeMs = GameEngine.getRandomValue(200,800);
        debris[index].doInit();
        debris[index].doRedraw();
    }
}

function spawnShipDebris(ship)
{
    for (var ii = 1; ii <= 20; ii++)
    {
        var index = debris.length;
        debris[index] = GameEngine.createSpaceObject(gameParent, "Debris.qml");
        debris[index].objectSpeedX = GameEngine.getRandomSpeed(0, 300);
        debris[index].objectSpeedY = GameEngine.getRandomSpeed(0, 300);
        debris[index].objectSpeedRotation = GameEngine.getRandomSpeed(-300, 300);
        debris[index].objectPosX = ship.objectPosX;
        debris[index].objectPosY = ship.objectPosY;
        debris[index].objectSizeMultiplier = GameEngine.getRandomSpeed(5, 20);
        debris[index].objectColor = ship.objectColor;
        debris[index].objectLifetimeMs = GameEngine.getRandomValue(1000,2000);
        debris[index].doInit();
        debris[index].doRedraw();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////
// Alien ship handling
////////////////////////////////////////////////////////////////////////////////////////////////

function doAlienShipHandling()
{
    if (alienShip === null) return;

    if (alienShipNextActionMs === null)
    {
        resetTimerNextAlienShipVisibility();
        initTimerNextAlienShipShoot();
    }

    if (gameTimeStampMs >= alienShipNextActionMs)
    {
        if (alienShip.objectHidden)
        {
            if (spaceShip.objectHidden) return;

            // Start from the right screen any position and the move to the left
            alienShip.objectPosX = gameAreaMaxX - alienShip.objectSizePixelScaled/2;
            alienShip.objectPosY = GameEngine.getRandomValue(0 + alienShip.objectSizePixelScaled/2,
                                                             gameAreaMaxY - alienShip.objectSizePixelScaled/2);
            alienShip.objectSpeedX = -50;
            alienShip.objectSpeedY = GameEngine.getRandomValue(-30,30);
            alienShip.objectHidden = false;
            GameEngine.doWrapCoordinates(alienShip, alienShipWrap, gameAreaMaxX, gameAreaMaxY);
            resetTimerNextAlienShipVisibility();
            initTimerNextAlienShipShoot();
        }
        else
        {
            // When alienShip reaches the left edge make it disapear
            if(alienShip.objectPosX <= alienShip.objectSizePixelScaled/2)
            {
                alienShip.objectHidden = true;
                alienShipWrap.objectHidden = true;
                resetTimerNextAlienShipVisibility();
            }
        }
    }
    if ( !alienShip.objectHidden && !spaceShip.objectHidden && gameTimeStampMs >= alienShipNextShootMs )
    {
        createAlienBullet();
        resetTimerNextAlienShipShoot();
    }
}

function resetTimerNextAlienShipVisibility()
{
    alienShipNextActionMs = gameTimeStampMs + GameEngine.getRandomValue(10,20) * 1000;
}
function initTimerNextAlienShipShoot()
{
    alienShipNextShootMs = gameTimeStampMs + 1000;
}
function resetTimerNextAlienShipShoot()
{
    alienShipNextShootMs = gameTimeStampMs + 5000;
}
function createAlienBullet()
{
    var bullet = GameEngine.createSpaceObject(gameParent, "Bullet.qml");
    bullet.objectPosX = alienShip.objectPosX;
    bullet.objectPosY = alienShip.objectPosY;
    bullet.objectBearing = Math.atan2( (spaceShip.objectPosX - alienShip.objectPosX), -(spaceShip.objectPosY - alienShip.objectPosY))
            * 180 / Math.PI;
    var tmpSpeed = 60 + Math.min(level, 3) * 20; // Bullet speed increase per level (must be faster than ship)
    bullet.objectSpeedX =  tmpSpeed * Math.sin(bullet.objectBearing * Math.PI/180);
    bullet.objectSpeedY = -tmpSpeed * Math.cos(bullet.objectBearing * Math.PI/180);
    bullet.objectSizeMultiplier = 30;
    bullet.objectLifetimeMs = 4000 + (2000 * level); // Bullet radius increase per level (limit is screen)
    //console.log(bullet.objectType + bullets.length + " created: " + bullet.objectSpeedX + "/" + bullet.objectSpeedY);
    bullet.doInit();
    bullet.doRedraw();
    alienbullets[alienbullets.length] = bullet;
}

////////////////////////////////////////////////////////////////////////////////////////////////
// Main Loop
////////////////////////////////////////////////////////////////////////////////////////////////

function doFastTimerLoop()
{
    var timeNow = Date.now();
    var millis = timeNow - gameTimeStampMs;
    gameTimeStampMs = timeNow;
    //console.log("time = " + timeNow + ", diff = " + millis);

    if (pause) return;
    if (spaceShip !== null)
    {
        // Rotate ship
        if (keyLeft)  { spaceShip.objectBearing -= spaceShip.shipTurnSpeed * 360 * millis / 1000; }
        if (keyRight) { spaceShip.objectBearing += spaceShip.shipTurnSpeed * 360 * millis / 1000; }
        spaceShip.objectBearing = spaceShip.objectBearing % 360;

        // Ship thrust
        spaceShip.shipThrust = keyUp
        if (keyUp)
        {
            spaceShip.objectSpeedX +=  (spaceShip.shipAcceleration * millis/1000) * Math.sin(spaceShip.objectBearing * Math.PI/180);
            spaceShip.objectSpeedY += -(spaceShip.shipAcceleration * millis/1000) * Math.cos(spaceShip.objectBearing * Math.PI/180);
            spaceShip.objectSpeedX = GameEngine.limitMinMax(spaceShip.objectSpeedX, -1000, 1000);
            spaceShip.objectSpeedY = GameEngine.limitMinMax(spaceShip.objectSpeedY, -1000, 1000);
        }
    }

    // Move the ship, bullets and asteroids
    doPositionAdjust(spaceShip, spaceShipWrap, millis);
    doPositionAdjust(alienShip, alienShipWrap, millis);
    bullets.forEach( element => doPositionAdjust(element, null, millis) );
    alienbullets.forEach( element => doPositionAdjust(element, null, millis) );
    asteroids.forEach( (element,index) => doPositionAdjust(element, asteroidsWrap[index], millis) );
    debris.forEach( element => doPositionAdjust(element, null, millis) );

    // Shoot bullets
    if (spaceShip !== null && !spaceShip.objectHidden)
    {
        if (requestShoot)
        {
            createBullet();
            requestShoot = false;
        }
        if (requestHyperjump)
        {
            doHyperjump();
            requestHyperjump = false;
        }

        // Handle
        doCollisionDetection();
    }

    // Check if objects are to be destroyed
    cleanUpDestroyedObjects(bullets);
    cleanUpDestroyedObjects(alienbullets);
    cleanUpDestroyedObjects(debris);
    cleanUpDestroyedWrappedObjects(asteroids, asteroidsWrap);

    //This is only hidden never destroyed
    //cleanUpDestroyedObject(spaceShip);
    //cleanUpDestroyedObject(alienShip);

    // Alien ship handling
    doAlienShipHandling();

    // Level handling
    doGameLevelHandling();
}

