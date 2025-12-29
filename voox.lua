--// VOX SPEED HUB v2.0 + KEY SYSTEM (FIXED UPDATE)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local defaultSpeed = 16
local savedSpeed = defaultSpeed
local infJumpEnabled = false
local noclipEnabled = false
local espEnabled = false
local savedPos = nil

-- SISTEMA DE SALVAMENTO
local HttpService = game:GetService("HttpService")
local configFileName = "VoxHubConfig.json"

local function saveConfig()
    local config = {
        speed = savedSpeed,
        infJump = infJumpEnabled,
        noclip = noclipEnabled,
        esp = espEnabled
    }
    pcall(function()
        if writefile then
            writefile(configFileName, HttpService:JSONEncode(config))
        end
    end)
end

local function loadConfig()
if savedPos then task.spawn(function() repeat task.wait() until player.Character; pcall(function() createTPVisual(savedPos) end) end) end
    pcall(function()
        if isfile and isfile(configFileName) then
            local data = readfile(configFileName)
            local config = HttpService:JSONDecode(data)
            savedSpeed = config.speed or defaultSpeed
            infJumpEnabled = config.infJump or false
            noclipEnabled = config.noclip or false
            espEnabled = config.esp or false
        end
    end)
end

loadConfig()
if savedPos then task.spawn(function() repeat task.wait() until player.Character; pcall(function() createTPVisual(savedPos) end) end) end


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

-- KEY SYSTEM

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

local keyGui = Instance.new("ScreenGui")
keyGui.Name = "VoxKey"
keyGui.ResetOnSpawn = false
keyGui.Parent = player.PlayerGui

local bg = Instance.new("Frame")
bg.Name = "Background"
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.new(0,0,0)
bg.BackgroundTransparency = 1
bg.Parent = keyGui

local box = Instance.new("Frame")
box.Name = "MainBox"
box.Size = UDim2.new(0,320,0,240)
box.Position = UDim2.new(0.5,0,0.5,0)
box.AnchorPoint = Vector2.new(0.5,0.5)
box.BackgroundColor3 = Color3.fromRGB(20,20,20)
box.BackgroundTransparency = 1
box.Parent = bg

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,20)
corner.Parent = box

local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.Transparency = 1
stroke.Color = WHITE_COLOR
stroke.Parent = box

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
    ColorSequenceKeypoint.new(0.5, Color3.new(0,0,0)),
    ColorSequenceKeypoint.new(1, Color3.new(1,1,1))
}
grad.Parent = stroke

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1,0,0,50)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = ""
keyTitle.Font = Enum.Font.GothamBlack
keyTitle.TextSize = 24
keyTitle.TextColor3 = WHITE_COLOR
keyTitle.TextTransparency = 1
keyTitle.Parent = box

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.8,0,0,40)
keyBox.Position = UDim2.new(0.1,0,0.35,0)
keyBox.PlaceholderText = "Key:"
keyBox.Text = ""
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 16
keyBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
keyBox.TextColor3 = WHITE_COLOR
keyBox.BorderSizePixel = 0
keyBox.TextTransparency = 1
keyBox.Parent = box

local cornerBox = Instance.new("UICorner")
cornerBox.CornerRadius = UDim.new(0,12)
cornerBox.Parent = keyBox

local confirm = Instance.new("TextButton")
confirm.Size = UDim2.new(0.8,0,0,36)
confirm.Position = UDim2.new(0.1,0,0.58,0)
confirm.Text = "CONFIRMAR"
confirm.Font = Enum.Font.GothamBold
confirm.TextSize = 15
confirm.TextColor3 = WHITE_COLOR
confirm.BackgroundColor3 = Color3.fromRGB(40,40,40)
confirm.BorderSizePixel = 0
confirm.TextTransparency = 1
confirm.Parent = box

local cornerBtn = Instance.new("UICorner")
cornerBtn.CornerRadius = UDim.new(0,12)
cornerBtn.Parent = confirm

