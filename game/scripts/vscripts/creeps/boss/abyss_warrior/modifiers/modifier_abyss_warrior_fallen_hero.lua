modifier_abyss_warrior_fallen_hero = modifier_abyss_warrior_fallen_hero or class({})

local mod = modifier_abyss_warrior_fallen_hero

function mod:IsHidden() 		return true end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return false end
function mod:IsPurgeException() return false end

function mod:OnCreated(kv)
	if not IsServer() then return end

	local ability = self:GetAbility()

	if not ability then return end

	local cd = ability:GetCooldown(ability:GetLevel() - 1)

	self.timer = Timers:CreateTimer(cd, function()
		if not self then return end

		if not ability then return end

		local parent = self:GetParent()

		if not parent then return end

		if not parent:PassivesDisabled() then
			ability:StartCooldown(cd)

			ParticleManager:CreateParticle("particles/econ/items/ember_spirit/ember_spirit_ashes/ember_spirit_ashes_weapon_blur.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)

			parent:Purge( false, true, false, true, true )

			return cd
		else
			return 0.01 -- next frame pls
		end
	end)
end

function mod:OnRefresh(kv)
end

function mod:OnDestroy()
	if not IsServer() then return end

	if self.timer then 
		Timers:RemoveTimer( self.timer )
		self.timer = nil
	end
end