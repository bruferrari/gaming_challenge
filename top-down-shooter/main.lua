require 'enemies'
require 'player'
require 'bullets'
require 'colision'

sprites = {}
player = {}
zombies = {}
bullets = {}
game = {}

function love.load()
    math.randomseed(os.time()) -- improve the randomness

    sprites.background = love.graphics.newImage('sprites/background.png')
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')

    resetPlayerPos()
    player.acel = 180

    font = love.graphics.newFont(30)

    game.state = 1
    game.score = 0
    resetMaxTime()
end

function love.update(dt)
    if game.state == 2 then
        if love.keyboard.isDown('d') and player.x < love.graphics.getWidth() then
            player.x = player.x + player.acel * dt
        end
    
        if love.keyboard.isDown('a') and player.x > 0 then
            player.x = player.x - player.acel * dt
        end
    
        if love.keyboard.isDown('w') and player.y > 0 then
            player.y = player.y - player.acel * dt
        end
    
        if love.keyboard.isDown('s') and player.y < love.graphics.getHeight() then
            player.y = player.y + player.acel * dt
        end
    end

    for i,z in ipairs(zombies) do
        moveTowardsPlayer(z, dt)

        if distanceBetween(z.x, z.y, player.x, player.y) < colision.peOffset then
            clearZombies()
            resetPlayerPos()
        end
    end

    for i,b in ipairs(bullets) do
        accelerateBullet(b, dt)
    end

    checkBulletsOutOfBounds()

    for i,z in ipairs(zombies) do
        for j,b in ipairs(bullets) do
            if distanceBetween(z.x, z.y, b.x, b.y) < colision.zbOffset then
                z.dead = true
                b.dead = true
                game.score = game.score + 1
            end
        end
    end

    removeDeadZombies()
    removeDeadBullets()

    if game.state == 2 then
        timer = timer - dt
        if timer <= 0 then
            spawnZombie()
            maxTime = 0.95 * maxTime --decreases ~5% on each spawn
            timer = maxTime
        end
    end
end

function love.draw()
    love.graphics.draw(sprites.background, 0, 0)

    if game.state == 1 then
        love.graphics.setFont(font)
        love.graphics.printf("Hit space to begin", 0, 50, love.graphics.getWidth(), "center")
    end

    love.graphics.printf(
        "Score: "..game.score, 0, 
        love.graphics.getHeight() - 100, 
        love.graphics.getWidth(), 
        "center"
    )

    drawPlayer()
    drawZombies()
    drawBullets()
end

function love.keypressed(key)
    if key == 'space' then
        game.state = 2
        resetMaxTime()
        game.score = 0
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and game.state == 2 then
        spawnBullet()
    end
end

function resetMaxTime()
    maxTime = 2
    timer = maxTime
end