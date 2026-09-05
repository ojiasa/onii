local KaitunTab = {}

-- BẢNG DANH SÁCH SCRIPT KAITUN (Thêm/Sửa tên & link script tại đây)
local KaitunScripts = {
    {
        name = "Kaitun Auto Max Level (Pro)",
        desc = "Tự động nhận quest, farm level & add stats từ A-Z",
        url = "https://raw.githubusercontent.com/acsu123/HOHO_HUB/main/Loading_v3.lua"
    },
    {
        name = "Kaitun Server Hop & Farm",
        desc = "Tự động đổi server tìm boss và cày nguyên liệu",
        url = "https://raw.githubusercontent.com/REDZHUB/REDZHUB/main/REDZHUB.lua"
    }
}

local function loadScript(scriptUrl)
    if scriptUrl and scriptUrl ~= "" then
        task.spawn(function()
            loadstring(game:HttpGet(scriptUrl))()
        end)
    end
end

function KaitunTab.Create(parentFrame)
    local mainFrame = Instance.new("Frame", parentFrame)
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundTransparency = 1

    -- KHUNG CUỘN DANH SÁCH SCRIPT KAITUN
    local scroll = Instance.new("ScrollingFrame", mainFrame)
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.Position = UDim2.new(0, 0, 0, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 220) -- Xanh nước

    local layout = Instance.new("UIListLayout", scroll)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)

    -- TẠO CÁC Ô SCRIPT đơn giản (Không Icon, Không Banner)
    for _, scriptInfo in ipairs(KaitunScripts) do
        local card = Instance.new("Frame", scroll)
        card.Size = UDim2.new(1, -10, 0, 58)
        card.BackgroundColor3 = Color3.fromRGB(20, 24, 35)
        card.BorderSizePixel = 0

        local cardCorner = Instance.new("UICorner", card)
        cardCorner.CornerRadius = UDim.new(0, 8)

        local cardStroke = Instance.new("UIStroke", card)
        cardStroke.Color = Color3.fromRGB(0, 255, 220) -- Viền xanh nước
        cardStroke.Thickness = 1.5

        -- Tên Script (Bên trái)
        local sName = Instance.new("TextLabel", card)
        sName.Size = UDim2.new(0.65, 0, 0, 20)
        sName.Position = UDim2.new(0, 12, 0, 10)
        sName.Text = scriptInfo.name
        sName.Font = Enum.Font.GothamBold
        sName.TextSize = 13
        sName.TextColor3 = Color3.fromRGB(255, 255, 255)
        sName.TextXAlignment = Enum.TextXAlignment.Left
        sName.BackgroundTransparency = 1

        -- Mô tả Script (Bên trái)
        local sDesc = Instance.new("TextLabel", card)
        sDesc.Size = UDim2.new(0.65, 0, 0, 18)
        sDesc.Position = UDim2.new(0, 12, 0, 30)
        sDesc.Text = scriptInfo.desc
        sDesc.Font = Enum.Font.Gotham
        sDesc.TextSize = 10
        sDesc.TextColor3 = Color3.fromRGB(140, 155, 180)
        sDesc.TextXAlignment = Enum.TextXAlignment.Left
        sDesc.BackgroundTransparency = 1

        -- Nút Chạy Script (Bên phải)
        local runBtn = Instance.new("TextButton", card)
        runBtn.Size = UDim2.new(0, 90, 0, 34)
        runBtn.Position = UDim2.new(1, -102, 0, 12)
        runBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 220) -- Nút xanh nước
        runBtn.Text = "Run Script"
        runBtn.Font = Enum.Font.GothamBold
        runBtn.TextSize = 11
        runBtn.TextColor3 = Color3.fromRGB(15, 20, 30) -- Text màu tối để dễ đọc
        runBtn.BorderSizePixel = 0

        local btnCorner = Instance.new("UICorner", runBtn)
        btnCorner.CornerRadius = UDim.new(0, 6)

        local btnStroke = Instance.new("UIStroke", runBtn)
        btnStroke.Color = Color3.fromRGB(0, 200, 200) -- Viền nút xanh nước đậm hơn
        btnStroke.Thickness = 1

        runBtn.MouseButton1Click:Connect(function()
            runBtn.Text = "Executing..."
            runBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 200) -- Xanh nước đậm khi executing
            runBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            loadScript(scriptInfo.url)
            
            task.wait(1.2)
            runBtn.Text = "Active ✓"
            runBtn.BackgroundColor3 = Color3.fromRGB(0, 220, 200) -- Xanh nước sáng hơn khi active
            runBtn.TextColor3 = Color3.fromRGB(15, 20, 30)
            
            task.wait(1.5)
            runBtn.Text = "Run Script"
            runBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 220)
            runBtn.TextColor3 = Color3.fromRGB(15, 20, 30)
        end)
    end

    return mainFrame
end

return KaitunTab
