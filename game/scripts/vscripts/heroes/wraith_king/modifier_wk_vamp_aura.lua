modifier_wk_vamp_aura = class({})

function modifier_wk_vamp_aura:IsHidden() 			return true end
function modifier_wk_vamp_aura:IsPurgable() 		return false end
function modifier_wk_vamp_aura:DestroyOnExpire() 	return false end

function modifier_wk_vamp_aura:IsAura() 			return true end
function modifier_wk_vamp_aura:GetAuraRadius() 		return self.radius end
function modifier_wk_vamp_aura:GetModifierAura()	return "modifier_skeleton_king_vampiric_aura_buff" end


function modifier_wk_vamp_aura:GetAuraSearchTeam()
	if not self:GetParent():PassivesDisabled() then
		return DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end
end

function modifier_wk_vamp_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_wk_vamp_aura:DeclareFunctions() return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
}
end

function modifier_wk_vamp_aura:GetAuraEntityReject(hEntity) -- return true to reject entity from gaining mod
	if IsServer() then
		if hEntity:GetAttackCapability() == 2 then -- if ranged
			if self.talent:GetLevel() > 0 then
				return false -- if talent graded - on
			else
				return true -- off otherwise
			end
		else
			return false -- if melee - always on
		end
	end
end

function modifier_wk_vamp_aura:OnCreated( ... )
	local ability = self:GetAbility()
	local parent  = self:GetParent()
	self.radius   = ability:GetSpecialValueFor("vampiric_aura_radius")

	if IsServer() then
		self.talent   = parent:FindAbilityByName("special_bonus_wk_vampiric_ranged")
	end 
end

function modifier_wk_vamp_aura:OnRefresh()
	local ability = self:GetAbility()
	local parent  = self:GetParent()
	self.radius   = ability:GetSpecialValueFor("vampiric_aura_radius")
	if IsServer() then
		self.talent   = parent:FindAbilityByName("special_bonus_wk_vampiric_ranged")
	end 
end
