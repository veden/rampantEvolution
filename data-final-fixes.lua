local presents = data.raw['map-gen-presets'].default

if settings.startup["rampant-evolution--shortcut-bar"].value then
    data:extend({
            {
                type = "shortcut",
                name = "rampant-evolution--info",
                action = "lua",
                localised_name = {"controls.rampant-evolution--toggle_evolution_info"},
                toggleable = true,
                icon =
                    {
                        filename = "__core__/graphics/icons/alerts/warning-icon.png",
                        priority = "extra-high-no-scale",
                        scale = 0.25,
                        size = 64,
                        flags = {"icon"}
                    }
            }
    })
end

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