local getLink = Instance.new("TextButton")
getLink.Size = UDim2.new(0.8,0,0,36)
getLink.Position = UDim2.new(0.1,0,0.78,0)
getLink.Text = "IR PARA KEY"
getLink.Font = Enum.Font.GothamBold
getLink.TextSize = 15
getLink.TextColor3 = WHITE_COLOR
getLink.BackgroundColor3 = BLUE_COLOR
getLink.BorderSizePixel = 0
getLink.TextTransparency = 1
getLink.Parent = box

local cornerLink = Instance.new("UICorner")
cornerLink.CornerRadius = UDim.new(0,12)
cornerLink.Parent = getLink

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
    if not keyGui or not keyGui.Parent then return end
    local boxX = box.AbsolutePosition.X
    local boxY = box.AbsolutePosition.Y
    local boxW = box.AbsoluteSize.X
    local boxH = box.AbsoluteSize.Y
    
    for k = 1, 10 do
        local side = math.random(1, 4)
        local pX, pY
        if side == 1 then pX = math.random(boxX, boxX + boxW); pY = boxY
        elseif side == 2 then pX = boxX + boxW; pY = math.random(boxY, boxY + boxH)
        elseif side == 3 then pX = math.random(boxX, boxX + boxW); pY = boxY + boxH
        else pX = boxX; pY = math.random(boxY, boxY + boxH) end
        
        local particle = Instance.new("Frame")
        particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
        particle.BackgroundColor3 = stroke.Color
        particle.BackgroundTransparency = 0
        particle.AnchorPoint = Vector2.new(0.5, 0.5)
        particle.Position = UDim2.new(0, pX, 0, pY)
        particle.Parent = keyGui
        
        local pCorner = Instance.new("UICorner")
        pCorner.CornerRadius = UDim.new(1, 0)
        pCorner.Parent = particle
        
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
    TweenService:Create(getLink,TweenInfo.new(0.5),{TextTransparency=0}):Play()
    
    task.spawn(function()
        task.wait(0.6)
        typeWrite(keyTitle, "VOX KEY SYSTEM", 0.08)
    end)
end

-- Loop de Animação da Aura (Rotação Contínua)
task.spawn(function()
    local blink = true
    local blinkCounter = 0
    while keyGui and keyGui.Parent do
        grad.Rotation = grad.Rotation + 4
        blinkCounter = blinkCounter + 1
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
    while keyGui and keyGui.Parent do
        spawnKeyParticles()
        task.wait(0.1)
    end
end)

local function shake()
    local originalPos = box.Position
    for i=1,8 do
        box.Position = originalPos + UDim2.new(0,i%2==0 and -6 or 6,0,0)
        task.wait(0.03)
    end
    box.Position = originalPos
end


---

