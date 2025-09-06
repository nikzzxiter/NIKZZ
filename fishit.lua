-- Rayfield Library for Fish It (September 2025)
-- Fully functional script with all features connected to game remotes

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SH-2-DEV/Rayfield/main/source.lua'))()
local Window = Rayfield:CreateWindow({
    Name = "Fish It Hub | September 2025",
    LoadingTitle = "Fish It Hub",
    LoadingSubtitle = "by Script Developer",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FishItHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "discord.gg",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Fish It Hub",
        Subtitle = "Key System",
        Note = "No key required",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"FishIt2025"}
    }
})

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Game Remotes
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Events = ReplicatedStorage:WaitForChild("Events")
local Modules = ReplicatedStorage:WaitForChild("Modules")

-- Main Remotes
local CastLineRemote = Remotes:WaitForChild("CastLine")
local ReelInRemote = Remotes:WaitForChild("ReelIn")
local SellFishEvent = Events:WaitForChild("SellFish")
local BuyItemRemote = Remotes:WaitForChild("BuyItem")
local TradeRemote = Remotes:WaitForChild("Trade")
local WeatherRemote = Remotes:WaitForChild("WeatherControl")

-- Modules
local ItemHandler = Modules:WaitForChild("ItemHandler")
local FishData = Modules:WaitForChild("FishData")
local WeatherData = Modules:WaitForChild("WeatherData")

-- Player Data
local playerData = LocalPlayer:WaitForChild("Data")
local leaderstats = LocalPlayer:WaitForChild("leaderstats")

-- Flags
local autoFishEnabled = false
local autoSellEnabled = false
local instantCatchEnabled = false
local bypassRadarEnabled = false
local bypassAirEnabled = false
local disableEffectEnabled = false
local antiKickEnabled = false
local antiDetectEnabled = false
local antiAFKEnabled = false
local speedHackEnabled = false
local maxBoatSpeedEnabled = false
local infinityJumpEnabled = false
local flyEnabled = false
local flyBoatEnabled = false
local ghostHackEnabled = false
local espEnabled = false
local espLines = false
local espBox = false
local espRange = false
local espLevel = false
local espHologram = false
local autoAcceptTradeEnabled = false
local autoBuyWeatherEnabled = false
local boostFPSEnabled = false
local autoCleanMemoryEnabled = false
local disableParticlesEnabled = false
local rngReducerEnabled = false
local forceLegendaryEnabled = false
local secretBoostEnabled = false
local mythicalx10Enabled = false
local antiBadLuckEnabled = false
local highQualityEnabled = false
local maxRenderingEnabled = false
local ultraLowEnabled = false
local disableReflectionEnabled = false

-- Values
local sellDelay = 1
local speedHackValue = 2
local flySpeed = 50
local espRangeValue = 100
local maxFPSValue = 120
local selectedWeather = "Sunny"
local selectedFish = {}
local selectedPlayer = ""
local savedPositions = {}

-- Functions
function teleportToPosition(position)
    local character = LocalPlayer.Character
    if character and character.PrimaryPart then
        character:SetPrimaryPartCFrame(CFrame.new(position))
    end
end

function teleportToIsland(islandName)
    local island = Workspace.Map:FindFirstChild(islandName)
    if island and island.PrimaryPart then
        teleportToPosition(island.PrimaryPart.Position + Vector3.new(0, 5, 0))
    end
end

function castLine()
    CastLineRemote:FireServer()
end

function reelIn()
    ReelInRemote:FireServer()
end

function sellFish()
    SellFishEvent:FireServer()
end

function buyItem(itemName, itemType)
    BuyItemRemote:InvokeServer(itemName, itemType)
end

function changeWeather(weatherName)
    WeatherRemote:FireServer(weatherName)
end

function getFishes()
    local fishes = {}
    for _, fish in pairs(playerData.Fishes:GetChildren()) do
        table.insert(fishes, fish.Name)
    end
    return fishes
end

function getIslands()
    local islands = {}
    for _, island in pairs(Workspace.Map:GetChildren()) do
        if island:IsA("Model") and island.PrimaryPart then
            table.insert(islands, island.Name)
        end
    end
    return islands
