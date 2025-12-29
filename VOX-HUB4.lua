--// VOX SPEED HUB v2.0 + KEY SYSTEM (MODIFICADO - DELTA-FRIENDLY)

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

-- Múltiplas Keys permitidas
local validKeys = {
    ["VOX-2025"] = true,
    ["Vox-2025"] = true,
    ["vox-2025"] = true
}

local GREEN_COLOR = Color3.fromRGB(0, 255, 0)
local RED_COLOR = Color3.fromRGB(255, 0, 0)
local WHITE_COLOR = Color3.new(1, 1, 1)

---

-- KEY SYSTEM

local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0

local keyGui = Instance.new("ScreenGui", player.PlayerGui)
keyGui.Name = "VoxKey"
keyGui.ResetOnSpawn = false

local bg = Instance.new("Frame", keyGui)
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.new(0,0,0)
bg.BackgroundTransparency = 1

local box = Instance.new("Frame", bg)
box.Size = UDim2.new(0,320,0,200)
box.Position = UDim2.new(0.5,0,0.5,0)
box.AnchorPoint = Vector2.new(0.5,0.5)
box.BackgroundColor3 = Color3.fromRGB(20,20,20)
box.BackgroundTransparency = 1
Instance.new("UICorner", box).CornerRadius = UDim.new(0,20)

local stroke = Instance.new("UIStroke", box)
stroke.Thickness = 3
stroke.Transparency = 1
stroke.Color = WHITE_COLOR

local grad = Instance.new("UIGradient", stroke)
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
    ColorSequenceKeypoint.new(0.5, Color3.new(0,0,0)),
    ColorSequenceKeypoint.new(1, Color3.new(1,1,1))
}

local keyTitle = Instance.new("TextLabel", box)
keyTitle.Size = UDim2.new(1,0,0,50)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "" -- Começa vazio para animação de digitação
keyTitle.Font = Enum.Font.GothamBlack
keyTitle.TextSize = 24
keyTitle.TextColor3 = WHITE_COLOR
keyTitle.TextTransparency = 1

local keyBox = Instance.new("TextBox", box)
keyBox.Size = UDim2.new(0.8,0,0,40)
keyBox.Position = UDim2.new(0.1,0,0.45,0)
keyBox.PlaceholderText = "Key:"
keyBox.Text = ""
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 16
keyBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
keyBox.TextColor3 = WHITE_COLOR
keyBox.BorderSizePixel = 0
keyBox.TextTransparency = 1
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0,12)

local confirm = Instance.new("TextButton", box)
confirm.Size = UDim2.new(0.8,0,0,36)
confirm.Position = UDim2.new(0.1,0,0.7,0)
confirm.Text = "CONFIRMAR"
confirm.Font = Enum.Font.GothamBold
confirm.TextSize = 15
confirm.TextColor3 = WHITE_COLOR
confirm.BackgroundColor3 = Color3.fromRGB(40,40,40)
confirm.BorderSizePixel = 0
confirm.TextTransparency = 1
Instance.new("UICorner", confirm).CornerRadius = UDim.new(0,12)

-- Função de Digitação
local function typeWrite(label, text, delayTime)
    label.Text = ""
    for i = 1, #text do
        label.Text = string.sub(text, 1, i)
        task.wait(delayTime or 0.1)
    end
end

-- Lógica de Partículas
local function spawnKeyParticles()
    local boxX = box.AbsolutePosition.X
    local boxY = box.AbsolutePosition.Y
    local boxW = box.AbsoluteSize.X
    local boxH = box.AbsoluteSize.Y
    
    for k = 1, 15 do
        local side = math.random(1, 4)
        local pX, pY
        if side == 1 then pX = math.random(boxX, boxX + boxW); pY = boxY
        elseif side == 2 then pX = boxX + boxW; pY = math.random(boxY, boxY + boxH)
        elseif side == 3 then pX = math.random(boxX, boxX + boxW); pY = boxY + boxH
        else pX = boxX; pY = math.random(boxY, boxY + boxH) end
        
        local particle = Instance.new("Frame", keyGui)
        particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
        particle.BackgroundColor3 = stroke.Color
        particle.BackgroundTransparency = 0
        particle.AnchorPoint = Vector2.new(0.5, 0.5)
        particle.Position = UDim2.new(0, pX, 0, pY)
        Instance.new("UICorner", particle).CornerRadius = UDim.new(1, 0)
        
        local angle = math.random() * 2 * math.pi
        local distance = math.random(30, 70)
        
        TweenService:Create(particle, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, pX + math.cos(angle) * distance, 0, pY + math.sin(angle) * distance),
            BackgroundTransparency = 1
        }):Play()
        game:GetService("Debris"):AddItem(particle, 0.7)
    end
