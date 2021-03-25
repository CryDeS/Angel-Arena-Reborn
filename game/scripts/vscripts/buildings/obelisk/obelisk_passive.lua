ability_obelisk_passive = ability_obelisk_passive or class({})
local ability = ability_obelisk_passive

LinkLuaModifier( "modifier_obelisk_passive", 'buildings/obelisk/modifiers/modifier_obelisk_passive', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_obelisk_passive_broken", 'buildings/obelisk/modifiers/modifier_obelisk_passive_broken', LUA_MODIFIER_MOTION_NONE )

------------------------------------------------------------------------------------------------------------------------------

function ability:GetIntrinsicModifierName()
	return "modifier_obelisk_passive"
end

function ability:GetIntrinsicMaterialGroup()
	local parent = self:GetCaster()
	local team_number = self:GetCaster():GetTeamNumber()

	if team_number == DOTA_TEAM_GOODGUYS then
		return "radiant_level1"
	end 

	if team_number == DOTA_TEAM_BADGUYS then
		return "dire_level1"
	end 

	if team_number == DOTA_TEAM_NEUTRALS then
		if parent.initial_team == DOTA_TEAM_GOODGUYS then
			return "radiant_level6"
		end 

		if parent.initial_team == DOTA_TEAM_BADGUYS then
			return "dire_level6"
		end 
	end 
end 

function ability:OnCreated()
	if not IsServer() then return end 

	self:GetCaster():SetMaterialGroup( self:GetIntrinsicMaterialGroup() )
	self.broken = false 
end 

-- Destroyer may be nil if obelisk was repaired!
function ability:OnStateChanged( is_broken, destroyer )
	local parent = self:GetCaster()

	if is_broken then
		parent:SetHealth(1)

		if self.broken ~= is_broken then 
			self.broken = is_broken

			parent.initial_team = self:GetCaster():GetTeamNumber() 
			parent:SetTeam( DOTA_TEAM_NEUTRALS )
			parent:SetMaterialGroup( self:GetIntrinsicMaterialGroup() )
			parent:AddNewModifier(parent, self, "modifier_obelisk_passive_broken", { duration = -1 })
			self:OnBroken( parent.initial_team, destroyer )
		end 
	elseif self.broken then 
		self.broken = is_broken

		parent:SetTeam( parent.initial_team )
		parent:SetHealth( parent:GetMaxHealth() )
		parent:SetMaterialGroup( self:GetIntrinsicMaterialGroup() )
		parent:RemoveModifierByName("modifier_obelisk_passive_broken")

		self:OnRepair( parent.initial_team )
	end 
end 

function ability:OnBroken( obelisk_team_number, destroyer )
	local destroyer_team = destroyer:GetTeamNumber() 

	local parent = self:GetCaster()
	local parent_position = parent:GetAbsOrigin()

	local gold = parent:GetGoldBounty()

	if obelisk_team_number ~= destroyer_team then
		TeamHelper:ApplyForPlayers( destroyer_team, function(playerid)
			PlayerResource:ModifyGold( playerid, gold, true, 0 )
		end)
	end

	-- Sound 
	if obelisk_team_number == DOTA_TEAM_GOODGUYS then
		EmitSoundOnLocationWithCaster(parent_position, "Building_RadiantTower.Destruction", parent)
	else 
		EmitSoundOnLocationWithCaster(parent_position, "Building_DireTower.Destruction", parent)
	end 

	if destroyer then
		Timers:CreateTimer(0.3, function() 
			EmitSoundOnLocationForAllies( parent_position, "General.Coins", destroyer )	
		end )
	end

	local particleDestr = ParticleManager:CreateParticle( "particles/obelisk/obelisk_broken.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControlEnt( particleDestr, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent_position, true)
	ParticleManager:ReleaseParticleIndex( particleDestr )
end

function ability:OnRepair( obelisk_team_number )
	local parent = self:GetCaster()
	local parent_position = parent:GetAbsOrigin()
	local particleRepair = ParticleManager:CreateParticle( "particles/items_fx/aegis_respawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControlEnt( particleRepair, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent_position, true)
	ParticleManager:ReleaseParticleIndex( particleRepair )
end