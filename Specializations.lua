ItemExporter = ItemExporter or {}

ItemExporter.Classes = {
	[0] = "All",
    [1] = "Warrior",
    [2] = "Paladin",
    [3] = "Hunter",
    [4] = "Rogue",
    [5] = "Priest",
    [6] = "Death Knight",
    [7] = "Shaman",
    [8] = "Mage",
    [9] = "Warlock",
    [10] = "Monk",
    [11] = "Druid",
    [12] = "Demon Hunter",
    [13] = "Evoker"
}

ItemExporter.Specializations = {
    ["Death Knight"] = {
        [250] = "Blood",
        [251] = "Frost",
        [252] = "Unholy"
    },
    ["Demon Hunter"] = {
        [577] = "Havoc",
        [581] = "Vengeance"
    },
    ["Druid"] = {
        [102] = "Balance",
        [103] = "Feral",
        [104] = "Guardian",
        [105] = "Restoration"
    },
    ["Evoker"] = {
        [1467] = "Devastation",
        [1468] = "Preservation",
        [1473] = "Augmentation"
    },
    ["Hunter"] = {
        [253] = "Beast Mastery",
        [254] = "Marksmanship",
        [255] = "Survival"
    },
    ["Mage"] = {
        [62] = "Arcane",
        [63] = "Fire",
        [64] = "Frost"
    },
    ["Monk"] = {
        [268] = "Brewmaster",
        [270] = "Mistweaver",
        [269] = "Windwalker"
    },
    ["Paladin"] = {
        [65] = "Holy",
        [66] = "Protection",
        [70] = "Retribution"
    },
    ["Priest"] = {
        [256] = "Discipline",
        [257] = "Holy",
        [258] = "Shadow"
    },
    ["Rogue"] = {
        [259] = "Assassination",
        [260] = "Outlaw",
        [261] = "Subtlety"
    },
    ["Shaman"] = {
        [262] = "Elemental",
        [263] = "Enhancement",
        [264] = "Restoration"
    },
    ["Warlock"] = {
        [265] = "Affliction",
        [266] = "Demonology",
        [267] = "Destruction"
    },
    ["Warrior"] = {
        [71] = "Arms",
        [72] = "Fury",
        [73] = "Protection"
    }
}

function ItemExporter:GetCurrentSpecialization()
	local specID = (GetSpecializationInfo(GetSpecialization()))
    return specID
end

function ItemExporter:GetSpecializationsByClass(classID)
    return self.Specializations[classID]
end

function ItemExporter:GetClassNameByID(classID)
    return self.Classes[classID]
end

function ItemExporter:GetCurrentClass()
	local classID = select(3, UnitClass("player"))
	return classID
end