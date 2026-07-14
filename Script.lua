-- ════════════════════════════════════════════════════════════
--  ZETA HUB v6.0 PREMIUM ANIMATED
--  Для игры: +1 Speed Keyboard Escape
--  by xZPUHigh
-- ════════════════════════════════════════════════════════════

print("🔥 ЗАГРУЗКА ZETA HUB v6.0...")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")

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

-- ════════════════════════════════════════════════════════════
--  АНИМИРОВАННАЯ ЗАГРУЗКА
-- ════════════════════════════════════════════════════════════

local loadGui = Instance.new("ScreenGui")
loadGui.Name = "LoadingScreen"
loadGui.ResetOnSpawn = false
loadGui.Parent = player:WaitForChild("PlayerGui")

-- Фон с градиентом
local loadBg = Instance.new("Frame")
loadBg.Size = UDim2.new(1, 0, 1, 0)
loadBg.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
loadBg.Parent = loadGui

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 5, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 30))
})
bgGradient.Parent = loadBg

-- Анимированные частицы
for i = 1, 20 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
    particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
    particle.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    particle.BackgroundTransparency = 0.7
    particle.BorderSizePixel = 0
    particle.Parent = loadBg
    
    local goal = {
        Position = UDim2.new(math.random(), 0, math.random(), 0),
        BackgroundTransparency = 0
    }
    
    local tween = TweenService:Create(particle, TweenInfo.new(math.random(3, 8), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), goal)
    tween:Play()
end

-- Логотип
local loadLogo = Instance.new("TextLabel")
loadLogo.Size = UDim2.new(0, 400, 0, 80)
loadLogo.Position = UDim2.new(0.5, -200, 0.3, 0)
loadLogo.BackgroundTransparency = 1
loadLogo.Text = "⚡ ZETA HUB"
loadLogo.TextColor3 = Color3.fromRGB(255, 215, 0)
loadLogo.TextSize = 60
loadLogo.Font = Enum.Font.GothamBold
loadLogo.Parent = loadBg

-- Подзаголовок
local loadSub = Instance.new("TextLabel")
loadSub.Size = UDim2.new(0, 300, 0, 30)
loadSub.Position = UDim2.new(0.5, -150, 0.3, 70)
loadSub.BackgroundTransparency = 1
loadSub.Text = "PREMIUM v6.0"
loadSub.TextColor3 = Color3.fromRGB(200, 200, 255)
loadSub.TextSize = 18
loadSub.Font = Enum.Font.Gotham
loadSub.Parent = loadBg

-- Анимированный круг загрузки
local spinner = Instance.new("Frame")
spinner.Size = UDim2.new(0, 60, 0, 60)
spinner.Position = UDim2.new(0.5, -30, 0.5, -30)
spinner.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
spinner.BackgroundTransparency = 0.8
spinner.BorderSizePixel = 3
spinner.BorderColor3 = Color3.fromRGB(255, 215, 0)
spinner.Parent = loadBg

-- Анимация вращения
local spinGoal = { Rotation = 360 }
local spinTween = TweenService:Create(spinner, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), spinGoal)
spinTween:Play()

-- Текст загрузки
local loadText = Instance.new("TextLabel")
loadText.Size = UDim2.new(0, 300, 0, 30)
loadText.Position = UDim2.new(0.5, -150, 0.5, 50)
loadText.BackgroundTransparency = 1
loadText.Text = "Загрузка..."
loadText.TextColor3 = Color3.fromRGB(200, 200, 200)
loadText.TextSize = 16
loadText.Font = Enum.Font.Gotham
loadText.Parent = loadBg

-- Полоса загрузки
local loadBarBg = Instance.new("Frame")
loadBarBg.Size = UDim2.new(0, 300, 0, 6)
loadBarBg.Position = UDim2.new(0.5, -150, 0.5, 80)
loadBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
loadBarBg.BorderSizePixel = 0
loadBarBg.Parent = loadBg

local loadBar = Instance.new("Frame")
loadBar.Size = UDim2.new(0, 0, 1, 0)
loadBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
loadBar.BorderSizePixel = 0
loadBar.Parent = loadBarBg

-- Анимация загрузки
local progress = 0
local loadComplete = false

