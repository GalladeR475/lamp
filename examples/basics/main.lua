local lamp = require "lib.lamp"

function love.load()
    player = {
        pos = lamp.vec2(),
        dir = lamp.vec2(),
        size = 5,
        speed = 5,
    }
    origin = lamp.vec2(math.floor(love.graphics.getWidth()/2), math.floor(love.graphics.getHeight()/2))
end

function love.update(dt)
    if (love.keyboard.isDown("w")) then
        player.pos.y = player.pos.y - player.speed
    end
    if (love.keyboard.isDown("a")) then
        player.pos.x = player.pos.x - player.speed
    end
    if (love.keyboard.isDown("s")) then
        player.pos.y = player.pos.y + player.speed
    end
    if (love.keyboard.isDown("d")) then
        player.pos.x = player.pos.x + player.speed
    end
    player.pos:normalize()
end

function love.draw()
    love.graphics.circle("line", player.pos.x, player.pos.y, player.size)
    --// red
    love.graphics.setColor(1, 0, 0)
    love.graphics.line(origin.x, origin.y, origin.x, 0)
    love.graphics.line(origin.x, origin.y, origin.x, (origin.y*2))
    --// green
    love.graphics.setColor(0, 1, 0)
    love.graphics.line(origin.x, origin.y, (origin.x*2), origin.y)
    love.graphics.line(origin.x, origin.y, -(origin.x*2), origin.y)
    --// yellow
    love.graphics.setColor(1, 1, 0)
    love.graphics.line(player.pos.x, player.pos.y, player.pos.x, origin.y)
    --// teal
    love.graphics.setColor(0, 1, 1)
    love.graphics.line(player.pos.x, player.pos.y, origin.x, player.pos.y)
    --// white
    love.graphics.setColor(1, 1, 1)
    love.graphics.line(origin.x, origin.y, player.pos.x, player.pos.y)

    love.graphics.print("o: "..tostring(origin), origin.x, origin.y)
    love.graphics.print("player: "..tostring(player.pos), player.pos.x, player.pos.y - 20)
    
    love.graphics.print(
        ("distance from origin: %.3f"):format(player.pos:distance(origin)), 
        player.pos.x, player.pos.y - 35
    )
    love.graphics.print(
        ("magnitude: %.3f"):format(player.pos.magnitude),
         player.pos.x, player.pos.y - 50
    )
    love.graphics.print("player on x: "..tostring((player.pos * lamp.x2())), player.pos.x, origin.y + 15)
    love.graphics.print("player on y: "..tostring((player.pos * lamp.y2())), origin.x, player.pos.y + 15)
end