windwing_small_blink_lua = class({})

--------------------------------------------------------------------------------

function windwing_small_blink_lua:OnSpellStart()

    local caster = self:GetCaster()
    local vPoint = self:GetCursorPosition()
    local vStart = caster:GetAbsOrigin()
    local nMaxBlink = self:GetSpecialValueFor( "blink_range" )
    ProjectileManager:ProjectileDodge(caster) --уклоняться от говна



    local vDiff = vPoint - vStart
    local nDiff = vDiff:Length2D()

    if nDiff > nMaxBlink then
          vPoint = vStart + vDiff:Normalized() * nMaxBlink
    end

    function create_particle(vPosition)
        local particle = ParticleManager:CreateParticle( "particles/econ/items/gyrocopter/hero_gyrocopter_atomic/gyro_rocket_barrage_atomic.vpcf", PATTACH_CUSTOMORIGIN, caster )
        ParticleManager:SetParticleControl( particle, 0, self:GetCaster():GetOrigin() )
        ParticleManager:SetParticleControl( particle, 1, vPosition )
    end

    for i = 0, 3 do
        create_particle(vPoint)
    end

    FindClearSpaceForUnit(caster, vPoint, false) --не влазить в говно

    for i = 0, 3 do
        create_particle(vStart)
    end
end

--------------------------------------------------------------------------------