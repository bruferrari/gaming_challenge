function playerMouseAngle()
    return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end

function resetPlayerPos()
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
end

function drawPlayer()
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
end