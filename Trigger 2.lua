function (e, ...)
	if e == "BAG_UPDATE_DELAYED" then
		if not InCombatLockdown() then
			aura_env.AutoOpen()
		else
			aura_env.AutoOpenQueued = true
		end
	elseif e == "PLAYER_REGEN_ENABLED" then
		if AutoOpenQueued then
			aura_env.AutoOpenQueued = false
			aura_env.AutoOpen()
		end
	end
end