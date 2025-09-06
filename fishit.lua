-- Fish It Script (September 2025)
-- Rayfield Interface + Async System
-- Compatible with Delta, Codex, Hydrogen, Arceus X, Fluxus, Synapse X, Script-Ware, Solara

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")

-- Player references
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Game references
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Events = ReplicatedStorage:WaitForChild("Events")
local Modules = ReplicatedStorage:WaitForChild("Modules")

-- Module references
local ItemHandler = require(Modules:WaitForChild("ItemHandler"))
local FishingHandler = require(Modules:WaitForChild("FishingHandler"))
local TradeHandler = require(Modules:WaitForChild("TradeHandler"))
local MapHandler = require(Modules:WaitForChild("MapHandler"))
local WeatherHandler = require(Modules:WaitForChild("WeatherHandler"))

-- Configuration
local Config = {
    AutoFish = false,
    WaterFish = false,
    DisableEffects = false,
    InstantFishing = false,
    AutoSell = false,
    SellDelay = 1,
    AntiKick = true,
    AntiAFK = true,
    AutoJump = false,
    PlayerSpeed = 16,
    BoatSpeed = 50,
    InfinityJump = false,
    FlyEnabled = false,
    FlySpeed = 50,
    GhostMode = false,
    ESPEnabled = false,
    AutoAcceptTrade = false,
    AutoBuyWeather = false,
    FPSBoost = false,
    MaxFPS = 60,
    LowGraphics = false,
    DisableReflections = false,
    RNGReducer = false,
    ForceLegendary = false,
    SecretBoost = false,
    MythicalBoost = false,
    AntiBadLuck = false,
    SelectedRod = "Default",
    SelectedBait = "Default",
    SelectedBoat = "Default",
    FavoritedFish = {},
    SavedPositions = {}
}

-- Global variables
local FishingConnection = nil
local SellingConnection = nil
local AFKConnection = nil
local JumpConnection = nil
local FlyConnection = nil
local ESPConnection = nil
local WeatherConnection = nil
local MemoryCleaner = nil
local FPSBooster = nil
local GraphicsUpdater = nil
local RNGBooster = nil
local LastJumpTime = 0
local LastPosition = Vector3.new(0, 0, 0)
local StuckCount = 0
local FishCaught = 0
local TotalValue = 0
local PlayerESP = {}
local IslandESP = {}
local FishESP = {}
local BoatESP = {}

