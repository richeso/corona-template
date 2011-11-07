-- Brick Breaker Game
-- Developed by Carlos Yanez
	
		-- Hide Status Bar
		
		display.setStatusBar(display.HiddenStatusBar)
		
		-- Physics Engine

		local physics = require 'physics'
		physics.start()
		physics.setGravity(0, 0)
		
		-- Variables
		
		local BRICK_W = 41
		local BRICK_H = 21
		local OFFSET = 23
		local W_LEN = 8
		local SCORE_CONST = 100
		local score = 0
		local bricks = display.newGroup()
		local xSpeed = 5
		local ySpeed = -5
		local xDir = 1
		local yDir = 1
		local gameEvent = ''
		local currentLevel = 1
		
		-- Graphics[MenuScreen]
		local background = display.newImage('bg.png')
		
		local menuScreen
		local mScreen
		local startB
		local aboutB
		
		-- About Screen
		
		local aboutScreen
		
		-- Game Screen
		
		local paddle
		local brick
		local ball
		
		-- Score/Level Text
		
		local scoreText
		local scoreNum
		local levelText
		local levelNum
		
		-- AlertScreen
		
		local alertScreen
		local alertBg
		local box
		local titleTF
		local msgTF
		
		-- Levels
		
		local levels = {}
		
		levels[1] = {{0,0,0,0,0,0,0,0},
				 	 {0,0,0,0,0,0,0,0},
				 	 {0,0,0,1,1,0,0,0},
				 	 {0,0,0,1,1,0,0,0},
				 	 {0,1,1,1,1,1,1,0},
				 	 {0,1,1,1,1,1,1,0},
				 	 {0,0,0,1,1,0,0,0},
				 	 {0,0,0,1,1,0,0,0},
				 	 {0,0,0,0,0,0,0,0},}
		
		levels[2] = {{0,0,0,0,0,0,0,0},
					 {0,0,0,1,1,0,0,0},
					 {0,0,1,0,0,1,0,0},
					 {0,0,0,0,0,1,0,0},
					 {0,0,0,0,1,0,0,0},
					 {0,0,0,1,0,0,0,0},
					 {0,0,1,0,0,0,0,0},
					 {0,0,1,1,1,1,0,0},}
					
		levels[3] = {{0,0,0,0,0,0,0,0},
	 	 			 {0,0,0,0,0,0,0,0},
				 	 {0,0,0,1,1,0,0,0},
				 	 {0,1,0,0,0,0,1,0},
				 	 {0,1,1,1,1,1,1,0},
				 	 {0,1,0,1,1,0,1,0},
				 	 {0,0,0,0,0,0,0,0},
				 	 {0,0,0,1,1,0,0,0},
				 	 {0,0,0,0,0,0,0,0},}
				
		levels[4] = {{0,0,0,0,0,0,0,0},
	 	 			 {0,0,0,0,0,0,0,0},
				 	 {1,1,1,1,1,1,1,1},
				 	 {1,0,0,0,0,0,0,1},
				 	 {1,0,0,0,0,0,0,1},
				 	 {1,0,0,0,0,0,0,1},
				 	 {1,0,0,0,0,0,0,1},
				 	 {1,0,0,0,0,0,0,1},
				 	 {1,1,1,1,1,1,1,1},}
						
		-- Functions
		
		local addMenuScreen = {}
		local tweenMS = {}
		local hideAbout = {}
		local rmvAbout = {}
		local addGameScreen = {}
		local buildLevel = {}
		local movePaddle = {}
		local gameListeners = {}
		local startGame = {}
		local update = {}
		local bounce = {}
		local removeBrick = {}
		local alert = {}
		local restart = {}
		local changeLevel = {}
							
		-- Main Function
		
		local function Main()
			addMenuScreen()
		end
		
		function addMenuScreen()
			menuScreen = display.newGroup()
			mScreen = display.newImage('mScreen.png')
			startB = display.newImage('startB.png')
			startB.name = 'startB'
			aboutB = display.newImage('aboutB.png')
			aboutB.name = 'aboutB'

			menuScreen:insert(mScreen)
			startB.x = 160
			startB.y = 260
			menuScreen:insert(startB)
			aboutB.x = 160
			aboutB.y = 310
			menuScreen:insert(aboutB)
			
			-- Button Listeners
			
			startB:addEventListener('tap', tweenMS)
			aboutB:addEventListener('tap', tweenMS)
		end
		
		function tweenMS:tap(e)
			if(e.target.name == 'startB') then
				
				-- Start Game
				
				transition.to(menuScreen, {time = 300, y = -menuScreen.height, transition = easing.outExpo, onComplete = addGameScreen})
			else
				
				-- Call AboutScreen
				
				aboutScreen = display.newImage('aboutScreen.png')
				transition.from(aboutScreen, {time = 300, x = menuScreen.contentWidth, transition = easing.outExpo})
				aboutScreen:addEventListener('tap', hideAbout)
				
				-- Hide Menu Buttons to disable
				
				startB.isVisible = false;
				aboutB.isVisible = false;
			end
		end
		
		function hideAbout:tap(e)
			transition.to(aboutScreen, {time = 300, x = aboutScreen.width*2, transition = easing.outExpo, onComplete = rmvAbout})
		end
		
		function rmvAbout()
			aboutScreen:removeSelf()
			
			-- Enable Menu Buttons
				
			startB.isVisible = true;
			aboutB.isVisible = true;
		end
		
		function addGameScreen()
		
			-- Destroy Menu Screen 
			
			menuScreen:removeSelf()
			menuScreen = nil
			
			-- Add Game Screen
			
			paddle = display.newImage('paddle.png')
			ball = display.newImage('ball.png')
			
			paddle.x = 160
			paddle.y = 460
			ball.x = 160
			ball.y = 446
			
			paddle.name = 'paddle'
			ball.name = 'ball'
			
			-- Build Level Bricks 
			
			buildLevel(levels[1])
			
			-- Text
			
			scoreText = display.newText('Score:', 5, 2, 'akashi', 14)
			scoreText:setTextColor(254, 203, 50)
			scoreNum = display.newText('0', 54, 2, 'akashi', 14)
			scoreNum:setTextColor(254,203,50)
			
			levelText = display.newText('Level:', 260, 2, 'akashi', 14)
			levelText:setTextColor(254, 203, 50)
			levelNum = display.newText('1', 307, 2, 'akashi', 14)
			levelNum:setTextColor(254,203,50)
			
			-- Start Listener 
			
			background:addEventListener('tap', startGame)
		end
		
		function movePaddle:accelerometer(e)
		
			-- Accelerometer Movement
			
			paddle.x = display.contentCenterX + (display.contentCenterX * (e.xGravity*3))
			
			-- Borders 
			
			if((paddle.x - paddle.width * 0.5) < 0) then
				paddle.x = paddle.width * 0.5
			elseif((paddle.x + paddle.width * 0.5) > display.contentWidth) then
				paddle.x = display.contentWidth - paddle.width * 0.5
			end
		end
		
		function buildLevel(level)
		
			-- Level length, height 

			local len = table.maxn(level)
			bricks:toFront()
			
			for i = 1, len do
				for j = 1, W_LEN do
					if(level[i][j] == 1) then
						local brick = display.newImage('brick.png')
						brick.name = 'brick'
						brick.x = BRICK_W * j - OFFSET
						brick.y = BRICK_H * i
						physics.addBody(brick, {density = 1, friction = 0, bounce = 0})
						brick.bodyType = 'static'
						bricks.insert(bricks, brick)
					end
				end
			end
		end
		
		function gameListeners(action)
			if(action == 'add') then
				Runtime:addEventListener('accelerometer', movePaddle)
				Runtime:addEventListener('enterFrame', update)
				paddle:addEventListener('collision', bounce)
				ball:addEventListener('collision', removeBrick)
				-- Used to drag the paddle on the simulator
				paddle:addEventListener('touch', dragPaddle)
				--
			else
				Runtime:removeEventListener('accelerometer', movePaddle)
				Runtime:removeEventListener('enterFrame', update)
				paddle:removeEventListener('collision', bounce)
				ball:removeEventListener('collision', removeBrick)
				-- Used to drag the paddle on the simulator
				paddle:removeEventListener('touch', dragPaddle)
				--
			end
		end
		
		-- Used to drag the paddle on the simulator
		
		function dragPaddle(e)
			if(e.phase == 'began') then
				lastX = e.x - paddle.x
			elseif(e.phase == 'moved') then
				paddle.x = e.x - lastX
			end
		end
		
		--
		
		function startGame:tap(e)
			background:removeEventListener('tap', startGame)
			gameListeners('add')
			-- Physics
			physics.addBody(paddle, {density = 1, friction = 0, bounce = 0})
			physics.addBody(ball, {density = 1, friction = 0, bounce = 0})
			paddle.bodyType = 'static'
		end
		
		function bounce(e)
			ySpeed = -5
			
			-- Paddle Collision, check the which side of the paddle the ball hits, left, right 
			
			if((ball.x + ball.width * 0.5) < paddle.x) then
				xSpeed = -5
			elseif((ball.x + ball.width * 0.5) >= paddle.x) then
				xSpeed = 5
			end
		end
		
		function removeBrick(e)
			
			-- Check the which side of the brick the ball hits, left, right  
    
            if(e.other.name == 'brick' and (ball.x + ball.width * 0.5) < (e.other.x + e.other.width * 0.5)) then
                xSpeed = -5
            elseif(e.other.name == 'brick' and (ball.x + ball.width * 0.5) >= (e.other.x + e.other.width * 0.5)) then
                xSpeed = 5
            end
			-- Bounce, Remove
			if(e.other.name == 'brick') then
				ySpeed = ySpeed * -1
				e.other:removeSelf()
				e.other = nil
				bricks.numChildren = bricks.numChildren - 1
				-- Score
				score = score + 1
				scoreNum.text = score * SCORE_CONST
				scoreNum:setReferencePoint(display.CenterLeftReferencePoint)
				scoreNum.x = 54 
			end
			
			-- Check if all bricks are destroyed
			
			if(bricks.numChildren < 0) then
				alert('  You Win!', '  Next Level ›')
				gameEvent = 'win'
			end
		end
		
		function update(e)
		
			-- Ball Movement 

			ball.x = ball.x + xSpeed
			ball.y = ball.y + ySpeed
			
			-- Wall Collision 
			
			if(ball.x < 0) then ball.x = ball.x + 3 xSpeed = -xSpeed end--Left
			if((ball.x + ball.width) > display.contentWidth) then ball.x = ball.x - 3 xSpeed = -xSpeed end--Right
			if(ball.y < 0) then ySpeed = -ySpeed end--Up
			if(ball.y + ball.height > paddle.y + paddle.height) then alert('  You Lose', '  Play Again ›') gameEvent = 'lose' end--down/lose
		end
		
		function alert(t, m)
			gameListeners('remove')
			
			alertBg = display.newImage('alertBg.png')
			box = display.newImage('alertBox.png', 90, 202)
			
			transition.from(box, {time = 300, xScale = 0.5, yScale = 0.5, transition = easing.outExpo})
			
			titleTF = display.newText(t, 0, 0, 'akashi', 19)
			titleTF:setTextColor(254,203,50)
			titleTF:setReferencePoint(display.CenterReferencePoint)
			titleTF.x = display.contentCenterX
			titleTF.y = display.contentCenterY - 15
			
			msgTF = display.newText(m, 0, 0, 'akashi', 12)
			msgTF:setTextColor(254,203,50)
			msgTF:setReferencePoint(display.CenterReferencePoint)
			msgTF.x = display.contentCenterX
			msgTF.y = display.contentCenterY + 15
			
			box:addEventListener('tap', restart)
			
			alertScreen = display.newGroup()
			alertScreen:insert(alertBg)
			alertScreen:insert(box)
			alertScreen:insert(titleTF)
			alertScreen:insert(msgTF)
		end
		
		function restart(e)
			if(gameEvent == 'win' and table.maxn(levels) > currentLevel) then
				currentLevel = currentLevel + 1
				changeLevel(levels[currentLevel])--next level
				levelNum.text = tostring(currentLevel)
			elseif(gameEvent == 'win' and table.maxn(levels) <= currentLevel) then
				box:removeEventListener('tap', restart)
				alertScreen:removeSelf()
				alertScreen = nil	
				alert('  Game Over', '  Congratulations!')
				gameEvent = 'finished'
			elseif(gameEvent == 'lose') then
				changeLevel(levels[currentLevel])--same level
			elseif(gameEvent == 'finished') then
				addMenuScreen()
				
				transition.from(menuScreen, {time = 300, y = -menuScreen.height, transition = easing.outExpo})
				
				box:removeEventListener('tap', restart)
				alertScreen:removeSelf()
				alertScreen = nil
				
				currentLevel = 1
				
				scoreText:removeSelf()
				scoreText = nil
				scoreNum:removeSelf()
				scoreNum = nil
				levelText:removeSelf()
				levelText = nil
				levelNum:removeSelf()
				levelNum = nil
				ball:removeSelf()
				ball = nil
				paddle:removeSelf()
				paddle = nil
				
				score = 0
			end
		end
		
		function changeLevel(level)
		
			-- Clear Level Bricks 
			
			bricks:removeSelf()
			
			bricks.numChildren = 0
			bricks = display.newGroup()

			-- Remove Alert 
			
			box:removeEventListener('tap', restart)
			alertScreen:removeSelf()
			alertScreen = nil
			
			-- Reset Ball and Paddle position 
			
			ball.x = (display.contentWidth * 0.5) - (ball.width * 0.5)
			ball.y = (paddle.y - paddle.height) - (ball.height * 0.5) -2
			
			paddle.x = display.contentWidth * 0.5
			
			-- Redraw Bricks 
			
			buildLevel(level)
			
			-- Start
			
			background:addEventListener('tap', startGame)
		end
		
		Main()