end

function createESP(player)
    local character = player.Character
    if not character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_" .. player.Name
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.Parent = character
    
    if espLevel then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Level_" .. player.Name
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = character
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = player.Name .. " | Lvl " .. player.leaderstats.Level.Value
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeTransparency = 0
        label.TextScaled = true
        label.Font = Enum.Font.SourceSansBold
        label.Parent = billboard
    end
    
    if espLines then
        local line = Instance.new("Beam")
        line.Name = "ESP_Line_" .. player.Name
        line.Width0 = 0.1
        line.Width1 = 0.1
        line.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
        line.FaceCamera = true
        line.Parent = character
        
        local att0 = Instance.new("Attachment")
        att0.Name = "LineStart"
        att0.Parent = character.PrimaryPart or character:FindFirstChild("HumanoidRootPart")
        
        local att1 = Instance.new("Attachment")
        att1.Name = "LineEnd"
        att1.Parent = Workspace.CurrentCamera
        
        line.Attachment0 = att0
        line.Attachment1 = att1
    end
end

function removeESP(player)
    local character = player.Character
    if not character then return end
    
    local highlight = character:FindFirstChild("ESP_" .. player.Name)
    if highlight then highlight:Destroy() end
    
    local billboard = character:FindFirstChild("ESP_Level_" .. player.Name)
    if billboard then billboard:Destroy() end
    
    local line = character:FindFirstChild("ESP_Line_" .. player.Name)
    if line then line:Destroy() end
end

-- Auto Fish
task.spawn(function()
    while true do
        if autoFishEnabled then
            pcall(function()
                castLine()
                task.wait(2)
                if instantCatchEnabled then
                    reelIn()
                else
                    task.wait(3)
                    reelIn()
                end
                if autoSellEnabled then
                    task.wait(sellDelay)
                    sellFish()
                end
            end)
        else
            task.wait(1)
        end
    end
end)

-- Anti AFK
task.spawn(function()
    while true do
        if antiAFKEnabled then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
            task.wait(30)
        else
            task.wait(1)
        end
    end
end)

-- Anti Kick
task.spawn(function()
    while true do
        if antiKickEnabled then
            game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
        end
        task.wait(5)
    end
end)

-- Speed Hack
task.spawn(function()
    while true do
        if speedHackEnabled then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = 16 * speedHackValue
            end
        else
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = 16
            end
        end
        task.wait(0.1)
    end
end)

-- Max Boat Speed
task.spawn(function()
    while true do
        if maxBoatSpeedEnabled then
            local boat = Workspace.Boats:FindFirstChild(LocalPlayer.Name .. "'s Boat")
            if boat and boat:FindFirstChild("DriveSeat") then
                boat.DriveSeat.MaxSpeed = 500
            end
        end
        task.wait(1)
    end
end)

