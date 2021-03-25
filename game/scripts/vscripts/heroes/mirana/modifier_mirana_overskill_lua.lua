modifier_mirana_overskill_lua = class({})

function modifier_mirana_overskill_lua:OnCreated()
	self.bonusAgi = self:GetStackCount()
	self.refreshed = false
end 
	
function modifier_mirana_overskill_lua:GetEffectName()
	return "particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_ti7_ambient.vpcf"
end 

function modifier_mirana_overskill_lua:GetEffectAttachType()    
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_mirana_overskill_lua:OnRefresh()	
	if not self.refreshed then
		self.bonusAgi = self:GetStackCount()
		self.refreshed = true
	end
end 
	
function modifier_mirana_overskill_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}

	return funcs
end

function modifier_mirana_overskill_lua:GetModifierBonusStats_Agility( params )
	return  self.bonusAgi
end