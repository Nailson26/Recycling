local composer = require( "composer" )
local scene = composer.newScene()
local base = require( "base" )
--Fisica
local physics = require( "physics" )
physics.start()
-- physics.setDrawMode("hybrid")
display.setStatusBar( display.HiddenStatusBar )

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
local pontuacao
local pontos
local vidas
local gameLoopTimer
local velocidadeQueda
local regenerador
local offSet
local caixaVidas
local quantidadeVidas
local dificuldade
local velocidade
local velocidadeSegundoMinuto
local velocidadeContagem

--Tabelas
local trashTable = {}
local lifeTable = {}

--Inicialização de variaveis
pontos = 0
vidas = 3
velocidadeContagem = true
velocidadeQueda = 1
regenerador = 0
offSet = { halfWidth = 18, halfHeight = 5, x = 0, y= -21 }

--Inicialização da física
 physics.setGravity( 0, 0.5 )

--funções

local function gameOver()
    composer.gotoScene("Cenas.gameOver" , {effect= "crossFade", time= 500})
end



local function createTrash()

    local this = math.random(1,9)
    -- local thisOutLine = graphics.newOutline( -20, base.tipoLixo[this].img )
    -- local thisQueda = audio.loadStream( "Musicas/queda.wav")
    -- audio.play(thisQueda, {channel = 10})
    -- audio.setVolume(0.3)

    local newTrash = display.newImageRect(mainGroup, base.tipoLixo[this].img, base.tipoLixo[this].x, base.tipoLixo[this].y)
    physics.addBody( newTrash, "dynamic", { radius=18, bounce=0}  )
    newTrash.myName = "trash"
    newTrash.x = math.random( 20, display.contentWidth-20 )
    newTrash.y =  - 60
    newTrash:setLinearVelocity( 0, velocidadeQueda )
    newTrash:applyTorque(0.1)
    table.insert( trashTable, newTrash )

    local lastX = 0 --variavel que move o lixo no eixo X
    local lastY = 0 --variavel que move o lixo no eixo Y

    local function moverLixo(e)
        if(e.phase == 'began' and e.phase == 'moved') then
            lastX = e.x - newTrash.x
            lastY = e.y - newTrash.y
            newTrash:setLinearVelocity( 0, velocidadeQueda + 50)
        elseif(e.phase == 'moved') then
            local newPositionX = e.x - lastX 
            if(newPositionX > 20 and newPositionX < display.contentWidth-20 ) then
                newTrash.x = e.x - lastX
                newTrash.y = e.y - lastY
                newTrash:setLinearVelocity( 0, velocidadeQueda + 50 )
            end
        end  
    end
    newTrash:addEventListener("touch", moverLixo)

    local function colisaoLixo(self, event)
        local obj1 = event.target
        local obj2 = event.other

        if(obj2.myName == "Lixeira" and obj2.tipo == base.tipoLixo[this].tipo)
        then
            display.remove(obj1)
            pontos = pontos + 10
            regenerador = regenerador + 1
            local reciclado = audio.loadStream( "Musicas/Item1A.wav")
	        audio.play(reciclado, {channel = 3})
	        audio.setVolume( 1.0 , {channel = 3} )
            for i = #trashTable, 1, -1 do
                if ( trashTable[i] == obj1) then
                    table.remove( trashTable, i)
                    break
                end
            end
        elseif(obj2.myName == "Plataforma" and obj1.myName == "trash")
        then
            display.remove(obj1)
            vidas = vidas - 1
            regenerador = 0
            local NaoReciclado = audio.loadStream( "Musicas/Item1B.wav")
	        audio.play(NaoReciclado, {channel = 3})
	        audio.setVolume( 1.0 , {channel = 3} )
            for i = #trashTable, 1, -1 do
                if ( trashTable[i] == obj1) then
                    table.remove( trashTable, i)
                    break
                end
            end
            if(vidas == 0)
            then
                timer.cancel( gameLoopTimer )
                gameOver()
            end
        elseif(obj2.myName == "Lixeira" and obj2.tipo ~= base.tipoLixo[this].tipo)
        then 
            display.remove(obj1)
            vidas = vidas - 1
            regenerador = 0
            local NaoReciclado = audio.loadStream( "Musicas/Item1B.wav")
	        audio.play(NaoReciclado, {channel = 3})
	        audio.setVolume( 1.0 , {channel = 3} )
            for i = #trashTable, 1, -1 do
                if ( trashTable[i] == obj1) then
                    table.remove( trashTable, i)
                    break
                end
            end
            if(vidas == 0)
            then
                timer.cancel( gameLoopTimer )
                gameOver()
            end
        end
    end
    newTrash.collision = colisaoLixo
    newTrash:addEventListener("collision")
