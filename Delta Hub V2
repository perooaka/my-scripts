-- [[ Delta Hub [Ultimate Edition] ]] --
-- Executor Compatibility: Delta, Fluxus, Codex, etc.

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaHubUI"
ScreenGui.ResetOnSpawn = false
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Variables / Toggles State
local States = {
    EspPlayer = false,
    EspNameDist = false,
    EspTracers = false,
    EspColor = Color3.fromRGB(255, 0, 0),
    Hitbox = false,
    Fullbright = false,
    Fly = false,
    InfJump = false,
    WallHop = false,
    NoClip = false,
    AutoClicker = false,
    AntiAFK = false,
    Spectate = false,
    LavaImmunity = false,
    StrechedRes = false
}

local Connections = {}
local TargetPlayer = nil

-- Utility Functions
local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- UI Framing
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 330)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -165)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
CreateCorner(MainFrame, 8)
MakeDraggable(MainFrame)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
CreateCorner(TopBar, 8)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -35, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "Delta Hub [Ultimate Edition]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 16

local FloatBtn = Instance.new("TextButton", ScreenGui)
FloatBtn.Size = UDim2.new(0, 110, 0, 30)
FloatBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
FloatBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
FloatBtn.Text = "Delta Hub 🔻"
FloatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatBtn.Visible = false
FloatBtn.Font = Enum.Font.SourceSansBold
FloatBtn.TextSize = 14
CreateCorner(FloatBtn, 6)
MakeDraggable(FloatBtn)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatBtn.Visible = true
end)

FloatBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    FloatBtn.Visible = false
end)

-- Sidebar and Container
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 110, 1, -30)
Sidebar.Position = UDim2.new(0, 0, 0, 30)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
CreateCorner(Sidebar, 0)

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -115, 1, -35)
Container.Position = UDim2.new(0, 112, 0, 32)
Container.BackgroundTransparency = 1

local Tabs = {}
local TabButtons = {}

local function CreateTab(name)
    local Button = Instance.new("TextButton", Sidebar)
    Button.Size = UDim2.new(1, -10, 0, 25)
    Button.Position = UDim2.new(0, 5, 0, #TabButtons * 28 + 5)
    Button.Text = name
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 12
    CreateCorner(Button, 4)

    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 3
    Page.CanvasSize = UDim2.new(0, 0, 2, 0)

    local UIList = Instance.new("UIListLayout", Page)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 5)

    Button.MouseButton1Click:Connect(function()
        for _, b in pairs(TabButtons) do b.BackgroundColor3 = Color3.fromRGB(25, 25, 25) end
        for _, p in pairs(Tabs) do p.Visible = false end
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
        Page.Visible = true
    end)

    table.insert(TabButtons, Button)
    table.insert(Tabs, Page)

    if #TabButtons == 1 then
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
        Page.Visible = true
    end

    return Page
end

-- UI Helper Components
local function AddToggle(parent, text, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 25)
    Frame.BackgroundTransparency = 1

    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundColor3 = default and Color3.fromRGB(40, 150, 40) or Color3.fromRGB(30, 30, 30)
    Btn.Text = text .. (default and " [ON]" or " [OFF]")
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSans
    Btn.TextSize = 12
    CreateCorner(Btn, 4)

    local state = default
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.BackgroundColor3 = state and Color3.fromRGB(40, 150, 40) or Color3.fromRGB(30, 30, 30)
        Btn.Text = text .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

local function AddInput(parent, placeholder, callback)
    local Box = Instance.new("TextBox", parent)
    Box.Size = UDim2.new(1, -10, 0, 25)
    Box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Box.PlaceholderText = placeholder
    Box.Text = ""
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.Font = Enum.Font.SourceSans
    Box.TextSize = 12
    CreateCorner(Box, 4)
    Box.FocusLost:Connect(function(enter)
        if enter then callback(Box.Text) end
    end)
end

local function AddButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -10, 0, 25)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSans
    Btn.TextSize = 12
    CreateCorner(Btn, 4)
    Btn.MouseButton1Click:Connect(callback)
end

-- ABAS
local TabVisual = CreateTab("Visual")
local TabMusic = CreateTab("Músicas")
local TabMove = CreateTab("Movimentação")
local TabGraphics = CreateTab("Gráficos")
local TabSkin = CreateTab("Skin")
local TabUtils = CreateTab("Farm / Utils")
local TabExtras = CreateTab("Extras")
local TabTroll = CreateTab("Troll / Server")

-- 1. ABA VISUAL
AddToggle(TabVisual, "ESP Player Highlight", false, function(s) States.EspPlayer = s end)
AddToggle(TabVisual, "ESP Nome + Distância", false, function(s) States.EspNameDist = s end)

