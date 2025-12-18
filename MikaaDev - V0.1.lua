-- ============================================
-- [ MIKAADEV FISHING BLOCKER v3.0 ]
-- Real-time invisible wall system
-- Blocks all fishermen from casting
-- ============================================

repeat task.wait() until game:IsLoaded()
print("[MIKAADEV] Fishing Blocker System Activated!")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- CONTROL VARIABLES
local blockMode = false
local blockThread = nil
local invisibleWalls = {}
local blockedPlayers = {}

-- ========== CREATE INVISIBLE WALL ==========
local function createBlockWall(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return nil end
    
    local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    -- Destroy old wall if exists
    if invisibleWalls[targetPlayer] then
        invisibleWalls[targetPlayer]:Destroy()
        invisibleWalls[targetPlayer] = nil
    end
    
    -- Create invisible wall IN FRONT of fisherman
    local wall = Instance.new("Part")
    wall.Name = "MIKAADEV_BLOCK_WALL_" .. targetPlayer.Name
    wall.Size = Vector3.new(15, 20, 2) -- Lebar, tinggi, tipis
    wall.Transparency = 0.7 -- Semi-transparan biar keliatan
    wall.Color = Color3.fromRGB(255, 0, 0)
    wall.Material = Enum.Material.Neon
    wall.CanCollide = true
    wall.Anchored = true
    wall.CastShadow = false
    
    -- Position wall 5 stud di depan pemancing
    local lookVector = root.CFrame.LookVector
    wall.CFrame = root.CFrame * CFrame.new(0, 0, -8) -- DI DEPAN!
    
    -- Add warning text
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.Parent = wall
    
    local label = Instance.new("TextLabel")
    label.Text = "🚫 NO FISHING! 🚫"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.TextColor3 = Color3.fromRGB(255, 50, 50)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBlack
    label.TextScaled = true
    label.Parent = billboard
    
    wall.Parent = workspace
    invisibleWalls[targetPlayer] = wall
    
    print("[WALL CREATED] Blocking", targetPlayer.Name)
    return wall
end

-- ========== DETECT FISHERMEN ==========
local function detectFishermen()
    local fishermen = {}
    
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= player and target.Character then
            -- Cek apakah lagi pegang fishing rod
            local hasFishingRod = false
            for _, tool in pairs(target.Character:GetChildren()) do
                if tool:IsA("Tool") and (
                    tool.Name:lower():find("rod") or
                    tool.Name:lower():find("fish") or
                    tool.Name:lower():find("pole")
                ) then
                    hasFishingRod = true
                    break
                end
            end
            
            -- Cek di backpack juga
            if not hasFishingRod and target:FindFirstChild("Backpack") then
                for _, tool in pairs(target.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and (
                        tool.Name:lower():find("rod") or
                        tool.Name:lower():find("fish")
                    ) then
                        hasFishingRod = true
                        break
                    end
                end
            end
            
            if hasFishingRod then
                table.insert(fishermen, target)
                blockedPlayers[target] = true
            end
        end
    end
    
    return fishermen
end

-- ========== REAL-TIME BLOCK SYSTEM ==========
local function startBlockSystem()
    if blockThread then
        blockMode = false
        task.wait(0.5)
    end
    
    blockMode = true
    print("[BLOCK SYSTEM] ACTIVATED - Creating invisible walls!")
    
    -- Clear old walls
    for _, wall in pairs(invisibleWalls) do
        wall:Destroy()
    end
    invisibleWalls = {}
    blockedPlayers = {}
    
    blockThread = task.spawn(function()
        while blockMode do
            -- Deteksi semua pemancing
            local fishermen = detectFishermen()
            
            -- Buat wall untuk setiap pemancing
            for _, fisherman in pairs(fishermen) do
                if not invisibleWalls[fisherman] then
                    createBlockWall(fisherman)
                else
                    -- Update wall position
                    local wall = invisibleWalls[fisherman]
                    local root = fisherman.Character:FindFirstChild("HumanoidRootPart")
                    if wall and root then
                        wall.CFrame = root.CFrame * CFrame.new(0, 0, -8)
                    end
                end
            end
            
            -- Hapus wall untuk yang udah gabawa rod
            for target, wall in pairs(invisibleWalls) do
                if not blockedPlayers[target] then
                    wall:Destroy()
                    invisibleWalls[target] = nil
                    print("[WALL REMOVED]", target.Name)
                end
            end
            
            blockedPlayers = {}
            task.wait(0.5) -- Update setiap 0.5 detik
        end
        
        -- Cleanup saat mode dimatikan
        for _, wall in pairs(invisibleWalls) do
            wall:Destroy()
        end
        invisibleWalls = {}
        blockedPlayers = {}
        
        blockThread = nil
        print("[BLOCK SYSTEM] DEACTIVATED")
    end)
end

-- ========== ANTI-CASTING SYSTEM ==========
local function antiCastingSystem()
    -- Monitor rod casting attempts
    local function monitorCasting(target)
        if not target.Character then return end
        
        local humanoid = target.Character:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        -- Intercept tool equip
        target.Character.ChildAdded:Connect(function(tool)
            if tool:IsA("Tool") and blockMode then
                -- Force unequip jika ada wall
                if invisibleWalls[target] then
                    task.wait(0.1)
                    humanoid:UnequipTools()
                    print("[CAST BLOCKED]", target.Name, "tried to equip rod")
                end
            end
        end)
    end
    
    -- Setup monitoring untuk semua player
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= player then
            monitorCasting(target)
        end
    end
    
    Players.PlayerAdded:Connect(function(newPlayer)
        monitorCasting(newPlayer)
    end)
end

-- ========== SIMPLE GUI ==========
local gui = Instance.new("ScreenGui")
gui.Name = "MIKAADEV_BLOCK_GUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.2, 0, 0.15, 0)
frame.Position = UDim2.new(0.02, 0, 0.02, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BackgroundTransparency = 0.2
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Text = "🚫 FISH BLOCKER"
title.Size = UDim2.new(1, 0, 0.35, 0)
title.TextColor3 = Color3.fromRGB(255, 50, 100)
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.BackgroundTransparency = 1
title.Parent = frame

-- Block button
local blockBtn = Instance.new("TextButton")
blockBtn.Name = "BlockButton"
blockBtn.Text = "🚫 BLOCK: OFF"
blockBtn.Size = UDim2.new(0.9, 0, 0.45, 0)
blockBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
blockBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
blockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
blockBtn.Font = Enum.Font.GothamBold
blockBtn.TextScaled = true
blockBtn.Parent = frame

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "Walls: 0 | Fishermen: 0"
statusLabel.Size = UDim2.new(1, 0, 0.2, 0)
statusLabel.Position = UDim2.new(0, 0, 0.85, 0)
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextScaled = true
statusLabel.Parent = frame

-- Button handler
blockBtn.MouseButton1Click:Connect(function()
    if blockMode then
        blockMode = false
        blockBtn.Text = "🚫 BLOCK: OFF"
        blockBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        
        -- Hapus semua wall
        for _, wall in pairs(invisibleWalls) do
            wall:Destroy()
        end
        invisibleWalls = {}
    else
        startBlockSystem()
        blockBtn.Text = "✅ BLOCK: ON"
        blockBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    end
end)

-- Start anti-casting system
antiCastingSystem()

-- Status update thread
task.spawn(function()
    while gui.Parent do
        local wallCount = 0
        for _ in pairs(invisibleWalls) do wallCount = wallCount + 1 end
        
        local fishermen = detectFishermen()
        local fisherCount = #fishermen
        
        statusLabel.Text = string.format("Walls: %d | Fishermen: %d", wallCount, fisherCount)
        task.wait(1)
    end
end)

-- Auto-create test wall for visualization
task.wait(2)
if player.Character then
    local testWall = Instance.new("Part")
    testWall.Name = "TEST_WALL_VISUAL"
    testWall.Size = Vector3.new(10, 10, 1)
    testWall.Transparency = 0.5
    testWall.Color = Color3.fromRGB(255, 0, 0)
    testWall.Material = Enum.Material.Neon
    testWall.CanCollide = true
    testWall.Anchored = true
    testWall.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -10)
    testWall.Parent = workspace
    
    task.wait(3)
    testWall:Destroy()
end

print("[MIKAADEV] ===================================")
print("[MIKAADEV] FISHING BLOCK SYSTEM READY!")
print("[MIKAADEV] ")
print("[MIKAADEV] HOW IT WORKS:")
print("[MIKAADEV] 1. System detects players with fishing rods")
print("[MIKAADEV] 2. Creates RED INVISIBLE WALL in front of them")
print("[MIKAADEV] 3. Wall blocks casting/rod throwing")
print("[MIKAADEV] 4. Real-time tracking (updates every 0.5s)")
print("[MIKAADEV] ")
print("[MIKAADEV] CONTROLS:")
print("[MIKAADEV] Click 🚫 BLOCK button to toggle")
print("[MIKAADEV] ===================================")
print("[MIKAADEV] Expected: Fishermen CANNOT cast rods!")
print("[MIKAADEV] ===================================")
