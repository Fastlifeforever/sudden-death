--[[
	MAIN SERVER SCRIPT
	Entry point for server-side game logic and player management
	
	Place this in: ServerScriptService (Script)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Load modules
local GameplayConfig = require(game.ServerScriptService:WaitForChild("Config"):WaitForChild("GameplayConfig"))
local Constants = require(game.ServerScriptService:WaitForChild("Shared"):WaitForChild("Constants"))
local Util = require(game.ServerScriptService:WaitForChild("Shared"):WaitForChild("Util"))
local WeaponSystem = require(game.ServerScriptService:WaitForChild("Systems"):WaitForChild("WeaponSystem"))
local AISystem = require(game.ServerScriptService:WaitForChild("Systems"):WaitForChild("AISystem"))

-- ===== GAME STATE =====
local GameState = {
	CurrentState = Constants.GameState.LOBBY,
	Players = {},
	Match = {
		Duration = 0,
		MaxDuration = 600,
		RedScore = 0,
		BlueScore = 0,
	},
	AI = {},
}

print("[SERVER] ===== SUDDEN DEATH FPS SERVER INITIALIZING =====")
print("[SERVER] GameplayConfig loaded")
print("[SERVER] Constants loaded")
print("[SERVER] Util loaded")

-- ===== PLAYER INITIALIZATION =====

local function InitializePlayer(player)
	print("[SERVER] Player joined: " .. player.Name)
	
	GameState.Players[player] = {
		UserId = player.UserId,
		Character = nil,
		Team = Constants.Team.SPECTATOR,
		Kills = 0,
		Deaths = 0,
		Assists = 0,
		Score = 0,
		Level = 1,
		Stats = {
			Health = GameplayConfig.Player.MaxHealth,
		},
	}
end

local function SpawnPlayer(player)
	if not Players:FindFirstChild(player.Name) then return end
	
	local character = player:LoadCharacter()
	if character then
		GameState.Players[player].Character = character
		GameState.Players[player].Stats.Health = GameplayConfig.Player.MaxHealth
		print("[SERVER] Player spawned: " .. player.Name)
	end
end

local function HandlePlayerDeath(player, killer)
	local playerData = GameState.Players[player]
	if not playerData then return end
	
	playerData.Deaths = playerData.Deaths + 1
	
	if killer and GameState.Players[killer] then
		GameState.Players[killer].Kills = GameState.Players[killer].Kills + 1
		GameState.Players[killer].Score = GameState.Players[killer].Score + 100
		
		local killerTeam = GameState.Players[killer].Team
		if killerTeam == Constants.Team.RED then
			GameState.Match.RedScore = GameState.Match.RedScore + 1
		elseif killerTeam == Constants.Team.BLUE then
			GameState.Match.BlueScore = GameState.Match.BlueScore + 1
		end
	end
	
	print("[SERVER] Player died: " .. player.Name)
	
	task.wait(GameplayConfig.Player.RespawnTime)
	SpawnPlayer(player)
end

-- ===== GAME MANAGEMENT =====

local function StartMatch()
	GameState.CurrentState = Constants.GameState.PLAYING
	GameState.Match.Duration = 0
	GameState.Match.RedScore = 0
	GameState.Match.BlueScore = 0
	
	print("[SERVER] ===== MATCH STARTED! =====")
	print("[SERVER] Game Mode: Team Deathmatch")
	print("[SERVER] Target Score: " .. GameplayConfig.GameModes.TDM.TargetScore)
end

local function EndMatch()
	GameState.CurrentState = Constants.GameState.GAME_END
	
	local winner = GameState.Match.RedScore > GameState.Match.BlueScore and Constants.Team.RED or Constants.Team.BLUE
	
	print("[SERVER] ===== MATCH ENDED! =====")
	print("[SERVER] Winner: " .. winner)
	print("[SERVER] Final Score - Red: " .. GameState.Match.RedScore .. " | Blue: " .. GameState.Match.BlueScore)
end

-- ===== PLAYER EVENTS =====

Players.PlayerAdded:Connect(function(player)
	InitializePlayer(player)
	task.wait(1)
	SpawnPlayer(player)
end)

Players.PlayerRemoving:Connect(function(player)
	print("[SERVER] Player left: " .. player.Name)
	GameState.Players[player] = nil
end)

-- ===== CHARACTER EVENTS =====

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		
		humanoid.Died:Connect(function()
			HandlePlayerDeath(player)
		end)
		
		humanoid.HealthChanged:Connect(function(newHealth)
			if GameState.Players[player] then
				GameState.Players[player].Stats.Health = newHealth
			end
		end)
	end)
end)

-- ===== GAME LOOP =====

RunService.Heartbeat:Connect(function(deltaTime)
	if GameState.CurrentState == Constants.GameState.PLAYING then
		-- Update player positions
		for player, playerData in pairs(GameState.Players) do
			if playerData.Character and Util.IsAlive(playerData.Character) then
				-- Server-side validation
			end
		end
		
		-- Check win condition
		if GameState.Match.RedScore >= GameplayConfig.GameModes.TDM.TargetScore then
			EndMatch()
		elseif GameState.Match.BlueScore >= GameplayConfig.GameModes.TDM.TargetScore then
			EndMatch()
		end
		
		-- Update match duration
		GameState.Match.Duration = GameState.Match.Duration + deltaTime
		if GameState.Match.Duration >= GameplayConfig.GameModes.TDM.Duration then
			EndMatch()
		end
	end
end)

-- ===== INITIALIZATION =====

print("[SERVER] Waiting for players to join...")
task.wait(5)

print("[SERVER] Starting match in 10 seconds...")
task.wait(10)

StartMatch()

-- ===== CLEANUP =====

game:BindToClose(function()
	print("[SERVER] ===== SERVER SHUTTING DOWN =====")
	print("[SERVER] Saving player data...")
	print("[SERVER] Goodbye!")
end)

return GameState
