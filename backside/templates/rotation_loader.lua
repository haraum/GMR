--This file is part of the AmsTaFFix' GMR plugins/profiles distribution
--(https://github.com/AmsTaFFix/gmr-stuff).
--Copyright (C) 2022 Nikita Sapogov
--
--This program is free software: you can redistribute it and/or modify
--it under the terms of the GNU General Public License as published by
--the Free Software Foundation, either version 3 of the License, or
--(at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.
--
--You should have received a copy of the GNU General Public License
--along with this program.  If not, see <https://www.gnu.org/licenses/>.

local ID = "CR>TODO/TODO"
local LIB_LINK = "TODO"
local ROTATION_LINK = "TODO"
---@type MageArcaneV1Config
local Config = {
    ---Toggle debug mode. Turn on, if you encounter some issues and want to deal with it, or record a video and send
    ---to author.
    debug = false,
    ---Use standard CombatRotation pluggable function. Change only if you know what you are doing.
    useCombatRotationLauncher = true,
    ---Use online loading feature to get last updates
    onlineLoad = true,
    ---Character names to force load that rotation
    forceLoadForCharacters = {},


    useTrinket1 = false,
    useTrinket1Type = 1, -- 1:self-buff, 2:target-harmful, 3:aoe-harmful

    useTrinket2 = false,
    useTrinket2Type = 1, -- 1:self-buff, 2:target-harmful, 3:aoe-harmful
}

local function printDbg(msg)
    if Config.debug then
        GMR.Print("[" .. ID .. "][DEBUG] " .. msg)
    end
end

do
    local msgPrefix = "[" .. ID .. "] "
    if Config.onlineLoad then
        GMR.SendHttpRequest({
            Url = LIB_LINK,
            Method = "Get",
            Callback = function(content)
                printDbg("library has been downloaded, now we'll try to execute it")
                RunScript(content)
                if not amstlib then
                    GMR.Print(msgPrefix .. "AmsTaFFix' Lib do not initialized properly")
                    return
                end

                printDbg("library successfully initialized, start work with rotation")
                local cr = amstlib:getCombatRotation(ID)
                cr:prepare(Config)
                printDbg("rotation has been prepared, start loading the file with rotation")
                cr:load(ROTATION_LINK)
            end
        })
    else
        GMR.Print(msgPrefix .. "Offline loading of rotation initiated")
        if amstlib then
            local cr = amstlib:getCombatRotation(ID)
            cr:prepare(Config)
            if Config.onlineLoad then
                cr:load(ROTATION_LINK)
            end
        else
            GMR.Print(msgPrefix .. "AmsTaFFix' Lib do not initialized properly")
        end
    end
end