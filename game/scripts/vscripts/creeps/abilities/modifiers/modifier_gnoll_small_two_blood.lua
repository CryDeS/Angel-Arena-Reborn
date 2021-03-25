modifier_gnoll_small_two_blood = class({})

--------------------------------------------------------------------------------

function modifier_gnoll_small_two_blood:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_two_blood:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_two_blood:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_two_blood:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_two_blood:GetEffectName()
	return "particles/blood_impact/blood_advisor_pierce_spray_c.vpcf"
end
 