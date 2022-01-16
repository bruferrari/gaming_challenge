Player = World:newRectangleCollider(360, 100, 40, 100, {collision_class = 'player'})
Player:setFixedRotation(true)
Player.speed = 240
Player.animation = Animations.idle
Player.isMoving = false
Player.isJumping = false
Player.direction = 1

function playerUpdate(dt)
    if Player.body then -- if the player still exists

        local colliders = World:queryRectangleArea(
            Player:getX() - 20,
            Player:getY() + 50,
            40,
            2,
            {'platform'}
        )

        if #colliders > 0 then
            Player.isJumping = false
        else
            Player.isJumping = true
        end

        local px, py = Player:getPosition()
        Player.isMoving = false

        if love.keyboard.isDown('right') then
            Player:setX(px + Player.speed * dt)
            Player.isMoving = true
            Player.direction = 1
        end

        if love.keyboard.isDown('left') then
            Player:setX(px - Player.speed * dt)
            Player.isMoving = true
            Player.direction = -1
        end

        if Player:enter('danger') then
            Player:destroy()
        end

        if Player.isJumping then
            Player.animation = Animations.jump
        elseif Player.isMoving then
            Player.animation = Animations.run
        else
            Player.animation = Animations.idle
        end
    end
    Player.animation:update(dt)
end

function drawPlayer()
    local px, py = Player:getPosition()
    Player.animation:draw(Sprites.playerSheet, px, py, nil, 0.25 * Player.direction, 0.25, 130, 300)
end