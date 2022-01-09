local _, Ammonite = ...
Ammonite = LibStub("AceAddon-3.0"):NewAddon(Ammonite, 
    "Ammonite", 
    "AceConsole-3.0", 
    "AceEvent-3.0", 
    "AceHook-3.0")
_G.Ammonite = Ammonite

local LDB = LibStub("LibDataBroker-1.1", true)
local LDBIcon = LibStub("LibDBIcon-1.0", true)

local defaults = {
    profile = {
        modules = {
            ['*'] = {enabled = true, visible = true},
            moduleB = {enabled = false, visible = true}
        }
    }
}
function Ammonite:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("AmmoniteDB", defaults)
    Ammonite:Print("Version: {{VERSION}}")
end

function Ammonite:OnEnable()
end

function Ammonite:OnDisable() 
end
