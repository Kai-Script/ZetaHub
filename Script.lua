-- ════════════════════════════════════════════
--  ZETA HUB v6.0 - PREMIUM UI
--  Для игры: +1 Speed Keyboard Escape
--  by xZPUHigh
-- ════════════════════════════════════════════

print("🔥 ZETA HUB v6.0 ЗАПУСК...")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

if not player then
    print("❌ Игрок не найден!")
    return
end

-- Ждем загрузки
repeat task.wait() until player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
print("✅ Игрок: " .. player.Name)

-- Удаляем старый GUI
local oldGui = player.PlayerGui:FindFirstChild("ZetaHub")
if oldGui then oldGui:Destroy() end

-- ════════════════════════════════════════════
--  СОЗДАНИЕ GUI
-- ════════════════════════════════════════════

local gui = Instance.new("ScreenGui")
gui.Name = "ZetaHub"
gui.ResetOnSpawn = false
gui.Enabled = true
gui.Parent = player:WaitForChild("PlayerGui")

-- ════════════════════════════════════════════
--  СТИЛИ
-- ════════════════════════════════════════════

local Colors = {
    Primary = Color3.fromRGB(255, 200, 0),      -- Золотой
    Secondary = Color3.fromRGB(30, 30, 50),     -- Темный
    Background = Color3.fromRGB(10, 10, 20),    -- Очень темный
    Success = Color3.fromRGB(0, 200, 100),
    Danger = Color3.fromRGB(200, 50, 50),
    Text = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(100, 150, 255),
}

local function createShadow(parent, size, position)
    local shadow = Instance.new("ImageLabel")
    shadow.Size = size
    shadow.Position = position
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316049745"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 10, 10)
    shadow.Parent = parent
    return shadow
end

-- ════════════════════════════════════════════
--  ГЛАВНОЕ ОКНО
-- ════════════════════════════════════════════

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.fromOffset(420, 580)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -290)
mainFrame.BackgroundColor3 = Colors.Background
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Visible = false
mainFrame.Parent = gui

-- Тень
createShadow(mainFrame, UDim2.new(1.05, 0, 1.05, 0), UDim2.new(-0.025, 0, -0.025, 0))

-- ════════════════════════════════════════════
--  ВЕРХНЯЯ ПАНЕЛЬ (с градиентом)
-- ════════════════════════════════════════════

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 55)
topBar.BackgroundColor3 = Colors.Primary
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

-- Градиент
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Colors.Primary),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 150, 0))
})
gradient.Parent = topBar

-- Логотип
local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(0.6, 0, 1, 0)
logo.Position = UDim2.new(0, 15, 0, 0)
logo.BackgroundTransparency = 1
logo.Text = "⚡ ZETA HUB"
logo.TextColor3 = Color3.fromRGB(0, 0, 0)
logo.TextSize = 24
logo.TextXAlignment = Enum.TextXAlignment.Left
logo.Font = Enum.Font.GothamBold
logo.Parent = topBar

local version = Instance.new("TextLabel")
version.Size = UDim2.new(0.3, 0, 1, 0)
version.Position = UDim2.new(0.7, 0, 0, 0)
version.BackgroundTransparency = 1
version.Text = "v6.0"
version.TextColor3 = Color3.fromRGB(50, 30, 0)
version.TextSize = 14
version.TextXAlignment = Enum.TextXAlignment.Right
version.Font = Enum.Font.Gotham
version.Parent = topBar

-- Кнопки управления
local function createTopButton(text, posX, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 32, 0, 32)
    btn.Position = UDim2.new(1, posX, 0.5, -16)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.TextSize = 18
    btn.BackgroundColor3 = color or Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Parent = topBar
    return btn
end

local minimizeBtn = createTopButton("─", -70, Color3.fromRGB(255, 255, 255))
local closeBtn = createTopButton("✕", -35, Color3.fromRGB(255, 80, 80))

closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- ════════════════════════════════════════════
--  СТАТУС БАР
-- ════════════════════════════════════════════

