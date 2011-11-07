-- Corona Comics Reader framework

module(..., package.seeall)


local Object = Runtime.Object

local function isDeviceLandscape( orientation )
	return "landscapeLeft" == orientation or "landscapeRight" == orientation
end

local kTime = 350
-------------------------------------------------------------------------------

local Frame = Object:new()

function Frame:initialize()
	local view = display.newGroup()
	self.view = view

	-- Center view in content
	local contentW = display.contentWidth
	local contentH = display.contentHeight

	local halfContentW = 0.5*contentW
	local halfContentH = 0.5*contentH
	view.x = halfContentW
	view.y = halfContentH

---[[
	-- offscreen (extra frame to mask off content during rotation)
	local maxOff = ( contentH > contentW ) and contentH or contentW
	local minOff = 0.25*maxOff
	local minOffHalf = 0.5*minOff
	local topOff = display.newRect( -(halfContentW + minOff + minOffHalf), -halfContentH - minOffHalf, maxOff + 2*minOff, minOff )
	topOff:setFillColor( 0, 0, 0 )
	view:insert( topOff )

	local botOff = display.newRect( -(halfContentW + minOff + minOffHalf), halfContentH - minOffHalf, maxOff + 2*minOff, minOff )
	botOff:setFillColor( 0, 0, 0 )
	view:insert( botOff )

	local leftOff = display.newRect( -(halfContentW + minOff + minOffHalf), -halfContentH, minOff, contentH )
	leftOff:setFillColor( 0, 0, 0 )
	view:insert( leftOff )	

	local rightOff = display.newRect( (halfContentW+ minOffHalf), -halfContentH, minOff, contentH )
	rightOff:setFillColor( 0, 0, 0 )
	view:insert( rightOff )
--]]

	-- max dimension 
	local unit = ( contentH > contentW ) and contentH or contentW
	self.unit = unit

	-- length needs to be long enough to cover diagonal of screen
	-- and also be an even integer
	local len = 2 * unit
	self.len = len

	-- Insert rects and position relative to view's origin
	local top = display.newRect( -halfContentW, -halfContentH, len, 0 )
	view:insert( top )
	local bottom = display.newRect( -halfContentW, halfContentH, len, 0 )
	view:insert( bottom )
	local left = display.newRect( -halfContentW, -halfContentH, 0, contentH )
	view:insert( left )
	local right = display.newRect( halfContentW, -halfContentH, 0, contentH )
	view:insert( right )

	view.top = top
	view.bottom = bottom
	view.left = left
	view.right = right
end

local function floor( a )
	return a - a%1
end

function Frame:setBounds( w, h, animate )
	local view = self.view

	local contentW = display.contentWidth
	local contentH = display.contentHeight

	local orientation = system.orientation
	if "landscapeLeft" == orientation or "landscapeRight" == orientation then
		contentW,contentH = contentH,contentW
	end

	-- Force h to be even
	if math.mod( h, 2 )~= 0 then
		h = h + 1
	end

	-- view group is at the center of the content bounds 
	local len = self.len
	local wNew = 0.5*(len - w)
	local hNew = 0.5*(len - h)
--	local wNew = 0.5*(contentW - w)
--	local hNew = 0.5*(contentH - h)

	local xNew = 0.5*(w + wNew)
	local yNew = 0.5*(h + hNew)

	if animate then
		transition.to( view.top, { height=hNew, y=-yNew, time=kTime, transition=easing.inOutQuad } )
		transition.to( view.bottom, { height=hNew, y=yNew, time=kTime, transition=easing.inOutQuad } )
--		transition.to( view.top, { width=contentW, height=hNew, x=0, y=-yNew } )
--		transition.to( view.bottom, { width=contentW, height=hNew, x=0, y=yNew } )
	else	
		local top = view.top
--		top.width = contentW
		top.height = hNew
		top.x = 0
		top.y = -yNew

		local bottom = view.bottom
