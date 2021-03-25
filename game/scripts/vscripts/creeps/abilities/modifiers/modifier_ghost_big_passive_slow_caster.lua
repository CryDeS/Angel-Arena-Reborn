modifier_ghost_big_passive_slow_caster = class({})

--------------------------------------------------------------------------------

function modifier_ghost_big_passive_slow_caster:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_big_passive_slow_caster:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_big_passive_slow_caster:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_big_passive_slow_caster:OnAttackLanded(kv)
	if IsServer() then 
	    if self:GetParent() ~= kv.attacker then return end 

		if RollPercentage(self:GetAbility():GetSpecialValueFor("chance")) then 
			local ability = self:GetAbility()
			kv.target:AddNewModifier(self:GetParent(), ability, "modifier_ghost_big_passive_slow", 
			{
				movespeed = ability:GetSpecialValueFor("bonus_movespeed"),
				attackspeed = ability:GetSpecialValueFor("bonus_attackspeed"),
				duration = ability:GetSpecialValueFor("duration")
			})
		end 
	end 
end 

--------------------------------------------------------------------------------

function modifier_ghost_big_passive_slow_caster:DeclareFunctions()
	return { MODIFIER_EVENT_ON_ATTACK_LANDED }
end
