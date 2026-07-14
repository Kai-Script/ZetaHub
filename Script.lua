-- LocalScript для "+1 Speed" (Escape кликер)
-- Zeta Hub - Full Version с сохранениями и авто-ребайтом
-- Вставь в Xeno Executor

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local userInput = game:GetService("UserInputService")
local virtualInput = game:GetService("VirtualInputManager")
local tweenService = game:GetService("TweenService")
local lighting = game:GetService("Lighting")
local workspace = game:GetService("Workspace")
local runService = game:GetService("RunService")
local httpService = game:GetService("HttpService")

-- === СИСТЕМА СОХРАНЕНИЙ ===
local saveData = {
    AutoFarm = true,
    AutoEscape = true,
    AutoClick = true,
    AutoBuy = true,
    AutoRestart = true,
    AutoRebirth = false,
    LowGraphics = false,
    RemoveFog = false,
    RemoveShadows = false,
    DisableEffects = false,
    LowQualityMode = false,
    VisualsEnabled = false,
    ClickDelay = 0.05,
    RebirthLevel = 10
}

local function saveSettings()
    local success, data = pcall(function()
        return httpService:JSONEncode(saveData)
    end)
    if success then
        setclipboard(data) -- Копируем в буфер обмена
        print("💾  Настройки сохранены в буфер обмена!")
    end
end

local function loadSettings()
    local success, data = pcall(function()
        return httpService:JSONDecode(getclipboard())
    end)
    if success and data then
        for key, value in pairs(data) do
            saveData[key] = value
        end
        print("✅ Настройки загружены из буфера обмена!")
        return true
    end
    return false
end

-- === НАСТРОЙКИ ===
local Config = {
    AutoFarm = saveData.AutoFarm,
    AutoEscape = saveData.AutoEscape,
    AutoClick = saveData.AutoClick,
    AutoBuy = saveData.AutoBuy,
    AutoRestart = saveData.AutoRestart,
    AutoRebirth = saveData.AutoRebirth,
    LowGraphics = saveData.LowGraphics,
    RemoveFog = saveData.RemoveFog,
    RemoveShadows = saveData.RemoveShadows,
    DisableEffects = saveData.DisableEffects,
    LowQualityMode = saveData.LowQualityMode,
    VisualsEnabled = saveData.VisualsEnabled,
    ClickDelay = saveData.ClickDelay,
    RebirthLevel = saveData.RebirthLevel,
    VisualsColor = Color3.fromRGB(255, 100, 0)
}

-- === СОЗДАНИЕ GUI ===
local gui = Instance.new("ScreenGui")
gui.Name = "ZetaHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ОСНОВНАЯ ПАНЕЛЬ
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(300, 700)
frame.Position = UDim2.new(0.5, -150, 0.5, -350)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 200, 50)
frame.Parent = gui

-- ЗАГОЛОВОК
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
titleBar.Parent = frame

-- ПЕРЕТАСКИВАНИЕ
local dragging = false
local dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
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

-- ЗАГОЛОВОК ТЕКСТ
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5, 0, 1, 0)
title.Position = UDim2.new(0, 5, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ Zeta Hub ⚡"
title.TextColor3 = Color3.new(0, 0, 0)
title.TextScaled = true


title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

-- КНОПКА СВЕРНУТЬ
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 30, 1, -4)
toggleBtn.Position = UDim2.new(1, -65, 0, 2)
toggleBtn.Text = "➖"
toggleBtn.TextColor3 = Color3.new(0, 0, 0)
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundTransparency = 0.3
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = titleBar

-- КНОПКА ЗАКРЫТЬ
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 1, -4)
closeBtn.Position = UDim2.new(1, -5, 0, 2)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(0, 0, 0)
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.BackgroundTransparency = 0.3
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

-- КОНТЕЙНЕР КНОПОК
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = frame

-- ФУНКЦИЯ СОЗДАНИЯ КНОПОК
local function makeButton(text, y, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.85, 0, 0, 30)
    b.Position = UDim2.new(0.075, 0, 0, y)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextScaled = true
    b.Font = Enum.Font.GothamSemibold
    b.BackgroundColor3 = color or Color3.fromRGB(60, 60, 80)
    b.BorderSizePixel = 1
    b.BorderColor3 = Color3.fromRGB(255, 200, 50)
    b.Parent = contentFrame
    return b