--		bottom.width = contentW
		bottom.height = hNew
		bottom.x = 0
		bottom.y = yNew
	end

	if animate then
		transition.to( view.left, { width=wNew, height=h, x=-xNew, y=0, time=kTime, transition=easing.inOutQuad } )
		transition.to( view.right, { width=wNew, height=h, x=xNew, y=0, time=kTime, transition=easing.inOutQuad } )
	else	
		local left = view.left
		left.width = wNew
		left.height = h
		left.x = -xNew
		left.y = 0
	
		local right = view.right
		right.width = wNew
		right.height = h
		right.x = xNew
		right.y = 0
	end
end

function Frame:setColor( ... )
	local view = self.view

	view.top:setFillColor( 0,0,0 )
	view.bottom:setFillColor( 0,0,0 )
	view.left:setFillColor( 0,0,0 )
	view.right:setFillColor( 0,0,0 )
--[[
	view.top:setFillColor( ... )
	view.bottom:setFillColor( ... )
	view.left:setFillColor( ... )
	view.right:setFillColor( ... )
--]]
end

-------------------------------------------------------------------------------

local Reader = Object:new()         
                                 

-- reader:initialize( basename [, startPage] )
function Reader:initialize( basename, data, startPage, options )
	local contentWidth = display.contentWidth
	local contentHeight = display.contentHeight
	self.basename = basename
	self.data = data     
	self.loadLastPage = false
	if options then
		if options.loadLastPage == true then
			self.loadLastPage = true           		
		end
	end

	local view = display.newGroup()
	self.view = view
	view:translate( 0.5*contentWidth, 0.5*contentHeight )

	local fullscreenRect = display.newRect( 0, 0, contentWidth, contentHeight )
	fullscreenRect.isHitTestable = true
	fullscreenRect:setFillColor( 0,0,0 )
	fullscreenRect.isVisible = false
	fullscreenRect:addEventListener( "touch", self )
	view:insert( fullscreenRect, true )

	self.screenW = contentWidth
	self.screenH = contentHeight
--[[
	if isDeviceLandscape( system.orientation ) then
		local tmp = self.screenW
		self.screenW = self.screenH
		self.screenH = tmp
	end
--]]
	local book = display.newGroup()
	view:insert( book )

	local pages = {}
	book.pages = pages

	self.book = book

	startPage = startPage or 0
	self:loadPage( startPage )

	local f = Frame:new()
	f:initialize()
	f:setColor( 0, 0, 0 )
	self.frame = f
	view:insert( f.view, true )
	f.view.alpha = 0

	self:setOrientation( system.orientation )
end

function Reader:loadData( pageNum )
--[[
	local datafile = system.pathForFile( basename .. ".lua", system.ResourceDirectory )
	local result = dofile( datafile )
	return result
--]]

	local data = self.data
	if pageNum < 0 then
		pageNum = #data
	end

	return data[pageNum], pageNum
end

function Reader:loadPage( pageNum, frameNum )
	local book = self.book
	local pages = book.pages
	local page = pages[pageNum]
	if not page then
		-- lazily load page
		local data
		data, pageNum = self:loadData( pageNum )

		if data then
			local basename = self.basename .. pageNum
			page = display.newImage( basename .. ".png" )
		
			pages[pageNum] = page -- add into array of pages
			book:insert( page, true )
			
			page.data = data
			page.number = pageNum
		end
	else
		page.alpha = 1
		page.xOrigin = 0
		page.yOrigin = 0
		page.xReference = 0
		page.yReference = 0
	end

	if ( page ) then
		book.current = page		
		if(frameNum) then
			page.index = frameNum
		else
			page.index = 0 -- show entire page
		end
	end

	return page
end

function Reader:invalidateFrame()
	local page = self.book.current
	local index = page.index
	self:showFrame( index )
end

function Reader:nextFrame(orientation)       

