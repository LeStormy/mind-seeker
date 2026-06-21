local ADDON, MS = ...

local READY    = "Interface\\RaidFrame\\ReadyCheck-Ready"
local NOTREADY = "Interface\\RaidFrame\\ReadyCheck-NotReady"

local FRAME_W, FRAME_H = 860, 640
local ROW_H            = 22
local LIST_W           = 290

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
-- Copyable-link popup (WoW can't open URLs, so we show a selectable text box)
-- ---------------------------------------------------------------------------

StaticPopupDialogs["MINDSEEKER_LINK"] = {
  text = "Copy this link (Ctrl+C / Cmd+C), then paste it in your browser:",
  button1 = OKAY or "Okay",
  hasEditBox = true,
  editBoxWidth = 420,
  timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
  OnShow = function(self, data)
    local eb = self.editBox or self.EditBox
    if eb then
      eb:SetText(data or "")
      eb:SetCursorPosition(0)
      eb:HighlightText()
      eb:SetFocus()
    end
  end,
  EditBoxOnEscapePressed = function(eb) eb:GetParent():Hide() end,
  EditBoxOnEnterPressed  = function(eb) eb:GetParent():Hide() end,
  EditBoxOnTextChanged   = function(eb, data) eb:SetText(data or ""); eb:HighlightText() end,
}

local function ShowLinkPopup(url)
  StaticPopup_Show("MINDSEEKER_LINK", nil, nil, url)
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
  self:BuildEntries()

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

  local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", -6, -6)

  local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOP", 0, -18)
  title:SetText("Mind-Seeker")

  local progress = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  progress:SetPoint("TOP", title, "BOTTOM", 0, -6)
  self.progress = progress

  local bar = CreateFrame("StatusBar", nil, frame)
  bar:SetPoint("TOP", progress, "BOTTOM", 0, -6)
  bar:SetSize(FRAME_W - 80, 12)
  bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
  bar:SetStatusBarColor(0.4, 0.7, 1)
  bar:SetMinMaxValues(0, self.REQUIRED)
  local barBg = bar:CreateTexture(nil, "BACKGROUND")
  barBg:SetAllPoints()
  barBg:SetColorTexture(0, 0, 0, 0.5)
  self.bar = bar

  -- ----- Left: scrollable list (headers + entry rows) ----------------------
  local listTop = -96
  local scroll = CreateFrame("ScrollFrame", "MindSeekerListScroll", frame, "UIPanelScrollFrameTemplate")
  scroll:SetPoint("TOPLEFT", 16, listTop)
  scroll:SetSize(LIST_W, FRAME_H + listTop - 40)
  EnableWheel(scroll, ROW_H * 3)

  local content = CreateFrame("Frame", nil, scroll)
  content:SetSize(LIST_W - 24, ROW_H * #self.rowModel)
  scroll:SetScrollChild(content)

  self.rows = {}
  for i, rm in ipairs(self.rowModel) do
    local row = CreateFrame("Button", nil, content)
    row:SetHeight(ROW_H)
    row:SetPoint("TOPLEFT", 0, -(i - 1) * ROW_H)
    row:SetPoint("RIGHT", content, "RIGHT", -4, 0)

    local sel = row:CreateTexture(nil, "BACKGROUND")
    sel:SetAllPoints()
    sel:SetColorTexture(1, 0.82, 0, 0.18)
    sel:Hide()
    row.sel = sel

    local icon = row:CreateTexture(nil, "ARTWORK")
    icon:SetSize(16, 16)
    icon:SetPoint("LEFT", 2, 0)
    row.icon = icon

    local label = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("LEFT", icon, "RIGHT", 6, 0)
    label:SetPoint("RIGHT", row, "RIGHT", -2, 0)
    label:SetJustifyH("LEFT")
    row.label = label

    if rm.header then
      row:EnableMouse(false)
      icon:Hide()
      label:ClearAllPoints()
      label:SetPoint("LEFT", row, "LEFT", 2, 0)
      label:SetPoint("RIGHT", row, "RIGHT", -2, 0)
      label:SetFontObject("GameFontNormal")
      label:SetText("|cffffd200" .. rm.header .. "|r")
    else
      local hl = row:CreateTexture(nil, "HIGHLIGHT")
      hl:SetAllPoints()
      hl:SetColorTexture(1, 1, 1, 0.10)
      row:SetScript("OnClick", function() MS:SelectEntry(rm.entry) end)
    end

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
    if MS.selectedEntry then
      MS:ToggleManual(MS.selectedEntry)
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
  self.linkButtons = {}

  -- ----- Footer ------------------------------------------------------------
  local footer = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  footer:SetPoint("BOTTOMLEFT", 18, 18)
  footer:SetPoint("BOTTOMRIGHT", -18, 18)
  footer:SetJustifyH("CENTER")
  footer:SetText("/mind toggle  |  /mind scan refresh  |  click a blue link to copy it  |  click the box to mark a secret done manually")

  self.selectedEntry = nil
  self:UpdateDetail()
end

-- ---------------------------------------------------------------------------
-- Link buttons inside the guide (clicking opens the copy popup)
-- ---------------------------------------------------------------------------

local function getLinkButton(self, index, parent)
  local b = self.linkButtons[index]
  if not b then
    b = CreateFrame("Button", nil, parent)
    b:SetHeight(16)
    b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    b.text:SetPoint("LEFT", 0, 0)
    b.text:SetJustifyH("LEFT")
    b:SetScript("OnClick", function(btn) ShowLinkPopup(btn.url) end)
    b:SetScript("OnEnter", function(btn) btn.text:SetTextColor(0.5, 0.9, 1) end)
    b:SetScript("OnLeave", function(btn) btn.text:SetTextColor(0.3, 0.65, 1) end)
    self.linkButtons[index] = b
  end
  return b
end

-- ---------------------------------------------------------------------------
-- Detail panel rendering (no recursion into Refresh)
-- ---------------------------------------------------------------------------

function MS:UpdateDetail()
  if not self.frame then return end

  local w = self.guideScroll:GetWidth()
  if not w or w < 50 then w = 360 end
  w = w - 18
  self.guideText:SetWidth(w)
  self.guideChild:SetWidth(w)

  for _, b in ipairs(self.linkButtons) do b:Hide() end

  local e = self.selectedEntry
  if not e then
    self.dRecord:SetText("")
    self.dName:SetText("Select a secret")
    self.dStatus:SetText("")
    self.check:Hide()
    self.guideText:SetText("Click a secret on the left to see how to obtain it.\n\nGreen check = you have it; red X = still needed.\n\nYou need " .. self.REQUIRED .. " solved to join the cabal.")
    self.guideChild:SetHeight((self.guideText:GetStringHeight() or 0) + 10)
    return
  end

  self.dRecord:SetText(e.record or "")
  self.dName:SetText(e.name)

  local got    = self:IsCollected(e)
  local manual = self:IsManual(e)
  if got then
    if e.auto then
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
    mount       = "Mount - detected from your Mount Journal",
    pet         = "Battle Pet - detected from your Pet Journal",
    toy         = "Toy - detected from your Toy Box",
    transmog    = "Appearance - detected from your collection",
    achievement = "Achievement - detected automatically",
    manual      = "No automatic detection - tick the box when done",
  })[e.kind] or ""

  local body = (e.guide or "No guide for this one yet - check warcraft-secrets.com or Wowhead.")
  self.guideText:SetText("|cffffd200How to get it|r\n" .. body .. "\n\n|cff808080" .. kindLabel .. "|r")
  local textH = self.guideText:GetStringHeight() or 0

  -- Place link buttons below the text.
  local y = -(textH + 16)
  if e.links then
    for i, link in ipairs(e.links) do
      local b = getLinkButton(self, i, self.guideChild)
      b.url = link[2]
      b.text:SetText("|cff4fa6ff> " .. link[1] .. "|r")
      b:SetWidth(b.text:GetStringWidth() + 4)
      b:ClearAllPoints()
      b:SetPoint("TOPLEFT", self.guideChild, "TOPLEFT", 0, y)
      b:Show()
      y = y - 18
    end
  end

  self.guideChild:SetHeight(math.max(textH + 10, -y + 6))
  self.guideScroll:SetVerticalScroll(0)
