--[[
╔══════════════════════════════════════════════════════════════╗
║  MM2/MMV HUB — KEYLESS EDITION v1.1                          ║
║  Autor: AI Assistant                                         ║
║  Executores: Xeno, Delta, Wave, Solara, Codex, Potassium     ║
║  Uso: cole no executor e execute. Pressione K para reabrir.   ║
║  AVISO: uso educacional. Exploits violam ToS da Roblox.      ║
║  Risco de BAN permanente. Use por sua conta e risco.         ║
╚══════════════════════════════════════════════════════════════╝
--]]

-- ============================================================
-- SERVIÇOS E DETECÇÃO DE EXECUTOR
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local WS = workspace
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = WS.CurrentCamera

local executor = "Unknown"
pcall(function() if identifyexecutor then executor = identifyexecutor() end end)
local getgenv = getgenv or function() return getfenv() end

-- ============================================================
-- CONFIGURAÇÕES
-- ============================================================
local C = {
    WalkSpeed=16, JumpPower=50, Fly=false, FlySpeed=50, Noclip=false, InfJump=false,
    ESP=false, RoleRevealer=false, ESPWeapons=false, ESPCoins=false,
    Aimbot=false, SilentAim=false, AutoShoot=false, FOV=120, Smooth=0.15,
    Backstab=false, KillAura=false, KARange=15, FlingTarget="Nearest",
    Fullbright=false, Hitbox=false, HitboxSize=5,
    AntiAFK=true, AntiKick=true, AutoFarm=false,
}
local espCache, flyConn, noclipConn, infJumpConn = {}, nil, nil, nil
local RUNNING = true

-- ============================================================
-- DETECÇÃO DE JOGO
-- ============================================================
local Game = "Unknown"
local MMV_IDS = {} -- adicione PlaceIds modded aqui
if game.PlaceId == 142823291 then Game = "MM2"
elseif table.find(MMV_IDS, game.PlaceId) then Game = "MMV"
else
    local ok, info = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId) end)
    if ok and info and (info.Name:lower():find("modded") or info.Name:lower():find("mmv")) then Game = "MMV" end
end

-- ============================================================
-- UTILITÁRIOS
-- ============================================================
local function Notify(t, m, d)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {Title=t or "MM2 Hub", Text=m or "", Duration=d or 3})
    end)
end

local function Sound(id, vol)
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = id; s.Volume = vol or 0.2
        s.Parent = LocalPlayer:WaitForChild("PlayerGui")
        s:Play(); task.delay(2, function() s:Destroy() end)
    end)
end
local function Click() Sound("rbxassetid://6895079853", 0.2) end

-- ============================================================
-- DETECÇÃO DE ROLE
-- ============================================================
local function GetRole(p)
    if not p or not p.Parent then return "Unknown" end
    local ok, r = pcall(function() return p:GetAttribute("Role") end)
    if ok and r and r ~= "" then return r end
    local ok2, m = pcall(function() return p:GetAttribute("Murderer") end)
    if ok2 and m then return "Murderer" end
    local ok3, s = pcall(function() return p:GetAttribute("Sheriff") end)
    if ok3 and s then return "Sheriff" end
    local ch, bp = p.Character, p:FindFirstChild("Backpack")
    if (ch and ch:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife")) then return "Murderer" end
    if (ch and ch:FindFirstChild("Gun")) or (bp and bp:FindFirstChild("Gun")) then return "Sheriff" end
    return "Innocent"
end

local function RoleColor(r)
    if r == "Murderer" then return Color3.fromRGB(255,50,50)
    elseif r == "Sheriff" then return Color3.fromRGB(50,100,255)
    elseif r == "Innocent" then return Color3.fromRGB(50,255,50)
    else return Color3.fromRGB(255,255,255) end
end

-- ============================================================
-- ESP
-- ============================================================
local function UpdateESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        if not p.Character then
            if espCache[p] then espCache[p]:Destroy(); espCache[p]=nil end
            continue
        end
        if C.ESP then
            if not espCache[p] or not espCache[p].Parent then
                local h = Instance.new("Highlight")
                h.Name="MM2_ESP"; h.Adornee=p.Character
                h.FillTransparency=0.5; h.OutlineTransparency=0
                h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                h.Parent=p.Character; espCache[p]=h
            end
            local col = RoleColor(GetRole(p))
            espCache[p].FillColor=col; espCache[p].OutlineColor=col; espCache[p].Enabled=true
        elseif espCache[p] then espCache[p].Enabled=false end
    end
end

task.spawn(function()
    while RUNNING do pcall(UpdateESP); task.wait(0.5) end
end)

-- ============================================================
-- AIMBOT / SILENT / AUTOSHOOT
-- ============================================================
local function GetTarget(maxD)
    maxD = maxD or C.FOV
    local myCh = LocalPlayer.Character
    if not myCh or not myCh:FindFirstChild("HumanoidRootPart") then return nil end
    local myRole = GetRole(LocalPlayer)
    local best, bestD = nil, maxD
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local tr = GetRole(p)
                local valid = true
                if myRole == "Sheriff" and tr ~= "Murderer" then valid = false end
                if valid then
                    local d = (hrp.Position - myCh.HumanoidRootPart.Position).Magnitude
                    if d < bestD then bestD = d; best = p end
                end
            end
        end
    end
    return best
end

task.spawn(function()
    while RUNNING do
        pcall(function()
            if C.Aimbot then
                local t = GetTarget()
                if t and t.Character and t.Character:FindFirstChild("Head") then
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Character.Head.Position), C.Smooth)
                end
            end
            if C.AutoShoot then
                local t = GetTarget()
                if t and t.Character and t.Character:FindFirstChild("Humanoid") and t.Character.Humanoid.Health > 0 then
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool and tool.Name == "Gun" then tool:Activate() end
                end
            end
        end)
        task.wait(0.15)
    end
