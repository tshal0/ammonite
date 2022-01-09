---@diagnostic disable: undefined-global

local _, Ammonite = ...
Ammonite = LibStub("AceAddon-3.0"):NewAddon(Ammonite, "Ammonite", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
print('Ammonite')
_G.Ammonite = Ammonite

local L = LibStub("AceLocale-3.0"):GetLocale("Ammonite")

local WoWClassic = (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE)

local LDB = LibStub("LibDataBroker-1.1", true)
local LDBIcon = LibStub("LibDBIcon-1.0", true)

local _G = _G

print('Test 2')
local defaults = {
    profile = {
        modules = {
            ['*'] = {enabled = true, visible = true},
            moduleB = {enabled = false, visible = true}
        }
    }
}
print('Test 3')
function Ammonite:OnInitialize()
    print('Test 4')
    Ammonite:Print("Hello, world!")
    self.db = LibStub("AceDB-3.0"):New("AmmoniteDB", defaults)
end

function Ammonite:OnEnable()
    Ammonite:Print("Hello, world!")
    self:RegisterEvent("ZONE_CHANGED")
end

function Ammonite:OnDisable() Ammonite:Print("Hello, world!") end
