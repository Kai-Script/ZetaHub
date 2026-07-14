-- Zeta Hub v1.8 - ПОЛНАЯ ВЕРСИЯ (РАБОЧАЯ)
-- Для игры: +1 Speed Keyboard Escape
-- Вставь в Xeno Executor и нажми Execute

print("🔥 Zeta Hub v1.8 ЗАПУСК...")

task.wait(3)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local virtualInput = game:GetService("VirtualInputManager")
local userInput = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

if not player then
    print("❌ Игрок не найден!")
    return
end

print("✅ Игрок: " .. player.Name)

-- === НАСТРОЙКИ ===
local Config = {
    AutoEscape = false,
    AutoClick = false,
    AutoBuy = false,
    AutoRestart = false,
    AutoRebirth = false,
    WinFarm = false,
    WinTarget = 1000000,
    CurrentWins = 0,
    FarmSpeed = 50,
    DisableEffects = false,
    BannerText = "👑ZETA HUB👑",
    BannerEnabled = true
}

-- === БАННЕР НАД СКИНОМ ===
local banner = nil
local function updateBanner()
    local char = player.Character
    if not char then return end
    
    if banner then 
        pcall(function() banner:Destroy() end)
        banner = nil
    end
    
    if not Config.BannerEnabled then return end
    
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    banner = Instance.new("BillboardGui")
    banner.Name = "ZetaBanner"
    banner.Size = UDim2.fromOffset(300, 60)
    banner.Adornee = head
    banner.AlwaysOnTop = true
    banner.StudsOffset = Vector3.new(0, 4, 0)
    banner.Parent = char
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    bg.BackgroundTransparency = 0.15
    bg.BorderSizePixel = 3
    bg.BorderColor3 = Color3.fromRGB(255, 0, 0)
    bg.Parent = banner
    
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1.1, 0, 1.3, 0)
    glow.Position = UDim2.new(-0.05, 0, -0.15, 0)
    glow.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    glow.BackgroundTransparency = 0.6
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

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    updateBanner()
end)

-- === ОТКЛЮЧЕНИЕ ЭФФЕКТОВ ===
local function toggleEffects(on)
    if on then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("Trail") then
                pcall(function() v.Enabled = false end)
            end
        end
        lighting.GlobalShadows = false
        lighting.Brightness = 0.5
        print("🛑 Эффекты отключены")
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("Trail") then
                pcall(function() v.Enabled = true end)
            end
        end
        lighting.GlobalShadows = true
        lighting.Brightness = 2
        print("✅ Эффекты включены")
    end
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
    task.wait(0.02)
    virtualInput:SendKeyEvent(false, Enum.KeyCode.Escape, false, nil)
    
    -- Клики
    for i = 1, 10 do
        mouse.Button1Click()
        task.wait(0.01)
    end
    
    task.wait(0.05)
    
    for i = 1, 5 do
        mouse.Button1Click()
        task.wait(0.01)
    end
    
    -- Авто-нажатие кнопок
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        for _, g in pairs(pg:GetChildren()) do
            if g:IsA("ScreenGui") then
                for _, btn in pairs(g:GetDescendants()) do
                    if btn:IsA("TextButton") then
                        local t = btn.Text:lower() or ""
                        if t:find("next") or t:find("continue") or t:find("restart") or t:find("play again") or t:find("ok") then
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

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(420, 620)
frame.Position = UDim2.new(0.5, -210, 0.5, -310)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
frame.BackgroundTransparency = 0.05
frame.ClipsDescendants = true
frame.Parent = gui

local border = Instance.new("Frame")
border.Size = UDim2.new(1, 2, 1, 2)
border.Position = UDim2.new(0, -1, 0, -1)
border.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
border.BackgroundTransparency = 0.5
border.Parent = frame

-- ЗАГОЛОВОК
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
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