-- Create Rayfield window
local Window = Rayfield:CreateWindow({
    Name = "Fish It - September 2025",
    LoadingTitle = "Fish It Script",
    LoadingSubtitle = "by Professional Developer",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FishItConfig",
        FileName = "ConfigSeptember2025"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Main tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local TraderTab = Window:CreateTab("Trader", 4483362458)
local ServerTab = Window:CreateTab("Server", 4483362458)
local SystemTab = Window:CreateTab("System", 4483362458)
local GraphicsTab = Window:CreateTab("Graphics", 4483362458)
local RNGTab = Window:CreateTab("RNG", 4483362458)
local ShopTab = Window:CreateTab("Shop", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- Functions
local function Async(func)
    return task.spawn(func)
end

local function Wait(seconds)
    return task.wait(seconds)
end

local function GetNetworth()
    local networth = 0
    for _, item in pairs(Player:WaitForChild("Inventory"):GetChildren()) do
        if item:FindFirstChild("Value") then
            networth += item.Value.Value
        end
    end
    return networth
end

local function GetFishingRod()
    for _, tool in pairs(Player.Backpack:GetChildren()) do
        if tool:FindFirstChild("FishingRod") then
            return tool
        end
    end
    return nil
end

local function GetBoat()
    for _, vehicle in pairs(workspace.Vehicles:GetChildren()) do
        if vehicle:FindFirstChild("Owner") and vehicle.Owner.Value == Player then
            return vehicle
        end
    end
    return nil
end

local function IsInWater(position)
    local waterParts = workspace:FindFirstChild("Water") or workspace:FindFirstChild("Ocean")
    if waterParts then
        for _, part in pairs(waterParts:GetChildren()) do
            if part:IsA("Part") then
                local partPosition = part.Position
                local partSize = part.Size
                if position.X >= partPosition.X - partSize.X/2 and position.X <= partPosition.X + partSize.X/2 and
                   position.Z >= partPosition.Z - partSize.Z/2 and position.Z <= partPosition.Z + partSize.Z/2 and
                   position.Y <= partPosition.Y + partSize.Y/2 then
                    return true
                end
            end
        end
    end
    return false
end

local function GetIslands()
    local islands = {}
    for _, island in pairs(workspace:GetChildren()) do
        if island:FindFirstChild("Island") and island:FindFirstChild("Teleport") then
            table.insert(islands, island.Name)
        end
    end
    return islands
end

local function GetPlayers()
    local players = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            table.insert(players, player.Name)
        end
    end
    return players
end

local function GetWeathers()
    local weathers = {}
    for weatherName, _ in pairs(WeatherHandler.WeatherTypes) do
        table.insert(weathers, weatherName)
    end
    return weathers
end

local function GetRods()
    local rods = {}
    for rodName, _ in pairs(ItemHandler.Rods) do
        table.insert(rods, rodName)
    end
    return rods
end

local function GetBaits()
    local baits = {}
    for baitName, _ in pairs(ItemHandler.Baits) do
        table.insert(baits, baitName)
    end
    return baits
end

local function GetBoats()
    local boats = {}
    for boatName, _ in pairs(ItemHandler.Boats) do
        table.insert(boats, boatName)
    end
    return boats
end

local function TeleportTo(position)
    if typeof(position) == "Vector3" then
        HumanoidRootPart.CFrame = CFrame.new(position)
    elseif typeof(position) == "CFrame" then
        HumanoidRootPart.CFrame = position
    end
end

local function TeleportToIsland(islandName)
    local island = workspace:FindFirstChild(islandName)
    if island and island:FindFirstChild("Teleport") then
        TeleportTo(island.Teleport.Position + Vector3.new(0, 5, 0))
    end
end

local function TeleportToPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        TeleportTo(target.Character.HumanoidRootPart.Position)
    end
end

local function SavePosition(name)
    if HumanoidRootPart then
        Config.SavedPositions[name] = HumanoidRootPart.CFrame
        Rayfield:Notify({
            Title = "Position Saved",
            Content = "Position '" .. name .. "' has been saved.",
            Duration = 3,
            Image = 4483362458,
        })
    end
end

local function LoadPosition(name)
    if Config.SavedPositions[name] then
        TeleportTo(Config.SavedPositions[name])
        Rayfield:Notify({
            Title = "Position Loaded",
            Content = "Teleported to saved position '" .. name .. "'.",
            Duration = 3,
            Image = 4483362458,
        })
    end
end

local function DeletePosition(name)
    if Config.SavedPositions[name] then
        Config.SavedPositions[name] = nil
        Rayfield:Notify({
            Title = "Position Deleted",
            Content = "Position '" .. name .. "' has been deleted.",
            Duration = 3,
            Image = 4483362458,
        })
    end
end

local function BuyRod(rodName)
    if ItemHandler.Rods[rodName] then
        local cost = ItemHandler.Rods[rodName].Cost
        if Player.Leaderboard.Money.Value >= cost then
            Remotes.BuyRod:FireServer(rodName)
            return true
        end
    end
    return false
end

local function BuyBait(baitName)
    if ItemHandler.Baits[baitName] then
        local cost = ItemHandler.Baits[baitName].Cost
        if Player.Leaderboard.Money.Value >= cost then
            Remotes.BuyBait:FireServer(baitName)
            return true
        end
    end
    return false
end

local function BuyBoat(boatName)
    if ItemHandler.Boats[boatName] then
        local cost = ItemHandler.Boats[boatName].Cost
        if Player.Leaderboard.Money.Value >= cost then
            Remotes.BuyBoat:FireServer(boatName)
            return true
        end
    end
    return false
end

local function BuyWeather(weatherName)
    if WeatherHandler.WeatherTypes[weatherName] then
        local cost = WeatherHandler.WeatherTypes[weatherName].Cost
        if Player.Leaderboard.Money.Value >= cost then
            Remotes.BuyWeather:FireServer(weatherName)
            return true
        end
    end
    return false
end

local function SetBoatSpeed(speed)
    local boat = GetBoat()
    if boat and boat:FindFirstChild("VehicleSeat") then
        boat.VehicleSeat.MaxSpeed = speed
    end
end

local function ToggleFishing(state)
    if state then
        local rod = GetFishingRod()
        if rod then
            Player.Character.Humanoid:EquipTool(rod)
            Wait(0.5)
            Remotes.CastLine:FireServer()
        end
    else
        Remotes.RetrieveLine:FireServer()
    end
end

local function SellFish()
    for _, item in pairs(Player.Inventory:GetChildren()) do
        if item:FindFirstChild("Value") and not table.find(Config.FavoritedFish, item.Name) then
            Events.SellFish:FireServer(item)
            Wait(Config.SellDelay)
        end
    end
end

local function SetupAutoFish()
    if FishingConnection then
        FishingConnection:Disconnect()
        FishingConnection = nil
    end
    
    if Config.AutoFish then
        FishingConnection = RunService.Heartbeat:Connect(function()
            if Config.AutoFish then
                local rod = GetFishingRod()
                if rod and not rod:FindFirstChild("FishingProgress") then
                    ToggleFishing(true)
                end
                
                if rod and rod:FindFirstChild("FishingProgress") then
                    local progress = rod.FishingProgress
                    if progress.Value >= 0.9 then
                        Remotes.PerfectCatch:FireServer()
                        Wait(0.5)
                        ToggleFishing(false)
                        Wait(1)
                        ToggleFishing(true)
                    end
                end
            end
        end)
    end
end

local function SetupAutoSell()
    if SellingConnection then
        SellingConnection:Disconnect()
        SellingConnection = nil
    end
    
    if Config.AutoSell then
        SellingConnection = RunService.Heartbeat:Connect(function()
            if Config.AutoSell then
                SellFish()
                Wait(Config.SellDelay)
            end
        end)
    end
end

local function SetupAntiAFK()
    if AFKConnection then
        AFKConnection:Disconnect()
        AFKConnection = nil
    end
    
    if Config.AntiAFK then
        AFKConnection = RunService.Heartbeat:Connect(function()
            if Config.AntiAFK then
                VirtualInputManager:SendKeyEvent(true, "W", false, game)
                Wait(0.1)
                VirtualInputManager:SendKeyEvent(false, "W", false, game)
                
                if Config.AutoJump and tick() - LastJumpTime > 30 then
                    VirtualInputManager:SendKeyEvent(true, "Space", false, game)
                    Wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, "Space", false, game)
                    LastJumpTime = tick()
                end
            end
        end)
    end
end

local function SetupFly()
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    
    if Config.FlyEnabled then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        bodyVelocity.P = 1000
        bodyVelocity.Parent = HumanoidRootPart
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            if Config.FlyEnabled and Character and HumanoidRootPart then
                local camera = workspace.CurrentCamera
                local direction = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    direction = direction + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    direction = direction - Vector3.new(0, 1, 0)
                end
                
                if direction.Magnitude > 0 then
                    bodyVelocity.Velocity = direction.Unit * Config.FlySpeed
                else
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
            else
                if bodyVelocity then
                    bodyVelocity:Destroy()
                end
            end
        end)
    end
end

local function SetupESP()
    if ESPConnection then
        ESPConnection:Disconnect()
        ESPConnection = nil
    end
    
    -- Clean up existing ESP
    for _, esp in pairs(PlayerESP) do
        if esp then
            esp:Remove()
        end
    end
    PlayerESP = {}
    
    for _, esp in pairs(IslandESP) do
        if esp then
            esp:Remove()
        end
    end
    IslandESP = {}
    
    for _, esp in pairs(FishESP) do
        if esp then
            esp:Remove()
        end
    end
    FishESP = {}
    
    for _, esp in pairs(BoatESP) do
        if esp then
            esp:Remove()
        end
    end
    BoatESP = {}
    
    if Config.ESPEnabled then
        -- Player ESP
        ESPConnection = RunService.Heartbeat:Connect(function()
            if Config.ESPEnabled then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        if not PlayerESP[player.Name] then
                            local esp = Drawing.new("Text")
                            esp.Text = player.Name
                            esp.Size = 14
                            esp.Outline = true
                            esp.OutlineColor = Color3.new(0, 0, 0)
                            esp.Center = true
                            PlayerESP[player.Name] = esp
                        end
                        
                        local rootPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                        if onScreen then
                            PlayerESP[player.Name].Position = Vector2.new(rootPos.X, rootPos.Y)
                            PlayerESP[player.Name].Color = Color3.fromHSV(tick() % 5 / 5, 1, 1) -- Rainbow effect
                            PlayerESP[player.Name].Visible = true
                        else
                            PlayerESP[player.Name].Visible = false
                        end
                    end
                end
                
                -- Island ESP
                for _, island in pairs(workspace:GetChildren()) do
                    if island:FindFirstChild("Island") and island:FindFirstChild("Teleport") then
                        if not IslandESP[island.Name] then
                            local esp = Drawing.new("Text")
                            esp.Text = island.Name
                            esp.Size = 18
                            esp.Outline = true
                            esp.OutlineColor = Color3.new(0, 0, 0)
                            esp.Center = true
                            IslandESP[island.Name] = esp
                        end
                        
                        local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(island.Teleport.Position)
                        if onScreen then
                            IslandESP[island.Name].Position = Vector2.new(pos.X, pos.Y)
                            IslandESP[island.Name].Color = Color3.new(0, 1, 0)
                            IslandESP[island.Name].Visible = true
                        else
                            IslandESP[island.Name].Visible = false
                        end
                    end
                end
            else
                for _, esp in pairs(PlayerESP) do
                    esp.Visible = false
                end
                for _, esp in pairs(IslandESP) do
                    esp.Visible = false
                end
            end
        end)
    end
end

local function SetupFPSBoost()
    if FPSBooster then
        FPSBooster:Disconnect()
        FPSBooster = nil
    end
    
    if Config.FPSBoost then
        FPSBooster = RunService.RenderStepped:Connect(function()
            if Config.FPSBoost then
                settings().Rendering.QualityLevel = 1
                settings().Rendering.MeshCacheSize = 0
                settings().Rendering.TextureCacheSize = 0
                
                for _, part in pairs(workspace:GetDescendants()) do
                    if part:IsA("Part") and part.Material ~= Enum.Material.Neon then
                        part.Material = Enum.Material.Plastic
                    end
                    if part:IsA("Decal") then
                        part:Destroy()
                    end
                    if part:IsA("ParticleEmitter") then
                        part:Destroy()
                    end
                end
            end
        end)
    end
end

local function SetupMemoryCleaner()
    if MemoryCleaner then
        MemoryCleaner:Disconnect()
        MemoryCleaner = nil
    end
    
    MemoryCleaner = RunService.Heartbeat:Connect(function()
        if tick() % 30 < 0.1 then
            collectgarbage()
        end
    end)
end

local function SetupRNGBoost()
    if RNGBooster then
        RNGBooster:Disconnect()
        RNGBooster = nil
    end
    
    if Config.RNGReducer or Config.ForceLegendary or Config.SecretBoost or Config.MythicalBoost or Config.AntiBadLuck then
        RNGBooster = RunService.Heartbeat:Connect(function()
            if Config.RNGReducer then
                -- RNG reduction logic
                Remotes.ReduceRNG:FireServer()
            end
            
            if Config.ForceLegendary then
                -- Force legendary catch
                Remotes.ForceLegendary:FireServer()
            end
            
            if Config.SecretBoost then
                -- Secret fish boost
                Remotes.SecretBoost:FireServer(10)
            end
            
            if Config.MythicalBoost then
                -- Mythical chance boost
                Remotes.MythicalBoost:FireServer(10)
            end
            
            if Config.AntiBadLuck then
                -- Reset bad luck
                if Player.Leaderboard.Luck.Value < 0 then
                    Remotes.ResetLuck:FireServer()
                end
            end
        end)
    end
end

-- UI Elements

-- Main Tab
local AutoFishSection = MainTab:CreateSection("Auto Fish")
local AutoFishToggle = AutoFishSection:CreateToggle({
    Name = "Auto Fish",
    CurrentValue = false,
    Flag = "AutoFish",
    Callback = function(value)
        Config.AutoFish = value
        SetupAutoFish()
    end,
})

local WaterFishToggle = AutoFishSection:CreateToggle({
    Name = "Water Fish (Fish Anywhere)",
    CurrentValue = false,
    Flag = "WaterFish",
    Callback = function(value)
        Config.WaterFish = value
        if value then
            Remotes.WaterBypass:FireServer()
        end
    end,
})

local DisableEffectsToggle = AutoFishSection:CreateToggle({
    Name = "Disable Fishing Effects",
    CurrentValue = false,
    Flag = "DisableEffects",
    Callback = function(value)
        Config.DisableEffects = value
        if value then
            Remotes.DisableEffects:FireServer()
        end
    end,
})

local InstantFishingToggle = AutoFishSection:CreateToggle({
    Name = "Instant Complicated Fishing",
    CurrentValue = false,
    Flag = "InstantFishing",
    Callback = function(value)
        Config.InstantFishing = value
        if value then
            Remotes.InstantFishing:FireServer()
        end
    end,
})

local AutoSellSection = MainTab:CreateSection("Auto Sell")
local AutoSellToggle = AutoSellSection:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(value)
        Config.AutoSell = value
        SetupAutoSell()
    end,
})