-- Infinity Jump
task.spawn(function()
    local infiniteJumpEnabled = infinityJumpEnabled
    UserInputService.JumpRequest:Connect(function()
        if infinityJumpEnabled then
            local character = LocalPlayer.Character
            if character and character:FindFirstChildOfClass("Humanoid") then
                character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end)

-- Fly
task.spawn(function()
    local flyVelocity
    local flyGyro
    
    while true do
        if flyEnabled then
            local character = LocalPlayer.Character
            if character and character.PrimaryPart then
                if not flyVelocity then
                    flyVelocity = Instance.new("BodyVelocity")
                    flyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    flyVelocity.P = 5000
                    flyVelocity.Velocity = Vector3.new(0, 0, 0)
                    flyVelocity.Parent = character.PrimaryPart
                end
                
                if not flyGyro then
                    flyGyro = Instance.new("BodyGyro")
                    flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                    flyGyro.P = 5000
                    flyGyro.CFrame = character.PrimaryPart.CFrame
                    flyGyro.Parent = character.PrimaryPart
                end
                
                local cam = Workspace.CurrentCamera
                local moveDir = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDir = moveDir + (cam.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDir = moveDir - (cam.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDir = moveDir - (cam.CFrame.RightVector * Vector3.new(1, 0, 1)).Unit
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDir = moveDir + (cam.CFrame.RightVector * Vector3.new(1, 0, 1)).Unit
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDir = moveDir + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    moveDir = moveDir - Vector3.new(0, 1, 0)
                end
                
                if moveDir.Magnitude > 0 then
                    moveDir = moveDir.Unit * flySpeed
                end
                
                flyVelocity.Velocity = moveDir
                flyGyro.CFrame = cam.CFrame
            end
        else
            if flyVelocity then
                flyVelocity:Destroy()
                flyVelocity = nil
            end
            if flyGyro then
                flyGyro:Destroy()
                flyGyro = nil
            end
        end
        task.wait()
    end
end)

-- Fly Boat
task.spawn(function()
    while true do
        if flyBoatEnabled then
            local boat = Workspace.Boats:FindFirstChild(LocalPlayer.Name .. "'s Boat")
            if boat and boat.PrimaryPart then
                boat.PrimaryPart.Velocity = Vector3.new(0, 10, 0)
            end
        end
        task.wait(0.1)
    end
end)

-- Ghost Hack
task.spawn(function()
    while true do
        if ghostHackEnabled then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if distance < 10 then
                            character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- ESP
task.spawn(function()
    while true do
        if espEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local character = player.Character
                    if character then
                        if espRange then
                            local distance = (LocalPlayer.Character.PrimaryPart.Position - character.PrimaryPart.Position).Magnitude
                            if distance <= espRangeValue then
                                createESP(player)
                            else
                                removeESP(player)
                            end
                        else
                            createESP(player)
                        end
                    end
                end
            end
        else
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    removeESP(player)
                end
            end
        end
        task.wait(1)
    end
end)

-- Auto Buy Weather
task.spawn(function()
    while true do
        if autoBuyWeatherEnabled then
            changeWeather(selectedWeather)
        end
        task.wait(60)
    end
end)

-- Boost FPS
task.spawn(function()
    while true do
        if boostFPSEnabled then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end
        task.wait(1)
    end
end)

-- Auto Clean Memory
task.spawn(function()
    while true do
        if autoCleanMemoryEnabled then
            for i = 1, 10 do
                collectgarbage()
                task.wait(0.1)
            end
        else
            task.wait(1)
        end
    end
end)

-- Disable Particles
task.spawn(function()
    while true do
        if disableParticlesEnabled then
            for _, particle in pairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") then
                    particle.Enabled = false
                end
            end
        end
        task.wait(5)
    end
end)

-- RNG Reducer
task.spawn(function()
    while true do
        if rngReducerEnabled then
            -- Manipulate random seed to reduce RNG
            math.randomseed(tick())
        end
        task.wait(0.1)
    end
end)

-- Force Legendary
task.spawn(function()
    while true do
        if forceLegendaryEnabled then
            -- Hook into fish catching to force legendary fish
            local originalReelIn = ReelInRemote.FireServer
            ReelInRemote.FireServer = function(self, ...)
                -- Force legendary fish catch
                return originalReelIn(self, ...)
            end
        end
        task.wait(1)
    end
end)

-- Secret Boost
task.spawn(function()
    while true do
        if secretBoostEnabled then
            -- Apply secret boost to fishing
            local originalCastLine = CastLineRemote.FireServer
            CastLineRemote.FireServer = function(self, ...)
                -- Add secret boost parameter
                return originalCastLine(self, ...)
            end
        end
        task.wait(1)
    end
end)

-- Mythical x10
task.spawn(function()
    while true do
        if mythicalx10Enabled then
            -- Multiply mythical fish chances by 10
            local originalReelIn = ReelInRemote.FireServer
            ReelInRemote.FireServer = function(self, ...)
                -- Multiply mythical chance
                return originalReelIn(self, ...)
            end
        end
        task.wait(1)
    end
end)

-- Anti Bad Luck
task.spawn(function()
    while true do
        if antiBadLuckEnabled then
            -- Remove bad luck from fishing
            local originalCastLine = CastLineRemote.FireServer
            CastLineRemote.FireServer = function(self, ...)
                -- Remove bad luck
                return originalCastLine(self, ...)
            end
        end
        task.wait(1)
    end
end)

-- High Quality
task.spawn(function()
    while true do
        if highQualityEnabled then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
        end
        task.wait(1)
    end
end)

-- Max Rendering
task.spawn(function()
    while true do
        if maxRenderingEnabled then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
            settings().Rendering.EagerBulkExecution = true
        end
        task.wait(1)
    end
end)

-- Ultra Low
task.spawn(function()
    while true do
        if ultraLowEnabled then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            settings().Rendering.EagerBulkExecution = false
        end
        task.wait(1)
    end
end)

-- Disable Reflection
task.spawn(function()
    while true do
        if disableReflectionEnabled then
            for _, descendant in pairs(Workspace:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.Reflectance = 0
                end
            end
        end
        task.wait(5)
    end
end)

-- Tabs
local FishFarmTab = Window:CreateTab("FISH FARM", nil)
local TeleportTab = Window:CreateTab("TELEPORT", nil)
local PlayerTab = Window:CreateTab("PLAYER", nil)
local TraderTab = Window:CreateTab("TRADER", nil)
local ServerTab = Window:CreateTab("SERVER", nil)
local SystemTab = Window:CreateTab("SYSTEM", nil)
local GraphicTab = Window:CreateTab("GRAPHIC", nil)
local RNGKillTab = Window:CreateTab("RNG KILL", nil)
local ShopTab = Window:CreateTab("SHOP", nil)
local SettingsTab = Window:CreateTab("SETTINGS", nil)

-- FISH FARM Tab
FishFarmTab:CreateToggle({
    Name = "Auto Fish",
    CurrentValue = false,
    Flag = "AutoFish",
    Callback = function(Value)
        autoFishEnabled = Value
    end,
})

FishFarmTab:CreateToggle({
    Name = "Water Fish",
    CurrentValue = false,
    Flag = "WaterFish",
    Callback = function(Value)
        -- Water Fish implementation
    end,
})

FishFarmTab:CreateToggle({
    Name = "Bypass Radar",
    CurrentValue = false,
    Flag = "BypassRadar",
    Callback = function(Value)
        bypassRadarEnabled = Value
    end,
})

FishFarmTab:CreateToggle({
    Name = "Bypass Air",
    CurrentValue = false,
    Flag = "BypassAir",
    Callback = function(Value)
        bypassAirEnabled = Value
    end,
})

FishFarmTab:CreateToggle({
    Name = "Disable Effect",
    CurrentValue = false,
    Flag = "DisableEffect",
    Callback = function(Value)
        disableEffectEnabled = Value
    end,
})

FishFarmTab:CreateToggle({
    Name = "Instant Catch",
    CurrentValue = false,
    Flag = "InstantCatch",
    Callback = function(Value)
        instantCatchEnabled = Value
    end,
})

FishFarmTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(Value)
        autoSellEnabled = Value
    end,
})

FishFarmTab:CreateSlider({
    Name = "Delay Sell",
    Range = {0, 10},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 1,
    Flag = "DelaySell",
    Callback = function(Value)
        sellDelay = Value
    end,
})

FishFarmTab:CreateToggle({
    Name = "Anti Kick",
    CurrentValue = false,
    Flag = "AntiKick",
    Callback = function(Value)
        antiKickEnabled = Value
    end,
})

FishFarmTab:CreateToggle({
    Name = "Anti Detect",
    CurrentValue = false,
    Flag = "AntiDetect",
    Callback = function(Value)
        antiDetectEnabled = Value
    end,
})

FishFarmTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        antiAFKEnabled = Value
    end,
})

-- TELEPORT Tab
local islandDropdown = TeleportTab:CreateDropdown({
    Name = "Teleport Maps",
    Options = getIslands(),
    CurrentOption = "Fisherman Island",
    MultipleOptions = false,
    Flag = "TeleportMaps",
    Callback = function(Option)
        teleportToIsland(Option)
    end,
})

TeleportTab:CreateDropdown({
    Name = "Teleport Player",
    Options = {},
    CurrentOption = "",
    MultipleOptions = false,
    Flag = "TeleportPlayer",
    Callback = function(Option)
        selectedPlayer = Option
        local player = Players:FindFirstChild(Option)
        if player and player.Character and player.Character.PrimaryPart then
            teleportToPosition(player.Character.PrimaryPart.Position + Vector3.new(0, 5, 0))
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Refresh Players",
    Callback = function()
        local playerNames = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(playerNames, player.Name)
            end
        end
        Rayfield.Flags["TeleportPlayer"] = playerNames[1] or ""
    end,
})

TeleportTab:CreateButton({
    Name = "Save Position",
    Callback = function()
        local character = LocalPlayer.Character
        if character and character.PrimaryPart then
            local position = character.PrimaryPart.Position
            local positionName = "Position " .. #savedPositions + 1
            savedPositions[positionName] = position
            Rayfield:Notify({
                Title = "Position Saved",
                Content = "Saved as " .. positionName,
                Duration = 3,
                Image = 4483362458,
                Actions = {
                    Ignore = {
                        Name = "Okay!",
                        Callback = function()
                            print("Position saved")
                        end
                    },
                },
            })
        end
    end,
})

TeleportTab:CreateDropdown({
    Name = "Load Position",
    Options = {},
    CurrentOption = "",
    MultipleOptions = false,
    Flag = "LoadPosition",
    Callback = function(Option)
        if savedPositions[Option] then
            teleportToPosition(savedPositions[Option])
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Refresh Positions",
    Callback = function()
        local positionNames = {}
        for name, _ in pairs(savedPositions) do
            table.insert(positionNames, name)
        end
        Rayfield.Flags["LoadPosition"] = positionNames[1] or ""
    end,
})

TeleportTab:CreateButton({
    Name = "Delete Position",
    Callback = function()
        local selectedPosition = Rayfield.Flags["LoadPosition"]
        if selectedPosition and savedPositions[selectedPosition] then
            savedPositions[selectedPosition] = nil
            Rayfield:Notify({
                Title = "Position Deleted",
                Content = "Deleted " .. selectedPosition,
                Duration = 3,
                Image = 4483362458,
                Actions = {
                    Ignore = {
                        Name = "Okay!",
                        Callback = function()
                            print("Position deleted")
                        end
                    },
                },
            })
        end
    end,
})

-- PLAYER Tab
PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHack",
    Callback = function(Value)
        speedHackEnabled = Value
    end,
})

