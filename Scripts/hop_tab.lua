local HopTab = {}

local Scripts = {
    { 
        name = "TEDDY HUB", 
        customRun = function()
            repeat task.wait() until game:IsLoaded() and game:GetService("Players") and game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")
            loadstring(game:HttpGet("https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/HopBoss.lua"))()
        end 
    },
    { 
        name = "NIGHT HUB (down)", 
        url = "https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/HopScript.luau" 
    }
}

local function loadScript(s)
    if s.customRun then
        task.spawn(s.customRun)
    elseif s.url and s.url ~= "" then
        loadstring(game:HttpGet(s.url, true))()
    end
end

function HopTab.Create(parentFrame)
    local scroll = Instance.new("ScrollingFrame", parentFrame)
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    
    -- Cấu hình Thanh Cuộn Xanh Nước Biển chuẩn MenuTab
    scroll.ScrollBarThickness = 6
    scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
    scroll.ScrollBarImageTransparency = 0
    scroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y

    local layout = Instance.new("UIListLayout", scroll)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)

    -- Tự động điều chỉnh CanvasSize
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

return HopTab
