wf = require('libs/windfield/windfield')
anim8 = require('libs/anim8/anim8')

game = {
    width = 356,
    height = 256,
    scale = 3
}

sprites = {}
animations = {}

function love.load()
    sprites.playerSheet = love.graphics.newImage('sprites/playerSheet.png')

    local grid = anim8.newGrid(614, 564, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())

    animations.idle = anim8.newAnimation(grid('1-15', 1), 0.05)
    animations.jump = anim8.newAnimation(grid('1-7', 2), 0.05)
    animations.run = anim8.newAnimation(grid('1-15', 3), 0.05)

    world = wf.newWorld(0, 800, false)
    world:setQueryDebugDrawing(true)

    world:addCollisionClass('platform')
    world:addCollisionClass('player')
    world:addCollisionClass('danger')

    player = world:newRectangleCollider(360, 100, 40, 100, {collision_class = 'player'})
    player:setFixedRotation(true)
    player.speed = 240
    player.animation = animations.idle
    player.isMoving = false
    player.isJumping = false
    player.direction = 1

    platform = world:newRectangleCollider(250, 400, 300, 100, {collision_class = 'platform'})
    platform:setType('static')

    dangerZone = world:newRectangleCollider(0, 550, 800, 50, {collision_class = 'danger'})
    dangerZone:setType('static')
end

function love.update(dt)
    world:update(dt)

    if player.body then -- if the player still exists
        local px, py = player:getPosition()
        player.isMoving = false

        if love.keyboard.isDown('right') then
            player:setX(px + player.speed * dt)
            player.isMoving = true
            player.direction = 1
        end

        if love.keyboard.isDown('left') then
            player:setX(px - player.speed * dt)
            player.isMoving = true
            player.direction = -1
        end

        if player:enter('danger') then
            player:destroy()
        end

        if player.isJumping then
            player.animation = animations.jump
        elseif player.isMoving then
            player.animation = animations.run
        else
            player.animation = animations.idle
        end
    end

    local colliders = world:queryRectangleArea(
            player:getX() - 20, 
            player:getY() + 50, 
            40,
            2,
            {'platform'}
        )
    
    if #colliders > 0 then
        player.isJumping = false
    end

    player.animation:update(dt)
end

function love.draw()
    world:draw()

    local px, py = player:getPosition()
    player.animation:draw(sprites.playerSheet, px, py, nil, 0.25 * player.direction, 0.25, 130, 300)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'up' then
        player.isJumping = true
        local colliders = world:queryRectangleArea(
            player:getX() - 20, 
            player:getY() + 50, 
            40,
            2,
            {'platform'}
        )
        if #colliders > 0 then
            player:applyLinearImpulse(0, -4000)
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local colliders = world:queryCircleArea(x, y, 200, {'platform', 'danger'})
        for i, c in ipairs(colliders) do
            c:destroy()
        end
    end
end
