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
            type = "int-setting",
            name = "rampant-evolution--processingPerTick",
            setting_type = "runtime-global",
            minimum_value = 1,
            default_value = 5,
            maximum_value = 300,
            order = "l[modifier]-m[unit]",
            per_user = false
        },

        {
            type = "bool-setting",
            name = "rampant-evolution--toggleResearchEvolutionMultipler",
            setting_type = "runtime-global",
            default_value = false,
            order = "l[modifier]-z[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--startResearchMultipler",
            setting_type = "runtime-global",
            minimum_value = -10000,
            default_value = 0,
            maximum_value = 10000,
            order = "l[modifier]-z[unit]z",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--endResearchMultipler",
            setting_type = "runtime-global",
            minimum_value = -10000,
            default_value = 0,
            maximum_value = 10000,
            order = "l[modifier]-z[unit]zz",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--researchMultiplerExponent",
            setting_type = "runtime-global",
            minimum_value = -10000,
            default_value = 1,
            maximum_value = 10000,
            order = "l[modifier]-z[unit]zzz",
            per_user = false
        },

        {
            type = "bool-setting",
            name = "rampant-evolution--toggleTickEvolutionMultipler",
            setting_type = "runtime-global",
            default_value = false,
            order = "l[modifier]-zz[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--startTickMultipler",
            setting_type = "runtime-global",
            minimum_value = -10000,
            default_value = 0,
            maximum_value = 10000,
            order = "l[modifier]-zz[unit]z",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--endTickMultipler",
            setting_type = "runtime-global",
            minimum_value = -10000,
            default_value = 0,
            maximum_value = 10000,
            order = "l[modifier]-zz[unit]zz",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--tickMultiplerExponent",
            setting_type = "runtime-global",
            minimum_value = -10000,
            default_value = 1,
            maximum_value = 10000,
            order = "l[modifier]-zz[unit]zzz",
            per_user = false
        },

        {
            type = "int-setting",
            name = "rampant-evolution--totalTickMultipler",
            setting_type = "runtime-global",
            minimum_value = 1,
            default_value = 60 * 40,
            maximum_value = 10000000000,
            order = "l[modifier]-zz[unit]zzz",
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
        },

        {
            type = "double-setting",
            name = "rampant-evolution--evolutionPerLowPlayer",
            setting_type = "runtime-global",
            minimum_value = -100000,
            maximum_value = 100000,
            default_value = 0,
            order = "l[modifier]-mza[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--evolutionPerMediumPlayer",
            setting_type = "runtime-global",
            minimum_value = -100000,
            maximum_value = 100000,
            default_value = 0,
            order = "l[modifier]-mzb[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--evolutionPerHighPlayer",
            setting_type = "runtime-global",
            minimum_value = -100000,
            maximum_value = 100000,
            default_value = 0,
            order = "l[modifier]-mzc[unit]",
            per_user = false
        },

        {
            type = "bool-setting",
            name = "rampant-evolution--researchEvolutionCap",
            setting_type = "runtime-global",
            default_value = false,
            order = "l[modifier]-oz[unit]",
            per_user = false
        },

        {
            type = "bool-setting",
            name = "rampant-evolution--researchEvolutionCapIncludeUpgrades",
            setting_type = "runtime-global",
            default_value = true,
            order = "l[modifier]-oz[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--technology-automation-science-multipler",
            setting_type = "runtime-global",
            minimum_value = 0,
            default_value = 1,
            maximum_value = 10000,
            order = "l[modifier]-oza[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--technology-logistic-science-multipler",
            setting_type = "runtime-global",
            minimum_value = 0,
            default_value = 1,
            maximum_value = 10000,
            order = "l[modifier]-ozb[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--technology-military-science-multipler",
            setting_type = "runtime-global",
            minimum_value = 0,
            default_value = 1,
            maximum_value = 10000,
            order = "l[modifier]-ozc[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--technology-chemical-science-multipler",
            setting_type = "runtime-global",
            minimum_value = 0,
            default_value = 1,
            maximum_value = 10000,
            order = "l[modifier]-ozd[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--technology-production-science-multipler",
            setting_type = "runtime-global",
            minimum_value = 0,
            default_value = 1,
            maximum_value = 10000,
            order = "l[modifier]-oze[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--technology-utility-science-multipler",
            setting_type = "runtime-global",
            minimum_value = 0,
            default_value = 1,
            maximum_value = 10000,
            order = "l[modifier]-ozf[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-evolution--technology-space-science-multipler",
            setting_type = "runtime-global",
            minimum_value = 0,
            default_value = 1,
            maximum_value = 10000,
            order = "l[modifier]-ozg[unit]",
            per_user = false
        }
})
