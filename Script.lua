-- ════════════════════════════════════════════════════════════
--  ZETA HUB v6.0 - FULLY WORKING
--  Для игры: +1 Speed Keyboard Escape
--  by KaiScritps
-- ════════════════════════════════════════════════════════════

print("🔥 ЗАГРУЗКА ZETA HUB v6.0...")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

if not player then
    print("❌ Игрок не найден!")
    return
end

-- Ждем загрузки
repeat task.wait() until player and player.Character
print("✅ Игрок: " .. player.Name)

-- Удаляем старые GUI
local oldGui = player.PlayerGui:FindFirstChild("ZetaHub")
if oldGui then oldGui:Destroy() end
local oldLoad = player.PlayerGui:FindFirstChild("LoadingScreen")
if oldLoad then oldLoad:Destroy() end
local oldKey = player.PlayerGui:FindFirstChild("KeySystem")
if oldKey then oldKey:Destroy() end

-- ════════════════════════════════════════════════════════════
--  АНИМИРОВАННАЯ ЗАГРУЗКА
-- ════════════════════════════════════════════════════════════

local loadGui = Instance.new("ScreenGui")
loadGui.Name = "LoadingScreen"
loadGui.ResetOnSpawn = false
loadGui.Parent = player.PlayerGui

local loadBg = Instance.new("Frame")
loadBg.Size = UDim2.new(1, 0, 1, 0)
loadBg.BackgroundColor3 = Color3.fromRGB(8, 8, 25)
loadBg.Parent = loadGui

-- Частицы
for i = 1, 30 do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, math.random(2, 5), 0, math.random(2, 5))
    p.Position = UDim2.new(math.random(), 0, math.random(), 0)
    p.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    p.BackgroundTransparency = 0.8
    p.BorderSizePixel = 0
    p.Parent = loadBg
    TweenService:Create(p, TweenInfo.new(math.random(3, 6), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
        Position = UDim2.new(math.random(), 0, math.random(), 0)
    }):Play()
end

-- Лого
local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(0, 350, 0, 70)
logo.Position = UDim2.new(0.5, -175, 0.3, -35)
logo.BackgroundTransparency = 1
logo.Text = "⚡ ZETA HUB"
logo.TextColor3 = Color3.fromRGB(255, 215, 0)
logo.TextSize = 50
logo.Font = Enum.Font.GothamBold
logo.Parent = loadBg

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(0, 250, 0, 25)
sub.Position = UDim2.new(0.5, -125, 0.3, 40)
sub.BackgroundTransparency = 1
sub.Text = "PREMIUM v6.0"
sub.TextColor3 = Color3.fromRGB(180, 180, 255)
sub.TextSize = 16
sub.Font = Enum.Font.Gotham
sub.Parent = loadBg

-- Спиннер
local spinner = Instance.new("Frame")
spinner.Size = UDim2.new(0, 50, 0, 50)
spinner.Position = UDim2.new(0.5, -25, 0.5, -25)
spinner.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
spinner.BackgroundTransparency = 0.9
spinner.BorderSizePixel = 3
spinner.BorderColor3 = Color3.fromRGB(255, 215, 0)
spinner.Parent = loadBg
TweenService:Create(spinner, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
    Rotation = 360
}):Play()

local loadText = Instance.new("TextLabel")
loadText.Size = UDim2.new(0, 300, 0, 25)
loadText.Position = UDim2.new(0.5, -150, 0.5, 45)
loadText.BackgroundTransparency = 1
loadText.Text = "Загрузка..."
loadText.TextColor3 = Color3.fromRGB(200, 200, 200)
loadText.TextSize = 14
loadText.Font = Enum.Font.Gotham
loadText.Parent = loadBg

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0, 250, 0, 4)
barBg.Position = UDim2.new(0.5, -125, 0.5, 70)
barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
barBg.BorderSizePixel = 0
barBg.Parent = loadBg

local bar = Instance.new("Frame")
bar.Size = UDim2.new(0, 0, 1, 0)
bar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
bar.BorderSizePixel = 0
bar.Parent = barBg

local progress = 0

local function updateLoad(text, prog)
    loadText.Text = text
    if prog then progress = prog end
    if progress < 100 then progress = progress + 5 end
    if progress > 100 then progress = 100 end
    TweenService:Create(bar, TweenInfo.new(0.3), {
        Size = UDim2.new(progress / 100, 0, 1, 0)
    }):Play()
end

-- ════════════════════════════════════════════════════════════
--  СИСТЕМА КЛЮЧЕЙ
-- ════════════════════════════════════════════════════════════

