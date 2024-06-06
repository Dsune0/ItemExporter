local _, ItemExporter = ...

-- localized armorTypes
ItemExporter.armorTypes = {
    INVTYPE_HEAD,
    INVTYPE_NECK,
    INVTYPE_SHOULDER,
    INVTYPE_CLOAK,
    INVTYPE_CHEST,
    INVTYPE_WRIST,
    INVTYPE_HAND,
    INVTYPE_WAIST,
    INVTYPE_LEGS,
    INVTYPE_FEET,
    INVTYPE_WEAPONMAINHAND,
    INVTYPE_WEAPONOFFHAND,
    INVTYPE_FINGER,
    INVTYPE_TRINKET,
}

-- filterTypes for SimulationCraft
local filterTypes = {
    [0] = 'head',
    [1] = 'neck',
    [2] = 'shoulder',
    [3] = 'back',
    [4] = 'chest',
    [5] = 'wrist',
    [6] = 'hands',
    [7] = 'waist',
    [8] = 'legs',
    [9] = 'feet',
    [10] = 'main_hand',
    [11] = 'off_hand',
    [12] = 'ring1',
    [13] = 'trinket1',
}

-- invType with filterType
local invType = {
    INVTYPE_HEAD = 0,
    INVTYPE_NECK = 1,
    INVTYPE_SHOULDER = 2,
    INVTYPE_CLOAK = 3,
    INVTYPE_CHEST = 4,
    INVTYPE_ROBE = 4,
    INVTYPE_WRIST = 5,
    INVTYPE_HAND = 6,
    INVTYPE_WAIST = 7,
    INVTYPE_LEGS = 8,
    INVTYPE_FEET = 9,
    INVTYPE_WEAPON = 10,
    INVTYPE_WEAPONMAINHAND = 10,
    INVTYPE_2HWEAPON = 10,
    INVTYPE_RANGED = 10,
    INVTYPE_HOLDABLE = 11,
    INVTYPE_WEAPONOFFHAND = 11,
    INVTYPE_SHIELD = 11,
    INVTYPE_FINGER = 12,
    INVTYPE_TRINKET = 13,
}

-- specs that can dual wield weapons
local CanSpecDualWield = {
    [72] = true, -- Warrior: Fury
    [251] = true, -- Death Knight: Frost
    [268] = true, -- Monk: Brewmaster
    [269] = true, -- Monk: Windwalker
    [259] = true, -- Rogue: Assassination
    [260] = true, -- Rogue: Outlaw
    [261] = true, -- Rogue: Subtlety
    [263] = true, -- Shaman: Enhancement
    [577] = true, -- Demon Hunter: Havoc
    [581] = true, -- Demon Hunter: Vengeance
}

local CanClassDualWield = {
    [1] = true, -- Warrior
    [4] = true, -- Rogue
    [6] = true, -- Death Knight
    [7] = true, -- Shaman
    [10] = true, -- Monk
    [12] = true, -- Demon Hunter
}

local function canDualWield(itemType, specID, classID)
    -- Check if the item is main hand
    if itemType == 10 then
        if specID ~= 0 then
            return CanSpecDualWield[specID] or false
        elseif classID ~= 0 then
            return CanClassDualWield[classID] or false
        else
            return true
        end
    else
        return false  -- cannot dual wield
    end
end

local function CreateItemStrings(itemData)
    local items = {}
    for _, item in ipairs(itemData) do
        table.insert(items, "# " .. item.name)
        table.insert(items, "# " .. item.filterType .. "=,id=" .. item.itemID .. ",bonus_id=4795" .. ",ilevel=" .. ItemExporter.selectedItemLevel .. "\n")
    end
    local text = table.concat(items, "\n")
    ItemExporter:GetMainFrame(text):Show()
end

function ItemExporter:SortItems(itemData)
    table.sort(itemData, function(a, b)
            local aIndex = 0
            local bIndex = 0
            for index, filterType in ipairs(filterTypes) do
                if filterType == a.filterType then
                    aIndex = index
                end
                if filterType == b.filterType then
                    bIndex = index
                end
            end
            return aIndex < bIndex
    end)
    CreateItemStrings(itemData)
end

-- fetch itemIDs function
function ItemExporter.GetItemsForSelectedInstances(selectedDungeons, selectedBosses, ClassSpecInfo, selectedArmorTypes, selectedTierset)
    ItemExporter:DisableEJ()
    local itemData = {}
    local itemCount = 0
    local itemsLoadedCount = 0
    local classFilter, specFilter = EJ_GetLootFilter()
    local classID, specID = ClassSpecInfo.classID, ClassSpecInfo.specID
    
    --fetch itemInfo function
    local function AddItemData(lootInfo)
        if lootInfo and lootInfo.itemID then
            local item = Item:CreateFromItemID(lootInfo.itemID)
            item:ContinueOnItemLoad(function()
                itemsLoadedCount = itemsLoadedCount + 1
                local itemName, _, _, _, _, _, _, _, itemEquipLoc = C_Item.GetItemInfo(lootInfo.itemID)
                local itemType = invType[itemEquipLoc]
                if itemType and selectedArmorTypes[itemType] and C_Item.IsEquippableItem(lootInfo.itemID) then
                    table.insert(itemData, {
                        name = itemName,
                        filterType = filterTypes[itemType],
                        itemID = lootInfo.itemID,
                        })
                    if canDualWield(itemType, specID, classID) then
                        table.insert(itemData, {
                            name = itemName,
                            filterType = filterTypes[itemType+1],
                            itemID = lootInfo.itemID,
                        })
                    end
                end
                if itemsLoadedCount == itemCount then
                    ItemExporter:SortItems(itemData)
                end
            end)
        end
    end
    
    -- Iterate dungeons
    for _, instanceID in ipairs(selectedDungeons) do
        EJ_SetLootFilter(classID, specID)
        EJ_SelectInstance(instanceID)
        EJ_SetDifficulty(8)
        itemCount = itemCount + EJ_GetNumLoot()
        for i = 1, EJ_GetNumLoot() do
            local lootInfo = C_EncounterJournal.GetLootInfoByIndex(i)
            AddItemData(lootInfo)
        end
    end
    
    -- Iterate raid bosses
    for instanceID, encounterIDs in pairs(selectedBosses) do
        EJ_SelectInstance(instanceID)
        for _, encounterID in ipairs(encounterIDs) do
            EJ_SelectEncounter(encounterID)
            itemCount = itemCount + EJ_GetNumLoot()
            for i = 1, EJ_GetNumLoot() do
                local lootInfo = C_EncounterJournal.GetLootInfoByIndex(i)
                AddItemData(lootInfo)
            end
        end
    end
    
    -- Add tierset items
        if ItemExporter:GetCurrentClass() == classID then
            for _, setID in ipairs(selectedTierset) do
                for slot=1, 15, 1 do
                    for key, itemInfo in ipairs(C_TransmogSets.GetSourcesForSlot(setID, slot)) do
                        itemCount = itemCount + 1
                        AddItemData(itemInfo)
                    end
                end
            end
        end
    
    EJ_SetLootFilter(classFilter, specFilter)
    ItemExporter:ReEnableEJ()
end
