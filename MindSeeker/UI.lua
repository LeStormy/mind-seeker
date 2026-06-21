local ADDON, MS = ...

local READY    = "Interface\\RaidFrame\\ReadyCheck-Ready"
local NOTREADY = "Interface\\RaidFrame\\ReadyCheck-NotReady"

local FRAME_W, FRAME_H = 840, 640
local ROW_H            = 22
local LIST_W           = 270

-- Bind the mouse wheel to a UIPanelScrollFrame so it scrolls its content.
local function EnableWheel(scrollFrame, step)
  step = step or 28
  scrollFrame:EnableMouseWheel(true)
  scrollFrame:SetScript("OnMouseWheel", function(self, delta)
    local newv = self:GetVerticalScroll() - delta * step
    local maxv = self:GetVerticalScrollRange()
    if newv < 0 then newv = 0 elseif newv > maxv then newv = maxv end
    self:SetVerticalScroll(newv)
  end)
end

-- ---------------------------------------------------------------------------
-- Position helpers
-- ---------------------------------------------------------------------------

function MS:SavePosition()
  if not self.frame then return end
  local point, _, relPoint, x, y = self.frame:GetPoint(1)
  MindSeekerDB.point = { point = point, relPoint = relPoint, x = x, y = y }
end

function MS:RestorePosition()
  if not self.frame or not MindSeekerDB.point then return end
  local p = MindSeekerDB.point
  self.frame:ClearAllPoints()
  self.frame:SetPoint(p.point, UIParent, p.relPoint, p.x, p.y)
end

function MS:ResetPosition()
  if not self.frame then return end
  self.frame:ClearAllPoints()
  self.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end

-- ---------------------------------------------------------------------------
-- Build the UI (called once at login). Frame starts hidden.
-- ---------------------------------------------------------------------------