end

-- ---------------------------------------------------------------------------
-- Refresh everything
-- ---------------------------------------------------------------------------

function MS:Refresh()
  if not self.frame then return end
  self:RefreshStatuses()

  for i, rm in ipairs(self.rowModel) do
    local row = self.rows[i]
    if rm.entry then
      local e   = rm.entry
      local got = self:IsCollected(e)
      row.icon:SetTexture(got and READY or NOTREADY)
      if e == self.selectedEntry then
        row.sel:Show()
        row.label:SetTextColor(1, 0.82, 0)
      else
        row.sel:Hide()
        if got then row.label:SetTextColor(0.6, 1, 0.6) else row.label:SetTextColor(0.85, 0.85, 0.85) end
      end
      row.label:SetText(e.name)
    end
  end

  local solved = self:CountSolved()
  local met    = solved >= self.REQUIRED
  local color  = met and "|cff40ff40" or "|cffffd200"
  self.progress:SetText(("%sSolved %d / %d needed|r   (%d of %d tracked secrets)"):format(
    color, solved, self.REQUIRED, solved, self.TOTAL))
  self.bar:SetMinMaxValues(0, self.REQUIRED)
  self.bar:SetValue(math.min(solved, self.REQUIRED))
  self.bar:SetStatusBarColor(met and 0.3 or 0.4, met and 0.9 or 0.7, met and 0.3 or 1)

  self:UpdateDetail()
end

function MS:SelectEntry(entry)
  self.selectedEntry = entry
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
  if self.frame:IsShown() then self:Hide() else self:Show() end
end
