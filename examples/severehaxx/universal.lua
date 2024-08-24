function get_players() --// this can be modified to work on any game, just make sure you've correctly adjusted the get_character function and that this returns a table
    return getchildren(players_service);
end;

function get_character(player)

    --[[ custom character example

    local character = {
        Head = path.Head,
        HumanoidRootPart = path.HumanoidRootPart
    }

    ]]--]] just return that

    return getcharacter(player); --// getcharacter is a built in severe function
end;

function is_localplayer(player)
    return player == getlocalplayer();
end
