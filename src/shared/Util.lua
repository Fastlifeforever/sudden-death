--[[
	UTILITY FUNCTIONS
	Shared utility functions used throughout the game
	
	Place this in: ServerScriptService > Shared > Util (ModuleScript)
]]

local Util = {}

-- ===== MATH UTILITIES =====

--- Clamps a value between min and max
function Util.Clamp(value, min, max)
	return math.max(min, math.min(max, value))
end

--- Lerps between two values
function Util.Lerp(a, b, t)
	t = Util.Clamp(t, 0, 1)
	return a + (b - a) * t
end

--- Calculates distance between two Vector3 points
function Util.Distance(pos1, pos2)
	return (pos1 - pos2).Magnitude
end

--- Rounds a number to X decimal places
function Util.Round(num, decimals)
	decimals = decimals or 0
	local mult = 10 ^ decimals
	return math.floor(num * mult + 0.5) / mult
end

-- ===== TABLE UTILITIES =====

--- Clones a table shallowly
function Util.TableClone(tbl)
	local clone = {}
	for k, v in pairs(tbl) do
		clone[k] = v
	end
	return clone
end

--- Clones a table deeply (recursive)
function Util.TableDeepClone(tbl)
	if type(tbl) ~= "table" then return tbl end
	local clone = {}
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			clone[k] = Util.TableDeepClone(v)
		else
			clone[k] = v
		end
	end
	return clone
end

--- Gets table length (works with non-sequential tables)
function Util.TableLength(tbl)
	local count = 0
	for _ in pairs(tbl) do
		count = count + 1
	end
	return count
end

--- Checks if table contains a value
function Util.TableContains(tbl, value)
	for _, v in pairs(tbl) do
		if v == value then return true end
	end
	return false
end

--- Gets random element from table
function Util.TableRandom(tbl)
	if Util.TableLength(tbl) == 0 then return nil end
	local keys = {}
	for k in pairs(tbl) do
		table.insert(keys, k)
	end
	return tbl[keys[math.random(1, #keys)]]
end

-- ===== STRING UTILITIES =====

--- Splits a string by delimiter
function Util.StringSplit(str, delimiter)
	local result = {}
	for part in string.gmatch(str, "[^" .. delimiter .. "]+") do
		table.insert(result, part)
	end
	return result
end

--- Trims whitespace from string
function Util.StringTrim(str)
	return string.gsub(str, "^%s*(.-)%s*$", "%1")
end

--- Capitalizes first letter of string
function Util.StringCapitalize(str)
	return string.upper(string.sub(str, 1, 1)) .. string.lower(string.sub(str, 2))
end

-- ===== TIME UTILITIES =====

--- Converts seconds to MM:SS format
function Util.TimeToString(seconds)
	local minutes = math.floor(seconds / 60)
	local secs = math.floor(seconds % 60)
	return string.format("%02d:%02d", minutes, secs)
end

-- ===== VECTOR UTILITIES =====

--- Gets direction from point A to point B
function Util.GetDirection(fromPos, toPos)
	return (toPos - fromPos).Unit
end

--- Lerps between two Vector3 values
function Util.Vector3Lerp(v1, v2, t)
	return v1 + (v2 - v1) * Util.Clamp(t, 0, 1)
end

-- ===== HUMANOID UTILITIES =====

--- Gets humanoid from character
function Util.GetHumanoid(character)
	if not character then return nil end
	return character:FindFirstChildOfClass("Humanoid")
end

--- Gets humanoid root part
function Util.GetHumanoidRootPart(character)
	if not character then return nil end
	return character:FindFirstChild("HumanoidRootPart")
end

--- Checks if character is alive
function Util.IsAlive(character)
	local humanoid = Util.GetHumanoid(character)
	return humanoid and humanoid.Health > 0
end

-- ===== RAYCAST UTILITIES =====

--- Finds parts in a radius around a position
function Util.FindPartsInRadius(position, radius)
	local parts = {}
	local region = Region3.new(
		position - Vector3.new(radius, radius, radius),
		position + Vector3.new(radius, radius, radius)
	)
	region = region:ExpandToGrid(4)
	
	for _, part in ipairs(workspace:FindPartBoundsInRadius(position, radius)) do
		table.insert(parts, part)
	end
	return parts
end

-- ===== PRINT UTILITIES =====

--- Debug print
function Util.Debug(message)
	print("[DEBUG] " .. tostring(message))
end

--- Warning print
function Util.Warn(message)
	warn("[WARNING] " .. tostring(message))
end

--- Error print
function Util.Error(message)
	error("[ERROR] " .. tostring(message))
end

return Util
