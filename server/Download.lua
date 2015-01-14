



local http = require("socket.http")
local socket = require("socket")
local json = require("json")
local mime = require("mime")

class("DownloadPictures")

function DownloadPictures:__init()


  socket.TIMEOUT = GlobalSettings.Timeout



  AvatarTable = {}

  execTimer = Timer()

  urlTranslation = {["small"] = "", ["medium"] = "medium", ["large"] = "full"}
  
  Events:Subscribe("ClientModuleLoad", self, self.GetAvatarOnJoin)
  Network:Subscribe("RequestPlayerAvatar", self, self.RequestAvatar)
  
  
end

function DownloadPictures:GetAvatarOnJoin(args)
    b64 = args.player:GetAvatar("small")
    Network:Broadcast("AvatarObtained", {["b64"] = b64, ["player"] = args.player})
    b64 = nil
end


function DownloadPictures:RequestAvatar(args, player)
  print("Received avatar request")
  if AvatarTable[args.player:ssid()] then
    if AvatarTable[args.player:ssid()].size == args.size then
      Network:Send(player, "AvatarObtained", {["b64"] = AvatarTable[args.player:ssid()].b64, ["player"] = args.player})
    else
      b64 = args.player:GetAvatar(args.size)
      Network:Send(player, "AvatarObtained", {["b64"] = b64, ["player"] = args.player})
      if GlobalSettings.StoreB64OnServer then
        AvatarTable[tostring(args.player:GetSteamId())] = {["b64"] = b64, ["size"] = args.size}
      else
        b64 = nil
      end
    end
  else
    b64 = args.player:GetAvatar(args.size)
    Network:Send(player, "AvatarObtained", {["b64"] = b64, ["player"] = args.player})
    if GlobalSettings.StoreB64OnServer then
      AvatarTable[tostring(args.player:GetSteamId())] = {["b64"] = b64, ["size"] = args.size}
    else
      b64 = nil
    end
  end
end

DownloadPictures = DownloadPictures()

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
  t = string.split(userdata, "\n")

  for i, l in pairs(t) do
    if string.find(l, "\"avatar" .. Settings.AvatarSize .. "\": ") != nil then
      local index, endIndex = string.find(l, "\"avatar" .. Settings.AvatarSize .. "\": ")
      imageurl = string.sub(l, endIndex+2, -3)
    end
  end
  
  print("Requesting URL: " .. imageurl .. "!")
  
  b64Data = http.request(imageurl)
  
  print("Fetch completed after " .. execTimer:GetSeconds() .. ".")
  print("Encoding...")
  
  b64 = ((mime.b64(b64Data)))
  
  if GlobalSettings.StoreB64OnServer then
    AvatarTable[tostring(self:GetSteamId())] = {["b64"] = b64, ["size"] = size}
  end

  print("Successfully completed fetch and encode for Steam avatar of user " .. name .. " in " .. execTimer:GetSeconds() .. " seconds!")
  
  return b64
end

function Player:ssid()
  return tostring(self:GetSteamId())
end


