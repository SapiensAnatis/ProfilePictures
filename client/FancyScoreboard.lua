class("FancyScoreboard")

function FancyScoreboard:__init()  
  PicturesTable = {}
  PlayerTable = {}
  PingTable = {}
  

  startpos = Vector2(Render.Width/2, 0)
  width = Render.Width/2
  rowHeight = 50

  active = false

  PlayerCount = 0
  
  localKillcount = 0
  localDeathcount = 0
  localPing = 0

  pos = startpos
  pos.x = pos.x - width/2

  placeholderAvatar = Image.Create(AssetLocation.Base64,
"/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAAgACADASIAAhEBAxEB/8QAGQAAAgMBAAAAAAAAAAAAAAAAAgUABgcD/8QALBAAAgEBBgQEBwAAAAAAAAAAAQIDAAQFBhIhMREiMnETFFGBFiVBQmGRwf/EABQBAQAAAAAAAAAAAAAAAAAAAAD/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIRAxEAPwDI2Zs7cx3ooo57RKsUKSSyNoqICxPsKButu9WfDGLFwvdd5+Us3za0hUhtZAIhUHXQ+v8ABQVyaK0WaVop45IpF3SRSpHsaBWbOvMd60fH01otGCcPT374fxBIzMTlCuYNeGYDb7dO/wCazdete9BG6270xw+eGJLsPljauFqiPgDhxl5hy66a7a0vZWztyneiieaCZJoWeOVGDI6EhlI2IP0NA8xteVrvTF14T2yOWGQSZBDKQTEo0C6afqkC9a966TST2mZ5p3kllc8WdyWZj6knegVWzryneg//2Q==")
  
  Events:Subscribe("KeyDown", self, self.TogglePList)
  Events:Subscribe("ActiveChanged", self, self.ActiveChanged)
  Events:Subscribe("Render", self, self.RenderFunction)
  Events:Subscribe("LocalPlayerInput", self, self.BlockDive)
  
  if not GlobalSettings.StoreB64OnClient then
    Events:Subscribe("ActiveChanged", self, self.Cleanup)
  end
  
  Network:Subscribe("HereAreYourPlayers", self, self.UpdatePlayerTable)
  Network:Subscribe("AvatarObtained", self, self.CacheAvatarData)
end


function FancyScoreboard:TogglePList(args)
  if args.key == 9 then
    active = not active
    print("Active changed...")
    Events:Fire("ActiveChanged")
  end
end



function FancyScoreboard:ActiveChanged()
  Network:Send("ActiveChanged", LocalPlayer)
  -- Request the player avatars for the list
  if active then
    Network:Send("RequestAllPlayers", LocalPlayer)
    for i, player in pairs(PlayerTable) do
      if not PicturesTable[tostring(player:GetSteamId())] then
        if player != LocalPlayer then
          Network:Send("RequestPlayerAvatar", {["size"] = "small", ["player"] = player})
          print("Requesting avatars")
        end
      end
    end
  end
end

function FancyScoreboard:Cleanup()
  if not active then
    for i, v in pairs(PicturesTable) do
      PicturesTable[i] = nil
    end
    
    PicturesTable = {}
  end
end


function FancyScoreboard:CacheAvatarData(args)
  PicturesTable[tostring(args.player:GetSteamId())] = Image.Create(AssetLocation.Base64, args.b64)
  print("Created entry for player", args.player:GetName(), "in pictures table.")
end

  

function FancyScoreboard:RenderFunction()
  if active then
    Network:Send("RequestAllPlayers", LocalPlayer)
    pos = startpos
    PlayerCount = 0
    
    Render:FillArea(pos + Vector2(0, 0), Vector2(width, rowHeight), Color(0, 0, 0, 99*1.5))
    Render:DrawText(pos + Vector2(20+32, (rowHeight/1.5)-8), "Name", Color.White, 17)
    Render:DrawText(pos + Vector2(20+width/6, (rowHeight/1.5)-8), "Kills", Color.White, 17)
    Render:DrawText(pos + Vector2(20+width/4, (rowHeight/1.5)-8), "Deaths", Color.White, 17)
    
    local textpos = pos + Vector2(20+width/4, (rowHeight/1.5)-8)
    Render:DrawText(textpos + Vector2((width/4 - width/6)*1.2, 0), "Ping", Color.White, 17)
    
    
    Render:DrawLine(pos + Vector2(0, rowHeight), pos + Vector2(width, rowHeight), Color.White)

    
    
    pos = pos + Vector2(0, rowHeight)
    for i, player in pairs(PlayerTable) do   
      PlayerCount = PlayerCount + 1
      color = Color(0, 0, 0, 0)
      if PlayerCount % 2 == 0 then 
        color.a = 72*1.5 
      else 
        color.a = 47*1.5
      end
      
      Render:FillArea(pos + Vector2(0, 0), Vector2(width, rowHeight), color)

      
      Render:DrawText(pos + Vector2(20+32, (rowHeight/2)-8), player:GetName(), Color.White, 17)
      Render:DrawText(pos + Vector2(20+width/6, (rowHeight/2)-8), tostring(localKillcount), Color.White, 17)
      Render:DrawText(pos + Vector2(20+width/4, (rowHeight/2)-8), tostring(localDeathcount), Color.White, 17)
      textpos = pos + Vector2(20+width/4, (rowHeight/2)-8)
      Render:DrawText(textpos + Vector2((width/4 - width/6)*1.2, 0), tostring(localPing), Color.White, 17)
      
      if PicturesTable[tostring(player:GetSteamId())] then
        local pic = PicturesTable[tostring(player:GetSteamId())]
        pic:SetPosition(pos + Vector2(10, (rowHeight/6)))
        pic:Draw()
      else
        placeholderAvatar:SetPosition(pos + Vector2(10, (rowHeight/6)))
        placeholderAvatar:Draw()
      end
      
      pos = pos - Vector2(0, rowHeight)
      Render:DrawText(pos + Vector2(20+width/1.24, (rowHeight/1.5)-8), "Total players: " .. PlayerCount, Color.White, 17)
      pos = pos + Vector2(0, rowHeight)
      
      pos = pos + Vector2(0, rowHeight)
    end
  end
end

function FancyScoreboard:UpdatePlayerTable(new)
  if PlayerTable != new then
    PlayerTable = new
  end
end

function FancyScoreboard:BlockDive(args)
  if args.input == 129 then
    return false
  else
    --print(args.input)
  end
end

FancyScoreboard = FancyScoreboard()


