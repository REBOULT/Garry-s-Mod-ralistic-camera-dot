CrosshairDot = CrosshairDot or {}

CrosshairDot.Lerp = function(t, from, to)
    local value = Lerp(t, from, to)
    if math.abs(value - to) < 0.001 then
        return to
    else
        return value
    end
end

CrosshairDot.LerpColor = function(t, from, to)
    return Color(
        CrosshairDot.Lerp(t, from.r, to.r),
        CrosshairDot.Lerp(t, from.g, to.g),
        CrosshairDot.Lerp(t, from.b, to.b),
        CrosshairDot.Lerp(t, from.a, to.a)
    )
end

CrosshairDot.ApplyGeneralAlphaColor = function (color, GeneralAlphaColor)
    return Color(color.r, color.g, color.b, color.a * (GeneralAlphaColor or CrosshairDot.GeneralAlphaColor))
end

CrosshairDot.DrawDot = function(x, y, radius, quality, color)
    x = x or 0
    y = y or 0
    radius = radius or 3
    quality = quality or 50
    color = color or Color(255,255,255, 255)
    local circle = {}
    local temp = 0
    for i = 1, quality do
        temp = math.rad(i*360)/quality
        circle[i] = {
            x = x + math.cos(temp) * radius/2,
            y = y + math.sin(temp) * radius/2
        }
    end
    
    surface.SetDrawColor(color)
    draw.NoTexture()
    surface.DrawPoly(circle)
end

local lastPrint;
function printOnce (text) 
    if text != lastPrint then 
        lastPrint = text
        print(text)
    end
end

CrosshairDot.ShouldDraw = function ()
    if CrosshairDot.Enabled then
        local player = LocalPlayer()
        local weapon = player:GetActiveWeapon();
        if 
            !player:InVehicle() and
            player:Team() ~= TEAM_SPECTATOR and 
            player == GetViewEntity() and
            not (not CrosshairDot.Thirdperson and player:EyePos() ~= EyePos()) and
            CrosshairDot.ShouldWeaponDraw(weapon) then
            return true
        end
    end
    return false
end

CrosshairDot.ShouldWeaponDraw = function (weapon)
    if type(weapon.DrawCrosshair) == "boolean" and not weapon.DrawCrosshair then return false end
    return (
        not (type(weapon.Getironsights) == "function" and weapon:Getironsights()) and
        not (type(weapon.GetIronsights) == "function" and weapon:GetIronsights()) and
        not (type(weapon.GetIronSights) == "function" and weapon:GetIronSights()) and
        not (weapon.Sighted ~= nil and ArcCW ~= nil and (weapon.Sighted or weapon:GetState() == ArcCW.STATE_SIGHTS)) -- ArcCW
    )
end

hook.Add("HUDShouldDraw", "CrosshairDot_ShouldDraw", function(name)
    if CrosshairDot.Enabled and name == "CHudCrosshair" then return false end
end)

hook.Add("HUDPaint", "CrosshairDot_HUD", function()
    if CrosshairDot.Enabled then
        local player = LocalPlayer()
        local weapon = player:GetActiveWeapon()

        local EyeTrace = player:GetEyeTrace()
        local dynamicAnglesDif = 1
        if CrosshairDot.DynamicAnglesEnabled then
            local angle = CrosshairDot.DynamicEyeAngles - EyeAngles()
            angle:Normalize()
            if angle ~= Angle() then
                local dif = math.abs(angle.p) + math.abs(angle.y) + math.abs(angle.r)
                dynamicAnglesDif = dif * (dif^-0.5) * CrosshairDot.DynamicAnglesScale + 1
            end
        end
        CrosshairDot.DynamicEyeAngles = EyeAngles()
        
        local dynamicDistance = 1
        if CrosshairDot.DynamicDistanceEnabled then
            if !player:InVehicle() then
                dynamicDistance = math.Clamp((EyeTrace.HitPos:Distance(EyePos()) * 1) ^ 0.1 - 1, 0.1, 30)
            end
        end
        
        local dynamicShake = 1
        if CrosshairDot.DynamicShakeEnabled then
            local punchAngle = player:GetViewPunchAngles()
            dynamicShake = math.Clamp(math.abs(punchAngle.p) + math.abs(punchAngle.y) + math.abs(punchAngle.r) + 1, 0, 5) ^ CrosshairDot.DynamicShakeScale
        end
        
        if CrosshairDot.ShouldDraw() then
            CrosshairDot.SmoothSize = CrosshairDot.Lerp(0.1 * CrosshairDot.SmoothSpeed, CrosshairDot.SmoothSize, CrosshairDot.Size * dynamicAnglesDif * dynamicShake / dynamicDistance)
            CrosshairDot.GeneralAlphaColor = CrosshairDot.Lerp(0.1 * CrosshairDot.SmoothSpeed, CrosshairDot.GeneralAlphaColor, 1);
        else
            CrosshairDot.SmoothSize = CrosshairDot.Lerp(0.1 * CrosshairDot.SmoothSpeed, CrosshairDot.SmoothSize, 0)
            CrosshairDot.GeneralAlphaColor = CrosshairDot.Lerp(0.1 * CrosshairDot.SmoothSpeed, CrosshairDot.GeneralAlphaColor, 0);
        end

        if CrosshairDot.DynamicColorEnabled and IsValid(EyeTrace.Entity) and (EyeTrace.Entity:IsNPC() or EyeTrace.Entity:IsPlayer()) then
            CrosshairDot.SmoothColor = CrosshairDot.LerpColor(0.1 * CrosshairDot.SmoothSpeed, CrosshairDot.SmoothColor, CrosshairDot.ApplyGeneralAlphaColor(CrosshairDot.DynamicColor))
        else
            CrosshairDot.SmoothColor = CrosshairDot.LerpColor(0.1 * CrosshairDot.SmoothSpeed, CrosshairDot.SmoothColor, CrosshairDot.ApplyGeneralAlphaColor(CrosshairDot.DotColor))
        end

        local pos = { x = 0, y = 0 }
        if CrosshairDot.Dynamic3D and EyeTrace.HitPos:Distance(EyePos()) > 0 then
            pos = EyeTrace.HitPos:ToScreen()
        else
            pos = { x = ScrW() / 2, y = ScrH() / 2 }
        end

        if IsValid(weapon) then
            if CrosshairDot.OutlineEnabled then
                CrosshairDot.DrawDot(pos.x, pos.y, CrosshairDot.SmoothSize + CrosshairDot.OutlineSize, 50, CrosshairDot.ApplyGeneralAlphaColor(CrosshairDot.OutlineColor))
            end
            CrosshairDot.DrawDot(pos.x, pos.y, CrosshairDot.SmoothSize, 50, CrosshairDot.SmoothColor)
        end
    end
end)