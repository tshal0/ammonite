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
      enable = {
        name = "Enable",
        desc = "Enables / disables the addon",
        type = "toggle",
        set = function(info, val) Ammonite.enabled = val end,
        get = function(info) return Ammonite.enabled end
      },
      minimap = {
        name = "Minimap",
        type = "group",
        args = {
          show = {
            name = "Show Minimap Button",
            type = "toggle",
            set = function(info, val)
              Ammonite.db.profile.minimap.visible = val
            end,
            get = function(info)
              return Ammonite.db.profile.minimap.visible
            end
          }
        }
      },
      ac = {
        name = "AmmoCounter",
        type = "group",
        args = {
          enable = {
            name = "Enable AmmoCounter",
            type = "toggle",
            set = function(info, val)
              Ammonite.db.profile.modules.ammoCounter.enabled = val
            end,
            get = function(info)
              return Ammonite.db.profile.modules.ammoCounter.enabled
            end
          },
          getAmmoCount = {
            name = "Get Ammo Count",
            type = "execute",
            func = function(info, val) Ammonite.UpdateAmmoCount() end

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
  if (not Ammonite.ammoCount) then Ammonite.ammoCount = {value = 0} end
  Ammonite.ammoCount.value = ammoCount
  local color = "00ff00"
  local message = "Ammo: " .. "|cff" .. color .. ("%.1f"):format(ammoCount)

  if (not Ammonite.ammoCount.frame) then
    Ammonite.ammoCount = {}
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:SetWidth(100)
    frame:SetHeight(20)
    frame:SetPoint("CENTER", 0, 0)
    local textFrame = frame:CreateFontString(nil, "OVERLAY", "GameTooltipText")
    textFrame:SetPoint("CENTER", 0, 0);
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetClampedToScreen(true)
    frame:SetFrameStrata("HIGH")
    frame:SetScript("OnMouseDown", frame.StartMoving)
    frame:SetScript("OnMouseUp", frame.StopMovingOrSizing)
    local tex = frame:CreateTexture("ARTWORK")
    tex:SetAllPoints()
    tex:SetColorTexture(1.0, 0.5, 0, 0.5)
    Ammonite.ammoCount.frame = frame
    Ammonite.ammoCount.textFrame = textFrame
    -- Ammonite.ammoCount.textFrame:SetTextColor("000");
  end
  Ammonite.ammoCount.textFrame:SetText(message);
end
