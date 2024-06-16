-- fix_floating/mapgen.lua
-- The mapgen thread
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

-- LUALOCALS < ---------------------------------------------------------
local minetest, pairs = minetest, pairs
-- LUALOCALS > ---------------------------------------------------------

local replace_nodes = {}

local ID = minetest.get_content_id
local function init_data()
    init_data = function() end

    for name, def in pairs(minetest.registered_nodes) do
        if def._falling_replace then
            replace_nodes[ID(name)] = ID(def._falling_replace)
        end
    end
end

-- https://dev.minetest.net/Mapgen_memory_optimisations
local data = {}

local CONTENT_AIR = minetest.CONTENT_AIR
local get_mapgen_object = minetest.get_mapgen_object
minetest.register_on_generated(function(vm, minp, maxp)
    init_data()

    local vminp, vmaxp = vm:get_emerged_area()
    local va = VoxelArea(vminp, vmaxp)
    vm:get_data(data)

    -- Iterate through generated blocks
    for i in va:iterp(minp, maxp) do
        local pos = va:position(i)
        pos.y = pos.y - 1
        local below = va:indexp(pos)

        if data[below] == CONTENT_AIR then
            local targ = replace_nodes[data[i]]
            if targ then
                data[i] = targ
            end
        end
    end

    vm:set_data(data)
end)
