fireblade_scorched_blades = fireblade_scorched_blades or class({})
local ability = fireblade_scorched_blades

LinkLuaModifier( "modifier_fireblade_scorched_blades", 'heroes/fireblade/modifiers/modifier_fireblade_scorched_blades', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fireblade_scorched_blades_debuff", 'heroes/fireblade/modifiers/modifier_fireblade_scorched_blades_debuff', LUA_MODIFIER_MOTION_NONE )

function ability:GetIntrinsicModifierName()
	return "modifier_fireblade_scorched_blades"
end

function ability:GetCooldown( nLevel )
	return self:GetCaster():GetTalentSpecialValueFor("fireblade_talent_scorched_blades_silence", "cooldown")
end