local function showKeySystem()
    updateLoad("Проверка ключа...", 30)
    task.wait(0.5)
    
    loadGui:Destroy()
    
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "KeySystem"
    keyGui.ResetOnSpawn = false
    keyGui.Parent = player.PlayerGui
    
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.7
    overlay.Parent = keyGui
    
    local keyFrame = Instance.new("Frame")
    keyFrame.Size = UDim2.new(0, 400, 0, 300)
    keyFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    keyFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 30)
    keyFrame.BorderSizePixel = 2
    keyFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
    keyFrame.ClipsDescendants = true
    keyFrame.Parent = overlay
    
    -- Анимация появления
    keyFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(keyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 400, 0, 300),
        Position = UDim2.new(0.5, -200, 0.5, -150)
    }):Play()
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    title.Text = "🔐 ВВЕДИТЕ КЛЮЧ"
    title.TextColor3 = Color3.fromRGB(0, 0, 0)
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.Parent = keyFrame
    
    local lock = Instance.new("TextLabel")
    lock.Size = UDim2.new(0, 60, 0, 60)
    lock.Position = UDim2.new(0.5, -30, 0, 70)
    lock.BackgroundTransparency = 1
    lock.Text = "🔒"
    lock.TextSize = 40
    lock.Parent = keyFrame
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0, 220, 0, 40)
    input.Position = UDim2.new(0.5, -110, 0, 150)
    input.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    input.BorderSizePixel = 2
    input.BorderColor3 = Color3.fromRGB(255, 215, 0)
    input.Text = ""
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.TextSize = 16
    input.PlaceholderText = "Введите ключ..."
    input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    input.Font = Enum.Font.Gotham
    input.Parent = keyFrame
    
    local submit = Instance.new("TextButton")
    submit.Size = UDim2.new(0, 180, 0, 40)
    submit.Position = UDim2.new(0.5, -90, 0, 210)
    submit.Text = "✅ ПОДТВЕРДИТЬ"
    submit.TextColor3 = Color3.fromRGB(0, 0, 0)
    submit.TextSize = 16
    submit.Font = Enum.Font.GothamBold
    submit.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    submit.BorderSizePixel = 0
    submit.Parent = keyFrame
    
    local error = Instance.new("TextLabel")
    error.Size = UDim2.new(1, 0, 0, 25)
    error.Position = UDim2.new(0, 0, 0, 255)
    error.BackgroundTransparency = 1
    error.Text = ""
    error.TextColor3 = Color3.fromRGB(255, 100, 100)
    error.TextSize = 13
    error.Font = Enum.Font.Gotham
    error.Parent = keyFrame
    
    local function checkKey()
        if input.Text == "ZetaHub" then
            error.Text = "✅ Ключ принят!"
            error.TextColor3 = Color3.fromRGB(100, 255, 100)
            task.wait(0.3)
            keyGui:Destroy()
            createMainUI()
        else
            error.Text = "❌ НЕВЕРНЫЙ КЛЮЧ!"
            error.TextColor3 = Color3.fromRGB(255, 100, 100)
            -- Встряска
            for i = 1, 3 do
                keyFrame.Position = UDim2.new(0.5, -200 + math.random(-10, 10), 0.5, -150)
                task.wait(0.05)
            end
            keyFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
            input.Text = ""
        end
    end
    
    submit.MouseButton1Click:Connect(checkKey)
    input.FocusLost:Connect(function(enter)
        if enter then checkKey() end
    end)
end

-- ════════════════════════════════════════════════════════════
--  АВТОФАРМ КУБКОВ
-- ════════════════════════════════════════════════════════════

local isFarming = false
local farmSpeed = 0.3
local farmLoop = nil
local wins = 0
local farmStatusText = nil
local winsLabel = nil

