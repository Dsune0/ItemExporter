local _, ItemExporter = ...

local AceGUI = LibStub("AceGUI-3.0")

local armorCheckboxes, instanceCheckboxes = {}, {}
local armorTypes = ItemExporter.armorTypes
local ClassSpecInfo = {}
local firstRun
ItemExporter.selectedItemLevel = 447

local function CreateCheckbox(name)
	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetLabel(name)
	return checkbox
end

local function CreateLabel(Name)
    local label = AceGUI:Create("Label")
    label:SetText(Name)
	label:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
    label:SetColor(1, 0.7, 0)
    label:SetFullWidth(true)
    return label
end

local function CreateGroup()
	local group = AceGUI:Create("SimpleGroup")
    group:SetLayout("Flow")
    group:SetFullWidth(true)
	return group
end

local function DrawContent(container, contentData, contentType)
    if not contentData then return end

    if contentType == "raids" then
        for _, raid in pairs(contentData) do
            local raidGroup = CreateGroup()
            raidGroup:AddChild(CreateLabel(raid.instanceName))

            for _, boss in ipairs(raid.bosses) do
                local checkbox = CreateCheckbox(boss.name)
                checkbox:SetValue(true)
                checkbox:SetUserData("instanceID", raid.instanceID)
                checkbox:SetUserData("encounterID", boss.encounterID)
                raidGroup:AddChild(checkbox)
                table.insert(instanceCheckboxes, checkbox)
            end

            container:AddChild(raidGroup)
        end
    elseif contentType == "dungeons" then
        local dungeonGroup = CreateGroup()
        dungeonGroup:AddChild(CreateLabel(DUNGEONS))

        for _, dungeon in pairs(contentData) do
            local checkbox = CreateCheckbox(dungeon.instanceName)
            checkbox:SetValue(true)
            checkbox:SetUserData("instanceID", dungeon.instanceID)
            dungeonGroup:AddChild(checkbox)
            table.insert(instanceCheckboxes, checkbox)
        end

        container:AddChild(dungeonGroup)
    end
end

local function ToggleAllCheckboxes(checkboxes)
    local newState = not checkboxes[1]:GetValue()
    for _, checkbox in ipairs(checkboxes) do
        checkbox:SetValue(newState)
	end
end

local function CreateToggleAllButton(container, text, checkboxes)
	local button = AceGUI:Create("Button")
	button:SetText(text)
	button:SetRelativeWidth(1)
	button:SetCallback("OnClick", function() ToggleAllCheckboxes(checkboxes) end)
	container:AddChild(button)
end

local function CreateDropdowns(classDropdown, specDropdown)
    local classDropdownValues = ItemExporter.Classes
    local currentClassID = ItemExporter:GetCurrentClass()
    local currentClass = ItemExporter:GetClassNameByID(currentClassID)
    local specializations = ItemExporter:GetSpecializationsByClass(currentClass)
	local currentSpecID = ItemExporter:GetCurrentSpecialization()
    
	ClassSpecInfo = {classID = currentClassID, specID = currentSpecID}
	
    classDropdown:SetList(classDropdownValues)
    classDropdown:SetValue(currentClassID)
    classDropdown:SetLabel(CLASS)
    
    specDropdown:SetList(specializations)
	specDropdown:SetValue(currentSpecID)
    specDropdown:SetLabel(SPECIALIZATION)
    
	classDropdown:SetCallback("OnValueChanged", function(widget, event, key)
        local selectedClass = ItemExporter:GetClassNameByID(key)
        if selectedClass and selectedClass ~= "All" then
			ClassSpecInfo.classID = key
            local updatedSpecializations = ItemExporter:GetSpecializationsByClass(selectedClass)
            specDropdown:SetList(updatedSpecializations)
            specDropdown:SetValue(0)
            specDropdown:SetDisabled(false)
			ClassSpecInfo.specID = 0
        else
			ClassSpecInfo.classID = 0
			ClassSpecInfo.specID = 0
            specDropdown:SetDisabled(true)
			specDropdown:SetValue(0)
        end
    end)
	
	specDropdown:SetCallback("OnValueChanged", function(widget, event, key)
        if ClassSpecInfo.specID then
			ClassSpecInfo.specID = key
		end
    end)
	
end

local function DrawArmorTypes(container)
	armorCheckboxes = {}
    for i, armorType in ipairs(armorTypes) do
        local checkbox = CreateCheckbox(armorType)
		checkbox:SetValue(true)
		checkbox:SetUserData("armorType", i-1)
        container:AddChild(checkbox)
        table.insert(armorCheckboxes, checkbox)
    end
	CreateToggleAllButton(container, "Toggle All Armortypes", armorCheckboxes)
end

local function CreateItemLevelSlider()
    local slider = AceGUI:Create("Slider")
    slider:SetLabel(STAT_AVERAGE_ITEM_LEVEL)
    slider:SetSliderValues(402, 450, 1)
    slider:SetValue(447)
	slider:SetCallback("OnValueChanged", function(self, event, value)
	ItemExporter.selectedItemLevel = value
    end)
    return slider
end


local function CreateTabGroup(raids, dungeons)
    local tabGroup = AceGUI:Create("TabGroup")
    tabGroup:SetFullWidth(true)
    tabGroup:SetFullHeight(true)
    tabGroup:SetLayout("Flow")
    tabGroup:SetTabs({
        {text = ALL, value = "all"}, 
        {text = RAIDS, value = "raids"}, 
        {text = DUNGEONS, value = "dungeons"},
    })
		
    tabGroup:SetCallback("OnGroupSelected", function(container, event, group)
        container:ReleaseChildren()
		local itemLevelSlider = CreateItemLevelSlider()
		container:AddChild(itemLevelSlider)
        instanceCheckboxes = {}
        if group == "all" then
            DrawContent(container, raids, "raids")
            DrawContent(container, dungeons, "dungeons")
        elseif group == "raids" then
            DrawContent(container, raids, "raids")
        elseif group == "dungeons" then
            DrawContent(container, dungeons, "dungeons")
        end
		CreateToggleAllButton(container, "Toggle All Instances", instanceCheckboxes)
    end)

    return tabGroup
