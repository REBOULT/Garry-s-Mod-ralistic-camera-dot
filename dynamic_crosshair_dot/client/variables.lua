CrosshairDot = CrosshairDot or {}

--------------------= Default values =--------------------

CrosshairDot.Enabled = true
CrosshairDot.OutlineEnabled = true
CrosshairDot.Thirdperson = true
CrosshairDot.Dynamic3D = false
CrosshairDot.DynamicAnglesEnabled = true
CrosshairDot.DynamicDistanceEnabled = true
CrosshairDot.DynamicShakeEnabled = true
CrosshairDot.DynamicColorEnabled = false
CrosshairDot.Size = 6
CrosshairDot.OutlineSize = 1
CrosshairDot.DynamicAnglesScale = 0.3
CrosshairDot.DynamicShakeScale = 0.5
CrosshairDot.SmoothSpeed = 1
CrosshairDot.DotColor = Color(255,255,255, 255)
CrosshairDot.OutlineColor = Color(0,0,0, 255)
CrosshairDot.DynamicColor = Color(255,50,50, 255)

----------------------------------------------------------

CrosshairDot.Enabled = CreateClientConVar("crosshairdot_enabled", CrosshairDot.Enabled and 1 or 0):GetBool()
CrosshairDot.OutlineEnabled = CreateClientConVar("crosshairdot_enabled_outline", CrosshairDot.OutlineEnabled and 1 or 0):GetBool()
CrosshairDot.Thirdperson = CreateClientConVar("crosshairdot_thirdperson", CrosshairDot.Thirdperson and 1 or 0):GetBool()
CrosshairDot.Dynamic3D = CreateClientConVar("crosshairdot_dynamic3d", CrosshairDot.Dynamic3D and 1 or 0):GetBool()
CrosshairDot.DynamicAnglesEnabled = CreateClientConVar("crosshairdot_enabled_dynamic_angles", CrosshairDot.DynamicAnglesEnabled and 1 or 0):GetBool()
CrosshairDot.DynamicDistanceEnabled = CreateClientConVar("crosshairdot_enabled_dynamic_distance", CrosshairDot.DynamicDistanceEnabled and 1 or 0):GetBool()
CrosshairDot.DynamicShakeEnabled = CreateClientConVar("crosshairdot_enabled_dynamic_shake", CrosshairDot.DynamicShakeEnabled and 1 or 0):GetBool()
CrosshairDot.DynamicColorEnabled = CreateClientConVar("crosshairdot_enabled_dynamic_color", CrosshairDot.DynamicColorEnabled and 1 or 0):GetBool()
CrosshairDot.Size = CreateClientConVar("crosshairdot_size", CrosshairDot.Size):GetFloat()
CrosshairDot.OutlineSize = CreateClientConVar("crosshairdot_outline_size", CrosshairDot.OutlineSize):GetFloat()
CrosshairDot.DynamicAnglesScale = CreateClientConVar("crosshairdot_dynamic_angles_scale", CrosshairDot.DynamicAnglesScale):GetFloat()
CrosshairDot.DynamicShakeScale = CreateClientConVar("crosshairdot_dynamic_shake_scale", CrosshairDot.DynamicShakeScale):GetFloat()
CrosshairDot.SmoothSpeed = CreateClientConVar("crosshairdot_smooth_speed", CrosshairDot.SmoothSpeed):GetFloat()

CrosshairDot.DotColor.r = CreateClientConVar("crosshairdot_dotcolor_r", CrosshairDot.DotColor.r):GetInt()
CrosshairDot.DotColor.g = CreateClientConVar("crosshairdot_dotcolor_g", CrosshairDot.DotColor.g):GetInt()
CrosshairDot.DotColor.b = CreateClientConVar("crosshairdot_dotcolor_b", CrosshairDot.DotColor.b):GetInt()
CrosshairDot.DotColor.a = CreateClientConVar("crosshairdot_dotcolor_a", CrosshairDot.DotColor.a):GetInt()

