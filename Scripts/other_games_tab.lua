local OtherGamesTab = {}

-- BẢNG DANH SÁCH GAME HỖ TRỢ (Bạn tự do thêm/sửa game ở đây)
local SupportedGames = {
    {
        name = "Blox Fruits",
        scriptName = "Hoho Hub",
        url = "https://raw.githubusercontent.com/acsu123/HOHO_HUB/main/Loading_v3.lua"
    },
    {
        name = "King Legacy",
        scriptName = "Redz Hub",
        url = "https://raw.githubusercontent.com/REDZHUB/REDZHUB/main/REDZHUB.lua"
    },
    {
        name = "Blade Ball",
        scriptName = "ThunderZ Hub",
        url = "https://raw.githubusercontent.com/AhmadStudio/ThunderZ/main/Main.lua"
    },
    {
        name = "Pet Simulator 99",
        scriptName = "Zap Hub",
        url = "https://raw.githubusercontent.com/ZapHub/Loader/main/ZapHub.lua"
    }
}

local function loadScript(scriptUrl)
    if scriptUrl and scriptUrl ~= "" then
        task.spawn(function()
            loadstring(game:HttpGet(scriptUrl))()
        end)
    end
end

function OtherGamesTab.Create(parentFrame)
    local mainFrame = Instance.new("Frame", parentFrame)
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundTransparency = 1

    -- 1. TIÊU ĐỀ NỔI BẬT: GAME HỖ TRỢ
    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Size = UDim2.new(1, -10, 0, 28)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.Text = "🎮 GAME HỖ TRỢ"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1

    -- Đường gạch ngang trang trí bên dưới tiêu đề
    local line = Instance.new("Frame", mainFrame)
    line.Size = UDim2.new(1, -10, 0, 1)
    line.Position = UDim2.new(0, 0, 0, 30)
    line.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    line.BorderSizePixel = 0
    line.BackgroundTransparency = 0.5

    -- 2. KHUNG CUỘN DANH SÁCH GAME
    local scroll = Instance.new("ScrollingFrame", mainFrame)
    scroll.Size = UDim2.new(1, 0, 1, -38)
    scroll.Position = UDim2.new(0, 0, 0, 38)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)

    local layout = Instance.new("UIListLayout", scroll)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)

    -- 3. TẠO CÁC Ô VUÔNG TỪNG GAME (XANH NƯỚC BIỂN)
    for _, item in ipairs(SupportedGames) do
        -- Ô vuông viền xanh nước biển
        local card = Instance.new("Frame", scroll)
        card.Size = UDim2.new(1, -10, 0, 52)
        card.BackgroundColor3 = Color3.fromRGB(18, 26, 38)
        card.BackgroundTransparency = 0.2
        card.BorderSizePixel = 0

        local cardCorner = Instance.new("UICorner", card)
        cardCorner.CornerRadius = UDim.new(0, 8)

        local cardStroke = Instance.new("UIStroke", card)
        cardStroke.Color = Color3.fromRGB(0, 180, 255) -- Viền xanh nước
        cardStroke.Transparency = 0.3
        cardStroke.Thickness = 1.2

        -- THÔNG TIN BÊN TRÁI: Tên Game & Tên Script
        local gameTitle = Instance.new("TextLabel", card)
        gameTitle.Size = UDim2.new(0.65, 0, 0, 20)
        gameTitle.Position = UDim2.new(0, 12, 0, 8)
        gameTitle.Text = item.name
        gameTitle.Font = Enum.Font.GothamBold
        gameTitle.TextSize = 13
        gameTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        gameTitle.TextXAlignment = Enum.TextXAlignment.Left
        gameTitle.BackgroundTransparency = 1

        local scriptSubText = Instance.new("TextLabel", card)
        scriptSubText.Size = UDim2.new(0.65, 0, 0, 16)
        scriptSubText.Position = UDim2.new(0, 12, 0, 28)
        scriptSubText.Text = "Script: " .. item.scriptName
        scriptSubText.Font = Enum.Font.GothamSemibold
        scriptSubText.TextSize = 11
        scriptSubText.TextColor3 = Color3.fromRGB(0, 200, 255)
        scriptSubText.TextXAlignment = Enum.TextXAlignment.Left
        scriptSubText.BackgroundTransparency = 1

        -- Ô BẤM BÊN PHẢI: Nút Chạy Script
        local runBtn = Instance.new("TextButton", card)
        runBtn.Size = UDim2.new(0, 85, 0, 32)
        runBtn.Position = UDim2.new(1, -95, 0, 10)
        runBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 220) -- Ô vuông xanh nước
        runBtn.Text = "Execute"
        runBtn.Font = Enum.Font.GothamBold
        runBtn.TextSize = 11
        runBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        runBtn.BorderSizePixel = 0

        local btnCorner = Instance.new("UICorner", runBtn)
        btnCorner.CornerRadius = UDim.new(0, 6)

        local btnStroke = Instance.new("UIStroke", runBtn)
        btnStroke.Color = Color3.fromRGB(0, 220, 255)
        btnStroke.Thickness = 1

        runBtn.MouseButton1Click:Connect(function()
            runBtn.Text = "Loading..."
            runBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
            
            loadScript(item.url)
            
            task.wait(1.2)
            runBtn.Text = "Loaded ✓"
            runBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
            
            task.wait(1)
            runBtn.Text = "Execute"
            runBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 220)
        end)
    end

    return mainFrame
end

return OtherGamesTab
