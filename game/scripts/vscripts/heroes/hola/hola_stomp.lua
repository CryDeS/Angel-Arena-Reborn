hola_stomp = class({})

local talent_name = "hola_special_bonus_heal"

function hola_stomp:IsHiddenWhenStolen() 		return false end

function hola_stomp:OnSpellStart( ... )
	if not IsServer() then return end

	local caster = self:GetCaster()
	local caster_origin = caster:GetOrigin()
	caster:EmitSound("Hero_EarthShaker.EchoSlam")

	local radius 		= self:GetSpecialValueFor("radius")
	local heal 			= self:GetSpecialValueFor("heal")
	local damage 		= self:GetSpecialValueFor("damage")
	local heal_percent 	= self:GetSpecialValueFor("heal_percent") / 100

	local part = ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl( part, 0, caster_origin )
	ParticleManager:SetParticleControl( part, 1, Vector( radius, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( part )

	local part = ParticleManager:CreateParticle("particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start_c.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl( part, 0, caster_origin )
	ParticleManager:SetParticleControl( part, 1, Vector( radius, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( part )

	local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	for _,ally in pairs(allies) do
		local hola_int = caster:GetIntellect()
		ally:Heal(hola_int*heal_percent, caster)
		SendOverheadEventMessage(caster, OVERHEAD_ALERT_HEAL, caster, hola_int*heal_percent, nil)
	end

	local damage_info = {
		victim = nil,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self
	}

	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	
	for _,enemy in pairs(enemies) do
		
		if not enemy:IsMagicImmune() and not enemy:IsInvulnerable() then
			damage_info.victim = enemy
			ApplyDamage(damage_info)

			if caster:HasAbility(talent_name) and caster:FindAbilityByName(talent_name):GetLevel() ~= 0 then
				local heal_from_damage = damage * (100 - enemy:GetMagicalArmorValue())/100
				caster:Heal(heal_from_damage, self)
				SendOverheadEventMessage(caster, OVERHEAD_ALERT_HEAL, caster, heal_from_damage, nil)
			end
		end
	end

end