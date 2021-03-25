modifier_forgotten_hero_meditation = modifier_forgotten_hero_meditation or class({})
local mod = modifier_forgotten_hero_meditation

function mod:IsHidden() 	 	return false end
function mod:RemoveOnDeath() 	return true  end
function mod:IsDebuff() 	 	return false end
function mod:IsPurgable() 	 	return false end
function mod:IsPurgeException() return false  end
function mod:DestroyOnExpire()  return true  end

function mod:OnCreated( kv )
	local parent  = self:GetParent()
	local ability = self:GetAbility()
	
	if not parent or not ability then return end

	self.regen = ability:GetSpecialValueFor("hp_regen")
end

function mod:OnDestroy()
end

function mod:DeclareFunctions() 
	local tbl = { 
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	} 

	local parent = self:GetParent()

	if parent and parent:HasTalent("forgotten_hero_talent_meditation_invis") then
		table.insert(tbl, MODIFIER_PROPERTY_INVISIBILITY_LEVEL)
	end

	return tbl
end

function mod:CheckState() 
	local tbl =  {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}

	local parent = self:GetParent()

	if parent and parent:HasTalent("forgotten_hero_talent_meditation_invis") then
		tbl[MODIFIER_STATE_INVISIBLE] = true
	end

	return tbl
end

function mod:GetModifierInvisibilityLevel()
	return 1
end

function mod:GetModifierHealthRegenPercentage()
	return self.regen
end

function mod:GetOverrideAnimation( params )
	return ACT_DOTA_VICTORY_START
end


function mod:GetEffectName()
	return "particles/econ/items/monkey_king/ti7_weapon/mk_ti7_golden_immortal_weapon_ambient.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
