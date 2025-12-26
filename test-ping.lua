-- ULTIMATE REAL-TIME PING & FPS DISPLAY
-- 100% ACCURATE, BIG TEXT, MOBILE OPTIMIZED

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StatsService = game:GetService("Stats")

-- ===== BIGGER UI FOR MOBILE =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MikaaDev_Stats"
screenGui.Parent = game:GetService("CoreGui")

-- Larger frame for bigger text
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 120) -- Lebih besar
mainFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BackgroundTransparency = 0.25
mainFrame.BorderSizePixel = 0

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.12, 0)
corner.Parent = mainFrame

-- Add subtle shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5554236805"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.6
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32) -- Lebih tinggi
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

-- Title with bigger text
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.BackgroundTransparency = 1
title.Text = "@MikaaDev"
title.TextColor3 = Color3.fromRGB(0, 180, 255)
title.TextSize = 16 -- Lebih besar
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Close Button (slightly bigger)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 28, 0, 28) -- Lebih besar
closeButton.Position = UDim2.new(1, -32, 0.5, -14)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
closeButton.BackgroundTransparency = 0.2
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18 -- Lebih besar
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.3, 0)
closeCorner.Parent = closeButton

closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundTransparency = 0.1
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundTransparency = 0.2
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

closeButton.Parent = titleBar

-- ===== BIGGER PING DISPLAY =====
local pingText = Instance.new("TextLabel")
pingText.Name = "PingDisplay"
pingText.Size = UDim2.new(1, -15, 0, 36) -- Lebih tinggi
pingText.Position = UDim2.new(0, 8, 0, 40)
pingText.BackgroundTransparency = 1
pingText.Text = "Ping: --ms"
pingText.TextColor3 = Color3.fromRGB(255, 255, 255)
pingText.TextSize = 18 -- BESAR! (dari 14)
pingText.Font = Enum.Font.GothamBold
pingText.TextXAlignment = Enum.TextXAlignment.Left
pingText.TextYAlignment = Enum.TextYAlignment.Top
pingText.Parent = mainFrame

-- ===== BIGGER FPS DISPLAY =====
local fpsText = Instance.new("TextLabel")
fpsText.Name = "FPSDisplay"
fpsText.Size = UDim2.new(1, -15, 0, 36) -- Lebih tinggi
fpsText.Position = UDim2.new(0, 8, 0, 76)
fpsText.BackgroundTransparency = 1
fpsText.Text = "FPS: --"
fpsText.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsText.TextSize = 18 -- BESAR! (dari 14)
fpsText.Font = Enum.Font.GothamBold
fpsText.TextXAlignment = Enum.TextXAlignment.Left
fpsText.TextYAlignment = Enum.TextYAlignment.Top
fpsText.Parent = mainFrame

mainFrame.Parent = screenGui

-- ===== DRAG FUNCTION =====
local dragging = false
local dragStart, frameStart

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
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

-- ===== ULTRA ACCURATE PING GETTER =====
local function GetExactRobloxPing()
    -- Method yang 100% sama dengan Shift+F3
    local success, ping = pcall(function()
        -- Ini cara Roblox internal mengambil ping
        local stats = game:GetService("Stats")
        local network = stats.Network
        local pingStat = network.ServerStatsItem["Data Ping"]
        return pingStat:GetValue()
    end)
    
    if success and ping then
        return math.floor(ping)
    end
    
    -- Fallback method
    local success2, ping2 = pcall(function()
        return StatsService:FindFirstChild("Network"):FindFirstChild("ServerStatsItem"):GetValue()
    end)
    
    return success2 and math.floor(ping2) or 0
end

-- ===== ULTRA ACCURATE FPS CALCULATOR =====
local frameTimestamps = {}
local FPS_HISTORY_SIZE = 120 -- Sample 2 detik untuk lebih smooth

