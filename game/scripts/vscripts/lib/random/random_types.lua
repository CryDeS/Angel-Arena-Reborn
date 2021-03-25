function random_std_uniform(from, to)
	-- lua random generator is uniform distributed by default
	local num = math.random()

	-- that mean [0, 1] range
	if from == nil and to == nil then 
		return num 
	end
	
	return from + num * (to - from)
end

function random_normal(from, to)
	if from == nil and to == nil then
		from = 0
		to 	 = 1
	end

	-- Valve random is normal distributed by default.
	return RandomFloat(from, to)
end