end

local function showKeyPrompt()
    TweenService:Create(bg,TweenInfo.new(0.4),{BackgroundTransparency=0.4}):Play()
    TweenService:Create(blur,TweenInfo.new(0.4),{Size=18}):Play()
    TweenService:Create(box,TweenInfo.new(0.5,Enum.EasingStyle.Back),{BackgroundTransparency=0}):Play()
    TweenService:Create(stroke,TweenInfo.new(0.5),{Transparency=0}):Play()
    TweenService:Create(keyTitle,TweenInfo.new(0.5),{TextTransparency=0}):Play()
    TweenService:Create(keyBox,TweenInfo.new(0.5),{TextTransparency=0}):Play()
    TweenService:Create(confirm,TweenInfo.new(0.5),{TextTransparency=0}):Play()
    
    task.spawn(function()
        task.wait(0.5)
        typeWrite(keyTitle, "VOX KEY SYSTEM", 0.08)
    end)
end

-- Loop de Animação da Aura (Rotação Contínua)
task.spawn(function()
    local blink = true
    local blinkCounter = 0
    while keyGui.Parent do
        grad.Rotation += 4
        blinkCounter += 1
        if blinkCounter >= 15 then
            blink = not blink
            keyBox.PlaceholderText = blink and "Key:" or "Key "
            blinkCounter = 0
        end
        task.wait(0.03)
    end
end)

-- Loop de Partículas
task.spawn(function()
    while keyGui.Parent do
        spawnKeyParticles()
        task.wait(0.08)
    end
end)

local function shake()
    for i=1,8 do
        box.Position += UDim2.new(0,i%2==0 and -6 or 6,0,0)
        task.wait(0.03)
    end
    box.Position = UDim2.new(0.5,0,0.5,0)
end


---

-- HUB

