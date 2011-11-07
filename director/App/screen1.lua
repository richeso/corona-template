module(..., package.seeall)

--====================================================================--
-- SCENE: SCREEN 1
--====================================================================--

--[[

 - Version: 1.3
 - Made by Ricardo Rauber Pereira @ 2010
 - Blog: http://rauberlabs.blogspot.com/
 - Mail: ricardorauber@gmail.com

******************
 - INFORMATION
******************

  - Sample scene.

--]]

new = function ( params )
	
	------------------
	-- Imports
	------------------
	
	local ui = require ( "ui" )
	
	------------------
	-- Groups
	------------------
	
	local localGroup = display.newGroup()
	
	------------------
	-- Display Objects
	------------------
	
	local background = display.newImage( "background1.png" )
	local title      = display.newText( "Director Class", 0, 0, native.systemFontBold, 16 )
	local createdBy  = display.newText( "Created by Ricardo Rauber", 0, 0, native.systemFontBold, 16 )
	local website    = display.newText( "http://rauberlabs.blogspot.com/", 0, 0, native.systemFontBold, 16 )
	
	------------------
	-- Link
	------------------
	
	local goBlog = function ( event )
		if event.phase == "ended" then
			system.openURL( "http://rauberlabs.blogspot.com/" )
		end
	end
	--
	title:addEventListener( "touch", goBlog )
	createdBy:addEventListener( "touch", goBlog )
	website:addEventListener( "touch", goBlog )
	
	--====================================================================--
	-- BUTTONS
	--====================================================================--
	
	------------------
	-- Functions
	------------------
	
	local bt01t = function ( event )
		if event.phase == "release" then
			director:changeScene( "screen2", "moveFromLeft" )
		end
	end
	--
	local bt02t = function ( event )
		if event.phase == "release" then
			director:changeScene( "screen2", "overFromRight" )
		end
	end
	--
	local bt03t = function ( event )
		if event.phase == "release" then
			director:changeScene( "screen2", "moveFromTop" )
		end
	end
	--
	local bt04t = function ( event )
		if event.phase == "release" then
			director:changeScene( "screen2", "overFromBottom" )
		end
	end
	--
	local bt05t = function ( event )
		if event.phase == "release" then
			director:changeScene( "screen2", "flip" )
		end
	end
	--
	local bt06t = function ( event )
		if event.phase == "release" then
			director:changeScene( "screen2", "downFlip" )
		end
	end
	--
	local bt07t = function ( event )
		if event.phase == "release" then
			director:changeScene( "screen2", "fade" )
		end
	end
	--
	local bt08t = function ( event )
		if event.phase == "release" then
			director:changeScene( "screen2", "crossfade" )
		end
	end
	
	------------------
	-- UI Objects
	------------------
	
	local bt01 = ui.newButton{
					default = "bt_moveFromLeft.png",
					over = "bt_moveFromLeft.png",
					onEvent = bt01t,
					id = "bt01"
	}
	--
	local bt02 = ui.newButton{
					default = "bt_overFromRight.png",
					over = "bt_overFromRight.png",
					onEvent = bt02t,
					id = "bt02"
	}
	--
	local bt03 = ui.newButton{
					default = "bt_moveFromTop.png",
					over = "bt_moveFromTop.png",
					onEvent = bt03t,
					id = "bt03"
	}
	--
	local bt04 = ui.newButton{
					default = "bt_overFromBottom.png",
					over = "bt_overFromBottom.png",
					onEvent = bt04t,
					id = "bt04"
	}
	--
	local bt05 = ui.newButton{
					default = "bt_flip.png",
					over = "bt_flip.png",
					onEvent = bt05t,
					id = "bt05"
	}
	--
	local bt06 = ui.newButton{
					default = "bt_downFlip.png",
					over = "bt_downFlip.png",
					onEvent = bt06t,
					id = "bt06"
	}
	--
	local bt07 = ui.newButton{
					default = "bt_fade.png",
					over = "bt_fade.png",
					onEvent = bt07t,
					id = "bt07"
	}
	--
	local bt08 = ui.newButton{
					default = "bt_crossfade.png",
					over = "bt_crossfade.png",
					onEvent = bt08t,
					id = "bt08"
	}
	
	--====================================================================--
	-- SLIDE
	--====================================================================--
	
	------------------
	-- Image
	------------------
	
	local btSlide = display.newImage( "bt_slide.png" )
	
	------------------
	-- Listener
	------------------
	
	local btSlidet = function ( event )
		if event.phase == "ended" then
			if event.xStart >= event.x then
				director:changeScene( "screen2", "moveFromRight" )
			else
				director:changeScene( "screen2", "moveFromLeft" )
			end
		end
	end
	
	--====================================================================--
	-- POPUP
	--====================================================================--
	
	------------------
	-- Image
	------------------
	
	local btPopUp = display.newImage( "bt_popup.png" )
	
	------------------
	-- On Close
	------------------
	
	local popClosed = function ()
		--
		local fxTime = 200
		--
		transition.to( bt01, { alpha=0, time=fxTime, delay=100 } )
		transition.to( bt02, { alpha=0, time=fxTime, delay=200 } )
		transition.to( bt03, { alpha=0, time=fxTime, delay=300 } )
		transition.to( bt04, { alpha=0, time=fxTime, delay=400 } )
		transition.to( bt05, { alpha=0, time=fxTime, delay=500 } )
		transition.to( bt06, { alpha=0, time=fxTime, delay=600 } )
		transition.to( bt07, { alpha=0, time=fxTime, delay=700 } )
		transition.to( bt08, { alpha=0, time=fxTime, delay=800 } )
		--
		transition.to( bt01, { alpha=1, time=fxTime, delay=fxTime*2+100 } )
		transition.to( bt02, { alpha=1, time=fxTime, delay=fxTime*2+200 } )
		transition.to( bt03, { alpha=1, time=fxTime, delay=fxTime*2+300 } )
		transition.to( bt04, { alpha=1, time=fxTime, delay=fxTime*2+400 } )
		transition.to( bt05, { alpha=1, time=fxTime, delay=fxTime*2+500 } )
		transition.to( bt06, { alpha=1, time=fxTime, delay=fxTime*2+600 } )
		transition.to( bt07, { alpha=1, time=fxTime, delay=fxTime*2+700 } )
		transition.to( bt08, { alpha=1, time=fxTime, delay=fxTime*2+800 } )
		--
	end
	
	------------------
	-- Listener
	------------------
	
	local btPopUpt = function ( event )
		if event.phase == "ended" then
			director:openPopUp( "screen3", popClosed )
		end
	end
	
	--====================================================================--
	-- PARAMETERS
	--====================================================================--
	
	------------------
	-- Image
	------------------
	
	local btParameters = display.newImage( "bt_parameters.png" )
	
	------------------
	-- Listener
	------------------
	
	local btParameterst = function ( event )
		if event.phase == "ended" then
			director:changeScene( { label="Sending Parameters", reload=true } , "screen2", "fade", "white" )
		end
	end
	
	--====================================================================--
	-- INITIALIZE
	--====================================================================--
	
	local initVars = function ()
		
		------------------
		-- Inserts
		------------------
		
		localGroup:insert( background )
		localGroup:insert( title )
		localGroup:insert( createdBy )
		localGroup:insert( website )
		localGroup:insert( bt01 )
		localGroup:insert( bt02 )
		localGroup:insert( bt03 )
		localGroup:insert( bt04 )
		localGroup:insert( bt05 )
		localGroup:insert( bt06 )
		localGroup:insert( bt07 )
		localGroup:insert( bt08 )
		localGroup:insert( btSlide )
		localGroup:insert( btPopUp )
		localGroup:insert( btParameters )
		
		------------------
		-- Positions
		------------------
		
		title.x = 160
		title.y = 20
		--
		bt01.x = 85
		bt01.y = 70
		--
		bt02.x = 240
		bt02.y = 70
		--
		bt03.x = 85
		bt03.y = 130
		--
		bt04.x = 240
		bt04.y = 130
		--
		bt05.x = 85
		bt05.y = 190
		--
		bt06.x = 240
		bt06.y = 190
		--
		bt07.x = 85
		bt07.y = 250
		--
		bt08.x = 240
		bt08.y = 250
		--
		btSlide.x = 160
		btSlide.y = 300
		--
		btPopUp.x = 160
		btPopUp.y = 350
		--
		btParameters.x = 160
		btParameters.y = 400
		--
		createdBy.x = 160
		createdBy.y = 440
		--
		website.x = 160
		website.y = 460
		
		------------------
		-- Colors
		------------------
		
		title:setTextColor( 255,255,255 )
		createdBy:setTextColor( 255,255,255 )
		website:setTextColor( 255,255,255 )
		
		------------------
		-- Listeners
		------------------
		
		btSlide:addEventListener ( "touch" , btSlidet )
		btPopUp:addEventListener ( "touch" , btPopUpt )
		btParameters:addEventListener ( "touch" , btParameterst )
		
	end
	
	------------------
	-- Initiate variables
	------------------
	
	initVars()
	
	------------------
	-- MUST return a display.newGroup()
	------------------
	
	return localGroup
	
end
