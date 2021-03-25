item_fury_shield = item_fury_shield or class({}) 
LinkLuaModifier( "modifier_item_fury_shield_passive", 	'items/fury_shield/modifiers/modifier_item_fury_shield_passive', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_fury_shield_active", 	'items/fury_shield/modifiers/modifier_item_fury_shield_active', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_fury_shield:GetTexture()
	return "fury_shield"--"../items/fury_shield"
end


function item_fury_shield:GetIntrinsicModifierName()
	return "modifier_item_fury_shield_passive"
end

function item_fury_shield:OnSpellStart()
	local caster 			= self:GetCaster() 

	caster:AddNewModifier(	caster, 
							self, 
							"modifier_item_fury_shield_active", 
							{ 
								duration 	 = self:GetSpecialValueFor("shield_duration"),
								block_damage = self:GetSpecialValueFor("block_damage")
							})
end
