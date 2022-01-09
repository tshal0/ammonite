---@diagnostic disable: undefined-global
local Ammonite = {}

function Ammonite.SlashCommand()
  print("Hello, I'm Ammonite!")
end

function Ammonite_OnLoad()
  SlashCmdList["Ammonite"] = Ammonite.SlashCommand;
  SLASH_Ammonite1= "/ammonite";
  print("Ammonite Initialized: Version {{VERSION}}")
  this:RegisterEvent("VARIABLES_LOADED")
end

return Ammonite