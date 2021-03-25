modifier_windwing_big_cyclone_dawn_lua = class({})
--------------------------------------------------------------------------------

function modifier_windwing_big_cyclone_dawn_lua:IsDebuff()
    return false
end

function modifier_windwing_big_cyclone_dawn_lua:IsHidden()
    return true
end
--------------------------------------------------------------------------------

function modifier_windwing_big_cyclone_dawn_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_VISUAL_Z_DELTA,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_windwing_big_cyclone_dawn_lua:GetVisualZDelta ( params )
    return 0
end

--------------------------------------------------------------------------------
