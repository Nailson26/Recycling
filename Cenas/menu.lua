local composer = require( "composer" )
 
local scene = composer.newScene()

local background
local plataforma
local button
local Group1 = display.newGroup()
local Group2 = display.newGroup()

local function proximaCenas()
    composer.gotoScene("Cenas.game" , {effect= "crossFade", time= 500})
end

    --Fundo (Camada 1)
background = display.newImageRect( Group1, "Imagens/layer-3.png" , 450, 650)
background.x = display.contentCenterX
background.y = display.contentCenterY

    --Plataforma (Camada 1)
plataforma = display.newImageRect(Group1, "Imagens/layer-4.png" , 450, 650)
plataforma.x = display.contentCenterX
plataforma.y = display.contentCenterY-20
  
    --Botão (Camada 2)
button = display.newImageRect(Group2, "Imagens/Button.png" , 150, 80)
button.x = display.contentCenterX
button.y = display.contentCenterY+100
button:addEventListener("tap", proximaCenas)

-- create()
function scene:create( event )

    local sceneGroup = self.view
    --Colocando grupos na Cena
    sceneGroup:insert(Group1)
    sceneGroup:insert(Group2)

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