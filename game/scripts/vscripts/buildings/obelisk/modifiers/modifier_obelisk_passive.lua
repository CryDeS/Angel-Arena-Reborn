modifier_obelisk_passive = class({})
--------------------------------------------------------------------------------

function modifier_obelisk_passive:IsHidden() 		return true; 	end
function modifier_obelisk_passive:IsPurgable() 		return false; 	end
function modifier_obelisk_passive:DestroyOnExpire() return false; 	end

--------------------------------------------------------------------------------

function modifier_obelisk_passive:DeclareFunctions()
	return { MODIFIER_EVENT_ON_TAKEDAMAGE }
end

-------------------------------------------------------------------------------

function modifier_obelisk_passive:OnTakeDamage( params )
	if not IsServer() then return end 

	if params.unit ~= self:GetParent() then return; end

	if self:GetParent():GetHealth() <= 0 then
		self:GetParent():Heal( 999999, self:GetAbility() )

		self:GetAbility():OnStateChanged( true, params.attacker )
	end
end

--------------------------------------------------------------------------------
