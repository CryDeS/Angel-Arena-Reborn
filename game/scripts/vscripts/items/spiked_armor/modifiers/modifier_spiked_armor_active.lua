modifier_spiked_armor_active = class({})
--------------------------------------------------------------------------------

function modifier_spiked_armor_active:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_active:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_active:DestroyOnExpire()
	return true
end


function modifier_spiked_armor_active:GetEffectName()
    return "particles/items_fx/blademail_b.vpcf"
end

function modifier_spiked_armor_active:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_active:OnCreated( kv )
    self.return_damage = (self:GetAbility():GetSpecialValueFor("return_damage") or 0) / 100
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_active:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------


function modifier_spiked_armor_active:OnTakeDamage( params )
	if IsServer() then
        if params.unit ~= self:GetParent() or params.unit == params.attacker then
        	return
        end

        if testflag(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) then return end 

        print("Returning ", params.damage * self.return_damage, "pct", self.return_damage)

        ApplyDamage({
            victim = params.attacker,
            attacker = params.unit,
            damage = params.damage * self.return_damage,
            damage_type = params.damage_type,
            ability = self:GetAbility(),
            damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
        })

	end
	return 0
end

function testflag(set, flag)
  return set % (2*flag) >= flag
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------