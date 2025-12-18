-- =================================
-- MIKAADEV DELTA EXECUTOR - FINAL
-- =================================
-- Owner: MikaaDev
-- TestingDevByMikaa


-- Hapus UI lama
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name == "MikaaDevUI" then
        v:Destroy()
    end
end

-- Variabel
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Status Fitur
local Features = {
    Coin = {Enabled = false, Value = 9999},
    Damage = {Enabled = false, Multiplier = 10},
    Health = {Enabled = false, Bonus = 500}
}

-- ========== UI UTAMA ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MikaaDevUI"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 280, 0, 350)
MainFrame.Position = UDim2.new(0, 10, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
MainFrame.BorderColor3 = Color3.fromRGB(0, 100, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
Header.Parent = MainFrame

-- Logo
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 30, 0, 30)
Logo.Position = UDim2.new(0, 5, 0, 5)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://100166477433523"
Logo.Parent = Header

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "MikaaDev Delta"
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 40, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Subtitle
local Subtitle = Instance.new("TextLabel")
Subtitle.Text = "TestingDevByMikaa"
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.new(0, 0, 0, 40)
Subtitle.BackgroundTransparency = 1
Subtitle.TextColor3 = Color3.fromRGB(150, 200, 255)
Subtitle.Font = Enum.Font.Code
Subtitle.TextSize = 10
Subtitle.Parent = MainFrame

-- Tombol Minimize
local MinBtn = Instance.new("TextButton")
MinBtn.Text = "_"
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -60, 0, 8)
MinBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.Parent = Header

-- Tombol Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

-- Container Fitur
local FeaturesFrame = Instance.new("ScrollingFrame")
FeaturesFrame.Size = UDim2.new(1, -10, 1, -70)
FeaturesFrame.Position = UDim2.new(0, 5, 0, 65)
FeaturesFrame.BackgroundTransparency = 1
FeaturesFrame.ScrollBarThickness = 4
FeaturesFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 100, 255)
FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 250)
FeaturesFrame.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = FeaturesFrame

-- ========== FUNGSI BUAT FITUR ==========
local function CreateFeature(name, desc)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 60)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    Frame.BorderSizePixel = 0
    
    -- Nama Fitur
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Text = name
    NameLabel.Size = UDim2.new(0.7, 0, 0, 25)
    NameLabel.Position = UDim2.new(0, 10, 0, 5)
    NameLabel.BackgroundTransparency = 1
    NameLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
    NameLabel.Font = Enum.Font.Gotham
    NameLabel.TextSize = 14
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = Frame
    
    -- Deskripsi
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Text = desc
    DescLabel.Size = UDim2.new(0.7, 0, 0, 20)
    DescLabel.Position = UDim2.new(0, 10, 0, 30)
    DescLabel.BackgroundTransparency = 1
    DescLabel.TextColor3 = Color3.fromRGB(150, 180, 220)
    DescLabel.Font = Enum.Font.Code
    DescLabel.TextSize = 10
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Parent = Frame
    
    -- Tombol ON/OFF
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "Toggle"
    ToggleBtn.Text = "OFF"
    ToggleBtn.Size = UDim2.new(0.25, 0, 0, 30)
    ToggleBtn.Position = UDim2.new(0.75, -5, 0.5, -15)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 12
    ToggleBtn.Parent = Frame
    
    Frame.Parent = FeaturesFrame
    return Frame, ToggleBtn
end

-- ========== FITUR COIN ==========
local CoinFrame, CoinBtn = CreateFeature("COIN", "Set coin to 9999")
CoinBtn.MouseButton1Click:Connect(function()
    Features.Coin.Enabled = not Features.Coin.Enabled
    
    if Features.Coin.Enabled then
        CoinBtn.Text = "ON"
        CoinBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        -- Eksekusi coin hack
        spawn(function()
            while Features.Coin.Enabled do
                -- Cari nilai coin di player
                local stats = LocalPlayer:FindFirstChild("leaderstats") or 
                             LocalPlayer:FindFirstChild("Stats") or
                             LocalPlayer:FindFirstChild("Data")
                
                if stats then
                    for _, child in pairs(stats:GetChildren()) do
                        if child.Name:lower():find("coin") or 
                           child.Name:lower():find("uang") or 
                           child.Name:lower():find("money") then
                            if child:IsA("IntValue") or child:IsA("NumberValue") then
                                child.Value = Features.Coin.Value
                            end
                        end
                    end
                end
                
                -- Auto collect coin di map
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name:lower():find("coin") and obj:IsA("Part") then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
                        end
                    end
                end
                
                wait(0.5)
            end
        end)
    else
        CoinBtn.Text = "OFF"
        CoinBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)

