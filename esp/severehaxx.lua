--// services

local workspace_service = findservice(game, "Workspace")
local players_service = findservice(game, "Players")

--// variables

local storage = {
    schedular = {start_time = tick()},
    cache = {}
}
local camera = findfirstchild(workspace_service, "Camera")

--

do --// main

    do --// funcs

        do --// math

            function calculate_distance_3d(end_pos, origin_pos)

                local x = end_pos[1] - origin_pos[1]
                local y = end_pos[2] - origin_pos[2]
                local z = end_pos[3] - origin_pos[3]

                return math.sqrt(x * x + y * y + z * z)

            end

        end

        do --// object caching

            function cache_object(object)
                if not storage.cache[object] then

                    local to_cache = {
                        box_outline = Drawing.new("Square"),
                        box = Drawing.new("Square")
                    }
                    storage.cache[object] = to_cache

                end
            end

            function uncache_object(object)
                if object and storage.cache[object] then
                    
                    for _, cached_obj in storage.cache[object] do
                        pcall(function()
                            if cached_obj then
                                cached_obj:Remove()
                            end
                        end)
                    end

                    storage.cache[object] = nil

                end
            end

            function clean_cache()

                local active_players = get_players()

                for player, _ in storage.cache do

                    if not table.find(active_players, player) then
                        uncache_object(player)
                    end

                end


            end

        end

        do --// players

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

        end

    end

    while true do

        do --// features

            do --// visuals

                for _, player in get_players() do
                   
                    if player and not is_localplayer(player) then

                        local character = get_character(player)

                        if character then

                            cache_object(player)

                            local player_cache = storage.cache[player]

                            if player_cache then

                                local esp_root = nil
                                local character_type = type(character)

                                if character_type == "userdata" and findfirstchild(character, "HumanoidRootPart") then
                                    esp_root = findfirstchild(character, "HumanoidRootPart")
                                elseif character_type == "table" and character.HumanoidRootPart then
                                    esp_root = character.HumanoidRootPart
                                end

                                if esp_root then

                                    local box = player_cache.box
                                    local box_outline = player_cache.box_outline
                                    --
                                    local camera_pos = getcframe(camera).position
                                    local enemy_pos = getposition(esp_root)
                                    local w2s_pos, onscreen = worldtoscreenpoint({enemy_pos.x, enemy_pos.y, enemy_pos.z})
                                    --
                                    local distance = calculate_distance_3d({camera_pos.x, camera_pos.y, camera_pos.z}, {enemy_pos.x, enemy_pos.y, enemy_pos.z})
                                    local scale = 1000 / distance * 80 / getcamerafov(camera)

                                    if onscreen then
                                        
                                        local box_width, box_height = math.round(4 * scale), math.round(scale * 6)

                                        --// box

                                        box.Visible = true
                                        box.Color = {255, 255, 255}
                                        box.Transparency = 1
                                        box.Size = {box_width, box_height}
                                        box.Position = {math.round(w2s_pos.x - box_width / 2), math.round(w2s_pos.y - box_height / 2)}
                                        box.Thickness = 1

                                        -- outline

                                        box_outline.Visible = true
                                        box_outline.Color = {0, 0, 0}
                                        box_outline.Transparency = 1
                                        box_outline.Thickness = 3
                                        box_outline.Position = {box.Position.x, box.Position.y}
                                        box_outline.Size = {box.Size.x, box.Size.y}

                                    else

                                        uncache_object(player)

                                    end
                                else

                                    uncache_object(player)

                                end

                            end
                        else

                            uncache_object(player)

                        end

                    else

                        uncache_object(player)

                    end
                end

                clean_cache()

            end

        end

    end

end
