local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local PlayerService = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")

local LocalPlayer = PlayerService.LocalPlayer
local Aimbot, SilentAim
	= false, nil

Parvus.Config = Parvus.Utilities.Config:ReadJSON(Parvus.Current, {
	PlayerESP = {
		AllyColor = {0.3333333432674408,1,1,0,false},
		EnemyColor = {1,1,1,0,false},

		TeamColor = false,
		TeamCheck = false,
		Highlight = {
			Enabled = false,
			Transparency = 0.5,
			OutlineColor = {0,0,0,0.5,false}
		},
		Box = {
			Enabled = false,
			Outline = true,
			Filled = false,
			Thickness = 1,
			Transparency = 1,
			Info = {
				Enabled = false,
				AutoScale = true,
				Transparency = 1,
				Size = 16
			}
		},
		Other = {
			Head = {
				Enabled = false,
				AutoScale = true,
				Filled = true,
				Radius = 8,
				NumSides = 4,
				Thickness = 1,
				Transparency = 1
			},
			Tracer = {
				Enabled = false,
				Thickness = 1,
				Transparency = 1,
				From = "ScreenBottom"
			},
			Arrow = {
				Enabled = false,
				Filled = true,
				Width = 16,
				Height = 16,
				Thickness = 1,
				Transparency = 1,
				DistanceFromCenter = 80
			}
		}
	},
	AimAssist = {
		TeamCheck = false,
		SilentAim = {
			Enabled = false,
			WallCheck = false,
			DynamicFoV = false,
			HitChance = 100,
			FieldOfView = 50,
			Priority = {"Head"},
			Circle = {
				Visible = true,
				Transparency = 0.5,
				Color = {0.6666666865348816,1,1,0.5,false},
				Thickness = 1,
				NumSides = 100,
				Filled = false
			}
		},
			Aimbot = {
				Enabled = false,
				WallCheck = false,
				DynamicFoV = false,
				Sensitivity = 0.25,
				FieldOfView = 100,
				Priority = {"Head","HumanoidRootPart"},
				Prediction = {
					Enabled = false,
					Velocity = 2000,
				},
				Circle = {
					Visible = true,
					Transparency = 0.5,
					Color = {1,1,1,0.5,false},
					Thickness = 1,
					NumSides = 100,
					Filled = false
				}
			}
		},
		UI = {
			Enabled = true,
			Keybind = "RightShift",
			Color = {0.8333333134651184,0.5,0.5,0,false},
			TileSize = 74,
			Watermark = true,
			Background = "Floral",
			BackgroundId = "rbxassetid://5553946656",
			BackgroundColor = {1,0,0,0,false},
			BackgroundTransparency = 0,
			Cursor = {
				Enabled = false,
				Length = 16,
				Width = 11,

				Crosshair = {
					Enabled = false,
					Color = {1,1,1,0,false},
					Size = 4,
					Gap = 2,
				}
			}
		},
		Binds = {
			Aimbot = "MouseButton2",
			SilentAim = "NONE"
		}
	})

