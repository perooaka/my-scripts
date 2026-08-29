-- DELTA HUB - INTERFACE NATIVA PRETA (ULTIMATE EDITION)
-- TUDO MANTIDO + ABA GRÁFICOS (TELA ESTICADA, REDUZIR LAG), WALL HOP REAL & 5 NOVAS FUNÇÕES

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")

-- GUI Principal
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaHubNativeGui"
gui.ResetOnSpawn = false

pcall(function()
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end)

-- Janela Principal (Preta)
local MainFrame = Instance.new("Frame", gui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 330)
MainFrame.Position = UDim2.new(0.5, -225, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Active = true
MainFrame.Draggable = true

-- Barra Superior de Título
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TopBar.BorderSizePixel = 0

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.Text = "Delta Hub [Ultimate Edition]"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1

-- Botão Flutuante (Minimizado)
local MiniBtn = Instance.new("TextButton", gui)
MiniBtn.Name = "DeltaMiniBtn"
MiniBtn.Size = UDim2.new(0, 130, 0, 35)
MiniBtn.Position = UDim2.new(0.5, -65, 0, 10)
MiniBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MiniBtn.BorderColor3 = Color3.fromRGB(40, 40, 40)
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtn.Text = "Delta Hub 🔻"
MiniBtn.Font = Enum.Font.SourceSansBold
MiniBtn.TextSize = 14
MiniBtn.Visible = false
MiniBtn.Active = true
MiniBtn.Draggable = true

-- Botão X (Fechar / Minimizar)
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 35, 1, 0)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.BorderSizePixel = 0

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniBtn.Visible = true
end)

MiniBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniBtn.Visible = false
end)

-- Barra Lateral de Abas
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 110, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Sidebar.BorderSizePixel = 0

-- Container de Conteúdo
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -110, 1, -35)
ContentArea.Position = UDim2.new(0, 110, 0, 35)
ContentArea.BackgroundTransparency = 1

local tabs = {}

