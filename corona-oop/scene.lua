module(..., package.seeall)

--decorator--------------------
function decorate(obj)	--object to decorate
	print("--init new scene--")
	function obj:slideIn()
		self.x = 320
		transition.to(self, {time = 200, x = 0})
	end
	function obj:slideOut()
		transition.to(self, {time = 200, x = -320, onComplete = self})
	end
	function obj:onComplete(event)
		self:remove()
	end
end