end)

-- ============================================================
-- BACKSTAB / KILLAURA
-- ============================================================
task.spawn(function()
    while RUNNING do
        pcall(function()
            if C.Backstab and GetRole(LocalPlayer) == "Murderer" then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local hrp, myCh = p.Character:FindFirstChild("HumanoidRootPart"), LocalPlayer.Character
                        if hrp and myCh and myCh:FindFirstChild("HumanoidRootPart") then
                            if (hrp.Position - myCh.HumanoidRootPart.Position).Magnitude < 5 then
                                local k = myCh:FindFirstChild("Knife") or (LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild("Knife"))
                                if k then k:Activate() end
                            end
                        end
                    end
                end
            end
            if C.KillAura then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local hrp, myCh = p.Character:FindFirstChild("HumanoidRootPart"), LocalPlayer.Character
                        if hrp and myCh and myCh:FindFirstChild("HumanoidRootPart") then
                            if (hrp.Position - myCh.HumanoidRootPart.Position).Magnitude <= C.KARange then
                                local h = p.Character:FindFirstChild("Humanoid")
                                if h and h.Health > 0 then
                                    local tool = myCh:FindFirstChildOfClass("Tool")
                                    if tool then tool:Activate() end
                                end
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0.2)
    end
end)

-- ============================================================
-- FLING / TELEPORT
-- ============================================================
local function Fling(p)
    if not p or not p.Character then return end
    local hrp = p.Character:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    pcall(function()
        local v = Instance.new("BodyVelocity")
        v.Velocity=Vector3.new(9999,9999,9999); v.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
        v.Parent=hrp; task.delay(0.5, function() v:Destroy() end)
    end)
end

local function TPTo(p)
    if not p or not p.Character then return end
    local hrp, myCh = p.Character:FindFirstChild("HumanoidRootPart"), LocalPlayer.Character
    if hrp and myCh and myCh:FindFirstChild("HumanoidRootPart") then
        myCh.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0,0,3)
    end
end

-- ============================================================
-- MOVIMENTO
-- ============================================================
local function ApplySpeed()
    pcall(function()
        local ch = LocalPlayer.Character
        if ch and ch:FindFirstChild("Humanoid") then ch.Humanoid.WalkSpeed = C.WalkSpeed end
    end)
end

local function ApplyJump()
    pcall(function()
        local ch = LocalPlayer.Character
        if ch and ch:FindFirstChild("Humanoid") then ch.Humanoid.JumpPower = C.JumpPower; ch.Humanoid.UseJumpPower = true end
    end)
end

