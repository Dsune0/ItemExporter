local _, ItemExporter = ...
local L = ItemExporter.L
local AceGUI = LibStub("AceGUI-3.0")

-- constants
local armorTypes = ItemExporter.armorTypes

-- locals
local ClassSpecInfo = {classID = 0, specID = 0}
local armorCheckboxes = {}
local contentCheckboxes = {}
local firstRun = false

-- UI helper functions
local function CreateCheckbox(name)
    local checkbox = AceGUI:Create("CheckBox")
    checkbox:SetLabel(name)
    return checkbox
end

local function CreateLabel(name)
    local label = AceGUI:Create("Label")
    label:SetText(name)
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

local function CreateDropdowns(classDropdown, specDropdown)
    local classDropdownValues = ItemExporter.Classes
    local currentClassID = ItemExporter:GetCurrentClass()
    local specializations = ItemExporter:GetSpecializationsByClassID(currentClassID)
    local currentSpecID = ItemExporter:GetCurrentSpecialization()

    ClassSpecInfo = {classID = currentClassID, specID = currentSpecID}

    classDropdown:SetList(classDropdownValues)
    classDropdown:SetValue(currentClassID)
    classDropdown:SetLabel(CLASS)

    specDropdown:SetList(specializations)
    specDropdown:SetValue(currentSpecID)
    specDropdown:SetLabel(SPECIALIZATION)

    classDropdown:SetCallback("OnValueChanged", function(widget, event, key)
        if key and key ~= 0 then
            ClassSpecInfo.classID = key
            local updatedSpecializations = ItemExporter:GetSpecializationsByClassID(key)
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

local function GetUpgradeLevel(trackName, level)
    local track = ItemExporter.UpgradeTracks[trackName]
    local levelIndex = tonumber(level)
    if not track then
        return nil
    end

    return track.levels[levelIndex]
end

local function SetSelectedUpgrade(trackName, level)
    local levelIndex = tonumber(level)
    local upgrade = GetUpgradeLevel(trackName, level)
    if not upgrade then
        return
    end

    ItemExporter.selectedUpgradeTrack = trackName
    ItemExporter.selectedUpgradeLevel = levelIndex
    ItemExporter.selectedUpgradeBonusID = upgrade.bonusID
end

local function GetTrackList()
    local tracks = {}

    for _, trackName in ipairs(ItemExporter.UpgradeTrackOrder) do
        tracks[trackName] = trackName
    end

    return tracks
end

local function GetUpgradeLevelList(trackName)
    local track = ItemExporter.UpgradeTracks[trackName]
    local levels = {}

    if not track then
        return levels
    end

    for _, upgrade in ipairs(track.levels) do
        levels[upgrade.level] = string.format("%s %d/%d (%d)", track.name, upgrade.level, upgrade.max, upgrade.itemLevel)
    end

    return levels
end

local function CreateUpgradeDropdowns()
    local trackDropdown = AceGUI:Create("Dropdown")
    local levelDropdown = AceGUI:Create("Dropdown")

    local function RefreshLevelDropdown(trackName, level)
        if not trackName then
            return
        end

        local selectedLevel = tonumber(level) or ItemExporter.selectedUpgradeLevel
        if not GetUpgradeLevel(trackName, selectedLevel) then
            selectedLevel = 1
        end

        levelDropdown:SetList(GetUpgradeLevelList(trackName))
        levelDropdown:SetValue(selectedLevel)
        SetSelectedUpgrade(trackName, selectedLevel)
    end

    trackDropdown:SetLabel(L["Upgrade Track"])
    trackDropdown:SetList(GetTrackList(), ItemExporter.UpgradeTrackOrder)
    trackDropdown:SetValue(ItemExporter.selectedUpgradeTrack)
    trackDropdown:SetRelativeWidth(0.5)
    trackDropdown:SetCallback("OnValueChanged", function(widget, event, key)
        RefreshLevelDropdown(key)
    end)

    levelDropdown:SetLabel(L["Upgrade Level"])
    levelDropdown:SetRelativeWidth(0.5)
    levelDropdown:SetCallback("OnValueChanged", function(widget, event, key)
        if key then
            SetSelectedUpgrade(ItemExporter.selectedUpgradeTrack, key)
        end
    end)

    RefreshLevelDropdown(ItemExporter.selectedUpgradeTrack, ItemExporter.selectedUpgradeLevel)

    return trackDropdown, levelDropdown
end

local function GetExportGroupingList()
    local groupings = {}

    for _, groupingKey in ipairs(ItemExporter.ExportGroupingOrder) do
        groupings[groupingKey] = ItemExporter.ExportGroupings[groupingKey]
    end

    return groupings
end

local function CreateExportGroupingDropdown()
    local dropdown = AceGUI:Create("Dropdown")

    dropdown:SetLabel(L["Export Grouping"])
    dropdown:SetList(GetExportGroupingList(), ItemExporter.ExportGroupingOrder)
    dropdown:SetValue(ItemExporter.selectedExportGrouping)
    dropdown:SetRelativeWidth(1)
    dropdown:SetCallback("OnValueChanged", function(widget, event, key)
        if key then
            ItemExporter.selectedExportGrouping = key
        end
    end)

    return dropdown
end

local function CreateItemLevelOverrideControls()
    local checkbox = AceGUI:Create("CheckBox")
    local editBox = AceGUI:Create("EditBox")

    local function SetItemLevelOverride(text)
        local itemLevel = tonumber(text)

        if itemLevel and itemLevel > 0 then
            ItemExporter.itemLevelOverride = math.floor(itemLevel)
        elseif text == "" then
            ItemExporter.itemLevelOverride = nil
        end

        return ItemExporter.itemLevelOverride
    end

    checkbox:SetLabel(L["Item Level Override"])
    checkbox:SetValue(ItemExporter.itemLevelOverrideEnabled)
    checkbox:SetRelativeWidth(0.5)
    checkbox:SetCallback("OnValueChanged", function(widget, event, value)
        ItemExporter.itemLevelOverrideEnabled = value and true or false
        editBox:SetDisabled(not ItemExporter.itemLevelOverrideEnabled)
    end)

    editBox:SetLabel(L["Item Level"])
    editBox:SetRelativeWidth(0.5)
    editBox:SetDisabled(not ItemExporter.itemLevelOverrideEnabled)
    editBox:SetText(ItemExporter.itemLevelOverride and tostring(ItemExporter.itemLevelOverride) or "")
    editBox:SetCallback("OnEnterPressed", function(widget, event, text)
        local itemLevel = SetItemLevelOverride(text)
        widget:SetText(itemLevel and tostring(itemLevel) or "")
    end)
    editBox:SetCallback("OnTextChanged", function(widget, event, text)
        SetItemLevelOverride(text)
    end)

    return checkbox, editBox
end

--checkbox toggling
local function ToggleAllCheckboxes(checkboxes)
    if not checkboxes[1] then
        return
    end

    local newState = not checkboxes[1]:GetValue()
    for _, checkbox in ipairs(checkboxes) do
        checkbox:SetValue(newState)
    end
end

-- checkbox creation
local function CreateToggleAllButton(container, text, checkboxes)
    if not checkboxes[1] then
        return
    end

    local button = AceGUI:Create("Button")
    button:SetText(text)
    button:SetRelativeWidth(1)
    button:SetCallback("OnClick", function() ToggleAllCheckboxes(checkboxes) end)
    container:AddChild(button)
end

-- UI draw content functions
local function DrawContent(container, contentData, contentType)
    if not contentData then return end

    if contentType == "raids" then
        for raidIndex, raid in ipairs(contentData) do
            local raidGroup = CreateGroup()
            raidGroup:AddChild(CreateLabel(raid.instanceName))

            for _, boss in ipairs(raid.bosses) do
                local checkbox = CreateCheckbox(boss.name)
                checkbox:SetValue(true)
                checkbox:SetUserData("instanceID", raid.instanceID)
                checkbox:SetUserData("encounterID", boss.encounterID)
                checkbox:SetUserData("raidName", raid.instanceName)
                checkbox:SetUserData("bossName", boss.name)
                checkbox:SetUserData("sourceOrder", raidIndex)
                raidGroup:AddChild(checkbox)
                table.insert(contentCheckboxes, checkbox)
            end
            container:AddChild(raidGroup)
        end

    elseif contentType == "dungeons" then
        local dungeonGroup = CreateGroup()
        dungeonGroup:AddChild(CreateLabel(DUNGEONS))

        for dungeonIndex, dungeon in ipairs(contentData) do
            local checkbox = CreateCheckbox(dungeon.instanceName)
            checkbox:SetValue(true)
            checkbox:SetUserData("instanceID", dungeon.instanceID)
            checkbox:SetUserData("dungeonName", dungeon.instanceName)
            checkbox:SetUserData("sourceOrder", dungeonIndex)
            dungeonGroup:AddChild(checkbox)
            table.insert(contentCheckboxes, checkbox)
        end
        container:AddChild(dungeonGroup)

    elseif contentType == "tierset" then
        for tierIndex, tierset in ipairs(contentData) do
            local tierGroup = CreateGroup()
            tierGroup:AddChild(CreateLabel(tierset.label))
            local checkbox = CreateCheckbox(tierset.name)
            checkbox:SetValue(true)
            checkbox:SetUserData("tierset", tierset.setID)
            checkbox:SetUserData("tierName", tierset.name)
            checkbox:SetUserData("tierLabel", tierset.label)
            checkbox:SetUserData("sourceOrder", tierIndex)
            tierGroup:AddChild(checkbox)
            table.insert(contentCheckboxes, checkbox)
            container:AddChild(tierGroup)
        end

    end
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
    CreateToggleAllButton(container, L["Toggle All"], armorCheckboxes)
end

local function DrawSelectedTab(container, group, raids, dungeons, tierset)
    container:ReleaseChildren()

    local trackDropdown, levelDropdown = CreateUpgradeDropdowns()
    local itemLevelOverrideCheckbox, itemLevelOverrideEditBox = CreateItemLevelOverrideControls()

    container:AddChild(trackDropdown)
    container:AddChild(levelDropdown)
    container:AddChild(itemLevelOverrideCheckbox)
    container:AddChild(itemLevelOverrideEditBox)
    container:AddChild(CreateExportGroupingDropdown())

    contentCheckboxes = {}

    if group == "all" or group == "raids" then
        DrawContent(container, raids, "raids")
    end

    if group == "all" or group == "dungeons" then
        DrawContent(container, dungeons, "dungeons")
    end

    if group == "all" or group == "tierset" then
        DrawContent(container, tierset, "tierset")
    end

    if group == "all" or group == "raids" or group == "dungeons" then
        CreateToggleAllButton(container, L["Toggle All"], contentCheckboxes)
    end
end

local function CreateTabGroup(raids, dungeons, tierset)
    local tabGroup = AceGUI:Create("TabGroup")
    tabGroup:SetFullWidth(true)
    tabGroup:SetFullHeight(true)
    tabGroup:SetLayout("Flow")
    tabGroup:SetTabs({
        {text = ALL, value = "all"},
        {text = RAIDS, value = "raids"},
        {text = DUNGEONS, value = "dungeons"},
        {text = L["Tierset"], value = "tierset"},
    })

    tabGroup:SetCallback("OnGroupSelected", function(container, event, group)
        DrawSelectedTab(container, group, raids, dungeons, tierset)
    end)
    return tabGroup
end

-- editbox creation
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
            if ItemExportEditBox then
                ItemExportEditBox:SetFocus()
            end
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
        eb:SetScript("OnEditFocusGained", function(self) self:EnableKeyboard(true) end)
        eb:SetScript("OnEditFocusLost", function(self) self:EnableKeyboard(false) end)
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
                self:GetHighlightTexture():Hide()
            end
        end)
        rb:SetScript("OnMouseUp", function(self, _) -- luacheck: ignore
            f:StopMovingOrSizing()
            self:GetHighlightTexture():Show()
            eb:SetWidth(sf:GetWidth())
            eb:SetFocus()
        end)

        ItemExportFrame = f
    end

    ItemExportEditBox:SetText(text)
    ItemExportEditBox:HighlightText()
    ItemExportEditBox:Raise()
    return ItemExportFrame
