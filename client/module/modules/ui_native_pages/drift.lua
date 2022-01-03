function Modules.UI.DisplayDrift()
    Modules.UI.DrawTexts(0.51041668653488, 0.89999997615814, tostring(Modules.Utils.Comma_value(Modules.DriftCounter.CurrentPoints)) .." ~c~PTS", true, 0.8, {250, 224, 64, 255}, 6, false, false)
    Modules.UI.DrawTexts(0.5, 0.35, tostring(Modules.DriftCounter.ChainTimeLeft), true, 0.8, {255, 255, 255, 255}, 6, false, false)


    local x,y = Modules.UI.ConvertToPixel(360, 76)
    Modules.UI.DrawSpriteNew("ui_drift", "plate", 0.40104168653488, 0.89259258508682, x,y, 0, 255, 255, 255, 255, {
        NoHover = true,
        CustomHoverTexture = false,
        NoSelect = true,
        devmod = false
    }, function(onSelected, onHovered)

    end)
end

Citizen.CreateThread(function()
    while true do
        -- if Modules.DriftCounter.IsDrifting or Modules.DriftCounter.ChainLoopStarted then
        --     Modules.UI.SetPageActive("hud_drift")
        -- else
        --     Modules.UI.SetPageInactive("hud_drift")
        -- end
        Modules.UI.SetPageActive("hud_drift")
        Wait(500)
    end
end)