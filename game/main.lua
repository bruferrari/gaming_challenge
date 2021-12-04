
-- run immediately when the game loads
function love.load()
    target = {}
    target.x = 300
    target.y = 300
    target.radius = 50
    target.offset = 15

    score = 0
    timer = 0
    gameState = 1

    gameFont = love.graphics.newFont(40)
    sprites = {}
    sprites.sky = love.graphics.newImage("sprites/sky.png")
    sprites.target = love.graphics.newImage("sprites/target.png")
    sprites.crosshairs = love.graphics.newImage("sprites/crosshairs.png")

    love.mouse.setVisible(false)
end

-- run on every game loop
function love.update(dt)
    if timer > 0 then
        timer = timer - dt
    end

    if timer < 0 then
        timer = 0
        gameOver()
    end
end

function love.draw()
    love.graphics.draw(sprites.sky, 0, 0)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(gameFont)
    love.graphics.print("Score: "..score, 5, 5)
    displayTimer()

    drawMenu()

    if gameState == 2 then
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
    end
    
    love.graphics.draw(sprites.crosshairs, love.mouse.getX() - 20, love.mouse.getY() - 20)
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 and gameState == 2 then
        local mouseTarget = distanceBetween(x, y, target.x, target.y)
        if mouseTarget < (target.radius / 2 - target.offset) then
            score = score + 10
            timer = timer - 1
            changeTargetPos()
        elseif mouseTarget < target.radius then
            score = score + 1
            changeTargetPos()
        elseif score > 0 then
            score = score - 1
        end
    elseif button == 1 and gameState == 1 then
        gameState = 2
        timer = 10
    end
end

function changeTargetPos()
    target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
    target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function displayTimer()
    local wOffset = 200
    love.graphics.print("Timer: "..math.ceil(timer), love.graphics.getWidth() - wOffset, 0)
end

function gameOver()
    gameState = 1
    score = 0
    love.graphics.print("GAME OVER!", 0, 0)
end

function drawMenu()
    if gameState == 1 then
        love.graphics.printf(
            "Click anywhere to begin!", 
            0, 
            250, 
            love.graphics.getWidth(),
            "center"
        )
    end
end