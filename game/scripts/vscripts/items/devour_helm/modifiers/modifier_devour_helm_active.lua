modifier_devour_helm_active = modifier_devour_helm_active or class({})
local mod = modifier_devour_helm_active

local TICK_TIME = 0.0001

function mod:IsHidden()         return false  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return true end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:GetTexture()
	return "../items/devour_helm_big"
end

function mod:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function mod:CheckState() return
{
	[MODIFIER_STATE_NO_UNIT_COLLISION] 	= true,
	[MODIFIER_STATE_INVISIBLE] 			= true,
	[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
	[MODIFIER_STATE_FROZEN] 			= true,
	[MODIFIER_STATE_INVULNERABLE] 		= true,
	[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
	[MODIFIER_STATE_OUT_OF_GAME] 		= true,
	[MODIFIER_STATE_UNSELECTABLE] 		= true,
	[MODIFIER_STATE_DISARMED] 			= true,
}
end

function mod:OnCreated( kv )
	local parent  = self:GetParent()
	
	if not parent then return end

	local ability = self:GetAbility()

	if not ability then return end

	ability:SetPocketUnit(parent)

	if not IsServer() then return end

	local caster  = self:GetCaster()

	if not caster then return end
	
	if self.timer then return end

	parent:AddNoDraw() 

	self.timer = Timers:CreateTimer(TICK_TIME, function() 
		if not self or self:IsNull() then return end

		if not caster or caster:IsNull() or not IsValidEntity(caster) then 
			self:Destroy()
			return 
		end

		local isCasterAlive = caster:IsAlive() or ( caster.IsReincarnating and caster:IsReincarnating() )

		if not isCasterAlive then
			self:Destroy()
			return
		end

		if not ability or ability:IsNull() then
			self:Destroy()
			return
		end

		local hasItem = false 

		-- TODO: Constant of items
		for i = 0, 10 do
			if caster:GetItemInSlot(i) == ability then
				hasItem = true
			end
		end

		if not hasItem then 
			self:Destroy() 
			return
		end

		parent:SetAbsOrigin( caster:GetAbsOrigin() )

		return TICK_TIME
	end)
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_EVENT_ON_ORDER,
}
end

local allowOrder

if IsServer() then
	allowOrder = {
		[DOTA_UNIT_ORDER_CAST_TOGGLE 			] = true,
		[DOTA_UNIT_ORDER_SELL_ITEM	 			] = true,
		[DOTA_UNIT_ORDER_PURCHASE_ITEM			] = true,
		[DOTA_UNIT_ORDER_DISASSEMBLE_ITEM		] = true,
		[DOTA_UNIT_ORDER_MOVE_ITEM				] = true,
		[DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO		] = true,
		[DOTA_UNIT_ORDER_GLYPH					] = true,
		[DOTA_UNIT_ORDER_TAUNT					] = true,
		[DOTA_UNIT_ORDER_STOP					] = true,
		[DOTA_UNIT_ORDER_TRAIN_ABILITY			] = true,
		[DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH 	] = true,
		[DOTA_UNIT_ORDER_GIVE_ITEM 				] = true,
		[DOTA_UNIT_ORDER_PICKUP_ITEM 			] = true,
		[27 									] = true, --pick on self item
	}
end
---------------------------------------------------------------------------------

function mod:OnOrder(kv)
	if not IsServer() then return end

	if kv.unit ~= self:GetParent() then return end

	local ability = self:GetAbility()

	if allowOrder[kv.order_type] then return end 

	self:Destroy() 
end

---------------------------------------------------------------------------------

function mod:OnDestroy()
	local parent = self:GetParent()
	local ability = self:GetAbility()

	if IsServer() then
		if parent and not parent:IsNull() then
			parent:RemoveNoDraw() 
		end

		if self.timer ~= nil then
			Timers:RemoveTimer(self.timer)
			self.timer = nil
		end
	end

	if ability then
		ability:ReleashPocketUnit()

		if IsServer() then
			ability:UseResources( false, false, true )
		end
	end
end