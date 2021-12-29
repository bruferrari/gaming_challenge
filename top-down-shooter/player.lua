player = {
    life = 100,
    acel = 180
}

function playerMouseAngle()
    return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end

function resetPlayerPos()
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
end

function drawPlayer()
    if game.state == 2 then
        if player.life == 100 then
            love.graphics.draw(sprites.fullLife, player.x - 25, player.y - 50)
        elseif player.life == 75 then
            love.graphics.draw(sprites.almostFullLife, player.x - 25, player.y - 50)
        elseif player.life == 50 then
            love.graphics.draw(sprites.halfLife, player.x - 25, player.y - 50)
        elseif player.life == 25 then
            love.graphics.draw(sprites.quarterLife, player.x - 25, player.y - 50)
        end
    end

    if player.life < 100 then
        love.graphics.setColor(255/255, 0, 0)
    end

    love.graphics.draw(
        sprites.player,
        player.x,
        player.y,
        playerMouseAngle(),
        nil,
        nil,
        sprites.player:getWidth()/2,
        sprites.player:getHeight()/2
    )
    love.graphics.setColor(255/255, 255/255, 255/255)
end