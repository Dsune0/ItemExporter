local _, ItemExporter = ...

ItemExporter.L = setmetatable({}, { __index = function(t, k)
    return k
end })

local L = ItemExporter.L

-- English (default) (enUS)
L["ItemExport"] = "ItemExport"
L["ItemExporter"] = "ItemExporter"
L["Export itemstrings to SimulationCraft format"] = "Export itemstrings to SimulationCraft format"
L["Export"] = "Export"
L["Toggle All Instances"] = "Toggle All Instances"
L["Toggle All Armortypes"] = "Toggle All Armortypes"

-- German (deDE)
if GetLocale() == "deDE" then
	L["ItemExport"] = "ItemExport"
	L["ItemExporter"] = "ItemExporter"
	L["Export itemstrings to SimulationCraft format"] = "Itemstrings ins SimulationCraft-Format exportieren"
	L["Export"] = "Exportieren"
	L["Toggle All Instances"] = "Alle Instanzen umschalten"
	L["Toggle All Armortypes"] = "Alle Rüstungstypen umschalten"
end

-- French (frFR)
if GetLocale() == "frFR" then
	L["ItemExport"] = "ItemExport"
	L["ItemExporter"] = "ItemExporter"
	L["Export itemstrings to SimulationCraft format"] = "Exportation des chaînes de caractères au format SimulationCraft"
	L["Export"] = "Exportation"
	L["Toggle All Instances"] = "Basculer toutes les instances"
	L["Toggle All Armortypes"] = "Basculer tous les types d'armures"
end

-- Spanish (esES and esMX)
if GetLocale() == "esES" or GetLocale() == "esMX" then
	L["ItemExport"] = "ItemExport"
	L["ItemExporter"] = "ItemExporter"
	L["Export itemstrings to SimulationCraft format"] = "Exportar cadenas de elementos a formato SimulationCraft"
	L["Export"] = "Exportar"
	L["Toggle All Instances"] = "Conmutar todas las instancias"
	L["Toggle All Armortypes"] = "Conmutar todos los tipos de armadura"
end

-- Russian (ruRU)
if GetLocale() == "ruRU" then
	L["ItemExport"] = "ItemExport"
	L["ItemExporter"] = "ItemExporter"
	L["Export itemstrings to SimulationCraft format"] = "Экспорт строк элементов в формат SimulationCraft"
	L["Export"] = "Экспорт"
	L["Toggle All Instances"] = "Переключить все экземпляры"
	L["Toggle All Armortypes"] = "Переключить все типы брони"
end

-- Korean (koKR)
if GetLocale() == "koKR" then
	L["ItemExport"] = "아이템 내보내기"
	L["ItemExporter"] = "아이템 내보내기"
	L["Export itemstrings to SimulationCraft format"] = "아이템스트링을 SimulationCraft 형식으로 내보내기"
	L["Export"] = "내보내기"
	L["Toggle All Instances"] = "모든 인스턴스 토글"
	L["Toggle All Armortypes"] =  "모든 무장 유형 토글"
end

--  Chinese Simplified (zhCN)
if GetLocale() == "zhCN" then
	L["ItemExport"] = "项目导出"
	L["ItemExporter"] = "项目导出器"
	L["Export itemstrings to SimulationCraft format"] = "将项目字符串导出为 SimulationCraft 格式"
	L["Export"] = "出口"
	L["Toggle All Instances"] = "切换所有实例"
	L["Toggle All Armortypes"] = "切换所有装甲类型"
end

-- Chinese Traditional (zhTW)
if GetLocale() == "zhTW" then

end

-- Italian (itIT)
if GetLocale() == "itIT" then
	L["ItemExport"] = "ItemExport"
	L["ItemExporter"] = "ItemExporter"
	L["Export itemstrings to SimulationCraft format"] = "Esportazione di itemstrings in formato SimulationCraft"
	L["Export"] = "Esporta"
	L["Toggle All Instances"] = "Attiva tutte le istanze"
	L["Toggle All Armortypes"] = "Attiva tutti i tipi di armatura"
end

-- Portuguese (ptBR)
if GetLocale() == "ptBR" then
	L["ItemExport"] = "ItemExport"
	L["ItemExporter"] = "Esportatore di articoli"
	L["Export itemstrings to SimulationCraft format"] = "Exportar itens para o formato SimulationCraft"
	L["Export"] = "Exportar"
	L["Toggle All Instances"] = "Alternar todas as instâncias"
	L["Toggle All Armortypes"] = "Alternar todos os tipos de armadura"
end
