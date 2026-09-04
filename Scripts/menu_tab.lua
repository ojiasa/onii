local MenuTab = {}

-- Danh sách tất cả các Script trong Menu
local Scripts = {
    { name = "OMG HUB", url = "https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua" },
    { name = "SPEED HUB X", url = "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua" },
    { name = "REAL HUB", url = "https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua" },
    { name = "REDZ V2 (NO KEY)", url = "https://raw.githubusercontent.com/UCT-hub/main/refs/heads/main/redz-v2" },
    { name = "PLAIN HUB (NO KEY)", url = "https://raw.githubusercontent.com/bloxfruitsnokey/Fluent/refs/heads/main/Plain/script.luau" },
    { name = "SCYTHE HUB (NO KEY)", url = "https://raw.githubusercontent.com/bloxfruitsnokey/Banana/refs/heads/main/Scythe/hub.luau" },
    { name = "AMETHYST HUB (NO KEY)", url = "https://raw.githubusercontent.com/bloxfruitsnokey/Redz/refs/heads/main/Amethyst/hub.luau" }
}

local function loadScript(s)
    if s.url and s.url ~= "" then
        loadstring(game:HttpGet(s.url, true))()
    end
end

function MenuTab.Create(parentFrame)
    local scroll = Instance.new("ScrollingFrame", parentFrame)
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    
    -- Cấu hình hiển thị rõ Thanh Cuộn Xanh Nước Biển
    scroll.ScrollBarThickness = 6
    scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255) -- Màu Xanh Nước Biển
    scroll.ScrollBarImageTransparency = 0 -- Hiện rõ 100%, không bị mờ
    scroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar -- Không bị đè lên nút
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y

    local layout = Instance.new("UIListLayout", scroll)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)

    -- Tự động tính toán độ dài Canvas để cuộn xuống đầy đủ danh sách
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 15)
    end)

    for _, s in ipairs(Scripts) do
        local btn = Instance.new("TextButton", scroll)
        btn.Size = UDim2.new(1, -12, 0, 42)
        btn.Text = "" 
        btn.BackgroundColor3 = Color3.fromRGB(20, 28, 40)
        btn.BackgroundTransparency = 0.3
        btn.BorderSizePixel = 0
        btn.ZIndex = 3

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(0, 180, 255)
        stroke.Transparency = 0.5
        stroke.Thickness = 1

        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 8)

        -- Tên Hub ở ĐẦU DÒNG (Bên trái)
        local titleLabel = Instance.new("TextLabel", btn)
        titleLabel.Size = UDim2.new(0.8, -10, 1, 0)
        titleLabel.Position = UDim2.new(0, 15, 0, 0)
        titleLabel.Text = s.name
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 13
        titleLabel.TextColor3 = Color3.fromRGB(230, 245, 255)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.BackgroundTransparency = 1
        titleLabel.ZIndex = 4

        -- Ký tự > ở CUỐI DÒNG (Bên phải)
        local arrowLabel = Instance.new("TextLabel", btn)
        arrowLabel.Size = UDim2.new(0.2, 0, 1, 0)
        arrowLabel.Position = UDim2.new(0.8, -15, 0, 0)
        arrowLabel.Text = ">"
        arrowLabel.Font = Enum.Font.GothamBold
        arrowLabel.TextSize = 14
        arrowLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
        arrowLabel.TextXAlignment = Enum.TextXAlignment.Right
        arrowLabel.BackgroundTransparency = 1
        arrowLabel.ZIndex = 4

        btn.MouseButton1Click:Connect(function()
            loadScript(s)
        end)
    end

    return scroll
end

return MenuTab
