module(..., package.seeall)
local ui = require("ui")
local physics = require("physics")
local Level = require("level")
local Floater = require("floater")

--constructor--------------------
function new(func)	--menu button function
	local obj = display.newGroup()
	Level.decorate(obj)
	
	obj.bg = display.newImage(obj, "level2.png", 320, 480)
	obj.bg.x = 160 obj.bg.y = 240
	
	obj:setup_walls()--method from Level
	
	--moving entities
	obj.entities = {}
	for i = 1, 5 do
		obj.entities[i] = display.newImage(obj, "entity.png", 16, 16)
		obj.entities[i].x = 30 * i + 70
		obj.entities[i].y = 0
		Floater.decorate(obj.entities[i])
	end
	
	obj.button = ui.newButton{
		defaultSrc = "up.png", defaultX = 30, defaultY = 30,
		overSrc = "down.png", overX = 30, overY = 30,
		onRelease = func
	}
	obj:insert(obj.button)
	obj.button.x = 300
	obj.button.y = 20
	
--destroy--------------------
	function obj:remove()
		self.bg:removeSelf()
		for i = 1, #self.walls do
			self.walls[i]:removeSelf()
		end
		for i = 1, #self.entities do
			self.entities[i]:remove()
		end
		
		for i=self.button.numChildren, 1, -1 do self.button[i]:removeSelf() end
		self.button:removeSelf()
		
		self:removeSelf()
	end
	
	return obj
end