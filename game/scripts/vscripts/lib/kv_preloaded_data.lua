require('lib/base_lua_helpers')

PreloadCache = PreloadCache or class({})

function PreloadCache:_init()
	function load_base_kv(path)
		print("[PreloadCache] Load KV '" .. path .."'")

		local data = LoadKeyValues(path)

		data['Version'] = nil
		
		return data
	end

	function load_kv_data(path, custom_path)
		local data = load_base_kv(path)
		local new_data = load_base_kv(custom_path)

		merge_table(data, new_data)

		return data
	end

	if not self.hero_data then
		self.hero_data = load_kv_data('scripts/npc/npc_heroes.txt', 'scripts/npc/npc_heroes_custom.txt')

		local for_delete = {}

		-- If we has a 'override_hero' in hero block, lets replace data in original hero and delete that overrider from 
		for hero_name, hero_info in pairs(self.hero_data) do
			local hero_override_name = hero_info['override_hero']
			local already_hero_data = self.hero_data[hero_override_name]

			if hero_override_name and already_hero_data and not already_hero_data['new_hero_name'] then
				local base_hero_info = self.hero_data[hero_override_name]
				if base_hero_info then
					table.insert(for_delete, hero_name)
					
					for k,v in pairs(hero_info) do
						base_hero_info[k] = v
					end

					self.hero_data[hero_override_name]['new_hero_name'] = hero_name
				end
			end
		end

		for _, hero_name in pairs(for_delete) do
			self.hero_data[hero_name] = nil
		end
	end

	self.ability_data = self.ability_data or load_kv_data('scripts/npc/npc_abilities.txt', 'scripts/npc/npc_abilities_custom.txt')
end

function PreloadCache:GetHeroData()
	return self.hero_data
end

function PreloadCache:GetAbilityData()
	return self.ability_data
end

PreloadCache:_init()