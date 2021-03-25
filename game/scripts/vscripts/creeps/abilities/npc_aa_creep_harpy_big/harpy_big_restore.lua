harpy_big_restore = class({})

--------------------------------------------------------------------------------

function harpy_big_restore:OnSpellStart()
	self.mana_restore = self:GetSpecialValueFor( "mana_restore" )
    local target = self:GetCursorTarget()
    target:GiveMana( self.mana_restore)
    for i = 0, 2 do
        local particle = ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_butterfly/templar_assassin_trap_explode_beam_butterfly.vpcf", PATTACH_CUSTOMORIGIN, nil )
        ParticleManager:SetParticleControl( particle, 0, target:GetOrigin() )
    end
end

--------------------------------------------------------------------------------
