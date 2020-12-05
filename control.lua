-- imports

-- local constants = require("libs/Constants")

-- constants

local settingToPercent = 1/10000000

local entitySet

-- imported functions

local mLog10 = math.log10
local mRandom = math.random
local mSqrt = math.sqrt
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

    if event and (string.sub(event.setting, 1, 17) ~= "rampant-evolution") then
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
        name = name,
        input = false,
        -- precision_index = defines.flow_precision_index.one_second,
        precision_index = defines.flow_precision_index.one_minute,
        count = true
    }

    return true
end

local function onConfigChanged()
    if not world.version or world.version < 2 then

        for i,p in ipairs(game.connected_players) do
            p.print("Rampant Evolution - Version 1.0.0")
        end
        world.version = 1
    end
    onModSettingsChange()
end

local function onTick(event)
    local enemyForce = game.forces.enemy
    local evo = enemyForce.evolution_factor
    local query = world.getFlowQuery

    -- print(evo)

    local pollutionStats = game.pollution_statistics
    local counts = pollutionStats.output_counts

    local pollutionFn = pollutionStats.get_flow_count
    for name,value in pairs(counts) do
        query.name = name
        if (name == "tile-proxy") and (world.evolutionPerTileAbsorbed < 0) then
            evo = evo + ((1 - evo) * world.evolutionPerTileAbsorbed * pollutionFn(query))
        elseif (name == "tree-proxy") and (world.evolutionPerTreeAbsorbed < 0) then
            evo = evo + ((1 - evo) * world.evolutionPerTreeAbsorbed * pollutionFn(query))
        elseif (name == "dying-tree-proxy") and (world.evolutionPerTreeDied < 0) then
            evo = evo + ((1 - evo) * world.evolutionPerTreeDied * pollutionFn(query))
        elseif (world.evolutionPerSpawnerAbsorbed < 0) and isValidSpawnerConsumer(name) then
            evo = evo + ((1 - evo) * world.evolutionPerSpawnerAbsorbed * pollutionFn(query))
        end
        if (evo < 0) then
            evo = 0
        end
    end

    for name,value in pairs(counts) do
        query.name = name
        if (name == "tile-proxy") and (world.evolutionPerTileAbsorbed > 0) then
            evo = evo + ((1 - evo) * world.evolutionPerTileAbsorbed * pollutionFn(query))
        elseif (name == "tree-proxy") and (world.evolutionPerTreeAbsorbed > 0) then
            evo = evo + ((1 - evo) * world.evolutionPerTreeAbsorbed * pollutionFn(query))
        elseif (name == "dying-tree-proxy") and (world.evolutionPerTreeDied > 0) then
            evo = evo + ((1 - evo) * world.evolutionPerTreeDied * pollutionFn(query))
        elseif (world.evolutionPerSpawnerAbsorbed > 0) and isValidSpawnerConsumer(name) then
            evo = evo + ((1 - evo) * world.evolutionPerSpawnerAbsorbed * pollutionFn(query))
        end
    end

    local killStats = enemyForce.kill_count_statistics

    counts = killStats.output_counts
    local killFn = killStats.get_flow_count

    for name,value in pairs(counts) do
        query.name = name
        if (world.evolutionPerSpawnerKilled < 0) and isValidSpawnerConsumer(name) then
            evo = evo + ((1 - evo) * world.evolutionPerSpawnerKilled * killFn(query))
        elseif (world.evolutionPerHiveKilled < 0) and isValidHiveConsumer(name) then
            evo = evo + ((1 - evo) * world.evolutionPerHiveKilled * killFn(query))
        elseif (world.evolutionPerUnitKilled < 0) and isValidUnit(name) then
            evo = evo + ((1 - evo) * world.evolutionPerUnitKilled * killFn(query))
        end
        if (evo < 0) then
            evo = 0
        end
    end

    for name,value in pairs(counts) do
        query.name = name
        if (world.evolutionPerSpawnerKilled > 0) and isValidSpawnerConsumer(name) then
            evo = evo + ((1 - evo) * world.evolutionPerSpawnerKilled * killFn(query))
        elseif (world.evolutionPerHiveKilled > 0) and isValidHiveConsumer(name) then
            evo = evo + ((1 - evo) * world.evolutionPerHiveKilled * killFn(query))
        elseif (world.evolutionPerUnitKilled > 0) and isValidUnit(name) then
            evo = evo + ((1 - evo) * world.evolutionPerUnitKilled * killFn(query))
        end
    end

    enemyForce.evolution_factor = evo
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

script.on_nth_tick(60*60, onTick)
-- script.on_nth_tick(60, onTick)
script.on_init(onInit)
script.on_load(onLoad)
script.on_event(defines.events.on_runtime_mod_setting_changed, onModSettingsChange)
script.on_configuration_changed(onConfigChanged)
