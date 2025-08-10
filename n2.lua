-- ===================================================
-- TRUE INVINCIBILITY FOR ANTARCTIC EXPEDITION
-- Fix: Full damage prevention, no visual-only effect
-- ===================================================
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Hapus sistem damage game
if Character:FindFirstChild("Cold") then
    Character.Cold:Destroy()
end

-- ========== CORE PROTECTION SYSTEM ==========
local function BlockAllDamage()
    -- 1. Block standard humanoid damage
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    
    Humanoid.HealthChanged:Connect(function()
        if Humanoid.Health < Humanoid.MaxHealth then
            Humanoid.Health = Humanoid.MaxHealth
        end
    end)

    -- 2. Block custom cold damage
    if workspace:FindFirstChild("Temperature") then
        workspace.Temperature:Destroy()
    end
    
    -- 3. Hook damage events
    for _, v in ipairs(getgc(true)) do
        if type(v) == "function" and islclosure(v) then
            local constants = getconstants(v)
            if table.find(constants, "DamagePlayer") then
                hookfunction(v, function(...)
                    return nil
                end)
            end
        end
    end

    -- 4. Block remote events
    for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") and remote.Name:match("Damage") then
            remote.OnClientEvent:Connect(function()
                -- Cancel all damage
                Humanoid.Health = Humanoid.MaxHealth
            end)
        end
    end
end

-- ========== ANTI-DEATH MECHANISM ==========
local function PreventDeath()
    -- Always revive if dead
    Humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Dead then
            task.wait(0.5)
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            Humanoid.Health = Humanoid.MaxHealth
        end
    end)

    -- Disable death screen
    if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("DeathGui") then
        game:GetService("Players").LocalPlayer.PlayerGui.DeathGui:Destroy()
    end
end

-- ========== AUTO-RECONNECT SYSTEM ==========
local function CharacterSetup(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    
    -- Wait for game systems to initialize
    task.wait(2)
    
    BlockAllDamage()
    PreventDeath()
    
    -- Reapply anti-cold
    if newChar:FindFirstChild("Cold") then
        newChar.Cold:Destroy()
    end
end

Player.CharacterAdded:Connect(CharacterSetup)

-- ========== VISUAL INDICATOR ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrueInvincibilityIndicator"
ScreenGui.Parent = game:GetService("CoreGui")

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Text = "🛡️ TRUE INVINCIBILITY ACTIVE"
StatusLabel.TextColor3 = Color3.new(0, 1, 0)
StatusLabel.Size = UDim2.new(0, 300, 0, 40)
StatusLabel.Position = UDim2.new(0.5, -150, 0.02, 0)
StatusLabel.BackgroundTransparency = 0.8
StatusLabel.BackgroundColor3 = Color3.new(0, 0, 0)
StatusLabel.Font = Enum.Font.SourceSansBold
StatusLabel.TextSize = 20
StatusLabel.Parent = ScreenGui

-- ========== INITIAL ACTIVATION ==========
BlockAllDamage()
PreventDeath()

-- Force health to max
Humanoid.MaxHealth = 100
Humanoid.Health = 100

-- Notifikasi
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "TRUE INVINCIBILITY",
    Text = "Damage prevention fully active!",
    Duration = 8,
    Icon = "rbxassetid://4458901886"
})
