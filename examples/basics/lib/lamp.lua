-- lamp
-- A tiny vector library for lua
-- author: cgl4de
-- version: 0.1
-- date created: 29th December 2023
-- license: MIT

---@class vec2
---@field x number
---@field y number
---@field magnitude number
---@field unit vec2
local vec2 = {}

---@class vec3
---@field x number
---@field y number
---@field z number
---@field magnitude number
---@field unit vec3
local vec3 = {}

local lamp = {}
lamp.__index = lamp

--// constructors //--

---Creates a new Vector2
---@param x number?
---@param y number?
---@return vec2
function lamp.vec2(x, y)
    local self = setmetatable({
        x = x or 0,
        y = y or 0,
    }, vec2)

    return self
end

---Creates a new Vector3
---@param x number?
---@param y number?
---@param z number?
---@return vec3
function lamp.vec3(x, y, z)
    local self = setmetatable({
        x = x or 0,
        y = y or 0,
        z = z or 0,
    }, vec3)

    return self
end

---Returns a read-only null vec2
---@return table
function lamp.null2readonly()
    return { x = 0, y = 0 }
end

---Returns a read-only null vec3
---@return table
function lamp.null3readonly()
    return { x = 0, y = 0, z = 0 }
end

---Returns a vec2 containing the x component
---@return vec2
function lamp.x2() return lamp.vec2(1, 0) end

---Returns a vec2 containing the y component
---@return vec2
function lamp.y2() return lamp.vec2(0, 1) end

---Returns a vec2 containing both x and y components
---@return vec2
function lamp.xy2() return lamp.vec2(1, 1) end

---Returns a vec3 containing the x component
---@return vec3
function lamp.x3() return lamp.vec3(1, 0, 0) end

---Returns a vec3 containing the y component
---@return vec3
function lamp.y3() return lamp.vec3(0, 1, 0) end

---Returns a vec3 containing the x component
---@return vec3
function lamp.z() return lamp.vec3(0, 0, 1) end

---Returns a vec3 containing the xy component
---@return vec3
function lamp.xy3() return lamp.vec3(1, 1, 0) end

---Returns a vec3 containing the yz component
---@return vec3
function lamp.yz() return lamp.vec3(0, 1, 1) end

---Returns a vec3 containing the xz component
---@return vec3
function lamp.xz() return lamp.vec3(1, 0, 1) end

--// vec2 metatables //--

---@param key string
---@return any
function vec2:__index(key)
    if (key == "magnitude") then
        return math.sqrt(self.x * self.x + self.y * self.y)
    end
    if (key == "unit") then
        return self/self.magnitude
    end

    return rawget(self, key) or rawget(vec2, key)
end 

--// vec2 arithmetic //--
---@param rhs vec2|number
---@return vec2
function vec2:__add(rhs)
    if (type(rhs) == "number") then
        return lamp.vec2(self.x + rhs, self.y + rhs)
    end
    return lamp.vec2(self.x + rhs.x, self.y + rhs.y)
end

---@param rhs vec2|number
---@return vec2
function vec2:__sub(rhs)
    if (type(rhs) == "number") then
        return lamp.vec2(self.x - rhs, self.y - rhs)
    end
    return lamp.vec2(self.x - rhs.x, self.y - rhs.y)
end

---@param rhs vec2|number
---@return vec2
function vec2:__mul(rhs)
    if (type(rhs) == "number") then
        return lamp.vec2(self.x * rhs, self.y * rhs)
    end
    return lamp.vec2(self.x * rhs.x, self.y * rhs.y)
end

---@param rhs vec2|number
---@return vec2
function vec2:__div(rhs)
    if (type(rhs) == "number") then
        return lamp.vec2(self.x / rhs, self.y / rhs)
    end
    return lamp.vec2(self.x / rhs.x, self.y / rhs.y)
end

---@return vec2
function vec2:__unm()
    return lamp.vec2(-self.x, -self.y)
end

--// vec2 logic //--
---@param rhs vec2
---@return boolean
function vec2:__eq(rhs)
    return self:newround(2).magnitude == rhs:newround(2).magnitude
end

---@param rhs vec2
---@return boolean
function vec2:__ne(rhs)
    return self:newround(2).magnitude ~= rhs:newround(2).magnitude
end

