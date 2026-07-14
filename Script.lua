print("🔥 Zeta Hub v4.2 ЗАПУСК...")

task.wait(2)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local virtualInput = game:GetService("VirtualInputManager")
local userInput = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")

if not player then
    print("❌ Игрок не найден!")
    return
end

print("✅ Игрок: " .. player.Name)

-- === НАСТРОЙКИ ===
local Config = {
    AutoClick = false,
    AutoBuy = false,
    AutoRestart = false,
    AutoRebirth = false,
    WinFarm = false,
    AutoAdminLoot = false,
    WinTarget = 1000000,
    CurrentWins = 0,
    FarmSpeed = 50,
    BannerText = "👑ZETA HUB👑",
    BannerEnabled = true,
    Minimized = false,
    Noclip = false,
    FlyMode = false,
    InfiniteJump = false,
    DisableEffects = false,
    -- НОВЫЕ ФУНКЦИИ
    TeleportToLastZone = false,
    AutoWalk = false,
    AntiAFK = false,
    AutoEquipBest = false
}

-- === ПЕРЕМЕННЫЕ ДЛЯ ANTI-AFK ===
local antiAFKTime = 0
local lastMoveTime = tick()

-- === НОВАЯ ФУНКЦИЯ: TELEPORT TO LAST ZONE ===
local function teleportToLastZone()
    if not Config.TeleportToLastZone then return end
    
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Ищем финишную зону (обычно жёлтая платформа в конце)
    local lastZone = nil
    local highestY = -math.huge
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Color == Color3.fromRGB(255, 255, 0) then
            if obj.Position.Y > highestY then
                highestY = obj.Position.Y
                lastZone = obj
            end
        end
    end
    
    -- Если не нашли жёлтую, ищем по названию
    if not lastZone then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("finish") or obj.Name:lower():find("end") or obj.Name:lower():find("goal") then
                if obj.Position.Y > highestY then
                    highestY = obj.Position.Y
                    lastZone = obj
                end
            end
        end
    end
    
    if lastZone then
        hrp.CFrame = lastZone.CFrame + Vector3.new(0, 5, 0)
        task.wait(0.1)
        hrp.CFrame = lastZone.CFrame
        print("📍 Телепорт к финишу!")
    end
end

-- === НОВАЯ ФУНКЦИЯ: AUTO WALK ===
local function autoWalk()
    if not Config.AutoWalk then return end
    
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Идём вперёд
    hum:MoveTo(hrp.Position + hrp.CFrame.LookVector * 100)
    
    -- Собираем скорость кликами
    local mouse = player:GetMouse()
    mouse.Button1Click()
end

-- === НОВАЯ ФУНКЦИЯ: ANTI-AFK ===
local function antiAFK()
    if not Config.AntiAFK then return end
    
    local now = tick()
    if now - antiAFKTime > 30 then
        antiAFKTime = now
        
        -- Имитация движения
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                -- Небольшое движение
                hum:MoveTo(char:FindFirstChild("HumanoidRootPart").Position + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)))
            end
        end
        
        -- Нажимаем клавишу для имитации активности
        virtualInput:SendKeyEvent(true, Enum.KeyCode.W, false, nil)
        task.wait(0.05)
        virtualInput:SendKeyEvent(false, Enum.KeyCode.W, false, nil)
        
        print("🔄 Anti-AFK: движение имитировано")
    end
end

-- === НОВАЯ ФУНКЦИЯ: AUTO EQUIP BEST AWARD ===
local function autoEquipBest()
    if not Config.AutoEquipBest then return end
    
    local pg = player:FindFirstChild("PlayerGui")
    if not pg then return end
    
    for _, g in pairs(pg:GetChildren()) do
        if g:IsA("ScreenGui") then
            for _, btn in pairs(g:GetDescendants()) do
                if btn:IsA("TextButton") then
                    local t = btn.Text:lower() or ""
                    -- Ищем кнопки с лучшими наградами
                    if t:find("best") or t:find("equip") or t:find("buy") or t:find("upgrade") then
                        if t:find("x100") or t:find("x25") or t:find("x10") or t:find("x5") then
                            pcall(function() btn:Click() end)
                            task.wait(0.1)
                            print("⚡ Куплено лучшее улучшение!")
                        end
                    end
                end
            end
        end
    end
