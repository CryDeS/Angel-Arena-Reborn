require('lib/common_abilities/base')

CommonAbilities.AutoTextured = CommonAbilities.AutoTextured or class({})

local subclass = CommonAbilities.AutoTextured

function subclass:GetTexture()
	if not self.textureName then
		self:CommonInitAutoTextured( self:GetAbility() )
	end

	return self.textureName
end

function subclass:CommonInitAutoTextured( ability )
	self.textureName = CommonAbilities:DeductTexture( ability )
end

function subclass:SetTextureName( textureName )
	self.textureName = textureName
end