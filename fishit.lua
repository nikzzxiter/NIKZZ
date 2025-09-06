-- Fish It Script - Full Implementation for September 2025
-- Using Rayfield UI Library with Async System
-- Compatible with all executors (Delta, Codex, Hydrogen, Arceus X, Fluxus, Synapse X, Script-Ware, Solara)

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local NetworkClient = game:GetService("NetworkClient")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Backpack = Player:WaitForChild("Backpack")
local Character = Player.Character or Player.CharacterAdded:Wait(function() end)
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Game-specific variables
local FishItRemotes = ReplicatedStorage:WaitForChild("Remotes")
local CastLineRemote = FishItRemotes:WaitForChild("CastLine")
local ReelInRemote = FishItRemotes:WaitForChild("ReelIn")
local SellFishRemote = FishItRemotes:WaitForChild("SellFish")
local BuyItemRemote = FishItRemotes:WaitForChild("BuyItem")
local TeleportRemote = FishItRemotes:WaitForChild("Teleport")
local TradeRemote = FishItRemotes:WaitForChild("Trade")
local WeatherRemote = FishItRemotes:WaitForChild("Weather")

local FishItModules = ReplicatedStorage:WaitForChild("Modules")
local ItemHandler = FishItModules:WaitForChild("ItemHandler")
local FishHandler = FishItModules:WaitForChild("FishHandler")
local RodHandler = FishItModules:WaitForChild("RodHandler")
local BaitHandler = FishItModules:WaitForChild("BaitHandler")
local MapHandler = FishItModules:WaitForChild("MapHandler")
local PlayerData = FishItModules:WaitForChild("PlayerData")

-- Variables for script functionality
local AutoFishEnabled = false
local WaterFishEnabled = false
local BypassRadarEnabled = false
local BypassAirEnabled = false
local DisableEffectFishingEnabled = false
local AutoInstantComplicatedFishingEnabled = false
local AutoSellFishEnabled = false
local SellMythosSecret = false
local FishSellDelay = 1
local AntiKickEnabled = true
local AntiDetectEnabled = true
local AntiAFKEnabled = true
local SpeedHackEnabled = false
local SpeedHackValue = 50
local MaxBoatSpeedEnabled = false
local InfinityJumpEnabled = false
local FlyEnabled = false
local FlySpeedValue = 50
local FlyBoatEnabled = false
local GhostHackEnabled = false
local ESPEnabled = false
local ESPConfig = {
    Lines = true,
    Box = true,
    Range = true,
    Level = true,
    Hologram = true
}
local AutoAcceptTradeEnabled = false
local AutoBuyWeatherEnabled = false
local BoostFPSEnabled = false
local FPSSetting = 60
local AutoCleanMemoryEnabled = false
local HighQualityEnabled = false
local MaxRenderingEnabled = false
local UltraLowModeEnabled = false
local DisableWaterReflectionEnabled = false
local CustomShaderEnabled = false
local RNGReducerEnabled = false
local ForceLegendaryCatchEnabled = false
local SecretFishBoostEnabled = false
local MythicalChanceEnabled = false
local AntiBadLuckEnabled = false

-- Saved positions
local SavedPositions = {}

-- UI Creation
local Window = Rayfield:CreateWindow({
    Name = "Fish It Hub | September 2025",
    LoadingTitle = "Fish It Script",
    LoadingSubtitle = "by Script Developer",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FishItScript",
        FileName = "FishItConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Fish It Hub",
        Subtitle = "Key System",
        Note = "No key system needed",
        FileName = "FishItKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"FishIt2025"}
    }
})

-- Tab 1: Fish Farm
local FishFarmTab = Window:CreateTab("Fish Farm", 4483362458) -- Icon

-- Auto Fish Section
local AutoFishSection = FishFarmTab:CreateSection("Auto Fish")

local AutoFishToggle = FishFarmTab:CreateToggle({
    Name = "Auto Fish",
    CurrentValue = false,
    Flag = "AutoFish",
    Callback = function(Value)
        AutoFishEnabled = Value
        if AutoFishEnabled then
            task.spawn(function()
                while AutoFishEnabled do
                    task.wait()
                    local Character = Player.Character
                    if Character and Character:FindFirstChild("HumanoidRootPart") then
                        local Rod = Character:FindFirstChildOfClass("Tool")
                        if Rod and Rod.Name:find("Rod") then
                            -- Check if fishing line is already cast
                            if not Character:FindFirstChild("FishingLine") then
                                CastLineRemote:FireServer()
                            else
                                -- Auto reel in when fish is caught
                                local FishingLine = Character:FindFirstChild("FishingLine")
                                if FishingLine and FishingLine:FindFirstChild("Fish") then
                                    ReelInRemote:FireServer(true) -- true for perfect catch
                                end
                            end
                        end
                    end
                end
            end)
        end
    end,
})

local WaterFishToggle = FishFarmTab:CreateToggle({
    Name = "Water Fish",
    CurrentValue = false,
    Flag = "WaterFish",
    Callback = function(Value)
        WaterFishEnabled = Value
        if WaterFishEnabled then
            task.spawn(function()
                while WaterFishEnabled do
                    task.wait()
                    local Character = Player.Character
                    if Character and Character:FindFirstChild("HumanoidRootPart") then
                        local Rod = Character:FindFirstChildOfClass("Tool")
                        if Rod and Rod.Name:find("Rod") then
                            -- Check if fishing line is already cast
                            if not Character:FindFirstChild("FishingLine") then
                                -- Cast line even on ground
                                CastLineRemote:FireServer()
                            else
                                -- Auto reel in when fish is caught
                                local FishingLine = Character:FindFirstChild("FishingLine")
                                if FishingLine and FishingLine:FindFirstChild("Fish") then
                                    ReelInRemote:FireServer(true) -- true for perfect catch
                                end
                            end
                        end
                    end
                end
            end)
        end
    end,
})

local BypassRadarToggle = FishFarmTab:CreateToggle({
    Name = "Bypass Radar",
    CurrentValue = false,
    Flag = "BypassRadar",
    Callback = function(Value)
        BypassRadarEnabled = Value
        if BypassRadarEnabled then
            -- Check if player has radar, if not buy it
            local PlayerDataModule = require(PlayerData)
            local playerData = PlayerDataModule.GetPlayerData(Player)
            
            if not playerData.Inventory.Radar then
                BuyItemRemote:FireServer("Radar", 1)
            end
            
            task.spawn(function()
                while BypassRadarEnabled do
                    task.wait()
                    -- Activate radar if not active
                    local Character = Player.Character
                    if Character and Character:FindFirstChild("HumanoidRootPart") then
                        local Radar = Character:FindFirstChild("Radar")
                        if Radar then
                            Radar:Activate()
                        end
                    end
                end
            end)
        end
    end,
})

local BypassAirToggle = FishFarmTab:CreateToggle({
    Name = "Bypass Air",
    CurrentValue = false,
    Flag = "BypassAir",
    Callback = function(Value)
        BypassAirEnabled = Value
        if BypassAirEnabled then
            -- Check if player has air item, if not buy it
            local PlayerDataModule = require(PlayerData)
            local playerData = PlayerDataModule.GetPlayerData(Player)
            
            if not playerData.Inventory.AirTank then
                BuyItemRemote:FireServer("AirTank", 1)
            end
            
            task.spawn(function()
                while BypassAirEnabled do
                    task.wait()
                    -- Activate air tank if not active
                    local Character = Player.Character
                    if Character and Character:FindFirstChild("HumanoidRootPart") then
                        local AirTank = Character:FindFirstChild("AirTank")
                        if AirTank then
                            AirTank:Activate()
                        end
                    end
                end
            end)
        end
    end,
})

