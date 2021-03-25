modifier_soul_merchant_active_buff_friendly = class({})
--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_friendly:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_friendly:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_friendly:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_friendly:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_friendly:RemoveOnDeath()
    return true
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_active_buff_friendly:GetTexture()
    return "../items/soul_merchant_big"
end
--------------------------------------------------------------------------------