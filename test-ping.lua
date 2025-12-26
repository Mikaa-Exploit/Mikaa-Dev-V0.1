-- SIMPLE PING & FPS FOR MOBILE
-- No Error, Just Ping & FPS

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Simple GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleStats"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 150, 0, 80)
mainFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.1, 0)
corner.Parent = mainFrame

-- Title Bar with Close Button
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 25)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 1, 0)
title.BackgroundTransparency = 1
title.Text = "Mobile Stats"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Close Button (X kecil)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -25, 0.5, -10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BackgroundTransparency = 0.3
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.3, 0)
closeCorner.Parent = closeButton

-- Hover effect untuk close button
closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundTransparency = 0.1
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundTransparency = 0.3
end)

-- Close function
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

closeButton.Parent = titleBar

-- Ping Display
local pingText = Instance.new("TextLabel")
pingText.Size = UDim2.new(1, -10, 0, 25)
pingText.Position = UDim2.new(0, 5, 0, 30)
pingText.BackgroundTransparency = 1
pingText.Text = "Ping: 0ms"
pingText.TextColor3 = Color3.fromRGB(255, 255, 255)
pingText.TextSize = 14
pingText.Font = Enum.Font.Gotham
pingText.TextXAlignment = Enum.TextXAlignment.Left
pingText.Parent = mainFrame

-- FPS Display
local fpsText = Instance.new("TextLabel")
fpsText.Size = UDim2.new(1, -10, 0, 25)
fpsText.Position = UDim2.new(0, 5, 0, 55)
fpsText.BackgroundTransparency = 1
fpsText.Text = "FPS: 0"
fpsText.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsText.TextSize = 14
fpsText.Font = Enum.Font.Gotham
fpsText.TextXAlignment = Enum.TextXAlignment.Left
fpsText.Parent = mainFrame

mainFrame.Parent = screenGui

-- Drag function (tidak termasuk close button)
local dragging = false
local dragStart, frameStart

local function isOverCloseButton(inputPosition)
    local closeButtonAbsolutePos = closeButton.AbsolutePosition
    local closeButtonSize = closeButton.AbsoluteSize
    
    return inputPosition.X >= closeButtonAbsolutePos.X and
           inputPosition.X <= closeButtonAbsolutePos.X + closeButtonSize.X and
           inputPosition.Y >= closeButtonAbsolutePos.Y and
           inputPosition.Y <= closeButtonAbsolutePos.Y + closeButtonSize.Y
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        -- Cek apakah touch di close button
        if isOverCloseButton(input.Position) then
            return -- Biarkan close button handle click-nya sendiri
        end
        
        dragging = true
        dragStart = input.Position
        frameStart = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            frameStart.X.Scale,
            frameStart.X.Offset + delta.X,
            frameStart.Y.Scale,
            frameStart.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- REAL PING GETTER (FIXED)
local function GetRealPing()
    local success, result = pcall(function()
        -- Method 1: Direct from Stats
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
        if ping then
            return ping:GetValue()
        end
        return 0
    end)
    
    if not success then
        -- Method 2: Alternative
        local success2, result2 = pcall(function()
            return game:GetService("Stats"):FindFirstChild("Network"):FindFirstChild("ServerStatsItem"):GetValue()
        end)
        return success2 and result2 or 0
    end
    
    return success and result or 0
end

-- FPS Counter
local frameCount = 0
local lastTime = tick()
local fps = 0
local lastPingCheck = 0
local currentPing = 0

-- Update loop
RunService.RenderStepped:Connect(function()
    -- Calculate FPS
    frameCount = frameCount + 1
    local now = tick()
    
    if now - lastTime >= 1 then
        fps = math.floor(frameCount / (now - lastTime))
        frameCount = 0
        lastTime = now
        
        -- Update FPS text with color
        fpsText.Text = "FPS: " .. fps
        if fps >= 45 then
            fpsText.TextColor3 = Color3.fromRGB(0, 255, 100)
        elseif fps >= 25 then
            fpsText.TextColor3 = Color3.fromRGB(255, 200, 0)
        else
            fpsText.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end
    
    -- Update Ping every 0.5 seconds
    if now - lastPingCheck >= 0.5 then
        currentPing = GetRealPing()
        lastPingCheck = now
        
        -- Update Ping text with color
        pingText.Text = "Ping: " .. math.floor(currentPing) .. "ms"
        if currentPing < 80 then
            pingText.TextColor3 = Color3.fromRGB(0, 255, 100)
        elseif currentPing < 150 then
            pingText.TextColor3 = Color3.fromRGB(255, 200, 0)
        else
            pingText.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end
end)

print("[Simple Ping & FPS Loaded]")
print("Drag to move | X button to close | Shows real ping & FPS")

-- Return close function untuk akses manual
return {
    Close = function()
        screenGui:Destroy()
    end,
    
    GetPing = function()
        return math.floor(currentPing)
    end,
    
    GetFPS = function()
        return fps
    end
}
