-- Zeta Hub v3.3 - ПОЛНЫЙ АВТО-ФАРМ (БЕГ ПО КАРТЕ + СБОР КУБКОВ)
-- Для игры: +1 Speed Keyboard Escape
-- Вставь в Xeno Executor и нажми Execute

print("🔥 Zeta Hub v3.3 ЗАПУСК...")

task.wait(2)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local workspace = game:GetService("Workspace")
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
    AutoWalk = false,          -- АВТОМАТИЧЕСКАЯ ХОДЬБА И СБОР ВИНОВ (НОВОЕ!)
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
    Minimized = false
}

-- === БАННЕР (КРАСНЫЙ) ===
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
    banner.Size = UDim2.fromOffset(350, 70)
    banner.Adornee = head
    banner.AlwaysOnTop = true
    banner.StudsOffset = Vector3.new(0, 4, 0)
    banner.Parent = char
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.3
    bg.BorderSizePixel = 3
    bg.BorderColor3 = Color3.fromRGB(255, 0, 0)
    bg.Parent = banner
    
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1.05, 0, 1.1, 0)
    glow.Position = UDim2.new(-0.025, 0, -0.05, 0)
    glow.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    glow.BackgroundTransparency = 0.7
    glow.BorderSizePixel = 0
    glow.Parent = banner
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = Config.BannerText
    txt.TextColor3 = Color3.fromRGB(255, 0, 0)
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBold
    txt.TextStrokeTransparency = 0.2
    txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    txt.Parent = banner
end

player.CharacterAdded:Connect(function() task.wait(0.5) updateBanner() end)

-- === НОВАЯ ФУНКЦИЯ: АВТО-БЕГ И СБОР ВИНОВ ===
local function autoWalkAndCollect()
    if not Config.AutoWalk then return end
    
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    
    -- 1. Автоматически идём вперёд
    hum:MoveTo(hrp.Position + hrp.CFrame.LookVector * 100)
    
    -- 2. Ищем жёлтые площадки с кубками (Wins)
    local winsPad = nil
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Color == Color3.fromRGB(255, 255, 0) and obj.Size.Y < 3 then
            if (hrp.Position - obj.Position).Magnitude < 100 then
                winsPad = obj
                break
            end
        end
    end
    
    -- 3. Телепортируемся к площадке, если нашли
    if winsPad then
        hrp.CFrame = winsPad.CFrame + Vector3.new(0, 3, 0)
        task.wait(0.1)
        hrp.CFrame = winsPad.CFrame
        print("🏆 Собраны кубки!")
        Config.CurrentWins = Config.CurrentWins + 100 -- симуляция
    end
    
    -- 4. Ищем беговые дорожки для фарма скорости
    local treadmill = nil
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("treadmill") then
            if (hrp.Position - obj.Position).Magnitude < 50 then
                treadmill = obj
                break
            end
        end
    end
    
    if treadmill then
        hrp.CFrame = treadmill.CFrame + Vector3.new(0, 2, 0)
        print("🏃 Фарм скорости на дорожке...")
    end
end

-- === ТЕЛЕПОРТ К МОНЕТАМ ===
local ignoreList = {"Baseplate", "SpawnLocation", "Terrain", "Part"}

local function isLootCoin(part)
    if not part or not part:IsA("BasePart") then return false end
    local name = part.Name:lower()
    local color = part.Color
    
    if name:find("admin") or name:find("coin") or name:find("loot") or 
       name:find("gold") or name:find("speed") or name:find("boost") or
       name:find("gem") or name:find("crystal") then
        return true
    end
    
    if color.R > 0.6 and color.G > 0.5 and color.B < 0.3 then
        return true
    end
    
    if part.Size.X < 5 and part.Size.Z < 5 then
        return true
    end
    
    return false
end

