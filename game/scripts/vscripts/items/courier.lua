require('lib/admins')

local personal_cour_ids = {
	[112315140	] = 1, -- aleshka
	[136098003	] = 1, -- homie
	[126897357	] = 1, -- alky
	[172156859	] = 1, -- Sanctus Animus
	[191556216  ] = 1, -- #SUPREME
	[336405700	] = 1, -- chinese translate 1 
	[143154036	] = 1, -- chinese translate 2
	[101963165	] = 1, -- sasha, for load-screen
	[67000847	] = 1, -- fury, for load-screen
}

AngelArenaAdmins:ForeachAdminID( function(steamid)
	personal_cour_ids[steamid] = 1
end)

LinkLuaModifier("modifier_courier", 'modifiers/modifier_courier', LUA_MODIFIER_MOTION_NONE)

function OnSpellStart(keys)
	local hero = keys.caster
	local player = hero:GetPlayerOwner()
	local pid = player:GetPlayerID()
	local steam_account_id = PlayerResource:GetSteamAccountID( player:GetPlayerID() )
	_G.pers_cour = _G.pers_cour or {}

	UTIL_Remove(keys.ability);
	if(not hero:IsRealHero() ) then return end
	
	if(not _G.pers_cour[pid] and personal_cour_ids[steam_account_id] ) then
		local has_cour = false;
		local couriers = Entities:FindAllByName("npc_dota_courier") 
		
		for _, x in pairs(couriers) do
			if x and IsValidEntity(x) and x:GetTeamNumber() == hero:GetTeamNumber() then has_cour = true; end
		end

		if not has_cour then 
			print("creating private courier")
			local cr = CreateUnitByName("npc_dota_courier", hero:GetAbsOrigin() + RandomVector(RandomFloat(100, 100)), true, nil, hero, hero:GetTeamNumber())
			cr:AddNewModifier(cr, nil, "modifier_courier", {duration = -1})
			for i = 0, 20 do
  			local temp_ply = PlayerResource:GetPlayer(i)
  			if(temp_ply and IsValidEntity(temp_ply)) then
  				Timers:CreateTimer(.1, function()
  					if(temp_ply:GetTeamNumber() == cr:GetTeamNumber() ) then
  						cr:SetControllableByPlayer(i, true)
  					end
  				end)		
  			end
  		end
			return 
		end

		local cr = CreateUnitByName("npc_dota_courier", hero:GetAbsOrigin() + RandomVector(RandomFloat(100, 100)), true, nil, hero, hero:GetTeamNumber())
		cr:AddNewModifier(cr, nil, "modifier_courier", {duration = -1})
		Timers:CreateTimer(.1, function()
			print("creating private courier")
     		cr:SetControllableByPlayer(hero:GetPlayerID(), true)
     		cr.personal = pid;
     		
  			_G.pers_cour[pid] = cr;
  		end)	
  		
  	else 
  		local cr = CreateUnitByName("npc_dota_courier", hero:GetAbsOrigin() + RandomVector(RandomFloat(100, 100)), true, nil, hero, hero:GetTeamNumber())
		cr:AddNewModifier(cr, nil, "modifier_courier", {duration = -1})
  		for i = 0, 20 do
  			local temp_ply = PlayerResource:GetPlayer(i)
  			if(temp_ply and IsValidEntity(temp_ply)) then
  				Timers:CreateTimer(.1, function()
  					if(temp_ply:GetTeamNumber() == cr:GetTeamNumber() ) then
  						cr:SetControllableByPlayer(i, true)
  					end
  				end)		
  			end
  		end
	end
end
