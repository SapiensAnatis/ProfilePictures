PicturesTable = {}
PlayerTable = {}

startpos = Vector2(Render.Width/2, 0)
width = Render.Width/2
rowHeight = 50

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
  Network:Send("RequestAllPlayers", LocalPlayer)
  for i, player in pairs(PlayerTable) do
    if not PicturesTable[tostring(player:GetSteamId())] then
      Network:Send("RequestPlayerAvatar", {["size"] = "small", ["player"] = player})
      print("Requesting avatars")
    end
  end
end

Events:Subscribe("ActiveChanged", ActiveChanged)

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
      
      Render:DrawText(pos + Vector2(20+32, (rowHeight/2)-5), player:GetName(), Color.White, 17)
      
      if PicturesTable[tostring(player:GetSteamId())] then
        local pic = PicturesTable[tostring(player:GetSteamId())]
        pic:SetPosition(pos + Vector2(10, (rowHeight/4)))
        pic:Draw()
      else
        --print("Checking pictures table: Entry", player:GetName(), "is nil.")
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