-- HUB


	local tpMarker = nil
	local tpBillboard = nil
	
	local function createTPVisual(pos)
		if tpMarker then tpMarker:Destroy() end
		if tpBillboard then tpBillboard:Destroy() end
		
		-- Círculo Azul (Borda Grossa, Rotativo)
		tpMarker = Instance.new("Part")
		tpMarker.Name = "VoxTPMarker"
		tpMarker.Shape = Enum.PartType.Cylinder
		tpMarker.Size = Vector3.new(0.2, 6, 6)
		tpMarker.CFrame = pos * CFrame.Angles(0, 0, math.rad(90))
		tpMarker.Anchored = true
		tpMarker.CanCollide = false
		tpMarker.Transparency = 0.8
		tpMarker.Color = Color3.fromRGB(0, 170, 255)
		tpMarker.Material = Enum.Material.Neon
		tpMarker.Parent = workspace
		
		local selection = Instance.new("SelectionBox")
		selection.Adornee = tpMarker
		selection.LineThickness = 0.15
		selection.Color3 = Color3.fromRGB(0, 255, 255)
		selection.SurfaceTransparency = 1
		selection.Parent = tpMarker
		
		tpBillboard = Instance.new("BillboardGui")
		tpBillboard.Name = "VoxTPDist"
		tpBillboard.Adornee = tpMarker
		tpBillboard.Size = UDim2.new(0, 150, 0, 50)
		tpBillboard.StudsOffset = Vector3.new(0, 4, 0)
		tpBillboard.AlwaysOnTop = true
		tpBillboard.Parent = tpMarker
		
		local distLabel = Instance.new("TextLabel")
		distLabel.Size = UDim2.new(1, 0, 1, 0)
		distLabel.BackgroundTransparency = 1
		distLabel.Font = Enum.Font.GothamBold
		distLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
		distLabel.TextSize = 18
		distLabel.TextStrokeTransparency = 0
		distLabel.Parent = tpBillboard
		
		task.spawn(function()
			while tpMarker and tpMarker.Parent do
				tpMarker.CFrame = tpMarker.CFrame * CFrame.Angles(0.05, 0, 0)
				local char = player.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					local d = (char.HumanoidRootPart.Position - tpMarker.Position).Magnitude
					distLabel.Text = "distância: " .. math.floor(d)
				end
				task.wait()
			end
		end)
	end
	
	local function showTPSavedMessage()
		local msg = Instance.new("TextLabel")
		msg.Size = UDim2.new(0, 200, 0, 40)
		msg.Position = UDim2.new(0.5, -100, 0, -50)
		msg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		msg.Text = "Posição salva!"
		msg.Font = Enum.Font.GothamBold
		msg.TextSize = 18
		msg.TextColor3 = Color3.fromRGB(0, 255, 0)
		msg.BackgroundTransparency = 1
		msg.TextTransparency = 1
		msg.Parent = player.PlayerGui:FindFirstChild("VoxHub") and player.PlayerGui.VoxHub:FindFirstChild("Frame") or player.PlayerGui:FindFirstChildOfClass("ScreenGui"):FindFirstChildOfClass("Frame")
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 10)
		corner.Parent = msg
		
		TweenService:Create(msg, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
			Position = UDim2.new(0.5, -100, 0, 10),
			BackgroundTransparency = 0.2,
			TextTransparency = 0
		}):Play()
		
		task.wait(1.5)
		
		local fade = TweenService:Create(msg, TweenInfo.new(0.4), {
			Position = UDim2.new(0.5, -100, 0, -50),
			BackgroundTransparency = 1,
			TextTransparency = 1
		})
		fade:Play()
		fade.Completed:Connect(function() msg:Destroy() end)
	end

