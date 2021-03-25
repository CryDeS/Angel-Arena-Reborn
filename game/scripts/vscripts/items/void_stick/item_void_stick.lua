item_void_stick = item_void_stick or class({}) 
LinkLuaModifier( "modifier_item_void_stick", 'items/void_stick/modifiers/modifier_item_void_stick', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_void_stick_cooldown", 'items/void_stick/modifiers/modifier_item_void_stick_cooldown', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_void_stick_astral", 'items/void_stick/modifiers/modifier_item_void_stick_astral', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_void_stick_active_finish", 'items/void_stick/modifiers/modifier_void_stick_active_finish', LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function IsLoneDruidBear(hTarget)
	if hTarget:GetUnitName() == "npc_dota_lone_druid_bear1" then return true end 
	if hTarget:GetUnitName() == "npc_dota_lone_druid_bear2" then return true end 
	if hTarget:GetUnitName() == "npc_dota_lone_druid_bear3" then return true end 
	if hTarget:GetUnitName() == "npc_dota_lone_druid_bear4" then return true end 

	return false;
end 

function item_void_stick:GetIntrinsicModifierName()
	return "modifier_item_void_stick"
end

function item_void_stick:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_SUCCESS
	end

	if not hTarget:IsCreep() and not hTarget:IsHero() and not IsLoneDruidBear(hTarget) then
		return UF_FAIL_CUSTOM
	end 

	return UF_SUCCESS
end

function item_void_stick:GetCustomCastErrorTarget( hTarget )
	if not hTarget:IsCreep() and not hTarget:IsHero() and not IsLoneDruidBear(hTarget) then
		return "#dota_hud_error_cast_only_hero_and_creeps"
	end 

	return ""
end

function item_void_stick:_StartAstral()
	self:_EndAstral()

	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("astral_duration")

	caster:AddNewModifier(caster, self, "modifier_item_void_stick_astral", { duration = duration })

	caster:EmitSound("Hero_Grimstroke.InkSwell.Cast")
end

function item_void_stick:_EndAstral()
	self:GetCaster():StopSound("Hero_Grimstroke.InkSwell.Cast")
	self:GetCaster():RemoveModifierByName("modifier_item_void_stick_astral")
end

function item_void_stick:OnSpellStart()
	local caster 			= self:GetCaster()
	if caster then
		self:SetChanneling(false)
		self:_StartAstral()
	end
end

function item_void_stick:CastFilterResultTarget( hTarget )

	local nCasterID = self:GetCaster():GetPlayerOwnerID()
	local nTargetID = hTarget:GetPlayerOwnerID()

	if IsServer() and not hTarget:IsOpposingTeam(self:GetCaster():GetTeamNumber()) and PlayerResource:IsDisableHelpSetForPlayerID(nTargetID,nCasterID) then
		return UF_FAIL_DISABLE_HELP
	end

end

function item_void_stick:OnChannelFinish(bInterrupted) -- сбилось или нет
	local caster = self:GetCaster()
	if not bInterrupted then
		local durationFinishBuff = self:GetSpecialValueFor("after_cast_bonus_duration")
		caster:AddNewModifier(caster, self, "modifier_void_stick_active_finish", { duration = durationFinishBuff })
	end
	self:_EndAstral()
end

--------------------------------------------------------------------------------
