module(..., package.seeall)
local physics = require("physics")

local random = math.random	--localized for performance

--decorator--------------------
function decorate(obj)	--object to decorate
	obj.speed = -random() * .5 - .5
	
	--respond to touch event--------------------
	function obj:touch(event)
		if event.phase == "began" then
			self:applyLinearImpulse(0, self.speed, self.x, self.y)
		end
		
		return true
	end
	
--destroy--------------------
	function obj:remove()
		Runtime:removeEventListener("enterFrame", self)
		Runtime:removeEventListener("touch", self)
		self:removeSelf()
	end
	
	if obj.bodyType == nil then
		physics.addBody(obj, {density=random(), bounce=random() * .8, radius=10})
	end
	Runtime:addEventListener("touch", obj)
end