AddButton(TabVisual, "Cor ESP: Vermelho", function() States.EspColor = Color3.fromRGB(255, 0, 0) end)
AddButton(TabVisual, "Cor ESP: Azul", function() States.EspColor = Color3.fromRGB(0, 100, 255) end)
AddButton(TabVisual, "Cor ESP: Amarelo", function() States.EspColor = Color3.fromRGB(255, 255, 0) end)
AddButton(TabVisual, "Cor ESP: Verde", function() States.EspColor = Color3.fromRGB(0, 255, 0) end)

AddToggle(TabVisual, "Hitbox Extender (10x10)", false, function(s) States.Hitbox = s end)
AddToggle(TabVisual, "Fullbright", false, function(s)
    States.Fullbright = s
    Lighting.Ambient = s and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(127, 127, 127)
end)
AddInput(TabVisual, "Ajustar FOV (Ex: 100)", function(val)
    Workspace.CurrentCamera.FieldOfView = tonumber(val) or 70
end)

-- Visual ESP Logic
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            -- Highlight ESP
            local hl = p.Character:FindFirstChild("DeltaHL")
            if States.EspPlayer then
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "DeltaHL"
                end
                hl.FillColor = States.EspColor
            elseif hl then hl:Destroy() end

            -- Name + Distance ESP
            local bb = p.Character:FindFirstChild("DeltaBB")
            if States.EspNameDist and p.Character:FindFirstChild("Head") then
                if not bb then
                    bb = Instance.new("BillboardGui", p.Character.Head)
                    bb.Name = "DeltaBB"
                    bb.Size = UDim2.new(0, 100, 0, 30)
                    bb.StudsOffset = Vector3.new(0, 2, 0)
                    bb.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", bb)
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.TextColor3 = States.EspColor
                    txt.TextSize = 10
                    txt.Name = "Txt"
                end
                local dist = math.floor((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.Head.Position).Magnitude) or 0)
                bb.Txt.Text = p.Name .. " [" .. dist .. "m]"
                bb.Txt.TextColor3 = States.EspColor
            elseif bb then bb:Destroy() end

            -- Hitbox
            if States.Hitbox and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
                p.Character.HumanoidRootPart.Transparency = 0.7
                p.Character.HumanoidRootPart.Color = Color3.fromRGB(255, 0, 0)
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
end)

-- 2. ABA MÚSICAS
local ActiveSound = nil
local SoundID = ""
AddInput(TabMusic, "ID do Áudio Roblox", function(id) SoundID = id end)
AddButton(TabMusic, "Tocar Áudio", function()
    if ActiveSound then ActiveSound:Destroy() end
    ActiveSound = Instance.new("Sound", SoundService)
    ActiveSound.SoundId = "rbxassetid://" .. SoundID
    ActiveSound.Volume = 1
    ActiveSound:Play()
end)
AddButton(TabMusic, "Parar Áudio", function()
    if ActiveSound then ActiveSound:Stop() ActiveSound:Destroy() end
end)