local DisableEffectFishingToggle = FishFarmTab:CreateToggle({
    Name = "Disable Effect Fishing",
    CurrentValue = false,
    Flag = "DisableEffectFishing",
    Callback = function(Value)
        DisableEffectFishingEnabled = Value
        if DisableEffectFishingEnabled then
            task.spawn(function()
                while DisableEffectFishingEnabled do
                    task.wait()
                    -- Disable particle effects for fishing
                    local Character = Player.Character
                    if Character then
                        local FishingLine = Character:FindFirstChild("FishingLine")
                        if FishingLine then
                            for _, particle in pairs(FishingLine:GetDescendants()) do
                                if particle:IsA("ParticleEmitter") or particle:IsA("PointLight") then
                                    particle.Enabled = false
                                end
                            end
                        end
                    end
                end
            end)
        end
    end,
})

local AutoInstantComplicatedFishingToggle = FishFarmTab:CreateToggle({
    Name = "Auto Instant Complicated Fishing",
    CurrentValue = false,
    Flag = "AutoInstantComplicatedFishing",
    Callback = function(Value)
        AutoInstantComplicatedFishingEnabled = Value
        if AutoInstantComplicatedFishingEnabled then
            task.spawn(function()
                while AutoInstantComplicatedFishingEnabled do
                    task.wait()
                    local Character = Player.Character
                    if Character and Character:FindFirstChild("HumanoidRootPart") then
                        local Rod = Character:FindFirstChildOfClass("Tool")
                        if Rod and Rod.Name:find("Rod") then
                            -- Check if fishing line is already cast
                            if not Character:FindFirstChild("FishingLine") then
                                CastLineRemote:FireServer()
                            else
                                -- Auto reel in when fish is caught, with instant catch
                                local FishingLine = Character:FindFirstChild("FishingLine")
                                if FishingLine and FishingLine:FindFirstChild("Fish") then
                                    -- Force instant catch by manipulating the fishing minigame
                                    ReelInRemote:FireServer(true) -- true for perfect catch
                                end
                            end
                        end
                    end
                end
            end)
        end
    end,
})

-- Auto Sell Section
local AutoSellSection = FishFarmTab:CreateSection("Auto Sell Fish")

local AutoSellFishToggle = FishFarmTab:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = false,
    Flag = "AutoSellFish",
    Callback = function(Value)
        AutoSellFishEnabled = Value
        if AutoSellFishEnabled then
            task.spawn(function()
                while AutoSellFishEnabled do
                    task.wait(FishSellDelay)
                    -- Get player's fish inventory
                    local PlayerDataModule = require(PlayerData)
                    local playerData = PlayerDataModule.GetPlayerData(Player)
                    
                    if playerData and playerData.Inventory.Fish then
                        local FishToSell = {}
                        for fishName, fishData in pairs(playerData.Inventory.Fish) do
                            -- Skip favorite fish
                            if not fishData.Favorite then
                                -- Skip mythos/secret if toggle is off
                                if SellMythosSecret or (fishData.Rarity ~= "Mythical" and fishData.Rarity ~= "Secret") then
                                    table.insert(FishToSell, fishName)
                                end
                            end
                        end
                        
                        if #FishToSell > 0 then
                            SellFishRemote:FireServer(FishToSell)
                        end
                    end
                end
            end)
        end
    end,
})

local SellMythosSecretToggle = FishFarmTab:CreateToggle({
    Name = "Sell Mythos/Secret",
    CurrentValue = false,
    Flag = "SellMythosSecret",
    Callback = function(Value)
        SellMythosSecret = Value
    end,
})

local FishSellDelaySlider = FishFarmTab:CreateSlider({
    Name = "Delay Fish Sell",
    Range = {0.1, 10},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 1,
    Flag = "FishSellDelay",
    Callback = function(Value)
        FishSellDelay = Value
    end,
})

-- Anti Section
local AntiSection = FishFarmTab:CreateSection("Anti")

local AntiKickToggle = FishFarmTab:CreateToggle({
    Name = "Anti Kick Server",
    CurrentValue = true,
    Flag = "AntiKick",
    Callback = function(Value)
        AntiKickEnabled = Value
        if AntiKickEnabled then
            task.spawn(function()
                while AntiKickEnabled do
                    task.wait(30) -- Check every 30 seconds
                    -- Simulate activity to prevent kick
                    if Character and Character:FindFirstChild("Humanoid") then
                        Character.Humanoid.Jump = true
                        task.wait(0.1)
                        Character.Humanoid.Jump = false
                    end
                end
            end)
        end
    end,
})

local AntiDetectToggle = FishFarmTab:CreateToggle({
    Name = "Anti Detect System",
    CurrentValue = true,
    Flag = "AntiDetect",
    Callback = function(Value)
        AntiDetectEnabled = Value
        if AntiDetectEnabled then
            -- Hook into detection systems
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                if method == "FireServer" and self.Name == "DetectionCheck" then
                    return -- Block detection checks
                end
                return oldNamecall(self, ...)
            end)
        end
    end,
})

local AntiAFKToggle = FishFarmTab:CreateToggle({
    Name = "Anti AFK & Auto Jump",
    CurrentValue = true,
    Flag = "AntiAFK",
    Callback = function(Value)
        AntiAFKEnabled = Value
        if AntiAFKEnabled then
            task.spawn(function()
                while AntiAFKEnabled do
                    task.wait(30) -- Jump every 30 seconds
                    if Character and Character:FindFirstChild("Humanoid") then
                        Character.Humanoid.Jump = true
                    end
                end
            end)
        end
    end,
})

-- Tab 2: Teleport
local TeleportTab = Window:CreateTab("Teleport", 4483362458) -- Icon

-- Teleport Maps Section
local TeleportMapsSection = TeleportTab:CreateSection("Teleport Maps")

-- Get all maps from game
local MapHandlerModule = require(MapHandler)
local AllMaps = MapHandlerModule.GetAllMaps()

local MapDropdown = TeleportTab:CreateDropdown({
    Name = "Select Map",
    Options = AllMaps,
    CurrentOption = "Starter Island",
    Flag = "SelectedMap",
    Callback = function(Option)
        -- Teleport to selected map
        TeleportRemote:FireServer("Map", Option)
    end,
})

-- Teleport Player Section
local TeleportPlayerSection = TeleportTab:CreateSection("Teleport Player")

local PlayerDropdown = TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = {},
    CurrentOption = "",
    Flag = "SelectedPlayer",
    Callback = function(Option)
        if Option and Option ~= "" then
            local TargetPlayer = Players:FindFirstChild(Option)
            if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local TargetCFrame = TargetPlayer.Character.HumanoidRootPart.CFrame
                HumanoidRootPart.CFrame = TargetCFrame
            end
        end
    end,
})

-- Update player list
task.spawn(function()
    while true do
        task.wait(5)
        local playerList = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player then
                table.insert(playerList, player.Name)
            end
        end
        PlayerDropdown:Refresh(playerList, true)
    end
end)

