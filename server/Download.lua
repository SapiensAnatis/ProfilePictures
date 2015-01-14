

local http = require("socket.http")
local socket = require("socket")

socket.TIMEOUT = GlobalSettings.Timeout

local json = require("json")
local mime = require("mime")

execTimer = Timer()



urlTranslation = {["small"] = "", ["medium"] = "medium", ["large"] = "full"}


function Player:GetAvatar(size)
  
  if GlobalSettings.APIKey == "defaultKey" then
    Console:Print("[Avatar]: You have not entered an API key! You must do so to use the Steam API and therefore the script!", Color.Red)
  end
  
  Settings = {}
  
  Settings.AvatarSize = urlTranslation[size]
  
  found = false
  for i, v in pairs(urlTranslation) do
    if v == Settings.AvatarSize then
      found = true
    end
  end
  
  if not found then
    Settings.AvatarSize = ""
  end
  
  steamid64 = self:GetSteamId().id
  name = self:GetName()
  execTimer:Restart()
  print("Fetching Steam avatar of user " .. name .. ".")
  local userdata = http.request("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=" .. GlobalSettings.APIKey .. "&steamids=" .. steamid64)
  print(userdata)
  t = string.split(userdata, "\n")

  for i, l in pairs(t) do
    if string.find(l, "avatar" .. Settings.AvatarSize) != nil then
      local index, endIndex = string.find(l, "\"avatar" .. Settings.AvatarSize .. "\": ")
      imageurl = string.sub(l, endIndex+2, -3)
    end
  end
  
  print("\n\nRequesting URL: " .. imageurl .. "!")
  
  b64Data = http.request(imageurl)
  print(b64Data)
  
  print("Fetch completed after " .. execTimer:GetSeconds() .. ".")
  print("Encoding...")
  
  b64 = ((mime.b64(b64Data)))
  

  print("Successfully completed fetch and encode for Steam avatar of user " .. name .. " in " .. execTimer:GetSeconds() .. " seconds!")
  
  return b64
end


Events:Subscribe("ClientModuleLoad", function(args)
    b64 = args.player:GetAvatar("medium")
    Network:Send(args.player, "AvatarData", b64)
end)