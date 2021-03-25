item_spiked_armor = class({})
LinkLuaModifier( "modifier_spiked_armor", 'items/spiked_armor/modifiers/modifier_spiked_armor', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spiked_armor_active", 'items/spiked_armor/modifiers/modifier_spiked_armor_active', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spiked_armor_aura_friend", 'items/spiked_armor/modifiers/modifier_spiked_armor_aura_friend', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spiked_armor_aura_enemy_emitter", 'items/spiked_armor/modifiers/modifier_spiked_armor_aura_enemy_emitter', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spiked_armor_aura_enemy", 'items/spiked_armor/modifiers/modifier_spiked_armor_aura_enemy', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_spiked_armor:OnSpellStart()
	local caster = self:GetCaster()

	caster:EmitSound("DOTA_Item.BladeMail.Activate")
	
	caster:AddNewModifier(caster, self, "modifier_spiked_armor_active", { duration = self:GetSpecialValueFor("return_duration") }) 
end

function item_spiked_armor:GetIntrinsicModifierName()
	return "modifier_spiked_armor"
end
