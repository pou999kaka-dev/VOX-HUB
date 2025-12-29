--// VOX SPEED HUB v2.0 + KEY SYSTEM (FINAL FIXED VERSION)
--// BASEADO NO ARQUIVO ENVIADO PELO USUÁRIO

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local defaultSpeed = 16
local savedSpeed = defaultSpeed
local infJumpEnabled = false
local noclipEnabled = false
local espEnabled = false
local savedPos = nil

-- Múltiplas Keys permitidas
local validKeys = {
    ["VOX-2025"] = true,
    ["Vox-2025"] = true,
    ["vox-2025"] = true
}

local GREEN_COLOR = Color3.fromRGB(0, 255, 0)
local RED_COLOR = Color3.fromRGB(255, 0, 0)
local WHITE_COLOR = Color3.new(1, 1, 1)
local BLUE_COLOR = Color3.fromRGB(0, 120, 255)

-- Proteção contra múltiplos carregamentos
if player.PlayerGui:FindFirstChild("VoxKey") then player.PlayerGui.VoxKey:Destroy() end
if player.PlayerGui:FindFirstChild("VoxHub") then player.PlayerGui.VoxHub:Destroy() end

---

-- FUNÇÕES DE UTILIDADE

local function createAura(parent)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5 -- Aura fina como solicitado
    stroke.Transparency = 0.3
    stroke.Color = WHITE_COLOR
    stroke.Parent = parent
    
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, WHITE_COLOR),
        ColorSequenceKeypoint.new(0.5, Color3.new(0,0,0)),
        ColorSequenceKeypoint.new(1, WHITE_COLOR)
    }
    grad.Parent = stroke
    
    task.spawn(function()
        while stroke and stroke.Parent do
            grad.Rotation = grad.Rotation + 4
            task.wait(0.03)
        end
    end)
    return stroke
end

local function clickEffect(stroke)
    if not stroke then return end
    TweenService:Create(stroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Thickness = 6}):Play()
    task.wait(0.15)
    TweenService:Create(stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Thickness = 1.5}):Play()
end

local function createParticles(originX, originY, count, color, sizeMult, parent, gui)
    local center
    if parent then
        center = parent.AbsolutePosition + parent.AbsoluteSize/2
    else
        center = Vector2.new(originX, originY)
    end
    
    local container = Instance.new("Frame", gui)
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(0, 0, 0, 0)
    container.Position = UDim2.new(0, center.X, 0, center.Y)
    
    local sM = sizeMult or 1
    for i = 1, count do
        local p = Instance.new("Frame", container)
        p.Size = UDim2.new(0, math.random(3, 6) * sM, 0, math.random(3, 6) * sM)
        p.BackgroundColor3 = color or WHITE_COLOR
        p.BackgroundTransparency = 0
        p.AnchorPoint = Vector2.new(0.5, 0.5)
        Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
        
        local a = math.random() * 2 * math.pi
        local d = math.random(50, 120) * sM
        
        TweenService:Create(p, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, math.cos(a) * d, 0, math.sin(a) * d),
            BackgroundTransparency = 1
        }):Play()
        game:GetService("Debris"):AddItem(p, 0.5)
    end
    game:GetService("Debris"):AddItem(container, 0.6)
end

---

-- KEY SYSTEM

local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0

local keyGui = Instance.new("ScreenGui", player.PlayerGui)
keyGui.Name, keyGui.ResetOnSpawn = "VoxKey", false

local bg = Instance.new("Frame", keyGui)
bg.Size, bg.BackgroundColor3, bg.BackgroundTransparency = UDim2.new(1,0,1,0), Color3.new(0,0,0), 1

local box = Instance.new("Frame", bg)
box.Size, box.Position, box.AnchorPoint, box.BackgroundColor3 = UDim2.new(0,320,0,240), UDim2.new(0.5,0,0.5,0), Vector2.new(0.5,0.5), Color3.fromRGB(20,20,20)
box.BackgroundTransparency = 1
Instance.new("UICorner", box).CornerRadius = UDim.new(0,20)
local mainStroke = createAura(box)
mainStroke.Thickness = 3

local keyTitle = Instance.new("TextLabel", box)
keyTitle.Size, keyTitle.BackgroundTransparency, keyTitle.Text = UDim2.new(1,0,0,50), 1, ""
keyTitle.Font, keyTitle.TextSize, keyTitle.TextColor3, keyTitle.TextTransparency = Enum.Font.GothamBlack, 24, WHITE_COLOR, 1

