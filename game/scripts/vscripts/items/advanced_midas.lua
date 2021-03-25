function UseAdvancedMidas(keys)
	local Target = keys.target
	local Caster = keys.caster
	local exp_mult = keys.XPMultiplier
	local bonus_gold = keys.BonusGold
	local ability = keys.ability

	if not Caster:IsRealHero() then
		Caster = Caster:GetPlayerOwner():GetAssignedHero() 
	end

	Caster:ModifyGold(bonus_gold, true, 0)

	if not Caster:IsTempestDouble() then
		Caster:AddExperience(Target:GetDeathXP() * exp_mult, 0, false, false) 
	end
	
	local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, Target)	
	ParticleManager:SetParticleControlEnt(midas_particle, 1, Caster, PATTACH_POINT_FOLLOW, "attach_hitloc", Caster:GetAbsOrigin(), false)
	Target:EmitSound("DOTA_Item.Hand_Of_Midas")

	Target:SetDeathXP(0)
	Target:Kill(keys.ability, Caster)
end