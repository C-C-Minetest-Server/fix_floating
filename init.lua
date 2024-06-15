-- fix_floating/init.lua
-- Avoid hanging sands and gravels
--[[
    Copyright (C) 2023  1F616EMO

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301
    USA
]]

local get_mapgen_object = minetest.get_mapgen_object
local VoxelArea = VoxelArea

local ID = minetest.get_content_id
local list_nodes = {}

if minetest.get_modpath("default") then
    list_nodes[ID("default:sand")] = ID("default:sandstone")
    list_nodes[ID("default:silver_sand")] = ID("default:silver_sandstone")
    list_nodes[ID("default:desert_sand")] = ID("default:desert_sandstone")
    list_nodes[ID("default:gravel")] = ID("default:stone")
end

if minetest.get_modpath("ethereal") then
    list_nodes[ID("ethereal:sandy")] = ID("default:sandstone")
end

-- https://dev.minetest.net/Mapgen_memory_optimisations
local data = {}

local CONTENT_AIR = minetest.CONTENT_AIR
minetest.register_on_generated(function(minp, maxp, blockseed)
    local vm = get_mapgen_object("voxelmanip")
    local vminp, vmaxp

    -- Load at least one block below
    do
        local nminp = { x = minp.x, y = minp.y - 1, z = minp.z }
        local nmaxp = { x = maxp.x, y = minp.y - 1, z = maxp.z }

        vminp, vmaxp = vm:read_from_map(nminp, nmaxp)
    end

    local va = VoxelArea(vminp, vmaxp)
    vm:get_data(data)

    -- Iterate through generated blocks
    for i in va:iterp(minp, maxp) do
        local pos = va:position(i)
        pos.y = pos.y - 1
        local below = va:indexp(pos)

        if data[below] == CONTENT_AIR then
            local targ = list_nodes[data[i]]
            if targ then
                data[i] = targ
            end
        end
    end

    vm:set_data(data)

    vm:write_to_map(true)
end)

fix_floating = {
    list_nodes = list_nodes
}
