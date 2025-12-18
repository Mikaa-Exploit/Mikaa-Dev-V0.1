-- ============================================
-- [ MIKAADEV FISH IT! FIXED v2.0 ]
-- FIXED: Chaos button error + Proper threading
-- ============================================

repeat task.wait() until game:IsLoaded()
print("[MIKAADEV] Fish It! Exploit v2.0 Activated!")

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GLOBAL CONTROL VARIABLES
local chaosMode = false
local chaosThread = nil
local exploitActive = true

-- ========== FIXED ROD DESTRUCTION ==========
local function deleteAllFishingRods()
    if not exploitActive then return end
    
    local destroyed = 0
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= player then
            -- Destroy equipped rods
            if target.Character then
                for _, tool in pairs(target.Character:GetChildren()) do
                    if tool:IsA("Tool") then
                        pcall(function() 
                            tool:Destroy()
                            destroyed = destroyed + 1
                        end)
                    end
                end
            end
            
            -- Destroy backpack rods
            local backpack = target:FindFirstChild("Backpack")
            if backpack then
                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        pcall(function() 
                            tool:Destroy()
                            destroyed = destroyed + 1
                        end)
                    end
                end
            end
        end
    end
    
    if destroyed > 0 then
        print("[RODS DESTROYED]", destroyed, "fishing rods deleted")
    end
end

-- ========== FIXED PLAYER LAUNCH ==========
local function launchFishermen()
    if not exploitActive then return end
    
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= player and target.Character then
            local root = target.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = target.Character:FindFirstChild("Humanoid")
            
            if root then
                -- FIXED: Proper physics launch
                pcall(function()
                    root.Velocity = Vector3.new(
                        math.random(-30, 30),
                        math.random(150, 300), -- LAUNCH POWER
                        math.random(-30, 30)
                    )
                    
                    root.RotVelocity = Vector3.new(
                        math.random(-20, 20),
                        math.random(-20, 20),
                        math.random(-20, 20)
                    )
                    
                    -- Unequip fishing rods
                    if humanoid then
                        humanoid:UnequipTools()
                        
                        -- Temporary stun
                        humanoid.PlatformStand = true
                        task.delay(2, function()
                            if humanoid then
                                humanoid.PlatformStand = false
                            end
                        end)
                    end
                    
                    print("[LAUNCHED]", target.Name)
                end)
            end
        end
    end
end

-- ========== FIXED CHAOS LOOP ==========
local function startChaosLoop()
    if chaosThread then
        chaosMode = false
        task.wait(0.2)
    end
    
    chaosMode = true
    print("[CHAOS] Mode activated!")
    
    chaosThread = task.spawn(function()
        while chaosMode and exploitActive do
            -- Execute attacks
            deleteAllFishingRods()
            task.wait(0.5)
            
            launchFishermen()
            task.wait(2.5) -- Interval 3 detik total
            
            -- Update GUI
            if chaosBtn then
                chaosBtn.Text = "🔥 CHAOS: ON"
                chaosBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            end
        end
        
        -- Cleanup when stopped
        chaosThread = nil
        if chaosBtn then
            chaosBtn.Text = "⚡ CHAOS: OFF"
            chaosBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        end
        print("[CHAOS] Mode deactivated!")
    end)
end

local function stopChaosLoop()
    chaosMode = false
    if chaosThread then
        task.cancel(chaosThread)
        chaosThread = nil
    end
end

-- ========== SIMPLE ONE-TIME ATTACK ==========
local function executeNuclearAttack()
    print("[NUCLEAR] Executing one-time attack...")
    
    -- Attack 1: Destroy rods
    deleteAllFishingRods()
    task.wait(0.3)
    
    -- Attack 2: Launch players
    launchFishermen()
    task.wait(0.3)
    
    -- Attack 3: Spam interruption
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= player and target.Character then
            local humanoid = target.Character:FindFirstChild("Humanoid")
            if humanoid then
                pcall(function()
                    for i = 1, 3 do
                        humanoid:UnequipTools()
                        task.wait(0.1)
                    end
                end)
            end
        end
    end
    
    print("[NUCLEAR] Attack completed!")
end

-- ========== FIXED GUI ==========
local gui = Instance.new("ScreenGui")
gui.Name = "MIKAADEV_EXPLOIT_GUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.18, 0, 0.2, 0)
mainFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Text = "🎣 MIKAADEV"
title.Size = UDim2.new(1, 0, 0.3, 0)
title.TextColor3 = Color3.fromRGB(255, 100, 0)
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.BackgroundTransparency = 1
title.Parent = mainFrame

-- Chaos button (FIXED)
chaosBtn = Instance.new("TextButton")
chaosBtn.Name = "ChaosButton"
chaosBtn.Text = "⚡ CHAOS: OFF"
chaosBtn.Size = UDim2.new(0.9, 0, 0.25, 0)
chaosBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
chaosBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
chaosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
chaosBtn.Font = Enum.Font.GothamBold
chaosBtn.TextScaled = true
chaosBtn.Parent = mainFrame

-- Nuclear attack button
local nuclearBtn = Instance.new("TextButton")
nuclearBtn.Text = "💥 NUCLEAR"
nuclearBtn.Size = UDim2.new(0.9, 0, 0.25, 0)
nuclearBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
nuclearBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 200)
nuclearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
nuclearBtn.Font = Enum.Font.GothamBold
nuclearBtn.TextScaled = true
nuclearBtn.Parent = mainFrame

-- Button click handlers (FIXED PROPER BINDING)
chaosBtn.MouseButton1Click:Connect(function()
    if chaosMode then
        stopChaosLoop()
        chaosBtn.Text = "⚡ CHAOS: OFF"
        chaosBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    else
        startChaosLoop()
    end
end)

nuclearBtn.MouseButton1Click:Connect(function()
    executeNuclearAttack()
    nuclearBtn.Text = "✅ EXECUTED"
    task.wait(1)
    nuclearBtn.Text = "💥 NUCLEAR"
end)

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "Status: Ready"
statusLabel.Size = UDim2.new(1, 0, 0.15, 0)
statusLabel.Position = UDim2.new(0, 0, 0.9, 0)
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextScaled = true
statusLabel.Parent = mainFrame

-- Auto status update
task.spawn(function()
    while gui.Parent do
        local status = chaosMode and "CHAOS ACTIVE" or "READY"
        local playerCount = #Players:GetPlayers() - 1
        statusLabel.Text = status .. " | Players: " .. playerCount
        task.wait(1)
    end
end)

-- Auto-execute first attack
task.wait(1)
executeNuclearAttack()

-- Cleanup on player leaving
game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        exploitActive = false
        stopChaosLoop()
        gui:Destroy()
    end
end)

print("[MIKAADEV] ==================================")
print("[MIKAADEV] SYSTEM READY!")
print("[MIKAADEV] GUI loaded with 2 buttons:")
print("[MIKAADEV] 1. ⚡ CHAOS: ON/OFF - Continuous attack")
print("[MIKAADEV] 2. 💥 NUCLEAR - One-time massive attack")
print("[MIKAADEV] ==================================")
print("[MIKAADEV] Auto-executed first nuclear attack!")
print("[MIKAADEV] Check if fishing rods disappeared!")
print("[MIKAADEV] ==================================")