local ver = Instance.new("TextLabel")
ver.Size = UDim2.new(0.2, 0, 1, 0)
ver.Position = UDim2.new(0.8, 0, 0, 0)
ver.BackgroundTransparency = 1
ver.Text = "v1.8"
ver.TextColor3 = Color3.new(0, 0, 0)
ver.TextScaled = true
ver.TextXAlignment = Enum.TextXAlignment.Right
ver.Font = Enum.Font.Gotham
ver.Parent = titleBar

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
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -40)
scroll.Position = UDim2.new(0, 0, 0, 40)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 820)
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 200, 50)
scroll.Parent = frame

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 0, 820)
content.BackgroundTransparency = 1
content.Parent = scroll

-- === ФУНКЦИИ ===
local function makeTitle(t, y)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.9, 0, 0, 22)
    l.Position = UDim2.new(0.05, 0, 0, y)
    l.BackgroundTransparency = 1
    l.Text = t
    l.TextColor3 = Color3.fromRGB(255, 200, 50)
    l.TextScaled = true
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.GothamBold
    l.Parent = content
    return l
end

local function makeToggle(text, y, default, key, cb)
    local c = Instance.new("Frame")
    c.Size = UDim2.new(0.9, 0, 0, 28)
    c.Position = UDim2.new(0.05, 0, 0, y)
    c.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    c.BackgroundTransparency = 0.5
    c.BorderSizePixel = 0
    c.Parent = content
    
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.65, 0, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.new(1, 1, 1)
    l.TextScaled = true
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.Gotham
    l.Parent = c
    
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.2, 0, 0.7, 0)
    b.Position = UDim2.new(0.78, 0, 0.15, 0)
    b.Text = default and "ON" or "OFF"
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextScaled = true
    b.Font = Enum.Font.GothamBold
    b.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
    b.BorderSizePixel = 0
    b.Parent = c
    
    local st = default
    b.MouseButton1Click:Connect(function()
        st = not st
        b.Text = st and "ON" or "OFF"
        b.BackgroundColor3 = st and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
        Config[key] = st
        if cb then cb(st) end
    end)
    
    return c
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
    b.Parent = content
    return b
end

local function makeTagButton(text, value, x, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.17, 0, 0, 25)
    b.Position = UDim2.new(0.05 + x * 0.19, 0, 0, y)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextScaled = true
    b.Font = Enum.Font.Gotham
    b.BackgroundColor3 = Color3.fromRGB(80, 50, 80)
    b.BorderSizePixel = 1
    b.BorderColor3 = Color3.fromRGB(255, 200, 50)
    b.Parent = content
    
    b.MouseButton1Click:Connect(function()
        Config.BannerText = value
        updateBanner()
    end)
    return b
end

local function makeSpeedButton(text, value, x, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.12, 0, 0, 25)
    b.Position = UDim2.new(0.05 + x * 0.14, 0, 0, y)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextScaled = true
    b.Font = Enum.Font.Gotham
    b.BackgroundColor3 = Color3.fromRGB(50, 80, 120)
    b.BorderSizePixel = 1
    b.BorderColor3 = Color3.fromRGB(255, 200, 50)
    b.Parent = content
    
    b.MouseButton1Click:Connect(function()
        Config.FarmSpeed = value
    end)
    return b
end

local function makeTargetButton(text, value, x, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.17, 0, 0, 28)
    b.Position = UDim2.new(0.05 + x * 0.19, 0, 0, y)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextScaled = true
    b.Font = Enum.Font.Gotham
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    b.BorderSizePixel = 1
    b.BorderColor3 = Color3.fromRGB(255, 200, 50)
    b.Parent = content
    
    b.MouseButton1Click:Connect(function()
        Config.WinTarget = value
    end)
    return b
end

-- === ПОСТРОЕНИЕ МЕНЮ ===
local y = 10

