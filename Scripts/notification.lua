local Notification = {}

local players = game:GetService("Players")
local player = players.LocalPlayer

function Notification.Show(title, text, duration, iconId)
    duration = duration or 3
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Xóa GUI Notification cũ để tránh trùng đè khi reload
    local oldNotifGui = playerGui:FindFirstChild("NanaNotificationGui")
    if oldNotifGui then
        oldNotifGui:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NanaNotificationGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    -- Khung thông báo mờ
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "Notification"
    notifFrame.Size = UDim2.new(0, 260, 0, 65)
    notifFrame.Position = UDim2.new(1, -270, 1, -85) 
    notifFrame.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
    notifFrame.BackgroundTransparency = 0.3
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = screenGui

    local nCorner = Instance.new("UICorner")
    nCorner.CornerRadius = UDim.new(0, 8)
    nCorner.Parent = notifFrame

    -- Viền sáng màu Xanh Cyan
    local nStroke = Instance.new("UIStroke")
    nStroke.Color = Color3.fromRGB(0, 220, 255)
    nStroke.Thickness = 1.5
    nStroke.Parent = notifFrame

    -- Hiển thị Icon
    if iconId and iconId ~= "" then
        local iconImg = Instance.new("ImageLabel")
        iconImg.Size = UDim2.new(0, 38, 0, 38)
        iconImg.Position = UDim2.new(0, 12, 0, 13)
        iconImg.BackgroundTransparency = 1
        iconImg.Image = iconId
        iconImg.Parent = notifFrame
        
        local imgCorner = Instance.new("UICorner")
        imgCorner.CornerRadius = UDim.new(0, 19)
        imgCorner.Parent = iconImg
    end

    local textOffsetLeft = (iconId and iconId ~= "") and 60 or 14
    local textWidthSize = (iconId and iconId ~= "") and -70 or -24

    -- Tiêu đề
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, textWidthSize, 0, 22)
    titleLbl.Position = UDim2.new(0, textOffsetLeft, 0, 8)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title or "NANA TỔNG HỢP"
    titleLbl.TextColor3 = Color3.fromRGB(0, 255, 230)
    titleLbl.TextSize = 13
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = notifFrame

    -- Nội dung chi tiết
    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, textWidthSize, 0, 28)
    descLbl.Position = UDim2.new(0, textOffsetLeft, 0, 28)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = text or "mày là gay à con!"
    descLbl.TextColor3 = Color3.fromRGB(200, 235, 255)
    descLbl.TextSize = 11
    descLbl.Font = Enum.Font.GothamMedium
    descLbl.TextWrapped = true
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.Parent = notifFrame

    -- Tự động xóa thông báo sau thời gian đặt trước
    task.delay(duration, function()
        if screenGui and screenGui.Parent then
            screenGui:Destroy()
        end
    end)
end

return Notification