local keyBox = Instance.new("TextBox", box)
keyBox.Size, keyBox.Position, keyBox.PlaceholderText = UDim2.new(0.8,0,0,40), UDim2.new(0.1,0,0.35,0), "Key:"
keyBox.Font, keyBox.TextSize, keyBox.BackgroundColor3, keyBox.TextColor3 = Enum.Font.Gotham, 16, Color3.fromRGB(35,35,35), WHITE_COLOR
keyBox.BorderSizePixel, keyBox.TextTransparency = 0, 1
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0,12)
local keyBoxAura = createAura(keyBox)

local confirm = Instance.new("TextButton", box)
confirm.Size, confirm.Position, confirm.Text = UDim2.new(0.8,0,0,36), UDim2.new(0.1,0,0.58,0), "CONFIRMAR"
confirm.Font, confirm.TextSize, confirm.TextColor3, confirm.BackgroundColor3 = Enum.Font.GothamBold, 15, WHITE_COLOR, Color3.fromRGB(40,40,40)
confirm.BorderSizePixel, confirm.TextTransparency = 0, 1
Instance.new("UICorner", confirm).CornerRadius = UDim.new(0,12)
local confirmAura = createAura(confirm)

local getLink = Instance.new("TextButton", box)
getLink.Size, getLink.Position, getLink.Text = UDim2.new(0.8,0,0,36), UDim2.new(0.1,0,0.78,0), "IR PARA KEY"
getLink.Font, getLink.TextSize, getLink.TextColor3, getLink.BackgroundColor3 = Enum.Font.GothamBold, 15, WHITE_COLOR, BLUE_COLOR
getLink.BorderSizePixel, getLink.TextTransparency = 0, 1
Instance.new("UICorner", getLink).CornerRadius = UDim.new(0,12)

-- Partículas do Key System
task.spawn(function()
    while keyGui and keyGui.Parent do
        local bP, bS = box.AbsolutePosition, box.AbsoluteSize
        for k = 1, 8 do
            local side = math.random(1, 4)
            local pX, pY
            if side == 1 then pX = math.random(bP.X, bP.X + bS.X); pY = bP.Y
            elseif side == 2 then pX = bP.X + bS.X; pY = math.random(bP.Y, bP.Y + bS.Y)
            elseif side == 3 then pX = math.random(bP.X, bP.X + bS.X); pY = bP.Y + bS.Y
            else pX = bP.X; pY = math.random(bP.Y, bP.Y + bS.Y) end
            local p = Instance.new("Frame", keyGui)
            p.Size, p.BackgroundColor3, p.Position = UDim2.new(0, 3, 0, 3), WHITE_COLOR, UDim2.new(0, pX, 0, pY)
            Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
            local a, d = math.random() * 2 * math.pi, math.random(30, 60)
            TweenService:Create(p, TweenInfo.new(0.6), {Position = UDim2.new(0, pX + math.cos(a) * d, 0, pY + math.sin(a) * d), BackgroundTransparency = 1}):Play()
            game:GetService("Debris"):AddItem(p, 0.6)
        end
        task.wait(0.15)
    end
end)

---

-- HUB PRINCIPAL