end



function ItemExporter:GetMainFrame(text)
	--based on simulationcrafts editbox
  if not ItemExportFrame then
    local f = CreateFrame("Frame", "ItemExportFrame", UIParent, "DialogBoxFrame")
	f:SetFrameStrata("FULLSCREEN_DIALOG")
    f:ClearAllPoints()
    f:SetPoint("CENTER")
    f:SetSize(600, 600)
    f:SetBackdrop({
      bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
      edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
      edgeSize = 16,
      insets = { left = 8, right = 8, top = 8, bottom = 8 },
    })
    f:SetMovable(true)
    f:SetClampedToScreen(true)
    f:SetScript("OnMouseDown", function(self, button) -- luacheck: ignore
      if button == "LeftButton" then
        self:StartMoving()
      end
    end)
    f:SetScript("OnMouseUp", function(self, _) -- luacheck: ignore
      self:StopMovingOrSizing()
    end)

    -- scroll frame
    local sf = CreateFrame("ScrollFrame", "ItemExportScrollFrame", f, "UIPanelScrollFrameTemplate")
    sf:SetPoint("LEFT", 16, 0)
    sf:SetPoint("RIGHT", -32, 0)
    sf:SetPoint("TOP", 0, -32)
    sf:SetPoint("BOTTOM", ItemExportFrameButton, "TOP", 0, 0)

    -- edit box
    local eb = CreateFrame("EditBox", "ItemExportEditBox", ItemExportScrollFrame)
    eb:SetSize(sf:GetSize())
    eb:SetMultiLine(true)
    eb:SetAutoFocus(true)
    eb:SetFontObject("ChatFontNormal")
    eb:SetScript("OnEscapePressed", function() f:Hide() end)
    sf:SetScrollChild(eb)

    -- resizing
    f:SetResizable(true)
	f:SetResizeBounds(150, 100, nil, nil)
    local rb = CreateFrame("Button", "ItemExportResizeButton", f)
    rb:SetPoint("BOTTOMRIGHT", -6, 7)
    rb:SetSize(16, 16)

    rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

    rb:SetScript("OnMouseDown", function(self, button) -- luacheck: ignore
        if button == "LeftButton" then
            f:StartSizing("BOTTOMRIGHT")
            self:GetHighlightTexture():Hide() -- more noticeable
        end
    end)
    rb:SetScript("OnMouseUp", function(self, _) -- luacheck: ignore
        f:StopMovingOrSizing()
        self:GetHighlightTexture():Show()
        eb:SetWidth(sf:GetWidth())
    end)

    ItemExportFrame = f
  end
  ItemExportEditBox:SetText(text)
  ItemExportEditBox:HighlightText()
  ItemExportEditBox:Raise()
  return ItemExportFrame
end

local function ExportButton()
    local selectedDungeons = {}
    local selectedBosses = {}
	local selectedArmorTypes = {}
	
    for _, checkbox in ipairs(instanceCheckboxes) do
        if checkbox:GetValue() then
            local instanceID = checkbox:GetUserData("instanceID")
            local encounterID = checkbox:GetUserData("encounterID")
            
            if encounterID then
                if not selectedBosses[instanceID] then
                    selectedBosses[instanceID] = {}
                end
                table.insert(selectedBosses[instanceID], encounterID)
            else
                table.insert(selectedDungeons, instanceID)
            end
        end
    end
	
	for _, checkbox in ipairs(armorCheckboxes) do
        if checkbox:GetValue() then
			local armorType = checkbox:GetUserData("armorType")
			selectedArmorTypes[armorType] = true
		end
    end

    ItemExporter.GetItemsForSelectedInstances(selectedDungeons, selectedBosses, ClassSpecInfo, selectedArmorTypes)
	if not firstRun then
		firstRun = true
		C_Timer.After(0.1, function() ItemExporter.GetItemsForSelectedInstances(selectedDungeons, selectedBosses, ClassSpecInfo, selectedArmorTypes)end)
	end
end


function ItemExporter:ToggleGUI()
    if not self.frame then
        local raids, dungeons = self:GetLatestContentInfo()
        self.frame = AceGUI:Create("Frame")
        self.frame:SetTitle("ItemExporter")
        self.frame:SetStatusText("Export items to SimulationCraft")
        self.frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) self.frame = nil end)
		self.frame:SetCallback("OnEscapePressed", function(widget) AceGUI:Release(widget) self.frame = nil end)
        self.frame:SetWidth(645)
        self.frame:SetHeight(745)
        self.frame:SetLayout("Flow")

        local classDropdown = AceGUI:Create("Dropdown")
        local specDropdown = AceGUI:Create("Dropdown")
        CreateDropdowns(classDropdown, specDropdown)
		
        local exportButton = AceGUI:Create("Button")
        exportButton:SetText("Export")
        exportButton:SetWidth(200)
        exportButton:SetCallback("OnClick", ExportButton)
		
		local tabGroup = CreateTabGroup(raids, dungeons)
		
		self.frame:AddChild(classDropdown)
		self.frame:AddChild(specDropdown)
		self.frame:AddChild(exportButton)
		DrawArmorTypes(self.frame)
		self.frame:AddChild(tabGroup)
		tabGroup:SelectTab("all")
        
    else
        AceGUI:Release(self.frame)
        self.frame = nil
    end
end