local function updateLoad(text, prog)
    loadText.Text = text
    progress = prog or progress + 5
    if progress > 100 then progress = 100 end
    
    local barGoal = { Size = UDim2.new(progress / 100, 0, 1, 0) }
    local barTween = TweenService:Create(loadBar, TweenInfo.new(0.3, Enum.EasingStyle.Quad), barGoal)
    barTween:Play()
end

-- ════════════════════════════════════════════════════════════
--  СИСТЕМА КЛЮЧЕЙ
-- ════════════════════════════════════════════════════════════

local function showKeySystem()
    updateLoad("Проверка ключа...", 30)
    task.wait(0.5)
    
    -- Создаем окно ввода ключа
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "KeySystem"
    keyGui.ResetOnSpawn = false
    keyGui.Parent = player.PlayerGui
    
    -- Затемнение
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.7
    overlay.Parent = keyGui
    
    -- Окно
    local keyFrame = Instance.new("Frame")
    keyFrame.Size = UDim2.new(0, 420, 0, 320)
    keyFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
    keyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
    keyFrame.BorderSizePixel = 2
    keyFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
    keyFrame.Parent = overlay
    
    -- Анимация появления
    keyFrame.BackgroundTransparency = 1
    local appearTween = TweenService:Create(keyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), { BackgroundTransparency = 0 })
    appearTween:Play()
    
    -- Заголовок
    local keyTitle = Instance.new("TextLabel")
    keyTitle.Size = UDim2.new(1, 0, 0, 60)
    keyTitle.Position = UDim2.new(0, 0, 0, 0)
    keyTitle.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    keyTitle.Text = "🔐 ВВЕДИТЕ КЛЮЧ"
    keyTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
    keyTitle.TextSize = 24
    keyTitle.Font = Enum.Font.GothamBold
    keyTitle.Parent = keyFrame
    
    -- Иконка замка
    local lockIcon = Instance.new("TextLabel")
    lockIcon.Size = UDim2.new(0, 80, 0, 80)
    lockIcon.Position = UDim2.new(0.5, -40, 0, 70)
    lockIcon.BackgroundTransparency = 1
    lockIcon.Text = "🔒"
    lockIcon.TextSize = 50
    lockIcon.Parent = keyFrame
    
    -- Поле ввода
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(0, 250, 0, 40)
    keyInput.Position = UDim2.new(0.5, -125, 0, 160)
    keyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    keyInput.BackgroundTransparency = 0.5
    keyInput.BorderSizePixel = 2
    keyInput.BorderColor3 = Color3.fromRGB(255, 215, 0)
    keyInput.Text = ""
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.TextSize = 18
    keyInput.PlaceholderText = "Введите ключ..."
    keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    keyInput.Font = Enum.Font.Gotham
    keyInput.Parent = keyFrame
    
    -- Кнопка подтверждения
    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(0, 200, 0, 45)
    submitBtn.Position = UDim2.new(0.5, -100, 0, 220)
    submitBtn.Text = "✅ ПОДТВЕРДИТЬ"
    submitBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    submitBtn.TextSize = 18
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    submitBtn.BorderSizePixel = 0
    submitBtn.Parent = keyFrame
    
    -- Текст ошибки
    local errorText = Instance.new("TextLabel")
    errorText.Size = UDim2.new(1, 0, 0, 30)
    errorText.Position = UDim2.new(0, 0, 0, 270)
    errorText.BackgroundTransparency = 1
    errorText.Text = ""
    errorText.TextColor3 = Color3.fromRGB(255, 100, 100)
    errorText.TextSize = 14
    errorText.Font = Enum.Font.Gotham
    errorText.Parent = keyFrame
    
    -- Функция проверки ключа
    local function checkKey()
        local entered = keyInput.Text
        if entered == "ZetaHub" then
            errorText.Text = "✅ Ключ принят! Загрузка..."
            errorText.TextColor3 = Color3.fromRGB(100, 255, 100)
            task.wait(0.5)
            keyGui:Destroy()
            loadGui:Destroy()
            createMainUI()
        else
            errorText.Text = "❌ НЕВЕРНЫЙ КЛЮЧ! Попробуйте снова."
            errorText.TextColor3 = Color3.fromRGB(255, 100, 100)
            -- Анимация встряски
            local shakeTween = TweenService:Create(keyFrame, TweenInfo.new(0.1), { Position = UDim2.new(0.5, -220, 0.5, -160) })
            shakeTween:Play()
            task.wait(0.1)
            local shakeTween2 = TweenService:Create(keyFrame, TweenInfo.new(0.1), { Position = UDim2.new(0.5, -200, 0.5, -160) })
            shakeTween2:Play()
            task.wait(0.1)
            local shakeTween3 = TweenService:Create(keyFrame, TweenInfo.new(0.1), { Position = UDim2.new(0.5, -210, 0.5, -160) })
            shakeTween3:Play()
        end
    end
    
    submitBtn.MouseButton1Click:Connect(checkKey)
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then checkKey() end
    end)
