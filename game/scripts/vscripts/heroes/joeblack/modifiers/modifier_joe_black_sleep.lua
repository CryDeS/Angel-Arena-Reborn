modifier_joe_black_sleep = class({})

function modifier_joe_black_sleep:GetEffectName()
	return "particles/units/heroes/hero_bane/bane_nightmare.vpcf"
end

function modifier_joe_black_sleep:IsDebuff( ... )
	return true
end

function modifier_joe_black_sleep:IsStunDebuff( ... )
	return false
end

function modifier_joe_black_sleep:OnCreated( ... )
	if not IsServer() then return end
	self.control_mod =self:GetCaster():FindModifierByName("modifier_joe_black_sleep_self") 
	self.table = self.control_mod.target_table
	local parent = self:GetParent()
	self.table[tostring(parent:entindex())] = parent

	parent:EmitSound("Hero_Bane.Nightmare")
	parent:EmitSound("Hero_Bane.Nightmare.Loop")
end

function modifier_joe_black_sleep:OnDestroy( ... )
	if not IsServer() then return end
	local parent = self:GetParent()
	self.table[tostring(parent:entindex())] = nil
	self.control_mod:SleepFinished(parent)
	parent.sleep_time = nil
	parent:StopSound("Hero_Bane.Nightmare.Loop")
	parent:EmitSound("Hero_Bane.Nightmare.End")
end

function modifier_joe_black_sleep:CheckState()
	local state = {
		[MODIFIER_STATE_BLIND]      		 = true,
		[MODIFIER_STATE_NIGHTMARED] 		 = true,
		[MODIFIER_STATE_STUNNED]    		 = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
	}

	return state
end

function modifier_joe_black_sleep:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_EVENT_ON_ATTACKED,
	}
	return funcs
end

function modifier_joe_black_sleep:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_joe_black_sleep:GetOverrideAnimationRate()
	return 0.2
end

function modifier_joe_black_sleep:OnAttacked( params )
	if self:GetParent() ~= params.target then
		return
	end

	self:Destroy()

	return 0
end