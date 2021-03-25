base_amulet_class = class({})

LinkLuaModifier("modifier_static_amulet", "items/static_amulets/modifier_static_amulet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slice_amulet", "items/static_amulets/modifier_static_amulet", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_static_mag_amplify_count", "items/static_amulets/modifier_static_mag_amplify_count", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_static_mag_amplify", "items/static_amulets/modifier_static_mag_amplify", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_static_disarm", "items/static_amulets/modifier_static_disarm", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function _projectileHit(self, target, location)
    if not target then return end 
    if target:IsMagicImmune() then return end
    
    if target:TriggerSpellAbsorb(self) or target:TriggerSpellReflect(self) then return end
    

    target:AddNewModifier(self:GetCaster(), self, "modifier_static_disarm", { duration=self:GetSpecialValueFor("debuff_duration") })

    EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "DOTA_Item.HeavensHalberd.Activate", self:GetCaster())
end 

function _startSpell(self)
    local caster   = self:GetCaster() 
    local target   = self:GetCursorTarget()

    local info = {
        Target = target,
        Source = caster,
        Ability = self,
        EffectName = "particles/items2_fx/skadi_projectile.vpcf",
        bDodgeable = false,
        bProvidesVision = true,
        iMoveSpeed = self:GetSpecialValueFor("debuff_speed"),
        iVisionRadius = 150,
        bVisibleToEnemies = true,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
    }

    ProjectileManager:CreateTrackingProjectile( info )

    EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "sounds/weapons/hero/winter_wyvern/arctic_burn.vsnd", self:GetCaster())
end 

function base_amulet_class:OnProjectileHit(hTarget, vLocation)
    _projectileHit(self, hTarget, vLocation)
end 

function base_amulet_class:OnSpellStart()
    _startSpell(self)
end


item_slice_amulet = class(base_amulet_class)
item_static_amulet = class(base_amulet_class)

function item_slice_amulet:GetIntrinsicModifierName() return "modifier_slice_amulet" end
function item_static_amulet:GetIntrinsicModifierName() return "modifier_static_amulet" end
