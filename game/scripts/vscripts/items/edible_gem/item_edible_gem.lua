item_edible_gem = class({})
LinkLuaModifier( "modifier_edible_gem_aura", 'items/edible_gem/modifiers/modifier_edible_gem_aura', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_edible_gem:OnSpellStart()
	local caster 			= self:GetCaster() 

	caster:AddNewModifier(caster, nil, "modifier_edible_gem_aura", { radius = self:GetSpecialValueFor("radius") or 0 } )

	self:Destroy()
end
