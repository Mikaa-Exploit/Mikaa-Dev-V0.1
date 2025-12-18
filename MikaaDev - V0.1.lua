-- ============================================
-- [ MIKAADEV FISH IT! DESTROYER PACK v1.0 ]
-- Target: Fish It! by Fish Atelier
-- Executor: Delta (Android)
-- Objective: Delete all fishing rods + Chaos
-- ============================================

repeat task.wait() until game:IsLoaded()
print("[MIKAADEV] Fish It! Nuclear Exploit Activated!")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- GENERATE RANDOM ID UNTUK BYPASS DETECTION
local exploitID = "MIKAADEV_" .. HttpService:GenerateGUID(false):sub(1, 8)
print("[EXPLOIT ID]", exploitID)

-- ========== PHASE 1: RECONNAISSANCE ==========
local function analyzeGame()
    print("[PHASE 1] Analyzing Fish It! structure...")
    
    -- Cari fishing-related objects
    local fishingRemotes = {}
    local fishingTools = {}
    
    for _, obj in pairs(game:GetDescendants()) do
        -- Cari RemoteEvents fishing
        if obj:IsA("RemoteEvent") and (
            obj.Name:lower():find("fish") or 
            obj.Name:lower():find("rod") or
            obj.Name:lower():find("cast") or
            obj.Name:lower():find("catch")
        ) then
            table.insert(fishingRemotes, obj)
            print("[FOUND REMOTE]", obj:GetFullName())
        end
        
        -- Cari fishing tools
        if obj:IsA("Tool") and (
            obj.Name:lower():find("rod") or
            obj.Name:lower():find("fish") or
            obj.Name:lower():find("pole")
        ) then
            table.insert(fishingTools, obj)
            print("[FOUND TOOL]", obj:GetFullName())
        end
    end
    
    return fishingRemotes, fishingTools
end

local remotes, tools = analyzeGame()

-- ========== PHASE 2: REMOTE EVENT HIJACK ==========
local function hijackFishingRemotes()
    print("[PHASE 2] Hijacking fishing remotes...")
    
    for _, remote in pairs(remotes) do
        coroutine.wrap(function()
            pcall(function()
                -- Kirim corrupt data ke server
                for i = 1, 10 do
                    remote:FireServer({
                        Action = "CORRUPT_" .. exploitID,
                        Player = player,
                        Data = string.rep("X", 10000), -- Large data
                        Timestamp = tick(),
                        Fake = true
                    })
                    task.wait(0.05)
                end
                print("[HIJACKED]", remote.Name)
            end)
        end)()
    end
end

-- ========== PHASE 3: FISHING ROD ANNIHILATION ==========
local function deleteAllFishingRods()
    print("[PHASE 3] Deleting ALL fishing rods...")
    
    -- METHOD 1: Direct destruction
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= player and target.Character then
            coroutine.wrap(function()
                -- Destroy equipped rods
                for _, tool in pairs(target.Character:GetChildren()) do
                    if tool:IsA("Tool") then
                        pcall(function() tool:Destroy() end)
                        print("[DESTROYED ROD]", target.Name, tool.Name)
                    end
                end
                
                -- Destroy backpack rods
                if target:FindFirstChild("Backpack") then
                    for _, tool in pairs(target.Backpack:GetChildren()) do
                        if tool:IsA("Tool") then
                            pcall(function() tool:Destroy() end)
                        end
                    end
                end
            end)()
        end
    end
    
    -- METHOD 2: Workspace rod destruction
    for _, tool in pairs(workspace:GetDescendants()) do
        if tool:IsA("Tool") and (
            tool.Name:lower():find("rod") or
            tool.Name:lower():find("fish")
        ) then
            pcall(function() tool:Destroy() end)
        end
    end
end

-- ========== PHASE 4: FISHING INTERRUPTION ==========
local function interruptAllFishing()
    print("[PHASE 4] Interrupting active fishing...")
    
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= player and target.Character then
            coroutine.wrap(function()
                local humanoid = target.Character:FindFirstChild("Humanoid")
                local root = target.Character:FindFirstChild("HumanoidRootPart")
                
                if humanoid and root then
                    -- Interrupt technique 1: Force unequip
                    pcall(function() humanoid:UnequipTools() end)
                    
                    -- Interrupt technique 2: Physics launch
                    pcall(function()
                        root.Velocity = Vector3.new(
                            math.random(-50, 50),
                            math.random(100, 250), -- Launch tinggi
                            math.random(-50, 50)
                        )
                        root.RotVelocity = Vector3.new(
                            math.random(-30, 30),
                            math.random(-30, 30),
                            math.random(-30, 30)
                        )
                    end)
                    
                    -- Interrupt technique 3: Fake catch notification
                    game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                        Text = "[SYSTEM] " .. target.Name .. "'s fishing rod broke!",
                        Color = Color3.fromRGB(255, 0, 0),
                        Font = Enum.Font.SourceSansBold
                    })
                    
                    print("[INTERRUPTED]", target.Name)
                end
            end)()
        end
    end
