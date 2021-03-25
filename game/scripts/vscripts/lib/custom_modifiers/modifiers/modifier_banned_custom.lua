modifier_banned_custom = class({})

--------------------------------------------------------------------------------
function modifier_banned_custom:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_banned_custom:OnCreated(event)
    if not IsServer() then return end
    local color = Vector(RandomInt(0,255), RandomInt(0,255), RandomInt(0,255))
    local x_step = 2
    local y_step = 3
    local z_step = 4
    local parent = self:GetParent()
    Timers:CreateTimer("colorbanned"..self:GetParent():GetEntityIndex() , {
        endTime = 0,
        callback = function()
            if color.x < 5 or color.x > 250 then
                x_step = -x_step
            end
            if color.y < 5 or color.y > 250 then
                y_step = -y_step
            end
            if color.z < 5 or color.z > 250 then
                z_step = -z_step
            end
            color = Vector(color.x + x_step, color.y + y_step, color.z + z_step)
            parent:SetRenderColor(color.x, color.y, color.z)
            return 0.01
        end
    })
end
--------------------------------------------------------------------------------
function modifier_banned_custom:OnDestroy()
    if not IsServer() then return end
    self:GetParent():SetRenderColor(255, 255, 255)
    Timers:RemoveTimer("colorbanned"..self:GetParent():GetEntityIndex())
end
--------------------------------------------------------------------------------
function modifier_banned_custom:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_banned_custom:GetTexture()
    return "shadow_shaman_voodoo"
end

--------------------------------------------------------------------------------
function modifier_banned_custom:GetEffectName()
    --return "particles/units/heroes/hero_lone_druid/lone_druid_bear_entangle_body.vpcf"
end

--------------------------------------------------------------------------------
function modifier_banned_custom:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_BLIND] = true,
    }
    return state
end
--------------------------------------------------------------------------------
function modifier_banned_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MODEL_SCALE,
    }
    return funcs
end
--------------------------------------------------------------------------------

function modifier_banned_custom:GetModifierModelChange()
    return "models/props_gameplay/rat_balloon.vmdl"
end

function modifier_banned_custom:GetModifierModelScale()
    return 90
end