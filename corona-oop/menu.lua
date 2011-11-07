module(..., package.seeall)
local ui = require("ui")
local Scene = require("scene")

--constructor--------------------
function new(func)	--level button function
	local obj = display.newGroup()
	Scene.decorate(obj)
	
	obj.bg = display.newImageRect(obj, "menu.png", 320, 480)
	obj.bg.x = 160 obj.bg.y = 240
	
	obj.button1 = ui.newButton{
		defaultSrc = "buttonBlue.png", defaultX = 298, defaultY = 56,
		overSrc = "buttonBlueOver.png", overX = 298, overY = 56,
		onRelease = function()func(1)end,	--use a function closure to pass parameter
		text = "Level 1",
		emboss = true
	}
	obj:insert(obj.button1)
	obj.button1.x = 160
	obj.button1.y = 220
	
	obj.button2 = ui.newButton{
		defaultSrc = "buttonBlue.png", defaultX = 298, defaultY = 56,
		overSrc = "buttonBlueOver.png", overX = 298, overY = 56,
		onRelease = function()func(2)end,	--use a function closure to pass parameter
		text = "Level 2",
		emboss = true
	}
	obj:insert(obj.button2)
	obj.button2.x = 160
	obj.button2.y = 300
	
	obj.button3 = ui.newButton{
		defaultSrc = "buttonBlue.png", defaultX = 298, defaultY = 56,
		overSrc = "buttonBlueOver.png", overX = 298, overY = 56,
		onRelease = function()func(3)end,	--use a function closure to pass parameter
		text = "Level 3",
		emboss = true
	}
	obj:insert(obj.button3)
	obj.button3.x = 160
	obj.button3.y = 380
	
--destroy--------------------
	function obj:remove()
		self.bg:removeSelf()
		
		for i=self.button1.numChildren, 1, -1 do self.button1[i]:removeSelf() end
		for i=self.button2.numChildren, 1, -1 do self.button2[i]:removeSelf() end
		for i=self.button3.numChildren, 1, -1 do self.button3[i]:removeSelf() end
		self.button1:removeSelf()
		self.button2:removeSelf()
		self.button3:removeSelf()
		
		self:removeSelf()
	end
	
	return obj
end