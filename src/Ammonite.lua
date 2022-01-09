local _, Ammonite = ...
Ammonite = LibStub("AceAddon-3.0"):NewAddon(Ammonite, "Ammonite",
                                            "AceConsole-3.0", "AceEvent-3.0",
                                            "AceHook-3.0")
_G.Ammonite = Ammonite

local LDB = LibStub("LibDataBroker-1.1", true):NewDataObject("Ammonite", {
  type = "data source",
  text = "Ammonite",
  icon = "Interface\\Icons\\inv_misc_quiver_03",
  OnClick = function()
    Ammonite:Print("Version: {{VERSION}}")
    Ammonite:ShowOptions()
  end
})
local LDBIcon = LibStub("LibDBIcon-1.0")

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
          }
        }
      }
    }
  }
  LibStub("AceConfig-3.0"):RegisterOptionsTable("Ammonite", Ammonite.options,
                                                {"ammonite", "am"})
  LibStub("AceConfigDialog-3.0"):SetDefaultSize("Ammonite", 680, 560)

  self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(
                        "Ammonite", "Ammonite", Ammonite.options);
end

local defaults = {
  profile = {
    minimap = {visible = true},
    modules = {
      ["*"] = {enabled = true, visible = true},
      ammoCounter = {enabled = true, visible = true}
    }
  }
}

local AceGUI = LibStub("AceGUI-3.0")

function Ammonite:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("AmmoniteDB", defaults)
  LDBIcon:Register("Ammonite", LDB, self.db.profile.minimap)
  self:InitOptions()

  Ammonite:Print("Version: {{VERSION}}")
end
function Ammonite:ToggleMinimapButton()
  self.db.profile.minimap.visible = not self.db.profile.minimap.visible
end

-- function that draws the widgets for the first tab
local function DrawGroup1(container)
  local desc = AceGUI:Create("Label")
  desc:SetText("This is Tab 1")
  desc:SetFullWidth(true)
  container:AddChild(desc)

  local button = AceGUI:Create("Button")
  button:SetText("Tab 1 Button")
  button:SetWidth(200)
  container:AddChild(button)
end

-- function that draws the widgets for the second tab
local function DrawGroup2(container)
  local desc = AceGUI:Create("Label")
  desc:SetText("This is Tab 2")
  desc:SetFullWidth(true)
  container:AddChild(desc)

  local button = AceGUI:Create("Button")
  button:SetText("Tab 2 Button")
  button:SetWidth(200)
  container:AddChild(button)
end

-- Callback function for OnGroupSelected

local function SelectGroup(container, event, group)
  container:ReleaseChildren()
  if group == "tab1" then
    DrawGroup1(container)
  elseif group == "tab2" then
    DrawGroup2(container)
  end
end

function Ammonite:DrawGroup()
  local frame = AceGUI:Create("Frame")
  frame:SetTitle("Ammonite")
  -- frame:SetStatusText("Ammonite Options")
  frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
  frame:SetLayout("Fill")

  -- Create List Group with Modules
  -- Create Content Group
  -- Add Module AmmoCounter
  -- Add AmmoCounterOptions Tab

  -- Create the TabGroup
  local tab = AceGUI:Create("TabGroup")
  tab:SetLayout("Flow")
  -- Setup which tabs to show
  tab:SetTabs({
    {text = "Tab 1", value = "tab1"},
    {text = "Tab 2", value = "tab2"}
  })
  -- Register callback
  tab:SetCallback("OnGroupSelected", SelectGroup)
  -- Set initial Tab (this will fire the OnGroupSelected callback)
  tab:SelectTab("tab1")

  -- add to the frame container
  frame:AddChild(tab)
end
function Ammonite:ShowOptions()
  -- InterfaceOptionsFrame_OpenToCategory(Ammonite.optionsFrame)
  -- InterfaceOptionsFrame_OpenToCategory(Ammonite.optionsFrame)
  LibStub("AceConfigDialog-3.0"):Open("Ammonite")
end