end

local function criarVidas()
    local this = math.random(1,4)
    -- local thisOutLine = graphics.newOutline( 0, base.vida[this].img )

    local newLife = display.newImageRect(mainGroup, base.vida[this].img, base.vida[this].x, base.vida[this].y)
    physics.addBody( newLife, "dynamic", { radius=18, bounce=0} )
    newLife.myName = "life"
    newLife.x = math.random( 20, display.contentWidth-20 )
    newLife.y = -60
    newLife:setLinearVelocity( 0, velocidadeQueda )
    -- newLife:applyTorque( math.random( -4,4 ) )
    table.insert( lifeTable, newLife )

    local lastX = 0 --variavel que move a vida no eixo X
    
    local function moverlife(e)
        if(e.phase == 'began' and e.phase == 'moved') then
             lastX = e.x - newLife.x
        elseif(e.phase == 'moved') then
            local newPosition = e.x - lastX 
            if(newPosition > 20 and newPosition < display.contentWidth-20 ) then
                newLife.x = e.x - lastX
            end
        end  
    end
    newLife:addEventListener("touch", moverlife)

    local function colisaoLife(self, event)
        local obj1 = event.target
        local obj2 = event.other

        if(obj2.myName == "Lixeira" and obj2.tipo == base.vida[this].tipo)
        then
            display.remove(obj1)
            if(vidas < 3)then
                vidas = vidas + 1
            elseif(vidas == 3)then
                pontos = pontos + 50
            end
            local vidaAcerto = audio.loadStream( "Musicas/vida-acerto.wav")
            audio.play(vidaAcerto, {channel = 6})
            audio.setVolume(0.3)
            for i = #lifeTable, 1, -1 do
                if ( lifeTable[i] == obj1) then
                    table.remove( lifeTable, i)
                    break
                end
            end
        elseif(obj2.myName == "Plataforma" and obj1.myName == "trash")
        then
            display.remove(obj1)
            local vidaErro = audio.loadStream( "Musicas/vida-erro.wav")
            audio.play(vidaErro, {channel = 6})
            audio.setVolume(0.3)
            for i = #trashTable, 1, -1 do
                if ( trashTable[i] == obj1) then
                    table.remove( trashTable, i)
                    break
                end
            end
        elseif(obj2.myName == "Lixeira" and obj2.tipo ~= base.vida[this].tipo)
        then 
            display.remove(obj1)
            local vidaErro = audio.loadStream( "Musicas/vida-erro.wav")
            audio.play(vidaErro, {channel = 6})
            audio.setVolume(0.3)
            for i = #trashTable, 1, -1 do
                if ( trashTable[i] == obj1) then
                    table.remove( trashTable, i)
                    break
                end
            end
        end
    end
    newLife.collision = colisaoLife
    newLife:addEventListener("collision")
    regenerador = 0
end


local function aumentarDificuldade()
    if(velocidadeQueda < 1000)
    then
        velocidadeQueda = velocidadeQueda + 5
    end
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

    -- for i = #lifeTable, 1, -1 do
	-- 	local thisLife = lifeTable[i]

	-- 	if ( thisLife.x < -100 or
	-- 		 thisLife.x > display.contentWidth + 100 or
	-- 		 thisLife.y < -100 or
	-- 		 thisLife.y > display.contentHeight + 100 )
	-- 	then
	-- 		display.remove( thisLife )
	-- 		table.remove( lifeTable, i )
	-- 	end
    -- end
