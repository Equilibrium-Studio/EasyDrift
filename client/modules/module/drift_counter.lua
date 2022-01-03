Modules.DriftCounter = {}
Modules.DriftCounter.IsDrifting = false



-- Source: https://github.com/Blumlaut/FiveM-DriftCounter/blob/master/driftcounter_c.lua
function Drift.GetCurrentAngle()
    if Modules.Player.IsPedInAnyVehicle() then
        local veh = Modules.Player.GetCurrentVehicle()
        local vx,vy,_ = table.unpack(GetEntityVelocity(veh))
        local modV = math.sqrt(vx*vx + vy*vy)


        local _,_,rz = table.unpack(GetEntityRotation(veh,0))
        local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))

        if GetEntitySpeed(veh)* 3.6 < 25 or GetVehicleCurrentGear(veh) == 0 then return 0,modV end --speed over 25 km/h

        local cosX = (sn*vx + cs*vy)/modV
        return math.deg(math.acos(cosX))*0.5, modV
    else
        return 0
    end
end

