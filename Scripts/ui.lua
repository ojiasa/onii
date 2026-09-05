local UI = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Tìm Parent phù hợp cho GUI (CoreGui nếu có quyền, nếu không sẽ dùng PlayerGui)
local function getGuiParent()
    local success, _ = pcall(function()
        local test = Instance.new("Folder")
        test.Parent = CoreGui
        test:Destroy()
    end)
    if success then
        return CoreGui
    else
        return LocalPlayer:WaitForChild("PlayerGui")
    end
end

local TargetParent = getGuiParent()

-- URL Repository GitHub chuẩn
local BASE_URL = "https://raw.githubusercontent.com/ojiasa/onii/refs/heads/main/Scripts/"

-- Cấu hình hình ảnh UI chuẩn Roblox Asset ID
local Config = {
    IconImageId = "rbxassetid://86285862396979",
    BackgroundImageId = "rbxassetid://116222439691339"
}

-- Hàm hỗ trợ nạp module an toàn
local function safeLoad(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success and result then
        return result
    else
        warn("[Shadow Glade] Lỗi nạp module từ URL: " .. tostring(url))
        return nil
    end
end

-- Nạp các module từ GitHub
local MenuTabModule       = safeLoad(BASE_URL .. "menu_tab.lua")
local KaitunTabModule     = safeLoad(BASE_URL .. "kaitun_tab.lua")
local HopTabModule        = safeLoad(BASE_URL .. "hop_tab.lua")
local OtherGamesTabModule = safeLoad(BASE_URL .. "other_games_tab.lua")
local OtherTabModule      = safeLoad(BASE_URL .. "other_tab.lua")
local StatusTabModule     = safeLoad(BASE_URL .. "status_tab.lua")

-- Dummy module nếu load thất bại
local function createDummyTab(name)
    return {
        Create = function(parentFrame)
            local frame = Instance.new("Frame", parentFrame)
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundTransparency = 1
            
            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Text = "Module '" .. name .. "' chưa được tải\n\nKiểm tra kết nối mạng hoặc GitHub URL"
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(255, 100, 100)
            label.BackgroundTransparency = 1
            label.TextWrapped = true
            
            return frame
        end
    }
end

-- Fallback nếu module nil
MenuTabModule = MenuTabModule or createDummyTab("Menu")
KaitunTabModule = KaitunTabModule or createDummyTab("Kaitun")
HopTabModule = HopTabModule or createDummyTab("Hop")
OtherGamesTabModule = OtherGamesTabModule or createDummyTab("Other Games")
OtherTabModule = OtherTabModule or createDummyTab("Setting")
StatusTabModule = StatusTabModule or createDummyTab("Status")

-- Hàm hiển thị thông báo trực tiếp (Độc lập & Chống lỗi 100%)
local function showNotification(titleText, messageText, duration, iconId)
    local gui = TargetParent:FindFirstChild("NanaHubUI")
    if not gui then return end

    -- Container chứa thông báo
    local container = gui:FindFirstChild("NotifContainer")
    if not container then
        container = Instance.new("Frame", gui)
        container.Name = "NotifContainer"
        container.Size = UDim2.new(0, 280, 1, -20)
        container.Position = UDim2.new(1, -290, 0, 10)
        container.BackgroundTransparency = 1
        container.ZIndex = 9999

        local layout = Instance.new("UIListLayout", container)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.Padding = UDim.new(0, 8)
    end

    local notifFrame = Instance.new("Frame", container)
    notifFrame.Size = UDim2.new(1, 0, 0, 60)
    notifFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
    notifFrame.BackgroundTransparency = 0.15
    notifFrame.BorderSizePixel = 0
    notifFrame.ZIndex = 10000

    local corner = Instance.new("UICorner", notifFrame)
    corner.CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", notifFrame)
    stroke.Color = Color3.fromRGB(0, 255, 220)
    stroke.Thickness = 1.5

    local img = Instance.new("ImageLabel", notifFrame)
    img.Size = UDim2.new(0, 36, 0, 36)
    img.Position = UDim2.new(0, 10, 0.5, -18)
    img.BackgroundTransparency = 1
    img.Image = iconId or Config.IconImageId
    img.ZIndex = 10001

    local imgCorner = Instance.new("UICorner", img)
    imgCorner.CornerRadius = UDim.new(0, 6)

    local tLabel = Instance.new("TextLabel", notifFrame)
    tLabel.Size = UDim2.new(1, -55, 0, 20)
    tLabel.Position = UDim2.new(0, 52, 0, 8)
    tLabel.Text = titleText
    tLabel.Font = Enum.Font.GothamBold
    tLabel.TextSize = 13
    tLabel.TextColor3 = Color3.fromRGB(0, 255, 230)
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.BackgroundTransparency = 1
    tLabel.ZIndex = 10001

    local mLabel = Instance.new("TextLabel", notifFrame)
    mLabel.Size = UDim2.new(1, -55, 0, 26)
    mLabel.Position = UDim2.new(0, 52, 0, 28)
    mLabel.Text = messageText
    mLabel.Font = Enum.Font.Gotham
    mLabel.TextSize = 11
    mLabel.TextColor3 = Color3.fromRGB(220, 240, 255)
    mLabel.TextXAlignment = Enum.TextXAlignment.Left
    mLabel.TextWrapped = true
    mLabel.BackgroundTransparency = 1
    mLabel.ZIndex = 10001

    task.delay(duration or 3, function()
        if notifFrame and notifFrame.Parent then
            notifFrame:Destroy()
        end
    end)
end

function UI.Init()
    -- Xóa GUI cũ nếu đã tồn tại
    local oldGui = TargetParent:FindFirstChild("NanaHubUI")
    if oldGui then
        oldGui:Destroy()
    end

    -- Tạo ScreenGui chính
    local gui = Instance.new("ScreenGui")
    gui.Name = "NanaHubUI"
    gui.Parent = TargetParent
    gui.ResetOnSpawn = false

    -- 1. NÚT ICON TRÒN MỞ/TẮT UI
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
    openBtn.ZIndex = 100

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
    frame.ZIndex = 1

    local frameCorner = Instance.new("UICorner", frame)
    frameCorner.CornerRadius = UDim.new(0, 12)

    local frameStroke = Instance.new("UIStroke", frame)
    frameStroke.Color = Color3.fromRGB(0, 220, 255)
    frameStroke.Thickness = 1.8

    -- 3. Ảnh nền Menu
    local panelBackground = Instance.new("ImageLabel", frame)
    panelBackground.Name = "PanelBackground"
    panelBackground.Size = UDim2.new(1, 0, 1, 0)
    panelBackground.Position = UDim2.new(0, 0, 0, 0)
    panelBackground.BackgroundTransparency = 1
    panelBackground.BorderSizePixel = 0
    panelBackground.ScaleType = Enum.ScaleType.Crop
    panelBackground.ZIndex = 1
    panelBackground.Image = Config.BackgroundImageId
    panelBackground.ImageTransparency = 0.35

    local panelBgCorner = Instance.new("UICorner", panelBackground)
    panelBgCorner.CornerRadius = UDim.new(0, 12)

    -- Tiêu đề Menu
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

    -- Sidebar chứa danh sách Tab
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

    local tabsScroll = Instance.new("ScrollingFrame", tabsFrame)
    tabsScroll.Size = UDim2.new(1, 0, 1, 0)
    tabsScroll.BackgroundTransparency = 1
    tabsScroll.BorderSizePixel = 0
    tabsScroll.ScrollBarThickness = 3
    tabsScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
    tabsScroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    tabsScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    tabsScroll.CanvasSize = UDim2.new(0, 0, 1, 0)
    tabsScroll.ZIndex = 3

    local tabsLayout = Instance.new("UIListLayout", tabsScroll)
    tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabsLayout.Padding = UDim.new(0, 6)

    local tabsPadding = Instance.new("UIPadding", tabsScroll)
    tabsPadding.PaddingTop = UDim.new(0, 8)
    tabsPadding.PaddingLeft = UDim.new(0, 8)
    tabsPadding.PaddingRight = UDim.new(0, 8)
    
    tabsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        task.wait()
        local contentHeight = tabsLayout.AbsoluteContentSize.Y
        local scrollHeight = tabsScroll.AbsoluteSize.Y
        
        if contentHeight > scrollHeight and scrollHeight > 0 then
            tabsScroll.CanvasSize = UDim2.new(0, 0, 0, contentHeight + 16)
        else
            tabsScroll.CanvasSize = UDim2.new(0, 0, 1, 0)
        end
    end)

    -- Container nội dung bên phải
    local contentFrame = Instance.new("Frame", frame)
    contentFrame.Name = "ContentFrame"
    contentFrame.Position = UDim2.new(0, 152, 0, 45)
    contentFrame.Size = UDim2.new(1, -164, 1, -57)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ZIndex = 2

    -- Nút Kéo Giãn GUI
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
            pcall(function()
                currentTab:Destroy()
            end)
        end
        for _, child in ipairs(contentFrame:GetChildren()) do
            if child:IsA("GuiObject") then
                pcall(function()
                    child:Destroy()
                end)
            end
        end
        if tabModule and tabModule.Create then
            pcall(function()
                currentTab = tabModule.Create(contentFrame)
            end)
        end
    end

    -- Danh sách Tab (Status đã được chuyển lên ĐẦU TÊN)
    local tabsData = {
        { Name = "Status", Module = StatusTabModule },
        { Name = "Menu", Module = MenuTabModule },
        { Name = "Kaitun", Module = KaitunTabModule },
        { Name = "Hop", Module = HopTabModule },
        { Name = "Other Games", Module = OtherGamesTabModule },
        { Name = "Setting", Module = OtherTabModule }
    }

    local activeBtn = nil
    for idx, tab in ipairs(tabsData) do
        local btn = Instance.new("TextButton", tabsScroll)
        btn.Size = UDim2.new(1, 0, 0, 34)
        btn.Text = tab.Name
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 12
        btn.BackgroundColor3 = Color3.fromRGB(20, 30, 45)
        btn.BackgroundTransparency = 0.3
        btn.TextColor3 = Color3.fromRGB(200, 240, 255)
        btn.BorderSizePixel = 0
        btn.ZIndex = 4

        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 6)

        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = Color3.fromRGB(0, 200, 255)
        btnStroke.Transparency = 0.6
        btnStroke.Thickness = 1

        btn.MouseButton1Click:Connect(function()
            if activeBtn then
                activeBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 45)
                activeBtn.TextColor3 = Color3.fromRGB(200, 240, 255)
            end
            btn.BackgroundColor3 = Color3.fromRGB(0, 160, 220)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            activeBtn = btn

            switchTab(tab.Module)
        end)

        if idx == 1 then
            btn.BackgroundColor3 = Color3.fromRGB(0, 160, 220)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            activeBtn = btn
        end
    end

    -- Bật / Tắt Menu khi bấm nút Icon tròn
    openBtn.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible
    end)

    -- Khởi tạo mặc định mở Tab Status
    switchTab(StatusTabModule)

    -- Bật thông báo, chống gọi trùng
    if not gui:GetAttribute("NotificationShown") then
        gui:SetAttribute("NotificationShown", true)

        task.defer(function()
            if gui and gui.Parent then
                showNotification(
                    "ＳＨＡＤＯＷ ＧＬＡＤＥ",
                    "mày thích hack không ban ngay!",
                    4,
                    Config.IconImageId
                )
            end
        end)
    end
end

UI.Init()
return UI
