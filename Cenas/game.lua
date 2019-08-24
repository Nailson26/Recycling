local composer = require( "composer" )
 
local scene = composer.newScene()

local physics = require( "physics" )
physics.start()
physics.setGravity(0,9.8)

local background
local plataforma
local garrafa
local Group1 = display.newGroup()
local Group2 = display.newGroup()

background = display.newImageRect(Group1, "Imagens/layer-3.png" , 450, 650)
background.x = display.contentCenterX
background.y = display.contentCenterY

plataforma = display.newImageRect( Group1, "Imagens/layer-4.png" , 450, 650)
plataforma.x = display.contentCenterX
plataforma.y = display.contentCenterY-8
physics.addBody(plataforma, "static")

local function gerarLixo(e)
          
end

background:addEventListener("tap", gerarLixo)


-- create()
function scene:create( event )
 
    local sceneGroup = self.view
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
