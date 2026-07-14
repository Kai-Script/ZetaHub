print("🔥 Zeta Hub v5.1 ЗАПУСК...")

task.wait(2)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

if not player then
    print("❌ Игрок не найден!")
    return
end

print("✅ Игрок: " .. player.Name)

-- === НАСТРОЙКИ ===
local Config = {
    Minimized = false
}

-- === СОЗДАНИЕ GUI ===
local gui = Instance.new("ScreenGui")
gui.Name = "ZetaHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- === СВЁРНУТОЕ МЕНЮ (как Pulse Hub) ===
local miniFrame = Instance.new("Frame")
miniFrame.Size = UDim2.fromOffset(160, 45)
miniFrame.Position = UDim2.new(0.5, -80, 0.9, -20)
miniFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
miniFrame.BackgroundTransparency = 0.85
miniFrame.BorderSizePixel = 2
miniFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
miniFrame.Visible = true
miniFrame.Parent = gui

-- ТЕКСТ НА СВЁРНУТОМ МЕНЮ
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

-- КНОПКА ДЛЯ РАЗВОРАЧИВАНИЯ
local expandBtn = Instance.new("TextButton")
expandBtn.Size = UDim2.new(1, 0, 1, 0)
expandBtn.BackgroundTransparency = 1
expandBtn.Text = ""
expandBtn.Parent = miniFrame

-- === РАЗВЁРНУТОЕ МЕНЮ ===
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(400, 500)
frame.Position = UDim2.new(0.5, -200, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 215, 0)
frame.ClipsDescendants = true
frame.Visible = false
frame.Parent = gui

-- ЗАГОЛОВОК
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
titleBar.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ ZETA HUB"
title.TextColor3 = Color3.new(0, 0, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

-- КНОПКА СВЕРНУТЬ
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

-- КНОПКА ЗАКРЫТЬ
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

-- ИНФО
local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, 0, 0, 30)
infoText.Position = UDim2.new(0, 0, 0, 55)
infoText.BackgroundTransparency = 1
infoText.Text = "Zeta Hub | by xZPUHigh & Rewrite Edition"
infoText.TextColor3 = Color3.fromRGB(255, 215, 0)
infoText.TextScaled = true
infoText.Font = Enum.Font.GothamBold
infoText.Parent = frame

-- КОНТЕЙНЕР
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -90)
scroll.Position = UDim2.new(0, 0, 0, 90)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 400)
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)
scroll.Parent = frame

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 0, 400)
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

local function makeButton(text, y, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
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

local function makeToggle(text, y, default)
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
    end)
    return c
end

-- === ПОСТРОЕНИЕ МЕНЮ ===
local y = 10

makeSection("General Tabs", y)
y = y + 30

local btn1 = makeButton("Auto Farm", y, Color3.fromRGB(0, 100, 200))
y = y + 40
local btn2 = makeButton("Auto Click", y, Color3.fromRGB(0, 150, 100))
y = y + 40
local btn3 = makeButton("Auto Buy", y, Color3.fromRGB(150, 100, 0))
y = y + 40

-- Trade Features
makeSection("Trade Features", y)
y = y + 30

local infoTrade = Instance.new("TextLabel")
infoTrade.Size = UDim2.new(0.9, 0, 0, 20)
infoTrade.Position = UDim2.new(0.05, 0, 0, y)
infoTrade.BackgroundTransparency = 1
infoTrade.Text = "Trade Information:"
infoTrade.TextColor3 = Color3.fromRGB(200, 200, 200)
infoTrade.TextScaled = true
infoTrade.TextXAlignment = Enum.TextXAlignment.Left
infoTrade.Font = Enum.Font.Gotham
infoTrade.Parent = content
y = y + 25

local infoTrade2 = Instance.new("TextLabel")
infoTrade2.Size = UDim2.new(0.9, 0, 0, 20)
infoTrade2.Position = UDim2.new(0.05, 0, 0, y)
infoTrade2.BackgroundTransparency = 1
infoTrade2.Text = "1. Add materials into the trade window."
infoTrade2.TextColor3 = Color3.fromRGB(150, 150, 150)
infoTrade2.TextScaled = true
infoTrade2.TextXAlignment = Enum.TextXAlignment.Left
infoTrade2.Font = Enum.Font.Gotham
infoTrade2.Parent = content
y = y + 22

