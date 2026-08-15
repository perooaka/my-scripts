--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- REMOVE GUI DUPLICADA
if player.PlayerGui:FindFirstChild("GPTHub") then
	player.PlayerGui.GPTHub:Destroy()
end

--// VARS
local noclip = false
local fly = false
local esp = false
local speedOn = false
local jumpOn = false
local tpEnabled = false
local dragging = false
local dragStart, startPos
local flyConn

-- AIMBOT
local aimbotOn = false
local selectedTarget = nil
local aimConn
local playerListFrame

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "GPTHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- BOTÃO FLUTUANTE
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(1, -70, 0.5, -30)
toggleBtn.Text = "💙"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextSize = 24
toggleBtn.Parent = gui

-- PAINEL
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 270, 0, 420)
frame.Position = UDim2.new(0.5, -135, 0.5, -210)
frame.Visible = false
frame.Parent = gui

-- GRADIENTE AZUL ESCURO
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 80))
}
gradient.Rotation = 45
gradient.Parent = frame

-- HEADER
local header = Instance.new("TextButton")
header.Size = UDim2.new(1, 0, 0, 30)
header.Text = "GPT Hub"
header.BackgroundColor3 = Color3.fromRGB(0, 0, 50)
header.TextColor3 = Color3.new(1, 1, 1)
header.Parent = frame

-- MINIMIZAR
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 30, 1, 0)
minimize.Position = UDim2.new(1, -30, 0, 0)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(10, 10, 40)
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.Parent = header

local minimized = false

-- FUNÇÃO UI
local function makeBtn(y, text)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 240, 0, 30)
	b.Position = UDim2.new(0, 15, 0, y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Parent = frame
	return b
end

-- BOTÕES
local speedBtn = makeBtn(40, "Speed OFF")
local jumpBtn = makeBtn(80, "Jump OFF")
local noclipBtn = makeBtn(120, "Noclip OFF")
local flyBtn = makeBtn(160, "Fly OFF")
local espBtn = makeBtn(200, "ESP OFF")
local tpBtn = makeBtn(240, "Teleport OFF")
local flingBtn = makeBtn(280, "Fling")
local aimbotBtn = makeBtn(320, "Aimbot OFF")

--// AIMBOT PLAYER LIST
playerListFrame = Instance.new("Frame")
playerListFrame.Size = UDim2.new(0, 240, 0, 70)
playerListFrame.Position = UDim2.new(0, 15, 0, 355)
playerListFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 20)
playerListFrame.Visible = false
playerListFrame.Parent = frame

local selectedLabel = Instance.new("TextLabel")
selectedLabel.Size = UDim2.new(1, 0, 0, 20)
selectedLabel.BackgroundTransparency = 1
selectedLabel.Text = "Alvo: nenhum"
selectedLabel.TextColor3 = Color3.new(1, 1, 1)
selectedLabel.TextSize = 13
selectedLabel.Parent = playerListFrame

local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size = UDim2.new(1, -10, 0, 45)
playerScroll.Position = UDim2.new(0, 5, 0, 22)
playerScroll.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
playerScroll.BorderSizePixel = 0
playerScroll.ScrollBarThickness = 4
playerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
playerScroll.Parent = playerListFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 2)
listLayout.Parent = playerScroll

-- FUNÇÕES BASE
local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHum()
	return getChar():WaitForChild("Humanoid")
end

-- SPEED
speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	getHum().WalkSpeed = speedOn and 100 or 16
	speedBtn.Text = "Speed " .. (speedOn and "ON" or "OFF")
end)

-- JUMP
jumpBtn.MouseButton1Click:Connect(function()
	jumpOn = not jumpOn
	getHum().JumpPower = jumpOn and 120 or 50
	jumpBtn.Text = "Jump " .. (jumpOn and "ON" or "OFF")
end)

-- NOCLIP
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = "Noclip " .. (noclip and "ON" or "OFF")
end)

