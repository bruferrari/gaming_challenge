bullets = {}

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

function bulletOutOfBounds(bullet)
    return 
        bullet.x < 0 or 
        bullet.y < 0 or 
        bullet.x > love.graphics.getWidth() or 
        bullet.y > love.graphics.getHeight()
end

function drawBullets()
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

function accelerateBullet(bullet, dt)
    bullet.x = bullet.x + (math.cos(bullet.direction) * bullet.acel * dt)
    bullet.y = bullet.y + (math.sin(bullet.direction) * bullet.acel * dt)
end

function removeDeadBullets()
    for i=#bullets, 1, -1 do
        if bullets[i].dead then
            table.remove(bullets, i)
        end
    end
end

function checkBulletsOutOfBounds()
    for i=#bullets, 1, -1 do
        local b = bullets[i]
        if bulletOutOfBounds(b) then
            table.remove(bullets, i)
        end
    end
end