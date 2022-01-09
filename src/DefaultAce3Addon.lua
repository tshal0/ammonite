local _, DefaultAce3Addon = ...
DefaultAce3Addon = LibStub("AceAddon-3.0"):NewAddon(DefaultAce3Addon, 
    "DefaultAce3Addon", 
    "AceConsole-3.0", 
    "AceEvent-3.0", 
    "AceHook-3.0")
_G.DefaultAce3Addon = DefaultAce3Addon

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
function DefaultAce3Addon:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("DefaultAce3AddonDB", defaults)
    DefaultAce3Addon:Print("Version: {{VERSION}}")
end

function DefaultAce3Addon:OnEnable()
end

function DefaultAce3Addon:OnDisable() 
end