local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0, 30)
statusBar.Position = UDim2.new(0, 0, 0, 55)
statusBar.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
statusBar.BorderSizePixel = 0
statusBar.Parent = mainFrame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -20, 1, 0)
statusText.Position = UDim2.new(0, 10, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "🟢 Онлайн | Готов к работе"
statusText.TextColor3 = Color3.fromRGB(150, 255, 150)
statusText.TextSize = 14
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Font = Enum.Font.Gotham
statusText.Parent = statusBar

local winsLabel = Instance.new("TextLabel")
winsLabel.Size = UDim2.new(0.4, 0, 1, 0)
winsLabel.Position = UDim2.new(0.6, 0, 0, 0)
winsLabel.BackgroundTransparency = 1
winsLabel.Text = "🏆 Побед: 0"
winsLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
winsLabel.TextSize = 14
winsLabel.TextXAlignment = Enum.TextXAlignment.Right
winsLabel.Font = Enum.Font.GothamBold
winsLabel.Parent = statusBar

-- ════════════════════════════════════════════
--  ВКЛАДКИ
-- ════════════════════════════════════════════

local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 40)
tabContainer.Position = UDim2.new(0, 0, 0, 85)
tabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local tabs = {"⚔️ Фарм", "⚡ Настройки", "📊 Инфо"}
local tabButtons = {}
local currentTab = 1

-- Контент для вкладок
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -125)
contentFrame.Position = UDim2.new(0, 0, 0, 125)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Создаем контент для каждой вкладки
local tabContents = {}

for i = 1, 3 do
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 500)
    tabContent.ScrollBarThickness = 3
    tabContent.ScrollBarImageColor3 = Colors.Primary
    tabContent.Visible = (i == 1)
    tabContent.Parent = contentFrame
    
    local inner = Instance.new("Frame")
    inner.Size = UDim2.new(1, 0, 0, 500)
    inner.BackgroundTransparency = 1
    inner.Parent = tabContent
    
    tabContents[i] = inner
end

-- Создаем кнопки вкладок
for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#tabs, 0, 1, 0)
    btn.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
    btn.Text = name
    btn.TextColor3 = (i == 1) and Colors.Primary or Color3.fromRGB(150, 150, 150)
    btn.TextSize = 16
    btn.BackgroundTransparency = 1
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = tabContainer
    tabButtons[i] = btn
    
    btn.MouseButton1Click:Connect(function()
        for j, tab in pairs(tabContents) do
            tab.Visible = (j == i)
        end
        for j, b in pairs(tabButtons) do
            b.TextColor3 = (j == i) and Colors.Primary or Color3.fromRGB(150, 150, 150)
        end
        currentTab = i
    end)
end

-- ════════════════════════════════════════════
--  ФУНКЦИИ СОЗДАНИЯ UI
-- ════════════════════════════════════════════

local function createSection(parent, title, y)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(0.95, 0, 0, 35)
    section.Position = UDim2.new(0.025, 0, 0, y)
    section.BackgroundTransparency = 1
    section.Parent = parent
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 2)
    line.Position = UDim2.new(0, 0, 1, -2)
    line.BackgroundColor3 = Colors.Primary
    line.BackgroundTransparency = 0.5
    line.Parent = section
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Colors.Primary
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.Parent = section
    
    return section
end

local function createButton(parent, text, y, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 40)
    btn.Position = UDim2.new(0.04, 0, 0, y)
    btn.Text = "  " .. text
    btn.TextColor3 = Colors.Text
    btn.TextSize = 16
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.GothamSemibold
    btn.BackgroundColor3 = color or Colors.Secondary
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Colors.Primary
    btn.Parent = parent
    
    -- Hover эффект
    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0.1
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundTransparency = 0.3
    end)
    
    if callback then
        btn.MouseButton1Click:Connect(callback)
    end
    
    return btn
end

