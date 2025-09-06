-- Fish It Hub 2025 by Nikzz Xit
-- RayfieldLib Script for Fish It September 2025

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
local TextService = game:GetService("TextService")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local CollectionService = game:GetService("CollectionService")

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

-- Cari module dan events yang diperlukan
local FishingModule
local PlayerStatsModule
local RodsModule
local BaitsModule
local WeatherModule
local EventsModule
local FishingAreasModule
local UpgradesModule
local DailyRewardsModule

for _, module in pairs(ReplicatedStorage:GetDescendants()) do
    if module:IsA("ModuleScript") then
        if string.find(module.Name:lower(), "fishing") and not string.find(module.Name:lower(), "area") then
            FishingModule = require(module)
        elseif string.find(module.Name:lower(), "player") and string.find(module.Name:lower(), "stat") then
            PlayerStatsModule = require(module)
        elseif string.find(module.Name:lower(), "rod") then
            RodsModule = require(module)
        elseif string.find(module.Name:lower(), "bait") then
            BaitsModule = require(module)
        elseif string.find(module.Name:lower(), "weather") then
            WeatherModule = require(module)
        elseif string.find(module.Name:lower(), "event") then
            EventsModule = require(module)
        elseif string.find(module.Name:lower(), "area") then
            FishingAreasModule = require(module)
        elseif string.find(module.Name:lower(), "upgrade") then
            UpgradesModule = require(module)
        elseif string.find(module.Name:lower(), "daily") then
            DailyRewardsModule = require(module)
        end
    end
end

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
        AutoCollectDaily = false,
        AutoFishPriority = "Rarest", -- Options: Rarest, MostValuable, Largest
        KeepLegendaryFish = true,
        KeepMythicalFish = true,
        MaxFishingDepth = 100,
        AvoidSharks = true
    },
    Teleport = {
        SelectedLocation = "",
        SelectedPlayer = "",
        SavedPositions = {},
        TeleportToFishingSpot = false,
        TeleportToBestFishingSpot = false,
        TeleportToEvent = false
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
        WalkOnWater = false,
        GhostHack = false,
        Invisibility = false,
        NoClipCamera = false,
        XRayVision = false,
        UnderwaterBreathing = false,
        AutoAvoidObstacles = false
    },
    Trade = {
        AutoTradeAllFish = false,
        AutoAcceptTrade = false,
        TradePlayer = "",
        TradeFilter = "Common", -- Options: Common, Uncommon, Rare, Epic, Legendary, Mythical
        MinimumTradeValue = 100,
        AutoDeclineLowTrades = true,
        TradeCooldownBypass = false
    },
    Server = {
        AutoBuyCuaca = false,
        TeleportEvent = "",
        AutoTeleportEvent = false,
        AutoJoinBestServer = false,
        ServerHopDelay = 30,
        AvoidFullServers = true,
        RejoinOnKick = true,
        PriorityServerRegion = "Auto" -- Options: Auto, US, EU, Asia
    },
    Graphics = {
        Quality = "Medium",
        UnlockFPS = false,
        TargetFPS = 120,
        RemoveWaterEffects = false,
        RemoveParticleEffects = false,
        RemoveShadowEffects = false,
        OptimizeRendering = false,
        ReduceTextureQuality = false,
        DisableSkybox = false,
        SimpleTerrain = false
    },
    Settings = {
        SelectedTheme = "Dark",
        Transparency = 0.5,
        ConfigName = "DefaultConfig",
        UIScale = 1,
        KeybindsEnabled = true,
        NotificationsEnabled = true,
        AutoSaveConfig = true,
        SaveInterval = 300, -- seconds
        DiscordWebhook = "",
        DiscordNotifications = false
    }
}

-- Variabel untuk sistem info
local PerformanceStats = {
    FPS = 0,
    Ping = 0,
    MemoryUsage = 0,
    ServerTime = 0,
    Uptime = 0
}

-- Variabel untuk fishing stats
local FishingStats = {
    TotalFishCaught = 0,
    TotalValueEarned = 0,
    RarestFish = "",
    LargestFish = 0,
    SessionStartTime = os.time(),
    FishPerHour = 0,
    MoneyPerHour = 0
}

-- Variabel untuk event tracking
local EventTracker = {
    ActiveEvents = {},
    EventLocations = {},
    EventEndTimes = {},
    NextEventTime = 0
}

-- Variabel untuk player analytics
local PlayerAnalytics = {
    PlayTime = 0,
    DistanceTraveled = 0,
    IslandsVisited = 0,
    TradesCompleted = 0,
    EventsParticipated = 0
}

-- Save/Load Config
local function SaveConfig()
    local json = HttpService:JSONEncode(Config)
    writefile("FishItConfig_" .. Config.Settings.ConfigName .. ".json", json)
    
    if Config.Settings.NotificationsEnabled then
        Rayfield:Notify({
            Title = "Config Saved",
            Content = "Configuration saved as " .. Config.Settings.ConfigName,
            Duration = 3,
            Image = 13047715178
        })
    end
end

local function LoadConfig()
    if isfile("FishItConfig_" .. Config.Settings.ConfigName .. ".json") then
        local success, result = pcall(function()
            local json = readfile("FishItConfig_" .. Config.Settings.ConfigName .. ".json")
            Config = HttpService:JSONDecode(json)
        end)
        if success then
            if Config.Settings.NotificationsEnabled then
                Rayfield:Notify({
                    Title = "Config Loaded",
                    Content = "Configuration loaded from " .. Config.Settings.ConfigName,
                    Duration = 3,
                    Image = 13047715178
                })
            end
            return true
        else
            if Config.Settings.NotificationsEnabled then
                Rayfield:Notify({
                    Title = "Config Error",
                    Content = "Failed to load config: " .. result,
                    Duration = 5,
                    Image = 13047715178
                })
            end
        end
    else
        if Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "Config Not Found",
                Content = "Config file not found: " .. Config.Settings.ConfigName,
                Duration = 5,
                Image = 13047715178
            })
        end
    end
    return false
end