-- 3. ABA MOVIMENTAÇÃO
AddInput(TabMove, "WalkSpeed (Velocidade)", function(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(val) or 16
    end
end)
AddInput(TabMove, "JumpPower (Pulo)", function(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = tonumber(val) or 50
    end
end)

AddToggle(TabMove, "Fly (Voar)", false, function(s)
    States.Fly = s
    if s and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local bv = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
        bv.Name = "DeltaFlyBV"
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        local bg = Instance.new("BodyGyro", LocalPlayer.Character.HumanoidRootPart)
        bg.Name = "DeltaFlyBG"
        bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        
        task.spawn(function()
            while States.Fly do
                local cam = Workspace.CurrentCamera.CFrame
                bv.Velocity = cam.LookVector * 50
                bg.CFrame = cam
                task.wait()
            end
            bv:Destroy() bg:Destroy()
        end)
    end
end)

AddToggle(TabMove, "Infinite Jump", false, function(s) States.InfJump = s end)
UserInputService.JumpRequest:Connect(function()
    if States.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

AddToggle(TabMove, "Wall Hop (Escalar Parede)", false, function(s) States.WallHop = s end)
UserInputService.JumpRequest:Connect(function()
    if States.WallHop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local ray = Ray.new(hrp.Position, hrp.CFrame.LookVector * 3)
        local part = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
        if part then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

AddInput(TabMove, "Alterar Gravidade", function(val) Workspace.Gravity = tonumber(val) or 196.2 end)

AddButton(TabMove, "Infinite Stamina", function()
    for _, v in pairs(game:GetDescendants()) do
        if v.Name:lower():find("stamina") and v:IsA("ValueBase") then v.Value = 999999 end
    end
end)

AddButton(TabMove, "Click Teleport (Adicionar Ferramenta)", function()
    local Tool = Instance.new("Tool")
    Tool.Name = "Click TP"
    Tool.RequiresHandle = false
    Tool.Parent = LocalPlayer.Backpack
    Tool.Activated:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = Mouse.Hit + Vector3.new(0, 3, 0)
        end
    end)
end)

AddToggle(TabMove, "NoClip", false, function(s) States.NoClip = s end)
RunService.Stepped:Connect(function()
    if States.NoClip and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetChildren()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- 4. ABA GRÁFICOS
AddToggle(TabGraphics, "Tela Esticada (Modo FF)", false, function(s)
    Workspace.CurrentCamera.FieldOfView = s and 110 or 70
end)

AddButton(TabGraphics, "Reduzir Lag (Modo Microondas)", function()
    Lighting.GlobalShadows = false
    settings().Rendering.QualityLevel = 1
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        elseif v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
            v.Enabled = false
        end
    end
end)

-- Helper para Listar Jogadores
local function CreatePlayerList(parent, onSelect)
    local Scroll = Instance.new("ScrollingFrame", parent)
    Scroll.Size = UDim2.new(1, -10, 0, 120)
    Scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    CreateCorner(Scroll, 4)
    
    local List = Instance.new("UIListLayout", Scroll)
    List.SortOrder = Enum.SortOrder.LayoutOrder

    local function Refresh()
        for _, c in pairs(Scroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local Btn = Instance.new("TextButton", Scroll)
                Btn.Size = UDim2.new(1, 0, 0, 20)
                Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                Btn.Text = p.Name
                Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                Btn.Font = Enum.Font.SourceSans
                Btn.TextSize = 11
                Btn.MouseButton1Click:Connect(function() onSelect(p) end)
            end
        end
    end
    Refresh()
    Players.PlayerAdded:Connect(Refresh)
    Players.PlayerRemoving:Connect(Refresh)
end

-- 5. ABA SKIN
local SelectedSkinTarget = nil
CreatePlayerList(TabSkin, function(p) SelectedSkinTarget = p end)
AddButton(TabSkin, "Clonar Skin do Player Selecionado", function()
    if SelectedSkinTarget and SelectedSkinTarget.Character and LocalPlayer.Character then
        for _, item in pairs(LocalPlayer.Character:GetChildren()) do
            if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("CharacterMesh") then
                item:Destroy()
            end
        end
        for _, item in pairs(SelectedSkinTarget.Character:GetChildren()) do
            if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("CharacterMesh") then
                item:Clone().Parent = LocalPlayer.Character
            end
        end
    end
end)

-- 6. ABA FARM / UTILS
AddToggle(TabUtils, "Auto-Clicker", false, function(s) States.AutoClicker = s end)
task.spawn(function()
    while true do
        if States.AutoClicker then
            VirtualUser:Button1Down(Vector2.new(0,0))
            task.wait(0.01)
            VirtualUser:Button1Up(Vector2.new(0,0))
        end
        task.wait(0.05)
    end
end)

AddToggle(TabUtils, "Anti-AFK", false, function(s) States.AntiAFK = s end)
LocalPlayer.Idled:Connect(function()
    if States.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- 7. ABA EXTRAS
AddButton(TabExtras, "Ativar Auto-Rejoin em Quedas", function()
    local gui = CoreGui:FindFirstChild("RobloxPromptGui")
    if gui then
        gui.DescendantAdded:Connect(function(child)
            if child.Name == "ErrorPrompt" then
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        end)
    end
end)

AddToggle(TabExtras, "Anti-Touch Damage (Lava Immunity)", false, function(s)
    States.LavaImmunity = s
    if s and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetChildren()) do
            if p:IsA("BasePart") then
                p.Touched:Connect(function() end)
            end
        end
    end
end)

AddButton(TabExtras, "Noclip de Câmera", function()
    LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
end)

AddButton(TabExtras, "Zoom Infinito", function()
    LocalPlayer.CameraMaxZoomDistance = 999999
end)

AddButton(TabExtras, "Destruir GUI", function()
    ScreenGui:Destroy()
end)

-- 8. ABA TROLL / SERVER
CreatePlayerList(TabTroll, function(p) TargetPlayer = p end)

AddToggle(TabTroll, "Spectate (Especionar)", false, function(s)
    if s and TargetPlayer and TargetPlayer.Character then
        Workspace.CurrentCamera.CameraSubject = TargetPlayer.Character:FindFirstChildOfClass("Humanoid")
    else
        if LocalPlayer.Character then
            Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    