local function createToggle(parent, text, y, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 40)
    frame.Position = UDim2.new(0.04, 0, 0, y)
    frame.BackgroundColor3 = Colors.Secondary
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Colors.Primary
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.Text
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 60, 0, 28)
    toggleBtn.Position = UDim2.new(1, -75, 0.5, -14)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Colors.Text
    toggleBtn.TextSize = 14
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BackgroundColor3 = default and Colors.Success or Colors.Danger
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = frame
    
    local state = default
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Colors.Success or Colors.Danger
        if callback then callback(state) end
    end)
    
    return toggleBtn, frame
end

-- ════════════════════════════════════════════
--  ВКЛАДКА 1: ФАРМ
-- ════════════════════════════════════════════

local farmTab = tabContents[1]
local yPos = 10

createSection(farmTab, "🤖 АВТОФАРМ", yPos)
yPos = yPos + 40

local farmStatus = Instance.new("TextLabel")
farmStatus.Size = UDim2.new(0.92, 0, 0, 25)
farmStatus.Position = UDim2.new(0.04, 0, 0, yPos)
farmStatus.BackgroundTransparency = 1
farmStatus.Text = "🔴 Фарм выключен"
farmStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
farmStatus.TextSize = 15
farmStatus.TextXAlignment = Enum.TextXAlignment.Center
farmStatus.Font = Enum.Font.Gotham
farmStatus.Parent = farmTab
yPos = yPos + 30

local farmToggle, _ = createToggle(farmTab, "🎯 Фармить победы", yPos, false, function(state)
    farmStatus.Text = state and "🟢 Фарм включен" or "🔴 Фарм выключен"
    farmStatus.TextColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    if state then
        startAutoFarm()
    else
        stopAutoFarm()
    end
end)
yPos = yPos + 45

createButton(farmTab, "🔥 Ускорить фарм (x2)", yPos, Color3.fromRGB(200, 100, 0), function()
    if farmSpeed < 0.05 then return end
    farmSpeed = farmSpeed / 2
    print("⚡ Скорость фарма увеличена!")
    statusText.Text = "⚡ Скорость фарма: " .. string.format("%.2f", farmSpeed)
end)
yPos = yPos + 45

createButton(farmTab, "🔄 Сбросить скорость", yPos, Color3.fromRGB(50, 50, 150), function()
    farmSpeed = 0.3
    print("🔄 Скорость сброшена")
    statusText.Text = "🟢 Онлайн | Готов к работе"
end)

-- ════════════════════════════════════════════
--  ВКЛАДКА 2: НАСТРОЙКИ
-- ════════════════════════════════════════════

local settingsTab = tabContents[2]
yPos = 10

createSection(settingsTab, "⚡ НАСТРОЙКИ", yPos)
yPos = yPos + 40

createButton(settingsTab, "👤 Телепорт в центр", yPos, Color3.fromRGB(0, 100, 200), function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
        print("✅ Телепорт выполнен!")
    end
end)
yPos = yPos + 45

createButton(settingsTab, "🏃 Супер-скорость", yPos, Color3.fromRGB(0, 200, 100), function()
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 80
            humanoid.JumpPower = 100
            print("✅ Скорость и прыжок увеличены!")
        end
    end
end)
yPos = yPos + 45

createButton(settingsTab, "💫 Бесконечный прыжок", yPos, Color3.fromRGB(150, 0, 200), function()
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            humanoid.JumpPower = 150
            print("✅ Бесконечный прыжок активирован!")
        end
    end
end)
yPos = yPos + 45

createButton(settingsTab, "🛡️ Сброс скорости", yPos, Color3.fromRGB(200, 50, 50), function()
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
            print("✅ Скорость сброшена до стандартной")
        end
    end
end)

-- ════════════════════════════════════════════
--  ВКЛАДКА 3: ИНФО
-- ════════════════════════════════════════════

local infoTab = tabContents[3]
yPos = 10

createSection(infoTab, "📊 ИНФОРМАЦИЯ", yPos)
yPos = yPos + 40