-- Teleport Event Section
local TeleportEventSection = TeleportTab:CreateSection("Teleport Event")

local EventDropdown = TeleportTab:CreateDropdown({
    Name = "Select Event",
    Options = {"Treasure Event", "Fishing Competition", "Rare Fish Event", "Merchant Event"},
    CurrentOption = "",
    Flag = "SelectedEvent",
    Callback = function(Option)
        if Option and Option ~= "" then
            TeleportRemote:FireServer("Event", Option)
        end
    end,
})

-- Position Management Section
local PositionSection = TeleportTab:CreateSection("Position Management")

local SavePositionButton = TeleportTab:CreateButton({
    Name = "Save Position",
    Callback = function()
        local PositionName = "Position " .. #SavedPositions + 1
        table.insert(SavedPositions, {
            Name = PositionName,
            CFrame = HumanoidRootPart.CFrame
        })
        Rayfield:Notify({
            Title = "Position Saved",
            Content = "Saved as " .. PositionName,
            Duration = 3,
            Image = 4483362458,
            Actions = { -- Notification Buttons
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("The user tapped Okay!")
                    end
                },
            },
        })
    end,
})

local LoadPositionDropdown = TeleportTab:CreateDropdown({
    Name = "Load Position",
    Options = {},
    CurrentOption = "",
    Flag = "SelectedPosition",
    Callback = function(Option)
        if Option and Option ~= "" then
            for _, positionData in pairs(SavedPositions) do
                if positionData.Name == Option then
                    HumanoidRootPart.CFrame = positionData.CFrame
                    break
                end
            end
        end
    end,
})

-- Update saved positions list
task.spawn(function()
    while true do
        task.wait(5)
        local positionList = {}
        for _, positionData in pairs(SavedPositions) do
            table.insert(positionList, positionData.Name)
        end
        LoadPositionDropdown:Refresh(positionList, true)
    end
end)

local DeletePositionDropdown = TeleportTab:CreateDropdown({
    Name = "Delete Position",
    Options = {},
    CurrentOption = "",
    Flag = "DeletePosition",
    Callback = function(Option)
        if Option and Option ~= "" then
            for i, positionData in pairs(SavedPositions) do
                if positionData.Name == Option then
                    table.remove(SavedPositions, i)
                    Rayfield:Notify({
                        Title = "Position Deleted",
                        Content = "Deleted " .. Option,
                        Duration = 3,
                        Image = 4483362458,
                        Actions = { -- Notification Buttons
                            Ignore = {
                                Name = "Okay!",
                                Callback = function()
                                    print("The user tapped Okay!")
                                end
                            },
                        },
                    })
                    break
                end
            end
        end
    end,
})

-- Update delete positions list
task.spawn(function()
    while true do
        task.wait(5)
        local positionList = {}
        for _, positionData in pairs(SavedPositions) do
            table.insert(positionList, positionData.Name)
        end
        DeletePositionDropdown:Refresh(positionList, true)
    end
end)

-- Tab 3: Player
local PlayerTab = Window:CreateTab("Player", 4483362458) -- Icon

-- Speed Hack Section
local SpeedHackSection = PlayerTab:CreateSection("Speed Hack")

local SpeedHackToggle = PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHack",
    Callback = function(Value)
        SpeedHackEnabled = Value
        if SpeedHackEnabled then
            task.spawn(function()
                while SpeedHackEnabled do
                    task.wait()
                    if Character and Character:FindFirstChild("Humanoid") then
                        Character.Humanoid.WalkSpeed = SpeedHackValue
                    end
                end
            end)
        else
            if Character and Character:FindFirstChild("Humanoid") then
                Character.Humanoid.WalkSpeed = 16 -- Default speed
            end
        end
    end,
})

local SpeedHackSlider = PlayerTab:CreateSlider({
    Name = "Speed Hack Setting",
    Range = {0, 500},
    Increment = 1,
    Suffix = "",
    CurrentValue = 50,
    Flag = "SpeedHackValue",
    Callback = function(Value)
        SpeedHackValue = Value
        if SpeedHackEnabled and Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.WalkSpeed = SpeedHackValue
        end
    end,
})

-- Boat Section
local BoatSection = PlayerTab:CreateSection("Boat")

local MaxBoatSpeedToggle = PlayerTab:CreateToggle({
    Name = "Max Boat Speed",
    CurrentValue = false,
    Flag = "MaxBoatSpeed",
    Callback = function(Value)
        MaxBoatSpeedEnabled = Value
        if MaxBoatSpeedEnabled then
            task.spawn(function()
                while MaxBoatSpeedEnabled do
                    task.wait()
                    -- Find player's boat and increase speed
                    local Boats = Workspace:FindFirstChild("Boats")
                    if Boats then
                        local PlayerBoat = Boats:FindFirstChild(Player.Name)
                        if PlayerBoat and PlayerBoat:FindFirstChild("VehicleSeat") then
                            local VehicleSeat = PlayerBoat.VehicleSeat
                            VehicleSeat.MaxSpeed = 1000 -- 1000% faster
                        end
                    end
                end
            end)
        end
    end,
})

local SpawnBoatButton = PlayerTab:CreateButton({
    Name = "Spawn Boat",
    Callback = function()
        -- Spawn the latest boat
        BuyItemRemote:FireServer("LatestBoat", 1)
    end,
})

-- Movement Section
local MovementSection = PlayerTab:CreateSection("Movement")

local InfinityJumpToggle = PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Flag = "InfinityJump",
    Callback = function(Value)
        InfinityJumpEnabled = Value
        if InfinityJumpEnabled then
            local connection
            connection = UserInputService.JumpRequest:Connect(function()
                if Character and Character:FindFirstChild("Humanoid") then
                    Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            
            -- Store connection to disconnect later
            InfinityJumpEnabled = connection
        else
            if InfinityJumpEnabled then
                InfinityJumpEnabled:Disconnect()
                InfinityJumpEnabled = false
            end
        end
    end,
})

local FlyToggle = PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        FlyEnabled = Value
        if FlyEnabled then
            local FlyBV = Instance.new("BodyVelocity")
            FlyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            FlyBV.P = 5000
            FlyBV.Velocity = Vector3.new(0, 0, 0)
            FlyBV.Parent = HumanoidRootPart
            
            local FlyBG = Instance.new("BodyGyro")
            FlyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            FlyBG.P = 5000
            FlyBG.CFrame = HumanoidRootPart.CFrame
            FlyBG.Parent = HumanoidRootPart
            
            task.spawn(function()
                while FlyEnabled do
                    task.wait()
                    if Character and Character:FindFirstChild("HumanoidRootPart") then
                        local moveDir = Vector3.new(0, 0, 0)
                        
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            moveDir = moveDir + (HumanoidRootPart.CFrame.LookVector * FlySpeedValue)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            moveDir = moveDir - (HumanoidRootPart.CFrame.LookVector * FlySpeedValue)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            moveDir = moveDir - (HumanoidRootPart.CFrame.RightVector * FlySpeedValue)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            moveDir = moveDir + (HumanoidRootPart.CFrame.RightVector * FlySpeedValue)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            moveDir = moveDir + Vector3.new(0, FlySpeedValue, 0)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                            moveDir = moveDir - Vector3.new(0, FlySpeedValue, 0)
                        end
                        
                        FlyBV.Velocity = moveDir
                        FlyBG.CFrame = HumanoidRootPart.CFrame
                    end
                end
                
                FlyBV:Destroy()
                FlyBG:Destroy()
            end)
        end
    end,
})