-- СТАТУС
local winsDisplay = Instance.new("TextLabel")
winsDisplay.Size = UDim2.new(0.9, 0, 0, 28)
winsDisplay.Position = UDim2.new(0.05, 0, 0, y)
winsDisplay.BackgroundColor3 = Color3.fromRGB(0, 50, 100)
winsDisplay.BackgroundTransparency = 0.3
winsDisplay.BorderSizePixel = 1
winsDisplay.BorderColor3 = Color3.fromRGB(255, 200, 50)
winsDisplay.Text = "🏆 Побед: 0 | Цель: 1,000,000"
winsDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
winsDisplay.TextScaled = true
winsDisplay.Font = Enum.Font.GothamBold
winsDisplay.Parent = content
y = y + 35

task.spawn(function()
    while task.wait(1) do
        local w = getWins()
        Config.CurrentWins = w
        winsDisplay.Text = "🏆 Побед: " .. string.format("%d", w) .. " | Цель: " .. string.format("%d", Config.WinTarget)
    end
end)

-- БАННЕР
makeTitle("👑 БАННЕР НАД СКИНОМ", y)
y = y + 28

makeToggle("Показать баннер", y, true, "BannerEnabled", function(s)
    Config.BannerEnabled = s
    updateBanner()
end)
y = y + 33

local bl = Instance.new("TextLabel")
bl.Size = UDim2.new(0.35, 0, 0, 28)
bl.Position = UDim2.new(0.05, 0, 0, y)
bl.BackgroundTransparency = 1
bl.Text = "📝 Текст:"
bl.TextColor3 = Color3.fromRGB(255, 255, 255)
bl.TextScaled = true
bl.TextXAlignment = Enum.TextXAlignment.Left
bl.Font = Enum.Font.Gotham
bl.Parent = content

local bb = Instance.new("TextBox")
bb.Size = UDim2.new(0.45, 0, 0, 28)
bb.Position = UDim2.new(0.45, 0, 0, y)
bb.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
bb.BackgroundTransparency = 0.5
bb.BorderSizePixel = 1
bb.BorderColor3 = Color3.fromRGB(255, 200, 50)
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

y = y + 33

local tags = {
    {"👑ZETA HUB👑", "👑ZETA HUB👑"},
    {"🎬CONTENT CREATOR", "🎬CONTENT CREATOR"},
    {"👑CREATOR👑", "👑CREATOR👑"},
    {"🌟STAR🌟", "🌟STAR🌟"},
    {"💎VIP💎", "💎VIP💎"}
}
for i, v in pairs(tags) do
    makeTagButton(v[1], v[2], i-1, y)
end
y = y + 33

local tags2 = {
    {"🔥ADMIN🔥", "🔥ADMIN🔥"},
    {"⚡PRO⚡", "⚡PRO⚡"},
    {"🏆WINNER🏆", "🏆WINNER🏆"},
    {"👾HACKER👾", "👾HACKER👾"},
    {"✨GOD✨", "✨GOD✨"}
}
for i, v in pairs(tags2) do
    makeTagButton(v[1], v[2], i-1, y)
end
y = y + 40

-- ЭФФЕКТЫ
makeTitle("🛡️ АДМИН-АБЬЮЗ", y)
y = y + 28

makeToggle("Отключить эффекты", y, false, "DisableEffects", function(s)
    Config.DisableEffects = s
    toggleEffects(s)
end)
y = y + 40

-- АВТО-ФАРМ
makeTitle("🤖 АВТО-ФАРМ", y)
y = y + 28

makeToggle("⌨️ Auto Escape", y, false, "AutoEscape")
y = y + 33
makeToggle("🖱️ Auto Click", y, false, "AutoClick")
y = y + 33
makeToggle("🛒 Auto Buy", y, false, "AutoBuy")
y = y + 33
makeToggle("🔄 Auto Restart", y, false, "AutoRestart")
y = y + 33
makeToggle("♻️ Auto Rebirth", y, false, "AutoRebirth")
y = y + 40

