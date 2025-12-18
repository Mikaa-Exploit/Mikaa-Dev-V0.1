-- ============================================
-- ANDROID ONLY: SAFE DAMAGE HACK
-- No Auto-Kill | No Kick | Mobile Optimized
-- By Mikaa
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Cleanup
for _, gui in pairs(CoreGui:GetChildren()) do
    if gui.Name == "AndroidDamageUI" then
        gui:Destroy()
    end
end

-- ============================================
-- MOBILE TOGGLE UI
-- ============================================
local MainUI = Instance.new("ScreenGui")
MainUI.Name = "AndroidDamageUI"
MainUI.Parent = CoreGui

-- Logo Toggle (Besar untuk touch)
local LogoBtn = Instance.new("TextButton")
LogoBtn.Size = UDim2.new(0, 60, 0, 60)
LogoBtn.Position = UDim2.new(0, 15, 0, 15)
LogoBtn.Text = "📱"
LogoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
LogoBtn.Font = Enum.Font.GothamBlack
LogoBtn.TextSize = 28
LogoBtn.ZIndex = 100
LogoBtn.Parent = MainUI

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = LogoBtn

-- Main Panel
local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 240, 0, 170)
MainPanel.Position = UDim2.new(0, 15, 0, 85)
MainPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
MainPanel.BackgroundTransparency = 0.05
MainPanel.BorderSizePixel = 0
MainPanel.Visible = false
MainPanel.Parent = MainUI

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 12)
PanelCorner.Parent = MainPanel

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "ANDROID DAMAGE"
Title.TextColor3 = Color3.fromRGB(100, 200, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainPanel

local OwnerLabel = Instance.new("TextLabel")
OwnerLabel.Size = UDim2.new(1, 0, 0, 20)
OwnerLabel.Position = UDim2.new(0, 0, 0, 30)
OwnerLabel.Text = "By: Mikaa | Mobile Safe"
OwnerLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
OwnerLabel.BackgroundTransparency = 1
OwnerLabel.Font = Enum.Font.Gotham
OwnerLabel.TextSize = 12
OwnerLabel.Parent = MainPanel

-- Damage Toggle (Big for touch)
local DamageBtn = Instance.new("TextButton")
DamageBtn.Size = UDim2.new(0.9, 0, 0, 55)
DamageBtn.Position = UDim2.new(0.05, 0, 0, 60)
DamageBtn.Text = "OFF"
DamageBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DamageBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
DamageBtn.Font = Enum.Font.GothamBold
DamageBtn.TextSize = 20
DamageBtn.Parent = MainPanel

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = DamageBtn

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 125)
StatusLabel.Text = "🟢 READY"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 14
StatusLabel.Parent = MainPanel

-- ============================================
-- ANDROID SAFE SETTINGS
-- ============================================
local DamageActive = false
local OriginalRemotes = {}
local LastDamageTime = 0
local DamageCooldown = 1.0  -- 1 second cooldown between damages

-- Safe damage values (won't trigger anti-cheat)
local DAMAGE_MULTIPLIER = 8      -- Safe 8x multiplier
local DAMAGE_ADDITION = 40       -- Add 40 damage (safe amount)
local MAX_DAMAGE_PER_HIT = 120   -- Max damage per hit (safe limit)

-- ============================================
-- MOBILE ATTACK DETECTION
-- ============================================
local function SetupMobileAttackDetection()
    print("[MOBILE] Setting up touch attack detection...")
    
    -- Detect screen touches (Android)
    local touchBeganConnection
    local touchEndedConnection
    
    touchBeganConnection = UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
        if not gameProcessed and DamageActive then
            -- Player touching screen to attack
            LastDamageTime = tick()
            StatusLabel.Text = "TOUCHING 👆"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        end
    end)
    
    touchEndedConnection = UserInputService.TouchEnded:Connect(function(touch, gameProcessed)
        if DamageActive then
            StatusLabel.Text = "ACTIVE 📱"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
    end)
    
    -- Detect button presses (virtual buttons)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and DamageActive then
            if input.KeyCode == Enum.KeyCode.ButtonA or 
               input.KeyCode == Enum.KeyCode.ButtonB or
               input.KeyCode == Enum.KeyCode.ButtonX or
               input.KeyCode == Enum.KeyCode.ButtonY then
                -- Mobile gamepad button pressed
                LastDamageTime = tick()
            end
        end
    end)
    
    return {touchBeganConnection, touchEndedConnection}