local GetFPS = Parvus.Utilities.SetupFPS()
Parvus.Utilities.Drawing:Cursor(Parvus.Config.UI.Cursor)
Parvus.Utilities.Drawing:FoVCircle(Parvus.Config.AimAssist.Aimbot)
Parvus.Utilities.Drawing:FoVCircle(Parvus.Config.AimAssist.SilentAim)
local Window = Parvus.Utilities.UI:Window({Name = "ridgeHUN v4.0 — " .. Parvus.Current,Enabled = Parvus.Config.UI.Enabled,
	Color = Parvus.Utilities.Config:TableToColor(Parvus.Config.UI.Color),Position = UDim2.new(0.2,-248,0.5,-248)}) do
	local AimAssistTab = Window:Tab({Name = "Combat"}) do
		local AimbotSection = AimAssistTab:Section({Name = "Aimbot",Side = "Left"}) do
			AimbotSection:Toggle({Name = "Enabled",Value = Parvus.Config.AimAssist.Aimbot.Enabled,Callback = function(Bool)
				Parvus.Config.AimAssist.Aimbot.Enabled = Bool
			end})
			AimbotSection:Toggle({Name = "Visibility Check",Value = Parvus.Config.AimAssist.Aimbot.WallCheck,Callback = function(Bool)
				Parvus.Config.AimAssist.Aimbot.WallCheck = Bool
			end})
			AimbotSection:Toggle({Name = "Dynamic FOV",Value = Parvus.Config.AimAssist.Aimbot.DynamicFoV,Callback = function(Bool)
				Parvus.Config.AimAssist.Aimbot.DynamicFoV = Bool
			end})
			AimbotSection:Keybind({Name = "Keybind",Key = Parvus.Config.Binds.Aimbot,Mouse = true,Callback = function(Bool,Key)
				Parvus.Config.Binds.Aimbot = Key or "NONE"
				Aimbot = Parvus.Config.AimAssist.Aimbot.Enabled and Bool
			end})
			AimbotSection:Slider({Name = "Smoothness",Min = 0,Max = 100,Value = Parvus.Config.AimAssist.Aimbot.Sensitivity * 100,Unit = "%",Callback = function(Number)
				Parvus.Config.AimAssist.Aimbot.Sensitivity = Number / 100
			end})
			AimbotSection:Slider({Name = "Field of View",Min = 0,Max = 500,Value = Parvus.Config.AimAssist.Aimbot.FieldOfView,Callback = function(Number)
				Parvus.Config.AimAssist.Aimbot.FieldOfView = Number
			end})
			AimbotSection:Dropdown({Name = "Priority",Default = Parvus.Config.AimAssist.Aimbot.Priority,List = {
				{Name = "Head",Mode = "Toggle",Callback = function(Selected)
					Parvus.Config.AimAssist.Aimbot.Priority = Selected
				end},
				{Name = "HumanoidRootPart",Mode = "Toggle",Callback = function(Selected)
					Parvus.Config.AimAssist.Aimbot.Priority = Selected
				end}
			}})
			AimbotSection:Divider({Text = "Prediction"})
			AimbotSection:Toggle({Name = "Enabled",Value = Parvus.Config.AimAssist.Aimbot.Prediction.Enabled,Callback = function(Bool)
				Parvus.Config.AimAssist.Aimbot.Prediction.Enabled = Bool
			end})
			AimbotSection:Slider({Name = "Velocity",Min = 100,Max = 5000,Value = Parvus.Config.AimAssist.Aimbot.Prediction.Velocity,Callback = function(Number)
				Parvus.Config.AimAssist.Aimbot.Prediction.Velocity = Number
			end})
		end
		local AFoVSection = AimAssistTab:Section({Name = "Aimbot FOV Circle",Side = "Left"}) do
			AFoVSection:Toggle({Name = "Enabled",Value = Parvus.Config.AimAssist.Aimbot.Circle.Visible,Callback = function(Bool)
				Parvus.Config.AimAssist.Aimbot.Circle.Visible = Bool
			end})
			AFoVSection:Toggle({Name = "Filled",Value = Parvus.Config.AimAssist.Aimbot.Circle.Filled,Callback = function(Bool)
				Parvus.Config.AimAssist.Aimbot.Circle.Filled = Bool
			end})
			AFoVSection:Colorpicker({Name = "Color",HSVAR = Parvus.Config.AimAssist.Aimbot.Circle.Color,Callback = function(HSVAR)
				Parvus.Config.AimAssist.Aimbot.Circle.Color = HSVAR
			end})
			AFoVSection:Slider({Name = "NumSides",Min = 3,Max = 100,Value = Parvus.Config.AimAssist.Aimbot.Circle.NumSides,Callback = function(Number)
				Parvus.Config.AimAssist.Aimbot.Circle.NumSides = Number
			end})
			AFoVSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = Parvus.Config.AimAssist.Aimbot.Circle.Thickness,Callback = function(Number)
				Parvus.Config.AimAssist.Aimbot.Circle.Thickness = Number
			end})
		end
		local SilentAimSection = AimAssistTab:Section({Name = "Silent Aim",Side = "Right"}) do
			SilentAimSection:Toggle({Name = "Enabled",Value = Parvus.Config.AimAssist.SilentAim.Enabled,Callback = function(Bool)
				Parvus.Config.AimAssist.SilentAim.Enabled = Bool
			end}):Keybind({Key = Parvus.Config.Binds.SilentAim,Mouse = true,Callback = function(Bool,Key)
				Parvus.Config.Binds.SilentAim = Key or "NONE"
			end})
			SilentAimSection:Toggle({Name = "Visibility Check",Value = Parvus.Config.AimAssist.SilentAim.WallCheck,Callback = function(Bool)
				Parvus.Config.AimAssist.SilentAim.WallCheck = Bool
			end})
			SilentAimSection:Toggle({Name = "Dynamic FOV",Value = Parvus.Config.AimAssist.SilentAim.DynamicFoV,Callback = function(Bool)
				Parvus.Config.AimAssist.SilentAim.DynamicFoV = Bool
			end})
			SilentAimSection:Slider({Name = "Hit Chance",Min = 0,Max = 100,Value = Parvus.Config.AimAssist.SilentAim.HitChance,Unit = "%",Callback = function(Number)
				Parvus.Config.AimAssist.SilentAim.HitChance = Number
			end})
			SilentAimSection:Slider({Name = "Field of View",Min = 0,Max = 500,Value = Parvus.Config.AimAssist.SilentAim.FieldOfView,Callback = function(Number)
				Parvus.Config.AimAssist.SilentAim.FieldOfView = Number
			end})
			SilentAimSection:Dropdown({Name = "Priority",Default = Parvus.Config.AimAssist.SilentAim.Priority,List = {
				{Name = "Head",Mode = "Toggle",Callback = function(Selected)
					Parvus.Config.AimAssist.SilentAim.Priority = Selected
				end},
				{Name = "HumanoidRootPart",Mode = "Toggle",Callback = function(Selected)
					Parvus.Config.AimAssist.SilentAim.Priority = Selected
				end}
			}})
		end
		local SAFoVSection = AimAssistTab:Section({Name = "Silent Aim FOV Circle",Side = "Right"}) do
			SAFoVSection:Toggle({Name = "Enabled",Value = Parvus.Config.AimAssist.SilentAim.Circle.Visible,Callback = function(Bool)
				Parvus.Config.AimAssist.SilentAim.Circle.Visible = Bool
			end})
			SAFoVSection:Toggle({Name = "Filled",Value = Parvus.Config.AimAssist.SilentAim.Circle.Filled,Callback = function(Bool)
				Parvus.Config.AimAssist.SilentAim.Circle.Filled = Bool
			end})
			SAFoVSection:Colorpicker({Name = "Color",HSVAR = Parvus.Config.AimAssist.SilentAim.Circle.Color,Callback = function(HSVAR)
				Parvus.Config.AimAssist.SilentAim.Circle.Color = HSVAR
			end})
			SAFoVSection:Slider({Name = "NumSides",Min = 3,Max = 100,Value = Parvus.Config.AimAssist.SilentAim.Circle.NumSides,Callback = function(Number)
				Parvus.Config.AimAssist.SilentAim.Circle.NumSides = Number
			end})
			SAFoVSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = Parvus.Config.AimAssist.SilentAim.Circle.Thickness,Callback = function(Number)
				Parvus.Config.AimAssist.SilentAim.Circle.Thickness = Number
			end})
		end
	end
	local VisualsTab = Window:Tab({Name = "Visuals"}) do
		local GlobalSection = VisualsTab:Section({Name = "Global",Side = "Left"}) do
			GlobalSection:Colorpicker({Name = "Ally Color",HSVAR = Parvus.Config.PlayerESP.AllyColor,Callback = function(HSVAR)
				Parvus.Config.PlayerESP.AllyColor = HSVAR
			end})
			GlobalSection:Colorpicker({Name = "Enemy Color",HSVAR = Parvus.Config.PlayerESP.EnemyColor,Callback = function(HSVAR)
				Parvus.Config.PlayerESP.EnemyColor = HSVAR
			end})
			GlobalSection:Toggle({Name = "Team Check",Value = Parvus.Config.PlayerESP.TeamCheck,Callback = function(Bool)
				Parvus.Config.PlayerESP.TeamCheck = Bool
			end})
			GlobalSection:Toggle({Name = "Use Team Color",Value = Parvus.Config.PlayerESP.TeamColor,Callback = function(Bool)
				Parvus.Config.PlayerESP.TeamColor = Bool
			end})
		end
		local BoxSection = VisualsTab:Section({Name = "Boxes",Side = "Left"}) do
			BoxSection:Toggle({Name = "Enabled",Value = Parvus.Config.PlayerESP.Box.Enabled,Callback = function(Bool)
				Parvus.Config.PlayerESP.Box.Enabled = Bool
			end})
			BoxSection:Toggle({Name = "Filled",Value = Parvus.Config.PlayerESP.Box.Filled,Callback = function(Bool)
				Parvus.Config.PlayerESP.Box.Filled = Bool
			end})
			BoxSection:Toggle({Name = "Outline",Value = Parvus.Config.PlayerESP.Box.Outline,Callback = function(Bool)
				Parvus.Config.PlayerESP.Box.Outline = Bool
			end})
			BoxSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = Parvus.Config.PlayerESP.Box.Thickness,Callback = function(Number)
				Parvus.Config.PlayerESP.Box.Thickness = Number
			end})
			BoxSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.PlayerESP.Box.Transparency,Callback = function(Number)
				Parvus.Config.PlayerESP.Box.Transparency = Number
			end})
			BoxSection:Divider({Text = "Text / Info"})
			BoxSection:Toggle({Name = "Enabled",Value = Parvus.Config.PlayerESP.Box.Info.Enabled,Callback = function(Bool)
				Parvus.Config.PlayerESP.Box.Info.Enabled = Bool
			end})
			BoxSection:Toggle({Name = "Autoscale",Value = Parvus.Config.PlayerESP.Box.Info.AutoScale,Callback = function(Bool)
				Parvus.Config.PlayerESP.Box.Info.AutoScale = Bool
			end})
			BoxSection:Slider({Name = "Size",Min = 14,Max = 28,Value = Parvus.Config.PlayerESP.Box.Info.Size,Callback = function(Number)
				Parvus.Config.PlayerESP.Box.Info.Size = Number
			end})
			BoxSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.PlayerESP.Box.Info.Transparency,Callback = function(Number)
				Parvus.Config.PlayerESP.Box.Info.Transparency = Number
			end})
		end
		local OoVSection = VisualsTab:Section({Name = "Offscreen Arrows",Side = "Left"}) do
			OoVSection:Toggle({Name = "Enabled",Value = Parvus.Config.PlayerESP.Other.Arrow.Enabled,Callback = function(Bool)
				Parvus.Config.PlayerESP.Other.Arrow.Enabled = Bool
			end})
			OoVSection:Toggle({Name = "Filled",Value = Parvus.Config.PlayerESP.Other.Arrow.Filled,Callback = function(Bool)
				Parvus.Config.PlayerESP.Other.Arrow.Filled = Bool
			end})
			OoVSection:Slider({Name = "Height",Min = 14,Max = 28,Value = Parvus.Config.PlayerESP.Other.Arrow.Height,Callback = function(Number)
				Parvus.Config.PlayerESP.Other.Arrow.Height = Number
			end})
			OoVSection:Slider({Name = "Width",Min = 14,Max = 28,Value = Parvus.Config.PlayerESP.Other.Arrow.Width,Callback = function(Number)
				Parvus.Config.PlayerESP.Other.Arrow.Width = Number
			end})
			OoVSection:Slider({Name = "Distance From Center",Min = 80,Max = 200,Value = Parvus.Config.PlayerESP.Other.Arrow.DistanceFromCenter,Callback = function(Number)
				Parvus.Config.PlayerESP.Other.Arrow.DistanceFromCenter = Number
			end})
			OoVSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = Parvus.Config.PlayerESP.Other.Arrow.Thickness,Callback = function(Number)
				Parvus.Config.PlayerESP.Other.Arrow.Thickness = Number
			end})
			OoVSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.PlayerESP.Other.Arrow.Transparency,Callback = function(Number)
				Parvus.Config.PlayerESP.Other.Arrow.Transparency = Number
			end})
		end
		local HeadSection = VisualsTab:Section({Name = "Head Circles",Side = "Right"}) do
			HeadSection:Toggle({Name = "Enabled",Value = Parvus.Config.PlayerESP.Other.Head.Enabled,Callback = function(Bool)
				Parvus.Config.PlayerESP.Other.Head.Enabled = Bool
			end})
			HeadSection:Toggle({Name = "Filled",Value = Parvus.Config.PlayerESP.Other.Head.Filled,Callback = function(Bool)
				Parvus.Config.PlayerESP.Other.Head.Filled = Bool
			end})
			HeadSection:Toggle({Name = "Autoscale",Value = Parvus.Config.PlayerESP.Other.Head.AutoScale,Callback = function(Bool)
				Parvus.Config.PlayerESP.Other.Head.AutoScale = Bool
			end})
			HeadSection:Slider({Name = "Radius",Min = 1,Max = 10,Value = Parvus.Config.PlayerESP.Other.Head.Radius,Callback = function(Number)
				Parvus.Config.PlayerESP.Other.Head.Radius = Number
			end})
			HeadSection:Slider({Name = "NumSides",Min = 3,Max = 100,Value = Parvus.Config.PlayerESP.Other.Head.NumSides,Callback = function(Number)
				Parvus.Config.PlayerESP.Other.Head.NumSides = Number
			end})
			HeadSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = Parvus.Config.PlayerESP.Other.Head.Thickness,Callback = function(Number)
				Parvus.Config.PlayerESP.Other.Head.Thickness = Number
			end})
			HeadSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.PlayerESP.Other.Head.Transparency,Callback = function(Number)
				Parvus.Config.PlayerESP.Other.Head.Transparency = Number
			end})
		end
		local TracerSection = VisualsTab:Section({Name = "Tracers",Side = "Right"}) do
			TracerSection:Toggle({Name = "Enabled",Value = Parvus.Config.PlayerESP.Other.Tracer.Enabled,Callback = function(Bool)
				Parvus.Config.PlayerESP.Other.Tracer.Enabled = Bool
			end})
			TracerSection:Dropdown({Name = "Mode",Default = {
				Parvus.Config.PlayerESP.Other.Tracer.From == "ScreenBottom" and "From Bottom" or "From Mouse"
			},List = {
				{Name = "From Bottom",Mode = "Button",Callback = function()
					Parvus.Config.PlayerESP.Other.Tracer.From = "ScreenBottom"
				end},
				{Name = "From Mouse",Mode = "Button",Callback = function()
					Parvus.Config.PlayerESP.Other.Tracer.From = "Mouse"
				end}
			}})
			TracerSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = Parvus.Config.PlayerESP.Other.Tracer.Thickness,Callback = function(Number)
				Parvus.Config.PlayerESP.Other.Tracer.Thickness = Number
			end})
			TracerSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.PlayerESP.Other.Tracer.Transparency,Callback = function(Number)
				Parvus.Config.PlayerESP.Other.Tracer.Transparency = Number
			end})
		end
		local HighlightSection = VisualsTab:Section({Name = "Highlights",Side = "Right"}) do
			HighlightSection:Toggle({Name = "Enabled",Value = Parvus.Config.PlayerESP.Highlight.Enabled,Callback = function(Bool)
				Parvus.Config.PlayerESP.Highlight.Enabled = Bool
			end})
			HighlightSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.PlayerESP.Highlight.Transparency,Callback = function(Number)
				Parvus.Config.PlayerESP.Highlight.Transparency = Number
			end})
			HighlightSection:Colorpicker({Name = "Outline Color",HSVAR = Parvus.Config.PlayerESP.Highlight.OutlineColor,Callback = function(HSVAR)
				Parvus.Config.PlayerESP.Highlight.OutlineColor = HSVAR
			end})
		end
	end
	local SettingsTab = Window:Tab({Name = "Settings"}) do
		local MenuSection = SettingsTab:Section({Name = "Menu",Side = "Left"}) do
			MenuSection:Toggle({Name = "Enabled",Value = Window.Enabled,Callback = function(Bool) 
				Window:Toggle(Bool)
			end}):Keybind({Key = Parvus.Config.UI.Keybind,Callback = function(Bool,Key)
				Parvus.Config.UI.Keybind = Key or "NONE"
			end})
			MenuSection:Toggle({Name = "Watermark",Value = Parvus.Config.UI.Watermark,Callback = function(Bool) 
				Parvus.Config.UI.Watermark = Bool
				if not Parvus.Config.UI.Watermark then
					Parvus.Utilities.UI:Watermark()
				end
			end})
			MenuSection:Toggle({Name = "Close On Exec",Value = not Parvus.Config.UI.Enabled,Callback = function(Bool) 
				Parvus.Config.UI.Enabled = not Bool
			end})
			MenuSection:Toggle({Name = "Custom Mouse",Value = Parvus.Config.UI.Cursor.Enabled,Callback = function(Bool) 
				Parvus.Config.UI.Cursor.Enabled = Bool
			end})
			MenuSection:Colorpicker({Name = "Color",HSVAR = Parvus.Config.UI.Color,Callback = function(HSVAR,Color)
				Parvus.Config.UI.Color = HSVAR
				Window:SetColor(Color)
			end})
		end
		local CrosshairSection = SettingsTab:Section({Name = "Custom Crosshair",Side = "Left"}) do
			CrosshairSection:Toggle({Name = "Enabled",Value = Parvus.Config.UI.Cursor.Crosshair.Enabled,Callback = function(Bool) 
				Parvus.Config.UI.Cursor.Crosshair.Enabled = Bool
			end})
			CrosshairSection:Colorpicker({Name = "Color",HSVAR = Parvus.Config.UI.Cursor.Crosshair.Color,Callback = function(HSVAR)
				Parvus.Config.UI.Cursor.Crosshair.Color = HSVAR
			end})
			CrosshairSection:Slider({Name = "Size",Min = 0,Max = 100,Value = Parvus.Config.UI.Cursor.Crosshair.Size,Callback = function(Number)
				Parvus.Config.UI.Cursor.Crosshair.Size = Number
			end})
			CrosshairSection:Slider({Name = "Gap",Min = 0,Max = 100,Value = Parvus.Config.UI.Cursor.Crosshair.Gap,Callback = function(Number)
				Parvus.Config.UI.Cursor.Crosshair.Gap = Number
			end})
		end

		local MiscTab = Window:Tab({Name = "Miscellaneous"}) do -- was here
			local MiscSection = MiscTab:Section({Name = "Quick Execution",Side = "Left"}) do
				MiscSection:Button({Name = "Infinite Yield",Side = "Left",Callback = function()
					loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
				end})
				MiscSection:Button({Name = "Fates Admin",Side = "Left",Callback = function()
					loadstring(game:HttpGet("https://raw.githubusercontent.com/fatesc/fates-admin/main/main.lua"))();
				end})
				MiscSection:Button({Name = "Fling",Side = "Left",Callback = function()
					local a="Torso"if game.Players.LocalPlayer.Character:FindFirstChild("UpperTorso")then a="UpperTorso"end;if game.Players.LocalPlayer.Character:FindFirstChild("Torso")then a="Torso"end;local b=game.Players.LocalPlayer.Character;local c=Instance.new("Model",workspace)local d=Instance.new("Part",c)d.Name="Torso"d.CanCollide=false;d.Anchored=true;local e=Instance.new("Part",c)e.Name="Head"e.Anchored=true;e.CanCollide=false;local f=Instance.new("Humanoid",c)f.Name="Humanoid"d.Position=Vector3.new(0,9999,0)e.Position=Vector3.new(0,9991,0)game.Players.LocalPlayer.Character=c;wait(5)game.Players.LocalPlayer.Character=b;wait(6)local g=game.Players.LocalPlayer.Character.Humanoid:Clone()wait()game.Players.LocalPlayer.Character[a]:Destroy()game.Players.LocalPlayer.Character.HumanoidRootPart:Destroy()game.Players.LocalPlayer.Character.LeftHand.Anchored=true;game.Players.LocalPlayer.Character.LeftLowerArm.Anchored=true;game.Players.LocalPlayer.Character.LeftUpperArm.Anchored=true;game.Players.LocalPlayer.Character.RightHand.Anchored=true;game.Players.LocalPlayer.Character.RightLowerArm.Anchored=true;game.Players.LocalPlayer.Character.RightUpperArm.Anchored=true;if game.Players.LocalPlayer.Character:FindFirstChild("UpperTorso")~=nil then game.Players.LocalPlayer.Character:FindFirstChild("UpperTorso").Anchored=true end;game.Players.LocalPlayer.Character.LeftLowerLeg.Anchored=true;game.Players.LocalPlayer.Character.LeftUpperLeg.Anchored=true;game.Players.LocalPlayer.Character.RightFoot.Anchored=true;game.Players.LocalPlayer.Character.RightLowerLeg.Anchored=true;game.Players.LocalPlayer.Character.RightUpperLeg.Anchored=true;game.Players.LocalPlayer.Character.LowerTorso.Anchored=true;game.Players.LocalPlayer.Character.LeftHand.Anchored=true;game.Players.LocalPlayer.Character.LeftHand.Anchored=true;local h=Instance.new("BodyThrust")h.Parent=game.Players.LocalPlayer.Character.Head;h.Force=Vector3.new(0,9999999,0)h.Location=game.Players.LocalPlayer.Character.Head.Position;local i=game.Players.LocalPlayer.Character.Head;game.Players.LocalPlayer.Character.Humanoid.Parent=game.Lighting;game:GetService("RunService").Stepped:connect(function()i.CanCollide=false end)g.Parent=game.Players.LocalPlayer.Character;local j=Instance.new("Humanoid",game.Players.LocalPlayer.Character)j.HipHeight=2;j.RigType=Enum.HumanoidRigType.R15;j.WalkSpeed=50;local k=game.Players.LocalPlayer:GetMouse()local l=i;local m=workspace.CurrentCamera;m.CameraType=Enum.CameraType.Follow;m.CameraSubject=l;local n=game.Players.LocalPlayer;local o=true;local p=true;local q={f=0,b=0,l=0,r=0}local r={f=0,b=0,l=0,r=0}local s=4000;local t=0;function Fly()local u=Instance.new("BodyGyro",i)u.P=9e4;u.maxTorque=Vector3.new(9e9,9e9,9e9)u.cframe=i.CFrame;local v=Instance.new("BodyVelocity",i)v.velocity=Vector3.new(0,0,0)v.maxForce=Vector3.new(9e9,9e9,9e9)repeat wait()if q.l+q.r~=0 or q.f+q.b~=0 then t=t+.5+t/s;if t>s then t=s end elseif not(q.l+q.r~=0 or q.f+q.b~=0)and t~=0 then t=t-1;if t<0 then t=0 end end;if q.l+q.r~=0 or q.f+q.b~=0 then v.velocity=(game.Workspace.CurrentCamera.CoordinateFrame.lookVector*(q.f+q.b)+game.Workspace.CurrentCamera.CoordinateFrame*CFrame.new(q.l+q.r,(q.f+q.b)*.2,0).p-game.Workspace.CurrentCamera.CoordinateFrame.p)*t;r={f=q.f,b=q.b,l=q.l,r=q.r}elseif q.l+q.r==0 and q.f+q.b==0 and t~=0 then v.velocity=(game.Workspace.CurrentCamera.CoordinateFrame.lookVector*(r.f+r.b)+game.Workspace.CurrentCamera.CoordinateFrame*CFrame.new(r.l+r.r,(r.f+r.b)*.2,0).p-game.Workspace.CurrentCamera.CoordinateFrame.p)*t else v.velocity=Vector3.new(0,0.1,0)end;u.cframe=game.Workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(-math.rad((q.f+q.b)*50*t/s),0,0)until not o;q={f=0,b=0,l=0,r=0}r={f=0,b=0,l=0,r=0}t=0;u:Destroy()v:Destroy()end;k.KeyDown:connect(function(w)if w:lower()=="w"then q.f=1 elseif w:lower()=="s"then q.b=-1 elseif w:lower()=="a"then q.l=-1 elseif w:lower()=="d"then q.r=1 end end)k.KeyUp:connect(function(w)if w:lower()=="w"then q.f=0 elseif w:lower()=="s"then q.b=0 elseif w:lower()=="a"then q.l=0 elseif w:lower()=="d"then q.r=0 end end)Fly()i.Name="HumanoidRootPart"k.KeyDown:connect(function(x)if x:lower()=="z"then i.Velocity=Vector3.new(0,1919191,0)end end)
				end})
				
				local GunModsSection = MiscTab:Section({Name = "Gun Modifications",Side = "Left"}) do
					MiscSection:Button({Name = "Unlimited Ammo",Side = "Left",Callback = function()
						local Player = game:GetService("Players").LocalPlayer
						local mag = require(game:GetService("ReplicatedStorage").Modules.Gun).get(Player.Character:FindFirstChildOfClass("Tool"));

						--mag.Clip = mag.Clip + 300
						mag.MagazineBullets = mag.MagazineBullets + 999
					end})
				end
			end
			
			local VehicleModsSection = MiscTab:Section({Name = "Vehicle Modifications",Side = "Right"}) do
				MiscSection:Button({Name = "Vehicle Acceleration",Side = "Left",Callback = function()
					for i, v in pairs(workspace.CarStorage:GetChildren()) do
						v.Cosmetics.Essentials.SpeedScalar.Value = 9999999999999999999999999999999
					end
				end})
			end
				

				SettingsTab:Button({Name = "Rejoin",Side = "Left",Callback = function()
					if #PlayerService:GetPlayers() <= 1 then
						LocalPlayer:Kick("\nRejoining...")
						task.wait()
						game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
					else
						game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
					end
				end})
				SettingsTab:Button({Name = "Server Hop",Side = "Left",Callback = function()
					local Servers = {}
					local Request = game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
					local DataDecoded = HttpService:JSONDecode(Request).data
					for Index,ServerData in ipairs(DataDecoded) do
						if type(ServerData) == "table" and ServerData.id ~= game.JobId then
							table.insert(Servers,ServerData.id)
						end
					end
					if #Servers > 0 then
						game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Servers[math.random(1, #Servers)])
					else
						Parvus.Utilities.UI:Notification({
							Title = "ridgeHUN v4.0",
							Description = "Couldn't find a server",
							Duration = 5
						})
					end
				end})
				SettingsTab:Button({Name = "Join Discord Server",Side = "Left",Callback = function()
					local Request = (syn and syn.request) or request
					Request({
						["Url"] = "http://localhost:6463/rpc?v=1",
						["Method"] = "POST",
						["Headers"] = {
							["Content-Type"] = "application/json",
							["Origin"] = "https://discord.com"
						},
						["Body"] = HttpService:JSONEncode({
							["cmd"] = "INVITE_BROWSER",
							["nonce"] = string.lower(HttpService:GenerateGUID(false)),
							["args"] = {
								["code"] = "sYqDpbPYb7"
							}
						})
					})
				end}):ToolTip("Join for support, updates and more!")
				local BackgroundSection = SettingsTab:Section({Name = "Background",Side = "Right"}) do
					BackgroundSection:Dropdown({Name = "Image",Default = {Parvus.Config.UI.Background},List = {
						{Name = "Legacy",Mode = "Button",Callback = function()
							Window.Background.Image = "rbxassetid://2151741365"
							Parvus.Config.UI.BackgroundId = "rbxassetid://2151741365"
						end},
						{Name = "Hearts",Mode = "Button",Callback = function()
							Window.Background.Image = "rbxassetid://6073763717"
							Parvus.Config.UI.BackgroundId = "rbxassetid://6073763717"
						end},
						{Name = "Abstract",Mode = "Button",Callback = function()
							Window.Background.Image = "rbxassetid://6073743871"
							Parvus.Config.UI.BackgroundId = "rbxassetid://6073743871"
						end},
						{Name = "Hexagon",Mode = "Button",Callback = function()
							Window.Background.Image = "rbxassetid://6073628839"
							Parvus.Config.UI.BackgroundId = "rbxassetid://6073628839"
						end},
						{Name = "Circles",Mode = "Button",Callback = function()
							Window.Background.Image = "rbxassetid://6071579801"
							Parvus.Config.UI.BackgroundId = "rbxassetid://6071579801"
						end},
						{Name = "Lace With Flowers",Mode = "Button",Callback = function()
							Window.Background.Image = "rbxassetid://6071575925"
							Parvus.Config.UI.BackgroundId = "rbxassetid://6071575925"
						end},
						{Name = "Floral",Mode = "Button",Callback = function()
							Window.Background.Image = "rbxassetid://5553946656"
							Parvus.Config.UI.BackgroundId = "rbxassetid://5553946656"
						end}
					}})
					Window.Background.Image = Parvus.Config.UI.BackgroundId
					Window.Background.ImageTransparency = Parvus.Config.UI.BackgroundColor[4]
					Window.Background.TileSize = UDim2.new(0,Parvus.Config.UI.TileSize,0,Parvus.Config.UI.TileSize)
					Window.Background.ImageColor3 = Parvus.Utilities.Config:TableToColor(Parvus.Config.UI.BackgroundColor)
					BackgroundSection:Textbox({Name = "Custom Image",Text = "",Placeholder = "ImageId",Callback = function(String)
						Window.Background.Image = "rbxassetid://" .. String
						Parvus.Config.UI.BackgroundId = "rbxassetid://" .. String
					end})
					BackgroundSection:Colorpicker({Name = "Color",HSVAR = Parvus.Config.UI.BackgroundColor,Callback = function(HSVAR,Color)
						Parvus.Config.UI.BackgroundColor = HSVAR
						Window.Background.ImageColor3 = Color
						Window.Background.ImageTransparency = HSVAR[4]
					end})
					BackgroundSection:Slider({Name = "Tile Offset",Min = 74, Max = 296,Value = Window.Background.TileSize.X.Offset,Callback = function(Number)
						Parvus.Config.UI.TileSize = Number
						Window.Background.TileSize = UDim2.new(0,Number,0,Number)
					end})
				end
				local CreditsSection = SettingsTab:Section({Name = "Credits",Side = "Right"}) do
					CreditsSection:Label({Text = "ridgeHUN v4.0 | re-written"})
					CreditsSection:Divider()
					CreditsSection:Label({Text = "i hate jetpack"})
				end
			end
		end

		local function TeamCheck(Player)
			if Parvus.Config.AimAssist.TeamCheck then
				return LocalPlayer.Team ~= Player.Team
			end
			return true
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
			local FieldOfView = Config.FieldOfView
			local ClosestHitbox = nil

			for Index, Player in pairs(PlayerService:GetPlayers()) do
				local Character = Player.Character
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
				local IsAlive = Humanoid and Humanoid.Health > 0
				if Player ~= LocalPlayer and IsAlive and TeamCheck(Player) then
					for Index, HumanoidPart in pairs(Config.Priority) do
						local Hitbox = Character and Character:FindFirstChild(HumanoidPart)
						if Hitbox then
							local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Hitbox.Position)
							local Magnitude = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
							FieldOfView = Config.DynamicFoV and (120 - Workspace.CurrentCamera.FieldOfView) * 4 or FieldOfView
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
		__namecall = hookmetamethod(game, "__namecall", function(self, ...)
			local args = {...}
			if Parvus.Config.AimAssist.SilentAim.Enabled and SilentAim then
				local Camera = Workspace.CurrentCamera
				local HitChance = math.random(0,100) <= Parvus.Config.AimAssist.SilentAim.HitChance
				if getnamecallmethod() == "Raycast" and HitChance then
					args[2] = SilentAim.Position - Camera.CFrame.Position
				elseif getnamecallmethod() == "FindPartOnRayWithIgnoreList" and HitChance then
					args[1] = Ray.new(args[1].Origin,SilentAim.Position - Camera.CFrame.Position)
				end
			end
			return __namecall(self, unpack(args))
		end)

		RunService.Heartbeat:Connect(function()
			SilentAim = GetHitbox(Parvus.Config.AimAssist.SilentAim)
			if Aimbot then AimAt(
				GetHitbox(Parvus.Config.AimAssist.Aimbot),
				Parvus.Config.AimAssist.Aimbot)
			end

			if Parvus.Config.UI.Watermark then
				Parvus.Utilities.UI:Watermark({
					Enabled = true,
					Title = string.format(
						"ridgeHUN v4.0 — %s\nTime: %s - %s\nFPS: %i/s\nPing: %i ms",
						Parvus.Current,os.date("%X"),os.date("%x"),GetFPS(),math.round(Stats.PerformanceStats.Ping:GetValue())
					)
				})
			end
		end)

		for Index, Player in pairs(PlayerService:GetPlayers()) do
			if Player ~= LocalPlayer then
				Parvus.Utilities.Drawing:AddESP("Player", Player, Parvus.Config.PlayerESP)
			end
		end
		PlayerService.PlayerAdded:Connect(function(Player)
			Parvus.Utilities.Drawing:AddESP("Player", Player, Parvus.Config.PlayerESP)
		end)
		PlayerService.PlayerRemoving:Connect(function(Player)
			if Player == LocalPlayer then Parvus.Utilities.Config:WriteJSON(Parvus.Current,Parvus.Config) end
			Parvus.Utilities.Drawing:RemoveESP(Player)
		end)