-- ФАРМ ПОБЕД
makeTitle("🏆 ФАРМ ПОБЕД", y)
y = y + 28

makeToggle("Фарм побед", y, false, "WinFarm")
y = y + 33

local tl = Instance.new("TextLabel")
tl.Size = UDim2.new(0.35, 0, 0, 28)
tl.Position = UDim2.new(0.05, 0, 0, y)
tl.BackgroundTransparency = 1
tl.Text = "🎯 Цель:"
tl.TextColor3 = Color3.fromRGB(255, 255, 255)
tl.TextScaled = true
tl.TextXAlignment = Enum.TextXAlignment.Left
tl.Font = Enum.Font.Gotham
tl.Parent = content

local tb = Instance.new("TextBox")
tb.Size = UDim2.new(0.4, 0, 0, 28)
tb.Position = UDim2.new(0.45, 0, 0, y)
tb.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
tb.BackgroundTransparency = 0.5
tb.BorderSizePixel = 1
tb.BorderColor3 = Color3.fromRGB(255, 200, 50)
tb.Text = "1000000"
tb.TextColor3 = Color3.new(1, 1, 1)
tb.TextScaled = true
tb.Font = Enum.Font.Gotham
tb.Parent = content

tb.FocusLost:Connect(function()
    local n = tonumber(tb.Text)
    if n and n > 0 then Config.WinTarget = n end
end)

y = y + 33

local sl = Instance.new("TextLabel")
sl.Size = UDim2.new(0.35, 0, 0, 28)
sl.Position = UDim2.new(0.05, 0, 0, y)
sl.BackgroundTransparency = 1
sl.Text = "⚡ Скорость:"
sl.TextColor3 = Color3.fromRGB(255, 255, 255)
sl.TextScaled = true
sl.TextXAlignment = Enum.TextXAlignment.Left
sl.Font = Enum.Font.Gotham
sl.Parent = content

local sb = Instance.new("TextBox")
sb.Size = UDim2.new(0.4, 0, 0, 28)
sb.Position = UDim2.new(0.45, 0, 0, y)
sb.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
sb.BackgroundTransparency = 0.5
sb.BorderSizePixel = 1
sb.BorderColor3 = Color3.fromRGB(255, 200, 50)
sb.Text = "50"
sb.TextColor3 = Color3.new(1, 1, 1)
sb.TextScaled = true
sb.Font = Enum.Font.Gotham
sb.Parent = content

sb.FocusLost:Connect(function()
    local n = tonumber(sb.Text)
    if n and n >= 1 and n <= 450 then Config.FarmSpeed = n end
end)

y = y + 33

local speeds = {{"1",1},{"10",10},{"25",25},{"50",50},{"100",100},{"150",150},{"250",250},{"450",450}}
for i, v in pairs(speeds) do
    makeSpeedButton(v[1], v[2], i-1, y)
end
y = y + 33

local targets = {{"1M",1000000},{"1.5M",1500000},{"2.5M",2500000},{"4M",4000000},{"6M",6000000}}
for i, v in pairs(targets) do
    makeTargetButton(v[1], v[2], i-1, y)
end
y = y + 33

local targets2 = {{"10M",10000000},{"15M",15000000},{"16M",16000000},{"25M",25000000},{"40M",40000000}}
for i, v in pairs(targets2) do
    makeTargetButton(v[1], v[2], i-1, y)
end
y = y + 40

-- БЫСТРЫЕ ДЕЙСТВИЯ
makeTitle("⚡ БЫСТРЫЕ ДЕЙСТВИЯ", y)
y = y + 28

local speedBtn = makeButton("⚡ Speed Boost", y, Color3.fromRGB(0, 150, 255))
y = y + 36
local jumpBtn = makeButton("🦘 Super Jump", y, Color3.fromRGB(255, 150, 0))
y = y + 36
local rebirthBtn = makeButton("♻️ Rebirth сейчас", y, Color3.fromRGB(200, 50, 255))
y = y + 40

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0, 22)
status.Position = UDim2.new(0.05, 0, 0, y + 5)
status.BackgroundTransparency = 1
status.Text = "✅ Zeta Hub v1.8 | Баннер над скином!"
status.TextColor3 = Color3.fromRGB(150, 255, 150)
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.Parent = content

