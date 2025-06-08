
local displaying = {}

Citizen.CreateThread(function()
    while true do
        Wait(Config.UpdateInterval)
        for _, pid in ipairs(GetActivePlayers()) do
            local isTalking = MumbleIsPlayerTalking(pid) -- pma-voice native
            displaying[pid] = isTalking
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(Config.DrawInterval)
        local myCoords = GetEntityCoords(PlayerPedId())

        for pid, isTalking in pairs(displaying) do
            if isTalking then
                local ped = GetPlayerPed(pid)
                local coords = GetEntityCoords(ped)

                if #(coords - myCoords) < Config.MaxDistance then
                    DrawText3D(coords.x, coords.y, coords.z + 1.0, Config.TalkingText)
                end
            end
        end
    end
end)


function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    local factor = (string.len(text)) / 225

    if onScreen then
        SetTextScale(Config.TextScale[1], Config.TextScale[2])
        SetTextFontForCurrentCommand(Config.TextFont)
        SetTextColor(Config.TextColor[1], Config.TextColor[2], Config.TextColor[3], Config.TextColor[4])
        SetTextCentre(1)
        DisplayText(str, _x, _y)
        DrawSprite("feeds", "toast_bg", _x, _y + 0.0125, 0.015 + factor, 0.03, 0.1, 20, 20, 20, 200, 0)
    end
end