Resistances = Resistances or class({})

function Resistances:GetArmorDecrease( target )
	local armor_value = target:GetPhysicalArmorValue( false )

	return (0.06 * armor_value ) / ( 1+ 0.06 * math.abs(armor_value) )
end
