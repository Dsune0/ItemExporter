local _, ItemExporter = ...

ItemExporter = LibStub("AceAddon-3.0"):NewAddon(ItemExporter, "ItemExporter", "AceConsole-3.0", "AceEvent-3.0")

local LDB = LibStub("LibDataBroker-1.1")
local icon = LibStub("LibDBIcon-1.0")
local L = ItemExporter.L
local ICON_TEXTURE = "134332"

local ExcludedInstanceIDs = {
    [1319] = true, -- Generic Mythic Keystone dungeon; seasonal affixes only, no loot.
}

local dataObject = LDB:NewDataObject("ItemExporter", {
    type = "data source",
    text = L["ItemExporter"],
    label = L["ItemExporter"],
    icon = ICON_TEXTURE,
    OnClick = function()
        ItemExporter:ToggleGUI()
    end,
    OnTooltipShow = function(tooltip)
        tooltip:SetText(L["ItemExporter"])
    end,
})

-- Slash command + Addon compartment
function ItemExporter:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("ItemExporterDB", {
        profile = {
            minimap = {
                hide = false,
            },
        },
    })

    icon:Register("ItemExporter", dataObject, self.db.profile.minimap)
    self:RegisterChatCommand("itemexport", "ToggleGUI")

    if AddonCompartmentFrame then
        AddonCompartmentFrame:RegisterAddon({
            text = L["ItemExporter"],
            icon = ICON_TEXTURE,
            notCheckable = true,
            func = function()
                ItemExporter:ToggleGUI()
            end,
        })
    end
end

local EJEvents = {
    "EJ_LOOT_DATA_RECIEVED",
    "EJ_DIFFICULTY_UPDATE",
    "UNIT_PORTRAIT_UPDATE",
    "PORTRAITS_UPDATED",
    "SEARCH_DB_LOADED",
    "UI_MODEL_SCENE_INFO_UPDATED"
}

function ItemExporter:DisableEJ()
    if not EncounterJournal then
        return
    end

    for _, event in ipairs(EJEvents) do
        EncounterJournal:UnregisterEvent(event)
    end
end

function ItemExporter:ReEnableEJ()
    if not EncounterJournal then
        return
    end

    for _, event in ipairs(EJEvents) do
        EncounterJournal:RegisterEvent(event)
    end
end

function ItemExporter:GetLatestContentInfo()
    self:DisableEJ()

    local latestTierIndex = EJ_GetNumTiers()
    EJ_SelectTier(latestTierIndex)

    local raids = {}
    local dungeons = {}
    local tierset = {}

    local index = 1
    while true do
        local instanceID, name, _, _, _, _, _, _, _, isRaid = EJ_GetInstanceByIndex(index, true)
        if not instanceID then
            break
        end

        if isRaid then
            local bosses = {}

            EJ_SelectInstance(instanceID)

            local bossIndex = 1
            while true do
                local bossName, _, encounterID = EJ_GetEncounterInfoByIndex(bossIndex)
                if not bossName then
                    break
                end

                table.insert(bosses, {name = bossName, encounterID = encounterID})
                bossIndex = bossIndex + 1
            end

            table.insert(raids, {instanceName = name, instanceID = instanceID, bosses = bosses})
        end

        index = index + 1
    end

    index = 1
    while true do
        local instanceID, name = EJ_GetInstanceByIndex(index, false)
        if not instanceID then
            break
        end

        if not ExcludedInstanceIDs[instanceID] then
            table.insert(dungeons, {instanceName = name, instanceID = instanceID})
        end

        index = index + 1
    end

    for _, info in pairs(C_TransmogSets.GetBaseSets()) do
        for _, raid in ipairs(raids) do
            if info.label and raid.instanceName and info.label == raid.instanceName then
                table.insert(tierset, {
                    setID = info.setID,
                    name = info.name,
                    label = raid.instanceName
                })
            end
        end
    end

    self:ReEnableEJ()

    return raids, dungeons, tierset
end
