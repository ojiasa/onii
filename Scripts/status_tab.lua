local StatusTab = {}
local RunService = game:GetService("RunService")

-- ĐIỀN THÔNG TIN DISCORD CỦA BẠN VÀO ĐÂY:
local DISCORD_LINK = "https://discord.gg/shadowglade"
local DISCORD_NAME = "ＳＨＡＤＯＷ ＧＬＡＤＥ"
local DISCORD_DESC = "Join my discord!!!"
local DISCORD_ICON = "rbxassetid://100445460077624"

function StatusTab.Create(parentFrame)
    local frame = Instance.new("Frame", parentFrame)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", frame)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)

    -- Hàm tạo khung hiển thị thông tin (TIME, FPS)
    local function createCard(titleText, defaultVal)
        local card = Instance.new("Frame", frame)
        card.Size = UDim2.new(1, -10, 0, 45)
        card.BackgroundColor3 = Color3.fromRGB(20, 28, 40)
        card.BackgroundTransparency = 0.3
        card.BorderSizePixel = 0

        local stroke = Instance.new("UIStroke", card)
        stroke.Color = Color3.fromRGB(0, 180, 255)
        stroke.Transparency = 0.5
        stroke.Thickness = 1

        local corner = Instance.new("UICorner", card)
        corner.CornerRadius = UDim.new(0, 8)

        local title = Instance.new("TextLabel", card)
        title.Size = UDim2.new(0.5, -15, 1, 0)
        title.Position = UDim2.new(0, 15, 0, 0)
        title.Text = titleText
        title.Font = Enum.Font.GothamBold
        title.TextSize = 13
        title.TextColor3 = Color3.fromRGB(0, 220, 255)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.BackgroundTransparency = 1

        local valLabel = Instance.new("TextLabel", card)
        valLabel.Size = UDim2.new(0.5, -15, 1, 0)
        valLabel.Position = UDim2.new(0.5, 0, 0, 0)
        valLabel.Text = defaultVal
        valLabel.Font = Enum.Font.GothamSemibold
        valLabel.TextSize = 13
        valLabel.TextColor3 = Color3.fromRGB(230, 245, 255)
        valLabel.TextXAlignment = Enum.TextXAlignment.Right
        valLabel.BackgroundTransparency = 1

        return valLabel
    end

    -- 1. Card Thời Gian
    local timeLabel = createCard("TIME", "--:--:--")
    
    -- 2. Card FPS (FPS counter sửa lỗi)
    local fpsLabel = createCard("FPS", "-- FPS")

    -- 3. Card Discord
    local discordCard = Instance.new("Frame", frame)
    discordCard.Size = UDim2.new(1, -10, 0, 105)
    discordCard.BackgroundColor3 = Color3.fromRGB(20, 28, 40)
    discordCard.BackgroundTransparency = 0.2
    discordCard.BorderSizePixel = 0

    local cardCorner = Instance.new("UICorner", discordCard)
    cardCorner.CornerRadius = UDim.new(0, 8)

    local cardStroke = Instance.new("UIStroke", discordCard)
    cardStroke.Color = Color3.fromRGB(50, 70, 95)
    cardStroke.Transparency = 0.3
    cardStroke.Thickness = 1

    local linkText = Instance.new("TextLabel", discordCard)
    linkText.Size = UDim2.new(1, -20, 0, 20)
    linkText.Position = UDim2.new(0, 12, 0, 6)
    linkText.Text = DISCORD_LINK
    linkText.Font = Enum.Font.GothamMedium
    linkText.TextSize = 11
    linkText.TextColor3 = Color3.fromRGB(0, 180, 255)
    linkText.TextXAlignment = Enum.TextXAlignment.Left
    linkText.BackgroundTransparency = 1

    local iconFrame = Instance.new("ImageLabel", discordCard)
    iconFrame.Size = UDim2.new(0, 38, 0, 38)
    iconFrame.Position = UDim2.new(0, 12, 0, 30)
    iconFrame.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
    iconFrame.Image = DISCORD_ICON
    iconFrame.BorderSizePixel = 0
    iconFrame.ClipsDescendants = true

    local iconCorner = Instance.new("UICorner", iconFrame)
    iconCorner.CornerRadius = UDim.new(0, 6)

    local serverName = Instance.new("TextLabel", discordCard)
    serverName.Size = UDim2.new(1, -60, 0, 18)
    serverName.Position = UDim2.new(0, 58, 0, 28)
    serverName.Text = DISCORD_NAME
    serverName.Font = Enum.Font.GothamBold
    serverName.TextSize = 13
    serverName.TextColor3 = Color3.fromRGB(255, 255, 255)
    serverName.TextXAlignment = Enum.TextXAlignment.Left
    serverName.BackgroundTransparency = 1

    local serverDesc = Instance.new("TextLabel", discordCard)
    serverDesc.Size = UDim2.new(1, -60, 0, 24)
    serverDesc.Position = UDim2.new(0, 58, 0, 46)
    serverDesc.Text = DISCORD_DESC
    serverDesc.Font = Enum.Font.Gotham
    serverDesc.TextSize = 11
    serverDesc.TextColor3 = Color3.fromRGB(160, 175, 195)
    serverDesc.TextXAlignment = Enum.TextXAlignment.Left
    serverDesc.TextYAlignment = Enum.TextYAlignment.Top
    serverDesc.TextWrapped = true
    serverDesc.BackgroundTransparency = 1

    local joinBtn = Instance.new("TextButton", discordCard)
    joinBtn.Size = UDim2.new(1, -24, 0, 26)
    joinBtn.Position = UDim2.new(0, 12, 0, 73)
    joinBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
    joinBtn.Text = "Join"
    joinBtn.Font = Enum.Font.GothamBold
    joinBtn.TextSize = 13
    joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    joinBtn.BorderSizePixel = 0

    local btnCorner = Instance.new("UICorner", joinBtn)
    btnCorner.CornerRadius = UDim.new(0, 6)

    joinBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(DISCORD_LINK)
            joinBtn.Text = "Copied Link! ✓"
            joinBtn.BackgroundColor3 = Color3.fromRGB(30, 140, 60)
            task.wait(2)
            joinBtn.Text = "Join"
            joinBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
        end
    end)

    -- ========== CẬP NHẬT GIỜ (1 giây/lần) ==========
    task.spawn(function()
        while frame:IsDescendantOf(game) do
            pcall(function()
                timeLabel.Text = os.date("%H:%M:%S")
            end)
            task.wait(1)
        end
    end)

    -- ========== CẬP NHẬT FPS (THROTTLED - 0.5 giây/lần) ==========
    -- Phương pháp 1: Dùng workspace:GetRealtimeFPS() + throttle
    task.spawn(function()
        local lastUpdate = 0
        local updateInterval = 0.5 -- Update mỗi 0.5 giây thay vì mỗi frame
        
        while frame:IsDescendantOf(game) do
            local currentTime = tick()
            if currentTime - lastUpdate >= updateInterval then
                pcall(function()
                    local fps = workspace:GetRealtimeFPS()
                    fpsLabel.Text = math.floor(fps) .. " FPS"
                end)
                lastUpdate = currentTime
            end
            task.wait(0.05) -- Check mỗi 0.05 giây
        end
    end)

    -- Alternative: Nếu GetRealtimeFPS() không hoạt động, dùng phương pháp tính FPS thủ công
    -- (Uncomment dòng dưới và comment phần trên nếu FPS vẫn không hiển thị)
    --[[
    task.spawn(function()
        local frameCount = 0
        local lastTime = tick()
        
        local renderConnection
        renderConnection = RunService.RenderStepped:Connect(function()
            if not frame:IsDescendantOf(game) then
                renderConnection:Disconnect()
                return
            end
            
            frameCount = frameCount + 1
            local currentTime = tick()
            local deltaTime = currentTime - lastTime
            
            if deltaTime >= 1 then
                pcall(function()
                    local fps = math.floor(frameCount / deltaTime)
                    fpsLabel.Text = fps .. " FPS"
                end)
                frameCount = 0
                lastTime = currentTime
            end
        end)
    end)
    ]]--

    return frame
end

return StatusTab
