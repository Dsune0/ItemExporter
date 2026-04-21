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

ItemExporter.UpgradeTrackOrder = {
    "Adventurer",
    "Veteran",
    "Champion",
    "Hero",
    "Myth",
}

ItemExporter.UpgradeTracks = {
    Adventurer = {
        name = "Adventurer",
        levels = {
            {level = 1, max = 6, bonusID = 12769, itemLevel = 220},
            {level = 2, max = 6, bonusID = 12770, itemLevel = 224},
            {level = 3, max = 6, bonusID = 12771, itemLevel = 227},
            {level = 4, max = 6, bonusID = 12772, itemLevel = 230},
            {level = 5, max = 6, bonusID = 12773, itemLevel = 233},
            {level = 6, max = 6, bonusID = 12774, itemLevel = 237},
        },
    },
    Veteran = {
        name = "Veteran",
        levels = {
            {level = 1, max = 6, bonusID = 12777, itemLevel = 233},
            {level = 2, max = 6, bonusID = 12778, itemLevel = 237},
            {level = 3, max = 6, bonusID = 12779, itemLevel = 240},
            {level = 4, max = 6, bonusID = 12780, itemLevel = 243},
            {level = 5, max = 6, bonusID = 12781, itemLevel = 246},
            {level = 6, max = 6, bonusID = 12782, itemLevel = 250},
        },
    },
    Champion = {
        name = "Champion",
        levels = {
            {level = 1, max = 6, bonusID = 12785, itemLevel = 246},
            {level = 2, max = 6, bonusID = 12786, itemLevel = 250},
            {level = 3, max = 6, bonusID = 12787, itemLevel = 253},
            {level = 4, max = 6, bonusID = 12788, itemLevel = 256},
            {level = 5, max = 6, bonusID = 12789, itemLevel = 259},
            {level = 6, max = 6, bonusID = 12790, itemLevel = 263},
        },
    },
    Hero = {
        name = "Hero",
        levels = {
            {level = 1, max = 6, bonusID = 12793, itemLevel = 259},
            {level = 2, max = 6, bonusID = 12794, itemLevel = 263},
            {level = 3, max = 6, bonusID = 12795, itemLevel = 266},
            {level = 4, max = 6, bonusID = 12796, itemLevel = 269},
            {level = 5, max = 6, bonusID = 12797, itemLevel = 272},
            {level = 6, max = 6, bonusID = 12798, itemLevel = 276},
        },
    },
    Myth = {
        name = "Myth",
        levels = {
            {level = 1, max = 6, bonusID = 12801, itemLevel = 272},
            {level = 2, max = 6, bonusID = 12802, itemLevel = 276},
            {level = 3, max = 6, bonusID = 12803, itemLevel = 279},
            {level = 4, max = 6, bonusID = 12804, itemLevel = 282},
            {level = 5, max = 6, bonusID = 12805, itemLevel = 285},
            {level = 6, max = 6, bonusID = 12806, itemLevel = 289},
        },
    },
}

ItemExporter.selectedUpgradeTrack = "Myth"
ItemExporter.selectedUpgradeLevel = 6
ItemExporter.selectedUpgradeBonusID = 12806
ItemExporter.selectedExportGrouping = "slot"
ItemExporter.itemLevelOverrideEnabled = false
ItemExporter.itemLevelOverride = nil

ItemExporter.SeasonBonusIDs = {
    mythicTag = 4795,
    catalyst = 13577,
    socket = 13668,
}

ItemExporter.ExportGroupingOrder = {
    "slot",
    "category",
    "source",
    "boss",
}

