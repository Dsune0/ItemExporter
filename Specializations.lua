local _, ItemExporter = ...


local classLootIndex = {
    [1] = "WARRIOR",
    [2] = "PALADIN",
    [3] = "HUNTER",
    [4] = "ROGUE",
    [5] = "PRIEST",
    [6] = "DEATHKNIGHT",
    [7] = "SHAMAN",
    [8] = "MAGE",
    [9] = "WARLOCK",
    [10] = "MONK",
    [11] = "DRUID",
    [12] = "DEMONHUNTER",
    [13] = "EVOKER"
}

ItemExporter.Classes = {}
ItemExporter.Classes[0] = ALL

for key, classKey in pairs(classLootIndex) do
    ItemExporter.Classes[key] = LOCALIZED_CLASS_NAMES_MALE[classKey]
end

ItemExporter.Specializations = {
    [1] = {
        [71] = "Arms",
        [72] = "Fury",
        [73] = "Protection"
    },
    [2] = {
        [65] = "Holy",
        [66] = "Protection",
        [70] = "Retribution"
    },
    [3] = {
        [253] = "Beast Mastery",
        [254] = "Marksmanship",
        [255] = "Survival"
    },
    [4] = {
        [259] = "Assassination",
        [260] = "Outlaw",
        [261] = "Subtlety"
    },
    [5] = {
        [256] = "Discipline",
        [257] = "Holy",
        [258] = "Shadow"
    },
    [6] = {
        [250] = "Blood",
        [251] = "Frost",
        [252] = "Unholy"
    },
    [7] = {
        [262] = "Elemental",
        [263] = "Enhancement",
        [264] = "Restoration"
    },
    [8] = {
        [62] = "Arcane",
        [63] = "Fire",
        [64] = "Frost"
    },
    [9] = {
        [265] = "Affliction",
        [266] = "Demonology",
        [267] = "Destruction"
    },
    [10] = {
        [268] = "Brewmaster",
		[269] = "Windwalker",
        [270] = "Mistweaver",
    },
    [11] = {
        [102] = "Balance",
        [103] = "Feral",
        [104] = "Guardian",
        [105] = "Restoration"
    },
    [12] = {
        [577] = "Havoc",
        [581] = "Vengeance"
    },
    [13] = {
        [1467] = "Devastation",
        [1468] = "Preservation",
        [1473] = "Augmentation"
    },
}

function ItemExporter:GetCurrentSpecialization()
	local specID = (GetSpecializationInfo(GetSpecialization()))
    return specID
end

function ItemExporter:GetSpecializationsByClassID(classID)
	local specNames = {}
	for key, name in pairs(self.Specializations[classID]) do
		specNames[key] = GetSpecializationNameForSpecID(key)
	end
    return specNames
end

function ItemExporter:GetClassNameByID(classID)
    return self.Classes[classID]
end

function ItemExporter:GetCurrentClass()
	local classID = select(3, UnitClass("player"))
	return classID
end