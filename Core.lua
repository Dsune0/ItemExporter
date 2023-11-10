local _, ItemExporter = ...

-- libs
ItemExporter = LibStub("AceAddon-3.0"):NewAddon(ItemExporter, "ItemExporter", "AceConsole-3.0", "AceEvent-3.0")
local LDB = LibStub("LibDataBroker-1.1")
local icon = LibStub("LibDBIcon-1.0")
local AceEvent = LibStub("AceEvent-3.0")
local L = ItemExporter.L

-- Minimap button
local dataObject = LDB:NewDataObject("ItemExporter", {
    type = "data source",
    text = L["ItemExporter"],
    label = L["ItemExporter"],
    icon = "134332",
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

    AddonCompartmentFrame:RegisterAddon({
        text = L["ItemExporter"],
        icon = "134332",
        notCheckable = true,
        func = function()
            ItemExporter:ToggleGUI()
        end,
      })
end

-- EJ events
local EJEvents = {
    "EJ_LOOT_DATA_RECIEVED",
    "EJ_DIFFICULTY_UPDATE",
    "UNIT_PORTRAIT_UPDATE",
    "PORTRAITS_UPDATED",
    "SEARCH_DB_LOADED",
    "UI_MODEL_SCENE_INFO_UPDATED"
}

-- prevent taint if user is using EJ
function ItemExporter:DisableEJ()
    for _, event in ipairs(EJEvents) do
        EncounterJournal:UnregisterEvent(event)
    end
end

-- enable EJ after we're done
function ItemExporter:ReEnableEJ()
    for _, event in ipairs(EJEvents) do
        EncounterJournal:RegisterEvent(event)
    end
end



-- Collect instance info
function ItemExporter:GetLatestContentInfo()
	ItemExporter:DisableEJ()
	local latestTierIndex = EJ_GetNumTiers() - 1
	EJ_SelectTier(latestTierIndex)
	
	local raids = {}
	local dungeons = {}
	local tierset = {}
	
	-- Collect raids
	local instanceID, name, _, _, _, _, _, _, _, isRaid = EJ_GetInstanceByIndex(4, true)
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
	
	
	-- Collect tierset ID
	for _,info in pairs(C_TransmogSets.GetBaseSets()) do
		for _,raid in ipairs(raids) do
			if info.label and raid.instanceName and info.label == raid.instanceName then
				tierset.setID = info.setID
				tierset.name = info.name
				tierset.label = L["Tierset"]
			end
		end
	end
	
	-- temporary dawn of the infinite
    local name = EJ_GetInstanceInfo(1209)
    table.insert(dungeons, {instanceName = name, instanceID = 1209})

    -- temporary Atal'Dazar
    local name = EJ_GetInstanceInfo(968)
    table.insert(dungeons, {instanceName = name, instanceID = 968})

    -- temporary Waycrest Manor	
    local name = EJ_GetInstanceInfo(1021)
    table.insert(dungeons, {instanceName = name, instanceID = 1021})

    -- temporary Blackrook Hold	
    local name = EJ_GetInstanceInfo(740)
    table.insert(dungeons, {instanceName = name, instanceID = 740})

    -- temporary Darkheart Thicket	
    local name = EJ_GetInstanceInfo(762)
    table.insert(dungeons, {instanceName = name, instanceID = 762})

    -- temporary Everbloom	
    local name = EJ_GetInstanceInfo(556)
    table.insert(dungeons, {instanceName = name, instanceID = 556})

    -- temporary Throne of the Tides	
    local name = EJ_GetInstanceInfo(65)
    table.insert(dungeons, {instanceName = name, instanceID = 65})
    
    
	ItemExporter:ReEnableEJ()
	return raids, dungeons, tierset
end



