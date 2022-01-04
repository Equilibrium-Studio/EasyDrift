-- Some parts here are pretty ugly, i know. Will to a refractor to this lib someday.
Modules.UI = {}
Modules.UI.cooldown = false
Modules.UI.font = {}
Modules.UI.AnimatedFrames = {}
Modules.UI.pages = {
    ["hud_drift"] = {
        label = "hud_drift",
        active = false,
        lockControls = false,
        showCursor = false,
        drawFunction = function()
            Modules.UI.DisplayDrift()
        end,
    },
}
Modules.UI.lockedControls = {
    {24, 30, 31, 32, 33, 34, 35, 69, 70, 92, 114, 121, 140, 141, 142, 257, 263, 264, 331, 1, 2, 4, 5, 17, 16, 15, 14}
}

function Modules.UI.IsAnySubMenuActive()
    for k,v in pairs(Modules.UI.pages) do
        if v.active then
            return true
        end
    end
    return false
end

function Modules.UI.SetPageActive(page)
    if Modules.UI.pages[page] then
        Modules.UI.pages[page].active = true
    end
end

function Modules.UI.SetPageInactive(page)
    if Modules.UI.pages[page] then
        Modules.UI.pages[page].active = false
    end
end

function Modules.UI.SetFullscreenLoaderActive(status)
    if status then
        SendNUIMessage({
            type    = 'toggleLoaderOn',
        })
    else
        SendNUIMessage({
            type    = 'toggleLoaderOff',
        })
    end
end

function Modules.UI.ForceStopIntro()
    SendNUIMessage({
        type    = 'stopIntro',
    })
end

Citizen.CreateThread(function()
    while true do
        local lockControls = false
        local showCursor = false


        for k,v in pairs(Modules.UI.pages) do
            --print(v.active, k)
            if v.active then
                if v.showCursor then
                    showCursor = true
                end
                if v.lockControls then
                    lockControls = true
                end
                v.drawFunction()
            end
        end

        if showCursor then
            ShowCursorThisFrame()
            SetMouseCursorSprite(1)
        end
        
        if lockControls then
            for k,v in pairs(Modules.UI.lockedControls[1]) do
                if v ~= nil then
                    DisableControlAction(0, v, true)
                end
            end
        end

        Wait(1)
    end
end)


-- Duplicate, need to be removed
function Modules.UI.RealWait(ms, cb)
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

function Modules.UI.LoadStreamDict(dict)
    while not HasStreamedTextureDictLoaded(dict) do
        RequestStreamedTextureDict(dict, 1)
        print("Loading dict ", dict)
        Wait(0)
    end
    print("Dict loaded! ", dict)
end

function Modules.UI.LoadFont(font)
    RegisterFontFile(font[1]) -- the name of your .gfx, without .gfx
    local fontId = RegisterFontId(font[2]) -- the name from the .xml

    Modules.UI.font[font[2]] = fontId
end


function Modules.UI.DrawSlider(screenX, screenY, width, height, backgroundColor, progressColor, value, max, settings, cb)
    if settings.devmod ~= nil and settings.devmod == true then
        local x = GetControlNormal(0, 239)
        local y = GetControlNormal(0, 240)


        screenX = x
        screenY = y

        
        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x..", "..y)
        end
    end
	
    if value > max then
        value = max
    end

    if settings.direction == nil then
        settings.direction = 1
    end

    local valueUpdated = false
    local newValue = value

    local pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)
    DrawRect(pos[1], pos[2], width, height, backgroundColor[1], backgroundColor[2], backgroundColor[3], backgroundColor[4])
    
    local progressWidth = (value/max) * width
    local progressHeight = height

    if settings.direction == 1 then -- left-to-right
        pos = (vector2(screenX, screenY) + vector2(progressWidth, height) / 2.0)
    elseif settings.direction == 2 then -- right-to-left
        pos = pos + vector2(width / 2.0, 0.0) - vector2(progressWidth / 2.0, 0.0)
    elseif settings.direction == 3 then -- bottom-to-top
        progressWidth = width
        progressHeight = (value/max) * width
        pos = pos + vector2(0.0, height / 2.0) - vector2(0.0, progressHeight / 2.0)
    elseif settings.direction == 4 then -- top-to-bottom
        progressWidth = width
        progressHeight = (value/max) * width
        pos = pos - vector2(0.0, height / 2.0) + vector2(0.0, progressHeight / 2.0)
    end

    DrawRect(pos[1], pos[2], progressWidth, progressHeight, progressColor[1], progressColor[2], progressColor[3], progressColor[4])

    if settings.noHover == false then
        if Modules.UI.isMouseOnButton({x = GetControlNormal(0, 239) , y = GetControlNormal(0, 240)}, {x = screenX, y = screenY}, width, height) then
            SetMouseCursorSprite(4)
            if IsControlPressed(0, 24) then
                local mouse = GetControlNormal(0, 239)
                local size = ((mouse - screenX) * max) / width
                newValue = size
    
                --print(newValue)
                valueUpdated = true
            end
        end
    end

    cb(valueUpdated, newValue)
