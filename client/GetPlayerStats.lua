Network:Subscribe("ClientIsMurderer", function()
    Killcount = Killcount + 1
end)

Network:Subscribe("ClientIsMurdered", function()
    Deathcount = Deathcount + 1
    print("Adding 1 to deathcount")
end)

PingTimer = Timer()

Events:Subscribe("Render", function()
    if PingTimer:GetSeconds() > 10 then
      Network:Send("RequestPing")
      PingTimer:Restart()
    end
end)



Network:Send("RequestPing")