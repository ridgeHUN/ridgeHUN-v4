local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local PlayerService = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")

local LocalPlayer = PlayerService.LocalPlayer
local Ping = Stats.Network.ServerStatsItem["Data Ping"]
local Aimbot,SilentAim = false,nil

local Window = Parvus.Utilities.UI:Window({
	Name = "hanoware — "..Parvus.Current,
	Position = UDim2.new(0.05,0,0.5,-248)
}) do Window:Watermark({Enabled = true})

	local AimAssistTab = Window:Tab({Name = "Combat"}) do
		local GlobalSection = AimAssistTab:Section({Name = "Global",Side = "Left"}) do
			GlobalSection:Toggle({Name = "Team Check",Flag = "TeamCheck",Value = false})
		end
		local AimbotSection = AimAssistTab:Section({Name = "Aimbot",Side = "Left"}) do
			AimbotSection:Toggle({Name = "Enabled",Flag = "Aimbot/Enabled",Value = false})
			AimbotSection:Toggle({Name = "Visibility Check",Flag = "Aimbot/WallCheck",Value = false})
			AimbotSection:Toggle({Name = "Dynamic FOV",Flag = "Aimbot/DynamicFoV",Value = false})
			AimbotSection:Keybind({Name = "Keybind",Flag = "Aimbot/Keybind",Value = "MouseButton2",Mouse = true,
				Callback = function(Key,KeyDown) Aimbot = Window.Flags["Aimbot/Enabled"] and KeyDown end})
			AimbotSection:Slider({Name = "Smoothness",Flag = "Aimbot/Smoothness",Min = 0,Max = 100,Value = 25,Unit = "%"})
			AimbotSection:Slider({Name = "Field of View",Flag = "Aimbot/FieldOfView",Min = 0,Max = 500,Value = 100})
			AimbotSection:Dropdown({Name = "Priority",Flag = "Aimbot/Priority",List = {
				{Name = "Head",Mode = "Toggle",Value = true},
				{Name = "HumanoidRootPart",Mode = "Toggle",Value = true}
			}})
			AimbotSection:Divider({Text = "Prediction"})
			AimbotSection:Toggle({Name = "Enabled",Flag = "Aimbot/Prediction/Enabled",Value = false})
			AimbotSection:Slider({Name = "Velocity",Flag = "Aimbot/Prediction/Velocity",Min = 100,Max = 5000,Value = 1600})
		end
		local AFoVSection = AimAssistTab:Section({Name = "Aimbot FOV Circle",Side = "Left"}) do
			AFoVSection:Toggle({Name = "Enabled",Flag = "Aimbot/Circle/Enabled",Value = true})
			AFoVSection:Toggle({Name = "Filled",Flag = "Aimbot/Circle/Filled",Value = false})
			AFoVSection:Colorpicker({Name = "Color",Flag = "Aimbot/Circle/Color",Value = {1,0.75,1,0.5,false}})
			AFoVSection:Slider({Name = "NumSides",Flag = "Aimbot/Circle/NumSides",Min = 3,Max = 100,Value = 100})
			AFoVSection:Slider({Name = "Thickness",Flag = "Aimbot/Circle/Thickness",Min = 1,Max = 10,Value = 1})
		end
		local TFoVSection = AimAssistTab:Section({Name = "Trigger FOV Circle",Side = "Left"}) do
			TFoVSection:Toggle({Name = "Enabled",Flag = "Trigger/Circle/Enabled",Value = true})
			TFoVSection:Toggle({Name = "Filled",Flag = "Trigger/Circle/Filled",Value = false})
			TFoVSection:Colorpicker({Name = "Color",Flag = "Trigger/Circle/Color",Value = {1,0.25,1,0.5,true}})
			TFoVSection:Slider({Name = "NumSides",Flag = "Trigger/Circle/NumSides",Min = 3,Max = 100,Value = 100})
			TFoVSection:Slider({Name = "Thickness",Flag = "Trigger/Circle/Thickness",Min = 1,Max = 10,Value = 1})
		end
		local TriggerSection = AimAssistTab:Section({Name = "Triggerbot",Side = "Right"}) do
			TriggerSection:Toggle({Name = "Enabled",Flag = "Trigger/Enabled",Value = false})
			TriggerSection:Toggle({Name = "Visibility Check",Flag = "Trigger/WallCheck",Value = true})
			TriggerSection:Toggle({Name = "Dynamic FOV",Flag = "Trigger/DynamicFoV",Value = false})
			TriggerSection:Slider({Name = "Field of View",Flag = "Trigger/FieldOfView",Min = 0,Max = 500,Value = 10})
			TriggerSection:Slider({Name = "Delay",Flag = "Trigger/Delay",Min = 0,Max = 1,Precise = 2,Value = 0.15})
			TriggerSection:Slider({Name = "Hold Time",Flag = "Trigger/HoldTime",Min = 0,Max = 1,Precise = 2,Value = 0})
			TriggerSection:Dropdown({Name = "Priority",Flag = "Trigger/Priority",List = {
				{Name = "Head",Mode = "Toggle",Value = true},
				{Name = "HumanoidRootPart",Mode = "Toggle",Value = true}
			}})
			TriggerSection:Divider({Text = "Prediction"})
			TriggerSection:Toggle({Name = "Enabled",Flag = "Trigger/Prediction/Enabled",Value = false})
			TriggerSection:Slider({Name = "Velocity",Flag = "Trigger/Prediction/Velocity",Min = 100,Max = 5000,Value = 1600})
		end
	end
	local VisualsTab = Window:Tab({Name = "Visuals"}) do
		local GlobalSection = VisualsTab:Section({Name = "Global",Side = "Left"}) do
			GlobalSection:Colorpicker({Name = "Ally Color",Flag = "ESP/Player/Ally",Value = {0.33333334326744,0.75,1,0,false}})
			GlobalSection:Colorpicker({Name = "Enemy Color",Flag = "ESP/Player/Enemy",Value = {1,0.75,1,0,false}})
			GlobalSection:Toggle({Name = "Team Check",Flag = "ESP/Player/TeamCheck",Value = false})
			GlobalSection:Toggle({Name = "Use Team Color",Flag = "ESP/Player/TeamColor",Value = false})
		end
		local BoxSection = VisualsTab:Section({Name = "Boxes",Side = "Left"}) do
			BoxSection:Toggle({Name = "Enabled",Flag = "ESP/Player/Box/Enabled",Value = false})
			BoxSection:Toggle({Name = "Filled",Flag = "ESP/Player/Box/Filled",Value = false})
			BoxSection:Toggle({Name = "Outline",Flag = "ESP/Player/Box/Outline",Value = true})
			BoxSection:Slider({Name = "Thickness",Flag = "ESP/Player/Box/Thickness",Min = 1,Max = 10,Value = 1})
			BoxSection:Slider({Name = "Transparency",Flag = "ESP/Player/Box/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
			BoxSection:Divider({Text = "Text / Info"})
			BoxSection:Toggle({Name = "Enabled",Flag = "ESP/Player/Text/Enabled",Value = false})
			BoxSection:Toggle({Name = "Outline",Flag = "ESP/Player/Text/Outline",Value = true})
			BoxSection:Toggle({Name = "Autoscale",Flag = "ESP/Player/Text/Autoscale",Value = true})
			BoxSection:Dropdown({Name = "Font",Flag = "ESP/Player/Text/Font",List = {
				{Name = "UI",Mode = "Button"},
				{Name = "System",Mode = "Button"},
				{Name = "Plex",Mode = "Button"},
				{Name = "Monospace",Mode = "Button",Value = true}
			}})
			BoxSection:Slider({Name = "Size",Flag = "ESP/Player/Text/Size",Min = 13,Max = 100,Value = 16})
			BoxSection:Slider({Name = "Transparency",Flag = "ESP/Player/Text/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
		end
		local OoVSection = VisualsTab:Section({Name = "Offscreen Arrows",Side = "Left"}) do
			OoVSection:Toggle({Name = "Enabled",Flag = "ESP/Player/Arrow/Enabled",Value = false})
			OoVSection:Toggle({Name = "Filled",Flag = "ESP/Player/Arrow/Filled",Value = true})
			OoVSection:Slider({Name = "Width",Flag = "ESP/Player/Arrow/Width",Min = 14,Max = 28,Value = 18})
			OoVSection:Slider({Name = "Height",Flag = "ESP/Player/Arrow/Height",Min = 14,Max = 28,Value = 28})
			OoVSection:Slider({Name = "Distance From Center",Flag = "ESP/Player/Arrow/Distance",Min = 80,Max = 200,Value = 200})
			OoVSection:Slider({Name = "Thickness",Flag = "ESP/Player/Arrow/Thickness",Min = 1,Max = 10,Value = 1})
			OoVSection:Slider({Name = "Transparency",Flag = "ESP/Player/Arrow/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
		end
		local HeadSection = VisualsTab:Section({Name = "Head Circles",Side = "Right"}) do
			HeadSection:Toggle({Name = "Enabled",Flag = "ESP/Player/Head/Enabled",Value = false})
			HeadSection:Toggle({Name = "Filled",Flag = "ESP/Player/Head/Filled",Value = true})
			HeadSection:Toggle({Name = "Autoscale",Flag = "ESP/Player/Head/Autoscale",Value = true})
			HeadSection:Slider({Name = "Radius",Flag = "ESP/Player/Head/Radius",Min = 1,Max = 10,Value = 8})
			HeadSection:Slider({Name = "NumSides",Flag = "ESP/Player/Head/NumSides",Min = 3,Max = 100,Value = 4})
			HeadSection:Slider({Name = "Thickness",Flag = "ESP/Player/Head/Thickness",Min = 1,Max = 10,Value = 1})
			HeadSection:Slider({Name = "Transparency",Flag = "ESP/Player/Head/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
		end
		local TracerSection = VisualsTab:Section({Name = "Tracers",Side = "Right"}) do
			TracerSection:Toggle({Name = "Enabled",Flag = "ESP/Player/Tracer/Enabled",Value = false})
			TracerSection:Dropdown({Name = "Mode",Flag = "ESP/Player/Tracer/Mode",List = {
				{Name = "From Bottom",Mode = "Button",Value = true},
				{Name = "From Mouse",Mode = "Button"}
			}})
			TracerSection:Slider({Name = "Thickness",Flag = "ESP/Player/Tracer/Thickness",Min = 1,Max = 10,Value = 1})
			TracerSection:Slider({Name = "Transparency",Flag = "ESP/Player/Tracer/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
		end
		local HighlightSection = VisualsTab:Section({Name = "Highlights",Side = "Right"}) do
			HighlightSection:Toggle({Name = "Enabled",Flag = "ESP/Player/Highlight/Enabled",Value = false})
			HighlightSection:Slider({Name = "Transparency",Flag = "ESP/Player/Highlight/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
			HighlightSection:Colorpicker({Name = "Outline Color",Flag = "ESP/Player/Highlight/OutlineColor",Value = {1,1,0,0.5,false}})
		end
		
		local MiscTab = Window:Tab({Name = "Miscellaneous"}) do -- was here
			local MiscSection = MiscTab:Section({Name = "Quick Execution",Side = "Left"}) do
				MiscSection:Button({Name = "Infinite Yield",Side = "Left",Callback = function()
					loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
				end})

				local GunModsSection = MiscTab:Section({Name = "Gun Modifications",Side = "Left"}) do
					GunModsSection:Button({Name = "Unlimited Ammo",Side = "Left",Callback = function()
						local Player = game:GetService("Players").LocalPlayer
						local mag = require(game:GetService("ReplicatedStorage").Modules.Gun).get(Player.Character:FindFirstChildOfClass("Tool"));

						--mag.Clip = mag.Clip + 300
						mag.MagazineBullets = mag.MagazineBullets + 999
					end})

					local VehicleModsSection = MiscTab:Section({Name = "Vehicle Modifications",Side = "Right"}) do
						VehicleModsSection:Button({Name = "Vehicle Acceleration",Side = "Left",Callback = function()
							for i, v in pairs(workspace.CarStorage:GetChildren()) do
								v.Cosmetics.Essentials.SpeedScalar.Value = 9999999999999999999999999999999
							end
						end})

        --[[local LightingSection = VisualsTab:Section({Name = "Lighting",Side = "Right"}) do
            LightingSection:Toggle({Name = "Enabled",Flag = "Lighting/Enabled",Value = false})
            LightingSection:Colorpicker({Name = "Ambient",Flag = "Lighting/Ambient",Value = {1,0,0,0,false}})
            LightingSection:Slider({Name = "Brightness",Flag = "Lighting/Brightness",Min = 0,Max = 10,Precise = 2,Value = 3})
            LightingSection:Slider({Name = "ClockTime",Flag = "Lighting/ClockTime",Min = 0,Max = 24,Precise = 2,Value = 14.5})
            LightingSection:Colorpicker({Name = "ColorShift_Bottom",Flag = "Lighting/ColorShift_Bottom",Value = {1,0,0,0,false}})
            LightingSection:Colorpicker({Name = "ColorShift_Top",Flag = "Lighting/ColorShift_Top",Value = {1,0,0,0,false}})
            LightingSection:Slider({Name = "EnvironmentDiffuseScale",Flag = "Lighting/EnvironmentDiffuseScale",Min = 0,Max = 1,Precise = 3,Value = 1})
            LightingSection:Slider({Name = "EnvironmentSpecularScale",Flag = "Lighting/EnvironmentSpecularScale",Min = 0,Max = 1,Precise = 3,Value = 1})
            LightingSection:Slider({Name = "ExposureCompensation",Flag = "Lighting/ExposureCompensation",Min = -3,Max = 3,Precise = 2,Value = 0})
            LightingSection:Colorpicker({Name = "FogColor",Flag = "Lighting/FogColor",Value = {1,0,1,0,false}})
            LightingSection:Slider({Name = "FogEnd",Flag = "Lighting/FogEnd",Min = 0,Max = 100000,Value = 100000})
            LightingSection:Slider({Name = "FogStart",Flag = "Lighting/FogStart",Min = 0,Max = 100000,Value = 0})
            LightingSection:Slider({Name = "GeographicLatitude",Flag = "Lighting/GeographicLatitude",Min = 0,Max = 360,Precise = 1,Value = 23.5})
            LightingSection:Toggle({Name = "GlobalShadows",Flag = "Lighting/GlobalShadows",Value = true})
            LightingSection:Colorpicker({Name = "OutdoorAmbient",Flag = "Lighting/OutdoorAmbient",Value = {1,0,0,0,false}})
            LightingSection:Slider({Name = "ShadowSoftness",Flag = "Lighting/ShadowSoftness",Min = 0,Max = 1,Precise = 2,Value = 1})
        end]]
	end
	local SettingsTab = Window:Tab({Name = "Settings"}) do
		local MenuSection = SettingsTab:Section({Name = "Menu",Side = "Left"}) do
			local MenuToggle = MenuSection:Toggle({Name = "Enabled",IgnoreFlag = true,Value = Window.Enabled,
				Callback = function(Bool)
					Window:Toggle(Bool)
				end}):Keybind({Value = "RightShift",Flag = "UI/Keybind",DoNotClear = true})
			MenuSection:Toggle({Name = "Watermark",Flag = "UI/Watermark",Value = true,
				Callback = function(Bool)
					Window.Watermark:Toggle(Bool)
				end})
			MenuSection:Toggle({Name = "Custom Mouse",Flag = "Mouse/Enabled",Value = false})
			MenuSection:Colorpicker({Name = "Color",Flag = "UI/Color",Value = {1,0.25,1,0,true},
			Callback = function(HSVAR,Color)
				Window:SetColor(Color)
			end})
		end
		SettingsTab:AddConfigSection("Left")
		SettingsTab:Button({Name = "Rejoin",Side = "Left",
			Callback = Parvus.Utilities.Misc.ReJoin})
		SettingsTab:Button({Name = "Server Hop",Side = "Left",
			Callback = Parvus.Utilities.Misc.ServerHop})
		local BackgroundSection = SettingsTab:Section({Name = "Background",Side = "Right"}) do
			BackgroundSection:Dropdown({Name = "Image",Flag = "Background/Image",List = {
				{Name = "Legacy",Mode = "Button",Callback = function()
					Window.Background.Image = "rbxassetid://2151741365"
					Window.Flags["Background/CustomImage"] = ""
				end},
				{Name = "Hearts",Mode = "Button",Callback = function()
					Window.Background.Image = "rbxassetid://6073763717"
					Window.Flags["Background/CustomImage"] = ""
				end},
				{Name = "Abstract",Mode = "Button",Callback = function()
					Window.Background.Image = "rbxassetid://6073743871"
					Window.Flags["Background/CustomImage"] = ""
				end},
				{Name = "Hexagon",Mode = "Button",Callback = function()
					Window.Background.Image = "rbxassetid://6073628839"
					Window.Flags["Background/CustomImage"] = ""
				end},
				{Name = "Circles",Mode = "Button",Callback = function()
					Window.Background.Image = "rbxassetid://6071579801"
					Window.Flags["Background/CustomImage"] = ""
				end},
				{Name = "Lace With Flowers",Mode = "Button",Callback = function()
					Window.Background.Image = "rbxassetid://6071575925"
					Window.Flags["Background/CustomImage"] = ""
				end},
				{Name = "Floral",Mode = "Button",Value = true,Callback = function()
					Window.Background.Image = "rbxassetid://5553946656"
					Window.Flags["Background/CustomImage"] = ""
				end}
			}})
			BackgroundSection:Textbox({Name = "Custom Image",Flag = "Background/CustomImage",Placeholder = "ImageId",
				Callback = function(String)
					if string.gsub(String," ","") ~= "" then
						Window.Background.Image = "rbxassetid://" .. String
					end
				end})
			BackgroundSection:Colorpicker({Name = "Color",Flag = "Background/Color",Value = {1,1,0,0,false},
			Callback = function(HSVAR,Color)
				Window.Background.ImageColor3 = Color
				Window.Background.ImageTransparency = HSVAR[4]
			end})
			BackgroundSection:Slider({Name = "Tile Offset",Flag = "Background/Offset",Min = 74, Max = 296,Value = 74,
				Callback = function(Number)
					Window.Background.TileSize = UDim2.new(0,Number,0,Number)
				end})
		end
		local CrosshairSection = SettingsTab:Section({Name = "Custom Crosshair",Side = "Right"}) do
			CrosshairSection:Toggle({Name = "Enabled",Flag = "Mouse/Crosshair/Enabled",Value = false})
			CrosshairSection:Colorpicker({Name = "Color",Flag = "Mouse/Crosshair/Color",Value = {1,1,1,0,false}})
			CrosshairSection:Slider({Name = "Size",Flag = "Mouse/Crosshair/Size",Min = 0,Max = 20,Value = 4})
			CrosshairSection:Slider({Name = "Gap",Flag = "Mouse/Crosshair/Gap",Min = 0,Max = 10,Value = 2})
		end
		local CreditsSection = SettingsTab:Section({Name = "Credits",Side = "Right"}) do
			CreditsSection:Label({Text = "hanoware is fake..."})
			CreditsSection:Divider()
			CreditsSection:Label({Text = "hano has no involvement stg"})
		end
	end
end

Window:LoadDefaultConfig()
local GetFPS = Parvus.Utilities.Misc:SetupFPS()
Parvus.Utilities.Drawing:Cursor(Window.Flags)
Parvus.Utilities.Drawing:FoVCircle("Aimbot",Window.Flags)
Parvus.Utilities.Drawing:FoVCircle("Trigger",Window.Flags)
Parvus.Utilities.Drawing:FoVCircle("SilentAim",Window.Flags)
--[[local DefaultLighting = {
    Ambient = Lighting.Ambient,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    ColorShift_Bottom = Lighting.ColorShift_Bottom,
    ColorShift_Top = Lighting.ColorShift_Top,
    EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
    EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
    ExposureCompensation = Lighting.ExposureCompensation,
    FogColor = Lighting.FogColor,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    GeographicLatitude = Lighting.GeographicLatitude,
    GlobalShadows = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ShadowSoftness = Lighting.ShadowSoftness
}]]

local function TeamCheck(Enabled,Player)
	if not Enabled then return true end
	return LocalPlayer.Team ~= Player.Team
end

local function WallCheck(Enabled,Hitbox,Character)
	if not Enabled then return true end
	local Camera = Workspace.CurrentCamera
	return not Camera:GetPartsObscuringTarget({Hitbox.Position},{
		LocalPlayer.Character,
		Character
	})[1]
end

local function GetHitbox(Config)
	if not Config.Enabled then return end
	local Camera = Workspace.CurrentCamera

	local FieldOfView,ClosestHitbox = Config.DynamicFoV and
		((120 - Camera.FieldOfView) * 4) + Config.FieldOfView
		or Config.FieldOfView,nil

	for Index, Player in pairs(PlayerService:GetPlayers()) do
		local Character = Player.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		local IsAlive = Humanoid and Humanoid.Health > 0
		if Player ~= LocalPlayer and IsAlive and TeamCheck(Config.TeamCheck,Player) then
			for Index, HumanoidPart in pairs(Config.Priority) do
				local Hitbox = Character and Character:FindFirstChild(HumanoidPart)
				if Hitbox then
					local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Hitbox.Position)
					local Magnitude = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
					if OnScreen and Magnitude < FieldOfView and WallCheck(Config.WallCheck,Hitbox,Character) then
						FieldOfView = Magnitude
						ClosestHitbox = Hitbox
					end
				end
			end
		end
	end

	return ClosestHitbox
end

local function Trigger(Config)
	if not Config.Enabled then return end
	local Camera = Workspace.CurrentCamera

	local FieldOfView,ClosestHitbox = Config.DynamicFoV and
		((120 - Camera.FieldOfView) * 4) + Config.FieldOfView
		or Config.FieldOfView,nil

	for Index, Player in pairs(PlayerService:GetPlayers()) do
		local Character = Player.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		local IsAlive = Humanoid and Humanoid.Health > 0
		if Player ~= LocalPlayer and IsAlive and TeamCheck(Config.TeamCheck,Player) then
			for Index, HumanoidPart in pairs(Config.Priority) do
				local Hitbox = Character and Character:FindFirstChild(HumanoidPart)
				if Hitbox then
					local HitboxDistance = (Hitbox.Position - Camera.CFrame.Position).Magnitude
					local HitboxVelocityCorrection = (Hitbox.AssemblyLinearVelocity * HitboxDistance) / Config.Prediction.Velocity

					local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Config.Prediction.Enabled
						and Hitbox.Position + HitboxVelocityCorrection or Hitbox.Position)
					local Magnitude = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
					if OnScreen and Magnitude < FieldOfView and WallCheck(Config.WallCheck,Hitbox,Character) then
						FieldOfView = Magnitude
						ClosestHitbox = Hitbox
					end
				end
			end
		end
	end

	if ClosestHitbox then
		task.wait(Config.Delay)
		mouse1press()
		task.wait(Config.HoldTime)
		mouse1release()
	end
end

local function AimAt(Hitbox,Config)
	if not Hitbox then return end
	local Camera = Workspace.CurrentCamera
	local Mouse = UserInputService:GetMouseLocation()

	local HitboxDistance = (Hitbox.Position - Camera.CFrame.Position).Magnitude
	local HitboxVelocityCorrection = (Hitbox.AssemblyLinearVelocity * HitboxDistance) / Config.Prediction.Velocity

	local HitboxOnScreen = Camera:WorldToViewportPoint(Config.Prediction.Enabled
		and Hitbox.Position + HitboxVelocityCorrection or Hitbox.Position)
	mousemoverel(
		(HitboxOnScreen.X - Mouse.X) * Config.Sensitivity,
		(HitboxOnScreen.Y - Mouse.Y) * Config.Sensitivity
	)
end

local __namecall
__namecall = hookmetamethod(game,"__namecall",function(self,...)
	local args = {...}
	if SilentAim then
		local Camera = Workspace.CurrentCamera
		local HitChance = math.random(0,100) <= Window.Flags["SilentAim/HitChance"]
		if getnamecallmethod() == "Raycast" and HitChance then
			args[2] = SilentAim.Position - Camera.CFrame.Position
		elseif getnamecallmethod() == "FindPartOnRayWithIgnoreList" and HitChance then
			args[1] = Ray.new(args[1].Origin,SilentAim.Position - Camera.CFrame.Position)
		end
	end
	return __namecall(self, unpack(args))
end)

--[[local __newindex
__newindex = hookmetamethod(game,"__newindex",function(self,index,value)
    if checkcaller() then return __newindex(self,index,value) end
    if self == Lighting and Window.Flags["Lighting/"..index] then
        DefaultLighting[index] = value
    end
    return __newindex(self,index,value)
end)]]

RunService.Heartbeat:Connect(function()
	SilentAim = GetHitbox({
		Enabled = Window.Flags["SilentAim/Enabled"],
		WallCheck = Window.Flags["SilentAim/WallCheck"],
		DynamicFoV = Window.Flags["SilentAim/DynamicFoV"],
		FieldOfView = Window.Flags["SilentAim/FieldOfView"],
		Priority = Window.Flags["SilentAim/Priority"],
		TeamCheck = Window.Flags["TeamCheck"]
	})
	if Aimbot then AimAt(
		GetHitbox({
			Enabled = Window.Flags["Aimbot/Enabled"],
			WallCheck = Window.Flags["Aimbot/WallCheck"],
			DynamicFoV = Window.Flags["Aimbot/DynamicFoV"],
			FieldOfView = Window.Flags["Aimbot/FieldOfView"],
			Priority = Window.Flags["Aimbot/Priority"],
			TeamCheck = Window.Flags["TeamCheck"]
		}),{
			Prediction = {
				Enabled = Window.Flags["Aimbot/Prediction/Enabled"],
				Velocity = Window.Flags["Aimbot/Prediction/Velocity"]
			},
			Sensitivity = Window.Flags["Aimbot/Smoothness"] / 100
		})
	end

	if Window.Flags["UI/Watermark"] then
		Window.Watermark:SetTitle(string.format(
			"Parvus Hub    %s    %i FPS    %i MS",
			os.date("%X"),GetFPS(),math.round(Ping:GetValue())
			))
	end
    --[[for Property,Value in pairs(DefaultLighting) do
        Lighting[Property] = Window.Flags["Lighting/Enabled"] and
        Parvus.Utilities.UI:TableToColor(Window.Flags["Lighting/"..Property])
        or Value
    end]]
end)
Parvus.Utilities.Misc:NewThreadLoop(0,function()
	Trigger({
		Enabled = Window.Flags["Trigger/Enabled"],
		WallCheck = Window.Flags["Trigger/WallCheck"],
		Prediction = {
			Enabled = Window.Flags["Trigger/Prediction/Enabled"],
			Velocity = Window.Flags["Trigger/Prediction/Velocity"]
		},
		DynamicFoV = Window.Flags["Trigger/DynamicFoV"],
		FieldOfView = Window.Flags["Trigger/FieldOfView"],
		Priority = Window.Flags["Trigger/Priority"],
		HoldTime = Window.Flags["Trigger/HoldTime"],
		Delay = Window.Flags["Trigger/Delay"]
	})
end)

for Index,Player in pairs(PlayerService:GetPlayers()) do
	if Player ~= LocalPlayer then
		Parvus.Utilities.Drawing:AddESP(Player,"Player","ESP/Player",Window.Flags)
	end
end
PlayerService.PlayerAdded:Connect(function(Player)
	Parvus.Utilities.Drawing:AddESP(Player,"Player","ESP/Player",Window.Flags)
end)
PlayerService.PlayerRemoving:Connect(function(Player)
	Parvus.Utilities.Drawing:RemoveESP(Player)
end)
