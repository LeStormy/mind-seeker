local ADDON, MS = ...

-- ---------------------------------------------------------------------------
-- Detection
-- ---------------------------------------------------------------------------

-- Build a lowercased set of every mount name you have collected. Filter-proof
-- (reads the collected flag directly) and rebuilt on every refresh.
function MS:BuildMountSet()
  self.mountSet = {}
  if not C_MountJournal then return end
  for _, mountID in ipairs(C_MountJournal.GetMountIDs()) do
    local name, _, _, _, _, _, _, _, _, _, collected = C_MountJournal.GetMountInfoByID(mountID)
    if collected and name then
      self.mountSet[name:lower()] = true
    end
  end
end

local function ownsPetNamed(name)
  -- FindPetIDByName searches your owned pets and returns nil if you have none.
  return C_PetJournal and C_PetJournal.FindPetIDByName(name) ~= nil
end

-- A "collectible" record: try every candidate name against mounts and pets.
function MS:HasCollectible(rec)
  local candidates = { rec.name }
  if rec.aliases then
    for _, a in ipairs(rec.aliases) do candidates[#candidates + 1] = a end
  end
  for _, n in ipairs(candidates) do
    if self.mountSet and self.mountSet[n:lower()] then return true end
    if ownsPetNamed(n) then return true end
  end
  return false
end

-- True if the record is satisfied by the game (ignoring any manual override).
function MS:AutoDetect(rec)
  local k = rec.kind
  if k == "collectible" then
    return self:HasCollectible(rec)
  elseif k == "toy" then
    return rec.id and PlayerHasToy(rec.id) or false
  elseif k == "transmog" then
    if rec.id and C_TransmogCollection and C_TransmogCollection.PlayerHasTransmog then
      return C_TransmogCollection.PlayerHasTransmog(rec.id) and true or false
    end
    return false
  elseif k == "achievement" then
    if rec.id then
      return select(4, GetAchievementInfo(rec.id)) and true or false
    end
    return false
  end
  return false -- "manual"
end

-- Final status = detected by the game OR ticked manually by the user.
function MS:IsCollected(rec)
  if MindSeekerDB and MindSeekerDB.manual and MindSeekerDB.manual[rec.record] then
    return true
  end
  return self:AutoDetect(rec)
end

function MS:IsManual(rec)
  return MindSeekerDB and MindSeekerDB.manual and MindSeekerDB.manual[rec.record] == true
end

function MS:ToggleManual(rec)
  MindSeekerDB.manual = MindSeekerDB.manual or {}
  if MindSeekerDB.manual[rec.record] then
    MindSeekerDB.manual[rec.record] = nil
  else
    MindSeekerDB.manual[rec.record] = true
  end
end

-- Count how many records are currently solved.
function MS:CountSolved()
  self:BuildMountSet()
  local n = 0
  for _, rec in ipairs(self.records) do
    if self:IsCollected(rec) then n = n + 1 end
  end
  return n
end

-- ---------------------------------------------------------------------------
-- Saved variables / events
-- ---------------------------------------------------------------------------

local function InitDB()
  MindSeekerDB = MindSeekerDB or {}
  MindSeekerDB.manual = MindSeekerDB.manual or {}
  MindSeekerDB.point  = MindSeekerDB.point or nil
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
-- Slash command:  /mind  (toggle)  |  show | hide | scan | reset
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
    local solved = MS:CountSolved()
    print(("|cff66ccffMind-Seeker|r: %d/%d secrets solved (%d needed)."):format(solved, MS.TOTAL, MS.REQUIRED))
  elseif msg == "reset" then
    MindSeekerDB.point = nil
    MS:ResetPosition()
    print("|cff66ccffMind-Seeker|r: window position reset.")
  else
    MS:Toggle()
  end
end
