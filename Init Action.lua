local objectives = {
    
    --Profession Monthlies
    {name="Alchemy",prof={"Alchemy"}, quests={29506}, type="prof"},
    {name="Archaeology",prof={"Archaeology"}, quests={29507}, type="prof"},
    {name="Blacksmithing", prof={"Blacksmithing"}, quests={29508}, type="prof"},
    {name="Cooking", prof={"Cooking"}, quests={29509}, type="prof"},
    {name="Enchanting", prof={"Enchanting"}, quests={29510}, type="prof"},
    {name="Engineering",prof={"Engineering"}, quests={29511}, type="prof"},
    {name="Fishing",prof={"Fishing"}, quests={29513}, type="prof"},
    {name="Herbalism",prof={"Herbalism"}, quests={29514}, type="prof"},
    {name="Inscription",prof={"Inscription"},  quests={29515}, type="prof"},
    {name="Jewelcrafting",prof={"Jewelcrafting"}, quests={29516}, type="prof"},
    {name="Leatherworking",prof={"Leatherworking"}, quests={29517}, type="prof"},
    {name="Mining",prof={"Mining"}, quests={29518}, type="prof"},
    {name="Skinning",prof={"Skinning"}, quests={29519}, type="prof"},
    {name="Tailoring",prof={"Tailoring"}, quests={29520}, type="prof"},
    
    --- Monthly Quests
    {name="Den Mothers Demise (Moonfang)", quests={33354}, type="monthly"},
    {name="Test your Strength (PvP)", quests={29443}, type="monthly"},
    
    --- Acount-wide Dailies
    {name="Jeremy Feasel Pet Battle", quests={32175}, type="awdaily"},
    {name="Christoph Vonfeasel Pet Battle", quests={36471}, type="awdaily"},

    --- Game Dailies
    {name="Whack-a-mole", quests={29463}, type="daily"},
    {name="Cannon Target", quests={29436}, type="daily"},
    {name="Shooting Gallery", quests={29438}, type="daily"},
    {name="Tank Battle", quests={29434}, type="daily"},
    {name="Flying Rings", quests={36481}, type="daily"},
    {name="Dance Dance", quests={64783}, type="daily"},
    {name="Turtle Ring Toss", quests={29455}, type="daily"},
    {name="Short Race", quests={37910}, type="daily"},
    {name="Long Race", quests={37911}, type="daily"},

    --- item turns ins
    {name="Fallen Adventurers Journal", quests={29458}, type="item"},
    {name="Banner of the Fallen", quests={29456}, type="item"},
    {name="Captured Insignia", quests={29457}, type="item"},
    {name="Imbued Crystal", quests={29443}, type="item"},
    {name="Monstrous Egg", quests={29444}, type="item"},
    {name="Mysterious Grimoire", quests={29445}, type="item"},
    {name="Ornate Weapon", quests={29446}, type="item"},
    {name="Soothsayer's Runes", quests={29464}, type="item"},
    {name="A Treatise on Strategy", quests={29451}, type="item"},
}


local timecalc = function(day1, day2, offset) --d1 = DMF start / d2 = today / offset = total number of days this month
    local dday = 0
    local d1 = day1
    local d2 = day2
    local os = offset
    
    if os == 0 then
        dday = d1['monthDay'] - d2['monthDay']
    else
        dday = (os - d2['monthDay']) + d1['monthDay']
    end
    
    
    local dhour =  d1['hour'] - d2['hour']
    local dminute =  d1['minute'] - d2['minute']
    
    
    if dminute < 0 then
        dhour = dhour - 1
        dminute = dminute +60
    end
    
    if dhour < 0 then
        dday = dday -1
        dhour = dhour + 24
    end
    
    return dday, dhour, dminute
end


local timeuntildmf = function()
    local nextdmf = false
    local today = C_DateAndTime.GetCurrentCalendarTime()
    local mdays = C_Calendar.GetMonthInfo(0)['numDays']
    
    local day = 0
    local hour = 0
    local minute = 0
    
    for i=today['monthDay'],mdays, 1 do -- Checks holiday events for current month from today
        local holidayInfo = C_Calendar.GetHolidayInfo(0,i,1)
        if holidayInfo and holidayInfo['name'] == "Darkmoon Faire" then
            local dmfstart = holidayInfo.startTime
            day, hour, minute = timecalc(dmfstart, today, 0)
            nextdmf = 1
        end
    end

    
    local nmdays = C_Calendar.GetMonthInfo(1)['numDays']
    if nextdmf == false then
        for j=1,nmdays, 1 do -- Checks holiday events for current month from today
            if C_Calendar.GetHolidayInfo(1,j,1) then
                if C_Calendar.GetHolidayInfo(1,j,1)['name'] == "Darkmoon Faire" then
                    local  dmfstart = C_Calendar.GetHolidayInfo(1,j,1).startTime
                    
                    day, hour, minute = timecalc(dmfstart, today, mdays)
                    
                    nextdmf = true
                    
                end
            end
            
        end
    end
    
    return day, hour, minute
    
end

local skillcheck = function(sk)
    local p, s, a, f, c = GetProfessions()
    local professions = {p, s, a, f, c}
    local names = {}

    for i, profession in ipairs(professions) do
        if profession then
            local name, _, _, _, _, spellOffset, skillID = GetProfessionInfo(profession)
            table.insert(names, name)
        end
    end

    for i, name in ipairs(names) do
        if sk == name then
            return true
        end
    end

    return false
end