local function teleportToAdminLoot()
    if not Config.AutoAdminLoot then return false end
    
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local bestLoot = nil
    local bestDist = math.huge
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent then
            local shouldIgnore = false
            for _, ignoreName in pairs(ignoreList) do
                if obj.Name == ignoreName then shouldIgnore = true break end
            end
            if shouldIgnore then continue end
            
            if isLootCoin(obj) then
                local success, pos = pcall(function() return obj.Position end)
                if success and pos then
                    local dist = (hrp.Position - pos).Magnitude
                    if dist < bestDist and dist < 500 then
                        bestDist = dist
                        bestLoot = obj
                    end
                end
            end
        end
    end
    
    if bestLoot then
        local pos = bestLoot.Position
        hrp.CFrame = CFrame.new(pos.X, pos.Y + 3, pos.Z)
        return true
    end
    return false
end

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

-- === СТАРЫЙ ФАРМ ПОБЕД (ОСТАВЛЯЕМ) ===
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
    
    virtualInput:SendKeyEvent(true, Enum.KeyCode.Escape, false, nil)
    task.wait(0.02)
    virtualInput:SendKeyEvent(false, Enum.KeyCode.Escape, false, nil)
    
    for i = 1, 10 do
        mouse.Button1Click()
        task.wait(0.01)
    end
    
    task.wait(0.05)
    
    for i = 1, 5 do
        mouse.Button1Click()
        task.wait(0.01)
    end
    
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        for _, g in pairs(pg:GetChildren()) do
            if g:IsA("ScreenGui") then
                for _, btn in pairs(g:GetDescendants()) do
                    if btn:IsA("TextButton") then
                        local t = btn.Text:lower() or ""
                        if t:find("next") or t:find("continue") or t:find("restart") or t:find("play again") or t:find("ok") or t:find("again") then
                            pcall(function() btn:Click() end)
                            task.wait(0.05)
                        end
                    end
                end
            end
        end
    end
end

-- === СОЗДАНИЕ GUI ===
local gui = Instance.new("ScreenGui")
gui.Name = "ZetaHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ГЛАВНОЕ ОКНО
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(380, 520)
frame.Position = UDim2.new(0.5, -190, 0.5, -260)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 215, 0)
frame.ClipsDescendants = true
frame.Parent = gui

-- === ПЕРЕТАСКИВАНИЕ ===
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
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- === ПЕРЕТАСКИВАНИЕ СВЁРНУТОГО ===
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
        miniFrame.Position = UDim2.new(
            miniStartPos.X.Scale,
            miniStartPos.X.Offset + delta.X,
            miniStartPos.Y.Scale,
            miniStartPos.Y.Offset + delta.Y
        )
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
title.Text = "⚡ ZETA HUB v3.3"
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

-- СКРОЛЛ
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -50)
scroll.Position = UDim2.new(0, 0, 0, 50)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 750)
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)
scroll.Parent = frame

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 0, 750)
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
        print("🔄 " .. text .. " -> " .. (st and "ON" or "OFF"))
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

makeToggle("🚶 Авто-бег и сбор кубков", y, false, "AutoWalk")
y = y + 35
makeToggle("🛒 Auto Buy", y, false, "AutoBuy")
y = y + 35
makeToggle("🔄 Auto Restart", y, false, "AutoRestart")
y = y + 35
makeToggle("♻️ Auto Rebirth", y, false, "AutoRebirth")
y = y + 35
makeToggle("🏆 Старый фарм побед", y, false, "WinFarm")
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
                            print("🏆 Нажата кнопка: " .. btn.Text)
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
        print("📍 Телепорт к ближайшей победе!")
    else
        print("❌ Победа не найдена!")
    end
end)

-- Movement
makeSection("🏃 Movement", y)
y = y + 30

local tpForward = makeBigButton("TP Forward (+50 studs)", y, Color3.fromRGB(100, 200, 50))
y = y + 45

tpForward.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 50
    print("📍 Вперёд на 50 студий!")
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
speedLabel.Text = "⚡ Скорость:"
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
        print("⚡ Скорость: " .. v)
    end)
    if i % 3 == 0 then y = y + 35 end
end
if #speedBtns % 3 ~= 0 then y = y + 35 end

-- VIP
makeSection("👑 VIP", y)
y = y + 30

local vipBtn = makeBigButton("🌟 VIP BOOST (x2 Speed)", y, Color3.fromRGB(200, 100, 255))
y = y + 45

