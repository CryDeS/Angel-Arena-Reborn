modifier_soul_merchant_active_buff_enemy = class({})
--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_enemy:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_enemy:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_enemy:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_enemy:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_enemy:RemoveOnDeath()
    return true
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_enemy:GetTexture()
    return "../items/soul_merchant_big"
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_enemy:OnCreated(kv)
    local caster = self:GetAbility():GetCaster()
    
    self.reduce_total_heal_pct = self:GetAbility():GetSpecialValueFor("reduce_total_heal_pct")
    self.destroy_bind_range = self:GetAbility():GetSpecialValueFor("destroy_bind_range") + caster:GetCastRangeBonus()
    self.slow_percent = self:GetAbility():GetSpecialValueFor("slow_percent")

    if IsServer() then
        self.health = self:GetParent():GetHealth()
    end

    
    local parent = self:GetParent()

    self.particleSoulBind = ParticleManager:CreateParticle("particles/soul_merchant/soul_merchant_bind.vpcf", PATTACH_POINT_FOLLOW, caster)

    ParticleManager:SetParticleControlEnt(self.particleSoulBind, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
    ParticleManager:SetParticleControlEnt(self.particleSoulBind, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), false)
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_enemy:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_EVENT_ON_UNIT_MOVED,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_enemy:GetModifierHPRegenAmplify_Percentage(kv)
    return -self.reduce_total_heal_pct
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_enemy:GetModifierHealAmplify_PercentageTarget(kv)
	return -self.reduce_total_heal_pct
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_enemy:GetModifierMoveSpeedBonus_Percentage(kv) return -self.slow_percent; end
--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_enemy:DestroyBinds()
    local ability = self:GetAbility()
    local caster = ability:GetCaster()
    if caster:HasModifier("modifier_soul_merchant_active_buff_friendly") then
        caster:RemoveModifierByName("modifier_soul_merchant_active_buff_friendly")
    end
    self:Destroy()
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_enemy:OnUnitMoved(params)
    if not IsServer() then return end
    local ability = self:GetAbility()
    local parent = self:GetParent()
    local caster = ability:GetCaster()

    if (params.unit == parent) or (params.unit == caster) then
        if ((caster:GetOrigin() - parent:GetOrigin()):Length2D()) >= self.destroy_bind_range then
            self:DestroyBinds()
        end
    end
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_enemy:OnDestroy()
    ParticleManager:DestroyParticle(self.particleSoulBind, false)
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_enemy:CheckState()
    local state = {
        [MODIFIER_STATE_MUTED] = true,
    }
    return state
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_enemy:OnTakeDamage(params)
    local parent = self:GetParent()

    if not params.unit == parent then return end

    self.health = self.health - params.damage
end

----------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_enemy:OnDeath(params)
    local caster = self:GetAbility():GetCaster()
    if params.unit == caster then
        self:DestroyBinds()
    end
end

----------------------------------------------------------------------------------
