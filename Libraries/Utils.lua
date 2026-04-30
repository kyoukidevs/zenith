-- utils library for my script zenith.xyz😈
local utils = {}

-- vectors shit 
utils.To2D = function(vector)
    if typeof(vector) ~= "Vector3" then
        return nil 
    end

    return Vector2.new(vector.X, vector.Y)
end

utils.FloorVector = function(vector)
    if typeof(vector) == "Vector2" then
        return Vector2.new(math.floor(vector.X), math.floor(vector.Y))
    else
        return Vector3.new(math.floor(vector.X), math.floor(vector.Y), math.floor(vector.Z))
    end
end

utils.GetBoundingBox = function(model, orientation)
    local parts = type(model) == "table" and model or nil 
    orientation = orientation or CFrame.new()

    if not parts then
        parts = {}
        for _,part in model:GetChildren() do
            if part:IsA("BasePart") then 
                table.insert(parts, part)
            end
        end
    end

	local abs = math.abs
	local inf = math.huge
	local minx, miny, minz = inf, inf, inf
	local maxx, maxy, maxz = -inf, -inf, -inf

	for _, obj in parts do
        local cf = orientation:ToObjectSpace(obj.CFrame)
        local size = obj.Size
        local sx, sy, sz = size.X, size.Y, size.Z
        local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cf:GetComponents()

        local wsx = 0.5 * (abs(R00) * sx + abs(R01) * sy + abs(R02) * sz)
        local wsy = 0.5 * (abs(R10) * sx + abs(R11) * sy + abs(R12) * sz)
        local wsz = 0.5 * (abs(R20) * sx + abs(R21) * sy + abs(R22) * sz)

        if minx > x - wsx then minx = x - wsx end
        if miny > y - wsy then miny = y - wsy end
        if minz > z - wsz then minz = z - wsz end
        if maxx < x + wsx then maxx = x + wsx end
        if maxy < y + wsy then maxy = y + wsy end
        if maxz < z + wsz then maxz = z + wsz end
	end

	local omin = Vector3.new(minx, miny, minz)
	local omax = Vector3.new(maxx, maxy, maxz)
	local omiddle = (omax + omin) / 2
	local wCf = orientation - orientation.Position + orientation:PointToWorldSpace(omiddle)

	return wCf, (omax - omin)
end

utils.DeepCopy = function(table)
    local copy = {}

    for k,v in table do
        if type(v) == "table" then
            copy[k] = utils.deep_copy(v)
        else
            copy[k] = v 
        end
    end

    return copy 
end

utils.Round = function(self, Value, Decimals)
	math.round(Value / Decimals) * Decimals
end

utils.CommaValue = function(self, Increment, Val)
	if Increment > 1 then
		return string.format("%.2f", Val)
	else
		return tostring(math.floor(Val + 0.5))
	end
end

utils.SafeCall = function(self, Callback)
	pcall(Callback)
end

utils.Rotate = function(cf)
    local x,y,z = cf:ToOrientation()
    return CFrame.new(cf.Position) * CFrame.Angles(0, y, 0)
end

return utils 