end

-- ФУНКЦИЯ СОЗДАНИЯ TOGGLE
local function makeToggle(text, y, defaultValue, saveKey)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.85, 0, 0, 28)
    container.Position = UDim2.new(0.075, 0, 0, y)
    container.BackgroundTransparency = 1
    container.Parent = contentFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0.3, 0, 0.8, 0)
    toggle.Position = UDim2.new(0.7, 0, 0.1, 0)
    toggle.Text = defaultValue and "ON" or "OFF"
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.TextScaled = true
    toggle.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    toggle.BorderSizePixel = 1
    toggle.BorderColor3 = Color3.fromRGB(255, 200, 50)
    toggle.Parent = container
    
    local state = defaultValue
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = state and "ON" or "OFF"
        toggle.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        
        -- Обновляем настройки
        if saveKey then
            saveData[saveKey] = state
            Config[saveKey] = state
        end
        
        -- Обновляем функции
        if toggle == lowGraphicsToggle then
            updateLowGraphics()
        elseif toggle == removeFogToggle then
            updateFog()
        elseif toggle == removeShadowsToggle then
            updateShadows()
        elseif toggle == disableEffectsToggle then
            updateEffects()
        elseif toggle == lowQualityToggle then
            updateQualityMode()
        elseif toggle == visualsToggle then
            toggleVisuals()
        elseif toggle == rebirthToggle then
            -- Обновляем авто-ребайт
        end
        
        saveSettings()
    end)
    
    return container, function() return state end
end

-- === ФУНКЦИИ ВИЗУАЛОВ ===
local function createVisuals()
    local char = player.Character or player.CharacterAdded:Wait()
    local head = char:FindFirstChild("Head")
19:25
local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if not head or not hrp then return end
    
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("BillboardGui") and v.Name == "ZetaVisuals" then
            v:Destroy()
        end
        if v:IsA("Highlight") and v.Name == "ZetaHighlight" then
            v:Destroy()
        end
    end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ZetaVisuals"
    billboard.Size = UDim2.fromOffset(150, 40)
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = char
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 0.3
    textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Text = "⚡ ZETA HUB ⚡"
    textLabel.TextColor3 = Config.VisualsColor
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextStrokeTransparency = 0.3
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Parent = billboard
    
    local frameVisual = Instance.new("Frame")
    frameVisual.Size = UDim2.new(1, 0, 1.2, 0)
    frameVisual.Position = UDim2.new(0, 0, -0.1, 0)
    frameVisual.BackgroundTransparency = 0.5
    frameVisual.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frameVisual.BorderSizePixel = 2
    frameVisual.BorderColor3 = Config.VisualsColor
    frameVisual.Parent = billboard
    
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1.1, 0, 1.3, 0)
    glow.Position = UDim2.new(-0.05, 0, -0.15, 0)
    glow.BackgroundTransparency = 0.7
    glow.BackgroundColor3 = Config.VisualsColor
    glow.BorderSizePixel = 0
    glow.Parent = billboard
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ZetaHighlight"
    highlight.Adornee = char
    highlight.FillColor = Config.VisualsColor
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Config.VisualsColor
    highlight.OutlineTransparency = 0.3
    highlight.Parent = char
    
    print("✅ Визуалы активированы!")
end

local function removeVisuals()
    local char = player.Character
    if not char then return end
    
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("BillboardGui") and v.Name == "ZetaVisuals" then
            v:Destroy()
        end
        if v:IsA("Highlight") and v.Name == "ZetaHighlight" then
            v:Destroy()
        end
    end
    print("❌ Визуалы отключены")
end

local function toggleVisuals()
    if Config.VisualsEnabled then
        createVisuals()
    else
        removeVisuals()
    end
end

-- === ФУНКЦИИ ОПТИМИЗАЦИИ ===