ItemExporter.ExportGroupings = {
    slot = "Per slot",
    category = "Per category",
    source = "Individual sources",
    boss = "Per boss",
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

local filterTypeOrder = {}
for index = 0, #filterTypes do
    filterTypeOrder[filterTypes[index]] = index
end

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
    INVTYPE_RANGEDRIGHT = 10,
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
    [1480] = true, -- Demon Hunter: Devourer
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
    if itemType ~= 10 then
        return false
    end

    if specID ~= 0 then
        return CanSpecDualWield[specID] or false
    elseif classID ~= 0 then
        return CanClassDualWield[classID] or false
    end

    return true
end

local function GetItemLevelOverride()
    if ItemExporter.itemLevelOverrideEnabled and ItemExporter.itemLevelOverride then
        return ItemExporter.itemLevelOverride
    end

    return nil
end

local function AddBonusID(bonusIDs, bonusID)
    if bonusID then
        table.insert(bonusIDs, bonusID)
    end
end

local function GetSeasonBonusIDs()
    local bonusIDs = {}

    AddBonusID(bonusIDs, ItemExporter.SeasonBonusIDs.mythicTag)
    AddBonusID(bonusIDs, ItemExporter.SeasonBonusIDs.catalyst)

    if not GetItemLevelOverride() then
        AddBonusID(bonusIDs, ItemExporter.selectedUpgradeBonusID)
    end

    return bonusIDs
end

local function GetSocketBonusIDs(item)
    if item.filterType == "ring1" or item.filterType == "neck" then
        return {ItemExporter.SeasonBonusIDs.socket}
    end

    return nil
end

local function CreateBonusString(item)
    local bonusIDs = GetSeasonBonusIDs()
    local socketBonusIDs = GetSocketBonusIDs(item)
    local bonusString = table.concat(bonusIDs, "/")

    if socketBonusIDs and socketBonusIDs[1] then
        bonusString = bonusString .. "/" .. table.concat(socketBonusIDs, "/")
    end

    return bonusString
end

local function GetSlotOrder(item)
    return filterTypeOrder[item.filterType] or 0
end

local function GetCategoryOrder(item)
    local source = item.source or {}
    local order = {
        raid = 1,
        dungeon = 2,
        tierset = 3,
    }

    return order[source.type] or 99
end

local function GetSourceOrder(item)
    return (item.source and (item.source.sourceOrder or item.source.order)) or 0
end

local function GetDetailOrder(item)
    return (item.source and (item.source.detailOrder or item.source.order)) or 0
end

local function SortItems(itemData, ...)
    local keys = {...}

    table.sort(itemData, function(a, b)
        for _, key in ipairs(keys) do
            local aValue = key(a)
            local bValue = key(b)

            if aValue ~= bValue then
                return aValue < bValue
            end
        end

        return (a.name or "") < (b.name or "")
    end)
end

local function AddBlankLine(lines)
    if lines[1] and lines[#lines] ~= "" then
        table.insert(lines, "")
    end
end

local function AddHeader(lines, text, level)
    if text then
        AddBlankLine(lines)
        table.insert(lines, string.rep("#", level or 2) .. " " .. text)
        table.insert(lines, "")
    end
end

local function AddItem(lines, item)
    local itemLevel = GetItemLevelOverride()
    local itemLevelString = itemLevel and ",ilevel=" .. itemLevel or ""

    AddBlankLine(lines)
    table.insert(lines, "# " .. item.name)
    table.insert(lines, "# " .. item.filterType .. "=,id=" .. item.itemID .. ",bonus_id=" .. CreateBonusString(item) .. itemLevelString)
end

local function AddSlotHeader(lines, item, currentSlot)
    if item.filterType ~= currentSlot then
        AddHeader(lines, item.filterType, 2)
        return item.filterType
    end

    return currentSlot
end

local function GetCategoryHeader(item)
    local source = item.source or {}

    if source.type == "raid" then
        return RAIDS
    elseif source.type == "dungeon" then
        return DUNGEONS
    elseif source.type == "tierset" then
        return "Tier Sets"
    end

    return "Other"
end

local function GetSourceHeader(item)
    local source = item.source or {}

    if source.type == "raid" then
        return source.raidName
    elseif source.type == "dungeon" then
        return source.dungeonName
    elseif source.type == "tierset" then
        return source.tierName or source.tierLabel
    end

    return "Other"
end

local function GetBossHeader(item)
    local source = item.source or {}

    if source.type == "raid" then
        return source.bossName
    end

    return GetSourceHeader(item)
end

local function FormatPerSlot(itemData)
    local lines = {}
    local currentSlot

    SortItems(itemData, GetSlotOrder)

    for _, item in ipairs(itemData) do
        currentSlot = AddSlotHeader(lines, item, currentSlot)
        AddItem(lines, item)
    end

    return lines
end

local function FormatPerCategory(itemData)
    local lines = {}
    local currentCategory
    local currentSlot

    SortItems(itemData, GetCategoryOrder, GetSlotOrder, GetSourceOrder)

    for _, item in ipairs(itemData) do
        local category = GetCategoryHeader(item)

        if category ~= currentCategory then
            currentCategory = category
            currentSlot = nil
            AddHeader(lines, category, 3)
        end

        currentSlot = AddSlotHeader(lines, item, currentSlot)
        AddItem(lines, item)
    end

    return lines
end

local function FormatPerSource(itemData)
    local lines = {}
    local currentSource
    local currentSlot

    SortItems(itemData, GetCategoryOrder, GetSourceOrder, GetSlotOrder)

    for _, item in ipairs(itemData) do
        local sourceHeader = GetSourceHeader(item)

        if sourceHeader ~= currentSource then
            currentSource = sourceHeader
            currentSlot = nil
            AddHeader(lines, sourceHeader, 3)
        end

        currentSlot = AddSlotHeader(lines, item, currentSlot)
        AddItem(lines, item)
    end

    return lines
end

local function FormatPerBoss(itemData)
    local lines = {}
    local currentRaid
    local currentSource
    local currentSlot

    SortItems(itemData, GetCategoryOrder, GetSourceOrder, GetDetailOrder, GetSlotOrder)

    for _, item in ipairs(itemData) do
        local source = item.source or {}
        local raidHeader = source.type == "raid" and source.raidName or GetCategoryHeader(item)
        local sourceHeader = GetBossHeader(item)

        if raidHeader ~= currentRaid then
            currentRaid = raidHeader
            currentSource = nil
            currentSlot = nil
            AddHeader(lines, raidHeader, 4)
        end

        if sourceHeader ~= currentSource then
            currentSource = sourceHeader
            currentSlot = nil
            AddHeader(lines, sourceHeader, 3)
        end

        currentSlot = AddSlotHeader(lines, item, currentSlot)
        AddItem(lines, item)
    end

    return lines
end

local function CreateItemStrings(itemData)
    local formatter = {
        slot = FormatPerSlot,
        category = FormatPerCategory,
        source = FormatPerSource,
        boss = FormatPerBoss,
    }

    local formatItems = formatter[ItemExporter.selectedExportGrouping] or FormatPerSlot
    local text = table.concat(formatItems(itemData), "\n")

    ItemExporter:GetMainFrame(text):Show()
end

function ItemExporter:SortItems(itemData)
    CreateItemStrings(itemData)
end

-- fetch itemIDs function
function ItemExporter.GetItemsForSelectedInstances(selectedDungeons, selectedBosses, ClassSpecInfo, selectedArmorTypes, selectedTierset)
    ItemExporter:DisableEJ()

    local itemData = {}
    local pendingItemLoads = 0
    local collectionComplete = false
    local classFilter, specFilter = EJ_GetLootFilter()
    local slotFilter = EJ_GetSlotFilter and EJ_GetSlotFilter()
    local classID, specID = ClassSpecInfo.classID, ClassSpecInfo.specID

    if EJ_ResetLootFilter then
        EJ_ResetLootFilter()
    end

    EJ_SetLootFilter(classID, specID)

    local function ExportWhenReady()
        if collectionComplete and pendingItemLoads == 0 then
            ItemExporter:SortItems(itemData)
        end
    end

    local function AddItemData(lootInfo, source)
        if not lootInfo or not lootInfo.itemID then
            return
        end

        pendingItemLoads = pendingItemLoads + 1

        local itemID = lootInfo.itemID
        local item = Item:CreateFromItemID(itemID)

        item:ContinueOnItemLoad(function()
            pendingItemLoads = pendingItemLoads - 1

            local itemName, _, _, _, _, _, _, _, itemEquipLoc = C_Item.GetItemInfo(itemID)
            local itemType = invType[itemEquipLoc]

            if itemType and selectedArmorTypes[itemType] and C_Item.IsEquippableItem(itemID) then
                table.insert(itemData, {
                    name = itemName,
                    filterType = filterTypes[itemType],
                    itemID = itemID,
                    source = source,
                })

                if canDualWield(itemType, specID, classID) then
                    table.insert(itemData, {
                        name = itemName,
                        filterType = filterTypes[itemType + 1],
                        itemID = itemID,
                        source = source,
                    })
                end
            end

            ExportWhenReady()
        end)
    end

    for _, dungeon in ipairs(selectedDungeons) do
        EJ_SelectInstance(dungeon.instanceID)
        EJ_SetDifficulty(23)

        for i = 1, EJ_GetNumLoot() do
            AddItemData(C_EncounterJournal.GetLootInfoByIndex(i), {
                type = "dungeon",
                dungeonName = dungeon.name,
                sourceOrder = dungeon.sourceOrder,
                order = dungeon.order,
            })
        end
    end

    for _, boss in ipairs(selectedBosses) do
        EJ_SelectInstance(boss.instanceID)
        EJ_SelectEncounter(boss.encounterID)

        for i = 1, EJ_GetNumLoot() do
            AddItemData(C_EncounterJournal.GetLootInfoByIndex(i), {
                type = "raid",
                raidName = boss.raidName,
                bossName = boss.bossName,
                sourceOrder = boss.sourceOrder,
                detailOrder = boss.order,
            })
        end
    end

    if ItemExporter:GetCurrentClass() == classID then
        for _, tierset in ipairs(selectedTierset) do
            for slot = 1, 15 do
                for _, itemInfo in ipairs(C_TransmogSets.GetSourcesForSlot(tierset.setID, slot)) do
                    AddItemData(itemInfo, {
                        type = "tierset",
                        tierName = tierset.name,
                        tierLabel = tierset.label,
                        sourceOrder = tierset.sourceOrder,
                        order = tierset.order,
                    })
                end
            end
        end
    end

    EJ_SetLootFilter(classFilter, specFilter)
    if slotFilter and EJ_SetSlotFilter then
        EJ_SetSlotFilter(slotFilter)
    end
    ItemExporter:ReEnableEJ()

    collectionComplete = true
    ExportWhenReady()
end
