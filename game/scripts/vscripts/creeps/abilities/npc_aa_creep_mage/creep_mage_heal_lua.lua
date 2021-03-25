creep_mage_heal_lua = class({})

--------------------------------------------------------------------------------

function creep_mage_heal_lua:OnSpellStart()
	local heal = self:GetSpecialValueFor( "heal" )
    local target = self:GetCursorTarget()
    target:Heal( heal, self )
    for i = 0, 2 do
        local particle = ParticleManager:CreateParticle( "particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold_glyph_flare.vpcf", PATTACH_CUSTOMORIGIN, nil )
        ParticleManager:SetParticleControl( particle, 0, target:GetAbsOrigin() )
    end
end

--------------------------------------------------------------------------------
