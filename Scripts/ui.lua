local UI = {}
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- URL Repository GitHub của bạn (emzymodios/anini)
local BASE_URL = "https://raw.githubusercontent.com/emzymodios/anini/main/Scripts/"

-- 1. Load các Module Tab từ GitHub
local MainTabModule       = loadstring(game:HttpGet(BASE_URL .. "menu_tab.lua"))()       -- Main (menu_tab.lua)
local KaitunTabModule     = loadstring(game:HttpGet(BASE_URL .. "kaitun_tab.lua"))()     -- Kaitun
local HopTabModule        = loadstring(game:HttpGet(BASE_URL .. "hop_tab.lua"))()        -- Hop
local OtherGamesTabModule = loadstring(game:HttpGet(BASE_URL .. "other_games_tab.lua"))()-- Other Games
local SettingTabModule    = loadstring(game:HttpGet(BASE_URL .. "other_tab.lua"))()      -- Setting (other_tab.lua)
local StatusTabModule     = loadstring(game:HttpGet(BASE_URL .. "status_tab.lua"))()     -- Status

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

    local mainCorner = Instance.new("UICorner", mainFrame)
    mainCorner.CornerRadius = UDim.new(0, 10)

    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = Color3.fromRGB(0, 180, 255)
    mainStroke.Thickness = 1.5

    -- Sidebar chứa danh sách nút Tab (Bên trái)
    local sidebar = Instance.new("Frame", mainFrame)
    sidebar.Size = UDim2.new(0, 145, 1, -20)
    sidebar.Position = UDim2.new(0, 10, 0, 10)
    sidebar.BackgroundColor3 = Color3.fromRGB(22, 29, 40)
    sidebar.BorderSizePixel = 0

    local sidebarCorner = Instance.new("UICorner", sidebar)
    sidebarCorner.CornerRadius = UDim.new(0, 8)

    local sidebarLayout = Instance.new("UIListLayout", sidebar)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 5)

    local sidebarPadding = Instance.new("UIPadding", sidebar)
    sidebarPadding.PaddingTop = UDim.new(0, 8)
    sidebarPadding.PaddingLeft = UDim.new(0, 6)
    sidebarPadding.PaddingRight = UDim.new(0, 6)

    -- Khung Nội Dung Tab (Bên phải)
    local contentFrame = Instance.new("Frame", mainFrame)
    contentFrame.Size = UDim2.new(1, -175, 1, -20)
    contentFrame.Position = UDim2.new(0, 165, 0, 10)
    contentFrame.BackgroundTransparency = 1

    -- BẢNG CẤU HÌNH 6 TAB THEO ĐÚNG THỨ TỰ BẠN YÊU CẦU
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
        -- Khung nội dung riêng cho từng Tab
        local tabContainer = Instance.new("Frame", contentFrame)
        tabContainer.Size = UDim2.new(1, 0, 1, 0)
        tabContainer.BackgroundTransparency = 1
        tabContainer.Visible = false

        -- Nạp UI từ file module tương ứng
        if tabData.module and tabData.module.Create then
            tabData.module.Create(tabContainer)
        end

        -- Nút bấm trên Sidebar
        local tabBtn = Instance.new("TextButton", sidebar)
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

        -- Chức năng chuyển Tab khi click
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

        -- Mặc định chọn Tab đầu tiên (Main)
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
