modifier_gun_joe_rapid = modifier_gun_joe_rapid or class({})
local mod = modifier_gun_joe_rapid

function mod:IsHidden() return true end
function mod:IsPurgable() return false end
function mod:DestroyOnExpire() return false end

function mod:_OnCreated( kv )
	local ability = self:GetAbility()

	if not ability or ability:IsNull() then return end

	self.cooldown 			= ability:GetSpecialValueFor( "cooldown" )
	self.bonus_attackspeed 	= ability:GetSpecialValueFor( "bonus_attackspeed" )
	self.bonus_movespeed 	= ability:GetSpecialValueFor( "bonus_movespeed" )
end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	if IsServer() then
		ability:EndCooldown() 
	end

	self:_OnCreated()

end

mod.OnRefresh = mod._OnCreated

function mod:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function mod:GetModifierMoveSpeedBonus_Constant( params )
	if not self or self:IsNull() then return 0 end

	local parent = self:GetParent()

	if not parent or parent:IsNull() then return 0 end

	if parent:HasModifier("mod_cd") then return 0 end

	if parent:PassivesDisabled() then return 0 end

	return self.bonus_movespeed
end

function mod:GetModifierAttackSpeedBonus_Constant( params )
	if not self or self:IsNull() then return 0 end

	local parent = self:GetParent()

	if not parent or parent:IsNull() then return 0 end

	if parent:HasModifier("mod_cd") then return 0 end

	if parent:PassivesDisabled() then return 0 end
	
	return self.bonus_attackspeed
end


function mod:OnTakeDamage( params )
	if not IsServer() then return end

	if not self or self:IsNull() then return end

	local parent = self:GetParent()

	if not parent or parent:IsNull() then return end

    if params.unit ~= parent then return end

    local attacker = params.attacker

    if not attacker or attacker:IsNull() then return end

    if not attacker:IsHero() then return end 

    local ability = self:GetAbility()

    if not ability or ability:IsNull() then return end

	self.cooldown = ability:GetSpecialValueFor("cooldown") + parent:GetTalentSpecialValueFor("gun_joe_special_bonus_rapid_cd") 

    ability:StartCooldown(self.cooldown)

	parent:AddNewModifier(parent, nil, "mod_cd", { duration = self.cooldown } )

	return 0
end