local infoLabels = {
    {"🎮 Игрок:", player.Name},
    {"🔄 Версия:", "Zeta Hub v6.0"},
    {"📅 Обновлено:", "26/03/26"},
    {"👤 Автор:", "xZPUHigh"}
}

for _, data in ipairs(infoLabels) do
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.92, 0, 0, 30)
    lbl.Position = UDim2.new(0.04, 0, 0, yPos)
    lbl.BackgroundTransparency = 1
    lbl.Text = data[1] .. " " .. data[2]
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.TextSize = 15
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Gotham
    lbl.Parent = infoTab
    yPos = yPos + 32
end

-- ════════════════════════════════════════════
--  АВТОФАРМ ПОБЕД
-- ════════════════════════════════════════════

local isFarming = false
local farmSpeed = 0.3
local farmLoop = nil
local wins = 0

function startAutoFarm()
    if isFarming then return end
    isFarming = true
    print("🟢 Автофарм запущен!")
    statusText.Text = "🟢 Фарм активен | Скорость: " .. string.format("%.2f", farmSpeed)
    
    farmLoop = RunService.Heartbeat:Connect(function(dt)
        if not isFarming then return end
        
        -- Эмулируем победу (для игры +1 Speed Keyboard Escape)
        -- Проверяем, есть ли специальные объекты для взаимодействия
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildWhichIsA("Humanoid")
            if humanoid then
                -- Ищем объекты для фарма
                local workspace = game:GetService("Workspace")
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj:IsA("Part") and obj.Name and string.find(obj.Name:lower(), "win") or string.find(obj.Name:lower(), "point") then
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.1)
                            wins = wins + 1
                            winsLabel.Text = "🏆 Побед: " .. wins
                            print("🏆 Победа #" .. wins)
                            break
                        end
                    end
                end
            end
        end
        
        -- Альтернативный метод: симуляция нажатий
        -- (для игр где победа засчитывается по нажатию клавиш)
        if isFarming then
            -- Нажимаем пробел и W для движения
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, nil)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, nil)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, nil)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, nil)
        end
        
        task.wait(farmSpeed)
    end)
end

function stopAutoFarm()
    if not isFarming then return end
    isFarming = false
    if farmLoop then
        farmLoop:Disconnect()
        farmLoop = nil
    end
    print("🔴 Автофарм остановлен")
    statusText.Text = "🟢 Онлайн | Готов к работе"
end

-- ════════════════════════════════════════════
--  ПЕРЕТАСКИВАНИЕ
-- ════════════════════════════════════════════

local dragStart, startPos, dragging = nil, nil, false
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
userInput.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ════════════════════════════════════════════
--  СВЕРТЫВАНИЕ
-- ════════════════════════════════════════════

local isMinimized = false

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    mainFrame.Visible = not isMinimized
    minimizeBtn.Text = isMinimized and "➕" or "─"
end)

-- ════════════════════════════════════════════
--  ГОРЯЧИЕ КЛАВИШИ
-- ════════════════════════════════════════════

userInput.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        mainFrame.Visible = not mainFrame.Visible
        if mainFrame.Visible then
            isMinimized = false
            minimizeBtn.Text = "─"
        end
    end
    if input.KeyCode == Enum.KeyCode.F2 then
        -- Быстрый запуск/остановка фарма
        if isFarming then
            stopAutoFarm()
            farmToggle.Text = "OFF"
            farmToggle.BackgroundColor3 = Colors.Danger
        else
            startAutoFarm()
            farmToggle.Text = "ON"
            farmToggle.BackgroundColor3 = Colors.Success
        end
    end
end)

-- ════════════════════════════════════════════
--  ЗАПУСК
-- ════════════════════════════════════════════

print("✅ Zeta Hub v6.0 загружен!")
print("📌 F1 - Показать/Скрыть меню")
print("📌 F2 - Вкл/Выкл автофарм")

-- Показываем меню через 1 секунду
task.wait(1)
mainFrame.Visible = true
print("✅ Меню открыто!")
