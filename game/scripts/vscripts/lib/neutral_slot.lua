NeutralSlot = NeutralSlot or class({})

DOTA_STASH_SLOT_1 = 9
DOTA_STASH_SLOT_6 = 15
local DOTA_SLOT_MAX = 16

local _isStashSlot = function(slot)
    return slot >= DOTA_STASH_SLOT_1 and slot <= DOTA_STASH_SLOT_6
end

local _moveToSlot = function(hero, item, newSlot)
    local slot = item:GetItemSlot()

    if slot < DOTA_ITEM_SLOT_1 or slot > DOTA_SLOT_MAX then return end
    if newSlot < DOTA_ITEM_SLOT_1 or newSlot > DOTA_SLOT_MAX then return end

    if _isStashSlot(slot) or _isStashSlot(newSlot) then 
        if not hero:IsInRangeOfShop(DOTA_SHOP_HOME, true) then return end
    end

    hero:SwapItems( slot, newSlot )
end

function NeutralSlot:_init()
    CustomGameEventManager:RegisterListener("aa_on_drop_item_to_slot", Dynamic_Wrap(self, 'OnDragEnd'))

    self.kv_data = LoadKeyValues("scripts/npc/neutral_slot_items.txt")
end

function NeutralSlot:OnDragEnd(data)
    local entIndex = data.idx
    local playerID = data.PlayerID
    local slot     = data.slt
    
    if not entIndex then return end
    if slot == nil then return end

    local item = EntIndexToHScript(entIndex)

    if not item then return end

    if not item.GetName or not item.GetParent then return end

    local parent = item:GetParent()

    if not parent then return end

    if parent:GetPlayerOwnerID() ~= playerID then return end

    if parent:IsIllusion() then return end
    if parent:IsTempestDouble() then return end

    local name = item:GetName()

    local isNeutralItem = NeutralSlot:NeedToNeutralSlot(name)

    if not isNeutralItem then return end

    local neutalSlotIndex = NeutralSlot:GetSlotIndex()

    if slot ~= neutalSlotIndex then
        local itemInSlot = parent:GetItemInSlot(slot)

        if itemInSlot and not NeutralSlot:NeedToNeutralSlot( itemInSlot:GetName() ) then return end
    end

    _moveToSlot( parent, item, slot )
end

function NeutralSlot:NeedToNeutralSlot(item_name)
    return self.kv_data[item_name] ~= nil
end

function NeutralSlot:GetSlotIndex()
    return 16
end

NeutralSlot:_init()