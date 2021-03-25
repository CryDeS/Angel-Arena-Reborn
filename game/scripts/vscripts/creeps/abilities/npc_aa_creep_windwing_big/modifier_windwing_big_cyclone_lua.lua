modifier_windwing_big_cyclone_lua = class({})
--------------------------------------------------------------------------------

function modifier_windwing_big_cyclone_lua:IsDebuff()
    return true
end

--------------------------------------------------------------------------------

function modifier_windwing_big_cyclone_lua:IsPurgable()
    return true
end

--------------------------------------------------------------------------------

function modifier_windwing_big_cyclone_lua:IsPurgeException()
    return true
end

--------------------------------------------------------------------------------

function modifier_windwing_big_cyclone_lua:OnCreated()
    self.target = self:GetParent();
    self.vPointTarget = self.target:GetAbsOrigin()
    self.particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_brewmaster/brewmaster_cyclone.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
    ParticleManager:SetParticleControl( self.particle, 0, self.vPointTarget )
end

--------------------------------------------------------------------------------

function modifier_windwing_big_cyclone_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_VISUAL_Z_DELTA,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_windwing_big_cyclone_lua:CheckState()
    local state = {
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,

    }
    return state
end

--------------------------------------------------------------------------------

function modifier_windwing_big_cyclone_lua:GetVisualZDelta ( params )
    return 250
end

--------------------------------------------------------------------------------

function modifier_windwing_big_cyclone_lua:	GetOverrideAnimation( params )
    return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------
function modifier_windwing_big_cyclone_lua:GetModifierIncomingDamage_Percentage( )
    return -100
end
--------------------------------------------------------------------------------

function modifier_windwing_big_cyclone_lua:OnDestroy(  )
    ParticleManager:DestroyParticle(self.particle, true)
    if IsServer() then
        self.target:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_windwing_big_cyclone_dawn_lua", { duration = 1} )
        FindClearSpaceForUnit(self.target, self.vPointTarget, false)
    end
end

--------------------------------------------------------------------------------