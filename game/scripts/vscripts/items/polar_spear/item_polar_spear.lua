item_polar_spear = item_polar_spear or class({}) 
LinkLuaModifier( "modifier_polar_spear", 'items/polar_spear/modifiers/modifier_polar_spear', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_polar_spear_active", 'items/polar_spear/modifiers/modifier_polar_spear_active', LUA_MODIFIER_MOTION_HORIZONTAL )
--------------------------------------------------------------------------------

function IsLoneDruidBear(hTarget)
	if hTarget:GetUnitName() == "npc_dota_lone_druid_bear1" then return true end 
	if hTarget:GetUnitName() == "npc_dota_lone_druid_bear2" then return true end 
	if hTarget:GetUnitName() == "npc_dota_lone_druid_bear3" then return true end 
	if hTarget:GetUnitName() == "npc_dota_lone_druid_bear4" then return true end 

	return false;
end 

function item_polar_spear:GetIntrinsicModifierName()
	return "modifier_polar_spear"
end

function item_polar_spear:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	if not hTarget:IsCreep() and not hTarget:IsHero() and not IsLoneDruidBear(hTarget) then
		return UF_FAIL_CUSTOM
	end

	if hTarget:GetTeamNumber()~=self:GetCaster():GetTeamNumber() and hTarget:IsMagicImmune() then
		return UF_FAIL_CUSTOM
	end

	return UF_SUCCESS
end

function item_polar_spear:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end

	if not hTarget:IsCreep() and not hTarget:IsHero() and not IsLoneDruidBear(hTarget) then
		return "#dota_hud_error_cast_only_hero_and_creeps"
	end

	if hTarget:GetTeamNumber()~=self:GetCaster():GetTeamNumber() and hTarget:IsMagicImmune() then
		return "#dota_hud_error_target_magic_immune"
	end

	return ""
end

function item_polar_spear:OnSpellStart()
	local caster 			= self:GetCaster() 
	local original_target	= self:GetCursorTarget()
	
	if caster:GetTeamNumber() ~= original_target:GetTeamNumber() then
		if original_target:TriggerSpellAbsorb(self) or original_target:TriggerSpellReflect(self) then return end
	else 
		if PlayerResource:IsDisableHelpSetForPlayerID(caster:GetPlayerOwnerID(), original_target:GetPlayerOwnerID() ) then
			return 
		end
	end

	original_target:AddNewModifier(caster, self, "modifier_polar_spear_active", { speed = 40 })
end
