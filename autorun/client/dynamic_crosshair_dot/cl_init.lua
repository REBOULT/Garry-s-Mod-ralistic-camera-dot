-- drafakiller

CrosshairDot = CrosshairDot or {}

--------------------= Default values =--------------------

  CrosshairDot.Enabled = true
  CrosshairDot.OutlineEnabled = true
  CrosshairDot.Thirdperson = true
  CrosshairDot.Dynamic3D = true
  CrosshairDot.Size = 2
  CrosshairDot.DynamicAnglesEnabled = true
  CrosshairDot.DynamicDistanceEnabled = true
  CrosshairDot.DynamicShakeEnabled = true
  CrosshairDot.DynamicColorEnabled = false
  CrosshairDot.DynamicAnglesScale = 0.3
  CrosshairDot.DynamicShakeScale = 0.5
  CrosshairDot.DotColor = Color(255,255,255, 50)
  CrosshairDot.DynamicColor = Color(255,50,50, 50)
  CrosshairDot.OutlineColor = Color(0,0,0,0)
  
  ----------------------------------------------------------

RunConsoleCommand("crosshair", "0")

CrosshairDot.DrawDot = function(x, y, radius, quality, color)
  x = x or 0
  y = y or 0
  radius = radius or 3
  quality = quality or 50
  color = color or Color(255,255,255, 255)
  local circle = {}
  local temp = 0
  for i=1, quality do
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
CrosshairDot.ResetConvar = function(name)
  local convar = GetConVar(name)
  if convar then convar:SetString(convar:GetDefault()) end
end
CrosshairDot.LerpColor = function(t, from, to)
  return Color(
    Lerp(t, from.r, to.r),
    Lerp(t, from.g, to.g),
    Lerp(t, from.b, to.b),
    Lerp(t, from.a, to.a)
  )
end

hook.Add("HUDShouldDraw", "CrosshairDot_ShouldDraw", function(name)
  if CrosshairDot.Enabled and name == "CHudCrosshair" then return false end
end)

CrosshairDot.DynamicEyeAngles = EyeAngles()
CrosshairDot.SmoothColor = CrosshairDot.DotColor
CrosshairDot.SmoothSize = CrosshairDot.Size
hook.Add("HUDPaint", "CrosshairDot_HUD", function()
  local EyeTrace = LocalPlayer():GetEyeTrace()
  local dynamicAnglesDif = 1
  if CrosshairDot.DynamicAnglesEnabled then
    local angle = CrosshairDot.DynamicEyeAngles - EyeAngles()
    angle:Normalize()
    if angle ~= Angle() then
      local dif = math.abs(angle.p) + math.abs(angle.y) + math.abs(angle.r)
      dynamicAnglesDif = dif*(dif^-0.5)*CrosshairDot.DynamicAnglesScale + 1
    end
  end
  CrosshairDot.DynamicEyeAngles = EyeAngles()
  
  local dynamicDistance = 1
  if CrosshairDot.DynamicDistanceEnabled then
    if !LocalPlayer():InVehicle() then
      dynamicDistance = math.Clamp((EyeTrace.HitPos:Distance(EyePos())*1)^0.1 - 1, 0.1, 30)
    end
  end
  
  local dynamicShake = 1
  if CrosshairDot.DynamicShakeEnabled then
    local punchAngle = LocalPlayer():GetViewPunchAngles()
    dynamicShake = math.Clamp(math.abs(punchAngle.p) + math.abs(punchAngle.y) + math.abs(punchAngle.r) + 1, 0, 5)^CrosshairDot.DynamicShakeScale
  end
  
  if CrosshairDot.DynamicColorEnabled and IsValid(EyeTrace.Entity) and (EyeTrace.Entity:IsNPC() or EyeTrace.Entity:IsPlayer()) then
    CrosshairDot.SmoothColor = CrosshairDot.LerpColor(0.1, CrosshairDot.SmoothColor, CrosshairDot.DynamicColor)
  else
    CrosshairDot.SmoothColor = CrosshairDot.LerpColor(0.1, CrosshairDot.SmoothColor, CrosshairDot.DotColor)
  end
  
  if CrosshairDot.Enabled and !(!CrosshairDot.Thirdperson and LocalPlayer():EyePos() ~= EyePos()) then
    local ply = LocalPlayer()
    local weapon = ply:GetActiveWeapon()
    local pos = { x = 0, y = 0 }
    if CrosshairDot.Dynamic3D and EyeTrace.HitPos:Distance(EyePos()) > 0 then
      pos = EyeTrace.HitPos:ToScreen()
    else
      pos = { x = ScrW()/2, y = ScrH()/2 }
    end
    if IsValid(weapon) then
      CrosshairDot.SmoothSize = Lerp(0.1, CrosshairDot.SmoothSize, CrosshairDot.Size * dynamicAnglesDif * dynamicShake / dynamicDistance)
      CrosshairDot.DrawDot(pos.x, pos.y, CrosshairDot.SmoothSize, 50, CrosshairDot.SmoothColor)
      if CrosshairDot.OutlineEnabled then
        surface.DrawCircle(pos.x + 0.5, pos.y + 0.5, CrosshairDot.SmoothSize/2, CrosshairDot.OutlineColor)
      end
    end
  end
end)