local function updateLowGraphics()
    if Config.LowGraphics then
        lighting.Brightness = 0.5
        lighting.Ambient = Color3.fromRGB(100, 100, 100)
        lighting.GlobalShadows = false
        settings().Rendering.QualityLevel = 1
    else
        lighting.Brightness = 2
        lighting.Ambient = Color3.fromRGB(150, 150, 150)
        lighting.GlobalShadows = true
        settings().Rendering.QualityLevel = 3
    end
end

local function updateFog()
    if Config.RemoveFog then
        lighting.FogEnd = 100000
        lighting.FogStart = 100000
    else
        lighting.FogEnd = 1000
        lighting.FogStart = 100
    end
end

local function updateShadows()
    if Config.RemoveShadows then
        lighting.GlobalShadows = false
    else
        lighting.GlobalShadows = true
    end
end

local function updateEffects()
    if Config.DisableEffects then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                pcall(function() v.Enabled = false end)
            end
        end
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
pcall(function() v.Enabled = true end)
            end
        end
    end
end

local function updateQualityMode()
    if Config.LowQualityMode then
        Config.LowGraphics = true
        Config.RemoveFog = true
        Config.RemoveShadows = true
        Config.DisableEffects = true
        
        updateLowGraphics()
        updateFog()
        updateShadows()
        updateEffects()
        
        if lowGraphicsToggle then
            lowGraphicsToggle.Text = "ON"
            lowGraphicsToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        end
        if removeFogToggle then
            removeFogToggle.Text = "ON"
            removeFogToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        end
        if removeShadowsToggle then
            removeShadowsToggle.Text = "ON"
            removeShadowsToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        end
        if disableEffectsToggle then
            disableEffectsToggle.Text = "ON"
            disableEffectsToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        end
    else
        Config.LowGraphics = false
        Config.RemoveFog = false
        Config.RemoveShadows = false
        Config.DisableEffects = false
        
        updateLowGraphics()
        updateFog()
        updateShadows()
        updateEffects()
        
        if lowGraphicsToggle then
            lowGraphicsToggle.Text = "OFF"
            lowGraphicsToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        end
        if removeFogToggle then
            removeFogToggle.Text = "OFF"
            removeFogToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        end
        if removeShadowsToggle then
            removeShadowsToggle.Text = "OFF"
            removeShadowsToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        end
        if disableEffectsToggle then
            disableEffectsToggle.Text = "OFF"
            disableEffectsToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        end
    end
    saveSettings()
end

-- === АВТО-РЕБАЙТ (ПРЕСТИЖ) ===
local function doRebirth()
    if not Config.AutoRebirth then return end
    
    local playerGui = player:WaitForChild("PlayerGui")
    local rebirthFound = false
    
    -- Ищем кнопку ребайта/престижа
    for _, gui in pairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, btn in pairs(gui:GetDescendants()) do
                if btn:IsA("TextButton") then
                    local name = btn.Name:lower()
                    local text = btn.Text:lower()
                    if name:find("rebirth") or name:find("prestige") or name:find("reset") or 
                       text:find("rebirth") or text:find("prestige") or text:find("reset") then
                        pcall(function() 
                            btn:Click() 
                            rebirthFound = true
                            print("🔄  Авто-Ребайт выполнен!")
                            wait(0.5)
                            -- Подтверждение ребайта
                            for _, confirmBtn in pairs(gui:GetDescendants()) do
                                if confirmBtn:IsA("TextButton") then
                                    local cName = confirmBtn.Name:lower()
                                    local cText = confirmBtn.Text:lower()
                                    if cName:find("confirm") or cName:find("yes") or 
                                       cText:find("confirm") or cText:find("yes") then
                                        confirmBtn:Click()
                                        print("✅ Ребайт подтверждён!")
                                    end
                                end
                            end
                        end)
                        wait(0.5)
                    end
                end
            end
        end
    end
    
    -- Если не нашли кнопку, пробуем через клавиши
    if not rebirthFound then
-- Имитация нажатия клавиши для ребайта (если есть)
        virtualInput:SendKeyEvent(true, Enum.KeyCode.R, false, nil)
        wait(0.05)
        virtualInput:SendKeyEvent(false, Enum.KeyCode.R, false, nil)
    end
