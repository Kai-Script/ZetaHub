print("🔥 Zeta Hub v5.2 ЗАПУСК...")

task.wait(2)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local soundService = game:GetService("SoundService")

if not player then
    print("❌ Игрок не найден!")
    return
end

print("✅ Игрок: " .. player.Name)

-- === НАСТРОЙКИ ===
local Config = {
    Minimized = true,
    MusicOn = false
}

-- === ВСТРОЕННАЯ МУЗЫКА ===
local music = nil
local function toggleMusic()
    Config.MusicOn = not Config.MusicOn
    
    if Config.MusicOn then
        if not music then
            music = Instance.new("Sound")
            music.SoundId = "rbxassetid://9120281726"
            music.Volume = 0.2
            music.Looped = true
            music.Parent = soundService
        end
        music:Play()
        print("🎵 Музыка включена!")
    else
        if music then
            music:Stop()
            music:Destroy()
            music = nil
            print("🔇 Музыка выключена!")
        end
    end
end

-- === СОЗДАНИЕ GUI ===
local gui = Instance.new("ScreenGui")
gui.Name = "ZetaHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- === СВЁРНУТОЕ МЕНЮ ===
local miniFrame = Instance.new("Frame")
miniFrame.Size = UDim2.fromOffset(160, 45)
miniFrame.Position = UDim2.new(0.5, -80, 0.9, -20)
miniFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
miniFrame.BackgroundTransparency = 0.85
miniFrame.BorderSizePixel = 2
miniFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
miniFrame.Visible = true
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

-- === РАЗВЁРНУТОЕ МЕНЮ ===
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(400, 550)
frame.Position = UDim2.new(0.5, -200, 0.5, -275)
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
title.Text = "⚡ ZETA HUB v5.2"
title.TextColor3 = Color3.new(0, 0, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

-- КНОПКИ УПРАВЛЕНИЯ
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -65, 0.5, -15)
minimizeBtn.Text = "➕"
minimizeBtn.TextColor3 = Color3.new(0, 0, 0)
minimizeBtn.TextScaled = true
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.BackgroundTransparency = 0.4
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0,
