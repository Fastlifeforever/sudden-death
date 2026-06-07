--[[
	CONSTANTS
	Shared game constants used throughout the entire game
	
	Place this in: ServerScriptService > Shared > Constants (ModuleScript)
]]

local Constants = {}

-- ===== GAME STATE =====
Constants.GameState = {
	LOBBY = "Lobby",
	LOADING = "Loading",
	PLAYING = "Playing",
	PAUSED = "Paused",
	ROUND_END = "RoundEnd",
	GAME_END = "GameEnd",
}

-- ===== PLAYER STATE =====
Constants.PlayerState = {
	IDLE = "Idle",
	MOVING = "Moving",
	SPRINTING = "Sprinting",
	CROUCHING = "Crouching",
	AIMING = "Aiming",
	RELOADING = "Reloading",
	DEAD = "Dead",
	RESPAWNING = "Respawning",
}

-- ===== AI STATE =====
Constants.AIState = {
	IDLE = "Idle",
	PATROL = "Patrol",
	ALERT = "Alert",
	CHASE = "Chase",
	COMBAT = "Combat",
	RELOAD = "Reload",
	TAKE_COVER = "TakeCover",
	DEAD = "Dead",
}

-- ===== TEAMS =====
Constants.Team = {
	RED = "Red",
	BLUE = "Blue",
	SPECTATOR = "Spectator",
	NONE = "None",
}

-- ===== TEAM COLORS =====
Constants.TeamColor = {
	[Constants.Team.RED] = Color3.fromRGB(255, 0, 0),
	[Constants.Team.BLUE] = Color3.fromRGB(0, 100, 255),
	[Constants.Team.SPECTATOR] = Color3.fromRGB(128, 128, 128),
}

-- ===== DAMAGE TYPES =====
Constants.DamageType = {
	BULLET = "Bullet",
	EXPLOSIVE = "Explosive",
	MELEE = "Melee",
	ENVIRONMENTAL = "Environmental",
}

-- ===== HIT ZONES =====
Constants.HitZone = {
	HEAD = "Head",
	TORSO = "Torso",
	LEFT_ARM = "LeftArm",
	RIGHT_ARM = "RightArm",
	LEFT_LEG = "LeftLeg",
	RIGHT_LEG = "RightLeg",
}

-- ===== GAME MODES =====
Constants.GameMode = {
	TDM = "TDM",
	ELIMINATION = "Elimination",
	CTF = "CTF",
	CAMPAIGN = "Campaign",
}

-- ===== NETWORK EVENTS =====
Constants.NetworkEvent = {
	-- Player events
	PLAYER_SPAWNED = "PlayerSpawned",
	PLAYER_DIED = "PlayerDied",
	PLAYER_RESPAWNED = "PlayerRespawned",
	
	-- Weapon events
	WEAPON_FIRED = "WeaponFired",
	WEAPON_RELOADED = "WeaponReloaded",
	WEAPON_SWITCHED = "WeaponSwitched",
	
	-- Game events
	MATCH_STARTED = "MatchStarted",
	MATCH_ENDED = "MatchEnded",
	SCORE_CHANGED = "ScoreChanged",
}

-- ===== TIME VALUES =====
Constants.Time = {
	SPAWN_PROTECTION_DURATION = 3,
	RESPAWN_DELAY = 5,
	MATCH_START_DELAY = 10,
	LOBBY_TIMEOUT = 300,
}

-- ===== DISTANCE VALUES =====
Constants.Distance = {
	MELEE_RANGE = 5,
	CLOSE_COMBAT = 30,
	MID_RANGE = 100,
	LONG_RANGE = 250,
	SNIPER_RANGE = 500,
}

-- ===== XP MULTIPLIERS =====
Constants.XPMultiplier = {
	KILL = 1.0,
	ASSIST = 0.5,
	HEADSHOT = 1.5,
	OBJECTIVE = 2.0,
}

return Constants
