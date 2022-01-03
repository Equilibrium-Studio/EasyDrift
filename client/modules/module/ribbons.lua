Modules.Ribbons = {}
Modules.Ribbons.WaitingFeed = {}
Modules.Ribbons.feed = {}
Modules.Ribbons.Size = {0, 0}


function Modules.Ribbons.AddNewRibbon(eventName, scoreToAdd)
    if ConfigShared.Ribbons.List[eventName] ~= nil then
        local self = ConfigShared.Ribbons.List[eventName]
        self.currentScore = self.currentScore + scoreToAdd
        if self.currentScore >= self.startEvent then
            self.currentScore = self.currentScore - self.startEvent
            table.insert(Modules.Ribbons.WaitingFeed, {eventName = eventName})
        end
    end
    local x,y = Modules.UI.ConvertToPixel(256,256)
    Modules.Ribbons.Size[1] = x
    Modules.Ribbons.Size[2] = y
end


Citizen.CreateThread(function()
    while true do
        --if Modules.Lobby.CurrentGameId ~= 0 then

            for index,feed in pairs(Modules.Ribbons.WaitingFeed) do
                if #Modules.Ribbons.feed <= 0 then
                    table.insert(Modules.Ribbons.feed, 1, {
                        eventName = feed.eventName,

                        displayedScore = 0,
                        correctScorejustReached = false,
                        correctScoreReached = false,
                        displayScoreSizeBonus = 1.3,
                        displayScoreSizeBonusCurrent = 1.0,
                        justAdded = true,
                        alpha = 0,
                        sizeBonus = 1.5,
                        frameOnScreen = 3000,
                    })
                    Modules.Ribbons.WaitingFeed[index] = nil
                    Modules.Sound.PlaySound(math.random(1,999), "reward/UX_EOR_Ribbon_Tick_End_Wave", false, 0.05)
                    Modules.PointFeed.AddNewRibbon(ConfigShared.Ribbons.List[feed.eventName].labelDisplayed, ConfigShared.Ribbons.List[feed.eventName].bonusXP)
                    break
                end
            end

            if not Modules.Player.GetDeadStatus() then
                local baseX = 0.51
                local baseY = 0.1
                local baseYToRemove = 0.025
                local i = 0

                for index,feed in pairs(Modules.Ribbons.feed) do
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

                    if not feed.correctScorejustReached and not feed.correctScoreReached then
                        feed.displayedScore = feed.displayedScore + 1
                        if feed.displayedScore >= ConfigShared.Ribbons.List[feed.eventName].bonusXP then
                            print("Starting size bonus")
                            feed.correctScorejustReached = true
                            feed.displayedScore = ConfigShared.Ribbons.List[feed.eventName].bonusXP
                        end
                    elseif feed.correctScorejustReached then
                        feed.displayScoreSizeBonusCurrent = feed.displayScoreSizeBonusCurrent + (0.0030 * Modules.Utils.TimeFrame)
                        if feed.displayScoreSizeBonusCurrent >= feed.displayScoreSizeBonus then
                            feed.displayScoreSizeBonusCurrent = feed.displayScoreSizeBonus
                            feed.correctScorejustReached = false
                            feed.correctScoreReached = true
                        end
                    elseif feed.correctScorejustReached == false and feed.displayScoreSizeBonusCurrent > 0 then
                        feed.displayScoreSizeBonusCurrent = feed.displayScoreSizeBonusCurrent - (0.0030 * Modules.Utils.TimeFrame)
                        if feed.displayScoreSizeBonusCurrent <= 1.0 then
                            feed.displayScoreSizeBonusCurrent = 1.0
                        end
                    end

                    feed.sizeBonus = feed.sizeBonus - (0.0015 * Modules.Utils.TimeFrame)
                    if feed.sizeBonus <= 1.0 then
                        feed.sizeBonus = 1.0
                    end

                    Modules.UI.DrawSpriteNew("ui_ribbons", ConfigShared.Ribbons.List[feed.eventName].sprite, baseX, baseY, Modules.Ribbons.Size[1] * feed.sizeBonus, Modules.Ribbons.Size[2] * feed.sizeBonus, 0, 255, 255, 255, math.floor(feed.alpha), {
                        NoHover = true,
                        CustomHoverTexture = false,
                        NoSelect = true,
                        devmod = false,
                        centerDraw = true,
                    }, function(onSelected, onHovered)
                
                    end)

                    Modules.UI.DrawTexts(baseX, baseY + 0.04 + (baseYToRemove * i), tostring(math.floor(feed.displayedScore)), true, 0.35 * feed.displayScoreSizeBonusCurrent, {255, 255, 255, math.floor(feed.alpha)}, Modules.UI.font["BF_Modernista-Regular"], false, false)
                    Modules.UI.DrawTexts(baseX, baseY - 0.08 + (baseYToRemove * i), ConfigShared.Ribbons.List[feed.eventName].labelDisplayed.." RIBBON", true, 0.35, {255, 255, 255, math.floor(feed.alpha)}, Modules.UI.font["BF_Modernista-Regular"], false, false)

                    i = i + 1
                end

                for index,feed in pairs(Modules.Ribbons.feed) do
                    if not feed.justAdded then
                        if feed.frameOnScreen <= 0 then
                            if feed.alpha <= 0 then
                                Modules.Ribbons.feed[index] = nil
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

RegisterNetEvent("Ribbons:AddEvent")
AddEventHandler("Ribbons:AddEvent", function(eventName, scoreToAdd)
    Modules.Ribbons.AddNewRibbon(eventName, scoreToAdd)
end)


-- Citizen.CreateThread(function()
--     while true do
--         Modules.Ribbons.AddNewRibbon("double_kill", 2)
--         Wait(math.random(100,3000))
--     end
-- end)