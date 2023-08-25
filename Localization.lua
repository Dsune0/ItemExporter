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
L["Toggle all Instances"] = "Toggle All Instances"
L["Toggle all armortypes"] = "Toggle All Armortypes"

-- German (deDE)
if GetLocale() == "deDE" then
	L["ItemExport"] = "ItemExport"
	L["ItemExporter"] = "ItemExporter"
	L["Export itemstrings to SimulationCraft format"] = "Itemstrings ins SimulationCraft-Format exportieren"
	L["Export"] = "Exportieren"
	L["Toggle all Instances"] = "Alle Instanzen umschalten"
	L["Toggle all armortypes"] = "Alle Rüstungstypen umschalten"
end

-- French (frFR)
if GetLocale() == "frFR" then
	L["ItemExport"] = "ItemExport"
	L["ItemExporter"] = "ItemExporter"
	L["Export itemstrings to SimulationCraft format"] = "Exportation des chaînes de caractères au format SimulationCraft"
	L["Export"] = "Exportation"
	L["Toggle all Instances"] = "Basculer toutes les instances"
	L["Toggle all armortypes"] = "Basculer tous les types d'armures"
end

-- Spanish (esES and esMX)
if GetLocale() == "esES" or GetLocale() == "esMX" then
	L["ItemExport"] = "ItemExport"
	L["ItemExporter"] = "ItemExporter"
	L["Export itemstrings to SimulationCraft format"] = "Exportar cadenas de elementos a formato SimulationCraft"
	L["Export"] = "Exportar"
	L["Toggle all Instances"] = "Conmutar todas las instancias"
	L["Toggle all armortypes"] = "Conmutar todos los tipos de armadura"
end

-- Russian (ruRU)
if GetLocale() == "ruRU" then
	L["ItemExport"] = "ItemExport"
	L["ItemExporter"] = "ItemExporter"
	L["Export itemstrings to SimulationCraft format"] = "Экспорт строк элементов в формат SimulationCraft"
	L["Export"] = "Экспорт"
	L["Toggle all Instances"] = "Переключить все экземпляры"
	L["Toggle all armortypes"] = "Переключить все типы брони"
end

-- Korean (koKR)
if GetLocale() == "koKR" then
	L["ItemExport"] = "아이템 내보내기"
	L["ItemExporter"] = "아이템 내보내기"
	L["Export itemstrings to SimulationCraft format"] = "아이템스트링을 SimulationCraft 형식으로 내보내기"
	L["Export"] = "내보내기"
	L["Toggle all Instances"] = "모든 인스턴스 토글"
	L["Toggle all armortypes"] =  "모든 무장 유형 토글"
end

--  Chinese Simplified (zhCN)
if GetLocale() == "zhCN" then
	L["ItemExport"] = "项目导出"
	L["ItemExporter"] = "项目导出器"
	L["Export itemstrings to SimulationCraft format"] = "将项目字符串导出为 SimulationCraft 格式"
	L["Export"] = "出口"
	L["Toggle all Instances"] = "切换所有实例"
	L["Toggle all armortypes"] = "切换所有装甲类型"
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
	L["Toggle all Instances"] = "Attiva tutte le istanze"
	L["Toggle all armortypes"] = "Attiva tutti i tipi di armatura"
end

-- Portuguese (ptBR)
if GetLocale() == "ptBR" then
	L["ItemExport"] = "ItemExport"
	L["ItemExporter"] = "Esportatore di articoli"
	L["Export itemstrings to SimulationCraft format"] = "Exportar itens para o formato SimulationCraft"
	L["Export"] = "Exportar"
	L["Toggle all Instances"] = "Alternar todas as instâncias"
	L["Toggle all armortypes"] = "Alternar todos os tipos de armadura"
end
