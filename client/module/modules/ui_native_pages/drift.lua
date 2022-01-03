function Modules.UI.DisplayDrift()
    Modules.UI.DrawTexts(0.5, 0.3, tostring(Modules.DriftCounter.CurrentPoints), true, 0.8, {255, 255, 255, 255}, 6, false, false)
    Modules.UI.DrawTexts(0.5, 0.35, tostring(Modules.DriftCounter.ChainTimeLeft), true, 0.8, {255, 255, 255, 255}, 6, false, false)
end

Citizen.CreateThread(function()
    while true do
        if Modules.DriftCounter.IsDrifting or Modules.DriftCounter.ChainLoopStarted then
            Modules.UI.SetPageActive("hud_drift")
        else
            Modules.UI.SetPageInactive("hud_drift")
        end
        Wait(500)
    end
end)