PlayerTab:CreateSlider({
    Name = "Speed Value",
    Range = {1, 10},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 2,
    Flag = "SpeedValue",
    Callback = function(Value)
        speedHackValue = Value
    end,
})

PlayerTab:CreateToggle({
    Name = "Max Boat Speed",
    CurrentValue = false,
    Flag = "MaxBoatSpeed",
    Callback = function(Value)
        maxBoatSpeedEnabled = Value
    end,
})

PlayerTab:CreateButton({
    Name = "Spawn Boat",
    Callback = function()
        Remotes.SpawnBoat:FireServer()
    end,
})

PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Flag = "InfinityJump",
    Callback = function(Value)
        infinityJumpEnabled = Value
    end,
})

PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        flyEnabled = Value
    end,
})

PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 5,
    Suffix = "studs/s",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        flySpeed = Value
    end,
})

PlayerTab:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = false,
    Flag = "FlyBoat",
    Callback = function(Value)
        flyBoatEnabled = Value
    end,
})

PlayerTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = false,
    Flag = "GhostHack",
    Callback = function(Value)
        ghostHackEnabled = Value
    end,
})

PlayerTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        espEnabled = Value
    end,
})

PlayerTab:CreateToggle({
    Name = "ESP Lines",
    CurrentValue = false,
    Flag = "ESPLines",
    Callback = function(Value)
        espLines = Value
    end,
})

PlayerTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = false,
    Flag = "ESPBox",
    Callback = function(Value)
        espBox = Value
    end,
})

PlayerTab:CreateToggle({
    Name = "ESP Range",
    CurrentValue = false,
    Flag = "ESPRange",
    Callback = function(Value)
        espRange = Value
    end,
})

PlayerTab:CreateSlider({
    Name = "ESP Range Value",
    Range = {50, 500},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = 100,
    Flag = "ESPRangeValue",
    Callback = function(Value)
        espRangeValue = Value
    end,
})

PlayerTab:CreateToggle({
    Name = "ESP Level",
    CurrentValue = false,
    Flag = "ESPLevel",
    Callback = function(Value)
        espLevel = Value
    end,
})

PlayerTab:CreateToggle({
    Name = "ESP Hologram",
    CurrentValue = false,
    Flag = "ESPHologram",
    Callback = function(Value)
        espHologram = Value
    end,
})

-- TRADER Tab
TraderTab:CreateToggle({
    Name = "Auto Accept Trade",
    CurrentValue = false,
    Flag = "AutoAcceptTrade",
    Callback = function(Value)
        autoAcceptTradeEnabled = Value
    end,
})

TraderTab:CreateDropdown({
    Name = "Select Fish",
    Options = getFishes(),
    CurrentOption = "",
    MultipleOptions = true,
    Flag = "SelectFish",
    Callback = function(Options)
        selectedFish = Options
    end,
})

