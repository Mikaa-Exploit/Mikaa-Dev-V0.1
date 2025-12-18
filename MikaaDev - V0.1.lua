-- ============================================
-- [ MIKAADEV TELEPORT & LAUNCH FIX v4.0 ]
-- HANYA TELEPORT + LAUNCH, NO UI RIBET
-- ============================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- SIMPLE CONFIG
local currentTarget = nil
local chaosBoat = nil

print("========================================")
print("MIKAADEV FISHING LAUNCHER v4.0")
print("Simple: Teleport → Launch")
print("========================================")

-- ========== SIMPLE BOAT ==========
local function createSimpleBoat()
    if chaosBoat then chaosBoat:Destroy() end
    
    local boat = Instance.new("Part")
    boat.Name = "MIKAADEV_BOAT"
    boat.Size = Vector3.new(8, 2, 15)
    boat.Material = Enum.Material.Neon
    boat.Color = Color3.fromRGB(255, 0, 0)
    boat.Anchored = false
    boat.CanCollide = true
    boat.Transparency = 0.3
    boat.Parent = workspace
    
    -- Simple seat
    local seat = Instance.new("Seat")
    seat.Size = Vector3.new(3, 1.5, 3)
    seat.CFrame = boat.CFrame * CFrame.new(0, 1.5, -4)
    seat.Parent = boat
    
    -- Simple velocity
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(50000, 50000, 50000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = boat
    
    -- Keep boat floating
    local bodyForce = Instance.new("BodyForce")
    bodyForce.Force = Vector3.new(0, boat:GetMass() * workspace.Gravity * 1.3, 0)
    bodyForce.Parent = boat
    
    print("[MIKAADEV] Boat created!")
    return boat
end

-- ========== TELEPORT TO FISHERMAN ==========
local function teleportToFisherman(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        print("[ERROR] Target not found!")
        return false
    end
    
    if not chaosBoat then
        print("[ERROR] Create boat first!")
        return false
    end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then
        print("[ERROR] Target root not found!")
        return false
    end
    
    -- TELEPORT BOAT DI ATAS TARGET
    chaosBoat.CFrame = targetRoot.CFrame * CFrame.new(0, 20, 0)
    
    -- Effect
    local exp = Instance.new("Explosion")
    exp.Position = targetRoot.Position
    exp.BlastPressure = 100
    exp.BlastRadius = 15
    exp.Parent = workspace
    
    print("[SUCCESS] Teleported to " .. targetPlayer.Name)
    return true
end

-- ========== LAUNCH FISHERMAN HIGH ==========
local function launchFisherman(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        print("[ERROR] Target not found for launch!")
        return false
    end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
    
    if not targetRoot then
        print("[ERROR] Cannot launch, no root part!")
        return false
    end
    
    -- STEP 1: BOAT DROP ON FISHERMAN
    if chaosBoat then
        -- Boat jatuh dari atas ke target
        chaosBoat.CFrame = targetRoot.CFrame * CFrame.new(0, 25, 0)
        task.wait(0.1)
        
        -- Force boat down
        if chaosBoat:FindFirstChild("BodyVelocity") then
            chaosBoat.BodyVelocity.Velocity = Vector3.new(0, -150, 0)
        end
        task.wait(0.2)
    end
    
    -- STEP 2: LAUNCH TARGET HIGH
    local launchPower = math.random(300, 400) -- HIGH POWER
    targetRoot.Velocity = Vector3.new(
        math.random(-15, 15),
        launchPower,  -- VERTICAL LAUNCH
        math.random(-15, 15)
    )
    
    -- STEP 3: SPIN TARGET
    targetRoot.RotVelocity = Vector3.new(
        math.random(-20, 20),
        math.random(-20, 20),
        math.random(-20, 20)
    )
    
    -- STEP 4: STUN TARGET
    if humanoid then
        humanoid.PlatformStand = true
        humanoid.WalkSpeed = 0
        
        -- Remove fishing tools
        for _, tool in pairs(targetPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                tool:Destroy()
            end
        end
        
        task.delay(4, function()
            if humanoid then
                humanoid.PlatformStand = false
                humanoid.WalkSpeed = 16
            end
        end)
    end
    
    -- STEP 5: EXPLOSION EFFECTS
    for i = 1, 3 do
        local exp = Instance.new("Explosion")
        exp.Position = targetRoot.Position + Vector3.new(
            math.random(-5, 5),
            math.random(0, 10),
            math.random(-5, 5)
        )
        exp.BlastPressure = 500
        exp.BlastRadius = 12
        exp.Parent = workspace
        task.wait(0.1)
    end
    
    print("[LAUNCH] " .. targetPlayer.Name .. " LAUNCHED " .. launchPower .. " STUD HIGH!")
    return true
end

-- ========== SIMPLE GUI ==========
local gui = Instance.new("ScreenGui")
gui.Name = "MIKAADEV_SIMPLE"
gui.Parent = player:WaitForChild("PlayerGui")

-- Toggle button
local toggle = Instance.new("TextButton")
toggle.Text = "⛔"
toggle.Size = UDim2.new(0, 45, 0, 45)
toggle.Position = UDim2.new(0, 5, 0.5, 0)
toggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Font = Enum.Font.GothamBlack
toggle.TextSize = 20
toggle.Parent = gui

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.25, 0, 0.4, 0)
frame.Position = UDim2.new(0, 55, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.15
frame.Parent = gui

-- Hide/show UI
local uiVisible = true
toggle.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    frame.Visible = uiVisible
    toggle.Text = uiVisible and "⛔" or "✅"
end)

-- Title
local title = Instance.new("TextLabel")
title.Text = "MIKAADEV"
title.Size = UDim2.new(1, 0, 0.15, 0)
title.TextColor3 = Color3.fromRGB(255, 100, 0)
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.BackgroundTransparency = 1
title.Parent = frame

-- Player list
local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(0.9, 0, 0.35, 0)
list.Position = UDim2.new(0.05, 0, 0.2, 0)
list.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
list.Parent = frame

local function updateList()
    list:ClearAllChildren()
    
    local y = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Text = plr.Name
            btn.Size = UDim2.new(0.9, 0, 0, 25)
            btn.Position = UDim2.new(0.05, 0, 0, y)
            btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.Gotham
            btn.TextScaled = true
            
            btn.MouseButton1Click:Connect(function()
                currentTarget = plr
                print("[TARGET] Selected: " .. plr.Name)
            end)
            
            btn.Parent = list
            y = y + 30
        end
    end
    list.CanvasSize = UDim2.new(0, 0, 0, y)
end

-- Simple buttons
local buttons = {
    {text = "🚤 BOAT", func = function()
        chaosBoat = createSimpleBoat()
        if humanoidRootPart then
            chaosBoat.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -2, -8)
        end
    end},
    
    {text = "🎣 TP & LAUNCH", func = function()
        if not currentTarget then
            print("[ERROR] Select target first!")
            return
        end
        
        if not chaosBoat then
            print("[ERROR] Create boat first!")
            return
        end
        
        -- Teleport dulu
        local teleportSuccess = teleportToFisherman(currentTarget)
        if not teleportSuccess then return end
        
        task.wait(0.3)
        
        -- Launch setelah teleport
        local launchSuccess = launchFisherman(currentTarget)
        if launchSuccess then
            print("[SUCCESS] Target launched successfully!")
        end
    end},
    
    {text = "⚡ AUTO RUSH", func = function(btn)
        if not currentTarget then
            print("[ERROR] Select target first!")
            return
        end
        
        if not chaosBoat then
            print("[ERROR] Create boat first!")
            return
        end
        
        -- Auto loop
        for i = 1, 5 do  -- 5x launch
            teleportToFisherman(currentTarget)
            task.wait(0.2)
            launchFisherman(currentTarget)
            task.wait(1.5)
        end
        
        print("[COMPLETE] Auto rush finished!")
    end}
}

local yPos = 0.6
for i, btnData in ipairs(buttons) do
    local btn = Instance.new("TextButton")
    btn.Text = btnData.text
    btn.Size = UDim2.new(0.9, 0, 0.1, 0)
    btn.Position = UDim2.new(0.05, 0, yPos, 0)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Parent = frame
    
    if i == 3 then
        btn.MouseButton1Click:Connect(function() btnData.func(btn) end)
    else
        btn.MouseButton1Click:Connect(btnData.func)
    end
    
    yPos = yPos + 0.12
end

-- Status
local status = Instance.new("TextLabel")
status.Text = "Status: Ready"
status.Size = UDim2.new(1, 0, 0.1, 0)
status.Position = UDim2.new(0, 0, 0.95, 0)
status.TextColor3 = Color3.fromRGB(0, 255, 0)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.Parent = frame

-- Update status
coroutine.wrap(function()
    while gui.Parent do
        local targetName = currentTarget and currentTarget.Name or "None"
        local boatStatus = chaosBoat and "✅" or "❌"
        status.Text = "Target: " .. targetName .. " | Boat: " .. boatStatus
        task.wait(1)
    end
end)()

-- Auto update list
coroutine.wrap(function()
    while gui.Parent do
        updateList()
        task.wait(2)
    end
end)()

print("[MIKAADEV] =================================")
print("[MIKAADEV] SYSTEM LOADED!")
print("[MIKAADEV] Instructions:")
print("[MIKAADEV] 1. Select target from list")
print("[MIKAADEV] 2. Click BOAT button")
print("[MIKAADEV] 3. Click TP & LAUNCH button")
print("[MIKAADEV] =================================")
print("[MIKAADEV] UI Toggle: Click ⛔ button")
print("[MIKAADEV] =================================")
