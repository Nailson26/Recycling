local composer = require( "composer" )
 
local scene = composer.newScene()
display.setStatusBar( display.HiddenStatusBar )

local backGroup  = display.newGroup()
local mainGroup  = display.newGroup()
local uiGroup = display.newGroup()

local background
local text
local buttonReturn
local chamaMenu

local musica = audio.loadStream( "Musicas/game-over.wav")
audio.play(musica, {channel = 2})
audio.setVolume(0.3)

local function proximaCena()
    composer.gotoScene("Cenas.menu" , {effect= "crossFade", time= 500})
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view

    background = display.newImageRect(backGroup, "Imagens/game-over-background.jpg", display.contentWidth, 550)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    
    text = display.newText(backGroup, "Game over",  240, 300, native.systemFont, 60)
    text.x = display.contentCenterX
    text.y = display.contentCenterY

    -- buttonReturn = display.newImageRect(backGroup, "Imagens/game-over-background.jpg", 320, 600)

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
        chamaMenu = timer.performWithDelay(3500, proximaCena)
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        audio.stop(2)
        timer.cancel(chamaMenu)
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene("Cenas.gameOver")
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    package.loaded["Cenas.gameOver"] = nil
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
