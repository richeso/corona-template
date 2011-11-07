-- example Corona SDK/Lua demo
require "sprite"

local levels = {}

levels[1] = {{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},}

local bricks = display.newGroup()
local brickRadius = 8

local cannonBase    = nil
local cannon        = nil
local cannonGroup   = nil

cannonRotation  = 0
rotateAmt       = 3
rotMin          = -40
rotMax          = 80

cannonForce     = 60
playerPoints    = 0
maxBroken       = 10
numBroken       = 0

function buildLevel(level)
    -- Level length, height
    local len = table.maxn(level)
    bricks:toFront()
    local c1 = math.random(1,255)
    local c2 = math.random (1,255)
    local c3 = math.random(1,255)
    for i = 1, len do
        for j = 1, 32 do
            if(level[i][j] == 1) then
                --local brick = display.newImage('brick.png')
                local brick = display.newCircle (0, 0, brickRadius)
                --local brick = display.newRect (0, 0, brickRadius, brickRadius)
                --brick:setFillColor(32,178,170);
                brick:setFillColor(c1,c2,c3)
                brick.name = "brick"
                brick.x = brickRadius  * 1 * j +180
                brick.y = brickRadius  * 1 * i +180
                physics.addBody(brick, {density = 1, friction = 5, bounce = 0})
                --physics.addBody(brick, {isSensor = true})
                brick:addEventListener('collision', brickCollision)
                brick.bodyType = 'static'
                bricks.insert(bricks, brick)
            end
        end
    end
end

function update()
    -- update for each frame
end

function scorePoint()
    playerPoints = playerPoints + 1
    print(playerPoints)
    scoreDisplay.text = "Points: " .. playerPoints
end

function moveUp(event)
    -- only move the barell if the touch event started
    if (event.phase == 'began') then
        cannonRotation = cannonRotation - rotateAmt
        if (cannonRotation > rotMax) then
            cannonRotation = rotMax
        end
        
        cannonBarrel.rotation = cannonRotation
    end
end

function moveDown(event)
    -- only move the barell if the touch event started
    if (event.phase == 'began') then
        print('move down!')
        cannonRotation = cannonRotation + rotateAmt
        if (cannonRotation < rotMin) then
            cannonRotation = rotMin
        end
        
        cannonBarrel.rotation = cannonRotation
    end
end

function fire(event)
    -- only fire at the beginning of a touch event
    if (event.phase == 'began') then
        -- make a new image
        --bullet = display.newImage('canonball-small.png')
        bullet = display.newCircle (event.x, event.y, 4)
        bullet.name = "bullet"
        bullet:setFillColor(255, 3, 0);
        -- determine a point along the cannon barrel in world coordinates
        cannon_x, cannon_y = cannonBarrel:localToContent(70,0)
        
        -- move the image
        bullet.x = cannon_x
        bullet.y = cannon_y

        -- physics.setDrawMode('debug')
        -- apply physics to the cannonball
        physics.addBody( bullet, {density=3.0, friction=0.2, bounce=0.05, radius=4 } )

        bullet:addEventListener('collision', bulletCollision)
        --physics.addBody(bullet, {isSensor = true})
        -- determine the appropriate ratio of horizontal to vertical force
        force_y = math.sin(math.rad(cannonRotation)) * cannonForce
        force_x = math.cos(math.rad(cannonRotation)) * cannonForce
        
        -- fire the cannonball            
        bullet:applyForce( force_x, force_y, bullet.x, bullet.y )

        numBroken = 0
        -- make sure that the cannon is on top of the 
        cannonGroup:toFront()
    end
end

-- this function creates the interface- buttons for moving the cannon and firing
-- as well as the display of points
function makeInterface()
    interface = display.newGroup()
    
    upButton = display.newImage('up_button.png')
        
    fireButton = display.newImage('fire_button.png')
    fireButton:translate(0,75)
        
    downButton = display.newImage('down_button.png')
    downButton:translate(0,110)
    
    interface:insert(upButton)
    interface:insert(downButton)
    interface:insert(fireButton)
    
    upButton:addEventListener('touch',moveUp)
    fireButton:addEventListener('touch',fire)
    downButton:addEventListener('touch',moveDown)
    
    --interface.rotation = 90
    interface:translate(5,5)
    
    display.getCurrentStage():insert(interface)
    
    scoreDisplay = display.newText( ("Points: " .. playerPoints), 0, 0, native.systemFont, 20 )
    --scoreDisplay.rotation = 90
    scoreDisplay.x = 150
    scoreDisplay.y = 20

    scoreDisplay:setTextColor( 255,255,255 )
end

function makeCannon()
    -- create a couple of display groups
    cannonGroup = display.newGroup()
    cannonBarrel = display.newGroup()

    -- load the images
    cannon      = display.newImage('cannon_sm.png')
    cannonBase  = display.newImage('cannon_base_sm.png')
    
    -- use a separate group to offset the registration point of the barrel
    cannonBarrel:insert(cannon)
    cannon:translate(-52,-30)
    
    cannonBarrel:translate(60,0)    
    cannonGroup:insert(cannonBarrel)
    cannonGroup:insert(cannonBase)
    
    -- rotate and move the cannon to the bottom-left corner
    --cannonGroup.rotation = 90
    cannonGroup:translate(10,250)
    -- add the cannon to the stage
    display.getCurrentStage():insert(cannonGroup)
    
end


function newExplosionSprite()
	local explosion = sprite.newSprite(explosionSet)
	explosion:prepare("default")
	explosion.isHitTestable = false
	return explosion
end

function brickCollision(event)
    print("event.other.name=" .. event.other.name)
    if (event.other.name == 'bullet') then
      local brick = event.target
      local explosion = newExplosionSprite()
      explosion.x = brick.x
      explosion.y = brick.y
      explosion:addEventListener("end", onBoomEnd)
      explosion:play()
      audio.play(popSound)
      --physics.setDrawMode('hybrid')
      event.target:removeSelf()
      bricks:toFront()
      crate:toFront()
      numBroken = numBroken + 1
    end
end


function bulletCollision(event)
    if (numBroken >= maxBroken) then
      event.target:removeSelf()
    end
end

function onBoomEnd(event)
	event.target:removeSelf()
end

function init()
    display.setStatusBar(display.HiddenStatusBar)
    
    physics = require('physics')
    physics.start()

    --physics.setDrawMode('hybrid')
    physics.setGravity(0, 9.81)
    background  = display.newImage('brick_back.png',0,0,true)
    
    makeInterface()
    makeCannon()    

    Runtime:addEventListener('enterFrame',update)
    buildLevel(levels[1])
    -- Runtime:addEventListener('touch',onTouch)
    explosionSpriteSheet = sprite.newSpriteSheet("BigExplosion.png", 82, 117)
	explosionSet = sprite.newSpriteSet(explosionSpriteSheet, 1, 18)
	sprite.add(explosionSet, "default", 1, 18, 200, 1)
	popSound = audio.loadStream("pop.wav")
    crate = display.newImage("crate.png")
    crate.name = "crate"
    crate.x = display.contentCenterX
    physics.addBody(crate, {density = 1, friction = 5, bounce = 0})

end

init()