end



Modules.UI.HoveredCache = {}

function Modules.UI.CheckIfAlreadyHovered(textureDict, textureName, screenX, screenY)
    local uniqueID = textureDict .. textureName .. screenX .. screenY
    if Modules.UI.HoveredCache[uniqueID] == nil then
        Modules.UI.HoveredCache[uniqueID] = false
        return false, uniqueID
    else
        return Modules.UI.HoveredCache[uniqueID], uniqueID
    end
end

function Modules.UI.SetHoveredStatus(uniqueID, status)
    if Modules.UI.HoveredCache[uniqueID] ~= nil then
        Modules.UI.HoveredCache[uniqueID] = status
    end
end

function Modules.UI.DrawSpriteNew(textureDict, textureName, screenX, screenY, width, height, heading, red, green, blue, alpha, settings, cb)
    local onSelected = false
    local onHovered = false

    if settings.devmod ~= nil and settings.devmod == true then
        local x = GetControlNormal(0, 239)
        local y = GetControlNormal(0, 240)

       print(x, y)

        screenX = x
        screenY = y

        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x..", "..y)
        end
    end

    local pos
    if settings.centerDraw ~= nil and settings.centerDraw == true then
        pos = vector2(screenX, screenY)
    else
        pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)
    end

    -- if Modules.Sheets.IsSpriteAnimated(textureDict, textureName) then
    --     textureName = textureName..Modules.Sheets.GetActualFrame(textureDict, textureName)
    -- end

    if settings.Draw3d ~= nil then
        SetDrawOrigin(settings.Draw3d.pos.x, settings.Draw3d.pos.y, settings.Draw3d.pos.z, 0)
        pos = (vector2(0.0, 0.0) + vector2(width, height) / 2.0)
    end

    if settings.NoHover ~= nil and settings.NoHover == true then
        DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
    else
        if settings.Draw3d ~= nil then
            _, screenX, screenY = GetScreenCoordFromWorldCoord(settings.Draw3d.pos.x, settings.Draw3d.pos.y, settings.Draw3d.pos.z)
        end
        if Modules.UI.isMouseOnButton({x = GetControlNormal(0, 239) , y = GetControlNormal(0, 240)}, {x = screenX, y = screenY}, width, height) then
            onHovered = true
            local aleadyHovered, spriteUniqueId = Modules.UI.CheckIfAlreadyHovered(textureDict, textureName, screenX, screenY)
            if not aleadyHovered then
                Modules.UI.SetHoveredStatus(spriteUniqueId, true)
                Modules.Sound.PlaySound(math.random(1,99999), "FrontEnd/Navigate_Highlight", false, 0.02)
            end
            if settings.CustomHoverTexture ~= nil and settings.CustomHoverTexture ~= false then
                if settings.CustomHoverTexture[3] ~= nil and settings.CustomHoverTexture[4] ~= nil then
                    local x,y = Modules.UI.ConvertToPixel(settings.CustomHoverTexture[3], settings.CustomHoverTexture[4])
                    width = x
                    height = y
                end

                DrawSprite(settings.CustomHoverTexture[1], settings.CustomHoverTexture[2], pos[1], pos[2], width, height, heading, red, green, blue, alpha)
            else
                DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
            end
        else
            onHovered = false
            local aleadyHovered, spriteUniqueId = Modules.UI.CheckIfAlreadyHovered(textureDict, textureName, screenX, screenY)
            if aleadyHovered then
                Modules.UI.SetHoveredStatus(spriteUniqueId, false)
            end
            DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
        end
    end


    if settings.NoSelect == nil or settings.NoSelect == false and not settings.devmod == true then
        if Modules.UI.isMouseOnButton({x = GetControlNormal(0, 239) , y = GetControlNormal(0, 240)}, {x = screenX, y = screenY}, width, height) then
            SetMouseCursorSprite(4)
            onHovered = true
            if Modules.UI.HandleControl() then
                --PlayCustomSound("FrontEnd/Navigate_Apply_01_Wave 0 0 0", 0.02)
                Modules.Sound.PlaySound(math.random(1,99999), "FrontEnd/Navigate_Apply_01_Wave 0 0 0", false, 0.02)
                onSelected = true
            end
        end
    end
    
    if settings.Draw3d ~= nil then
        ClearDrawOrigin()
    end

    cb(onSelected, onHovered, pos)
end

-- Position = mouse pos
function Modules.UI.isMouseOnButton(position, buttonPos, Width, Heigh)
   -- print(position, buttonPos, Width, Heigh)
	return position.x >= buttonPos.x and position.y >= buttonPos.y and position.x < buttonPos.x + Width and position.y < buttonPos.y + Heigh
end



