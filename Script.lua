-- Zeta Hub v1.0
-- Для игры: +1 Speed Keyboard Escape
-- Автозагрузка для Xeno Executor
-- Просто вставь и играй!

local function main()
    print("🔥 Загрузка Zeta Hub v1.0...")
    print("⏳ Пожалуйста, подождите...")
    
    task.wait(1)
    
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    if not player then
        print("❌ Ошибка: Игрок не найден!")
        return
    end
    
    print("✅ Игрок найден: " .. player.Name)
    print("🚀 Запуск Zeta Hub v1.0...")

    -- === НАСТРОЙКИ ===
    local Config = {
        AutoFarm = true,
        AutoEscape = true,
        AutoClick = true,
        AutoBuy = true,
        AutoRestart = true,
        AutoRebirth = false,
        UnlockedTrackFarm = false,
        ClickDelay = 0.05
    }

    -- === ФУНКЦИЯ ФАРМА НА НЕКУПЛЕННЫХ ДОРОЖКАХ ===
    local function farmUnlockedTracks()
        if not Config.UnlockedTrackFarm then return end
        
        local playerGui = player:WaitForChild("PlayerGui")
        
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                for _, btn in pairs(gui:GetDescendants()) do
                    if btn:IsA("TextButton") then
                        local name = btn.Name:lower()
                        local text = btn.Text:lower()
                        
                        if (name:find("track") or name:find("level") or name:find("road") or name:find("map")) and
                           (text:find("lock") or text:find("🔒") or text:find("купить") or text:find("buy")) then
                            
                            pcall(function()
                                btn:Click()
                                task.wait(0.2)
                                
                                for _, playBtn in pairs(gui:GetDescendants()) do
                                    if playBtn:IsA("TextButton") then
                                        local pName = playBtn.Name:lower()
                                        local pText = playBtn.Text:lower()
                                        if pName:find("play") or pName:find("start") or 
                                           pText:find("play") or pText:find("start") or pText:find("играть") then
                                            playBtn:Click()
                                            task.wait(0.1)
                                        end
                                    end
                                end
                            end)
                            break
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
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- ОСНОВНАЯ ПАНЕЛЬ
    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(320, 680)
    frame.Position = UDim2.new(0.5, -160, 0.5, -340)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 200, 50)
    frame.Parent = gui

    -- Анимация появления
    frame.Size = UDim2.fromOffset(0, 0)
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tween = tweenService:Create(frame, tweenInfo, {Size = UDim2.fromOffset(320, 680)})
    tween:Play()

    -- ЗАГОЛОВОК
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    titleBar.Parent = frame

    -- Перетаскивание
    local dragging = false
    local dragStart, startPos
    local userInput = game:GetService("UserInputService")

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

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -40)
    contentFrame.Position = UDim2.new(0, 0, 0, 40)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = frame

    -- Функции создания кнопок
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
            if saveKey then
                Config[saveKey] = state
            end
        end)
        
        return container, function() return state end
    end

    -- === СОЗДАНИЕ КНОПОК ===
    local yPos = 5
    
    -- Основные Toggle'ы
    local farmToggle, getFarm = makeToggle("🤖 Auto Farm", yPos, true, "AutoFarm")
    yPos = yPos + 33
    local escapeToggle, getEscape = makeToggle("⌨️ Auto Escape", yPos, true, "AutoEscape")
    yPos = yPos + 33
    local clickToggle, getClick = makeToggle("🖱️ Auto Click", yPos, true, "AutoClick")
    yPos = yPos + 33
    local buyToggle, getBuy = makeToggle("🛒 Auto Buy", yPos, true, "AutoBuy")
    yPos = yPos + 33
    local restartToggle, getRestart = makeToggle("🔄 Auto Restart", yPos, true, "AutoRestart")
    yPos = yPos + 33
    local rebirthToggle, getRebirth = makeToggle("♻️ Auto Rebirth", yPos, false, "AutoRebirth")
    yPos = yPos + 40

    -- === ФАРМ НА НЕКУПЛЕННЫХ ДОРОЖКАХ ===
    local trackDivider = Instance.new("Frame")
    trackDivider.Size = UDim2.new(0.85, 0, 0, 2)
    trackDivider.Position = UDim2.new(0.075, 0, 0, yPos)
    trackDivider.BackgroundColor3 = Color3.fromRGB(255, 100, 255)
    trackDivider.Parent = contentFrame
    yPos = yPos + 10

    local trackTitle = Instance.new("TextLabel")
    trackTitle.Size = UDim2.new(0.85, 0, 0, 20)
    trackTitle.Position = UDim2.new(0.075, 0, 0, yPos)
    trackTitle.Text = "🆕 ФАРМ НА НЕКУПЛЕННЫХ ДОРОЖКАХ"
    trackTitle.TextColor3 = Color3.fromRGB(255, 100, 255)
    trackTitle.TextScaled = true
    trackTitle.BackgroundTransparency = 1
    trackTitle.Font = Enum.Font.GothamBold
    trackTitle.Parent = contentFrame
    yPos = yPos + 25

    local trackToggle, getTrackFarm = makeToggle("🔓 Фарм на некупленных", yPos, false, "UnlockedTrackFarm")
    yPos = yPos + 33

    local trackInfo = Instance.new("TextLabel")
    trackInfo.Size = UDim2.new(0.85, 0, 0, 20)
    trackInfo.Position = UDim2.new(0.075, 0, 0, yPos)
    trackInfo.Text = "💡 Фарм на дорожках, которые ещё не куплены"
    trackInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
    trackInfo.TextScaled = true
    trackInfo.BackgroundTransparency = 1
    trackInfo.Font = Enum.Font.Gotham
    trackInfo.Parent = contentFrame
    yPos = yPos + 25

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
    local jumpBtn = makeButton("🦘 Super Jump", yPos, Color3.fromRGB(255, 150, 0))
    yPos = yPos + 35
    local healBtn = makeButton("❤️ Heal", yPos, Color3.fromRGB(0, 200, 100))
    yPos = yPos + 35
    local rebirthBtn = makeButton("♻️ Rebirth сейчас", yPos, Color3.fromRGB(200, 50, 255))
    yPos = yPos + 40

    -- Статус
    local statusBar = Instance.new("TextLabel")
    statusBar.Size = UDim2.new(0.85, 0, 0, 20)
    statusBar.Position = UDim2.new(0.075, 0, 0, yPos + 5)
    statusBar.Text = "✅ Zeta Hub v1.0 Active"
    statusBar.TextColor3 = Color3.fromRGB(150, 255, 150)
    statusBar.TextScaled = true
    statusBar.BackgroundTransparency = 1
    statusBar.Font = Enum.Font.Gotham
    statusBar.Parent = contentFrame

    -- === ФУНКЦИИ АВТО-ФАРМА ===
    local virtualInput = game:GetService("VirtualInputManager")
    local mouse = player:GetMouse()

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
                        local name = btn.Name:lower()
                        if name:find("buy") or name:find("upgrade") or name:find("purchase") or name:find("shop") then
                            pcall(function() btn:Click() end)
                            task.wait(0.05)
                        end
                    end
                end
            end
        end
    end

    local function doRestart()
        if not getRestart() then return end
        local playerGui = player:WaitForChild("PlayerGui")
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                for _, btn in pairs(gui:GetDescendants()) do
                    if btn:IsA("TextButton") then
                        local name = btn.Name:lower()
                        if name:find("restart") or name:find("retry") or name:find("play") or name:find("reset") or name:find("again") then
                            pcall(function() btn:Click() end)
                            task.wait(0.1)
                        end
                    end
                end
            end
        end
    end

    local function doRebirth()
        if not getRebirth() then return end
        local playerGui = player:WaitForChild("PlayerGui")
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                for _, btn in pairs(gui:GetDescendants()) do
                    if btn:IsA("TextButton") then
                        local name = btn.Name:lower()
                        local text = btn.Text:lower()
                        if name:find("rebirth") or name:find("prestige") or text:find("rebirth") or text:find("prestige") then
                            pcall(function() btn:Click() end)
                            task.wait(0.5)
                        end
                    end
                end
            end
        end
    end

    -- === ОСНОВНОЙ ЦИКЛ ===
    task.spawn(function()
        while task.wait(0.05) do
            if getFarm() then
                pcall(function()
                    doEscape()
                    doClick()
                    doBuy()
                    doRestart()
                    doRebirth()
                    
                    if getTrackFarm() then
                        farmUnlockedTracks()
                    end
                end)
            end
        end
    end)

    -- === ОБРАБОТЧИКИ ===
    speedBtn.MouseButton1Click:Connect(function()
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            local orig = hum.WalkSpeed
            hum.WalkSpeed = 80
            task.wait(2)
            hum.WalkSpeed = orig or 16
        end
    end)

    jumpBtn.MouseButton1Click:Connect(function()
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            local orig = hum.JumpPower
            hum.JumpPower = 150
            hum:Jump()
            task.wait(0.3)
            hum.JumpPower = orig or 50
        end
    end)

    healBtn.MouseButton1Click:Connect(function()
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.Health = hum.MaxHealth
        end
    end)

    rebirthBtn.MouseButton1Click:Connect(function()
        doRebirth()
    end)

    -- Свернуть
    local isMinimized = false
    toggleBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetSize = isMinimized and UDim2.fromOffset(320, 40) or UDim2.fromOffset(320, 680)
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = tweenService:Create(frame, tweenInfo, {Size = targetSize})
        tween:Play()
        contentFrame.Visible = not isMinimized
        toggleBtn.Text = isMinimized and "➕" or "➖"
        frame.Position = isMinimized and UDim2.new(0.5, -160, 0, 10) or UDim2.new(0.5, -160, 0.5, -340)
    end)

    closeBtn.MouseButton1Click:Connect(function()
        gui.Enabled = false
    end)

    -- Горячие клавиши
    userInput.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.F1 then
            gui.Enabled = not gui.Enabled
        end
    end)

    print("✅ Zeta Hub v1.0 загружен!")
    print("📌 F1 - Показать/Скрыть панель")
    print("🆕 Фарм на некупленных дорожках - включи в меню!")
    print("🔥 Спасибо за использование Zeta Hub!")
end

-- === АВТОМАТИЧЕСКИЙ ЗАПУСК ===
local function startScript()
    local success, err = pcall(main)
    if not success then
        print("❌ Ошибка загрузки: " .. tostring(err))
        print("🔄 Повторная попытка через 2 секунды...")
        task.wait(2)
        pcall(main)
    end
end
-- Запуск
startScript()

print("🔥 Zeta Hub v1.0")
print("🚀 Просто вставь в Xeno Executor и играй!")
print("📌 Игра: +1 Speed Keyboard Escape")
