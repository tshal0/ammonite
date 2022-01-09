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
