modifier_sheo_dev = class({})

function modifier_sheo_dev:IsHidden()
	return false
end

function modifier_sheo_dev:OnCreated(event)

end

function modifier_sheo_dev:IsPurgable()
	return false
end

function modifier_sheo_dev:GetTexture()
	return "sheo"
end