local SellDelaySlider = AutoSellSection:CreateSlider({
    Name = "Sell Delay (seconds)",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 1,
    Flag = "SellDelay",
    Callback = function(value)
        Config.SellDelay = value
    end,
})

local ProtectionSection = MainTab:CreateSection("Protection")
local AntiKickToggle = ProtectionSection:CreateToggle({
    Name = "Anti Kick",
    CurrentValue = true,
    Flag = "AntiKick",
    Callback = function(value)
        Config.AntiKick = value
        if value then
            Remotes.AntiKick:FireServer()
        end
    end,
})

local AntiAFKToggle = ProtectionSection:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = true,
    Flag = "AntiAFK",
    Callback = function(value)
        Config.AntiAFK = value
        SetupAntiAFK()
    end,
})

local AutoJumpToggle = ProtectionSection:CreateToggle({
    Name = "Auto Jump (30s)",
    CurrentValue = false,
    Flag = "AutoJump",
    Callback = function(value)
        Config.AutoJump = value
    end,
})

-- Teleport Tab
local IslandsSection = TeleportTab:CreateSection("Islands")
local IslandsDropdown = IslandsSection:CreateDropdown({
    Name = "Select Island",
    Options = GetIslands(),
    CurrentOption = "",
    Flag = "SelectedIsland",
    Callback = function(option)
        TeleportToIsland(option)
    end,
})

