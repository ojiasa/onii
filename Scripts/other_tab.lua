local OtherTab = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Biến Trạng Thái
local SpeedEnabled = false
local NoclipEnabled = false
local InfJumpEnabled = false
local CurrentSpeed = 50 -- Tốc độ mặc định khi bật Speed

function OtherTab.Create(parentFrame)
    local scroll = Instance.new("ScrollingFrame", parentFrame)
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)

    local layout = Instance.new("UIListLayout", scroll)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)

    -- Hàm tạo nút Toggle chuyển màu Xanh Nước
    local function createToggle(nameText, defaultState, callback)
        local btn = Instance.new("TextButton", scroll)
        btn.Size = UDim2.new(1, -10, 0, 42)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 13
        btn.BorderSizePixel = 0
        btn.ZIndex = 3

        local stroke = Instance.new("UIStroke", btn)
        stroke.Thickness = 1

        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 8)

        local isToggled = defaultState

        local function updateVisual()
            if isToggled then
                btn.Text = nameText .. " [ ON ]"
                btn.BackgroundColor3 = Color3.fromRGB(0, 140, 220)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                stroke.Color = Color3.fromRGB(0, 220, 255)
            else
                btn.Text = nameText .. " [ OFF ]"
                btn.BackgroundColor3 = Color3.fromRGB(20, 28, 40)
                btn.TextColor3 = Color3.fromRGB(180, 200, 220)
                stroke.Color = Color3.fromRGB(50, 70, 95)
            end
        end

        updateVisual()

        btn.MouseButton1Click:Connect(function()
            isToggled = not isToggled
            updateVisual()
            callback(isToggled)
        end)

        return btn
    end

    -- Hàm tạo Thanh Kéo Tốc Độ (Slider) phong cách Nana Hub
    local function createSlider(titleText, minVal, maxVal, defaultVal, callback)
        local frame = Instance.new("Frame", scroll)
        frame.Size = UDim2.new(1, -10, 0, 50)
        frame.BackgroundColor3 = Color3.fromRGB(20, 28, 40)
        frame.BackgroundTransparency = 0.2
        frame.BorderSizePixel = 0

        local corner = Instance.new("UICorner", frame)
        corner.CornerRadius = UDim.new(0, 8)

        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = Color3.fromRGB(50, 70, 95)
        stroke.Thickness = 1

        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, -20, 0, 20)
        label.Position = UDim2.new(0, 10, 0, 5)
        label.Text = titleText .. ": " .. tostring(defaultVal)
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 12
        label.TextColor3 = Color3.fromRGB(0, 220, 255)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1

        local sliderBg = Instance.new("Frame", frame)
        sliderBg.Size = UDim2.new(1, -20, 0, 8)
        sliderBg.Position = UDim2.new(0, 10, 0, 30)
        sliderBg.BackgroundColor3 = Color3.fromRGB(35, 45, 60)
        sliderBg.BorderSizePixel = 0

        local sliderBgCorner = Instance.new("UICorner", sliderBg)
        sliderBgCorner.CornerRadius = UDim.new(0, 4)

        local sliderFill = Instance.new("Frame", sliderBg)
        sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
        sliderFill.BorderSizePixel = 0

        local sliderFillCorner = Instance.new("UICorner", sliderFill)
        sliderFillCorner.CornerRadius = UDim.new(0, 4)

        local isDragging = false

        local function updateSlider(input)
            local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            local value = math.floor(minVal + (maxVal - minVal) * pos)
            label.Text = titleText .. ": " .. tostring(value)
            callback(value)
        end

        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                updateSlider(input)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
            end
        end)
    end

    -- 1. Toggle SPEED
    createToggle("Speed (Fast Walk)", SpeedEnabled, function(state)
        SpeedEnabled = state
        if not SpeedEnabled then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
            end
        end
    end)

    -- 2. Thanh Kéo Tốc Độ (Đã đổi Max = 500)
    createSlider("Speed Value", 16, 500, CurrentSpeed, function(value)
        CurrentSpeed = value
    end)

    -- 3. Toggle NOCLIP
    createToggle("Noclip (Walk Through Walls)", NoclipEnabled, function(state)
        NoclipEnabled = state
    end)

    -- 4. Toggle INFINITE JUMP
    createToggle("Infinite Jump", InfJumpEnabled, function(state)
        InfJumpEnabled = state
    end)

    -- Vòng lặp Xử Lý Speed & Noclip
    local renderConnection
    renderConnection = RunService.Stepped:Connect(function()
        if not scroll:IsDescendantOf(game) then
            renderConnection:Disconnect()
            return
        end

        local character = LocalPlayer.Character
        if character then
            -- Áp dụng tốc độ từ thanh kéo khi bật Speed
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and SpeedEnabled then
                humanoid.WalkSpeed = CurrentSpeed
            end

            -- Áp dụng Noclip
            if NoclipEnabled then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)

    -- Xử lý Infinite Jump (Phím Space / Mobile Jump)
    local jumpConnection
    jumpConnection = UserInputService.JumpRequest:Connect(function()
        if not scroll:IsDescendantOf(game) then
            jumpConnection:Disconnect()
            return
        end

        if InfJumpEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    return scroll
end

return OtherTab
