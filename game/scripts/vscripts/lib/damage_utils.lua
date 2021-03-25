--[[
	Arguments comment:
	 -victim 			// unit that take damage 
	 -attacker 			// unit that deal damage
	 -damage_type 		// damage type(DAMAGE_TYPE_PHYSICAL / DAMAGE_TYPE_MAGICAL / DAMAGE_TYPE_PURE)
	 -damage_const 		// constant damage(number)
	 -damage_pct 		// percent damage(number, percent)
	 -spell_amp 		// bool, is spell amplify can work for it?


	Functions:
	 DealPercentDamage( victim, attacker, damage_type, damage_const, damage_pct )
	 DealPercentDamageOfMaxHealth( victim, attacker, damage_type, damage_const, damage_pct )
	 DealDamageFromStats( victim, attacker, damage_type, str_damage, agi_damage, int_damage, spell_amp )
	 EmitSoundOnClient( playerid, sound_name )
	 HealUnitOfMaxHealth( target, caster, heal_const, heal_pct )
	 HealUnitOfCurrentHealth( target, caster, heal_const, heal_pct )
	 PrintName( { text = "hello", unit = hUnit} ) 							// print("hello", hUnit:GetUnitName())
	 PrintKeys( table ) 													// print keys fo table
	 EmitSoundOnClient( playerid, sound_name )								// emit sound to client by name
	 DisableSpellAmp( caster, damage )										// Decrease damage that affected by spell amplify (NOT REALLY DISABLE SPELL AMP!)
]]

Util = Util or class({})

------------------------------------- Safe functions --------------------------------------
	
function Util:HealUnitOfMaxHealth(target, caster, heal_const, heal_pct)
	Util:_HealUnit(target, caster, heal_const, heal_pct, true)
end

function Util:HealUnitOfCurrentHealth(target, caster, heal_const, heal_pct)
	Util:_HealUnit(target, caster, heal_const, heal_pct, false)
end

function Util:DealPercentDamage(victim, attacker, damage_type, damage_const, damage_pct)
	return Util:_DealDamage(victim, attacker, damage_type, damage_const, damage_pct, false)
end

function Util:DealPercentDamageOfMaxHealth(victim, attacker, damage_type, damage_const, damage_pct)
	return Util:_DealDamage(victim, attacker, damage_type, damage_const, damage_pct, true)
end

function Util:PrintName( keys )
	local string 	= keys.text
	local unit 		= keys.unit 

	if not unit or not IsValidEntity(unit) then return end

	print(string, unit:GetUnitName() )
end

function Util:PrintKeys( keys )
	if not keys or type(keys) ~= "table" then print("[UTIL] PrintKeys, expected table, got " .. type(keys) ); return; end

	for key, value in pairs(keys) do print(key, value) end
end

function Util:EmitSoundOnClient(playerid, sound_name)
	local player = PlayerResource:GetPlayer(playerid)

	if not player then return end

  	if player then
	    CustomGameEventManager:Send_ServerToPlayer(player, "cont_emit_client_sound", { sound = sound_name })
  	end
end

function Util:DisableSpellAmp(caster, damage)
	return damage
end

function Util:GetReallyCooldown(caster, ability)
	local multipler = 1
	
	if caster:HasItemInInventory("item_octarine_core_2") or caster:HasItemInInventory("item_octarine_core") then
		multipler = 0.75
	end

	return ability:GetCooldown(ability:GetLevel() - 1) * multipler
end

