function doResetObjectPositionToCenter(object, gameAreaMaxX, gameAreaMaxY)
{
    if (object === null)
    {
        console.error("ERROR: cannot center object - null");
        return;
    }
    object.objectPosX = gameAreaMaxX/2;
    object.objectPosY = gameAreaMaxY/2;
    //console.log(object.objectType + " (real) : x = " + object.objectPosX + ", y = " + object.objectPosY);
    object.doRedraw();
}

function doResetObjectPositionToRandomPosition(object, gameAreaMaxX, gameAreaMaxY)
{
    if (object === null)
        return;
    object.objectPosX = getRandomSpacePosition(gameAreaMaxX, 200);
    object.objectPosY = getRandomSpacePosition(gameAreaMaxY, 200);
    object.objectBearing = 0;
    //console.log(object.objectType + " (real) : x = " + object.objectPosX + ", y = " + object.objectPosY);
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
        //objectWrap.objectColor = "blue"
        //console.log(objectWrap.objectType + " (wrap) : x = " + objectWrap.objectPosX + ", y = " + objectWrap.objectPosY);
    }
    return objectWrap;
}

function doWrapCoordinates(object, objectWrap, gameAreaMaxX, gameAreaMaxY)
{
    var limit = object.objectSizePixelScaled/2;
    if (object.objectPosX <= -limit) { object.objectPosX = object.objectPosX + gameAreaMaxX; }
    if (object.objectPosX >= gameAreaMaxX + limit) { object.objectPosX = object.objectPosX - gameAreaMaxX; }
    if (object.objectPosY <= -limit) { object.objectPosY = object.objectPosY + gameAreaMaxY; }
    if (object.objectPosY >= gameAreaMaxY + limit) { object.objectPosY = object.objectPosY - gameAreaMaxY; }
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
        if ( object.objectPosX >= (gameAreaMaxX - limit) )
        {
            objectWrap.objectPosX = object.objectPosX - gameAreaMaxX;
            bVisibleX = !object.objectHidden;
        }
        else if ( object.objectPosX <= limit )
        {
            objectWrap.objectPosX = object.objectPosX + gameAreaMaxX;
            bVisibleX = !object.objectHidden;
        }
        else
        {
            objectWrap.objectPosX = object.objectPosX
        }
        var bVisibleY = false;
        if ( object.objectPosY >= (gameAreaMaxY - limit) )
        {
            objectWrap.objectPosY = object.objectPosY - gameAreaMaxY;
            bVisibleY = !object.objectHidden;
        }
        else if ( object.objectPosY <= limit )
        {
            objectWrap.objectPosY = object.objectPosY + gameAreaMaxY;
            bVisibleY = !object.objectHidden;
        }
        else
        {
            objectWrap.objectPosY = object.objectPosY
        }
        objectWrap.objectHidden = !(bVisibleX || bVisibleY);
    }
}

function isPointInsideCircle(cx, cy, radius, x, y)
{
    return Math.sqrt( (x - cx)*(x - cx) + (y - cy)*(y - cy) ) < radius;
}
