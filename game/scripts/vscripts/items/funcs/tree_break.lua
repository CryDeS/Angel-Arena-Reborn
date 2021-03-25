function DestroyTree(keys)
	local target = keys.target

	if target then
		GridNav:DestroyTreesAroundPoint(target:GetAbsOrigin(), 15, true)
	end
end