function Modules.UI.HandleCooldown()
    if not Modules.UI.cooldown then
        Modules.UI.cooldown = true
        Citizen.CreateThread(function()
            Wait(150)
            Modules.UI.cooldown = false
        end)
    end
end

local clickControl = {24, 176}
function Modules.UI.HandleControl()
    for k,v in pairs(clickControl) do
        if not Modules.UI.cooldown then
            if IsControlJustReleased(0, v) or IsDisabledControlJustReleased(0, v) then
                Modules.UI.HandleCooldown()
                return true 
            end
        end
    end
    return false
end


function Modules.UI.DrawTexts(x, y, text, center, scale, rgb, font, rightJustify, devmod) 

    if devmod then
        local x2 = GetControlNormal(0, 239)
        local y2 = GetControlNormal(0, 240)

        x = x2
        y = y2

        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x..", "..y)
        end
    end

    if rightJustify ~= 0 and rightJustify ~= false then
        SetTextJustification(2)
        SetTextWrap(0.0, x) 
    end

    SetTextFont(font)
    SetTextScale(scale, scale)

    SetTextColour(rgb[1], rgb[2], rgb[3], rgb[4])
    SetTextEntry("STRING")
    SetTextCentre(center)
    AddTextComponentString(text)
    EndTextCommandDisplayText(x,y)
end

function Modules.UI.DrawTextsNoLimit(x, y, text, center, scale, rgb, font, rightJustify, devmod)
    AddTextEntry("text", text)

    if devmod then
        local x2 = GetControlNormal(0, 239)
        local y2 = GetControlNormal(0, 240)

        print(x2, y2)

        x = x2
        y = y2
    end

    if rightJustify ~= 0 and rightJustify ~= false then
        SetTextJustification(2)
        SetTextWrap(0.0, x) 
    end

    SetTextFont(font)
    SetTextScale(scale, scale)

    SetTextColour(rgb[1], rgb[2], rgb[3], rgb[4])
    SetTextEntry("STRING")
    SetTextCentre(center)
    AddTextComponentString(text)
    EndTextCommandDisplayText(x,y)
end

function Modules.UI.Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov   
    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(250, 250, 250, 255)		-- You can change the text color here
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end


-- pos.xyz
-- textureDict
-- textureName
-- x
-- y
-- width
-- height
-- heading
-- r
-- g
-- b
-- a
function Modules.UI.DrawSprite3d(data, dontDrawHowOfScreen)
    if dontDrawHowOfScreen == nil then
        dontDrawHowOfScreen = false
    end

    local draw = false
    if dontDrawHowOfScreen == false then
        draw = true
    else
        local get, x,y = GetScreenCoordFromWorldCoord(data.pos.x, data.pos.y, data.pos.z)
        --print(get, x, y)
        if not get or x < 0.0 or x > 1.0 or y < 0.0 or y > 1.0 then
            draw = false
        else
            draw = true
        end
    end

    if draw then
        local dist = #(GetGameplayCamCoords().xy - data.pos.xy)
        local fov = (1 / GetGameplayCamFov()) * 100
        local scale = ((1 / dist) * 2) * fov
        SetDrawOrigin(data.pos.x, data.pos.y, data.pos.z, 0)
        DrawSprite(
            data.textureDict,
            data.textureName,
            (data.x or 0) * scale,
            (data.y or 0) * scale,
            data.width * scale,
            data.height * scale,
            data.heading or 0,
            data.r or 255,
            data.g or 255,
            data.b or 255,
            data.a or 255
        )
        ClearDrawOrigin()
    end
    return draw
end

function Modules.UI.DrawSprite3dNoDownSize(data, dontDrawHowOfScreen)
    if dontDrawHowOfScreen == nil then
        dontDrawHowOfScreen = false
    end

    local draw = false
    if dontDrawHowOfScreen == false then
        draw = true
    else
        local get, x,y = GetScreenCoordFromWorldCoord(data.pos.x, data.pos.y, data.pos.z)
        if not get or x < 0.0 or x > 1.0 or y < 0.0 or y > 1.0 then
            draw = false
        else
            draw = true
        end
    end

    if draw then
        local scale = 1
        SetDrawOrigin(data.pos.x, data.pos.y, data.pos.z, 0)
        DrawSprite(
            data.textureDict,
            data.textureName,
            data.x or (0 * scale),
            data.y or (0 * scale),
            data.width * scale,
            data.height * scale,
            data.heading or 0,
            data.r or 255,
            data.g or 255,
            data.b or 255,
            data.a or 255
        )
        ClearDrawOrigin()
    end
    return draw

end

-- function Modules.UI.ConvertToPixel(x, y)
--     return (x * 1920), (y * 1080)
-- end

function Modules.UI.ConvertToPixel(x, y)
    return (x / 1920), (y / 1080)
end

function Modules.UI.ConvertToRes(x, y)
    return (x * 1920), (y * 1080)
end