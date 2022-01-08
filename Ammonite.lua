---@diagnostic disable: undefined-global
function Ammonite_OnLoad()
  SlashCmdList["Ammonite"] = Ammonite_SlashCommand;
  SLASH_Ammonite1= "/ammonite";
  this:RegisterEvent("VARIABLES_LOADED")
end
function Ammonite_SlashCommand()
  print("Hello, I'm Ammonite!")
end

Ammonite_OnLoad()