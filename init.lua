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

local function set_falling_replace(nodename, replacename)
    minetest.override_item(nodename, {
        _falling_replace = replacename
    })
end

if minetest.get_modpath("default") then
    set_falling_replace("default:sand", "default:sandstone")
    set_falling_replace("default:silver_sand", "default:silver_sandstone")
    set_falling_replace("default:desert_sand", "default:desert_sandstone")
    set_falling_replace("default:gravel", "default:stone")
end

if minetest.get_modpath("ethereal") then
    set_falling_replace("ethereal:sandy", "default:sandstone")
end

minetest.register_mapgen_script(minetest.get_modpath("fix_floating") .. DIR_DELIM .. "mapgen.lua")
