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

    console.log("GAME: Init game request ...");

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
    console.log("GAME: New game request ...");
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
    if (!object?.objectState?.objectType)
    {
        return;
    }

    var prevScore = score;
    //console.log("GAME: " + object.objectState.objectType + " hit - size " + object.objectState.objectSizeMultiplier);
    if (object.objectState.objectType === "asteroid")
    {
        switch(object.objectState.objectSizeMultiplier)
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
            console.log("GAME: Unexpected size!!!");
            break;
        }
    }
    else if (object.objectState.objectType === "alienShip")
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
    if (spaceShip.objectState.objectHidden)
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
    spaceShip.objectState.objectHidden = true;
    spaceShip.objectState.objectPosX = GameEngine.getRandomValue(0 + spaceShip.objectState.objectSizePixelScaled/2,
                                                     gameAreaMaxX - spaceShip.objectState.objectSizePixelScaled/2);
    spaceShip.objectState.objectPosY = GameEngine.getRandomValue(0 + spaceShip.objectState.objectSizePixelScaled/2,
                                                     gameAreaMaxY - spaceShip.objectState.objectSizePixelScaled/2);
    spaceShip.objectState.objectSpeedX = 0;
    spaceShip.objectState.objectSpeedY = 0;
    spaceShip.objectState.objectHidden = false;
}

////////////////////////////////////////////////////////////////////////////////////////////////

function setGameArea(x,y)
{
    gameAreaMaxX = x;
    gameAreaMaxY = y;
    console.log("GAME: Screen size (gamearea): x/y : " + x + "/" + y);
}

////////////////////////////////////////////////////////////////////////////////////////////////
// Object creation
////////////////////////////////////////////////////////////////////////////////////////////////

function createShips()
{
    // Create the wrappable spaceShip
    spaceShip = GameEngine.createSpaceObject(gameParent, "SpaceShip.qml");
    GameEngine.doResetObjectPositionToCenter(spaceShip, gameAreaMaxX, gameAreaMaxY);
    spaceShip.objectState.objectBearing = 45;
    spaceShip.doInit();
    spaceShip.doRedraw();
    spaceShipWrap = GameEngine.createWrapObject(spaceShip, "SpaceShip.qml");

    // Create the wrappable alienShip
    alienShip = GameEngine.createSpaceObject(gameParent, "AlienShip.qml");
    GameEngine.doResetObjectPositionToCenter(alienShip, gameAreaMaxX, gameAreaMaxY);
    alienShip.objectState.objectPosX += 100;
    alienShip.objectState.objectHidden = true;
    alienShip.objectState.objectHidden = true;
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
        var speedXY = 5 * (Math.min(level,3) - 1) + (8 - sizeFactor) * 2.5;
        asteroids[index].objectState.objectSpeedX = GameEngine.getRandomSpeed(30, 100 + speedXY);
        asteroids[index].objectState.objectSpeedY = GameEngine.getRandomSpeed(0.3, 100 + speedXY);
        asteroids[index].objectState.objectSpeedRotation = GameEngine.getRandomSpeed(0.1, 0.3);
        asteroids[index].objectState.objectSizeMultiplier = sizeFactor;
        GameEngine.doResetObjectPositionToRandomPosition(asteroids[index], gameAreaMaxX, gameAreaMaxY, false);
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
    if (bullets == null) {
        bullets = new Array(0);
    }
    if (alienbullets == null) {
        alienbullets = new Array(0);
    }
}

function createBullets()
{
    spaceShip.weapons?.cannonList?.forEach( cannon => createBullet(spaceShip, cannon) );
    spaceShip.weaponsUlti?.cannonList?.forEach( cannon => createBullet(spaceShip, cannon) );
}