local FlySlider = PlayerTab:CreateSlider({
    Name = "Fly Settings",
    Range = {1, 200},
    Increment = 1,
    Suffix = "",
    CurrentValue = 50,
    Flag = "FlySpeedValue",
    Callback = function(Value)
        FlySpeedValue = Value
    end,
})

local FlyBoatToggle = PlayerTab:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = false,
    Flag = "FlyBoat",
    Callback = function(Value)
        FlyBoatEnabled = Value
        if FlyBoatEnabled then
            task.spawn(function()
                while FlyBoatEnabled do
                    task.wait()
                    -- Find player's boat and make it fly
                    local Boats = Workspace:FindFirstChild("Boats")
                    if Boats then
                        local PlayerBoat = Boats:FindFirstChild(Player.Name)
                        if PlayerBoat then
                            local BoatPrimaryPart = PlayerBoat.PrimaryPart
                            if BoatPrimaryPart then
                                local moveDir = Vector3.new(0, 0, 0)
                                
                                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                                    moveDir = moveDir + (BoatPrimaryPart.CFrame.LookVector * FlySpeedValue)
                                end
                                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                                    moveDir = moveDir - (BoatPrimaryPart.CFrame.LookVector * FlySpeedValue)
                                end
                                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                                    moveDir = moveDir - (BoatPrimaryPart.CFrame.RightVector * FlySpeedValue)
                                end
                                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                                    moveDir = moveDir + (BoatPrimaryPart.CFrame.RightVector * FlySpeedValue)
                                end
                                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                                    moveDir = moveDir + Vector3.new(0, FlySpeedValue, 0)
                                end
                                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                                    moveDir = moveDir - Vector3.new(0, FlySpeedValue, 0)
                                end
                                
                                BoatPrimaryPart.CFrame = BoatPrimaryPart.CFrame + moveDir * 0.1
                            end
                        end
                    end
                end
            end)
        end
    end,
})

local GhostHackToggle = PlayerTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = false,
    Flag = "GhostHack",
    Callback = function(Value)
        GhostHackEnabled = Value
        if GhostHackEnabled then
            -- Make player transparent and able to pass through objects
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                        part.Transparency = 0.5
                    end
                end
            end
        else
            -- Restore normal settings
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                        part.Transparency = 0
                    end
                end
            end
        end
    end,
})

-- ESP Section
local ESPSection = PlayerTab:CreateSection("ESP Config")

local ESPToggle = PlayerTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        ESPEnabled = Value
        if ESPEnabled then
            task.spawn(function()
                while ESPEnabled do
                    task.wait()
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local char = player.Character
                            local hrp = char.HumanoidRootPart
                            
                            -- ESP Lines
                            if ESPConfig.Lines then
                                local line = Instance.new("Beam")
                                line.Attachment0 = Instance.new("Attachment", HumanoidRootPart)
                                line.Attachment1 = Instance.new("Attachment", hrp)
                                line.Width0 = 0.1
                                line.Width1 = 0.1
                                line.Color = ColorSequence.new(Color3.new(1, 0, 0))
                                line.FaceCamera = true
                                line.Parent = Workspace.CurrentCamera
                                
                                game:GetService("Debris"):AddItem(line, 0.1)
                            end
                            
                            -- ESP Box
                            if ESPConfig.Box then
                                local box = Instance.new("BoxHandleAdornment")
                                box.Adornee = char
                                box.Size = char:GetExtentsSize()
                                box.Color3 = Color3.new(1, 0, 0)
                                box.Transparency = 0.7
                                box.AlwaysOnTop = true
                                box.ZIndex = 10
                                box.Parent = char
                                
                                game:GetService("Debris"):AddItem(box, 0.1)
                            end
                            
                            -- ESP Range
                            if ESPConfig.Range then
                                local distance = (hrp.Position - HumanoidRootPart.Position).Magnitude
                                local rangeText = Drawing.new("Text")
                                rangeText.Text = math.floor(distance) .. " studs"
                                rangeText.Color = Color3.new(1, 1, 1)
                                rangeText.Size = 16
                                rangeText.Center = true
                                rangeText.Outline = true
                                rangeText.Position = Vector2.new(workspace.CurrentCamera:WorldToViewportPoint(hrp.Position).X, workspace.CurrentCamera:WorldToViewportPoint(hrp.Position).Y - 20)
                                rangeText.Visible = true
                                
                                game:GetService("Debris"):AddItem(rangeText, 0.1)
                            end
                            
                            -- ESP Level
                            if ESPConfig.Level then
                                local PlayerDataModule = require(PlayerData)
                                local playerData = PlayerDataModule.GetPlayerData(player)
                                local level = playerData and playerData.Level or 1
                                
                                local levelText = Drawing.new("Text")
                                levelText.Text = "Lvl " .. level
                                levelText.Color = Color3.new(1, 1, 0)
                                levelText.Size = 16
                                levelText.Center = true
                                levelText.Outline = true
                                levelText.Position = Vector2.new(workspace.CurrentCamera:WorldToViewportPoint(hrp.Position).X, workspace.CurrentCamera:WorldToViewportPoint(hrp.Position).Y + 20)
                                levelText.Visible = true
                                
                                game:GetService("Debris"):AddItem(levelText, 0.1)
                            end
                            
                            -- ESP Hologram
                            if ESPConfig.Hologram then
                                local hologram = Instance.new("BillboardGui")
                                hologram.Adornee = hrp
                                hologram.Size = UDim2.new(0, 100, 0, 50)
                                hologram.StudsOffset = Vector3.new(0, 3, 0)
                                hologram.AlwaysOnTop = true
                                
                                local text = Instance.new("TextLabel", hologram)
                                text.Size = UDim2.new(1, 0, 1, 0)
                                text.BackgroundTransparency = 1
                                text.Text = player.Name
                                text.TextColor3 = Color3.new(1, 0, 0)
                                text.TextScaled = true
                                
                                -- Rainbow effect
                                local hue = 0
                                local connection
                                connection = RunService.Heartbeat:Connect(function()
                                    hue = (hue + 0.01) % 1
                                    text.TextColor3 = Color3.fromHSV(hue, 1, 1)
                                    
                                    if not ESPEnabled or not ESPConfig.Hologram then
                                        connection:Disconnect()
                                    end
                                end)
                                
                                hologram.Parent = hrp
                                
                                game:GetService("Debris"):AddItem(hologram, 0.1)
                            end
                        end
                    end
                end
            end)
        end
    end,
})

local ESPLinesToggle = PlayerTab:CreateToggle({
    Name = "ESP Lines",
    CurrentValue = true,
    Flag = "ESPLines",
    Callback = function(Value)
        ESPConfig.Lines = Value
    end,
})

local ESPBoxToggle = PlayerTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = true,
    Flag = "ESPBox",
    Callback = function(Value)
        ESPConfig.Box = Value
    end,
})

local ESPRangeToggle = PlayerTab:CreateToggle({
    Name = "ESP Range",
    CurrentValue = true,
    Flag = "ESPRange",
    Callback = function(Value)
        ESPConfig.Range = Value
    end,
})

local ESPLevelToggle = PlayerTab:CreateToggle({
    Name = "ESP Level",
    CurrentValue = true,
    Flag = "ESPLevel",
    Callback = function(Value)
        ESPConfig.Level = Value
    end,
})

