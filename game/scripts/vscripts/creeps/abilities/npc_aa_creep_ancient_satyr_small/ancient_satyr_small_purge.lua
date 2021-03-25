ancient_satyr_small_purge = class({})

function ancient_satyr_small_purge:OnSpellStart()
    if not IsServer() then return end
    local hTarget = self:GetCursorTarget()
    if hTarget:TriggerSpellAbsorb(self) then
        return
    else
        hTarget:Purge(true, false, false, false, false)
        local part = ParticleManager:CreateParticle("particles/items_fx/diffusal_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
        ParticleManager:SetParticleControlEnt(part, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
        local DeletePart = function()
            ParticleManager:DestroyParticle(part, true)
            ParticleManager:ReleaseParticleIndex(part)
            return nil
        end

        Timers:CreateTimer(0.5, DeletePart)
    end
end