PicturesTable = {}
PlayerTable = {}

startpos = Vector2(Render.Width/2, 0)
width = Render.Width/2
rowHeight = 50

placeholderAvatar = Image.Create(AssetLocation.Base64,
"/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAAgACADASIAAhEBAxEB/8QAGQAAAgMBAAAAAAAAAAAAAAAAAgUABgcD/8QALBAAAgEBBgQEBwAAAAAAAAAAAQIDAAQFBhIhMREiMnETFFGBFiVBQmGRwf/EABQBAQAAAAAAAAAAAAAAAAAAAAD/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIRAxEAPwDI2Zs7cx3ooo57RKsUKSSyNoqICxPsKButu9WfDGLFwvdd5+Us3za0hUhtZAIhUHXQ+v8ABQVyaK0WaVop45IpF3SRSpHsaBWbOvMd60fH01otGCcPT374fxBIzMTlCuYNeGYDb7dO/wCazdete9BG6270xw+eGJLsPljauFqiPgDhxl5hy66a7a0vZWztyneiieaCZJoWeOVGDI6EhlI2IP0NA8xteVrvTF14T2yOWGQSZBDKQTEo0C6afqkC9a966TST2mZ5p3kllc8WdyWZj6knegVWzryneg//2Q==")

Network:Subscribe("AvatarData", function(args)
    PicturesTable[tostring(LocalPlayer:GetSteamId())] = Image.Create(AssetLocation.Base64, args)
end)

active = false

PlayerCount = 0

pos = startpos
pos.x = pos.x - width/2

function TogglePList(args)
  if args.key == 9 then
    active = not active
    print("Active changed...")
    Events:Fire("ActiveChanged")
  end
end

Events:Subscribe("KeyDown", TogglePList)

function ActiveChanged()
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

function Cleanup()
  if not active then
    for i, v in pairs(PicturesTable) do
      PicturesTable[i] = nil
    end
    
    PicturesTable = {}
  end
end

Events:Subscribe("ActiveChanged", ActiveChanged)
if not GlobalSettings.StoreB64OnClient then
  Events:Subscribe("ActiveChanged", Cleanup)
end

function ReceiveNewAvatar(args)
  PicturesTable[tostring(args.player:GetSteamId())] = Image.Create(AssetLocation.Base64, args.b64)
  print("Created entry for player", args.player:GetName(), "in pictures table.")
end

Network:Subscribe("AvatarObtained", ReceiveNewAvatar)
  

function RenderFunction()
  if active then
    Network:Send("RequestAllPlayers", LocalPlayer)
    pos = startpos
    PlayerCount = 0
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
      
      if PicturesTable[tostring(player:GetSteamId())] then
        local pic = PicturesTable[tostring(player:GetSteamId())]
        pic:SetPosition(pos + Vector2(10, (rowHeight/6)))
        pic:Draw()
      else
        placeholderAvatar:SetPosition(pos + Vector2(10, (rowHeight/6)))
        placeholderAvatar:Draw()
      end
        
      
      pos = pos + Vector2(0, rowHeight)
    end
  end
end

Network:Subscribe("HereAreYourPlayers", function(args)
    if PlayerTable != args then
      PlayerTable = args
    end
end)

Events:Subscribe("Render", RenderFunction)
