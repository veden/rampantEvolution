-- imports

-- local constants = require("libs/Constants")

-- constants

local settingToPercent = 1e-7

-- imported functions

local sFind = string.find

-- local references

local world

-- module code

local function isValidSpawnerConsumer(name)
    return sFind(name, "spawner")
end

local function isValidHiveConsumer(name)
    return sFind(name, "hive") or sFind(name, "utility")
end

local function isValidUnit(name)
    return not (isValidSpawnerConsumer(name) or isValidHiveConsumer(name)) and (sFind(name, "biter") or sFind(name, "spitter"))
end

local function onStatsGrabPollution()
    local pollutionStats = game.pollution_statistics
    local counts = pollutionStats.output_counts

    for name,count in pairs(counts) do
        local previousCount = world.pollutionConsumed[name]
        local delta
        if not previousCount then
            world.pollutionConsumed[name] = count
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
            local delta
            if not previousCount then
                world.pollutionProduced[name] = count
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
        local delta
        if not previousCount then
            world.kills[name] = count
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
        ["totalPollution"] = 0,
        ["time"] = 0
    }
end

local function onModSettingsChange(event)

    if event and (string.sub(event.setting, 1, #"rampant-evolution") ~= "rampant-evolution") then
        return false
    end

    world.evolutionPerSpawnerAbsorbed = settings.global["rampant-evolution-evolutionPerSpawnerAbsorbed"].value * settingToPercent
    world.evolutionPerTreeAbsorbed = settings.global["rampant-evolution-evolutionPerTreeAbsorbed"].value * settingToPercent
    world.evolutionPerTreeDied = settings.global["rampant-evolution-evolutionPerTreeDied"].value * settingToPercent
    world.evolutionPerTileAbsorbed = settings.global["rampant-evolution-evolutionPerTileAbsorbed"].value * settingToPercent
    world.evolutionPerSpawnerKilled = settings.global["rampant-evolution-evolutionPerSpawnerKilled"].value * settingToPercent
    world.evolutionPerUnitKilled = settings.global["rampant-evolution-evolutionPerUnitKilled"].value * settingToPercent
    world.evolutionPerHiveKilled = settings.global["rampant-evolution-evolutionPerHiveKilled"].value * settingToPercent

    world.evolutionPerTime = settings.global["rampant-evolution--evolutionPerTime"].value * settingToPercent
    world.evolutionPerPollution = settings.global["rampant-evolution--evolutionPerPollution"].value * settingToPercent

    world.displayEvolutionMsg = settings.global["rampant-evolution--displayEvolutionMsg"].value
    world.displayEvolutionMsgInterval = math.ceil(settings.global["rampant-evolution--displayEvolutionMsgInterval"].value * (60 * 60))

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
    if not world.version or world.version < 4 then
        world.version = 4

        reset()

        onModSettingsChange()

        game.print("Rampant Evolution - Version 1.2.0")
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

local function roundTo(x, multipler)
    return math.floor(x / multipler) * multipler
end

local function printEvolutionMsg()
    local enemy = game.forces.enemy
    local stats = world.stats
    game.print({
            "description.rampant-evolution--displayEvolutionMsg",
            roundTo(enemy.evolution_factor*100,0.01),
            roundTo(stats["tile"]*100, 0.01),
            roundTo(stats["tree"]*100, 0.01),
            roundTo(stats["dyingTree"]*100, 0.01),
            roundTo(stats["absorbed"]*100, 0.01),
            roundTo(stats["spawner"]*100, 0.01),
            roundTo(stats["hive"]*100, 0.01),
            roundTo(stats["unit"]*100, 0.01),
            roundTo(stats["totalPollution"]*100, 0.01),
            roundTo(stats["time"]*100, 0.01)
    })
end

local function onProcessing(event)
    local enemy = game.forces.enemy
    enemy.evolution_factor = processKill(
        processPollution(
            enemy.evolution_factor,
            1000
        ),
        1000
    )
    if (event.tick % 60) == 0 then
        world.killDeltas["time"] = (world.killDeltas["time"] or 0) + 1
    end

    if world.displayEvolutionMsg and ((event.tick % world.displayEvolutionMsgInterval) == 0) then
        printEvolutionMsg()
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

-- hooks

script.on_nth_tick((2.5*60*60)+0, onStatsGrabPollution)
script.on_nth_tick((2.5*60*60)+1, onStatsGrabKill)
script.on_nth_tick((2.5*60*60)+2, onStatsGrabTotalPollution)
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
