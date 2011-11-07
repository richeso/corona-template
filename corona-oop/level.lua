module(..., package.seeall)
local physics = require("physics")
local Scene = require("scene")

--decorator--------------------
function decorate(obj)	--object to decorate
	Scene.decorate(obj)
	
	function obj:setup_walls()
		self.walls = {}
		
		--screen edges
		self.walls[1] = display.newRect(320, 0, 1, 480)
		self.walls[2] = display.newRect(0, 480, 320, 1)
		self.walls[3] = display.newRect(0, -1, 320, 1)
		self.walls[4] = display.newRect(-1, 0, 1, 480)
		
		local staticMaterial = {density = 2, friction = 1, bounce=.4}
		for i=1, #self.walls do
			physics.addBody(self.walls[i], "static", staticMaterial)
			self:insert(self.walls[i])
		end
	end
end