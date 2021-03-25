function CheckIllusion(keys)
	local caster = keys.caster
	local modifier_name = keys.modifier_name

	if caster:IsIllusion() then
		while caster:HasModifier(modifier_name) do
			caster:RemoveModifierByName(modifier_name)
		end
	end
end