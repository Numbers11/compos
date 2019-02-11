local inspect = require "lib.inspect.inspect"
local System = require "system"
local Entity = require "entity"
local Vec = require "lib.hump.vector"
local GTimer = require "lib.hump.timer"


----------------------
local Timer = System("Timer")

function Timer:onAdd(e)
    print("added ", self.name, e.name)
    --init necessary values here
    e.timer = GTimer.new()
    --if e.ttl then
    --    e.timer:after(ttl, function() e:destroy() end)
    --end
end

function Timer:onRemove(e)
    print("removed ", self.name, e.name)
    e.timer = nil
end

function Timer:update(dt)
    self:iter(function(e)
        e.timer:update(dt)
    end)
end
----------------------

----------------------
local Movement = System("Movement")

function Movement:onAdd(e)
    print("added ", self.name, e.name)
    --init necessary values here
    e.velocity = e.velocity or Vec(0,0)
    e.acceleration = e.acceleration or Vec(0,0)
end

function Movement:onRemove(e)
    print("removed ", self.name, e.name)
    --remove values that might cause troubles
end

function Movement:update(dt)
    self:iter(function(e)
        e.pos = e.pos + e.velocity * dt
    end)
end
----------------------

-- input -> movement (aka physics) step -> collision
function love.load()
    GTimer.every(0.1, function()
        local radius = 200
        local angle = math.random() * math.pi * 2;
        local x = math.cos(angle)*radius;
        local y = math.sin(angle)*radius;
        local ent = Entity({name = "Adolf", pos = Vec(400, 300), velocity = Vec(x, y), ttl = 5})
        Timer:add(ent)
        Movement:add(ent)

        GTimer.after(1, function() print("ff"); ent:destroy() end)
    end)

end

function love.update(dt)
    Timer:update(dt)
    GTimer.update(dt)
    Movement:update(dt)
end

function love.draw()
    love.graphics.print(love.timer.getFPS() .. "\n" .. Entity.count, 2, 2)
    for _,e in pairs(Movement.entities) do
        love.graphics.circle("fill", e.pos.x, e.pos.y, 3)
    end
end