end


local function atualizador()
    pontuacao.text = pontos
    quantidadeVidas.text = vidas

    if(regenerador == 10)then
        criarVidas()
    end

end
Runtime:addEventListener( "enterFrame", atualizador )


local function umMinutoDeJogo()
    timer.cancel( gameLoopTimer )
    gameLoopTimer = timer.performWithDelay(2000, gameLoop, -1)
    print("gerando a cada  dois segundos")
end

local function doisMinutoDeJogo()
    timer.cancel( gameLoopTimer )
    gameLoopTimer = timer.performWithDelay(1000, gameLoop, -1)
    print("gerando a cada  um segundos")
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
    physics.addBody(plataforma, "static" )
    plataforma.myName = "Plataforma"
	
	lixeiraAzul = display.newImageRect(mainGroup, "Imagens/lixeira-azul.png" , 70, 100)
    lixeiraAzul.x = (display.contentWidth/4)/2
	lixeiraAzul.y = display.contentCenterY+198
    physics.addBody(lixeiraAzul, "static" , {box = offSet})
    lixeiraAzul.myName = "Lixeira"
    lixeiraAzul.tipo = "Papel"
    
	lixeiraVermelha = display.newImageRect(mainGroup, "Imagens/lixeira-vermelha.png" , 70, 100)
    lixeiraVermelha.x = (display.contentWidth/4)/2 + 80
	lixeiraVermelha.y = display.contentCenterY+198
    physics.addBody(lixeiraVermelha, "static", {box = offSet})
    lixeiraVermelha.myName = "Lixeira"
    lixeiraVermelha.tipo = "Plastico"

	lixeiraAmarela = display.newImageRect(mainGroup, "Imagens/lixeira-amarela.png" , 70, 100)
    lixeiraAmarela.x = (display.contentWidth/4)/2 + 160
	lixeiraAmarela.y = display.contentCenterY+198
    physics.addBody(lixeiraAmarela, "static", {box = offSet})
    lixeiraAmarela.myName = "Lixeira"
    lixeiraAmarela.tipo = "Metal"

	lixeiraVerde = display.newImageRect(mainGroup, "Imagens/lixeira-verde.png" , 70, 100)
    lixeiraVerde.x = (display.contentWidth/4)/2 + 240
	lixeiraVerde.y = display.contentCenterY+198
    physics.addBody(lixeiraVerde, "static", {box = offSet})
    lixeiraVerde.myName = "Lixeira"
    lixeiraVerde.tipo = "Vidro"
    
    caixaPontuacao = display.newImageRect(uiGroup, "Imagens/Caixa-pontuacao.png" , 110, 40)
    caixaPontuacao.x = display.contentWidth-55

    pontuacao = display.newText(uiGroup, "0",  240, 300, native.systemFont, 16 )
    pontuacao.x = display.contentWidth-25
    pontuacao.y = display.contentCenterY-240

    caixaVidas = display.newImageRect(uiGroup, "Imagens/caixa-vidas.png" , 110, 40)
    caixaVidas.x = display.contentWidth-55
    caixaVidas.y = display.contentHeight/2 - 200

    quantidadeVidas = display.newText(uiGroup, "3",  240, 300, native.systemFont, 16 )
    quantidadeVidas.x = display.contentWidth-25
    quantidadeVidas.y = display.contentCenterY-200

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
        -- physics.start()
        gameLoopTimer = timer.performWithDelay(3000, gameLoop, -1)
        dificuldade = timer.performWithDelay(10000, aumentarDificuldade, -1 )
        velocidade =  timer.performWithDelay(60000, umMinutoDeJogo)
        velocidadeSegundoMinuto = timer.performWithDelay(1200000, doisMinutoDeJogo)
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        timer.cancel(dificuldade)
        timer.cancel(velocidade)
        timer.cancel(velocidadeSegundoMinuto)
        audio.stop(2)
        audio.stop(3)
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        Runtime:removeEventListener("enterFrame", atualizador)
        physics.pause()
        composer.removeScene("Cenas.game")
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    package.loaded["Cenas.game"] = nil
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
