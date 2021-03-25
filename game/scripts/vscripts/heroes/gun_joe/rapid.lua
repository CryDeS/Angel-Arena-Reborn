gun_joe_rapid = gun_joe_rapid or class({})

LinkLuaModifier( "modifier_gun_joe_rapid", 'heroes/gun_joe/modifiers/modifier_gun_joe_rapid', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gun_joe_rapid_cd", 'heroes/gun_joe/modifiers/modifier_gun_joe_rapid_cd', LUA_MODIFIER_MOTION_NONE )

local talent_name = "gun_joe_special_bonus_rapid_cd"

function gun_joe_rapid:GetIntrinsicModifierName()
	return "modifier_gun_joe_rapid"
end

function gun_joe_rapid:GetCooldown( nLevel )
	if not self or self:IsNull() then return 0 end

	local caster = self:GetCaster()

	if not caster or caster:IsNull() then return 0 end

	local cd = self:GetSpecialValueFor("cooldown") + caster:GetTalentSpecialValueFor(talent_name)

	return cd
end
