CustomModifiers = CustomModifiers or class({})

-- Steam ID3 table
local modTable = {
	-- leha
	[112315140] = "modifier_tester",

	-- homyak
	[136098003] = "modifier_dcp_tester",

	-- sheodar
	[104356809] = "modifier_sheo_dev",

	-- Banned
	[163227098] 	= "modifier_banned_custom",
	[162720331] 	= "modifier_banned_custom",
	[114152435] 	= "modifier_banned_custom",
	[68207584] 		= "modifier_banned_custom",
	[254249264] 	= "modifier_banned_custom",
	[262065464] 	= "modifier_banned_custom",
	[119682577] 	= "modifier_banned_custom",
	[187357138] 	= "modifier_banned_custom",
}

LinkLuaModifier("modifier_tester", 			'lib/custom_modifiers/modifiers/modifier_tester', 			LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dcp_tester", 		'lib/custom_modifiers/modifiers/modifier_dcp_tester', 		LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sheo_dev", 		'lib/custom_modifiers/modifiers/modifier_sheo_dev', 		LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_banned_custom", 	'lib/custom_modifiers/modifiers/modifier_banned_custom', 	LUA_MODIFIER_MOTION_NONE)

function CustomModifiers:OnHeroSpawn(hero)
	if not hero then return end

	local steam_id = PlayerResource:GetSteamAccountID( hero:GetPlayerOwnerID() )

	local modName = modTable[steam_id]

	if not modName then return end

	hero:AddNewModifier(hero, nil, modName, { duration = -1 })
end
