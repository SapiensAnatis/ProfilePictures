
cachedAvatars = {
  large = {
    
  },
  medium = {
    
  },
  small = {
  
  }
}


local http = require("socket.http")
local socket = require("socket")
local json = require("json")
local mime = require("mime")

class("DownloadPictures")

function DownloadPictures:__init()


  socket.TIMEOUT = GlobalSettings.Timeout

  execTimer = Timer()

  urlTranslation = {["small"] = "", ["medium"] = "medium", ["large"] = "full"}
  defaultAvatars = {
    ["large"] = "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",
    ["medium"] = "/9j/4AAQSkZJRgABAQAAAQABAAD//gA7Q1JFQVRPUjogZ2QtanBlZyB2MS4wICh1c2luZyBJSkcgSlBFRyB2NjIpLCBxdWFsaXR5ID0gODAK/9sAQwAGBAUGBQQGBgUGBwcGCAoQCgoJCQoUDg8MEBcUGBgXFBYWGh0lHxobIxwWFiAsICMmJykqKRkfLTAtKDAlKCko/9sAQwEHBwcKCAoTCgoTKBoWGigoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgo/8AAEQgAQABAAwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/aAAwDAQACEQMRAD8A8Inmk8+T94/3j/EfWmedJ/z0f/vo0T/6+T/eP86ZQA/zpP8Ano//AH0aPOk/56P/AN9GmVo6Loeq65M0Wj6ddXrr94QRF9v1I6fjQBR86T/no/8A30aPOk/56P8A99GtHW/Dus6GV/tjS7yyD8K00RVW+h6GsugB/nSf89H/AO+jT4JpPPj/AHj/AHh/EfWoafB/r4/94fzoAJ/9fJ/vH+dMp8/+vk/3j/OmUAXdE099W1mw06Jgsl3PHApPYswUH9a+qPF3iHSPhF4S0+003TxK0hMcEAbZvIA3SO2OvIz6k18nW88ttcRz28jxTRMHSRGKsrA5BBHQg1b1TWdT1fy/7V1G8vfLzs+0TNJtz1xknHQUAfUXw+8c6Z8UdN1HS9V0xIpUTM1s7eYkiE43KcAgg/lxg180+NtEHhzxZqmkqxdLWcojHqUPK598EV9CfBbwpF4G8J3fiLxA4trm5hEsnmceRCOQD/tHqR9B1r568a63/wAJH4r1TVghRLqYuinqE6KD74AoAxafB/r4/wDeH86ZT4P9fH/vD+dABP8A6+T/AHj/ADplPn/18n+8f50ygArt/gtpltq/xK0e2vYxJArPMUYZDFEZhn2yBXEV0/w203VNX8YWdloOoHTtQkWQx3IZl2gISeV55AI/GgD1H9pvxPdi/s/DcDGOz8pbqfHWRizBQfYbc/U+1eD12PxW0fWtE8Tpa+I9UOqXpt0cTl2bCEthctz1B/OuOoAKfB/r4/8AeH86ZT4P9fH/ALw/nQAT/wCvk/3j/OmVNPDJ58n7t/vH+E+tM8mT/nm//fJoAZV7Q9Xv9C1KLUNJuGtryMEJIoBIyCD1BHQmqnkyf883/wC+TR5Mn/PN/wDvk0AaHiHXtT8RX4vdau2u7oIIxIygHaCSBwB6msyn+TJ/zzf/AL5NHkyf883/AO+TQAynwf6+P/eH86PJk/55v/3yafBDJ58f7t/vD+E+tAH/2Q==",
    ["small"] = "/9j/4AAQSkZJRgABAQAAAQABAAD//gA7Q1JFQVRPUjogZ2QtanBlZyB2MS4wICh1c2luZyBJSkcgSlBFRyB2ODApLCBxdWFsaXR5ID0gNzUK/9sAQwAIBgYHBgUIBwcHCQkICgwUDQwLCwwZEhMPFB0aHx4dGhwcICQuJyAiLCMcHCg3KSwwMTQ0NB8nOT04MjwuMzQy/9sAQwEJCQkMCwwYDQ0YMiEcITIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIy/8AAEQgAIAAgAwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/aAAwDAQACEQMRAD8A8jZm3t8x606KOe4lWKFJJZG4VEBYn8BTG++31rp/DHixfC+l6n9ktv8AibXIVIbsgEQqDzwfX+goA5yaK4tpWinjkikXqkilSPwNMVm3r8x616P4+muLjwT4en13y/8AhIJGZidoVzBzjcB0/h4+vvXm6/fX60ADffb61o+HzjxJph+zG6xdRHyBjMvzD5eeOenNZ7K29vlPWnRPNBMk0LPHKjBkdCQykdCD2NAG5421K71TxdqE95HLDIJNghlIJiUcBeOPyrAX76/WpJpJ7mZ5p3kllc5Z3JZmPqSetMVW3r8p60Af/9k="
    }
  
  Events:Subscribe("ClientModuleLoad", self, self.GetAvatarOnJoin)
  
  