CrosshairDot.OutlineColor.r = CreateClientConVar("crosshairdot_outlinecolor_r", CrosshairDot.OutlineColor.r):GetInt()
CrosshairDot.OutlineColor.g = CreateClientConVar("crosshairdot_outlinecolor_g", CrosshairDot.OutlineColor.g):GetInt()
CrosshairDot.OutlineColor.b = CreateClientConVar("crosshairdot_outlinecolor_b", CrosshairDot.OutlineColor.b):GetInt()
CrosshairDot.OutlineColor.a = CreateClientConVar("crosshairdot_outlinecolor_a", CrosshairDot.OutlineColor.a):GetInt()

CrosshairDot.DynamicColor.r = CreateClientConVar("crosshairdot_dynamiccolor_r", CrosshairDot.DynamicColor.r):GetInt()
CrosshairDot.DynamicColor.g = CreateClientConVar("crosshairdot_dynamiccolor_g", CrosshairDot.DynamicColor.g):GetInt()
CrosshairDot.DynamicColor.b = CreateClientConVar("crosshairdot_dynamiccolor_b", CrosshairDot.DynamicColor.b):GetInt()
CrosshairDot.DynamicColor.a = CreateClientConVar("crosshairdot_dynamiccolor_a", CrosshairDot.DynamicColor.a):GetInt()

CrosshairDot.DynamicEyeAngles = EyeAngles()
CrosshairDot.SmoothColor = CrosshairDot.DotColor
CrosshairDot.SmoothSize = CrosshairDot.Size
CrosshairDot.ChangedShouldDraw = true
CrosshairDot.GeneralAlphaColor = 1

CrosshairDot.ResetConvar = function(name)
    local convar = GetConVar(name)
    if convar then convar:SetString(convar:GetDefault()) end
end

concommand.Add("crosshairdot_reset", function()
    CrosshairDot.ResetConvar("crosshairdot_enabled")
    CrosshairDot.ResetConvar("crosshairdot_enabled_outline")
    CrosshairDot.ResetConvar("crosshairdot_thirdperson")
    CrosshairDot.ResetConvar("crosshairdot_dynamic3d")
    CrosshairDot.ResetConvar("crosshairdot_enabled_dynamic_angles")
    CrosshairDot.ResetConvar("crosshairdot_enabled_dynamic_distance")
    CrosshairDot.ResetConvar("crosshairdot_enabled_dynamic_shake")
    CrosshairDot.ResetConvar("crosshairdot_enabled_dynamic_color")
    CrosshairDot.ResetConvar("crosshairdot_size")
    CrosshairDot.ResetConvar("crosshairdot_outline_size")
    CrosshairDot.ResetConvar("crosshairdot_dynamic_angles_scale")
    CrosshairDot.ResetConvar("crosshairdot_dynamic_shake_scale")
    CrosshairDot.ResetConvar("crosshairdot_smooth_speed")
    CrosshairDot.ResetConvar("crosshairdot_dotcolor_r")
    CrosshairDot.ResetConvar("crosshairdot_dotcolor_g")
    CrosshairDot.ResetConvar("crosshairdot_dotcolor_b")
    CrosshairDot.ResetConvar("crosshairdot_dotcolor_a")
    CrosshairDot.ResetConvar("crosshairdot_outlinecolor_r")
    CrosshairDot.ResetConvar("crosshairdot_outlinecolor_g")
    CrosshairDot.ResetConvar("crosshairdot_outlinecolor_b")
    CrosshairDot.ResetConvar("crosshairdot_outlinecolor_a")
    CrosshairDot.ResetConvar("crosshairdot_dynamiccolor_r")
    CrosshairDot.ResetConvar("crosshairdot_dynamiccolor_g")
    CrosshairDot.ResetConvar("crosshairdot_dynamiccolor_b")
    CrosshairDot.ResetConvar("crosshairdot_dynamiccolor_a")
    surface.PlaySound("buttons/button15.wav")
end)
  
