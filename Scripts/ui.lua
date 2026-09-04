local UI = {}
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- URL Repository GitHub của bạn (emzymodios/anini)
local BASE_URL = "https://raw.githubusercontent.com/emzymodios/anini/main/Scripts/"

-- 1. CẤU HÌNH HÌNH ẢNH (Thay ID ảnh Roblox của bạn vào đây)
local BACKGROUND_IMAGE_ID = "rbxassetid://10967390919" -- ID ảnh nền Menu
local LOGO_IMAGE_ID       = "rbxassetid://10967390919" -- ID ảnh Logo Anini Hub

-- Hàm hỗ trợ nạp module an toàn chống crash GUI khi bị lỗi mạng/file
local function safeLoad(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success and type(result) == "table" then
        return result
    else
        warn("[Anini Hub] Lỗi nạp module từ URL: " .. tostring(url))
        return { Create = function(parent) end }
    end
end

-- 2. Load các Module Tab từ GitHub
local MainTabModule       = safeLoad(BASE_URL .. "menu_tab.lua")
local KaitunTabModule     = safeLoad(BASE_URL .. "kaitun_tab.lua")
local HopTabModule        = safeLoad(BASE_URL .. "hop_tab.lua")
local OtherGamesTabModule = safeLoad(BASE_URL .. "other_games_tab.lua")
local SettingTabModule    = safeLoad(BASE_URL .. "other_tab.lua")
local StatusTabModule     = safeLoad(BASE_URL .. "status_tab.lua")

function UI.Init()
    -- Xóa GUI cũ nếu đã tồn tại
    if CoreGui:FindFirstChild("AniniHubGui") then
        CoreGui.AniniHubGui:Destroy()
    end

    -- Tạo ScreenGui chính
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AniniHubGui"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    -- Khung Menu Chính
    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 560, 0, 360)
    mainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ClipsDescendants = true

    local mainCorner = Instance.new("UICorner", mainFrame)
    mainCorner.CornerRadius = UDim.new(0, 10)

    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = Color3.fromRGB(0, 180, 255)
    mainStroke.Thickness = 1.5

    -- ========================================================
    -- 1. HÌNH NỀN MENU (BACKGROUND IMAGE)
    -- ========================================================
    local bgImage = Instance.new("ImageLabel", mainFrame)
    bgImage.Name = "BackgroundImage"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.Image = BACKGROUND_IMAGE_ID
    bgImage.ImageTransparency = 0.85 -- Độ trong suốt của ảnh nền (chỉnh từ 0 đến 1)
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.BackgroundTransparency = 1
    bgImage.ZIndex = 1

    -- Sidebar chứa danh sách nút Tab (Bên trái)
    local sidebar = Instance.new("Frame", mainFrame)
    sidebar.Size = UDim2.new(0, 145, 1, -20)
    sidebar.Position = UDim2.new(0, 10, 0, 10)
    sidebar.BackgroundColor3 = Color3.fromRGB(22, 29, 40)
    sidebar.BackgroundTransparency = 0.2
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 2

    local sidebarCorner = Instance.new("UICorner", sidebar)
    sidebarCorner.CornerRadius = UDim.new(0, 8)

    -- ========================================================
    -- 2. LOGO ANINI HUB TRÊN CÙNG SIDEBAR (LOGO IMAGE)
    -- ========================================================
    local logoImage = Instance.new("ImageLabel", sidebar)
    logoImage.Name = "LogoImage"
    logoImage.Size = UDim2.new(0, 42, 0, 42)
    logoImage.Position = UDim2.new(0.5, -21, 0, 8)
    logoImage.Image = LOGO_IMAGE_ID
    logoImage.BackgroundTransparency = 1
    logoImage.ScaleType = Enum.ScaleType.Fit
    logoImage.ZIndex = 3

    local logoCorner = Instance.new("UICorner", logoImage)
    logoCorner.CornerRadius = UDim.new(0, 8)

    -- Khung chứa danh sách nút Tab (Đặt dưới Logo)
    local navFrame = Instance.new("Frame", sidebar)
    navFrame.Size = UDim2.new(1, -12, 1, -58)
    navFrame.Position = UDim2.new(0, 6, 0, 54)
    navFrame.BackgroundTransparency = 1
    navFrame.ZIndex = 3

    local sidebarLayout = Instance.new("UIListLayout", navFrame)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 5)

    -- Khung Nội Dung Tab (Bên phải)
    local contentFrame = Instance.new("Frame", mainFrame)
    contentFrame.Size = UDim2.new(1, -175, 1, -20)
    contentFrame.Position = UDim2.new(0, 165, 0, 10)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ZIndex = 2

    -- BẢNG CẤU HÌNH 6 TAB
    local tabsConfig = {
        { name = "Main",        module = MainTabModule },
        { name = "Kaitun",      module = KaitunTabModule },
        { name = "Hop",         module = HopTabModule },
        { name = "Other Games", module = OtherGamesTabModule },
        { name = "Setting",     module = SettingTabModule },
        { name = "Status",      module = StatusTabModule }
    }

    local activeTabBtn = nil
    local activeTabFrame = nil

    -- Khởi tạo nút bấm & khung hiển thị cho từng Tab
    for index, tabData in ipairs(tabsConfig) do
        local tabContainer = Instance.new("Frame", contentFrame)
        tabContainer.Size = UDim2.new(1, 0, 1, 0)
        tabContainer.BackgroundTransparency = 1
        tabContainer.Visible = false

        if tabData.module and tabData.module.Create then
            pcall(function()
                tabData.module.Create(tabContainer)
            end)
        end

        local tabBtn = Instance.new("TextButton", navFrame)
        tabBtn.Size = UDim2.new(1, 0, 0, 32)
        tabBtn.Text = tabData.name
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.TextSize = 12
        tabBtn.BorderSizePixel = 0
        tabBtn.BackgroundColor3 = Color3.fromRGB(28, 37, 50)
        tabBtn.TextColor3 = Color3.fromRGB(160, 180, 205)

        local btnCorner = Instance.new("UICorner", tabBtn)
        btnCorner.CornerRadius = UDim.new(0, 6)

        local btnStroke = Instance.new("UIStroke", tabBtn)
        btnStroke.Color = Color3.fromRGB(45, 60, 80)
        btnStroke.Thickness = 1

        tabBtn.MouseButton1Click:Connect(function()
            if activeTabBtn then
                activeTabBtn.BackgroundColor3 = Color3.fromRGB(28, 37, 50)
                activeTabBtn.TextColor3 = Color3.fromRGB(160, 180, 205)
            end
            if activeTabFrame then
                activeTabFrame.Visible = false
            end

            tabBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 220)
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabContainer.Visible = true

            activeTabBtn = tabBtn
            activeTabFrame = tabContainer
        end)

        if index == 1 then
            tabBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 220)
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabContainer.Visible = true
            activeTabBtn = tabBtn
            activeTabFrame = tabContainer
        end
    end
end

UI.Init()
return UI
