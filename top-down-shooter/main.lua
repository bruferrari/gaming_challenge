window = {}
window.w = 160
window.h = 120
window.scale = 4
window.params = {}

window.params.fullscreen = true
window.params.fullscreentype = "desktop"

sprites = {}
player = {}
zombies = {}
bullets = {}

function love.load()
    -- love.window.setMode(window.w * window.scale, window.h * window.scale, window.params)
    sprites.background = love.graphics.newImage('sprites/background.png')
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')

    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    player.acel = 180
end

function love.update(dt)
    if love.keyboard.isDown('d') then
        player.x = player.x + player.acel * dt
    end

    if love.keyboard.isDown('a') then
        player.x = player.x - player.acel * dt
    end

    if love.keyboard.isDown('w') then
        player.y = player.y + player.acel * dt
    end

    if love.keyboard.isDown('s') then
        player.y = player.y - player.acel * dt
    end

    for i,z in ipairs(zombies) do
        z.x = z.x + (math.cos(zombiePlayerAngle(z)) * z.acel * dt)
        z.y = z.y + (math.sin(zombiePlayerAngle(z)) * z.acel * dt)

        if distanceBetween(z.x, z.y, player.x, player.y) < 30 then
            clearZombies()
        end
    end

    for i,b in ipairs(bullets) do
        b.x = b.x + (math.cos(b.direction) * b.acel * dt)
        b.y = b.y + (math.sin(b.direction) * b.acel * dt)
    end

    for i=#bullets, 1, -1 do
        local b = bullets[i]
        if bulletOutOfBounds(b) then
            table.remove(bullets, i)
        end
    end

    for i,z in ipairs(zombies) do
        for j,b in ipairs(bullets) do
            if distanceBetween(z.x, z.y, b.x, b.y) < 20 then
                z.dead = true
                b.dead = true
            end
        end
    end

    for i=#zombies, 1, -1 do
        if zombies[i].dead then
            table.remove(zombies, i)
        end
    end

    for i=#bullets, 1, -1 do
        if bullets[i].dead then
            table.remove(bullets, i)
        end
    end
end

function love.draw()
    love.graphics.draw(sprites.background, 0, 0)
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

    for i,b in ipairs(bullets) do
        love.graphics.draw(
            sprites.bullet,
            b.x,
            b.y,
            nil,
            b.scale,
            b.scale,
            sprites.bullet:getWidth()/2,
            sprites.bullet:getHeight()/2
        )
    end
end

function love.keypressed(key)
    if key == 'space' then
        spawnZombie()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        spawnBullet()
    end
end

function playerMouseAngle()
    return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end

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

function spawnBullet()
    local bullet = {}
    bullet.x = player.x
    bullet.y = player.y
    bullet.acel = 500
    bullet.direction = playerMouseAngle()
    bullet.scale = 0.3
    bullet.dead = false
    table.insert(bullets, bullet)
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function clearZombies()
    for i,z in ipairs(zombies) do
        zombies[i] = nil
    end
end

function bulletOutOfBounds(bullet)
    return 
        bullet.x < 0 or 
        bullet.y < 0 or 
        bullet.x > love.graphics.getWidth() or 
        bullet.y > love.graphics.getHeight()
end