local composer = require( "composer" )
 
local scene = composer.newScene()

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )
-- physics.setDrawMode("hybrid")

--Grupos
local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()
local lixos = display.newGroup()

--Variaveis
local background
local plataforma
local garrafa
local lixeiraAzul
local lixeiraVermelha
local lixeiraAmarela
local lixeiraVerde

local gameLoopTimer

local trashTable = {}



--funções
local function createTrash()

	local newTrash = display.newImageRect( mainGroup,"Imagens/garrafa.png", 102, 85 )
	table.insert( trashTable, newTrash )
	physics.addBody( newTrash, "dynamic", { radius=30, bounce=0.5 } )
	newTrash.myName = "trash"

	local whereFrom = math.random( 3 )

	if ( whereFrom == 1 ) then
		-- From the left
		newTrash.x = -60
		newTrash.y = math.random( 500 )
		newTrash:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
	elseif ( whereFrom == 2 ) then
		-- From the top
		newTrash.x = math.random( display.contentWidth )
		newTrash.y = -60
		newTrash:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
	elseif ( whereFrom == 3 ) then
		-- From the right
		newTrash.x = display.contentWidth + 60
		newTrash.y = math.random( 500 )
		newTrash:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
	end

	newTrash:applyTorque( math.random( -6,6 ) )
end

local function gameLoop()

	-- Create new trash
	createTrash()

	-- Remove asteroids which have drifted off screen
	for i = #trashTable, 1, -1 do
		local thisTrash = trashTable[i]

		if ( thisTrash.x < -100 or
			 thisTrash.x > display.contentWidth + 100 or
			 thisTrash.y < -100 or
			 thisTrash.y > display.contentHeight + 100 )
		then
			display.remove( thisTrash )
			table.remove( trashTable, i )
		end
	end
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    physics.pause()

    background = display.newImageRect(backGroup, "Imagens/layer-3.png" , 450, 650)
    background.x = display.contentCenterX
	background.y = display.contentCenterY
	--physics.addBody(plataforma, "static")

    plataforma = display.newImageRect(mainGroup, "Imagens/layer-5.png" , 450, 80)
    plataforma.x = display.contentCenterX
    plataforma.y = display.contentCenterY+280
	physics.addBody(plataforma, "static")
	
	lixeiraAzul = display.newImageRect(mainGroup, "Imagens/lixeira-azul-papel.png" , 60, 80)
    lixeiraAzul.x = display.contentCenterX-120
	lixeiraAzul.y = display.contentCenterY+210
	physics.addBody(lixeiraAzul, "static")
	
	lixeiraVermelha = display.newImageRect(mainGroup, "Imagens/lixeira-vermelho-plastico.png" , 60, 80)
    lixeiraVermelha.x = display.contentCenterX-40
	lixeiraVermelha.y = display.contentCenterY+210
	physics.addBody(lixeiraVermelha, "static")

	lixeiraAmarela = display.newImageRect(mainGroup, "Imagens/lixeira-amarela-metal.png" , 60, 80)
    lixeiraAmarela.x = display.contentCenterX+40
	lixeiraAmarela.y = display.contentCenterY+210
	physics.addBody(lixeiraAmarela, "static")

	lixeiraVerde = display.newImageRect(mainGroup, "Imagens/lixeira-verde-vidro.png" , 60, 80)
    lixeiraVerde.x = display.contentCenterX+120
	lixeiraVerde.y = display.contentCenterY+210
	physics.addBody(lixeiraVerde, "static")
	

    sceneGroup:insert(backGroup)
    sceneGroup:insert(mainGroup)
    sceneGroup:insert(uiGroup)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        --criarLixo()
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        physics.start()
        gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        timer.cancel( gameLoopTimer )
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene
