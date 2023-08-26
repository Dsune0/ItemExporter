local _, ItemExporter = ...

ItemExporter = LibStub("AceAddon-3.0"):NewAddon(ItemExporter, "ItemExporter", "AceConsole-3.0", "AceEvent-3.0")

local LDB = LibStub("LibDataBroker-1.1")
local icon = LibStub("LibDBIcon-1.0")
local AceEvent = LibStub("AceEvent-3.0")
local L = ItemExporter.L

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
	text = L["ItemExporter"],
	icon = "134332",
	OnClick = function()
		ItemExporter:ToggleGUI()
	end,
	OnTooltipShow = function(tooltip)
		tooltip:SetText(L["ItemExporter"])
	end,
})

--register minimap button
icon:Register("ItemExporter", dataObj, ItemExporter.db.profile.minimap)

-- reenable EJ events
function ItemExporter:ReEnableEJ()
	EncounterJournal:RegisterEvent("EJ_LOOT_DATA_RECIEVED");
	EncounterJournal:RegisterEvent("EJ_DIFFICULTY_UPDATE");
	EncounterJournal:RegisterEvent("UNIT_PORTRAIT_UPDATE");
	EncounterJournal:RegisterEvent("PORTRAITS_UPDATED");
	EncounterJournal:RegisterEvent("SEARCH_DB_LOADED");
	EncounterJournal:RegisterEvent("UI_MODEL_SCENE_INFO_UPDATED");
end

--disable EJ events to prevent taint
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
		if not instanceID then break end
		table.insert(dungeons, {instanceName = name, instanceID = instanceID})
		index = index + 1
	end
	
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
	
	ItemExporter:ReEnableEJ()
	return raids, dungeons, tierset
end



