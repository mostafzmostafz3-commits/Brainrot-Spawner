local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui كامل الشاشة
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltraHackerCinematic"
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- الخلفية
local background = Instance.new("Frame")
background.Size = UDim2.new(1,0,1,0)
background.Position = UDim2.new(0,0,0,0)
background.BackgroundColor3 = Color3.fromRGB(0,0,0)
background.BorderSizePixel = 0
background.Parent = screenGui

-- Matrix Rain مزدوجة (0 و 1)
local matrixFrame = Instance.new("Frame")
matrixFrame.Size = UDim2.new(1,0,1,0)
matrixFrame.BackgroundTransparency = 1
matrixFrame.Parent = background

local columns = 150
local chars = {}
local screenWidth = workspace.CurrentCamera.ViewportSize.X
local colWidth = math.ceil(screenWidth / columns)

for i = 1, columns do
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, colWidth, 0, 30)
    label.Position = UDim2.new((i-1)/columns,0,math.random(),0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0,255,0)
    label.Font = Enum.Font.Code
    label.TextScaled = true
    label.Text = tostring(math.random(0,1))
    label.Parent = matrixFrame
    table.insert(chars, label)

    -- نضيف نسخة ثانية لكل عمود (مضاعفة الرقم)
    local label2 = label:Clone()
    label2.Position = UDim2.new((i-1)/columns,0,math.random(),0)
    label2.Parent = matrixFrame
    table.insert(chars, label2)
end

-- حركة الأرقام نزول مستمر
spawn(function()
    while matrixFrame.Parent do
        for _, label in pairs(chars) do
            label.Position = UDim2.new(label.Position.X.Scale,0,label.Position.Y.Scale + 0.05,0)
            if label.Position.Y.Scale > 1 then
                label.Position = UDim2.new(label.Position.X.Scale,0,0,0)
                label.Text = tostring(math.random(0,1))
            end
        end
        wait(0.015)
    end
end)

-- شريط التحميل
local loadingBarBackground = Instance.new("Frame")
loadingBarBackground.Size = UDim2.new(1,0,0.05,0)
loadingBarBackground.Position = UDim2.new(0,0,0.92,0)
loadingBarBackground.BackgroundColor3 = Color3.fromRGB(20,20,20)
loadingBarBackground.BorderSizePixel = 0
loadingBarBackground.Parent = background

local loadingBar = Instance.new("Frame")
loadingBar.Size = UDim2.new(0,0,1,0)
loadingBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
loadingBar.BorderSizePixel = 0
loadingBar.Parent = loadingBarBackground

-- نص ثابت WAIT LOADING
local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1,0,0.25,0)
loadingText.Position = UDim2.new(0,0,0.75,0)
loadingText.BackgroundTransparency = 1
loadingText.TextColor3 = Color3.fromRGB(0,255,0)
loadingText.Font = Enum.Font.Code
loadingText.TextScaled = true
loadingText.Text = "WAIT LOADING"
loadingText.Parent = background

-- Neon حواف متحركة
local function createNeonEdge(position, size)
    local edge = Instance.new("Frame")
    edge.Size = size
    edge.Position = position
    edge.BackgroundColor3 = Color3.fromRGB(0,255,0)
    edge.BackgroundTransparency = 0.4
    edge.BorderSizePixel = 0
    edge.Parent = background
    spawn(function()
        while edge.Parent do
            edge.BackgroundTransparency = 0.2 + math.random()*0.5
            wait(0.04)
        end
    end)
end

createNeonEdge(UDim2.new(0,0,0,0), UDim2.new(1,0,0.005,0))      -- أعلى
createNeonEdge(UDim2.new(0,0,0.995,0), UDim2.new(1,0,0.005,0))  -- أسفل
createNeonEdge(UDim2.new(0,0,0,0), UDim2.new(0.005,0,1,0))      -- يسار
createNeonEdge(UDim2.new(0.995,0,0,0), UDim2.new(0.005,0,1,0))  -- يمين

-- خطوط Neon Scanner داخل الشاشة
for i = 1, 20 do
    local scanner = Instance.new("Frame")
    scanner.Size = UDim2.new(0, math.random(5,15), 0, workspace.CurrentCamera.ViewportSize.Y)
    scanner.Position = UDim2.new(math.random(),0,0,0)
    scanner.BackgroundColor3 = Color3.fromRGB(0,255,0)
    scanner.BackgroundTransparency = 0.6
    scanner.BorderSizePixel = 0
    scanner.Parent = background

    spawn(function()
        while scanner.Parent do
            local speed = math.random(0.005,0.02)
            scanner.Position = UDim2.new(-0.1,0,0,0)
            for x = 0,1.1,speed do
                scanner.Position = UDim2.new(x,0,0,0)
                wait(0.01)
            end
            wait(math.random()*0.3)
        end
    end)
end

-- التحميل لمدة دقيقتين (120 ثانية)
local duration = 120
local progress = 0
local increment = 100 / (duration / 0.03)
while progress <= 100 do
    loadingBar:TweenSize(UDim2.new(progress/100,0,1,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.03, true)
    progress = progress + increment
    wait(0.03)
end

-- ثانيتين إضافيتين بعد انتهاء التحميل قبل الفيد اوت
wait(2)

-- Fade Out كامل
local fadeTween = TweenService:Create(background, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
fadeTween:Play()
fadeTween.Completed:Wait()
screenGui:Destroy()
