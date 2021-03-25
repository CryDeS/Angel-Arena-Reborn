gun_joe_explosive = gun_joe_explosive or class({})
ability = gun_joe_explosive

LinkLuaModifier( "modifier_gun_joe_explosive", 'heroes/gun_joe/modifiers/modifier_gun_joe_explosive', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function ability:OnSpellStart( keys )
	if not self or self:IsNull() then return end

	local caster = self:GetCaster()

	if not caster or caster:IsNull() then return end

	caster:AddNewModifier(caster, self, "modifier_gun_joe_explosive", { duration = self:GetSpecialValueFor("duration") } ) 

	local stack_count = self:GetSpecialValueFor("stack_count") + caster:GetTalentSpecialValueFor("gun_joe_special_bonus_explosive_bullets_stack")

	caster:SetModifierStackCount("modifier_gun_joe_explosive", caster, stack_count )
end

function ability:GetCooldown( nLevel )
	if not self or self:IsNull() then return 0 end
	
	local caster = self:GetCaster()

	if not caster or caster:IsNull() then return 0 end

	return self:GetSpecialValueFor("cooldown") + caster:GetTalentSpecialValueFor("gun_joe_special_bonus_explosive_bullets_cd")
end
