function zombiePlayerAngle(zombie)
    return math.atan2(zombie.y - player.y, zombie.x - player.x) + math.pi
end

function spawnZombie()
    local zombie = {}
    zombie.x = 0
    zombie.y = 0
    zombie.acel = 100
    zombie.dead = false

    local side = math.random(1, 4)
    if side == 1 then
        zombie.x = -30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 2 then
        zombie.x = love.graphics.getWidth() + 30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 3 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = -30
    elseif side == 4 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = love.graphics.getHeight() + 30
    end

    table.insert(zombies, zombie)
end

function clearZombies()
    for i,z in ipairs(zombies) do
        zombies[i] = nil
        game.state = 1
    end
end

function drawZombies()
    for i,z in ipairs(zombies) do
        love.graphics.draw(
            sprites.zombie,
            z.x,
            z.y,
            zombiePlayerAngle(z),
            nil,
            nil,
            sprites.zombie:getWidth()/2,
            sprites.zombie:getHeight()/2
        )
    end
end

function moveTowardsPlayer(zombie, dt)
    zombie.x = zombie.x + (math.cos(zombiePlayerAngle(zombie)) * zombie.acel * dt)
    zombie.y = zombie.y + (math.sin(zombiePlayerAngle(zombie)) * zombie.acel * dt)
end

function removeDeadZombies()
    for i=#zombies, 1, -1 do
        if zombies[i].dead then
            table.remove(zombies, i)
        end
    end
end