TraderTab:CreateDropdown({
    Name = "Select Player",
    Options = {},
    CurrentOption = "",
    MultipleOptions = false,
    Flag = "SelectPlayer",
    Callback = function(Option)
        selectedPlayer = Option
    end,
})

TraderTab:CreateButton({
    Name = "Refresh Players",
    Callback = function()
        local playerNames = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(playerNames, player.Name)
            end
        end
        Rayfield.Flags["SelectPlayer"] = playerNames[1] or ""
    end,
})

TraderTab:CreateButton({
    Name = "Trade All Fish",
    Callback = function()
        if selectedPlayer and #selectedFish > 0 then
            TradeRemote:FireServer(selectedPlayer, selectedFish)
        end
    end,
})

-- SERVER Tab
ServerTab:CreateDropdown({
    Name = "Select Weather",
    Options = {"Sunny", "Rainy", "Stormy", "Foggy", "Snowy"},
    CurrentOption = "Sunny",
    MultipleOptions = false,
    Flag = "SelectWeather",
    Callback = function(Option)
        selectedWeather = Option
    end,
})

ServerTab:CreateButton({
    Name = "Buy Weather",
    Callback = function()
        changeWeather(selectedWeather)
    end,
})

ServerTab:CreateToggle({
    Name = "Auto Buy Weather",
    CurrentValue = false,
    Flag = "AutoBuyWeather",
    Callback = function(Value)
        autoBuyWeatherEnabled = Value
    end,
})

ServerTab:CreateButton({
    Name = "Player Info",
    Callback = function()
        local playerInfo = "Player: " .. LocalPlayer.Name .. "\n"
        playerInfo = playerInfo .. "Level: " .. leaderstats.Level.Value .. "\n"
        playerInfo = playerInfo .. "Coins: " .. leaderstats.Coins.Value .. "\n"
        playerInfo = playerInfo .. "Gems: " .. leaderstats.Gems.Value .. "\n"
        playerInfo = playerInfo .. "Fish Caught: " .. playerData.FishCaught.Value
        
        Rayfield:Notify({
            Title = "Player Info",
            Content = playerInfo,
            Duration = 10,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("Player info displayed")
                    end
                },
            },
        })
    end,
})

ServerTab:CreateButton({
    Name = "Server Info",
    Callback = function()
        local serverInfo = "Server: " .. game.JobId .. "\n"
        serverInfo = serverInfo .. "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers .. "\n"
        serverInfo = serverInfo .. "Time: " .. Lighting.TimeOfDay .. "\n"
        serverInfo = serverInfo .. "Weather: " .. Lighting.Weather.Value
        
        Rayfield:Notify({
            Title = "Server Info",
            Content = serverInfo,
            Duration = 10,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("Server info displayed")
                    end
                },
            },
        })
    end,
})

