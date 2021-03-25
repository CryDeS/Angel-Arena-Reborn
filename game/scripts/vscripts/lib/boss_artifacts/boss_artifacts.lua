local TIME_FOR_CHARGE_FROM_BOSS_KILL = 3

local function SearchCurrentAltarForTeam(team)
	local altars = Entities:FindAllByName('angel_arena_altar_for_artifacts')

	for _, focusAltar in pairs(altars) do
		if focusAltar:GetTeamNumber() == team then
			return focusAltar
		end
	end

	return false
end

local function CreateProjectileToAltar(killedUnit, killerTeam, nSouls)
	local currentAltar = SearchCurrentAltarForTeam(killerTeam)

	if not currentAltar then return end

	local killedUnitPosition = killedUnit:GetAbsOrigin()
	local altarPosition      = currentAltar:GetAbsOrigin()

	local speedParticle = ((killedUnitPosition-altarPosition):Length2D()) / TIME_FOR_CHARGE_FROM_BOSS_KILL

	local info =
	{
		Target = currentAltar,
		Source = killedUnit,
		Ability = nil,
		EffectName = "particles/units/phantom_assassin/death_mark/phantom_assassin_death_mark.vpcf",
		iMoveSpeed = speedParticle,
		vSourceLoc = killedUnitPosition,
		bDrawsOnMinimap = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
	}

	ProjectileManager:CreateTrackingProjectile(info)

	Timers:CreateTimer(TIME_FOR_CHARGE_FROM_BOSS_KILL, function()
		CustomGameEventManager:Send_ServerToTeam( currentAltar:GetTeam(), "increased_altar_charges", { chargesCount = nSouls } )
		AddChargeToAltar(currentAltar, nSouls)
	end)
end

if not ArtefactsUpgrade then
	ArtefactsUpgrade = class({})
	CustomGameEventManager:RegisterListener( "transform_item_to_artifact", Dynamic_Wrap(ArtefactsUpgrade, "_TransferItemToArt") )
end

function ArtefactsUpgrade:Open(player)
	CustomGameEventManager:Send_ServerToPlayer(player, "open_altar", {})
end

function ArtefactsUpgrade:Close(player)
	CustomGameEventManager:Send_ServerToPlayer(player,"close_altar",{})
end

function ArtefactsUpgrade:AddCharges(fromUnit, toTeam, nCharges)
	CreateProjectileToAltar( fromUnit, toTeam, nCharges )
end

function ArtefactsUpgrade:_TransferItemToArt(data)
	UpgradeItemToArtifactBase(data)
end
