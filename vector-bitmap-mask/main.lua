---
-- Created by IntelliJ IDEA.
-- User: richard
-- Date: 11-10-27
-- Time: 10:31 PM
-- To change this template use File | Settings | File Templates.
--
--[[
TapFingerShot -- a demo of vector based masking with Corona
By Kenn W @ 21x20 Media
June 23rd, 2011

This paints a blue screen in the front with a red screen behind it.
Between the screens, there's lots of letters to prove we're masking. ;-)

As you tap the screen, shots are fired through the blue and the red
and the letters under the blue are shown.
]]--


--[[###########################################]]--
-- When the foreground is tap'd ... do this:
function onTap ( event )
    --physics.removeBody(thisMainRect)
    -- paint our 'bullet hole' black...
        local thisCirc = display.newCircle (event.x, event.y, 30)
        dynamicMask:insert(thisCirc);
        thisCirc:setFillColor(0, 0, 0);

    -- now the magic:
        display.save (dynamicMask, "tmp.jpg",  system.TemporaryDirectory)

        -- load the last saved image as our mask.
        local mask = graphics.newMask( "tmp.jpg", system.TemporaryDirectory )

    -- apply or re-apply the mask.
        thisMainRect:setMask(nil)
        thisMainRect:setMask(mask)

        -- this next bit is due to some weird bug in corona with masks...
        -- if you nil a mask, the next maskX and maskY are not right...
        -- and setting them to 0 is ignored.
        -- setting them to .01 doesn't move anything
        --  but it does make sure they're in the right spot.
        thisMainRect.maskX = .01;--display.contentWidth/4
        thisMainRect.maskY = .01;--display.contentHeight/4
        --physics.addBody(thisMainRect,"static")
        return true

end

local background = display.newImage("background.png")

thisMainRect = display.newRect (0,100,display.contentWidth, display.contentHeight/2)
thisMainRect:addEventListener("tap", onTap)
--thisMainRect:setFillColor(0,0,150);
thisMainRect:setFillColor(244, 242, 147);

--[[###########################################]]--
-- Let's make a "mask" group for our vector...
dynamicMask = display.newGroup();
dynamicMask:toBack();
local thisRect = display.newRect (-50, -50,display.contentWidth+100, display.contentHeight+100)
dynamicMask:insert(thisRect);
thisRect.x =display.contentWidth/2;
thisRect.y = display.contentHeight/2

local ground = display.newImage("ground.png")
ground.y = display.contentHeight - ground.height / 2


local crate = display.newImage("crate.png")
crate.x = display.contentCenterX

local physics = require( "physics" )
physics.start(true)
--physics.setDrawMode( "debug" ) -- shows collision engine outlines only
--physics.setDrawMode( "hybrid" ) -- overlays collision outlines on normal Corona objects
physics.setDrawMode( "normal" ) -- the default Corona renderer, with no collision outline
physics.addBody(ground, "static")
physics.addBody(thisMainRect,"static")
physics.addBody(crate)