cvars.AddChangeCallback("crosshairdot_enabled", function(convar, oldValue, newValue)
    CrosshairDot.Enabled = tobool(newValue)
end)
cvars.AddChangeCallback("crosshairdot_enabled_outline", function(convar, oldValue, newValue)
    CrosshairDot.OutlineEnabled = tobool(newValue)
end)
cvars.AddChangeCallback("crosshairdot_thirdperson", function(convar, oldValue, newValue)
    CrosshairDot.Thirdperson = tobool(newValue)
end)
cvars.AddChangeCallback("crosshairdot_dynamic3d", function(convar, oldValue, newValue)
    CrosshairDot.Dynamic3D = tobool(newValue)
end)
cvars.AddChangeCallback("crosshairdot_enabled_dynamic_angles", function(convar, oldValue, newValue)
    CrosshairDot.DynamicAnglesEnabled = tobool(newValue)
end)
cvars.AddChangeCallback("crosshairdot_enabled_dynamic_distance", function(convar, oldValue, newValue)
    CrosshairDot.DynamicDistanceEnabled = tobool(newValue)
end)
cvars.AddChangeCallback("crosshairdot_enabled_dynamic_shake", function(convar, oldValue, newValue)
    CrosshairDot.DynamicShakeEnabled = tobool(newValue)
end)
cvars.AddChangeCallback("crosshairdot_enabled_dynamic_color", function(convar, oldValue, newValue)
    CrosshairDot.DynamicColorEnabled = tobool(newValue)
end)

cvars.AddChangeCallback("crosshairdot_size", function(convar, oldValue, newValue)
    CrosshairDot.Size = math.Clamp(tonumber(newValue), 0, 50)
end)
cvars.AddChangeCallback("crosshairdot_outline_size", function(convar, oldValue, newValue)
    CrosshairDot.OutlineSize = math.Clamp(tonumber(newValue), 0, 20)
end)

cvars.AddChangeCallback("crosshairdot_dynamic_angles_scale", function(convar, oldValue, newValue)
    CrosshairDot.DynamicAnglesScale = math.Clamp(tonumber(newValue), -5, 5)
end)
cvars.AddChangeCallback("crosshairdot_dynamic_shake_scale", function(convar, oldValue, newValue)
    CrosshairDot.DynamicShakeScale = math.Clamp(tonumber(newValue), -3, 3)
end)
cvars.AddChangeCallback("crosshairdot_smooth_speed", function(convar, oldValue, newValue)
    CrosshairDot.SmoothSpeed = math.Clamp(tonumber(newValue), 0, 1)
end)

cvars.AddChangeCallback("crosshairdot_dotcolor_r", function(convar, oldValue, newValue)
    CrosshairDot.DotColor.r = tonumber(newValue)
end)
cvars.AddChangeCallback("crosshairdot_dotcolor_g", function(convar, oldValue, newValue)
    CrosshairDot.DotColor.g = tonumber(newValue)
end)
cvars.AddChangeCallback("crosshairdot_dotcolor_b", function(convar, oldValue, newValue)
    CrosshairDot.DotColor.b = tonumber(newValue)
end)
cvars.AddChangeCallback("crosshairdot_dotcolor_a", function(convar, oldValue, newValue)
    CrosshairDot.DotColor.a = tonumber(newValue)
end)

cvars.AddChangeCallback("crosshairdot_outlinecolor_r", function(convar, oldValue, newValue)
    CrosshairDot.OutlineColor.r = tonumber(newValue)
end)
cvars.AddChangeCallback("crosshairdot_outlinecolor_g", function(convar, oldValue, newValue)
    CrosshairDot.OutlineColor.g = tonumber(newValue)
end)
cvars.AddChangeCallback("crosshairdot_outlinecolor_b", function(convar, oldValue, newValue)
    CrosshairDot.OutlineColor.b = tonumber(newValue)
end)
cvars.AddChangeCallback("crosshairdot_outlinecolor_a", function(convar, oldValue, newValue)
    CrosshairDot.OutlineColor.a = tonumber(newValue)
end)

cvars.AddChangeCallback("crosshairdot_dynamiccolor_r", function(convar, oldValue, newValue)
    CrosshairDot.DynamicColor.r = tonumber(newValue)
end)
cvars.AddChangeCallback("crosshairdot_dynamiccolor_g", function(convar, oldValue, newValue)
    CrosshairDot.DynamicColor.g = tonumber(newValue)
end)
cvars.AddChangeCallback("crosshairdot_dynamiccolor_b", function(convar, oldValue, newValue)
    CrosshairDot.DynamicColor.b = tonumber(newValue)
end)
cvars.AddChangeCallback("crosshairdot_dynamiccolor_a", function(convar, oldValue, newValue)
    CrosshairDot.DynamicColor.a = tonumber(newValue)
end)