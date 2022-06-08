-- Copyright (C) 2022  veden

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.


data:extend({

        {
            type = "bool-setting",
            name = "rampant-evolution--displayEvolutionMsg",
            setting_type = "runtime-global",
            default_value = false,
            order = "l[modifier]-m[unit]",
            per_user = false
        },

        {
            type = "bool-setting",
            name = "rampant-evolution--shortcut-bar",
            setting_type = "startup",
            default_value = true,
            order = "a[modifier]-b[unit]",
            per_user = false
        },

        {
            type = "bool-setting",
            name = "rampant-evolution--setMapSettingsToZero",
            setting_type = "runtime-global",
            default_value = true,
            order = "l[modifier]-m[unit]",
            per_user = false
        },

        {
            type = "int-setting",
            name = "rampant-evolution--evolutionResolutionLevel",
            setting_type = "runtime-global",
            minimum_value = 0,
            default_value = 0,
            maximum_value = 100000,
            order = "l[modifier]-m[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--minimumDevolutionPercentage",
            setting_type = "runtime-global",
            minimum_value = 0,
            default_value = 0,
            maximum_value = 1,
            order = "l[modifier]-m[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--displayEvolutionMsgInterval",
            setting_type = "runtime-global",
            minimum_value = 0.001,
            default_value = 10.0,
            maximum_value = 9999999999,
            order = "l[modifier]-m[unit]",
            per_user = false
        },

        {
            type = "bool-setting",
            name = "rampant-evolution--recalculateAllEvolution",
            setting_type = "runtime-global",
            default_value = true,
            order = "l[modifier]-m[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution-evolutionPerSpawnerAbsorbed",
            setting_type = "runtime-global",
            minimum_value = -100000,
            maximum_value = 100000,
            default_value = 15.75,
            order = "l[modifier]-m[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution-evolutionPerTreeAbsorbed",
            setting_type = "runtime-global",
            minimum_value = -100000,
            maximum_value = 100000,
            default_value = -8,
            order = "l[modifier]-m[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution-evolutionPerTreeDied",
            setting_type = "runtime-global",
            minimum_value = -100000,
            maximum_value = 100000,
            default_value = 27,
            order = "l[modifier]-m[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution-evolutionPerTileAbsorbed",
            setting_type = "runtime-global",
            minimum_value = -100000,
            maximum_value = 100000,
            default_value = 7,
            order = "l[modifier]-m[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution-evolutionPerSpawnerKilled",
            setting_type = "runtime-global",
            minimum_value = -100000,
            maximum_value = 100000,
            default_value = 300,
            order = "l[modifier]-m[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--evolutionPerWormKilled",
            setting_type = "runtime-global",
            minimum_value = -100000,
            maximum_value = 100000,
            default_value = 0,
            order = "l[modifier]-mx[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution-evolutionPerHiveKilled",
            setting_type = "runtime-global",
            minimum_value = -100000,
            maximum_value = 100000,
            default_value = -30000,
            order = "l[modifier]-m[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution-evolutionPerUnitKilled",
            setting_type = "runtime-global",
            minimum_value = -100000,
            maximum_value = 100000,
            default_value = -10,
            order = "l[modifier]-m[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--evolutionPerTime",
            setting_type = "runtime-global",
            minimum_value = -100000,
            maximum_value = 100000,
            default_value = 0,
            order = "l[modifier]-mz[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--evolutionPerPollution",
            setting_type = "runtime-global",
            minimum_value = -100000,
            maximum_value = 100000,
            default_value = 0,
            order = "l[modifier]-mz[unit]",
            per_user = false
        }
})
