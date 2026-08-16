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
            {level = 1, max = 6, bonusID = 12817, itemLevel = 266},
            {level = 2, max = 6, bonusID = 12818, itemLevel = 269},
            {level = 3, max = 6, bonusID = 12819, itemLevel = 272},
            {level = 4, max = 6, bonusID = 12820, itemLevel = 276},
            {level = 5, max = 6, bonusID = 12821, itemLevel = 279},
            {level = 6, max = 6, bonusID = 12822, itemLevel = 282},
        },
    },
    Veteran = {
        name = "Veteran",
        levels = {
            {level = 1, max = 6, bonusID = 12825, itemLevel = 279},
            {level = 2, max = 6, bonusID = 12826, itemLevel = 282},
            {level = 3, max = 6, bonusID = 12827, itemLevel = 285},
            {level = 4, max = 6, bonusID = 12828, itemLevel = 289},
            {level = 5, max = 6, bonusID = 12829, itemLevel = 292},
            {level = 6, max = 6, bonusID = 12830, itemLevel = 295},
        },
    },
    Champion = {
        name = "Champion",
        levels = {
            {level = 1, max = 6, bonusID = 12833, itemLevel = 292},
            {level = 2, max = 6, bonusID = 12834, itemLevel = 295},
            {level = 3, max = 6, bonusID = 12835, itemLevel = 298},
            {level = 4, max = 6, bonusID = 12836, itemLevel = 302},
            {level = 5, max = 6, bonusID = 12837, itemLevel = 305},
            {level = 6, max = 6, bonusID = 12838, itemLevel = 308},
        },
    },
    Hero = {
        name = "Hero",
        levels = {
            {level = 1, max = 6, bonusID = 12841, itemLevel = 305},
            {level = 2, max = 6, bonusID = 12842, itemLevel = 308},
            {level = 3, max = 6, bonusID = 12843, itemLevel = 311},
            {level = 4, max = 6, bonusID = 12844, itemLevel = 315},
            {level = 5, max = 6, bonusID = 12845, itemLevel = 318},
            {level = 6, max = 6, bonusID = 12846, itemLevel = 321},
        },
    },
    Myth = {
        name = "Myth",
        levels = {
            {level = 1, max = 6, bonusID = 12849, itemLevel = 318},
            {level = 2, max = 6, bonusID = 12850, itemLevel = 321},
            {level = 3, max = 6, bonusID = 12851, itemLevel = 324},
            {level = 4, max = 6, bonusID = 12852, itemLevel = 328},
            {level = 5, max = 6, bonusID = 12853, itemLevel = 331},
            {level = 6, max = 6, bonusID = 12854, itemLevel = 334},
        },
    },
}

ItemExporter.selectedUpgradeTrack = "Myth"
ItemExporter.selectedUpgradeLevel = 6
ItemExporter.selectedUpgradeBonusID = 12854
ItemExporter.selectedExportGrouping = "slot"
ItemExporter.itemLevelOverrideEnabled = false
ItemExporter.itemLevelOverride = nil

ItemExporter.SeasonBonusIDs = {
    quality = 4786,
    mythicTag = 4800,
    catalyst = 13662,
    socket = 13750,
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

local function GetBaseBonusIDs(item)
    local bonusIDs = {}
    local source = item.source or {}

    if source.type == "tierset" then
        if not GetItemLevelOverride() then
            AddBonusID(bonusIDs, ItemExporter.selectedUpgradeBonusID)
        end

        AddBonusID(bonusIDs, ItemExporter.SeasonBonusIDs.catalyst)
    else
        AddBonusID(bonusIDs, ItemExporter.SeasonBonusIDs.quality)

        local socketBonusIDs = GetSocketBonusIDs(item)
        if socketBonusIDs then
            for _, bonusID in ipairs(socketBonusIDs) do
                AddBonusID(bonusIDs, bonusID)
            end
        end

        if not GetItemLevelOverride() then
            AddBonusID(bonusIDs, ItemExporter.selectedUpgradeBonusID)
        end
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
    local bonusIDs = GetBaseBonusIDs(item)
    local bonusString = table.concat(bonusIDs, "/")

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
