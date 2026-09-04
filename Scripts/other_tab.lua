local OtherTab = {}

local Scripts = {
    { name = "Other Script", url = "https://example.com/other.lua" }
}

local function loadScript(s)
    if s.url and s.url ~= "" then
        loadstring(game:HttpGet(s.url))()
    end
end

function OtherTab.Create(parentFrame)
    local scroll = Instance.new("ScrollingFrame", parentFrame)
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)

    local layout = Instance.new("UIListLayout", scroll)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)

    for _, s in ipairs(Scripts) do
        local btn = Instance.new("TextButton", scroll)
        btn.Size = UDim2.new(1, -10, 0, 42)
        btn.Text = s.name .. "  ➤"
        btn.BackgroundColor3 = Color3.fromRGB(32, 28, 48)
        btn.BackgroundTransparency = 0.2
        btn.TextColor3 = Color3.fromRGB(235, 235, 245)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        btn.ZIndex = 3

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(75, 60, 110)
        stroke.Thickness = 1

        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 8)

        btn.MouseButton1Click:Connect(function()
            loadScript(s)
        end)
    end

    return scroll
end

return OtherTab