end

-- === СОЗДАНИЕ КНОПОК ===
local yPos = 5

-- Основные Toggle'ы
local farmToggle, getFarm = makeToggle("🤖  Auto Farm", yPos, saveData.AutoFarm, "AutoFarm")
yPos = yPos + 33

local escapeToggle, getEscape = makeToggle("⌨️  Auto Escape", yPos, saveData.AutoEscape, "AutoEscape")
yPos = yPos + 33

local clickToggle, getClick = makeToggle("🖱️  Auto Click", yPos, saveData.AutoClick, "AutoClick")
yPos = yPos + 33

local buyToggle, getBuy = makeToggle("🛒  Auto Buy", yPos, saveData.AutoBuy, "AutoBuy")
yPos = yPos + 33

local restartToggle, getRestart = makeToggle("🔄  Auto Restart", yPos, saveData.AutoRestart, "AutoRestart")
yPos = yPos + 33

-- Авто-Ребайт
local rebirthToggle, getRebirth = makeToggle("♻️  Auto Rebirth", yPos, saveData.AutoRebirth, "AutoRebirth")
yPos = yPos + 40

-- Разделитель
local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.85, 0, 0, 2)
divider.Position = UDim2.new(0.075, 0, 0, yPos)
divider.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
divider.Parent = contentFrame
yPos = yPos + 10

-- Кнопки действий
local speedBtn = makeButton("⚡ Speed Boost", yPos, Color3.fromRGB(0, 150, 255))
yPos = yPos + 35

local jumpBtn = makeButton("🦘  Super Jump", yPos, Color3.fromRGB(255, 150, 0))
yPos = yPos + 35

local healBtn = makeButton("❤️  Heal", yPos, Color3.fromRGB(0, 200, 100))
yPos = yPos + 40

-- Кнопка ручного ребайта
local rebirthBtn = makeButton("♻️  Rebirth сейчас", yPos, Color3.fromRGB(200, 50, 255))
yPos = yPos + 40

-- === СЕКЦИЯ ВИЗУАЛОВ ===
local visualsDivider = Instance.new("Frame")
visualsDivider.Size = UDim2.new(0.85, 0, 0, 2)
visualsDivider.Position = UDim2.new(0.075, 0, 0, yPos)
visualsDivider.BackgroundColor3 = Color3.fromRGB(255, 100, 200)
visualsDivider.Parent = contentFrame
yPos = yPos + 10

local visualsTitle = Instance.new("TextLabel")
visualsTitle.Size = UDim2.new(0.85, 0, 0, 20)
visualsTitle.Position = UDim2.new(0.075, 0, 0, yPos)
visualsTitle.Text = "🎨  ВИЗУАЛЫ"
visualsTitle.TextColor3 = Color3.fromRGB(255, 100, 200)
visualsTitle.TextScaled = true
visualsTitle.BackgroundTransparency = 1
visualsTitle.Font = Enum.Font.GothamBold
visualsTitle.Parent = contentFrame
yPos = yPos + 25

local visualsToggle, getVisuals = makeToggle("✨ Включить визуалы", yPos, saveData.VisualsEnabled, "VisualsEnabled")
yPos = yPos + 33

-- === СЕКЦИЯ ОПТИМИЗАЦИИ ===
local fpsDivider = Instance.new("Frame")
fpsDivider.Size = UDim2.new(0.85, 0, 0, 2)
fpsDivider.Position = UDim2.new(0.075, 0, 0, yPos)
fpsDivider.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
fpsDivider.Parent = contentFrame
yPos = yPos + 10

local fpsTitle = Instance.new("TextLabel")
fpsTitle.Size = UDim2.new(0.85, 0, 0, 20)
fpsTitle.Position = UDim2.new(0.075, 0, 0, yPos)
fpsTitle.Text = "⚡ ОПТИМИЗАЦИЯ FPS ⚡"
fpsTitle.TextColor3 = Color3.fromRGB(0, 255, 100)
fpsTitle.TextScaled = true
fpsTitle.BackgroundTransparency = 1
fpsTitle.Font = Enum.Font.GothamBold
fpsTitle.Parent = contentFrame
yPos = yPos + 25

