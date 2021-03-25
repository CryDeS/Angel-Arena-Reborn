if item_rubick_dagon == nil then
    item_rubick_dagon = class({})
end

LinkLuaModifier( "modifier_rubick_dagon_passive", 'items/rubick_dagon/modifier_rubick_dagon_passive', LUA_MODIFIER_MOTION_NONE )

function item_rubick_dagon:GetIntrinsicModifierName()
	return "modifier_rubick_dagon_passive"
end


function item_rubick_dagon:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    
   	if not caster or not target then return end

   	if target:TriggerSpellAbsorb(self) then return end

	local int_pct = self:GetSpecialValueFor("int_damage_pct") / 100
	local dagon_level = 6

	local dagon_particle = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf",  PATTACH_POINT_FOLLOW, caster)
	local particle_effect_intensity = 300 + (100 * dagon_level)

	ParticleManager:SetParticleControlEnt(dagon_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), false)
	ParticleManager:SetParticleControlEnt(dagon_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), false)
	ParticleManager:SetParticleControl(dagon_particle, 2, Vector(particle_effect_intensity))
	
	caster:EmitSound("DOTA_Item.Dagon.Activate")
	target:EmitSound("DOTA_Item.Dagon5.Target")

	if IsServer() then
		if not caster:IsRealHero() then
			local player = caster:GetPlayerOwner() 
			caster = player:GetAssignedHero() 
		end

		local damage = caster:GetIntellect()*int_pct + self:GetSpecialValueFor("damage");
		if GameRules:IsCheatMode() then damage = 999999999999 end
		ApplyDamage({ victim = target, attacker = caster, damage = damage,	damage_type = DAMAGE_TYPE_MAGICAL, ability = self })
		print("is ill", target:IsIllusion() )
		if target:IsIllusion() then
			target:SetHealth(5)
			ApplyDamage({ victim = target, attacker = caster, damage = 10,	damage_type = DAMAGE_TYPE_PURE, ability = self })
		end
	end
end