end

function DownloadPictures:GetAvatarOnJoin(args)
    execTimer:Restart()
    if GlobalSettings.GetAvatarSmallOnJoin then
      if cachedAvatars.small[tostring(args.player:GetSteamId())] == nil and args.player:GetValue("avatar_s") == nil then
        args.player:GetAvatar("small") 
      elseif cachedAvatars.small[tostring(args.player:GetSteamId())] != nil then
        args.player:SetValue("avatar_s", cachedAvatars.small[tostring(args.player:GetSteamId())])
        print("Got player " .. args.player:GetName() .. "'s avatar in " .. execTimer:GetSeconds() .. " seconds. (pre-cached from leave)")
      elseif args.player:GetValue("avatar_s") != nil then
        print("Player " .. args.player:GetName() .. "'s avatar already existed as a PlayerNetworkValue.")
      end
    end
    
    if GlobalSettings.GetAvatarMedOnJoin then
      if cachedAvatars.medium[tostring(args.player:GetSteamId())] == nil and args.player:GetValue("avatar_m") == nil then
        args.player:GetAvatar("medium")
      elseif cachedAvatars.medium[tostring(args.player:GetSteamId())] != nil then
        args.player:SetValue("avatar_m", cachedAvatars.medium[tostring(args.player:GetSteamId())])
        print("Got player " .. args.player:GetName() .. "'s avatar in " .. execTimer:GetSeconds() .. " seconds. (pre-cached from leave)")
      elseif args.player:GetValue("avatar_m") then
        print("Player " .. args.player:GetName() .. "'s avatar already existed as a PlayerNetworkValue.")
      end
    end
    
    if GlobalSettings.GetAvatarLargeOnJoin then
      if cachedAvatars.large[tostring(args.player:GetSteamId())] == nil and args.player:GetValue("avatar_l") == nil then
        args.player:GetAvatar("large")
      elseif cachedAvatars.large[tostring(args.player:GetSteamId())] != nil then
        args.player:SetValue("avatar_l", cachedAvatars.large[tostring(args.player:GetSteamId())])
        print("Got player " .. args.player:GetName() .. "'s avatar in " .. execTimer:GetSeconds() .. " seconds. (pre-cached from leave)")
      elseif args.player:GetValue("avatar_l") then
        print("Player " .. args.player:GetName() .. "'s avatar already existed as a PlayerNetworkValue.")
      end
      
    end
end