local function createTab(name)
    local tabContainer = Instance.new("ScrollingFrame", ContentArea)
    tabContainer.Size = UDim2.new(1, -10, 1, -10)
    tabContainer.Position = UDim2.new(0, 5, 0, 5)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ScrollBarThickness = 4
    tabContainer.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    tabContainer.Visible = false
    
    local layout = Instance.new("UIListLayout", tabContainer)
    layout.Padding = UDim.new(0, 5)
    
    local tabBtn = Instance.new("TextButton", Sidebar)
    tabBtn.Size = UDim2.new(1, 0, 0, 35)
    tabBtn.Position = UDim2.new(0, 0, 0, #tabs * 35)
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    tabBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    tabBtn.BorderSizePixel = 0
    tabBtn.Font = Enum.Font.SourceSans
    tabBtn.TextSize = 14

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.container.Visible = false
            t.btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            t.btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        tabContainer.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    table.insert(tabs, {container = tabContainer, btn = tabBtn})
    
    if #tabs == 1 then
        tabContainer.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    return tabContainer
end

local function addBtn(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    btn.BorderColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function addInput(parent, placeholder, callback)
    local input = Instance.new("TextBox", parent)
    input.Size = UDim2.new(1, -10, 0, 32)
    input.PlaceholderText = placeholder
    input.Text = ""
    input.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    input.BorderColor3 = Color3.fromRGB(40, 40, 40)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.Font = Enum.Font.SourceSans
    input.TextSize = 14
    input.FocusLost:Connect(function()
        callback(input.Text)
    end)
    return input
end

local function addLabel(parent, text)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, -10, 0, 25)
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

-- ========================================================
-- ABA 1: VISUAL (ESP, CORES & FOV)
-- ========================================================
local visualTab = createTab("Visual")

local espActive = false
local espNamesActive = false
local selectedESPColor = Color3.fromRGB(255, 0, 0)

addBtn(visualTab, "Toggle ESP Player", function()
    espActive = not espActive
    if not espActive then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ESPHighlight") then
                p.Character.ESPHighlight:Destroy()
            end
        end
    end
end)

addBtn(visualTab, "Toggle ESP Nome + Distância", function()
    espNamesActive = not espNamesActive
    if not espNamesActive then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("ESPNameTag") then
                p.Character.Head.ESPNameTag:Destroy()
            end
        end
    end
end)

local tracersActive = false
addBtn(visualTab, "Toggle ESP Tracers (Linhas)", function()
    tracersActive = not tracersActive
    if not tracersActive then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("TracerLine") then
                p.Character.TracerLine:Destroy()
            end
        end
    end
end)

addLabel(visualTab, "🎨 Escolher Cor do ESP:")

local function createColorBtn(parent, text, color)
    return addBtn(parent, text, function()
        selectedESPColor = color
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ESPHighlight") then
                p.Character.ESPHighlight.FillColor = selectedESPColor
            end
        end
    end)
end

createColorBtn(visualTab, "🔴 Vermelho", Color3.fromRGB(255, 0, 0))
createColorBtn(visualTab, "🔵 Azul", Color3.fromRGB(0, 120, 255))
createColorBtn(visualTab, "🟡 Amarelo", Color3.fromRGB(255, 220, 0))
createColorBtn(visualTab, "🟢 Verde", Color3.fromRGB(0, 255, 100))

RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if espActive then
                local hl = p.Character:FindFirstChild("ESPHighlight") or Instance.new("Highlight", p.Character)
                hl.Name = "ESPHighlight"
                hl.FillColor = selectedESPColor
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            end
            
            if espNamesActive and p.Character:FindFirstChild("Head") then
                local tag = p.Character.Head:FindFirstChild("ESPNameTag")
                if not tag then
                    tag = Instance.new("BillboardGui", p.Character.Head)
                    tag.Name = "ESPNameTag"
                    tag.Size = UDim2.new(0, 150, 0, 30)
                    tag.StudsOffset = Vector3.new(0, 2.5, 0)
                    tag.AlwaysOnTop = true
                    
                    local lbl = Instance.new("TextLabel", tag)
                    lbl.Name = "TagLabel"
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.TextColor3 = selectedESPColor
                    lbl.Font = Enum.Font.SourceSansBold
                    lbl.TextSize = 14
                    lbl.TextStrokeTransparency = 0
                end
                
                local dist = 0
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude)
                end
                if tag:FindFirstChild("TagLabel") then
                    tag.TagLabel.Text = p.Name .. " [" .. tostring(dist) .. "m]"
                    tag.TagLabel.TextColor3 = selectedESPColor
                end
            end

            if tracersActive then
                local line = p.Character:FindFirstChild("TracerLine") or Instance.new("SelectionBox", p.Character)
                line.Name = "TracerLine"
                line.Adornee = p.Character.HumanoidRootPart
                line.Color3 = selectedESPColor
            end
        end
    end
end)

addBtn(visualTab, "Hitbox Extender", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
            p.Character.HumanoidRootPart.Transparency = 0.7
            p.Character.HumanoidRootPart.BrickColor = BrickColor.new("Red")
            p.Character.HumanoidRootPart.CanCollide = false
        end
    end
end)

addBtn(visualTab, "Fullbright", function()
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 2
    Lighting.GlobalShadows = false
end)

addInput(visualTab, "Mudar FOV (ex: 100)", function(txt)
    local val = tonumber(txt)
    if val then
        Workspace.CurrentCamera.FieldOfView = val
    end
end)

-- ========================================================
-- ABA 2: MÚSICAS (LOCAL / VISUAL)
-- ========================================================
local musicTab = createTab("Músicas")

local currentLocalSound = nil
local soundIDInput = ""

addInput(musicTab, "Digite o ID da Música (Sound ID)", function(txt)
    soundIDInput = txt
end)

addBtn(musicTab, "▶ Tocar Música (Só Você Ouve)", function()
    if currentLocalSound then
        currentLocalSound:Stop()
        currentLocalSound:Destroy()
    end
    if soundIDInput ~= "" then
        currentLocalSound = Instance.new("Sound", SoundService)
        currentLocalSound.SoundId = "rbxassetid://" .. soundIDInput
        currentLocalSound.Volume = 1
        currentLocalSound.Looped = true
        currentLocalSound:Play()
    end
end)

addBtn(musicTab, "⏹ Parar Música", function()
    if currentLocalSound then
        currentLocalSound:Stop()
        currentLocalSound:Destroy()
        currentLocalSound = nil
    end
end)

-- ========================================================
-- ABA 3: MOVIMENTAÇÃO (FLY, INF JUMP & WALL HOP REAL)
-- ========================================================
local moveTab = createTab("Movimentação")

