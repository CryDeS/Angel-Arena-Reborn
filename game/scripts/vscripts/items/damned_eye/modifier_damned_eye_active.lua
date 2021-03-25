modifier_damned_eye_active = class({})

--------------------------------------------------------------------------------
function modifier_damned_eye_active:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_damned_eye_active:RemoveOnDeath()
    return true
end

--------------------------------------------------------------------------------
function modifier_damned_eye_active:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_damned_eye_active:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_damned_eye_active:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------
function modifier_damned_eye_active:GetTexture()
    return "../items/damned_eye_big"
end

--------------------------------------------------------------------------------
function modifier_damned_eye_active:OnCreated(kv)
    if not IsServer() then return end

    local heal_const = self:GetAbility():GetSpecialValueFor("heal_const")
    local heal_per_main_stat = self:GetAbility():GetSpecialValueFor("heal_per_main_stat")
    local time_to_heal = kv.duration
    local caster = self:GetParent()

    self.particleDamnedEye = ParticleManager:CreateParticle("particles/damned_eye/damned_eye.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(self.particleDamnedEye, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

    if not caster:IsRealHero() then
        caster = caster:GetPlayerOwner()
        if not IsValidEntity(caster) then return end
        caster = caster:GetAssignedHero()
    end

    local heal_stat = caster:GetPrimaryStatValue() * heal_per_main_stat
    self.allHeal = heal_stat + heal_const
    caster = self:GetParent()
    Timers:CreateTimer("item_damned_eye" .. tostring(caster:entindex()), {
        useGameTime = true,
        endTime = 0,
        callback = function()
            caster:Heal(self.allHeal / 100, self)
            return time_to_heal / 100
        end
    })
end

--------------------------------------------------------------------------------
function modifier_damned_eye_active:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_damned_eye_active:OnTakeDamage(params)
    if not IsServer() then return end
    local attacker = params.attacker
    local parent = params.unit
    if parent == self:GetParent() then
        if attacker:IsHero() and attacker:GetTeamNumber() ~= parent:GetTeamNumber() then
            params.unit:RemoveModifierByName("modifier_damned_eye_active")
--            local damageTable = {
--                victim = params.unit,
--                attacker = params.attacker,
--                damage = self.allHeal,
--                damage_type = DAMAGE_TYPE_PURE,
--                damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL,
--            }
--            ApplyDamage(damageTable)
        end
    end
end

--------------------------------------------------------------------------------
function modifier_damned_eye_active:OnDestroy()
    if not IsServer() then return end
    ParticleManager:DestroyParticle(self.particleDamnedEye, false)
    Timers:RemoveTimer("item_damned_eye" .. tostring(self:GetParent():entindex()))
end

--------------------------------------------------------------------------------
function modifier_damned_eye_active:GetStatusEffectName()
    return "particles/status_fx/status_effect_blur.vpcf"
end

--------------------------------------------------------------------------------