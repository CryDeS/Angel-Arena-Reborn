function KingsBar_purge(keys)
	local ability = keys.ability
	local caster = keys.caster
	
	caster:Purge( false, true, false, false, false )

	caster:EmitSound("DOTA_Item.BlackKingBar.Activate")
end