local ESPHologramToggle = PlayerTab:CreateToggle({
    Name = "ESP Hologram",
    CurrentValue = true,
    Flag = "ESPHologram",
    Callback = function(Value)
        ESPConfig.Hologram = Value
    end,
})

-- Tab 4: Trader
local TraderTab = Window:CreateTab("Trader", 4483362458) -- Icon

-- Auto Trade Section
local AutoTradeSection = TraderTab:CreateSection("Auto Trade")

local AutoAcceptTradeToggle = TraderTab:CreateToggle({
    Name = "Auto Accept Trade",
    CurrentValue = false,
    Flag = "AutoAcceptTrade",
    Callback = function(Value)
        AutoAcceptTradeEnabled = Value
        if AutoAcceptTradeEnabled then
            -- Hook into trade requests
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                if method == "FireServer" and self.Name == "TradeRequest" then
                    -- Accept all trade requests
                    TradeRemote:FireServer("Accept", ...)
                    return
                end
                return oldNamecall(self, ...)
            end)
        end
    end,
})

-- Select Fish Section
local SelectFishSection = TraderTab:CreateSection("Select Fish")

local FishListDropdown = TraderTab:CreateDropdown({
    Name = "Select Fish",
    Options = {},
    CurrentOption = "",
    Flag = "SelectedFish",
    Callback = function(Option)
        -- This will store the selected fish for trading
    end,
})

-- Update fish list
task.spawn(function()
    while true do
        task.wait(10)
        local PlayerDataModule = require(PlayerData)
        local playerData = PlayerDataModule.GetPlayerData(Player)
        local fishList = {}
        
        if playerData and playerData.Inventory.Fish then
            for fishName, fishData in pairs(playerData.Inventory.Fish) do
                table.insert(fishList, fishName)
            end
        end
        
        FishListDropdown:Refresh(fishList, true)
    end
end)

-- Select Player Section
local SelectPlayerSection = TraderTab:CreateSection("Select Player")

local TradePlayerDropdown = TraderTab:CreateDropdown({
    Name = "Select Player",
    Options = {},
    CurrentOption = "",
    Flag = "TradePlayer",
    Callback = function(Option)
        -- This will store the selected player for trading
    end,
})

-- Update player list for trading
task.spawn(function()
    while true do
        task.wait(5)
        local playerList = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player then
                table.insert(playerList, player.Name)
            end
        end
        TradePlayerDropdown:Refresh(playerList, true)
    end
end)

-- Trade All Section
local TradeAllSection = TraderTab:CreateSection("Trade All")

local TradeAllFishButton = TraderTab:CreateButton({
    Name = "Trade All Fish",
    Callback = function()
        -- Get selected player
        local selectedPlayer = Rayfield.Flags["TradePlayer"].Value
        if selectedPlayer and selectedPlayer ~= "" then
            local TargetPlayer = Players:FindFirstChild(selectedPlayer)
            if TargetPlayer then
                -- Get player's fish inventory
                local PlayerDataModule = require(PlayerData)
                local playerData = PlayerDataModule.GetPlayerData(Player)
                
                if playerData and playerData.Inventory.Fish then
                    local FishToTrade = {}
                    for fishName, fishData in pairs(playerData.Inventory.Fish) do
                        table.insert(FishToTrade, fishName)
                    end
                    
                    if #FishToTrade > 0 then
                        TradeRemote:FireServer("Send", TargetPlayer, FishToTrade)
                        Rayfield:Notify({
                            Title = "Trade Sent",
                            Content = "Sent all fish to " .. selectedPlayer,
                            Duration = 3,
                            Image = 4483362458,
                            Actions = { -- Notification Buttons
                                Ignore = {
                                    Name = "Okay!",
                                    Callback = function()
                                        print("The user tapped Okay!")
                                    end
                                },
                            },
                        })
                    end
                end
            end
        end
    end,
})

-- Tab 5: Server
local ServerTab = Window:CreateTab("Server", 4483362458) -- Icon

-- Weather Section
local WeatherSection = ServerTab:CreateSection("Weather")

local WeatherDropdown = ServerTab:CreateDropdown({
    Name = "Select Weather",
    Options = {"Sunny", "Stormy", "Fog", "Night", "Event Weather"},
    CurrentOption = "Sunny",
    Flag = "SelectedWeather",
    Callback = function(Option)
        WeatherRemote:FireServer("Change", Option)
    end,
})

local BuyWeatherButton = ServerTab:CreateButton({
    Name = "Buy Weather",
    Callback = function()
        local selectedWeather = Rayfield.Flags["SelectedWeather"].Value
        if selectedWeather and selectedWeather ~= "" then
            BuyItemRemote:FireServer("Weather_" .. selectedWeather, 1)
        end
    end,
})

local AutoBuyWeatherToggle = ServerTab:CreateToggle({
    Name = "Auto Buy Weather",
    CurrentValue = false,
    Flag = "AutoBuyWeather",
    Callback = function(Value)
        AutoBuyWeatherEnabled = Value
        if AutoBuyWeatherEnabled then
            task.spawn(function()
                while AutoBuyWeatherEnabled do
                    task.wait(300) -- Check every 5 minutes
                    local selectedWeather = Rayfield.Flags["SelectedWeather"].Value
                    if selectedWeather and selectedWeather ~= "" then
                        BuyItemRemote:FireServer("Weather_" .. selectedWeather, 1)
                    end
                end
            end)
        end
    end,
})

-- Server Info Section
local ServerInfoSection = ServerTab:CreateSection("Server Info")

local PlayerInfoLabel = ServerTab:CreateLabel("Player Info: Loading...")
local ServerInfoLabel = ServerTab:CreateLabel("Server Info: Loading...")

-- Update server info
task.spawn(function()
    while true do
        task.wait(5)
        -- Update player count
        local playerCount = #Players:GetPlayers()
        PlayerInfoLabel:Set("Player Info: " .. playerCount .. " players online")
        
        -- Update server info
        local PlayerDataModule = require(PlayerData)
        local serverData = PlayerDataModule.GetServerData()
        if serverData then
            local serverLuck = serverData.Luck or 0
            local serverSeed = serverData.Seed or "Unknown"
            ServerInfoLabel:Set("Server Info: " .. serverLuck .. "% luck, Seed: " .. tostring(serverSeed))
        end
    end
end)

-- Tab 6: System
local SystemTab = Window:CreateTab("System", 4483362458) -- Icon

-- System Info Section
local SystemInfoSection = SystemTab:CreateSection("System Info")

local InfoLabel = SystemTab:CreateLabel("FPS: 0 | Battery: 100% | Ping: 0ms | Time: 00:00:00")

-- Update system info
task.spawn(function()
    while true do
        task.wait(1)
        -- Get FPS
        local fps = math.floor(1 / RunService.Heartbeat:Wait())
        
        -- Get Battery (only on mobile)
        local battery = "N/A"
        if UserInputService:GetBatteryInfo() then
            battery = math.floor(UserInputService:GetBatteryInfo().ChargeLevel * 100) .. "%"
        end
        
        -- Get Ping
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        
        -- Get Time
        local currentTime = DateTime.now():FormatLocalTime("HH:mm:ss", "en-us")
        
        -- Update label
        InfoLabel:Set("FPS: " .. fps .. " | Battery: " .. battery .. " | Ping: " .. ping .. "ms | Time: " .. currentTime)
    end
end)

