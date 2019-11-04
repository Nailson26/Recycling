local composer = require( "composer" )
 
local scene = composer.newScene()
display.setStatusBar( display.HiddenStatusBar )

local backGroup  = display.newGroup()
local mainGroup  = display.newGroup()
local uiGroup = display.newGroup()

local background
local plataforma
local button
local logo
local buttonSom
local somPause = false

local function proximaCenas()
    local toquePlay = audio.loadStream( "Musicas/Menu1A.wav")
	audio.play(toquePlay, {channel = 5})
	audio.setVolume( 1.0 , {channel = 5} )
    composer.gotoScene("Cenas.game" , {effect= "crossFade", time= 500})
end

local musica = audio.loadStream( "Musicas/musica-loop.mp3")
audio.play(musica, {channel = 2, loops = -1})
audio.setVolume(0.3)

local function DesativarSom()
    if(somPause == false)then
        audio.stop(2)
        somPause = true

    elseif(somPause == true)then
        local musica = audio.loadStream( "Musicas/musica-loop.mp3")
        audio.play(musica, {channel = 2, loops = -1})
        somPause = false

    end
end

-- create()
function scene:create( event )

    local sceneGroup = self.view

        --Fundo (Camada 1)
    background = display.newImageRect( backGroup, "Imagens/layer-3.png" , 450, 650)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

        --Plataforma (Camada 1)
    plataforma = display.newImageRect(mainGroup, "Imagens/layer-4.png" , 450, 650)
    plataforma.x = display.contentCenterX
    plataforma.y = display.contentCenterY-8

        --logo
    logo = display.newImageRect(mainGroup, "Imagens/logo-recycling.png" , 250, 400)
    logo.x = display.contentWidth/2 -5
    logo.y = display.contentCenterY/2
    
        --Botão (Camada 2)
    button = display.newImageRect(uiGroup, "Imagens/button-play.png" , 150, 80)
    button.x = display.contentWidth/2 
    button.y = display.contentCenterY+100
    button:addEventListener("tap", proximaCenas)

    buttonSom = display.newImageRect(uiGroup, "Imagens/button-som.png" , 50, 50)
    buttonSom.x = (display.contentWidth/18) + display.contentWidth-50
    buttonSom.y = (display.contentHeight/18) 
    buttonSom:addEventListener("tap", DesativarSom)

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
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        audio.stop(5)
        button:removeEventListener("tap", proximaCenas)
        buttonSom:removeEventListener("tap", DesativarSom)
        composer.removeScene("Cenas.menu")
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    -- package.loaded["Cenas.menu"] = nil
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