-- PING & FPS MIKAA V0.2 (Posisi default kiri atas)

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MikaaDev_Stats"
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 140, 0, 60)
mainFrame.Position = UDim2.new(0.02, 0, 0.02, 0) -- kiri atas
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(1, -10, 0, 28)
pingLabel.Position = UDim2.new(0, 5, 0, 5)
pingLabel.BackgroundTransparency = 1
pingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
pingLabel.TextSize = 16
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextXAlignment = Enum.TextXAlignment.Left
pingLabel.Text = "Ping: --ms"
pingLabel.Parent = mainFrame

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, -10, 0, 28)
fpsLabel.Position = UDim2.new(0, 5, 0, 30)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsLabel.TextSize = 16
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Text = "FPS: --"
fpsLabel.Parent = mainFrame

local dragging = false
local dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)
mainFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)
mainFrame.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

local function GetPing()
	local success, ping = pcall(function()
		local item = Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
		if item then return item:GetValue() end
	end)
	if success and ping then
		return math.floor(ping)
	end
	return 0
end

local frameTimes = {}
local MAX_FRAMES = 120
local function GetFPS()
	local now = tick()
	table.insert(frameTimes, now)
	while #frameTimes > MAX_FRAMES do
		table.remove(frameTimes, 1)
	end
	local count = 0
	local oneSecAgo = now - 1
	for i = #frameTimes, 1, -1 do
		if frameTimes[i] >= oneSecAgo then
			count = count + 1
		else
			break
		end
	end
	return count
end

RunService.RenderStepped:Connect(function()
	local ping = GetPing()
	pingLabel.Text = "Ping: "..ping.."ms"
	if ping < 30 then
		pingLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
	elseif ping < 60 then
		pingLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
	elseif ping < 100 then
		pingLabel.TextColor3 = Color3.fromRGB(200, 255, 100)
	elseif ping < 150 then
		pingLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
	elseif ping < 250 then
		pingLabel.TextColor3 = Color3.fromRGB(255, 180, 0)
	else
		pingLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
	end

	local fps = GetFPS()
	fpsLabel.Text = "FPS: "..fps
	if fps >= 60 then
		fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
	elseif fps >= 40 then
		fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
	else
		fpsLabel.TextColor3 = Color3.fromRGB(255, 180, 0)
	end
end)

print("[MIKAA DEV] Ping & FPS UI Loaded")
