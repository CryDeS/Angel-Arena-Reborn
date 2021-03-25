modifier_tester = class({})

function modifier_tester:DeclareFunctions()
	return {}
end

function modifier_tester:IsHidden()
	return false
end

function modifier_tester:OnCreated(event)
	
end

function modifier_tester:IsPurgable()
	return false
end

function modifier_tester:GetTexture()
	return "ghostwarr"
end