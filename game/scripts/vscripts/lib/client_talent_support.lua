require('lib/kv_preloaded_data')

-- Already inited
if _ClientTalentSupport then return end

_ClientTalentSupport = class({})

local N_ABILITIES = 24
local MOD_NAME = 'modifier_aa_talent_'

if IsClient() then
	function C_DOTA_BaseNPC:GetTalentSpecialValueFor(tn, field) 
		return _ClientTalentSupport:GetTalentSpecialValueFor(self, tn, field)
	end

	function C_DOTA_BaseNPC:HasTalent(tn) 
		return _ClientTalentSupport:HasTalent(self, tn) 
	end
end

function _ClientTalentSupport:Init()
	if self.inited then return end
	self.inited = true
	
	self.ability_data_table = {}
	self:LoadData()
	self:CreateModifiers()

	if IsServer() then	
		ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(_ClientTalentSupport, 'OnAbilityLearned'), self)
	end
end

function _ClientTalentSupport:LoadData()
	local all_heroes_files 	 = PreloadCache:GetHeroData()
	local all_abilities_file = PreloadCache:GetAbilityData()

	for heroname, herokv_data in pairs(all_heroes_files) do
		for index = 1, N_ABILITIES do
			
			local sIndex = tostring(index)
			local ability_name = herokv_data["Ability" .. sIndex]

			if ability_name and #ability_name then
				local cache_ability_name = heroname .. ability_name

				if all_abilities_file[ability_name] then
					self.ability_data_table[cache_ability_name] = {all_abilities_file[ability_name], sIndex}
				end
			end

		end
	end
end

function _ClientTalentSupport:CreateModifiers()
	function __trueFunc()
		return true
	end

	function __falseFunc()
		return false
	end

	function __getModAttributes()
		return MODIFIER_ATTRIBUTE_PERMANENT
	end

	function _MakeModifier()
		local mod = class({})

		mod.IsHidden 			= __trueFunc

		mod.IsPurgable 			= __falseFunc
		mod.RemoveOnDeath 		= __falseFunc
		mod.DestroyOnExpire 	= __falseFunc
		mod.IsPurgeException 	= __falseFunc

		mod.GetAttributes 		= __getModAttributes

		return mod
	end

	local names = {}

	for i = 1, N_ABILITIES do
		local modname = MOD_NAME .. tostring(i)

		_G[modname] = _MakeModifier()
		table.insert(names, modname)
	end
	
	for _, modname in pairs(names) do
		LinkLuaModifier(modname, 'lib/client_talent_support', LUA_MODIFIER_MOTION_NONE)
	end
end

if IsServer() then	
	function _ClientTalentSupport:OnAbilityLearned(data)
		local player = EntIndexToHScript(data.player)

		if not player then return end

		local hero = player:GetAssignedHero() 

		if not hero then return end

		local abilityname = data.abilityname

		if not abilityname or not #abilityname then return end

		local heroname = hero:GetUnitName()

		if not heroname or not #heroname then return end

		local ability_data = self.ability_data_table[ heroname .. abilityname]

		if not ability_data then return end

		local index = ability_data[2]

		if not index then return end

		local modname = MOD_NAME .. index

		hero:AddNewModifier(hero, nil, modname, {})
	end
end -- if IsServer

if IsClient() then
	function _ClientTalentSupport:_Get(caster, talent_name)
		local talentCache = caster._talent_cache

		if not talentCache then
			talentCache = {}
			caster._talent_cache = talentCache
		end

		local cachedValue = talentCache[talent_name]

		if cachedValue ~= nil then
			return cachedValue
		end

		local unitName = caster:GetUnitName()

		if not unitName or not #unitName then 
			return nil
		end

		local ability_data = self.ability_data_table[unitName .. talent_name]

		if not ability_data then
			return nil
		end

		local index = ability_data[2]

		if not index then 
			return nil
		end

	    local modname = MOD_NAME .. index;

	    local data = ability_data[1]['AbilitySpecial']

	    local values = {}

	    for _, subdata in pairs(data) do
	    	for keyname, value in pairs(subdata) do
	    		if keyname ~= "var_type" then
	    			values[keyname] = value
	    			break
	    		end
	    	end
	    end

	    talentCache[talent_name] = { modname, values }

		return talentCache[talent_name]
	end

	function _ClientTalentSupport:HasTalent(caster, talent_name)
		local data = self:_Get(caster, talent_name)

		if not data then return false end

	    return caster:HasModifier( data[1] );
	end

	function _ClientTalentSupport:GetTalentSpecialValueFor(caster, talent_name, value_name)
		if value_name == nil then
			value_name = "value"
		end

		local data = self:_Get(caster, talent_name)

		if not data then return 0.0 end

		if not caster:HasModifier(data[1]) then return 0.0 end

		return tonumber( data[2][value_name] or 0 )
	end
end

_ClientTalentSupport:Init()