local _, ItemExporter = ...



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


local CanDualWield = {
	[72] = true,
	[251] = true,
	[577] = true,
	[103] = true,
	[269] = true,
	[259] = true,
	[260] = true,
	[261] = true,
	[263] = true
}




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

function ItemExporter.GetItemsForSelectedInstances(selectedDungeons, selectedBosses, ClassSpecInfo, selectedArmorTypes, selectedTierset)
	ItemExporter:DisableEJ()
	local itemData = {}
	local itemCount = 0
	local itemsLoadedCount = 0
	local classFilter, specFilter = EJ_GetLootFilter()
	local classID, specID = ClassSpecInfo.classID, ClassSpecInfo.specID
	
	-- add items
	local function addItemData(lootInfo)
		if lootInfo and lootInfo.itemID then
			local item = Item:CreateFromItemID(lootInfo.itemID)
			item:ContinueOnItemLoad(function()
					itemsLoadedCount = itemsLoadedCount + 1
					local itemName, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(lootInfo.itemID)
					local itemType = invType[itemEquipLoc]
					if itemType and IsEquippableItem(lootInfo.itemID) and selectedArmorTypes[itemType] then
						table.insert(itemData, {
								name = itemName,
								filterType = filterTypes[itemType],
								itemID = lootInfo.itemID,
						})
						if itemType == 10 and (specID == 0 or CanDualWield[specID]) then
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
	
	-- dungeon items
	for _, instanceID in ipairs(selectedDungeons) do
		EJ_SetLootFilter(classID, specID)
		EJ_SelectInstance(instanceID)
		EJ_SetDifficulty(8)
		local numLoot = EJ_GetNumLoot()
		itemCount = itemCount + numLoot
		for i = 1, numLoot do
			local lootInfo = C_EncounterJournal.GetLootInfoByIndex(i)
			addItemData(lootInfo)
		end
	end
	
	-- raid items
	for instanceID, encounterIDs in pairs(selectedBosses) do
		EJ_SelectInstance(instanceID)
		EJ_SetLootFilter(classID, specID)
		for _, encounterID in ipairs(encounterIDs) do
			EJ_SelectEncounter(encounterID)
			local numLoot = EJ_GetNumLoot()
			itemCount = itemCount + numLoot
			for i = 1, EJ_GetNumLoot() do
				local lootInfo = C_EncounterJournal.GetLootInfoByIndex(i)
				addItemData(lootInfo)
			end
		end
	end
	
	--tier items
	for _, setID in ipairs(selectedTierset) do
		itemCount = itemCount + 9
		for slot=1, 15, 1 do
			for key, itemInfo in ipairs(C_TransmogSets.GetSourcesForSlot(setID, slot)) do
				if key == 1 and itemInfo.itemID then
					addItemData(itemInfo)
				end
			end
		end
	end
	
	EJ_SetLootFilter(classFilter, specFilter)
	ItemExporter:ReEnableEJ()
end

