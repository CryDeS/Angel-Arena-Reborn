windwing_small_heal_lua = class({})

--------------------------------------------------------------------------------

function windwing_small_heal_lua:OnSpellStart()
	local heal = self:GetSpecialValueFor( "heal" )
    local target = self:GetCursorTarget()
    target:Heal( heal, self )
    for i = 0, 2 do
        local particle = ParticleManager:CreateParticle( "particles/econ/items/warlock/warlock_staff_hellborn/warlock_rain_of_chaos_hellborn_cast.vpcf", PATTACH_CUSTOMORIGIN, nil )
        ParticleManager:SetParticleControl( particle, 0, target:GetOrigin() )
        ParticleManager:SetParticleControl( particle, 1, target:GetOrigin() )
    end
end

--------------------------------------------------------------------------------
