Modules.PointFeed = {}
Modules.PointFeed.WaitingFeed = {}
Modules.PointFeed.feed = {}


function Modules.PointFeed.AddNewKill(weapon, name, xp)
    table.insert(Modules.PointFeed.WaitingFeed, {type = "kill", weap = weapon, name = name, xp = xp})
    Modules.Sound.PlaySound(math.random(1,999), "reward/UX_EOR_Ribbon_Tick_End_Wave", false, 0.01)
end

function Modules.PointFeed.AddNewCapture(xp)
    table.insert(Modules.PointFeed.WaitingFeed, {type = "obj_captured", xp = xp})
    Modules.Sound.PlaySound(math.random(1,999), "reward/UX_EOR_Promotion_Wave", false, 0.1)
end

function Modules.PointFeed.AddNewObjectiveStolen(xp)
    table.insert(Modules.PointFeed.WaitingFeed, {type = "obj_stolen", xp = xp})
end

function Modules.PointFeed.AddNewRibbon(name, xp)
    table.insert(Modules.PointFeed.WaitingFeed, {type = "ribbons", name = name, xp = xp})
end


Citizen.CreateThread(function()
    while true do
        --if Modules.Lobby.CurrentGameId ~= 0 then

            for index,feed in pairs(Modules.PointFeed.WaitingFeed) do
                table.insert(Modules.PointFeed.feed, 1, {
                    type = feed.type,
                    weap = feed.weap,
                    name = feed.name,
                    xp = feed.xp,

                    justAdded = true,
                    alpha = 0,
                    sizeBonus = 1.5,
                    frameOnScreen = 5000,
                })
                Modules.PointFeed.WaitingFeed[index] = nil
                break
            end

            if not Modules.Player.GetDeadStatus() then
                local baseX = 0.55
                local baseY = 0.8
                local baseYToRemove = 0.025
                local i = 0

                for index,feed in pairs(Modules.PointFeed.feed) do
                    if feed.justAdded then
                        if feed.alpha < 255 then
                            feed.alpha = feed.alpha + (0.65 * Modules.Utils.TimeFrame)
                        else
                            feed.alpha = 255
                            feed.justAdded = false
                        end
                    else
                        feed.frameOnScreen = feed.frameOnScreen - (1 * Modules.Utils.TimeFrame)
                        if feed.frameOnScreen < 0 then
                            feed.alpha = feed.alpha - (0.45 * Modules.Utils.TimeFrame)
                        end
                    end

                    feed.sizeBonus = feed.sizeBonus - (0.0015 * Modules.Utils.TimeFrame)
                    if feed.sizeBonus <= 1.0 then
                        feed.sizeBonus = 1.0
                    end

                    Modules.UI.DrawTexts(baseX, baseY + (baseYToRemove * i), tostring(feed.xp.." XP"), false, 0.35 * feed.sizeBonus, {255, 255, 255, math.floor(feed.alpha)}, Modules.UI.font["BF_Modernista-Regular"], false, false)
                    if feed.type == "kill" then
                        Modules.UI.DrawTexts(baseX - 0.01, baseY + (baseYToRemove * i), tostring("~c~["..feed.weap.."]~s~ "..feed.name), false, 0.35 * feed.sizeBonus, {ConfigShared.Colors.enemy[1], ConfigShared.Colors.enemy[2], ConfigShared.Colors.enemy[3], math.floor(feed.alpha)}, Modules.UI.font["BF_Modernista-Regular"], true, false)
                    elseif feed.type == "obj_captured" then
                        Modules.UI.DrawTexts(baseX - 0.01, baseY + (baseYToRemove * i), "OBJECTIVE CAPTURED", false, 0.35 * feed.sizeBonus, {255, 255, 255, math.floor(feed.alpha)}, Modules.UI.font["BF_Modernista-Regular"], true, false)
                    elseif feed.type == "obj_stolen" then
                        Modules.UI.DrawTexts(baseX - 0.01, baseY + (baseYToRemove * i), "OBJECTIVE STOLEN", false, 0.35 * feed.sizeBonus, {255, 255, 255, math.floor(feed.alpha)}, Modules.UI.font["BF_Modernista-Regular"], true, false)
                    elseif feed.type == "ribbons" then
                        Modules.UI.DrawTexts(baseX - 0.01, baseY + (baseYToRemove * i), feed.name.." RIBBON", false, 0.35 * feed.sizeBonus, {255, 255, 255, math.floor(feed.alpha)}, Modules.UI.font["BF_Modernista-Regular"], true, false)
                    end
                    i = i + 1
                end

                for index,feed in pairs(Modules.PointFeed.feed) do
                    if not feed.justAdded then
                        if feed.frameOnScreen <= 0 then
                            if feed.alpha <= 0 then
                                Modules.PointFeed.feed[index] = nil
                            end
                        end
                    end
                end

            end

        -- else
        --     Wait(1000)
        -- end
        Wait(0)
    end
end)


-- Citizen.CreateThread(function()
--     local i = 0
--     local nextObj = 5
--     while true do
--         Modules.PointFeed.AddNewKill("AK-47", "ItsYaBooy - "..i, 50)
--         if i == nextObj then
--             Modules.PointFeed.AddNewCapture(1000)
--             nextObj = nextObj + 5
--         end
--         print(#Modules.PointFeed.feed)
--         i = i + 1
--         Wait(math.random(1000,3000))
--     end
-- end)