AIHelpers = AIHelpers or class({})

function AIHelpers:CanBeSeen(unit, target)
	return unit:CanEntityBeSeenByMyTeam(target) and not target:IsInvisible() and not target:IsInvulnerable()
end

function AIHelpers:GetEnemiesNear(caster, pos, teamNumber, radius)
	local enemies = FindUnitsInRadius( 	teamNumber,
										pos,
										nil,
										radius,
										DOTA_UNIT_TARGET_TEAM_ENEMY,
										DOTA_UNIT_TARGET_ALL,
										DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
										FIND_CLOSEST,
										false )

	local res = {}

	for _, x in pairs(enemies) do
		if x and self:CanBeSeen(caster, x) and not x:IsCourier() then
			table.insert(res, x)
		end
	end

	return res
end

function AIHelpers:CastRangeFilter(data, basePos, castRange, functor)
	for _, unit in pairs(data) do
		if (unit:GetAbsOrigin() - basePos):Length() < castRange then
			if functor( unit ) then
				return true
			end
		end
	end

	return false
end

function AIHelpers:IsCastable( ability, unit )
	if not unit or not ability then return false end

	local function CheckBit( funcName, bitValue )
		local func = unit[funcName]
		if func( unit ) then
			return bitValue
		else
			return 0
		end
	end

	local bitsTable = {
		{ "IsHero", DOTA_UNIT_TARGET_HERO },
		{ "IsCreep", DOTA_UNIT_TARGET_CREEP },
		{ "IsBuilding", DOTA_UNIT_TARGET_BUILDING },
		{ "IsCourier", DOTA_UNIT_TARGET_COURIER },
		{ "IsOther", DOTA_UNIT_TARGET_OTHER },
	}

	local unitTypeBits = 0

	for _, subtable in pairs(bitsTable) do
		unitTypeBits = unitTypeBits + CheckBit(subtable[1], subtable[2])
	end

	local bCastable = bit.band(unitTypeBits, ability:GetAbilityTargetType()) ~= 0
	return bCastable
end