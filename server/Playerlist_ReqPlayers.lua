Network:Subscribe("RequestAllPlayers", function(args, player)
    nArgs = {}
    for player in Server:GetPlayers() do
      table.insert(nArgs, player)
    end
    
    Network:Send(player, "HereAreYourPlayers", nArgs)
end)

Events:Subscribe("PlayerDeath", function(args)
    if IsValid(args.killer) then
      Network:Send(args.killer, "ClientIsMurderer")
    end
    Network:Send(args.player, "ClientIsMurdered")
end)