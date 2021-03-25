if modifier_edible_gem_aura == nil then modifier_edible_gem_aura = class({}) end

LinkLuaModifier( "modifier_edible_gem", 'items/edible_gem/modifiers/modifier_edible_gem', LUA_MODIFIER_MOTION_NONE )

function modifier_edible_gem_aura:OnCreated(kv)
	self.radius = kv.radius or 900 

	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_edible_gem_aura:IsAura()
	return true
end

function modifier_edible_gem_aura:IsHidden()
	return false
end

function modifier_edible_gem_aura:IsPurgable()
	return false
end

function modifier_edible_gem_aura:RemoveOnDeath()
	return false
end

function modifier_edible_gem_aura:AllowIllusionDuplicate()
	return true
end

function modifier_edible_gem_aura:GetAuraRadius()
	return self.radius
end

function modifier_edible_gem_aura:DeclareFunctions()
	return { MODIFIER_EVENT_ON_DEATH }
end

function modifier_edible_gem_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_edible_gem_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER
end

function modifier_edible_gem_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_edible_gem_aura:GetModifierAura()
	return "modifier_edible_gem"
end

function modifier_edible_gem_aura:GetTexture()
	return "item_gem"
end

function modifier_edible_gem_aura:OnDeath( keys )
	if IsServer() then
		local dead_hero = keys.unit 

		if dead_hero ~= self:GetParent() then return end
		if dead_hero.IsReincarnating and dead_hero:IsReincarnating() then return end 

		self:Destroy()
	end
end

function modifier_edible_gem_aura:OnIntervalThink()
	if not IsServer() then return end 

	local hero = self:GetParent()

	local enemyUnits = FindUnitsInRadius(hero:GetOpposingTeamNumber() ,
                              hero:GetAbsOrigin(),
                              nil,
                              self.radius,
                              DOTA_UNIT_TARGET_TEAM_BOTH,
                              DOTA_UNIT_TARGET_OTHER,
                              DOTA_UNIT_TARGET_FLAG_NONE+DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
                              FIND_ANY_ORDER,
                              false)

	for _, tree in pairs(enemyUnits) do 
		if tree:GetClassname() == "npc_dota_treant_eyes" then
			tree:AddNewModifier(hero, self:GetAbility(), "modifier_truesight", {duration = 0.11}) 
		end 
	end 
end 