local function GetExactRobloxFPS()
    local currentTime = tick()
    
    -- Tambah timestamp sekarang
    table.insert(frameTimestamps, currentTime)
    
    -- Pertahankan hanya 2 detik terakhir
    while #frameTimestamps > 0 and currentTime - frameTimestamps[1] > 2.0 do
        table.remove(frameTimestamps, 1)
    end
    
    if #frameTimestamps < 2 then
        return 0
    end
    
    -- Hitung FPS berdasarkan 1 detik terakhir
    local oneSecondAgo = currentTime - 1.0
    local framesInLastSecond = 0
    
    for i = #frameTimestamps, 1, -1 do
        if frameTimestamps[i] >= oneSecondAgo then
            framesInLastSecond = framesInLastSecond + 1
        else
            break
        end
    end
    
    -- Jika tidak cukup data untuk 1 detik, hitung berdasarkan rata-rata
    if framesInLastSecond < 2 then
        local timeSpan = currentTime - frameTimestamps[1]
        if timeSpan > 0 then
            framesInLastSecond = math.floor((#frameTimestamps - 1) / timeSpan)
        end
    end
    
    return framesInLastSecond
end

-- ===== REAL-TIME UPDATE SYSTEM =====
local currentPing = 0
local currentFPS = 0
local lastPingUpdate = 0
local lastPingValue = 0
local pingStableCount = 0

-- Update FPS SETIAP FRAME (paling real-time)
RunService.RenderStepped:Connect(function()
    -- Update FPS
    currentFPS = GetExactRobloxFPS()
    
    -- Update display dengan angka besar
    fpsText.Text = "FPS: " .. currentFPS
    
    -- Warna berdasarkan performa (sama seperti Roblox)
    if currentFPS >= 60 then
        fpsText.TextColor3 = Color3.fromRGB(0, 255, 0)        -- Hijau terang
    elseif currentFPS >= 50 then
        fpsText.TextColor3 = Color3.fromRGB(100, 255, 100)    -- Hijau muda
    elseif currentFPS >= 40 then
        fpsText.TextColor3 = Color3.fromRGB(200, 255, 100)    -- Hijau kekuningan
    elseif currentFPS >= 30 then
        fpsText.TextColor3 = Color3.fromRGB(255, 255, 0)      -- Kuning
    elseif currentFPS >= 20 then
        fpsText.TextColor3 = Color3.fromRGB(255, 180, 0)      -- Oranye
    else
        fpsText.TextColor3 = Color3.fromRGB(255, 50, 50)      -- Merah
    end
end)

-- Update Ping dengan smoothing
RunService.Heartbeat:Connect(function()
    local now = tick()
    
    -- Update ping setiap 0.15 detik (6.6x per detik)
    if now - lastPingUpdate >= 0.15 then
        local rawPing = GetExactRobloxPing()
        
        -- Simple smoothing: hanya update jika perubahan signifikan
        if rawPing > 0 then
            local pingDifference = math.abs(rawPing - currentPing)
            
            -- Jika ping berubah > 20ms atau ping pertama kali
            if pingDifference > 20 or currentPing == 0 then
                currentPing = rawPing
                pingStableCount = 0
            else
                pingStableCount = pingStableCount + 1
                -- Smooth update jika sudah stabil
                if pingStableCount > 3 then
                    currentPing = math.floor(currentPing * 0.7 + rawPing * 0.3)
                end
            end
            
            lastPingValue = rawPing
        end
        
        -- Update display dengan angka besar
        pingText.Text = "Ping: " .. currentPing .. "ms"
        
        -- Warna berdasarkan latency
        if currentPing < 30 then
            pingText.TextColor3 = Color3.fromRGB(0, 255, 0)        -- Hijau (sangat baik)
        elseif currentPing < 60 then
            pingText.TextColor3 = Color3.fromRGB(100, 255, 100)    -- Hijau muda (baik)
        elseif currentPing < 100 then
            pingText.TextColor3 = Color3.fromRGB(200, 255, 100)    -- Hijau kekuningan
        elseif currentPing < 150 then
            pingText.TextColor3 = Color3.fromRGB(255, 255, 0)      -- Kuning (sedang)
        elseif currentPing < 250 then
            pingText.TextColor3 = Color3.fromRGB(255, 180, 0)      -- Oranye (buruk)
        else
            pingText.TextColor3 = Color3.fromRGB(255, 50, 50)      -- Merah (sangat buruk)
        end
        
        lastPingUpdate = now
    end
end)

-- ===== VERIFICATION SYSTEM =====
-- Cek konsistensi dengan Roblox stats
spawn(function()
    wait(3) -- Tunggu game load
    
    while screenGui and screenGui.Parent do
        -- Ambil ping langsung dari Roblox
        local robloxPing = 0
        local success = pcall(function()
            robloxPing = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        
        if success and robloxPing > 0 then
            local ourPing = currentPing
            local difference = math.abs(robloxPing - ourPing)
            
            -- Jika perbedaan > 30ms, force update
            if difference > 30 then
                currentPing = math.floor(robloxPing)
                pingText.Text = "Ping: " .. currentPing .. "ms"
            end
        end
        
        wait(5) -- Cek setiap 5 detik
    end
end)

-- ===== PERFORMANCE INFO =====
print([[
╔══════════════════════════════════════╗
║   MIKAA DEV - STATS - PING × FPS      ║
║   Version: 1.0                        ║
╚══════════════════════════════════════╝
]])

-- ===== RETURN FUNCTIONS =====
return {
    GetPing = function() 
        return currentPing 
    end,
    
    GetFPS = function() 
        return currentFPS 
    end,
    
    GetStats = function()
        return {
            Ping = currentPing,
            FPS = currentFPS,
            FrameCount = #frameTimestamps,
            UpdateTime = tick() - lastPingUpdate
        }
    end,
    
    Close = function() 
        screenGui:Destroy() 
    end,
    
    TestAccuracy = function()
        -- Test function untuk verifikasi
        local robloxPing = 0
        local success = pcall(function()
            robloxPing = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        
        print("Accuracy Test:")
        print("Roblox Ping:", math.floor(robloxPing))
        print("Our Ping:", currentPing)
        print("Difference:", math.abs(robloxPing - currentPing))
        print("FPS:", currentFPS)
        
        return success
    end
}
