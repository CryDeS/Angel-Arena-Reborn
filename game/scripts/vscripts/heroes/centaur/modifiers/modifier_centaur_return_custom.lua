modifier_centaur_return_custom = class({})

--------------------------------------------------------------------------------

function modifier_centaur_return_custom:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_centaur_return_custom:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_centaur_return_custom:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------

function modifier_centaur_return_custom:GetModifierAura()
	return "modifier_centaur_return_custom_aura"
end

--------------------------------------------------------------------------------

function modifier_centaur_return_custom:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_centaur_return_custom:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_centaur_return_custom:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifier_centaur_return_custom:GetAuraRadius()
	local tbl = CustomNetTables:GetTableValue( "heroes", "centaur_return") 
	
	tbl = tbl or {}
	return tbl.aura_radius or 1
end


--------------------------------------------------------------------------------

function modifier_centaur_return_custom:OnCreated( kv )

end

function modifier_centaur_return_custom:OnCreated( keys )
	if IsServer() then
		Timers:CreateTimer(1, function() 
			if self:GetCaster():HasTalent("special_bonus_unique_centaur_1") then
				print("talent")
				CustomNetTables:SetTableValue( "heroes", "centaur_return" , { aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius") } )
			else 
				print("no talent")
				CustomNetTables:SetTableValue( "heroes", "centaur_return" , { aura_radius = 1 } )
			end
			if not self then 
				print("failed centaur ability")
				return nil 
			end 

			return 1 
		end)
	end

end

--[[
--------------------------------------------------------------------------------

function modifier_centaur_return_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACKED,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_centaur_return_custom:OnAttacked( params )
	  if IsServer() then
        
	end

	return 0
end
]]
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------