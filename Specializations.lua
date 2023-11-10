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

ItemExporter.ClassStats = {
    [1] = {strength = true},
    [2] = {intellect = true, strength = true},
    [3] = {agility = true},
    [4] = {agility = true},
    [5] = {intellect = true},
    [6] = {strength = true},
    [7] = {intellect = true, agility = true},
    [8] = {intellect = true},
    [9] = {intellect = true},
    [10] = {intellect = true, agility = true},
    [11] = {intellect = true, agility = true},
    [12] = {agility=true},
    [13] = {intellect = true},
}

ItemExporter.SpecializationStats = {
    [71] = {strength = true},  -- Arms Warrior
    [72] = {strength = true},  -- Fury Warrior
    [73] = {strength = true},  -- Protection Warrior
    [65] = {intellect = true}, -- Holy Paladin
    [66] = {strength = true},  -- Protection Paladin
    [70] = {strength = true},  -- Retribution Paladin
    [253] = {agility = true},  -- Beast Mastery Hunter
    [254] = {agility = true},  -- Marksmanship Hunter
    [255] = {agility = true},  -- Survival Hunter
    [259] = {agility = true},  -- Assassination Rogue
    [260] = {agility = true},  -- Outlaw Rogue
    [261] = {agility = true},  -- Subtlety Rogue
    [256] = {intellect = true},-- Discipline Priest
    [257] = {intellect = true},-- Holy Priest
    [258] = {intellect = true},-- Shadow Priest
    [250] = {strength = true}, -- Blood Death Knight
    [251] = {strength = true}, -- Frost Death Knight
    [252] = {strength = true}, -- Unholy Death Knight
    [262] = {intellect = true},-- Elemental Shaman
    [263] = {agility = true},  -- Enhancement Shaman
    [264] = {intellect = true},-- Restoration Shaman
    [62] = {intellect = true}, -- Arcane Mage
    [63] = {intellect = true}, -- Fire Mage
    [64] = {intellect = true}, -- Frost Mage
    [265] = {intellect = true},-- Affliction Warlock
    [266] = {intellect = true},-- Demonology Warlock
    [267] = {intellect = true},-- Destruction Warlock
    [268] = {agility = true},  -- Brewmaster Monk
    [269] = {agility = true},  -- Windwalker Monk
    [270] = {intellect = true},-- Mistweaver Monk
    [102] = {intellect = true},-- Balance Druid
    [103] = {agility = true},  -- Feral Druid
    [104] = {agility = true},  -- Guardian Druid
    [105] = {intellect = true},-- Restoration Druid
    [577] = {agility = true},  -- Havoc Demon Hunter
    [581] = {agility = true},  -- Vengeance Demon Hunter
    [1467] = {intellect = true},-- Devastation Spec, Assumed as Caster
    [1468] = {intellect = true},-- Preservation Spec, Assumed as Caster
    [1473] = {intellect = true},-- Augmentation Spec, Assumed as Caster
}


function ItemExporter:GetCurrentSpecialization()
    local specID = (GetSpecializationInfo(GetSpecialization()))
    return specID
end

function ItemExporter:GetSpecializationsByClassID(classID)
    local specNames = {[0] = "All Specializations"}
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