------------------------------------- Unsafe functions -------------------------------------
function Util:DealDamageFromStats(victim, attacker, damage_type, str_damage, agi_damage, int_damage, spell_amp)
	if not victim or not IsValidEntity(victim) then 
		print("[UTIL] DealDamageFromStats error, <victim> is invalid")
		return
	end

	if not attacker or not IsValidEntity(victim) then 
		print("[UTIL] DealDamageFromStats error, <attacker> is invalid")
		return
	end

	if damage_type ~= DAMAGE_TYPE_PHYSICAL and damage_type ~= DAMAGE_TYPE_MAGICAL and damage_type ~= DAMAGE_TYPE_PURE then
		print("[UTIL] DealDamageFromStats error, <damage_type> is invalid")
		return 
	end

	str_damage = str_damage or 0
	agi_damage = agi_damage or 0
	int_damage = int_damage or 0

	damage = attacker:GetStrength()*str_damage + attacker:GetAgility()*agi_damage + attacker:GetIntellect()*int_damage

	if (not spell_amp) then
		damage = Util:DisableSpellAmp(attacker, damage)
	end


	print("[UTIL] DealDamageFromStats deal " .. damage .. " damage")
	local damage_table = {
		victim 		= victim,
		attacker 	= attacker,
		damage 		= damage,
		damage_type = damage_type,
	}
	
	ApplyDamage(damage_table)

end

function Util:_DealDamage(victim, attacker, damage_type, damage_const, damage_pct, from_max_health)
	if not victim or not IsValidEntity(victim) then 
		print("[UTIL] _DealDamage error, <victim> is invalid")
		return
	end

	if not attacker or not IsValidEntity(victim) then 
		print("[UTIL] _DealDamage error, <attacker> is invalid")
		return
	end

	if damage_type ~= DAMAGE_TYPE_PHYSICAL and damage_type ~= DAMAGE_TYPE_MAGICAL and damage_type ~= DAMAGE_TYPE_PURE then
		print("[UTIL] _DealDamage error, <damage_type> is invalid")
		return 
	end

	if not damage_const then
		print("[UTIL] _DealDamage warning, <damage_const> is nil, setting to 0")
		damage_const = 0
	end

	if not damage_pct then
		print("[UTIL] _DealDamage warning, <damage_pct> is nil, setting to 0")
		damage_pct = 0
	end

	---------------------------------------------------------------------------------------------------
	-------------------------------------// Start Apply Damage \\ -------------------------------------
	---------------------------------------------------------------------------------------------------
	local damage = 0

	if from_max_health then
		damage = ( victim:GetMaxHealth() * damage_pct / 100 )
	else
		damage = ( victim:GetHealth() * damage_pct / 100 )
	end
	local damage_before_spellamp = damage + damage_const

	damage = (damage + damage_const)

	local damage_table = {
		victim 		= victim,
		attacker 	= attacker,
		damage 		= damage,
		damage_type = damage_type,
	}
	ApplyDamage(damage_table)

	return damage_before_spellamp
end

function Util:_HealUnit(target, caster, heal_const, heal_pct, from_max_health)
	if not target or not IsValidEntity(target) then
		print("[UTIL] _HealUnit error, <target> is not valid entity")
		return
	end

	if not caster or not IsValidEntity(caster) then
		print("[UTIL] _HealUnit warning, <caster> is not valid entity")
	end

	if not heal_const then
		print("[UTIL] _HealUnit warning, <heal_const> is nil, setting to 0")
		heal_const = 0
	end

	if not heal_pct then
		print("[UTIL] _HealUnit warning, <heal_pct> is nil, setting to 0")
		heal_pct = 0
	end


	local heal = 0

	if from_max_health then
		heal = heal_const + target:GetMaxHealth() * heal_pct / 100
	else
		heal = heal_const + target:GetHealth() * heal_pct / 100
	end

	print("[UTIL] _HealUnit heal pct = ", heal_pct, "heal = ", heal_const, "total heal = ", heal)
	target:Heal(heal, caster)
end

function _GetNearestUnitUnderPoint(point, radius)
    local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE

    local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, point, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, flags, 0, false)

    if not units or #units < 0 then return nil end

    local res_unit = nil
    local res_len = nil

    for _, unit in pairs(units) do
        local ln = 999999

        if unit and unit.GetAbsOrigin then
            ln = (unit:GetAbsOrigin() - point):Length()
        end

        if not res_len or ln < res_len then
            res_unit = unit
            res_len = ln
        end
    end

    return res_unit
end
