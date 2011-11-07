local reader = require ("Reader")

local data = require ("coordinates")

reader:initialize( "Page", data)               

Runtime:addEventListener( "orientation", reader )

display.setStatusBar( display.HiddenStatusBar )
