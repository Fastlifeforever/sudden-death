--[[
	WEAPON SYSTEM
	Handles weapon mechanics, firing, reloading, and ballistics
	
	Place this in: ServerScriptService > Systems > WeaponSystem (ModuleScript)
]]

local WeaponSystem = {}
WeaponSystem.__index = WeaponSystem

function WeaponSystem.new(weaponName, owner)
	local self = setmetatable({}, WeaponSystem)
	
	self.Name = weaponName
	self.Owner = owner
	self.Config = owner.GameplayConfig.Weapons[weaponName] or owner.GameplayConfig.Weapons.M16
	
	-- Ammo management
	self.AmmoInMagazine = self.Config.MagazineSize
	self.TotalAmmo = self.Config.MagazineSize * 5
	
	-- State
	self.IsReloading = false
	self.IsFiring = false
	self.LastFireTime = 0
	self.FireCounter = 0
	
	-- Spread and recoil
	self.CurrentSpread = 0
	self.CurrentRecoil = 0
	
	print("[WEAPON] Created weapon: " .. weaponName)
	
	return self
end

--- Fire weapon
function WeaponSystem:Fire(origin, direction)
	local currentTime = tick()
	local timeSinceLastFire = currentTime - self.LastFireTime
	
	-- Check if weapon can fire
	if timeSinceLastFire < self.Config.FireRate then
		return false
	end
	
	if self.AmmoInMagazine <= 0 then
		print("[WEAPON] Out of ammo!")
		return false
	end
	
	if self.IsReloading then
		return false
	end
	
	self.LastFireTime = currentTime
	self.AmmoInMagazine = self.AmmoInMagazine - 1
	self.FireCounter = self.FireCounter + 1
	
	-- Calculate spread
	local spread = self:CalculateSpread()
	local finalDirection = self:ApplySpread(direction, spread)
	
	-- Apply recoil
	self:ApplyRecoil()
	
	-- Cast bullet
	self:CastBullet(origin, finalDirection)
	
	-- Auto reload when empty
	if self.AmmoInMagazine <= 0 and self.TotalAmmo > 0 then
		self:Reload()
	end
	
	return true
end

--- Calculate weapon spread
function WeaponSystem:CalculateSpread()
	local baseSpread = (1 - self.Config.Accuracy) * 10
	local additionalSpread = self.CurrentSpread
	
	-- Increase spread based on fire rate (more shots = more spread)
	if self.Config.Type == "Auto" then
		baseSpread = baseSpread + (self.FireCounter * 0.1)
	end
	
	return math.min(baseSpread + additionalSpread, 45)
end

--- Apply spread to direction
function WeaponSystem:ApplySpread(direction, spread)
	local spreadRadian = math.rad(spread)
	local randomAngle = math.random() * math.pi * 2
	
	local offset = Vector3.new(
		math.cos(randomAngle) * spreadRadian,
		math.sin(randomAngle) * spreadRadian,
		0
	)
	
	return (direction + offset).Unit
end

--- Apply recoil to weapon
function WeaponSystem:ApplyRecoil()
	self.CurrentRecoil = self.CurrentRecoil + self.Config.Recoil
	self.CurrentSpread = self.CurrentSpread + (self.Config.Recoil * 0.5)
end

--- Cast bullet and check for hits
function WeaponSystem:CastBullet(origin, direction)
	local bulletDistance = self.Config.Range
	
	-- Raycast to find hit
	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Blacklist
	rayParams.FilterDescendantsInstances = {self.Owner.Character}
	
	local rayResult = workspace:Raycast(origin, direction * bulletDistance, rayParams)
	
	if rayResult then
		self:HandleBulletHit(rayResult, direction)
	end
end

--- Handle bullet hitting something
function WeaponSystem:HandleBulletHit(rayResult, direction)
	local hitPart = rayResult.Instance
	local character = hitPart.Parent
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	
	if humanoid and character ~= self.Owner.Character then
		-- Calculate damage
		local damage = self:CalculateDamage(character, hitPart)
		
		-- Apply damage
		humanoid:TakeDamage(damage)
		
		print("[WEAPON] Hit " .. character.Name .. " for " .. damage .. " damage")
		
		return true
	end
	
	return false
end

--- Calculate damage based on hit zone
function WeaponSystem:CalculateDamage(character, hitPart)
	local baseDamage = self.Config.Damage
	local multiplier = self.Owner.GameplayConfig.Player.DamageMultiplier[hitPart.Name] or 1.0
	
	return baseDamage * multiplier
end

--- Reload weapon
function WeaponSystem:Reload()
	if self.IsReloading then return false end
	if self.TotalAmmo <= 0 then return false end
	
	self.IsReloading = true
	print("[WEAPON] Reloading " .. self.Name)
	
	task.wait(self.Config.ReloadTime)
	
	-- Calculate ammo to reload
	local ammoNeeded = self.Config.MagazineSize - self.AmmoInMagazine
	local ammoToReload = math.min(ammoNeeded, self.TotalAmmo)
	
	self.AmmoInMagazine = self.AmmoInMagazine + ammoToReload
	self.TotalAmmo = self.TotalAmmo - ammoToReload
	self.IsReloading = false
	self.FireCounter = 0
	
	print("[WEAPON] Reload complete. Ammo: " .. self.AmmoInMagazine .. "/" .. self.TotalAmmo)
	
	return true
end

--- Get weapon info
function WeaponSystem:GetInfo()
	return {
		Name = self.Name,
		Type = self.Config.Type,
		Damage = self.Config.Damage,
		AmmoInMag = self.AmmoInMagazine,
		TotalAmmo = self.TotalAmmo,
		IsReloading = self.IsReloading,
	}
end

return WeaponSystem
