modifier_dimensional_predictor_passive_unique = class({})
--------------------------------------------------------------------------------

function modifier_dimensional_predictor_passive_unique:IsHidden() 			return true; end
function modifier_dimensional_predictor_passive_unique:IsPurgable() 		return false; end
function modifier_dimensional_predictor_passive_unique:DestroyOnExpire() 	return false; end
function modifier_dimensional_predictor_passive_unique:RemoveOnDeath() 		return false; end

function modifier_dimensional_predictor_passive_unique:GetAttributes() 		return (MODIFIER_ATTRIBUTE_PERMANENT); end

--------------------------------------------------------------------------------

function modifier_dimensional_predictor_passive_unique:OnCreated( kv )
	if not IsServer() then return end 

	self.cd 	 = self:GetAbility():GetSpecialValueFor("passive_cd")
	self.dmg 	 = self:GetAbility():GetSpecialValueFor("passive_damage_att") / 100
	self.radius  = self:GetAbility():GetSpecialValueFor("radius")

	self.charged = false 
	self.timerID = "dimensional_predictor_" .. tostring(self:GetParent():entindex())

	self:StartCharge() 
end


--------------------------------------------------------------------------------
function modifier_dimensional_predictor_passive_unique:OnDestroy( kv )
	if not IsServer() then return end 

	self:OnUncharge( nil )
	self:StopCharge()
end 

--------------------------------------------------------------------------------

function modifier_dimensional_predictor_passive_unique:DeclareFunctions() return {
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_RESPAWN,
} end

--------------------------------------------------------------------------------

function modifier_dimensional_predictor_passive_unique:OnRespawn( kv )
	if not IsServer() then return end 
	if kv.unit ~= self:GetParent() then return end 

	self:OnUncharge( nil )
	self:StopCharge()
	self:StartCharge() 
end 

--------------------------------------------------------------------------------

function modifier_dimensional_predictor_passive_unique:OnAttackLanded( kv )
	if not IsServer() then return end 
	if self:GetParent() ~= kv.attacker then return end
	local target = kv.target
	local targetName = target:GetUnitName()
	if targetName == "npc_dota_observer_wards" or targetName == "npc_dota_sentry_wards" then return end

	local caster = kv.attacker

	if self.charged then
		local damage = 0

		if not caster:IsRealHero() then
			local owner = caster:GetPlayerOwner() 
			if IsValidEntity(owner) then
				owner = owner:GetAssignedHero() 
				damage = self.dmg * owner:GetPrimaryStatValue() 
			end 
		else 
			damage = self.dmg * caster:GetPrimaryStatValue() 
		end

		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
					local infoDamage = {
						victim = enemy,
						attacker = caster,
						damage = damage,
						ability = self:GetAbility(),
						damage_type = DAMAGE_TYPE_MAGICAL,
					}
					ApplyDamage(infoDamage)
					SendOverheadEventMessage( enemy, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE , caster, damage, nil )
				end
			end
		end

		self:OnUncharge(target)
		self:StartCharge()
	end

-- 	self:StopCharge()
--	self:StartCharge()
end

--------------------------------------------------------------------------------

function modifier_dimensional_predictor_passive_unique:OnCharged()
	self.charged = true 

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_dimensional_predictor_charged_dummy", { duration = -1 })
	
	local caster = self:GetParent()

	if caster:IsAlive() then
		local idx = ParticleManager:CreateParticle("particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_small_c_it_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(idx, 0, caster:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex(idx)
	end 

end 

function modifier_dimensional_predictor_passive_unique:OnUncharge( target )
	self.charged = false 

	self:GetParent():RemoveModifierByName("modifier_dimensional_predictor_charged_dummy")

	if target then 
		local idx = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_storm_bolt_projectile_explosion.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(idx, 3, target:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex(idx)
	end

end 

--------------------------------------------------------------------------------

function modifier_dimensional_predictor_passive_unique:StartCharge()

	Timers:CreateTimer(self.timerID, 
	{
		useGameTime = true,
		endTime = self.cd,
		callback = function()
			self:OnCharged()
			self:StopCharge() 

			return nil 
		end
	})

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_dimensional_predictor_charged_dummy_cd", { duration = self.cd })
end 

function modifier_dimensional_predictor_passive_unique:StopCharge()
	Timers:RemoveTimer(self.timerID)
	self:GetParent():RemoveModifierByName("modifier_dimensional_predictor_charged_dummy_cd")
end 