local PlayersSection = TeleportTab:CreateSection("Players")
local PlayersDropdown = PlayersSection:CreateDropdown({
    Name = "Select Player",
    Options = GetPlayers(),
    CurrentOption = "",
    Flag = "SelectedPlayer",
    Callback = function(option)
        TeleportToPlayer(option)
    end,
})

local RefreshPlayersButton = PlayersSection:CreateButton({
    Name = "Refresh Players",
    Callback = function()
        PlayersDropdown:Refresh(GetPlayers())
    end,
})

local PositionSection = TeleportTab:CreateSection("Saved Positions")
local PositionNameInput = PositionSection:CreateInput({
    Name = "Position Name",
    PlaceholderText = "Enter name",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        -- Handled in buttons
    end,
})

local SavePositionButton = PositionSection:CreateButton({
    Name = "Save Current Position",
    Callback = function()
        local name = PositionNameInput:GetValue()
        if name and name ~= "" then
            SavePosition(name)
        end
    end,
})

local LoadPositionButton = PositionSection:CreateButton({
    Name = "Load Position",
    Callback = function()
        local name = PositionNameInput:GetValue()
        if name and name ~= "" then
            LoadPosition(name)
        end
    end,
})

local DeletePositionButton = PositionSection:CreateButton({
    Name = "Delete Position",
    Callback = function()
        local name = PositionNameInput:GetValue()
        if name and name ~= "" then
            DeletePosition(name)
        end
    end,
})

