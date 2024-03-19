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
	local latestTierIndex = EJ_GetNumTiers()-1
	EJ_SelectTier(latestTierIndex)
	
	local raids = {}
	local dungeons = {}
	local tierset = {}
	
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
	
	-- Collect mythic+ dungeons
	index = 1
	while true do
		local instanceID, name = EJ_GetInstanceByIndex(index, false)
        -- remove Dawn
		if not instanceID or instanceID == 1209 then break end
		table.insert(dungeons, {instanceName = name, instanceID = instanceID})
		index = index + 1
	end
	
	-- Collect tierset ID
    for _, info in pairs(C_TransmogSets.GetBaseSets()) do
        for _, raid in ipairs(raids) do		
            if info.label and raid.instanceName and info.label == raid.instanceName then
                -- Create a new table for each match and insert it into tiersets
                local match = {
                    setID = info.setID,
                    name = info.name,
                    label = raid.instanceName
                }
                table.insert(tierset, match)
            end
        end
    end
	
	ItemExporter:ReEnableEJ()
	return raids, dungeons, tierset
end