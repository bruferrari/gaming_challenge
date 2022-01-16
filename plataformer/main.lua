wf = require('libs/windfield/windfield')
anim8 = require('libs/anim8/anim8')
sti = require('libs/Simple-Tiled-Implementation/sti')

Game = {
    width = 1000,
    height = 768,
    scale = 3
}

Sprites = {}
Animations = {}

function love.load()
    love.window.setMode(Game.width, Game.height)
    Sprites.playerSheet = love.graphics.newImage('sprites/playerSheet.png')

    local grid = anim8.newGrid(614, 564, Sprites.playerSheet:getWidth(), Sprites.playerSheet:getHeight())

    Animations.idle = anim8.newAnimation(grid('1-15', 1), 0.05)
    Animations.jump = anim8.newAnimation(grid('1-7', 2), 0.05)
    Animations.run = anim8.newAnimation(grid('1-15', 3), 0.05)

    World = wf.newWorld(0, 800, false)
    World:setQueryDebugDrawing(true)

    World:addCollisionClass('platform')
    World:addCollisionClass('player')
    World:addCollisionClass('danger')

    require('player')

    Platform = World:newRectangleCollider(250, 400, 300, 100, {collision_class = 'platform'})
    Platform:setType('static')

    DangerZone = World:newRectangleCollider(0, 550, 800, 50, {collision_class = 'danger'})
    DangerZone:setType('static')

    LoadMap()
end

function love.update(dt)
    World:update(dt)
    GameMap:update(dt)
    playerUpdate(dt)
end

function love.draw()
    World:draw()
    GameMap:drawLayer(GameMap.layers["Tile Layer 1"])
    drawPlayer()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'up' then
        if not Player.isJumping then
            Player:applyLinearImpulse(0, -4000)
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local colliders = World:queryCircleArea(x, y, 200, {'platform', 'danger'})
        for i, c in ipairs(colliders) do
            c:destroy()
        end
    end
end

function LoadMap()
    GameMap = sti('maps/lvl_one.lua')
end
