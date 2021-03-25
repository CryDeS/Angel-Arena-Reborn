function OnAegisPickup( keys )
	local caster = keys.caster
	local ability = keys.ability 
	print("OnAegisPickup start")

	if not caster:IsRealHero() then
		local drop = CreateItem("item_aegis_aa", nil, nil)
		UTIL_Remove(ability)
		CreateItemOnPositionSync(caster:GetAbsOrigin(), drop)
		drop:LaunchLoot(false, 250, 0.5, caster:GetAbsOrigin() + RandomVector(100))

		return
	end

	if caster:HasModifier("modifier_aegis_tooltip") then 
		UTIL_Remove(ability)
		return 
	end

	local really_aegis = CreateItem("item_aegis", hero, hero)

	caster:AddNewModifier(hero, really_aegis, "modifier_item_aegis", {}) 			
	
	UTIL_Remove(really_aegis)	

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_aegis_tooltip", {}) 
	print("OnAegisPickup end")
	UTIL_Remove(ability)

end

function OnAegisEnd( keys )
	local caster = keys.caster 

	if caster:IsAlive() then
		print("Delete aegis")
		while(caster:HasModifier("modifier_item_aegis")) do
			caster:RemoveModifierByName("modifier_item_aegis") 
		end
	end
end