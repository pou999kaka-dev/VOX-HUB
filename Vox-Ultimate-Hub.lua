-- ===================== RAYFIELD LOADER =====================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Vox Ultimate Hub",
    LoadingTitle = "Vox Ultimate Hub",
    LoadingSubtitle = "by Pou999kaka02",
    ShowText = "Vox Ultimate Hub",
    Theme = "Default",
    ToggleUIKeybind = "K",
    ConfigurationSaving = {Enabled = true, FolderName = nil, FileName = "VoxUltimateHub"},
    Discord = {Enabled = false},
    KeySystem = true,
    KeySettings = {
        Title = "Vox Ultimate Hub Key",
        Subtitle = "Key System",
        Note = "Insira a key correta para acessar o hub",
        FileName = "VoxKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {
            "Vox-2025",
            "VOX-2025",
            "vox-2025",
            "Vox2025",
            "VOX2025"
        }
    }
})

-- ===================== PLAYER VARIABLES =====================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local TeleportPosition = RootPart.Position
local RemotePosition = RootPart.Position

-- ===================== TABS =====================
local MovementTab = Window:CreateTab("Movement", 4483362458)
local TeleportTab = Window:CreateTab("Teleport", "rewind")
local ESPTab = Window:CreateTab("ESP", 4483362458)

-- ===================== MOVEMENT =====================
-- Super Speed
local SuperSpeed = 16
MovementTab:CreateSlider({
    Name = "Super Speed",
    Range = {16, 500},
    Increment = 10,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "SuperSpeed",
    Callback = function(Value)
        SuperSpeed = Value
        Humanoid.WalkSpeed = SuperSpeed
    end,
})

-- Super Jump
local SuperJump = Humanoid.JumpPower
MovementTab:CreateSlider({
    Name = "Super Jump",
    Range = {50, 500},
    Increment = 10,
    Suffix = "JumpPower",
    CurrentValue = Humanoid.JumpPower,
    Flag = "SuperJump",
    Callback = function(Value)
        SuperJump = Value
        Humanoid.JumpPower = SuperJump
    end,
})

-- Infinite Jump
local InfiniteJumpEnabled = false
MovementTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(Value)
        InfiniteJumpEnabled = Value
    end,
})
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Gravity
local GravityValue = workspace.Gravity
MovementTab:CreateSlider({
    Name = "Gravity",
    Range = {0, 500},
    Increment = 10,
    Suffix = "Gravity",
    CurrentValue = workspace.Gravity,
    Flag = "Gravity",
    Callback = function(Value)
        workspace.Gravity = Value
        GravityValue = Value
    end,
})

-- ===================== TELEPORT TAB =====================
local TeleportSpeed = 50
local RemoteSpeed = 50

-- Função para criar anel animado
local function CreateRing(position, color)
    local ring = Instance.new("Part")
    ring.Anchored = true
    ring.CanCollide = false
    ring.Shape = Enum.PartType.Cylinder
    ring.Material = Enum.Material.Neon
    ring.Color = color
    ring.Size = Vector3.new(6,0.3,6)
    ring.CFrame = CFrame.new(position) * CFrame.Angles(math.rad(90),0,0)
    ring.Parent = Workspace

    -- Animação de rotação
    spawn(function()
        while ring.Parent do
            ring.CFrame = ring.CFrame * CFrame.Angles(0, math.rad(5), 0)
            RunService.RenderStepped:Wait()
        end
    end)

    -- Brilho pulsante
    spawn(function()
        local increment = 0.03
        while ring.Parent do
            ring.Transparency = 0.3 + math.abs(math.sin(tick())*0.3)
            RunService.RenderStepped:Wait()
        end
    end)
    return ring
end

-- Botões de Teleport
TeleportTab:CreateButton({
    Name = "Save Teleport Position",
    Callback = function()
        TeleportPosition = RootPart.Position
        if Workspace:FindFirstChild("TeleportRing") then Workspace.TeleportRing:Destroy() end
        local ring = CreateRing(TeleportPosition, Color3.fromRGB(128,0,255)) -- Roxo
        ring.Name = "TeleportRing"
        Rayfield:Notify({Title="Teleport", Content="Posição salva!", Duration=3})
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to Saved Position",
    Callback = function()
        -- Animação de teleporte
        for i=1,10 do
            RootPart.CFrame = RootPart.CFrame:Lerp(CFrame.new(TeleportPosition), i/10)
            RunService.RenderStepped:Wait()
        end
    end
})

-- Botões de Remote-Controlled (renomeado para Teleport também)
TeleportTab:CreateButton({
    Name = "Save Remote-Controlled Position",
    Callback = function()
        RemotePosition = RootPart.Position
        if Workspace:FindFirstChild("RemoteRing") then Workspace.RemoteRing:Destroy() end
        local ring = CreateRing(RemotePosition, Color3.fromRGB(0,0,0))
        ring.Name = "RemoteRing"
        Rayfield:Notify({Title="Remote", Content="Posição remota salva!", Duration=3})
    end
})

TeleportTab:CreateButton({
    Name = "Move to Remote-Controlled Position",
    Callback = function()
        local direction = (RemotePosition - RootPart.Position).Unit
        local distance = (RemotePosition - RootPart.Position).Magnitude
        while distance > 1 do
            RootPart.CFrame = RootPart.CFrame + direction * (RemoteSpeed * RunService.RenderStepped:Wait())
            distance = (RemotePosition - RootPart.Position).Magnitude
        end
    end
})

-- Sliders de velocidade
TeleportTab:CreateSlider({
    Name = "Teleport Speed",
    Range = {1, 500},
    Increment = 5,
    Suffix = "Speed",
    CurrentValue = 50,
    Flag = "TeleportSpeed",
    Callback = function(Value)
        TeleportSpeed = Value
    end
})

TeleportTab:CreateSlider({
    Name = "Remote Speed",
    Range = {1, 500},
    Increment = 5,
    Suffix = "Speed",
    CurrentValue = 50,
    Flag = "RemoteSpeed",
    Callback = function(Value)
        RemoteSpeed = Value
    end
})

-- ===================== ESP =====================
local ESPEnabled = false
local ESPBoxes = {}
local ESPColor = Color3.fromRGB(255,255,255) -- Branco padrão

ESPTab:CreateColorPicker({
    Name = "ESP Color",
    Color = ESPColor,
    Flag = "ESPColor",
    Callback = function(Value)
        ESPColor = Value
        for _, box in pairs(ESPBoxes) do
            box.Color = ESPColor
        end
    end
})

ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        ESPEnabled = Value
        for _, box in pairs(ESPBoxes) do
            box.Visible = ESPEnabled
        end
    end
})

-- ESP animado
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if not ESPBoxes[player.Name] then
                    local box = Drawing.new("Square")
                    box.Color = ESPColor
                    box.Thickness = 2
                    box.Filled = false
                    box.Size = 20
                    ESPBoxes[player.Name] = box
                end
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                local box = ESPBoxes[player.Name]
                if onScreen then
                    box.Position = Vector2.new(pos.X-10,pos.Y-10)
                    box.Visible = true
                else
                    box.Visible = false
                end
            end
        end
    end
end)
