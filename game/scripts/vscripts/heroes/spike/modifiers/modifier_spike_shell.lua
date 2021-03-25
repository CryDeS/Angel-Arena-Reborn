modifier_spike_shell = class({})
--------------------------------------------------------------------------------

function modifier_spike_shell:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_spike_shell:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_spike_shell:DestroyOnExpire()
	return false
end

function modifier_spike_shell:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	self.returnDamage = ability:GetSpecialValueFor("return_damage") / 100
end

modifier_spike_shell.OnRefresh = modifier_spike_shell.OnCreated

function modifier_spike_shell:GetAttributes() 
    return MODIFIER_ATTRIBUTE_PERMANENT
end

if IsServer() then
	function modifier_spike_shell:DeclareFunctions()
		local funcs = {
			MODIFIER_EVENT_ON_TAKEDAMAGE,
		}

		return funcs
	end

	function modifier_spike_shell:OnTakeDamage( params )
		local parent = self:GetParent()

	    if params.unit ~= parent then return end

	    if not parent or parent:IsNull() then return end

	    if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= 0 then return end 

	    local ability = self:GetAbility()

	    if not ability or ability:IsNull() then return end

	    if parent:PassivesDisabled() then return end 

	    local takeDamage = params.damage
	    
	    local resultDamage = takeDamage * ( self.returnDamage + parent:GetTalentSpecialValueFor( "spike_special_bonus_shell_25") / 100 )

	    if resultDamage == 0 then return end

        if params.attacker:IsInvulnerable() then return end

        if parent:HasTalent("spike_special_bonus_shell_block") then
            if parent:GetHealth() > takeDamage - resultDamage then
                parent:Heal(resultDamage, ability)
            end
        end

        ApplyDamage({
            victim 		 = params.attacker,
            attacker 	 = parent,
            damage 		 = resultDamage,
            damage_type  = DAMAGE_TYPE_PURE,
            ability 	 = self:GetAbility(),
            damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
        })
	end

	function testflag(set, flag)
	  return set % (2*flag) >= flag
	end
end