function DownloadPictures:FetchAvatar_l(player)
	local host = "api.steampowered.com"
	local uri = "/ISteamUser/GetPlayerSummaries/v0002/?key=" .. GlobalSettings.APIKey .. "&steamids=" .. player:GetSteamId().id
	MakeRequest(host, uri, 80, function(response)
		if response and IsValid(player) then
			local status, err = pcall(function()
				local userdata = (json.decode(response)).response.players[1] -- Use whatever json library you have
				local url = userdata.avatarfull:gsub("http://", "")
				local host = url:sub(0, url:find("/") - 1)
        
				local uri = url:sub(url:find("/"), #url)




				MakeRequest(host, uri, 80, function(response)
					if response and IsValid(player) then
						player:SetNetworkValue("avatar_l", tostring(mime.b64(response)))
            print("Successfully retrieved " .. player:GetName() .. "'s avatar in " .. execTimer:GetSeconds() .. " seconds.")
					elseif IsValid(player) then
						print("Failed to fetch " .. player:GetName() .. "'s avatar!")
					else
						print("Player no longer exists.")
					end
				end)
			end)
			
			if not status then
				print(err)
			end
		elseif IsValid(player) then
			print("Failed to fetch userdata for " .. player:GetName() .. "!")
		else
			print("Player no longer exists.")
		end
	end)
end

function DownloadPictures:FetchAvatar_s(player)
	local host = "api.steampowered.com"
	local uri = "/ISteamUser/GetPlayerSummaries/v0002/?key=" .. GlobalSettings.APIKey .. "&steamids=" .. player:GetSteamId().id
	MakeRequest(host, uri, 80, function(response)
		if response and IsValid(player) then
			local status, err = pcall(function()
				local userdata = (json.decode(response)).response.players[1] -- Use whatever json library you have
				local url = userdata.avatar:gsub("http://", "")
				local host = url:sub(0, url:find("/") - 1)
        
				local uri = url:sub(url:find("/"), #url)




				MakeRequest(host, uri, 80, function(response)
					if response and IsValid(player) then
						player:SetNetworkValue("avatar_s", tostring(mime.b64(response)))
            print("Successfully retrieved " .. player:GetName() .. "'s avatar in " .. execTimer:GetSeconds() .. " seconds.")
					elseif IsValid(player) then
						print("Failed to fetch " .. player:GetName() .. "'s avatar!")
					else
						print("Player no longer exists.")
					end
				end)
			end)
			
			if not status then
				print(err)
			end
		elseif IsValid(player) then
			print("Failed to fetch userdata for " .. player:GetName() .. "!")
		else
			print("Player no longer exists.")
		end
	end)
end

function DownloadPictures:FetchAvatar_m(player)
	local host = "api.steampowered.com"
	local uri = "/ISteamUser/GetPlayerSummaries/v0002/?key=" .. GlobalSettings.APIKey .. "&steamids=" .. player:GetSteamId().id
	MakeRequest(host, uri, 80, function(response)
		if response and IsValid(player) then
			local status, err = pcall(function()
        print(response)
				local userdata = (json.decode(response)).response.players[1] -- Use whatever json library you have
        print(userdata)
				local url = userdata.avatarmedium:gsub("http://", "")
				local host = url:sub(0, url:find("/") - 1)
        
				local uri = url:sub(url:find("/"), #url)

				


				MakeRequest(host, uri, 80, function(response)
					if response and IsValid(player) then
						player:SetNetworkValue("avatar_m", tostring(mime.b64(response)))
            print("Successfully retrieved " .. player:GetName() .. "'s avatar in " .. execTimer:GetSeconds() .. " seconds.")
					elseif IsValid(player) then
						print("Failed to fetch " .. player:GetName() .. "'s avatar!")
					else
						print("Player no longer exists.")
					end
				end)
			end)
			
			if not status then
				print(err)
			end
		elseif IsValid(player) then
			print("Failed to fetch userdata for " .. player:GetName() .. "!")
		else
			print("Player no longer exists.")
		end
	end)
end

DownloadPictures = DownloadPictures()

function Player:GetAvatar(size)
  
  steamid64 = self:GetSteamId().id
  
  print("Requesting " .. self:GetName() .. "'s avatar.")
  
  if size == "small" then
    DownloadPictures:FetchAvatar_s(self)
  elseif size == "medium" then
    DownloadPictures:FetchAvatar_m(self)
  elseif size == "large" then
    DownloadPictures:FetchAvatar_l(self)
  end

end

function Player:ssid()
  return tostring(self:GetSteamId())
end

Network:Subscribe("RequestPing", function(args, player)
    local nArgs = player:GetPing()
    Network:Send(player, "DeliverPing", nArgs)
end)

function PlayerQuitCache(args)
    if args.player:GetValue("avatar_s") != nil then
      cachedAvatars.small[tostring(args.player:GetSteamId())] = args.player:GetValue("avatar_s")
    end
    
    if args.player:GetValue("avatar_m") != nil then
      cachedAvatars.medium[tostring(args.player:GetSteamId())] = args.player:GetValue("avatar_m")
    end
    
    if args.player:GetValue("avatar_l") != nil then
      cachedAvatars.large[tostring(args.player:GetSteamId())] = args.player:GetValue("avatar_l")
    end
end

if GlobalSettings.CacheAvatarOnLeave then
  Events:Subscribe("PlayerQuit", PlayerQuitCache)
end