end

-- === ОСТАЛЬНЫЕ ФУНКЦИИ ===
local function toggleNoclip(state)
    local char = player.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

local flyBodyVelocity = nil
local function toggleFly(state)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    
    if state then
        hum.PlatformStand = true
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
        flyBodyVelocity.Velocity = Vector3.new(0, 20, 0)
        flyBodyVelocity.Parent = hrp
    else
        hum.PlatformStand = false
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
    end
end

local function toggleInfiniteJump(state)
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    hum.JumpPower = state and 99999 or 50
end

local function toggleEffects(state)
    if state then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("Trail") then
                pcall(function() v.Enabled = false end)
            end
        end
        lighting.GlobalShadows = false
        lighting.Brightness = 0.5
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("Trail") then
                pcall(function() v.Enabled = true end)
            end
        end
        lighting.GlobalShadows = true
        lighting.Brightness = 2
    end
end

-- === УПРАВЛЕНИЕ ПОЛЁТОМ ===
userInput.InputBegan:Connect(function(input, processed)
    if processed then return end
    if not Config.FlyMode then return end
    if not flyBodyVelocity then return end
    
    if input.KeyCode == Enum.KeyCode.W then
        flyBodyVelocity.Velocity = Vector3.new(0, 20, 0)
    elseif input.KeyCode == Enum.KeyCode.S then
        flyBodyVelocity.Velocity = Vector3.new(0, -20, 0)
    elseif input.KeyCode == Enum.KeyCode.A then
        flyBodyVelocity.Velocity = Vector3.new(-20, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.D then
        flyBodyVelocity.Velocity = Vector3.new(20, 0, 0)
    end
end)

-- === БАННЕР ===
local banner = nil
local function updateBanner()
    local char = player.Character
    if not char then return end
    if banner then pcall(function() banner:Destroy() end) banner = nil end
    if not Config.BannerEnabled then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    banner = Instance.new("BillboardGui")
    banner.Name = "ZetaBanner"
    banner.Size = UDim2.fromOffset(400, 60)
    banner.Adornee = head
    banner.AlwaysOnTop = true
    banner.StudsOffset = Vector3.new(0, 3.5, 0)
    banner.Parent = char
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = Config.BannerText
    txt.TextColor3 = Color3.fromRGB(255, 0, 0)
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBold
    txt.TextStrokeTransparency = 0.15
    txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    txt.Parent = banner
end

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    updateBanner()
    if Config.Noclip then toggleNoclip(true) end
    if Config.FlyMode then toggleFly(true) end
    if Config.InfiniteJump then toggleInfiniteJump(true) end
end)

-- === ПОЛУЧЕНИЕ ПОБЕД ===
local function getWins()
    local pg = player:FindFirstChild("PlayerGui")
    if not pg then return 0 end
    for _, g in pairs(pg:GetChildren()) do
        if g:IsA("ScreenGui") then
            for _, v in pairs(g:GetDescendants()) do
                if v:IsA("TextLabel") or v:IsA("TextButton") then
                    local t = v.Text or ""
                    if t:find("Win") or t:find("Побед") or t:find("🏆") then
                        local n = t:match("%d+[,.]?%d*")
                        if n then
                            local w = tonumber(n:gsub(",", ""):gsub("%.", ""))
                            if w and w > 0 then return w end
                        end
                    end
                end
            end
        end
    end
    return 0
end

-- === ФАРМ ПОБЕД ===
local function farmWins()
    if not Config.WinFarm then return end
    local wins = getWins()
    Config.CurrentWins = wins
    if wins >= Config.WinTarget then
        print("🏆 Цель достигнута!")
        Config.WinFarm = false
        return
    end
    
    local mouse = player:GetMouse()
    
    -- ESCAPE
    virtualInput:SendKeyEvent(true, Enum.KeyCode.Escape, false, nil)
    task.wait(0.01)
    virtualInput:SendKeyEvent(false, Enum.KeyCode.Escape, false, nil)
    
    -- Клики для скорости
    for i = 1, 15 do
        mouse.Button1Click()
        task.wait(0.005)
    end
    
    task.wait(0.03)
    
    for i = 1, 8 do
        mouse.Button1Click()
        task.wait(0.005)
    end
    
    -- Ищем кнопку продолжения
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        for _, g in pairs(pg:GetChildren()) do
            if g:IsA("ScreenGui") then
                for _, btn in pairs(g:GetDescendants()) do
                    if btn:IsA("TextButton") then
                        local t = btn.Text:lower() or ""
                        if t:find("next") or t:find("continue") or t:find("restart") or t:find("play again") or t:find("ok") or t:find("again") then
                            pcall(function() btn:Click() end)
                            task.wait(0.03)
                        end
                    end
                end
            end
        end
    end