---@param rhs vec2
---@return boolean
function vec2:__ge(rhs)
    return self.magnitude >= rhs.magnitude
end

---@param rhs vec2
---@return boolean
function vec2:__le(rhs)
    return self.magnitude <= rhs.magnitude
end

---@param rhs vec2
---@return boolean
function vec2:__g(rhs)
    return self.magnitude > rhs.magnitude
end

--// vec2 misc //--
function vec2:__tostring()
    return self:str()
end

function vec2:str()
    return ("vec2[%.3f, %.3f]"):format(self.x, self.y)
end

--// vec2 functions //--

---Sets the value of x and y
---@param x number?
---@param y number?
function vec2:set(x, y)
    self.x = x or self.x
    self.y = y or self.y
end

---Returns the dot product between 2 vec2's
---@param rhs vec2
---@return number
function vec2:dot(rhs)
    return self.x * rhs.x + self.y * rhs.y
end

---Returns the angle (in degrees) between two vec2's.
---@param rhs vec2
---@return number
function vec2:angle(rhs)
    local dot = self:dot(rhs)
    local magnitude = self.magnitude * rhs.magnitude
    return math.deg(math.acos(dot/magnitude))
end

---Normalizes the Vector2
function vec2:normalize()
    self = self/self.magnitude
end

---Rounds the vec2
---@param points number
function vec2:round(points)
    points = points or 0
    local resolution = 10^(points)
    local x, y
    if (self.x >= 0) then x = math.floor((self.x*resolution)+.5)/resolution
    else x = math.ceil((self.x*resolution)-.5)/resolution end
    if (self.y >= 0) then y = math.floor((self.y*resolution)+.5)/resolution
    else y = math.ceil((self.y*resolution)-.5)/resolution end
    self:set(x, y)
end

---Returns a copy of the rounded off version of the current vector2
---`points`: Number of decimal points
---@param points number
---@return vec2
function vec2:newround(points)
    points = points or 0
    local resolution = 10^(points)
    local vec = lamp.vec2()
    if (self.x >= 0) then vec.x = math.floor((self.x*resolution)+.5)/resolution
    else vec.x = math.ceil((self.x*resolution)-.5)/resolution end
    if (self.y >= 0) then vec.y = math.floor((self.y*resolution)+.5)/resolution
    else vec.y = math.ceil((self.y*resolution)-.5)/resolution end
    return vec
end

---Returns the distance between 2 vec2's
---@param rhs vec2
---@return number
function vec2:distance(rhs)
    return math.sqrt((rhs.x - self.x)^2 + (rhs.y - self.y)^2)
end

--// * * * * * * //--

---@param key string
---@return any
function vec3:__index(key)
    if (key == "magnitude") then
        return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
    end
    if (key == "unit") then
        return self/self.magnitude
    end

    return rawget(self, key) or rawget(vec3, key)
end

--// vec3 arithmetic //--

---@param rhs vec3|number
---@return vec3
function vec3:__add(rhs)
    if (type(rhs) == "number") then
        return lamp.vec3(self.x + rhs, self.y + rhs, self.z + rhs)
    end

    return lamp.vec3(self.x + rhs.x, self.y + rhs.y, self.z + rhs.z)
end

---@param rhs vec3|number
---@return vec3
function vec3:__sub(rhs)
    if (type(rhs) == "number") then
        return lamp.vec3(self.x - rhs, self.y - rhs, self.z - rhs)
    end

    return lamp.vec3(self.x - rhs.x, self.y - rhs.y, self.z - rhs.z)
end

---@param rhs vec3|number
---@return vec3
function vec3:__mul(rhs)
    if (type(rhs) == "number") then
        return lamp.vec3(self.x * rhs, self.y * rhs, self.z * rhs)
    end

    return lamp.vec3(self.x * rhs.x, self.y * rhs.y, self.z * rhs.z)
end

---@param rhs vec3|number
---@return vec3
function vec3:__div(rhs)
    if (type(rhs) == "number") then
        return lamp.vec3(self.x / rhs, self.y / rhs, self.z / rhs)
    end

    return lamp.vec3(self.x / rhs.x, self.y / rhs.y, self.z / rhs.z)
end

---@return vec3
function vec3:__unm()
    return lamp.vec3(-self.x, -self.y, -self.z)
end