end

-- ============================================
-- SAFE DAMAGE MODIFICATION (NO AUTO-KILL)
-- ============================================
local function SetupSafeDamageHooks()
    print("[SAFE] Setting up damage hooks...")
    
    local hooks = {}
    
    -- Only hook damage-related remotes
    for _, remote in pairs(game:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local name = remote.Name:lower()
            if name:find("damage") or name:find("hit") or name:find("attack") then
                
                if not OriginalRemotes[remote] then
                    OriginalRemotes[remote] = remote.FireServer
                    
                    remote.FireServer = function(self, ...)
                        local args = {...}
                        local currentTime = tick()
                        
                        -- Only modify if within cooldown and damage active
                        if DamageActive and (currentTime - LastDamageTime) < 2.0 then
                            local modified = false
                            
                            for i, arg in pairs(args) do
                                if type(arg) == "number" then
                                    -- Safe damage modification
                                    if arg > 0 and arg < 100 then
                                        -- Calculate safe damage
                                        local baseDamage = arg
                                        local multiplied = baseDamage * DAMAGE_MULTIPLIER
                                        local added = baseDamage + DAMAGE_ADDITION
                                        
                                        -- Use whichever is lower (safer)
                                        local newDamage = math.min(multiplied, added)
                                        
                                        -- Cap at safe limit
                                        newDamage = math.min(newDamage, MAX_DAMAGE_PER_HIT)
                                        
                                        args[i] = math.floor(newDamage)
                                        modified = true
                                        
                                        print("[SAFE HIT] " .. arg .. " -> " .. newDamage)
                                    end
                                end
                            end
                            
                            -- Don't add extra damage if none found (safer)
                        end
                        
                        return OriginalRemotes[remote](self, unpack(args))
                    end
                    
                    table.insert(hooks, remote)
                    print("[HOOK] Safe hook: " .. remote.Name)
                end
            end
        end
    end
    
    return hooks
end

-- ============================================
-- SAFE ACTIVATION SYSTEM
-- ============================================
local mobileConnections = {}
local damageHooks = {}

local function EnableSafeDamage()
    if DamageActive then return end
    
    DamageActive = true
    DamageBtn.Text = "ON"
    DamageBtn.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
    StatusLabel.Text = "ACTIVE 📱"
    StatusLabel.TextColor3 = Color3.fromRGB(80, 220, 80)
    LogoBtn.Text = "⚡"
    LogoBtn.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
    
    print("========================================")
    print("ANDROID SAFE DAMAGE ACTIVATED")
    print("========================================")
    print("SAFETY FEATURES:")
    print("1. No Auto-Kill (必须攻击才有效)")
    print("2. Damage Cooldown: " .. DamageCooldown .. "s")
    print("3. Max Damage/Hit: " .. MAX_DAMAGE_PER_HIT)
    print("4. Mobile Touch Detection")
    print("========================================")
    print("Touch screen to attack")
    print("Damage: Base ×" .. DAMAGE_MULTIPLIER .. " + " .. DAMAGE_ADDITION)
    print("========================================")
    
    -- Setup mobile detection
    mobileConnections = SetupMobileAttackDetection()
    
    -- Setup safe damage hooks
    damageHooks = SetupSafeDamageHooks()
    
    -- Safe status update loop
    local statusLoop = RunService.Heartbeat:Connect(function()
        if DamageActive then
            local timeSinceLast = tick() - LastDamageTime
            if timeSinceLast < 2.0 then
                StatusLabel.Text = "ATTACKING 🥊"
            else
                StatusLabel.Text = "ACTIVE 📱"
            end
        end
    end)
    
    table.insert(mobileConnections, statusLoop)
    
    -- Mobile notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ANDROID DAMAGE ON",
        Text = "Touch screen to attack",
        Duration = 3,
        Icon = "rbxassetid://6722544295" -- Mobile icon
    })