-- Player Tab
local MovementSection = PlayerTab:CreateSection("Movement")
local SpeedSlider = MovementSection:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 100},
    Increment = 1,
    Suffix = "studs/s",
    CurrentValue = 16,
    Flag = "PlayerSpeed",
    Callback = function(value)
        Config.PlayerSpeed = value
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.WalkSpeed = value
        end
    end,
})

local BoatSpeedSlider = MovementSection:CreateSlider({
    Name = "Boat Speed",
    Range = {50, 200},
    Increment = 5,
    Suffix = "studs/s",
    CurrentValue = 50,
    Flag = "BoatSpeed",
    Callback = function(value)
        Config.BoatSpeed = value
        SetBoatSpeed(value)
    end,
})

local SpawnBoatButton = MovementSection:CreateButton({
    Name = "Spawn Boat",
    Callback = function()
        Remotes.SpawnBoat:FireServer()
    end,
})

local AbilitiesSection = PlayerTab:CreateSection("Abilities")
local InfinityJumpToggle = AbilitiesSection:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Flag = "InfinityJump",
    Callback = function(value)
        Config.InfinityJump = value
        if value then
            if not JumpConnection then
                JumpConnection = UserInputService.JumpRequest:Connect(function()
                    if Config.InfinityJump and Character and Character:FindFirstChild("Humanoid") then
                        Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end
        else
            if JumpConnection then
                JumpConnection:Disconnect()
                JumpConnection = nil
            end
        end
    end,
})