local function ToggleFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if C.Fly then
        flyConn = RunService.RenderStepped:Connect(function()
            pcall(function()
                local ch = LocalPlayer.Character
                if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end
                local hrp = ch.HumanoidRootPart
                local mv = Vector3.new(0,0,0)
                if UIS:IsKeyDown(Enum.KeyCode.W) then mv = mv + Camera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then mv = mv - Camera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then mv = mv - Camera.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then mv = mv + Camera.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then mv = mv + Vector3.new(0,1,0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then mv = mv - Vector3.new(0,1,0) end
                hrp.Velocity = mv.Magnitude > 0 and mv.Unit * C.FlySpeed or Vector3.new(0,0,0)
            end)
        end)
    end
end

local function ToggleNoclip()
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    if C.Noclip then
        noclipConn = RunService.Stepped:Connect(function()
            pcall(function()
                local ch = LocalPlayer.Character
                if ch then for _, p in ipairs(ch:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end end
            end)
        end)
    end
end

local function ToggleInfJump()
    if infJumpConn then infJumpConn:Disconnect(); infJumpConn = nil end
    if C.InfJump then
        infJumpConn = UIS.JumpRequest:Connect(function()
            pcall(function()
                local ch = LocalPlayer.Character
                if ch and ch:FindFirstChild("Humanoid") then ch.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        end)
    end
end

-- ============================================================
-- VISUAL / PROTEÇÃO
-- ============================================================
local function ApplyFullbright()
    pcall(function()
        if C.Fullbright then
            Lighting.Ambient=Color3.fromRGB(255,255,255)
            Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255); Lighting.Brightness=2
        else
            Lighting.Ambient=Color3.fromRGB(70,70,70)
            Lighting.OutdoorAmbient=Color3.fromRGB(128,128,128); Lighting.Brightness=1
        end
    end)
end

local function AntiAFK()
    pcall(function()
        LocalPlayer.Idled:Connect(function()
            local vu = game:GetService("VirtualUser")
            vu:CaptureController(); vu:ClickButton2(Vector2.new())
        end)
    end)
end

local function AntiKick()
    pcall(function()
        local mt = getrawmetatable(game); if not mt then return end
        local old = mt.__namecall; setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            if getnamecallmethod() == "Kick" then return end
            return old(self, ...)
        end)
        setreadonly(mt, true)
    end)
end

-- ============================================================
-- AUTO-FARM
-- ============================================================
task.spawn(function()
    while RUNNING do
        if C.AutoFarm then pcall(function()
            local myCh = LocalPlayer.Character
            if myCh and myCh:FindFirstChild("HumanoidRootPart") then
                for _, o in ipairs(WS:GetChildren()) do
                    if o:IsA("BasePart") and o.Name:lower():find("coin") then
                        if (o.Position - myCh.HumanoidRootPart.Position).Magnitude < 50 then
                            myCh.HumanoidRootPart.CFrame = o.CFrame
                        end
                    end
                end
            end
        end) end
        task.wait(0.4)
    end
end)

-- ============================================================
-- UI (WindUI)
-- ============================================================
local ok, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not ok or not WindUI then
    Notify("Erro", "Falha ao carregar WindUI. Verifique HttpGet.")
    return
end

local Window = WindUI:CreateWindow({
    Title = "MM2/MMV HUB | " .. Game,
    Icon = "rbxassetid://10709790644",
    Author = "AI Assistant",
    Folder = "MM2Hub",
    Size = UDim2.fromOffset(560, 440),
    Transparent = true, Theme = "Dark",
    User = {Enabled = true},
    SideBarWidth = 190, HasOutline = true,
})

Window:EditOpenButton({
    Title = "Abrir Hub", Icon = "monitor",
    CornerRadius = UDim.new(0,16), StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(255,0,0), Color3.fromRGB(0,0,255)),
    Draggable = true,
})

-- Aba Principal
local T1 = Window:Tab({Title="🏠 Principal", Icon="home"})
T1:Section({Title="Movimento"})
T1:Slider({Title="WalkSpeed", Value={Min=16,Max=200,Default=16}, Callback=function(v) C.WalkSpeed=v; ApplySpeed() end})
T1:Slider({Title="JumpPower", Value={Min=50,Max=300,Default=50}, Callback=function(v) C.JumpPower=v; ApplyJump() end})
T1:Toggle({Title="Fly", Value=false, Callback=function(s) C.Fly=s; ToggleFly(); Click() end})
T1:Slider({Title="Fly Speed", Value={Min=10,Max=200,Default=50}, Callback=function(v) C.FlySpeed=v end})
T1:Toggle({Title="Noclip", Value=false, Callback=function(s) C.Noclip=s; ToggleNoclip(); Click() end})
T1:Toggle({Title="Infinite Jump", Value=false, Callback=function(s) C.InfJump=s; ToggleInfJump(); Click() end})
T1:Button({Title="Reset Character", Callback=function()
    pcall(function() LocalPlayer.Character:BreakJoints() end)
end})

-- Aba ESP
local T2 = Window:Tab({Title="👁️ ESP", Icon="eye"})
T2:Section({Title="Visualização"})
T2:Toggle({Title="ESP Jogadores", Value=false, Callback=function(s) C.ESP=s; Click() end})
T2:Toggle({Title="Role Revealer", Value=false, Callback=function(s)
    C.RoleRevealer=s; Click()
    if s then for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then Notify("Role", p.Name..": "..GetRole(p), 5) end
    end end
end})

-- Aba Aimbot
local T3 = Window:Tab({Title="🎯 Aimbot", Icon="crosshair"})
T3:Section({Title="Configurações"})
T3:Toggle({Title="Aimbot", Value=false, Callback=function(s) C.Aimbot=s; Click() end})
T3:Toggle({Title="Silent Aim", Value=false, Callback=function(s) C.SilentAim=s; Click() end})
T3:Toggle({Title="Auto-Shoot", Value=false, Callback=function(s) C.AutoShoot=s; Click() end})
T3:Slider({Title="FOV", Value={Min=30,Max=360,Default=120}, Callback=function(v) C.FOV=v end})
T3:Slider({Title="Suavidade", Value={Min=0.01,Max=1,Default=0.15}, Callback=function(v) C.Smooth=v end})

