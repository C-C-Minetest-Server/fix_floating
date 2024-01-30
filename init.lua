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

fix_floating = {
    list_nodes = {}
}

local ID = minetest.get_content_id

if minetest.get_modpath("default") then
    fix_floating.list_nodes[ID("default:sand")] = ID("default:sandstone")
    fix_floating.list_nodes[ID("default:silver_sand")] = ID("default:silver_sandstone")
    fix_floating.list_nodes[ID("default:desert_sand")] = ID("default:desert_sandstone")
    fix_floating.list_nodes[ID("default:gravel")] = ID("default:stone")
end

if minetest.get_modpath("ethereal") then
    fix_floating.list_nodes[ID("ethereal:sandy")] = ID("default:sandstone")
end

minetest.register_on_generated(function(minp, maxp, blockseed)
    local vm, vminp, vmaxp = minetest.get_mapgen_object("voxelmanip")

    -- Load at least one block below
    do
        local nminp = vector.new(minp.x, minp.y - 1, minp.z)
        local nmaxp = vector.new(maxp.x, minp.y - 1, maxp.z)

        vminp, vmaxp = vm:read_from_map(nminp, nmaxp)
    end

    do
        local va = VoxelArea(vminp, vmaxp)
        local data = vm:get_data()

        -- Iterate through generated blocks
        for i in va:iterp(minp, maxp) do
            local below = va:indexp(vector.subtract(va:position(i), {x=0, y=1, z=0}))

            if data[below] == minetest.CONTENT_AIR then
                local targ = fix_floating.list_nodes[data[i]]
                if targ then
                    data[i] = targ
                end
            end
        end

        vm:set_data(data)
    end

    vm:write_to_map(true)
end)

