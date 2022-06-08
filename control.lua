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


-- imports

local gui = require("libs/Gui")

--[[
    Vanilla factors
    time_factor
    :: double
    The amount evolution naturally progresses by every second. Defaults to 0.000004.

    destroy_factor
    :: double
    The amount evolution progresses for every destroyed spawner. Defaults to 0.002.

    pollution_factor
    :: double
    The amount evolution progresses for every unit of pollution. Defaults to 0.0000009.


    Pollution production is the total pollution produced by buildings per tick, not the
    pollution spreading on the map, so it is not reduced by trees or other absorbers.
    e.g. : 10 boilers produce 300 pollution in one minute, raising the evolution factor
    by around 0.027%.

    The percentages are applied on the base of (1 - current_evolution_factor)². So
    for instance destroying enemy spawners in the beginning of the game results in
    increase of evolution factor by 0.002 (0.2%) while doing this when the evolution
    factor is 0.5 the increase is only 0.0005 (0.05%).

    This also means that the evolution factor approaches 1 asymptotically - generally,
    increases past 0.9 or so are very slow and the number never actually reaches 1.0.
--]]

-- constants

local SETTINGS_TO_PERCENT = 1e-7
local SHORT_EVOLUTION_CHECK_DURATION = 5 * 60 * 60
local LONG_EVOLUTION_CHECK_DURATION = 30 * 60 * 60
local LONG_LONG_EVOLUTION_CHECK_DURATION = 60 * 60 * 60

-- imported functions

local sFind = string.find
local mMin = math.min
local roundTo = gui.roundTo

-- local references

local world

-- module code

local function isValidSpawnerConsumer(name)
    return sFind(name, "-spawner")
end

local function isValidWorm(name)
    return sFind(name, "-worm")
end

local function isValidHiveConsumer(name)
    return sFind(name, "-hive")
end

local function isValidUnit(name)
    return sFind(name, "biter") or sFind(name, "spitter")
end

local function onStatsGrabPollution()
    local pollutionStats = game.pollution_statistics
    local counts = pollutionStats.output_counts

    for name,count in pairs(counts) do
        local previousCount = world.pollutionConsumed[name]
        world.pollutionConsumed[name] = count
        local delta
        if not previousCount then
            delta = count
        else
            delta = count - previousCount
        end

        if delta ~= 0 then
            world.pollutionDeltas[name] = (world.pollutionDeltas[name] or 0) + delta
        end
    end
end

local function onStatsGrabTotalPollution()
    if world.evolutionPerPollution ~= 0 then
        local pollutionStats = game.pollution_statistics
        local counts = pollutionStats.input_counts

        for name,count in pairs(counts) do
            local previousCount = world.pollutionProduced[name]
            world.pollutionProduced[name] = count
            local delta
            if not previousCount then
                delta = count
            else
                delta = count - previousCount
            end

            if delta ~= 0 then
                world.pollutionDeltas["totalPollution"] = (world.pollutionDeltas["totalPollution"] or 0) + delta
            end
        end
    end
end

local function onStatsGrabKill()
    local killStats = game.forces.enemy.kill_count_statistics

    local counts = killStats.output_counts

    for name,count in pairs(counts) do
        local previousCount = world.kills[name]
        world.kills[name] = count
        local delta
        if not previousCount then
            delta = count
        else
            delta = count - previousCount
        end

        if delta ~= 0 then
            world.killDeltas[name] = (world.killDeltas[name] or 0) + delta
        end
    end
end

local function reset()
    world.killDeltasIterator = nil
    world.pollutionDeltasIterator = nil
    world.kills = {}
    world.killDeltas = {
        ["time"] = math.floor(game.tick / 60)
    }
    world.pollutionConsumed = {}
    world.pollutionProduced = {}
    world.pollutionDeltas = {}
    world.stats = {
        ["tile"] = 0,
        ["tree"] = 0,
        ["dyingTree"] = 0,
        ["absorbed"] = 0,
        ["spawner"] = 0,
        ["hive"] = 0,
        ["unit"] = 0,
        ["worm"] = 0,
        ["totalPollution"] = 0,
        ["time"] = 0,
        ["minimumEvolution"] = 0
    }
end

