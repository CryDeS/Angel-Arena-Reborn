item_throwing_daggers = item_throwing_daggers or class({})

LinkLuaModifier("modifier_throwing_daggers", 'items/throwing_daggers/modifiers/modifier_throwing_daggers', LUA_MODIFIER_MOTION_NONE)

function item_throwing_daggers:GetIntrinsicModifierName() return "modifier_throwing_daggers"; end

local textures = {
	"throwing_daggers_1",
	"throwing_daggers_2",
	"throwing_daggers_3",
	"throwing_daggers_1_vampire",
	"throwing_daggers_2_vampire",
	"throwing_daggers_3_vampire",
}

function item_throwing_daggers:GetAbilityTextureName()
	local charges = 1
	local vampire = 0

	if self then
		charges = self:GetCurrentCharges() or 1

		if charges == 0 then 
			charges = 1 
		end

		if self:GetCaster():HasModifier("modifier_item_vampire_claw") then
			vampire = 1
		end
	end

	return textures[ charges + 3 * vampire ]
end

function HasFreeSlot(unit)
	for i = 0, 8 do
		if unit:GetItemInSlot(i) == nil then
			return true
		end
	end

	if unit:GetItemInSlot(16) == nil then
		return true
	end

	return false
end

function item_throwing_daggers:OnSpellStart()
	if not IsServer() then return end

	local target = self:GetCursorTarget()
	local caster = self:GetCaster()

	 if self:GetCurrentCharges() == 0 then return end

	if target:GetTeamNumber() == caster:GetTeamNumber() then 
		if ( not target:IsRealHero() and not target:HasInventory() ) or target:IsIllusion() or target:IsTempestDouble() then 
			self:EndCooldown()
			return 
		end

		if not HasFreeSlot(target) then 
			self:EndCooldown()
			return 
		end

		if target == caster then 
			self:EndCooldown()
			return 
		end

		target:AddItemByName("item_throwing_daggers")
		self:Spend()

		return 
	else
		if target:TriggerSpellAbsorb(self) or target:TriggerSpellReflect(self) then return end

		self:CreateParticle(caster, target)

		self:Spend()

		caster:EmitSound("Hero_Riki.TricksOfTheTrade")
	end
end

function item_throwing_daggers:Spend()
	self:SpendCharge()

	if self:GetCurrentCharges() == 0 then
		local hItem = self:GetCaster():TakeItem(self)

		-- That is a garbage collection timer
		Timers:CreateTimer(120, function() 
			if hItem and IsValidEntity(hItem) and hItem.Destroy then
				hItem:Destroy()
			end
		end)
	end
end


function item_throwing_daggers:CreateParticle(hSource, hTarget)
	local particle 

	if hSource:HasModifier("modifier_item_vampire_claw") then
		particle = "particles/throwing_daggers/throwing_daggers_vampire.vpcf";
	else
		particle = "particles/throwing_daggers/throwing_daggers.vpcf";
	end

	local info =
	{
		Target = hTarget,
		Source = hSource,
		Ability = self,
		EffectName = particle,
		iMoveSpeed = self:GetSpecialValueFor("throw_speed"),
		vSourceLoc = hSource:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
	}

	ProjectileManager:CreateTrackingProjectile(info)
end 

function item_throwing_daggers:OnProjectileHit(hTarget, vLocation)
	if not self then return end

	if not hTarget then return end
	
	local caster = self:GetCaster()

	local dealed = ApplyDamage({
		victim = hTarget,
		attacker = caster,
		damage = self:GetSpecialValueFor("throw_damage"),
		damage_type = self:GetAbilityDamageType(),
		ability = self
	})

	local particleName

	if caster:HasModifier("modifier_item_vampire_claw") then
		caster:Heal( dealed, self )

		local casterParticle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		ParticleManager:SetParticleControl(casterParticle, 0, caster:GetAbsOrigin())
	
		SendOverheadEventMessage(caster, OVERHEAD_ALERT_HEAL, caster, dealed, nil)

		particleName = "particles/econ/events/ti6/blink_dagger_end_ti6_lvl2.vpcf"
	else
		particleName = "particles/econ/events/ti5/blink_dagger_end_lvl2_ti5.vpcf"
	end
	
	local targetParticle = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, hTarget )

	ParticleManager:SetParticleControl( targetParticle, 0, hTarget:GetAbsOrigin() )

	hTarget:EmitSound("Hero_PhantomAssassin.Dagger.Target")

	if self:GetCurrentCharges() == 0 then
		self:Destroy()
	end
end 
