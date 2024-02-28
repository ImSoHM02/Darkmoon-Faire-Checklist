{
  "d": {
    "actions": {
      "finish": [],
      "init": {
        "custom": "local objectives = {\n    \n    --Profession Monthlies\n    {name=\"Alchemy\",prof={\"Alchemy\"}, quests={29506}, type=\"prof\"},\n    {name=\"Archaelogy\",prof={\"Archaelogy\"}, quests={29507}, type=\"prof\"},\n    {name=\"Blacksmithing\", prof={\"Blacksmithing\"}, quests={29508}, type=\"prof\"},\n    {name=\"Cooking\", prof={\"Cooking\"}, quests={29509}, type=\"prof\"},\n    {name=\"Enchanting\", prof={\"Enchanting\"}, quests={29510}, type=\"prof\"},\n    {name=\"Engineering\",prof={\"Engineering\"}, quests={29511}, type=\"prof\"},\n    {name=\"Fishing\",prof={\"Fishing\"}, quests={29513}, type=\"prof\"},\n    {name=\"Herbalism\",prof={\"Herbalism\"}, quests={29514}, type=\"prof\"},\n    {name=\"Inscription\",prof={\"Inscription\"},  quests={29515}, type=\"prof\"},\n    {name=\"Jewelcrafting\",prof={\"Jewelcrafting\"}, quests={29516}, type=\"prof\"},\n    {name=\"Leatherworking\",prof={\"Leatherworking\"}, quests={29517}, type=\"prof\"},\n    {name=\"Mining\",prof={\"Mining\"}, quests={29518}, type=\"prof\"},\n    {name=\"Skinning\",prof={\"Skinning\"}, quests={29519}, type=\"prof\"},\n    {name=\"Tailoring\",prof={\"Tailoring\"}, quests={29520}, type=\"prof\"},\n    \n    --- Monthly Quests\n    {name=\"Den Mothers Demise(Moonfang Monthly)\", quests={33354}, type=\"monthly\"},\n    {name=\"Test your Strength(PvP Monthly)\", quests={29443}, type=\"montly\"},\n    \n    ---Game Dailies\n    {name=\"Whack-a-mole\", quests={29463}, type=\"daily\"},\n    {name=\"Cannon Target\", quests={29436}, type=\"daily\"},\n    {name=\"Shooting Gallery\", quests={29438}, type=\"daily\"},\n    {name=\"Tank Battle\", quests={29434}, type=\"daily\"},\n    {name=\"Turtle Ring Toss\", quests={29455}, type=\"daily\"},\n    {name=\"Flying Rings\", quests={36481}, type=\"daily\"},\n    {name=\"Short Race\", quests={37910}, type=\"daily\"},\n    {name=\"Long Race\", quests={37911}, type=\"daily\"},\n    {name=\"Easy Pet Battle\", quests={32175}, type=\"daily\"},\n    {name=\"Hard Pet Battle\", quests={36471}, type=\"daily\"},\n    {name=\"Dance Dance\", quests={64783}, type=\"daily\"},\n    \n    --- item turns ins\n    {name=\"Fallen Adventurers Journal\", quests={29458}, type=\"item\"},\n    {name=\"Banner of the Fallen\", quests={29456}, type=\"item\"},\n    {name=\"Captured Insignia\", quests={29457}, type=\"item\"},\n    {name=\"Imbued Crystal\", quests={29443}, type=\"item\"},\n    {name=\"Monstrous Egg\", quests={29444}, type=\"item\"},\n    {name=\"Mysterious Grimoire\", quests={29445}, type=\"item\"},\n    {name=\"Ornate Weapon\", quests={29446}, type=\"item\"},\n    {name=\"Soothsayer's Runes\", quests={29464}, type=\"item\"},\n    {name=\"A Treatise on Strategy\", quests={29451}, type=\"item\"},\n}\n\n\nlocal timecalc = function(day1, day2, offset) --d1 = DMF start / d2 = today / offset = total number of days this month\n    local dday = 0\n    local d1 = day1\n    local d2 = day2\n    local os = offset\n    \n    if os == 0 then\n        dday = d1['monthDay'] - d2['monthDay']\n    else\n        dday = (os - d2['monthDay']) + d1['monthDay']\n    end\n    \n    \n    local dhour =  d1['hour'] - d2['hour']\n    local dminute =  d1['minute'] - d2['minute']\n    \n    \n    if dminute < 0 then\n        dhour = dhour - 1\n        dminute = dminute +60\n    end\n    \n    if dhour < 0 then\n        dday = dday -1\n        dhour = dhour + 24\n    end\n    \n    return dday, dhour, dminute\nend\n\n\nlocal timeuntildmf = function()\n    local nextdmf = false\n    local today = C_DateAndTime.GetCurrentCalendarTime()\n    local mdays = C_Calendar.GetMonthInfo(0)['numDays']\n    \n    local day = 0\n    local hour = 0\n    local minute = 0\n    \n    for i=today['monthDay'],mdays, 1 do -- Checks holiday events for current month from today\n        if C_Calendar.GetHolidayInfo(0,i,1)['name'] == \"Darkmoon Faire\" then\n            local dmfstart = C_Calendar.GetHolidayInfo(0,i,1).startTime\n            day, hour, minute = timecalc(dmfstart, today, 0)\n            nextdmf = 1\n        end\n        \n    end\n    \n    local nmdays = C_Calendar.GetMonthInfo(1)['numDays']\n    if nextdmf == false then\n        for j=1,nmdays, 1 do -- Checks holiday events for current month from today\n            if C_Calendar.GetHolidayInfo(1,j,1) then\n                if C_Calendar.GetHolidayInfo(1,j,1)['name'] == \"Darkmoon Faire\" then\n                    local  dmfstart = C_Calendar.GetHolidayInfo(1,j,1).startTime\n                    \n                    day, hour, minute = timecalc(dmfstart, today, mdays)\n                    \n                    nextdmf = true\n                    \n                end\n            end\n            \n        end\n    end\n    \n    return day, hour, minute\n    \nend\n\nlocal skillcheck = function(sk)\n    -- didn't feel like writing a loop. suck it.\n    local p, s, a, f, c = GetProfessions()\n    local name, _, _, _, _, spellOffset, skillID = GetProfessionInfo(p)\n    local primary = name\n    local name, _, _, _, _, spellOffset, skillID = GetProfessionInfo(s)\n    local secondary = name\n    local name, _, _, _, _, spellOffset, skillID = GetProfessionInfo(a)\n    local archy = name\n    local name, _, _, _, _, spellOffset, skillID = GetProfessionInfo(f)\n    local fishing = name\n    local name, _, _, _, _, spellOffset, skillID = GetProfessionInfo(c)\n    local cooking = name\n    \n    -- check them all a lazy way. dont feel like learning lua\n    return( sk == primary or sk == secondary or sk == archy or sk == fishing or sk == cooking )\n    \nend\n\n-- This returns true if profession is available for the quest or something like that\nlocal is_active = function(objective)\n    if not objective.prof then\n        return true\n    end\n    -- check if the objective requires a skill and if you have the skill learned.\n    for _, q in ipairs(objective.prof) do\n        return skillcheck(q)\n    end\nend\n\n\nlocal dmfrep = function()\n    local space = \"\"\n    local factionID = 909\n    local repNameColour = \"FFFFFFFF\"            \n    \n    local repName, _, _, _, barMax, barValue = GetFactionInfoByID(factionID)\n    \n    space=\" \"\n    \n    if #tostring(barMax)==4 then\n        for j=1,25-#repName do\n            space=space..\" \"\n        end\n    end\n    if #tostring(barMax)==5 then\n        for j=1,22-#repName do\n            space=space..\" \"\n        end\n    end\n    \n    --Check if person is above Neutral and adjust\n    if barValue > 3000 then\n        barValue = barValue - 3000\n        barMax = barMax - 3000\n    end\n    --Check if person is above Friendly and adjust\n    if barValue > 6000 then\n        barValue = barValue - 6000\n        barMax = barMax - 6000\n    end\n    --Check if person is above Honored and adjust\n    if barValue > 12000 then\n        barValue = barValue - 12000\n        barMax = barMax - 12000\n    end\n    if barValue > 21000 then\n        barValue = barValue - 21000\n        barMax = barMax - 21000\n    end\n    \n    \n    local out = \"\"\n    out = \"\\n\\124cffffffff\"..repName..\" \"..barValue..\"/\"..barMax\n    \n    return out\nend    \n\naura_env.update_display = function()\n    \n    aura_env.text = \"\"\n    local c = 1\n    -- Check if Quest is available or completed\n    for _, objective in ipairs(objectives) do\n        --lazy way of formatting, don't judge me. i got tired of this.\n        \n        if c == 1 and aura_env.config[\"profhide\"] == false then\n            aura_env.text = aura_env.text .. \"\\124cffffffff Profession (Monthly):\\124r\"\n        end\n        \n        if c == 15 and aura_env.config[\"mqhide\"] == false then\n            aura_env.text = aura_env.text .. \"\\n\\124cffffffff\" .. \"Quests (Monthly):\\124r\"\n        end\n        \n        if c == 17 and aura_env.config[\"dailyhide\"] == false then\n            aura_env.text = aura_env.text .. \"\\n\\124cffffffff\" .. \"Games (Daily):\\124r\"\n        end\n        \n        if c==28 and aura_env.config[\"itemhide\"] == false then\n            aura_env.text = aura_env.text .. \"\\n\\124cffffffff\" .. \"Item Turnins(Monthly):\\124r\"\n        end\n        \n        \n        \n        --check each of the objectives.\n        if is_active(objective) then\n            local c = #objective.quests\n            for _, q in ipairs(objective.quests) do\n                --green done red not done. obviously.\n                qtype = objective.type\n                if (qtype == \"prof\" and aura_env.config['profhide'] == false) or (qtype == \"monthly\" and aura_env.config['mqhide'] == false) or (qtype == \"daily\" and aura_env.config['dailyhide'] == false) or (qtype == \"item\" and aura_env.config['itemhide'] == false) then\n                    if C_QuestLog.IsQuestFlaggedCompleted(q) then\n                        if aura_env.config['comphide'] == false then\n                            aura_env.text = aura_env.text .. \"\\n \\124cFF00FF00  \" .. objective.name  .. \"\\124r\"\n                        end\n                        \n                    else\n                        aura_env.text = aura_env.text .. \"\\n \\124cFFFF0000  \" .. objective.name .. \"\\124r\"\n                    end\n                end\n                \n            end\n        end\n        c = c + 1\n        \n    end\n    if aura_env.config['rephide'] == false then\n        local currep = \"\"\n        \n        currep = dmfrep()\n        aura_env.text = aura_env.text .. \"\\n\" .. currep\n        \n    end\n    if aura_env.config['tixhide'] == false then\n        local dmftix = C_CurrencyInfo.GetCurrencyInfo(515)\n        local dmfcount = dmftix.quantity\n        aura_env.text = aura_env.text .. \"\\n      \" .. dmfcount .. \" Tickets      \"\n    end\n    \n    if aura_env.config['counthide'] == false then\n        days, hours, minutes = timeuntildmf()\n        local tts = (days * 1440) + (hours * 60) + (minutes)\n        \n        if tts <= 0  then\n            aura_env.text = aura_env.text .. \"\\n\\n DMF ACTIVE!\"\n            aura_env.text = aura_env.text .. \"\\n\\n DMF In: \" .. days .. \"D \" .. hours.. \"H \" .. minutes.. \"M\"\n        else\n            \n            aura_env.text = aura_env.text .. \"\\n\\n DMF In: \" .. days .. \"D \" .. hours.. \"H \" .. minutes.. \"M\"\n        end\n    end\n    \nend\n\nlocal AutoOpenIDs = {\n    \n    [93724]     = true,\n    [116062]    = true,\n    [91086]     = true\n}\n\naura_env.AutoOpenQueued = false\n\naura_env.AutoOpen = function()\n    for bag = 4,0,-1 do\n        for slot = GetContainerNumSlots(bag),1,-1 do\n            local _, _, locked, _, _, _, _, _, _, itemId = GetContainerItemInfo(bag, slot)\n            -- It will be opened the next time something happens in the bag anyway.\n            if AutoOpenIDs[itemId] and not InCombatLockdown() and not locked then\n                UseContainerItem(bag, slot)\n                print(\"[WA][\"..aura_env.id..\"] Working.\")\n            end\n        end\n    end\nend\n\n\naura_env.update_display()\n\n\n\n",
        "do_custom": true
      },
      "start": []
    },
    "anchorFrameFrame": "UIParent",
    "anchorFrameParent": true,
    "anchorFrameType": "SELECTFRAME",
    "anchorPoint": "BOTTOMLEFT",
    "animation": {
      "finish": {
        "duration_type": "seconds",
        "easeStrength": 3,
        "easeType": "none",
        "type": "none"
      },
      "main": {
        "duration_type": "seconds",
        "easeStrength": 3,
        "easeType": "none",
        "type": "none"
      },
      "start": {
        "duration_type": "seconds",
        "easeStrength": 3,
        "easeType": "none",
        "type": "none"
      }
    },
    "authorOptions": [
      {
        "default": false,
        "key": "profhide",
        "name": "Hide Professions",
        "type": "toggle",
        "useDesc": false,
        "width": 1
      },
      {
        "default": false,
        "key": "mqhide",
        "name": "Hide Monthly Quests",
        "type": "toggle",
        "useDesc": false,
        "width": 1
      },
      {
        "default": false,
        "key": "dailyhide",
        "name": "Hide Dailies",
        "type": "toggle",
        "useDesc": false,
        "width": 1
      },
      {
        "default": false,
        "key": "itemhide",
        "name": "Hide Item Turnins",
        "type": "toggle",
        "useDesc": false,
        "width": 1
      },
      {
        "default": false,
        "key": "tixhide",
        "name": "Hide Ticket Counter",
        "type": "toggle",
        "useDesc": false,
        "width": 1
      },
      {
        "default": false,
        "key": "comphide",
        "name": "Hide When Complete",
        "type": "toggle",
        "useDesc": false,
        "width": 1
      },
      {
        "default": false,
        "key": "rephide",
        "name": "Hide Reputation",
        "type": "toggle",
        "useDesc": false,
        "width": 1
      },
      {
        "default": false,
        "key": "counthide",
        "name": "Hide Countdown",
        "type": "toggle",
        "useDesc": false,
        "width": 1
      }
    ],
    "automaticWidth": "Auto",
    "color": [
      1,
      1,
      1,
      1
    ],
    "conditions": [],
    "config": {
      "comphide": false,
      "counthide": false,
      "dailyhide": false,
      "itemhide": false,
      "mqhide": false,
      "profhide": false,
      "rephide": false,
      "tixhide": false
    },
    "customText": "function()\n    if not aura_env.last or aura_env.last < GetTime() - 1 then\n        aura_env.last = GetTime()\n        aura_env.update_display()\n    end\n    return aura_env.text\nend",
    "customTextUpdate": "update",
    "displayText": "%c",
    "displayText_format_c_format": "none",
    "displayText_format_p_format": "timed",
    "displayText_format_p_time_dynamic_threshold": 60,
    "displayText_format_p_time_format": 0,
    "displayText_format_p_time_precision": 1,
    "fixedWidth": 200,
    "font": "Friz Quadrata TT",
    "fontSize": 14,
    "frameStrata": 1,
    "id": "Darkmoon Faire Checklist",
    "information": {
      "forceEvents": true
    },
    "internalVersion": 59,
    "justify": "LEFT",
    "load": {
      "class": {
        "multi": [],
        "single": "PALADIN"
      },
      "class_and_spec": {
        "multi": [
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          true,
          true,
          null,
          null,
          null,
          true
        ],
        "single": 70
      },
      "size": {
        "multi": []
      },
      "spec": {
        "multi": []
      },
      "talent": {
        "multi": []
      },
      "use_class": true,
      "use_never": false,
      "use_zone": false,
      "use_zoneIds": true,
      "zone": "The Darkmoon Faire",
      "zoneIds": "407, g142, g411, 1165"
    },
    "outline": "OUTLINE",
    "regionType": "text",
    "selfPoint": "BOTTOMLEFT",
    "semver": "1.0.0",
    "shadowColor": [
      0,
      0,
      0,
      1
    ],
    "shadowXOffset": 1,
    "shadowYOffset": -1,
    "subRegions": [
      {
        "type": "subbackground"
      }
    ],
    "tocversion": 100002,
    "triggers": {
      "1": {
        "trigger": {
          "debuffType": "HELPFUL",
          "duration": "1",
          "event": "Conditions",
          "names": [],
          "spellIds": [],
          "subeventPrefix": "SPELL",
          "subeventSuffix": "_CAST_START",
          "type": "unit",
          "unevent": "auto",
          "unit": "player",
          "use_absorbMode": true,
          "use_alwaystrue": true,
          "use_unit": true
        },
        "untrigger": []
      },
      "2": {
        "trigger": {
          "custom": "function (e, ...)\n\tif e == \"BAG_UPDATE_DELAYED\" then\n\t\tif not InCombatLockdown() then\n\t\t\taura_env.AutoOpen()\n\t\telse\n\t\t\taura_env.AutoOpenQueued = true\n\t\tend\n\telseif e == \"PLAYER_REGEN_ENABLED\" then\n\t\tif AutoOpenQueued then\n\t\t\taura_env.AutoOpenQueued = false\n\t\t\taura_env.AutoOpen()\n\t\tend\n\tend\nend",
          "custom_hide": "timed",
          "custom_type": "event",
          "debuffType": "HELPFUL",
          "events": "BAG_UPDATE_DELAYED, PLAYER_REGEN_ENABLED",
          "type": "custom",
          "unit": "player"
        },
        "untrigger": []
      },
      "activeTriggerMode": 2,
      "disjunctive": "any"
    },
    "uid": "6M7CBcq5pWG",
    "url": "https://wago.io/wblYb5gnT/1",
    "version": 1,
    "wagoID": "wblYb5gnT",
    "wordWrap": "WordWrap",
    "xOffset": 33.562950134277,
    "yOffset": 776.82183837891
  },
  "m": "d",
  "s": "5.2.0",
  "v": 1421,
  "wagoID": "wblYb5gnT"
}