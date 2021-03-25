modifier_abyss_warrior_death_link = modifier_abyss_warrior_death_link or class({})

local mod = modifier_abyss_warrior_death_link

function mod:IsHidden() 		return false end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return true end
function mod:IsPurgeException() return true end


function mod:DeclareFunctions() return 
{ 
	MODIFIER_EVENT_ON_TAKEDAMAGE, 
} 
end

function mod:OnCreated(kv)
	if not IsServer() then return end

	local ability = self:GetAbility()

	if not ability then return end

	self.damageMult 	= ability:GetSpecialValueFor("damage_pct") / 100
	self.breakDistance  = ability:GetSpecialValueFor("link_radius") + 50
end

mod.OnRefresh = mod.OnCreated

function mod:OnDestroy()
	if not IsServer() then return end

	local target = self.target

	ParticleManager:CreateParticle(	"particles/econ/wards/warlock/ward_warlock/warlock_ambient_ward_explosion.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())

	if target and not target:IsNull() then
		target:RemoveModifierByName("modifier_abyss_warrior_death_link")
	end
end

function testflag(set, flag)
	return set % (2*flag) >= flag
end

function mod:OnTakeDamage( params )
	if not IsServer() then return end

	local parent = params.unit

	if parent ~= self:GetParent() then return end

	if not parent or parent:IsNull() then return end

	if testflag(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) then return end 

	local target = self.target

	if not target or target:IsNull() or ( parent:GetAbsOrigin() - target:GetAbsOrigin() ):Length() > self.breakDistance then
		self:Destroy()
		return
	end

	ApplyDamage({
		victim 		 = target,
		attacker 	 = parent,
		damage 		 = self.damageMult * params.damage,
		ability 	 = self:GetAbility(),
		damage_type  = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
	})
end

function mod:GetEffectName()
	return "particles/econ/items/warlock/warlock_ti10_head/warlock_ti_10_fatal_bonds_icon.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end