local infoTrade3 = Instance.new("TextLabel")
infoTrade3.Size = UDim2.new(0.9, 0, 0, 20)
infoTrade3.Position = UDim2.new(0.05, 0, 0, y)
infoTrade3.BackgroundTransparency = 1
infoTrade3.Text = "2. Select a preset then click 'Add Trade Items'."
infoTrade3.TextColor3 = Color3.fromRGB(150, 150, 150)
infoTrade3.TextScaled = true
infoTrade3.TextXAlignment = Enum.TextXAlignment.Left
infoTrade3.Font = Enum.Font.Gotham
infoTrade3.Parent = content
y = y + 30

makeSection("Select Items", y)
y = y + 30

local selectBtn = makeButton("Choose items preset to add items into trade window.", y, Color3.fromRGB(80, 50, 150))
y = y + 45

makeSection("Count Multiplier", y)
y = y + 30

local multLabel = Instance.new("TextLabel")
multLabel.Size = UDim2.new(0.5, 0, 0, 25)
multLabel.Position = UDim2.new(0.05, 0, 0, y)
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

local defaultsBtn = makeButton("Defaults: 1", y, Color3.fromRGB(50, 50, 80))
y = y + 45

-- СТАТУС
local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0, 20)
status.Position = UDim2.new(0.05, 0, 0, y + 5)
status.BackgroundTransparency = 1
status.Text = "✅ Zeta Hub v5.1"
status.TextColor3 = Color3.fromRGB(150, 255, 150)
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.Parent = content

-- ФУТЕР
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Position = UDim2.new(0, 0, 0, -30)
footer.BackgroundTransparency = 1
footer.Text = 'print("Welcome To Zeta Hub!")'
footer.TextColor3 = Color3.fromRGB(100, 200, 255)
footer.TextScaled = true
footer.Font = Enum.Font.Gotham
footer.Parent = frame

local footer2 = Instance.new("TextLabel")
footer2.Size = UDim2.new(1, 0, 0, 25)
footer2.Position = UDim2.new(0, 0, 0, 0)
footer2.BackgroundTransparency = 1
footer2.Text = 'echo "Last Updated 26/03/26"'
footer2.TextColor3 = Color3.fromRGB(100, 200, 150)
footer2.TextScaled = true
footer2.Font = Enum.Font.Gotham
footer2.Parent = frame

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
    Config.Minimized = not Config.Minimized
    
    if Config.Minimized then
        frame.Visible = false
        miniFrame.Visible = true
        minimizeBtn.Text = "➕"
        miniFrame.Position = UDim2.new(0.5, -80, 0.9, -20)
    else
        frame.Visible = true
        miniFrame.Visible = false
        minimizeBtn.Text = "➖"
    end
end

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)
expandBtn.MouseButton1Click:Connect(function()
    if Config.Minimized then toggleMinimize() end
end)

-- === ОБРАБОТЧИКИ КНОПОК ===
btn1.MouseButton1Click:Connect(function()
    print("🔄 Auto Farm запущен!")
end)

btn2.MouseButton1Click:Connect(function()
    print("🖱️ Auto Click запущен!")
end)

btn3.MouseButton1Click:Connect(function()
    print("🛒 Auto Buy запущен!")
end)

selectBtn.MouseButton1Click:Connect(function()
    print("📦 Выбор предметов для трейда")
end)

defaultsBtn.MouseButton1Click:Connect(function()
    multBox.Text = "1"
    print("✅ Defaults: 1")
end)

userInput.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F1 then 
        gui.Enabled = not gui.Enabled 
    end
end)

print("✅ Zeta Hub v5.1 ЗАГРУЖЕН!")
print("📌 F1 - Показать/Скрыть")
print("📌 Нажми ➖ чтобы свернуть (как Pulse Hub)")
print("🔥 Свёрнутое меню: ZETA HUB")
