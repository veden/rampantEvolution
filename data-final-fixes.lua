local presents = data.raw['map-gen-presets'].default

-- change scenarios like death world
for present, data in pairs(presents) do
    if (present ~= "type") and (present ~= "name") and (present ~= "default") then
        if not data.advanced_settings then
            data.advanced_settings = {
                enemy_evolution = {
                    time_factor=0,
                    destroy_factor=0,
                    pollution_factor=0
                }
            }
        else
            data.advanced_settings.enemy_evolution = {
                time_factor=0,
                destroy_factor=0,
                pollution_factor=0
            }
        end
    end
end

-- change new map defaults
data.raw['map-settings']['map-settings'].enemy_evolution = {
    enabled=true,
    time_factor=0,
    destroy_factor=0,
    pollution_factor=0
}