-- This returns true if profession is available for the quest or something like that
local is_active = function(objective)
    if not objective.prof then
        return true
    end
    -- check if the objective requires a skill and if you have the skill learned.
    for _, q in ipairs(objective.prof) do
        return skillcheck(q)
    end
end


local dmfrep = function()
    local space = ""
    local factionID = 909
    local repNameColour = "FFFFFFFF"            
    local barRep = "Neutral"  -- Define barRep here with a default value

    local repName, _, _, _, barMax, barValue = GetFactionInfoByID(factionID)
    
    space=" "
    
    if #tostring(barMax) == 4 then
        for j = 1,25-#repName do
            space=space.." "
        end
    end
    if #tostring(barMax) == 5 then
        for j = 1,22-#repName do
            space=space.." "
        end
    end
    
    --Check if person is above Neutral and adjust
    if barValue > 3000 then
        barValue = barValue - 3000
        barMax = barMax - 3000
        barRep = "Neautral"
    end
    --Check if person is above Friendly and adjust
    if barValue > 6000 then
        barValue = barValue - 6000
        barMax = barMax - 6000
        barRep = "Friendly"
    end
    --Check if person is above Honored and adjust
    if barValue > 12000 then
        barValue = barValue - 12000
        barMax = barMax - 12000
        barRep = "Honored"
    end
    --Check if person is above Revered and adjust
    if barValue > 21000 then
        barValue = barValue - 21000
        barMax = barMax - 21000
        barRep = "Revered"
    end
    
    
    local out = ""
    out = "\n\124cffAF7EE2"..repName.." Reputation:\n\124cFFD9BBF9  "..barValue.."/"..barMax.. "\124cFFD9BBF9 - " ..barRep.. "\n\n"
    
    return out
end    

aura_env.update_display = function()
    
    aura_env.text = ""
    if aura_env.config['counthide'] == false then
        days, hours, minutes = timeuntildmf()
        local tts = (days * 1440) + (hours * 60) + (minutes)
        
        if tts <= 0  then
            aura_env.text = aura_env.text .. "\124cffD9BBF9DMF is active!\124r\n"
        else
            aura_env.text = aura_env.text .. "\124cff777777DMF is not active.\124r"
            aura_env.text = aura_env.text .. "\n" .. days .. "D " .. hours.. "H " .. minutes.. "M\n"
        end
    end

    if aura_env.config['tixhide'] == false then
        local dmftix = C_CurrencyInfo.GetCurrencyInfo(515)
        local dmfcount = dmftix.quantity
        aura_env.text = aura_env.text .. "\n\124cffAF7EE2Tickets\124r\n\124cffD9BBF9  "  .. dmfcount .. "\124r"
    end

    if aura_env.config['rephide'] == false then
        local currep = ""
        
        currep = dmfrep()
        aura_env.text = aura_env.text .. "\n" .. currep
        
    end

    local c = 1
    -- Check if Quest is available or completed
    for _, objective in ipairs(objectives) do
        --lazy way of formatting, don't judge me. i got tired of this.

        if c == 1 and aura_env.config["profhide"] == false then
            aura_env.text = aura_env.text .. "\124cffAF7EE2" .. "Professions (Monthly):\124r"
        end
        
        if c == 15 and aura_env.config["mqhide"] == false then
            aura_env.text = aura_env.text .. "\n\124cffAF7EE2" .. "\nQuests (Monthly):\124r"
        end
        
        if c == 17 and aura_env.config["awdailyhide"] == false then
            aura_env.text = aura_env.text .. "\n\124cffAF7EE2" .. "\nGames (Account-Wide Daily):\124r"
        end

        if c == 19 and aura_env.config["dailyhide"] == false then
            aura_env.text = aura_env.text .. "\n\124cffAF7EE2" .. "\nGames (Daily):\124r"
        end
        
        if c == 28 and aura_env.config["itemhide"] == false then
            aura_env.text = aura_env.text .. "\n\124cffAF7EE2" .. "\nItem Turn In (Monthly):\124r"
        end
        
        --check each of the objectives.
        if is_active(objective) then
            local c = #objective.quests
            for _, q in ipairs(objective.quests) do
                --green done red not done. obviously.
                qtype = objective.type
                if (qtype == "prof" and aura_env.config['profhide'] == false) or (qtype == "monthly" and aura_env.config['mqhide'] == false) or (qtype == "daily" and aura_env.config['dailyhide'] == false) or (qtype == "item" and aura_env.config['itemhide'] == false) or (qtype == "awdaily" and aura_env.config['awdailyhide'] == false) then
                    if C_QuestLog.IsQuestFlaggedCompleted(q) then
                        if aura_env.config['comphide'] == false then
                            aura_env.text = aura_env.text .. "\n \124cffD9BBF9  " .. objective.name  .. "\124r"
                        end
                        else
                            aura_env.text = aura_env.text .. "\n \124cFF777777  " .. objective.name  .. "\124r"
                        end
                end
                
            end
        end
     c = c + 1
        
    end
end

local AutoOpenIDs = {
    
    [93724]     = true,
    [116062]    = true,
    [91086]     = true
}

aura_env.AutoOpenQueued = false

aura_env.AutoOpen = function()
    for bag = 4,0,-1 do
        for slot = C_Container.GetContainerNumSlots(bag),1,-1 do
            local _, _, locked, _, _, _, _, _, _, itemId = C_Container.GetContainerNumSlots(bag, slot)
            -- It will be opened the next time something happens in the bag anyway.
            if AutoOpenIDs[itemId] and not InCombatLockdown() and not locked then
                UseContainerItem(bag, slot)
                print("[WA]["..aura_env.id.."] Working.")
            end
        end
    end
end


aura_env.update_display()