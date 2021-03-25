CommonAbilities = CommonAbilities or class({})

function CommonAbilities:ConstructModifier(classData, ...)
	local nBaseClasses = select("#", ...)

	classData = classData or {}

	if nBaseClasses == 0 then return classData end

	for i = 1, nBaseClasses do
		local addiditionalClass = select(i, ...)

		for key, value in pairs( addiditionalClass ) do
			classData[key] = value
		end
	end

	return classData
end

function CommonAbilities:Inherit( me, base )
	me = me or {}

	for key, value in pairs(base) do
		me[key] = value
	end

	return me
end

function CommonAbilities:DeductTexture( ability )
	if not ability then return end

	local prefix = ""

	local abilityName = ""

	abilityName = ability:GetName()

	if ability:IsItem() then
		abilityName = abilityName:gsub("item_", "")
		prefix = "../items/"
	else
		prefix = "custom/" -- TODO: Remove abilities from custom folder
	end

	return prefix .. abilityName
end