--// vec3 logic //--

---@param rhs vec3
---@return boolean
function vec3:__eq(rhs)
    return self:round(2) == rhs:round(2)
end

---@param rhs vec3
---@return boolean
function vec3:__ne(rhs)
    return self:round(2) ~= rhs:round(2)
end

---@param rhs vec3
---@return boolean
function vec3:__ge(rhs)
    return self.magnitude >= rhs.magnitude
end

---@param rhs vec3
---@return boolean
function vec3:__le(rhs)
    return self.magnitude <= rhs.magnitude
end

---@param rhs vec3
---@return boolean
function vec3:__g(rhs)
    return self.magnitude > rhs.magnitude
end

---Sets the value of x, y and z
---@param x number?
---@param y number?
---@param z number?
function vec3:set(x, y, z)
    self.x = x or self.x
    self.y = y or self.y
    self.z = z or self.z
end

--// vec3 misc //--
function vec3:__tostring()
    return self:str()
end

function vec3:str()
    return ("vec3[%.3f, %.3f, %.3f]"):format(self.x, self.y, self.z)
end

function vec3:as_eq()
    return ("%ii + %ij + %ik"):format(self.x, self.y, self.z)
end

--// vec3 REAL arithmetic //--

---Returns `a . b` (a dot b)
---@param rhs vec3
---@param angle number?
---@return number
function vec3:dot(rhs, angle)
    if (angle and type(angle) == "number") then
        return self.magnitude * rhs.magnitude * math.cos(angle)
    end;

    return self.x * rhs.x + self.y * rhs.y + self.z * rhs.z
end

---Returns `a x b` (a cross b)
---@param rhs vec3
---@return vec3
function vec3:cross(rhs)
    local vec = lamp.vec3();
    vec:set(
        (self.y * rhs.z) - (self.z * rhs.y),
        -((self.x * rhs.z) - (self.z * rhs.x)),
        (self.x * rhs.y) - (self.y * rhs.x)
    )
    return vec
end

---Returns the angle (in degrees) between two vectors.
---@param rhs vec3
---@return number
function vec3:angle(rhs)
    local cross = self:cross(rhs).magnitude
    local magnitude = self.magnitude * rhs.magnitude
    return math.deg(math.asin(cross/magnitude))
end

---Normalizes the Vector3
function vec3:normalize()
    self = self/self.magnitude
end

---Rounds off the current vec2
---@param points any
function vec3:round(points)
    points = points or 0
    local resolution = 10^(points)
    local x, y, z
    if (self.x >= 0) then x = math.floor((self.x * resolution) + .5) / resolution
    else x = math.ceil((self.x * resolution) - .5) / resolution end
    if (self.y >= 0) then y = math.floor((self.y * resolution) + .5) / resolution
    else y = math.ceil((self.y * resolution) - .5) / resolution end
    if (self.z >= 0) then z = math.floor((self.z * resolution) + .5) / resolution
    else z = math.ceil((self.z * resolution) - .5) / resolution end
    self:set(x, y, z)
end

---Returns a copy of the rounded off version of the current vector3
---`points`: Number of decimal points
---@param points any
---@return vec3
function vec3:newround(points)
    points = points or 0
    local resolution = 10^(points)
    local vec = lamp.vec3()
    if (self.x >= 0) then vec.x = math.floor((self.x * resolution) + .5) / resolution
    else vec.x = math.ceil((self.x * resolution) - .5) / resolution end
    if (self.y >= 0) then vec.y = math.floor((self.y * resolution) + .5) / resolution
    else vec.y = math.ceil((self.y * resolution) - .5) / resolution end
    if (self.z >= 0) then vec.z = math.floor((self.z * resolution) + .5) / resolution
    else vec.z = math.ceil((self.z * resolution) - .5) / resolution end
    return vec
end

---Returns the distance between 2 vec2's
---@param rhs vec3
---@return number
function vec3:distance(rhs)
    return math.sqrt((rhs.x - self.x)^2 + (rhs.y - self.y)^2 + (rhs.z - self.z)^2)
end

--// * * * * * * // --

return lamp

--// Message for anyone who uses this library for their projects:
--// Thank you so much for choosing my vector library over the other "better" libraries.
--// I made this library just for fun and to speed up my game development with LOVE.
--// Once again thank you so much! :)