end

-- ========== PHASE 5: MEMORY OVERLOAD ==========
local function overloadFishingSystem()
    print("[PHASE 5] Overloading fishing system...")
    
    -- Create massive fake fishing data
    for i = 1, 50 do
        coroutine.wrap(function()
            local fakeRod = Instance.new("Tool")
            fakeRod.Name = "CorruptRod_" .. exploitID .. "_" .. i
            fakeRod.Parent = workspace
            
            -- Add heavy data
            for j = 1, 20 do
                local val = Instance.new("StringValue")
                val.Name = "FakeData_" .. j
                val.Value = string.rep("CORRUPT", 1000)
                val.Parent = fakeRod
            end
            
            task.wait(0.1)
            pcall(function() fakeRod:Destroy() end)
        end)()
    end
end

-- ========== PHASE 6: ANTI-REPLACEMENT ==========
local function preventRodReplacement()
    print("[PHASE 6] Preventing rod replacement...")
    
    -- Hook tool added event
    local function onToolAdded(tool)
        if tool:IsA("Tool") and (
            tool.Name:lower():find("rod") or
            tool.Name:lower():find("fish")
        ) then
            task.wait(0.1)
            pcall(function() tool:Destroy() end)
            print("[PREVENTED ROD]", tool.Name)
        end
    end
    
    -- Monitor all players
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= player then
            if target.Character then
                target.Character.ChildAdded:Connect(onToolAdded)
            end
            if target:FindFirstChild("Backpack") then
                target.Backpack.ChildAdded:Connect(onToolAdded)
            end
        end
    end
end

-- ========== MAIN EXECUTION ==========
print("[MIKAADEV] ================================")
print("[MIKAADEV] FISH IT! NUCLEAR EXPLOIT")
print("[MIKAADEV] Target: Fish Atelier Game")
print("[MIKAADEV] Executor: Delta Android")
print("[MIKAADEV] ================================")

-- Execute semua phase
coroutine.wrap(hijackFishingRemotes)()
task.wait(0.5)

coroutine.wrap(deleteAllFishingRods)()
task.wait(0.5)

coroutine.wrap(interruptAllFishing)()
task.wait(0.5)

coroutine.wrap(overloadFishingSystem)()
task.wait(0.5)

coroutine.wrap(preventRodReplacement)()

-- ========== AUTO-REPEAT SYSTEM ==========
local chaosMode = false

local function toggleChaosMode()
    chaosMode = not chaosMode
    
    if chaosMode then
        print("[CHAOS MODE] ACTIVATED - Continuous disruption!")
        
        -- Continuous attack loop
        while chaosMode do
            deleteAllFishingRods()
            interruptAllFishing()
            task.wait(3) -- Attack setiap 3 detik
        end
    else
        print("[CHAOS MODE] DEACTIVATED")
    end
end

-- ========== SIMPLE GUI ==========
local gui = Instance.new("ScreenGui")
gui.Name = exploitID .. "_GUI"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.2, 0, 0.15, 0)
frame.Position = UDim2.new(0.02, 0, 0.02, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Text = "🎣 MIKAADEV 🚤"
title.Size = UDim2.new(1, 0, 0.4, 0)
title.TextColor3 = Color3.fromRGB(255, 50, 50)
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.BackgroundTransparency = 1
title.Parent = frame

local chaosBtn = Instance.new("TextButton")
chaosBtn.Text = "⚡ CHAOS: OFF"
chaosBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
chaosBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
chaosBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
chaosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
chaosBtn.Font = Enum.Font.GothamBold
chaosBtn.TextScaled = true
chaosBtn.Parent = frame

chaosBtn.MouseButton1Click:Connect(function()
    toggleChaosMode()
    chaosBtn.Text = chaosMode and "🔥 CHAOS: ON" or "⚡ CHAOS: OFF"
    chaosBtn.BackgroundColor3 = chaosMode and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

print("[MIKAADEV] ================================")
print("[MIKAADEV] CONTROLS:")
print("[MIKAADEV] 1. Script auto-execute semua attack")
print("[MIKAADEV] 2. Klik CHAOS button buat continuous mode")
print("[MIKAADEV] 3. Fishing rods should be deleted")
print("[MIKAADEV] 4. Players will be launched")
print("[MIKAADEV] ================================")
print("[MIKAADEV] EXPECTED RESULTS:")
print("[MIKAADEV] - All fishing rods disappear")
print("[MIKAADEV] - Players get launched randomly")
print("[MIKAADEV] - Fishing interrupted permanently")
print("[MIKAADEV] ================================")

-- Auto-cleanup notification
task.wait(10)
print("[MIKAADEV] Status: Exploit running...")
print("[MIKAADEV] Monitor chat for 'fishing rod broke' messages!")
