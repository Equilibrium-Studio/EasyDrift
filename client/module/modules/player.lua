Modules.Player = {}
Modules.Player.IsDead = false


function Modules.Player.GetPed()
    return PlayerPedId()
end

function Modules.Player.GetDeadStatus()
    return Modules.Player.IsDead
end

function Modules.Player.SetDeadStatus(status)
    Modules.Player.IsDead = status
end

function Modules.Player.GetPos()
    return GetEntityCoords(Modules.Player.GetPed())
end

function Modules.Player.GetHeading()
    return GetEntityHeading(Modules.Player.GetPed())
end

function Modules.Player.GetCurrentVehicle()
    return GetVehiclePedIsIn(Modules.Player.GetPed(), false)
end

function Modules.Player.GetLastVehicle()
    return GetVehiclePedIsIn(Modules.Player.GetPed(), true)
end

function Modules.Player.IsPedInAnyVehicle()
    if IsPedInAnyVehicle(Modules.Player.GetPed(), false) or IsPedInAnyVehicle(Modules.Player.GetPed(), true) then
        return true
    end
end

function Modules.Player.GetHealth()
    return GetEntityHealth(Modules.Player.GetPed())
end