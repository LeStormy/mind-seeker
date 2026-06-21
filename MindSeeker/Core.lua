local ADDON, MS = ...

-- ---------------------------------------------------------------------------
-- Build the entry/row model by resolving the authoritative IDs at runtime.
-- Each entry = { name, kind, auto, id, guide, links, record }
-- ---------------------------------------------------------------------------

local function petOwned(speciesID)
  local n = C_PetJournal and C_PetJournal.GetNumCollectedInfo(speciesID)
  return (n or 0) > 0
end

local function attachGuide(entry)
  local g = MS:FindGuide(entry.name)
  if g then
    entry.guide  = g.text
    entry.links  = g.links
    entry.record = g.record
  end
  return entry
end

function MS:BuildEntries()
  local mounts, pets, others = {}, {}, {}

  for _, mountID in ipairs(self.mountIDs) do
    local name, _, _, _, _, _, _, _, _, _, collected = C_MountJournal.GetMountInfoByID(mountID)
    mounts[#mounts + 1] = attachGuide({
      name = name or ("Mount #" .. mountID), kind = "mount",
      auto = collected and true or false, id = mountID,
    })
  end

  for _, speciesID in ipairs(self.petIDs) do
    local name = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
    pets[#pets + 1] = attachGuide({
      name = name or ("Pet #" .. speciesID), kind = "pet",
      auto = petOwned(speciesID), id = speciesID,
    })
  end

  for _, e in ipairs(self.extras) do
    local auto = false
    if e.kind == "toy" then
      auto = PlayerHasToy(e.id) and true or false
    elseif e.kind == "transmog" then
      if C_TransmogCollection and C_TransmogCollection.PlayerHasTransmog then
        auto = C_TransmogCollection.PlayerHasTransmog(e.id) and true or false
      end
    elseif e.kind == "achievement" then
      auto = select(4, GetAchievementInfo(e.id)) and true or false
    end
    others[#others + 1] = attachGuide({
      name = e.name, kind = e.kind, auto = auto, id = e.id,
    })
  end

  local byName = function(a, b) return a.name < b.name end
  table.sort(mounts, byName)
  table.sort(pets, byName)

  -- Flat entry list (for counting) + display rows (with section headers).
  self.entries = {}
  self.rowModel = {}
  local function addSection(label, list)
    self.rowModel[#self.rowModel + 1] = { header = label }
    for _, e in ipairs(list) do
      self.entries[#self.entries + 1] = e
      self.rowModel[#self.rowModel + 1] = { entry = e }
    end
  end
  addSection("Mounts", mounts)
  addSection("Battle Pets", pets)
  addSection("Other", others)

  self.TOTAL = #self.entries
  return self.entries
end

-- Re-resolve the auto-detected status of every entry (cheap; call on refresh).
function MS:RefreshStatuses()
  for _, e in ipairs(self.entries or {}) do
    if e.kind == "mount" then
      e.auto = select(11, C_MountJournal.GetMountInfoByID(e.id)) and true or false
    elseif e.kind == "pet" then
      e.auto = petOwned(e.id)
    elseif e.kind == "toy" then
      e.auto = PlayerHasToy(e.id) and true or false
    elseif e.kind == "transmog" then
      e.auto = (C_TransmogCollection and C_TransmogCollection.PlayerHasTransmog
                and C_TransmogCollection.PlayerHasTransmog(e.id)) and true or false
    elseif e.kind == "achievement" then
      e.auto = select(4, GetAchievementInfo(e.id)) and true or false
    end
  end
end

-- Final status = detected by the game OR ticked manually by the user.
function MS:IsCollected(entry)
  if MindSeekerDB and MindSeekerDB.manual and MindSeekerDB.manual[entry.name] then
    return true
  end
  return entry.auto
end

function MS:IsManual(entry)
  return MindSeekerDB and MindSeekerDB.manual and MindSeekerDB.manual[entry.name] == true
end

function MS:ToggleManual(entry)
  MindSeekerDB.manual = MindSeekerDB.manual or {}
  if MindSeekerDB.manual[entry.name] then
    MindSeekerDB.manual[entry.name] = nil
  else
    MindSeekerDB.manual[entry.name] = true
  end
end

function MS:CountSolved()
  local n = 0
  for _, e in ipairs(self.entries or {}) do
    if self:IsCollected(e) then n = n + 1 end
  end
  return n
end

-- ---------------------------------------------------------------------------
-- Saved variables / events
-- ---------------------------------------------------------------------------

local function InitDB()
  MindSeekerDB = MindSeekerDB or {}
  MindSeekerDB.manual = MindSeekerDB.manual or {}
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(_, event)
  if event == "PLAYER_LOGIN" then
    InitDB()
    MS:CreateUI()          -- defined in UI.lua; frame starts hidden
    if MindSeekerDB.point then
      MS:RestorePosition()
    end
  end
end)

-- ---------------------------------------------------------------------------
-- Slash command:  /mind  (toggle)  |  show | hide | scan | reset | dump
-- ---------------------------------------------------------------------------

SLASH_MINDSEEKER1 = "/mind"
SLASH_MINDSEEKER2 = "/mindseeker"
SlashCmdList["MINDSEEKER"] = function(msg)
  msg = (msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
  if msg == "show" then
    MS:Show()
  elseif msg == "hide" then
    MS:Hide()
  elseif msg == "scan" or msg == "refresh" then
    MS:Refresh()
    print(("|cff66ccffMind-Seeker|r: %d/%d secrets solved (%d needed)."):format(MS:CountSolved(), MS.TOTAL or 0, MS.REQUIRED))
  elseif msg == "reset" then
    MindSeekerDB.point = nil
    MS:ResetPosition()
    print("|cff66ccffMind-Seeker|r: window position reset.")
  elseif msg == "dump" then
    -- Diagnostic: print exactly what each authoritative ID resolves to.
    print("|cff66ccffMind-Seeker|r ID dump:")
    for _, id in ipairs(MS.mountIDs) do
      local name, _, _, _, _, _, _, _, _, _, c = C_MountJournal.GetMountInfoByID(id)
      print(("  mount %d = %s [%s]"):format(id, tostring(name), c and "HAVE" or "missing"))
    end
    for _, sid in ipairs(MS.petIDs) do
      local name = C_PetJournal.GetPetInfoBySpeciesID(sid)
      print(("  pet %d = %s [%s]"):format(sid, tostring(name), petOwned(sid) and "HAVE" or "missing"))
    end
  else
    MS:Toggle()
  end
end
