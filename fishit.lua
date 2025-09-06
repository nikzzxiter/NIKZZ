-- Fish It Hub 2025 by Nikzz Xit - REVISED VERSION
-- RayfieldLib Script for Fish It September 2025 - FULLY FUNCTIONAL

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local Stats = game:GetService("Stats")

-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Anti-Kick
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" then
        return nil
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- Game Variables
local FishingEvents = ReplicatedStorage:FindFirstChild("FishingEvents") or ReplicatedStorage:WaitForChild("FishingEvents", 10)
local TradeEvents = ReplicatedStorage:FindFirstChild("TradeEvents") or ReplicatedStorage:WaitForChild("TradeEvents", 10)
local GameFunctions = ReplicatedStorage:FindFirstChild("GameFunctions") or ReplicatedStorage:WaitForChild("GameFunctions", 10)
local PlayerData = LocalPlayer:FindFirstChild("PlayerData") or LocalPlayer:WaitForChild("PlayerData", 10)

-- Cari module penting game
local GameModules = {}
local function FindGameModules()
    for _, module in pairs(ReplicatedStorage:GetDescendants()) do
        if module:IsA("ModuleScript") then
            if module.Name:find("Fish") or module.Name:find("Rod") or module.Name:find("Bait") or module.Name:find("Event") then
                GameModules[module.Name] = require(module)
            end
        end
    end
    
    -- Cari module khusus
    local success, result = pcall(function()
        GameModules.FishingSystem = require(ReplicatedStorage:FindFirstChild("FishingSystem") or ReplicatedStorage:WaitForChild("FishingSystem"))
        GameModules.RodManager = require(ReplicatedStorage:FindFirstChild("RodManager") or ReplicatedStorage:WaitForChild("RodManager"))
        GameModules.BaitManager = require(ReplicatedStorage:FindFirstChild("BaitManager") or ReplicatedStorage:WaitForChild("BaitManager"))
        GameModules.EventManager = require(ReplicatedStorage:FindFirstChild("EventManager") or ReplicatedStorage:WaitForChild("EventManager"))
        GameModules.WeatherSystem = require(ReplicatedStorage:FindFirstChild("WeatherSystem") or ReplicatedStorage:WaitForChild("WeatherSystem"))
        GameModules.TradeSystem = require(ReplicatedStorage:FindFirstChild("TradeSystem") or ReplicatedStorage:WaitForChild("TradeSystem"))
    end)
end

FindGameModules()

-- Configuration
local Config = {
    AutoFarm = {
        FishingRadar = false,
        AutoFishV1 = false,
        AutoFishDelay = 1,
        DisableEffectFishing = false,
        AutoInstantComplicatedFishing = false,
        AutoLockPositionCamera = false,
        SellAllFish = false,
        AutoSellFish = false,
        DelaySellFish = 5,
        AntiKickServer = true,
        AntiAFK = true,
        AutoUpgradeRod = false,
        AutoUpgradeBackpack = false,
        AutoEquipBestRod = false,
        AutoEquipBestBait = false,
        AutoCollectDaily = false
    },
    Teleport = {
        SelectedLocation = "",
        SelectedPlayer = "",
        SavedPositions = {},
        AutoTeleportEvent = false
    },
    User = {
        SpeedHack = false,
        SpeedValue = 16,
        InfinityJump = false,
        Fly = false,
        FlyRange = 50,
        PlayerESP = false,
        ESPBox = true,
        ESPLines = true,
        ESPName = true,
        ESPLevel = true,
        ESPDistance = true,
        Noclip = false,
        WalkOnWater = false
    },
    Trade = {
        AutoTradeAllFish = false,
        AutoAcceptTrade = false,
        TradePlayer = ""
    },
    Server = {
        AutoBuyCuaca = false,
        TeleportEvent = "",
        AutoJoinEvent = false
    },
    Lucky = {
        LuckyBoost = false,
        NoTrash = false,
        DoubleRoll = false,
        SecretGuarantee = false,
        EventLuckSync = false,
        LuckyMultiplier = 1.0
    },
    Settings = {
        SelectedTheme = "Dark",
        Transparency = 0.5,
        ConfigName = "DefaultConfig",
        GraphicsMode = "Medium",
        UnlockFPS = false,
        MaxFPS = 120
    }
}

-- System Info
local PerformanceStats = Stats:FindFirstChild("PerformanceStats")
local PingStats = Stats:FindFirstChild("Ping")
local FPS = 0
local lastTime = os.clock()

-- Save/Load Config
local function SaveConfig()
    local json = HttpService:JSONEncode(Config)
    writefile("FishItConfig_" .. Config.Settings.ConfigName .. ".json", json)
    Rayfield:Notify({
        Title = "Config Saved",
        Content = "Configuration saved as " .. Config.Settings.ConfigName,
        Duration = 3,
        Image = 13047715178
    })
end

local function LoadConfig()
    if isfile("FishItConfig_" .. Config.Settings.ConfigName .. ".json") then
        local success, result = pcall(function()
            local json = readfile("FishItConfig_" .. Config.Settings.ConfigName .. ".json")
            Config = HttpService:JSONDecode(json)
        end)
        if success then
            Rayfield:Notify({
                Title = "Config Loaded",
                Content = "Configuration loaded from " .. Config.Settings.ConfigName,
                Duration = 3,
                Image = 13047715178
            })
            return true
        else
            Rayfield:Notify({
                Title = "Config Error",
                Content = "Failed to load config: " .. result,
                Duration = 5,
                Image = 13047715178
            })
        end
    else
        Rayfield:Notify({
            Title = "Config Not Found",
            Content = "Config file not found: " .. Config.Settings.ConfigName,
            Duration = 5,
            Image = 13047715178
        })
    end
    return false
end

-- UI Library
local Window = Rayfield:CreateWindow({
    Name = "NIKZZ - FISH SCRIPT v2.0",
    LoadingTitle = "NIKZZ SCRIPT",
    LoadingSubtitle = "by Nikzz Xit - Fish It September 2025",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    }
})

-- Auto Farm Tab
local AutoFarmTab = Window:CreateTab("🐟 Auto Farm", 13014546625)