end

-- === ТЕЛЕПОРТ К ПОБЕДАМ ===
local function tpToNearestWin()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local best = nil
    local bestDist = math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Color == Color3.fromRGB(255, 255, 0) then
            local dist = (hrp.Position - obj.Position).Magnitude
            if dist < bestDist and dist < 200 then
                bestDist = dist
                best = obj
            end
        end
    end
    if best then
        hrp.CFrame = best.CFrame + Vector3.new(0, 3, 0)
        task.wait(0.1)
        hrp.CFrame = best.CFrame
        print("📍 Телепорт к победе!")
    end
end

-- === TP FORWARD ===
local function tpForward()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 50
    print("📍 Вперёд на 50 студий!")
end

-- === СОЗДАНИЕ GUI ===
local gui = Instance.new("ScreenGui")
gui.Name = "ZetaHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ГЛАВНОЕ ОКНО
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(420, 680)
frame.Position = UDim2.new(0.5, -210, 0.5, -340)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 215, 0)
frame.ClipsDescendants = true
frame.Parent = gui

-- ПЕРЕТАСКИВАНИЕ
local dragStart, startPos, dragging = nil, nil, false
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)
frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
userInput.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ЗАГОЛОВОК
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
titleBar.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ ZETA HUB v4.2"
title.TextColor3 = Color3.new(0, 0, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

-- КНОПКИ УПРАВЛЕНИЯ
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -65, 0.5, -15)
minimizeBtn.Text = "➖"
minimizeBtn.TextColor3 = Color3.new(0, 0, 0)
minimizeBtn.TextScaled = true
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.BackgroundTransparency = 0.4
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -5, 0.5, -15)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(0, 0, 0)
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.BackgroundTransparency = 0.4
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

-- СВЁРНУТОЕ МЕНЮ
local miniFrame = Instance.new("Frame")
miniFrame.Size = UDim2.fromOffset(160, 45)
miniFrame.Position = UDim2.new(0.5, -80, 0.9, -20)
miniFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
miniFrame.BackgroundTransparency = 0.85
miniFrame.BorderSizePixel = 2
miniFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
miniFrame.Visible = false
miniFrame.Parent = gui

local miniText = Instance.new("TextLabel")
miniText.Size = UDim2.new(1, 0, 1, 0)
miniText.BackgroundTransparency = 1
miniText.Text = "ZETA HUB"
miniText.TextColor3 = Color3.fromRGB(255, 255, 255)
miniText.TextScaled = true
miniText.Font = Enum.Font.GothamBold
miniText.TextStrokeTransparency = 0.3
miniText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
miniText.Parent = miniFrame

local expandBtn = Instance.new("TextButton")
expandBtn.Size = UDim2.new(1, 0, 1, 0)
expandBtn.BackgroundTransparency = 1
expandBtn.Text = ""
expandBtn.Parent = miniFrame

-- ПЕРЕТАСКИВАНИЕ СВЁРНУТОГО
local miniDragStart, miniStartPos, miniDragging = nil, nil, false
miniFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        miniDragging = true
        miniDragStart = input.Position
        miniStartPos = miniFrame.Position
    end
end)
miniFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        miniDragging = false
    end
end)
userInput.InputChanged:Connect(function(input)
    if miniDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - miniDragStart
        miniFrame.Position = UDim2.new(miniStartPos.X.Scale, miniStartPos.X.Offset + delta.X, miniStartPos.Y.Scale, miniStartPos.Y.Offset + delta.Y)
    end
end)

-- СКРОЛЛ
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -50)
scroll.Position = UDim2.new(0, 0, 0, 50)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 1050)
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)
scroll.Parent = frame

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 0, 1050)
content.BackgroundTransparency = 1
content.Parent = scroll

