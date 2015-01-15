Network:Subscribe("ClientIsMurderer", function()
    localKillcount = localKillcount + 1
end)

Network:Subscribe("ClientIsMurdered", function()
    localDeathcount = localDeathcount + 1
end)

PingTimer = Timer()

Events:Subscribe("Render", function()
    if PingTimer:GetSeconds() > 10 then
      Network:Send("RequestPing")
      PingTimer:Restart()
    end
end)

Network:Subscribe("DeliverPing", function(args)
    localPing = args
end)

Network:Send("RequestPing")