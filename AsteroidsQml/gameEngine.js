function doResetObjectPositionToCenter(object, gameAreaMaxX, gameAreaMaxY)
{
    if (object === null)
    {
        console.error("ERROR: cannot center object - null");
        return;
    }
    object.objectState.objectPosX = gameAreaMaxX/2;
    object.objectState.objectPosY = gameAreaMaxY/2;
    //console.log(object.objectState.objectType + " (real) : x = " + object.objectState.objectPosX + ", y = " + object.objectState.objectPosY);
    object.doRedraw();
}

function doResetObjectPositionToRandomPosition(object, gameAreaMaxX, gameAreaMaxY)
{
    if (object === null)
        return;
    object.objectState.objectPosX = getRandomSpacePosition(gameAreaMaxX, 200);
    object.objectState.objectPosY = getRandomSpacePosition(gameAreaMaxY, 200);
    object.objectState.objectBearing = 0;
    //console.log(object.objectState.objectType + " (real) : x = " + object.objectState.objectPosX + ", y = " + object.objectState.objectPosY);
    object.doRedraw();
}
function getRandomSpacePosition(gameAreaMax, safeArea)
{
    var retVal = Math.random() * gameAreaMax;
    if (Math.abs(retVal - gameAreaMax/2) > safeArea)
    {
        return retVal;
    }
    return getRandomSpacePosition(gameAreaMax, safeArea);
}
function getRandomSpeed(min, max)
{
    if ( (Math.random() - 0.5) >= 0 )
    {
        return Math.max(min, min + Math.random() * (max - min));
    }
    else
    {
        return -Math.max(min, min + Math.random() * (max - min));
    }
}

function getRandomValue(min, max)
{
    return min + Math.random() * (max - min);
}

function limitMinMax(valueIn, minValue, maxValue)
{
    return Math.min(Math.max(minValue, valueIn), maxValue);
}

function createSpaceObject(parent, filename)
{
    var component = Qt.createComponent(filename);
    if (component.status === Component.Ready)
    {
        var objectWrap = component.createObject(parent)
        if (objectWrap === null)
        {
            console.log("Object created failed");
        }
        else
        {
            //console.log("Object created : " + objectWrap);
        }
        return objectWrap;
    }
    else
    {
        console.log("Wrap object component created failed");
        return null;
    }
}

function createWrapObject(parent, filename)
{
    var objectWrap = createSpaceObject(parent, filename);
    if (objectWrap !== null)
    {
        parent.copyInitialProperties(objectWrap)
        //objectWrap.objectState.objectColor = "blue"
        //console.log(objectWrap.objectState.objectType + " (wrap) : x = " + objectWrap.objectState.objectPosX + ", y = " + objectWrap.objectState.objectPosY);
    }
    return objectWrap;
}

function doWrapCoordinates(object, objectWrap, gameAreaMaxX, gameAreaMaxY)
{
    var limit = object.objectState.objectSizePixelScaled/2;
    if (object.objectState.objectPosX <= -limit) { object.objectState.objectPosX = object.objectState.objectPosX + gameAreaMaxX; }
    if (object.objectState.objectPosX >= gameAreaMaxX + limit) { object.objectState.objectPosX = object.objectState.objectPosX - gameAreaMaxX; }
    if (object.objectState.objectPosY <= -limit) { object.objectState.objectPosY = object.objectState.objectPosY + gameAreaMaxY; }
    if (object.objectState.objectPosY >= gameAreaMaxY + limit) { object.objectState.objectPosY = object.objectState.objectPosY - gameAreaMaxY; }
    if (objectWrap === null)
    {
        //console.log("no wrap");
    }
    else
    {
        // Bearing, thrust etc is kept the same
        object.copyDynamicProperties(objectWrap);

        // Wrap "ghost" ship to view the screen wrapping
        var bVisibleX = false;
        if ( object.objectState.objectPosX >= (gameAreaMaxX - limit) )
        {
            objectWrap.objectState.objectPosX = object.objectState.objectPosX - gameAreaMaxX;
            bVisibleX = !object.objectState.objectHidden;
        }
        else if ( object.objectState.objectPosX <= limit )
        {
            objectWrap.objectState.objectPosX = object.objectState.objectPosX + gameAreaMaxX;
            bVisibleX = !object.objectState.objectHidden;
        }
        else
        {
            objectWrap.objectState.objectPosX = object.objectState.objectPosX
        }
        var bVisibleY = false;
        if ( object.objectState.objectPosY >= (gameAreaMaxY - limit) )
        {
            objectWrap.objectState.objectPosY = object.objectState.objectPosY - gameAreaMaxY;
            bVisibleY = !object.objectState.objectHidden;
        }
        else if ( object.objectState.objectPosY <= limit )
        {
            objectWrap.objectState.objectPosY = object.objectState.objectPosY + gameAreaMaxY;
            bVisibleY = !object.objectState.objectHidden;
        }
        else
        {
            objectWrap.objectState.objectPosY = object.objectState.objectPosY
        }
        objectWrap.objectState.objectHidden = !(bVisibleX || bVisibleY);
    }
}

function isPointInsideCircle(cx, cy, radius, x, y)
{
    return Math.sqrt( (x - cx)*(x - cx) + (y - cy)*(y - cy) ) < radius;
}

function rotateVectorAroundOrigin(ovec_vector2d, objvec_2d, deg)
{
    // Note - upwards is y negative
    var resvec_2d = {x: 0, y: 0}
    resvec_2d.x = ( (objvec_2d.x * Math.cos(deg * Math.PI/180)) -
                    (objvec_2d.y * Math.sin(deg * Math.PI/180)) );
    resvec_2d.y = ( (objvec_2d.x * Math.sin(deg * Math.PI/180)) +
                    (objvec_2d.y * Math.cos(deg * Math.PI/180)) );
    resvec_2d.x += ovec_vector2d.x;
    resvec_2d.y += ovec_vector2d.y;
    return resvec_2d;
}
