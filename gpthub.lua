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

--// GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "GPTHub"
gui.ResetOnSpawn = false

-- BOTÃO FLUTUANTE
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(1, -70, 0.5, -30)
toggleBtn.Text = "💙"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)

-- PAINEL
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 270, 0, 320)
frame.Position = UDim2.new(0.5, -135, 0.5, -160)
frame.Visible = false

-- GRADIENTE AZUL ESCURO
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 80))
}

-- HEADER
local header = Instance.new("TextButton", frame)
header.Size = UDim2.new(1,0,0,30)
header.Text = "GPT Hub"
header.BackgroundColor3 = Color3.fromRGB(0, 0, 50)
header.TextColor3 = Color3.new(1,1,1)

-- MINIMIZAR
local minimize = Instance.new("TextButton", header)
minimize.Size = UDim2.new(0,30,1,0)
minimize.Position = UDim2.new(1,-30,0,0)
minimize.Text = "-"

local minimized = false

-- FUNÇÃO UI
local function makeBtn(y, text)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0, 240, 0, 30)
	b.Position = UDim2.new(0, 15, 0, y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(20,20,20)
	b.TextColor3 = Color3.new(1,1,1)
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
		for _,v in pairs(char:GetChildren()) do
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
		local bv = Instance.new("BodyVelocity", root)
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)
		bv.Name = "FlyVel"

		flyConn = RunService.RenderStepped:Connect(function()
			bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 80
		end)
	else
		if flyConn then flyConn:Disconnect() end
		if root:FindFirstChild("FlyVel") then
			root.FlyVel:Destroy()
		end
	end
end)

-- ESP
espBtn.MouseButton1Click:Connect(function()
	esp = not esp
	espBtn.Text = "ESP " .. (esp and "ON" or "OFF")

	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			if esp then
				if not plr.Character:FindFirstChild("Highlight") then
					local h = Instance.new("Highlight", plr.Character)
					h.FillColor = Color3.fromRGB(0, 150, 255)
				end
			else
				for _,v in pairs(plr.Character:GetChildren()) do
					if v:IsA("Highlight") then
						v:Destroy()
					end
				end
			end
		end
	end
end)

-- TELEPORT (corrigido)
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
	local bv = Instance.new("BodyVelocity", root)
	bv.Velocity = Vector3.new(0,200,0)
	bv.MaxForce = Vector3.new(1e5,1e5,1e5)
	game.Debris:AddItem(bv, 0.3)
end)

-- TOGGLE
toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- MINIMIZAR
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized

	for _,v in pairs(frame:GetChildren()) do
		if v ~= header then
			v.Visible = not minimized
		end
	end

	frame.Size = minimized and UDim2.new(0,270,0,30) or UDim2.new(0,270,0,320)
end)

-- DRAG
header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
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