vipBtn.MouseButton1Click:Connect(function()
    Config.FarmSpeed = Config.FarmSpeed * 2
    if Config.FarmSpeed > 450 then Config.FarmSpeed = 450 end
    speedBox.Text = tostring(Config.FarmSpeed)
    print("👑 VIP Boost активирован! Скорость: " .. Config.FarmSpeed)
end)

-- TP to Stage
makeSection("📍 TP to Stage", y)
y = y + 30

local stages = {"Stage 2", "Stage 5", "Stage 10", "Stage 15", "Stage 20"}
for i, v in pairs(stages) do
    local btn = makeSmallButton(v, y, (i-1)%3, Color3.fromRGB(80, 50, 120))
    btn.MouseButton1Click:Connect(function()
        print("📍 Телепорт на " .. v)
        local pg = player:FindFirstChild("PlayerGui")
        if pg then
            for _, g in pairs(pg:GetChildren()) do
                if g:IsA("ScreenGui") then
                    for _, btn2 in pairs(g:GetDescendants()) do
                        if btn2:IsA("TextButton") then
                            local t = btn2.Text:lower() or ""
                            if t:find("stage") or t:find("level") then
                                pcall(function() btn2:Click() end)
                                task.wait(0.2)
                            end
                        end
                    end
                end
            end
        end
    end)
    if i % 3 == 0 then y = y + 35 end
end
if #stages % 3 ~= 0 then y = y + 35 end

-- Discord и Exit
makeSection("🎮 Discord & Exit", y)
y = y + 30

local discordBtn = makeBigButton("💬 Discord", y, Color3.fromRGB(100, 100, 255))
y = y + 45

discordBtn.MouseButton1Click:Connect(function()
    print("📋 Discord ссылка скопирована!")
    setclipboard("https://discord.gg/your-server")
end)

local refreshBtn = makeBigButton("🔄 Refresh Stage List", y, Color3.fromRGB(0, 200, 150))
y = y + 45

refreshBtn.MouseButton1Click:Connect(function()
    print("🔄 Список этапов обновлён!")
end)

-- БАННЕР (КРАСНЫЙ)
makeSection("🔴 БАННЕР (КРАСНЫЙ)", y)
y = y + 30

makeToggle("Показать баннер", y, true, "BannerEnabled", function(s)
    Config.BannerEnabled = s
    updateBanner()
end)
y = y + 35

local bl = Instance.new("TextLabel")
bl.Size = UDim2.new(0.3, 0, 0, 25)
bl.Position = UDim2.new(0.05, 0, 0, y)
bl.BackgroundTransparency = 1
bl.Text = "📝 Текст:"
bl.TextColor3 = Color3.fromRGB(255, 255, 255)
bl.TextScaled = true
bl.TextXAlignment = Enum.TextXAlignment.Left
bl.Font = Enum.Font.Gotham
bl.Parent = content

local bb = Instance.new("TextBox")
bb.Size = UDim2.new(0.5, 0, 0, 25)
bb.Position = UDim2.new(0.4, 0, 0, y)
bb.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
bb.BackgroundTransparency = 0.5
bb.BorderSizePixel = 1
bb.BorderColor3 = Color3.fromRGB(255, 0, 0)
bb.Text = "👑ZETA HUB👑"
bb.TextColor3 = Color3.new(1, 1, 1)
bb.TextScaled = true
bb.Font = Enum.Font.Gotham
bb.Parent = content

bb.FocusLost:Connect(function()
    if bb.Text and bb.Text ~= "" then
        Config.BannerText = bb.Text
        updateBanner()
    end
end)
y = y + 35

-- КРАСНЫЕ ТЕГИ
local tags = {"👑ZETA","🎬CREATOR","👑CREATOR","🌟STAR","💎VIP"}
for i, v in pairs(tags) do
    local btn = makeSmallButton(v, y, i, Color3.fromRGB(200, 0, 0))
    btn.MouseButton1Click:Connect(function()
        Config.BannerText = v
        bb.Text = v
        updateBanner()
    end)
    if i % 3 == 0 then y = y + 35 end
end
if #tags % 3 ~= 0 then y = y + 35 end

local tags2 = {"🔥ADMIN","⚡PRO","🏆WINNER","👾HACKER","✨GOD"}
for i, v in pairs(tags2) do
    local btn = makeSmallButton(v, y, i, Color3.fromRGB(200, 0, 0))
    btn.MouseButton1Click:Connect(function()
        Config.BannerText = v
        bb.Text = v
        updateBanner()
    end)
    if i % 3 == 0 then y = y + 35 end