local function createHub()
	local gui = Instance.new("ScreenGui", player.PlayerGui)
	gui.Name = "VoxHub"
	gui.ResetOnSpawn = false
	
	local INSTAGRAM_LINK = "https://www.instagram.com/paopremium15?igsh=MTFqemxsaXE5N3RsMQ=="
	
	local copiedMsg = Instance.new("TextLabel", gui)
	copiedMsg.Size = UDim2.new(0, 150, 0, 40)
	copiedMsg.Position = UDim2.new(0.5, -75, 0.5, -20)
	copiedMsg.BackgroundTransparency = 1
	copiedMsg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	copiedMsg.Text = "COPIADO!"
	copiedMsg.Font = Enum.Font.GothamBold
	copiedMsg.TextSize = 20
	copiedMsg.TextColor3 = WHITE_COLOR
	copiedMsg.TextTransparency = 1
	copiedMsg.Visible = false
	Instance.new("UICorner", copiedMsg).CornerRadius = UDim.new(0, 10)
	
	local function showCopiedAnimation()
		copiedMsg.Visible = true
		TweenService:Create(copiedMsg, TweenInfo.new(0.2), {TextTransparency = 0, BackgroundTransparency = 0.2}):Play()
		task.wait(1)
		TweenService:Create(copiedMsg, TweenInfo.new(0.3), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
		task.wait(0.3)
		copiedMsg.Visible = false
	end

	local function applySpeed(v)
		local hum = player.Character and player.Character:FindFirstChild("Humanoid")
		if hum then hum.WalkSpeed = v end
	end
	
	if player.Character then applySpeed(savedSpeed) end
	player.CharacterAdded:Connect(function()
		task.wait(0.2)
		applySpeed(savedSpeed)
	end)
	
	local main = Instance.new("Frame", gui)
	local finalSize = UDim2.new(0,230,0,260)
	main.Size = UDim2.new(0,0,0,0)
	main.Position = UDim2.new(0.5,0,0.5,0)
	main.AnchorPoint = Vector2.new(0.5,0.5)
	main.BackgroundColor3 = Color3.fromRGB(20,20,20)
	main.BorderSizePixel = 0
	main.Active = true
	Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)
	
	TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = finalSize}):Play()
	
	local hubAura = Instance.new("UIStroke", main)
	hubAura.Thickness = 4
	hubAura.Transparency = 0.25
	
	task.spawn(function()
		while main.Parent do
			TweenService:Create(hubAura,TweenInfo.new(2.5),{Color=WHITE_COLOR}):Play()
			task.wait(2.5)
			TweenService:Create(hubAura,TweenInfo.new(2.5),{Color=Color3.new(0,0,0)}):Play()
			task.wait(2.5)
		end
	end)
	
	-- PARTICLE SYSTEM
	local function createParticles(originX, originY, count, color)
		local center = main.AbsolutePosition + Vector2.new(originX, originY)
		local container = Instance.new("Frame", gui)
		container.BackgroundTransparency = 1
		container.Size = UDim2.new(0, 0, 0, 0)
		container.Position = UDim2.new(0, center.X, 0, center.Y)
		
		for i = 1, count do
			local particle = Instance.new("Frame", container)
			particle.Size = UDim2.new(0, math.random(3, 6), 0, math.random(3, 6))
			particle.BackgroundColor3 = color or WHITE_COLOR
			particle.BackgroundTransparency = 0
			particle.AnchorPoint = Vector2.new(0.5, 0.5)
			Instance.new("UICorner", particle).CornerRadius = UDim.new(1, 0)
			
			local angle = math.random() * 2 * math.pi
			local distance = math.random(50, 120)
			
			TweenService:Create(particle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.new(0, math.cos(angle) * distance, 0, math.sin(angle) * distance),
				BackgroundTransparency = 1
			}):Play()
			
			game:GetService("Debris"):AddItem(particle, 0.5)
		end
		game:GetService("Debris"):AddItem(container, 0.6)
	end
	
	-- TOP BAR
	local topBar = Instance.new("Frame", main)
	topBar.Size = UDim2.new(1,0,0,42)
	topBar.BackgroundTransparency = 1
	topBar.Active = true
	
	local title = Instance.new("TextLabel", topBar)
	title.Size = UDim2.new(1,0,1,10)
	title.Position = UDim2.new(0,0,0,-2)
	title.BackgroundTransparency = 1
	title.Text = "VOX"
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 40
	title.TextColor3 = WHITE_COLOR
	
	local close = Instance.new("TextButton", topBar)
	close.Size = UDim2.new(0,26,0,26)
	close.Position = UDim2.new(1,-30,0.5,-13)
	close.BackgroundTransparency = 1
	close.Text = "X"
	close.Font = Enum.Font.GothamBold
	close.TextSize = 20
	close.TextColor3 = WHITE_COLOR
	
	-- 🔁 RESET
	local resetBtn = Instance.new("TextButton", main)
	resetBtn.Size = UDim2.new(0,28,0,28)
	resetBtn.Position = UDim2.new(0.5,-14,0,50)
	resetBtn.BackgroundTransparency = 1
	resetBtn.Text = "🔁"
	resetBtn.Font = Enum.Font.GothamBold
	resetBtn.TextSize = 20
	resetBtn.TextColor3 = WHITE_COLOR
	
	-- SPEED BOX
	local speedBox = Instance.new("TextBox", main)
	speedBox.Size = UDim2.new(0.8,0,0,34)
	speedBox.Position = UDim2.new(0.1,0,0,80)
	speedBox.PlaceholderText = "Velocidade (0 - 1000)"
	speedBox.Font = Enum.Font.Gotham
	speedBox.TextSize = 15
	speedBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
	speedBox.TextColor3 = WHITE_COLOR
	speedBox.BorderSizePixel = 0
	speedBox.Text = tostring(savedSpeed)
	Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0,12)
	
	speedBox.FocusLost:Connect(function(e)
		if e then
			local n = tonumber(speedBox.Text)
			if n and n <= 1000 then
				savedSpeed = n
				applySpeed(n)
			else
				speedBox.Text = tostring(savedSpeed)
			end
		end
	end)
	
	resetBtn.MouseButton1Click:Connect(function()
		savedSpeed = defaultSpeed
		speedBox.Text = tostring(defaultSpeed)
		applySpeed(defaultSpeed)
		TweenService:Create(resetBtn, TweenInfo.new(0.3,Enum.EasingStyle.Back), {Rotation = resetBtn.Rotation + 360}):Play()
	end)
	
	-- Função para atualizar a cor do texto ON/OFF com animação
	local function updateButtonColor(button, state)
		local baseText = string.match(button.Text, "(.+): ") or string.gsub(button.Text, ": .*", "")
		local newStatus = state and "ON" or "OFF"
		
		pcall(function()
			button.RichText = true
			local colorHex = state and "#00FF00" or "#FF0000"
			button.Text = baseText .. ": <font color=\"" .. colorHex .. "\">" .. newStatus .. "</font>"
		end)
		
		TweenService:Create(button, TweenInfo.new(0.3), {TextColor3 = WHITE_COLOR}):Play()
		createParticles(main.Size.X.Offset / 2, main.Size.Y.Offset / 2, 30, state and GREEN_COLOR or RED_COLOR)
	end
	
	-- INF JUMP
	local jumpBtn = Instance.new("TextButton", main)
	jumpBtn.Size = UDim2.new(0.8,0,0,34)
	jumpBtn.Position = UDim2.new(0.1,0,0,118)
	jumpBtn.Text = "INF PULO: OFF"
	jumpBtn.Font = Enum.Font.GothamBold
	jumpBtn.TextSize = 15
	jumpBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	jumpBtn.TextColor3 = WHITE_COLOR
	jumpBtn.BorderSizePixel = 0
	Instance.new("UICorner", jumpBtn).CornerRadius = UDim.new(0,12)
	
	jumpBtn.MouseButton1Click:Connect(function()
		infJumpEnabled = not infJumpEnabled
		updateButtonColor(jumpBtn, infJumpEnabled)
	end)
	
	-- NOCLIP BUTTON
	local noclipBtn = Instance.new("TextButton", main)
	noclipBtn.Size = UDim2.new(0.8,0,0,34)
	noclipBtn.Position = UDim2.new(0.1,0,0,156)
	noclipBtn.Text = "NOCLIP: OFF"
	noclipBtn.Font = Enum.Font.GothamBold
	noclipBtn.TextSize = 15
	noclipBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	noclipBtn.TextColor3 = WHITE_COLOR
	noclipBtn.BorderSizePixel = 0
	Instance.new("UICorner", noclipBtn).CornerRadius = UDim.new(0,12)
	
	noclipBtn.MouseButton1Click:Connect(function()
		noclipEnabled = not noclipEnabled
		updateButtonColor(noclipBtn, noclipEnabled)
		
		if noclipEnabled then
			task.spawn(function()
				while noclipEnabled do
					if player.Character then
						for _, part in ipairs(player.Character:GetDescendants()) do
							if part:IsA("BasePart") then part.CanCollide = false end
						end
					end
					task.wait()
				end
			end)
		end
	end)
	
	-- ESP BUTTON
	local espBtn = Instance.new("TextButton", main)
	espBtn.Size = UDim2.new(0.8,0,0,34)
	espBtn.Position = UDim2.new(0.1,0,0,194)
	espBtn.Text = "ESP: OFF"
	espBtn.Font = Enum.Font.GothamBold
	espBtn.TextSize = 15
	espBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	espBtn.TextColor3 = WHITE_COLOR
	espBtn.BorderSizePixel = 0
	Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0,12)
	
	local function createESP(p)
		if p == player then return end
		local function addHighlight(char)
			local highlight = Instance.new("Highlight")
			highlight.Name = "VoxESP"
			highlight.Adornee = char
			highlight.FillColor = Color3.fromRGB(255, 255, 255)
			highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
			highlight.FillTransparency = 0.5
			highlight.OutlineTransparency = 0
			highlight.Parent = char
		end
		if p.Character then addHighlight(p.Character) end
		p.CharacterAdded:Connect(addHighlight)
	end
	
	local function removeESP(p)
		if p.Character then
			local highlight = p.Character:FindFirstChild("VoxESP")
			if highlight then highlight:Destroy() end
		end
	end
	
	espBtn.MouseButton1Click:Connect(function()
		espEnabled = not espEnabled
		updateButtonColor(espBtn, espEnabled)
		if espEnabled then
			for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
		else
			for _, p in ipairs(Players:GetPlayers()) do removeESP(p) end
		end
	end)
	
	Players.PlayerAdded:Connect(function(p)
		if espEnabled then createESP(p) end
	end)
	
	updateButtonColor(jumpBtn, infJumpEnabled)
	updateButtonColor(noclipBtn, noclipEnabled)
	updateButtonColor(espBtn, espEnabled)
	
	UIS.JumpRequest:Connect(function()
		if infJumpEnabled then
			local hum = player.Character and player.Character:FindFirstChild("Humanoid")
			if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
		end
	end)
	
	local version = Instance.new("TextLabel", main)
	version.Size = UDim2.new(0,60,0,16)
	version.Position = UDim2.new(1,-62,1,-20)
	version.BackgroundTransparency = 1
	version.Text = "v2.0"
	version.Font = Enum.Font.Gotham
	version.TextSize = 14
	version.TextColor3 = Color3.fromRGB(160,160,160)
	version.TextXAlignment = Enum.TextXAlignment.Right
	
	local copyBtn = Instance.new("TextButton", main)
	copyBtn.Size = UDim2.new(0, 28, 0, 28)
	copyBtn.Position = UDim2.new(0, 5, 0, 5)
	copyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
	copyBtn.Text = "IG"
	copyBtn.Font = Enum.Font.GothamBold
	copyBtn.TextSize = 16
	copyBtn.TextColor3 = WHITE_COLOR
	copyBtn.BorderSizePixel = 0
	Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(1, 0)
	
	copyBtn.MouseButton1Click:Connect(function()
		TweenService:Create(copyBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(0, 7, 0, 7)}):Play()
		task.wait(0.1)
		TweenService:Create(copyBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 5, 0, 5)}):Play()
		pcall(function() setclipboard(INSTAGRAM_LINK) end)
		showCopiedAnimation()
	end)
	
	local dragging, dragStart, startPos = false
	local minimized = false
	local fullSize = finalSize
	local miniSize = UDim2.new(0,230,0,42)
	
	local function valid(i)
		return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
	end
	
	topBar.InputBegan:Connect(function(i)
		if valid(i) then
			dragging = true
			dragStart = i.Position
			startPos = main.Position
			TweenService:Create(hubAura,TweenInfo.new(0.15),{Thickness=6}):Play()
		end
	end)
	
	topBar.InputChanged:Connect(function(i)
		if dragging then
			local d = i.Position - dragStart
			TweenService:Create(main,TweenInfo.new(0.08),{Position = startPos + UDim2.new(0,d.X,0,d.Y)}):Play()
			
			local hubX = main.AbsolutePosition.X
			local hubY = main.AbsolutePosition.Y
			local hubW = main.AbsoluteSize.X
			local hubH = main.AbsoluteSize.Y
			
			for k = 1, 12 do
				local side = math.random(1, 4)
				local pX, pY
				if side == 1 then pX = math.random(hubX, hubX + hubW); pY = hubY
				elseif side == 2 then pX = hubX + hubW; pY = math.random(hubY, hubY + hubH)
				elseif side == 3 then pX = math.random(hubX, hubX + hubW); pY = hubY + hubH
				else pX = hubX; pY = math.random(hubY, hubY + hubH) end
				
				local particle = Instance.new("Frame", gui)
				particle.Size = UDim2.new(0, 3, 0, 3)
				particle.BackgroundColor3 = WHITE_COLOR
				particle.BackgroundTransparency = 0
				particle.AnchorPoint = Vector2.new(0.5, 0.5)
				particle.Position = UDim2.new(0, pX, 0, pY)
				Instance.new("UICorner", particle).CornerRadius = UDim.new(1, 0)
				
				local angle = math.random() * 2 * math.pi
				local distance = math.random(20, 40)
				
				TweenService:Create(particle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Position = UDim2.new(0, pX + math.cos(angle) * distance, 0, pY + math.sin(angle) * distance),
					BackgroundTransparency = 1
				}):Play()
				game:GetService("Debris"):AddItem(particle, 0.3)
			end
		end
	end)
	
	UIS.InputEnded:Connect(function(i)
		if valid(i) then
			dragging = false
			TweenService:Create(hubAura,TweenInfo.new(0.2),{Thickness=4}):Play()
		end
	end)
	
	close.MouseButton1Click:Connect(function()
		if minimized then return end
		minimized = true
		speedBox.Visible = false
		jumpBtn.Visible = false
		noclipBtn.Visible = false
		espBtn.Visible = false
		resetBtn.Visible = false
		version.Visible = false
		copyBtn.Visible = false
		TweenService:Create(main,TweenInfo.new(0.3,Enum.EasingStyle.Back),{Size = miniSize}):Play()
	end)
	
	topBar.InputEnded:Connect(function(i)
		if minimized and valid(i) then
			minimized = false
			TweenService:Create(main,TweenInfo.new(0.35,Enum.EasingStyle.Back),{Size = fullSize}):Play()
			task.wait(0.25)
			speedBox.Visible = true
			jumpBtn.Visible = true
			noclipBtn.Visible = true
			espBtn.Visible = true
			resetBtn.Visible = true
			version.Visible = true
			copyBtn.Visible = true
		end
	end)
end

-- Lógica de Key
showKeyPrompt()
confirm.MouseButton1Click:Connect(function()
    if validKeys[keyBox.Text] then
        TweenService:Create(stroke,TweenInfo.new(0.3),{Color=GREEN_COLOR}):Play()
        task.wait(0.4)
        
        -- Animação de Saída Coesa (Todos os elementos encolhem juntos)
        local shrinkInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        TweenService:Create(box, shrinkInfo, {Size = UDim2.new(0,0,0,0)}):Play()
        TweenService:Create(keyTitle, shrinkInfo, {TextSize = 0}):Play()
        TweenService:Create(keyBox, shrinkInfo, {Size = UDim2.new(0,0,0,0)}):Pla
