function()
    if not aura_env.last or aura_env.last < GetTime() - 1 then
        aura_env.last = GetTime()
        aura_env.update_display()
    end
    return aura_env.text
end