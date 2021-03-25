require('lib/repick_menu')

function hc_menu_open(trigger)
	if not IsServer() then return end

	if not RepickMenu:CanPickNow() then return end

	local player = trigger.activator:GetPlayerOwner()

	if not player then return end

	RepickMenu:Open( player )
end

function hc_menu_close(trigger)
	if not trigger.activator then return end

	local player = trigger.activator:GetPlayerOwner()

	if not player then return end

	RepickMenu:Close( player )
end