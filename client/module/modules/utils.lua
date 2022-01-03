Modules.Utils = {}
Modules.Utils.cachedData = {}
Modules.Utils.TimeFrame = 0

function Modules.Utils.RealWait(ms, cb)
    local timer = GetGameTimer() + ms
	local timeLeft = GetGameTimer() - timer
    while GetGameTimer() < timer do
		timeLeft = GetGameTimer() - timer
        if cb ~= nil then
            cb(function(stop, setValue)
                if stop then
                    timer = 0
                    return
                end

				if setValue ~= nil then
					timer = GetGameTimer() + setValue
				end
            end, timeLeft)
        end
        Wait(0)
    end
end

-- Source: http://lua-users.org/wiki/FormattingNumbers
function Modules.Utils.Comma_value(amount)
    local formatted = amount
    local k
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

local timer = GetGameTimer()
Citizen.CreateThread(function()
	while true do
		Modules.Utils.TimeFrame = (GetGameTimer() - timer)
		timer = GetGameTimer()
		Wait(0)
	end
end)