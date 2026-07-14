-- Zeta Hub v6.0 - КАК SPECTRUM HUB (FIXED)
-- Для игры: +1 Speed Keyboard Escape
-- Вставь в Xeno Executor и нажми Execute

print("🔥 Zeta Hub v6.0 ЗАПУСК...")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local userInput = game:GetService("UserInputService")

if not player then
    print("❌ Игрок не найден!")
    return
end

-- === ЖДЕМ ПОЛНОЙ ЗАГРУЗКИ ИГРОКА ===
repeat task.wait() until player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
print("✅ Игрок загружен: " .. player.Name)

-- === УДАЛЯЕМ СТАРЫЙ GUI ===
local oldGui = player.PlayerGui:FindFirstChild("ZetaHub")
if oldGui then 
    oldGui:Destroy() 
    print("✅ Старый GUI удален")
end

-- === СОЗДАНИЕ GUI ===
local gui = Instance.new("ScreenGui")
gui.Name = "ZetaHub"
gui.ResetOnSpawn = false
gui.Enabled = true

-- ЖДЕМ PlayerGui
local playerGui = player:WaitForChild("PlayerGui", 5)
if not playerGui then
    print("❌ PlayerGui не найден!")
    return
end

gui.Parent = playerGui
print("✅ GUI создан!")

-- === ТЕСТОВАЯ КНОПКА ДЛЯ ПРОВЕРКИ (исчезнет через 2 сек) ===
local testBtn = Instance.new("TextButton")
testBtn.Size = UDim2.new(0, 200, 0, 50)
testBtn.Position = UDim2.new(0.5, -100, 0.5, -25)
testBtn.Text = "✅ GUI РАБОТАЕТ!"
testBtn.TextColor3 = Color3.new(1, 1, 1)
testBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
testBtn.Parent = gui
task.wait(2)
testBtn:Destroy()

-- === СВЁРНУТОЕ МЕНЮ ===
local miniFrame = Instance.new("Frame")
miniFrame.Size = UDim2.fromOffset(160, 45)
miniFrame.Position = UDim2.new(0.5, -80, 0.9, -20)
miniFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
miniFrame.BackgroundTransparency = 0.3
miniFrame.BorderSizePixel = 2
miniFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
miniFrame.Visible = true
miniFrame.Parent = gui

local miniText = Instance.new("TextLabel")
miniText.Size = UDim2.new(1, 0, 1, 0)
miniText.BackgroundTransparency = 1
miniText.Text = "ZETA HUB"
miniText.TextColor3 = Color3.fromRGB(0, 0, 0)
miniText.TextScaled = true
miniText.Font = Enum.Font.GothamBold
miniText.Parent = miniFrame

local expandBtn = Instance.new("TextButton")
expandBtn.Size = UDim2.new(1, 0, 1, 0)
expandBtn.BackgroundTransparency = 1
expandBtn.Text = ""
expandBtn.Parent = miniFrame

-- === ОСНОВНОЕ МЕНЮ (КАК SPECTRUM HUB) ===
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(450, 600)
frame.Position = UDim2.new(0.5, -225, 0.5, -300)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = gui

-- ЗАГОЛОВОК (как на скриншоте)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
titleBar.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ ZETA HUB v6.0"
title.TextColor3 = Color3.new(0, 0, 0)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

local subTitle = Instance.new("TextLabel")
subTitle.Size = UDim2.new(0.7, 0, 1, 0)
subTitle.Position = UDim2.new(0.7, 0, 0, 0)
subTitle.BackgroundTransparency = 1
subTitle.Text = "by xZPUHigh"
subTitle.TextColor3 = Color3.new(0, 0, 0)
subTitle.TextScaled = true
subTitle.TextXAlignment = Enum.TextXAlignment.Right
subTitle.Font = Enum.Font.Gotham
subTitle.Parent = titleBar

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
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- === СКРОЛЛ ===
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -45)
scroll.Position = UDim2.new(0, 0, 0, 45)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 900)
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)
scroll.Parent = frame

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 0, 900)
content.BackgroundTransparency = 1
content.Parent = scroll

