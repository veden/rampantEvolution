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


if guiG then
    return guiG
end

-- imports

-- constants

-- import functions

-- module code

local gui = {}

function gui.roundTo(x, multipler)
    return math.floor(x / multipler) * multipler
end

function gui.create(player, world)
    local guis = player.gui.screen.children
    for i=1,#guis do
        if guis[i].name == "rampant-evolution--metrics" then
            return guis[i]
        end
    end
    local panel = player.gui.screen.add({
            type="frame",
            name="rampant-evolution--metrics",
            direction="vertical",
            caption="Evolution Metrics"
    })
    panel.auto_center = true
    local contentPanel = panel.add({type="frame", name="contentPanel", direction="horizontal"})
    local contents = contentPanel.add({type="table", name="contentTable", column_count=2})
    contents.draw_horizontal_lines = true
    contents.vertical_centering = true
    contents.add({
            type = "label",
            caption = {"description.rampant-evolution--evolution"},
            tooltip = {"tooltip.rampant-evolution--evolution"}
    })
    contents.add({
            type = "label",
            name = "EvolutionValue",
            tooltip = {"tooltip.rampant-evolution--evolution"}
    })

    if world.evolutionPerTileAbsorbed ~= 0 then
        contents.add({
                type = "label",
                caption = {"description.rampant-evolution--tile"},
                tooltip = {"tooltip.rampant-evolution--tile"}
        })
        contents.add({
                type = "label",
                name = "TileValue",
                tooltip = {"tooltip.rampant-evolution--tile"}
        })
    end

    if world.evolutionPerTreeAbsorbed ~= 0 then
        contents.add({
                type = "label",
                caption = {"description.rampant-evolution--tree"},
                tooltip = {"tooltip.rampant-evolution--tree"}
        })
        contents.add({
                type = "label",
                name = "TreeValue",
                tooltip = {"tooltip.rampant-evolution--tree"}
        })
    end

    if world.evolutionPerTreeDied ~= 0 then
        contents.add({
                type = "label",
                caption = {"description.rampant-evolution--dyingTree"},
                tooltip = {"tooltip.rampant-evolution--dyingTree"}
        })
        contents.add({
                type = "label",
                name = "DyingTreeValue",
                tooltip = {"tooltip.rampant-evolution--dyingTree"}
        })
    end

    if world.evolutionPerSpawnerAbsorbed ~= 0 then
        contents.add({
                type = "label",
                caption = {"description.rampant-evolution--absorbed"},
                tooltip = {"tooltip.rampant-evolution--absorbed"}
        })
        contents.add({
                type = "label",
                name = "AbsorbedValue",
                tooltip = {"tooltip.rampant-evolution--absorbed"}
        })
    end

    if world.evolutionPerSpawnerKilled ~= 0 then
        contents.add({
                type = "label",
                caption = {"description.rampant-evolution--spawner"},
                tooltip = {"tooltip.rampant-evolution--spawner"}
        })
        contents.add({
                type = "label",
                name = "SpawnerValue",
                tooltip = {"tooltip.rampant-evolution--spawner"}
        })
    end

    if world.evolutionPerHiveKilled ~= 0 then
        contents.add({
                type = "label",
                caption = {"description.rampant-evolution--hive"},
                tooltip = {"tooltip.rampant-evolution--hive"}
        })
        contents.add({
                type = "label",
                name = "HiveValue",
                tooltip = {"tooltip.rampant-evolution--hive"}
        })
    end

    if world.evolutionPerUnitKilled ~= 0 then
        contents.add({
                type = "label",
                caption = {"description.rampant-evolution--unit"},
                tooltip = {"tooltip.rampant-evolution--unit"}
        })
        contents.add({
                type = "label",
                name = "UnitValue",
                tooltip = {"tooltip.rampant-evolution--unit"}
        })
    end

    if world.evolutionPerWormKilled ~= 0 then
        contents.add({
                type = "label",
                caption = {"description.rampant-evolution--worm"},
                tooltip = {"tooltip.rampant-evolution--worm"}
        })
        contents.add({
                type = "label",
                name = "WormValue",
                tooltip = {"tooltip.rampant-evolution--worm"}
        })
    end

    if world.evolutionPerPollution ~= 0 then
        contents.add({
                type = "label",
                caption = {"description.rampant-evolution--totalPollution"},
                tooltip = {"tooltip.rampant-evolution--totalPollution"}
        })
        contents.add({
                type = "label",
                name = "TotalPollutionValue",
                tooltip = {"tooltip.rampant-evolution--totalPollution"}
        })
    end

    if world.evolutionPerTime ~= 0 then
        contents.add({
                type = "label",
                caption = {"description.rampant-evolution--time"},
                tooltip = {"tooltip.rampant-evolution--time"}
        })
        contents.add({
                type = "label",
                name = "TimeValue",
                tooltip = {"tooltip.rampant-evolution--time"}
        })
    end

    if world.minimumDevolutionPercentage ~= 0 then
        contents.add({
                type = "label",
                caption = {"description.rampant-evolution--minimumEvolution"},
                tooltip = {"tooltip.rampant-evolution--minimumEvolution"}
        })
        contents.add({
                type = "label",
                name = "MinimumEvolutionValue",
                tooltip = {"tooltip.rampant-evolution--minimumEvolution"}
        })
    end

    contents.add({
            type = "label",
            caption = {"description.rampant-evolution--shortChange"},
            tooltip = {"tooltip.rampant-evolution--shortChange"}
    })
    contents.add({
            type = "label",
            name = "ShortChangeValue",
            tooltip = {"tooltip.rampant-evolution--shortChange"}
    })

    contents.add({
            type = "label",
            caption = {"description.rampant-evolution--longChange"},
            tooltip = {"tooltip.rampant-evolution--longChange"}
    })
    contents.add({
            type = "label",
            name = "LongChangeValue",
            tooltip = {"tooltip.rampant-evolution--longChange"}
    })

    contents.add({
            type = "label",
            caption = {"description.rampant-evolution--longLongChange"},
            tooltip = {"tooltip.rampant-evolution--longLongChange"}
    })
    contents.add({
            type = "label",
            name = "LongLongChangeValue",
            tooltip = {"tooltip.rampant-evolution--longLongChange"}
    })


    return panel
