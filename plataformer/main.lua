wf = require('libs/windfield/windfield')
anim8 = require('libs/anim8/anim8')
sti = require('libs/Simple-Tiled-Implementation/sti')
cameraFile = require('libs/hump/camera')

Game = {
    width = 1000,
    height = 768,
    scale = 3
}

Sprites = {}
Animations = {}
Platforms = {}
Sounds = {}

function love.load()
    love.window.setMode(Game.width, Game.height)
    Sprites.playerSheet = love.graphics.newImage('sprites/playerSheet.png')
    Sprites.enemySheet = love.graphics.newImage('sprites/enemySheet.png')
    Sprites.background = love.graphics.newImage('sprites/background.png')

    local grid = anim8.newGrid(614, 564, Sprites.playerSheet:getWidth(), Sprites.playerSheet:getHeight())
    local enemyGrid = anim8.newGrid(100, 79, Sprites.enemySheet:getWidth(), Sprites.enemySheet:getHeight())

    cam = cameraFile()

    Sounds.jump = love.audio.newSource('audio/jump.wav', 'static')
    Sounds.music = love.audio.newSource('audio/music.mp3', 'stream')
    Sounds.music:setLooping(true)
    Sounds.music:setVolume(0.5)

    Sounds.music:play()

    Animations.idle = anim8.newAnimation(grid('1-15', 1), 0.05)
    Animations.jump = anim8.newAnimation(grid('1-7', 2), 0.05)
    Animations.run = anim8.newAnimation(grid('1-15', 3), 0.05)
    Animations.enemy = anim8.newAnimation(enemyGrid('1-2', 1), 0.03)

    World = wf.newWorld(0, 800, false)
    World:setQueryDebugDrawing(true)

    World:addCollisionClass('platform')
    World:addCollisionClass('player')
    World:addCollisionClass('danger')

    require('player')
    require('enemy')
    require('libs/show')

    DangerZone = World:newRectangleCollider(-500, 800, 800, 50, {collision_class='danger'})
    DangerZone:setType('static')

    FlagX = 0
    FlagY = 0

    SaveData = {}
    SaveData.currentLevel = "lvl1"

    if love.filesystem.getInfo("data.lua") then
        local data = love.filesystem.load("data.lua")
        data()
    end

    LoadMap(SaveData.currentLevel)
end

function love.draw()
    love.graphics.draw(Sprites.background, 0, 0)

    cam:attach()
    GameMap:drawLayer(GameMap.layers["Tile Layer 1"])
    -- World:draw()
    drawPlayer()
    drawEnemies()
    cam:detach()
end

function love.update(dt)
    World:update(dt)
    GameMap:update(dt)
    playerUpdate(dt)
    UpdateEnemies(dt)

    local px, py = Player:getPosition()
    cam:lookAt(px, love.graphics.getHeight() / 2)

    local colliders = World:queryCircleArea(FlagX, FlagY, 10, {'player'})
    if #colliders > 0 then
        if SaveData.currentLevel == "lvl1" then
            LoadMap('lvl2')
        elseif SaveData.currentLevel == "lvl2" then
            LoadMap('lvl1')
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'up' then
        if not Player.isJumping then
            Player:applyLinearImpulse(0, -4000)
            Sounds.jump:play()
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local colliders = World:queryCircleArea(x, y, 200, {'platform', 'danger'})
        for i, c in ipairs(colliders) do
            c:destroy()
        end
    end
end

function SpawnPlatform(x, y, width, height)
    if width > 0 and height > 0 then -- check if there are real platforms to be created
        local platform = World:newRectangleCollider(x, y, width, height, {collision_class = 'platform'})
        platform:setType('static')
        table.insert(Platforms, platform)
    end
end

function destroyAllPlatforms()
    local i = #Platforms
    while i > -1 do
        if Platforms[i] ~= nil then
            Platforms[i]:destroy()
        end
        table.remove(Platforms, i)
        i = i - 1
    end
end

function LoadMap(mapName)
    SaveData.currentLevel = mapName
    love.filesystem.write("data.lua", table.show(SaveData, "SaveData"))
    destroyAllPlatforms()
    Player:setPosition(PlayerStartX, PlayerStartY)
    destroyEnemies()
    GameMap = sti("maps/" .. mapName .. ".lua")
    for _, obj in pairs(GameMap.layers["Platforms"].objects) do
        SpawnPlatform(obj.x, obj.y, obj.width, obj.height)
    end

    for _, obj in pairs(GameMap.layers["Enemies"].objects) do
        SpawnEnemy(obj.x, obj.y)
    end

    for _, obj in pairs(GameMap.layers["Flag"].objects) do
        FlagX = obj.x
        FlagY = obj.y
    end

    for _, obj in ipairs(GameMap.layers["Start"].objects) do
        PlayerStartX = obj.x
        PlayerStartY = obj.y
    end
end