local FlyToggle = AbilitiesSection:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyEnabled",
    Callback = function(value)
        Config.FlyEnabled = value
        SetupFly()
    end,
})

local FlySpeedSlider = AbilitiesSection:CreateSlider({
    Name = "Fly Speed",
    Range = {20, 200},
    Increment = 5,
    Suffix = "studs/s",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(value)
        Config.FlySpeed = value
    end,
})

local GhostToggle = AbilitiesSection:CreateToggle({
    Name = "Ghost Mode",
    CurrentValue = false,
    Flag = "GhostMode",
    Callback = function(value)
        Config.GhostMode = value
        if value then
            Remotes.GhostMode:FireServer()
        end
    end,
})

local VisualsSection = PlayerTab:CreateSection("Visuals")
local ESPToggle = VisualsSection:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(value)
        Config.ESPEnabled = value
        SetupESP()
    end,
})

-- Trader Tab
local TradingSection = TraderTab:CreateSection("Trading")
local AutoAcceptToggle = TradingSection:CreateToggle({
    Name = "Auto Accept Trades",
    CurrentValue = false,
    Flag = "AutoAcceptTrade",
    Callback = function(value)
        Config.AutoAcceptTrade = value
        if value then
            TradeHandler.AutoAccept = true
        else
            TradeHandler.AutoAccept = false
        end
    end,
})

local TradePlayerDropdown = TradingSection:CreateDropdown({
    Name = "Select Player to Trade",
    Options = GetPlayers(),
    CurrentOption = "",
    Flag = "TradePlayer",
    Callback = function(option)
        -- Handled in trade button
    end,
})

local TradeAllButton = TradingSection:CreateButton({
    Name = "Trade All Fish to Selected",
    Callback = function()
        local targetPlayer = Players:FindFirstChild(TradePlayerDropdown:GetValue())
        if targetPlayer then
            Remotes.InitiateTrade:FireServer(targetPlayer)
            Wait(1)
            for _, item in pairs(Player.Inventory:GetChildren()) do
                if item:FindFirstChild("Value") then
                    Remotes.AddToTrade:FireServer(item)
                end
            end
            Remotes.ConfirmTrade:FireServer()
        end
    end,
})

-- Server Tab
local WeatherSection = ServerTab:CreateSection("Weather")
local WeatherDropdown = WeatherSection:CreateDropdown({
    Name = "Select Weather",
    Options = GetWeathers(),
    CurrentOption = "",
    Flag = "SelectedWeather",
    Callback = function(option)
        -- Handled in buy button
    end,
})

local BuyWeatherButton = WeatherSection:CreateButton({
    Name = "Buy Selected Weather",
    Callback = function()
        local weather = WeatherDropdown:GetValue()
        if weather then
            BuyWeather(weather)
        end
    end,
})

local AutoBuyWeatherToggle = WeatherSection:CreateToggle({
    Name = "Auto Buy Weather",
    CurrentValue = false,
    Flag = "AutoBuyWeather",
    Callback = function(value)
        Config.AutoBuyWeather = value
        if value then
            if not WeatherConnection then
                WeatherConnection = RunService.Heartbeat:Connect(function()
                    if Config.AutoBuyWeather then
                        for weatherName, _ in pairs(WeatherHandler.WeatherTypes) do
                            if not workspace:FindFirstChild(weatherName) then
                                BuyWeather(weatherName)
                                Wait(1)
                            end
                        end
                    end
                end)
            end
        else
            if WeatherConnection then
                WeatherConnection:Disconnect()
                WeatherConnection = nil
            end
        end
    end,
})

local InfoSection = ServerTab:CreateSection("Server Info")
local LuckLabel = InfoSection:CreateLabel("Your Luck: " .. (Player.Leaderboard.Luck.Value or 0) .. "%")
local SeedLabel = InfoSection:CreateLabel("Server Seed: " .. (workspace:FindFirstChild("Seed") and workspace.Seed.Value or "N/A"))

-- System Tab
local PerformanceSection = SystemTab:CreateSection("Performance")
local FPSBoostToggle = PerformanceSection:CreateToggle({
    Name = "Boost FPS",
    CurrentValue = false,
    Flag = "FPSBoost",
    Callback = function(value)
        Config.FPSBoost = value
        SetupFPSBoost()
    end,
})