end

function gui.close(world, playerIndex)
    local guiPanel = world.playerGuiOpen[playerIndex]
    if guiPanel then
        guiPanel.destroy()
        world.playerGuiOpen[playerIndex] = nil
    end
end

function gui.update(world, playerId, tick)
    local guiPanel = world.playerGuiOpen[playerId]
    if guiPanel then
        if not world.playerGuiTick[playerId] or
            (tick - world.playerGuiTick[playerId]) >= world.displayEvolutionMsgInterval
        then
            world.playerGuiTick[playerId] = tick
        else
            return
        end
        local enemy = game.forces.enemy
        local contentTable = guiPanel.contentPanel.contentTable
        local stats = world.stats
        if contentTable.EvolutionValue then
            contentTable.EvolutionValue.caption =
                tostring(gui.roundTo(enemy.evolution_factor*100,0.001)).."%"
        end

        if contentTable.TileValue then
            contentTable.TileValue.caption =
                tostring(gui.roundTo(stats["tile"]*100, 0.001)).."%"
        end

        if contentTable.TreeValue then
            contentTable.TreeValue.caption =
                tostring(gui.roundTo(stats["tree"]*100, 0.001)).."%"
        end

        if contentTable.DyingTreeValue then
            contentTable.DyingTreeValue.caption =
                tostring(gui.roundTo(stats["dyingTree"]*100, 0.001)).."%"
        end

        if contentTable.AbsorbedValue then
            contentTable.AbsorbedValue.caption =
                tostring(gui.roundTo(stats["absorbed"]*100, 0.001)).."%"
        end

        if contentTable.SpawnerValue then
            contentTable.SpawnerValue.caption =
                tostring(gui.roundTo(stats["spawner"]*100, 0.001)).."%"
        end

        if contentTable.HiveValue then
            contentTable.HiveValue.caption =
                tostring(gui.roundTo(stats["hive"]*100, 0.001)).."%"
        end

        if contentTable.UnitValue then
            contentTable.UnitValue.caption =
                tostring(gui.roundTo(stats["unit"]*100, 0.001)).."%"
        end

        if contentTable.WormValue then
            contentTable.WormValue.caption =
                tostring(gui.roundTo(stats["worm"]*100, 0.001)).."%"
        end

        if contentTable.TotalPollutionValue then
            contentTable.TotalPollutionValue.caption =
                tostring(gui.roundTo(stats["totalPollution"]*100, 0.001)).."%"
        end

        if contentTable.TimeValue then
            contentTable.TimeValue.caption =
                tostring(gui.roundTo(stats["time"]*100, 0.001)).."%"
        end

        if contentTable.MinimumEvolutionValue then
            contentTable.MinimumEvolutionValue.caption =
                tostring(gui.roundTo(stats["minimumEvolution"]*100, 0.001)).."%"
        end

        contentTable.ShortChangeValue.caption =
            tostring(gui.roundTo(world.lastChangeShort*100, 0.001)).."%"

        contentTable.LongChangeValue.caption =
            tostring(gui.roundTo(world.lastChangeLong*100, 0.001)).."%"

        contentTable.LongLongChangeValue.caption =
            tostring(gui.roundTo(world.lastChangeLongLong*100, 0.001)).."%"
    end
end

guiGend = gui
return gui
