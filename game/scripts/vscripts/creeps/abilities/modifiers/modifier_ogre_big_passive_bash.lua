modifier_ogre_big_passive_bash = class({})
--------------------------------------------------------------------------------

function modifier_ogre_big_passive_bash:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_ogre_big_passive_bash:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_ogre_big_passive_bash:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_ogre_big_passive_bash:OnCreated( kv )
end

--------------------------------------------------------------------------------

function modifier_ogre_big_passive_bash:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_ogre_big_passive_bash:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_ogre_big_passive_bash:CheckState()
	return 
	{ 
		[MODIFIER_STATE_STUNNED] = true, 
	}
end