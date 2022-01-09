---@diagnostic disable: undefined-global
local Ammonite = {}

function Ammonite.OnLoad()
  SlashCmdList["Ammonite"] = Ammonite_SlashCommand;
  SLASH_Ammonite1= "/ammonite";
  this:RegisterEvent("VARIABLES_LOADED")
end

function Ammonite.SlashCommand()
  print("Hello, I'm Ammonite!")
end


return Ammonite