local function createHub()
	local gui = Instance.new("ScreenGui", player.PlayerGui)
	gui.Name, gui.ResetOnSpawn = "VoxHub", false
	
	local main = Instance.new("Frame", gui)
	local finalSize = UDim2.new(0,230,0,320)
	main.Size, main.Position, main.AnchorPoint, main.BackgroundColor3 = UDim2.new(0,0,0,0), UDim2.new(0.5,0,0.5,0), Vector2.new(0.5,0.5), Color3.fromRGB(20,20,20)
	main.BorderSizePixel, main.Active = 0, true
	Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)
	local hubAura = createAura(main)
	hubAura.Thickness = 4
	
	TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = finalSize}):Play()
	
	-- TOP BAR
	local topBar = Instance.new("Frame", main)
	topBar.Size, topBar.BackgroundTransparency, topBar.Active = UDim2.new(1,0,0,42), 1, true
	local title = Instance.new("TextLabel", topBar)
	title.Size, title.Position, title.BackgroundTransparency, title.Text, title.Font, title.TextSize, title.TextColor3 = UDim2.new(1,0,1,10), UDim2.new(0,0,0,-2), 1, "VOX", Enum.Font.GothamBlack, 40, WHITE_COLOR
	local close = Instance.new("TextButton", topBar)
	close.Size, close.Position, close.BackgroundTransparency, close.Text, close.Font, close.TextSize, close.TextColor3 = UDim2.new(0,26,0,26), UDim2.new(1,-30,0.5,-13), 1, "X", Enum.Font.GothamBold, 20, WHITE_COLOR

	-- BOTÕES
	local resetBtn = Instance.new("TextButton", main)
	resetBtn.Size, resetBtn.Position, resetBtn.BackgroundTransparency, resetBtn.Text, resetBtn.Font, resetBtn.TextSize, resetBtn.TextColor3 = UDim2.new(0,28,0,28), UDim2.new(0.5,-14,0,50), 1, "🔁", Enum.Font.GothamBold, 20, WHITE_COLOR

	local speedBox = Instance.new("TextBox", main)
	speedBox.Size, speedBox.Position, speedBox.PlaceholderText, speedBox.Text = UDim2.new(0.8,0,0,34), UDim2.new(0.1,0,0,80), "Velocidade", tostring(savedSpeed)
	speedBox.Font, speedBox.TextSize, speedBox.BackgroundColor3, speedBox.TextColor3, speedBox.BorderSizePixel = Enum.Font.Gotham, 15, Color3.fromRGB(35,35,35), WHITE_COLOR, 0
	Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0,12)
	local speedAura = createAura(speedBox)

	local jumpBtn = Instance.new("TextButton", main)
	jumpBtn.Size, jumpBtn.Position, jumpBtn.Text, jumpBtn.Font, jumpBtn.TextSize, jumpBtn.BackgroundColor3, jumpBtn.TextColor3, jumpBtn.BorderSizePixel = UDim2.new(0.8,0,0,34), UDim2.new(0.1,0,0,118), "INF PULO: OFF", Enum.Font.GothamBold, 15, Color3.fromRGB(35,35,35), WHITE_COLOR, 0
	Instance.new("UICorner", jumpBtn).CornerRadius = UDim.new(0,12)
	local jumpAura = createAura(jumpBtn)

	local noclipBtn = Instance.new("TextButton", main)
	noclipBtn.Size, noclipBtn.Position, noclipBtn.Text, noclipBtn.Font, noclipBtn.TextSize, noclipBtn.BackgroundColor3, noclipBtn.TextColor3, noclipBtn.BorderSizePixel = UDim2.new(0.8,0,0,34), UDim2.new(0.1,0,0,156), "NOCLIP: OFF", Enum.Font.GothamBold, 15, Color3.fromRGB(35,35,35), WHITE_COLOR, 0
	Instance.new("UICorner", noclipBtn).CornerRadius = UDim.new(0,12)
	local noclipAura = createAura(noclipBtn)

	local espBtn = Instance.new("TextButton", main)
	espBtn.Size, espBtn.Position, espBtn.Text, espBtn.Font, espBtn.TextSize, espBtn.BackgroundColor3, espBtn.TextColor3, espBtn.BorderSizePixel = UDim2.new(0.8,0,0,34), UDim2.new(0.1,0,0,194), "ESP: OFF", Enum.Font.GothamBold, 15, Color3.fromRGB(35,35,35), WHITE_COLOR, 0
	Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0,12)
	local espAura = createAura(espBtn)

	local tpBtn = Instance.new("TextButton", main)
	tpBtn.Size, tpBtn.Position, tpBtn.Text, tpBtn.Font, tpBtn.TextSize, tpBtn.BackgroundColor3, tpBtn.TextColor3, tpBtn.BorderSizePixel = UDim2.new(0.8,0,0,34), UDim2.new(0.1,0,0,232), "SALVAR POSIÇÃO", Enum.Font.GothamBold, 15, Color3.fromRGB(35,35,35), WHITE_COLOR, 0
	Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0,12)
	local tpAura = createAura(tpBtn)

	local saveBtn = Instance.new("TextButton", main)
	saveBtn.Size, saveBtn.Position, saveBtn.AnchorPoint, saveBtn.Text, saveBtn.Font, saveBtn.TextSize, saveBtn.BackgroundColor3, saveBtn.TextColor3, saveBtn.BorderSizePixel, saveBtn.Visible = UDim2.new(0,0,0,34), UDim2.new(0.9,0,0,232), Vector2.new(1,0), "P", Enum.Font.GothamBold, 18, BLUE_COLOR, WHITE_COLOR, 0, false
	Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0,12)

	-- ESP LÓGICA (AUTOMÁTICO COM NOMES)
	local function addESP(p)
		if p == player then return end
		local function setup(char)
			if not espEnabled then return end
			task.wait(0.5)
			local h = char:FindFirstChild("VoxESP") or Instance.new("Highlight", char)
			h.Name, h.FillColor, h.OutlineColor, h.FillTransparency = "VoxESP", WHITE_COLOR, Color3.new(0,0,0), 0.5
			local billboard = char:FindFirstChild("VoxName") or Instance.new("BillboardGui", char)
			billboard.Name, billboard.Size, billboard.AlwaysOnTop, billboard.ExtentsOffset = "VoxName", UDim2.new(0, 200, 0, 50), true, Vector3.new(0, 3, 0)
			local label = billboard:FindFirstChild("Label") or Instance.new("TextLabel", billboard)
			label.Name, label.Size, label.BackgroundTransparency, label.Text, label.Font, label.TextSize, label.TextColor3 = "Label", UDim2.new(1, 0, 1, 0), 1, p.Name, Enum.Font.GothamBold, 14, WHITE_COLOR
		end
		if p.Character then setup(p.Character) end
		p.CharacterAdded:Connect(setup)
	end

	local function removeESP(p)
		if p.Character then
			local h = p.Character:FindFirstChild("VoxESP") if h then h:Destroy() end
			local b = p.Character:FindFirstChild("VoxName") if b then b:Destroy() end
		end
	end

	Players.PlayerAdded:Connect(function(p) if espEnabled then addESP(p) end end)

	-- EVENTOS
	resetBtn.MouseButton1Click:Connect(function()
		task.spawn(function()
			local tween = TweenService:Create(resetBtn, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Rotation = 360})
			tween:Play()
			tween.Completed:Wait()
			resetBtn.Rotation = 0
		end)
		savedSpeed = defaultSpeed
		speedBox.Text = tostring(defaultSpeed)
		local char = player.Character if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = defaultSpeed end
	end)

	jumpBtn.MouseButton1Click:Connect(function()
		infJumpEnabled = not infJumpEnabled
		clickEffect(jumpAura)
		local status = infJumpEnabled and "ON" or "OFF"
		local color = infJumpEnabled and "#00FF00" or "#FF0000"
		jumpBtn.RichText = true
		jumpBtn.Text = "INF PULO: <font color=\""..color.."\">"..status.."</font>"
		createParticles(0,0,15,infJumpEnabled and GREEN_COLOR or RED_COLOR, 1, jumpBtn, gui)
	end)

	UIS.JumpRequest:Connect(function()
		if infJumpEnabled then
			local h = player.Character and player.Character:FindFirstChild("Humanoid")
			if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
		end
	end)

	espBtn.MouseButton1Click:Connect(function()
		espEnabled = not espEnabled
		clickEffect(espAura)
		local status = espEnabled and "ON" or "OFF"
		local color = espEnabled and "#00FF00" or "#FF0000"
		espBtn.RichText = true
		espBtn.Text = "ESP: <font color=\""..color.."\">"..status.."</font>"
		if espEnabled then for _, p in ipairs(Players:GetPlayers()) do addESP(p) end
		else for _, p in ipairs(Players:GetPlayers()) do removeESP(p) end end
	end)

	tpBtn.MouseButton1Click:Connect(function()
		clickEffect(tpAura)
		if tpBtn.Text == "SALVAR POSIÇÃO" then
			local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if root then
				savedPos = root.CFrame
				createParticles(0,0,15,GREEN_COLOR, 1, tpBtn, gui)
				-- Layout sem espaço
				TweenService:Create(tpBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0.65,0,0,34)}):Play()
				task.wait(0.1)
				saveBtn.Visible = true
				TweenService:Create(saveBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0.15,0,0,34)}):Play()
				tpBtn.Text = "TELEPORTE"
			end
		elseif savedPos then
			local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if root then root.CFrame = savedPos createParticles(0,0,20,BLUE_COLOR, 1, tpBtn, gui) end
		end
	end)

	saveBtn.MouseButton1Click:Connect(function()
		task.spawn(function()
			local tween = TweenService:Create(saveBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Rotation = 360})
			tween:Play()
			tween.Completed:Wait()
			saveBtn.Rotation = 0
		end)
		local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if root then
			savedPos = root.CFrame
			-- Partículas azuis menores saindo do botão P
			createParticles(0,0,8,BLUE_COLOR, 0.5, saveBtn, gui)
		end
	end)

	-- FECHAMENTO INVERTIDO (BAIXO PARA CIMA)
	local minimized = false
	close.MouseButton1Click:Connect(function()
		if minimized then return end
		minimized = true
		for _, v in ipairs(main:GetChildren()) do if v:IsA("GuiObject") and v ~= topBar then v.Visible = false end end
		TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0,230,0,42), Position = UDim2.new(0.5,0,0,42)}):Play()
	end)

	topBar.InputEnded:Connect(function(i)
		if minimized and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
			minimized = false
			TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = finalSize, Position = UDim2.new(0.5,0,0.5,0)}):Play()
			task.wait(0.3)
			for _, v in ipairs(main:GetChildren()) do if v:IsA("GuiObject") and v ~= topBar then if v == saveBtn and tpBtn.Text ~= "TELEPORTE" then v.Visible = false else v.Visible = true end end end
		end
	end)

	-- DRAG
	local dragging, dragStart, startPos = false
	topBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging, dragStart, startPos = true, i.Position, main.Position end end)
	topBar.InputChanged:Connect(function(i) if dragging then local d = i.Position - dragStart TweenService:Create(main, TweenInfo.new(0.08), {Position = startPos + UDim2.new(0,d.X,0,d.Y)}):Play() end end)
	UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end

