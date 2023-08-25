local _, ItemExporter = ...

ItemExporter = LibStub("AceAddon-3.0"):NewAddon(ItemExporter, "ItemExporter", "AceConsole-3.0", "AceEvent-3.0")

local LDB = LibStub("LibDataBroker-1.1")
local icon = LibStub("LibDBIcon-1.0")
local AceEvent = LibStub("AceEvent-3.0")

ItemExporter.db = LibStub("AceDB-3.0"):New("ItemExporterDB", {
    profile = {
        minimap = {
            hide = false,
        },
    },
})

-- Slash command
function ItemExporter:OnInitialize()
    self:RegisterChatCommand("itemexport", "ToggleGUI")
end

-- Minimap button
local dataObj = LDB:NewDataObject("ItemExporter", {
    type = "data source",
    text = "ItemExporter",
    icon = "134332",
    OnClick = function()
        ItemExporter:ToggleGUI()
    end,
    OnTooltipShow = function(tooltip)
        tooltip:SetText("ItemExporter")
    end,
})

icon:Register("ItemExporter", dataObj, ItemExporter.db.profile.minimap)

function ItemExporter:ReEnableEJ()
  EncounterJournal:RegisterEvent("EJ_LOOT_DATA_RECIEVED");
  EncounterJournal:RegisterEvent("EJ_DIFFICULTY_UPDATE");
  EncounterJournal:RegisterEvent("UNIT_PORTRAIT_UPDATE");
  EncounterJournal:RegisterEvent("PORTRAITS_UPDATED");
  EncounterJournal:RegisterEvent("SEARCH_DB_LOADED");
  EncounterJournal:RegisterEvent("UI_MODEL_SCENE_INFO_UPDATED");
end
function ItemExporter:DisableEJ()
  EncounterJournal:UnregisterEvent("EJ_LOOT_DATA_RECIEVED");
  EncounterJournal:UnregisterEvent("EJ_DIFFICULTY_UPDATE");
  EncounterJournal:UnregisterEvent("UNIT_PORTRAIT_UPDATE");
  EncounterJournal:UnregisterEvent("PORTRAITS_UPDATED");
  EncounterJournal:UnregisterEvent("SEARCH_DB_LOADED");
  EncounterJournal:UnregisterEvent("UI_MODEL_SCENE_INFO_UPDATED");
end


-- Collect instance info
function ItemExporter:GetLatestContentInfo()
	ItemExporter:DisableEJ()
    local latestTierIndex = EJ_GetNumTiers()
	EJ_SelectTier(latestTierIndex)
    
    local raids = {}
    local dungeons = {}

	-- Collect raids
    local index = 1
    while true do
        local instanceID, name, _, _, _, _, _, _, _, isRaid = EJ_GetInstanceByIndex(index, true)
        if not instanceID then break end
        if isRaid then
			local bosses = {}
            EJ_SelectInstance(instanceID)
			local bossIndex = 1
            while true do
                local bossName, _, encounterID = EJ_GetEncounterInfoByIndex(bossIndex)
                if not bossName then break end
                table.insert(bosses, {name = bossName, encounterID = encounterID})
                bossIndex = bossIndex + 1
            end
            table.insert(raids, {instanceName = name, instanceID = instanceID, bosses = bosses})
        end
        index = index + 1
    end
    
    -- Collcet mythic+ dungeons
    index = 1
    while true do
        local instanceID, name = EJ_GetInstanceByIndex(index, false)
        if not instanceID then break end
        table.insert(dungeons, {instanceName = name, instanceID = instanceID})
        index = index + 1
    end
	ItemExporter:ReEnableEJ()
    return raids, dungeons
end