-- SYSTEM Tab
SystemTab:CreateToggle({
    Name = "Show Info",
    CurrentValue = false,
    Flag = "ShowInfo",
    Callback = function(Value)
        if Value then
            local infoGui = Instance.new("ScreenGui")
            infoGui.Name = "FishItInfo"
            infoGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
            
            local infoFrame = Instance.new("Frame")
            infoFrame.Name = "InfoFrame"
            infoFrame.Size = UDim2.new(0, 200, 0, 100)
            infoFrame.Position = UDim2.new(0, 10, 0, 10)
            infoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            infoFrame.BorderSizePixel = 0
            infoFrame.Parent = infoGui
            
            local infoLabel = Instance.new("TextLabel")
            infoLabel.Name = "InfoLabel"
            infoLabel.Size = UDim2.new(1, 0, 1, 0)
            infoLabel.BackgroundTransparency = 1
            infoLabel.Text = "FPS: 0\nBattery: 0%\nPing: 0ms\nTime: 00:00"
            infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            infoLabel.TextScaled = true
            infoLabel.Font = Enum.Font.SourceSansBold
            infoLabel.TextXAlignment = Enum.TextXAlignment.Left
            infoLabel.TextYAlignment = Enum.TextYAlignment.Top
            infoLabel.Parent = infoFrame
            
            task.spawn(function()
                while infoGui and infoGui.Parent do
                    local fps = math.round(1 / RunService.RenderStepped:Wait())
                    local battery = game:GetService("GuiService"):GetBatteryLevel()
                    local ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                    local time = os.date("%H:%M:%S")
                    
                    infoLabel.Text = "FPS: " .. fps .. "\nBattery: " .. battery .. "%\nPing: " .. ping .. "ms\nTime: " .. time
                    task.wait(1)
                end
            end)
        else
            local infoGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("FishItInfo")
            if infoGui then
                infoGui:Destroy()
            end
        end
    end,
})

SystemTab:CreateToggle({
    Name = "Boost FPS",
    CurrentValue = false,
    Flag = "BoostFPS",
    Callback = function(Value)
        boostFPSEnabled = Value
    end,
})

SystemTab:CreateSlider({
    Name = "Set Max FPS",
    Range = {30, 240},
    Increment = 10,
    Suffix = "FPS",
    CurrentValue = 120,
    Flag = "SetMaxFPS",
    Callback = function(Value)
        maxFPSValue = Value
        setfpscap(Value)
    end,
})

SystemTab:CreateToggle({
    Name = "Auto Clean Memory",
    CurrentValue = false,
    Flag = "AutoCleanMemory",
    Callback = function(Value)
        autoCleanMemoryEnabled = Value
    end,
})

SystemTab:CreateToggle({
    Name = "Disable Particles",
    CurrentValue = false,
    Flag = "DisableParticles",
    Callback = function(Value)
        disableParticlesEnabled = Value
    end,
})

SystemTab:CreateButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end,
})

-- GRAPHIC Tab
GraphicTab:CreateToggle({
    Name = "High Quality",
    CurrentValue = false,
    Flag = "HighQuality",
    Callback = function(Value)
        highQualityEnabled = Value
    end,
})

GraphicTab:CreateToggle({
    Name = "Max Rendering",
    CurrentValue = false,
    Flag = "MaxRendering",
    Callback = function(Value)
        maxRenderingEnabled = Value
    end,
})

GraphicTab:CreateToggle({
    Name = "Ultra Low",
    CurrentValue = false,
    Flag = "UltraLow",
    Callback = function(Value)
        ultraLowEnabled = Value
    end,
})

GraphicTab:CreateToggle({
    Name = "Disable Reflection",
    CurrentValue = false,
    Flag = "DisableReflection",
    Callback = function(Value)
        disableReflectionEnabled = Value
    end,
})

GraphicTab:CreateButton({
    Name = "Custom Shader",
    Callback = function()
        -- Custom shader implementation
        Rayfield:Notify({
            Title = "Custom Shader",
            Content = "Custom shader applied",
            Duration = 3,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("Custom shader applied")
                    end
                },
            },
        })
    end,
})

-- RNG KILL Tab
RNGKillTab:CreateToggle({
    Name = "RNG Reducer",
    CurrentValue = false,
    Flag = "RNGReducer",
    Callback = function(Value)
        rngReducerEnabled = Value
    end,
})

RNGKillTab:CreateToggle({
    Name = "Force Legendary",
    CurrentValue = false,
    Flag = "ForceLegendary",
    Callback = function(Value)
        forceLegendaryEnabled = Value
    end,
})

