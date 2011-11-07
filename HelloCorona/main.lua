local background = display.newImage("background.png")

local ground = display.newImage("ground.png")
ground.y = display.contentHeight - ground.height / 2

local crate = display.newImage("crate.png")
crate.x = display.contentCenterX

local physics = require( "physics" )
physics.start()
physics.addBody(ground, "static")
physics.addBody(crate)