function MS:CreateUI()
  if self.frame then return end

  local frame = CreateFrame("Frame", "MindSeekerFrame", UIParent, "BackdropTemplate")
  self.frame = frame
  frame:SetSize(FRAME_W, FRAME_H)
  frame:SetPoint("CENTER")
  frame:SetFrameStrata("HIGH")
  frame:SetBackdrop({
    bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 },
  })
  frame:SetClampedToScreen(true)
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", function(s) s:StartMoving() end)
  frame:SetScript("OnDragStop", function(s) s:StopMovingOrSizing(); MS:SavePosition() end)
  frame:Hide()

  -- Close button
  local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", -6, -6)

  -- Title
  local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOP", 0, -18)
  title:SetText("Mind-Seeker")

  -- Progress text
  local progress = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  progress:SetPoint("TOP", title, "BOTTOM", 0, -6)
  self.progress = progress

  -- Progress bar
  local bar = CreateFrame("StatusBar", nil, frame)
  bar:SetPoint("TOP", progress, "BOTTOM", 0, -6)
  bar:SetSize(FRAME_W - 80, 12)
  bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
  bar:SetStatusBarColor(0.4, 0.7, 1)
  bar:SetMinMaxValues(0, self.REQUIRED)
  bar:SetValue(0)
  local barBg = bar:CreateTexture(nil, "BACKGROUND")
  barBg:SetAllPoints()
  barBg:SetColorTexture(0, 0, 0, 0.5)
  self.bar = bar

  -- ----- Left: scrollable list ---------------------------------------------
  local listTop = -96
  local scroll = CreateFrame("ScrollFrame", "MindSeekerListScroll", frame, "UIPanelScrollFrameTemplate")
  scroll:SetPoint("TOPLEFT", 16, listTop)
  scroll:SetSize(LIST_W, FRAME_H + listTop - 40)

  EnableWheel(scroll, ROW_H * 3)

  local content = CreateFrame("Frame", nil, scroll)
  content:SetSize(LIST_W - 24, ROW_H * self.TOTAL) -- leave room for the scrollbar
  scroll:SetScrollChild(content)

  self.rows = {}
  for i, rec in ipairs(self.records) do
    local row = CreateFrame("Button", nil, content)
    row:SetHeight(ROW_H)
    row:SetPoint("TOPLEFT", 0, -(i - 1) * ROW_H)
    row:SetPoint("RIGHT", content, "RIGHT", -4, 0)

    local sel = row:CreateTexture(nil, "BACKGROUND")
    sel:SetAllPoints()
    sel:SetColorTexture(1, 0.82, 0, 0.18)
    sel:Hide()
    row.sel = sel

    local hl = row:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints()
    hl:SetColorTexture(1, 1, 1, 0.10)

    local icon = row:CreateTexture(nil, "ARTWORK")
    icon:SetSize(16, 16)
    icon:SetPoint("LEFT", 2, 0)
    row.icon = icon

    local label = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("LEFT", icon, "RIGHT", 6, 0)
    label:SetPoint("RIGHT", row, "RIGHT", -2, 0)
    label:SetJustifyH("LEFT")
    label:SetText(rec.name)
    row.label = label

    row:SetScript("OnClick", function() MS:SelectRecord(i) end)
    self.rows[i] = row
  end

  -- ----- Right: detail panel -----------------------------------------------
  local detail = CreateFrame("Frame", nil, frame)
  detail:SetPoint("TOPLEFT", scroll, "TOPRIGHT", 22, 0)
  detail:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -28, 40)

  local dRecord = detail:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  dRecord:SetPoint("TOPLEFT", 0, 0)
  dRecord:SetPoint("RIGHT", detail, "RIGHT", 0, 0)
  dRecord:SetJustifyH("LEFT")
  dRecord:SetTextColor(0.7, 0.7, 0.7)
  self.dRecord = dRecord

  local dName = detail:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  dName:SetPoint("TOPLEFT", dRecord, "BOTTOMLEFT", 0, -4)
  dName:SetPoint("RIGHT", detail, "RIGHT", 0, 0)
  dName:SetJustifyH("LEFT")
  self.dName = dName

  local dStatus = detail:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  dStatus:SetPoint("TOPLEFT", dName, "BOTTOMLEFT", 0, -6)
  self.dStatus = dStatus

  local check = CreateFrame("CheckButton", nil, detail, "UICheckButtonTemplate")
  check:SetSize(22, 22)
  check:SetPoint("TOPLEFT", dStatus, "BOTTOMLEFT", -2, -6)
  check.text = check:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  check.text:SetPoint("LEFT", check, "RIGHT", 2, 0)
  check.text:SetText("Mark as solved (manual)")
  check:SetScript("OnClick", function()
    if MS.selected then
      MS:ToggleManual(MS.records[MS.selected])
      MS:Refresh()
    end
  end)
  self.check = check

  local guideScroll = CreateFrame("ScrollFrame", "MindSeekerGuideScroll", detail, "UIPanelScrollFrameTemplate")
  guideScroll:SetPoint("TOPLEFT", check, "BOTTOMLEFT", 2, -10)
  guideScroll:SetPoint("BOTTOMRIGHT", detail, "BOTTOMRIGHT", -24, 0)

  EnableWheel(guideScroll)

  local guideChild = CreateFrame("Frame", nil, guideScroll)
  guideChild:SetSize(1, 1)
  guideScroll:SetScrollChild(guideChild)

  local guideText = guideChild:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  guideText:SetPoint("TOPLEFT", 0, 0)
  guideText:SetJustifyH("LEFT")
  guideText:SetJustifyV("TOP")
  guideText:SetSpacing(3)
  self.guideScroll = guideScroll
  self.guideChild  = guideChild
  self.guideText   = guideText

  -- ----- Footer ------------------------------------------------------------
  local footer = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  footer:SetPoint("BOTTOMLEFT", 18, 18)
  footer:SetPoint("BOTTOMRIGHT", -18, 18)
  footer:SetJustifyH("CENTER")
  footer:SetText("/mind toggle  |  /mind scan refresh  |  guides are short summaries -- full walkthroughs at warcraft-secrets.com/guides/mind-seeker")

  self.selected = nil
  self:UpdateDetail()
end