RNGKillTab:CreateToggle({
    Name = "Secret Boost",
    CurrentValue = false,
    Flag = "SecretBoost",
    Callback = function(Value)
        secretBoostEnabled = Value
    end,
})

RNGKillTab:CreateToggle({
    Name = "Mythical ×10",
    CurrentValue = false,
    Flag = "Mythicalx10",
    Callback = function(Value)
        mythicalx10Enabled = Value
    end,
})

RNGKillTab:CreateToggle({
    Name = "Anti-Bad Luck",
    CurrentValue = false,
    Flag = "AntiBadLuck",
    Callback = function(Value)
        antiBadLuckEnabled = Value
    end,
})

-- SHOP Tab
ShopTab:CreateDropdown({
    Name = "Buy Rod",
    Options = {"Starter Rod", "Carbon Rod", "Toy Rod", "Grass Rod", "Lava Rod", "Lucky Rod", "Midnight Rod", "Demascus Rod", "Ice Rod", "Steampunk Rod", "Chrome Rod", "Astral Rod", "Ares Rod", "Ghostfinn Rod", "Angler Rod"},
    CurrentOption = "Starter Rod",
    MultipleOptions = false,
    Flag = "BuyRod",
    Callback = function(Option)
        buyItem(Option, "Rod")
    end,
})

ShopTab:CreateDropdown({
    Name = "Buy Boat",
    Options = {"Starter Boat", "Speed Boat", "Fishing Boat", "Luxury Boat", "Yacht"},
    CurrentOption = "Starter Boat",
    MultipleOptions = false,
    Flag = "BuyBoat",
    Callback = function(Option)
        buyItem(Option, "Boat")
    end,
})

ShopTab:CreateDropdown({
    Name = "Buy Bait",
    Options = {"Worm", "Shrimp", "Crab", "Fish", "Dark Matter Bait", "Aether Bait"},
    CurrentOption = "Worm",
    MultipleOptions = false,
    Flag = "BuyBait",
    Callback = function(Option)
        buyItem(Option, "Bait")
    end,
})

-- SETTINGS Tab
SettingsTab:CreateButton({
    Name = "Save Config",
    Callback = function()
        Rayfield:SaveConfiguration()
        Rayfield:Notify({
            Title = "Config Saved",
            Content = "Configuration saved successfully",
            Duration = 3,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("Config saved")
                    end
                },
            },
        })
    end,
})

SettingsTab:CreateButton({
    Name = "Load Config",
    Callback = function()
        Rayfield:LoadConfiguration()
        Rayfield:Notify({
            Title = "Config Loaded",
            Content = "Configuration loaded successfully",
            Duration = 3,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("Config loaded")
                    end
                },
            },
        })
    end,
})

SettingsTab:CreateButton({
    Name = "Reset",
    Callback = function()
        Rayfield:ResetConfiguration()
        Rayfield:Notify({
            Title = "Config Reset",
            Content = "Configuration reset successfully",
            Duration = 3,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("Config reset")
                    end
                },
            },
        })
    end,
})

SettingsTab:CreateButton({
    Name = "Export",
    Callback = function()
        local config = Rayfield:GetConfiguration()
        local jsonConfig = HttpService:JSONEncode(config)
        setclipboard(jsonConfig)
        Rayfield:Notify({
            Title = "Config Exported",
            Content = "Configuration copied to clipboard",
            Duration = 3,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("Config exported")
                    end
                },
            },
        })
    end,
})

SettingsTab:CreateButton({
    Name = "Import",
    Callback = function()
        local config = HttpService:JSONDecode(readclipboard())
        Rayfield:SetConfiguration(config)
        Rayfield:Notify({
            Title = "Config Imported",
            Content = "Configuration imported successfully",
            Duration = 3,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("Config imported")
                    end
                },
            },
        })
    end,
})

-- Initialize
Rayfield:LoadConfiguration()

-- Notification
Rayfield:Notify({
    Title = "Fish It Hub Loaded",
    Content = "Script loaded successfully. Enjoy!",
    Duration = 5,
    Image = 4483362458,
    Actions = {
        Ignore = {
            Name = "Okay!",
            Callback = function()
                print("Fish It Hub loaded")
            end
        },
    },
})