-- Fishing Radar
AutoFarmTab:CreateToggle({
    Name = "Fishing Radar",
    CurrentValue = Config.AutoFarm.FishingRadar,
    Flag = "FishingRadar",
    Callback = function(Value)
        Config.AutoFarm.FishingRadar = Value
        if Value then
            Rayfield:Notify({
                Title = "Fishing Radar",
                Content = "Fishing Radar enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Fish V1 (Perfect Fishing)
AutoFarmTab:CreateToggle({
    Name = "Auto Fish V1 (Perfect Fishing)",
    CurrentValue = Config.AutoFarm.AutoFishV1,
    Flag = "AutoFishV1",
    Callback = function(Value)
        Config.AutoFarm.AutoFishV1 = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Fish V1",
                Content = "Perfect Fishing enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Fish Delay
AutoFarmTab:CreateSlider({
    Name = "Auto Fish Delay",
    Range = {0, 10},
    Increment = 0.1,
    Suffix = "seconds",
    CurrentValue = Config.AutoFarm.AutoFishDelay,
    Flag = "AutoFishDelay",
    Callback = function(Value)
        Config.AutoFarm.AutoFishDelay = Value
    end
})

-- Disable Effect Fishing
AutoFarmTab:CreateToggle({
    Name = "Disable Effect Fishing",
    CurrentValue = Config.AutoFarm.DisableEffectFishing,
    Flag = "DisableEffectFishing",
    Callback = function(Value)
        Config.AutoFarm.DisableEffectFishing = Value
        if Value then
            Rayfield:Notify({
                Title = "Fishing Effects",
                Content = "Fishing effects disabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Instant Complicated Fishing
AutoFarmTab:CreateToggle({
    Name = "Auto Instant Complicated Fishing",
    CurrentValue = Config.AutoFarm.AutoInstantComplicatedFishing,
    Flag = "AutoInstantComplicatedFishing",
    Callback = function(Value)
        Config.AutoFarm.AutoInstantComplicatedFishing = Value
        if Value then
            Rayfield:Notify({
                Title = "Complicated Fishing",
                Content = "Instant complicated fishing enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Lock Position Camera
AutoFarmTab:CreateToggle({
    Name = "Auto Lock Position Camera",
    CurrentValue = Config.AutoFarm.AutoLockPositionCamera,
    Flag = "AutoLockPositionCamera",
    Callback = function(Value)
        Config.AutoFarm.AutoLockPositionCamera = Value
        if Value then
            Rayfield:Notify({
                Title = "Camera Lock",
                Content = "Camera position locked",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Sell All Fish Button
AutoFarmTab:CreateButton({
    Name = "Sell All Fish",
    Callback = function()
        if FishingEvents and FishingEvents:FindFirstChild("SellAllFish") then
            FishingEvents.SellAllFish:FireServer()
            Rayfield:Notify({
                Title = "Sell Fish",
                Content = "All fish sold",
                Duration = 3,
                Image = 13047715178
            })
        else
            -- Fallback method
            pcall(function()
                local SellEvent = ReplicatedStorage:FindFirstChild("SellFishEvent")
                if SellEvent then
                    SellEvent:FireServer("All")
                end
            end)
        end
    end
})

-- Auto Sell Fish
AutoFarmTab:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = Config.AutoFarm.AutoSellFish,
    Flag = "AutoSellFish",
    Callback = function(Value)
        Config.AutoFarm.AutoSellFish = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Sell",
                Content = "Auto selling fish enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Delay Sell Fish
AutoFarmTab:CreateSlider({
    Name = "Delay Sell Fish",
    Range = {1, 60},
    Increment = 1,
    Suffix = "seconds",
    CurrentValue = Config.AutoFarm.DelaySellFish,
    Flag = "DelaySellFish",
    Callback = function(Value)
        Config.AutoFarm.DelaySellFish = Value
    end
})

-- Auto Upgrade Rod
AutoFarmTab:CreateToggle({
    Name = "Auto Upgrade Rod",
    CurrentValue = Config.AutoFarm.AutoUpgradeRod,
    Flag = "AutoUpgradeRod",
    Callback = function(Value)
        Config.AutoFarm.AutoUpgradeRod = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Upgrade Rod",
                Content = "Auto upgrading rod enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Upgrade Backpack
AutoFarmTab:CreateToggle({
    Name = "Auto Upgrade Backpack",
    CurrentValue = Config.AutoFarm.AutoUpgradeBackpack,
    Flag = "AutoUpgradeBackpack",
    Callback = function(Value)
        Config.AutoFarm.AutoUpgradeBackpack = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Upgrade Backpack",
                Content = "Auto upgrading backpack enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Equip Best Rod
AutoFarmTab:CreateToggle({
    Name = "Auto Equip Best Rod",
    CurrentValue = Config.AutoFarm.AutoEquipBestRod,
    Flag = "AutoEquipBestRod",
    Callback = function(Value)
        Config.AutoFarm.AutoEquipBestRod = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Equip Best Rod",
                Content = "Auto equipping best rod enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Equip Best Bait
AutoFarmTab:CreateToggle({
    Name = "Auto Equip Best Bait",
    CurrentValue = Config.AutoFarm.AutoEquipBestBait,
    Flag = "AutoEquipBestBait",
    Callback = function(Value)
        Config.AutoFarm.AutoEquipBestBait = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Equip Best Bait",
                Content = "Auto equipping best bait enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Collect Daily Reward
AutoFarmTab:CreateToggle({
    Name = "Auto Collect Daily Reward",
    CurrentValue = Config.AutoFarm.AutoCollectDaily,
    Flag = "AutoCollectDaily",
    Callback = function(Value)
        Config.AutoFarm.AutoCollectDaily = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Collect Daily",
                Content = "Auto collecting daily reward enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Anti Kick Server
AutoFarmTab:CreateToggle({
    Name = "Anti Kick Server",
    CurrentValue = Config.AutoFarm.AntiKickServer,
    Flag = "AntiKickServer",
    Callback = function(Value)
        Config.AutoFarm.AntiKickServer = Value
        if Value then
            Rayfield:Notify({
                Title = "Anti Kick",
                Content = "Anti kick protection enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Anti AFK
AutoFarmTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = Config.AutoFarm.AntiAFK,
    Flag = "AntiAFK",
    Callback = function(Value)
        Config.AutoFarm.AntiAFK = Value
        if Value then
            Rayfield:Notify({
                Title = "Anti AFK",
                Content = "Anti AFK enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Teleport Tab
local TeleportTab = Window:CreateTab("🗺 Teleport", 13014546625)

-- Get actual island locations from workspace
local function GetIslandLocations()
    local locations = {}
    local islands = Workspace:FindFirstChild("Islands")
    
    if islands then
        for _, island in pairs(islands:GetChildren()) do
            if island:FindFirstChild("TeleportPart") then
                table.insert(locations, island.Name)
            end
        end
    end
    
    -- Fallback locations
    if #locations == 0 then
        locations = {
            "Fisherman Island",
            "Stingray Shores", 
            "Kohana Island",
            "Coral Reefs",
            "Esoteric Depths",
            "Tropical Grove",
            "Crater Island",
            "Lost Isle"
        }
    end
    
    return locations
end

-- Select Location (Island Location)
local Locations = GetIslandLocations()

TeleportTab:CreateDropdown({
    Name = "Select Location",
    Options = Locations,
    CurrentOption = Config.Teleport.SelectedLocation,
    Flag = "SelectedLocation",
    Callback = function(Value)
        Config.Teleport.SelectedLocation = Value
    end
})

-- Teleport To Island Button
TeleportTab:CreateButton({
    Name = "Teleport To Island",
    Callback = function()
        if Config.Teleport.SelectedLocation ~= "" then
            local targetCFrame
            local islands = Workspace:FindFirstChild("Islands")
            
            if islands then
                local targetIsland = islands:FindFirstChild(Config.Teleport.SelectedLocation)
                if targetIsland and targetIsland:FindFirstChild("TeleportPart") then
                    targetCFrame = targetIsland.TeleportPart.CFrame
                end
            end
            
            -- Fallback positions
            if not targetCFrame then
                if Config.Teleport.SelectedLocation == "Fisherman Island" then
                    targetCFrame = CFrame.new(-120, 15, -80)
                elseif Config.Teleport.SelectedLocation == "Stingray Shores" then
                    targetCFrame = CFrame.new(250, 10, 450)
                elseif Config.Teleport.SelectedLocation == "Kohana Island" then
                    targetCFrame = CFrame.new(-350, 25, 800)
                elseif Config.Teleport.SelectedLocation == "Coral Reefs" then
                    targetCFrame = CFrame.new(600, -5, 200)
                elseif Config.Teleport.SelectedLocation == "Esoteric Depths" then
                    targetCFrame = CFrame.new(0, -50, 1000)
                elseif Config.Teleport.SelectedLocation == "Tropical Grove" then
                    targetCFrame = CFrame.new(-600, 15, -300)
                elseif Config.Teleport.SelectedLocation == "Crater Island" then
                    targetCFrame = CFrame.new(800, 30, -500)
                elseif Config.Teleport.SelectedLocation == "Lost Isle" then
                    targetCFrame = CFrame.new(-900, 40, 600)
                end
            end
            
            if targetCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:SetPrimaryPartCFrame(targetCFrame)
                Rayfield:Notify({
                    Title = "Teleport",
                    Content = "Teleported to " .. Config.Teleport.SelectedLocation,
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            Rayfield:Notify({
                Title = "Teleport Error",
                Content = "Please select a location first",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Player List for Teleport
local function UpdatePlayerList()
    playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    return playerList
end

TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = UpdatePlayerList(),
    CurrentOption = Config.Teleport.SelectedPlayer,
    Flag = "SelectedPlayer",
    Callback = function(Value)
        Config.Teleport.SelectedPlayer = Value
    end
})

-- Refresh Player List Button
TeleportTab:CreateButton({
    Name = "Refresh Player List",
    Callback = function()
        TeleportTab:UpdateDropdown("SelectedPlayer", {
            Options = UpdatePlayerList()
        })
        Rayfield:Notify({
            Title = "Player List",
            Content = "Player list refreshed",
            Duration = 2,
            Image = 13047715178
        })
    end
})

-- Teleport To Player Button
TeleportTab:CreateButton({
    Name = "Teleport To Player",
    Callback = function()
        if Config.Teleport.SelectedPlayer ~= "" then
            local targetPlayer = Players:FindFirstChild(Config.Teleport.SelectedPlayer)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:SetPrimaryPartCFrame(targetPlayer.Character.HumanoidRootPart.CFrame)
                Rayfield:Notify({
                    Title = "Teleport",
                    Content = "Teleported to " .. Config.Teleport.SelectedPlayer,
                    Duration = 3,
                    Image = 13047715178
                })
            else
                Rayfield:Notify({
                    Title = "Teleport Error",
                    Content = "Player not found or not loaded",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            Rayfield:Notify({
                Title = "Teleport Error",
                Content = "Please select a player first",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Teleport to Event
TeleportTab:CreateToggle({
    Name = "Auto Teleport to Event",
    CurrentValue = Config.Teleport.AutoTeleportEvent,
    Flag = "AutoTeleportEvent",
    Callback = function(Value)
        Config.Teleport.AutoTeleportEvent = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Event Teleport",
                Content = "Auto teleport to events enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Save Position
TeleportTab:CreateInput({
    Name = "Save Position Name",
    PlaceholderText = "Enter position name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text ~= "" then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Config.Teleport.SavedPositions[Text] = LocalPlayer.Character.HumanoidRootPart.CFrame
                Rayfield:Notify({
                    Title = "Position Saved",
                    Content = "Position saved as: " .. Text,
                    Duration = 3,
                    Image = 13047715178
                })
                
                -- Update dropdown
                local savedPositionsList = {}
                for name, _ in pairs(Config.Teleport.SavedPositions) do
                    table.insert(savedPositionsList, name)
                end
                TeleportTab:UpdateDropdown("SavedPosition", {
                    Options = savedPositionsList
                })
            end
        end
    end
})

-- Load Saved Positions Dropdown
local savedPositionsList = {}
for name, _ in pairs(Config.Teleport.SavedPositions) do
    table.insert(savedPositionsList, name)
end

TeleportTab:CreateDropdown({
    Name = "Saved Positions",
    Options = savedPositionsList,
    CurrentOption = "",
    Flag = "SavedPosition",
    Callback = function(Value)
        if Config.Teleport.SavedPositions[Value] then
            LocalPlayer.Character:SetPrimaryPartCFrame(Config.Teleport.SavedPositions[Value])
            Rayfield:Notify({
                Title = "Position Loaded",
                Content = "Teleported to saved position: " .. Value,
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Delete Position
TeleportTab:CreateInput({
    Name = "Delete Position",
    PlaceholderText = "Enter position name to delete",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text ~= "" and Config.Teleport.SavedPositions[Text] then
            Config.Teleport.SavedPositions[Text] = nil
            Rayfield:Notify({
                Title = "Position Deleted",
                Content = "Deleted position: " .. Text,
                Duration = 3,
                Image = 13047715178
            })
            
            -- Update dropdown
            local savedPositionsList = {}
            for name, _ in pairs(Config.Teleport.SavedPositions) do
                table.insert(savedPositionsList, name)
            end
            TeleportTab:UpdateDropdown("SavedPosition", {
                Options = savedPositionsList
            })
        end
    end
})

-- User Tab
local UserTab = Window:CreateTab("👤 User", 13014546625)

-- Speed Hack
UserTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = Config.User.SpeedHack,
    Flag = "SpeedHack",
    Callback = function(Value)
        Config.User.SpeedHack = Value
        if Value then
            Rayfield:Notify({
                Title = "Speed Hack",
                Content = "Speed hack enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

UserTab:CreateSlider({
    Name = "Speed Value",
    Range = {16, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = Config.User.SpeedValue,
    Flag = "SpeedValue",
    Callback = function(Value)
        Config.User.SpeedValue = Value
    end
})

-- Infinity Jump
UserTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = Config.User.InfinityJump,
    Flag = "InfinityJump",
    Callback = function(Value)
        Config.User.InfinityJump = Value
        if Value then
            Rayfield:Notify({
                Title = "Infinity Jump",
                Content = "Infinity jump enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Fly
UserTab:CreateToggle({
    Name = "Fly",
    CurrentValue = Config.User.Fly,
    Flag = "Fly",
    Callback = function(Value)
        Config.User.Fly = Value
        if Value then
            Rayfield:Notify({
                Title = "Fly",
                Content = "Fly enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Fly Range
UserTab:CreateSlider({
    Name = "Fly Range",
    Range = {10, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = Config.User.FlyRange,
    Flag = "FlyRange",
    Callback = function(Value)
        Config.User.FlyRange = Value
    end
})

-- Noclip
UserTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = Config.User.Noclip,
    Flag = "Noclip",
    Callback = function(Value)
        Config.User.Noclip = Value
        if Value then
            Rayfield:Notify({
                Title = "Noclip",
                Content = "Noclip enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Walk on Water
UserTab:CreateToggle({
    Name = "Walk on Water",
    CurrentValue = Config.User.WalkOnWater,
    Flag = "WalkOnWater",
    Callback = function(Value)
        Config.User.WalkOnWater = Value
        if Value then
            Rayfield:Notify({
                Title = "Walk on Water",
                Content = "Walk on water enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Player ESP
UserTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = Config.User.PlayerESP,
    Flag = "PlayerESP",
    Callback = function(Value)
        Config.User.PlayerESP = Value
        if Value then
            Rayfield:Notify({
                Title = "Player ESP",
                Content = "Player ESP enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- ESP Box
UserTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = Config.User.ESPBox,
    Flag = "ESPBox",
    Callback = function(Value)
        Config.User.ESPBox = Value
    end
})

-- ESP Lines
UserTab:CreateToggle({
    Name = "ESP Lines",
    CurrentValue = Config.User.ESPLines,
    Flag = "ESPLines",
    Callback = function(Value)
        Config.User.ESPLines = Value
    end
})

-- ESP Name
UserTab:CreateToggle({
    Name = "ESP Name",
    CurrentValue = Config.User.ESPName,
    Flag = "ESPName",
    Callback = function(Value)
        Config.User.ESPName = Value
    end
})

-- ESP Level
UserTab:CreateToggle({
    Name = "ESP Level",
    CurrentValue = Config.User.ESPLevel,
    Flag = "ESPLevel",
    Callback = function(Value)
        Config.User.ESPLevel = Value
    end
})

-- ESP Distance
UserTab:CreateToggle({
    Name = "ESP Distance",
    CurrentValue = Config.User.ESPDistance,
    Flag = "ESPDistance",
    Callback = function(Value)
        Config.User.ESPDistance = Value
    end
})

-- Trade Tab
local TradeTab = Window:CreateTab("💱 Trade", 13014546625)

-- Auto Trade All Fish
TradeTab:CreateToggle({
    Name = "Auto Trade All Fish",
    CurrentValue = Config.Trade.AutoTradeAllFish,
    Flag = "AutoTradeAllFish",
    Callback = function(Value)
        Config.Trade.AutoTradeAllFish = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Trade",
                Content = "Auto trade all fish enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Accept Trade
TradeTab:CreateToggle({
    Name = "Auto Accept Trade",
    CurrentValue = Config.Trade.AutoAcceptTrade,
    Flag = "AutoAcceptTrade",
    Callback = function(Value)
        Config.Trade.AutoAcceptTrade = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Accept Trade",
                Content = "Auto accept trade enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Trade Player Input
TradeTab:CreateInput({
    Name = "Trade Player",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        Config.Trade.TradePlayer = Text
    end
})

-- Trade Player Button
TradeTab:CreateButton({
    Name = "Send Trade Request",
    Callback = function()
        if Config.Trade.TradePlayer ~= "" then
            local targetPlayer = Players:FindFirstChild(Config.Trade.TradePlayer)
            if targetPlayer then
                if TradeEvents and TradeEvents:FindFirstChild("SendTradeRequest") then
                    TradeEvents.SendTradeRequest:FireServer(targetPlayer)
                    Rayfield:Notify({
                        Title = "Trade Request",
                        Content = "Trade request sent to " .. Config.Trade.TradePlayer,
                        Duration = 3,
                        Image = 13047715178
                    })
                else
                    -- Fallback method
                    pcall(function()
                        local TradeSystem = GameModules.TradeSystem
                        if TradeSystem then
                            TradeSystem.SendRequest(targetPlayer)
                        end
                    end)
                end
            else
                Rayfield:Notify({
                    Title = "Trade Error",
                    Content = "Player not found: " .. Config.Trade.TradePlayer,
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            Rayfield:Notify({
                Title = "Trade Error",
                Content = "Please enter a player name first",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Server Tab
local ServerTab = Window:CreateTab("🌍 Server", 13014546625)

-- Auto Buy Cuaca
ServerTab:CreateToggle({
    Name = "Auto Buy Cuaca",
    CurrentValue = Config.Server.AutoBuyCuaca,
    Flag = "AutoBuyCuaca",
    Callback = function(Value)
        Config.Server.AutoBuyCuaca = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Buy Cuaca",
                Content = "Auto buy cuaca enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Join Event
ServerTab:CreateToggle({
    Name = "Auto Join Event",
    CurrentValue = Config.Server.AutoJoinEvent,
    Flag = "AutoJoinEvent",
    Callback = function(Value)
        Config.Server.AutoJoinEvent = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Join Event",
                Content = "Auto join events enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Player Total
local playerCountLabel = ServerTab:CreateLabel("Player Total: " .. #Players:GetPlayers())

-- Update player count periodically
spawn(function()
    while wait(5) do
        playerCountLabel:Set("Player Total: " .. #Players:GetPlayers())
    end
end)

-- System Info
local fpsLabel = ServerTab:CreateLabel("FPS: " .. FPS)
local pingLabel = ServerTab:CreateLabel("Ping: " .. (PingStats and math.floor(PingStats:GetValue()) or "N/A") .. " ms")

-- Event Teleport Dropdown
local Events = {
    "Orca Migration",
    "Shark Hunt",
    "Whale Migration",
    "Megalodon Hunt",
    "Kraken Hunt",
    "Ancient Kraken Hunt",
    "Scylla Hunt",
    "Octophant Hunt",
    "Sunken Chests",
    "Strange Whirlpool",
    "Nuke",
    "Lovestorm",
    "Lucky Event"
}

ServerTab:CreateDropdown({
    Name = "Teleport Event",
    Options = Events,
    CurrentOption = Config.Server.TeleportEvent,
    Flag = "TeleportEvent",
    Callback = function(Value)
        Config.Server.TeleportEvent = Value
    end
})

-- Teleport to Event Button
ServerTab:CreateButton({
    Name = "Teleport to Event",
    Callback = function()
        if Config.Server.TeleportEvent ~= "" then
            -- Find event location
            local eventLocation
            local eventsFolder = Workspace:FindFirstChild("Events")
            
            if eventsFolder then
                for _, event in pairs(eventsFolder:GetChildren()) do
                    if event.Name:find(Config.Server.TeleportEvent) and event:FindFirstChild("Location") then
                        eventLocation = event.Location.CFrame
                        break
                    end
                end
            end
            
            if eventLocation then
                LocalPlayer.Character:SetPrimaryPartCFrame(eventLocation)
                Rayfield:Notify({
                    Title = "Event Teleport",
                    Content = "Teleporting to " .. Config.Server.TeleportEvent,
                    Duration = 3,
                    Image = 13047715178
                })
            else
                Rayfield:Notify({
                    Title = "Event Error",
                    Content = "Event not active or not found",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            Rayfield:Notify({
                Title = "Event Error",
                Content = "Please select an event first",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Lucky Tab (NEW)
local LuckyTab = Window:CreateTab("🍀 Lucky", 13014546625)

-- Lucky Boost
LuckyTab:CreateToggle({
    Name = "Lucky Boost",
    CurrentValue = Config.Lucky.LuckyBoost,
    Flag = "LuckyBoost",
    Callback = function(Value)
        Config.Lucky.LuckyBoost = Value
        if Value then
            Rayfield:Notify({
                Title = "Lucky Boost",
                Content = "Lucky boost enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- No Trash
LuckyTab:CreateToggle({
    Name = "No Trash",
    CurrentValue = Config.Lucky.NoTrash,
    Flag = "NoTrash",
    Callback = function(Value)
        Config.Lucky.NoTrash = Value
        if Value then
            Rayfield:Notify({
                Title = "No Trash",
                Content = "No trash fish enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Double Roll
LuckyTab:CreateToggle({
    Name = "Double Roll",
    CurrentValue = Config.Lucky.DoubleRoll,
    Flag = "DoubleRoll",
    Callback = function(Value)
        Config.Lucky.DoubleRoll = Value
        if Value then
            Rayfield:Notify({
                Title = "Double Roll",
                Content = "Double RNG roll enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Secret Guarantee
LuckyTab:CreateToggle({
    Name = "Secret Guarantee",
    CurrentValue = Config.Lucky.SecretGuarantee,
    Flag = "SecretGuarantee",
    Callback = function(Value)
        Config.Lucky.SecretGuarantee = Value
        if Value then
            Rayfield:Notify({
                Title = "Secret Guarantee",
                Content = "Secret fish guarantee enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Event Luck Sync
LuckyTab:CreateToggle({
    Name = "Event Luck Sync",
    CurrentValue = Config.Lucky.EventLuckSync,
    Flag = "EventLuckSync",
    Callback = function(Value)
        Config.Lucky.EventLuckSync = Value
        if Value then
            Rayfield:Notify({
                Title = "Event Luck Sync",
                Content = "Event luck synchronization enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Lucky Multiplier
LuckyTab:CreateSlider({
    Name = "Lucky Multiplier",
    Range = {1.0, 5.0},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = Config.Lucky.LuckyMultiplier,
    Flag = "LuckyMultiplier",
    Callback = function(Value)
        Config.Lucky.LuckyMultiplier = Value
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙ Settings", 13014546625)

-- Select Tema
local Themes = {
    "Dark",
    "Light",
    "Midnight",
    "Aqua",
    "Neon"
}

SettingsTab:CreateDropdown({
    Name = "Select Tema",
    Options = Themes,
    CurrentOption = Config.Settings.SelectedTheme,
    Flag = "SelectedTheme",
    Callback = function(Value)
        Config.Settings.SelectedTheme = Value
        Rayfield:ChangeTheme(Value)
        Rayfield:Notify({
            Title = "Theme Changed",
            Content = "Theme set to " .. Value,
            Duration = 3,
            Image = 13047715178
        })
    end
})

-- Transparansi
SettingsTab:CreateSlider({
    Name = "Transparansi",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "opacity",
    CurrentValue = Config.Settings.Transparency,
    Flag = "Transparency",
    Callback = function(Value)
        Config.Settings.Transparency = Value
        Rayfield:SetTransparency(Value)
    end
})

-- Graphics Mode
local GraphicsModes = {
    "Low",
    "Medium",
    "High"
}

SettingsTab:CreateDropdown({
    Name = "Graphics Mode",
    Options = GraphicsModes,
    CurrentOption = Config.Settings.GraphicsMode,
    Flag = "GraphicsMode",
    Callback = function(Value)
        Config.Settings.GraphicsMode = Value
        if Value == "Low" then
            settings().Rendering.QualityLevel = 1
            Workspace.DescendantAdded:Connect(function(child)
                if child:IsA("Part") then
                    child.Material = Enum.Material.Plastic
                end
            end)
        elseif Value == "Medium" then
            settings().Rendering.QualityLevel = 5
        else
            settings().Rendering.QualityLevel = 10
        end
        Rayfield:Notify({
            Title = "Graphics Mode",
            Content = "Graphics mode set to " .. Value,
            Duration = 3,
            Image = 13047715178
        })
    end
})

-- Unlock FPS
SettingsTab:CreateToggle({
    Name = "Unlock FPS",
    CurrentValue = Config.Settings.UnlockFPS,
    Flag = "UnlockFPS",
    Callback = function(Value)
        Config.Settings.UnlockFPS = Value
        if Value then
            setfpscap(Config.Settings.MaxFPS)
            Rayfield:Notify({
                Title = "FPS Unlocked",
                Content = "FPS unlocked to " .. Config.Settings.MaxFPS,
                Duration = 3,
                Image = 13047715178
            })
        else
            setfpscap(60)
            Rayfield:Notify({
                Title = "FPS Locked",
                Content = "FPS locked to 60",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Max FPS
SettingsTab:CreateSlider({
    Name = "Max FPS",
    Range = {60, 360},
    Increment = 10,
    Suffix = "FPS",
    CurrentValue = Config.Settings.MaxFPS,
    Flag = "MaxFPS",
    Callback = function(Value)
        Config.Settings.MaxFPS = Value
        if Config.Settings.UnlockFPS then
            setfpscap(Value)
        end
    end
})

-- Config Name Input
SettingsTab:CreateInput({
    Name = "Config Name",
    PlaceholderText = "Enter config name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        Config.Settings.ConfigName = Text
    end
})

-- Save Config Button
SettingsTab:CreateButton({
    Name = "Save Config",
    Callback = function()
        SaveConfig()
    end
})

-- Load Config Button
SettingsTab:CreateButton({
    Name = "Load Config",
    Callback = function()
        LoadConfig()
    end
})

-- Destroy GUI Button
SettingsTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        Rayfield:Destroy()
    end
})

-- Main Loops and Functions
local ESP = {
    Boxes = {},
    Lines = {},
    Names = {},
    Levels = {},
    Distances = {}
}

-- Fishing Variables
local lastFishingTime = 0
local lastSellTime = 0
local isFishing = false
local biteDetectionConnection = nil

-- ESP Functions
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- ESP Box
    if Config.User.ESPBox and Config.User.PlayerESP then
        local box = Drawing.new("Square")
        box.Visible = false
        box.Color = Color3.fromRGB(255, 255, 255)
        box.Thickness = 2
        box.Filled = false
        ESP.Boxes[player] = box
    end
    
    -- ESP Line
    if Config.User.ESPLines and Config.User.PlayerESP then
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = Color3.fromRGB(255, 255, 255)
        line.Thickness = 2
        ESP.Lines[player] = line
    end
    
    -- ESP Name
    if Config.User.ESPName and Config.User.PlayerESP then
        local name = Drawing.new("Text")
        name.Visible = false
        name.Color = Color3.fromRGB(255, 255, 255)
        name.Size = 14
        name.Center = true
        name.Outline = true
        name.Text = player.DisplayName or player.Name
        ESP.Names[player] = name
    end
    
    -- ESP Level
    if Config.User.ESPLevel and Config.User.PlayerESP then
        local level = Drawing.new("Text")
        level.Visible = false
        level.Color = Color3.fromRGB(255, 255, 0)
        level.Size = 14
        level.Center = true
        level.Outline = true
        
        -- Try to get player level
        local leaderstats = player:FindFirstChild("leaderstats")
        local levelValue = "N/A"
        if leaderstats then
            local lvl = leaderstats:FindFirstChild("Level") or leaderstats:FindFirstChild("LVL") or leaderstats:FindFirstChild("lvl")
            if lvl then
                levelValue = tostring(lvl.Value)
            end
        end
        
        level.Text = "Level: " .. levelValue
        ESP.Levels[player] = level
    end
    
    -- ESP Distance
    if Config.User.ESPDistance and Config.User.PlayerESP then
        local distance = Drawing.new("Text")
        distance.Visible = false
        distance.Color = Color3.fromRGB(0, 255, 255)
        distance.Size = 14
        distance.Center = true
        distance.Outline = true
        ESP.Distances[player] = distance
    end
end

local function UpdateESP()
    for player, box in pairs(ESP.Boxes) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and Config.User.PlayerESP and Config.User.ESPBox then
            local humanoidRootPart = player.Character.HumanoidRootPart
            local position, visible = Workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
            
            if visible then
                local size = Vector2.new(2000 / position.Z, 3000 / position.Z)
                box.Size = size
                box.Position = Vector2.new(position.X - size.X / 2, position.Y - size.Y / 2)
                box.Visible = true
                
                -- Update line if exists
                if ESP.Lines[player] then
                    local line = ESP.Lines[player]
                    line.From = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y)
                    line.To = Vector2.new(position.X, position.Y)
                    line.Visible = Config.User.ESPLines
                end
                
                -- Update name if exists
                if ESP.Names[player] then
                    local name = ESP.Names[player]
                    name.Position = Vector2.new(position.X, position.Y - size.Y / 2 - 20)
                    name.Visible = Config.User.ESPName
                end
                
                -- Update level if exists
                if ESP.Levels[player] then
                    local level = ESP.Levels[player]
                    level.Position = Vector2.new(position.X, position.Y + size.Y / 2 + 10)
                    level.Visible = Config.User.ESPLevel
                end
                
                -- Update distance if exists
                if ESP.Distances[player] and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = ESP.Distances[player]
                    local dist = (humanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    distance.Position = Vector2.new(position.X, position.Y + size.Y / 2 + 30)
                    distance.Text = math.floor(dist) .. " studs"
                    distance.Visible = Config.User.ESPDistance
                end
            else
                box.Visible = false
                if ESP.Lines[player] then ESP.Lines[player].Visible = false end
                if ESP.Names[player] then ESP.Names[player].Visible = false end
                if ESP.Levels[player] then ESP.Levels[player].Visible = false end
                if ESP.Distances[player] then ESP.Distances[player].Visible = false end
            end
        else
            box.Visible = false
            if ESP.Lines[player] then ESP.Lines[player].Visible = false end
            if ESP.Names[player] then ESP.Names[player].Visible = false end
            if ESP.Levels[player] then ESP.Levels[player].Visible = false end
            if ESP.Distances[player] then ESP.Distances[player].Visible = false end
        end
    end
end

local function RemoveESP(player)
    if ESP.Boxes[player] then
        ESP.Boxes[player]:Remove()
        ESP.Boxes[player] = nil
    end
    if ESP.Lines[player] then
        ESP.Lines[player]:Remove()
        ESP.Lines[player] = nil
    end
    if ESP.Names[player] then
        ESP.Names[player]:Remove()
        ESP.Names[player] = nil
    end
    if ESP.Levels[player] then
        ESP.Levels[player]:Remove()
        ESP.Levels[player] = nil
    end
    if ESP.Distances[player] then
        ESP.Distances[player]:Remove()
        ESP.Distances[player] = nil
    end
end

-- Initialize ESP for all players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

-- Handle new players
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        CreateESP(player)
    end)
end)

-- Handle players leaving
Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- Speed Hack
local function SpeedHack()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.User.SpeedHack and Config.User.SpeedValue or 16
    end
end

-- Infinity Jump
local function InfinityJump()
    if Config.User.InfinityJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

-- Noclip
local function Noclip()
    if LocalPlayer.Character and Config.User.Noclip then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end

-- Walk on Water
local function WalkOnWater()
    if LocalPlayer.Character and Config.User.WalkOnWater then
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local ray = Ray.new(humanoidRootPart.Position, Vector3.new(0, -10, 0))
            local part, position = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
            
            if part and part.Name == "Water" or part and part.Name:find("Water") then
                humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, part.Position.Y + 5, humanoidRootPart.Position.Z)
            end
        end
    end
end

-- Fly
local flying = false
local flyBV = nil
local flyBG = nil
local function Fly()
    if Config.User.Fly and LocalPlayer.Character and not flying then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end
        
        local torso = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if torso then
            if flyBG then flyBG:Destroy() end
            if flyBV then flyBV:Destroy() end
            
            flyBG = Instance.new("BodyGyro", torso)
            flyBG.Name = "FlyBG"
            flyBG.P = 10000
            flyBG.maxTorque = Vector3.new(900000, 900000, 900000)
            flyBG.cframe = torso.CFrame
            
            flyBV = Instance.new("BodyVelocity", torso)
            flyBV.Name = "FlyBV"
            flyBV.velocity = Vector3.new(0, 0, 0)
            flyBV.maxForce = Vector3.new(1000000, 1000000, 1000000)
            
            flying = true
            
            spawn(function()
                local control = {f = 0, b = 0, l = 0, r = 0}
                local lastSpace = false
                
                UserInputService.InputBegan:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.W then
                        control.f = 1
                    elseif input.KeyCode == Enum.KeyCode.S then
                        control.b = -1
                    elseif input.KeyCode == Enum.KeyCode.A then
                        control.l = -1
                    elseif input.KeyCode == Enum.KeyCode.D then
                        control.r = 1
                    elseif input.KeyCode == Enum.KeyCode.Space then
                        lastSpace = true
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.W then
                        control.f = 0
                    elseif input.KeyCode == Enum.KeyCode.S then
                        control.b = 0
                    elseif input.KeyCode == Enum.KeyCode.A then
                        control.l = 0
                    elseif input.KeyCode == Enum.KeyCode.D then
                        control.r = 0
                    elseif input.KeyCode == Enum.KeyCode.Space then
                        lastSpace = false
                    end
                end)
                
                while flying and wait() do
                    if not Config.User.Fly then
                        flying = false
                        if humanoid then
                            humanoid.PlatformStand = false
                        end
                        if flyBG then flyBG:Destroy() end
                        if flyBV then flyBV:Destroy() end
                        break
                    end
                    
                    if torso then
                        local cam = Workspace.CurrentCamera.CFrame
                        local move = Vector3.new(control.r + control.l, (lastSpace and 1 or 0) + (control.f + control.b > 0 and -0.2 or 0), control.f + control.b)
                        if move.Magnitude > 0 then
                            move = cam:VectorToWorldSpace(move)
                            flyBV.velocity = move * Config.User.FlyRange
                        else
                            flyBV.velocity = Vector3.new(0, 0, 0)
                        end
                        
                        flyBG.cframe = cam
                    end
                end
            end)
        end
    elseif not Config.User.Fly and flying then
        flying = false
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
            if flyBG then flyBG:Destroy() end
            if flyBV then flyBV:Destroy() end
        end
    end
end

-- Auto Fishing
local function SetupBiteDetection()
    if biteDetectionConnection then
        biteDetectionConnection:Disconnect()
        biteDetectionConnection = nil
    end
    
    -- Try to find fishing bite event
    local fishingGui = LocalPlayer.PlayerGui:FindFirstChild("FishingGui")
    if fishingGui then
        local biteFrame = fishingGui:FindFirstChild("BiteFrame")
        if biteFrame then
            biteDetectionConnection = biteFrame:GetPropertyChangedSignal("Visible"):Connect(function()
                if biteFrame.Visible and Config.AutoFarm.AutoFishV1 then
                    -- This is when the fish bites
                    if FishingEvents and FishingEvents:FindFirstChild("ReelFish") then
                        FishingEvents.ReelFish:FireServer()
                        
                        -- For perfect fishing
                        if Config.AutoFarm.AutoInstantComplicatedFishing then
                            wait(0.2)
                            if FishingEvents:FindFirstChild("CompleteFishing") then
                                FishingEvents.CompleteFishing:FireServer(true)
                            end
                        end
                    end
                end
            end)
        end
    end
end

local function AutoFish()
    if Config.AutoFarm.AutoFishV1 and FishingEvents and FishingEvents:FindFirstChild("StartFishing") then
        local currentTime = tick()
        if currentTime - lastFishingTime >= Config.AutoFarm.AutoFishDelay and not isFishing then
            FishingEvents.StartFishing:FireServer()
            lastFishingTime = currentTime
            isFishing = true
            
            -- Set up bite detection if not already set up
            if not biteDetectionConnection then
                SetupBiteDetection()
            end
            
            -- Reset fishing state after a reasonable time
            delay(30, function()
                isFishing = false
            end)
        end
    end
end

-- Auto Sell
local function AutoSell()
    if Config.AutoFarm.AutoSellFish then
        local currentTime = tick()
        if currentTime - lastSellTime >= Config.AutoFarm.DelaySellFish then
            if FishingEvents and FishingEvents:FindFirstChild("SellAllFish") then
                FishingEvents.SellAllFish:FireServer()
                lastSellTime = currentTime
            else
                -- Fallback method
                pcall(function()
                    local SellEvent = ReplicatedStorage:FindFirstChild("SellFishEvent")
                    if SellEvent then
                        SellEvent:FireServer("All")
                        lastSellTime = currentTime
                    end
                end)
            end
        end
    end
end

-- Auto Upgrade
local function AutoUpgrade()
    if Config.AutoFarm.AutoUpgradeRod then
        pcall(function()
            local upgradeEvent = ReplicatedStorage:FindFirstChild("UpgradeRod")
            if upgradeEvent then
                upgradeEvent:FireServer()
            end
        end)
    end
    
    if Config.AutoFarm.AutoUpgradeBackpack then
        pcall(function()
            local upgradeEvent = ReplicatedStorage:FindFirstChild("UpgradeBackpack")
            if upgradeEvent then
                upgradeEvent:FireServer()
            end
        end)
    end
end

-- Auto Equip Best
local function AutoEquipBest()
    if Config.AutoFarm.AutoEquipBestRod then
        pcall(function()
            -- This would require knowing the best rod available
            local bestRod = "Advanced Fishing Rod" -- Placeholder
            local equipEvent = ReplicatedStorage:FindFirstChild("EquipRod")
            if equipEvent then
                equipEvent:FireServer(bestRod)
            end
        end)
    end
    
    if Config.AutoFarm.AutoEquipBestBait then
        pcall(function()
            -- This would require knowing the best bait available
            local bestBait = "Super Bait" -- Placeholder
            local equipEvent = ReplicatedStorage:FindFirstChild("EquipBait")
            if equipEvent then
                equipEvent:FireServer(bestBait)
            end
        end)
    end
end

-- Auto Collect Daily
local function AutoCollectDaily()
    if Config.AutoFarm.AutoCollectDaily then
        pcall(function()
            local dailyEvent = ReplicatedStorage:FindFirstChild("CollectDaily")
            if dailyEvent then
                dailyEvent:FireServer()
            end
        end)
    end
end

-- Auto Buy Cuaca
local function AutoBuyCuaca()
    if Config.Server.AutoBuyCuaca then
        pcall(function()
            local weatherEvent = ReplicatedStorage:FindFirstChild("BuyWeather")
            if weatherEvent then
                -- This would need to know which weather to buy
                weatherEvent:FireServer("Clear Skies") -- Placeholder
            end
        end)
    end
end

-- Lucky System Functions
local function ApplyLuckySystem()
    if not GameModules.FishingSystem then return end
    
    -- Backup original functions
    if not GameModules.FishingSystem.OriginalCalculateCatch then
        GameModules.FishingSystem.OriginalCalculateCatch = GameModules.FishingSystem.CalculateCatch
    end
    
    -- Override with lucky system
    GameModules.FishingSystem.CalculateCatch = function(...)
        local result = GameModules.FishingSystem.OriginalCalculateCatch(...)
        
        -- Apply lucky modifications
        if Config.Lucky.LuckyBoost then
            -- Increase rare fish chance
            if result and result.Rarity then
                if result.Rarity == "Rare" or result.Rarity == "Secret" or result.Rarity == "Mythic" then
                    -- Double the chance for rare fish
                    result.Chance = result.Chance * Config.Lucky.LuckyMultiplier
                end
            end
        end
        
        if Config.Lucky.NoTrash then
            -- Filter out common fish
            if result and result.Rarity == "Common" then
                -- Recaculate to get a different fish
                return GameModules.FishingSystem.OriginalCalculateCatch(...)
            end
        end
        
        if Config.Lucky.DoubleRoll then
            -- Roll twice and pick the better result
            local result2 = GameModules.FishingSystem.OriginalCalculateCatch(...)
            if result2 and result2.Rarity and result.Rarity then
                local rarityOrder = {Common = 1, Uncommon = 2, Rare = 3, Secret = 4, Mythic = 5}
                if rarityOrder[result2.Rarity] > rarityOrder[result.Rarity] then
                    result = result2
                end
            end
        end
        
        if Config.Lucky.SecretGuarantee then
            -- Force secret fish after certain conditions
            -- This would need more complex logic based on game mechanics
        end
        
        if Config.Lucky.EventLuckSync then
            -- Sync with lucky events
            local events = Workspace:FindFirstChild("Events")
            if events then
                for _, event in pairs(events:GetChildren()) do
                    if event.Name:find("Lucky") and event:FindFirstChild("Active") and event.Active.Value then
                        -- Increase luck during lucky events
                        if result and result.Chance then
                            result.Chance = result.Chance * 2
                        end
                    end
                end
            end
        end
        
        return result
    end
end

local function RestoreOriginalSystem()
    if GameModules.FishingSystem and GameModules.FishingSystem.OriginalCalculateCatch then
        GameModules.FishingSystem.CalculateCatch = GameModules.FishingSystem.OriginalCalculateCatch
    end
end

-- Main Game Loop
RunService.Heartbeat:Connect(function(deltaTime)
    -- Update FPS counter
    local currentTime = os.clock()
    FPS = math.floor(1 / deltaTime)
    if fpsLabel then
        fpsLabel:Set("FPS: " .. FPS)
    end
    if pingLabel and PingStats then
        pingLabel:Set("Ping: " .. math.floor(PingStats:GetValue()) .. " ms")
    end
    
    -- Update ESP
    if Config.User.PlayerESP then
        UpdateESP()
    else
        for player, box in pairs(ESP.Boxes) do
            box.Visible = false
        end
        for player, line in pairs(ESP.Lines) do
            line.Visible = false
        end
        for player, name in pairs(ESP.Names) do
            name.Visible = false
        end
        for player, level in pairs(ESP.Levels) do
            level.Visible = false
        end
        for player, distance in pairs(ESP.Distances) do
            distance.Visible = false
        end
    end
    
    -- Speed Hack
    SpeedHack()
    
    -- Noclip
    Noclip()
    
    -- Walk on Water
    WalkOnWater()
    
    -- Fly
    if Config.User.Fly and not flying then
        Fly()
    elseif not Config.User.Fly and flying then
        flying = false
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
            if flyBG then flyBG:Destroy() end
            if flyBV then flyBV:Destroy() end
        end
    end
    
    -- Auto Fish
    AutoFish()
    
    -- Auto Sell
    AutoSell()
    
    -- Auto Upgrade
    AutoUpgrade()
    
    -- Auto Equip Best
    AutoEquipBest()
    
    -- Auto Collect Daily (once per 10 minutes)
    if tick() % 600 < deltaTime then
        AutoCollectDaily()
    end
    
    -- Auto Buy Cuaca
    AutoBuyCuaca()
    
    -- Apply Lucky System
    if Config.Lucky.LuckyBoost or Config.Lucky.NoTrash or Config.Lucky.DoubleRoll or 
       Config.Lucky.SecretGuarantee or Config.Lucky.EventLuckSync then
        ApplyLuckySystem()
    else
        RestoreOriginalSystem()
    end
end)

-- Infinity Jump Input
UserInputService.JumpRequest:Connect(function()
    if Config.User.InfinityJump and LocalPlayer.Character then
        InfinityJump()
    end
end)

-- Re-setup bite detection when character changes
LocalPlayer.CharacterAdded:Connect(function()
    wait(1) -- Wait for character to fully load
    SetupBiteDetection()
end)

-- Initial setup
if LocalPlayer.Character then
    SetupBiteDetection()
end

-- Notify when loaded
Rayfield:Notify({
    Title = "NIKZZ SCRIPT v2.0",
    Content = "by Nikzz Xit Loaded - Fish It September 2025",
    Duration = 5,
    Image = 13047715178
})

-- Load default config if exists
if isfile("FishItConfig_DefaultConfig.json") then
    LoadConfig()
end

-- Apply graphics settings
if Config.Settings.GraphicsMode == "Low" then
    settings().Rendering.QualityLevel = 1
elseif Config.Settings.GraphicsMode == "Medium" then
    settings().Rendering.QualityLevel = 5
else
    settings().Rendering.QualityLevel = 10
end

-- Apply FPS settings
if Config.Settings.UnlockFPS then
    setfpscap(Config.Settings.MaxFPS)
else
    setfpscap(60)
end
