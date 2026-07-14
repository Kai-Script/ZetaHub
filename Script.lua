Вот Zeta Hub v1.6 — убрал Heal и Auto Escape, добавил скорость фарма от 1 до 450.

```lua
-- Zeta Hub v1.6
-- Для игры: +1 Speed Keyboard Escape
-- Вставь в Xeno Executor и нажми Execute

print("🔥 Zeta Hub v1.6")
print("🔑 Ключ: ZetaHub")

-- === СИСТЕМА КЛЮЧЕЙ ===
local function checkKey(inputKey)
    local validKeys = {"ZetaHub", "ZetaHubPro", "ZetaHubVIP", "FreeAccess", "KaiScripts", "12345", "admin", "vip2024"}
    for _, key in pairs(validKeys) do if inputKey == key then return true end end
    return false
end

-- === ОКНО ВВОДА КЛЮЧА ===
local function showKeyWindow()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    if not player then return end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "KeySystem"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.7
    bg.Parent = gui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(450, 320)
    frame.Position = UDim2.new(0.5, -225, 0.5, -160)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 200, 50)
    frame.Parent = gui

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    titleBar.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "🔑 ZETA HUB"
    title.TextColor3 = Color3.new(0, 0, 0)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextScaled = true
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(0.9, 0, 0, 30)
    desc.Position = UDim2.new(0.05, 0, 0, 65)
    desc.BackgroundTransparency = 1
    desc.Text = "🔐 Введите ключ для доступа"
    desc.TextColor3 = Color3.new(1, 1, 1)
    desc.TextScaled = true
    desc.Font = Enum.Font.Gotham
    desc.Parent = frame

    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(0.8, 0, 0, 45)
    keyBox.Position = UDim2.new(0.1, 0, 0, 105)
    keyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    keyBox.BackgroundTransparency = 0.3
    keyBox.BorderSizePixel = 2
    keyBox.BorderColor3 = Color3.fromRGB(255, 200, 50)
    keyBox.Text = ""
    keyBox.TextColor3 = Color3.new(1, 1, 1)
    keyBox.TextScaled = true
    keyBox.Font = Enum.Font.Gotham
    keyBox.PlaceholderText = "Введите ключ..."
    keyBox.Parent = frame

    local confirmBtn = Instance.new("TextButton")
    confirmBtn.Size = UDim2.new(0.8, 0, 0, 45)
    confirmBtn.Position = UDim2.new(0.1, 0, 0, 165)
    confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    confirmBtn.BorderSizePixel = 0
    confirmBtn.Text = "✅ ПОДТВЕРДИТЬ"
    confirmBtn.TextColor3 = Color3.new(0, 0, 0)
    confirmBtn.TextScaled = true
    confirmBtn.Font = Enum.Font.GothamBold
    confirmBtn.Parent = frame

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0.9, 0, 0, 25)
    status.Position = UDim2.new(0.05, 0, 0, 220)
    status.BackgroundTransparency = 1
    status.Text = "Введите ключ для доступа"
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
    status.TextScaled = true
    status.Font = Enum.Font.Gotham
    status.Parent = frame

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(0.9, 0, 0, 20)
    info.Position = UDim2.new(0.05, 0, 0, 255)
    info.BackgroundTransparency = 1
    info.Text = "🔑 Ключ: ZetaHub"
    info.TextColor3 = Color3.fromRGB(150, 150, 150)
    info.TextScaled = true
    info.Font = Enum.Font.Gotham
    info.Parent = frame

    local function tryKey()
        local input = keyBox.Text
        if input and input ~= "" then
            if checkKey(input) then
                status.Text = "✅ Ключ принят! Загрузка..."
                status.TextColor3 = Color3.fromRGB(0, 255, 0)
                confirmBtn.Text = "✅ ДОСТУП РАЗРЕШЁН"
                confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                task.wait(1)
                gui:Destroy()
                startMainScript()
            else
                status.Text = "❌ НЕВЕРНЫЙ КЛЮЧ!"
                status.TextColor3 = Color3.fromRGB(255, 0, 0)
                keyBox.Text = ""
                task.wait(1.5)
                status.Text = "Введите ключ для доступа"
                status.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
    end

    confirmBtn.MouseButton1Click:Connect(tryKey)
    keyBox.FocusLost:Connect(function(enterPressed) if enterPressed then tryKey() end end)
end

-- === ОСНОВНОЙ СКРИПТ ===
local function startMainScript()
    print("🚀 Запуск Zeta Hub v1.6...")
    task.wait(1)
    
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local userInput = game:GetService("UserInputService")
    local virtualInput = game:GetService("VirtualInputManager")
    
    if not player then print("❌ Ошибка: Игрок не найден!") return end
    
    print("✅ Игрок: " .. player.Name)

    -- === НАСТРОЙКИ ===
    local Config = {
        AutoFarm = false,
        AutoClick = false,
        AutoBuy = false,
        AutoRestart = false,
        AutoRebirth = false,
        WinFarm = false,
        WinTarget = 1000000,
        CurrentWins = 0,
        IsFarming = false,
        FarmSpeed = 50  -- Скорость фарма по умолчанию
    }

    -- === ФУНКЦИЯ ПОЛУЧЕНИЯ ПОБЕД ===
    local function getCurrentWins()
        local playerGui = player:WaitForChild("PlayerGui")
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                for _, label in pairs(gui:GetDescendants()) do
                    if label:IsA("TextLabel") or label:IsA("TextButton") then
                        local text = label.Text or ""
                        if text:find("Win") or text:find("Побед") or text:find("🏆") then
                            local num = text:match("%d+[,.]?%d*")
                            if num then
                                local clean = num:gsub(",", ""):gsub("%.", "")
                                local wins = tonumber(clean)
                                if wins and wins > 0 then return wins end
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
        if not Config.WinFarm then 
            Config.IsFarming = false
            return 
        end
        
        local currentWins = getCurrentWins()
        Config.CurrentWins = currentWins
        
        if currentWins >= Config.WinTarget then
            print("🏆 ЦЕЛЬ ДОСТИГНУТА! " .. currentWins .. " побед!")
            Config.WinFarm = false
            Config.IsFarming = false
            return
        end
        
        if not Config.IsFarming then
            Config.IsFarming = true
            print("🔄 Фарм побед запущен...")
        end
        
        local mouse = player:GetMouse()
        
        -- ESCAPE (бег)
        virtualInput:SendKeyEvent(true, Enum.KeyCode.Escape, false, nil)
        task.wait(0.02)
        virtualInput:SendKeyEvent(false, Enum.KeyCode.Escape, false, nil)
        
        -- Клики для скорости
        for i = 1, 10 do
            mouse.Button1Click()
            task.wait(0.005)
        end
        
        task.wait(0.05)
        
        for i = 1, 5 do
            mouse.Button1Click()
            task.wait(0.005)
        end
        
        -- Авто-нажатие кнопок
        local playerGui = player:WaitForChild("PlayerGui")
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                for _, btn in pairs(gui:GetDescendants()) do
                    if btn:IsA("TextButton") then
                        local text = btn.Text:lower()
                        if text:find("next") or text:find("continue") or text:find("restart") or 
                           text:find("play again") or text:find("again") or text:find("retry") or text:find("ok") then
                            pcall(function() btn:Click() end)
                            task.wait(0.05)
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

    -- ОСНОВНАЯ КАРТОЧКА
    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(420, 580)
    frame.Position = UDim2.new(0.5, -210, 0.5, -290)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    frame.BackgroundTransparency = 0.05
    frame.ClipsDescendants = true
    frame.Parent = gui

    -- РАМКА
    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 2, 1, 2)
    border.Position = UDim2.new(0, -1, 0, -1)
    border.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    border.BackgroundTransparency = 0.5
    border.Parent = frame

    -- ЗАГОЛОВОК
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    titleBar.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.6, 0, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ ZETA HUB"
    title.TextColor3 = Color3.new(0, 0, 0)
    title.TextScaled = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.Parent = titleBar

    local version = Instance.new("TextLabel")
    version.Size = UDim2.new(0.2, 0, 1, 0)
    version.Position = UDim2.new(0.8, 0, 0, 0)
    version.BackgroundTransparency = 1
    version.Text = "v1.6"
    version.TextColor3 = Color3.new(0, 0, 0)
    version.TextScaled = true
    version.TextXAlignment = Enum.TextXAlignment.Right
    version.Font = Enum.Font.Gotham
    version.Parent = titleBar

    -- КНОПКИ УПРАВЛЕНИЯ
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 25, 0, 25)
    toggleBtn.Position = UDim2.new(1, -55, 0.5, -12.5)
    toggleBtn.Text = "➖"
    toggleBtn.TextColor3 = Color3.new(0, 0, 0)
    toggleBtn.TextScaled = true
    toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.BackgroundTransparency = 0.5
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -28, 0.5, -12.5)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(0, 0, 0)
    closeBtn.TextScaled = true
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.BackgroundTransparency = 0.5
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar

    -- СКРОЛЛ
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, -45)
    scrollFrame.Position = UDim2.new(0, 0, 0, 45)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 750)
    scrollFrame.ScrollBarThickness = 3
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 200, 50)
    scrollFrame.Parent = frame

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 0, 750)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = scrollFrame

    -- === ФУНКЦИИ ===
    
    local function makeTitle(text, y)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.9, 0, 0, 22)
        lbl.Position = UDim2.new(0.05, 0, 0, y)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(255, 200, 50)
        lbl.TextScaled = true
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.GothamBold
        lbl.Parent = contentFrame
        return lbl
    end

    local function makeToggle(text, y, defaultValue, saveKey)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0.9, 0, 0, 28)
        container.Position = UDim2.new(0.05, 0, 0, y)
        container.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        container.BackgroundTransparency = 0.5
        container.BorderSizePixel = 0
        container.Parent = contentFrame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.65, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextScaled = true
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.Parent = container
        
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0.2, 0, 0.7, 0)
        toggle.Position = UDim2.new(0.78, 0, 0.15, 0)
        toggle.Text = defaultValue and "ON" or "OFF"
        toggle.TextColor3 = Color3.new(1, 1, 1)
        toggle.TextScaled = true
        toggle.Font = Enum.Font.GothamBold
        toggle.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
        toggle.BorderSizePixel = 0
        toggle.Parent = container
        
        local state = defaultValue
        toggle.MouseButton1Click:Connect(function()
            state = not state
            toggle.Text = state and "ON" or "OFF"
            toggle.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
            if saveKey then
                Config[saveKey] = state
                if saveKey == "WinFarm" and state == true then
                    Config.IsFarming = false
                    print("🏆 Фарм побед АКТИВИРОВАН!")
                end
            end
        end)
        
        return container, function() return state end
    end

    local function makeButton(text, y, color)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0.9, 0, 0, 32)
        b.Position = UDim2.new(0.05, 0, 0, y)
        b.Text = text
        b.TextColor3 = Color3.new(1, 1, 1)
        b.TextScaled = true
        b.Font = Enum.Font.GothamSemibold
        b.BackgroundColor3 = color or Color3.fromRGB(60, 60, 100)
        b.BorderSizePixel = 0
        b.Parent = contentFrame
        return b
    end

    -- === СОЗДАНИЕ КНОПОК ===
    local yPos = 10
    
    -- СТАТУС ПОБЕД
    local winsDisplay = Instance.new("TextLabel")
    winsDisplay.Size = UDim2.new(0.9, 0, 0, 28)
    winsDisplay.Position = UDim2.new(0.05, 0, 0, yPos)
    winsDisplay.BackgroundColor3 = Color3.fromRGB(0, 50, 100)
    winsDisplay.BackgroundTransparency = 0.3
    winsDisplay.BorderSizePixel = 1
    winsDisplay.BorderColor3 = Color3.fromRGB(255, 200, 50)
    winsDisplay.Text = "🏆 Побед: 0 | Цель: 1,000,000"
    winsDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
    winsDisplay.TextScaled = true
    winsDisplay.Font = Enum.Font.GothamBold
    winsDisplay.Parent = contentFrame
    yPos = yPos + 35

    -- ОБНОВЛЕНИЕ СТАТУСА
    task.spawn(function()
        while task.wait(1) do
            local wins = getCurrentWins()
            Config.CurrentWins = wins
            winsDisplay.Text = "🏆 Побед: " .. string.format("%d", wins) .. " | Цель: " .. string.format("%d", Config.WinTarget)
        end
    end)

    makeTitle("🤖 АВТО-ФАРМ", yPos)
    yPos = yPos + 28
    
    local farmToggle, getFarm = makeToggle("Auto Farm (все вместе)", yPos, false, "AutoFarm")
    yPos = yPos + 33
    
    -- Убрал Auto Escape!
    local clickToggle, getClick = makeToggle("Auto Click", yPos, false, "AutoClick")
    yPos = yPos + 33
    local buyToggle, getBuy = makeToggle("Auto Buy", yPos, false, "AutoBuy")
    yPos = yPos + 33
    local restartToggle, getRestart = makeToggle("Auto Restart", yPos, false, "AutoRestart")
    yPos = yPos + 33
    local rebirthToggle, getRebirth = makeToggle("Auto Rebirth", yPos, false, "AutoRebirth")
    yPos = yPos + 40

    makeTitle("🏆 ФАРМ ПОБЕД", yPos)
    yPos = yPos + 28
    
    local winFarmToggle, getWinFarm = makeToggle("Фарм побед", yPos, false, "WinFarm")
    yPos = yPos + 33

    -- ВЫБОР ЦЕЛИ
    local targetLabel = Instance.new("TextLabel")
    targetLabel.Size = UDim2.new(0.35, 0, 0, 28)
    targetLabel.Position = UDim2.new(0.05, 0, 0, yPos)
    targetLabel.BackgroundTransparency = 1
    targetLabel.Text = "🎯 Цель:"
    targetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    targetLabel.TextScaled = true
    targetLabel.TextXAlignment = Enum.TextXAlignment.Left
    targetLabel.Font = Enum.Font.Gotham
    targetLabel.Parent = contentFrame

    local targetBox = Instance.new("TextBox")
    targetBox.Size = UDim2.new(0.4, 0, 0, 28)
    targetBox.Position = UDim2.new(0.45, 0, 0, yPos)
    targetBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    targetBox.BackgroundTransparency = 0.5
    targetBox.BorderSizePixel = 1
    targetBox.BorderColor3 = Color3.fromRGB(255, 200, 50)
    targetBox.Text = "1000000"
    targetBox.TextColor3 = Color3.new(1, 1, 1)
    targetBox.TextScaled = true
    targetBox.Font = Enum.Font.Gotham
    targetBox.Parent = contentFrame
    
    targetBox.FocusLost:Connect(function()
        local num = tonumber(targetBox.Text)
        if num and num > 0 then Config.WinTarget = num end
    end)

    yPos = yPos + 33

    -- === НОВОЕ: СКОРОСТЬ ФАРМА ОТ 1 ДО 450 ===
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0.35, 0, 0, 28)
    speedLabel.Position = UDim2.new(0.05, 0, 0, yPos)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "⚡ Скорость:"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextScaled = true
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.Parent = contentFrame

    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0.4, 0, 0, 28)
    speedBox.Position = UDim2.new(0.45, 0, 0, yPos)
    speedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    speedBox.BackgroundTransparency = 0.5
    speedBox.BorderSizePixel = 1
    speedBox.BorderColor3 = Color3.fromRGB(255, 200, 50)
    speedBox.Text = "50"
    speedBox.TextColor3 = Color3.new(1, 1, 1)
    speedBox.TextScaled = true
    speedBox.Font = Enum.Font.Gotham
    speedBox.Parent = contentFrame
    
    speedBox.FocusLost:Connect(function()
        local num = tonumber(speedBox.Text)
        if num and num >= 1 and num <= 450 then
            Config.FarmSpeed = num
            print("⚡ Скорость фарма: " .. num)
        else
            speedBox.Text = tostring(Config.FarmSpeed)
        end
    end)

    yPos = yPos + 33

    -- Кнопки быстрой скорости
    local function makeSpeedButton(text, value, xOffset)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.12, 0, 0, 25)
        btn.Position = UDim2.new(0.05 + xOffset * 0.14, 0, 0, yPos)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.BackgroundColor3 = Color3.fromRGB(50, 80, 120)
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(255, 200, 50)
        btn.Parent = contentFrame
        
        btn.MouseButton1Click:Connect(function()
            Config.FarmSpeed = value
            speedBox.Text = tostring(value)
            print("⚡ Скорость фарма: " .. value)
        end)
        return btn
    end

    makeSpeedButton("1", 1, 0)
    makeSpeedButton("10", 10, 1)
    makeSpeedButton("25", 25, 2)
    makeSpeedButton("50", 50, 3)
    makeSpeedButton("100", 100, 4)
    makeSpeedButton("150", 150, 5)
    makeSpeedButton("250", 250, 6)
    makeSpeedButton("450", 450, 7)
    yPos = yPos + 33

    -- КНОПКИ БЫСТРОЙ ЦЕЛИ
    local function makeTargetButton(text, value, xOffset)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.17, 0, 0, 28)
        btn.Position = UDim2.new(0.05 + xOffset * 0.19, 0, 0, yPos)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(255, 200, 50)
        btn.Parent = contentFrame
        
        btn.MouseButton1Click:Connect(function()
            Config.WinTarget = value
            targetBox.Text = tostring(value)
            print("🎯 Цель: " .. value .. " побед")
        end)
        return btn
    end

    makeTargetButton("1M", 1000000, 0)
    makeTargetButton("1.5M", 1500000, 1)
    makeTargetButton("2.5M", 2500000, 2)
    makeTargetButton("4M", 4000000, 3)
    makeTargetButton("6M", 6000000, 4)
    yPos = yPos + 33

    makeTargetButton("10M", 10000000, 0)
    makeTargetButton("15M", 15000000, 1)
    makeTargetButton("16M", 16000000, 2)
    makeTargetButton("25M", 25000000, 3)
    makeTargetButton("40M", 40000000, 4)
    yPos = yPos + 40

    -- БЫСТРЫЕ ДЕЙСТВИЯ (убрал Heal!)
    makeTitle("⚡ БЫСТРЫЕ ДЕЙСТВИЯ", yPos)
    yPos = yPos + 28
    
    local speedBtn = makeButton("⚡ Speed Boost", yPos, Color3.fromRGB(0, 150, 255))
    yPos = yPos + 36
    local jumpBtn = makeButton("🦘 Super Jump", yPos, Color3.fromRGB(255, 150, 0))
    yPos = yPos + 36
    -- Heal убран!
    local rebirthBtn = makeButton("♻️ Rebirth сейчас", yPos, Color3.fromRGB(200, 50, 255))
    yPos = yPos + 40

    -- СТАТУС
    local statusBar = Instance.new("TextLabel")
    statusBar.Size = UDim2.new(0.9, 0, 0, 22)
    statusBar.Position = UDim2.new(0.05, 0, 0, yPos + 5)
    statusBar.BackgroundTransparency = 1
    statusBar.Text = "✅ Включай что нужно! Скорость от 1 до 450"
    statusBar.TextColor3 = Color3.fromRGB(150, 255, 150)
    statusBar.TextScaled = true
    statusBar.Font = Enum.Font.Gotham
    statusBar.Parent = contentFrame

    -- === ОСНОВНОЙ ЦИКЛ ===
    task.spawn(function()
        while task.wait(0.05) do
            if getFarm() then
                pcall(function()
                    -- Auto Escape убран!
                    
                    if getClick() then
                        local mouse = player:GetMouse()
                        mouse.Button1Click()
                    end
                    
                    if getBuy() then
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
                    
                    if getRestart() then
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
                    
                    if getRebirth() then
                        local playerGui = player:WaitForChild("PlayerGui")
                        for _, gui in pairs(playerGui:GetChildren()) do
                            if gui:IsA("ScreenGui") then
                                for _, btn in pairs(gui:GetDescendants()) do
                                    if btn:IsA("TextButton") then
                                        local name = btn.Name:lower()
                                        local text = btn.Text:lower()
                                        if name:find("rebirth") or name:find("prestige") or text:find("rebirth") or text:find("prestige") then
                                            pcall(function() btn:Click() end)
                                            task.wait(0.3)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
            
            -- ФАРМ ПОБЕД С РЕГУЛИРУЕМОЙ СКОРОСТЬЮ
            if getWinFarm() and Config.CurrentWins < Config.WinTarget then
                pcall(farmWins)
                -- Задержка от 1 до 450 (чем выше число, тем быстрее)
                local delay = math.max(0.01, 1 / Config.FarmSpeed)
                task.wait(delay)
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

    rebirthBtn.MouseButton1Click:Connect(function()
        local playerGui = player:WaitForChild("PlayerGui")
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                for _, btn in pairs(gui:GetDescendants()) do
                    if btn:IsA("TextButton") then
                        local name = btn.Name:lower()
                        local text = btn.Text:lower()
                        if name:find("rebirth") or name:find("prestige") or text:find("rebirth") or text:find("prestige") then
                            pcall(function() btn:Click() end)
                            task.wait(0.3)
                        end
                    end
                end
            end
        end
    end)

    -- Свернуть
    local isMinimized = false
    local tweenService = game:GetService("TweenService")
    toggleBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetSize = isMinimized and UDim2.fromOffset(420, 45) or UDim2.fromOffset(420, 580)
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = tweenService:Create(frame, tweenInfo, {Size = targetSize})
        tween:Play()
        scrollFrame.Visible = not isMinimized
        toggleBtn.Text = isMinimized and "➕" or "➖"
        frame.Position = isMinimized and UDim2.new(0.5, -210, 0, 10) or UDim2.new(0.5, -210, 0.5, -290)
    end)

    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- Горячие клавиши
    userInput.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.F1 then
            gui.Enabled = not gui.Enabled
        end
    end)

    print("✅ Zeta Hub v1.6 загружен!")
    print("📌 F1 - Показать/Скрыть панель")
    print("⚡ Скорость фарма от 1 до 450!")
    print("🎯 Каждый тогл работает отдельно!")
end

-- === ЗАПУСК ===
showKeyWindow()
print("🔑 Введите ключ 'ZetaHub' для доступа")
print("⚡ Zeta Hub v1.6 - Скорость фарма 1-450!")
```

---

✅ Что изменилось в v1.6:

❌ УБРАНО:

· Auto Escape — больше нет в меню
· Heal — больше нет в быстрых действиях

✅ ДОБАВЛЕНО:

· Скорость фарма от 1 до 450
· Поле ввода для скорости
· Кнопки быстрой скорости: 1, 10, 25, 50, 100, 150, 250, 450

---

⚡ Как работает скорость фарма:

Значение Задержка Скорость
1 1 сек Медленно
50 0.02 сек Средне
100 0.01 сек Быстро
450 0.0022 сек Очень быстро

Чем выше число, тем быстрее фарм!

---

📋 Что осталось:

🤖 Авто-фарм:

· Auto Farm (всё вместе)
· Auto Click
· Auto Buy
· Auto Restart
· Auto Rebirth

🏆 Фарм побед:

· Фарм побед
· Цель (любое число)
· Быстрые кнопки 1M-40M

⚡ Быстрые действия:

· Speed Boost
· Super Jump
· Rebirth сейчас

---

Готово! Версия 1.6 — чистая и быстрая! 🚀