CrosshairDot.Enabled = CreateClientConVar("crosshairdot_enabled", CrosshairDot.Enabled and 1 or 0):GetBool()
CrosshairDot.OutlineEnabled = CreateClientConVar("crosshairdot_enabled_outline", CrosshairDot.OutlineEnabled and 1 or 0):GetBool()
CrosshairDot.Thirdperson = CreateClientConVar("crosshairdot_thirdperson", CrosshairDot.Thirdperson and 1 or 0):GetBool()
CrosshairDot.Dynamic3D = CreateClientConVar("crosshairdot_dynamic3d", CrosshairDot.Dynamic3D and 1 or 0):GetBool()
CrosshairDot.DynamicAnglesEnabled = CreateClientConVar("crosshairdot_enabled_dynamic_angles", CrosshairDot.DynamicAnglesEnabled and 1 or 0):GetBool()
CrosshairDot.DynamicDistanceEnabled = CreateClientConVar("crosshairdot_enabled_dynamic_distance", CrosshairDot.DynamicDistanceEnabled and 1 or 0):GetBool()
CrosshairDot.DynamicShakeEnabled = CreateClientConVar("crosshairdot_enabled_dynamic_shake", CrosshairDot.DynamicShakeEnabled and 1 or 0):GetBool()
CrosshairDot.DynamicColorEnabled = CreateClientConVar("crosshairdot_enabled_dynamic_color", CrosshairDot.DynamicColorEnabled and 1 or 0):GetBool()
CrosshairDot.Size = CreateClientConVar("crosshairdot_size", CrosshairDot.Size):GetFloat()
CrosshairDot.DynamicAnglesScale = CreateClientConVar("crosshairdot_dynamic_angles_scale", CrosshairDot.DynamicAnglesScale):GetFloat()
CrosshairDot.DynamicShakeScale = CreateClientConVar("crosshairdot_dynamic_shake_scale", CrosshairDot.DynamicShakeScale):GetFloat()

CrosshairDot.DotColor.r = CreateClientConVar("crosshairdot_dotcolor_r", CrosshairDot.DotColor.r):GetInt()
CrosshairDot.DotColor.g = CreateClientConVar("crosshairdot_dotcolor_g", CrosshairDot.DotColor.g):GetInt()
CrosshairDot.DotColor.b = CreateClientConVar("crosshairdot_dotcolor_b", CrosshairDot.DotColor.b):GetInt()
CrosshairDot.DotColor.a = CreateClientConVar("crosshairdot_dotcolor_a", CrosshairDot.DotColor.a):GetInt()

CrosshairDot.DynamicColor.r = CreateClientConVar("crosshairdot_dynamiccolor_r", CrosshairDot.DynamicColor.r):GetInt()
CrosshairDot.DynamicColor.g = CreateClientConVar("crosshairdot_dynamiccolor_g", CrosshairDot.DynamicColor.g):GetInt()
CrosshairDot.DynamicColor.b = CreateClientConVar("crosshairdot_dynamiccolor_b", CrosshairDot.DynamicColor.b):GetInt()
CrosshairDot.DynamicColor.a = CreateClientConVar("crosshairdot_dynamiccolor_a", CrosshairDot.DynamicColor.a):GetInt()

