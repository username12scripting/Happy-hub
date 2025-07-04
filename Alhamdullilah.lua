-- UniverseHub Script

local Players = game:GetService("Players")

local TweenService = game:GetService("TweenService")

local RunService = game:GetService("RunService")

local UserInputService = game:GetService("UserInputService")

local MarketplaceService = game:GetService("MarketplaceService")

local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui", 10)

if not playerGui then

    warn("[UniverseHub] Error: PlayerGui tidak ditemukan!")

    return

end

local success, err = pcall(function()

    local screenGui = Instance.new("ScreenGui")

    screenGui.Name = "UniverseHub"

    screenGui.Enabled = true

    screenGui.ResetOnSpawn = false

    screenGui.Parent = playerGui

    local mainFrame = Instance.new("Frame")

    mainFrame.Size = UDim2.new(0, 600, 0, 400)

    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)

    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)

    mainFrame.BorderSizePixel = 2

    mainFrame.Visible = true

    mainFrame.Parent = screenGui

    local mainCorner = Instance.new("UICorner")

    mainCorner.CornerRadius = UDim.new(0, 15)

    mainCorner.Parent = mainFrame

    local mainBorder = Instance.new("UIStroke")

    mainBorder.Color = Color3.fromRGB(255, 255, 255)

    mainBorder.Thickness = 2

    mainBorder.Parent = mainFrame

    local rgbConnection

    local function startMainRGB()

        if rgbConnection then rgbConnection:Disconnect() end

        rgbConnection = RunService.RenderStepped:Connect(function()

            local hue = tick() % 1

            mainBorder.Color = Color3.fromHSV(hue, 1, 1)

        end)

    end

    startMainRGB()

    local dragBar = Instance.new("Frame")

    dragBar.Size = UDim2.new(1, 0, 0, 30)

    dragBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

    dragBar.BorderSizePixel = 0

    dragBar.Parent = mainFrame

    local dragCorner = Instance.new("UICorner")

    dragCorner.CornerRadius = UDim.new(0, 15)

    dragCorner.Parent = dragBar

    local dragTitle = Instance.new("TextLabel")

    dragTitle.Size = UDim2.new(1, -40, 1, 0)

    dragTitle.Position = UDim2.new(0, 10, 0, 0)

    dragTitle.BackgroundTransparency = 1

    dragTitle.Text = "UniverseHub"

    dragTitle.TextColor3 = Color3.fromRGB(255, 255, 255)

    dragTitle.TextScaled = true

    dragTitle.Font = Enum.Font.GothamBold

    dragTitle.TextXAlignment = Enum.TextXAlignment.Left

    dragTitle.Parent = dragBar

    local dragging, dragStart, startPos

    dragBar.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1 then

            dragging = true

            dragStart = input.Position

            startPos = mainFrame.Position

        end

    end)

    UserInputService.InputChanged:Connect(function(input)

        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then

            local delta = input.Position - dragStart

            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)

        end

    end)

    UserInputService.InputEnded:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1 then

            dragging = false

        end

    end)

    local closeButton = Instance.new("TextButton")

    closeButton.Size = UDim2.new(0, 30, 0, 30)

    closeButton.Position = UDim2.new(1, -35, 0, 5)

    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

    closeButton.Text = "X"

    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

    closeButton.Font = Enum.Font.GothamBold

    closeButton.TextScaled = true

    closeButton.Parent = dragBar

    local closeCorner = Instance.new("UICorner")

    closeCorner.CornerRadius = UDim.new(0, 8)

    closeCorner.Parent = closeButton

    local openButton = Instance.new("TextButton")

    openButton.Size = UDim2.new(0, 60, 0, 60)

    openButton.Position = UDim2.new(0, 10, 0, 10)

    openButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

    openButton.Text = "🔥"

    openButton.TextColor3 = Color3.fromRGB(255, 255, 255)

    openButton.TextScaled = true

    openButton.Font = Enum.Font.GothamBold

    openButton.Visible = true

    openButton.Parent = screenGui

    local openCorner = Instance.new("UICorner")

    openCorner.CornerRadius = UDim.new(0, 15)

    openCorner.Parent = openButton

    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local function toggleGui()

        if mainFrame.Visible then

            local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), Transparency = 1})

            tween:Play()

            tween.Completed:Wait()

            mainFrame.Visible = false

            openButton.Visible = true

            local openTween = TweenService:Create(openButton, tweenInfo, {Size = UDim2.new(0, 60, 0, 60), Transparency = 0})

            openTween:Play()

        else

            mainFrame.Visible = true

            mainFrame.Transparency = 1

            local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 600, 0, 400), Transparency = 0})

            tween:Play()

            openButton.Visible = false

            local openTween = TweenService:Create(openButton, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), Transparency = 1})

            openTween:Play()

        end

    end

    closeButton.MouseButton1Click:Connect(toggleGui)

    openButton.MouseButton1Click:Connect(toggleGui)

    local tabContainer = Instance.new("ScrollingFrame")

    tabContainer.Size = UDim2.new(0.3, 0, 1, -40)

    tabContainer.Position = UDim2.new(0, 0, 0, 40)

    tabContainer.BackgroundTransparency = 1

    tabContainer.ScrollBarThickness = 6

    tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)

    tabContainer.Parent = mainFrame

    local tabList = Instance.new("UIListLayout")

    tabList.Padding = UDim.new(0, 5)

    tabList.SortOrder = Enum.SortOrder.LayoutOrder

    tabList.Parent = tabContainer

    local contentFrame = Instance.new("ScrollingFrame")

    contentFrame.Size = UDim2.new(0.7, 0, 1, -40)

    contentFrame.Position = UDim2.new(0.3, 0, 0, 40)

    contentFrame.BackgroundTransparency = 1

    contentFrame.ScrollBarThickness = 6

    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

    contentFrame.Parent = mainFrame

    local tabs = {

        {

            Name = "Main",

            LayoutOrder = 1,

            Content = function(frame)

                local welcomeLabel = Instance.new("TextLabel")

                welcomeLabel.Size = UDim2.new(1, 0, 0, 50)

                welcomeLabel.BackgroundTransparency = 1

                welcomeLabel.Text = "Welcome To UniverseHub"

                welcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

                welcomeLabel.TextScaled = true

                welcomeLabel.Font = Enum.Font.GothamBold

                welcomeLabel.Parent = frame

                local avatarImage = Instance.new("ImageLabel")

                avatarImage.Size = UDim2.new(0, 100, 0, 100)

                avatarImage.Position = UDim2.new(0, 10, 0, 60)

                avatarImage.BackgroundTransparency = 1

                local thumbnail = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420) or "rbxassetid://0"

                avatarImage.Image = thumbnail

                avatarImage.Parent = frame

                local infoFrame = Instance.new("Frame")

                infoFrame.Size = UDim2.new(1, -120, 0, 300)

                infoFrame.Position = UDim2.new(0, 120, 0, 60)

                infoFrame.BackgroundTransparency = 1

                infoFrame.Parent = frame

                local infoList = Instance.new("UIListLayout")

                infoList.Padding = UDim.new(0, 5)

                infoList.Parent = infoFrame

                local gameName, gameCreator = "Unknown", "Unknown"

                local success, info = pcall(function()

                    return MarketplaceService:GetProductInfo(game.PlaceId)

                end)

                if success then

                    gameName = info.Name

                    gameCreator = game.CreatorType == Enum.CreatorType.User and Players:GetNameFromUserIdAsync(game.CreatorId) or tostring(game.CreatorId)

                end

                local ipAddress = "Unknown"

                local successIP, result = pcall(function()

                    return HttpService:GetAsync("https://api.ipify.org")

                end)

                if successIP then

                    ipAddress = result

                end

                local infoLabels = {

                    "Username: " .. player.DisplayName,

                    "Name: " .. player.Name,

                    "UserId: " .. player.UserId,

                    "IP: " .. ipAddress,

                    "Game Name: " .. gameName,

                    "GameId: " .. game.PlaceId,

                    "Creator: " .. gameCreator

                }

                for _, text in ipairs(infoLabels) do

                    local label = Instance.new("TextLabel")

                    label.Size = UDim2.new(1, 0, 0, 30)

                    label.BackgroundTransparency = 1

                    label.Text = text

                    label.TextColor3 = Color3.fromRGB(255, 255, 255)

                    label.TextScaled = true

                    label.Font = Enum.Font.Gotham

                    label.TextXAlignment = Enum.TextXAlignment.Left

                    label.Parent = infoFrame

                end

                frame.CanvasSize = UDim2.new(0, 0, 0, infoList.AbsoluteContentSize.Y + 60)

            end

        },

        {

            Name = "Plyr settings",

            LayoutOrder = 2,

            Content = function(frame)

                local settingsList = Instance.new("UIListLayout")

                settingsList.Padding = UDim.new(0, 10)

                settingsList.Parent = frame

                -- Speed Control

                local speedFrame = Instance.new("Frame")

                speedFrame.Size = UDim2.new(1, -20, 0, 100)

                speedFrame.Position = UDim2.new(0, 10, 0, 10)

                speedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

                speedFrame.Parent = frame

                local speedCorner = Instance.new("UICorner")

                speedCorner.CornerRadius = UDim.new(0, 8)

                speedCorner.Parent = speedFrame

                local speedLabel = Instance.new("TextLabel")

                speedLabel.Size = UDim2.new(0.4, 0, 0, 30)

                speedLabel.Position = UDim2.new(0, 10, 0, 10)

                speedLabel.BackgroundTransparency = 1

                speedLabel.Text = "Speed: 16"

                speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

                speedLabel.TextScaled = true

                speedLabel.Font = Enum.Font.Gotham

                speedLabel.TextXAlignment = Enum.TextXAlignment.Left

                speedLabel.Parent = speedFrame

                local defaultSpeed = 16

                local currentSpeed = defaultSpeed

                local speedPlusButton = Instance.new("TextButton")

                speedPlusButton.Size = UDim2.new(0.15, 0, 0, 30)

                speedPlusButton.Position = UDim2.new(0.45, 0, 0, 50)

                speedPlusButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

                speedPlusButton.Text = "+"

                speedPlusButton.TextColor3 = Color3.fromRGB(255, 255, 255)

                speedPlusButton.TextScaled = true

                speedPlusButton.Font = Enum.Font.GothamBold

                speedPlusButton.Parent = speedFrame

                local speedPlusCorner = Instance.new("UICorner")

                speedPlusCorner.CornerRadius = UDim.new(0, 8)

                speedPlusCorner.Parent = speedPlusButton

                local speedMinusButton = Instance.new("TextButton")

                speedMinusButton.Size = UDim2.new(0.15, 0, 0, 30)

                speedMinusButton.Position = UDim2.new(0.65, 0, 0, 50)

                speedMinusButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

                speedMinusButton.Text = "-"

                speedMinusButton.TextColor3 = Color3.fromRGB(255, 255, 255)

                speedMinusButton.TextScaled = true

                speedMinusButton.Font = Enum.Font.GothamBold

                speedMinusButton.Parent = speedFrame

                local speedMinusCorner = Instance.new("UICorner")

                speedMinusCorner.CornerRadius = UDim.new(0, 8)

                speedMinusCorner.Parent = speedMinusButton

                local speedResetButton = Instance.new("TextButton")

                speedResetButton.Size = UDim2.new(0.15, 0, 0, 30)

                speedResetButton.Position = UDim2.new(0.85, 0, 0, 50)

                speedResetButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)

                speedResetButton.Text = "Reset"

                speedResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)

                speedResetButton.TextScaled = true

                speedResetButton.Font = Enum.Font.GothamBold

                speedResetButton.Parent = speedFrame

                local speedResetCorner = Instance.new("UICorner")

                speedResetCorner.CornerRadius = UDim.new(0, 8)

                speedResetCorner.Parent = speedResetButton

                -- JumpPower Control

                local jumpFrame = Instance.new("Frame")

                jumpFrame.Size = UDim2.new(1, -20, 0, 100)

                jumpFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

                jumpFrame.Parent = frame

                local jumpCorner = Instance.new("UICorner")

                jumpCorner.CornerRadius = UDim.new(0, 8)

                jumpCorner.Parent = jumpFrame

                local jumpLabel = Instance.new("TextLabel")

                jumpLabel.Size = UDim2.new(0.4, 0, 0, 30)

                jumpLabel.Position = UDim2.new(0, 10, 0, 10)

                jumpLabel.BackgroundTransparency = 1

                jumpLabel.Text = "JumpPower: 50"

                jumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

                jumpLabel.TextScaled = true

                jumpLabel.Font = Enum.Font.Gotham

                jumpLabel.TextXAlignment = Enum.TextXAlignment.Left

                jumpLabel.Parent = jumpFrame

                local defaultJump = 50

                local currentJump = defaultJump

                local jumpPlusButton = Instance.new("TextButton")

                jumpPlusButton.Size = UDim2.new(0.15, 0, 0, 30)

                jumpPlusButton.Position = UDim2.new(0.45, 0, 0, 50)

                jumpPlusButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

                jumpPlusButton.Text = "+"

                jumpPlusButton.TextColor3 = Color3.fromRGB(255, 255, 255)

                jumpPlusButton.TextScaled = true

                jumpPlusButton.Font = Enum.Font.GothamBold

                jumpPlusButton.Parent = jumpFrame

                local jumpPlusCorner = Instance.new("UICorner")

                jumpPlusCorner.CornerRadius = UDim.new(0, 8)

                jumpPlusCorner.Parent = jumpPlusButton

                local jumpMinusButton = Instance.new("TextButton")

                jumpMinusButton.Size = UDim2.new(0.15, 0, 0, 30)

                jumpMinusButton.Position = UDim2.new(0.65, 0, 0, 50)

                jumpMinusButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

                jumpMinusButton.Text = "-"

                jumpMinusButton.TextColor3 = Color3.fromRGB(255, 255, 255)

                jumpMinusButton.TextScaled = true

                jumpMinusButton.Font = Enum.Font.GothamBold

                jumpMinusButton.Parent = jumpFrame

                local jumpMinusCorner = Instance.new("UICorner")

                jumpMinusCorner.CornerRadius = UDim.new(0, 8)

                jumpMinusCorner.Parent = jumpMinusButton

                local jumpResetButton = Instance.new("TextButton")

                jumpResetButton.Size = UDim2.new(0.15, 0, 0, 30)

                jumpResetButton.Position = UDim2.new(0.85, 0, 0, 50)

                jumpResetButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)

                jumpResetButton.Text = "Reset"

                jumpResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)

                jumpResetButton.TextScaled = true

                jumpResetButton.Font = Enum.Font.GothamBold

                jumpResetButton.Parent = jumpFrame

                local jumpResetCorner = Instance.new("UICorner")

                jumpResetCorner.CornerRadius = UDim.new(0, 8)

                jumpResetCorner.Parent = jumpResetButton

                -- Gravity Control

                local gravityFrame = Instance.new("Frame")

                gravityFrame.Size = UDim2.new(1, -20, 0, 100)

                gravityFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

                gravityFrame.Parent = frame

                local gravityCorner = Instance.new("UICorner")

                gravityCorner.CornerRadius = UDim.new(0, 8)

                gravityCorner.Parent = gravityFrame

                local gravityLabel = Instance.new("TextLabel")

                gravityLabel.Size = UDim2.new(0.4, 0, 0, 30)

                gravityLabel.Position = UDim2.new(0, 10, 0, 10)

                gravityLabel.BackgroundTransparency = 1

                gravityLabel.Text = "Gravity: 196.2"

                gravityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

                gravityLabel.TextScaled = true

                gravityLabel.Font = Enum.Font.Gotham

                gravityLabel.TextXAlignment = Enum.TextXAlignment.Left

                gravityLabel.Parent = gravityFrame

                local defaultGravity = 196.2

                local currentGravity = defaultGravity

                local gravityPlusButton = Instance.new("TextButton")

                gravityPlusButton.Size = UDim2.new(0.15, 0, 0, 30)

                gravityPlusButton.Position = UDim2.new(0.45, 0, 0, 50)

                gravityPlusButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

                gravityPlusButton.Text = "+"

                gravityPlusButton.TextColor3 = Color3.fromRGB(255, 255, 255)

                gravityPlusButton.TextScaled = true

                gravityPlusButton.Font = Enum.Font.GothamBold

                gravityPlusButton.Parent = gravityFrame

                local gravityPlusCorner = Instance.new("UICorner")

                gravityPlusCorner.CornerRadius = UDim.new(0, 8)

                gravityPlusCorner.Parent = gravityPlusButton

                local gravityMinusButton = Instance.new("TextButton")

                gravityMinusButton.Size = UDim2.new(0.15, 0, 0, 30)

                gravityMinusButton.Position = UDim2.new(0.65, 0, 0, 50)

                gravityMinusButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

                gravityMinusButton.Text = "-"

                gravityMinusButton.TextColor3 = Color3.fromRGB(255, 255, 255)

                gravityMinusButton.TextScaled = true

                gravityMinusButton.Font = Enum.Font.GothamBold

                gravityMinusButton.Parent = gravityFrame

                local gravityMinusCorner = Instance.new("UICorner")

                gravityMinusCorner.CornerRadius = UDim.new(0, 8)

                gravityMinusCorner.Parent = gravityMinusButton

                local gravityResetButton = Instance.new("TextButton")

                gravityResetButton.Size = UDim2.new(0.15, 0, 0, 30)

                gravityResetButton.Position = UDim2.new(0.85, 0, 0, 50)

                gravityResetButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)

                gravityResetButton.Text = "Reset"

                gravityResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)

                gravityResetButton.TextScaled = true

                gravityResetButton.Font = Enum.Font.GothamBold

                gravityResetButton.Parent = gravityFrame

                local gravityResetCorner = Instance.new("UICorner")

                gravityResetCorner.CornerRadius = UDim.new(0, 8)

                gravityResetCorner.Parent = gravityResetButton

                -- Button Functionality

                speedPlusButton.MouseButton1Click:Connect(function()

                    currentSpeed = currentSpeed + 1

                    speedLabel.Text = "Speed: " .. currentSpeed

                    if player.Character and player.Character:FindFirstChild("Humanoid") then

                        player.Character.Humanoid.WalkSpeed = currentSpeed

                    end

                end)

                speedMinusButton.MouseButton1Click:Connect(function()

                    currentSpeed = math.max(1, currentSpeed - 1)

                    speedLabel.Text = "Speed: " .. currentSpeed

                    if player.Character and player.Character:FindFirstChild("Humanoid") then

                        player.Character.Humanoid.WalkSpeed = currentSpeed

                    end

                end)

                speedResetButton.MouseButton1Click:Connect(function()

                    currentSpeed = defaultSpeed

                    speedLabel.Text = "Speed: " .. currentSpeed

                    if player.Character and player.Character:FindFirstChild("Humanoid") then

                        player.Character.Humanoid.WalkSpeed = currentSpeed

                    end

                end)

                jumpPlusButton.MouseButton1Click:Connect(function()

                    currentJump = currentJump + 1

                    jumpLabel.Text = "JumpPower: " .. currentJump

                    if player.Character and player.Character:FindFirstChild("Humanoid") then

                        player.Character.Humanoid.JumpPower = currentJump

                    end

                end)

                jumpMinusButton.MouseButton1Click:Connect(function()

                    currentJump = math.max(0, currentJump - 1)

                    jumpLabel.Text = "JumpPower: " .. currentJump

                    if player.Character and player.Character:FindFirstChild("Humanoid") then

                        player.Character.Humanoid.JumpPower = currentJump

                    end

                end)

                jumpResetButton.MouseButton1Click:Connect(function()

                    currentJump = defaultJump

                    jumpLabel.Text = "JumpPower: " .. currentJump

                    if player.Character and player.Character:FindFirstChild("Humanoid") then

                        player.Character.Humanoid.JumpPower = currentJump

                    end

                end)

                gravityPlusButton.MouseButton1Click:Connect(function()

                    currentGravity = currentGravity + 1

                    gravityLabel.Text = "Gravity: " .. string.format("%.1f", currentGravity)

                    game.Workspace.Gravity = currentGravity

                end)

                gravityMinusButton.MouseButton1Click:Connect(function()

                    currentGravity = math.max(0, currentGravity - 1)

                    gravityLabel.Text = "Gravity: " .. string.format("%.1f", currentGravity)

                    game.Workspace.Gravity = currentGravity

                end)

                gravityResetButton.MouseButton1Click:Connect(function()

                    currentGravity = defaultGravity

                    gravityLabel.Text = "Gravity: " .. string.format("%.1f", currentGravity)

                    game.Workspace.Gravity = currentGravity

                end)

                -- Update canvas size for scrolling

                frame.CanvasSize = UDim2.new(0, 0, 0, settingsList.AbsoluteContentSize.Y + 20)

            end

        },

        {

            Name = "ScriptHub",

            LayoutOrder = 3,

            Content = function(frame)

                local scriptList = Instance.new("Frame")

                scriptList.Size = UDim2.new(1, -10, 0, 150) -- Further reduced height

                scriptList.Position = UDim2.new(0, 5, 0, 5)

                scriptList.BackgroundTransparency = 1

                scriptList.Parent = frame

                local listLayout = Instance.new("UIListLayout")

                listLayout.Padding = UDim.new(0, 3) -- Tighter padding

                listLayout.SortOrder = Enum.SortOrder.LayoutOrder

                listLayout.Parent = scriptList

                local function createScriptButton(name, url)

                    local scriptFrame = Instance.new("Frame")

                    scriptFrame.Size = UDim2.new(1, -10, 0, 50) -- Smaller frame

                    scriptFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

                    scriptFrame.Parent = scriptList

                    local scriptCorner = Instance.new("UICorner")

                    scriptCorner.CornerRadius = UDim.new(0, 8)

                    scriptCorner.Parent = scriptFrame

                    local scriptLabel = Instance.new("TextLabel")

                    scriptLabel.Size = UDim2.new(1, -10, 0, 20)

                    scriptLabel.Position = UDim2.new(0, 5, 0, 5)

                    scriptLabel.BackgroundTransparency = 1

                    scriptLabel.Text = name

                    scriptLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

                    scriptLabel.TextScaled = true

                    scriptLabel.Font = Enum.Font.Gotham

                    scriptLabel.TextXAlignment = Enum.TextXAlignment.Left

                    scriptLabel.Parent = scriptFrame

                    local executeButton = Instance.new("TextButton")

                    executeButton.Size = UDim2.new(0.4, -10, 0, 20)

                    executeButton.Position = UDim2.new(0, 5, 0, 25)

                    executeButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

                    executeButton.Text = "Execute"

                    executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

                    executeButton.TextScaled = true

                    executeButton.Font = Enum.Font.GothamBold

                    executeButton.Parent = scriptFrame

                    local buttonCorner = Instance.new("UICorner")

                    buttonCorner.CornerRadius = UDim.new(0, 8)

                    buttonCorner.Parent = executeButton

                    executeButton.MouseButton1Click:Connect(function()

                        local success, scriptErr = pcall(function()

                            loadstring(game:HttpGet(url))()

                        end)

                        if not success then

                            warn("[UniverseHub] Error executing " .. name .. ": " .. tostring(scriptErr))

                        else

                            print("[UniverseHub] " .. name .. " executed successfully")

                        end

                    end)

                end

                -- Scripts for ScriptHub (excluding Gun/Sword/tools)

                local scripts = {

                    {"SoulX Fe", "https://pastefy.app/xOJJQ4SV/raw"},

                    {"Krystal Dance", "https://raw.githubusercontent.com/nicolasbarbosa323/crytasl/refs/heads/main/Krystal%20Dance%20V2.lua.txt"},

                    {"Neko", "https://raw.githubusercontent.com/GooberDoesStuff/RandomClientRep/refs/heads/main/Neko.lua"},

                    {"Bomb Vest V1", "https://rawscripts.net/raw/Universal-Script-Bomb-Vest-v1-35089"},

                    {"Good cop bad cop", "https://raw.githubusercontent.com/nicolasbarbosa323/good-cop-bad-coop/refs/heads/main/KwuminKa.txt"},

                    {"Ban Hammer", "https://raw.githubusercontent.com/nicolasbarbosa323/ban-hammer/refs/heads/main/ban"},

                    {"Nebula Star Glitcher", "https://pastebin.com/raw/j09BnGB3"},

                    {"Spectrum Star Glitcher", "https://raw.githubusercontent.com/nicolasbarbosa323/SCPECTRUMGLITCHER/refs/heads/main/SpectrumG%20(1).txt"},

                    {"Grab Knife V4", "https://rawscripts.net/raw/Client-Replication-Grab-Knife-V4-27394"},

                    {"Grab Knife V3", "https://rawscripts.net/raw/Prison-Life-Grab-V3-18932"},

                    {"Ranenger Claws", "https://rawscripts.net/raw/Universal-Script-ravenger-claws-9234"},

                    {"Ronald McDonald", "https://raw.githubusercontent.com/HappyCow91/RobloxScripts/refs/heads/main/ClientSided/clown.lua"},

                    {"Pipe Bomb Launcher", "https://raw.githubusercontent.com/gitezgitgit/rare-scripts/refs/heads/main/PipeBomb%20Launcher.txt"},

                    {"Plasma Cutters", "https://rawscripts.net/raw/Prison-Life-Plasma-Cutters-18936"},

                    {"Bomb Vest V2", "https://rawscripts.net/raw/Universal-Script-Bomb-Vest-V666-Xymatekidd-37476"},

                    {"Galaxy Titan", "https://raw.githubusercontent.com/gitezgitgit/rare-scripts/refs/heads/main/Galaxy%20Titan.txt"},

                    {"Steve", "https://rawscripts.net/raw/Universal-Script-Minecraft-Steve-38043"},

                    {"Master Hand", "https://raw.githubusercontent.com/gitezgitgit/rare-scripts/refs/heads/main/MasterHand.txt"},

                    {"Xester", "https://rawscripts.net/raw/Prison-Life-Xester-18937"},

                    {"Vereus", "https://rawscripts.net/raw/Universal-Script-Roblox-VEREUS-monster-script-3746"},

                    {"Goner", "https://raw.githubusercontent.com/nicolasbarbosa323/crytasl/refs/heads/main/goner.lua.txt"},

                    {"Server Admin", "https://raw.githubusercontent.com/nicolasbarbosa323/crytasl/refs/heads/main/serveradmin.lua"},

                    {"C00lgui", "https://rawscripts.net/raw/Universal-Script-c00lgui-38055"},

                    {"T0PK3K V3", "https://rawscripts.net/raw/Natural-Disaster-Survival-idk-script-t0pk3k-29594"},

                    {"T0PK3K V4", "https://rawscripts.net/raw/Universal-Script-t0pk3k-remake-37536"},

                    {"Jumpscare GUI", "https://rawscripts.net/raw/Client-Replication-Jumpscare-gui-38259"},

                    {"Sheldoni", "https://rawscripts.net/raw/Universal-Script-Sheldoni-gui-29377"},

                    {"Dick GUI", "https://raw.githubusercontent.com/Avtor1zaTion/NO-FE-SNAKE/refs/heads/main/NO-FE-Snake.txt"},

                    {"Pee (R6)", "https://raw.githubusercontent.com/gitezgitgit/Pee/refs/heads/main/PeeScript.lua"},

                    {"R15 To R6", "https://rawscripts.net/raw/Universal-Script-R15-to-r6-script-working-all-game-26416"},

                    {"Keyboard", "https://rawscripts.net/raw/Universal-Script-Mobile-keyboard-6975"}

                }

                for _, script in ipairs(scripts) do

                    createScriptButton(script[1], script[2])

                end

                -- Update canvas size dynamically

                local function updateScriptCanvas()

                    frame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)

                end

                updateScriptCanvas()

                listLayout.Changed:Connect(updateScriptCanvas)

            end

        },

        {

            Name = "Executor",

            LayoutOrder = 4,

            Content = function(frame)

                local title = Instance.new("TextLabel")

                title.Size = UDim2.new(1, 0, 0, 50)

                title.BackgroundTransparency = 1

                title.Text = "Universe Executor"

                title.TextColor3 = Color3.fromRGB(255, 255, 255)

                title.TextScaled = true

                title.Font = Enum.Font.GothamBold

                title.Parent = frame

                local textBox = Instance.new("TextBox")

                textBox.Size = UDim2.new(1, -20, 0, 200)

                textBox.Position = UDim2.new(0, 10, 0, 60)

                textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

                textBox.TextColor3 = Color3.fromRGB(255, 255, 255)

                textBox.Text = ""

                textBox.MultiLine = true

                textBox.Font = Enum.Font.Gotham

                textBox.Parent = frame

                local textBoxCorner = Instance.new("UICorner")

                textBoxCorner.CornerRadius = UDim.new(0, 8)

                textBoxCorner.Parent = textBox

                local executeButton = Instance.new("TextButton")

                executeButton.Size = UDim2.new(0.45, 0, 0, 40)

                executeButton.Position = UDim2.new(0, 10, 0, 270)

                executeButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

                executeButton.Text = "Execute"

                executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

                executeButton.Font = Enum.Font.GothamBold

                executeButton.TextScaled = true

                executeButton.Parent = frame

                local executeCorner = Instance.new("UICorner")

                executeCorner.CornerRadius = UDim.new(0, 8)

                executeCorner.Parent = executeButton

                local clearButton = Instance.new("TextButton")

                clearButton.Size = UDim2.new(0.45, 0, 0, 40)

                clearButton.Position = UDim2.new(0.55, 0, 0, 270)

                clearButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

                clearButton.Text = "Clear"

                clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)

                clearButton.Font = Enum.Font.GothamBold

                clearButton.TextScaled = true

                clearButton.Parent = frame

                local clearCorner = Instance.new("UICorner")

                clearCorner.CornerRadius = UDim.new(0, 8)

                clearCorner.Parent = clearButton

                local resetButton = Instance.new("TextButton")

                resetButton.Size = UDim2.new(0.45, 0, 0, 40)

                resetButton.Position = UDim2.new(0, 10, 0, 320)

                resetButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)

                resetButton.Text = "Reset Player"

                resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)

                resetButton.TextScaled = true

                resetButton.Font = Enum.Font.GothamBold

                resetButton.Parent = frame

                local resetCorner = Instance.new("UICorner")

                resetCorner.CornerRadius = UDim.new(0, 8)

                resetCorner.Parent = resetButton

                executeButton.MouseButton1Click:Connect(function()

                    local success, err = pcall(function()

                        loadstring(textBox.Text)()

                    end)

                    if not success then

                        warn("[UniverseHub] Execution Error: " .. tostring(err))

                    end

                end)

                clearButton.MouseButton1Click:Connect(function()

                    textBox.Text = ""

                end)

                resetButton.MouseButton1Click:Connect(function()

                    if player.Character then

                        player.Character:BreakJoints()

                    end

                end)

            end

        },

        {

            Name = "Gear",

            LayoutOrder = 5,

            Content = function(frame)

                local gearList = Instance.new("Frame")

                gearList.Size = UDim2.new(1, -10, 0, 150) -- Same height as ScriptHub

                gearList.Position = UDim2.new(0, 5, 0, 5)

                gearList.BackgroundTransparency = 1

                gearList.Parent = frame

                local gearLayout = Instance.new("UIListLayout")

                gearLayout.Padding = UDim.new(0, 3)

                gearLayout.SortOrder = Enum.SortOrder.LayoutOrder

                gearLayout.Parent = gearList

                local function createGearButton(name, url)

                    local gearFrame = Instance.new("Frame")

                    gearFrame.Size = UDim2.new(1, -10, 0, 50)

                    gearFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

                    gearFrame.Parent = gearList

                    local gearCorner = Instance.new("UICorner")

                    gearCorner.CornerRadius = UDim.new(0, 8)

                    gearCorner.Parent = gearFrame

                    local gearLabel = Instance.new("TextLabel")

                    gearLabel.Size = UDim2.new(1, -10, 0, 20)

                    gearLabel.Position = UDim2.new(0, 5, 0, 5)

                    gearLabel.BackgroundTransparency = 1

                    gearLabel.Text = name

                    gearLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

                    gearLabel.TextScaled = true

                    gearLabel.Font = Enum.Font.Gotham

                    gearLabel.TextXAlignment = Enum.TextXAlignment.Left

                    gearLabel.Parent = gearFrame

                    local executeButton = Instance.new("TextButton")

                    executeButton.Size = UDim2.new(0.4, -10, 0, 20)

                    executeButton.Position = UDim2.new(0, 5, 0, 25)

                    executeButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

                    executeButton.Text = "Execute"

                    executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

                    executeButton.TextScaled = true

                    executeButton.Font = Enum.Font.GothamBold

                    executeButton.Parent = gearFrame

                    local buttonCorner = Instance.new("UICorner")

                    buttonCorner.CornerRadius = UDim.new(0, 8)

                    buttonCorner.Parent = executeButton

                    executeButton.MouseButton1Click:Connect(function()

                        local success, scriptErr = pcall(function()

                            loadstring(game:HttpGet(url))()

                        end)

                        if not success then

                            warn("[UniverseHub] Error executing " .. name .. ": " .. tostring(scriptErr))

                        else

                            print("[UniverseHub] " .. name .. " executed successfully")

                        end

                    end)

                end

                -- Scripts for Gear (Gun/Sword/tools)

                local gearScripts = {

                    {"MLG Gun", "https://rawscripts.net/raw/Client-Replication-the-ss-loadstring-script-27393"},

                    {"Dual Pink Guns", "https://rawscripts.net/raw/Universal-Script-dual-pink-guns-9235"},

                    {"Kitchen Gun", "https://raw.githubusercontent.com/nicolasbarbosa323/rare/refs/heads/main/kitcher%20gun.lua"},

                    {"Suicide Gun", "https://rawscripts.net/raw/Universal-Script-Suicide-GUN-Script-Xymatekidd-37872"},

                    {"Laser Gun", "https://pastebin.com/raw/DxCuMin9"},

                    {"AK74", "https://rawscripts.net/raw/Universal-Script-AK74-5621"},

                    {"Dick Gun", "https://rawscripts.net/raw/Client-Replication-Fe-bypass-gun-38354"}

                }

                for _, script in ipairs(gearScripts) do

                    createGearButton(script[1], script[2])

                end

                -- Update canvas size dynamically

                local function updateGearCanvas()

                    frame.CanvasSize = UDim2.new(0, 0, 0, gearLayout.AbsoluteContentSize.Y + 20)

                end

                updateGearCanvas()

                gearLayout.Changed:Connect(updateGearCanvas)

            end

        },

        {

            Name = "Credit",

            LayoutOrder = 6,

            Content = function(frame)

                local creditsFrame = Instance.new("Frame")

                creditsFrame.Size = UDim2.new(1, 0, 1, 0)

                creditsFrame.BackgroundTransparency = 1

                creditsFrame.Parent = frame

                local creditList = Instance.new("UIListLayout")

                creditList.Padding = UDim.new(0, 10)

                creditList.Parent = creditsFrame

                local credits = {

                    "Owner: Violent",

                    "Developer: SoulX",

                    "Co Owner: ???",

                    "Staff: ???",

                    "Staff: ????",

                    "Staff: ???",

                    "Infector: SoulX"

                }

                for _, text in ipairs(credits) do

                    local label = Instance.new("TextLabel")

                    label.Size = UDim2.new(1, 0, 0, 30)

                    label.BackgroundTransparency = 1

                    label.Text = text

                    label.TextColor3 = Color3.fromRGB(255, 255, 255)

                    label.TextScaled = true

                    label.Font = Enum.Font.Gotham

                    label.TextXAlignment = Enum.TextXAlignment.Left

                    label.Parent = creditsFrame

                end

                frame.CanvasSize = UDim2.new(0, 0, 0, creditList.AbsoluteContentSize.Y + 20)

            end

        },

        {

            Name = "Settings",

            LayoutOrder = 7,

            Content = function(frame)

                local settingsFrame = Instance.new("Frame")

                settingsFrame.Size = UDim2.new(1, 0, 1, 0)

                settingsFrame.BackgroundTransparency = 1

                settingsFrame.Parent = frame

                local settingsList = Instance.new("UIListLayout")

                settingsList.Padding = UDim.new(0, 10)

                settingsList.Parent = settingsFrame

                local title = Instance.new("TextLabel")

                title.Size = UDim2.new(1, 0, 0, 30)

                title.BackgroundTransparency = 1

                title.Text = "Change Border Color"

                title.TextColor3 = Color3.fromRGB(255, 255, 255)

                title.TextScaled = true

                title.Font = Enum.Font.GothamBold

                title.Parent = settingsFrame

                local inputBox = Instance.new("TextBox")

                inputBox.Size = UDim2.new(1, -20, 0, 40)

                inputBox.Position = UDim2.new(0, 10, 0, 40)

                inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

                inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)

                inputBox.Text = ""

                inputBox.Font = Enum.Font.Gotham

                inputBox.Parent = settingsFrame

                local inputCorner = Instance.new("UICorner")

                inputCorner.CornerRadius = UDim.new(0, 8)

                inputCorner.Parent = inputBox

                local applyButton = Instance.new("TextButton")

                applyButton.Size = UDim2.new(1, -20, 0, 40)

                applyButton.Position = UDim2.new(0, 10, 0, 90)

                applyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

                applyButton.Text = "Apply"

                applyButton.TextColor3 = Color3.fromRGB(255, 255, 255)

                applyButton.Font = Enum.Font.GothamBold

                applyButton.TextScaled = true

                applyButton.Parent = settingsFrame

                local applyCorner = Instance.new("UICorner")

                applyCorner.CornerRadius = UDim.new(0, 8)

                applyCorner.Parent = applyButton

                local rgbConnection

                local function stopRGB()

                    if rgbConnection then

                        rgbConnection:Disconnect()

                        rgbConnection = nil

                    end

                end

                local function startRGB()

                    stopRGB()

                    rgbConnection = RunService.RenderStepped:Connect(function()

                        local hue = tick() % 1

                        mainBorder.Color = Color3.fromHSV(hue, 1, 1)

                    end)

                end

                applyButton.MouseButton1Click:Connect(function()

                    local input = inputBox.Text:lower()

                    stopRGB()

                    local colors = {

                        blue = Color3.fromRGB(0, 0, 255),

                        red = Color3.fromRGB(255, 0, 0),

                        purple = Color3.fromRGB(128, 0, 128),

                        black = Color3.fromRGB(0, 0, 0),

                        white = Color3.fromRGB(255, 255, 255)

                    }

                    if input == "rgb" then

                        startRGB()

                    elseif colors[input] then

                        mainBorder.Color = colors[input]

                    else

                        mainBorder.Color = Color3.fromRGB(255, 255, 255)

                    end

                end)

                frame.CanvasSize = UDim2.new(0, 0, 0, settingsList.AbsoluteContentSize.Y + 20)

            end

        }

    }

    local tabFrames = {}

    for _, tab in ipairs(tabs) do

        local tabButton = Instance.new("TextButton")

        tabButton.Size = UDim2.new(1, -10, 0, 40)

        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

        tabButton.Text = tab.Name

        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)

        tabButton.TextScaled = true

        tabButton.Font = Enum.Font.GothamBold

        tabButton.LayoutOrder = tab.LayoutOrder

        tabButton.Parent = tabContainer

        local buttonCorner = Instance.new("UICorner")

        buttonCorner.CornerRadius = UDim.new(0, 8)

        buttonCorner.Parent = tabButton

        local buttonBorder = Instance.new("UIStroke")

        buttonBorder.Color = Color3.fromRGB(255, 255, 255)

        buttonBorder.Thickness = 1

        buttonBorder.Parent = tabButton

        local tabFrame = Instance.new("ScrollingFrame")

        tabFrame.Size = UDim2.new(1, 0, 1, 0)

        tabFrame.BackgroundTransparency = 1

        tabFrame.ScrollBarThickness = 6

        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

        tabFrame.Visible = tab.Name == "Main"

        tabFrame.Parent = contentFrame

        local tabFrameCorner = Instance.new("UICorner")

        tabFrameCorner.CornerRadius = UDim.new(0, 15)

        tabFrameCorner.Parent = tabFrame

        tabFrames[tab.Name] = tabFrame

        if tab.Content then

            local success, contentErr = pcall(tab.Content, tabFrame)

            if not success then

                warn("[UniverseHub] Error saat membuat konten tab " .. tab.Name .. ": " .. tostring(contentErr))

            end

        end

        tabButton.MouseButton1Click:Connect(function()

            for _, frame in pairs(tabFrames) do

                frame.Visible = false

            end

            tabFrames[tab.Name].Visible = true

        end)

    end

    local function updateCanvasSize()

        tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabList.AbsoluteContentSize.Y)

        for _, frame in pairs(tabFrames) do

            local content = frame:FindFirstChildOfClass("Frame")

            if content then

                local layout = content:FindFirstChildOfClass("UIListLayout")

                if layout then

                    frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)

                else

                    frame.CanvasSize = UDim2.new(0, 0, 0, content.AbsoluteSize.Y + 20)

                end

            else

                frame.CanvasSize = UDim2.new(0, 0, 0, 400)

            end

        end

    end

    tabList.Changed:Connect(updateCanvasSize)

    contentFrame.ChildAdded:Connect(updateCanvasSize)

    RunService.Heartbeat:Connect(updateCanvasSize)

    updateCanvasSize()

    toggleGui()

end)

if not success then

    warn("[UniverseHub] Error saat menjalankan script: " .. tostring(err))

else

    print("[UniverseHub] Script berhasil dijalankan")

end

player.CharacterAdded:Connect(function()

    if playerGui:FindFirstChild("UniverseHub") then

        playerGui.UniverseHub.Parent = playerGui

    end

end)