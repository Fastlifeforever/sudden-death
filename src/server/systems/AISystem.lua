--[[
	AI SYSTEM
	Handles enemy AI behavior, combat, and pathfinding
	
	Place this in: ServerScriptService > Systems > AISystem (ModuleScript)
]]

local AISystem = {}
AISystem.__index = AISystem

function AISystem.new(character, difficulty, gameplayConfig, util, constants)
	local self = setmetatable({}, AISystem)
	
	self.Character = character
	self.Humanoid = character:FindFirstChildOfClass("Humanoid")
	self.RootPart = character:FindFirstChild("HumanoidRootPart")
	
	-- Config
	self.GameplayConfig = gameplayConfig
	self.Util = util
	self.Constants = constants
	
	-- AI Configuration
	difficulty = difficulty or "Medium"
	self.Config = gameplayConfig.AI.Difficulties[difficulty] or gameplayConfig.AI.Difficulties.Medium
	self.Difficulty = difficulty
	
	-- State
	self.State = constants.AIState.IDLE
	self.Target = nil
	self.LastDecisionTime = 0
	self.DecisionInterval = gameplayConfig.AI.DecisionUpdateRate
	
	-- Awareness
	self.EnemiesInSight = {}
	self.LastSeenPosition = nil
	self.AwarenessLevel = 0
	
	-- Pathfinding
	self.CurrentPath = nil
	self.PathIndex = 1
	
	print("[AI] Spawned AI: " .. character.Name .. " (" .. difficulty .. ")")
	
	return self
end

--- Update AI behavior
function AISystem:Update()
	if not self.Util.IsAlive(self.Character) then
		self.State = self.Constants.AIState.DEAD
		return
	end
	
	local currentTime = tick()
	
	-- Update awareness
	self:UpdateAwareness()
	
	-- Make decisions periodically
	if currentTime - self.LastDecisionTime > self.DecisionInterval then
		self:MakeDecision()
		self.LastDecisionTime = currentTime
	end
	
	-- Execute current state
	self:ExecuteState()
end

--- Scan for enemies
function AISystem:UpdateAwareness()
	self.EnemiesInSight = {}
	
	local sightRange = self.Config.SightRange
	local partsInRange = self.Util.FindPartsInRadius(self.RootPart.Position, sightRange)
	
	for _, part in ipairs(partsInRange) do
		local character = part.Parent
		if character and character ~= self.Character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Health > 0 then
				if self:HasLineOfSight(character) then
					table.insert(self.EnemiesInSight, character)
					self.LastSeenPosition = character:FindFirstChild("HumanoidRootPart").Position
				end
			end
		end
	end
	
	-- Update threat level
	if #self.EnemiesInSight > 0 then
		self.Target = self.EnemiesInSight[1]
		self.AwarenessLevel = self.Util.Clamp(self.AwarenessLevel + 0.5, 0, 1.0)
	else
		self.AwarenessLevel = self.Util.Clamp(self.AwarenessLevel - 0.2, 0, 1.0)
		if self.AwarenessLevel <= 0 then
			self.Target = nil
		end
	end
end

--- Check line of sight to target
function AISystem:HasLineOfSight(target)
	local targetRootPart = target:FindFirstChild("HumanoidRootPart")
	if not targetRootPart then return false end
	
	local direction = (targetRootPart.Position - self.RootPart.Position)
	local distance = direction.Magnitude
	
	if distance > self.Config.SightRange then
		return false
	end
	
	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Blacklist
	rayParams.FilterDescendantsInstances = {self.Character, target}
	
	local rayResult = workspace:Raycast(self.RootPart.Position, direction.Unit * distance, rayParams)
	
	return rayResult == nil or rayResult.Instance:IsDescendantOf(target)
end

--- Make AI decision
function AISystem:MakeDecision()
	if not self.Target or not self.Util.IsAlive(self.Target) then
		if self.AwarenessLevel > 0.3 then
			self.State = self.Constants.AIState.ALERT
		else
			self.State = self.Constants.AIState.PATROL
		end
		return
	end
	
	local targetDistance = self.Util.Distance(self.RootPart.Position, self.Target:FindFirstChild("HumanoidRootPart").Position)
	
	if targetDistance < self.GameplayConfig.AI.PreferredCombatDistance then
		self.State = self.Constants.AIState.COMBAT
	elseif targetDistance < self.GameplayConfig.AI.PreferredCombatDistance * 2 then
		self.State = self.Constants.AIState.CHASE
	else
		self.State = self.Constants.AIState.IDLE
	end
end

--- Execute current AI state
function AISystem:ExecuteState()
	if self.State == self.Constants.AIState.IDLE then
		self:IdleBehavior()
	elseif self.State == self.Constants.AIState.PATROL then
		self:PatrolBehavior()
	elseif self.State == self.Constants.AIState.ALERT then
		self:AlertBehavior()
	elseif self.State == self.Constants.AIState.CHASE then
		self:ChaseBehavior()
	elseif self.State == self.Constants.AIState.COMBAT then
		self:CombatBehavior()
	end
end

--- Idle behavior
function AISystem:IdleBehavior()
	self.Humanoid:MoveTo(self.RootPart.Position)
end

--- Patrol behavior
function AISystem:PatrolBehavior()
	if not self.CurrentPath or self.PathIndex > #self.CurrentPath then
		local randomOffset = Vector3.new(
			math.random(-50, 50),
			0,
			math.random(-50, 50)
		)
		local patrolPoint = self.RootPart.Position + randomOffset
		self.CurrentPath = {patrolPoint}
		self.PathIndex = 1
	end
	
	if self.PathIndex <= #self.CurrentPath then
		local targetPoint = self.CurrentPath[self.PathIndex]
		self.Humanoid:MoveTo(targetPoint)
		
		if self.Util.Distance(self.RootPart.Position, targetPoint) < 5 then
			self.PathIndex = self.PathIndex + 1
		end
	end
end

--- Alert behavior
function AISystem:AlertBehavior()
	if self.LastSeenPosition then
		self.Humanoid:MoveTo(self.LastSeenPosition)
	end
end

--- Chase behavior
function AISystem:ChaseBehavior()
	if self.Target and self.Util.IsAlive(self.Target) then
		local targetPos = self.Target:FindFirstChild("HumanoidRootPart").Position
		self.Humanoid:MoveTo(targetPos)
		self.Humanoid.WalkSpeed = self.GameplayConfig.Player.SprintSpeed
	end
end

--- Combat behavior
function AISystem:CombatBehavior()
	if not self.Target or not self.Util.IsAlive(self.Target) then
		self.State = self.Constants.AIState.IDLE
		return
	end
	
	local targetRootPart = self.Target:FindFirstChild("HumanoidRootPart")
	if not targetRootPart then return end
	
	local targetPos = targetRootPart.Position
	
	-- Strafe around target
	local strafeOffset = Vector3.new(math.cos(tick()) * 20, 0, math.sin(tick()) * 20)
	self.Humanoid:MoveTo(targetPos + strafeOffset)
end

return AISystem
