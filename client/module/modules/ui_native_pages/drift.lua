function Modules.UI.DisplayDrift()
    local alphaToUse = math.floor(Modules.DriftCounter.GlobalAlpha)
    Modules.UI.DrawTexts(0.51041668653488, 0.88999997615814, tostring(Modules.Utils.Comma_value(Modules.DriftCounter.CurrentPoints)) .." ~c~PTS", true, 0.8, {250, 224, 64, alphaToUse}, Modules.UI.font["forza"], false, false)
    --Modules.UI.DrawTexts(0.5, 0.35, tostring(Modules.DriftCounter.ChainTimeLeft), true, 0.8, {255, 255, 255, alphaToUse}, 6, false, false)


    local x,y = Modules.UI.ConvertToPixel(360, 76)
    Modules.UI.DrawSpriteNew("ui_drift", "plate", 0.40104168653488, 0.89259258508682, x,y, 0, 255, 255, 255, alphaToUse, {
        NoHover = true,
        CustomHoverTexture = false,
        NoSelect = true,
        devmod = false
    }, function(onSelected, onHovered)

    end)


    -- Condition is a bit hacky, but it's to avoid displaying the bars while drifting on the hud as it make the hud less cool
    if Modules.DriftCounter.ChainTimeLeft <= ConfigShared.DriftChainTime - 100 then
        local x,y = Modules.UI.ConvertToPixel(279, 2)
        Modules.UI.DrawSlider(0.44010418653488, 0.89259254932404, x, y, {0, 0, 0, 0}, {207, 5, 81, alphaToUse}, Modules.DriftCounter.ChainTimeLeft, ConfigShared.   DriftChainTime, {
            noHover = true,
            direction = 1,
            devmod = false,
        }, function(onUpdate, newValue)

        end)

        Modules.UI.DrawSlider(0.44010418653488, 0.96018517017365, x, y, {0, 0, 0, 0}, {207, 5, 81, alphaToUse}, Modules.DriftCounter.ChainTimeLeft, ConfigShared.   DriftChainTime, {
            noHover = true,
            direction = 1,
            devmod = false,
        }, function(onUpdate, newValue)

        end)
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
            Wait(100)
        end
    end
end)