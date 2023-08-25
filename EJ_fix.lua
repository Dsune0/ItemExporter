ItemExporter = ItemExporter or {}

function ItemExporter.ReEnableEJ()
  EncounterJournal:RegisterEvent("EJ_LOOT_DATA_RECIEVED");
  EncounterJournal:RegisterEvent("EJ_DIFFICULTY_UPDATE");
  EncounterJournal:RegisterEvent("UNIT_PORTRAIT_UPDATE");
  EncounterJournal:RegisterEvent("PORTRAITS_UPDATED");
  EncounterJournal:RegisterEvent("SEARCH_DB_LOADED");
  EncounterJournal:RegisterEvent("UI_MODEL_SCENE_INFO_UPDATED");
end
function ItemExporter:DisableEJ()
  EncounterJournal:UnregisterEvent("EJ_LOOT_DATA_RECIEVED");
  EncounterJournal:UnregisterEvent("EJ_DIFFICULTY_UPDATE");
  EncounterJournal:UnregisterEvent("UNIT_PORTRAIT_UPDATE");
  EncounterJournal:UnregisterEvent("PORTRAITS_UPDATED");
  EncounterJournal:UnregisterEvent("SEARCH_DB_LOADED");
  EncounterJournal:UnregisterEvent("UI_MODEL_SCENE_INFO_UPDATED");
end