-- ========== FITUR DAMAGE ==========
local DamageFrame, DamageBtn = CreateFeature("DAMAGE", "Katana damage x10")
DamageBtn.MouseButton1Click:Connect(function()
    Features.Damage.Enabled = not Features.Damage.Enabled
    
    if Features.Damage.Enabled then
        DamageBtn.Text = "ON"
        DamageBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        -- Hook damage function
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if method == "FireServer" or method == "InvokeServer" then
                local name = tostring(self):lower()
                if name:find("damage") or name:find("hit") or name:find("attack") then
                    for i, v in ipairs(args) do
                        if type(v) == "number" and v > 0 and v < 1000 then
                            args[i] = v * Features.Damage.Multiplier
                        end
                    end
                end
            end
            
            return oldNamecall(self, unpack(args))
        end)
    else
        DamageBtn.Text = "OFF"
        DamageBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)

-- ========== FITUR HEALTH ==========
local HealthFrame, HealthBtn = CreateFeature("HEALTH", "+500 HP Bonus")
HealthBtn.MouseButton1Click:Connect(function()
    Features.Health.Enabled = not Features.Health.Enabled
    
    if Features.Health.Enabled then
        HealthBtn.Text = "ON"
        HealthBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        local function BoostHealth()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.MaxHealth = humanoid.MaxHealth + Features.Health.Bonus
                    humanoid.Health = humanoid.MaxHealth
                    
                    -- Auto heal
                    humanoid.HealthChanged:Connect(function()
                        if Features.Health.Enabled and humanoid.Health < humanoid.MaxHealth then
                            humanoid.Health = humanoid.MaxHealth
                        end
                    end)
                end
            end
        end
        
        BoostHealth()
        LocalPlayer.CharacterAdded:Connect(BoostHealth)
    else
        HealthBtn.Text = "OFF"
        HealthBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)

-- ========== FITUR SPEED ==========
local SpeedFrame, SpeedBtn = CreateFeature("SPEED", "2x Movement Speed")
SpeedBtn.MouseButton1Click:Connect(function()
    local enabled = SpeedBtn.Text == "OFF"
    
    if enabled then
        SpeedBtn.Text = "ON"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        local function SetSpeed()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 32
                end
            end
        end
        
        SetSpeed()
        LocalPlayer.CharacterAdded:Connect(SetSpeed)
    else
        SpeedBtn.Text = "OFF"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end
end)

-- ========== TOMBOL MINIMIZE/CLOSE ==========
local isMinimized = false
local originalSize = MainFrame.Size
local minimizedSize = UDim2.new(0, 280, 0, 40)

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        MainFrame.Size = minimizedSize
        FeaturesFrame.Visible = false
        Subtitle.Visible = false
        MinBtn.Text = "□"
    else
        MainFrame.Size = originalSize
        FeaturesFrame.Visible = true
        Subtitle.Visible = true
        MinBtn.Text = "_"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ========== HOTKEY ==========
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ========== NOTIFIKASI ==========
print("========================================")
print("MIKAADEV DELTA EXECUTOR LOADED")
print("TestingDevByMikaa")
print("Press RightShift to hide/show UI")
print("========================================")

-- Auto apply jika karakter spawn
LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    -- Re-apply enabled features
    if Features.Health.Enabled then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = humanoid.MaxHealth + Features.Health.Bonus
            humanoid.Health = humanoid.MaxHealth
        end
    end
end)

-- Done
return "MikaaDev Delta Executor by TestingDevByMikaa"
