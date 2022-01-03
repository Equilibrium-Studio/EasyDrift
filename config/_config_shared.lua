ConfigShared = {}
ConfigShared.UseDefaultUI = true -- Set this to false if you want to use your own UI


ConfigShared.DriftChainTime = 5000 -- Time in MS
ConfigShared.AddStaticPointOnDrifting = true -- Add a static number of point on every frame when the player is drifting
ConfigShared.StaticPointToAdd = 1 -- This is added every frame, so it will grow very fast

ConfigShared.AddPointBasedOnAngle = true -- Add an angle based point every frame when the player is drifting. The more angle the player take, the more point he will get

ConfigShared.DriftFinishedEvent = "drift:finish" -- Name of the evet triggered when a drift is finished, this is a client side event. The drift score is sent as first arg
ConfigShared.DriftStartEvent = "drift:start" -- Name of the evet triggered when a drift is started, this is a client side event.