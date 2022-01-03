Modules.Utils = {}
Modules.Utils.cachedData = {}
Modules.Utils.TimeFrame = 0

function Modules.Utils.ShowNotification(message)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(message)
	DrawNotification(0,1)
end

function Modules.Utils.InputString(text, number, windows)
	AddTextEntry("FMMC_MPM_NA", text)
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", windows or "", "", "", "", number or 30)
	while UpdateOnscreenKeyboard() == 0 do
	  DisableAllControlActions(0)
	  Wait(0)
	end

	if (GetOnscreenKeyboardResult()) then
	  local result = GetOnscreenKeyboardResult()
		return result
	end
end



local entityEnumerator = {
    __gc = function(enum)
      if enum.destructor and enum.handle then
        enum.destructor(enum.handle)
      end
      enum.destructor = nil
      enum.handle = nil
    end
  }

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function Modules.Utils.EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function Modules.Utils.EnumeratePeds()
  	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function Modules.Utils.EnumerateVehicles()
  	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function Modules.Utils.EnumeratePickups()
  	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

function Modules.Utils.LoadAnimDict(animDict)
    RequestAnimDict(animDict)
    if DoesAnimDictExist(animDict) then
        while not HasAnimDictLoaded(animDict) do
            Wait(1)
        end
        -- Citizen.CreateThread(function() -- For now we let the dict loaded
        --     Wait(1000)
        --     RemoveAnimDict(animDict)
        -- end)
    else
        print("^1Trying to load anim dict that do not exist ", animDict)
    end
end

function Modules.Utils.StartMusicEvent(event)
    PrepareMusicEvent(event)
    return TriggerMusicEvent(event) == 1
end

function Modules.Utils.RealWait(ms, cb)
    local timer = GetGameTimer() + ms
    while GetGameTimer() < timer do
        if cb ~= nil then
            cb(function(stop)
                if stop then
                    timer = 0
                    return
                end
            end)
        end
        Wait(0)
    end
end

function Modules.Utils.GetRankIcon(level)
	local level = (level)
	if level < 10 then
		level = "00" .. tostring(level)
	elseif level < 100 then
		level = "0" .. tostring(level)
	end

	return "Rank"..level
end

function Modules.Utils.GetKillerPedFromSource(source)
	for k,v in pairs(GetActivePlayers()) do
		if GetPlayerPed(v) == source then
			return v
		end
	end
	return nil
end

function Modules.Utils.GetPedCauseOfDeath(victim, killer)
	local weapon
	if IsPedInAnyVehicle(killer, false) then
		local veh = GetVehiclePedIsIn(killer, false)
		if ConfigShared.Vehicules.List[GetEntityModel(veh)] ~= nil then
			weapon = ConfigShared.Vehicules.List[GetEntityModel(veh)].killfeedName
		else
			weapon = GetPedCauseOfDeath(victim)
		end
	else
		weapon = GetPedCauseOfDeath(victim)
	end
	return weapon
end

local timer = GetGameTimer()
Citizen.CreateThread(function()
	while true do
		Modules.Utils.TimeFrame = (GetGameTimer() - timer)
		timer = GetGameTimer()
		Wait(0)
	end
end)

--@Events

RegisterNetEvent("imperial:notification")
AddEventHandler("imperial:notification", function(message)
    Modules.Utils.ShowNotification(message)
end)