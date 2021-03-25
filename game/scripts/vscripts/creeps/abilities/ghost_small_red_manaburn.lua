ghost_small_red_manaburn = class({})
--------------------------------------------------------------------------------

function ghost_small_red_manaburn:OnSpellStart( keys )
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	target:ReduceMana( self:GetSpecialValueFor("mana_burn") )
	
	target:EmitSound("Hero_Antimage.ManaBreak")

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spell_blink.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) 
end