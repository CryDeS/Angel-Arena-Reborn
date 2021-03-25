function clamp(v, mn, mx)
	return min(max(v, mn), mx)
end

function lerp(a, b, t)
	return a + t * (b - a)
end