-- 	Clever hack to handle navigation when in portraitupsidedown or landscapeleft orientations.
    if "portraitUpsideDown" == orientation or "landscapeLeft" == orientation then 
            self:prevFrame()
            return
    end

	local page = self.book.current
	-- print("nextFrame. current page index: " .. page.index)
	
	local index = page.index + 1   
	if ( self:showFrame( index ) ) then     
		page.index = index
	else
		-- Show entire next page
		-- TODO: make it an option that it goes directly to next frame on next page
		index = 0

		local newPage = self:loadPage( page.number + 1 )
		if newPage then
			self:showFrame( index )
		else                                   
			newPage = self:loadPage( 0 ) -- load cover
			self:showFrame( 0 ) -- hide frame
		end

		transition.to( page, { alpha = 0, time=kTime, transition=easing.inOutQuad } )
		transition.from( newPage, { alpha = 0, time=kTime, transition=easing.inOutQuad } )
		newPage.index = index
	end

	return true
end

function Reader:prevFrame(orientation)                                                                       
	
	-- 	Clever hack to handle navigation when in portraitupsidedown or landscapeleft orientations.
    if "portraitUpsideDown" == orientation or "landscapeLeft" == orientation then
            self:nextFrame()
            return
    end
	
	local page = self.book.current
	local index = page.index - 1
	if ( self:showFrame( index ) ) then  
		page.index = index
	else
		-- Show entire next page
		-- TODO: make it an option that it goes directly to next frame on next page
		index = 0

		local newPage = self:loadPage( page.number - 1 )
		if newPage then
			index = #newPage.data
			self:showFrame( index )
		else
			newPage = self:loadPage( 0 ) -- load cover
			self:showFrame( 0 ) -- hide frame
		end

		transition.to( page, { alpha = 0, time=kTime, transition=easing.inOutQuad } )
		transition.from( newPage, { alpha = 0, time=kTime, transition=easing.inOutQuad } )
		newPage.index = index
	end

	return true
end

function Reader:calculateScale()
end

