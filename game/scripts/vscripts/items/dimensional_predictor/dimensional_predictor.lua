item_dimensional_predictor = item_dimensional_predictor or class({}) 

LinkLuaModifier( "modifier_dimensional_predictor_passive", 			'items/dimensional_predictor/modifiers/modifier_dimensional_predictor_passive', 		LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dimensional_predictor_active",  			'items/dimensional_predictor/modifiers/modifier_dimensional_predictor_active', 			LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dimensional_predictor_passive_unique", 	'items/dimensional_predictor/modifiers/modifier_dimensional_predictor_passive_unique', 	LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dimensional_predictor_charged_dummy", 	'items/dimensional_predictor/modifiers/modifier_dimensional_predictor_charged_dummy', 	LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dimensional_predictor_charged_dummy_cd", 'items/dimensional_predictor/modifiers/modifier_dimensional_predictor_charged_dummy_cd', 	LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_dimensional_predictor:GetIntrinsicModifierName()
	return "modifier_dimensional_predictor_passive"
end

function item_dimensional_predictor:OnSpellStart()
	if not IsServer() then return end 

	local caster = self:GetCaster() 

	caster:AddNewModifier(caster, self, "modifier_dimensional_predictor_active", { 
		duration = self:GetSpecialValueFor("active_duration")
	})
end

function item_dimensional_predictor:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_dimensional_predictor_charged_dummy") then
		return"dimensional_predictor_charge"
	else
		return "dimensional_predictor"
	end
end
