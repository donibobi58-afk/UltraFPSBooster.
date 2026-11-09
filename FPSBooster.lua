--====================================
-- ULTRA FPS BOOSTER
-- Roblox LocalScript
--====================================

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraFPS"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(260, 175)
Main.Position = UDim2.new(0.5, -130, 0.5, -87)
Main.BackgroundColor3 = Color3.fromRGB(18, 20, 27)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 255, 150)
Stroke.Thickness = 1.5
Stroke.Parent = Main

-- TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -85, 0, 40)
Title.Position = UDim2.fromOffset(12, 4)
Title.BackgroundTransparency = 1
Title.Text = "ULTRA FPS BOOST"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

-- CLOSE
local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(30, 30)
Close.Position = UDim2.new(1, -37, 0, 7)
Close.Text = "X"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 15
Close.Parent = Main

Instance.new("UICorner", Close).CornerRadius =
	UDim.new(0, 7)

-- FPS LABEL
local FPS = Instance.new("TextLabel")
FPS.Size = UDim2.new(1, -20, 0, 35)
FPS.Position = UDim2.fromOffset(10, 48)
FPS.BackgroundTransparency = 1
FPS.Text = "FPS: Calculating..."
FPS.TextColor3 = Color3.new(1, 1, 1)
FPS.Font = Enum.Font.GothamBold
FPS.TextSize = 16
FPS.Parent = Main

-- BOOST BUTTON
local Boost = Instance.new("TextButton")
Boost.Size = UDim2.new(1, -30, 0, 42)
Boost.Position = UDim2.fromOffset(15, 95)
Boost.BackgroundColor3 = Color3.fromRGB(0, 150, 95)
Boost.Text = "BOOST: OFF"
Boost.TextColor3 = Color3.new(1, 1, 1)
Boost.Font = Enum.Font.GothamBold
Boost.TextSize = 16
Boost.Parent = Main

Instance.new("UICorner", Boost).CornerRadius =
	UDim.new(0, 8)

-- STATUS
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 22)
Status.Position = UDim2.fromOffset(0, 145)
Status.BackgroundTransparency = 1
Status.Text = "STATUS: READY"
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.TextSize = 11
Status.Font = Enum.Font.Gotham
Status.Parent = Main

-- MINIMIZE BUTTON
local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(30, 30)
Minimize.Position = UDim2.new(1, -73, 0, 7)
Minimize.Text = "—"
Minimize.TextColor3 = Color3.new(1, 1, 1)
Minimize.BackgroundColor3 = Color3.fromRGB(45, 100, 180)
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 18
Minimize.Parent = Main

Instance.new("UICorner", Minimize).CornerRadius =
	UDim.new(0, 7)

-- MINIMIZE SYSTEM
local Minimized = false

Minimize.MouseButton1Click:Connect(function()
	Minimized = not Minimized

	FPS.Visible = not Minimized
	Boost.Visible = not Minimized
	Status.Visible = not Minimized

	if Minimized then
		Main.Size = UDim2.fromOffset(260, 48)
		Minimize.Text = "+"
	else
		Main.Size = UDim2.fromOffset(260, 175)
		Minimize.Text = "—"
	end
end)


-- FPS BOOST SYSTEM
local Active = false
local Saved = {}
local OldShadows = Lighting.GlobalShadows
local OldFog = Lighting.FogEnd

local function ChangeEffect(obj, state)
	if obj:IsA("ParticleEmitter")
		or obj:IsA("Trail")
		or obj:IsA("Beam")
		or obj:IsA("Smoke")
		or obj:IsA("Fire")
		or obj:IsA("Sparkles")
		or obj:IsA("PostEffect") then

		if Saved[obj] == nil then
			Saved[obj] = obj.Enabled
		end

		obj.Enabled = state
	end
end

local function EnableBoost()
	Active = true

	OldShadows = Lighting.GlobalShadows
	OldFog = Lighting.FogEnd

	Lighting.GlobalShadows = false
	Lighting.FogEnd = 1000000

	for _, obj in ipairs(Workspace:GetDescendants()) do
		ChangeEffect(obj, false)
	end

	for _, obj in ipairs(Lighting:GetDescendants()) do
		ChangeEffect(obj, false)
	end

	Boost.Text = "BOOST: ON"
	Boost.BackgroundColor3 = Color3.fromRGB(190, 65, 45)
	Status.Text = "STATUS: BOOST ACTIVE"
	Status.TextColor3 = Color3.fromRGB(0, 255, 150)
end

local function DisableBoost()
	Active = false

	Lighting.GlobalShadows = OldShadows
	Lighting.FogEnd = OldFog

	for obj, oldValue in pairs(Saved) do
		if obj.Parent then
			obj.Enabled = oldValue
		end
	end

	table.clear(Saved)

	Boost.Text = "BOOST: OFF"
	Boost.BackgroundColor3 = Color3.fromRGB(0, 150, 95)
	Status.Text = "STATUS: BOOST DISABLED"
	Status.TextColor3 = Color3.fromRGB(180, 180, 180)
end

Boost.MouseButton1Click:Connect(function()
	if Active then
		DisableBoost()
	else
		EnableBoost()
	end
end)

-- FPS COUNTER
local elapsed = 0
local frames = 0

local fpsConnection = RunService.RenderStepped:Connect(function(dt)
	frames += 1
	elapsed += dt

	if elapsed >= 0.5 then
		local value = math.floor(frames / elapsed)
		FPS.Text = "FPS: " .. value

		frames = 0
		elapsed = 0
	end
end)

-- CLOSE BUTTON
Close.MouseButton1Click:Connect(function()
	if Active then
		DisableBoost()
	end

	fpsConnection:Disconnect()
	ScreenGui:Destroy()
end)

print("ULTRA FPS BOOSTER LOADED!")

-- DRAG GUI SYSTEM
local UserInputService =
	game:GetService("UserInputService")

local dragging = false
local dragInput
local dragStart
local startPos

Title.Active = true

Title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = Main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Title.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - dragStart

		Main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

