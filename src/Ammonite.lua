local _, Ammonite = ...
Ammonite = LibStub("AceAddon-3.0"):NewAddon(Ammonite, "Ammonite", "AceConsole-3.0", "AceEvent-3.0",
                                            "AceHook-3.0")
_G.Ammonite = Ammonite

local LDB = LibStub("LibDataBroker-1.1", true):NewDataObject("Ammonite!", {
  type = "data source",
  text = "Ammonite!",
  icon = "Interface\\Icons\\inv_misc_quiver_03",
  OnClick = function()
    Ammonite:Print("AmmoniteOptionsFrame:Show")
    Ammonite:Print("Version: {{VERSION}}")
  end
})
local LDBIcon = LibStub("LibDBIcon-1.0")
local defaults = {
  profile = {
    minimap = {hide = false},
    modules = {
      ["*"] = {enabled = true, visible = true},
      ammoCounter = {enabled = true, visible = true}
    }
  }
}
function Ammonite:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("AmmoniteDB", defaults)
  LDBIcon:Register("Ammonite!", LDB, self.db.profile.minimap)
  self:RegisterChatCommand("bunnies", "CommandTheAmmonite")
  Ammonite:Print("Version: {{VERSION}}")
end
function Ammonite:CommandTheAmmonite()
  self.db.profile.minimap.hide = not self.db.profile.minimap.hide
  if self.db.profile.minimap.hide then
    LDBIcon:Hide("Ammonite!")
  else
    LDBIcon:Show("Ammonite!")
  end
end
function Ammonite:OnEnable() end

function Ammonite:OnDisable() end
