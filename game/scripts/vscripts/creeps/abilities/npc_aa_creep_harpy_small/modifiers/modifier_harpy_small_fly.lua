modifier_harpy_small_fly = class({})

--------------------------------------------------------------------------------
function modifier_harpy_small_fly:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_harpy_small_fly:RemoveOnDeath()
    return true
end

--------------------------------------------------------------------------------
function modifier_harpy_small_fly:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_harpy_small_fly:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_harpy_small_fly:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------

function modifier_harpy_small_fly:CheckState() return 
{
    [MODIFIER_STATE_FLYING] = true,
}
end
