modifier_dcp_tester = class({})

function modifier_dcp_tester:DeclareFunctions()
	return {}
end

function modifier_dcp_tester:IsHidden()
	return false
end

function modifier_dcp_tester:OnCreated(event)
	
end

function modifier_dcp_tester:IsPurgable()
	return false
end

function modifier_dcp_tester:GetTexture()
	return "shadow_shaman_voodoo"
end