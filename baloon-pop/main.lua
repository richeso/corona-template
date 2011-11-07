--[[

Open Source Initiative OSI - The MIT License:Licensing

The MIT License

Copyright (c) <year> <copyright holders>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]--

--[[

Balloon Pop

A simple, unfinished Lua game.  Shows how to:
- use sprite sheets (for explosion)
- how to play audio
- how to animate objects
- handle touch events

Jesse Warden
jesterxl@jessewarden.com
twitter.com/jesterxl

]]--


require "sprite"

function newExplosionSprite()
	local explosion = sprite.newSprite(explosionSet)
	explosion:prepare("default")
	explosion.isHitTestable = false
	return explosion
end

function onBoomEnd(event)
	event.target:removeSelf()
end

function getNewBalloon()
	if(balloonCount < maxBalloons) then
		randomNum = math.random(totalColors)
		colorName = colors[randomNum]
		local balloon = display.newImage("balloon-" .. colorName .. ".png")
		return balloon
	else
		return getBalloonFromPool()
	end
end

function addBalloonToPool(balloon)
	balloonPool[balloonCount] = balloon
	balloonCount = balloonCount + 1
end

function getBalloonFromPool()
	local balloon = balloonPool[balloonCount]
	balloonPool[balloonCount] = nil
	return balloon
end
	
function addBalloon()
	currentBalloonsShown = currentBalloonsShown + 1
	balloonsPerLevel = balloonsPerLevel - 1
	local balloon = getNewBalloon()
	balloon:addEventListener("touch", onTouch)
	balloon.y = display.contentHeight + balloon.contentHeight
	balloon.x = math.random(display.contentWidth)
	local tween = transition.to(balloon, {time=5000, y=-100, onComplete=onBalloonEscaped})
	currentBalloons[balloon] = {balloon=balloon, tween=tween}
	return balloon
end

function onBalloonEscaped(balloon)
	print("Balloon Escaped")
	removeBalloon(balloon)
end

function removeBalloon(balloon)
	currentBalloonsShown = currentBalloonsShown - 1
	local balloonObject = currentBalloons[balloon]
	transition.cancel(balloonObject.tween)
	balloonObject.tween = nil
	balloonObject.balloon = nil
	currentBalloons[balloonObject] = nil
	balloon:removeEventListener("touch", onTouch)
	addBalloonToPool(balloon)
end
	
function startBalloons()
	Runtime:addEventListener("enterFrame", onTick)
end

function onTick()
	if(balloonsPerLevel > 0) then
		if(currentBalloonsShown < balloonsShownPerLevel) then
			addBalloon()
		end
	end
end

function onTouch(event)
	local balloon = event.target
	balloon.isVisible = false
	local explosion = newExplosionSprite()
	explosion.x = balloon.x
	explosion.y = balloon.y
	explosion:addEventListener("end", onBoomEnd)
	explosion:play()
	removeBalloon(balloon)
	audio.play(popSound)
end

local function init()
	level = 1
	colors = {"yellow", "blue", "green", "red", "purple", "white"}
	colorName = ""
	balloonPool = {}
	totalColors = 6
	randomNum = 0
	maxBalloons = 12
	balloonCount = 0

	balloonsPerLevel = 3
	balloonsShownPerLevel = 1
	currentBalloonsShown = 0
	currentBalloons = {}

	explosionSpriteSheet = sprite.newSpriteSheet("BigExplosion.png", 82, 117)
	explosionSet = sprite.newSpriteSet(explosionSpriteSheet, 1, 18)
	sprite.add(explosionSet, "default", 1, 18, 200, 1)
	
	popSound = audio.loadStream("pop.wav")
	startBalloons()
end


print("--- Balloon Pop Running ---")
init()