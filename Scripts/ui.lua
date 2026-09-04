local UI = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Import Module Notification
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/emzymodios/anini/main/Scripts/notification.lua"))()

local Config = {
    IconImageId = "rbxassetid://86285862396979",
    BackgroundImageId = "http://www.roblox.com/asset/?id=116222439691339"
}

-- Đường dẫn các tab (Thêm StatusTab vào đây)
local MenuTab = loadstring(game:HttpGet("https://raw.githubusercontent.com/emzymodios/anini/main/Scripts/menu_tab.lua"))()
local HopTab = loadstring(game:HttpGet("https://raw.githubusercontent.com/emzymodios/anini/main/Scripts/hop_tab.lua"))()
local OtherTab = loadstring(game:HttpGet("https://raw.githubusercontent.com/emzymodios/anini/main/Scripts/other_tab.lua"))()
local StatusTab = loadstring(game:HttpGet("https://raw.githubusercontent.com/emzymodios/anini/main/Scripts/status_tab.lua"))()

function UI.Init()
    local guiParent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local oldGui = guiParent:FindFirstChild("NanaHubUI")
    if oldGui then
        oldGui:Destroy()
    end

    local gui = Instance.new("ScreenGui", guiParent)
    gui.Name = "NanaHubUI"
    gui.ResetOnSpawn = false

    -- 1. Nút Icon tròn mở/tắt UI
    local openBtn = Instance.new("ImageButton", gui)
    openBtn.Name = "OpenButton"
    openBtn.Size = UDim2.new(0, 50, 0, 50)
    openBtn.Position = UDim2.new(0, 20, 0.5, -25)
    openBtn.Image = Config.IconImageId
    openBtn.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
    openBtn.BackgroundTransparency = 0.2
    openBtn.BorderSizePixel = 0
    openBtn.Active = true
    openBtn.Draggable = true

    local btnCorner = Instance.new("UICorner", openBtn)
    btnCorner.CornerRadius = UDim.new(0, 25)

    local btnStroke = Instance.new("UIStroke", openBtn)
    btnStroke.Color = Color3.fromRGB(0, 255, 220)
    btnStroke.Thickness = 2.5

    -- 2. Khung giao diện chính
    local frame = Instance.new("Frame", gui)
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 580, 0, 380)
    frame.Position = UDim2.new(0.5, -290, 0.5, -190)
    frame.BackgroundColor3 = Color3.fromRGB(12, 14, 22)
    frame.BackgroundTransparency = 0.65
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Visible = false
    frame.Active = true
    frame.Draggable = true

    local frameCorner = Instance.new("UICorner", frame)
    frameCorner.CornerRadius = UDim.new(0, 12)

    local frameStroke = Instance.new("UIStroke", frame)
    frameStroke.Color = Color3.fromRGB(0, 220, 255)
    frameStroke.Thickness = 1.8

    -- 3. Ảnh nền
    local panelBackground = Instance.new("ImageLabel")
    panelBackground.Name = "PanelBackground"
    panelBackground.Size = UDim2.new(1, 0, 1, 0)
    panelBackground.Position = UDim2.new(0, 0, 0, 0)
    panelBackground.BackgroundTransparency = 1
    panelBackground.BorderSizePixel = 0
    panelBackground.ScaleType = Enum.ScaleType.Crop
    panelBackground.ZIndex = 1
    panelBackground.Image = Config.BackgroundImageId
    panelBackground.ImageTransparency = 0.35
    panelBackground.Parent = frame

    local panelBgCorner = Instance.new("UICorner", panelBackground)
    panelBgCorner.CornerRadius = UDim.new(0, 12)

    -- Tiêu đề NANA TỔNG HỢP
    local titleLabel = Instance.new("TextLabel", frame)
    titleLabel.Size = UDim2.new(1, -20, 0, 35)
    titleLabel.Position = UDim2.new(0, 15, 0, 5)
    titleLabel.Text = "ＳＨＡＤＯＷ ＧＬＡＤＥ HUB"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 15
    titleLabel.TextColor3 = Color3.fromRGB(0, 255, 230)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.ZIndex = 2

    -- Sidebar chứa Tab
    local tabsFrame = Instance.new("Frame", frame)
    tabsFrame.Position = UDim2.new(0, 12, 0, 45)
    tabsFrame.Size = UDim2.new(0, 130, 1, -57)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
    tabsFrame.BackgroundTransparency = 0.5
    tabsFrame.BorderSizePixel = 0
    tabsFrame.ZIndex = 2

    local tabsCorner = Instance.new("UICorner", tabsFrame)
    tabsCorner.CornerRadius = UDim.new(0, 8)

    local tabsStroke = Instance.new("UIStroke", tabsFrame)
    tabsStroke.Color = Color3.fromRGB(0, 180, 220)
    tabsStroke.Transparency = 0.5
    tabsStroke.Thickness = 1

    -- Container nội dung
    local contentFrame = Instance.new("Frame", frame)
    contentFrame.Name = "ContentFrame"
    contentFrame.Position = UDim2.new(0, 152, 0, 45)
    contentFrame.Size = UDim2.new(1, -164, 1, -57)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ZIndex = 2

    -- Nút Kéo Giãn Tàng Hình ở góc dưới bên phải
    local resizeBtn = Instance.new("TextButton", frame)
    resizeBtn.Name = "ResizeButton"
    resizeBtn.Size = UDim2.new(0, 25, 0, 25)
    resizeBtn.Position = UDim2.new(1, -25, 1, -25)
    resizeBtn.Text = ""
    resizeBtn.BackgroundTransparency = 1
    resizeBtn.TextTransparency = 1
    resizeBtn.ZIndex = 10

    local isResizing = false
    local startInputPos, startFrameSize

    resizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isResizing = true
            startInputPos = input.Position
            startFrameSize = frame.AbsoluteSize
            
            frame.Draggable = false

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isResizing = false
                    frame.Draggable = true
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startInputPos
            local newWidth = math.max(450, startFrameSize.X + delta.X)
            local newHeight = math.max(280, startFrameSize.Y + delta.Y)
            
            frame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)

    local currentTab = nil

    local function switchTab(tabModule)
        if currentTab and typeof(currentTab) == "Instance" then
            currentTab:Destroy()
        end
        for _, child in ipairs(contentFrame:GetChildren()) do
            if child:IsA("GuiObject") then
                child:Destroy()
            end
        end
        currentTab = tabModule.Create(contentFrame)
    end

    -- Đã thêm tab Status ở dưới Other
    local tabsData = {
        { Name = "Menu", Module = MenuTab },
        { Name = "Hop", Module = HopTab },
        { Name = "Other", Module = OtherTab },
        { Name = "Status", Module = StatusTab }
    }

    local yPos = 10
    for _, tab in ipairs(tabsData) do
        local btn = Instance.new("TextButton", tabsFrame)
        btn.Size = UDim2.new(1, -16, 0, 36)
        btn.Position = UDim2.new(0, 8, 0, yPos)
        btn.Text = tab.Name
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 13
        btn.BackgroundColor3 = Color3.fromRGB(20, 30, 45)
        btn.BackgroundTransparency = 0.3
        btn.TextColor3 = Color3.fromRGB(200, 240, 255)
        btn.BorderSizePixel = 0
        btn.ZIndex = 3

        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 6)

        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = Color3.fromRGB(0, 200, 255)
        btnStroke.Transparency = 0.6
        btnStroke.Thickness = 1

        btn.MouseButton1Click:Connect(function()
            switchTab(tab.Module)
        end)
        yPos = yPos + 46
    end

    openBtn.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible
    end)

    switchTab(MenuTab)

    Notification.Show("ＳＨＡＤＯＷ ＧＬＡＤＥ", "mày là gay đúng không!", 3, Config.IconImageId)
end

return UI