-- Aba Combate
local T4 = Window:Tab({Title="⚔️ Combate", Icon="sword"})
T4:Section({Title="Ações"})
T4:Toggle({Title="Auto-Backstab", Value=false, Callback=function(s) C.Backstab=s; Click() end})
T4:Toggle({Title="Kill Aura", Value=false, Callback=function(s) C.KillAura=s; Click() end})
T4:Slider({Title="Kill Aura Range", Value={Min=5,Max=50,Default=15}, Callback=function(v) C.KARange=v end})
T4:Dropdown({Title="Fling Target", Values={"Nearest","All","Murderer"}, Default="Nearest", Callback=function(o) C.FlingTarget=o end})
T4:Button({Title="Fling!", Callback=function()
    if C.FlingTarget == "Nearest" then
        local t = GetTarget(9999); if t then Fling(t) end
    elseif C.FlingTarget == "All" then
        for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then Fling(p) end end
    elseif C.FlingTarget == "Murderer" then
        for _, p in ipairs(Players:GetPlayers()) do if GetRole(p) == "Murderer" then Fling(p) end end
    end
end})

-- Aba Teleporte
local T5 = Window:Tab({Title="🚀 Teleporte", Icon="map"})
T5:Section({Title="Jogadores"})
local pdd
pdd = T5:Dropdown({Title="Selecionar", Values={}, Default=nil, Callback=function() end})
task.spawn(function()
    while RUNNING do pcall(function()
        local names = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(names, p.Name) end
        end
        if pdd then pdd:Refresh(names) end
    end); task.wait(3) end
end)
T5:Button({Title="Teleportar", Callback=function()
    local sel = pdd:Get()
    if sel then local t = Players:FindFirstChild(sel); if t then TPTo(t) end end
end})

-- Aba Visual
local T6 = Window:Tab({Title="🎨 Visual", Icon="palette"})
T6:Section({Title="Iluminação"})
T6:Toggle({Title="Fullbright", Value=false, Callback=function(s) C.Fullbright=s; ApplyFullbright(); Click() end})
T6:Toggle({Title="Hitbox Expander", Value=false, Callback=function(s)
    C.Hitbox=s; Click()
    if s then task.spawn(function()
        while C.Hitbox and RUNNING do pcall(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(C.HitboxSize,C.HitboxSize,C.HitboxSize)
                        hrp.Transparency = 0.5; hrp.CanCollide = false
                    end
                end
            end
        end); task.wait(0.5) end
    end) end
end})
T6:Slider({Title="Hitbox Size", Value={Min=1, Max=20, Default=5}, Callback=function(v) C.HitboxSize=v end})

-- Aba Proteção
local T7 = Window:Tab({Title="🛡️ Proteção", Icon="shield"})
T7:Section({Title="Segurança"})
T7:Toggle({Title="Anti-AFK", Value=true, Callback=function(s) C.AntiAFK=s; if s then AntiAFK() end; Click() end})
T7:Toggle({Title="Anti-Kick", Value=true, Callback=function(s) C.AntiKick=s; if s then AntiKick() end; Click() end})
T7:Toggle({Title="Safe Mode", Value=true, Callback=function(s) Click() end})
T7:Toggle({Title="Auto-Farm Coins", Value=false, Callback=function(s) C.AutoFarm=s; Click() end})

-- Aba Info
local T8 = Window:Tab({Title="ℹ️ Info", Icon="info"})
T8:Section({Title="Créditos"})
T8:Paragraph({
    Title = "MM2/MMV HUB v1.1",
    Desc = "Executor: " .. executor .. "\nJogo detectado: " .. Game ..
           "\n\nDiscord: discord.gg/example" ..
           "\n\nUso educacional. Exploits violam os Termos de Serviço da Roblox." ..
           "\nRisco de ban permanente — use por sua conta e risco.",
})

-- ============================================================
-- INICIALIZAÇÃO
-- ============================================================
pcall(function()
    ApplySpeed()
    ApplyJump()
    AntiAFK()
    AntiKick()
end)

Notify("MM2 Hub", "Bem-vindo, " .. LocalPlayer.Name .. "! Jogo: " .. Game, 5)

-- Hotkey: tecla K reabre o hub
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.K then
        pcall(function() Window:Toggle() end)
    end
end)

-- Limpeza ao sair
Players.PlayerRemoving:Connect(function(p)
    if espCache[p] then
        pcall(function() espCache[p]:Destroy() end)
        espCache[p] = nil
    end
end)

print("[MM2 HUB] v1.1 | Executor: " .. executor .. " | Jogo: " .. Game)