CrosshairDot.OutlineColor.r = CreateClientConVar("crosshairdot_outlinecolor_r", CrosshairDot.OutlineColor.r):GetInt()
CrosshairDot.OutlineColor.g = CreateClientConVar("crosshairdot_outlinecolor_g", CrosshairDot.OutlineColor.g):GetInt()
CrosshairDot.OutlineColor.b = CreateClientConVar("crosshairdot_outlinecolor_b", CrosshairDot.OutlineColor.b):GetInt()
CrosshairDot.OutlineColor.a = CreateClientConVar("crosshairdot_outlinecolor_a", CrosshairDot.OutlineColor.a):GetInt()

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
  CrosshairDot.ResetConvar("crosshairdot_dynamic_angles_scale")
  CrosshairDot.ResetConvar("crosshairdot_dynamic_shake_scale")
  CrosshairDot.ResetConvar("crosshairdot_dotcolor_r")
  CrosshairDot.ResetConvar("crosshairdot_dotcolor_g")
  CrosshairDot.ResetConvar("crosshairdot_dotcolor_b")
  CrosshairDot.ResetConvar("crosshairdot_dotcolor_a")
  CrosshairDot.ResetConvar("crosshairdot_dynamiccolor_r")
  CrosshairDot.ResetConvar("crosshairdot_dynamiccolor_g")
  CrosshairDot.ResetConvar("crosshairdot_dynamiccolor_b")
  CrosshairDot.ResetConvar("crosshairdot_dynamiccolor_a")
  CrosshairDot.ResetConvar("crosshairdot_outlinecolor_r")
  CrosshairDot.ResetConvar("crosshairdot_outlinecolor_g")
  CrosshairDot.ResetConvar("crosshairdot_outlinecolor_b")
  CrosshairDot.ResetConvar("crosshairdot_outlinecolor_a")
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
cvars.AddChangeCallback("crosshairdot_dynamic_angles_scale", function(convar, oldValue, newValue)
  CrosshairDot.DynamicAnglesScale = math.Clamp(tonumber(newValue), -5, 5)
end)
cvars.AddChangeCallback("crosshairdot_dynamic_shake_scale", function(convar, oldValue, newValue)
  CrosshairDot.DynamicShakeScale = math.Clamp(tonumber(newValue), -3, 3)
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


hook.Add("PopulateToolMenu", "CrosshairDot_Settings", function()
	spawnmenu.AddToolMenuOption("Utilities", "User", "CrosshairDot", "Dynamic Crosshair Dot", "", "", function(panel)
		panel:ClearControls()
    panel:CheckBox("Enabled", "crosshairdot_enabled")
    panel:CheckBox("Outlined", "crosshairdot_enabled_outline")
    panel:CheckBox("Thirdperson", "crosshairdot_thirdperson")
		panel:NumSlider("Dot Size:", "crosshairdot_size", 0, 50)
    panel:Button("Reset to Default", "crosshairdot_reset")

    local DynamicList = vgui.Create("DForm")
    DynamicList:SetLabel("Dynamic Settings")
    DynamicList:DockMargin(-10, 10, -10, 0)
    DynamicList:DockPadding(0,0,0,10)
    DynamicList:SetExpanded(true)
    
    DynamicList:CheckBox("Dynamic 3D Dot", "crosshairdot_dynamic3d")
    DynamicList:CheckBox("Dynamic Angles", "crosshairdot_enabled_dynamic_angles")
    DynamicList:CheckBox("Dynamic Distance", "crosshairdot_enabled_dynamic_distance")
    DynamicList:CheckBox("Dynamic Shake", "crosshairdot_enabled_dynamic_shake")
		DynamicList:NumSlider("Dynamic Angles Scale:", "crosshairdot_dynamic_angles_scale", 0, 1)
		DynamicList:NumSlider("Dynamic Shake Scale:", "crosshairdot_dynamic_shake_scale", 0, 1)
    
    DynamicList:CheckBox("Dynamic Color:", "crosshairdot_enabled_dynamic_color")
    
    local DynamicColor = vgui.Create("DColorMixer")
    DynamicColor:SetConVarR("crosshairdot_dynamiccolor_r")
    DynamicColor:SetConVarG("crosshairdot_dynamiccolor_g")
    DynamicColor:SetConVarB("crosshairdot_dynamiccolor_b")
    DynamicColor:SetConVarA("crosshairdot_dynamiccolor_a")
    DynamicList:AddItem(DynamicColor)
    
    panel:AddItem(DynamicList)

    local ColorList = vgui.Create("DForm")
    ColorList:SetLabel("Color Settings")
    ColorList:DockMargin(-10, -5, -10, 0)
    ColorList:DockPadding(0,0,0,10)
    ColorList:SetExpanded(false)
    
    local DotColorLabel = vgui.Create("DLabel")
    DotColorLabel:SetText("Dot Color:")
    DotColorLabel:SetColor(Color(0,0,0, 255))
    ColorList:AddItem(DotColorLabel)
    
    local DotColor = vgui.Create("DColorMixer")
    DotColor:SetConVarR("crosshairdot_dotcolor_r")
    DotColor:SetConVarG("crosshairdot_dotcolor_g")
    DotColor:SetConVarB("crosshairdot_dotcolor_b")
    DotColor:SetConVarA("crosshairdot_dotcolor_a")
    ColorList:AddItem(DotColor)
    
    local OutlineColorLabel = vgui.Create("DLabel")
    OutlineColorLabel:SetText("Outline Color:")
    OutlineColorLabel:SetColor(Color(0,0,0, 255))
    ColorList:AddItem(OutlineColorLabel)
    
    local OutlineColor = vgui.Create("DColorMixer")
    OutlineColor:SetConVarR("crosshairdot_outlinecolor_r")
    OutlineColor:SetConVarG("crosshairdot_outlinecolor_g")
    OutlineColor:SetConVarB("crosshairdot_outlinecolor_b")
    OutlineColor:SetConVarA("crosshairdot_outlinecolor_a")
    ColorList:AddItem(OutlineColor)
    
    panel:AddItem(ColorList)
	end)
end)