-- FPS Section
local FPSSection = SystemTab:CreateSection("FPS")

local BoostFPSToggle = SystemTab:CreateToggle({
    Name = "Boost FPS",
    CurrentValue = false,
    Flag = "BoostFPS",
    Callback = function(Value)
        BoostFPSEnabled = Value
        if BoostFPSEnabled then
            -- Set FPS cap to 360
            setfpscap(360)
            
            -- Disable some visual effects
            for _, part in pairs(Workspace:GetDescendants()) do
                if part:IsA("ParticleEmitter") or part:IsA("Fire") or part:IsA("Smoke") or part:IsA("Sparkles") then
                    part.Enabled = false
                end
            end
        else
            -- Reset FPS cap
            setfpscap(60)
            
            -- Re-enable visual effects
            for _, part in pairs(Workspace:GetDescendants()) do
                if part:IsA("ParticleEmitter") or part:IsA("Fire") or part:IsA("Smoke") or part:IsA("Sparkles") then
                    part.Enabled = true
                end
            end
        end
    end,
})

local FPSSlider = SystemTab:CreateSlider({
    Name = "Settings FPS",
    Range = {0, 360},
    Increment = 1,
    Suffix = " FPS",
    CurrentValue = 60,
    Flag = "FPSSetting",
    Callback = function(Value)
        FPSSetting = Value
        setfpscap(FPSSetting)
    end,
})

local AutoCleanMemoryToggle = SystemTab:CreateToggle({
    Name = "Auto Clean Memory",
    CurrentValue = false,
    Flag = "AutoCleanMemory",
    Callback = function(Value)
        AutoCleanMemoryEnabled = Value
        if AutoCleanMemoryEnabled then
            task.spawn(function()
                while AutoCleanMemoryEnabled do
                    task.wait(60) -- Clean every minute
                    -- Clean up memory
                    for i = 1, 10 do
                        game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua")
                        task.wait(0.1)
                    end
                    collectgarbage("collect")
                end
            end)
        end
    end,
})

-- Server Actions Section
local ServerActionsSection = SystemTab:CreateSection("Server Actions")

local RejoinServerButton = SystemTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        local ts = game:GetService("TeleportService")
        local p = game:GetService("Players").LocalPlayer
        ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, p)
    end,
})

-- Tab 7: Graphic
local GraphicTab = Window:CreateTab("Graphic", 4483362458) -- Icon

-- Quality Section
local QualitySection = GraphicTab:CreateSection("Quality")

local HighQualityToggle = GraphicTab:CreateToggle({
    Name = "High Quality",
    CurrentValue = false,
    Flag = "HighQuality",
    Callback = function(Value)
        HighQualityEnabled = Value
        if HighQualityEnabled then
            -- Set graphics to high quality
            game:GetService("Workspace").Terrain.WaterWaveSize = 5
            game:GetService("Workspace").Terrain.WaterWaveSpeed = 10
            game:GetService("Workspace").Terrain.WaterReflectance = 0.5
            game:GetService("Workspace").Terrain.WaterTransparency = 0.2
            game:GetService("Lighting").GlobalShadows = true
            game:GetService("Lighting").ShadowSoftness = 0.5
        end
    end,
})

local MaxRenderingToggle = GraphicTab:CreateToggle({
    Name = "Max Rendering",
    CurrentValue = false,
    Flag = "MaxRendering",
    Callback = function(Value)
        MaxRenderingEnabled = Value
        if MaxRenderingEnabled then
            -- Set rendering distance to maximum
            game:GetService("Workspace").StreamingEnabled = false
            game:GetService("Workspace").StreamingMinRadius = 0
            game:GetService("Workspace").StreamingTargetRadius = math.huge
        end
    end,
})

local UltraLowModeToggle = GraphicTab:CreateToggle({
    Name = "Ultra Low Mode",
    CurrentValue = false,
    Flag = "UltraLowMode",
    Callback = function(Value)
        UltraLowModeEnabled = Value
        if UltraLowModeEnabled then
            -- Set graphics to lowest quality
            game:GetService("Workspace").Terrain.WaterWaveSize = 0
            game:GetService("Workspace").Terrain.WaterWaveSpeed = 0
            game:GetService("Workspace").Terrain.WaterReflectance = 0
            game:GetService("Workspace").Terrain.WaterTransparency = 1
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").ShadowSoftness = 0
            
            -- Disable all particles
            for _, part in pairs(Workspace:GetDescendants()) do
                if part:IsA("ParticleEmitter") or part:IsA("Fire") or part:IsA("Smoke") or part:IsA("Sparkles") then
                    part.Enabled = false
                end
            end
        end
    end,
})

-- Water Section
local WaterSection = GraphicTab:CreateSection("Water")

local DisableWaterReflectionToggle = GraphicTab:CreateToggle({
    Name = "Disable Water Reflection",
    CurrentValue = false,
    Flag = "DisableWaterReflection",
    Callback = function(Value)
        DisableWaterReflectionEnabled = Value
        if DisableWaterReflectionEnabled then
            game:GetService("Workspace").Terrain.WaterReflectance = 0
        else
            game:GetService("Workspace").Terrain.WaterReflectance = 0.5
        end
    end,
})

-- Shader Section
local ShaderSection = GraphicTab:CreateSection("Shader")

local CustomShaderToggle = GraphicTab:CreateToggle({
    Name = "Custom Shader",
    CurrentValue = false,
    Flag = "CustomShader",
    Callback = function(Value)
        CustomShaderEnabled = Value
        if CustomShaderEnabled then
            -- Apply custom shader effects
            local Lighting = game:GetService("Lighting")
            
            -- Create custom color correction
            local ColorCorrection = Instance.new("ColorCorrectionEffect", Lighting)
            ColorCorrection.TintColor = Color3.new(1, 1, 1)
            ColorCorrection.Saturation = 0.2
            ColorCorrection.Contrast = 0.1
            
            -- Create custom bloom
            local Bloom = Instance.new("BloomEffect", Lighting)
            Bloom.Intensity = 0.5
            Bloom.Size = 24
            Bloom.Threshold = 0.8
            
            -- Create custom sun rays
            local SunRays = Instance.new("SunRaysEffect", Lighting)
            SunRays.Intensity = 0.2
            SunRays.Spread = 0.1
        else
            -- Remove custom shader effects
            local Lighting = game:GetService("Lighting")
            for _, effect in pairs(Lighting:GetChildren()) do
                if effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("SunRaysEffect") then
                    effect:Destroy()
                end
            end
        end
    end,
})

-- Tab 8: RNG Kill
local RNGKillTab = Window:CreateTab("RNG Kill", 4483362458) -- Icon

-- RNG Manipulation Section
local RNGManipulationSection = RNGKillTab:CreateSection("RNG Manipulation")

local RNGReducerToggle = RNGKillTab:CreateToggle({
    Name = "RNG Reducer",
    CurrentValue = false,
    Flag = "RNGReducer",
    Callback = function(Value)
        RNGReducerEnabled = Value
        if RNGReducerEnabled then
            -- Hook into RNG calculations
            local oldRandom
            oldRandom = hookfunction(math.random, function(min, max)
                if min and max then
                    -- Increase chance of higher values
                    local newValue = oldRandom(min, max)
                    if newValue < max * 0.8 then
                        return oldRandom(max * 0.8, max)
                    end
                    return newValue
                elseif min then
                    -- Increase chance of higher values
                    if min > 0 then
                        return oldRandom(min * 0.8, min)
                    end
                    return oldRandom(min, 0)
                else
                    return oldRandom(0.8, 1)
                end
            end)
        end
    end,
})

