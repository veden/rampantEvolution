-- imports

-- local constants = require("libs/Constants")

-- constants

local settingToPercent = 1/10000000

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

    world.getFlowQuery = {
        name = "",
        input = false,
        precision_index = defines.flow_precision_index.five_seconds,
        -- precision_index = defines.flow_precision_index.one_minute,
        count = true
    }

    return true
end

local function onConfigChanged()
    if not world.version or world.version < 3 then
        world.version = 3

        onModSettingsChange()

        world.kills = {}
        world.pollution = {}
        game.forces.enemy.evolution_factor = 0

        game.print("Rampant Evolution - Version 1.1.0")
    end
end

local function onStatsGrabPollution()
    local enemyForce = game.forces.enemy
    local evo = enemyForce.evolution_factor
    local negativeEvo = evo
    local positiveEvo = evo

    local pollutionStats = game.pollution_statistics
    local counts = pollutionStats.output_counts

    for name,count in pairs(counts) do
        local previousCount = world.pollution[name]
        local delta
        if not previousCount then
            world.pollution[name] = count
            delta = count
        else
            delta = count - previousCount
        end

        if delta ~= 0 then
            if (name == "tile-proxy") then
                if (world.evolutionPerTileAbsorbed < 0) then
                    negativeEvo = negativeEvo + ((1 - negativeEvo) * world.evolutionPerTileAbsorbed * delta)
                else
                    positiveEvo = positiveEvo + ((1 - positiveEvo) * world.evolutionPerTileAbsorbed * delta)
                end
            elseif (name == "tree-proxy") then
                if (world.evolutionPerTreeAbsorbed < 0) then
                    negativeEvo = negativeEvo + ((1 - negativeEvo) * world.evolutionPerTreeAbsorbed * delta)
                else
                    positiveEvo = positiveEvo + ((1 - positiveEvo) * world.evolutionPerTreeAbsorbed * delta)
                end
            elseif (name == "dying-tree-proxy") then
                if (world.evolutionPerTreeDied < 0) then
                    negativeEvo = negativeEvo + ((1 - negativeEvo) * world.evolutionPerTreeDied * delta)
                else
                    positiveEvo = positiveEvo + ((1 - positiveEvo) * world.evolutionPerTreeDied * delta)
                end

            elseif isValidSpawnerConsumer(name) then
                if (world.evolutionPerSpawnerAbsorbed < 0) then
                    negativeEvo = negativeEvo + ((1 - negativeEvo) * world.evolutionPerSpawnerAbsorbed * delta)
                else
                    positiveEvo = positiveEvo + ((1 - positiveEvo) * world.evolutionPerSpawnerAbsorbed * delta)
                end
            end
        end
    end

    local negativeEvoDelta = evo - negativeEvo
    if negativeEvoDelta < 0 then
        negativeEvoDelta = 0
        evo = 0
    end

    local positiveEvoDelta = positiveEvo - evo

    enemyForce.evolution_factor = (evo - negativeEvoDelta) + positiveEvoDelta
end

local function onStatsGrabKill()
    local enemyForce = game.forces.enemy
    local killStats = game.forces.enemy.kill_count_statistics

    local evo = enemyForce.evolution_factor
    local negativeEvo = evo
    local positiveEvo = evo
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
            if isValidSpawnerConsumer(name) then
                if (world.evolutionPerSpawnerKilled < 0) then
                    negativeEvo = negativeEvo + ((1 - negativeEvo) * world.evolutionPerSpawnerKilled * delta)
                else
                    positiveEvo = positiveEvo + ((1 - positiveEvo) * world.evolutionPerSpawnerKilled * delta)
                end
            elseif isValidHiveConsumer(name) then
                if (world.evolutionPerHiveKilled < 0) then
                    negativeEvo = negativeEvo + ((1 - negativeEvo) * world.evolutionPerHiveKilled * delta)
                else
                    positiveEvo = positiveEvo + ((1 - positiveEvo) * world.evolutionPerHiveKilled * delta)
                end
            elseif isValidUnit(name) then
                if (world.evolutionPerUnitKilled < 0) then
                    negativeEvo = negativeEvo + ((1 - negativeEvo) * world.evolutionPerUnitKilled * delta)
                else
                    positiveEvo = positiveEvo + ((1 - positiveEvo) * world.evolutionPerUnitKilled * delta)
                end
            end
        end
    end

    local negativeEvoDelta = evo - negativeEvo
    if (negativeEvoDelta < 0) then
        negativeEvoDelta = 0
        evo = 0
    end

    local positiveEvoDelta = positiveEvo - evo

    enemyForce.evolution_factor = (evo - negativeEvoDelta) + positiveEvoDelta
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

script.on_nth_tick((5*60*60)+0, onStatsGrabPollution)
script.on_nth_tick((5*60*60)+1, onStatsGrabKill)

script.on_init(onInit)
script.on_load(onLoad)
script.on_event(defines.events.on_runtime_mod_setting_changed, onModSettingsChange)
script.on_configuration_changed(onConfigChanged)
