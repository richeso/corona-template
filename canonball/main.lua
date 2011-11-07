-- example Corona SDK/Lua demo



local cannonBase    = nil
local cannon        = nil
local cannonGroup   = nil

cannonRotation  = 0
rotateAmt       = 5
rotMin          = -40
rotMax          = 80

cannonForce     = 1200
playerPoints    = 0

function update()
    
    -- has the target fallen below the ground?
    if (target.x < 0) then
        scorePoint()
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
    target.x = math.random(10,300)
    target.y = math.random(100,300) + 170
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
        bullet = display.newImage('cannonball.png')             
        
        -- determine a point along the cannon barrel in world coordinates
        cannon_x, cannon_y = cannonBarrel:localToContent(70,0)
        
        -- move the image
        bullet.x = cannon_x
        bullet.y = cannon_y
        physics.setDrawMode('hybrid')
        -- apply physics to the cannonball
        physics.addBody( bullet, { density=3.0, friction=0.2, bounce=0.05, radius=15 } )
        
        -- determine the appropriate ratio of horizontal to vertical force
        force_x = math.sin(math.rad(-cannonRotation)) * cannonForce
        force_y = math.cos(math.rad(-cannonRotation)) * cannonForce
        
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
    
    interface.rotation = 90
    interface:translate(300,5)
    
    display.getCurrentStage():insert(interface)
    
    scoreDisplay = display.newText( ("Points: " .. playerPoints), 0, 0, native.systemFont, 40 )
    scoreDisplay.rotation = 90
    scoreDisplay.x = display.contentWidth - 40
    scoreDisplay.y = display.contentHeight - 100
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
    cannonGroup.rotation = 90
    cannonGroup:translate(70,50)
    
    -- add the cannon to the stage
    display.getCurrentStage():insert(cannonGroup)
    
end

function onCollide(event)
    -- make the target active, so that it falls
    -- actually resetting of the target happens n the update function
    target.bodyType = 'dynamic'
end

function init()
    display.setStatusBar(display.HiddenStatusBar)
    
    physics = require('physics')
    physics.start()

    physics.setDrawMode('hybrid')
    physics.setGravity(-9.81, 0)
    background  = display.newImage('brick_back.png',0,0,true)
    
    makeInterface()
    makeCannon()    
    
    target = display.newImage('target.png')
    physics.addBody(target,{ density=3.0, friction=0.5, bounce=0.05, radius=30})
    target.bodyType = 'static'
    target:addEventListener('collision',onCollide)
    
    resetTarget()
    
    Runtime:addEventListener('enterFrame',update)
    -- Runtime:addEventListener('touch',onTouch)
end

init()