-- === ФУНКЦИИ ===
local function makeSection(title, y)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.9, 0, 0, 25)
    lbl.Position = UDim2.new(0.05, 0, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = Color3.fromRGB(255, 215, 0)
    lbl.TextScaled = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.GothamBold
    lbl.Parent = content
    return lbl
end

local function makeBigButton(text, y, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 60)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(255, 215, 0)
    btn.Parent = content
    return btn
end

local function makeSmallButton(text, y, x, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.28, 0, 0, 30)
    btn.Position = UDim2.new(0.05 + x * 0.34, 0, 0, y)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 80)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(255, 215, 0)
    btn.Parent = content
    return btn
end

local function makeToggle(text, y, default, key, cb)
    local c = Instance.new("Frame")
    c.Size = UDim2.new(0.9, 0, 0, 30)
    c.Position = UDim2.new(0.05, 0, 0, y)
    c.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    c.BackgroundTransparency = 0.3
    c.BorderSizePixel = 1
    c.BorderColor3 = Color3.fromRGB(255, 215, 0)
    c.Parent = content
    
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.6, 0, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.new(1, 1, 1)
    l.TextScaled = true
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.Gotham
    l.Parent = c
    
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.25, 0, 0.7, 0)
    b.Position = UDim2.new(0.72, 0, 0.15, 0)
    b.Text = default and "ON" or "OFF"
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextScaled = true
    b.Font = Enum.Font.GothamBold
    b.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    b.BorderSizePixel = 0
    b.Parent = c
    
    local st = default
    b.MouseButton1Click:Connect(function()
        st = not st
        b.Text = st and "ON" or "OFF"
        b.BackgroundColor3 = st and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        Config[key] = st
        if cb then cb(st) end
        
        if key == "Noclip" then toggleNoclip(st) end
        if key == "FlyMode" then toggleFly(st) end
        if key == "InfiniteJump" then toggleInfiniteJump(st) end
        if key == "DisableEffects" then toggleEffects(st) end
    end)
    return c
end

-- === ПОСТРОЕНИЕ МЕНЮ ===
local y = 10

-- ИНФО
local infoLine1 = Instance.new("TextLabel")
infoLine1.Size = UDim2.new(0.9, 0, 0, 20)
infoLine1.Position = UDim2.new(0.05, 0, 0, y)
infoLine1.BackgroundTransparency = 1
infoLine1.Text = "🏆 Побед: 0 | Цель: 1,000,000"
infoLine1.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLine1.TextScaled = true
infoLine1.Font = Enum.Font.Gotham
infoLine1.Parent = content
y = y + 25

task.spawn(function()
    while task.wait(1) do
        local w = getWins()
        Config.CurrentWins = w
        infoLine1.Text = "🏆 Побед: " .. string.format("%d", w) .. " | Цель: " .. string.format("%d", Config.WinTarget)
    end
end)

-- === НОВАЯ СЕКЦИЯ: ФАРМ КУБКОВ ===
makeSection("🏆 ФАРМ КУБКОВ (WINS)", y)
y = y + 30

makeToggle("🚀 Teleport to Last Zone", y, false, "TeleportToLastZone")
y = y + 35
makeToggle("🚶 Auto Walk", y, false, "AutoWalk")
y = y + 35
makeToggle("🛡️ Anti-AFK", y, false, "AntiAFK")
y = y + 35
makeToggle("⚡ Auto Equip Best Award", y, false, "AutoEquipBest")
y = y + 40

-- MOVEMENT (из Pulse Hub)
makeSection("🏃 MOVEMENT", y)
y = y + 30

makeToggle("🚪 Noclip (Сквозь стены)", y, false, "Noclip")
y = y + 35
makeToggle("✈️ Fly Mode (WASD)", y, false, "FlyMode")
y = y + 35
makeToggle("🦘 Infinite Jump", y, false, "InfiniteJump")
y = y + 40

-- VISUALS
makeSection("🎨 VISUALS", y)
y = y + 30

makeToggle("⚡ Disable Effects (FPS+)", y, false, "DisableEffects")
y = y + 40

