ConfigShared = {}
ConfigShared.devmod = false -- Keep the UI on by default, usefull when tweaking UI
ConfigShared.UseDefaultUI = true -- Set this to false if you want to use your own UI


ConfigShared.DriftChainTime = 5000 -- Time in MS
ConfigShared.AddStaticPointOnDrifting = true -- Add a static number of point on every frame when the player is drifting
ConfigShared.StaticPointToAdd = 1 -- This is added every frame, so it will grow very fast

ConfigShared.AddPointBasedOnAngle = true -- Add an angle based point every frame when the player is drifting. The more angle the player take, the more point he will get


ConfigShared.DriftStartEvent = "drift:start" -- Name of the evet triggered when a drift is started, this is a client side event.
ConfigShared.DriftFinishedEvent = "drift:finish" -- Name of the evet triggered when a drift is finished, this is a client side event. The drift score is sent as first arg
ConfigShared.EnableEvent = "drift:enable" -- Enables the drift counter
ConfigShared.DisableEvent = "drift:disable" -- Disables the drift counter
ConfigShared.ToggleEvent = "drift:toggle" -- Toggles the drift counter
ConfigShared.GetCurrentDriftScore = "drift:GetCurrentDriftScore" -- Get the current drift score ... I mean it's in the name ... 

-- Example usage
-- TriggerEvent("drift:GetCurrentDriftScore", function(score)
--     print("My score is: ", score) 
-- end)

ConfigShared.IsDrifting = "drift:IsDrifting" -- Return true or false if the player is drifting or not

-- Example usage
-- TriggerEvent("drift:IsDrifting", function(isDrifting)
--     print("Am i drifitng?", isDrifting) 
-- end)


ConfigShared.IsEnabled = "drift:IsEnabled" -- Checks if the counter is enabled

-- Example usage
-- TriggerEvent("drift:IsEnabled", function(isEnabled)
--     print("Is the counter enabled?", isEnabled) 
-- end)

ConfigShared.UseVehicleWhitelist = false -- Allow only listed vehicule to use the drift counter
ConfigShared.WhitelistedVehicules = { 
    [GetHashKey("180sx")] = true, -- This is an exemple, add more lines and replace '180sx' with the model name you want to add. the  '= true' means nothing, it's just here because with this syntaxe, a value is needed. Also yes, i could use `` instead of GetHashKey but my IDE don't like it and the it doesn't impact performance in this use case. Please don't make a PR to change that
    [GetHashKey("gtr")] = true,
    [GetHashKey("futo")] = true,
}


-- Possible positions:
-- 1 = bottom of the screen in the middle
-- 2 = top of the screen in the middle
ConfigShared.Position = 1

-- Do not touch this if you don't know what you are doing.
-- This allow you to add custom position, first value is pos X of the screen, second in pos Y of the screen.
-- min value is 0, max value is 1
ConfigShared.PositionsCoords = {
    [1] = {0.40104168653488, 0.89259258508682},
    [2] = {0.40104168653488, 0.05259258508682},
}


ConfigShared.DisplayAngle = true
ConfigShared.MaxAngle = 50