-- === ОСНОВНОЙ ЦИКЛ ===
task.spawn(function()
    while task.wait(0.1) do
        -- Auto Escape
        if Config.AutoEscape then
            pcall(function()
                virtualInput:SendKeyEvent(true, Enum.KeyCode.Escape, false, nil)
                task.wait(0.02)
                virtualInput:SendKeyEvent(false, Enum.KeyCode.Escape, false, nil)
            end)
        end
        
        -- Auto Click
        if Config.AutoClick then
            pcall(function()
                player:GetMouse().Button1Click()
            end)
        end
        
        -- Auto Buy
        if Config.AutoBuy then
            pcall(function()
                local pg = player:FindFirstChild("PlayerGui")
                if pg then
                    for _, g in pairs(pg:GetChildren()) do
                        if g:IsA("ScreenGui") then
                            for _, btn in pairs(g:GetDescendants()) do
                                if btn:IsA("TextButton") then
                                    local n = btn.Name:lower() or ""
                                    if n:find("buy") or n:find("upgrade") or n:find("shop") then
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
        
        -- Auto Restart
        if Config.AutoRestart then
            pcall(function()
                local pg = player:FindFirstChild("PlayerGui")
                if pg then
                    for _, g in pairs(pg:GetChildren()) do
                        if g:IsA("ScreenGui") then
                            for _, btn in pairs(g:GetDescendants()) do
                                if btn:IsA("TextButton") then
                                    local n = btn.Name:lower() or ""
                                    if n:find("restart") or n:find("retry") or n:find("again") then
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
        
        -- Auto Rebirth
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
                                    if n:find("rebirth") or n:find("prestige") or t:find("rebirth") then
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
        
        -- Фарм побед
        if Config.WinFarm then
            pcall(farmWins)
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
        local o = hum.WalkSpeed
        hum.WalkSpeed = 80
        task.wait(2)
        hum.WalkSpeed = o or 16
    end
end)

jumpBtn.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        local o = hum.JumpPower
        hum.JumpPower = 150
        hum:Jump()
        task.wait(0.3)
        hum.JumpPower = o or 50
    end
end)

rebirthBtn.MouseButton1Click:Connect(function()
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        for _, g in pairs(pg:GetChildren()) do
            if g:IsA("ScreenGui") then
                for _, btn in pairs(g:GetDescendants()) do
                    if btn:IsA("TextButton") then
                        local n = btn.Name:lower() or ""
                        local t = btn.Text:lower() or ""
                        if n:find("rebirth") or n:find("prestige") or t:find("rebirth") then
                            pcall(function() btn:Click() end)
                            task.wait(0.2)
                        end
                    end
                end
            end
        end
    end
end)

-- БАННЕР ПРИ ЗАПУСКЕ
task.wait(0.5)
updateBanner()

-- СВЕРНУТЬ
local minimized = false
toggleBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local sz = minimized and UDim2.fromOffset(420, 40) or UDim2.fromOffset(420, 620)
    local tw = tweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = sz})
    tw:Play()
    scroll.Visible = not minimized
    toggleBtn.Text = minimized and "➕" or "➖"
    frame.Position = minimized and UDim2.new(0.5, -210, 0, 10) or UDim2.new(0.5, -210, 0.5, -310)
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

userInput.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        gui.Enabled = not gui.Enabled
    end
end)

print("✅ Zeta Hub v1.8 ЗАГРУЖЕН!")
print("📌 F1 - Показать/Скрыть")
print("👑 Баннер: " .. Config.BannerText)
print("🛡️ Отключение эффектов - в меню!")
```

