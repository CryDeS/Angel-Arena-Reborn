modifier_shadowsong_absorption_aura_effect = class({})
mod = modifier_shadowsong_absorption_aura_effect

local talentName = "shadowsong_special_bonus_absorbtion_kill_bonus"
local talentMod  = "modifier_shadowsong_absorption_talent"
local parentMod  = "modifier_shadowsong_absorption_aura"

function mod:IsHidden() 		return false end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return false end
function mod:DestroyOnExpire() 	return true end

function mod:OnCreated( kv )
	if not IsServer() then return end

	local parentMod = self:GetParentMod()

	if parentMod then
		parentMod:register( self:GetParent() )
	end
end

mod.OnRefresh = mod.OnCreated

function mod:OnDestroy( kv )
	if not IsServer() then return end

	local parentMod = self:GetParentMod()

	if parentMod then
		parentMod:unregister( self:GetParent() )
	end
end

function mod:DeclareFunctions() return 
{
	MODIFIER_EVENT_ON_DEATH,
}
end

function mod:GetParentMod()
	local owner = self:GetAuraOwner()

	if not owner then return end
	
	local parentMod = owner:FindModifierByNameAndCaster(parentMod, owner)

	if not parentMod then return end

	if not parentMod.isOk then return end

	return parentMod
end

function mod:OnDeath(params)
	if not IsServer() then return end

	local parent = self:GetParent()

	if params.unit ~= parent then return end

	local ability = self:GetAbility()
	local bonusDuration = 0

	if parent:IsRealHero() then
		local caster = self:GetAuraOwner()

		if caster:HasTalent(talentName) then 
			local mod = caster:FindModifierByNameAndCaster(talentMod, caster) or caster:AddNewModifier(caster, self:GetAbility(), talentMod, { duration = -1 })

			mod:IncrementStackCount()
			mod:ForceRefresh()
		end

		bonusDuration = ability:GetSpecialValueFor("bonus_duration_hero")
	else
		bonusDuration = ability:GetSpecialValueFor("bonus_duration_creep")
	end

	local parentMod = self:GetParentMod()

	if parentMod then
		parentMod:SetDuration( parentMod:GetDuration() - parentMod:GetElapsedTime() + bonusDuration, true )
	end
end

function mod:GetEffectName()
	return "particles/shadowsong/shadowsong_absorbtion/shadowsong_absorbtion.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
