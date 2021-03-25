require('lib/client_talent_support')

if IsServer() then 
	function CDOTA_BaseNPC:HasTalent(talent_name)
	    if self:HasAbility(talent_name) and self:FindAbilityByName(talent_name):GetLevel() ~= 0 then 
	    	return true 
	    end

	    return false
	end

	function CDOTA_BaseNPC:GetTalentSpecialValueFor(talent_name, value_name)
		if not value_name then
			value_name = "value"
		end

	    if self:HasAbility(talent_name) and self:FindAbilityByName(talent_name):GetLevel() ~= 0 then 
	    	return self:FindAbilityByName(talent_name):GetSpecialValueFor(value_name)
	    end

	    return 0
	end

	function CDOTA_BaseNPC:RemoveAllModifiersByName(modifier_name)
		while self:HasModifier(modifier_name) do
			self:RemoveModifierByName(modifier_name)
		end
	end
end