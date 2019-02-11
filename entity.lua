_id = 0
--is this bullshit witht he two tabels?
local Entity = {
    toBeCreated = {},
    toBeRemoved = {},
    count = 0
}

function Entity:new(values)
    local o = {}
    o.type = "Entity"
    _id = _id + 1
    o.id = _id
    o.dead = false
    o.systems = {}
    o.destroy = Entity.destroy
    for k, v in pairs(values) do
        o[k] = v 
    end
    Entity.count = Entity.count + 1
    return o
end

function Entity:destroy()
    self.dead = true
    Entity.count = Entity.count - 1
end

function Entity:postStepCreate()
    self.toBeCreated()
end

function Entity:postStepRemove()
end

setmetatable( Entity, { __call = Entity.new } )
return Entity