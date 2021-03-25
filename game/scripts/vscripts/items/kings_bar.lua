function KingsBar_purge(keys)
	local ability = keys.ability
	local caster = keys.caster
	
	caster:Purge( false, true, false, true, true )
	caster:RemoveModifierByName("modifier_slark_pounce_leash")

	caster:EmitSound("DOTA_Item.BlackKingBar.Activate")
end