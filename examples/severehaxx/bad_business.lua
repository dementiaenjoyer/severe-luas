function get_players()
    local plrs = {}
    for _, player in getchildren(findfirstchild(workspace_service, "Characters")) do
        plrs[#plrs+1] = player
    end
    return plrs
end;

function get_character(player)

    local body = findfirstchild(player, "Body")
    local character = {
        Head = findfirstchild(body, "Head"),
        HumanoidRootPart = findfirstchild(body, "Chest")
    }

    return character

end;

function is_localplayer(player)
    local char = get_character(player)
    if char and char.HumanoidRootPart then

        local pos = getposition(char.HumanoidRootPart)
        local cam_pos = getcframe(camera).position

        return calculate_distance_3d({pos.x, pos.y, pos.z}, {cam_pos.x, cam_pos.y, cam_pos.z}) < 3
        
    end
end