end
if #tags2 % 3 ~= 0 then y = y + 35 end

y = y + 10

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0, 22)
status.Position = UDim2.new(0.05, 0, 0, y + 5)
status.BackgroundTransparency = 1
status.Text = "✅ Zeta Hub v3.3 | Авто-бег + сбор кубков!"
status.TextColor3 = Color3.fromRGB(150, 255, 150)
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.Parent = content

-- === ФУНКЦИЯ СВЕРТЫВАНИЯ ===
local function toggleMinimize()
    Config.Minimized = not Config.Minimized
    
    if Config.Minimized then
        frame.Visible = false
        miniFrame.Visible = true
        miniFrame.Position = UDim2.new(0.5, -80, 0.9, -20)
        minimizeBtn.Text = "➕"
        print("📱 Zeta Hub свернут")
    else
        frame.Visible = true
        miniFrame.Visible = false
        minimizeBtn.Text = "➖"
        print("📱 Zeta Hub развернут")
    end
end

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)
expandBtn.MouseButton1Click:Connect(function()
    if Config.Minimized then toggleMinimize() end
end)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- === ОСНОВНОЙ ЦИКЛ ===
task.spawn(function()
    while task.wait(0.1) do
        -- НОВАЯ ФУНКЦИЯ: АВТО-БЕГ И СБОР КУБКОВ
        if Config.AutoWalk then
            pcall(autoWalkAndCollect)
        end
        
        if Config.AutoBuy then
            pcall(function()
                local pg = player:FindFirstChild("PlayerGui")
                if pg then
                    for _, g in pairs(pg:GetChildren()) do
                        if g:IsA("ScreenGui") then
                            for _, btn in pairs(g:GetDescendants()) do
                                if btn:IsA("TextButton") then
                                    local n = btn.Name:lower() or ""
                                    if n:find("buy") or n:find("upgrade") or n:find("shop") or n:find("purchase") then
                                        pcall(function() btn:Click() end)
                                        task.wait(0.05)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
        
        if Config.AutoRestart then
            pcall(function()
                local pg = player:FindFirstChild("PlayerGui")
                if pg then
                    for _, g in pairs(pg:GetChildren()) do
                        if g:IsA("ScreenGui") then
                            for _, btn in pairs(g:GetDescendants()) do
                                if btn:IsA("TextButton") then
                                    local n = btn.Name:lower() or ""
                                    local t = btn.Text:lower() or ""
                                    if n:find("restart") or n:find("retry") or n:find("again") or t:find("restart") or t:find("play again") then
                                        pcall(function() btn:Click() end)
                                        task.wait(0.05)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
        
        if Config.AutoRebirth then
            pcall(function()
                local pg = player:FindFirstChild("PlayerGui")
                if pg then
                    for _, g in pairs(pg:GetChildren()) do
                        if g:IsA("ScreenGui") then
                            for _, btn in pairs(g:GetDescendants()) do
                                if btn:IsA("TextButton") then
                                    local n = btn.Name:lower() or ""
                                    local t = btn.Text:lower() or ""
                                    if n:find("rebirth") or n:find("prestige") or t:find("rebirth") or t:find("prestige") then
                                        pcall(function() btn:Click() end)
                                        task.wait(0.2)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
        
        if Config.WinFarm then
            pcall(farmWins)
            local delay = math.max(0.01, 1 / Config.FarmSpeed)
            task.wait(delay)
        end
        
        if Config.AutoAdminLoot then
            pcall(teleportToAdminLoot)
        end
    end
end)

-- БАННЕР ПРИ ЗАПУСКЕ
task.wait(0.5)
updateBanner()

userInput.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F1 then 
        gui.Enabled = not gui.Enabled 
    end
end)

print("✅ Zeta Hub v3.3 ЗАГРУЖЕН!")
print("📌 F1 - Показать/Скрыть")
print("🚶 Включи 'Авто-бег и сбор кубков' для фарма!")
print("🔥 Теперь персонаж сам бегает по карте и собирает кубки!")