function startFarm()
    if isFarming then return end
    isFarming = true
    print("🟢 Автофарм запущен!")
    
    -- Ищем объекты для фарма
    local function findFarmObjects()
        local objects = {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") or obj:IsA("MeshPart") then
                local name = obj.Name:lower()
                if name:find("win") or name:find("point") or name:find("goal") or name:find("finish") or name:find("checkpoint") then
                    table.insert(objects, obj)
                end
            end
        end
        return objects
    end
    
    farmLoop = RunService.Heartbeat:Connect(function()
        if not isFarming then return end
        
        local character = player.Character
        if not character then return end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
        if not humanoid then return end
        
        -- Находим ближайший объект для фарма
        local farmObjects = findFarmObjects()
        local closest = nil
        local closestDist = math.huge
        
        for _, obj in ipairs(farmObjects) do
            if obj and obj.Position then
                local dist = (hrp.Position - obj.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = obj
                end
            end
        end
        
        if closest then
            -- Телепортируемся к объекту
            hrp.CFrame = CFrame.new(closest.Position + Vector3.new(0, 3, 0))
            task.wait(0.1)
            
            -- Симулируем нажатие для победы
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, nil)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, nil)
            
            wins = wins + 1
            if winsLabel then
                winsLabel.Text = "🏆 " .. wins
            end
            if farmStatusText then
                farmStatusText.Text = "🟢 Фарм активен | Побед: " .. wins
            end
            print("🏆 Победа #" .. wins)
        else
            -- Если объектов нет, просто бегаем
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, nil)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, nil)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, nil)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, nil)
        end
        
        task.wait(farmSpeed)
    end)
end

function stopFarm()
    if not isFarming then return end
    isFarming = false
    if farmLoop then
        farmLoop:Disconnect()
        farmLoop = nil
    end
    if farmStatusText then
        farmStatusText.Text = "🔴 Фарм выключен"
    end
    print("🔴 Автофарм остановлен")
end

-- ════════════════════════════════════════════════════════════
--  ОСНОВНОЙ GUI
-- ════════════════════════════════════════════════════════════

function createMainUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "ZetaHub"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui
    
    -- Главное окно
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 420, 0, 550)
    main.Position = UDim2.new(0.5, -210, 0.5, -275)
    main.BackgroundColor3 = Color3.fromRGB(8, 8, 25)
    main.BorderSizePixel = 2
    main.BorderColor3 = Color3.fromRGB(255, 215, 0)
    main.ClipsDescendants = true
    main.Parent = gui
    
    -- Анимация появления
    main.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 420, 0, 550),
        Position = UDim2.new(0.5, -210, 0.5, -275)
    }):Play()
    
    -- Верхняя панель
    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 50)
    top.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    top.BorderSizePixel = 0
    top.Parent = main
    
    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(0.6, 0, 1, 0)
    logo.Position = UDim2.new(0, 10, 0, 0)
    logo.BackgroundTransparency = 1
    logo.Text = "⚡ ZETA HUB"
    logo.TextColor3 = Color3.fromRGB(0, 0, 0)
    logo.TextSize = 22
    logo.TextXAlignment = Enum.TextXAlignment.Left
    logo.Font = Enum.Font.GothamBold
    logo.Parent = top
    
    -- Кнопки
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(1, -65, 0.5, -15)
    minBtn.Text = "─"
    minBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    minBtn.TextSize = 18
    minBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.BackgroundTransparency = 0.3
    minBtn.BorderSizePixel = 0
    minBtn.Parent = top
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0.5, -15)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    closeBtn.TextSize = 18
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = top
    
    closeBtn.MouseButton1Click:Connect(function()
        stopFarm()
        TweenService:Create(main, TweenInfo.new(0.3), { Size = UDim2.new(0, 0, 0, 0) }):Play()
        task.wait(0.3)
        gui:Destroy()
    end)
    
    -- Статус бар
    local status = Instance.new("Frame")
    status.Size = UDim2.new(1, 0, 0, 30)
    status.Position = UDim2.new(0, 0, 0, 50)
    status.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
    status.BorderSizePixel = 0
    status.Parent = main
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(0.5, -10, 1, 0)
    statusText.Position = UDim2.new(0, 10, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "🟢 Онлайн"
    statusText.TextColor3 = Color3.fromRGB(150, 255, 150)
    statusText.TextSize = 13
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.Font = Enum.Font.Gotham
    statusText.Parent = status
    
    winsLabel = Instance.new("TextLabel")
    winsLabel.Size = UDim2.new(0.45, 0, 1, 0)
    winsLabel.Position = UDim2.new(0.55, 0, 0, 0)
    winsLabel.BackgroundTransparency = 1
    winsLabel.Text = "🏆 0"
    winsLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    winsLabel.TextSize = 14
    winsLabel.TextXAlignment = Enum.TextXAlignment.Right
    winsLabel.Font = Enum.Font.GothamBold
    winsLabel.Parent = status
    
    -- Вкладки
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 40)
    tabContainer.Position = UDim2.new(0, 0, 0, 80)
    tabContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 28)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = main
    
    local tabs = {"⚔️ ФАРМ", "⚡ НАСТРОЙКИ"}
    local tabButtons = {}
    local tabContents = {}
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, -120)
    content.Position = UDim2.new(0, 0, 0, 120)
    content.BackgroundTransparency = 1
    content.Parent = main
    
    for i = 1, 2 do
        local tc = Instance.new("ScrollingFrame")
        tc.Size = UDim2.new(1, 0, 1, 0)
        tc.BackgroundTransparency = 1
        tc.CanvasSize = UDim2.new(0, 0, 0, 400)
        tc.ScrollBarThickness = 3
        tc.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)
        tc.Visible = (i == 1)
        tc.Parent = content
        
        local inner = Instance.new("Frame")
        inner.Size = UDim2.new(1, 0, 0, 400)
        inner.BackgroundTransparency = 1
        inner.Parent = tc
        
        tabContents[i] = inner
    end
    
    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.5, 0, 1, 0)
        btn.Position = UDim2.new((i-1) * 0.5, 0, 0, 0)
        btn.Text = name
        btn.TextColor3 = (i == 1) and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(150, 150, 150)
        btn.TextSize = 14
        btn.BackgroundTransparency = 1
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = tabContainer
        tabButtons[i] = btn
        
        btn.MouseButton1Click:Connect(function()
            for j, tc in pairs(tabContents) do
                tc.Visible = (j == i)
            end
            for j, b in pairs(tabButtons) do
                b.TextColor3 = (j == i) and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(150, 150, 150)
            end
        end)
    end
    
    -- ════════════════════════════════════════════════════════
    --  ВКЛАДКА ФАРМ
    -- ════════════════════════════════════════════════════════
    
    local farmTab = tabContents[1]
    local y = 10
    
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(0.92, 0, 0, 30)
    section.Position = UDim2.new(0.04, 0, 0, y)
    section.BackgroundTransparency = 1
    section.Text = "🤖 АВТОФАРМ КУБКОВ"
    section.TextColor3 = Color3.fromRGB(255, 215, 0)
    section.TextSize = 16
    section.TextXAlignment = Enum.TextXAlignment.Left
    section.Font = Enum.Font.GothamBold
    section.Parent = farmTab
    y = y + 35
    
    farmStatusText = Instance.new("TextLabel")
    farmStatusText.Size = UDim2.new(0.92, 0, 0, 30)
    farmStatusText.Position = UDim2.new(0.04, 0, 0, y)
    farmStatusText.BackgroundTransparency = 1
    farmStatusText.Text = "🔴 Фарм выключен"
    farmStatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
    farmStatusText.TextSize = 15
    farmStatusText.TextXAlignment = Enum.TextXAlignment.Center
    farmStatusText.Font = Enum.Font.Gotham
    farmStatusText.Parent = farmTab
    y = y + 35
    
    local farmBtn = Instance.new("TextButton")
    farmBtn.Size = UDim2.new(0.92, 0, 0, 40)
    farmBtn.Position = UDim2.new(0.04, 0, 0, y)
    farmBtn.Text = "▶️ ЗАПУСТИТЬ ФАРМ"
    farmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    farmBtn.TextSize = 16
    farmBtn.Font = Enum.Font.GothamBold
    farmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    farmBtn.BorderSizePixel = 0
    farmBtn.Parent = farmTab
    
    local farming = false
    
    farmBtn.MouseButton1Click:Connect(function()
        farming = not farming
        if farming then
            farmBtn.Text = "⏹️ ОСТАНОВИТЬ ФАРМ"
            farmBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            startFarm()
        else
            farmBtn.Text = "▶️ ЗАПУСТИТЬ ФАРМ"
            farmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            stopFarm()
        end
    end)
    y = y + 45
    
    local speedBtn = Instance.new("TextButton")
    speedBtn.Size = UDim2.new(0.92, 0, 0, 35)
    speedBtn.Position = UDim2.new(0.04, 0, 0, y)
    speedBtn.Text = "🚀 Ускорить фарм"
    speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedBtn.TextSize = 14
    speedBtn.Font = Enum.Font.Gotham
    speedBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 0)
    speedBtn.BorderSizePixel = 0
    speedBtn.Parent = farmTab
    
    speedBtn.MouseButton1Click:Connect(function()
        if farmSpeed > 0.05 then
            farmSpeed = farmSpeed / 1.5
            statusText.Text = "⚡ Скорость: " .. string.format("%.2f", farmSpeed)
        end
    end)
    y = y + 40
    
    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(0.92, 0, 0, 35)
    resetBtn.Position = UDim2.new(0.04, 0, 0, y)
    resetBtn.Text = "🔄 Сбросить скорость"
    resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetBtn.TextSize = 14
    resetBtn.Font = Enum.Font.Gotham
    resetBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
    resetBtn.BorderSizePixel = 0
    resetBtn.Parent = farmTab
    
    resetBtn.MouseButton1Click:Connect(function()
        farmSpeed = 0.3
        statusText.Text = "🟢 Онлайн"
    end)
    
    -- ════════════════════════════════════════════════════════
    --  ВКЛАДКА НАСТРОЙКИ
    -- ════════════════════════════════════════════════════════
    
    local settingsTab = tabContents[2]
    y = 10
    
    local section2 = Instance.new("TextLabel")
    section2.Size = UDim2.new(0.92, 0, 0, 30)
    section2.Position = UDim2.new(0.04, 0, 0, y)
    section2.BackgroundTransparency = 1
    section2.Text = "⚡ БЫСТРЫЕ НАСТРОЙКИ"
    section2.TextColor3 = Color3.fromRGB(255, 215, 0)
    section2.TextSize = 16
    section2.TextXAlignment = Enum.TextXAlignment.Left
    section2.Font = Enum.Font.GothamBold
    section2.Parent = settingsTab
    y = y + 35
    
    local function createSettingBtn(text, y, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.92, 0, 0, 38)
        btn.Position = UDim2.new(0.04, 0, 0, y)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.Gotham
        btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 55)
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(255, 215, 0)
        btn.Parent = settingsTab
        
        btn.MouseButton1Click:Connect(callback)
        return btn
    end
    
    createSettingBtn("👤 Телепорт в центр", y, Color3.fromRGB(0, 100, 200), function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
            statusText.Text = "✅ Телепорт выполнен"
        end
    end)
    y = y + 43
    
    createSettingBtn("🏃 Супер-скорость (x5)", y, Color3.fromRGB(0, 200, 100), function()
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildWhichIsA("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 80
                humanoid.JumpPower = 100
                statusText.Text = "✅ Скорость увеличена!"
            end
        end
    end)
    y = y + 43
    
    createSettingBtn("💫 Мега-прыжок", y, Color3.fromRGB(150, 0, 200), function()
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildWhichIsA("Humanoid")
            if humanoid then
                humanoid.JumpPower = 150
                statusText.Text = "✅ Прыжок увеличен!"
            end
        end
    end)
    y = y + 43
    
    createSettingBtn("🛡️ Сброс скорости", y, Color3.fromRGB(200, 50, 50), function()
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildWhichIsA("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
                statusText.Text = "🟢 Скорость сброшена"
            end
        end
    end)
    
    -- ════════════════════════════════════════════════════════
    --  ПЕРЕТАСКИВАНИЕ
    -- ════════════════════════════════════════════════════════
    
    local dragStart, startPos, dragging = nil, nil, false
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    main.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    userInput.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Свертывание
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            main.Size = UDim2.new(0, 160, 0, 40)
            main.Position = UDim2.new(0.5, -80, 0.9, -20)
            content.Visible = false
            status.Visible = false
            tabContainer.Visible = false
            top.Size = UDim2.new(1, 0, 1, 0)
            minBtn.Text = "➕"
        else
            main.Size = UDim2.new(0, 420, 0, 550)
            main.Position = UDim2.new(0.5, -210, 0.5, -275)
            content.Visible = true
            status.Visible = true
            tabContainer.Visible = true
            top.Size = UDim2.new(1, 0, 0, 50)
            minBtn.Text = "─"
        end
    end)
    
    -- Горячие клавиши
    userInput.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.F1 then
            main.Visible = not main.Visible
        end
        if input.KeyCode == Enum.KeyCode.F2 then
            farming = not farming
            if farming then
                farmBtn.Text = "⏹️ ОСТАНОВИТЬ ФАРМ"
                farmBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                startFarm()
            else
                farmBtn.Text = "▶️ ЗАПУСТИТЬ ФАРМ"
                farmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                stopFarm()
            end
        end
    end)
    
    print("✅ ZETA HUB ЗАГРУЖЕН!")
    print("📌 F1 - Показать/Скрыть")
    print("📌 F2 - Вкл/Выкл фарм")
end

-- ════════════════════════════════════════════════════════════
--  ЗАПУСК
-- ════════════════════════════════════════════════════════════

-- Анимация загрузки
updateLoad("Инициализация...", 10)
task.wait(0.3)
updateLoad("Загрузка модулей...", 25)
task.wait(0.3)
updateLoad("Подключение к серверу...", 40)
task.wait(0.3)
updateLoad("Проверка лицензии...", 55)
task.wait(0.3)

-- Показываем систему ключей
showKeySystem()
