module(..., package.seeall)

function new()
	local localGroup = display.newGroup()
	--> This is how we start every single file or "screen" in our folder, except for main.lua
	-- and director.lua
	--> director.lua is NEVER modified, while only one line in main.lua changes, described in that file
------------------------------------------------------------------------------
------------------------------------------------------------------------------
--local background = display.newImage ("redbackground.png")
--localGroup:insert(background)
--> This sets the background

local background = display.newImage("background.png")
localGroup:insert(background)


local backbutton = display.newImage ("backbutton.png")
backbutton.x = 160
backbutton.y = 100
localGroup:insert(backbutton)

local ground = display.newImage("ground.png")
ground.y = display.contentHeight - ground.height / 2

localGroup:insert(ground)


local crate = display.newImage("crate.png")
crate.x = display.contentCenterX

localGroup:insert(crate)

local physics = require( "physics" )
physics.start()
physics.addBody(ground, "static")
physics.addBody(crate)

--> This places our "back" button

local function pressBack (event)
if event.phase == "ended" then
director:changeScene ("menu")
end
end

backbutton:addEventListener ("touch", pressBack)
--> This adds the function and listener to the "back" button

------------------------------------------------------------------------------
------------------------------------------------------------------------------
	return localGroup
end
--> This is how we end every file except for director and main, as mentioned in my first comment