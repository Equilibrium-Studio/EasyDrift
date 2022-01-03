local useMaxSpeedInsteadOfThrootle = true
function Modules.UI.DisplayHudRally()
    local pVeh = Modules.Player.GetCurrentVehicle()
    local throttle = GetVehicleThrottleOffset(pVeh)
    local max
    if useMaxSpeedInsteadOfThrootle then
        max = GetVehicleEstimatedMaxSpeed(pVeh)* 3.6  + 50 
    end
    local rpm = GetVehicleCurrentRpm(pVeh) - 0.2
    local speed = math.floor(GetEntitySpeed(pVeh) * 3.6)
    local highGear = GetVehicleHighGear(pVeh)
    local gear = GetVehicleCurrentGear(pVeh)
    local previousGear = gear - 1
    local nextGear = gear + 1

    local previousGearAgain = gear - 2
    local nextGearAgain = gear + 2

    if previousGear <= 0 then
        previousGear = ""
    end
    if nextGear > highGear then
        nextGear = ""
    end

    if previousGearAgain <= 0 then
        previousGearAgain = ""
    end
    if nextGearAgain > highGear then
        nextGearAgain = ""
    end

    if speed <= 0 then
        speed = 0
    end

    if throttle <= 0 then
        throttle = 0
    end

    if rpm <= 0 then
        rpm = 0
    end

    Modules.UI.DrawSpriteNew("ui_rally", "race_hud", 0.0, 0.0, 1.0, 1.0, 0, 255, 255, 255, 255, {
        NoHover = true,
        CustomHoverTexture = false,
        NoSelect = true,
        devmod = false
    }, function(onSelected, onHovered)

    end)

    Modules.UI.DrawTexts(0.49895834922791, 0.85037036418915, tostring(speed), true, 1.25, {255, 255, 255, 255}, 6, false, false)

    local baseX = 0.50104171037674
    local baseY = 0.91759258508682
    local toAddOrRemove = 0.02

    Modules.UI.DrawTexts(baseX + toAddOrRemove * 2, baseY + 0.01, tostring(nextGearAgain), true, 0.8, {200, 200, 200, 200}, 6, false, false)
    Modules.UI.DrawTexts(baseX + toAddOrRemove, baseY + 0.01, tostring(nextGear), true, 0.8, {200, 200, 200, 200}, 6, false, false)
    Modules.UI.DrawTexts(baseX, baseY, tostring(gear), true, 1.1, {255, 255, 255, 255}, 6, false, false)
    Modules.UI.DrawTexts(baseX - toAddOrRemove, baseY + 0.01, tostring(previousGear), true, 0.8, {200, 200, 200, 200}, 6, false, false)
    Modules.UI.DrawTexts(baseX - toAddOrRemove * 2, baseY + 0.01, tostring(previousGearAgain), true, 0.8, {200, 200, 200, 200}, 6, false, false)

    local x,y = Modules.UI.ConvertToPixel(585, 43)

    if useMaxSpeedInsteadOfThrootle then
        Modules.UI.DrawSlider(0.61718755960464, 0.94259256124496, x, y, {0, 0, 0, 50}, {106, 255, 89, 255}, speed, max, {
            noHover = true,
            direction = 1,
            devmod = false,
        }, function(onUpdate, newValue)
            
        end)
    else
        Modules.UI.DrawSlider(0.61718755960464, 0.94259256124496, x, y, {0, 0, 0, 50}, {106, 255, 89, 255}, throttle, 1.0, {
            noHover = true,
            direction = 1,
            devmod = false,
        }, function(onUpdate, newValue)
            
        end)
    end


    local x,y = Modules.UI.ConvertToPixel(585, 43)
    Modules.UI.DrawSlider(0.07291667163372, 0.94259256124496, x, y, {0, 0, 0, 50}, {255, 89, 89, 255}, rpm, 0.8, {
        noHover = true,
        direction = 2,
        devmod = false,
    }, function(onUpdate, newValue)
        
    end)
end

Citizen.CreateThread(function()
    while true do
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            Modules.UI.SetPageActive("hud_rally")
        else
            Modules.UI.SetPageInactive("hud_rally")
        end
        Wait(500)
    end
end)