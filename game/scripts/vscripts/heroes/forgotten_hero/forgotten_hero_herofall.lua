forgotten_hero_herofall = forgotten_hero_herofall or class({})

local ability = forgotten_hero_herofall

LinkLuaModifier( "modifier_forgotten_hero_herofall", 		"heroes/forgotten_hero/modifiers/modifier_forgotten_hero_herofall", 		LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_forgotten_hero_herofall_debuff", "heroes/forgotten_hero/modifiers/modifier_forgotten_hero_herofall_debuff", 	LUA_MODIFIER_MOTION_NONE )

-- because valve has broken function GetAOERadius for abilities.
function ability:GetAOERadius()
	return self:GetSpecialValueFor("aoe_radius")
end

function ability:GetCastRange(point, target)
	if self:GetLevel() == 0 then return 0 end

	return self.BaseClass.GetCastRange(self, point, target) + self:GetCaster():GetTalentSpecialValueFor("forgotten_hero_talent_herofall_range_bonus")
end

function ability:OnSpellStart( kv )
	if not IsServer() then return end

	local caster 	= self:GetCaster()
	local pos 		= self:GetCursorPosition()

	caster:AddNewModifier(caster, self, "modifier_forgotten_hero_herofall", { px = pos.x, py = pos.y, pz = pos.z, duration = -1 })

	ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_spring_cast_spiral_arm_b.vpcf", PATTACH_ABSORIGIN, caster)
	
	caster:EmitSound("Hero_ForgottenHero.Herofall.Cast")
end