function createBullet( ship, cannon )
{
    if (!cannon.cannonPoweredUp) return;
    var bullet = GameEngine.createSpaceObject(gameParent, "Bullet.qml");
    bullet.objectState.objectBearing = ship.objectState.objectBearing + cannon.r_angle;
    var result = GameEngine.rotateVectorAroundOrigin(
                { x: ship.objectState.objectPosX, y: ship.objectState.objectPosY},
                { x: cannon.r_x, y: cannon.r_y}, ship.objectState.objectBearing);
    bullet.objectState.objectPosX = result.x;
    bullet.objectState.objectPosY = result.y;
    bullet.objectState.objectSpeedX =  1000 * Math.sin(bullet.objectState.objectBearing * Math.PI/180);
    bullet.objectState.objectSpeedY = -1000 * Math.cos(bullet.objectState.objectBearing * Math.PI/180);
    bullet.objectState.objectSizeMultiplier = 50;
    //console.log("GAME: " + bullet.objectState.objectType + bullets.length + " created: " + bullet.objectState.objectSpeedX + "/" + bullet.objectState.objectSpeedY);
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
        if (objects[ii].objectState.objectDestroy || objectsWrap[ii].objectState.objectDestroy)
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
        if (objects[ii].objectState.objectDestroy)
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
    if (object.objectState.objectDestroy)
    {
        object.destroy();
        object = null;
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
    if (source.objectState.objectHidden === true) return;
    if (source.objectState.objectDesroyed === true) return;
    if (target.objectState.objectHidden === true) return;
    if (target.objectState.objectDesroyed === true) return;

    if ( GameEngine.isPointInsideCircle( source.objectState.objectPosX, source.objectState.objectPosY,
                                         source.objectState.objectSizePixelScaled/2 + target.objectState.objectSizePixelScaled/2,
                                         target.objectState.objectPosX, target.objectState.objectPosY))
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
    element.objectState.objectDestroy = true;
    if (element.objectState.objectSizeMultiplier > 1)
    {
        spawnNewAsteroids(element);
    }
    spawnAsteroidDebris(element);
    increaseScore(element);
}

function onShipCollision(not_used)
{
    console.log("GAME: Ship destroyed ....");

    // Nice effect of ship being destroyed
    spawnShipDebris(spaceShip);

    if (lives <= 1)
    {
        gameOver = true;
        spaceShip.objectState.objectHidden = true;
        spaceShipWrap.objectState.objectHidden = true;
        spaceShip.objectState.objectDestroy = true;
        spaceShipWrap.objectState.objectDestroy = true;
    }
    else
    {
        spaceShip.objectState.objectHidden = true;
        spaceShipWrap.objectState.objectHidden = true;
        lives--;
    }
}

function onAlienShipCollision(not_used)
{
    console.log("GAME: Alien Ship destroyed ....");

    // Nice effect of ship being destroyed
    spawnAsteroidDebris(alienShip);

    alienShip.objectState.objectHidden = true;
    alienShipWrap.objectState.objectHidden = true;
    resetTimerNextAlienShipVisibility();

    increaseScore(alienShip);
}

function onBulletHits(bullet)
{
    bullet.objectState.objectDestroy = true;
}

////////////////////////////////////////////////////////////////////////////////////////////////
// Object movement over time
////////////////////////////////////////////////////////////////////////////////////////////////

function doPositionAdjust(object, objectWrap, millis)
{
    if (object === null) return;
    object.objectState.objectPosX += object.objectState.objectSpeedX * millis / 1000;
    object.objectState.objectPosY += object.objectState.objectSpeedY * millis / 1000;
    object.objectState.objectBearing += object.objectState.objectSpeedRotation * 360 * millis / (1000);

    // Wrap coordinates
    if ( objectWrap !== null)
    {
        GameEngine.doWrapCoordinates(object, objectWrap, gameAreaMaxX, gameAreaMaxY);
    }
    else
    {
        // If no wrap object exist, the object is to be destroyed when it goes off the screen
        if (object.objectState.objectPosX < 0 || object.objectState.objectPosX > gameAreaMaxX ||
            object.objectState.objectPosY < 0 || object.objectState.objectPosY > gameAreaMaxY)
        {
            object.objectState.objectDestroy = true;
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
        asteroids[index].objectState.objectPosX = asteroid.objectState.objectPosX;
        asteroids[index].objectState.objectPosY = asteroid.objectState.objectPosY;
        asteroids[index].objectState.objectSpeedX = GameEngine.getRandomSpeed(50, 100 + speedXY);
        asteroids[index].objectState.objectSpeedY = GameEngine.getRandomSpeed(50, 100 + speedXY);
        asteroids[index].objectState.objectSpeedRotation = GameEngine.getRandomSpeed(0.1 * level, 0.2 * level);
        asteroids[index].objectState.objectSizeMultiplier = asteroid.objectState.objectSizeMultiplier/2;
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
        debris[index].objectState.objectSpeedX = GameEngine.getRandomSpeed(20, 50);
        debris[index].objectState.objectSpeedY = GameEngine.getRandomSpeed(20, 50);
        debris[index].objectState.objectPosX = asteroid.objectState.objectPosX;
        debris[index].objectState.objectPosY = asteroid.objectState.objectPosY;
        debris[index].objectState.objectSizeMultiplier = 1;
        debris[index].objectState.objectColor = asteroid.objectState.objectColor;
        debris[index].objectState.objectLifetimeMs = GameEngine.getRandomValue(200,800);
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
        debris[index].objectState.objectSpeedX = GameEngine.getRandomSpeed(0, 300);
        debris[index].objectState.objectSpeedY = GameEngine.getRandomSpeed(0, 300);
        debris[index].objectState.objectSpeedRotation = GameEngine.getRandomSpeed(-1, 1);
        debris[index].objectState.objectPosX = ship.objectState.objectPosX;
        debris[index].objectState.objectPosY = ship.objectState.objectPosY;
        debris[index].objectState.objectSizeMultiplier = GameEngine.getRandomValue(5, 20);
        debris[index].objectState.objectColor = ship.objectState.objectColor;
        debris[index].objectState.objectLifetimeMs = GameEngine.getRandomValue(1000,2000);
        debris[index].doInit();
        debris[index].doRedraw();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////
// Alien ship handling
////////////////////////////////////////////////////////////////////////////////////////////////

function doAlienShipHandling()
{
    if (!alienShip)
        return;

    if (!alienShipNextActionMs)
    {
        resetTimerNextAlienShipVisibility();
        initTimerNextAlienShipShoot();
    }

    if (gameTimeStampMs >= alienShipNextActionMs)
    {
        if (alienShip.objectState.objectHidden)
        {
            if (spaceShip.objectState.objectHidden) return;

            // Start from the right screen any position and the move to the left
            alienShip.objectState.objectPosX = gameAreaMaxX - alienShip.objectState.objectSizePixelScaled/2;
            alienShip.objectState.objectPosY = GameEngine.getRandomValue(0 + alienShip.objectState.objectSizePixelScaled/2,
                                                             gameAreaMaxY - alienShip.objectState.objectSizePixelScaled/2);
            alienShip.objectState.objectSpeedX = -50;
            alienShip.objectState.objectSpeedY = GameEngine.getRandomValue(-30,30);
            alienShip.objectState.objectHidden = false;
            GameEngine.doWrapCoordinates(alienShip, alienShipWrap, gameAreaMaxX, gameAreaMaxY);
            resetTimerNextAlienShipVisibility();
            initTimerNextAlienShipShoot();
        }
        else
        {
            // When alienShip reaches the left edge make it disapear
            if(alienShip.objectPosX <= alienShip.objectState.objectSizePixelScaled/2)
            {
                alienShip.objectState.objectHidden = true;
                alienShipWrap.objectState.objectHidden = true;
                resetTimerNextAlienShipVisibility();
            }
        }
    }
    if ( !alienShip.objectState.objectHidden && !spaceShip.objectState.objectHidden && gameTimeStampMs >= alienShipNextShootMs )
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
    bullet.objectState.objectPosX = alienShip.objectState.objectPosX;
    bullet.objectState.objectPosY = alienShip.objectState.objectPosY;
    bullet.objectState.objectBearing = Math.atan2( (spaceShip.objectState.objectPosX - alienShip.objectState.objectPosX),
                                                  -(spaceShip.objectState.objectPosY - alienShip.objectState.objectPosY))
            * 180 / Math.PI;
    var tmpSpeed = 60 + Math.min(level, 3) * 20; // Bullet speed increase per level (must be faster than ship)
    bullet.objectState.objectSpeedX =  tmpSpeed * Math.sin(bullet.objectState.objectBearing * Math.PI/180);
    bullet.objectState.objectSpeedY = -tmpSpeed * Math.cos(bullet.objectState.objectBearing * Math.PI/180);
    bullet.objectState.objectSizeMultiplier = 30;
    bullet.objectState.objectLifetimeMs = 4000 + (2000 * level); // Bullet radius increase per level (limit is screen)
    //console.log("GAME: " + bullet.objectState.objectType + bullets.length + " created: " + bullet.objectState.objectSpeedX + "/" + bullet.objectState.objectSpeedY);
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
    //console.log("GAME: time = " + timeNow + ", diff = " + millis);

    if (pause) return;
    if (spaceShip !== null)
    {
        // Rotate ship
        if (keyLeft)  { spaceShip.objectState.objectBearing -= spaceShip.shipTurnSpeed * 360 * millis / 1000; }
        if (keyRight) { spaceShip.objectState.objectBearing += spaceShip.shipTurnSpeed * 360 * millis / 1000; }
        spaceShip.objectState.objectBearing = spaceShip.objectState.objectBearing % 360;

        // Ship thrust
        spaceShip.shipThrust = keyUp
        if (keyUp)
        {
            spaceShip.objectState.objectSpeedX +=  (spaceShip.shipAcceleration * millis/1000) * Math.sin(spaceShip.objectState.objectBearing * Math.PI/180);
            spaceShip.objectState.objectSpeedY += -(spaceShip.shipAcceleration * millis/1000) * Math.cos(spaceShip.objectState.objectBearing * Math.PI/180);
            spaceShip.objectState.objectSpeedX = GameEngine.limitMinMax(spaceShip.objectState.objectSpeedX, -1000, 1000);
            spaceShip.objectState.objectSpeedY = GameEngine.limitMinMax(spaceShip.objectState.objectSpeedY, -1000, 1000);
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
    if (spaceShip !== null && !spaceShip.objectState.objectHidden)
    {
        if (requestShoot)
        {
            createBullets();
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

function doUltiActivation(activated)
{
    spaceShip.ultiActivated = activated;
}

function getStatistics()
{
    var strRet = "Asteroids : " + asteroids.length + "/" + asteroidsWrap.length;
    strRet += " Bullets : " + bullets.length + "/" + alienbullets.length;
    strRet += " Debris : " + debris.length;
    return strRet;
}