-- ---------------------------------------------------------------------------
-- Detail panel rendering (no recursion into Refresh)
-- ---------------------------------------------------------------------------

function MS:UpdateDetail()
  if not self.frame then return end
  -- Effective text width (anchors can briefly report 0 before first layout).
  local w = self.guideScroll:GetWidth()
  if not w or w < 50 then w = 320 end
  w = w - 18 -- keep clear of the scrollbar
  self.guideText:SetWidth(w)
  self.guideChild:SetWidth(w)

  local i = self.selected
  if not i then
    self.dRecord:SetText("")
    self.dName:SetText("Select a record")
    self.dStatus:SetText("")
    self.check:Hide()
    self.guideText:SetText("Click a record on the left to see how to obtain it.\n\nThe green check means you already have it; the red X means you still need it.\n\nYou need " .. self.REQUIRED .. " of " .. self.TOTAL .. " to join the cabal.")
    self.guideChild:SetHeight((self.guideText:GetStringHeight() or 0) + 10)
    return
  end

  local rec = self.records[i]
  self.dRecord:SetText(rec.record)
  self.dName:SetText(rec.name)

  local got     = self:IsCollected(rec)
  local auto    = self:AutoDetect(rec)
  local manual  = self:IsManual(rec)
  if got then
    if auto then
      self.dStatus:SetText("|cff40ff40Collected|r")
    else
      self.dStatus:SetText("|cff40ff40Collected|r |cff808080(marked manually)|r")
    end
  else
    self.dStatus:SetText("|cffff4040Not collected yet|r")
  end

  self.check:Show()
  self.check:SetChecked(manual)

  local kindLabel = ({
    collectible = "Mount / Pet -- detected automatically from your collection",
    toy         = "Toy -- detected automatically",
    transmog    = "Cosmetic appearance -- detected automatically",
    achievement = "Achievement -- detected automatically",
    manual      = "No automatic detection -- tick the box when done",
  })[rec.kind] or ""

  self.guideText:SetText("|cffffd200How to get it|r\n" .. rec.guide .. "\n\n|cff808080" .. kindLabel .. "|r")
  self.guideChild:SetHeight((self.guideText:GetStringHeight() or 0) + 10)
  self.guideScroll:SetVerticalScroll(0)
end

-- ---------------------------------------------------------------------------
-- Refresh everything
-- ---------------------------------------------------------------------------

function MS:Refresh()
  if not self.frame then return end
  self:BuildMountSet()

  local solved = 0
  for i, rec in ipairs(self.records) do
    local got = self:IsCollected(rec)
    if got then solved = solved + 1 end
    local row = self.rows[i]
    row.icon:SetTexture(got and READY or NOTREADY)
    if i == self.selected then
      row.sel:Show()
      row.label:SetTextColor(1, 0.82, 0)
    else
      row.sel:Hide()
      if got then
        row.label:SetTextColor(0.6, 1, 0.6)
      else
        row.label:SetTextColor(0.85, 0.85, 0.85)
      end
    end
  end

  local met = solved >= self.REQUIRED
  local color = met and "|cff40ff40" or "|cffffd200"
  self.progress:SetText(("%sSolved %d / %d|r   (need %d to join)"):format(color, solved, self.TOTAL, self.REQUIRED))
  self.bar:SetMinMaxValues(0, self.REQUIRED)
  self.bar:SetValue(math.min(solved, self.REQUIRED))
  self.bar:SetStatusBarColor(met and 0.3 or 0.4, met and 0.9 or 0.7, met and 0.3 or 1)

  self:UpdateDetail()
end

function MS:SelectRecord(i)
  self.selected = i
  self:Refresh()
end

-- ---------------------------------------------------------------------------
-- Show / hide
-- ---------------------------------------------------------------------------

function MS:Show()
  if not self.frame then return end
  self.frame:Show()
  self:Refresh()
end

function MS:Hide()
  if self.frame then self.frame:Hide() end
end

function MS:Toggle()
  if not self.frame then return end
  if self.frame:IsShown() then
    self:Hide()
  else
    self:Show()
  end
end
