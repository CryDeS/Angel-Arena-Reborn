ghost_big_dash = class({})
LinkLuaModifier( "modifier_ghost_big_dash", 'creeps/abilities/modifiers/modifier_ghost_big_dash', LUA_MODIFIER_MOTION_HORIZONTAL )


function ghost_big_dash:OnSpellStart()
	local caster 	= self:GetCaster() 
	local vPos 

	if self:GetCursorTarget() then
		vPos = self:GetCursorTarget():GetOrigin()
	else
		vPos = self:GetCursorPosition()
	end


	caster:AddNewModifier(caster, self, "modifier_ghost_big_dash", 
			{ 	speed = self:GetSpecialValueFor("speed"), 
				point_x = vPos.x, 
				point_y = vPos.y, 
				point_z = vPos.z,
				damage =  self:GetSpecialValueFor("damage"),
				damage_type = self:GetAbilityDamageType() })
end