RunService.Stepped:Connect(function()
	if noclip then
		local char = getChar()

		for _, v in pairs(char:GetChildren()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- FLY
flyBtn.MouseButton1Click:Connect(function()
	fly = not fly
	flyBtn.Text = "Fly " .. (fly and "ON" or "OFF")

	local root = getChar():WaitForChild("HumanoidRootPart")

	if fly then
		local bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bv.Name = "FlyVel"
		bv.Parent = root

		flyConn = RunService.RenderStepped:Connect(function()
			if bv and bv.Parent then
				bv.Velocity =
					workspace.CurrentCamera.CFrame.LookVector * 80
			end
		end)
	else
		if flyConn then
			flyConn:Disconnect()
			flyConn = nil
		end

		if root:FindFirstChild("FlyVel") then
			root.FlyVel:Destroy()
		end
	end
end)

-- ESP
espBtn.MouseButton1Click:Connect(function()
	esp = not esp
	espBtn.Text = "ESP " .. (esp and "ON" or "OFF")

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			if esp then
				if not plr.Character:FindFirstChild("Highlight") then
					local h = Instance.new("Highlight")
					h.Name = "GPTHubHighlight"
					h.FillColor = Color3.fromRGB(0, 150, 255)
					h.Parent = plr.Character
				end
			else
				local highlight = plr.Character:FindFirstChild("GPTHubHighlight")

				if highlight then
					highlight:Destroy()
				end
			end
		end
	end
end)

-- TELEPORT
tpBtn.MouseButton1Click:Connect(function()
	tpEnabled = not tpEnabled
	tpBtn.Text = "Teleport " .. (tpEnabled and "ON" or "OFF")
end)

mouse.Button1Down:Connect(function()
	if tpEnabled then
		local pos = mouse.Hit.Position
		getChar():MoveTo(pos)
	end
end)

-- FLING
flingBtn.MouseButton1Click:Connect(function()
	local root = getChar():WaitForChild("HumanoidRootPart")

	local bv = Instance.new("BodyVelocity")
	bv.Velocity = Vector3.new(0, 200, 0)
	bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bv.Parent = root

	game.Debris:AddItem(bv, 0.3)
end)

--// ATUALIZAR LISTA DE JOGADORES
local function updatePlayerList()
	for _, child in pairs(playerScroll:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	local players = Players:GetPlayers()

	for _, plr in ipairs(players) do
		if plr ~= player then
			local button = Instance.new("TextButton")
			button.Size = UDim2.new(1, -5, 0, 25)
			button.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
			button.TextColor3 = Color3.new(1, 1, 1)
			button.Text = plr.DisplayName .. "  @" .. plr.Name
			button.TextSize = 12
			button.Parent = playerScroll

			button.MouseButton1Click:Connect(function()
				selectedTarget = plr
				selectedLabel.Text = "Alvo: " .. plr.DisplayName

				-- Ativa automaticamente ao selecionar
				aimbotOn = true
				aimbotBtn.Text = "Aimbot ON"
			end)
		end
	end

	playerScroll.CanvasSize =
		UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 5)
end

-- Atualiza quando jogadores entram/saem
Players.PlayerAdded:Connect(function()
	task.wait(0.2)
	updatePlayerList()
end)

Players.PlayerRemoving:Connect(function(plr)
	if selectedTarget == plr then
		selectedTarget = nil
		aimbotOn = false
		aimbotBtn.Text = "Aimbot OFF"
		selectedLabel.Text = "Alvo: nenhum"
	end

	updatePlayerList()
end)

updatePlayerList()

--// AIMBOT / CÂMERA
aimbotBtn.MouseButton1Click:Connect(function()
	aimbotOn = not aimbotOn

	if aimbotOn then
		aimbotBtn.Text = "Aimbot ON"
	else
		aimbotBtn.Text = "Aimbot OFF"

		-- Devolve a câmera ao personagem
		local camera = workspace.CurrentCamera
		camera.CameraType = Enum.CameraType.Custom

		local humanoid = getChar():FindFirstChildOfClass("Humanoid")
		if humanoid then
			camera.CameraSubject = humanoid
		end
	end
end)

-- Abre/fecha lista
local function toggleAimbotList()
	playerListFrame.Visible = not playerListFrame.Visible

	if playerListFrame.Visible then
		updatePlayerList()
	end
end

-- Clique direito no botão abre a lista
aimbotBtn.MouseButton2Click:Connect(function()
	toggleAimbotList()
end)

-- Clicar no Aimbot com botão esquerdo:
-- se não houver alvo, abre a lista
local oldAimbotClick
oldAimbotClick = aimbotBtn.MouseButton1Click:Connect(function()
	if not selectedTarget then
		aimbotOn = false
		aimbotBtn.Text = "Aimbot OFF"
		toggleAimbotList()
	end
end)

-- CÂMERA ACOMPANHANDO O ALVO
aimConn = RunService.RenderStepped:Connect(function()
	if not aimbotOn then
		return
	end

	if not selectedTarget then
		return
	end

	local targetCharacter = selectedTarget.Character

	if not targetCharacter then
		return
	end

	local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
	local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")

	if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then
		return
	end

	local camera = workspace.CurrentCamera

	camera.CameraType = Enum.CameraType.Scriptable

	-- Mantém a câmera olhando para o alvo
	local cameraPosition = camera.CFrame.Position
	local targetPosition = targetRoot.Position

	camera.CFrame = CFrame.lookAt(
		cameraPosition,
		targetPosition
	)
end)

--// TOGGLE
toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible

	if frame.Visible then
		updatePlayerList()
	end
end)

--// MINIMIZAR
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized

	for _, v in pairs(frame:GetChildren()) do
		if v ~= header and v ~= gradient then
			v.Visible = not minimized
		end
	end

	frame.Size = minimized
		and UDim2.new(0, 270, 0, 30)
		or UDim2.new(0, 270, 0, 420)
end)

--// DRAG
header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then

		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

header.InputChanged:Connect(function(input)
	if dragging then
		local delta = input.Position - dragStart

		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function()
	dragging = false
end)