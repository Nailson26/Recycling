local composer = require( "composer" )
local scene = composer.newScene()
local base = require( "base" )
--Fisica
local physics = require( "physics" )
physics.start()
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
local caixaPontuacao
local pontos
local vidas
local gameLoopTimer
local gameLoopDificuldade
local velocidadeQueda
local velocidadeGerar

--Tabelas
local trashTable = {}


--Inicialização de variaveis
pontos = 0
vidas = 3
velocidadeGerar = 3000
velocidadeQueda = 1

--Inicialização da física
physics.setGravity( 0, 1 )

--funções
local function createTrash()

    local this = math.random(1,9)

    local newTrash = display.newImageRect(mainGroup, base.tipoLixo[this].img, base.tipoLixo[this].x, base.tipoLixo[this].y)
    physics.addBody( newTrash, "dynamic", { radius=30, bounce=0.0 } )
    newTrash.myName = "trash"
    newTrash.x = math.random( 20, display.contentWidth-20 )
    newTrash.y = -60
    newTrash:setLinearVelocity( 0, velocidadeQueda )
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

    local function colisaoLixo(self, event)
        local obj1 = event.target
        local obj2 = event.other

        if(obj2.myName == base.tipoLixo[this].tipo)
        then
            display.remove(obj1)
            pontos = pontos + 10
            for i = #trashTable, 1, -1 do
                if ( trashTable[i] == obj1) then
                    table.remove( trashTable, i)
                    break
                end
            end
        end
    end
    newTrash.collision = colisaoLixo
    newTrash:addEventListener("collision")
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

local function aumentarDificuldade()
    if(velocidadeQueda < 1000)
    then
        velocidadeQueda = velocidadeQueda + 10
        print(velocidadeQueda)
    end
end

local function aumentarVelocidadeQueda(event)
    if(velocidadeQueda < 100)then
        gameLoopTimer = timer.performWithDelay(3000, gameLoop, 0 )
        print("gerando a cada 3 segundos")
    elseif(velocidadeQueda > 100 and velocidadeQueda < 200)then
        gameLoopTimer = timer.performWithDelay(2000, gameLoop, 0 )
        print("gerando a cada 2 segundos")
    elseif(velocidadeQueda > 200)then
        gameLoopTimer = timer.performWithDelay(1000, gameLoop, 0 )
        print("gerando a cada 1 segundos")
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
    plataforma.y = display.contentHeight+40
	physics.addBody(plataforma, "static")
	
	lixeiraAzul = display.newImageRect(mainGroup, "Imagens/lixeira-azul-papel.png" , 60, 80)
    lixeiraAzul.x = display.contentCenterX-120
	lixeiraAzul.y = display.contentCenterY+210
    physics.addBody(lixeiraAzul, "static")
    lixeiraAzul.myName = "Papel"
	
	lixeiraVermelha = display.newImageRect(mainGroup, "Imagens/lixeira-vermelho-plastico.png" , 60, 80)
    lixeiraVermelha.x = display.contentCenterX-40
	lixeiraVermelha.y = display.contentCenterY+210
    physics.addBody(lixeiraVermelha, "static")
    lixeiraVermelha.myName = "Plastico"

	lixeiraAmarela = display.newImageRect(mainGroup, "Imagens/lixeira-amarela-metal.png" , 60, 80)
    lixeiraAmarela.x = display.contentCenterX+40
	lixeiraAmarela.y = display.contentCenterY+210
    physics.addBody(lixeiraAmarela, "static")
    lixeiraAmarela.myName = "Metal"

	lixeiraVerde = display.newImageRect(mainGroup, "Imagens/lixeira-verde-vidro.png" , 60, 80)
    lixeiraVerde.x = display.contentCenterX+120
	lixeiraVerde.y = display.contentCenterY+210
    physics.addBody(lixeiraVerde, "static")
    lixeiraVerde.myName = "Vidro"
    
    caixaPontuacao = display.newImageRect(uiGroup, "Imagens/Caixa-pontuacao.png" , 110, 40)
    caixaPontuacao.x = display.contentWidth-55


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
        gameLoopDificuldade = timer.performWithDelay(10000, aumentarDificuldade, 0 )
        gameLoopTimer = timer.performWithDelay(3000, gameLoop, 0 )
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