-- === ФУНКЦИИ ===
local function makeSection(title, y)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.9, 0, 0, 28)
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

local function makeButton(text, y, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 32)
    btn.Position = UDim2.new(0.075, 0, 0, y)
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

local function makeToggle(text, y, default, key)
    local c = Instance.new("Frame")
    c.Size = UDim2.new(0.85, 0, 0, 32)
    c.Position = UDim2.new(0.075, 0, 0, y)
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
        if key then Config[key] = st end
    end)
    return c
end

-- === НАСТРОЙКИ ===
local Config = {
    AutoFarm = false,
    AutoClick = false,
    AutoBuy = false
}

-- === ПОСТРОЕНИЕ МЕНЮ ===
local y = 10

-- ЗАГОЛОВОК КАК НА СКРИНШОТЕ
local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(0.9, 0, 0, 25)
infoText.Position = UDim2.new(0.05, 0, 0, y)
infoText.BackgroundTransparency = 1
infoText.Text = "⚡ ZETA HUB | +1 Speed Keyboard Escape"
infoText.TextColor3 = Color3.fromRGB(255, 255, 255)
infoText.TextScaled = true
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.Font = Enum.Font.Gotham
infoText.Parent = content
y = y + 30

-- General Tabs
makeSection("📋 GENERAL TABS", y)
y = y + 33

makeToggle("🤖 Autofarm", y, false, "AutoFarm")
y = y + 37
makeToggle("🖱️ Auto Click", y, false, "AutoClick")
y = y + 37
makeToggle("🛒 Auto Buy", y, false, "AutoBuy")
y = y + 37
makeButton("🗺️ Teleport", y, Color3.fromRGB(0, 150, 200))
y = y + 37
makeButton("🏃 Movement", y, Color3.fromRGB(100, 200, 50))
y = y + 37
makeButton("👑 VIP", y, Color3.fromRGB(200, 100, 255))
y = y + 45

-- Trade Features (как на скриншоте)
makeSection("📦 TRADE FEATURES", y)
y = y + 33

local tradeInfo = Instance.new("TextLabel")
tradeInfo.Size = UDim2.new(0.85, 0, 0, 22)
tradeInfo.Position = UDim2.new(0.075, 0, 0, y)
tradeInfo.BackgroundTransparency = 1
tradeInfo.Text = "Trade Information:"
tradeInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
tradeInfo.TextScaled = true
tradeInfo.TextXAlignment = Enum.TextXAlignment.Left
tradeInfo.Font = Enum.Font.Gotham
tradeInfo.Parent = content
y = y + 25

local tradeInfo2 = Instance.new("TextLabel")
tradeInfo2.Size = UDim2.new(0.85, 0, 0, 20)
tradeInfo2.Position = UDim2.new(0.075, 0, 0, y)
tradeInfo2.BackgroundTransparency = 1
tradeInfo2.Text = "1. Add materials into the trade window."
tradeInfo2.TextColor3 = Color3.fromRGB(150, 150, 150)
tradeInfo2.TextScaled = true
tradeInfo2.TextXAlignment = Enum.TextXAlignment.Left
tradeInfo2.Font = Enum.Font.Gotham
tradeInfo2.Parent = content
y = y + 22

local tradeInfo3 = Instance.new("TextLabel")
tradeInfo3.Size = UDim2.new(0.85, 0, 0, 20)
tradeInfo3.Position = UDim2.new(0.075, 0, 0, y)
tradeInfo3.BackgroundTransparency = 1
tradeInfo3.Text = "2. Select a preset then click 'Add Trade Items'."
tradeInfo3.TextColor3 = Color3.fromRGB(150, 150, 150)
tradeInfo3.TextScaled = true
tradeInfo3.TextXAlignment = Enum.TextXAlignment.Left
tradeInfo3.Font = Enum.Font.Gotham
tradeInfo3.Parent = content
y = y + 30

makeSection("📦 SELECT ITEMS", y)
y = y + 33

makeButton("Choose items preset to add items into trade window.", y, Color3.fromRGB(80, 50, 150))
y = y + 40