end

-- export button function
local function ExportButton()
    local selectedDungeons = {}
    local selectedBosses = {}
    local selectedArmorTypes = {}
    local selectedTierset = {}

    for _, checkbox in ipairs(contentCheckboxes) do
        if checkbox:GetValue() then
            local instanceID = checkbox:GetUserData("instanceID")
            local encounterID = checkbox:GetUserData("encounterID")
            local setID = checkbox:GetUserData("tierset")

            if setID then
                table.insert(selectedTierset, {
                    setID = setID,
                    name = checkbox:GetUserData("tierName"),
                    label = checkbox:GetUserData("tierLabel"),
                    sourceOrder = checkbox:GetUserData("sourceOrder"),
                    order = #selectedTierset + 1,
                })
            elseif encounterID then
                table.insert(selectedBosses, {
                    instanceID = instanceID,
                    encounterID = encounterID,
                    raidName = checkbox:GetUserData("raidName"),
                    bossName = checkbox:GetUserData("bossName"),
                    sourceOrder = checkbox:GetUserData("sourceOrder"),
                    order = #selectedBosses + 1,
                })
            elseif instanceID then
                table.insert(selectedDungeons, {
                    instanceID = instanceID,
                    name = checkbox:GetUserData("dungeonName"),
                    sourceOrder = checkbox:GetUserData("sourceOrder"),
                    order = #selectedDungeons + 1,
                })
            end
        end
    end

    for _, checkbox in ipairs(armorCheckboxes) do
        if checkbox:GetValue() then
            local armorType = checkbox:GetUserData("armorType")
            selectedArmorTypes[armorType] = true
        end
    end

    ItemExporter.GetItemsForSelectedInstances(selectedDungeons, selectedBosses, ClassSpecInfo, selectedArmorTypes, selectedTierset)
    if not firstRun then
        firstRun = true
        C_Timer.After(0.1, function()
            ItemExporter.GetItemsForSelectedInstances(selectedDungeons, selectedBosses, ClassSpecInfo, selectedArmorTypes, selectedTierset)
        end)
    end
