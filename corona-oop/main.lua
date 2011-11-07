display.setStatusBar(display.HiddenStatusBar)
local physics = require("physics")
local Menu = require("menu")
local Level = {}
for i = 1, 3 do
	Level[i] = require("level"..i)
end

local random = math.random	--localized for performance

math.randomseed(os.time())
random()	--bug in first use
physics.start()
--physics.setDrawMode("debug")

local scene = nil

function go_menu()
	if scene then scene:slideOut() end
	scene = Menu.new(go_level)
	scene:slideIn()
end

function go_level(num)
	scene:slideOut()
	scene = Level[num].new(go_menu)
	scene:slideIn()
end

--[[	set the gc to work fast and heavy and check for leaks
collectgarbage("setpause", 50);
local function garbagePrinting()
    print("mem "..collectgarbage("count"));
    print("tex "..system.getInfo("textureMemoryUsed"));
end
Runtime:addEventListener("enterFrame", garbagePrinting);
--]]

--start the game--------------------
print("-----start-----")
go_menu()