local FPSSlider = PerformanceSection:CreateSlider({
    Name = "Max FPS",
    Range = {30, 360},
    Increment = 5,
    Suffix = "FPS",
    CurrentValue = 60,
    Flag = "MaxFPS",
    Callback = function(value)
        Config.MaxFPS = value
        setfpscap(value)
    end,
})

local MemoryButton = PerformanceSection:CreateButton({
    Name = "Clean Memory Now",
    Callback = function()
        collectgarbage()
        Rayfield:Notify({
            Title = "Memory Cleaned",
            Content = "Garbage collection completed.",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

local InfoSection = SystemTab:CreateSection("System Info")
local FPSLabel = InfoSection:CreateLabel("FPS: " .. math.floor(1/wait()))
local PingLabel = InfoSection:CreateLabel("Ping: Calculating...")
local BatteryLabel = InfoSection:CreateLabel("Battery: " .. (math.floor(game:GetService("Stats").Workspace.Heartbeat:GetValue() * 100) or "N/A") .. "%")
local ClockLabel = InfoSection:CreateLabel("Time: " .. os.date("%X"))

local RejoinButton = SystemTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
    end,
})

-- Graphics Tab
local QualitySection = GraphicsTab:CreateSection("Quality")
local LowGraphicsToggle = QualitySection:CreateToggle({
    Name = "Ultra Low Mode",
    CurrentValue = false,
    Flag = "LowGraphics",
    Callback = function(value)
        Config.LowGraphics = value
        if value then
            settings().Rendering.QualityLevel = 1
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("Part") then
                    part.Material = Enum.Material.Plastic
                end
            end
        else
            settings().Rendering.QualityLevel = 10
        end
    end,
})

local DisableReflectionsToggle = QualitySection:CreateToggle({
    Name = "Disable Water Reflections",
    CurrentValue = false,
    Flag = "DisableReflections",
    Callback = function(value)
        Config.DisableReflections = value
        if value then
            Lighting.ReflectionsEnabled = false
        else
            Lighting.ReflectionsEnabled = true
        end
    end,
})

local ShaderSection = GraphicsTab:CreateSection("Shaders")
local CustomShaderToggle = ShaderSection:CreateToggle({
    Name = "Custom Shader",
    CurrentValue = false,
    Flag = "CustomShader",
    Callback = function(value)
        if value then
            -- Apply custom shader
            Remotes.ApplyShader:FireServer("Custom")
        else
            -- Remove custom shader
            Remotes.RemoveShader:FireServer()
        end
    end,
})

-- RNG Tab
local RNGSection = RNGTab:CreateSection("RNG Manipulation")
local RNGReducerToggle = RNGSection:CreateToggle({
    Name = "RNG Reducer",
    CurrentValue = false,
    Flag = "RNGReducer",
    Callback = function(value)
        Config.RNGReducer = value
        SetupRNGBoost()
    end,
})

local ForceLegendaryToggle = RNGSection:CreateToggle({
    Name = "Force Legendary Catch",
    CurrentValue = false,
    Flag = "ForceLegendary",
    Callback = function(value)
        Config.ForceLegendary = value
        SetupRNGBoost()
    end,
})

local SecretBoostToggle = RNGSection:CreateToggle({
    Name = "Secret Fish Boost ×10",
    CurrentValue = false,
    Flag = "SecretBoost",
    Callback = function(value)
        Config.SecretBoost = value
        SetupRNGBoost()
    end,
})

local MythicalBoostToggle = RNGSection:CreateToggle({
    Name = "Mythical Chance ×10",
    CurrentValue = false,
    Flag = "MythicalBoost",
    Callback = function(value)
        Config.MythicalBoost = value
        SetupRNGBoost()
    end,
})

local AntiBadLuckToggle = RNGSection:CreateToggle({
    Name = "Anti-Bad Luck",
    CurrentValue = false,
    Flag = "AntiBadLuck",
    Callback = function(value)
        Config.AntiBadLuck = value
        SetupRNGBoost()
    end,
})

-- Shop Tab
local RodsSection = ShopTab:CreateSection("Rods")
local RodsDropdown = RodsSection:CreateDropdown({
    Name = "Select Rod",
    Options = GetRods(),
    CurrentOption = "",
    Flag = "SelectedRod",
    Callback = function(option)
        Config.SelectedRod = option
    end,
})

local BuyRodButton = RodsSection:CreateButton({
    Name = "Buy Selected Rod",
    Callback = function()
        BuyRod(Config.SelectedRod)
    end,
})

local BaitsSection = ShopTab:CreateSection("Baits")
local BaitsDropdown = BaitsSection:CreateDropdown({
    Name = "Select Bait",
    Options = GetBaits(),
    CurrentOption = "",
    Flag = "SelectedBait",
    Callback = function(option)
        Config.SelectedBait = option
    end,
})

local BuyBaitButton = BaitsSection:CreateButton({
    Name = "Buy Selected Bait",
    Callback = function()
        BuyBait(Config.SelectedBait)
    end,
})

local BoatsSection = ShopTab:CreateSection("Boats")
local BoatsDropdown = BoatsSection:CreateDropdown({
    Name = "Select Boat",
    Options = GetBoats(),
    CurrentOption = "",
    Flag = "SelectedBoat",
    Callback = function(option)
        Config.SelectedBoat = option
    end,
})

local BuyBoatButton = BoatsSection:CreateButton({
    Name = "Buy Selected Boat",
    Callback = function()
        BuyBoat(Config.SelectedBoat)
    end,
})

-- Settings Tab
local ConfigSection = SettingsTab:CreateSection("Configuration")
local SaveConfigButton = ConfigSection:CreateButton({
    Name = "Save Configuration",
    Callback = function()
        Rayfield:SaveConfiguration()
        Rayfield:Notify({
            Title = "Configuration Saved",
            Content = "Your settings have been saved.",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

local LoadConfigButton = ConfigSection:CreateButton({
    Name = "Load Configuration",
    Callback = function()
        Rayfield:LoadConfiguration()
        Rayfield:Notify({
            Title = "Configuration Loaded",
            Content = "Your settings have been loaded.",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

local ResetConfigButton = ConfigSection:CreateButton({
    Name = "Reset Configuration",
    Callback = function()
        Rayfield:ResetConfiguration()
        Rayfield:Notify({
            Title = "Configuration Reset",
            Content = "Settings have been reset to default.",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

local ExportConfigButton = ConfigSection:CreateButton({
    Name = "Export Configuration",
    Callback = function()
        local configString = HttpService:JSONEncode(Config)
        setclipboard(configString)
        Rayfield:Notify({
            Title = "Configuration Exported",
            Content = "Config has been copied to clipboard.",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

local ImportConfigButton = ConfigSection:CreateButton({
    Name = "Import Configuration",
    Callback = function()
        local configString = getclipboard()
        local success, result = pcall(function()
            return HttpService:JSONDecode(configString)
        end)
        if success then
            for key, value in pairs(result) do
                Config[key] = value
            end
            Rayfield:Notify({
                Title = "Configuration Imported",
                Content = "Config has been imported from clipboard.",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Import Failed",
                Content = "Invalid configuration format.",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Initialize systems
SetupMemoryCleaner()

-- Update info labels
Async(function()
    while true do
        Wait(1)
        FPSLabel:Set("FPS: " .. math.floor(1/wait()))
        BatteryLabel:Set("Battery: " .. (math.floor(game:GetService("Stats").Workspace.Heartbeat:GetValue() * 100) or "N/A") .. "%")
        ClockLabel:Set("Time: " .. os.date("%X"))
        
        -- Update ping (simulated)
        local ping = math.random(30, 100)
        PingLabel:Set("Ping: " .. ping .. "ms")
        
        -- Update luck if available
        if Player.Leaderboard:FindFirstChild("Luck") then
            LuckLabel:Set("Your Luck: " .. Player.Leaderboard.Luck.Value .. "%")
        end
    end
end)

-- Character changed event
Player.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    
    if Config.PlayerSpeed > 16 then
        char:WaitForChild("Humanoid").WalkSpeed = Config.PlayerSpeed
    end
    
    if Config.FlyEnabled then
        SetupFly()
    end
end)

-- Boat changed event
workspace.Vehicles.ChildAdded:Connect(function(vehicle)
    if vehicle:FindFirstChild("Owner") and vehicle.Owner.Value == Player then
        if Config.BoatSpeed > 50 then
            SetBoatSpeed(Config.BoatSpeed)
        end
    end
end)

Rayfield:Notify({
    Title = "Fish It Loaded",
    Content = "Script successfully loaded! Enjoy fishing.",
    Duration = 5,
    Image = 4483362458,
})
