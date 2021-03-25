local not_refreshing_items = {
	"item_black_king_bar" = 1,
}

function Refresh(event)
	local caster = event.caster

	-- refreshing abilities
	for i = 0, caster:GetAbilityCount() - 1 do
		local ability = caster:GetAbilityByIndex( i )
		if ability and ability ~= keys.ability then
			ability:EndCooldown()
		end
	end

	-- refreshing items
end