colision = {
    peOffset = 30,
    zbOffset = 20
}

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function player:collide(zombie)
    return distanceBetween(zombie.x, zombie.y, self.x, self.y) < colision.peOffset
end