end

-- ════════════════════════════════════════════════════════════
--  ОСНОВНОЙ GUI (КРАСИВЫЙ И АНИМИРОВАННЫЙ)
-- ════════════════════════════════════════════════════════════

local mainGui = nil
local isFarming = false
local farmSpeed = 0.3
local farmLoop = nil
local wins = 0
local colors = {
    Primary = Color3.fromRGB(255, 215, 0),
    Secondary = Color3.fromRGB(20, 20, 45),
    Background = Color3.fromRGB(8, 8, 25),
    Success = Color3.fromRGB(0, 220, 100),
    Danger = Color3.fromRGB(220, 50, 50),
    Text = Color3.fromRGB(255, 255, 255)
}

function createMainUI()
    mainGui = Instance.new("ScreenGui")
    mainGui.Name = "ZetaHub"
    mainGui.ResetOnSpawn = false
    mainGui.Parent = player.PlayerGui
    
    -- ════════════════════════════════════════════════════════
    --  ГЛАВНОЕ ОКНО С АНИМАЦИЕЙ
    -- ════════════════════════════════════════════════════════
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 450, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
    mainFrame.BackgroundColor3 = colors.Background
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = colors.Primary
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = mainGui
    
    -- Анимация появления
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 450, 0, 600),
        Position = UDim2.new(0.5, -225, 0.5, -300)
    })
    openTween:Play()
    
    -- Тень
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1.05, 0, 1.05, 0)
    shadow.Position = UDim2.new(-0.025, 0, -0.025, 0)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316049745"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 10, 10)
    shadow.Parent = mainFrame
    
    -- ════════════════════════════════════════════════════════
    --  ВЕРХНЯЯ ПАНЕЛЬ С ГРАДИЕНТОМ
    -- ════════════════════════════════════════════════════════
    
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 60)
    topBar.BackgroundColor3 = colors.Primary
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, colors.Primary),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 180, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 150, 0))
    })
    gradient.Parent = topBar
    
    -- Анимированный логотип
    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(0.6, 0, 1, 0)
    logo.Position = UDim2.new(0, 15, 0, 0)
    logo.BackgroundTransparency = 1
    logo.Text = "⚡ ZETA HUB"
    logo.TextColor3 = Color3.fromRGB(0, 0, 0)
    logo.TextSize = 26
    logo.TextXAlignment = Enum.TextXAlignment.Left
    logo.Font = Enum.Font.GothamBold
    logo.Parent = topBar
    
    -- Анимация пульсации логотипа
    local pulseTween = TweenService:Create(logo, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        TextSize = 28
    })
    pulseTween:Play()
    
    -- Кнопки управления
    local function createTopBtn(text, posX, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 35, 0, 35)
        btn.Position = UDim2.new(1, posX, 0.5, -17.5)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        btn.TextSize = 20
        btn.BackgroundColor3 = color or Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 0.3
        btn.BorderSizePixel = 0
        btn.Parent = topBar
        return btn
    end
    
    local minimizeBtn = createTopBtn("─", -75, Color3.fromRGB(255, 255, 255))
    local closeBtn = createTopBtn("✕", -35, Color3.fromRGB(255, 80, 80))
    
    closeBtn.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        closeTween:Play()
        task.wait(0.3)
        mainGui:Destroy()
    end)
    
    -- ════════════════════════════════════════════════════════
    --  СТАТУС БАР
    -- ════════════════════════════════════════════════════════
    
    local statusBar = Instance.new("Frame")
    statusBar.Size = UDim2.new(1, 0, 0, 35)
    statusBar.Position = UDim2.new(0, 0, 0, 60)
    statusBar.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
    statusBar.BorderSizePixel = 0
    statusBar.Parent = mainFrame
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(0.5, -10, 1, 0)
    statusText.Position = UDim2.new(0, 10, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "🟢 Онлайн"
    statusText.TextColor3 = Color3.fromRGB(150, 255, 150)
    statusText.TextSize = 14
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.Font = Enum.Font.Gotham
    statusText.Parent = statusBar
    
    local winsLabel = Instance.new("TextLabel")
    winsLabel.Size = UDim2.new(0.45, 0, 1, 0)
    winsLabel.Position = UDim2.new(0.55, 0, 0, 0)
    winsLabel.BackgroundTransparency = 1
    winsLabel.Text = "🏆 0"
    winsLabel.TextColor3 = colors.Primary
    winsLabel.TextSize = 16
    winsLabel.TextXAlignment = Enum.TextXAlignment.Right
    winsLabel.Font = Enum.Font.GothamBold
    winsLabel.Parent = statusBar
    
    -- ════════════════════════════════════════════════════════
    --  ВКЛАДКИ
    -- ════════════════════════════════════════════════════════
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 45)
    tabContainer.Position = UDim2.new(0, 0, 0, 95)
    tabContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 28)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame
    
    local tabs = {"⚔️ ФАРМ", "⚡ НАСТРОЙКИ", "📊 СТАТИСТИКА"}
    local tabButtons = {}
    local tabContents = {}
    
    -- Контейнер для контента
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -140)
    contentFrame.Position = UDim2.new(0, 0, 0, 140)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Создаем вкладки
    for i = 1, 3 do
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 550)
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = colors.Primary
        tabContent.Visible = (i == 1)
        tabContent.Parent = contentFrame
        
        local inner = Instance.new("Frame")
        inner.Size = UDim2.new(1, 0, 0, 550)
        inner.BackgroundTransparency = 1
        inner.Parent = tabContent
        
        tabContents[i] = inner
    end
    
    -- Создаем кнопки вкладок
    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1/3, 0, 1, 0)
        btn.Position = UDim2.new((i-1)/3, 0, 0, 0)
        btn.Text = name
        btn.TextColor3 = (i == 1) and colors.Primary or Color3.fromRGB(150, 150, 150)
        btn.TextSize = 14
        btn.BackgroundTransparency = 1
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = tabContainer
        tabButtons[i] = btn
        
        -- Индикатор
        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0.3, 0, 0, 3)
        indicator.Position = UDim2.new(0.35, 0, 1, 0)
        indicator.BackgroundColor3 = colors.Primary
        indicator.BackgroundTransparency = (i == 1) and 0 or 1
        indicator.BorderSizePixel = 0
        indicator.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            for j, tab in pairs(tabContents) do
                tab.Visible = (j == i)
            end
            for j, b in pairs(tabButtons) do
                b.TextColor3 = (j == i) and colors.Primary or Color3.fromRGB(150, 150, 150)
                local ind = b:FindFirstChildWhichIsA("Frame")
                if ind then
                    ind.BackgroundTransparency = (j == i) and 0 or 1
                end
            end
        end)
    end
    
    -- ════════════════════════════════════════════════════════
    --  ФУНКЦИИ СОЗДАНИЯ UI
    -- ════════════════════════════════════════════════════════
    
    local function createSection(parent, text, y)
        local section = Instance.new("Frame")
        section.Size = UDim2.new(0.95, 0, 0, 35)
        section.Position = UDim2.new(0.025, 0, 0, y)
        section.BackgroundTransparency = 1
        section.Parent = parent
        
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, 0, 0, 2)
        line.Position = UDim2.new(0, 0, 1, -2)
        line.BackgroundColor3 = colors.Primary
        line.BackgroundTransparency = 0.5
        line.Parent = section
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.8, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = colors.Primary
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamBold
        label.Parent = section
        
        return section
    end
    
    local function createBtn(parent, text, y, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.92, 0, 0, 42)
        btn.Position = UDim2.new(0.04, 0, 0, y)
        btn.Text = "  " .. text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 15
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Font = Enum.Font.GothamSemibold
        btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 55)
        btn.BackgroundTransparency = 0.3
        btn.BorderSizePixel = 1
        btn.BorderColor3 = colors.Primary
        btn.Parent = parent
        
        -- Hover анимация
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundTransparency = 0.1 }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundTransparency = 0.3 }):Play()
        end)
        
        if callback then
            btn.MouseButton1Click:Connect(callback)
        end
        
        return btn
    end
    
    local function createToggle(parent, text, y, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.92, 0, 0, 42)
        frame.Position = UDim2.new(0.04, 0, 0, y)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 1
        frame.BorderColor3 = colors.Primary
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 15
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.Parent = frame
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 65, 0, 30)
        toggleBtn.Position = UDim2.new(1, -75, 0.5, -15)
        toggleBtn.Text = default and "ON" or "OFF"
        toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleBtn.TextSize = 14
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.BackgroundColor3 = default and colors.Success or colors.Danger
        toggleBtn.BorderSizePixel = 0
        toggleBtn.Parent = frame
        
        local state = default
        toggleBtn.MouseButton1Click:Connect(function()
            state = not state
            toggleBtn.Text = state and "ON" or "OFF"
            toggleBtn.BackgroundColor3 = state and colors.Success or colors.Danger
            if callback then callback(state) end
        end)
        
        return toggleBtn, frame
    end
    
    -- ════════════════════════════════════════════════════════
    --  ВКЛАДКА 1: ФАРМ
    -- ════════════════════════════════════════════════════════
    
    local farmTab = tabContents[1]
    local yPos = 10
    
    createSection(farmTab, "🤖 АВТОФАРМ КУБКОВ", yPos)
    yPos = yPos + 40
    
    local farmStatus = Instance.new("TextLabel")
    farmStatus.Size = UDim2.new(0.92, 0, 0, 30)
    farmStatus.Position = UDim2.new(0.04, 0, 0, yPos)
    farmStatus.BackgroundTransparency = 1
    farmStatus.Text = "🔴 Фарм выключен"
    farmStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    farmStatus.TextSize = 16
    farmStatus.TextXAlignment = Enum.TextXAlignment.Center
    farmStatus.Font = Enum.Font.Gotham
    farmStatus.Parent = farmTab
    yPos = yPos + 35
    
    local farmToggle, _ = createToggle(farmTab, "🎯 Фармить кубки", yPos, false, function(state)
        farmStatus.Text = state and "🟢 Фарм активен" or "🔴 Фарм выключен"
        farmStatus.TextColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        if state then
            startFarm()
        else
            stopFarm()
        end
    end)
    yPos = yPos + 48
    
    createBtn(farmTab, "🚀 Ускорить фарм (x2)", yPos, Color3.fromRGB(200, 120, 0), function()
        if farmSpeed <= 0.05 then return end
        farmSpeed = farmSpeed / 1.5
        statusText.Text = "⚡ Скорость: " .. string.format("%.2f", farmSpeed)
    end)
    yPos = yPos + 48
    
    createBtn(farmTab, "🔄 Сбросить скорость", yPos, Color3.fromRGB(50, 50, 150), function()
        farmSpeed = 0.3
        statusText.Text = "🟢 Онлайн"
    end)
    yPos = yPos + 48
    
    createBtn(farmTab, "📊 Показать статистику", yPos, Color3.fromRGB(0, 150, 200), function()
        print("🏆 Всего побед: " .. wins)
        statusText.Text = "🏆 Побед: " .. wins
    end)
    
    -- ════════════════════════════════════════════════════════
    --  ВКЛАДКА 2: НАСТРОЙКИ
    -- ════════════════════════════════════════════════════════
    
    local settingsTab = tabContents[2]
    yPos = 10
    
    createSection(settingsTab, "⚡ БЫСТРЫЕ НАСТРОЙКИ", yPos)
    yPos = yPos + 40
    
    createBtn(settingsTab, "👤 Телепорт в центр", yPos, Color3.fromRGB(0, 100, 200), function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
            statusText.Text = "✅ Телепорт выполнен"
        end
    end)
    yPos = yPos + 48
    
    createBtn(settingsTab, "🏃 Супер-скорость (x5)", yPos, Color3.fromRGB(0, 200, 100), function()
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
    yPos = yPos + 48
    
    createBtn(settingsTab, "💫 Мега-прыжок", yPos, Color3.fromRGB(150, 0, 200), function()
        local char = player.Character
        if char then
            local humanoid = char:
