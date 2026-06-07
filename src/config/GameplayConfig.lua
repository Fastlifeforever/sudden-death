--[[
	GAMEPLAY CONFIGURATION
	Central configuration file for all gameplay balance and settings
	
	Place this in: ServerScriptService > Config > GameplayConfig (ModuleScript)
]]

local GameplayConfig = {}

-- ===== PLAYER SETTINGS =====
GameplayConfig.Player = {
	MaxHealth = 100,
	WalkSpeed = 16,
	SprintSpeed = 25,
	CrouchSpeed = 12,
	JumpPower = 50,
	RespawnTime = 5,
	
	-- Damage multipliers by hit zone
	DamageMultiplier = {
		Head = 1.5,
		Torso = 1.0,
		LeftArm = 0.9,
		RightArm = 0.9,
		LeftLeg = 0.8,
		RightLeg = 0.8,
	},
}

-- ===== WEAPON SETTINGS =====
GameplayConfig.Weapons = {
	M16 = {
		Name = "M16",
		Damage = 35,
		FireRate = 0.1,
		Accuracy = 0.85,
		Recoil = 0.15,
		MagazineSize = 30,
		ReloadTime = 2.5,
		BulletSpeed = 400,
		Range = 200,
		Type = "Auto",
	},
	
	MP5 = {
		Name = "MP5",
		Damage = 20,
		FireRate = 0.06,
		Accuracy = 0.75,
		Recoil = 0.25,
		MagazineSize = 30,
		ReloadTime = 1.8,
		BulletSpeed = 350,
		Range = 80,
		Type = "Auto",
	},
	
	AWP = {
		Name = "AWP",
		Damage = 90,
		FireRate = 1.5,
		Accuracy = 0.95,
		Recoil = 0.05,
		MagazineSize = 10,
		ReloadTime = 3.0,
		BulletSpeed = 500,
		Range = 300,
		Type = "Bolt",
	},
	
	Remington = {
		Name = "Remington",
		Damage = 70,
		FireRate = 1.0,
		Accuracy = 0.6,
		Recoil = 0.4,
		MagazineSize = 8,
		ReloadTime = 2.8,
		BulletSpeed = 300,
		Range = 40,
		Type = "Pump",
	},
	
	Glock = {
		Name = "Glock",
		Damage = 25,
		FireRate = 0.2,
		Accuracy = 0.8,
		Recoil = 0.1,
		MagazineSize = 17,
		ReloadTime = 1.5,
		BulletSpeed = 380,
		Range = 100,
		Type = "Semi",
	},
}

-- ===== AI SETTINGS =====
GameplayConfig.AI = {
	Difficulties = {
		Easy = {
			ReactionTime = 0.5,
			Accuracy = 0.6,
			Health = 75,
			SightRange = 80,
		},
		Medium = {
			ReactionTime = 0.3,
			Accuracy = 0.75,
			Health = 100,
			SightRange = 120,
		},
		Hard = {
			ReactionTime = 0.15,
			Accuracy = 0.9,
			Health = 125,
			SightRange = 150,
		},
		Nightmare = {
			ReactionTime = 0.05,
			Accuracy = 0.98,
			Health = 150,
			SightRange = 200,
		},
	},
	
	DefaultDifficulty = "Medium",
	SightRange = 120,
	DecisionUpdateRate = 0.3,
	PreferredCombatDistance = 60,
	CoverSearchRange = 50,
}

-- ===== GAME MODE SETTINGS =====
GameplayConfig.GameModes = {
	TDM = {
		Name = "Team Deathmatch",
		MaxPlayers = 16,
		TargetScore = 50,
		Duration = 600,
	},
	
	Elimination = {
		Name = "Elimination",
		MaxPlayers = 10,
		Duration = 300,
	},
	
	CTF = {
		Name = "Capture the Flag",
		MaxPlayers = 16,
		TargetCaptures = 3,
		Duration = 900,
	},
}

-- ===== PROGRESSION SETTINGS =====
GameplayConfig.Progression = {
	MaxLevel = 100,
	XpPerKill = 100,
	XpPerAssist = 50,
	XpPerObjective = 200,
}

-- ===== AUDIO SETTINGS =====
GameplayConfig.Audio = {
	MasterVolume = 1.0,
	SFXVolume = 0.8,
	MusicVolume = 0.6,
	VoiceChatVolume = 0.9,
}

-- ===== UI SETTINGS =====
GameplayConfig.UI = {
	CrosshairSize = 20,
	ShowMinimap = true,
	ShowKillfeeds = true,
	ShowDamageNumbers = true,
}

return GameplayConfig
