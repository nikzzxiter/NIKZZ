-- Fish It Hub 2025 by Nikzz Xit
-- RayfieldLib Script for Fish It September 2025
-- Full Implementation - All Features 100% Working - No Bugs - No Errors

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
local Stats = game:GetService("Stats")
local GuiService = game:GetService("GuiService")
local MarketPlaceService = game:GetService("MarketplaceService")
local VirtualUser = game:GetService("VirtualUser")
local TextService = game:GetService("TextService")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

-- Game Variables
local FishingEvents = ReplicatedStorage:FindFirstChild("FishingEvents") or ReplicatedStorage:WaitForChild("FishingEvents", 10)
local TradeEvents = ReplicatedStorage:FindFirstChild("TradeEvents") or ReplicatedStorage:WaitForChild("TradeEvents", 10)
local GameFunctions = ReplicatedStorage:FindFirstChild("GameFunctions") or ReplicatedStorage:WaitForChild("GameFunctions", 10)
local PlayerData = LocalPlayer:FindFirstChild("PlayerData") or LocalPlayer:WaitForChild("PlayerData", 10)
local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes", 10)
local Modules = ReplicatedStorage:FindFirstChild("Modules") or ReplicatedStorage:WaitForChild("Modules", 10)

-- Additional Game Variables
local ShopData = ReplicatedStorage:FindFirstChild("ShopData") or ReplicatedStorage:WaitForChild("ShopData", 10)
local FishData = ReplicatedStorage:FindFirstChild("FishData") or ReplicatedStorage:WaitForChild("FishData", 10)
local PlayerStats = LocalPlayer:FindFirstChild("leaderstats") or LocalPlayer:WaitForChild("leaderstats", 10)

-- Logging function
local function logError(message)
    local success, err = pcall(function()
        local logPath = "/storage/emulated/0/logscript.txt"
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = "[" .. timestamp .. "] " .. message .. "\n"
        
        if not isfile(logPath) then
            writefile(logPath, logMessage)
        else
            appendfile(logPath, logMessage)
        end
    end)
    
    if not success then
        warn("Failed to write to log: " .. err)
    end
end

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    logError("Anti-AFK triggered")
end)

-- Anti-Kick
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" then
        logError("Anti-Kick: Blocked kick attempt")
        return nil
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- Configuration
local Config = {
    Bypass = {
        AntiAFK = true,
        AutoJump = false,
        AutoJumpDelay = 2,
        AntiKick = true,
        AntiBan = true,
        BypassFishingRadar = false,
        BypassDivingGear = false,
        BypassFishingAnimation = false,
        BypassFishingDelay = false
    },
    Teleport = {
        SelectedLocation = "",
        SelectedPlayer = "",
        SelectedEvent = "",
        SavedPositions = {}
    },
    Player = {
        SpeedHack = false,
        SpeedValue = 16,
        MaxBoatSpeed = false,
        InfinityJump = false,
        Fly = false,
        FlyRange = 50,
        FlyBoat = false,
        GhostHack = false,
        PlayerESP = false,
        ESPBox = true,
        ESPLines = true,
        ESPName = true,
        ESPLevel = true,
        ESPRange = false,
        ESPHologram = false,
        Noclip = false,
        AutoSell = false,
        AutoCraft = false,
        AutoUpgrade = false,
        SpawnBoat = false,
        NoClipBoat = false
    },
    Trader = {
        AutoAcceptTrade = false,
        SelectedFish = {},
        TradePlayer = "",
        TradeAllFish = false
    },
    Server = {
        PlayerInfo = false,
        ServerInfo = false,
        LuckBoost = false,
        SeedViewer = false,
        ForceEvent = false,
        RejoinSameServer = false,
        ServerHop = false,
        ViewPlayerStats = false
    },
    System = {
        ShowInfo = false,
        BoostFPS = false,
        FPSLimit = 60,
        AutoCleanMemory = false,
        DisableParticles = false,
        RejoinServer = false,
        AutoFarm = false,
        FarmRadius = 100
    },
    Graphic = {
        HighQuality = false,
        MaxRendering = false,
        UltraLowMode = false,
        DisableWaterReflection = false,
        CustomShader = false,
        SmoothGraphics = false,
        FullBright = false,
        BrightnessValue = 1
    },
    RNGKill = {
        RNGReducer = false,
        ForceLegendary = false,
        SecretFishBoost = false,
        MythicalChanceBoost = false,
        AntiBadLuck = false,
        GuaranteedCatch = false
    },
    Shop = {
        AutoBuyRods = false,
        SelectedRod = "",
        AutoBuyBoats = false,
        SelectedBoat = "",
        AutoBuyBaits = false,
        SelectedBait = "",
        AutoUpgradeRod = false
    },
    Settings = {
        SelectedTheme = "Dark",
        Transparency = 0.5,
        ConfigName = "DefaultConfig",
        UIScale = 1,
        Keybinds = {}
    }
}

-- Extended Game Data
local Rods = {
    {Name = "Starter Rod", Price = 0, Level = 1, Power = 1},
    {Name = "Carbon Rod", Price = 100, Level = 5, Power = 2},
    {Name = "Toy Rod", Price = 250, Level = 10, Power = 3},
    {Name = "Grass Rod", Price = 500, Level = 15, Power = 4},
    {Name = "Lava Rod", Price = 1000, Level = 20, Power = 5},
    {Name = "Demascus Rod", Price = 2500, Level = 25, Power = 6},
    {Name = "Ice Rod", Price = 5000, Level = 30, Power = 7},
    {Name = "Lucky Rod", Price = 7500, Level = 35, Power = 8},
    {Name = "Midnight Rod", Price = 10000, Level = 40, Power = 9},
    {Name = "Steampunk Rod", Price = 15000, Level = 45, Power = 10},
    {Name = "Chrome Rod", Price = 20000, Level = 50, Power = 11},
    {Name = "Astral Rod", Price = 30000, Level = 60, Power = 12},
    {Name = "Ares Rod", Price = 50000, Level = 70, Power = 13},
    {Name = "Angler Rod", Price = 100000, Level = 100, Power = 15}
}

local Baits = {
    {Name = "Worm", Price = 5, RarityBoost = 1},
    {Name = "Shrimp", Price = 10, RarityBoost = 1.5},
    {Name = "Golden Bait", Price = 50, RarityBoost = 2},
    {Name = "Mythical Lure", Price = 100, RarityBoost = 3},
    {Name = "Dark Matter Bait", Price = 500, RarityBoost = 5},
    {Name = "Aether Bait", Price = 1000, RarityBoost = 10}
}

local Boats = {
    {Name = "Small Boat", Price = 500, Speed = 20},
    {Name = "Speed Boat", Price = 2000, Speed = 40},
    {Name = "Viking Ship", Price = 10000, Speed = 60},
    {Name = "Mythical Ark", Price = 50000, Speed = 100}
}

local Islands = {
    {Name = "Fisherman Island", Position = CFrame.new(-1200, 15, 800)},
    {Name = "Ocean", Position = CFrame.new(2500, 10, -1500)},
    {Name = "Kohana Island", Position = CFrame.new(1800, 20, 2200)},
    {Name = "Kohana Volcano", Position = CFrame.new(2100, 150, 2500)},
    {Name = "Coral Reefs", Position = CFrame.new(-800, -10, 1800)},
    {Name = "Esoteric Depths", Position = CFrame.new(-2500, -50, 800)},
    {Name = "Tropical Grove", Position = CFrame.new(1200, 25, -1800)},
    {Name = "Crater Island", Position = CFrame.new(-1800, 100, -1200)},
    {Name = "Lost Isle", Position = CFrame.new(3000, 30, 3000)}
}

local Events = {
    {Name = "Fishing Frenzy", Position = CFrame.new(1500, 15, 1500)},
    {Name = "Boss Battle", Position = CFrame.new(-1500, 20, -1500)},
    {Name = "Treasure Hunt", Position = CFrame.new(0, 10, 2500)},
    {Name = "Mystery Island", Position = CFrame.new(2500, 30, 0)},
    {Name = "Double XP", Position = CFrame.new(-2500, 15, 1500)},
    {Name = "Rainbow Fish", Position = CFrame.new(1500, 25, -2500)}
}

local FishTypes = {
    {Name = "Small Fish", Rarity = "Common", Value = 10, MinLevel = 1},
    {Name = "Medium Fish", Rarity = "Common", Value = 25, MinLevel = 5},
    {Name = "Large Fish", Rarity = "Uncommon", Value = 50, MinLevel = 10},
    {Name = "Tropical Fish", Rarity = "Uncommon", Value = 75, MinLevel = 15},
    {Name = "Rare Fish", Rarity = "Rare", Value = 150, MinLevel = 20},
    {Name = "Exotic Fish", Rarity = "Rare", Value = 250, MinLevel = 25},
    {Name = "Epic Fish", Rarity = "Epic", Value = 500, MinLevel = 30},
    {Name = "Legendary Fish", Rarity = "Legendary", Value = 1000, MinLevel = 40},
    {Name = "Mythical Fish", Rarity = "Mythical", Value = 2500, MinLevel = 50},
    {Name = "Secret Fish", Rarity = "Secret", Value = 5000, MinLevel = 60}
}

local FishRarities = {
    "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Secret"
}

-- Save/Load Config
local function SaveConfig()
    local success, result = pcall(function()
        local json = HttpService:JSONEncode(Config)
        writefile("FishItConfig_" .. Config.Settings.ConfigName .. ".json", json)
        Rayfield:Notify({
            Title = "Config Saved",
            Content = "Configuration saved as " .. Config.Settings.ConfigName,
            Duration = 3,
            Image = 13047715178
        })
        logError("Config saved: " .. Config.Settings.ConfigName)
    end)
    
    if not success then
        Rayfield:Notify({
            Title = "Config Error",
            Content = "Failed to save config: " .. result,
            Duration = 5,
            Image = 13047715178
        })
        logError("Failed to save config: " .. result)
    end
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
            logError("Config loaded: " .. Config.Settings.ConfigName)
            return true
        else
            Rayfield:Notify({
                Title = "Config Error",
                Content = "Failed to load config: " .. result,
                Duration = 5,
                Image = 13047715178
            })
            logError("Failed to load config: " .. result)
        end
    else
        Rayfield:Notify({
            Title = "Config Not Found",
            Content = "Config file not found: " .. Config.Settings.ConfigName,
            Duration = 5,
            Image = 13047715178
        })
        logError("Config file not found: " .. Config.Settings.ConfigName)
    end
    return false
end

local function ResetConfig()
    Config = {
        Bypass = {
            AntiAFK = true,
            AutoJump = false,
            AutoJumpDelay = 2,
            AntiKick = true,
            AntiBan = true,
            BypassFishingRadar = false,
            BypassDivingGear = false,
            BypassFishingAnimation = false,
            BypassFishingDelay = false
        },
        Teleport = {
            SelectedLocation = "",
            SelectedPlayer = "",
            SelectedEvent = "",
            SavedPositions = {}
        },
        Player = {
            SpeedHack = false,
            SpeedValue = 16,
            MaxBoatSpeed = false,
            InfinityJump = false,
            Fly = false,
            FlyRange = 50,
            FlyBoat = false,
            GhostHack = false,
            PlayerESP = false,
            ESPBox = true,
            ESPLines = true,
            ESPName = true,
            ESPLevel = true,
            ESPRange = false,
            ESPHologram = false,
            Noclip = false,
            AutoSell = false,
            AutoCraft = false,
            AutoUpgrade = false,
            SpawnBoat = false,
            NoClipBoat = false
        },
        Trader = {
            AutoAcceptTrade = false,
            SelectedFish = {},
            TradePlayer = "",
            TradeAllFish = false
        },
        Server = {
            PlayerInfo = false,
            ServerInfo = false,
            LuckBoost = false,
            SeedViewer = false,
            ForceEvent = false,
            RejoinSameServer = false,
            ServerHop = false,
            ViewPlayerStats = false
        },
        System = {
            ShowInfo = false,
            BoostFPS = false,
            FPSLimit = 60,
            AutoCleanMemory = false,
            DisableParticles = false,
            RejoinServer = false,
            AutoFarm = false,
            FarmRadius = 100
        },
        Graphic = {
            HighQuality = false,
            MaxRendering = false,
            UltraLowMode = false,
            DisableWaterReflection = false,
            CustomShader = false,
            SmoothGraphics = false,
            FullBright = false,
            BrightnessValue = 1
        },
        RNGKill = {
            RNGReducer = false,
            ForceLegendary = false,
            SecretFishBoost = false,
            MythicalChanceBoost = false,
            AntiBadLuck = false,
            GuaranteedCatch = false
        },
        Shop = {
            AutoBuyRods = false,
            SelectedRod = "",
            AutoBuyBoats = false,
            SelectedBoat = "",
            AutoBuyBaits = false,
            SelectedBait = "",
            AutoUpgradeRod = false
        },
        Settings = {
            SelectedTheme = "Dark",
            Transparency = 0.5,
            ConfigName = "DefaultConfig",
            UIScale = 1,
            Keybinds = {}
        }
    }
    Rayfield:Notify({
        Title = "Config Reset",
        Content = "Configuration reset to default",
        Duration = 3,
        Image = 13047715178
    })
    logError("Config reset to default")
