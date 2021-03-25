modifier_boss_power = modifier_boss_power or class({})
local mod = modifier_boss_power

function mod:IsHidden()         return true  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return false end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:DeclareFunctions() return 
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
}
end

function mod:OnTakeDamage(params)
	local attacker  = params.attacker
	if not attacker then return end

	local caster 	= params.unit

	if IsServer() then
		if BossSpawner:IsBoss(caster) then 
			attacker:RemoveModifierByName("modifier_smoke_of_deceit")
			attacker:RemoveModifierByName("modifier_bane_nightmare_invulnerable")
			attacker:RemoveModifierByName("modifier_bane_nightmare")
			attacker:RemoveModifierByName("modifier_phantom_assassin_blur_active")


			if(caster:GetAbsOrigin() - attacker:GetAbsOrigin()):Length2D() > 2000 and attacker and attacker:GetUnitName() == "npc_dota_hero_shredder" then
				caster:Heal(params.damage, caster)
			end
		end
	end
end