-- GAME SPEED
makeSection("⚡ GAME SPEED (+1 KEYBOARD ESCAPE)", y)
y = y + 30

local add1000 = makeBigButton("Add +1000 Game Speed", y, Color3.fromRGB(0, 100, 200))
y = y + 45
local add10000 = makeBigButton("Add +10000 Game Speed", y, Color3.fromRGB(0, 150, 200))
y = y + 45

add1000.MouseButton1Click:Connect(function()
    Config.WinTarget = Config.WinTarget + 1000
    print("🎯 +1000 к цели! Цель: " .. Config.WinTarget)
end)

add10000.MouseButton1Click:Connect(function()
    Config.WinTarget = Config.WinTarget + 10000
    print("🎯 +10000 к цели! Цель: " .. Config.WinTarget)
end)

-- NO KEY
makeSection("🔑 NO KEY", y)
y = y + 30

makeToggle("🖱️ Auto Click", y, false, "AutoClick")
y = y + 35
makeToggle("🛒 Auto Buy", y, false, "AutoBuy")
y = y + 35
makeToggle("🔄 Auto Restart", y, false, "AutoRestart")
y = y + 35
makeToggle("♻️ Auto Rebirth", y, false, "AutoRebirth")
y = y + 35
makeToggle("🏆 Фарм побед", y, false, "WinFarm")
y = y + 40

-- WINS & STAGES
makeSection("🏆 WINS & STAGES", y)
y = y + 30

local tpWin = makeBigButton("TP TO WIN + UNLOCK GAMEPASS", y, Color3.fromRGB(200, 100, 0))
y = y + 45

tpWin.MouseButton1Click:Connect(function()
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        for _, g in pairs(pg:GetChildren()) do
            if g:IsA("ScreenGui") then
                for _, btn in pairs(g:GetDescendants()) do
                    if btn:IsA("TextButton") then
                        local t = btn.Text:lower() or ""
                        if t:find("win") or t:find("claim") or t:find("collect") or t:find("get") then
                            pcall(function() btn:Click() end)
                            task.wait(0.2)
                        end
                    end
                end
            end
        end
    end
    print("🏆 Попытка собрать победы!")
end)

-- Teleport
makeSection("📡 Teleport", y)
y = y + 30

local tpNearest = makeBigButton("TP to Nearest Win Pad", y, Color3.fromRGB(0, 150, 200))
y = y + 45

tpNearest.MouseButton1Click:Connect(function()
    tpToNearestWin()
end)

-- Movement
makeSection("🏃 Movement", y)
y = y + 30

local tpForwardBtn = makeBigButton("TP Forward (+50 studs)", y, Color3.fromRGB(100, 200, 50))
y = y + 45

tpForwardBtn.MouseButton1Click:Connect(function()
    tpForward()
end)

-- Speed Farm
makeSection("⚡ Speed Farm", y)
y = y + 30

makeToggle("💰 Auto Admin Loot TP", y, false, "AutoAdminLoot")
y = y + 35

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.35, 0, 0, 25)
speedLabel.Position = UDim2.new(0.05, 0, 0, y)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ Speed Modifier:"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = content

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.4, 0, 0, 25)
speedBox.Position = UDim2.new(0.45, 0, 0, y)
speedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
speedBox.BackgroundTransparency = 0.5
speedBox.BorderSizePixel = 1
speedBox.BorderColor3 = Color3.fromRGB(255, 215, 0)
speedBox.Text = "50"
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.TextScaled = true
speedBox.Font = Enum.Font.Gotham
speedBox.Parent = content

speedBox.FocusLost:Connect(function()
    local n = tonumber(speedBox.Text)
    if n and n >= 1 and n <= 450 then Config.FarmSpeed = n end
end)
y = y + 33

local speedBtns = {"1","10","25","50","100","150","250","450"}
for i, v in pairs(speedBtns) do
    local btn = makeSmallButton(v, y, (i-1)%3, Color3.fromRGB(50, 80, 120))
    btn.MouseButton1Click:Connect(function()
        Config.FarmSpeed = tonumber(v)
        speedBox.Text = v
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = tonumber(v) + 16
            end
        end
    end)
    if i % 3 == 0 then y = y + 35 end
end
if #speedBtns % 3 ~= 0 then y = y + 35 end

-- AUTO
make
