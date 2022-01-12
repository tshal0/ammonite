local _, Ammonite = ...
Ammonite = LibStub("AceAddon-3.0"):NewAddon(Ammonite, "Ammonite",
                                            "AceConsole-3.0", "AceEvent-3.0",
                                            "AceHook-3.0")
_G.Ammonite = Ammonite
local ldbOptions = {
  type = "data source",
  text = "Ammonite",
  icon = "Interface\\Icons\\inv_misc_quiver_03",
  OnClick = function()
    Ammonite:Print("Version: {{VERSION}}")
    Ammonite:ShowOptions()
  end
}
local LDB = LibStub("LibDataBroker-1.1", true)
local ALDB = LDB:NewDataObject("Ammonite", ldbOptions)

local LDBIcon = LibStub("LibDBIcon-1.0")
local AceCfg = LibStub("AceConfig-3.0")
local AceCfgDlg = LibStub("AceConfigDialog-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local AceEvent = LibStub("AceEvent-3.0")

AceEvent:Embed(Ammonite)

local defaults = {
  profile = {
    minimap = {visible = true},
    player = {ammoCount = 0},
    modules = {
      ["*"] = {enabled = true, visible = true},
      ammoCounter = {enabled = true, visible = true}
    }
  }
}
local AceDB = LibStub("AceDB-3.0")
function Ammonite:InitOptions()
  Ammonite.enabled = true
  Ammonite.options = {
    type = "group",
    name = "Ammonite",
    icon = "Interface\\Icons\\inv_misc_quiver_03",
    childGroups = "tree",
    plugins = {},
    args = {
      lock = {
        name = "Lock Frames",
        type = "toggle",
        set = function(info, val) Ammonite:SetLocked(val) end,
        get = function(info) return Ammonite.db.profile.ammoCount.locked end
      },
      ac = {
        name = "AmmoCounter",
        type = "group",
        args = {
          lock = {
            name = "Lock Frames",
            type = "toggle",
            set = function(info, val) Ammonite:SetLocked(val) end,
            get = function(info)
              return Ammonite.db.profile.ammoCount.locked
            end
          },
          resetPosition = {
            name = "Reset Position",
            type = "execute",
            func = function(info, val)
              Ammonite.ResetCurrentPosition()
            end

          }
        }
      }
    }
  }

  AceCfg:RegisterOptionsTable("Ammonite", Ammonite.options, {"ammonite", "am"})
  AceCfgDlg:SetDefaultSize("Ammonite", 680, 560)
  Ammonite.optionsFrame = AceCfgDlg:AddToBlizOptions("Ammonite", "Ammonite",
                                                     Ammonite.options);
end
function Ammonite:OnInitialize()
  self.db = AceDB:New("AmmoniteDB", defaults)
  LDBIcon:Register("Ammonite", ALDB, self.db.profile.minimap)
  Ammonite.InitOptions()
  Ammonite:CreateFrame()
  Ammonite.RegisterAmmoEvents()
  Ammonite:Print("Version: {{VERSION}}")
end

function Ammonite:ShowOptions() AceCfgDlg:Open("Ammonite") end

-- AmmoCounter

function Ammonite:RegisterAmmoEvents()
  Ammonite.events = {}
  Ammonite:RegisterEvent("BAG_UPDATE", "UpdateAmmoCount")
end

function Ammonite:UpdateAmmoCount()
  local ammoSlot = GetInventorySlotInfo("AmmoSlot");
  local ammoCount = GetInventoryItemCount("player", ammoSlot);
  if ((ammoCount == 1) and (not GetInventoryItemTexture("player", ammoSlot))) then
    ammoCount = 0;
  end
  Ammonite.ammoCount.value = ammoCount
  local color = "00ff00"
  local message = "Ammo: " .. "|cff" .. color .. ("%.1f"):format(ammoCount)
  Ammonite.ammoCount.textFrame:SetText(message);
end

function Ammonite:CreateFrame()
  if (not Ammonite.ammoCount) then Ammonite.ammoCount = {value = 0} end

  if (not Ammonite.db.profile.ammoCount) then
    Ammonite.db.profile.ammoCount = {
      xOfs = 0,
      yOfs = 0,
      relativeTo = 0,
      locked = true
    }
  end
  if (not Ammonite.ammoCount.frame) then
    Ammonite.ammoCount = {}
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:SetFrameStrata("HIGH")

    local textFrame = frame:CreateFontString(nil, "OVERLAY", "GameTooltipText")

    Ammonite.ammoCount.frame = frame
    Ammonite.ammoCount.textFrame = textFrame

    -- Ammonite.ammoCount.textFrame:SetTextColor("000");
  end
  if (not Ammonite.db.profile.ammoCount.locked) then Ammonite:UnlockAmmoCount() end
  Ammonite:ApplySettings()
end

function Ammonite:SaveCurrentPosition()
  local frame = Ammonite.ammoCount.frame
  local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()

  Ammonite.db.profile.ammoCount.xOfs = xOfs
  Ammonite.db.profile.ammoCount.yOfs = yOfs
  Ammonite.db.profile.ammoCount.relativeTo = relativeTo
end
function Ammonite:ResetCurrentPosition()
  local frame = Ammonite.ammoCount.frame
  local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()

  Ammonite.db.profile.ammoCount.xOfs = 0
  Ammonite.db.profile.ammoCount.yOfs = 0
  Ammonite.db.profile.ammoCount.relativeTo = "CENTER"
  Ammonite:ApplySettings()
end
function Ammonite:ApplySettings()
  local frame = Ammonite.ammoCount.frame
  local textFrame = Ammonite.ammoCount.textFrame
  frame:SetWidth(100)
  frame:SetHeight(20)

  local xOfs = Ammonite.db.profile.ammoCount.xOfs
  local yOfs = Ammonite.db.profile.ammoCount.yOfs
  local relativeTo = Ammonite.db.profile.ammoCount.relativeTo

  textFrame:SetPoint("CENTER", 0, 0)
  frame:SetPoint("CENTER", xOfs, yOfs)
  -- textFrame:SetPoint("CENTER", xOfs, yOfs)
end
local function StopMoving()
  local frame = Ammonite.ammoCount.frame;
  frame:StopMovingOrSizing()
  Ammonite:SaveCurrentPosition()
end
local function StartMoving()
  if (not Ammonite.db.profile.ammoCount.locked) then
    local frame = Ammonite.ammoCount.frame;
    frame:StartMoving()
  end
end

function Ammonite:SetLocked(val)
  if (Ammonite.db.profile.ammoCount.locked == nil) then
    Ammonite.db.profile.ammoCount.locked = true
  end
  if (val) then
    Ammonite:LockAmmoCount()
  else
    Ammonite.UnlockAmmoCount()
  end
end

function Ammonite:UnlockAmmoCount()
  local frame = Ammonite.ammoCount.frame

  Ammonite.db.profile.ammoCount.locked = false;
  if (Ammonite.ammoCount.textureFrame) then
    Ammonite.ammoCount.textureFrame:Show()
  else
    local tex = frame:CreateTexture("ARTWORK")
    tex:SetAllPoints()
    tex:SetColorTexture(1.0, 0.5, 0, 0.5)
    Ammonite.ammoCount.textureFrame = tex
  end

  frame:SetMovable(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetClampedToScreen(true)
  frame:SetScript("OnMouseDown", StartMoving)
  frame:SetScript("OnMouseUp", StopMoving)
end
function Ammonite:LockAmmoCount()
  local frame = Ammonite.ammoCount.frame

  Ammonite.db.profile.ammoCount.locked = true;
  if (Ammonite.ammoCount.textureFrame) then
    Ammonite.ammoCount.textureFrame:Hide()
  end

  frame:SetMovable(false)

  frame:SetClampedToScreen(true)

  frame:SetScript("OnMouseDown", StartMoving)
  frame:SetScript("OnMouseUp", StopMoving)
end

function Ammonite:GetCurrentPosition()
  local frame = Ammonite.ammoCount.frame
  local textFrame = Ammonite.ammoCount.textFrame
  local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()
  Ammonite:Print(point)
  Ammonite:Print(relativeTo)
  Ammonite:Print(relativePoint)
  Ammonite:Print(xOfs)
  Ammonite:Print(yOfs)
end