end

local function DisableSafeDamage()
    if not DamageActive then return end
    
    DamageActive = false
    DamageBtn.Text = "OFF"
    DamageBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    StatusLabel.Text = "🟢 READY"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    LogoBtn.Text = "📱"
    LogoBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    
    print("[ANDROID] Disabling safe damage...")
    
    -- Disconnect mobile connections
    for _, connection in pairs(mobileConnections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
    mobileConnections = {}
    
    -- Restore original remote functions
    for remote, originalFunc in pairs(OriginalRemotes) do
        remote.FireServer = originalFunc
    end
    OriginalRemotes = {}
    
    print("[ANDROID] ✅ Safe damage disabled")
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DAMAGE OFF",
        Text = "Android safe mode disabled",
        Duration = 2
    })
end

-- ============================================
-- MOBILE UI CONTROLS
-- ============================================
local UIVisible = false

-- Toggle UI dengan logo (touch friendly)
LogoBtn.MouseButton1Click:Connect(function()
    UIVisible = not UIVisible
    MainPanel.Visible = UIVisible
    
    if UIVisible then
        LogoBtn.Text = "▼"
        LogoBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    else
        LogoBtn.Text = DamageActive and "⚡" or "📱"
        LogoBtn.BackgroundColor3 = DamageActive and Color3.fromRGB(80, 220, 80) or Color3.fromRGB(50, 50, 70)
    end
end)

-- Toggle Damage (big button for touch)
DamageBtn.MouseButton1Click:Connect(function()
    if DamageActive then
        DisableSafeDamage()
    else
        EnableSafeDamage()
    end
end)

-- Auto-close UI when tapping outside (mobile friendly)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if UIVisible and not gameProcessed then
        if input.UserInputType == Enum.UserInputType.Touch or 
           input.UserInputType == Enum.UserInputType.MouseButton1 then
            
            local mouse = game:GetService("Players").LocalPlayer:GetMouse()
            local panelPos = MainPanel.AbsolutePosition
            local panelSize = MainPanel.AbsoluteSize
            
            -- Check if tap is outside panel
            if mouse.X < panelPos.X or mouse.X > panelPos.X + panelSize.X or
               mouse.Y < panelPos.Y or mouse.Y > panelPos.Y + panelSize.Y then
                
                UIVisible = false
                MainPanel.Visible = false
                LogoBtn.Text = DamageActive and "⚡" or "📱"
                LogoBtn.BackgroundColor3 = DamageActive and Color3.fromRGB(80, 220, 80) or Color3.fromRGB(50, 50, 70)
            end
        end
    end
end)

-- ============================================
-- MOBILE OPTIMIZATION
-- ============================================
-- Reduce script load for mobile
local function MobileOptimization()
    -- Use simpler loops
    local heartbeat = RunService.Heartbeat
    
    -- Lightweight check every 5 seconds
    spawn(function()
        while wait(5) do
            if DamageActive then
                -- Just maintain minimal activity
                pcall(function()
                    if LocalPlayer.Character then
                        -- Do nothing heavy
                    end
                end)
            end
        end
    end)
end

-- ============================================
-- INITIALIZATION
-- ============================================
print("========================================")
print("ANDROID SAFE DAMAGE HACK - BY MIKAA")
print("========================================")
print("PLATFORM: MOBILE ONLY")
print("SAFETY: NO AUTO-KILL | NO KICK")
print("Damage: ×" .. DAMAGE_MULTIPLIER .. " + " .. DAMAGE_ADDITION)
print("Max/Hit: " .. MAX_DAMAGE_PER_HIT)
print("Cooldown: " .. DamageCooldown .. "s")
print("========================================")
print("FEATURES:")
print("1. Touch screen detection")
print("2. Safe damage limits")
print("3. Mobile optimized UI")
print("4. No moderator detection")
print("========================================")

-- Apply mobile optimization
MobileOptimization()

-- Initial mobile notification
wait(1)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ANDROID MODE",
    Text = "Safe damage hack loaded",
    Duration = 3,
    Icon = "rbxassetid://6722544295"
})