function Reader:showFrame( index, suppressAnimation )
	
	local result = true

	local page = self.book.current      
	local data = page.data       
	
	-- print ("page/frame " .. page.number, page.index)

	if ( 0 == index ) then
		local scale = 1
		-- print( "page/screen", page.width, self.screenW, page.height, self.screenH )
		if ( page.width > self.screenW ) or ( page.height > self.screenH ) then
			local sx = self.screenW / page.width
			local sy = self.screenH / page.height
			scale = ( sx < sy ) and sx or sy
		end
		
		transition.to( self.frame.view, { alpha = 0, time=kTime, transition=easing.inOutQuad } )
		transition.to( page, { alpha = 1, xOrigin = 0, yOrigin = 0, xReference = 0, yReference = 0, xScale = scale, yScale = scale, time=kTime, transition=easing.inOutQuad } )
	elseif ( index > 0 and index <= #data ) then
		local elem = data[index]
		local x,y,w,h = unpack( elem, 1, 4 )      

		local orientation = system.orientation
		local isLandscape = "landscapeLeft" == orientation or "landscapeRight" == orientation

		local wMax = self.screenW - 80
		local hMax = self.screenH - 80

		local pageAspect = w / h
		local screenAspect = wMax / hMax
		local zoomWidth = ( screenAspect < pageAspect )
		-- print( isLandscape, w,h,wMax,hMax)
		-- print( zoomWidth, pageAspect, screenAspect )

		local scale = (zoomWidth) and (wMax / w) or (hMax / h)
		-- print( "scale", scale )
		local f = self.frame
		f.view.alpha = 1

		local firstFrame = ( 0 == page.index )

		-- scale = scale *0.75

		local animate = (not suppressAnimation) and (not firstFrame)
		f:setBounds( scale*w, scale*h, animate )

		if firstFrame then
			transition.from( f.view, { alpha = 0, time=kTime, transition=easing.inOutQuad } )
		end

		local wPage = page.width
		local hPage = page.height

		local xCenter = x + 0.5*w
		local yCenter = y + 0.5*h
		local xNew = 0.5*wPage - xCenter
		local yNew = 0.5*hPage - yCenter
		-- print( xCenter, yCenter, 0.5*page.width, 0.5*page.height, xNew, yNew, scale )

		local xRef = (xCenter-0.5*wPage)
		local yRef = (yCenter-0.5*hPage)
			
		transition.to( page, { xOrigin=xNew, yOrigin=yNew, xReference=xRef, yReference=yRef, xScale=scale, yScale=scale, time=kTime, transition=easing.inOutQuad } )
	else
		result = false
	end

	return result
end

function Reader:touch( event )
	local phase = event.phase
	if "began" == phase then
		self.touchStartPosX = event.x
		self.touchStartPosY = event.y
	else
		local resetStartPos = true

		if "ended" == phase then
			local x,y = event.x,event.y
			local startX = self.touchStartPosX
			local orientation = system.orientation
			-- if "landscapeLeft" == orientation then
			-- 	startX = display.contentHeight - self.touchStartPosY				
			-- 	x = (display.contentHeight - y)
			-- elseif "landscapeRight" == orientation then
			-- 	startX = self.touchStartPosY				
			-- 	x = y
			-- end      
			if "landscapeLeft" == orientation or "landscapeRight" == orientation then
			                startX = self.touchStartPosY                            
			                x = y
	        end			

			local delta = 10

--print( "x", startX, x )
			if x < (startX - delta) then
				self:nextFrame(orientation)
			elseif x > (startX + delta) then
				self:prevFrame(orientation)
			end
		elseif "cancelled" == phase then
		else
			resetStartPos = false
		end

		if resetStartPos then
			self.touchStartPosX = nil
			self.touchStartPosY = nil
		end
	end
	return true
end

function Reader:setOrientation( orientation, animate )
	local angles = {
		portrait = 0,
		landscapeRight = 90,
		landscapeLeft = -90,
		portraitUpsideDown = 180
	}

	local rotation = angles[orientation]

	if rotation then
		self.screenW = display.contentWidth
		self.screenH = display.contentHeight
		if ( rotation == 90 or rotation == -90 ) then
			self.screenW,self.screenH = self.screenH,self.screenW
		end

		if animate then
			transition.to( self.view, {
					rotation=rotation,
					time=200,
					transition=easing.inOutQuad })
		else
			self.view.rotation = rotation
		end

		self:invalidateFrame()

		self.suppressFirstOrientationEvent = true
	end
end

function Reader:orientation( event )
	-- print( event.type )
	self:setOrientation( event.type, true )
end


---[[      

-- Optional: Save user's last page and load it on next application launch. 


local function onSystemEvent( event )          
	
	if Reader.loadLastPage then

		local filePath = system.pathForFile( "comicprefs.txt", system.DocumentsDirectory )

		 	if "applicationExit" == event.type or "applicationSuspend" == event.type then            

				local file = io.open( filePath, "w" )     
		  		local page = Reader.book.current			
				local data = {page.number, page.index}   
				local datastring = table.concat(data, ",")

			    if file then
					-- print("writing " .. page.number, page.index)
					file:write( "page="..tostring(page.number) .. ", index="..tostring(page.index))
					io.close( file )
			   else -- create file b/c it doesn't exist yet 
					local file = io.open( filePath, "w" )     
					local page = Reader.book.current
					file:write( page.number, page.index)

					io.close( file )
				end
			elseif "applicationStart" == event.type then

				-- io.open opens a file at filePath. returns nil if no file found
				--
			   	local file = io.open( filePath, "r" )           

				if file then
					-- read all contents of file into a string
					local contents = file:read( "*a" )				
					io.close( file )

					local fields = {}
				     for k, v in string.gmatch(contents, "(%w+)=(%w+)") do
				       fields[k] = tonumber(v)
				     end							   			 	

					-- print( "Loading page : " .. fields["page"])    
					Reader:loadPage( fields["page"] )     	 

			     else
					-- create file b/c it doesn't exist yet
					-- print("creating new prefs file")
					file = io.open( filePath, "w" )      
					io.close( file )				
				end
			end		
	end


end

Runtime:addEventListener( "system", onSystemEvent )             
--]]

return Reader