MessageFormaters = MessageFormaters or class({})

function MessageFormaters:FormatTime( t )
	local minutes = math.floor(t / 60)
	local seconds = t - (minutes * 60)
	local m10 = math.floor(minutes / 10)
	local m01 = minutes - (m10 * 10)
	local s10 = math.floor(seconds / 10)
	local s01 = seconds - (s10 * 10)
	local timerText = m10 .. m01 .. ":" .. s10 .. s01

	return timerText
end