function Modules.UI.DisplayDrift()
    if ConfigShared.PositionsCoords[ConfigShared.Position] ~= nil then
        local alphaToUse = math.floor(Modules.DriftCounter.GlobalAlpha)

        local baseX = ConfigShared.PositionsCoords[ConfigShared.Position][1]
        local baseY = ConfigShared.PositionsCoords[ConfigShared.Position][2]
    
        local x,y = Modules.UI.ConvertToPixel(360, 76)
        Modules.UI.DrawSpriteNew("ui_drift", "plate", baseX, baseY, x,y, 0, 255, 255, 255, alphaToUse, {
            NoHover = true,
            CustomHoverTexture = false,
            NoSelect = true,
            devmod = false
        }, function(onSelected, onHovered)
    
        end)
    
        -- 0.51041668653488, 0.88999997615814
        Modules.UI.DrawTexts(baseX + 0.109375, baseY - 0.00259260892868, tostring(Modules.Utils.Comma_value(Modules.DriftCounter.CurrentPoints)) .." ~c~PTS", true, 0.8, {250, 224, 64, alphaToUse}, Modules.UI.font["forza"], false, false)
    
    
    
        -- Condition is a bit hacky, but it's to avoid displaying the bars while drifting on the hud as it make the hud less cool
        if Modules.DriftCounter.ChainTimeLeft <= ConfigShared.DriftChainTime - 100 then
            local x,y = Modules.UI.ConvertToPixel(279, 2)
             -- 0.44010418653488, 0.89259254932404
             Modules.UI.DrawSlider(baseX + 0.0390625, baseY - 0.00000003576278, x, y, {0, 0, 0, 0}, {207, 5, 81, alphaToUse}, Modules.DriftCounter.ChainTimeLeft, ConfigShared.DriftChainTime, {
                noHover = true,
                direction = 1,
                devmod = false,
            }, function(onUpdate, newValue)
    
            end)
    
            -- 0.44010418653488, 0.96018517017365
            Modules.UI.DrawSlider(baseX + 0.0390625, baseY + 0.06759258508683, x, y, {0, 0, 0, 0}, {207, 5, 81, alphaToUse}, Modules.DriftCounter.ChainTimeLeft, ConfigShared.DriftChainTime, {
                noHover = true,
                direction = 1,
                devmod = false,
            }, function(onUpdate, newValue)
    
            end)
        end

        if ConfigShared.DisplayAngle then
            local alphaToUseForAngle = 150
            if alphaToUse < alphaToUseForAngle then
                alphaToUseForAngle = alphaToUse
            end
    
            local x,y = Modules.UI.ConvertToPixel(180, 13)
            local baseYToAdd = 0.08
            Modules.UI.DrawSlider(baseX + x, baseY + baseYToAdd, x, y, {0, 0, 0, alphaToUseForAngle}, {207, 5, 81, alphaToUse}, Modules.DriftCounter.CurrentAngle, ConfigShared.MaxAngle, {
                noHover = true,
                direction = 1,
                devmod = false,
            }, function(onUpdate, newValue)
        
            end)
            Modules.UI.DrawSlider(baseX, baseY + baseYToAdd, x, y, {0, 0, 0, alphaToUseForAngle}, {207, 5, 81, alphaToUse}, Modules.DriftCounter.CurrentAngle, ConfigShared.MaxAngle, {
                noHover = true,
                direction = 2,
                devmod = false,
            }, function(onUpdate, newValue)
        
            end)
            Modules.UI.DrawTexts(baseX + x, baseY + baseYToAdd - 0.0122, tostring(math.floor(Modules.DriftCounter.CurrentAngle)) .."°", true, 0.4, {250, 224, 64, alphaToUse}, Modules.UI.font["forza"], false, false)
        end
    else
        Modules.Log.Error("Wrong value used in config for ConfigShared.Position. Positon do not exist")
    end
end

Citizen.CreateThread(function()
    if ConfigShared.UseDefaultUI then
        while true do
            if Modules.DriftCounter.IsDrifting or Modules.DriftCounter.ChainLoopStarted or Modules.DriftCounter.InAnimation then
                Modules.UI.SetPageActive("hud_drift")
            else
                Modules.UI.SetPageInactive("hud_drift")
            end
            if ConfigShared.devmod then
                Modules.UI.SetPageActive("hud_drift")
            end
            Wait(100)
        end
    end
end)