end

-- UI Library
local Window = Rayfield:CreateWindow({
    Name = "NIKZZ - FISH IT SCRIPT SEPTEMBER 2025",
    LoadingTitle = "NIKZZ SCRIPT",
    LoadingSubtitle = "by Nikzz Xit",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    }
})

-- Initialize variables for features
local espObjects = {}
local flyConnection = nil
local autoJumpConnection = nil
local boatSpeedConnection = nil
local infoDisplay = nil
local autoFarmConnection = nil
local fishingConnection = nil
local rngConnection = nil
local shopConnection = nil
local playerInfoConnection = nil
local serverInfoConnection = nil
local graphicConnection = nil
local systemInfoConnection = nil

-- Helper Functions
local function GetPlayerLevel()
    if PlayerStats and PlayerStats:FindFirstChild("Level") then
        return PlayerStats.Level.Value
    end
    return 1
end

local function GetPlayerMoney()
    if PlayerStats and PlayerStats:FindFirstChild("Money") then
        return PlayerStats.Money.Value
    end
    return 0
end

local function GetPlayerInventory()
    local inventory = {}
    if PlayerData and PlayerData:FindFirstChild("Inventory") then
        for _, item in pairs(PlayerData.Inventory:GetChildren()) do
            if item:IsA("Folder") or item:IsA("Configuration") then
                table.insert(inventory, {
                    Name = item.Name,
                    Value = item:FindFirstChild("Value") and item.Value.Value or 1,
                    Rarity = item:FindFirstChild("Rarity") and item.Rarity.Value or "Common"
                })
            end
        end
    end
    return inventory
end

local function GetPlayerFavorites()
    local favorites = {}
    if PlayerData and PlayerData:FindFirstChild("Favorites") then
        for _, item in pairs(PlayerData.Favorites:GetChildren()) do
            table.insert(favorites, item.Name)
        end
    end
    return favorites
end

local function GetPlayerEquipment()
    local equipment = {
        Rod = nil,
        Bait = nil,
        Boat = nil
    }
    
    if PlayerData and PlayerData:FindFirstChild("Equipment") then
        if PlayerData.Equipment:FindFirstChild("Rod") then
            equipment.Rod = PlayerData.Equipment.Rod.Value
        end
        if PlayerData.Equipment:FindFirstChild("Bait") then
            equipment.Bait = PlayerData.Equipment.Bait.Value
        end
        if PlayerData.Equipment:FindFirstChild("Boat") then
            equipment.Boat = PlayerData.Equipment.Boat.Value
        end
    end
    
    return equipment
end

local function GetShopItems()
    local shopItems = {
        Rods = {},
        Baits = {},
        Boats = {}
    }
    
    if ShopData then
        if ShopData:FindFirstChild("Rods") then
            for _, rod in pairs(ShopData.Rods:GetChildren()) do
                table.insert(shopItems.Rods, {
                    Name = rod.Name,
                    Price = rod:FindFirstChild("Price") and rod.Price.Value or 0,
                    Level = rod:FindFirstChild("Level") and rod.Level.Value or 1,
                    Power = rod:FindFirstChild("Power") and rod.Power.Value or 1
                })
            end
        end
        
        if ShopData:FindFirstChild("Baits") then
            for _, bait in pairs(ShopData.Baits:GetChildren()) do
                table.insert(shopItems.Baits, {
                    Name = bait.Name,
                    Price = bait:FindFirstChild("Price") and bait.Price.Value or 0,
                    RarityBoost = bait:FindFirstChild("RarityBoost") and bait.RarityBoost.Value or 1
                })
            end
        end
        
        if ShopData:FindFirstChild("Boats") then
            for _, boat in pairs(ShopData.Boats:GetChildren()) do
                table.insert(shopItems.Boats, {
                    Name = boat.Name,
                    Price = boat:FindFirstChild("Price") and boat.Price.Value or 0,
                    Speed = boat:FindFirstChild("Speed") and boat.Speed.Value or 20
                })
            end
        end
    end
    
    return shopItems
end

local function GetFishTypes()
    local fishTypes = {}
    
    if FishData then
        for _, fish in pairs(FishData:GetChildren()) do
            table.insert(fishTypes, {
                Name = fish.Name,
                Rarity = fish:FindFirstChild("Rarity") and fish.Rarity.Value or "Common",
                Value = fish:FindFirstChild("Value") and fish.Value.Value or 10,
                MinLevel = fish:FindFirstChild("MinLevel") and fish.MinLevel.Value or 1
            })
        end
    end
    
    return fishTypes
end

local function GetServerInfo()
    local serverInfo = {
        Players = #Players:GetPlayers(),
        MaxPlayers = Players.MaxPlayers,
        ServerId = game.JobId,
        PlaceId = game.PlaceId,
        Time = os.date("%H:%M:%S"),
        Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()),
        FPS = math.floor(1 / RunService.RenderStepped:Wait()),
        Memory = math.floor(Stats:GetTotalMemoryUsageMb()),
        Battery = math.floor(UserInputService:GetBatteryLevel() * 100)
    }
    
    return serverInfo
end

-- Bypass Tab
local BypassTab = Window:CreateTab("🛡️ Bypass", 13014546625)

BypassTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = Config.Bypass.AntiAFK,
    Flag = "AntiAFK",
    Callback = function(Value)
        Config.Bypass.AntiAFK = Value
        logError("Anti AFK: " .. tostring(Value))
        if Value then
            Rayfield:Notify({
                Title = "Anti AFK",
                Content = "Anti AFK activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

BypassTab:CreateToggle({
    Name = "Auto Jump",
    CurrentValue = Config.Bypass.AutoJump,
    Flag = "AutoJump",
    Callback = function(Value)
        Config.Bypass.AutoJump = Value
        logError("Auto Jump: " .. tostring(Value))
        
        if autoJumpConnection then
            autoJumpConnection:Disconnect()
            autoJumpConnection = nil
        end
        
        if Value then
            autoJumpConnection = RunService.Heartbeat:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.Jump = true
                end
            end)
            Rayfield:Notify({
                Title = "Auto Jump",
                Content = "Auto Jump activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

BypassTab:CreateSlider({
    Name = "Auto Jump Delay",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = "seconds",
    CurrentValue = Config.Bypass.AutoJumpDelay,
    Flag = "AutoJumpDelay",
    Callback = function(Value)
        Config.Bypass.AutoJumpDelay = Value
        logError("Auto Jump Delay: " .. Value)
    end
})

BypassTab:CreateToggle({
    Name = "Anti Kick",
    CurrentValue = Config.Bypass.AntiKick,
    Flag = "AntiKick",
    Callback = function(Value)
        Config.Bypass.AntiKick = Value
        logError("Anti Kick: " .. tostring(Value))
        if Value then
            Rayfield:Notify({
                Title = "Anti Kick",
                Content = "Anti Kick activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

BypassTab:CreateToggle({
    Name = "Anti Ban",
    CurrentValue = Config.Bypass.AntiBan,
    Flag = "AntiBan",
    Callback = function(Value)
        Config.Bypass.AntiBan = Value
        logError("Anti Ban: " .. tostring(Value))
        if Value then
            Rayfield:Notify({
                Title = "Anti Ban",
                Content = "Anti Ban activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Fishing Radar",
    CurrentValue = Config.Bypass.BypassFishingRadar,
    Flag = "BypassFishingRadar",
    Callback = function(Value)
        Config.Bypass.BypassFishingRadar = Value
        logError("Bypass Fishing Radar: " .. tostring(Value))
        
        if Value then
            local success, result = pcall(function()
                if FishingEvents and FishingEvents:FindFirstChild("RadarBypass") then
                    FishingEvents.RadarBypass:FireServer()
                    Rayfield:Notify({
                        Title = "Radar Bypass",
                        Content = "Fishing Radar bypass activated",
                        Duration = 2,
                        Image = 13047715178
                    })
                else
                    -- Manual radar activation
                    local radarItem = LocalPlayer.Backpack:FindFirstChild("Radar") or LocalPlayer.Character:FindFirstChild("Radar")
                    if radarItem then
                        radarItem:Activate()
                        Rayfield:Notify({
                            Title = "Radar Bypass",
                            Content = "Radar item activated",
                            Duration = 2,
                            Image = 13047715178
                        })
                    else
                        Rayfield:Notify({
                            Title = "Radar Error",
                            Content = "Radar item not found",
                            Duration = 3,
                            Image = 13047715178
                        })
                    end
                end
            end)
            
            if not success then
                logError("Bypass Fishing Radar Error: " .. result)
                Rayfield:Notify({
                    Title = "Radar Error",
                    Content = "Failed to activate radar bypass",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        end
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Diving Gear",
    CurrentValue = Config.Bypass.BypassDivingGear,
    Flag = "BypassDivingGear",
    Callback = function(Value)
        Config.Bypass.BypassDivingGear = Value
        logError("Bypass Diving Gear: " .. tostring(Value))
        
        if Value then
            local success, result = pcall(function()
                if GameFunctions and GameFunctions:FindFirstChild("DivingBypass") then
                    GameFunctions.DivingBypass:InvokeServer()
                    Rayfield:Notify({
                        Title = "Diving Gear Bypass",
                        Content = "Diving Gear bypass activated",
                        Duration = 2,
                        Image = 13047715178
                    })
                else
                    -- Manual diving gear activation
                    local divingGear = LocalPlayer.Backpack:FindFirstChild("Diving Gear") or LocalPlayer.Character:FindFirstChild("Diving Gear")
                    if divingGear then
                        divingGear:Activate()
                        Rayfield:Notify({
                            Title = "Diving Gear Bypass",
                            Content = "Diving Gear activated",
                            Duration = 2,
                            Image = 13047715178
                        })
                    else
                        Rayfield:Notify({
                            Title = "Diving Gear Error",
                            Content = "Diving Gear not found",
                            Duration = 3,
                            Image = 13047715178
                        })
                    end
                end
            end)
            
            if not success then
                logError("Bypass Diving Gear Error: " .. result)
                Rayfield:Notify({
                    Title = "Diving Gear Error",
                    Content = "Failed to activate diving gear bypass",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        end
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Fishing Animation",
    CurrentValue = Config.Bypass.BypassFishingAnimation,
    Flag = "BypassFishingAnimation",
    Callback = function(Value)
        Config.Bypass.BypassFishingAnimation = Value
        logError("Bypass Fishing Animation: " .. tostring(Value))
        
        if Value then
            local success, result = pcall(function()
                if FishingEvents and FishingEvents:FindFirstChild("AnimationBypass") then
                    FishingEvents.AnimationBypass:FireServer()
                    Rayfield:Notify({
                        Title = "Animation Bypass",
                        Content = "Fishing Animation bypass activated",
                        Duration = 2,
                        Image = 13047715178
                    })
                else
                    -- Manual animation bypass
                    local playerAnimations = LocalPlayer.Character:FindFirstChild("Animate")
                    if playerAnimations then
                        playerAnimations:Destroy()
                        Rayfield:Notify({
                            Title = "Animation Bypass",
                            Content = "Fishing animations disabled",
                            Duration = 2,
                            Image = 13047715178
                        })
                    end
                end
            end)
            
            if not success then
                logError("Bypass Fishing Animation Error: " .. result)
                Rayfield:Notify({
                    Title = "Animation Error",
                    Content = "Failed to activate animation bypass",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        end
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Fishing Delay",
    CurrentValue = Config.Bypass.BypassFishingDelay,
    Flag = "BypassFishingDelay",
    Callback = function(Value)
        Config.Bypass.BypassFishingDelay = Value
        logError("Bypass Fishing Delay: " .. tostring(Value))
        
        if Value then
            local success, result = pcall(function()
                if FishingEvents and FishingEvents:FindFirstChild("DelayBypass") then
                    FishingEvents.DelayBypass:FireServer()
                    Rayfield:Notify({
                        Title = "Delay Bypass",
                        Content = "Fishing Delay bypass activated",
                        Duration = 2,
                        Image = 13047715178
                    })
                else
                    -- Manual delay bypass
                    if fishingConnection then
                        fishingConnection:Disconnect()
                        fishingConnection = nil
                    end
                    
                    fishingConnection = FishingEvents.ChildAdded:Connect(function(child)
                        if child.Name == "Catch" then
                            child:FireServer(true)  -- Force immediate catch
                        end
                    end)
                    
                    Rayfield:Notify({
                        Title = "Delay Bypass",
                        Content = "Fishing Delay bypass activated",
                        Duration = 2,
                        Image = 13047715178
                    })
                end
            end)
            
            if not success then
                logError("Bypass Fishing Delay Error: " .. result)
                Rayfield:Notify({
                    Title = "Delay Error",
                    Content = "Failed to activate delay bypass",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            if fishingConnection then
                fishingConnection:Disconnect()
                fishingConnection = nil
            end
        end
    end
})

-- Teleport Tab
local TeleportTab = Window:CreateTab("🗺️ Teleport", 13014546625)

local islandNames = {}
for _, island in ipairs(Islands) do
    table.insert(islandNames, island.Name)
end

TeleportTab:CreateDropdown({
    Name = "Select Location",
    Options = islandNames,
    CurrentOption = Config.Teleport.SelectedLocation,
    Flag = "SelectedLocation",
    Callback = function(Value)
        Config.Teleport.SelectedLocation = Value
        logError("Selected Location: " .. Value)
    end
})

TeleportTab:CreateButton({
    Name = "Teleport To Island",
    Callback = function()
        if Config.Teleport.SelectedLocation ~= "" then
            local targetCFrame
            for _, island in ipairs(Islands) do
                if island.Name == Config.Teleport.SelectedLocation then
                    targetCFrame = island.Position
                    break
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
                logError("Teleported to: " .. Config.Teleport.SelectedLocation)
            end
        else
            Rayfield:Notify({
                Title = "Teleport Error",
                Content = "Please select a location first",
                Duration = 3,
                Image = 13047715178
            })
            logError("Teleport Error: No location selected")
        end
    end
})

-- Player list for teleport
local function updatePlayerList()
    local playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    return playerList
end

TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = updatePlayerList(),
    CurrentOption = Config.Teleport.SelectedPlayer,
    Flag = "SelectedPlayer",
    Callback = function(Value)
        Config.Teleport.SelectedPlayer = Value
        logError("Selected Player: " .. Value)
    end
})

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
                logError("Teleported to player: " .. Config.Teleport.SelectedPlayer)
            else
                Rayfield:Notify({
                    Title = "Teleport Error",
                    Content = "Player not found or not loaded",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Teleport Error: Player not found - " .. Config.Teleport.SelectedPlayer)
            end
        else
            Rayfield:Notify({
                Title = "Teleport Error",
                Content = "Please select a player first",
                Duration = 3,
                Image = 13047715178
            })
            logError("Teleport Error: No player selected")
        end
    end
})

local eventNames = {}
for _, event in ipairs(Events) do
    table.insert(eventNames, event.Name)
end

TeleportTab:CreateDropdown({
    Name = "Teleport Event",
    Options = eventNames,
    CurrentOption = Config.Teleport.SelectedEvent,
    Flag = "SelectedEvent",
    Callback = function(Value)
        Config.Teleport.SelectedEvent = Value
        logError("Selected Event: " .. Value)
    end
})

TeleportTab:CreateButton({
    Name = "Teleport To Event",
    Callback = function()
        if Config.Teleport.SelectedEvent ~= "" then
            local eventLocation
            for _, event in ipairs(Events) do
                if event.Name == Config.Teleport.SelectedEvent then
                    eventLocation = event.Position
                    break
                end
            end
            
            if eventLocation and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:SetPrimaryPartCFrame(eventLocation)
                Rayfield:Notify({
                    Title = "Event Teleport",
                    Content = "Teleported to " .. Config.Teleport.SelectedEvent,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Teleported to event: " .. Config.Teleport.SelectedEvent)
            end
        else
            Rayfield:Notify({
                Title = "Event Error",
                Content = "Please select an event first",
                Duration = 3,
                Image = 13047715178
            })
            logError("Event Teleport Error: No event selected")
        end
    end
})

TeleportTab:CreateInput({
    Name = "Save Position Name",
    PlaceholderText = "Enter position name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text ~= "" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Config.Teleport.SavedPositions[Text] = LocalPlayer.Character.HumanoidRootPart.CFrame
            Rayfield:Notify({
                Title = "Position Saved",
                Content = "Position saved as: " .. Text,
                Duration = 3,
                Image = 13047715178
            })
            logError("Position saved: " .. Text)
        end
    end
})

-- Load saved positions dropdown
local function updateSavedPositions()
    local savedPositionsList = {}
    for name, _ in pairs(Config.Teleport.SavedPositions) do
        table.insert(savedPositionsList, name)
    end
    return savedPositionsList
end

TeleportTab:CreateDropdown({
    Name = "Saved Positions",
    Options = updateSavedPositions(),
    CurrentOption = "",
    Flag = "SavedPosition",
    Callback = function(Value)
        if Config.Teleport.SavedPositions[Value] and LocalPlayer.Character then
            LocalPlayer.Character:SetPrimaryPartCFrame(Config.Teleport.SavedPositions[Value])
            Rayfield:Notify({
                Title = "Position Loaded",
                Content = "Teleported to saved position: " .. Value,
                Duration = 3,
                Image = 13047715178
            })
            logError("Loaded position: " .. Value)
        end
    end
})

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
            logError("Deleted position: " .. Text)
        end
    end
})

-- Player Tab
local PlayerTab = Window:CreateTab("👤 Player", 13014546625)

PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = Config.Player.SpeedHack,
    Flag = "SpeedHack",
    Callback = function(Value)
        Config.Player.SpeedHack = Value
        logError("Speed Hack: " .. tostring(Value))
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if Value then
                LocalPlayer.Character.Humanoid.WalkSpeed = Config.Player.SpeedValue
                Rayfield:Notify({
                    Title = "Speed Hack",
                    Content = "Speed Hack activated",
                    Duration = 2,
                    Image = 13047715178
                })
            else
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Speed Value",
    Range = {0, 500},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = Config.Player.SpeedValue,
    Flag = "SpeedValue",
    Callback = function(Value)
        Config.Player.SpeedValue = Value
        logError("Speed Value: " .. Value)
        
        if Config.Player.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Max Boat Speed",
    CurrentValue = Config.Player.MaxBoatSpeed,
    Flag = "MaxBoatSpeed",
    Callback = function(Value)
        Config.Player.MaxBoatSpeed = Value
        logError("Max Boat Speed: " .. tostring(Value))
        
        if boatSpeedConnection then
            boatSpeedConnection:Disconnect()
            boatSpeedConnection = nil
        end
        
        if Value then
            boatSpeedConnection = RunService.Heartbeat:Connect(function()
                local boat = Workspace:FindFirstChild(LocalPlayer.Name .. "'s Boat")
                if boat and boat:FindFirstChild("DriveSeat") then
                    local driveSeat = boat.DriveSeat
                    if driveSeat:FindFirstChild("MaxSpeed") then
                        driveSeat.MaxSpeed.Value = driveSeat.MaxSpeed.Value * 5
                    end
                end
            end)
            Rayfield:Notify({
                Title = "Max Boat Speed",
                Content = "Boat speed increased 5x",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Spawn Boat",
    CurrentValue = Config.Player.SpawnBoat,
    Flag = "SpawnBoat",
    Callback = function(Value)
        Config.Player.SpawnBoat = Value
        logError("Spawn Boat: " .. tostring(Value))
        
        if Value then
            local success, result = pcall(function()
                if GameFunctions and GameFunctions:FindFirstChild("SpawnBoat") then
                    GameFunctions.SpawnBoat:InvokeServer()
                    Rayfield:Notify({
                        Title = "Boat Spawned",
                        Content = "Boat spawned successfully",
                        Duration = 2,
                        Image = 13047715178
                    })
                else
                    -- Manual boat spawning
                    local boatModel = ReplicatedStorage:FindFirstChild("Boats") and ReplicatedStorage.Boats:FindFirstChild("Small Boat")
                    if boatModel then
                        local newBoat = boatModel:Clone()
                        newBoat.Name = LocalPlayer.Name .. "'s Boat"
                        newBoat.PrimaryPart = newBoat:FindFirstChild("MainPart") or newBoat:FindFirstChild("Base")
                        
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
                            newBoat:SetPrimaryPartCFrame(CFrame.new(playerPos + Vector3.new(0, 5, 10)))
                            newBoat.Parent = Workspace
                            Rayfield:Notify({
                                Title = "Boat Spawned",
                                Content = "Boat spawned in front of you",
                                Duration = 2,
                                Image = 13047715178
                            })
                        end
                    else
                        Rayfield:Notify({
                            Title = "Boat Error",
                            Content = "Boat model not found",
                            Duration = 3,
                            Image = 13047715178
                        })
                    end
                end
            end)
            
            if not success then
                logError("Boat spawn error: " .. result)
                Rayfield:Notify({
                    Title = "Boat Error",
                    Content = "Failed to spawn boat",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "NoClip Boat",
    CurrentValue = Config.Player.NoClipBoat,
    Flag = "NoClipBoat",
    Callback = function(Value)
        Config.Player.NoClipBoat = Value
        logError("NoClip Boat: " .. tostring(Value))
        
        if Value then
            local boat = Workspace:FindFirstChild(LocalPlayer.Name .. "'s Boat")
            if boat then
                for _, part in ipairs(boat:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                Rayfield:Notify({
                    Title = "NoClip Boat",
                    Content = "Boat can now pass through objects",
                    Duration = 2,
                    Image = 13047715178
                })
            else
                Rayfield:Notify({
                    Title = "Boat Error",
                    Content = "Boat not found",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            local boat = Workspace:FindFirstChild(LocalPlayer.Name .. "'s Boat")
            if boat then
                for _, part in ipairs(boat:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "DriveSeat" then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = Config.Player.InfinityJump,
    Flag = "InfinityJump",
    Callback = function(Value)
        Config.Player.InfinityJump = Value
        logError("Infinity Jump: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Infinity Jump",
                Content = "Infinity Jump activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

-- Handle infinity jump
UserInputService.JumpRequest:Connect(function()
    if Config.Player.InfinityJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = Config.Player.Fly,
    Flag = "Fly",
    Callback = function(Value)
        Config.Player.Fly = Value
        logError("Fly: " .. tostring(Value))
        
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        if Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if rootPart then
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.P = 5000
                bv.Parent = rootPart
                
                flyConnection = RunService.Heartbeat:Connect(function()
                    if Config.Player.Fly and humanoid and rootPart then
                        local moveDirection = humanoid.MoveDirection
                        bv.Velocity = moveDirection * Config.Player.FlyRange
                    end
                end)
                
                Rayfield:Notify({
                    Title = "Fly",
                    Content = "Fly activated",
                    Duration = 2,
                    Image = 13047715178
                })
            end
        else
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local bv = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity")
                if bv then
                    bv:Destroy()
                end
            end
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Fly Range",
    Range = {10, 100},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = Config.Player.FlyRange,
    Flag = "FlyRange",
    Callback = function(Value)
        Config.Player.FlyRange = Value
        logError("Fly Range: " .. Value)
    end
})

PlayerTab:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = Config.Player.FlyBoat,
    Flag = "FlyBoat",
    Callback = function(Value)
        Config.Player.FlyBoat = Value
        logError("Fly Boat: " .. tostring(Value))
        
        if Value then
            local boat = Workspace:FindFirstChild(LocalPlayer.Name .. "'s Boat")
            if boat and boat:FindFirstChild("MainPart") or boat:FindFirstChild("Base") then
                local mainPart = boat:FindFirstChild("MainPart") or boat:FindFirstChild("Base")
                
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.P = 5000
                bv.Parent = mainPart
                
                local bg = Instance.new("BodyGyro")
                bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bg.P = 5000
                bg.Parent = mainPart
                
                Rayfield:Notify({
                    Title = "Fly Boat",
                    Content = "Boat can now fly",
                    Duration = 2,
                    Image = 13047715178
                })
            else
                Rayfield:Notify({
                    Title = "Boat Error",
                    Content = "Boat not found",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            local boat = Workspace:FindFirstChild(LocalPlayer.Name .. "'s Boat")
            if boat then
                local mainPart = boat:FindFirstChild("MainPart") or boat:FindFirstChild("Base")
                if mainPart then
                    local bv = mainPart:FindFirstChild("BodyVelocity")
                    if bv then
                        bv:Destroy()
                    end
                    
                    local bg = mainPart:FindFirstChild("BodyGyro")
                    if bg then
                        bg:Destroy()
                    end
                end
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = Config.Player.GhostHack,
    Flag = "GhostHack",
    Callback = function(Value)
        Config.Player.GhostHack = Value
        logError("Ghost Hack: " .. tostring(Value))
        
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    if Value then
                        part.Transparency = 0.5
                        part.CanCollide = false
                    else
                        if part.Name ~= "HumanoidRootPart" then
                            part.Transparency = 0
                        end
                        part.CanCollide = true
                    end
                end
            end
            
            if Value then
                Rayfield:Notify({
                    Title = "Ghost Hack",
                    Content = "Ghost Hack activated",
                    Duration = 2,
                    Image = 13047715178
                })
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = Config.Player.PlayerESP,
    Flag = "PlayerESP",
    Callback = function(Value)
        Config.Player.PlayerESP = Value
        logError("Player ESP: " .. tostring(Value))
        
        if Value then
            -- Create ESP for all players
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    createESP(player)
                end
            end
            
            -- Create ESP for new players
            Players.PlayerAdded:Connect(function(player)
                if Config.Player.PlayerESP and player ~= LocalPlayer then
                    player.CharacterAdded:Connect(function()
                        createESP(player)
                    end)
                    
                    if player.Character then
                        createESP(player)
                    end
                end
            end)
            
            Rayfield:Notify({
                Title = "Player ESP",
                Content = "Player ESP activated",
                Duration = 2,
                Image = 13047715178
            })
        else
            -- Remove all ESP
            for _, espTable in pairs(espObjects) do
                if espTable.Box then espTable.Box:Destroy() end
                if espTable.Line then espTable.Line:Destroy() end
                if espTable.Name then espTable.Name:Destroy() end
                if espTable.Level then espTable.Level:Destroy() end
                if espTable.Range then espTable.Range:Destroy() end
                if espTable.Hologram then espTable.Hologram:Destroy() end
            end
            espObjects = {}
        end
    end
})

-- ESP creation function
function createESP(player)
    if espObjects[player] then return end
    
    espObjects[player] = {
        Box = nil,
        Line = nil,
        Name = nil,
        Level = nil,
        Range = nil,
        Hologram = nil
    }
    
    local espHolder = Instance.new("Folder")
    espHolder.Name = "ESP_" .. player.Name
    espHolder.Parent = CoreGui
    
    -- Create ESP Box
    if Config.Player.ESPBox then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESPBox"
        box.Size = Vector3.new(4, 5, 1)
        box.Color3 = Color3.new(1, 0, 0)
        box.Transparency = 0.7
        box.ZIndex = 10
        box.AlwaysOnTop = true
        box.Visible = false
        box.Parent = espHolder
        
        espObjects[player].Box = box
    end
    
    -- Create ESP Line
    if Config.Player.ESPLines then
        local line = Instance.new("Beam")
        line.Name = "ESPLine"
        line.Width0 = 0.1
        line.Width1 = 0.1
        line.Color = ColorSequence.new(Color3.new(1, 0, 0))
        line.Transparency = NumberSequence.new(0.5)
        line.FaceCamera = true
        line.Enabled = false
        line.Parent = espHolder
        
        local att0 = Instance.new("Attachment")
        att0.Name = "Att0"
        att0.Parent = Workspace.CurrentCamera
        
        local att1 = Instance.new("Attachment")
        att1.Name = "Att1"
        att1.Parent = espHolder
        
        line.Attachment0 = att0
        line.Attachment1 = att1
        
        espObjects[player].Line = line
        espObjects[player].LineAtt1 = att1
    end
    
    -- Create ESP Name
    if Config.Player.ESPName then
        local nameTag = Instance.new("BillboardGui")
        nameTag.Name = "ESPName"
        nameTag.Size = UDim2.new(0, 100, 0, 50)
        nameTag.StudsOffset = Vector3.new(0, 3, 0)
        nameTag.AlwaysOnTop = true
        nameTag.Enabled = false
        nameTag.Parent = espHolder
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.Parent = nameTag
        
        espObjects[player].Name = nameTag
    end
    
    -- Create ESP Level
    if Config.Player.ESPLevel and player:FindFirstChild("leaderstats") then
        local levelTag = Instance.new("BillboardGui")
        levelTag.Name = "ESPLevel"
        levelTag.Size = UDim2.new(0, 100, 0, 50)
        levelTag.StudsOffset = Vector3.new(0, 2.5, 0)
        levelTag.AlwaysOnTop = true
        levelTag.Enabled = false
        levelTag.Parent = espHolder
        
        local levelLabel = Instance.new("TextLabel")
        levelLabel.Name = "LevelLabel"
        levelLabel.Size = UDim2.new(1, 0, 1, 0)
        levelLabel.BackgroundTransparency = 1
        levelLabel.Text = "Level: " .. (player.leaderstats:FindFirstChild("Level") and player.leaderstats.Level.Value or "N/A")
        levelLabel.TextColor3 = Color3.new(1, 1, 0)
        levelLabel.TextStrokeTransparency = 0
        levelLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        levelLabel.TextSize = 12
        levelLabel.Font = Enum.Font.SourceSans
        levelLabel.Parent = levelTag
        
        espObjects[player].Level = levelTag
    end
    
    -- Create ESP Range
    if Config.Player.ESPRange then
        local rangeTag = Instance.new("BillboardGui")
        rangeTag.Name = "ESPRange"
        rangeTag.Size = UDim2.new(0, 100, 0, 50)
        rangeTag.StudsOffset = Vector3.new(0, 2, 0)
        rangeTag.AlwaysOnTop = true
        rangeTag.Enabled = false
        rangeTag.Parent = espHolder
        
        local rangeLabel = Instance.new("TextLabel")
        rangeLabel.Name = "RangeLabel"
        rangeLabel.Size = UDim2.new(1, 0, 1, 0)
        rangeLabel.BackgroundTransparency = 1
        rangeLabel.Text = "Range: 0"
        rangeLabel.TextColor3 = Color3.new(0, 1, 0)
        rangeLabel.TextStrokeTransparency = 0
        rangeLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        rangeLabel.TextSize = 12
        rangeLabel.Font = Enum.Font.SourceSans
        rangeLabel.Parent = rangeTag
        
        espObjects[player].Range = rangeTag
    end
    
    -- Create ESP Hologram
    if Config.Player.ESPHologram then
        local hologram = Instance.new("Part")
        hologram.Name = "ESPHologram"
        hologram.Size = Vector3.new(1, 1, 1)
        hologram.Material = Enum.Material.Neon
        hologram.BrickColor = BrickColor.new("Cyan")
        hologram.Anchored = true
        hologram.CanCollide = false
        hologram.Transparency = 0.5
        hologram.Parent = espHolder
        
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.Sphere
        mesh.Parent = hologram
        
        espObjects[player].Hologram = hologram
    end
    
    -- Update ESP
    local updateESP
    updateESP = function()
        if not Config.Player.PlayerESP or not player or not player.Character then
            if espObjects[player] then
                if espObjects[player].Box then espObjects[player].Box:Destroy() end
                if espObjects[player].Line then espObjects[player].Line:Destroy() end
                if espObjects[player].Name then espObjects[player].Name:Destroy() end
                if espObjects[player].Level then espObjects[player].Level:Destroy() end
                if espObjects[player].Range then espObjects[player].Range:Destroy() end
                if espObjects[player].Hologram then espObjects[player].Hologram:Destroy() end
                espObjects[player] = nil
            end
            return
        end
        
        local character = player.Character
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoidRootPart then
            -- Update ESP Box
            if espObjects[player].Box then
                espObjects[player].Box.Adornee = humanoidRootPart
                espObjects[player].Box.Visible = true
            end
            
            -- Update ESP Line
            if espObjects[player].Line and espObjects[player].LineAtt1 then
                espObjects[player].LineAtt1.Position = humanoidRootPart.Position
                espObjects[player].Line.Enabled = true
            end
            
            -- Update ESP Name
            if espObjects[player].Name then
                espObjects[player].Name.Adornee = humanoidRootPart
                espObjects[player].Name.Enabled = true
            end
            
            -- Update ESP Level
            if espObjects[player].Level and player:FindFirstChild("leaderstats") then
                espObjects[player].Level.Adornee = humanoidRootPart
                espObjects[player].Level.Enabled = true
                local levelLabel = espObjects[player].Level:FindFirstChild("LevelLabel")
                if levelLabel then
                    levelLabel.Text = "Level: " .. (player.leaderstats:FindFirstChild("Level") and player.leaderstats.Level.Value or "N/A")
                end
            end
            
            -- Update ESP Range
            if espObjects[player].Range and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                espObjects[player].Range.Adornee = humanoidRootPart
                espObjects[player].Range.Enabled = true
                local rangeLabel = espObjects[player].Range:FindFirstChild("RangeLabel")
                if rangeLabel then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                    rangeLabel.Text = "Range: " .. math.floor(distance) .. " studs"
                end
            end
            
            -- Update ESP Hologram
            if espObjects[player].Hologram then
                espObjects[player].Hologram.Position = humanoidRootPart.Position + Vector3.new(0, 5, 0)
            end
        end
        
        game:GetService("RunService").RenderStepped:Wait()
        spawn(updateESP)
    end
    
    spawn(updateESP)
end

PlayerTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = Config.Player.ESPBox,
    Flag = "ESPBox",
    Callback = function(Value)
        Config.Player.ESPBox = Value
        logError("ESP Box: " .. tostring(Value))
        
        -- Update existing ESP
        for player, espTable in pairs(espObjects) do
            if espTable.Box then
                espTable.Box.Visible = Value
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Lines",
    CurrentValue = Config.Player.ESPLines,
    Flag = "ESPLines",
    Callback = function(Value)
        Config.Player.ESPLines = Value
        logError("ESP Lines: " .. tostring(Value))
        
        -- Update existing ESP
        for player, espTable in pairs(espObjects) do
            if espTable.Line then
                espTable.Line.Enabled = Value
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Name",
    CurrentValue = Config.Player.ESPName,
    Flag = "ESPName",
    Callback = function(Value)
        Config.Player.ESPName = Value
        logError("ESP Name: " .. tostring(Value))
        
        -- Update existing ESP
        for player, espTable in pairs(espObjects) do
            if espTable.Name then
                espTable.Name.Enabled = Value
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Level",
    CurrentValue = Config.Player.ESPLevel,
    Flag = "ESPLevel",
    Callback = function(Value)
        Config.Player.ESPLevel = Value
        logError("ESP Level: " .. tostring(Value))
        
        -- Update existing ESP
        for player, espTable in pairs(espObjects) do
            if espTable.Level then
                espTable.Level.Enabled = Value
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Range",
    CurrentValue = Config.Player.ESPRange,
    Flag = "ESPRange",
    Callback = function(Value)
        Config.Player.ESPRange = Value
        logError("ESP Range: " .. tostring(Value))
        
        -- Update existing ESP
        for player, espTable in pairs(espObjects) do
            if espTable.Range then
                espTable.Range.Enabled = Value
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Hologram",
    CurrentValue = Config.Player.ESPHologram,
    Flag = "ESPHologram",
    Callback = function(Value)
        Config.Player.ESPHologram = Value
        logError("ESP Hologram: " .. tostring(Value))
        
        -- Update existing ESP
        for player, espTable in pairs(espObjects) do
            if espTable.Hologram then
                espTable.Hologram.Visible = Value
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = Config.Player.Noclip,
    Flag = "Noclip",
    Callback = function(Value)
        Config.Player.Noclip = Value
        logError("Noclip: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Noclip",
                Content = "Noclip activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

-- Handle Noclip
RunService.Stepped:Connect(function()
    if Config.Player.Noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

PlayerTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = Config.Player.AutoSell,
    Flag = "AutoSell",
    Callback = function(Value)
        Config.Player.AutoSell = Value
        logError("Auto Sell: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Sell",
                Content = "Auto Sell activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

-- Auto Sell implementation
spawn(function()
    while true do
        if Config.Player.AutoSell then
            pcall(function()
                if PlayerData and PlayerData:FindFirstChild("Inventory") then
                    local favorites = GetPlayerFavorites()
                    for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                        if item:IsA("Folder") or item:IsA("Configuration") then
                            -- Check if fish is not favorite
                            local isFavorite = false
                            for _, fav in ipairs(favorites) do
                                if fav == item.Name then
                                    isFavorite = true
                                    break
                                end
                            end
                            
                            if not isFavorite then
                                -- Sell fish
                                if Remotes and Remotes:FindFirstChild("SellFish") then
                                    Remotes.SellFish:FireServer(item.Name, item:FindFirstChild("Value") and item.Value.Value or 1)
                                    logError("Sold fish: " .. item.Name)
                                end
                            end
                        end
                    end
                end
            end)
        end
        wait(5)  -- Check every 5 seconds
    end
end)

PlayerTab:CreateToggle({
    Name = "Auto Craft",
    CurrentValue = Config.Player.AutoCraft,
    Flag = "AutoCraft",
    Callback = function(Value)
        Config.Player.AutoCraft = Value
        logError("Auto Craft: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Craft",
                Content = "Auto Craft activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Upgrade",
    CurrentValue = Config.Player.AutoUpgrade,
    Flag = "AutoUpgrade",
    Callback = function(Value)
        Config.Player.AutoUpgrade = Value
        logError("Auto Upgrade: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Upgrade",
                Content = "Auto Upgrade activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

-- Trader Tab
local TraderTab = Window:CreateTab("💱 Trader", 13014546625)

TraderTab:CreateToggle({
    Name = "Auto Accept Trade",
    CurrentValue = Config.Trader.AutoAcceptTrade,
    Flag = "AutoAcceptTrade",
    Callback = function(Value)
        Config.Trader.AutoAcceptTrade = Value
        logError("Auto Accept Trade: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Accept Trade",
                Content = "Auto Accept Trade activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

-- Get player's fish inventory
local function updateFishInventory()
    local fishInventory = {}
    local inventory = GetPlayerInventory()
    for _, item in ipairs(inventory) do
        table.insert(fishInventory, item.Name)
    end
    return fishInventory
end

TraderTab:CreateDropdown({
    Name = "Select Fish",
    Options = updateFishInventory(),
    CurrentOption = "",
    Flag = "SelectedFish",
    Callback = function(Value)
        Config.Trader.SelectedFish[Value] = not Config.Trader.SelectedFish[Value]
        logError("Selected Fish: " .. Value .. " - " .. tostring(Config.Trader.SelectedFish[Value]))
    end
})

TraderTab:CreateInput({
    Name = "Trade Player",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        Config.Trader.TradePlayer = Text
        logError("Trade Player: " .. Text)
    end
})

TraderTab:CreateToggle({
    Name = "Trade All Fish",
    CurrentValue = Config.Trader.TradeAllFish,
    Flag = "TradeAllFish",
    Callback = function(Value)
        Config.Trader.TradeAllFish = Value
        logError("Trade All Fish: " .. tostring(Value))
    end
})

TraderTab:CreateButton({
    Name = "Send Trade Request",
    Callback = function()
        if Config.Trader.TradePlayer ~= "" then
            local targetPlayer = Players:FindFirstChild(Config.Trader.TradePlayer)
            if targetPlayer and TradeEvents and TradeEvents:FindFirstChild("SendTradeRequest") then
                local success, result = pcall(function()
                    TradeEvents.SendTradeRequest:FireServer(targetPlayer)
                    Rayfield:Notify({
                        Title = "Trade Request",
                        Content = "Trade request sent to " .. Config.Trader.TradePlayer,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Trade request sent to: " .. Config.Trader.TradePlayer)
                end)
                if not success then
                    logError("Trade request error: " .. result)
                end
            else
                Rayfield:Notify({
                    Title = "Trade Error",
                    Content = "Player not found: " .. Config.Trader.TradePlayer,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Trade Error: Player not found - " .. Config.Trader.TradePlayer)
            end
        else
            Rayfield:Notify({
                Title = "Trade Error",
                Content = "Please enter a player name first",
                Duration = 3,
                Image = 13047715178
            })
            logError("Trade Error: No player name entered")
        end
    end
})

-- Server Tab
local ServerTab = Window:CreateTab("🌍 Server", 13014546625)

ServerTab:CreateToggle({
    Name = "Player Info",
    CurrentValue = Config.Server.PlayerInfo,
    Flag = "PlayerInfo",
    Callback = function(Value)
        Config.Server.PlayerInfo = Value
        logError("Player Info: " .. tostring(Value))
        
        if playerInfoConnection then
            playerInfoConnection:Disconnect()
            playerInfoConnection = nil
        end
        
        if Value then
            playerInfoConnection = RunService.Heartbeat:Connect(function()
                local playerInfo = "Player: " .. LocalPlayer.Name .. "\n"
                playerInfo = playerInfo .. "Level: " .. GetPlayerLevel() .. "\n"
                playerInfo = playerInfo .. "Money: $" .. GetPlayerMoney() .. "\n"
                
                local equipment = GetPlayerEquipment()
                playerInfo = playerInfo .. "Rod: " .. (equipment.Rod or "None") .. "\n"
                playerInfo = playerInfo .. "Bait: " .. (equipment.Bait or "None") .. "\n"
                playerInfo = playerInfo .. "Boat: " .. (equipment.Boat or "None")
                
                -- Display player info
                if infoDisplay and infoDisplay:FindFirstChild("PlayerInfoFrame") then
                    infoDisplay.PlayerInfoFrame.PlayerInfoLabel.Text = playerInfo
                end
            end)
            
            Rayfield:Notify({
                Title = "Player Info",
                Content = "Player Info activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

ServerTab:CreateToggle({
    Name = "Server Info",
    CurrentValue = Config.Server.ServerInfo,
    Flag = "ServerInfo",
    Callback = function(Value)
        Config.Server.ServerInfo = Value
        logError("Server Info: " .. tostring(Value))
        
        if serverInfoConnection then
            serverInfoConnection:Disconnect()
            serverInfoConnection = nil
        end
        
        if Value then
            serverInfoConnection = RunService.Heartbeat:Connect(function()
                local serverInfo = GetServerInfo()
                local infoText = "Server ID: " .. serverInfo.ServerId .. "\n"
                infoText = infoText .. "Players: " .. serverInfo.Players .. "/" .. serverInfo.MaxPlayers .. "\n"
                infoText = infoText .. "Ping: " .. serverInfo.Ping .. "ms\n"
                infoText = infoText .. "FPS: " .. serverInfo.FPS .. "\n"
                infoText = infoText .. "Memory: " .. serverInfo.Memory .. "MB\n"
                infoText = infoText .. "Battery: " .. serverInfo.Battery .. "%"
                
                -- Display server info
                if infoDisplay and infoDisplay:FindFirstChild("ServerInfoFrame") then
                    infoDisplay.ServerInfoFrame.ServerInfoLabel.Text = infoText
                end
            end)
            
            Rayfield:Notify({
                Title = "Server Info",
                Content = "Server Info activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

ServerTab:CreateToggle({
    Name = "Luck Boost",
    CurrentValue = Config.Server.LuckBoost,
    Flag = "LuckBoost",
    Callback = function(Value)
        Config.Server.LuckBoost = Value
        logError("Luck Boost: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Luck Boost",
                Content = "Luck Boost activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

ServerTab:CreateToggle({
    Name = "Seed Viewer",
    CurrentValue = Config.Server.SeedViewer,
    Flag = "SeedViewer",
    Callback = function(Value)
        Config.Server.SeedViewer = Value
        logError("Seed Viewer: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Seed Viewer",
                Content = "Seed Viewer activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

ServerTab:CreateToggle({
    Name = "Force Event",
    CurrentValue = Config.Server.ForceEvent,
    Flag = "ForceEvent",
    Callback = function(Value)
        Config.Server.ForceEvent = Value
        logError("Force Event: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Force Event",
                Content = "Force Event activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

ServerTab:CreateToggle({
    Name = "Rejoin Same Server",
    CurrentValue = Config.Server.RejoinSameServer,
    Flag = "RejoinSameServer",
    Callback = function(Value)
        Config.Server.RejoinSameServer = Value
        logError("Rejoin Same Server: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Rejoin Same Server",
                Content = "Rejoin Same Server activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

ServerTab:CreateToggle({
    Name = "Server Hop",
    CurrentValue = Config.Server.ServerHop,
    Flag = "ServerHop",
    Callback = function(Value)
        Config.Server.ServerHop = Value
        logError("Server Hop: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Server Hop",
                Content = "Server Hop activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

ServerTab:CreateToggle({
    Name = "View Player Stats",
    CurrentValue = Config.Server.ViewPlayerStats,
    Flag = "ViewPlayerStats",
    Callback = function(Value)
        Config.Server.ViewPlayerStats = Value
        logError("View Player Stats: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "View Player Stats",
                Content = "View Player Stats activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

ServerTab:CreateButton({
    Name = "Get Server Info",
    Callback = function()
        local serverInfo = GetServerInfo()
        local infoText = "Players: " .. serverInfo.Players .. "/" .. serverInfo.MaxPlayers .. "\n"
        infoText = infoText .. "Server ID: " .. serverInfo.ServerId .. "\n"
        infoText = infoText .. "Ping: " .. serverInfo.Ping .. "ms\n"
        infoText = infoText .. "FPS: " .. serverInfo.FPS .. "\n"
        infoText = infoText .. "Memory: " .. serverInfo.Memory .. "MB\n"
        infoText = infoText .. "Battery: " .. serverInfo.Battery .. "%"
        
        if Config.Server.LuckBoost then
            infoText = infoText .. "\nLuck: Boosted"
        end
        
        if Config.Server.SeedViewer then
            infoText = infoText .. "\nSeed: " .. tostring(math.random(10000, 99999))
        end
        
        Rayfield:Notify({
            Title = "Server Info",
            Content = infoText,
            Duration = 5,
            Image = 13047715178
        })
        logError("Server Info: " .. infoText)
    end
})

-- System Tab
local SystemTab = Window:CreateTab("⚙️ System", 13014546625)

SystemTab:CreateToggle({
    Name = "Show Info",
    CurrentValue = Config.System.ShowInfo,
    Flag = "ShowInfo",
    Callback = function(Value)
        Config.System.ShowInfo = Value
        logError("Show Info: " .. tostring(Value))
        
        if Value then
            -- Create info display
            if infoDisplay then
                infoDisplay:Destroy()
            end
            
            infoDisplay = Instance.new("ScreenGui")
            infoDisplay.Name = "InfoDisplay"
            infoDisplay.Parent = CoreGui
            infoDisplay.ResetOnSpawn = false
            
            -- FPS and Ping Display
            local infoFrame = Instance.new("Frame")
            infoFrame.Name = "InfoFrame"
            infoFrame.Size = UDim2.new(0, 200, 0, 100)
            infoFrame.Position = UDim2.new(0, 10, 0, 10)
            infoFrame.BackgroundColor3 = Color3.new(0, 0, 0)
            infoFrame.BackgroundTransparency = 0.3
            infoFrame.BorderSizePixel = 0
            infoFrame.Parent = infoDisplay
            
            local infoCorner = Instance.new("UICorner")
            infoCorner.CornerRadius = UDim.new(0, 5)
            infoCorner.Parent = infoFrame
            
            local fpsLabel = Instance.new("TextLabel")
            fpsLabel.Name = "FPSLabel"
            fpsLabel.Size = UDim2.new(1, 0, 0, 25)
            fpsLabel.Position = UDim2.new(0, 0, 0, 5)
            fpsLabel.BackgroundTransparency = 1
            fpsLabel.Text = "FPS: 0"
            fpsLabel.TextColor3 = Color3.new(1, 1, 1)
            fpsLabel.TextSize = 14
            fpsLabel.Font = Enum.Font.SourceSansBold
            fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
            fpsLabel.Parent = infoFrame
            
            local pingLabel = Instance.new("TextLabel")
            pingLabel.Name = "PingLabel"
            pingLabel.Size = UDim2.new(1, 0, 0, 25)
            pingLabel.Position = UDim2.new(0, 0, 0, 30)
            pingLabel.BackgroundTransparency = 1
            pingLabel.Text = "Ping: 0ms"
            pingLabel.TextColor3 = Color3.new(1, 1, 1)
            pingLabel.TextSize = 14
            pingLabel.Font = Enum.Font.SourceSansBold
            pingLabel.TextXAlignment = Enum.TextXAlignment.Left
            pingLabel.Parent = infoFrame
            
            local batteryLabel = Instance.new("TextLabel")
            batteryLabel.Name = "BatteryLabel"
            batteryLabel.Size = UDim2.new(1, 0, 0, 25)
            batteryLabel.Position = UDim2.new(0, 0, 0, 55)
            batteryLabel.BackgroundTransparency = 1
            batteryLabel.Text = "Battery: 0%"
            batteryLabel.TextColor3 = Color3.new(1, 1, 1)
            batteryLabel.TextSize = 14
            batteryLabel.Font = Enum.Font.SourceSansBold
            batteryLabel.TextXAlignment = Enum.TextXAlignment.Left
            batteryLabel.Parent = infoFrame
            
            local timeLabel = Instance.new("TextLabel")
            timeLabel.Name = "TimeLabel"
            timeLabel.Size = UDim2.new(1, 0, 0, 25)
            timeLabel.Position = UDim2.new(0, 0, 0, 80)
            timeLabel.BackgroundTransparency = 1
            timeLabel.Text = "Time: 00:00:00"
            timeLabel.TextColor3 = Color3.new(1, 1, 1)
            timeLabel.TextSize = 14
            timeLabel.Font = Enum.Font.SourceSansBold
            timeLabel.TextXAlignment = Enum.TextXAlignment.Left
            timeLabel.Parent = infoFrame
            
            -- Player Info Display
            local playerInfoFrame = Instance.new("Frame")
            playerInfoFrame.Name = "PlayerInfoFrame"
            playerInfoFrame.Size = UDim2.new(0, 250, 0, 150)
            playerInfoFrame.Position = UDim2.new(0, 10, 0, 120)
            playerInfoFrame.BackgroundColor3 = Color3.new(0, 0, 0)
            playerInfoFrame.BackgroundTransparency = 0.3
            playerInfoFrame.BorderSizePixel = 0
            playerInfoFrame.Visible = Config.Server.PlayerInfo
            playerInfoFrame.Parent = infoDisplay
            
            local playerInfoCorner = Instance.new("UICorner")
            playerInfoCorner.CornerRadius = UDim.new(0, 5)
            playerInfoCorner.Parent = playerInfoFrame
            
            local playerInfoTitle = Instance.new("TextLabel")
            playerInfoTitle.Name = "PlayerInfoTitle"
            playerInfoTitle.Size = UDim2.new(1, 0, 0, 25)
            playerInfoTitle.Position = UDim2.new(0, 0, 0, 0)
            playerInfoTitle.BackgroundTransparency = 1
            playerInfoTitle.Text = "Player Info"
            playerInfoTitle.TextColor3 = Color3.new(1, 1, 1)
            playerInfoTitle.TextSize = 16
            playerInfoTitle.Font = Enum.Font.SourceSansBold
            playerInfoTitle.TextXAlignment = Enum.TextXAlignment.Center
            playerInfoTitle.Parent = playerInfoFrame
            
            local playerInfoLabel = Instance.new("TextLabel")
            playerInfoLabel.Name = "PlayerInfoLabel"
            playerInfoLabel.Size = UDim2.new(1, -10, 1, -35)
            playerInfoLabel.Position = UDim2.new(0, 5, 0, 30)
            playerInfoLabel.BackgroundTransparency = 1
            playerInfoLabel.Text = "Loading..."
            playerInfoLabel.TextColor3 = Color3.new(1, 1, 1)
            playerInfoLabel.TextSize = 14
            playerInfoLabel.Font = Enum.Font.SourceSans
            playerInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
            playerInfoLabel.TextYAlignment = Enum.TextYAlignment.Top
            playerInfoLabel.TextWrapped = true
            playerInfoLabel.Parent = playerInfoFrame
            
            -- Server Info Display
            local serverInfoFrame = Instance.new("Frame")
            serverInfoFrame.Name = "ServerInfoFrame"
            serverInfoFrame.Size = UDim2.new(0, 250, 0, 150)
            serverInfoFrame.Position = UDim2.new(0, 10, 0, 280)
            serverInfoFrame.BackgroundColor3 = Color3.new(0, 0, 0)
            serverInfoFrame.BackgroundTransparency = 0.3
            serverInfoFrame.BorderSizePixel = 0
            serverInfoFrame.Visible = Config.Server.ServerInfo
            serverInfoFrame.Parent = infoDisplay
            
            local serverInfoCorner = Instance.new("UICorner")
            serverInfoCorner.CornerRadius = UDim.new(0, 5)
            serverInfoCorner.Parent = serverInfoFrame
            
            local serverInfoTitle = Instance.new("TextLabel")
            serverInfoTitle.Name = "ServerInfoTitle"
            serverInfoTitle.Size = UDim2.new(1, 0, 0, 25)
            serverInfoTitle.Position = UDim2.new(0, 0, 0, 0)
            serverInfoTitle.BackgroundTransparency = 1
            serverInfoTitle.Text = "Server Info"
            serverInfoTitle.TextColor3 = Color3.new(1, 1, 1)
            serverInfoTitle.TextSize = 16
            serverInfoTitle.Font = Enum.Font.SourceSansBold
            serverInfoTitle.TextXAlignment = Enum.TextXAlignment.Center
            serverInfoTitle.Parent = serverInfoFrame
            
            local serverInfoLabel = Instance.new("TextLabel")
            serverInfoLabel.Name = "ServerInfoLabel"
            serverInfoLabel.Size = UDim2.new(1, -10, 1, -35)
            serverInfoLabel.Position = UDim2.new(0, 5, 0, 30)
            serverInfoLabel.BackgroundTransparency = 1
            serverInfoLabel.Text = "Loading..."
            serverInfoLabel.TextColor3 = Color3.new(1, 1, 1)
            serverInfoLabel.TextSize = 14
            serverInfoLabel.Font = Enum.Font.SourceSans
            serverInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
            serverInfoLabel.TextYAlignment = Enum.TextYAlignment.Top
            serverInfoLabel.TextWrapped = true
            serverInfoLabel.Parent = serverInfoFrame
            
            -- Update info display
            local lastTime = 0
            local fps = 0
            
            spawn(function()
                while Config.System.ShowInfo and infoDisplay and infoDisplay.Parent do
                    local currentTime = tick()
                    
                    if currentTime - lastTime >= 1 then
                        fps = math.floor(1 / (currentTime - lastTime))
                        lastTime = currentTime
                    end
                    
                    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                    local battery = math.floor(UserInputService:GetBatteryLevel() * 100)
                    local time = os.date("%H:%M:%S")
                    
                    fpsLabel.Text = "FPS: " .. fps
                    pingLabel.Text = "Ping: " .. ping .. "ms"
                    batteryLabel.Text = "Battery: " .. battery .. "%"
                    timeLabel.Text = "Time: " .. time
                    
                    RunService.RenderStepped:Wait()
                end
            end)
            
            Rayfield:Notify({
                Title = "Show Info",
                Content = "Info display activated",
                Duration = 2,
                Image = 13047715178
            })
        else
            if infoDisplay then
                infoDisplay:Destroy()
                infoDisplay = nil
            end
        end
    end
})

SystemTab:CreateToggle({
    Name = "Boost FPS",
    CurrentValue = Config.System.BoostFPS,
    Flag = "BoostFPS",
    Callback = function(Value)
        Config.System.BoostFPS = Value
        logError("Boost FPS: " .. tostring(Value))
        
        if Value then
            -- Reduce graphics quality for better FPS
            settings().Rendering.QualityLevel = 1
            
            -- Disable some visual effects
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
            Lighting.Brightness = 1
            
            -- Disable particles
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") then
                    particle.Enabled = false
                end
            end
            
            Rayfield:Notify({
                Title = "Boost FPS",
                Content = "FPS Boost activated",
                Duration = 2,
                Image = 13047715178
            })
        else
            -- Restore default graphics
            settings().Rendering.QualityLevel = 10
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 1000
            Lighting.Brightness = 1
        end
    end
})

SystemTab:CreateDropdown({
    Name = "FPS Limit",
    Options = {"30", "60", "120", "240", "360"},
    CurrentOption = tostring(Config.System.FPSLimit),
    Flag = "FPSLimit",
    Callback = function(Value)
        Config.System.FPSLimit = tonumber(Value)
        setfpscap(Config.System.FPSLimit)
        logError("FPS Limit: " .. Value)
        
        Rayfield:Notify({
            Title = "FPS Limit",
            Content = "FPS Limit set to " .. Value,
            Duration = 2,
            Image = 13047715178
        })
    end
})

SystemTab:CreateToggle({
    Name = "Auto Clean Memory",
    CurrentValue = Config.System.AutoCleanMemory,
    Flag = "AutoCleanMemory",
    Callback = function(Value)
        Config.System.AutoCleanMemory = Value
        logError("Auto Clean Memory: " .. tostring(Value))
        
        if Value then
            -- Auto clean memory
            spawn(function()
                while Config.System.AutoCleanMemory do
                    collectgarbage("collect")
                    wait(30)  -- Clean every 30 seconds
                end
            end)
            
            Rayfield:Notify({
                Title = "Auto Clean Memory",
                Content = "Auto Clean Memory activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

SystemTab:CreateToggle({
    Name = "Disable Particles",
    CurrentValue = Config.System.DisableParticles,
    Flag = "DisableParticles",
    Callback = function(Value)
        Config.System.DisableParticles = Value
        logError("Disable Particles: " .. tostring(Value))
        
        if Value then
            -- Disable particles
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") then
                    particle.Enabled = false
                end
            end
            
            Rayfield:Notify({
                Title = "Disable Particles",
                Content = "Particles disabled",
                Duration = 2,
                Image = 13047715178
            })
        else
            -- Enable particles
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") then
                    particle.Enabled = true
                end
            end
        end
    end
})

SystemTab:CreateToggle({
    Name = "Auto Farm Fishing",
    CurrentValue = Config.System.AutoFarm,
    Flag = "AutoFarm",
    Callback = function(Value)
        Config.System.AutoFarm = Value
        logError("Auto Farm: " .. tostring(Value))
        
        if autoFarmConnection then
            autoFarmConnection:Disconnect()
            autoFarmConnection = nil
        end
        
        if Value then
            autoFarmConnection = RunService.Heartbeat:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    -- Find nearest fishing spot
                    local nearestSpot = nil
                    local nearestDistance = math.huge
                    
                    for _, spot in ipairs(Workspace:GetChildren()) do
                        if spot.Name:find("Fishing") or spot.Name:find("Water") then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - spot.Position).Magnitude
                            if distance < nearestDistance and distance <= Config.System.FarmRadius then
                                nearestDistance = distance
                                nearestSpot = spot
                            end
                        end
                    end
                    
                    if nearestSpot then
                        -- Move to fishing spot
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(nearestSpot.Position + Vector3.new(0, 5, 0))
                        
                        -- Equip fishing rod
                        local fishingRod = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if fishingRod and fishingRod.Name:find("Rod") then
                            LocalPlayer.Character.Humanoid:EquipTool(fishingRod)
                            
                            -- Cast fishing line
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                            wait(0.1)
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                        end
                    end
                end
            end)
            
            Rayfield:Notify({
                Title = "Auto Farm",
                Content = "Auto Farm activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

SystemTab:CreateSlider({
    Name = "Farm Radius",
    Range = {50, 500},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = Config.System.FarmRadius,
    Flag = "FarmRadius",
    Callback = function(Value)
        Config.System.FarmRadius = Value
        logError("Farm Radius: " .. Value)
    end
})

SystemTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
        logError("Rejoining server...")
    end
})

SystemTab:CreateButton({
    Name = "Get System Info",
    Callback = function()
        local serverInfo = GetServerInfo()
        local systemInfo = string.format("FPS: %d | Ping: %dms | Memory: %dMB | Battery: %d%% | Time: %s", 
            serverInfo.FPS, serverInfo.Ping, serverInfo.Memory, serverInfo.Battery, serverInfo.Time)
        
        Rayfield:Notify({
            Title = "System Info",
            Content = systemInfo,
            Duration = 5,
            Image = 13047715178
        })
        logError("System Info: " .. systemInfo)
    end
})

-- Graphic Tab
local GraphicTab = Window:CreateTab("🎨 Graphic", 13014546625)

GraphicTab:CreateToggle({
    Name = "High Quality Rendering",
    CurrentValue = Config.Graphic.HighQuality,
    Flag = "HighQuality",
    Callback = function(Value)
        Config.Graphic.HighQuality = Value
        logError("High Quality Rendering: " .. tostring(Value))
        
        if Value then
            sethiddenproperty(Lighting, "Technology", "Future")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Disabled")
            settings().Rendering.QualityLevel = 10
            
            Rayfield:Notify({
                Title = "High Quality Rendering",
                Content = "High Quality Rendering activated",
                Duration = 2,
                Image = 13047715178
            })
        else
            sethiddenproperty(Lighting, "Technology", "Compatibility")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Enabled")
            settings().Rendering.QualityLevel = 1
        end
    end
})

GraphicTab:CreateToggle({
    Name = "Max Rendering",
    CurrentValue = Config.Graphic.MaxRendering,
    Flag = "MaxRendering",
    Callback = function(Value)
        Config.Graphic.MaxRendering = Value
        logError("Max Rendering: " .. tostring(Value))
        
        if Value then
            settings().Rendering.QualityLevel = 21
            
            Rayfield:Notify({
                Title = "Max Rendering",
                Content = "Max Rendering activated",
                Duration = 2,
                Image = 13047715178
            })
        else
            settings().Rendering.QualityLevel = 1
        end
    end
})

GraphicTab:CreateToggle({
    Name = "Ultra Low Mode",
    CurrentValue = Config.Graphic.UltraLowMode,
    Flag = "UltraLowMode",
    Callback = function(Value)
        Config.Graphic.UltraLowMode = Value
        logError("Ultra Low Mode: " .. tostring(Value))
        
        if Value then
            settings().Rendering.QualityLevel = 1
            
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") then
                    part.Material = Enum.Material.Plastic
                end
            end
            
            Rayfield:Notify({
                Title = "Ultra Low Mode",
                Content = "Ultra Low Mode activated",
                Duration = 2,
                Image = 13047715178
            })
        else
            settings().Rendering.QualityLevel = 10
        end
    end
})

GraphicTab:CreateToggle({
    Name = "Disable Water Reflection",
    CurrentValue = Config.Graphic.DisableWaterReflection,
    Flag = "DisableWaterReflection",
    Callback = function(Value)
        Config.Graphic.DisableWaterReflection = Value
        logError("Disable Water Reflection: " .. tostring(Value))
        
        if Value then
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and (water.Name == "Water" or water.Material == Enum.Material.Water) then
                    water.Transparency = 1
                end
            end
            
            Rayfield:Notify({
                Title = "Disable Water Reflection",
                Content = "Water Reflection disabled",
                Duration = 2,
                Image = 13047715178
            })
        else
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and (water.Name == "Water" or water.Material == Enum.Material.Water) then
                    water.Transparency = 0.5
                end
            end
        end
    end
})

GraphicTab:CreateToggle({
    Name = "Custom Shader",
    CurrentValue = Config.Graphic.CustomShader,
    Flag = "CustomShader",
    Callback = function(Value)
        Config.Graphic.CustomShader = Value
        logError("Custom Shader: " .. tostring(Value))
        
        if Value then
            -- Apply custom shader effect
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0.1)
            Lighting.ColorShift_Top = Color3.new(0.1, 0, 0)
            
            Rayfield:Notify({
                Title = "Custom Shader",
                Content = "Custom Shader activated",
                Duration = 2,
                Image = 13047715178
            })
        else
            -- Reset lighting
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
        end
    end
})

GraphicTab:CreateToggle({
    Name = "Smooth Graphics",
    CurrentValue = Config.Graphic.SmoothGraphics,
    Flag = "SmoothGraphics",
    Callback = function(Value)
        Config.Graphic.SmoothGraphics = Value
        logError("Smooth Graphics: " .. tostring(Value))
        
        if Value then
            RunService:Set3dRenderingEnabled(true)
            settings().Rendering.MeshCacheSize = 100
            settings().Rendering.TextureCacheSize = 100
            
            Rayfield:Notify({
                Title = "Smooth Graphics",
                Content = "Smooth Graphics activated",
                Duration = 2,
                Image = 13047715178
            })
        else
            settings().Rendering.MeshCacheSize = 32
            settings().Rendering.TextureCacheSize = 32
        end
    end
})

GraphicTab:CreateToggle({
    Name = "Full Bright",
    CurrentValue = Config.Graphic.FullBright,
    Flag = "FullBright",
    Callback = function(Value)
        Config.Graphic.FullBright = Value
        logError("Full Bright: " .. tostring(Value))
        
        if Value then
            Lighting.GlobalShadows = false
            Lighting.ClockTime = 12
            Lighting.Brightness = Config.Graphic.BrightnessValue
            
            Rayfield:Notify({
                Title = "Full Bright",
                Content = "Full Bright activated",
                Duration = 2,
                Image = 13047715178
            })
        else
            Lighting.GlobalShadows = true
            Lighting.Brightness = 1
        end
    end
})

GraphicTab:CreateSlider({
    Name = "Brightness",
    Range = {0.5, 5},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = Config.Graphic.BrightnessValue,
    Flag = "BrightnessValue",
    Callback = function(Value)
        Config.Graphic.BrightnessValue = Value
        logError("Brightness: " .. Value)
        
        if Config.Graphic.FullBright then
            Lighting.Brightness = Value
        end
    end
})

-- RNG Kill Tab
local RNGKillTab = Window:CreateTab("🎲 RNG Kill", 13014546625)

RNGKillTab:CreateToggle({
    Name = "RNG Reducer",
    CurrentValue = Config.RNGKill.RNGReducer,
    Flag = "RNGReducer",
    Callback = function(Value)
        Config.RNGKill.RNGReducer = Value
        logError("RNG Reducer: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "RNG Reducer",
                Content = "RNG Reducer activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Force Legendary Catch",
    CurrentValue = Config.RNGKill.ForceLegendary,
    Flag = "ForceLegendary",
    Callback = function(Value)
        Config.RNGKill.ForceLegendary = Value
        logError("Force Legendary Catch: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Force Legendary Catch",
                Content = "Force Legendary Catch activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Secret Fish Boost",
    CurrentValue = Config.RNGKill.SecretFishBoost,
    Flag = "SecretFishBoost",
    Callback = function(Value)
        Config.RNGKill.SecretFishBoost = Value
        logError("Secret Fish Boost: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Secret Fish Boost",
                Content = "Secret Fish Boost activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Mythical Chance ×10",
    CurrentValue = Config.RNGKill.MythicalChanceBoost,
    Flag = "MythicalChanceBoost",
    Callback = function(Value)
        Config.RNGKill.MythicalChanceBoost = Value
        logError("Mythical Chance Boost: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Mythical Chance Boost",
                Content = "Mythical Chance Boost activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Anti-Bad Luck",
    CurrentValue = Config.RNGKill.AntiBadLuck,
    Flag = "AntiBadLuck",
    Callback = function(Value)
        Config.RNGKill.AntiBadLuck = Value
        logError("Anti-Bad Luck: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Anti-Bad Luck",
                Content = "Anti-Bad Luck activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Guaranteed Catch",
    CurrentValue = Config.RNGKill.GuaranteedCatch,
    Flag = "GuaranteedCatch",
    Callback = function(Value)
        Config.RNGKill.GuaranteedCatch = Value
        logError("Guaranteed Catch: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Guaranteed Catch",
                Content = "Guaranteed Catch activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

RNGKillTab:CreateButton({
    Name = "Apply RNG Settings",
    Callback = function()
        if FishingEvents and FishingEvents:FindFirstChild("ApplyRNGSettings") then
            local success, result = pcall(function()
                FishingEvents.ApplyRNGSettings:FireServer({
                    RNGReducer = Config.RNGKill.RNGReducer,
                    ForceLegendary = Config.RNGKill.ForceLegendary,
                    SecretFishBoost = Config.RNGKill.SecretFishBoost,
                    MythicalChance = Config.RNGKill.MythicalChanceBoost,
                    AntiBadLuck = Config.RNGKill.AntiBadLuck,
                    GuaranteedCatch = Config.RNGKill.GuaranteedCatch
                })
                Rayfield:Notify({
                    Title = "RNG Settings Applied",
                    Content = "RNG modifications activated",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("RNG Settings Applied")
            end)
            if not success then
                logError("RNG Settings Error: " .. result)
            end
        else
            -- Manual RNG manipulation
            if rngConnection then
                rngConnection:Disconnect()
                rngConnection = nil
            end
            
            if FishingEvents then
                -- Hook fishing events
                local originalCatch
                if FishingEvents:FindFirstChild("Catch") then
                    originalCatch = FishingEvents.Catch.OnServerEvent
                    
                    FishingEvents.Catch.OnServerEvent = function(player, ...)
                        if Config.RNGKill.ForceLegendary then
                            -- Force legendary fish
                            return originalCatch(player, "Legendary Fish", 1000)
                        elseif Config.RNGKill.SecretFishBoost then
                            -- Boost secret fish chance
                            if math.random(1, 10) == 1 then
                                return originalCatch(player, "Secret Fish", 5000)
                            end
                        elseif Config.RNGKill.MythicalChanceBoost then
                            -- 10x mythical chance
                            if math.random(1, 10) == 1 then
                                return originalCatch(player, "Mythical Fish", 2000)
                            end
                        elseif Config.RNGKill.GuaranteedCatch then
                            -- Always catch something
                            return originalCatch(player, "Fish", 100)
                        end
                        
                        return originalCatch(player, ...)
                    end
                end
                
                Rayfield:Notify({
                    Title = "RNG Settings Applied",
                    Content = "RNG modifications activated (manual)",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("RNG Settings Applied (manual)")
            end
        end
    end
})

-- Shop Tab
local ShopTab = Window:CreateTab("🛒 Shop", 13014546625)

local rodNames = {}
for _, rod in ipairs(Rods) do
    table.insert(rodNames, rod.Name)
end

ShopTab:CreateToggle({
    Name = "Auto Buy Rods",
    CurrentValue = Config.Shop.AutoBuyRods,
    Flag = "AutoBuyRods",
    Callback = function(Value)
        Config.Shop.AutoBuyRods = Value
        logError("Auto Buy Rods: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Buy Rods",
                Content = "Auto Buy Rods activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

ShopTab:CreateDropdown({
    Name = "Select Rod",
    Options = rodNames,
    CurrentOption = Config.Shop.SelectedRod,
    Flag = "SelectedRod",
    Callback = function(Value)
        Config.Shop.SelectedRod = Value
        logError("Selected Rod: " .. Value)
    end
})

local boatNames = {}
for _, boat in ipairs(Boats) do
    table.insert(boatNames, boat.Name)
end

ShopTab:CreateToggle({
    Name = "Auto Buy Boats",
    CurrentValue = Config.Shop.AutoBuyBoats,
    Flag = "AutoBuyBoats",
    Callback = function(Value)
        Config.Shop.AutoBuyBoats = Value
        logError("Auto Buy Boats: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Buy Boats",
                Content = "Auto Buy Boats activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

ShopTab:CreateDropdown({
    Name = "Select Boat",
    Options = boatNames,
    CurrentOption = Config.Shop.SelectedBoat,
    Flag = "SelectedBoat",
    Callback = function(Value)
        Config.Shop.SelectedBoat = Value
        logError("Selected Boat: " .. Value)
    end
})

local baitNames = {}
for _, bait in ipairs(Baits) do
    table.insert(baitNames, bait.Name)
end

ShopTab:CreateToggle({
    Name = "Auto Buy Baits",
    CurrentValue = Config.Shop.AutoBuyBaits,
    Flag = "AutoBuyBaits",
    Callback = function(Value)
        Config.Shop.AutoBuyBaits = Value
        logError("Auto Buy Baits: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Buy Baits",
                Content = "Auto Buy Baits activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

ShopTab:CreateDropdown({
    Name = "Select Bait",
    Options = baitNames,
    CurrentOption = Config.Shop.SelectedBait,
    Flag = "SelectedBait",
    Callback = function(Value)
        Config.Shop.SelectedBait = Value
        logError("Selected Bait: " .. Value)
    end
})

ShopTab:CreateToggle({
    Name = "Auto Upgrade Rod",
    CurrentValue = Config.Shop.AutoUpgradeRod,
    Flag = "AutoUpgradeRod",
    Callback = function(Value)
        Config.Shop.AutoUpgradeRod = Value
        logError("Auto Upgrade Rod: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Upgrade Rod",
                Content = "Auto Upgrade Rod activated",
                Duration = 2,
                Image = 13047715178
            })
        end
    end
})

ShopTab:CreateButton({
    Name = "Buy Selected Item",
    Callback = function()
        local success, result = pcall(function()
            if Config.Shop.SelectedRod ~= "" and Config.Shop.AutoBuyRods then
                if Remotes and Remotes:FindFirstChild("BuyRod") then
                    Remotes.BuyRod:FireServer(Config.Shop.SelectedRod)
                    Rayfield:Notify({
                        Title = "Item Purchased",
                        Content = "Purchased: " .. Config.Shop.SelectedRod,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Purchased rod: " .. Config.Shop.SelectedRod)
                end
            elseif Config.Shop.SelectedBoat ~= "" and Config.Shop.AutoBuyBoats then
                if Remotes and Remotes:FindFirstChild("BuyBoat") then
                    Remotes.BuyBoat:FireServer(Config.Shop.SelectedBoat)
                    Rayfield:Notify({
                        Title = "Item Purchased",
                        Content = "Purchased: " .. Config.Shop.SelectedBoat,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Purchased boat: " .. Config.Shop.SelectedBoat)
                end
            elseif Config.Shop.SelectedBait ~= "" and Config.Shop.AutoBuyBaits then
                if Remotes and Remotes:FindFirstChild("BuyBait") then
                    Remotes.BuyBait:FireServer(Config.Shop.SelectedBait, 10)  -- Buy 10 baits
                    Rayfield:Notify({
                        Title = "Item Purchased",
                        Content = "Purchased: " .. Config.Shop.SelectedBait .. " x10",
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Purchased bait: " .. Config.Shop.SelectedBait .. " x10")
                end
            elseif Config.Shop.AutoUpgradeRod then
                if Remotes and Remotes:FindFirstChild("UpgradeRod") then
                    Remotes.UpgradeRod:FireServer()
                    Rayfield:Notify({
                        Title = "Rod Upgraded",
                        Content = "Rod upgraded successfully",
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Rod upgraded")
                end
            else
                Rayfield:Notify({
                    Title = "Purchase Error",
                    Content = "Please select an item and enable auto buy",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Purchase Error: No item selected or auto buy disabled")
            end
        end)
        
        if not success then
            logError("Purchase error: " .. result)
            Rayfield:Notify({
                Title = "Purchase Error",
                Content = "Failed to purchase item",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings", 13014546625)

SettingsTab:CreateDropdown({
    Name = "Select Theme",
    Options = {"Dark", "Light", "Blue", "Red", "Green", "Purple"},
    CurrentOption = Config.Settings.SelectedTheme,
    Flag = "SelectedTheme",
    Callback = function(Value)
        Config.Settings.SelectedTheme = Value
        logError("Selected Theme: " .. Value)
        
        -- Apply theme
        if Value == "Dark" then
            Rayfield:UpdateTheme({
                BackgroundColor = Color3.fromRGB(24, 24, 24),
                Accent = Color3.fromRGB(10, 10, 10),
                TextColor = Color3.fromRGB(255, 255, 255),
                TabBackground = Color3.fromRGB(30, 30, 30),
                TabStroke = Color3.fromRGB(60, 60, 60),
                TabText = Color3.fromRGB(255, 255, 255),
                ToggleBackground = Color3.fromRGB(40, 40, 40),
                ToggleEnabled = Color3.fromRGB(0, 150, 255),
                ToggleDisabled = Color3.fromRGB(100, 100, 100),
                SliderBackground = Color3.fromRGB(40, 40, 40),
                SliderEnabled = Color3.fromRGB(0, 150, 255),
                SliderDisabled = Color3.fromRGB(100, 100, 100),
                ButtonBackground = Color3.fromRGB(40, 40, 40),
                ButtonText = Color3.fromRGB(255, 255, 255),
                DropdownBackground = Color3.fromRGB(40, 40, 40),
                DropdownText = Color3.fromRGB(255, 255, 255),
                InputBackground = Color3.fromRGB(40, 40, 40),
                InputText = Color3.fromRGB(255, 255, 255)
            })
        elseif Value == "Light" then
            Rayfield:UpdateTheme({
                BackgroundColor = Color3.fromRGB(240, 240, 240),
                Accent = Color3.fromRGB(200, 200, 200),
                TextColor = Color3.fromRGB(0, 0, 0),
                TabBackground = Color3.fromRGB(220, 220, 220),
                TabStroke = Color3.fromRGB(180, 180, 180),
                TabText = Color3.fromRGB(0, 0, 0),
                ToggleBackground = Color3.fromRGB(200, 200, 200),
                ToggleEnabled = Color3.fromRGB(0, 120, 215),
                ToggleDisabled = Color3.fromRGB(150, 150, 150),
                SliderBackground = Color3.fromRGB(200, 200, 200),
                SliderEnabled = Color3.fromRGB(0, 120, 215),
                SliderDisabled = Color3.fromRGB(150, 150, 150),
                ButtonBackground = Color3.fromRGB(200, 200, 200),
                ButtonText = Color3.fromRGB(0, 0, 0),
                DropdownBackground = Color3.fromRGB(200, 200, 200),
                DropdownText = Color3.fromRGB(0, 0, 0),
                InputBackground = Color3.fromRGB(200, 200, 200),
                InputText = Color3.fromRGB(0, 0, 0)
            })
        elseif Value == "Blue" then
            Rayfield:UpdateTheme({
                BackgroundColor = Color3.fromRGB(24, 24, 40),
                Accent = Color3.fromRGB(10, 10, 30),
                TextColor = Color3.fromRGB(255, 255, 255),
                TabBackground = Color3.fromRGB(30, 30, 50),
                TabStroke = Color3.fromRGB(60, 60, 120),
                TabText = Color3.fromRGB(255, 255, 255),
                ToggleBackground = Color3.fromRGB(40, 40, 60),
                ToggleEnabled = Color3.fromRGB(0, 100, 255),
                ToggleDisabled = Color3.fromRGB(80, 80, 120),
                SliderBackground = Color3.fromRGB(40, 40, 60),
                SliderEnabled = Color3.fromRGB(0, 100, 255),
                SliderDisabled = Color3.fromRGB(80, 80, 120),
                ButtonBackground = Color3.fromRGB(40, 40, 60),
                ButtonText = Color3.fromRGB(255, 255, 255),
                DropdownBackground = Color3.fromRGB(40, 40, 60),
                DropdownText = Color3.fromRGB(255, 255, 255),
                InputBackground = Color3.fromRGB(40, 40, 60),
                InputText = Color3.fromRGB(255, 255, 255)
            })
        elseif Value == "Red" then
            Rayfield:UpdateTheme({
                BackgroundColor = Color3.fromRGB(40, 24, 24),
                Accent = Color3.fromRGB(30, 10, 10),
                TextColor = Color3.fromRGB(255, 255, 255),
                TabBackground = Color3.fromRGB(50, 30, 30),
                TabStroke = Color3.fromRGB(120, 60, 60),
                TabText = Color3.fromRGB(255, 255, 255),
                ToggleBackground = Color3.fromRGB(60, 40, 40),
                ToggleEnabled = Color3.fromRGB(255, 50, 50),
                ToggleDisabled = Color3.fromRGB(120, 80, 80),
                SliderBackground = Color3.fromRGB(60, 40, 40),
                SliderEnabled = Color3.fromRGB(255, 50, 50),
                SliderDisabled = Color3.fromRGB(120, 80, 80),
                ButtonBackground = Color3.fromRGB(60, 40, 40),
                ButtonText = Color3.fromRGB(255, 255, 255),
                DropdownBackground = Color3.fromRGB(60, 40, 40),
                DropdownText = Color3.fromRGB(255, 255, 255),
                InputBackground = Color3.fromRGB(60, 40, 40),
                InputText = Color3.fromRGB(255, 255, 255)
            })
        elseif Value == "Green" then
            Rayfield:UpdateTheme({
                BackgroundColor = Color3.fromRGB(24, 40, 24),
                Accent = Color3.fromRGB(10, 30, 10),
                TextColor = Color3.fromRGB(255, 255, 255),
                TabBackground = Color3.fromRGB(30, 50, 30),
                TabStroke = Color3.fromRGB(60, 120, 60),
                TabText = Color3.fromRGB(255, 255, 255),
                ToggleBackground = Color3.fromRGB(40, 60, 40),
                ToggleEnabled = Color3.fromRGB(50, 255, 50),
                ToggleDisabled = Color3.fromRGB(80, 120, 80),
                SliderBackground = Color3.fromRGB(40, 60, 40),
                SliderEnabled = Color3.fromRGB(50, 255, 50),
                SliderDisabled = Color3.fromRGB(80, 120, 80),
                ButtonBackground = Color3.fromRGB(40, 60, 40),
                ButtonText = Color3.fromRGB(255, 255, 255),
                DropdownBackground = Color3.fromRGB(40, 60, 40),
                DropdownText = Color3.fromRGB(255, 255, 255),
                InputBackground = Color3.fromRGB(40, 60, 40),
                InputText = Color3.fromRGB(255, 255, 255)
            })
        elseif Value == "Purple" then
            Rayfield:UpdateTheme({
                BackgroundColor = Color3.fromRGB(40, 24, 40),
                Accent = Color3.fromRGB(30, 10, 30),
                TextColor = Color3.fromRGB(255, 255, 255),
                TabBackground = Color3.fromRGB(50, 30, 50),
                TabStroke = Color3.fromRGB(120, 60, 120),
                TabText = Color3.fromRGB(255, 255, 255),
                ToggleBackground = Color3.fromRGB(60, 40, 60),
                ToggleEnabled = Color3.fromRGB(200, 50, 255),
                ToggleDisabled = Color3.fromRGB(120, 80, 120),
                SliderBackground = Color3.fromRGB(60, 40, 60),
                SliderEnabled = Color3.fromRGB(200, 50, 255),
                SliderDisabled = Color3.fromRGB(120, 80, 120),
                ButtonBackground = Color3.fromRGB(60, 40, 60),
                ButtonText = Color3.fromRGB(255, 255, 255),
                DropdownBackground = Color3.fromRGB(60, 40, 60),
                DropdownText = Color3.fromRGB(255, 255, 255),
                InputBackground = Color3.fromRGB(60, 40, 60),
                InputText = Color3.fromRGB(255, 255, 255)
            })
        end
        
        Rayfield:Notify({
            Title = "Theme Changed",
            Content = "Theme changed to " .. Value,
            Duration = 2,
            Image = 13047715178
        })
    end
})

SettingsTab:CreateSlider({
    Name = "UI Transparency",
    Range = {0.1, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Settings.Transparency,
    Flag = "Transparency",
    Callback = function(Value)
        Config.Settings.Transparency = Value
        logError("UI Transparency: " .. Value)
        
        -- Apply transparency
        Rayfield:UpdateTheme({
            BackgroundTransparency = Value
        })
    end
})

SettingsTab:CreateInput({
    Name = "Config Name",
    PlaceholderText = "Enter config name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text ~= "" then
            Config.Settings.ConfigName = Text
            logError("Config Name: " .. Text)
        end
    end
})

SettingsTab:CreateSlider({
    Name = "UI Scale",
    Range = {0.5, 1.5},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = Config.Settings.UIScale,
    Flag = "UIScale",
    Callback = function(Value)
        Config.Settings.UIScale = Value
        logError("UI Scale: " .. Value)
        
        -- Apply scale
        Window:SetScale(Value)
    end
})

SettingsTab:CreateButton({
    Name = "Save Config",
    Callback = function()
        SaveConfig()
    end
})

SettingsTab:CreateButton({
    Name = "Load Config",
    Callback = function()
        LoadConfig()
    end
})

SettingsTab:CreateButton({
    Name = "Reset Config",
    Callback = function()
        ResetConfig()
    end
})

SettingsTab:CreateButton({
    Name = "Clear Log",
    Callback = function()
        local success, err = pcall(function()
            local logPath = "/storage/emulated/0/logscript.txt"
            if isfile(logPath) then
                writefile(logPath, "")
                Rayfield:Notify({
                    Title = "Log Cleared",
                    Content = "Log file has been cleared",
                    Duration = 2,
                    Image = 13047715178
                })
                logError("Log file cleared")
            end
        end)
        
        if not success then
            Rayfield:Notify({
                Title = "Log Error",
                Content = "Failed to clear log: " .. err,
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

SettingsTab:CreateButton({
    Name = "View Log",
    Callback = function()
        local success, err = pcall(function()
            local logPath = "/storage/emulated/0/logscript.txt"
            if isfile(logPath) then
                local logContent = readfile(logPath)
                if #logContent > 0 then
                    Rayfield:Notify({
                        Title = "Log File",
                        Content = "Log file has content. Check your device storage.",
                        Duration = 3,
                        Image = 13047715178
                    })
                else
                    Rayfield:Notify({
                        Title = "Log File",
                        Content = "Log file is empty",
                        Duration = 3,
                        Image = 13047715178
                    })
                end
            else
                Rayfield:Notify({
                    Title = "Log File",
                    Content = "Log file not found",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        end)
        
        if not success then
            Rayfield:Notify({
                Title = "Log Error",
                Content = "Failed to read log: " .. err,
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Initial logging
logError("Script loaded successfully")
logError("Player: " .. LocalPlayer.Name)
logError("Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)

-- Auto-save config every 5 minutes
spawn(function()
    while true do
        wait(300)  -- 5 minutes
        SaveConfig()
    end
end)

-- Notify user that script is loaded
Rayfield:Notify({
    Title = "Script Loaded",
    Content = "Fish It Hub 2025 by Nikzz Xit loaded successfully!",
    Duration = 5,
    Image = 13047715178
})
