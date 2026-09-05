local KaitunTab = {}

-- BẢNG DANH SÁCH SCRIPT KAITUN
local KaitunScripts = {
    {
        name = "Kaitun Blox Fruit",
        desc = "Teddy Hub",
        -- Script 1: Truyền link trực tiếp
        url = "https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/TeddyHub-kaitunBF.lua"
    },
    {
        name = "Kaitun Blox fruit",
        desc = "Trau hub",
        -- Script 2: Truyền một hàm thực thi cấu hình + loadstring
        exec = function()
            getgenv().Configs = {
                ["Quest"] = {
                    ["Evo Race V1"] = true,
                    ["Evo Race V2"] = true,
                    ["RGB Haki"] = true,
                    ["Pull Lerver"] = true,
                },
                Sword = {
                    "Dual-Headed Blade", "Smoke Admiral", "Wardens Sword", "Cutlass",
                    "Katana", "Dual Katana", "Triple Katana", "Iron Mace",
                    "Saber", "Pole (1st Form)", "Gravity Blade", "Longsword",
                    "Rengoku", "Midnight Blade", "Soul Cane", "Bisento",
                    "Yama", "Tushita", "Cursed Dual Katana",
                },
                Gun = {
                    "Skull Guitar", "Kabucha", "Venom Bow", "Musket",
                    "Flintlock", "Refined Slingshot", "Magma Blaster",
                    "Dual Flintlock", "Cannon", "Bizarre Revolver", "Bazooka",
                },
                ["Bypass TP"] = true,
                ["Auto Active Race V4"] = true,
                ["FPS Limit"] = 15,
                ["Boost FPS"] = true,
            }
            loadstring(game:HttpGet("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/kaitun.lua"))()
        end
    }
}

-- Hàm hỗ trợ chạy script linh hoạt
local function executeScript(scriptInfo)
    task.spawn(function()
        if scriptInfo.exec then
            -- Nếu có hàm custom exec thì thực thi hàm đó
            scriptInfo.exec()
        elseif scriptInfo.url and scriptInfo.url ~= "" then
            -- Nếu chỉ có URL thì tải link bình thường
            loadstring(game:HttpGet(scriptInfo.url))()
        end
    end)
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
    scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 220)

    local layout = Instance.new("UIListLayout", scroll)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)

    -- TẠO CÁC Ô SCRIPT
    for _, scriptInfo in ipairs(KaitunScripts) do
        local card = Instance.new("Frame", scroll)
        card.Size = UDim2.new(1, -10, 0, 58)
        card.BackgroundColor3 = Color3.fromRGB(20, 24, 35)
        card.BorderSizePixel = 0

        local cardCorner = Instance.new("UICorner", card)
        cardCorner.CornerRadius = UDim.new(0, 8)

        local cardStroke = Instance.new("UIStroke", card)
        cardStroke.Color = Color3.fromRGB(0, 255, 220)
        cardStroke.Thickness = 1.5

        -- Tên Script
        local sName = Instance.new("TextLabel", card)
        sName.Size = UDim2.new(0.65, 0, 0, 20)
        sName.Position = UDim2.new(0, 12, 0, 10)
        sName.Text = scriptInfo.name
        sName.Font = Enum.Font.GothamBold
        sName.TextSize = 13
        sName.TextColor3 = Color3.fromRGB(255, 255, 255)
        sName.TextXAlignment = Enum.TextXAlignment.Left
        sName.BackgroundTransparency = 1

        -- Mô tả Script
        local sDesc = Instance.new("TextLabel", card)
        sDesc.Size = UDim2.new(0.65, 0, 0, 18)
        sDesc.Position = UDim2.new(0, 12, 0, 30)
        sDesc.Text = scriptInfo.desc
        sDesc.Font = Enum.Font.Gotham
        sDesc.TextSize = 10
        sDesc.TextColor3 = Color3.fromRGB(140, 155, 180)
        sDesc.TextXAlignment = Enum.TextXAlignment.Left
        sDesc.BackgroundTransparency = 1

        -- Nút Chạy Script
        local runBtn = Instance.new("TextButton", card)
        runBtn.Size = UDim2.new(0, 90, 0, 34)
        runBtn.Position = UDim2.new(1, -102, 0, 12)
        runBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 220)
        runBtn.Text = "Run Script"
        runBtn.Font = Enum.Font.GothamBold
        runBtn.TextSize = 11
        runBtn.TextColor3 = Color3.fromRGB(15, 20, 30)
        runBtn.BorderSizePixel = 0

        local btnCorner = Instance.new("UICorner", runBtn)
        btnCorner.CornerRadius = UDim.new(0, 6)

        local btnStroke = Instance.new("UIStroke", runBtn)
        btnStroke.Color = Color3.fromRGB(0, 200, 200)
        btnStroke.Thickness = 1

        runBtn.MouseButton1Click:Connect(function()
            runBtn.Text = "Executing..."
            runBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 200)
            runBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            -- Gọi hàm xử lý chạy script linh hoạt
            executeScript(scriptInfo)
            
            task.wait(1.2)
            runBtn.Text = "Active ✓"
            runBtn.BackgroundColor3 = Color3.fromRGB(0, 220, 200)
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
