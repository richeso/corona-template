-- example Corona SDK/Lua demo
require "sprite"

local levels = {}

levels[1] = {{1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
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
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
             {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},}

local bricks = display.newGroup()
local brickRadius = 3

local cannonBase    = nil
local cannon        = nil
local cannonGroup   = nil

cannonRotation  = 0
rotateAmt       = 5
rotMin          = -40
rotMax          = 80

cannonForce     = 1200
playerPoints    = 0

function buildLevel(level)
    -- Level length, height
    local len = table.maxn(level)
    bricks:toFront()

    for i = 1, len do
        for j = 1, 32 do
            if(level[i][j] == 1) then
                --local brick = display.newImage('brick.png')
                local brick = display.newCircle (0, 0, brickRadius)
                --local brick = display.newRect (0, 0, brickRadius, brickRadius)
                brick:setFillColor(32,178,170);
                brick.name = 'brick'
                brick.x = brickRadius  * 1 * j +250
                brick.y = brickRadius  * 1 * i +150
                physics.addBody(brick, {density = 1, friction = 0, bounce = 0})
                --physics.addBody(brick, {isSensor = true})
                brick:addEventListener('collision', brickCollision)
                brick.bodyType = 'static'
                bricks.insert(bricks, brick)
            end
        end
    end
end

function update()
    
    -- has the target fallen below the ground?
    if (target.y > display.contentHeight or target.x > display.contentWidth) then
        scorePoint ()
        pointDisplay.text= "Targ: " .. math.floor(target.x) .. " " .. math.floor(target.y) .. " " .. display.contentWidth .. " " .. display.contentHeight

        resetTarget()
    end

end

function onTouch(event)
    print(event.x,event.y)
end

function scorePoint()
    playerPoints = playerPoints + 1
    print(playerPoints)
    scoreDisplay.text = "Points: " .. playerPoints
end

function resetTarget()
    target.bodyType = 'static'      -- turn physics off on the target
    target.x = math.random(160,400)
    target.y = math.random(50, 200)
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
        bullet = display.newCircle (event.x, event.y, 2)
        bullet:setFillColor(255, 3, 0);
        -- determine a point along the cannon barrel in world coordinates
        cannon_x, cannon_y = cannonBarrel:localToContent(70,0)
        
        -- move the image
        bullet.x = cannon_x
        bullet.y = cannon_y

        -- physics.setDrawMode('debug')
        -- apply physics to the cannonball
        physics.addBody( bullet, {density=3.0, friction=0.2, bounce=0.05, radius=2 } )

        --physics.addBody(bullet, {isSensor = true})
        -- determine the appropriate ratio of horizontal to vertical force
        force_y = math.sin(math.rad(cannonRotation)) * cannonForce
        force_x = math.cos(math.rad(cannonRotation)) * cannonForce
        
        -- fire the cannonball            
        bullet:applyForce( force_x, force_y, bullet.x, bullet.y )
        
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

function targetCollision(event)
    -- make the target active, so that it falls
    -- actually resetting of the target happens n the update function
    target.bodyType = 'dynamic'
end


function newExplosionSprite()
	local explosion = sprite.newSprite(explosionSet)
	explosion:prepare("default")
	explosion.isHitTestable = false
	return explosion
end

function brickCollision(event)
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
    
    target=display.newImage('target.png')
    physics.addBody(target,{ density=3.0, friction=0.5, bounce=0.05, radius=10})
    target.bodyType = 'static'
    target:addEventListener('collision',targetCollision)
    
    resetTarget()
    pointDisplay = display.newText( ("Targ: " .. target.x .." "..target.y), 0, 0, native.systemFont, 20 )
    --scoreDisplay.rotation = 90
    pointDisplay.x = 350
    pointDisplay.y = 20
    pointDisplay:setTextColor( 255,255,255 )

    Runtime:addEventListener('enterFrame',update)
    buildLevel(levels[1])
    -- Runtime:addEventListener('touch',onTouch)
    explosionSpriteSheet = sprite.newSpriteSheet("BigExplosion.png", 82, 117)
	explosionSet = sprite.newSpriteSet(explosionSpriteSheet, 1, 18)
	sprite.add(explosionSet, "default", 1, 18, 200, 1)
	popSound = audio.loadStream("bomb.mp3")
end

init()