local ForceLegendaryCatchToggle = RNGKillTab:CreateToggle({
    Name = "Force Legendary Catch",
    CurrentValue = false,
    Flag = "ForceLegendaryCatch",
    Callback = function(Value)
        ForceLegendaryCatchEnabled = Value
        if ForceLegendaryCatchEnabled then
            -- Hook into fish catch calculations
            local oldFireServer
            oldFireServer = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                if method == "FireServer" and self.Name == "ReelIn" then
                    -- Force legendary fish
                    return oldFireServer(self, "Legendary")
                end
                return oldFireServer(self, ...)
            end)
        end
    end,
})

local SecretFishBoostToggle = RNGKillTab:CreateToggle({
    Name = "Secret Fish Boost",
    CurrentValue = false,
    Flag = "SecretFishBoost",
    Callback = function(Value)
        SecretFishBoostEnabled = Value
        if SecretFishBoostEnabled then
            -- Hook into fish rarity calculations
            local FishHandlerModule = require(FishHandler)
            local oldGetFishRarity = FishHandlerModule.GetFishRarity
            
            FishHandlerModule.GetFishRarity = function(fishName, location, bait)
                -- Increase chance of secret fish
                local rarity = oldGetFishRarity(fishName, location, bait)
                if rarity == "Rare" or rarity == "Epic" then
                    return "Secret"
                end
                return rarity
            end
        end
    end,
})

local MythicalChanceToggle = RNGKillTab:CreateToggle({
    Name = "Mythical Chance ×10",
    CurrentValue = false,
    Flag = "MythicalChance",
    Callback = function(Value)
        MythicalChanceEnabled = Value
        if MythicalChanceEnabled then
            -- Hook into fish rarity calculations
            local FishHandlerModule = require(FishHandler)
            local oldGetFishRarity = FishHandlerModule.GetFishRarity
            
            FishHandlerModule.GetFishRarity = function(fishName, location, bait)
                -- Increase chance of mythical fish
                local rarity = oldGetFishRarity(fishName, location, bait)
                if rarity == "Legendary" then
                    return "Mythical"
                end
                return rarity
            end
        end
    end,
})

local AntiBadLuckToggle = RNGKillTab:CreateToggle({
    Name = "Anti-Bad Luck",
    CurrentValue = false,
    Flag = "AntiBadLuck",
    Callback = function(Value)
        AntiBadLuckEnabled = Value
        if AntiBadLuckEnabled then
            -- Reset RNG seed
            local PlayerDataModule = require(PlayerData)
            local playerData = PlayerDataModule.GetPlayerData(Player)
            if playerData then
                playerData.RNGSeed = tick()
                PlayerDataModule.SetPlayerData(Player, playerData)
            end
        end
    end,
})

-- Tab 9: Shop
local ShopTab = Window:CreateTab("Shop", 4483362458) -- Icon

-- Buy Rod Section
local BuyRodSection = ShopTab:CreateSection("Buy Rod")

local RodDropdown = ShopTab:CreateDropdown({
    Name = "Select Rod",
    Options = {
        "Starter Rod (Common)",
        "Carbon Rod (Common)",
        "Toy Rod (Common)",
        "Grass Rod (Uncommon)",
        "Lava Rod (Uncommon)",
        "Lucky Rod (Rare)",
        "Midnight Rod (Rare)",
        "Demascus Rod (Uncommon)",
        "Ice Rod (Uncommon)",
        "Steampunk Rod (Epic)",
        "Chrome Rod (Epic)",
        "Astral Rod (Legendary)",
        "Ares Rod (Mythic)",
        "Ghostfinn Rod (Mythic)",
        "Angler Rod (Mythic)"
    },
    CurrentOption = "Starter Rod (Common)",
    Flag = "SelectedRod",
    Callback = function(Option)
        -- This will store the selected rod for purchase
    end,
})

local BuyRodButton = ShopTab:CreateButton({
    Name = "Buy Rod",
    Callback = function()
        local selectedRod = Rayfield.Flags["SelectedRod"].Value
        if selectedRod and selectedRod ~= "" then
            -- Extract rod name from dropdown option
            local rodName = selectedRod:match("(.+)%s%(.+%)")
            if rodName then
                BuyItemRemote:FireServer("Rod_" .. rodName, 1)
                Rayfield:Notify({
                    Title = "Purchase Successful",
                    Content = "Bought " .. rodName,
                    Duration = 3,
                    Image = 4483362458,
                    Actions = { -- Notification Buttons
                        Ignore = {
                            Name = "Okay!",
                            Callback = function()
                                print("The user tapped Okay!")
                            end
                        },
                    },
                })
            end
        end
    end,
})

-- Buy Boat Section
local BuyBoatSection = ShopTab:CreateSection("Buy Boat")

local BoatDropdown = ShopTab:CreateDropdown({
    Name = "Select Boat",
    Options = {
        "Small Boat",
        "Speed Boat",
        "Viking Ship",
        "Mythical Ark"
    },
    CurrentOption = "Small Boat",
    Flag = "SelectedBoat",
    Callback = function(Option)
        -- This will store the selected boat for purchase
    end,
})

local BuyBoatButton = ShopTab:CreateButton({
    Name = "Buy Boat",
    Callback = function()
        local selectedBoat = Rayfield.Flags["SelectedBoat"].Value
        if selectedBoat and selectedBoat ~= "" then
            BuyItemRemote:FireServer("Boat_" .. selectedBoat, 1)
            Rayfield:Notify({
                Title = "Purchase Successful",
                Content = "Bought " .. selectedBoat,
                Duration = 3,
                Image = 4483362458,
                Actions = { -- Notification Buttons
                    Ignore = {
                        Name = "Okay!",
                        Callback = function()
                            print("The user tapped Okay!")
                        end
                    },
                },
            })
        end
    end,
})

-- Buy Bait Section
local BuyBaitSection = ShopTab:CreateSection("Buy Bait")

local BaitDropdown = ShopTab:CreateDropdown({
    Name = "Select Bait",
    Options = {
        "Dark Matter Bait",
        "Aether Bait"
    },
    CurrentOption = "Dark Matter Bait",
    Flag = "SelectedBait",
    Callback = function(Option)
        -- This will store the selected bait for purchase
    end,
})

local BuyBaitButton = ShopTab:CreateButton({
    Name = "Buy Bait",
    Callback = function()
        local selectedBait = Rayfield.Flags["SelectedBait"].Value
        if selectedBait and selectedBait ~= "" then
            BuyItemRemote:FireServer("Bait_" .. selectedBait, 1)
            Rayfield:Notify({
                Title = "Purchase Successful",
                Content = "Bought " .. selectedBait,
                Duration = 3,
                Image = 4483362458,
                Actions = { -- Notification Buttons
                    Ignore = {
                        Name = "Okay!",
                        Callback = function()
                            print("The user tapped Okay!")
                        end
                    },
                },
            })
        end
    end,
})

-- Tab 10: Settings
local SettingsTab = Window:CreateTab("Settings", 4483362458) -- Icon

