modifier_axe_counter_helix_recode_lua = class({})

-----------------------------------------------------------------------------
function modifier_axe_counter_helix_recode_lua:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_axe_counter_helix_recode_lua:OnCreated(kv)
	local ability = self:GetAbility()
    self.radius = ability:GetSpecialValueFor("radius")
    self.damage = ability:GetSpecialValueFor("damage")
    self.chance = ability:GetSpecialValueFor("trigger_chance")
	self.dmg_from_attack = ability:GetSpecialValueFor("damage_from_attack")
end

-------------------------------------------------------------------------------
function modifier_axe_counter_helix_recode_lua:OnRefresh(kv)
	local ability = self:GetAbility()
    self.radius = ability:GetSpecialValueFor("radius")
    self.damage = ability:GetSpecialValueFor("damage")
    self.chance = ability:GetSpecialValueFor("trigger_chance")
    self.dmg_from_attack = ability:GetSpecialValueFor("damage_from_attack")
end

-------------------------------------------------------------------------------
function modifier_axe_counter_helix_recode_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
    }
    return funcs
end

function modifier_axe_counter_helix_recode_lua:_TriggerCounterHelix()
	local parent = self:GetParent()
	if not parent or parent:PassivesDisabled() then return end

	local ability = self:GetAbility()
	if not ability:IsCooldownReady() then return end
	
	if not RollPercentage(self.chance) then return end
	
	local damage = self.damage + parent:GetAverageTrueAttackDamage(nil) * self.dmg_from_attack
	local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	
	local particle = ParticleManager:CreateParticle( "particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser.vpcf", PATTACH_CUSTOMORIGIN, parent )
	ParticleManager:SetParticleControl( particle, 0, parent:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( particle )
	
	for _, enemy in pairs(enemies) do
		ApplyDamage({ victim = enemy, attacker = parent, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL })
	end
	
	ability:StartCooldown(ability:GetCooldown(ability:GetLevel() - 1))
end

function modifier_axe_counter_helix_recode_lua:OnAttacked(params)
	local parent = self:GetParent()
	
    if not IsServer() then return end
    if params.target ~= parent then return end
	
	self:_TriggerCounterHelix()
end

-------------------------------------------------------------------------------
function modifier_axe_counter_helix_recode_lua:GetModifierProcAttack_Feedback()
	local parent = self:GetParent()
	
	if not parent:HasModifier("modifier_item_aghanims_shard") then return end
	if not IsServer() then return end
    
	self:_TriggerCounterHelix()
end

-------------------------------------------------------------------------------