makeSection("🔢 COUNT MULTIPLIER", y)
y = y + 33

local multLabel = Instance.new("TextLabel")
multLabel.Size = UDim2.new(0.5, 0, 0, 25)
multLabel.Position = UDim2.new(0.075, 0, 0, y)
multLabel.BackgroundTransparency = 1
multLabel.Text = "item amounts by this"
multLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
multLabel.TextScaled = true
multLabel.TextXAlignment = Enum.TextXAlignment.Left
multLabel.Font = Enum.Font.Gotham
multLabel.Parent = content

local multBox = Instance.new("TextBox")
multBox.Size = UDim2.new(0.2, 0, 0, 25)
multBox.Position = UDim2.new(0.6, 0, 0, y)
multBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
multBox.BackgroundTransparency = 0.5
multBox.BorderSizePixel = 1
multBox.BorderColor3 = Color3.fromRGB(255, 215, 0)
multBox.Text = "1"
multBox.TextColor3 = Color3.new(1, 1, 1)
multBox.TextScaled = true
multBox.Font = Enum.Font.Gotham
multBox.Parent = content
y = y + 35

makeButton("Default: 1", y, Color3.fromRGB(50, 50, 80))
y = y + 45

-- ФУТЕР (как на скриншоте)
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(0.9, 0, 0, 25)
footer.Position = UDim2.new(0.05, 0, 0, y)
footer.BackgroundTransparency = 1
footer.Text = 'print("Welcome To Zeta Hub!")'
footer.TextColor3 = Color3.fromRGB(100, 200, 255)
footer.TextScaled = true
footer.Font = Enum.Font.Gotham
footer.Parent = content
y = y + 28

local footer2 = Instance.new("TextLabel")
footer2.Size = UDim2.new(0.9, 0, 0, 25)
footer2.Position = UDim2.new(0.05, 0, 0, y)
footer2.BackgroundTransparency = 1
footer2.Text = 'echo "Last Updated 26/03/26"'
footer2.TextColor3 = Color3.fromRGB(100, 200, 150)
footer2.TextScaled = true
footer2.Font = Enum.Font.Gotham
footer2.Parent = content
y = y + 35

-- СТАТУС
local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0, 22)
status.Position = UDim2.new(0.05, 0, 0, y + 5)
status.BackgroundTransparency = 1
status.Text = "✅ Zeta Hub v6.0 | Готов к работе!"
status.TextColor3 = Color3.fromRGB(150, 255, 150)
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.Parent = content

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
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
        miniFrame.Position = UDim2.new(miniStartPos.X.Scale, miniStartPos.X.Offset + delta.X, miniStartPos.Y.Scale, miniStartPos.Y.Offset + delta.Y)
    end
end)

-- === СВЕРТЫВАНИЕ/РАЗВЕРТЫВАНИЕ ===
local function toggleMinimize()
    if frame.Visible then
        frame.Visible = false
        miniFrame.Visible = true
        minimizeBtn.Text = "➕"
    else
        frame.Visible = true
        miniFrame.Visible = false
        minimizeBtn.Text = "➖"
    end
end

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)
expandBtn.MouseButton1Click:Connect(toggleMinimize)

-- === ГОРЯЧИЕ КЛАВИШИ ===
userInput.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F1 then 
        gui.Enabled = not gui.Enabled 
    end
end)

-- === ДИАГНОСТИКА ===
task.wait(1)
print("=== ДИАГНОСТИКА GUI ===")
print("✅ GUI существует:", gui ~= nil)
print("✅ GUI Enabled:", gui.Enabled)
print("✅ GUI Parent:", gui.Parent)
print("✅ GUI Parent.Name:", gui.Parent and gui.Parent.Name or "НЕТ")
print("✅ Все дети GUI:")
for _, child in ipairs(gui:GetChildren()) do
    print("   -", child.Name, child.ClassName)
end

print("✅ Zeta Hub v6.0 ЗАГРУЖЕН!")
print("📌 F1 - Показать/Скрыть")
print("📌 Нажми ➖ чтобы свернуть")