addInput(moveTab, "WalkSpeed (ex: 50)", function(txt)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = tonumber(txt) or 16 end
end)

addInput(moveTab, "JumpPower (ex: 100)", function(txt)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum.JumpPower = tonumber(txt) or 50 end
end)

local flying = false
local flyBodyVel, flyBodyGyro

addBtn(moveTab, "Toggle Fly (Voar)", function()
    flying = not flying
    local char = LocalPlayer.Character
    if flying and char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        flyBodyVel = Instance.new("BodyVelocity", hrp)
        flyBodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBodyVel.Velocity = Vector3.new(0, 0, 0)
        
        flyBodyGyro = Instance.new("BodyGyro", hrp)
        flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        flyBodyGyro.CFrame = hrp.CFrame
        
        task.spawn(function()
            while flying and char and char:FindFirstChild("Humanoid") do
                local camCFrame = Workspace.CurrentCamera.CFrame
                flyBodyGyro.CFrame = camCFrame
                flyBodyVel.Velocity = camCFrame.LookVector * 50
                task.wait()
            end
            if flyBodyVel then flyBodyVel:Destroy() end
            if flyBodyGyro then flyBodyGyro:Destroy() end
        end)
    else
        if flyBodyVel then flyBodyVel:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
    end
end)

local infJump = false
addBtn(moveTab, "Toggle Infinite Jump", function()
    infJump = not infJump
end)

UserInputService.JumpRequest:Connect(function()
    if infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- WALL HOP REAL (PULAR E ESCALAR PAREDES)
local wallHopActive = false
addBtn(moveTab, "🧗 Toggle Wall Hop (Escalar Parede)", function()
    wallHopActive = not wallHopActive
end)

UserInputService.JumpRequest:Connect(function()
    if wallHopActive and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hrp and hum then
            local ray = Ray.new(hrp.Position, hrp.CFrame.LookVector * 3)
            local part, pos = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
            if part then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

addInput(moveTab, "Mudar Gravidade (ex: 50)", function(txt)
    local val = tonumber(txt)
    if val then
        Workspace.Gravity = val
    end
end)

addBtn(moveTab, "Infinite Stamina", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Stamina") then
        LocalPlayer.Character.Stamina.Value = 999999
    end
end)

addBtn(moveTab, "Ferramenta Click Teleport", function()
    local mouse = LocalPlayer:GetMouse()
    local tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = "Click Teleport"
    tool.Activated:Connect(function()
        local pos = mouse.Hit.p
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
        end
    end)
    tool.Parent = LocalPlayer.Backpack
end)

local noclip = false
addBtn(moveTab, "Toggle NoClip", function()
    noclip = not noclip
end)

RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- ========================================================
-- ABA 4: GRÁFICOS (NOVA!)
-- ========================================================
local gfxTab = createTab("Gráficos")

local stretchedScreen = false
addBtn(gfxTab, "📱 Toggle Tela Esticada (Modo FF)", function()
    stretchedScreen = not stretchedScreen
    local cam = Workspace.CurrentCamera
    if stretchedScreen then
        cam.FieldOfView = 110
    else
        cam.FieldOfView = 70
    end
end)

addBtn(gfxTab, "⚡ Reduzir Lag (Modo Microondas)", function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    settings().Rendering.QualityLevel = 1
    
    for _, item in pairs(Workspace:GetDescendants()) do
        if item:IsA("BasePart") then
            item.Material = Enum.Material.SmoothPlastic
            item.Reflectance = 0
        elseif item:IsA("Decal") or item:IsA("Texture") then
            item:Destroy()
        elseif item:IsA("ParticleEmitter") or item:IsA("Trail") or item:IsA("Smoke") or item:IsA("Fire") then
            item.Enabled = false
        end
    end
end)

-- ========================================================
-- ABA 5: SKIN (CLONAR APARÊNCIA DE JOGADORES)
-- ========================================================
local skinTab = createTab("Skin")

local selectedSkinPlayer = nil
local skinStatusLabel = addLabel(skinTab, "Jogador Selecionado: Nenhum")

local skinListFrame = Instance.new("ScrollingFrame", skinTab)
skinListFrame.Size = UDim2.new(1, -10, 0, 110)
skinListFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
skinListFrame.BorderColor3 = Color3.fromRGB(35, 35, 35)
skinListFrame.ScrollBarThickness = 4
skinListFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)

local skinListLayout = Instance.new("UIListLayout", skinListFrame)
skinListLayout.Padding = UDim.new(0, 3)

local function refreshSkinPlayerList()
    for _, child in pairs(skinListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local pBtn = Instance.new("TextButton", skinListFrame)
            pBtn.Size = UDim2.new(1, -8, 0, 25)
            pBtn.Text = p.Name
            pBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            pBtn.BorderColor3 = Color3.fromRGB(40, 40, 40)
            pBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
            pBtn.Font = Enum.Font.SourceSans
            pBtn.TextSize = 13
            
            pBtn.MouseButton1Click:Connect(function()
                selectedSkinPlayer = p
                skinStatusLabel.Text = "Jogador Selecionado: " .. p.Name
            end)
        end
    end
end

addBtn(skinTab, "🔄 Atualizar Lista de Jogadores", function()
    refreshSkinPlayerList()
end)

refreshSkinPlayerList()

addBtn(skinTab, "👤 Clonar Skin do Jogador", function()
    if selectedSkinPlayer and selectedSkinPlayer.Character and LocalPlayer.Character then
        local myChar = LocalPlayer.Character
        local targetChar = selectedSkinPlayer.Character
        
        for _, item in pairs(myChar:GetChildren()) do
            if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("CharacterMesh") then
                item:Destroy()
            end
        end
        
        for _, item in pairs(targetChar:GetChildren()) do
            if item:IsA("Accessory") or item:IrollTab)
playerListFrame.Size = UDim2.new(1, -10, 0, 100)
playerListFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
playerListFrame.BorderColor3 = Color3.fromRGB(35, 35, 35)
playerListFrame.ScrollBarThickness = 4
playerListFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)

local playerListLayout = Instance.new("UIListLayout", playerListFrame)
playerListLayout.Padding = UDim.new(0, 3)

local function refreshPlayerList()
    for _, child in pairs(playerListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local pBtn = Instance.new("TextButton", playerListFrame)
            pBtn.Size = UDim2.new(1, -8, 0, 25)
            pBtn.Text = p.Name
            pBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            pBtn.BorderColor3 = Color3.fromRGB(40, 40, 40)
            pBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
            pBtn.Font = Enum.Font.SourceSans
            pBtn.TextSize = 13
            
            pBtn.MouseButton1Click:Connect(function()
                selectedPlayerName = p.Name
                statusLabel.Text = "Jogador Selecionado: " .. p.Name
            end)
        end
    end
end

addBtn(trollTab, "🔄 Atualizar Lista de Jogadores", function()
    refreshPlayerList()
end)

refreshPlayerList()

addBtn(trollTab, "🚀 Teleportar até o Jogador", function()
    if selectedPlayerName then
        local target = Players:FindFirstChild(selectedPlayerName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
            end
        end
    end
end)

local spectating = false
addBtn(trollTab, "👁️ Assistir / Espectar Jogador", function()
    if selectedPlayerName then
        local target = Players:FindFirstChild(selectedPlayerName)
        if target and target.Character and target.Character:FindFirstChild("Humanoid") then
            spectating = not spectating
            if spectating then
                Workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
            else
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
                end
            end
        end
    end
end)

addBtn(trollTab, "❌ Parar de Espectar (Voltar Câmera)", function()
    spectating = false
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end)

addBtn(trollTab, "Bring All (Puxar Ferramentas)", function()
    for _, item in pairs(Workspace:GetChildren()) do
        if item:IsA("Tool") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:EquipTool(item)
        end
    end
end)

addBtn(trollTab, "Fling Jogadores Próximos", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local bAv = Instance.new("BodyAngularVelocity", char.HumanoidRootPart)
        bAv.MaxTorque = Vector3.new(0, math.huge, 0)
        bAv.AngularVelocity = Vector3.new(0, 99999, 0)
        task.wait(2)
        bAv:Destroy()
    end
end)

addBtn(trollTab, "Invisibilidade (Visual)", function()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 1
            end
        end
    end
end)

-- ========================================================
-- NOTIFICAÇÃO DE CARREGAMENTO
-- ========================================================
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Delta Roblox",
        Text = "Script Executado com Sucesso!",
        Duration = 5
    })
end)