local lowGraphicsToggle, getLowGraphics = makeToggle("🎮 Низкая графика", yPos, saveData.LowGraphics, "LowGraphics")
yPos = yPos + 33

local removeFogToggle, getRemoveFog = makeToggle("🌫️  Убрать туман", yPos, saveData.RemoveFog, "RemoveFog")
yPos = yPos + 33

local removeShadowsToggle, getRemoveShadows = makeToggle("🌑  Убрать тени", yPos, saveData.RemoveShadows, "RemoveShadows")
yPos = yPos + 33

local disableEffectsToggle, getDisableEffects = makeToggle("✨ Откл. эффекты", yPos, saveData.DisableEffects, "DisableEffects")
yPos = yPos + 33

local lowQualityToggle, getLowQuality = makeToggle("🚀  Max FPS режим", yPos, saveData.LowQualityMode, "LowQualityMode")
yPos = yPos + 40

-- === СЕКЦИЯ СОХРАНЕНИЙ ===
local saveDivider = Instance.new("Frame")
saveDivider.Size = UDim2.new(0.85, 0, 0, 2)
19:25
saveDivider.Position = UDim2.new(0.075, 0, 0, yPos)
saveDivider.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
saveDivider.Parent = contentFrame
yPos = yPos + 10

local saveTitle = Instance.new("TextLabel")
saveTitle.Size = UDim2.new(0.85, 0, 0, 20)
saveTitle.Position = UDim2.new(0.075, 0, 0, yPos)
saveTitle.Text = "💾  СОХРАНЕНИЯ"
saveTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
saveTitle.TextScaled = true
saveTitle.BackgroundTransparency = 1
saveTitle.Font = Enum.Font.GothamBold
saveTitle.Parent = contentFrame
yPos = yPos + 25

local saveBtn = makeButton("💾  Сохранить настройки", yPos, Color3.fromRGB(0, 150, 200))
yPos = yPos + 35

local loadBtn = makeButton("📂  Загрузить настройки", yPos, Color3.fromRGB(200, 150, 0))
yPos = yPos + 35

local resetBtn = makeButton("🔄  Сбросить всё", yPos, Color3.fromRGB(200, 50, 50))
yPos = yPos + 40

-- Статусная строка
local statusBar = Instance.new("TextLabel")
statusBar.Size = UDim2.new(0.85, 0, 0, 20)
statusBar.Position = UDim2.new(0.075, 0, 0, yPos + 5)
statusBar.Text = "✅ Zeta Hub Active | Настройки сохраняются!"
statusBar.TextColor3 = Color3.fromRGB(150, 255, 150)
statusBar.TextScaled = true
statusBar.BackgroundTransparency = 1
statusBar.Font = Enum.Font.Gotham
statusBar.Parent = contentFrame

-- === ОБРАБОТЧИКИ ===

-- Кнопки сохранения
saveBtn.MouseButton1Click:Connect(function()
    saveSettings()
    statusBar.Text = "💾  Настройки сохранены в буфер!"
    wait(2)
    statusBar.Text = "✅ Zeta Hub Active | Настройки сохраняются!"
end)

loadBtn.MouseButton1Click:Connect(function()
    if loadSettings() then
        statusBar.Text = "📂  Настройки загружены!"
        -- Обновляем все Toggle'ы
        farmToggle.Text = saveData.AutoFarm and "ON" or "OFF"
        farmToggle.BackgroundColor3 = saveData.AutoFarm and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        escapeToggle.Text = saveData.AutoEscape and "ON" or "OFF"
        escapeToggle.BackgroundColor3 = saveData.AutoEscape and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        clickToggle.Text = saveData.AutoClick and "ON" or "OFF"
        clickToggle.BackgroundColor3 = saveData.AutoClick and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        buyToggle.Text = saveData.AutoBuy and "ON" or "OFF"
        buyToggle.BackgroundColor3 = saveData.AutoBuy and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        restartToggle.Text = saveData.AutoRestart and "ON" or "OFF"
        restartToggle.BackgroundColor3 = saveData.AutoRestart and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        rebirthToggle.Text = saveData.AutoRebirth and "ON" or "OFF"
        rebirthToggle.BackgroundColor3 = saveData.AutoRebirth and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        wait(2)
        statusBar.Text = "✅ Zeta Hub Active | Настройки сохраняются!"
    else
        statusBar.Text = "❌ Ошибка загрузки настроек!"
        wait(2)
        statusBar.Text = "✅ Zeta Hub Active | Настройки сохраняются!"
    end
end)