-- INICIALIZAÇÃO DO KEY SYSTEM
local function showKeyPrompt()
    TweenService:Create(bg,TweenInfo.new(0.4),{BackgroundTransparency=0.4}):Play()
    TweenService:Create(blur,TweenInfo.new(0.4),{Size=18}):Play()
    TweenService:Create(box,TweenInfo.new(0.5,Enum.EasingStyle.Back),{BackgroundTransparency=0}):Play()
    TweenService:Create(mainStroke,TweenInfo.new(0.5),{Transparency=0}):Play()
    TweenService:Create(keyTitle,TweenInfo.new(0.5),{TextTransparency=0}):Play()
    TweenService:Create(keyBox,TweenInfo.new(0.5),{TextTransparency=0}):Play()
    TweenService:Create(confirm,TweenInfo.new(0.5),{TextTransparency=0}):Play()
    TweenService:Create(getLink,TweenInfo.new(0.5),{TextTransparency=0}):Play()
    
    task.spawn(function()
        task.wait(0.6)
        local text = "VOX KEY SYSTEM"
        keyTitle.Text = ""
        for i = 1, #text do
            keyTitle.Text = string.sub(text, 1, i)
            task.wait(0.08)
        end
    end)
end

showKeyPrompt()

getLink.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("https://link-target.net/2585620/VIVaDTlBVRVn")
        getLink.Text = "LINK COPIADO!"
        task.wait(1.5)
        getLink.Text = "IR PARA KEY"
    end)
end)

confirm.MouseButton1Click:Connect(function()
    if validKeys[keyBox.Text] then
        clickEffect(confirmAura)
        TweenService:Create(mainStroke,TweenInfo.new(0.3),{Color=GREEN_COLOR}):Play()
        task.wait(0.4)
        local sI = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        TweenService:Create(box, sI, {Size = UDim2.new(0,0,0,0)}):Play()
        task.wait(0.4)
        keyGui:Destroy()
        blur:Destroy()
        createHub()
    else
        clickEffect(confirmAura)
        TweenService:Create(mainStroke,TweenInfo.new(0.2),{Color=RED_COLOR}):Play()
        local o = box.Position
        for i=1,8 do box.Position = o + UDim2.new(0,i%2==0 and -6 or 6,0,0) task.wait(0.03) end
        box.Position = o
        task.wait(0.2)
        TweenService:Create(mainStroke,TweenInfo.new(0.3),{Color=WHITE_COLOR}):Play()
    end
end)
