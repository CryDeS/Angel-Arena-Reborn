require('lib/team_helper')
require('lib/output_redirect')

--[[
Admin commands
 -kick 1      				-- helper command to fix teammate-man. 
 -check_userid				-- helper command to fix teammate-man 
 -pause, -p					-- set pause on 
 -unpause, -up				-- set pause off
 -debug_playerinfo 			-- print debug info for our player
 -check_modifiers			-- print modifier list for player hero
 -check_skills				-- print skills and cd list for player hero
 -get_gold					-- print all players gold(pseudo-stash)
 -test						-- make the arena great again
]]

--LinkLuaModifier( "modifier_hero_passive", 'modifiers/modifier_hero_passive', 		LUA_MODIFIER_MOTION_NONE )

Commands = Commands or class({})

local BAN_MODIFIER_NAME = "modifier_banned_custom"
local admin_ids = {
    [73911256] = 1, -- cry
    [104356809] = 1, -- Sheodar
    [136098003] = 1, -- homie
    [144780201] = 1, -- cyberpunk
    [302781235] = 1, -- dimon
}

function IsAdmin(player)
    local steam_account_id = PlayerResource:GetSteamAccountID(player:GetPlayerID())
    return (admin_ids[steam_account_id] == 1)
end

function Commands:kick(player, arg)
    if not IsAdmin(player) then return end

    if not arg[1] then return end

    PlayerResource:ForceDisconnect(tonumber(arg[1]))
end

function Commands:stop(player, arg)
    if not IsAdmin(player) then return end
    if not arg[1] then return end
    
    local hero

    if tonumber(arg[1]) then
        hero = PlayerResource:GetSelectedHeroEntity( tonumber(arg[1]) )
    end

    if hero and hero:GetPlayerOwnerID() and hero:GetUnitName() then
        if hero:HasModifier(BAN_MODIFIER_NAME) then
            hero:RemoveModifierByName(BAN_MODIFIER_NAME)
        else
            hero:AddNewModifier(hero, nil, BAN_MODIFIER_NAME, { duration = -1 })
        end
    end
end

function Commands:check_userid(player, arg)
    if not IsAdmin(player) then return end

    local all_heroes = HeroList:GetAllHeroes()
    for _, hero in pairs(all_heroes) do
        if hero and hero:GetPlayerOwnerID() and hero:GetUnitName() then
            force_print_player(player, "[", hero:GetPlayerOwnerID(), "] - ", hero:GetUnitName())
        end
    end
end

function Commands:setTimerLimit(player,arg)
    if not IsAdmin(player) then return end

    local limit = tonumber(arg[1])

    if not limit then return end

    Timers._timeLimit = limit
end

function Commands:get_output(player, arg)
    if not IsAdmin(player) then return end

    local playerid = player:GetPlayerID()

    OutputRedirection:connect( playerid, not OutputRedirection:isConnected(playerid) )
end

function Commands:pause(player, arg)
    if not IsAdmin(player) then return end

    PauseGame(true)
end

function Commands:p(player, arg) self:pause(player, arg); end

function Commands:unpause(player, arg)
    if not IsAdmin(player) then return end

    PauseGame(false)
end

function Commands:up(player, arg) self:unpause(player, arg); end

function Commands:check_modifiers(player, arg)
    if not IsAdmin(player) then return end

    CheckModifiers(player)
end

function Commands:cm(player, arg)
    if not IsAdmin(player) then return end

    CheckModifiers(player)
end

function Commands:check_skills(player, arg)
    if not IsAdmin(player) then return end

    CheckSkills(player)
end

function Commands:r(player, arg)
    if not IsAdmin(player) then return end

    SendToServerConsole('script_reload');
    SendToServerConsole('script_reload_entity_code');
    SendToConsole('cl_script_reload');
    SendToConsole('cl_script_reload_entity_code');
end

function Commands:rc(player,arg)
	if not IsAdmin(player) then return end

    GameRules:Playtesting_UpdateAddOnKeyValues()
end

function Commands:ctime(player, arg)
    if not IsAdmin(player) then return end

    force_print_player(player, "ctime:")

    if not PlayerResource.__internal__ or not PlayerResource.__internal__["playerid_info"] or not PlayerResource.__internal__["playerid_info"]["connection_times"] then
        force_print_player(player, "something gonna wrong in -ctime")
    end

    for i, x in pairs(PlayerResource.__internal__["playerid_info"]["connection_times"]) do
        if i and x then
            force_print_player(player, i, ":", x)
        end
    end
end

function Commands:cstates(player, arg)
    if not IsAdmin(player) then return end

    local tbl = PlayerResource:GetAllHeroes()
    --print(tbl, #tbl)

    for _, hero in pairs(tbl) do
        local playerid = hero:GetPlayerOwnerID()
        local conn = "-"
        local disc = "-"
        local abad = "-"

        if hero:IsPlayerConnected() then conn = "+" end
        if hero:IsPlayerAbandoned() then abad = "+" end
        if hero:IsPlayerDisconnected() then disc = "+" end

        force_print_player(player, "[", playerid, ":" , hero:GetUnitName(), "] = C[", conn, "] D[", disc, "] A[", abad, "]")
    end
end

function Commands:setcstate(player, arg)
    if not IsAdmin(player) then return end

    if not arg[1] or not arg[2] or not arg[3] then return end

    local pid = tonumber(arg[1])
    local c_type = tonumber(arg[2])
    local val = arg[3]

    if val == "nil" then
        val = nil
    elseif val == "1" then
        val = true
    else
        val = false
    end

    if c_type == 0 then
        PlayerResource:SetConnected(pid, val)
    end

    if c_type == 1 then
        PlayerResource:SetDisconnected(pid, val)
    end

    if c_type == 2 then
        PlayerResource:SetAbandoned(pid, val)
    end
end

--------------------------------------------- Helper functions -----------------------------------------------

function CheckModifiers(player)
    if not player then return end
    local hero = player:GetAssignedHero()

    MouseCursor:OnNearestUnit(player, function(unit)
        force_print_player(player, "Unit '", unit:GetUnitName(), "' modifiers:")

        for i = 0, unit:GetModifierCount() - 1 do
            force_print_player( player, " |->", unit:GetModifierNameByIndex(i) )
        end
    end)
end

function CheckSkills(player)
    if not player then return end
    local hero = player:GetAssignedHero()
    if not hero then end

    force_print_player(player, "hero '", hero:GetUnitName(), "' skills:")
    local ability
    for i = 0, hero:GetAbilityCount() - 1 do
        ability = hero:GetAbilityByIndex(i)
        if ability then
            force_print_player(player, " |->", ability:GetName(), " cd = ", ability:GetCooldownTimeRemaining())
        end
    end
end