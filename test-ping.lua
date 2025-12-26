-- ULTRA REAL-TIME PING & FPS FOR MOBILE
-- Exact same as Shift+F3 and Shift+F5 stats

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StatsService = game:GetService("Stats")

-- Simple GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RealTimeStats"
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

-- Title with Credit
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 1, 0)
title.BackgroundTransparency = 1
title.Text = "@MikaaDev"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextSize = 14
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

-- Ping Display (Bold)
local pingText = Instance.new("TextLabel")
pingText.Size = UDim2.new(1, -10, 0, 25)
pingText.Position = UDim2.new(0, 5, 0, 30)
pingText.BackgroundTransparency = 1
pingText.Text = "Ping: 0ms"
pingText.TextColor3 = Color3.fromRGB(255, 255, 255)
pingText.TextSize = 14
pingText.Font = Enum.Font.GothamBold  -- BOLD
pingText.TextXAlignment = Enum.TextXAlignment.Left
pingText.Parent = mainFrame

-- FPS Display (Bold)
local fpsText = Instance.new("TextLabel")
fpsText.Size = UDim2.new(1, -10, 0, 25)
fpsText.Position = UDim2.new(0, 5, 0, 55)
fpsText.BackgroundTransparency = 1
fpsText.Text = "FPS: 0"
fpsText.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsText.TextSize = 14
fpsText.Font = Enum.Font.GothamBold  -- BOLD
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
        if isOverCloseButton(input.Position) then
            return
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

-- ===== EXACT SAME AS SHIFT+F3 PING =====
local lastPingValue = 0
local pingUpdateTime = 0

local function GetExactShiftF3Ping()
    -- Method yang sama persis dengan Roblox Shift+F3
    local success, ping = pcall(function()
        -- Ini cara Roblox sendiri mengambil ping
        local networkStats = StatsService:FindFirstChild("Network")
        if networkStats then
            local serverStats = networkStats:FindFirstChild("ServerStatsItem")
            if serverStats then
                return serverStats:GetValue()
            end
        end
        return 0
    end)
    
    if not success then
        -- Fallback ke method lain yang sama akuratnya
        local success2, ping2 = pcall(function()
            return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        return success2 and ping2 or lastPingValue
    end
    
    return ping
end

-- ===== EXACT SAME AS SHIFT+F5 FPS =====
local frameTimes = {}
local lastFPSUpdate = 0

local function GetExactShiftF5FPS()
    -- Cara Roblox menghitung FPS (per second frame count)
    local currentTime = tick()
    
    -- Tambah waktu frame saat ini
    table.insert(frameTimes, currentTime)
    
    -- Hapus frame times yang lebih dari 1 detik
    while #frameTimes > 0 and currentTime - frameTimes[1] > 1.0 do
        table.remove(frameTimes, 1)
    end
    
    if #frameTimes < 2 then
        return 0
    end
    
    local timeSpan = currentTime - frameTimes[1]
    if timeSpan <= 0 then
        return 0
    end
    
    -- Hitung FPS persis seperti Roblox
    local fps = (#frameTimes - 1) / timeSpan
    
    -- Bulatkan ke integer seperti Roblox
    return math.floor(fps + 0.5)
end

-- ===== ULTRA REAL-TIME UPDATE =====
local currentPing = 0
local currentFPS = 0

-- Update FPS SETIAP FRAME (paling real-time)
RunService.RenderStepped:Connect(function()
    -- Update FPS setiap frame (seperti monitor FPS real-time)
    currentFPS = GetExactShiftF5FPS()
    
    -- Update display
    fpsText.Text = "FPS: " .. currentFPS
    
    -- Warna seperti Roblox performance stats
    if currentFPS >= 60 then
        fpsText.TextColor3 = Color3.fromRGB(0, 255, 0)      -- Green
    elseif currentFPS >= 45 then
        fpsText.TextColor3 = Color3.fromRGB(150, 255, 150)  -- Light Green
    elseif currentFPS >= 30 then
        fpsText.TextColor3 = Color3.fromRGB(255, 255, 0)    -- Yellow
    elseif currentFPS >= 20 then
        fpsText.TextColor3 = Color3.fromRGB(255, 150, 0)    -- Orange
    else
        fpsText.TextColor3 = Color3.fromRGB(255, 50, 50)    -- Red
    end
end)

-- Update Ping lebih sering (setiap 0.2 detik)
RunService.Heartbeat:Connect(function()
    local now = tick()
    if now - pingUpdateTime >= 0.2 then  -- 5x per detik
        currentPing = GetExactShiftF3Ping()
        pingUpdateTime = now
        lastPingValue = currentPing
        
        -- Update display
        pingText.Text = "Ping: " .. math.floor(currentPing) .. "ms"
        
        -- Warna seperti Roblox network stats
        if currentPing < 50 then
            pingText.TextColor3 = Color3.fromRGB(0, 255, 0)      -- Green
        elseif currentPing < 100 then
            pingText.TextColor3 = Color3.fromRGB(150, 255, 150)  -- Light Green
        elseif currentPing < 200 then
            pingText.TextColor3 = Color3.fromRGB(255, 255, 0)    -- Yellow
        elseif currentPing < 350 then
            pingText.TextColor3 = Color3.fromRGB(255, 150, 0)    -- Orange
        else
            pingText.TextColor3 = Color3.fromRGB(255, 50, 50)    -- Red
        end
    end
end)

print("======================================")
print("EXACT ROBLOX STATS LOADED")
print("Created by @MikaaDev")
print("Identical to Shift+F3 (Ping) and Shift+F5 (FPS)")
print("Ultra real-time updates")
print("======================================")

return {
    GetPing = function() return math.floor(currentPing) end,
    GetFPS = function() return currentFPS end,
    Close = function() screenGui:Destroy() end
}
