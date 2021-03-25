modifier_lina_fire_shield = modifier_lina_fire_shield or class({})
local mod = modifier_lina_fire_shield

function testflag(set, flag)
	return set % (2*flag) >= flag
end

function mod:IsHidden() return false end
function mod:IsDebuff() return false end
function mod:IsPurgable() return false end
function mod:OnRefresh() self:OnCreated() end
function mod:GetEffectName(kv) return "particles/units/lina/lina_fire_shield/lina_fire_shield.vpcf" end

function mod:OnCreated()
	self.incomingDamage = math.max(self.incomingDamage or 0, 0)
    self.absorb = true
	local ability = self:GetAbility()
    self.damage_reduction_pct = ability:GetSpecialValueFor("damage_reduction_pct")
    self.radius = ability:GetSpecialValueFor("radius")
end

function mod:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end

function mod:GetModifierIncomingDamage_Percentage(params)
	if params.damage and not testflag(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) then
	    self.incomingDamage = self.incomingDamage + params.damage
	end
	return -self.damage_reduction_pct
end

function mod:OnDestroy()
    if not IsServer() then return end

    local parent = self:GetParent()

    if not parent or parent:IsNull() then return end

    local ability = self:GetAbility()

    if not ability or ability:IsNull() then return end

    if parent:IsAlive() then
        local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

        local nEnemies = #enemies

        local damage = self.incomingDamage / (nEnemies)

        if nEnemies > 0 then
            for _, enemy in pairs(enemies) do
                if enemy ~= nil and not enemy:IsNull() and (not enemy:IsMagicImmune()) and (not enemy:IsInvulnerable()) then
                    local info = {
                        victim = enemy,
                        attacker = parent,
                        damage = damage,
                        damage_type = DAMAGE_TYPE_MAGICAL,
                        ability = ability,
                    }
                    ApplyDamage(info)
                end
            end
        end
    end
end
