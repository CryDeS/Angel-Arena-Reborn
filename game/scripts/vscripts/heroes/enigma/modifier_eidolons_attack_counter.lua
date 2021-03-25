modifier_eidolons_attack_counter = class({})

function modifier_eidolons_attack_counter:IsPurgable( ... )
	return false
end

function modifier_eidolons_attack_counter:IsHidden( ... )
	return true
end

function modifier_eidolons_attack_counter:OnCreated(kv)
	if not IsServer() then return end
	self.attack_limit 		= self:GetAbility():GetSpecialValueFor("split_attack_count")
	self.attack_performed 	= 0
end

function modifier_eidolons_attack_counter:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_eidolons_attack_counter:OnAttackLanded(params)
	if not IsServer() then return end 

	if params.attacker ~= self:GetParent() then return end
	
	self.attack_performed = self.attack_performed + 1

	if self.attack_performed == self.attack_limit then

		local ability = self:GetAbility()
		local caster  = self:GetAbility():GetCaster()
		local parent  = self:GetParent()

		local eidolon = CreateUnitByName(parent:GetUnitName(), parent:GetOrigin() + RandomVector(70),true,caster,nil,caster:GetTeam())
		eidolon:SetControllableByPlayer(caster:GetPlayerID(),true)
		eidolon:SetOwner(caster)
		eidolon:AddNewModifier(caster,ability,"modifier_demonic_conversion",{duration = ability:GetDuration()})
		FindClearSpaceForUnit(eidolon,eidolon:GetOrigin(), true)
		--refresh old eidolon
		parent:AddNewModifier(caster,ability,"modifier_demonic_conversion",{duration = ability:GetDuration()})
		parent:SetHealth(99999)
		self:Destroy()
	end
end