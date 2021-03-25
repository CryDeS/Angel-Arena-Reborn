require('lib/common_abilities/auto_textured')

modifier_damage_to_exp_cd = CommonAbilities:ConstructModifier( modifier_damage_to_exp_cd, CommonAbilities.AutoTextured )
local mod = modifier_damage_to_exp_cd

function mod:IsHidden()         return false end
function mod:IsPurgable()       return false end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end
function mod:DestroyOnExpire()  return true end