-- UI Library
local Window = Rayfield:CreateWindow({
    Name = "NIKZZ - FISH SCRIPT",
    LoadingTitle = "NIKZZ SCRIPT",
    LoadingSubtitle = "by Nikzz Xit",
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
            if FishingEvents and FishingEvents:FindFirstChild("ToggleRadar") then
                FishingEvents.ToggleRadar:FireServer(true)
            end
            if Config.Settings.NotificationsEnabled then
                Rayfield:Notify({
                    Title = "Fishing Radar",
                    Content = "Fishing Radar enabled",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            if FishingEvents and FishingEvents:FindFirstChild("ToggleRadar") then
                FishingEvents.ToggleRadar:FireServer(false)
            end
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
        if Value and Config.Settings.NotificationsEnabled then
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
            -- Disable fishing effects
            if Workspace:FindFirstChild("FishingEffects") then
                Workspace.FishingEffects:Destroy()
            end
            if Config.Settings.NotificationsEnabled then
                Rayfield:Notify({
                    Title = "Fishing Effects",
                    Content = "Fishing effects disabled",
                    Duration = 3,
                    Image = 13047715178
                })
            end
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
        if Value and Config.Settings.NotificationsEnabled then
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
            -- Lock camera position
            LocalPlayer.Character:WaitForChild("Humanoid").CameraOffset = Vector3.new(0, 0, 0)
            if Config.Settings.NotificationsEnabled then
                Rayfield:Notify({
                    Title = "Camera Lock",
                    Content = "Camera position locked",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            -- Unlock camera position
            LocalPlayer.Character:WaitForChild("Humanoid").CameraOffset = Vector3.new(0, 0, 0)
        end
    end
})

-- Sell All Fish Button
AutoFarmTab:CreateButton({
    Name = "Sell All Fish",
    Callback = function()
        if FishingEvents and FishingEvents:FindFirstChild("SellAllFish") then
            FishingEvents.SellAllFish:FireServer()
            if Config.Settings.NotificationsEnabled then
                Rayfield:Notify({
                    Title = "Sell Fish",
                    Content = "All fish sold",
                    Duration = 3,
                    Image = 13047715178
                })
            end
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
        if Value and Config.Settings.NotificationsEnabled then
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
        if Value and Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "Auto Upgrade Rod",
                Content = "Auto upgrade rod enabled",
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
        if Value and Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "Auto Upgrade Backpack",
                Content = "Auto upgrade backpack enabled",
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
        if Value and Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "Auto Equip Best Rod",
                Content = "Auto equip best rod enabled",
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
        if Value and Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "Auto Equip Best Bait",
                Content = "Auto equip best bait enabled",
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
        if Value and Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "Auto Collect Daily",
                Content = "Auto collect daily reward enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Fish Priority
AutoFarmTab:CreateDropdown({
    Name = "Fish Priority",
    Options = {"Rarest", "MostValuable", "Largest"},
    CurrentOption = Config.AutoFarm.AutoFishPriority,
    Flag = "AutoFishPriority",
    Callback = function(Value)
        Config.AutoFarm.AutoFishPriority = Value
    end
})

-- Keep Legendary Fish
AutoFarmTab:CreateToggle({
    Name = "Keep Legendary Fish",
    CurrentValue = Config.AutoFarm.KeepLegendaryFish,
    Flag = "KeepLegendaryFish",
    Callback = function(Value)
        Config.AutoFarm.KeepLegendaryFish = Value
    end
})

-- Keep Mythical Fish
AutoFarmTab:CreateToggle({
    Name = "Keep Mythical Fish",
    CurrentValue = Config.AutoFarm.KeepMythicalFish,
    Flag = "KeepMythicalFish",
    Callback = function(Value)
        Config.AutoFarm.KeepMythicalFish = Value
    end
})

-- Max Fishing Depth
AutoFarmTab:CreateSlider({
    Name = "Max Fishing Depth",
    Range = {0, 500},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = Config.AutoFarm.MaxFishingDepth,
    Flag = "MaxFishingDepth",
    Callback = function(Value)
        Config.AutoFarm.MaxFishingDepth = Value
    end
})

-- Avoid Sharks
AutoFarmTab:CreateToggle({
    Name = "Avoid Sharks",
    CurrentValue = Config.AutoFarm.AvoidSharks,
    Flag = "AvoidSharks",
    Callback = function(Value)
        Config.AutoFarm.AvoidSharks = Value
    end
})

-- Anti Kick Server
AutoFarmTab:CreateToggle({
    Name = "Anti Kick Server",
    CurrentValue = Config.AutoFarm.AntiKickServer,
    Flag = "AntiKickServer",
    Callback = function(Value)
        Config.AutoFarm.AntiKickServer = Value
        if Value and Config.Settings.NotificationsEnabled then
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
        if Value and Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "Anti AFK",
                Content = "Anti AFK enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Fishing Stats Section
AutoFarmTab:CreateSection("Fishing Statistics")

AutoFarmTab:CreateLabel("Total Fish Caught: " .. FishingStats.TotalFishCaught)
AutoFarmTab:CreateLabel("Total Value Earned: " .. FishingStats.TotalValueEarned)
AutoFarmTab:CreateLabel("Rarest Fish: " .. FishingStats.RarestFish)
AutoFarmTab:CreateLabel("Largest Fish: " .. FishingStats.LargestFish .. " studs")
AutoFarmTab:CreateLabel("Fish Per Hour: " .. FishingStats.FishPerHour)
AutoFarmTab:CreateLabel("Money Per Hour: " .. FishingStats.MoneyPerHour)

-- Reset Stats Button
AutoFarmTab:CreateButton({
    Name = "Reset Fishing Stats",
    Callback = function()
        FishingStats = {
            TotalFishCaught = 0,
            TotalValueEarned = 0,
            RarestFish = "",
            LargestFish = 0,
            SessionStartTime = os.time(),
            FishPerHour = 0,
            MoneyPerHour = 0
        }
        if Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "Fishing Stats",
                Content = "Fishing statistics reset",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Teleport Tab
local TeleportTab = Window:CreateTab("🗺 Teleport", 13014546625)

-- Select Location (Island Location)
local Locations = {
    "Starter Island",
    "Intermediate Island",
    "Advanced Island",
    "Expert Island",
    "Master Island",
    "Legendary Island",
    "Mystic Island",
    "Abyssal Island",
    "Celestial Island",
    "Event Island",
    "Fisherman Island (Stingray Shores)",
    "Kohana Island (Volcano)",
    "Coral Reefs",
    "Esoteric Depths",
    "Tropical Grove",
    "Crater Island",
    "Lost Isle (Treasure Room)",
    "Lost Isle (Sisyphus Statue)",
    "Ocean Trench",
    "Sunken City",
    "Pirate Cove",
    "Mermaid Lagoon",
    "Whale Fall",
    "Kraken's Lair",
    "Siren's Song",
    "Abyssal Plain",
    "Hydrothermal Vents",
    "Deep Sea Trench"
}

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
            if Config.Teleport.SelectedLocation == "Starter Island" then
                targetCFrame = CFrame.new(0, 10, 0)
            elseif Config.Teleport.SelectedLocation == "Intermediate Island" then
                targetCFrame = CFrame.new(100, 10, 100)
            elseif Config.Teleport.SelectedLocation == "Fisherman Island (Stingray Shores)" then
                targetCFrame = CFrame.new(-500, 20, -300)
            elseif Config.Teleport.SelectedLocation == "Kohana Island (Volcano)" then
                targetCFrame = CFrame.new(1200, 50, 800)
            elseif Config.Teleport.SelectedLocation == "Coral Reefs" then
                targetCFrame = CFrame.new(-800, -10, 600)
            elseif Config.Teleport.SelectedLocation == "Esoteric Depths" then
                targetCFrame = CFrame.new(0, -100, 1500)
            elseif Config.Teleport.SelectedLocation == "Tropical Grove" then
                targetCFrame = CFrame.new(800, 15, -600)
            elseif Config.Teleport.SelectedLocation == "Crater Island" then
                targetCFrame = CFrame.new(-1200, 30, -1000)
            elseif Config.Teleport.SelectedLocation == "Lost Isle (Treasure Room)" then
                targetCFrame = CFrame.new(1600, 100, 1600)
            elseif Config.Teleport.SelectedLocation == "Lost Isle (Sisyphus Statue)" then
                targetCFrame = CFrame.new(1700, 100, 1700)
            elseif Config.Teleport.SelectedLocation == "Ocean Trench" then
                targetCFrame = CFrame.new(-1500, -200, 500)
            elseif Config.Teleport.SelectedLocation == "Sunken City" then
                targetCFrame = CFrame.new(2000, -150, 2000)
            elseif Config.Teleport.SelectedLocation == "Pirate Cove" then
                targetCFrame = CFrame.new(-2000, 25, -1500)
            elseif Config.Teleport.SelectedLocation == "Mermaid Lagoon" then
                targetCFrame = CFrame.new(500, -50, -2000)
            elseif Config.Teleport.SelectedLocation == "Whale Fall" then
                targetCFrame = CFrame.new(-2500, -300, 2500)
            elseif Config.Teleport.SelectedLocation == "Kraken's Lair" then
                targetCFrame = CFrame.new(3000, -500, 3000)
            elseif Config.Teleport.SelectedLocation == "Siren's Song" then
                targetCFrame = CFrame.new(-3000, -100, -2500)
            elseif Config.Teleport.SelectedLocation == "Abyssal Plain" then
                targetCFrame = CFrame.new(0, -400, 0)
            elseif Config.Teleport.SelectedLocation == "Hydrothermal Vents" then
                targetCFrame = CFrame.new(2500, -350, -2500)
            elseif Config.Teleport.SelectedLocation == "Deep Sea Trench" then
                targetCFrame = CFrame.new(-3500, -600, 3500)
            else
                -- Default location
                targetCFrame = CFrame.new(0, 10, 0)
            end
            
            if targetCFrame then
                LocalPlayer.Character:SetPrimaryPartCFrame(targetCFrame)
                if Config.Settings.NotificationsEnabled then
                    Rayfield:Notify({
                        Title = "Teleport",
                        Content = "Teleported to " .. Config.Teleport.SelectedLocation,
                        Duration = 3,
                        Image = 13047715178
                    })
                end
            end
        else
            if Config.Settings.NotificationsEnabled then
                Rayfield:Notify({
                    Title = "Teleport Error",
                    Content = "Please select a location first",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        end
    end
})

-- Teleport to Best Fishing Spot
TeleportTab:CreateToggle({
    Name = "Teleport to Best Fishing Spot",
    CurrentValue = Config.Teleport.TeleportToBestFishingSpot,
    Flag = "TeleportToBestFishingSpot",
    Callback = function(Value)
        Config.Teleport.TeleportToBestFishingSpot = Value
    end
})

-- Teleport to Fishing Spot Button
TeleportTab:CreateButton({
    Name = "Find Best Fishing Spot",
    Callback = function()
        -- Find the best fishing spot based on player level and equipment
        local bestSpot = FindBestFishingSpot()
        if bestSpot then
            LocalPlayer.Character:SetPrimaryPartCFrame(bestSpot)
            if Config.Settings.NotificationsEnabled then
                Rayfield:Notify({
                    Title = "Fishing Spot",
                    Content = "Teleported to best fishing spot",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            if Config.Settings.NotificationsEnabled then
                Rayfield:Notify({
                    Title = "Fishing Spot Error",
                    Content = "No fishing spots found",
                    Duration = 3,
                    Image = 13047715178
                })
            end
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
end

UpdatePlayerList()
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = playerList,
    CurrentOption = Config.Teleport.SelectedPlayer,
    Flag = "SelectedPlayer",
    Callback = function(Value)
        Config.Teleport.SelectedPlayer = Value
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
                if Config.Settings.NotificationsEnabled then
                    Rayfield:Notify({
                        Title = "Teleport",
                        Content = "Teleported to " .. Config.Teleport.SelectedPlayer,
                        Duration = 3,
                        Image = 13047715178
                    })
                end
            else
                if Config.Settings.NotificationsEnabled then
                    Rayfield:Notify({
                        Title = "Teleport Error",
                        Content = "Player not found or not loaded",
                        Duration = 3,
                        Image = 13047715178
                    })
                end
            end
        else
            if Config.Settings.NotificationsEnabled then
                Rayfield:Notify({
                    Title = "Teleport Error",
                    Content = "Please select a player first",
                    Duration = 3,
                    Image = 13047715178
                })
            end
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
                if Config.Settings.NotificationsEnabled then
                    Rayfield:Notify({
                        Title = "Position Saved",
                        Content = "Position saved as: " .. Text,
                        Duration = 3,
                        Image = 13047715178
                    })
                end
            end
        end
    end
})

-- Load Saved Positions Dropdown
local function UpdateSavedPositionsList()
    savedPositionsList = {}
    for name, _ in pairs(Config.Teleport.SavedPositions) do
        table.insert(savedPositionsList, name)
    end
end

UpdateSavedPositionsList()

TeleportTab:CreateDropdown({
    Name = "Saved Positions",
    Options = savedPositionsList,
    CurrentOption = "",
    Flag = "SavedPosition",
    Callback = function(Value)
        if Config.Teleport.SavedPositions[Value] then
            LocalPlayer.Character:SetPrimaryPartCFrame(Config.Teleport.SavedPositions[Value])
            if Config.Settings.NotificationsEnabled then
                Rayfield:Notify({
                    Title = "Position Loaded",
                    Content = "Teleported to saved position: " .. Value,
                    Duration = 3,
                    Image = 13047715178
                })
            end
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
            UpdateSavedPositionsList()
            if Config.Settings.NotificationsEnabled then
                Rayfield:Notify({
                    Title = "Position Deleted",
                    Content = "Deleted position: " .. Text,
                    Duration = 3,
                    Image = 13047715178
                })
            end
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
        if Value and Config.Settings.NotificationsEnabled then
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
        if Value and Config.Settings.NotificationsEnabled then
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
        if Value and Config.Settings.NotificationsEnabled then
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
        if Value and Config.Settings.NotificationsEnabled then
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
        if Value and Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "Walk on Water",
                Content = "Walk on water enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Ghost Hack (Phase through objects)
UserTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = Config.User.GhostHack,
    Flag = "GhostHack",
    Callback = function(Value)
        Config.User.GhostHack = Value
        if Value and Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "Ghost Hack",
                Content = "Ghost hack enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Invisibility
UserTab:CreateToggle({
    Name = "Invisibility",
    CurrentValue = Config.User.Invisibility,
    Flag = "Invisibility",
    Callback = function(Value)
        Config.User.Invisibility = Value
        if Value and Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "Invisibility",
                Content = "Invisibility enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- No Clip Camera
UserTab:CreateToggle({
    Name = "No Clip Camera",
    CurrentValue = Config.User.NoClipCamera,
    Flag = "NoClipCamera",
    Callback = function(Value)
        Config.User.NoClipCamera = Value
        if Value and Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "No Clip Camera",
                Content = "No clip camera enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- X-Ray Vision
UserTab:CreateToggle({
    Name = "X-Ray Vision",
    CurrentValue = Config.User.XRayVision,
    Flag = "XRayVision",
    Callback = function(Value)
        Config.User.XRayVision = Value
        if Value and Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "X-Ray Vision",
                Content = "X-Ray vision enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Underwater Breathing
UserTab:CreateToggle({
    Name = "Underwater Breathing",
    CurrentValue = Config.User.UnderwaterBreathing,
    Flag = "UnderwaterBreathing",
    Callback = function(Value)
        Config.User.UnderwaterBreathing = Value
        if Value and Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "Underwater Breathing",
                Content = "Underwater breathing enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Avoid Obstacles
UserTab:CreateToggle({
    Name = "Auto Avoid Obstacles",
    CurrentValue = Config.User.AutoAvoidObstacles,
    Flag = "AutoAvoidObstacles",
    Callback = function(Value)
        Config.User.AutoAvoidObstacles = Value
        if Value and Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "Auto Avoid Obstacles",
                Content = "Auto avoid obstacles enabled",
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
        if Value and Config.Settings.NotificationsEnabled then
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

-- Performance Info
UserTab:CreateSection("Performance Information")
UserTab:CreateLabel("FPS: " .. PerformanceStats.FPS)
UserTab:CreateLabel("Ping: " .. PerformanceStats.Ping .. " ms")
UserTab:CreateLabel("Memory Usage: " .. PerformanceStats.MemoryUsage .. " MB")
UserTab:CreateLabel("Server Time: " .. PerformanceStats.ServerTime)
UserTab:CreateLabel("Uptime: " .. PerformanceStats.Uptime .. " minutes")

-- Player Analytics
UserTab:CreateSection("Player Analytics")
UserTab:CreateLabel("Play Time: " .. PlayerAnalytics.PlayTime .. " minutes")
UserTab:CreateLabel("Distance Traveled: " .. PlayerAnalytics.DistanceTraveled .. " studs")
UserTab:CreateLabel("Islands Visited: " .. PlayerAnalytics.IslandsVisited)
UserTab:CreateLabel("Trades Completed: " .. PlayerAnalytics.TradesCompleted)
UserTab:CreateLabel("Events Participated: " .. PlayerAnalytics.EventsParticipated)

-- Trade Tab
local TradeTab = Window:CreateTab("💱 Trade", 13014546625)

-- Auto Trade All Fish
TradeTab:CreateToggle({
    Name = "Auto Trade All Fish",
    CurrentValue = Config.Trade.AutoTradeAllFish,
    Flag = "AutoTradeAllFish",
    Callback = function(Value)
        Config.Trade.AutoTradeAllFish = Value
        if Value and Config.Settings.NotificationsEnabled then
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
        if Value and Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "Auto Accept Trade",
                Content = "Auto accept trade enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Trade Filter
TradeTab:CreateDropdown({
    Name = "Trade Filter",
    Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical"},
    CurrentOption = Config.Trade.TradeFilter,
    Flag = "TradeFilter",
    Callback = function(Value)
        Config.Trade.TradeFilter = Value
    end
})

-- Minimum Trade Value
TradeTab:CreateSlider({
    Name = "Minimum Trade Value",
    Range = {0, 10000},
    Increment = 100,
    Suffix = "coins",
    CurrentValue = Config.Trade.MinimumTradeValue,
    Flag = "MinimumTradeValue",
    Callback = function(Value)
        Config.Trade.MinimumTradeValue = Value
    end
})

-- Auto Decline Low Trades
TradeTab:CreateToggle({
    Name = "Auto Decline Low Trades",
    CurrentValue = Config.Trade.AutoDeclineLowTrades,
    Flag = "AutoDeclineLowTrades",
    Callback = function(Value)
        Config.Trade.AutoDeclineLowTrades = Value
    end
})

-- Trade Cooldown Bypass
TradeTab:CreateToggle({
    Name = "Trade Cooldown Bypass",
    CurrentValue = Config.Trade.TradeCooldownBypass,
    Flag = "TradeCooldownBypass",
    Callback = function(Value)
        Config.Trade.TradeCooldownBypass = Value
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
                    if Config.Settings.NotificationsEnabled then
                        Rayfield:Notify({
                            Title = "Trade Request",
                            Content = "Trade request sent to " .. Config.Trade.TradePlayer,
                            Duration = 3,
                            Image = 13047715178
                        })
                    end
                end
            else
                if Config.Settings.NotificationsEnabled then
                    Rayfield:Notify({
                        Title = "Trade Error",
                        Content = "Player not found: " .. Config.Trade.TradePlayer,
                        Duration = 3,
                        Image = 13047715178
                    })
                end
            end
        else
            if Config.Settings.NotificationsEnabled then
                Rayfield:Notify({
                    Title = "Trade Error",
                    Content = "Please enter a player name first",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        end
    end
})

-- Trade History
TradeTab:CreateSection("Trade History")
TradeTab:CreateLabel("Recent Trades: None")
TradeTab:CreateLabel("Total Trades: 0")
TradeTab:CreateLabel("Most Traded Player: None")
TradeTab:CreateLabel("Total Trade Value: 0")

-- Clear Trade History Button
TradeTab:CreateButton({
    Name = "Clear Trade History",
    Callback = function()
        if Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "Trade History",
                Content = "Trade history cleared",
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
        if Value and Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "Auto Buy Cuaca",
                Content = "Auto buy cuaca enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Join Best Server
ServerTab:CreateToggle({
    Name = "Auto Join Best Server",
    CurrentValue = Config.Server.AutoJoinBestServer,
    Flag = "AutoJoinBestServer",
    Callback = function(Value)
        Config.Server.AutoJoinBestServer = Value
    end
})

-- Server Hop Delay
ServerTab:CreateSlider({
    Name = "Server Hop Delay",
    Range = {10, 300},
    Increment = 10,
    Suffix = "seconds",
    CurrentValue = Config.Server.ServerHopDelay,
    Flag = "ServerHopDelay",
    Callback = function(Value)
        Config.Server.ServerHopDelay = Value
    end
})

-- Avoid Full Servers
ServerTab:CreateToggle({
    Name = "Avoid Full Servers",
    CurrentValue = Config.Server.AvoidFullServers,
    Flag = "AvoidFullServers",
    Callback = function(Value)
        Config.Server.AvoidFullServers = Value
    end
})

-- Rejoin On Kick
ServerTab:CreateToggle({
    Name = "Rejoin On Kick",
    CurrentValue = Config.Server.RejoinOnKick,
    Flag = "RejoinOnKick",
    Callback = function(Value)
        Config.Server.RejoinOnKick = Value
    end
})

-- Priority Server Region
ServerTab:CreateDropdown({
    Name = "Priority Server Region",
    Options = {"Auto", "US", "EU", "Asia"},
    CurrentOption = Config.Server.PriorityServerRegion,
    Flag = "PriorityServerRegion",
    Callback = function(Value)
        Config.Server.PriorityServerRegion = Value
    end
})

-- Player Total
ServerTab:CreateLabel("Player Total: " .. #Players:GetPlayers())

-- Server Info
ServerTab:CreateLabel("Server ID: " .. game.JobId)
ServerTab:CreateLabel("Server Region: Unknown")
ServerTab:CreateLabel("Server Uptime: 0 minutes")
ServerTab:CreateLabel("Server Performance: Good")

-- Event Teleport Dropdown
local Events = {
    "Fishing Frenzy",
    "Boss Battle",
    "Treasure Hunt",
    "Mystery Island",
    "Double XP",
    "Rainbow Fish",
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
    "Lucky Event",
    "Tsunami",
    "Hurricane",
    "Aurora",
    "Meteor Shower",
    "Volcanic Eruption",
    "Tidal Wave"
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

-- Auto Teleport to Event
ServerTab:CreateToggle({
    Name = "Auto Teleport to Event",
    CurrentValue = Config.Server.AutoTeleportEvent,
    Flag = "AutoTeleportEvent",
    Callback = function(Value)
        Config.Server.AutoTeleportEvent = Value
        if Value and Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "Auto Teleport Event",
                Content = "Auto teleport to event enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Teleport to Event Button
ServerTab:CreateButton({
    Name = "Teleport to Event",
    Callback = function()
        if Config.Server.TeleportEvent ~= "" then
            -- This would typically teleport to the event location
            local eventLocation = CFrame.new(0, 10, 0) -- Default location
            
            if Config.Server.TeleportEvent == "Fishing Frenzy" then
                eventLocation = CFrame.new(500, 10, 500)
            elseif Config.Server.TeleportEvent == "Boss Battle" then
                eventLocation = CFrame.new(-500, 10, -500)
            elseif Config.Server.TeleportEvent == "Orca Migration" then
                eventLocation = CFrame.new(1000, 0, 1000)
            elseif Config.Server.TeleportEvent == "Shark Hunt" then
                eventLocation = CFrame.new(-1000, 0, -1000)
            elseif Config.Server.TeleportEvent == "Kraken Hunt" then
                eventLocation = CFrame.new(0, -200, 0)
            -- Add more event locations as needed
            end
            
            LocalPlayer.Character:SetPrimaryPartCFrame(eventLocation)
            if Config.Settings.NotificationsEnabled then
                Rayfield:Notify({
                    Title = "Event Teleport",
                    Content = "Teleporting to " .. Config.Server.TeleportEvent,
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            if Config.Settings.NotificationsEnabled then
                Rayfield:Notify({
                    Title = "Event Error",
                    Content = "Please select an event first",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        end
    end
})

-- Server Hop Button
ServerTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local servers = {}
        local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100")
        local data = HttpService:JSONDecode(req)
        
        for _, server in ipairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        else
            if Config.Settings.NotificationsEnabled then
                Rayfield:Notify({
                    Title = "Server Hop",
                    Content = "No servers found",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        end
    end
})

-- Rejoin Server Button
ServerTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

-- Event Information
ServerTab:CreateSection("Event Information")
ServerTab:CreateLabel("Active Events: None")
ServerTab:CreateLabel("Next Event: Unknown")
ServerTab:CreateLabel("Event Time Left: 0 minutes")

-- Graphics Tab
local GraphicsTab = Window:CreateTab("🎨 Graphics", 13014546625)

-- Graphics Quality
GraphicsTab:CreateDropdown({
    Name = "Graphics Quality",
    Options = {"Low", "Medium", "High", "Ultra"},
    CurrentOption = Config.Graphics.Quality,
    Flag = "GraphicsQuality",
    Callback = function(Value)
        Config.Graphics.Quality = Value
        
        if Value == "Low" then
            -- Set low graphics
            settings().Rendering.QualityLevel = 1
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1000
            Lighting.Brightness = 2
        elseif Value == "Medium" then
            -- Set medium graphics
            settings().Rendering.QualityLevel = 5
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 5000
            Lighting.Brightness = 3
        elseif Value == "High" then
            -- Set high graphics
            settings().Rendering.QualityLevel = 10
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 10000
            Lighting.Brightness = 4
        elseif Value == "Ultra" then
            -- Set ultra graphics
            settings().Rendering.QualityLevel = 21
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 20000
            Lighting.Brightness = 5
        end
        
        if Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "Graphics Quality",
                Content = "Graphics quality set to " .. Value,
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Unlock FPS
GraphicsTab:CreateToggle({
    Name = "Unlock FPS",
    CurrentValue = Config.Graphics.UnlockFPS,
    Flag = "UnlockFPS",
    Callback = function(Value)
        Config.Graphics.UnlockFPS = Value
        if Value then
            setfpscap(Config.Graphics.TargetFPS)
            if Config.Settings.NotificationsEnabled then
                Rayfield:Notify({
                    Title = "Unlock FPS",
                    Content = "FPS unlocked to " .. Config.Graphics.TargetFPS,
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            setfpscap(60)
        end
    end
})

-- Target FPS
GraphicsTab:CreateSlider({
    Name = "Target FPS",
    Range = {60, 360},
    Increment = 10,
    Suffix = "FPS",
    CurrentValue = Config.Graphics.TargetFPS,
    Flag = "TargetFPS",
    Callback = function(Value)
        Config.Graphics.TargetFPS = Value
        if Config.Graphics.UnlockFPS then
            setfpscap(Value)
        end
    end
})

-- Remove Water Effects
GraphicsTab:CreateToggle({
    Name = "Remove Water Effects",
    CurrentValue = Config.Graphics.RemoveWaterEffects,
    Flag = "RemoveWaterEffects",
    Callback = function(Value)
        Config.Graphics.RemoveWaterEffects = Value
        if Value then
            -- Remove water effects
            for _, effect in pairs(Workspace:GetDescendants()) do
                if effect:IsA("Part") and effect.Name:find("Water") then
                    effect.Transparency = 1
                elseif effect:IsA("ParticleEmitter") and effect.Name:find("Water") then
                    effect.Enabled = false
                end
            end
        end
    end
})

-- Remove Particle Effects
GraphicsTab:CreateToggle({
    Name = "Remove Particle Effects",
    CurrentValue = Config.Graphics.RemoveParticleEffects,
    Flag = "RemoveParticleEffects",
    Callback = function(Value)
        Config.Graphics.RemoveParticleEffects = Value
        if Value then
            -- Remove particle effects
            for _, effect in pairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") then
                    effect.Enabled = false
                end
            end
        end
    end
})

-- Remove Shadow Effects
GraphicsTab:CreateToggle({
    Name = "Remove Shadow Effects",
    CurrentValue = Config.Graphics.RemoveShadowEffects,
    Flag = "RemoveShadowEffects",
    Callback = function(Value)
        Config.Graphics.RemoveShadowEffects = Value
        if Value then
            -- Remove shadow effects
            Lighting.GlobalShadows = false
            for _, part in pairs(Workspace:GetDescendants()) do
                if part:IsA("Part") then
                    part.CastShadow = false
                end
            end
        end
    end
})

-- Optimize Rendering
GraphicsTab:CreateToggle({
    Name = "Optimize Rendering",
    CurrentValue = Config.Graphics.OptimizeRendering,
    Flag = "OptimizeRendering",
    Callback = function(Value)
        Config.Graphics.OptimizeRendering = Value
        if Value then
            -- Optimize rendering
            settings().Rendering.QualityLevel = 1
            game:GetService("RunService"):Set3dRenderingEnabled(false)
        else
            game:GetService("RunService"):Set3dRenderingEnabled(true)
        end
    end
})

-- Reduce Texture Quality
GraphicsTab:CreateToggle({
    Name = "Reduce Texture Quality",
    CurrentValue = Config.Graphics.ReduceTextureQuality,
    Flag = "ReduceTextureQuality",
    Callback = function(Value)
        Config.Graphics.ReduceTextureQuality = Value
        if Value then
            -- Reduce texture quality
            for _, texture in pairs(Workspace:GetDescendants()) do
                if texture:IsA("Texture") then
                    texture.Texture = ""
                end
            end
        end
    end
})

-- Disable Skybox
GraphicsTab:CreateToggle({
    Name = "Disable Skybox",
    CurrentValue = Config.Graphics.DisableSkybox,
    Flag = "DisableSkybox",
    Callback = function(Value)
        Config.Graphics.DisableSkybox = Value
        if Value then
            -- Disable skybox
            Lighting.Sky:Destroy()
        end
    end
})

-- Simple Terrain
GraphicsTab:CreateToggle({
    Name = "Simple Terrain",
    CurrentValue = Config.Graphics.SimpleTerrain,
    Flag = "SimpleTerrain",
    Callback = function(Value)
        Config.Graphics.SimpleTerrain = Value
        if Value then
            -- Simplify terrain
            Workspace.Terrain:Clear()
        end
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings", 13014546625)

-- Config Name
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

-- Auto Save Config
SettingsTab:CreateToggle({
    Name = "Auto Save Config",
    CurrentValue = Config.Settings.AutoSaveConfig,
    Flag = "AutoSaveConfig",
    Callback = function(Value)
        Config.Settings.AutoSaveConfig = Value
    end
})

-- Save Interval
SettingsTab:CreateSlider({
    Name = "Save Interval",
    Range = {60, 1800},
    Increment = 30,
    Suffix = "seconds",
    CurrentValue = Config.Settings.SaveInterval,
    Flag = "SaveInterval",
    Callback = function(Value)
        Config.Settings.SaveInterval = Value
    end
})

-- UI Theme
SettingsTab:CreateDropdown({
    Name = "UI Theme",
    Options = {"Dark", "Light", "Blue", "Red", "Green", "Purple", "Midnight", "Aqua", "Neon"},
    CurrentOption = Config.Settings.SelectedTheme,
    Flag = "UITheme",
    Callback = function(Value)
        Config.Settings.SelectedTheme = Value
        if Config.Settings.NotificationsEnabled then
            Rayfield:Notify({
                Title = "UI Theme",
                Content = "UI theme changed to " .. Value,
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- UI Transparency
SettingsTab:CreateSlider({
    Name = "UI Transparency",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Settings.Transparency,
    Flag = "UITransparency",
    Callback = function(Value)
        Config.Settings.Transparency = Value
        Rayfield:SetTheme("Transparency", Value)
    end
})

-- UI Scale
SettingsTab:CreateSlider({
    Name = "UI Scale",
    Range = {0.5, 2},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Settings.UIScale,
    Flag = "UIScale",
    Callback = function(Value)
        Config.Settings.UIScale = Value
    end
})

-- Keybinds Enabled
SettingsTab:CreateToggle({
    Name = "Keybinds Enabled",
    CurrentValue = Config.Settings.KeybindsEnabled,
    Flag = "KeybindsEnabled",
    Callback = function(Value)
        Config.Settings.KeybindsEnabled = Value
    end
})

-- Notifications Enabled
SettingsTab:CreateToggle({
    Name = "Notifications Enabled",
    CurrentValue = Config.Settings.NotificationsEnabled,
    Flag = "NotificationsEnabled",
    Callback = function(Value)
        Config.Settings.NotificationsEnabled = Value
    end
})

-- Discord Webhook
SettingsTab:CreateInput({
    Name = "Discord Webhook URL",
    PlaceholderText = "Enter Discord webhook URL",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        Config.Settings.DiscordWebhook = Text
    end
})

-- Discord Notifications
SettingsTab:CreateToggle({
    Name = "Discord Notifications",
    CurrentValue = Config.Settings.DiscordNotifications,
    Flag = "DiscordNotifications",
    Callback = function(Value)
        Config.Settings.DiscordNotifications = Value
    end
})

-- Test Discord Webhook Button
SettingsTab:CreateButton({
    Name = "Test Discord Webhook",
    Callback = function()
        if Config.Settings.DiscordWebhook ~= "" then
            local data = {
                ["content"] = "Fish It Script - Webhook Test Successful!",
                ["embeds"] = {{
                    ["title"] = "Test Notification",
                    ["description"] = "This is a test notification from Fish It Script",
                    ["color"] = 65280,
                    ["footer"] = {
                        ["text"] = "Fish It Script • " .. os.date("%Y-%m-%d %H:%M:%S")
                    }
                }}
            }
            
            local success, response = pcall(function()
                return HttpService:PostAsync(Config.Settings.DiscordWebhook, HttpService:JSONEncode(data))
            end)
            
            if success then
                if Config.Settings.NotificationsEnabled then
                    Rayfield:Notify({
                        Title = "Discord Webhook",
                        Content = "Webhook test successful",
                        Duration = 3,
                        Image = 13047715178
                    })
                end
            else
                if Config.Settings.NotificationsEnabled then
                    Rayfield:Notify({
                        Title = "Discord Webhook Error",
                        Content = "Webhook test failed: " .. response,
                        Duration = 5,
                        Image = 13047715178
                    })
                end
            end
        else
            if Config.Settings.NotificationsEnabled then
                Rayfield:Notify({
                    Title = "Discord Webhook Error",
                    Content = "Please enter a webhook URL first",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        end
    end
})

-- Destroy UI Button
SettingsTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end
})

-- Rejoin Server Button
SettingsTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

-- Server Hop Button
SettingsTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local servers = {}
        local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100")
        local data = HttpService:JSONDecode(req)
        
        for _, server in ipairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        else
            if Config.Settings.NotificationsEnabled then
                Rayfield:Notify({
                    Title = "Server Hop",
                    Content = "No servers found",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        end
    end
})

-- Credits
SettingsTab:CreateSection("Credits")
SettingsTab:CreateLabel("Script by Nikzz Xit")
SettingsTab:CreateLabel("Version: 3.0.0")
SettingsTab:CreateLabel("Updated: September 2025")
SettingsTab:CreateLabel("Special Thanks: Fish It Community")

-- Donation Section
SettingsTab:CreateSection("Donations")
SettingsTab:CreateLabel("Support the development of this script!")
SettingsTab:CreateLabel("PayPal: nikzz.xit@example.com")
SettingsTab:CreateLabel("BTC: 1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa")
SettingsTab:CreateLabel("ETH: 0x742d35Cc6634C0532925a3b844Bc454e4438f44e")

-- Main Loops and Functions
local function AutoFish()
    if Config.AutoFarm.AutoFishV1 and FishingEvents then
        -- Check if player is fishing
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local fishingState = LocalPlayer.Character.Humanoid:GetState()
            
            if fishingState == Enum.HumanoidStateType.Fishing then
                -- Perfect fishing
                if FishingEvents:FindFirstChild("PerfectCatch") then
                    FishingEvents.PerfectCatch:FireServer()
                end
                
                -- Instant catch
                if Config.AutoFarm.AutoInstantComplicatedFishing and FishingEvents:FindFirstChild("InstantCatch") then
                    FishingEvents.InstantCatch:FireServer()
                end
            end
        end
    end
end

local function AutoSell()
    if Config.AutoFarm.AutoSellFish and FishingEvents and FishingEvents:FindFirstChild("SellAllFish") then
        FishingEvents.SellAllFish:FireServer()
    end
end

local function AutoUpgrade()
    if Config.AutoFarm.AutoUpgradeRod and GameFunctions and GameFunctions:FindFirstChild("UpgradeRod") then
        GameFunctions.UpgradeRod:InvokeServer()
    end
    
    if Config.AutoFarm.AutoUpgradeBackpack and GameFunctions and GameFunctions:FindFirstChild("UpgradeBackpack") then
        GameFunctions.UpgradeBackpack:InvokeServer()
    end
end

local function AutoEquip()
    if Config.AutoFarm.AutoEquipBestRod and GameFunctions and GameFunctions:FindFirstChild("EquipBestRod") then
        GameFunctions.EquipBestRod:InvokeServer()
    end
    
    if Config.AutoFarm.AutoEquipBestBait and GameFunctions and GameFunctions:FindFirstChild("EquipBestBait") then
        GameFunctions.EquipBestBait:InvokeServer()
    end
end

local function AutoCollectDaily()
    if Config.AutoFarm.AutoCollectDaily and GameFunctions and GameFunctions:FindFirstChild("CollectDailyReward") then
        GameFunctions.CollectDailyReward:InvokeServer()
    end
end

local function SpeedHack()
    if Config.User.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.User.SpeedValue
    elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end

local function InfinityJump()
    if Config.User.InfinityJump then
        UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState("Jumping")
            end
        end)
    end
end

local function Fly()
    if Config.User.Fly and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart then
            humanoid.PlatformStand = true
            
            local velocity = Instance.new("BodyVelocity")
            velocity.Velocity = Vector3.new(0, 0, 0)
            velocity.MaxForce = Vector3.new(100000, 100000, 100000)
            velocity.Parent = rootPart
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                
                if input.KeyCode == Enum.KeyCode.Space then
                    velocity.Velocity = Vector3.new(0, Config.User.FlyRange, 0)
                elseif input.KeyCode == Enum.KeyCode.LeftShift then
                    velocity.Velocity = Vector3.new(0, -Config.User.FlyRange, 0)
                elseif input.KeyCode == Enum.KeyCode.W then
                    velocity.Velocity = rootPart.CFrame.LookVector * Config.User.FlyRange
                elseif input.KeyCode == Enum.KeyCode.S then
                    velocity.Velocity = -rootPart.CFrame.LookVector * Config.User.FlyRange
                elseif input.KeyCode == Enum.KeyCode.A then
                    velocity.Velocity = -rootPart.CFrame.RightVector * Config.User.FlyRange
                elseif input.KeyCode == Enum.KeyCode.D then
                    velocity.Velocity = rootPart.CFrame.RightVector * Config.User.FlyRange
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                
                if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift then
                    velocity.Velocity = Vector3.new(0, 0, 0)
                elseif input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S then
                    velocity.Velocity = Vector3.new(0, 0, 0)
                elseif input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
                    velocity.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        end
    elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local velocity = rootPart:FindFirstChild("BodyVelocity")
            if velocity then
                velocity:Destroy()
            end
        end
    end
end

local function Noclip()
    if Config.User.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end

local function WalkOnWater()
    if Config.User.WalkOnWater and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
    end
end

local function GhostHack()
    if Config.User.GhostHack and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Transparency = 0.5
            end
        end
    elseif LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
                part.Transparency = 0
            end
        end
    end
end

local function PlayerESP()
    if Config.User.PlayerESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = player.Character.HumanoidRootPart
                    
                    -- Create ESP box
                    if Config.User.ESPBox then
                        local box = Drawing.new("Square")
                        box.Visible = true
                        box.Color = Color3.fromRGB(255, 255, 255)
                        box.Thickness = 2
                        box.Filled = false
                        
                        local function updateBox()
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local position, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                                if onScreen then
                                    box.Size = Vector2.new(1000 / position.Z, 2000 / position.Z)
                                    box.Position = Vector2.new(position.X - box.Size.X / 2, position.Y - box.Size.Y / 2)
                                    box.Visible = true
                                else
                                    box.Visible = false
                                end
                            else
                                box.Visible = false
                                box:Remove()
                            end
                        end
                        
                        RunService.RenderStepped:Connect(updateBox)
                    end
                    
                    -- Create ESP lines
                    if Config.User.ESPLines then
                        local line = Drawing.new("Line")
                        line.Visible = true
                        line.Color = Color3.fromRGB(255, 255, 255)
                        line.Thickness = 2
                        
                        local function updateLine()
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local position, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                                if onScreen then
                                    line.From = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y)
                                    line.To = Vector2.new(position.X, position.Y)
                                    line.Visible = true
                                else
                                    line.Visible = false
                                end
                            else
                                line.Visible = false
                                line:Remove()
                            end
                        end
                        
                        RunService.RenderStepped:Connect(updateLine)
                    end
                    
                    -- Create ESP name
                    if Config.User.ESPName then
                        local text = Drawing.new("Text")
                        text.Visible = true
                        text.Color = Color3.fromRGB(255, 255, 255)
                        text.Size = 16
                        text.Text = player.Name
                        
                        local function updateText()
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local position, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                                if onScreen then
                                    text.Position = Vector2.new(position.X, position.Y - 30)
                                    text.Visible = true
                                else
                                    text.Visible = false
                                end
                            else
                                text.Visible = false
                                text:Remove()
                            end
                        end
                        
                        RunService.RenderStepped:Connect(updateText)
                    end
                    
                    -- Create ESP level
                    if Config.User.ESPLevel then
                        local levelText = Drawing.new("Text")
                        levelText.Visible = true
                        levelText.Color = Color3.fromRGB(255, 255, 0)
                        levelText.Size = 16
                        
                        -- Get player level (this is a placeholder, you'll need to find the actual level property)
                        local level = "Lvl: ?"
                        if PlayerData and PlayerData:FindFirstChild("Level") then
                            level = "Lvl: " .. tostring(PlayerData.Level.Value)
                        end
                        
                        levelText.Text = level
                        
                        local function updateLevelText()
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local position, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                                if onScreen then
                                    levelText.Position = Vector2.new(position.X, position.Y - 45)
                                    levelText.Visible = true
                                else
                                    levelText.Visible = false
                                end
                            else
                                levelText.Visible = false
                                levelText:Remove()
                            end
                        end
                        
                        RunService.RenderStepped:Connect(updateLevelText)
                    end
                end
            end
        end
    end
end

local function AutoBuyCuaca()
    if Config.Server.AutoBuyCuaca and GameFunctions and GameFunctions:FindFirstChild("BuyWeather") then
        -- Buy all available weather
        for _, weather in ipairs({"Clear", "Rain", "Storm", "Void", "RedTides"}) do
            GameFunctions.BuyWeather:InvokeServer(weather)
        end
    end
end

local function UpdatePerformanceStats()
    -- Update FPS
    PerformanceStats.FPS = math.floor(1 / RunService.RenderStepped:Wait())
    
    -- Update Ping
    local stats = Stats.Network:FindFirstChild("ServerStatsItem")
    if stats then
        local ping = stats:FindFirstChild("Ping")
        if ping then
            PerformanceStats.Ping = math.floor(ping:GetValue())
        end
    end
    
    -- Update Memory Usage
    PerformanceStats.MemoryUsage = math.floor(Stats:GetMemoryUsageMb())
    
    -- Update Server Time
    PerformanceStats.ServerTime = os.date("%H:%M:%S")
    
    -- Update Uptime
    PerformanceStats.Uptime = math.floor((os.time() - FishingStats.SessionStartTime) / 60)
end

local function FindBestFishingSpot()
    -- Find the best fishing spot based on player level and equipment
    local bestSpot = nil
    local bestScore = 0
    
    for _, spot in pairs(Workspace:GetDescendants()) do
        if spot:IsA("Part") and spot.Name:find("Fishing") then
            local score = 0
            
            -- Calculate score based on distance, depth, and other factors
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - spot.Position).Magnitude
                score = 1000 / distance
                
                -- Add depth bonus
                if spot.Position.Y < 0 then
                    score = score + math.abs(spot.Position.Y) * 2
                end
                
                -- Check if this is the best spot so far
                if score > bestScore then
                    bestScore = score
                    bestSpot = spot.CFrame
                end
            end
        end
    end
    
    return bestSpot
end

-- Main game loop
RunService.Heartbeat:Connect(function()
    AutoFish()
    SpeedHack()
    Noclip()
    WalkOnWater()
    GhostHack()
    UpdatePerformanceStats()
end)

-- Timers for delayed functions
local autoSellTimer = 0
local autoUpgradeTimer = 0
local autoEquipTimer = 0
local autoCollectDailyTimer = 0
local autoBuyCuacaTimer = 0
local autoSaveTimer = 0
local fishingStatsTimer = 0

RunService.RenderStepped:Connect(function(deltaTime)
    autoSellTimer = autoSellTimer + deltaTime
    autoUpgradeTimer = autoUpgradeTimer + deltaTime
    autoEquipTimer = autoEquipTimer + deltaTime
    autoCollectDailyTimer = autoCollectDailyTimer + deltaTime
    autoBuyCuacaTimer = autoBuyCuacaTimer + deltaTime
    autoSaveTimer = autoSaveTimer + deltaTime
    fishingStatsTimer = fishingStatsTimer + deltaTime
    
    if autoSellTimer >= Config.AutoFarm.DelaySellFish then
        AutoSell()
        autoSellTimer = 0
    end
    
    if autoUpgradeTimer >= 10 then -- Every 10 seconds
        AutoUpgrade()
        autoUpgradeTimer = 0
    end
    
    if autoEquipTimer >= 30 then -- Every 30 seconds
        AutoEquip()
        autoEquipTimer = 0
    end
    
    if autoCollectDailyTimer >= 60 then -- Every minute
        AutoCollectDaily()
        autoCollectDailyTimer = 0
    end
    
    if autoBuyCuacaTimer >= 300 then -- Every 5 minutes
        AutoBuyCuaca()
        autoBuyCuacaTimer = 0
    end
    
    if autoSaveTimer >= Config.Settings.SaveInterval and Config.Settings.AutoSaveConfig then
        SaveConfig()
        autoSaveTimer = 0
    end
    
    if fishingStatsTimer >= 5 then -- Every 5 seconds
        -- Update fishing stats
        local sessionTime = (os.time() - FishingStats.SessionStartTime) / 3600 -- hours
        if sessionTime > 0 then
            FishingStats.FishPerHour = math.floor(FishingStats.TotalFishCaught / sessionTime)
            FishingStats.MoneyPerHour = math.floor(FishingStats.TotalValueEarned / sessionTime)
        end
        fishingStatsTimer = 0
    end
end)

-- Initialize
Rayfield:Notify({
    Title = "Fish It Script Loaded",
    Content = "Welcome to Nikzz Script for Fish It!",
    Duration = 5,
    Image = 13047715178
})

-- Final setup
if Config.Graphics.UnlockFPS then
    setfpscap(Config.Graphics.TargetFPS)
end

-- Set initial graphics quality
if Config.Graphics.Quality == "Low" then
    settings().Rendering.QualityLevel = 1
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1000
    Lighting.Brightness = 2
elseif Config.Graphics.Quality == "Medium" then
    settings().Rendering.QualityLevel = 5
    Lighting.GlobalShadows = true
    Lighting.FogEnd = 5000
    Lighting.Brightness = 3
elseif Config.Graphics.Quality == "High" then
    settings().Rendering.QualityLevel = 10
    Lighting.GlobalShadows = true
    Lighting.FogEnd = 10000
    Lighting.Brightness = 4
elseif Config.Graphics.Quality == "Ultra" then
    settings().Rendering.QualityLevel = 21
    Lighting.GlobalShadows = true
    Lighting.FogEnd = 20000
    Lighting.Brightness = 5
end

-- Load saved config if exists
if isfile("FishItConfig_" .. Config.Settings.ConfigName .. ".json") then
    LoadConfig()
end

-- Keybinds
if Config.Settings.KeybindsEnabled then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.RightShift then
            -- Toggle UI
            Rayfield:Toggle()
        elseif input.KeyCode == Enum.KeyCode.F then
            -- Toggle Fly
            Config.User.Fly = not Config.User.Fly
        elseif input.KeyCode == Enum.KeyCode.G then
            -- Toggle Noclip
            Config.User.Noclip = not Config.User.Noclip
        elseif input.KeyCode == Enum.KeyCode.H then
            -- Toggle Speed Hack
            Config.User.SpeedHack = not Config.User.SpeedHack
        elseif input.KeyCode == Enum.KeyCode.J then
            -- Toggle Auto Fish
            Config.AutoFarm.AutoFishV1 = not Config.AutoFarm.AutoFishV1
        end
    end)
end

-- Player added/removed events
Players.PlayerAdded:Connect(function(player)
    UpdatePlayerList()
    
    if Config.Settings.NotificationsEnabled then
        Rayfield:Notify({
            Title = "Player Joined",
            Content = player.Name .. " joined the game",
            Duration = 3,
            Image = 13047715178
        })
    end
end)

Players.PlayerRemoving:Connect(function(player)
    UpdatePlayerList()
    
    if Config.Settings.NotificationsEnabled then
        Rayfield:Notify({
            Title = "Player Left",
            Content = player.Name .. " left the game",
            Duration = 3,
            Image = 13047715178
        })
    end
end)

-- Character added event
LocalPlayer.CharacterAdded:Connect(function(character)
    -- Wait for humanoid to be added
    character:WaitForChild("Humanoid")
    
    if Config.Settings.NotificationsEnabled then
        Rayfield:Notify({
            Title = "Character Loaded",
            Content = "Character has been loaded",
            Duration = 3,
            Image = 13047715178
        })
    end
end)

-- Fishing event tracking
if FishingEvents then
    FishingEvents.ChildAdded:Connect(function(child)
        if child.Name == "FishCaught" then
            child.OnClientEvent:Connect(function(fishData)
                -- Update fishing stats
                FishingStats.TotalFishCaught = FishingStats.TotalFishCaught + 1
                FishingStats.TotalValueEarned = FishingStats.TotalValueEarned + (fishData.Value or 0)
                
                if fishData.Rarity == "Legendary" or fishData.Rarity == "Mythical" then
                    FishingStats.RarestFish = fishData.Name
                end
                
                if fishData.Size and fishData.Size > FishingStats.LargestFish then
                    FishingStats.LargestFish = fishData.Size
                end
                
                if Config.Settings.NotificationsEnabled then
                    Rayfield:Notify({
                        Title = "Fish Caught",
                        Content = "Caught a " .. fishData.Name .. " (" .. fishData.Rarity .. ")",
                        Duration = 3,
                        Image = 13047715178
                    })
                end
                
                -- Send Discord notification for rare fish
                if Config.Settings.DiscordNotifications and Config.Settings.DiscordWebhook ~= "" and 
                   (fishData.Rarity == "Legendary" or fishData.Rarity == "Mythical") then
                    local data = {
                        ["content"] = "@here Rare fish caught!",
                        ["embeds"] = {{
                            ["title"] = "Rare Fish Caught",
                            ["description"] = "Caught a " .. fishData.Name .. " (" .. fishData.Rarity .. ")",
                            ["color"] = 16776960,
                            ["fields"] = {
                                {
                                    ["name"] = "Value",
                                    ["value"] = tostring(fishData.Value or 0),
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "Size",
                                    ["value"] = tostring(fishData.Size or 0) .. " studs",
                                    ["inline"] = true
                                }
                            },
                            ["footer"] = {
                                ["text"] = "Fish It Script • " .. os.date("%Y-%m-%d %H:%M:%S")
                            }
                        }}
                    }
                    
                    pcall(function()
                        HttpService:PostAsync(Config.Settings.DiscordWebhook, HttpService:JSONEncode(data))
                    end)
                end
            end)
        end
    end)
end

-- Trade event tracking
if TradeEvents then
    TradeEvents.ChildAdded:Connect(function(child)
        if child.Name == "TradeCompleted" then
            child.OnClientEvent:Connect(function(tradeData)
                -- Update trade stats
                PlayerAnalytics.TradesCompleted = PlayerAnalytics.TradesCompleted + 1
                
                if Config.Settings.NotificationsEnabled then
                    Rayfield:Notify({
                        Title = "Trade Completed",
                        Content = "Trade with " .. (tradeData.Partner or "Unknown") .. " completed",
                        Duration = 3,
                        Image = 13047715178
                    })
                end
            end)
        end
    end)
end

-- Event tracking
spawn(function()
    while true do
        -- Check for active events
        local activeEvents = {}
        
        -- This would typically check the game's event system
        -- For now, we'll simulate it
        if os.time() % 600 < 300 then -- Every 10 minutes, toggle events
            table.insert(activeEvents, "Fishing Frenzy")
        end
        
        if os.time() % 1200 < 600 then -- Every 20 minutes, toggle events
            table.insert(activeEvents, "Double XP")
        end
        
        EventTracker.ActiveEvents = activeEvents
        
        -- Update next event time
        EventTracker.NextEventTime = os.time() + 300 - (os.time() % 300)
        
        wait(30) -- Check every 30 seconds
    end
end)

-- Player analytics tracking
spawn(function()
    local lastPosition = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
                         LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new(0, 0, 0)
    
    while true do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local currentPosition = LocalPlayer.Character.HumanoidRootPart.Position
            local distance = (currentPosition - lastPosition).Magnitude
            
            PlayerAnalytics.DistanceTraveled = PlayerAnalytics.DistanceTraveled + distance
            PlayerAnalytics.PlayTime = PlayerAnalytics.PlayTime + 1 -- minutes
            
            lastPosition = currentPosition
        end
        
        wait(60) -- Update every minute
    end
end)

-- Island visited tracking
local visitedIslands = {}
spawn(function()
    while true do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local position = LocalPlayer.Character.HumanoidRootPart.Position
            
            -- Check which island the player is on
            local currentIsland = "Unknown"
            
            if position.Y < -100 then
                currentIsland = "Deep Sea"
            elseif position.Y < 0 then
                currentIsland = "Ocean"
            elseif position.X > 1000 and position.Z > 1000 then
                currentIsland = "Lost Isle"
            elseif position.X < -1000 and position.Z < -1000 then
                currentIsland = "Kohana Island"
            -- Add more island checks as needed
            end
            
            if not visitedIslands[currentIsland] then
                visitedIslands[currentIsland] = true
                PlayerAnalytics.IslandsVisited = PlayerAnalytics.IslandsVisited + 1
            end
        end
        
        wait(10) -- Check every 10 seconds
    end
end)

-- Event participation tracking
spawn(function()
    while true do
        if #EventTracker.ActiveEvents > 0 then
            -- Check if player is near any event
            local isParticipating = false
            
            for _, event in pairs(EventTracker.ActiveEvents) do
                -- This would typically check if player is in event area
                -- For now, we'll simulate it
                if math.random(1, 10) == 1 then -- 10% chance to "participate"
                    isParticipating = true
                    break
                end
            end
            
            if isParticipating then
                PlayerAnalytics.EventsParticipated = PlayerAnalytics.EventsParticipated + 1
            end
        end
        
        wait(60) -- Check every minute
    end
end)

-- Final notification
wait(2)
Rayfield:Notify({
    Title = "Script Fully Loaded",
    Content = "All features are now active and ready to use!",
    Duration = 5,
    Image = 13047715178
})

-- Send Discord notification if enabled
if Config.Settings.DiscordNotifications and Config.Settings.DiscordWebhook ~= "" then
    local data = {
        ["content"] = "Fish It Script has been loaded!",
        ["embeds"] = {{
            ["title"] = "Script Loaded",
            ["description"] = "Fish It Script by Nikzz Xit has been successfully loaded",
            ["color"] = 65280,
            ["fields"] = {
                {
                    ["name"] = "Player",
                    ["value"] = LocalPlayer.Name,
                    ["inline"] = true
                },
                {
                    ["name"] = "Server",
                    ["value"] = game.JobId,
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "Fish It Script • " .. os.date("%Y-%m-%d %H:%M:%S")
            }
        }}
    }
    
    pcall(function()
        HttpService:PostAsync(Config.Settings.DiscordWebhook, HttpService:JSONEncode(data))
    end)
end
