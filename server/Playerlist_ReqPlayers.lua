Network:Subscribe("RequestAllPlayers", function(args, player)
    nArgs = {}
    for player in Server:GetPlayers() do
      table.insert(nArgs, player)
    end
    
    Network:Send(player, "HereAreYourPlayers", nArgs)
end)