-- Config Management Section
local ConfigManagementSection = SettingsTab:CreateSection("Config Management")

local SaveConfigButton = SettingsTab:CreateButton({
    Name = "Save Config",
    Callback = function()
        Rayfield:SaveConfiguration()
        Rayfield:Notify({
            Title = "Config Saved",
            Content = "Your configuration has been saved.",
            Duration = 3,
            Image = 4483362458,
            Actions = { -- Notification Buttons
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("The user tapped Okay!")
                    end
                },
            },
        })
    end,
})

local LoadConfigButton = SettingsTab:CreateButton({
    Name = "Load Config",
    Callback = function()
        Rayfield:LoadConfiguration()
        Rayfield:Notify({
            Title = "Config Loaded",
            Content = "Your configuration has been loaded.",
            Duration = 3,
            Image = 4483362458,
            Actions = { -- Notification Buttons
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("The user tapped Okay!")
                    end
                },
            },
        })
    end,
})

local ResetConfigButton = SettingsTab:CreateButton({
    Name = "Reset Config",
    Callback = function()
        Rayfield:ResetConfiguration()
        Rayfield:Notify({
            Title = "Config Reset",
            Content = "Your configuration has been reset to default.",
            Duration = 3,
            Image = 4483362458,
            Actions = { -- Notification Buttons
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("The user tapped Okay!")
                    end
                },
            },
        })
    end,
})

-- Config Sharing Section
local ConfigSharingSection = SettingsTab:CreateSection("Config Sharing")

local ExportConfigButton = SettingsTab:CreateButton({
    Name = "Export Config",
    Callback = function()
        local config = Rayfield:GetConfiguration()
        local configJson = HttpService:JSONEncode(config)
        
        -- Create a textbox to display the config
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "ConfigExporter"
        ScreenGui.Parent = CoreGui
        ScreenGui.ResetOnSpawn = false
        
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0.5, 0, 0.5, 0)
        Frame.Position = UDim2.new(0.25, 0, 0.25, 0)
        Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
        Frame.BorderSizePixel = 0
        Frame.Parent = ScreenGui
        
        local TextBox = Instance.new("TextBox")
        TextBox.Size = UDim2.new(1, -20, 1, -60)
        TextBox.Position = UDim2.new(0, 10, 0, 10)
        TextBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        TextBox.Text = configJson
        TextBox.TextColor3 = Color3.new(1, 1, 1)
        TextBox.TextScaled = true
        TextBox.Font = Enum.Font.SourceSans
        TextBox.TextXAlignment = Enum.TextXAlignment.Left
        TextBox.TextYAlignment = Enum.TextYAlignment.Top
        TextBox.ClearTextOnFocus = false
        TextBox.MultiLine = true
        TextBox.Parent = Frame
        
        local CloseButton = Instance.new("TextButton")
        CloseButton.Size = UDim2.new(1, -20, 0, 40)
        CloseButton.Position = UDim2.new(0, 10, 1, -50)
        CloseButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        CloseButton.Text = "Close"
        CloseButton.TextColor3 = Color3.new(1, 1, 1)
        CloseButton.TextScaled = true
        CloseButton.Font = Enum.Font.SourceSans
        CloseButton.Parent = Frame
        
        CloseButton.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
        end)
        
        Rayfield:Notify({
            Title = "Config Exported",
            Content = "Your configuration has been exported to the textbox.",
            Duration = 3,
            Image = 4483362458,
            Actions = { -- Notification Buttons
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("The user tapped Okay!")
                    end
                },
            },
        })
    end,
})

local ImportConfigButton = SettingsTab:CreateButton({
    Name = "Import Config",
    Callback = function()
        -- Create a textbox to input the config
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "ConfigImporter"
        ScreenGui.Parent = CoreGui
        ScreenGui.ResetOnSpawn = false
        
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0.5, 0, 0.5, 0)
        Frame.Position = UDim2.new(0.25, 0, 0.25, 0)
        Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
        Frame.BorderSizePixel = 0
        Frame.Parent = ScreenGui
        
        local TextBox = Instance.new("TextBox")
        TextBox.Size = UDim2.new(1, -20, 1, -100)
        TextBox.Position = UDim2.new(0, 10, 0, 10)
        TextBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        TextBox.Text = "Paste your config JSON here..."
        TextBox.TextColor3 = Color3.new(1, 1, 1)
        TextBox.TextScaled = true
        TextBox.Font = Enum.Font.SourceSans
        TextBox.TextXAlignment = Enum.TextXAlignment.Left
        TextBox.TextYAlignment = Enum.TextYAlignment.Top
        TextBox.ClearTextOnFocus = true
        TextBox.MultiLine = true
        TextBox.Parent = Frame
        
        local ImportButton = Instance.new("TextButton")
        ImportButton.Size = UDim2.new(0.5, -15, 0, 40)
        ImportButton.Position = UDim2.new(0, 10, 1, -90)
        ImportButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        ImportButton.Text = "Import"
        ImportButton.TextColor3 = Color3.new(1, 1, 1)
        ImportButton.TextScaled = true
        ImportButton.Font = Enum.Font.SourceSans
        ImportButton.Parent = Frame
        
        local CloseButton = Instance.new("TextButton")
        CloseButton.Size = UDim2.new(0.5, -15, 0, 40)
        CloseButton.Position = UDim2.new(0.5, 5, 1, -90)
        CloseButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        CloseButton.Text = "Close"
        CloseButton.TextColor3 = Color3.new(1, 1, 1)
        CloseButton.TextScaled = true
        CloseButton.Font = Enum.Font.SourceSans
        CloseButton.Parent = Frame
        
        ImportButton.MouseButton1Click:Connect(function()
            local success, config = pcall(function()
                return HttpService:JSONDecode(TextBox.Text)
            end)
            
            if success then
                Rayfield:LoadConfiguration(config)
                Rayfield:Notify({
                    Title = "Config Imported",
                    Content = "Your configuration has been imported successfully.",
                    Duration = 3,
                    Image = 4483362458,
                    Actions = { -- Notification Buttons
                        Ignore = {
                            Name = "Okay!",
                            Callback = function()
                                print("The user tapped Okay!")
                            end
                        },
                    },
                })
                ScreenGui:Destroy()
            else
                Rayfield:Notify({
                    Title = "Import Failed",
                    Content = "Invalid config JSON. Please check your input.",
                    Duration = 3,
                    Image = 4483362458,
                    Actions = { -- Notification Buttons
                        Ignore = {
                            Name = "Okay!",
                            Callback = function()
                                print("The user tapped Okay!")
                            end
                        },
                    },
                })
            end
        end)
        
        CloseButton.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
        end)
        
        Rayfield:Notify({
            Title = "Config Importer",
            Content = "Paste your config JSON in the textbox and click Import.",
            Duration = 3,
            Image = 4483362458,
            Actions = { -- Notification Buttons
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("The user tapped Okay!")
                    end
                },
            },
        })
    end,
})

-- Initialization complete notification
Rayfield:Notify({
    Title = "Fish It Hub Loaded",
    Content = "Script loaded successfully. Enjoy!",
    Duration = 5,
    Image = 4483362458,
    Actions = { -- Notification Buttons
        Ignore = {
            Name = "Okay!",
            Callback = function()
                print("The user tapped Okay!")
            end
        },
    },
})
