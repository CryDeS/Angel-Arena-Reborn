charon_last_word = class({})
LinkLuaModifier( "modifier_charon_last_word_aura", "heroes/charon/charon_last_word/modifier_charon_last_word_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_charon_last_word_aura_effect", "heroes/charon/charon_last_word/modifier_charon_last_word_aura_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function charon_last_word:GetIntrinsicModifierName()
	return "modifier_charon_last_word_aura"
end

--------------------------------------------------------------------------------
function charon_last_word:GetCastRange()
	if self:GetLevel() == 0 then return 0 end
	return self:GetSpecialValueFor( "radius" ) - self:GetCaster():GetCastRangeBonus()
end