local function createHub()
	local gui = Instance.new("ScreenGui")
	gui.Name = "VoxHub"
	gui.ResetOnSpawn = false
	gui.Parent = player.PlayerGui
	
	local INSTAGRAM_LINK = "https://www.instagram.com/paopremium15?igsh=MTFqemxsaXE5N3RsMQ=="
	
	local copiedMsg = Instance.new("TextLabel")
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
	copiedMsg.Parent = gui
	
	local cMsgCorner = Instance.new("UICorner")
	cMsgCorner.CornerRadius = UDim.new(0, 10)
	cMsgCorner.Parent = copiedMsg
	
	local function showCopiedAnimation()
		copiedMsg.Visible = true
		TweenService:Create(copiedMsg, TweenInfo.new(0.2), {TextTransparency = 0, BackgroundTransparency = 0.2}):Play()
		task.wait(1)
		TweenService:Create(copiedMsg, TweenInfo.new(0.3), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
		task.wait(0.3)
		copiedMsg.Visible = false
	end

	local function applySpeed(v)
		local char = player.Character or player.CharacterAdded:Wait()
		local hum = char:WaitForChild("Humanoid")
		if hum then hum.WalkSpeed = v end
	end
	
	applySpeed(savedSpeed)
	player.CharacterAdded:Connect(function()
		task.wait(0.5)
		applySpeed(savedSpeed)
	end)
	
	local main = Instance.new("Frame")
	local finalSize = UDim2.new(0,230,0,300)
	main.Size = UDim2.new(0,0,0,0)
	main.Position = UDim2.new(0.5,0,0.5,0)
	main.AnchorPoint = Vector2.new(0.5,0.5)
	main.BackgroundColor3 = Color3.fromRGB(20,20,20)
	main.BorderSizePixel = 0
	main.Active = true
	main.Parent = gui
	
	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0,18)
	mainCorner.Parent = main
	
	TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = finalSize}):Play()
	
	local hubAura = Instance.new("UIStroke")
	hubAura.Thickness = 4
	hubAura.Transparency = 0.25
	hubAura.Parent = main
	
	task.spawn(function()
		while main and main.Parent do
			TweenService:Create(hubAura,TweenInfo.new(2.5),{Color=WHITE_COLOR}):Play()
			task.wait(2.5)
			TweenService:Create(hubAura,TweenInfo.new(2.5),{Color=Color3.new(0,0,0)}):Play()
			task.wait(2.5)
		end
	end)
	
	-- PARTICLE SYSTEM
	local function createParticles(originX, originY, count, color, sizeMult)
		sizeMult = sizeMult or 1
		local container = Instance.new("Frame")
		container.BackgroundTransparency = 1
		container.Size = UDim2.new(0, 1, 0, 1)
		container.Position = UDim2.new(0, originX, 0, originY)
		container.Parent = main
		
		for i = 1, count do
			local p = Instance.new("Frame")
			p.Size = UDim2.new(0, math.random(3, 5) * sizeMult, 0, math.random(3, 5) * sizeMult)
			p.BackgroundColor3 = color
			p.BorderSizePixel = 0
			p.AnchorPoint = Vector2.new(0.5, 0.5)
			p.Position = UDim2.new(0.5, 0, 0.5, 0)
			p.Parent = container
			
			local pc = Instance.new("UICorner")
			pc.CornerRadius = UDim.new(1, 0)
			pc.Parent = p
			
			local angle = math.random() * 2 * math.pi
			local dist = math.random(20, 50) * sizeMult
			local tx = math.cos(angle) * dist
			local ty = math.sin(angle) * dist
			
			TweenService:Create(p, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.new(0.5, tx, 0.5, ty),
				BackgroundTransparency = 1
			}):Play()
		end
		game:GetService("Debris"):AddItem(container, 0.7)
	end

	local topBar = Instance.new("Frame")
	topBar.Size = UDim2.new(1,0,0,42)
	topBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
	topBar.BorderSizePixel = 0
	topBar.Parent = main
	
	local topCorner = Instance.new("UICorner")
	topCorner.CornerRadius = UDim.new(0,18)
	topCorner.Parent = topBar
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1,-80,1,0)
	title.Position = UDim2.new(0,40,0,0)
	title.BackgroundTransparency = 1
	title.Text = "Vox Hub"
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 20
	title.TextColor3 = WHITE_COLOR
	title.TextXAlignment = Enum.TextXAlignment.Center
	title.Parent = topBar
	
	local close = Instance.new("TextButton")
	close.Size = UDim2.new(0,30,0,30)
	close.Position = UDim2.new(1,-35,0.5,-15)
	close.BackgroundColor3 = Color3.fromRGB(35,35,35)
	close.Text = "X"
	close.Font = Enum.Font.GothamBold
	close.TextSize = 14
	close.TextColor3 = WHITE_COLOR
	close.Parent = topBar
	
	local cCorner = Instance.new("UICorner")
	cCorner.CornerRadius = UDim.new(0,8)
	cCorner.Parent = close
	
	-- NOVO BOTÃO INSTAGRAM (CANTO SUPERIOR ESQUERDO)
	local igBtn = Instance.new("TextButton")
	igBtn.Name = "InstagramButton"
	igBtn.Size = UDim2.new(0, 30, 0, 30)
	igBtn.Position = UDim2.new(0, 10, 0.5, -15)
	igBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
	igBtn.Text = "ig"
	igBtn.Font = Enum.Font.GothamBold
	igBtn.TextSize = 14
	igBtn.TextColor3 = Color3.new(1, 1, 1)
	igBtn.Parent = topBar
	
	local igCorner = Instance.new("UICorner")
	igCorner.CornerRadius = UDim.new(1, 0)
	igCorner.Parent = igBtn

	igBtn.MouseButton1Click:Connect(function()
		local originalSize = igBtn.Size
		local originalPos = igBtn.Position
		local clickTween = TweenService:Create(igBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 25, 0, 25),
			Position = UDim2.new(0, 12.5, 0.5, -12.5)
		})
		clickTween:Play()
		clickTween.Completed:Connect(function()
			TweenService:Create(igBtn, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = originalSize,
				Position = originalPos
			}):Play()
		end)

		setclipboard(INSTAGRAM_LINK)
		
		local igCopied = Instance.new("TextLabel")
		igCopied.Size = UDim2.new(0, 180, 0, 35)
		igCopied.Position = UDim2.new(0.5, -90, 0, -50)
		igCopied.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		igCopied.Text = "Link do Instagram copiado!"
		igCopied.Font = Enum.Font.GothamBold
		igCopied.TextSize = 14
		igCopied.TextColor3 = Color3.new(1, 1, 1)
		igCopied.BackgroundTransparency = 1
		igCopied.TextTransparency = 1
		igCopied.Parent = main
		
		local igCopiedCorner = Instance.new("UICorner")
		igCopiedCorner.CornerRadius = UDim.new(0, 10)
		igCopiedCorner.Parent = igCopied
		
		TweenService:Create(igCopied, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, -90, 0, 10),
			BackgroundTransparency = 0.2,
			TextTransparency = 0
		}):Play()
		
		task.wait(1.5)
		
		local fadeOut = TweenService:Create(igCopied, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(0.5, -90, 0, -50),
			BackgroundTransparency = 1,
			TextTransparency = 1
		})
		fadeOut:Play()
		fadeOut.Completed:Connect(function()
			igCopied:Destroy()
		end)
	end)

	-- SPEED CONTROLS
	
	local speedBox = Instance.new("TextBox")
	speedBox.Size = UDim2.new(0.58,0,0,34)
	speedBox.Position = UDim2.new(0.1,0,0,80)
	speedBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
	speedBox.PlaceholderText = "Velocidade 0-1000"
	speedBox.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
	speedBox.Text = tostring(savedSpeed)
	speedBox.Font = Enum.Font.GothamBold
	speedBox.TextSize = 14
	speedBox.TextColor3 = WHITE_COLOR
	speedBox.BorderSizePixel = 0
	speedBox.Parent = main

	
	local resetBtn = Instance.new("TextButton")
	resetBtn.Size = UDim2.new(0.2,0,0,34)
	resetBtn.Position = UDim2.new(0.70,0,0,80)
	resetBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	resetBtn.Text = "🔁"
	resetBtn.Font = Enum.Font.GothamBold
	resetBtn.TextSize = 18
	resetBtn.TextColor3 = WHITE_COLOR
	resetBtn.BorderSizePixel = 0
	resetBtn.Parent = main
	
	local rBtnCorner = Instance.new("UICorner")
	rBtnCorner.CornerRadius = UDim.new(0,12)
	rBtnCorner.Parent = resetBtn
	
	local sBoxCorner = Instance.new("UICorner")
	sBoxCorner.CornerRadius = UDim.new(0,12)
	sBoxCorner.Parent = speedBox

	speedBox.FocusLost:Connect(function(e)
		if e then
			local n = tonumber(speedBox.Text)
			if n and n <= 1000 then
				savedSpeed = n
				applySpeed(n)
				saveConfig()
			end
		end
		speedBox.Text = tostring(savedSpeed)
	end)
	
	resetBtn.MouseButton1Click:Connect(function()
		savedSpeed = defaultSpeed
		speedBox.Text = tostring(defaultSpeed)
		applySpeed(defaultSpeed)
		saveConfig()
		resetBtn.Rotation = 0
		TweenService:Create(resetBtn, TweenInfo.new(0.3,Enum.EasingStyle.Back), {Rotation = 360}):Play()
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
		createParticles(main.Size.X.Offset / 2, main.Size.Y.Offset / 2, 20, state and GREEN_COLOR or RED_COLOR)
	end
	
	-- INF JUMP
	local jumpBtn = Instance.new("TextButton")
	jumpBtn.Size = UDim2.new(0.8,0,0,34)
	jumpBtn.Position = UDim2.new(0.1,0,0,118)
	jumpBtn.Text = "INF PULO: OFF"
	jumpBtn.Font = Enum.Font.GothamBold
	jumpBtn.TextSize = 15
	jumpBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	jumpBtn.TextColor3 = WHITE_COLOR
	jumpBtn.BorderSizePixel = 0
	jumpBtn.Parent = main
	
	local jBtnCorner = Instance.new("UICorner")
	jBtnCorner.CornerRadius = UDim.new(0,12)
	jBtnCorner.Parent = jumpBtn
	
	jumpBtn.MouseButton1Click:Connect(function()
		infJumpEnabled = not infJumpEnabled
		updateButtonColor(jumpBtn, infJumpEnabled)
		saveConfig()
	end)

	UIS.JumpRequest:Connect(function()
		if infJumpEnabled then
			local char = player.Character
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
			end
		end
	end)
	
	-- NOCLIP
	local noclipBtn = Instance.new("TextButton")
	noclipBtn.Size = UDim2.new(0.8,0,0,34)
	noclipBtn.Position = UDim2.new(0.1,0,0,156)
	noclipBtn.Text = "NOCLIP: OFF"
	noclipBtn.Font = Enum.Font.GothamBold
	noclipBtn.TextSize = 15
	noclipBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	noclipBtn.TextColor3 = WHITE_COLOR
	noclipBtn.BorderSizePixel = 0
	noclipBtn.Parent = main
	
	local nBtnCorner = Instance.new("UICorner")
	nBtnCorner.CornerRadius = UDim.new(0,12)
	nBtnCorner.Parent = noclipBtn
	
	noclipBtn.MouseButton1Click:Connect(function()
		noclipEnabled = not noclipEnabled
		updateButtonColor(noclipBtn, noclipEnabled)
		saveConfig()
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
	
	-- ESP
	local espBtn = Instance.new("TextButton")
	espBtn.Size = UDim2.new(0.8,0,0,34)
	espBtn.Position = UDim2.new(0.1,0,0,194)
	espBtn.Text = "ESP: OFF"
	espBtn.Font = Enum.Font.GothamBold
	espBtn.TextSize = 15
	espBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	espBtn.TextColor3 = WHITE_COLOR
	espBtn.BorderSizePixel = 0
	espBtn.Parent = main
	
	local eBtnCorner = Instance.new("UICorner")
	eBtnCorner.CornerRadius = UDim.new(0,12)
	eBtnCorner.Parent = espBtn
	
	local function createESP(p)
		if p == player then return end
		local function addHighlight(char)
			if not espEnabled then return end
			local highlight = char:FindFirstChild("VoxESP") or Instance.new("Highlight")
			highlight.Name = "VoxESP"
			highlight.Adornee = char
			highlight.FillColor = Color3.fromRGB(255, 255, 255)
			highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
			highlight.FillTransparency = 0.5
			highlight.OutlineTransparency = 0
			highlight.Parent = char
			local head = char:WaitForChild("Head", 5)
			if head then
				local billboard = head:FindFirstChild("VoxName") or Instance.new("BillboardGui")
				billboard.Name = "VoxName"
				billboard.Adornee = head
				billboard.Size = UDim2.new(0, 100, 0, 50)
				billboard.StudsOffset = Vector3.new(0, 2, 0)
				billboard.AlwaysOnTop = true
				billboard.Parent = head
				local nameLabel = billboard:FindFirstChild("Label") or Instance.new("TextLabel")
				nameLabel.Name = "Label"
				nameLabel.BackgroundTransparency = 1
				nameLabel.Size = UDim2.new(1, 0, 1, 0)
				nameLabel.Text = p.Name
				nameLabel.Font = Enum.Font.GothamBold
				nameLabel.TextColor3 = WHITE_COLOR
				nameLabel.TextStrokeTransparency = 0
				nameLabel.TextSize = 14
				nameLabel.Parent = billboard
			end
		end
		if p.Character then addHighlight(p.Character) end
		p.CharacterAdded:Connect(addHighlight)
	end
	
	local function removeESP(p)
		if p.Character then
			local highlight = p.Character:FindFirstChild("VoxESP")
			if highlight then highlight:Destroy() end
			local head = p.Character:FindFirstChild("Head")
			if head then
				local billboard = head:FindFirstChild("VoxName")
				if billboard then billboard:Destroy() end
			end
		end
	end
	
	espBtn.MouseButton1Click:Connect(function()
		espEnabled = not espEnabled
		updateButtonColor(espBtn, espEnabled)
		saveConfig()
		if espEnabled then
			for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
		else
			for _, p in ipairs(Players:GetPlayers()) do removeESP(p) end
		end
	end)

	Players.PlayerAdded:Connect(function(p)
		if espEnabled then createESP(p) end
	end)
	
	-- TELEPORTE
	local tpBtn = Instance.new("TextButton")
	tpBtn.Size = UDim2.new(0.8,0,0,34)
	tpBtn.Position = UDim2.new(0.1,0,0,232)
	tpBtn.Text = "SALVAR POSIÇÃO"
	tpBtn.Font = Enum.Font.GothamBold
	tpBtn.TextSize = 15
	tpBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	tpBtn.TextColor3 = WHITE_COLOR
	tpBtn.BorderSizePixel = 0
	tpBtn.Parent = main
	
	local tpCorner = Instance.new("UICorner")
	tpCorner.CornerRadius = UDim.new(0,12)
	tpCorner.Parent = tpBtn
	
	local saveBtn = Instance.new("TextButton")
	saveBtn.Size = UDim2.new(0,0,0,34)
	saveBtn.Position = UDim2.new(0.9,0,0,232)
	saveBtn.AnchorPoint = Vector2.new(1,0)
	saveBtn.Text = "P"
	saveBtn.Font = Enum.Font.GothamBold
	saveBtn.TextSize = 18
	saveBtn.BackgroundColor3 = BLUE_COLOR
	saveBtn.TextColor3 = WHITE_COLOR
	saveBtn.BorderSizePixel = 0
	saveBtn.Visible = false
	saveBtn.Parent = main
	
	local sBtnCorner = Instance.new("UICorner")
	sBtnCorner.CornerRadius = UDim.new(0,12)
	sBtnCorner.Parent = saveBtn
	
	tpBtn.MouseButton1Click:Connect(function()
		if tpBtn.Text == "SALVAR POSIÇÃO" then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				savedPos = char.HumanoidRootPart.CFrame
					pcall(function() createTPVisual(savedPos) end)
					pcall(function() showTPSavedMessage() end)
				createParticles(tpBtn.Position.X.Offset + (tpBtn.Size.X.Offset/2), tpBtn.Position.Y.Offset + (tpBtn.Size.Y.Offset/2), 15, GREEN_COLOR)
				TweenService:Create(tpBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0.65,0,0,34)}):Play()
				task.wait(0.1)
				saveBtn.Visible = true
				TweenService:Create(saveBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0.15,0,0,34)}):Play()
				tpBtn.Text = "TELEPORTE"
			end
		elseif tpBtn.Text == "TELEPORTE" and savedPos then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				char.HumanoidRootPart.CFrame = savedPos
				createParticles(tpBtn.Position.X.Offset + (tpBtn.Size.X.Offset/2), tpBtn.Position.Y.Offset + (tpBtn.Size.Y.Offset/2), 20, BLUE_COLOR)
			end
		end
	end)
	
	saveBtn.MouseButton1Click:Connect(function()
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			savedPos = char.HumanoidRootPart.CFrame
					pcall(function() createTPVisual(savedPos) end)
					pcall(function() showTPSavedMessage() end)
			saveBtn.Rotation = 0
			TweenService:Create(saveBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Rotation = 360}):Play()
			createParticles(saveBtn.Position.X.Offset - (saveBtn.Size.X.Offset/2), saveBtn.Position.Y.Offset + (saveBtn.Size.Y.Offset/2), 8, BLUE_COLOR, 0.5)
		end
	end)
	
	-- FECHAMENTO
	local minimized = false
	local fullSize = finalSize
	local miniSize = UDim2.new(0,230,0,42)
	
	close.MouseButton1Click:Connect(function()
		if minimized then return end
		minimized = true
		for _, v in ipairs(main:GetChildren()) do
			if v:IsA("GuiObject") and v ~= topBar then v.Visible = false end
		end
		local targetPos = main.Position - UDim2.new(0, 0, 0, (fullSize.Y.Offset - miniSize.Y.Offset) / 2)
		TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = miniSize,
			Position = targetPos
		}):Play()
	end)
	
	topBar.InputEnded:Connect(function(i)
		if minimized and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
			minimized = false
			local targetPos = main.Position + UDim2.new(0, 0, 0, (fullSize.Y.Offset - miniSize.Y.Offset) / 2)
			TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = fullSize,
				Position = targetPos
			}):Play()
			task.wait(0.3)
			for _, v in ipairs(main:GetChildren()) do
				if v:IsA("GuiObject") and v ~= topBar then 
					if v == saveBtn and tpBtn.Text ~= "TELEPORTE" then v.Visible = false else v.Visible = true end
				end
			end
		end
	end)

	
	updateButtonColor(jumpBtn, infJumpEnabled)
	updateButtonColor(noclipBtn, noclipEnabled)
	updateButtonColor(espBtn, espEnabled)
	if espEnabled then
		task.spawn(function()
			task.wait(1)
			for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
		end)
	end

	-- CRÉDITOS E VERSÃO
	local versionLabel = Instance.new("TextLabel")
	versionLabel.Size = UDim2.new(0, 50, 0, 20)
	versionLabel.Position = UDim2.new(1, -55, 1, -22)
	versionLabel.BackgroundTransparency = 1
	versionLabel.Text = "V7.0"
	versionLabel.Font = Enum.Font.GothamBold
	versionLabel.TextSize = 12
	versionLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
	versionLabel.TextXAlignment = Enum.TextXAlignment.Right
	versionLabel.Parent = main
	
	local creditsLabel = Instance.new("TextLabel")
	creditsLabel.Size = UDim2.new(0, 150, 0, 20)
	creditsLabel.Position = UDim2.new(0, 10, 1, -22)
	creditsLabel.BackgroundTransparency = 1
	creditsLabel.Text = "by: Pou999kaka02"
	creditsLabel.Font = Enum.Font.GothamBold
	creditsLabel.TextSize = 12
	creditsLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
	creditsLabel.TextXAlignment = Enum.TextXAlignment.Left
	creditsLabel.Parent = main

	-- DRAG SYSTEM
	local dragging, dragStart, startPos = false
	topBar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
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
			local hubX, hubY = main.AbsolutePosition.X, main.AbsolutePosition.Y
			local hubW, hubH = main.AbsoluteSize.X, main.AbsoluteSize.Y
			for k = 1, 6 do
				local side = math.random(1, 4)
				local pX, pY
				if side == 1 then pX = math.random(hubX, hubX + hubW); pY = hubY
				elseif side == 2 then pX = hubX + hubW; pY = math.random(hubY, hubY + hubH)
				elseif side == 3 then pX = math.random(hubX, hubX + hubW); pY = hubY + hubH
				else pX = hubX; pY = math.random(hubY, hubY + hubH) end
				local p = Instance.new("Frame", gui)
				p.Size, p.BackgroundColor3, p.Position = UDim2.new(0, 3, 0, 3), WHITE_COLOR, UDim2.new(0, pX, 0, pY)
				Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
				local a, dist = math.random() * 2 * math.pi, math.random(20, 40)
				TweenService:Create(p, TweenInfo.new(0.3), {Position = UDim2.new(0, pX + math.cos(a) * dist, 0, pY + math.sin(a) * dist), BackgroundTransparency = 1}):Play()
				game:GetService("Debris"):AddItem(p, 0.3)
			end
		end
	end)
	
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			TweenService:Create(hubAura,TweenInfo.new(0.2),{Thickness=4}):Play()
		end
	end)
end

-- Lógica de Key
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
        TweenService:Create(stroke,TweenInfo.new(0.3),{Color=GREEN_COLOR}):Play()
        task.wait(0.4)
        local sI = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        TweenService:Create(box, sI, {Size = UDim2.new(0,0,0,0)}):Play()
        TweenService:Create(keyTitle, sI, {TextSize = 0}):Play()
        task.wait(0.4)
        keyGui:Destroy()
        blur:Destroy()
        createHub()
    else
        TweenService:Create(stroke,TweenInfo.new(0.2),{Color=RED_COLOR}):Play()
        shake()
        task.wait(0.2)
        TweenService:Create(stroke,TweenInfo.new(0.3),{Color=WHITE_COLOR}):Play()
    end
end)