end

-- UI toggle function
function ItemExporter:ToggleGUI()
    if not select(2, C_AddOns.IsAddOnLoaded("Blizzard_EncounterJournal")) then
        C_AddOns.LoadAddOn("Blizzard_EncounterJournal")
    end

    if not self.frame then
        local raids, dungeons, tierset = self:GetLatestContentInfo()
        self.frame = AceGUI:Create("Frame")
        self.frame:SetTitle(L["ItemExporter"])
        self.frame:SetStatusText(L["Export itemstrings to SimulationCraft format"])
        self.frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) self.frame = nil end)
        self.frame:SetWidth(800)
        self.frame:SetHeight(1000)
        self.frame:SetLayout("Flow")

        local classDropdown = AceGUI:Create("Dropdown")
        local specDropdown = AceGUI:Create("Dropdown")
        CreateDropdowns(classDropdown, specDropdown)

        local exportButton = AceGUI:Create("Button")
        exportButton:SetText(L["Export"])
        exportButton:SetWidth(200)
        exportButton:SetCallback("OnClick", ExportButton)

        local tabGroup = CreateTabGroup(raids, dungeons, tierset)

        self.frame:AddChild(classDropdown)
        self.frame:AddChild(specDropdown)
        self.frame:AddChild(exportButton)
        DrawArmorTypes(self.frame)
        self.frame:AddChild(tabGroup)
        tabGroup:SelectTab("all")

        self.frame.frame:SetResizeBounds(500, 840)
        self.frame.frame:SetClampedToScreen(true)
        if InCombatLockdown() then
            self.frame.frame:EnableKeyboard(false)
        else
            self.frame.frame:SetPropagateKeyboardInput(true)
            self.frame.frame:SetScript("OnKeyDown", function(self, key)
                if key == "ESCAPE" and self:GetFrameLevel() == 100 then
                    if not InCombatLockdown() then
                        self:SetPropagateKeyboardInput(false)
                    end

                    AceGUI:Release(ItemExporter.frame)
                end
            end)
        end
    else
        AceGUI:Release(self.frame)
    end
end