local function onModSettingsChange(event)

    if event and (string.sub(event.setting, 1, #"rampant-evolution") ~= "rampant-evolution") then
        return false
    end

    world.evolutionPerSpawnerAbsorbed = settings.global["rampant-evolution-evolutionPerSpawnerAbsorbed"].value * SETTINGS_TO_PERCENT
    world.evolutionPerTreeAbsorbed = settings.global["rampant-evolution-evolutionPerTreeAbsorbed"].value * SETTINGS_TO_PERCENT
    world.evolutionPerTreeDied = settings.global["rampant-evolution-evolutionPerTreeDied"].value * SETTINGS_TO_PERCENT
    world.evolutionPerTileAbsorbed = settings.global["rampant-evolution-evolutionPerTileAbsorbed"].value * SETTINGS_TO_PERCENT
    world.evolutionPerSpawnerKilled = settings.global["rampant-evolution-evolutionPerSpawnerKilled"].value * SETTINGS_TO_PERCENT
    world.evolutionPerUnitKilled = settings.global["rampant-evolution-evolutionPerUnitKilled"].value * SETTINGS_TO_PERCENT
    world.evolutionPerHiveKilled = settings.global["rampant-evolution-evolutionPerHiveKilled"].value * SETTINGS_TO_PERCENT
    world.evolutionPerWormKilled = settings.global["rampant-evolution--evolutionPerWormKilled"].value * SETTINGS_TO_PERCENT

    world.evolutionPerTime = settings.global["rampant-evolution--evolutionPerTime"].value * SETTINGS_TO_PERCENT
    world.evolutionPerPollution = settings.global["rampant-evolution--evolutionPerPollution"].value * SETTINGS_TO_PERCENT

    world.displayEvolutionMsg = settings.global["rampant-evolution--displayEvolutionMsg"].value
    world.displayEvolutionMsgInterval = math.ceil(settings.global["rampant-evolution--displayEvolutionMsgInterval"].value * (60 * 60))

    world.minimumDevolutionPercentage = settings.global["rampant-evolution--minimumDevolutionPercentage"].value

    world.evolutionResolutionLevel = settings.global["rampant-evolution--evolutionResolutionLevel"].value

    if settings.global["rampant-evolution--setMapSettingsToZero"].value then
        game.map_settings.enemy_evolution.enabled = false
    else
        game.map_settings.enemy_evolution.enabled = true
    end

    if settings.global["rampant-evolution--recalculateAllEvolution"].value then
        reset()
        game.forces.enemy.evolution_factor = 0
        game.print({"description.rampant-evolution--refreshingEvolution"})
    end

    onStatsGrabPollution()
    onStatsGrabKill()
    onStatsGrabTotalPollution()

    if not settings.global["rampant-evolution--recalculateAllEvolution"].value then
        world.killDeltasIterator = nil
        world.pollutionDeltasIterator = nil
        world.killDeltas = {}
        world.pollutionDeltas = {}
    end

    return true
end

local function onConfigChanged()
    if not world.version or world.version < 7 then
        world.version = 7

        reset()

        onModSettingsChange()

        world.playerGuiOpen = {}
        world.playerGuiTick = {}

        world.lastChangeShortTick = 0
        world.lastChangeShortEvolution = 0
        world.lastChangeShort = 0
        world.lastChangeLongTick = 0
        world.lastChangeLongEvolution = 0
        world.lastChangeLong = 0
        world.lastChangeLongLongTick = 0
        world.lastChangeLongLongEvolution = 0
        world.lastChangeLongLong = 0
    end
    if not world.version or world.version < 8 then
        world.version = 8

        world.playerIterator = nil

        game.print("Rampant Evolution - Version 1.4.2")
    end
end

local function processKill(evo, initialRunsRemaining)
    local name = world.killDeltasIterator
    local count
    if not name then
        name,count = next(world.killDeltas, nil)
    else
        count = world.killDeltas[name]
    end
    if not name then
        return evo
    end
    world.killDeltasIterator = next(world.killDeltas, name)
    local runsRemaining = math.min(initialRunsRemaining, count)
    count = count - runsRemaining
    if count <= 0 then
        world.killDeltas[name] = nil
    else
        world.killDeltas[name] = count
    end

    local stats = world.stats
    if name == "time" then
        if world.evolutionPerTime ~= 0 then
            while (runsRemaining > 0) do
                runsRemaining = runsRemaining - 1
                local contribution = ((1 - evo)^2) * world.evolutionPerTime
                evo = evo + contribution
                stats["time"] = stats["time"] + contribution
            end
        end
    elseif isValidSpawnerConsumer(name) then
        if world.evolutionPerSpawnerKilled ~= 0 then
            while (runsRemaining > 0) do
                runsRemaining = runsRemaining - 1
                local contribution = ((1 - evo)^2) * world.evolutionPerSpawnerKilled
                evo = evo + contribution
                stats["spawner"] = stats["spawner"] + contribution
            end
        end
    elseif isValidHiveConsumer(name) then
        if world.evolutionPerHiveKilled ~= 0 then
            while (runsRemaining > 0) do
                runsRemaining = runsRemaining - 1
                local contribution = ((1 - evo)^2) * world.evolutionPerHiveKilled
                evo = evo + contribution
                stats["hive"] = stats["hive"] + contribution
            end
        end
    elseif isValidWorm(name) then
        if world.evolutionPerWormKilled ~= 0 then
            while (runsRemaining > 0) do
                runsRemaining = runsRemaining - 1
                local contribution = ((1 - evo)^2) * world.evolutionPerWormKilled
                evo = evo + contribution
                stats["worm"] = stats["worm"] + contribution
            end
        end
    elseif isValidUnit(name) then
        if world.evolutionPerUnitKilled ~= 0 then
            while (runsRemaining > 0) do
                runsRemaining = runsRemaining - 1
                local contribution = ((1 - evo)^2) * world.evolutionPerUnitKilled
                evo = evo + contribution
                stats["unit"] = stats["unit"] + contribution
            end
        end
    end

    if evo < 0 then
        evo = 0
    end
    return evo
end

local function processPollution(evo, initialRunsRemaining)
    local name = world.pollutionDeltasIterator
    local count
    if not name then
        name,count = next(world.pollutionDeltas, nil)
    else
        count = world.pollutionDeltas[name]
    end
    if not name then
        return evo
    end
    world.pollutionDeltasIterator = next(world.pollutionDeltas, name)
    local runsRemaining = math.min(initialRunsRemaining, count)
    count = count - runsRemaining
    if count <= 0 then
        world.pollutionDeltas[name] = nil
    else
        world.pollutionDeltas[name] = count
    end

    local stats = world.stats
    if (name == "tile-proxy") then
        if world.evolutionPerTileAbsorbed ~= 0 then
            while (runsRemaining > 0) do
                runsRemaining = runsRemaining - 1
                local contribution = ((1 - evo)^2) * world.evolutionPerTileAbsorbed
                evo = evo + contribution
                stats["tile"] = stats["tile"] + contribution
            end
        end
    elseif (name == "tree-proxy") then
        if world.evolutionPerTreeAbsorbed ~= 0 then
            while (runsRemaining > 0) do
                runsRemaining = runsRemaining - 1
                local contribution = ((1 - evo)^2) * world.evolutionPerTreeAbsorbed
                evo = evo + contribution
                stats["tree"] = stats["tree"] + contribution
            end
        end
    elseif (name == "tree-dying-proxy") then
        if world.evolutionPerTreeDied ~= 0 then
            while (runsRemaining > 0) do
                runsRemaining = runsRemaining - 1
                local contribution = ((1 - evo)^2) * world.evolutionPerTreeDied
                evo = evo + contribution
                stats["dyingTree"] = stats["dyingTree"] + contribution
            end
        end
    elseif (name == "totalPollution") then
        if world.evolutionPerPollution ~= 0 then
            while (runsRemaining > 0) do
                runsRemaining = runsRemaining - 1
                local contribution = ((1 - evo)^2) * world.evolutionPerPollution
                evo = evo + contribution
                stats["totalPollution"] = stats["totalPollution"] + contribution
            end
        end
    elseif isValidSpawnerConsumer(name) then
        if world.evolutionPerSpawnerAbsorbed ~= 0 then
            while (runsRemaining > 0) do
                runsRemaining = runsRemaining - 1
                local contribution = ((1 - evo)^2) * world.evolutionPerSpawnerAbsorbed
                evo = evo + contribution
                stats["absorbed"] = stats["absorbed"] + contribution
            end
        end
    end

    if evo < 0 then
        evo = 0
    end
    return evo
end

local function printEvolutionMsg()
    local enemy = game.forces.enemy
    local stats = world.stats
    game.print({
            "description.rampant-evolution--displayEvolutionMsg",
            roundTo(enemy.evolution_factor*100,0.001),
            roundTo(stats["tile"]*100, 0.001),
            roundTo(stats["tree"]*100, 0.001),
            roundTo(stats["dyingTree"]*100, 0.001),
            roundTo(stats["absorbed"]*100, 0.001),
            roundTo(stats["spawner"]*100, 0.001),
            roundTo(stats["hive"]*100, 0.001),
            roundTo(stats["unit"]*100, 0.001),
            roundTo(stats["worm"]*100, 0.001),
            roundTo(stats["totalPollution"]*100, 0.001),
            roundTo(stats["time"]*100, 0.001),
            roundTo(stats["minimumEvolution"]*100, 0.001),
            roundTo(world.lastChangeShort*100, 0.001),
            roundTo(world.lastChangeLong*100, 0.001),
            roundTo(world.lastChangeLongLong*100, 0.001)
    })
end

local function linearInterpolation(percent, min, max)
    return ((max - min) * percent) + min
end

local function onProcessing(event)
    local tick = event.tick
    local enemy = game.forces.enemy
    local resolutionLevel = world.evolutionResolutionLevel
    if resolutionLevel == 0 then
        local x = tick / 17280000 -- (60 * 60 * 60 * 80)
        resolutionLevel = linearInterpolation(
            mMin(x, 1),
            20,
            4000
        )
    end
    local evo = processKill(
        processPollution(
            enemy.evolution_factor,
            resolutionLevel
        ),
        resolutionLevel
    )
    if (tick % 60) == 0 then
        world.killDeltas["time"] = (world.killDeltas["time"] or 0) + 1
    end

    local newMinimumEvolution = enemy.evolution_factor * world.minimumDevolutionPercentage
    if newMinimumEvolution > world.stats["minimumEvolution"] then
        world.stats["minimumEvolution"] = newMinimumEvolution
    end
    if evo < world.stats["minimumEvolution"] then
        evo = world.stats["minimumEvolution"]
    end
    enemy.evolution_factor = evo

    if (tick - world.lastChangeShortTick) >= SHORT_EVOLUTION_CHECK_DURATION then
        world.lastChangeShortTick = tick
        world.lastChangeShort = evo - world.lastChangeShortEvolution
        world.lastChangeShortEvolution = evo
    end

    if (tick - world.lastChangeLongTick) >= LONG_EVOLUTION_CHECK_DURATION then
        world.lastChangeLongTick = tick
        world.lastChangeLong = evo - world.lastChangeLongEvolution
        world.lastChangeLongEvolution = evo
    end

    if (tick - world.lastChangeLongLongTick) >= LONG_LONG_EVOLUTION_CHECK_DURATION then
        world.lastChangeLongLongTick = tick
        world.lastChangeLongLong = evo - world.lastChangeLongLongEvolution
        world.lastChangeLongLongEvolution = evo
    end

    if world.displayEvolutionMsg and ((tick % world.displayEvolutionMsgInterval) == 0) then
        printEvolutionMsg()
    end

    local playerId = world.playerIterator
    if not playerId then
        world.playerIterator = next(game.connected_players, world.playerIterator)
    else
        world.playerIterator = next(game.connected_players, playerId)
        gui.update(world, playerId, tick)
    end
end

local function onInit()
    global.world = {}

    world = global.world

    onConfigChanged()
end

local function onLoad()
    world = global.world
end

local function onLuaShortcut(event)
    if event.prototype_name == "rampant-evolution--info" then
        local playerIndex = event.player_index
        local guiPanel = world.playerGuiOpen[playerIndex]
        if not guiPanel then
            world.playerGuiOpen[playerIndex] = gui.create(game.players[playerIndex], world)
        else
            gui.close(world, event.player_index)
            world.playerGuiOpen[playerIndex] = nil
            world.playerGuiTick[playerIndex] = 0
        end
    end
end

local function onPlayerRemoved(event)
    world.playerIterator = nil
end

-- hooks

script.on_event(
    {
        defines.events.on_player_left_game,
        defines.events.on_player_kicked,
        defines.events.on_player_removed,
        defines.events.on_player_banned
    },
    onPlayerRemoved)
script.on_event(defines.events.on_lua_shortcut, onLuaShortcut)
script.on_nth_tick((2*60*60)+0, onStatsGrabPollution)
script.on_nth_tick((2*60*60)+1, onStatsGrabKill)
script.on_nth_tick((2*60*60)+2, onStatsGrabTotalPollution)
script.on_event(defines.events.on_tick, onProcessing)

script.on_init(onInit)
script.on_load(onLoad)
script.on_event(defines.events.on_runtime_mod_setting_changed, onModSettingsChange)
script.on_configuration_changed(onConfigChanged)

-- commands

local function rampantEvolution(event)
    printEvolutionMsg()
end

commands.add_command('rampantEvolution', "", rampantEvolution)
