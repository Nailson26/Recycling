local composer = require( "composer" )
 
local scene = composer.newScene()

--Fisica
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 2)
-- physics.setDrawMode("hybrid")

--Grupos
local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

--Variaveis
local background
local plataforma
local garrafa
local lixeiraAzul
local lixeiraVermelha
local lixeiraAmarela
local lixeiraVerde
local pontuacao

local gameLoopTimer

--Tabelas
local trashTable = {}

--funções
local function createTrash()

    local tipoLixo = {}
    tipoLixo[1] =  display.newImageRect( "Imagens/garrafa-vidro.png", 20, 40)
    tipoLixo[2] =  display.newImageRect( "Imagens/lata.png", 30, 40)
    tipoLixo[3] =  display.newImageRect( "Imagens/vidro.png", 30, 40)
    tipoLixo[4] =  display.newImageRect( "Imagens/papel.png", 40, 40)
    tipoLixo[1].x = -200
    tipoLixo[2].x = -200
    tipoLixo[3].x = -200
    tipoLixo[4].x = -200
    
    local newTrash = tipoLixo[math.random( 1,4 )]
    physics.addBody( newTrash, "dynamic", { radius=30, bounce=0.0 } )
    newTrash.myName = "trash"
    newTrash.x = math.random( 20, display.contentWidth-20 )
    newTrash.y = -60
    newTrash:setLinearVelocity( 0, math.random( 2,4 ) )
    newTrash:applyTorque( math.random( -6,6 ) )
    table.insert( trashTable, newTrash )

    local lastX = 0 --variavel que move o lixo no eixo X
    
    local function moverLixo(e)
        if(e.phase == 'began') then
             lastX = e.x - newTrash.x
        elseif(e.phase == 'moved') then
            local newPosition = e.x - lastX 
            if(newPosition > 20 and newPosition < display.contentWidth-20 ) then
                newTrash.x = e.x - lastX
            end
        end  
    end
    newTrash:addEventListener("touch", moverLixo)
end


local function gameLoop()

	-- Create new trash
    createTrash()

	-- Remove trash which have drifted off screen
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
    -- physics.pause()

    background = display.newImageRect(backGroup, "Imagens/layer-3.png" , 450, 650)
    background.x = display.contentCenterX
	background.y = display.contentCenterY

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
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        physics.start()
        gameLoopTimer = timer.performWithDelay( 2000, gameLoop, 0 )
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