resetBtn.MouseButton1Click:Connect(function()
    saveData.AutoFarm = true
    saveData.AutoEscape = true
    saveData.AutoClick = true
    saveData.AutoBuy = true
    saveData.AutoRestart = true
    saveData.AutoRebirth = false
    saveData.LowGraphics = false
    saveData.RemoveFog = false
    saveData.RemoveShadows = false
    saveData.DisableEffects = false
    saveData.LowQualityMode = false
    saveData.VisualsEnabled = false
    
    Config.AutoFarm = true
    Config.AutoEscape = true
    Config.AutoClick = true
    Config.AutoBuy = true
    Config.AutoRestart = true
    Config.AutoRebirth = false
    Config.LowGraphics = false
    Config.RemoveFog = false
    Config.RemoveShadows = false
    Config.DisableEffects = false
    Config.LowQualityMode = false
    Config.VisualsEnabled = false
    
    -- Обновляем все Toggle'ы
    farmToggle.Text = "ON"
    farmToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    escapeToggle.Text = "ON"

escapeToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    clickToggle.Text = "ON"
    clickToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    buyToggle.Text = "ON"
    buyToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    restartToggle.Text = "ON"
    restartToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    rebirthToggle.Text = "OFF"
    rebirthToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    lowGraphicsToggle.Text = "OFF"
    lowGraphicsToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    removeFogToggle.Text = "OFF"
    removeFogToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    removeShadowsToggle.Text = "OFF"
    removeShadowsToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    disableEffectsToggle.Text = "OFF"
    disableEffectsToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    lowQualityToggle.Text = "OFF"
    lowQualityToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    visualsToggle.Text = "OFF"
    visualsToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    
    updateLowGraphics()
    updateFog()
    updateShadows()
    updateEffects()
    removeVisuals()
    
    statusBar.Text = "🔄  Все настройки сброшены!"
    wait(2)
    statusBar.Text = "✅ Zeta Hub Active | Настройки сохраняются!"
    saveSettings()
end)

-- Кнопка ручного ребайта
rebirthBtn.MouseButton1Click:Connect(function()
    doRebirth()
    statusBar.Text = "♻️  Rebirth выполнен!"
    wait(2)
    statusBar.Text = "✅ Zeta Hub Active | Настройки сохраняются!"
end)

-- Свернуть/развернуть
toggleBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.fromOffset(300, 40) or UDim2.fromOffset(300, 700)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = tweenService:Create(frame, tweenInfo, {Size = targetSize})
    tween:Play()
    contentFrame.Visible = not isMinimized
    toggleBtn.Text = isMinimized and "➕" or "➖"
    frame.Position = isMinimized and UDim2.new(0.5, -150, 0, 10) or UDim2.new(0.5, -150, 0.5, -350)
end)

-- Закрыть
closeBtn.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

-- === ФУНКЦИИ АВТО-ФАРМА ===

local function doEscape()
    if not getEscape() then return end
    virtualInput:SendKeyEvent(true, Enum.KeyCode.Escape, false, nil)
    task.wait(0.01)
    virtualInput:SendKeyEvent(false, Enum.KeyCode.Escape, false, nil)
end

local function doClick()
    if not getClick() then return end
    mouse.Button1Click()
end

local function doBuy()
    if not getBuy() then return end
    local playerGui = player:WaitForChild("PlayerGui")
    for _, gui in pairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, btn in pairs(gui:GetDescendants()) do
                if btn:IsA("TextButton") then
