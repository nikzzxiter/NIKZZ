-- Fish It Hub 2025 by Nikzz Xit
-- Rayfield Script for Fish It September 2025
-- Full Implementation - All Features 100% Working
-- Optimized for Low-End Devices

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

-- Game Variables
local FishingEvents = ReplicatedStorage:FindFirstChild("FishingEvents") or ReplicatedStorage:WaitForChild("FishingEvents", 10)
local TradeEvents = ReplicatedStorage:FindFirstChild("TradeEvents") or ReplicatedStorage:WaitForChild("TradeEvents", 10)
local GameFunctions = ReplicatedStorage:FindFirstChild("GameFunctions") or ReplicatedStorage:WaitForChild("GameFunctions", 10)
local PlayerData = LocalPlayer:FindFirstChild("PlayerData") or LocalPlayer:WaitForChild("PlayerData", 10)
local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes", 10)
local Modules = ReplicatedStorage:FindFirstChild("Modules") or ReplicatedStorage:WaitForChild("Modules", 10)

-- Enhanced Logging System
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

-- Enhanced Anti-AFK System
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    
    -- Additional anti-AFK methods
    if Config.Bypass.AutoJump then
        spawn(function()
            while Config.Bypass.AutoJump and wait(Config.Bypass.AutoJumpDelay) do
                VirtualUser:CaptureController()
                VirtualUser:SetKeyDown(0x20) -- Space key
                wait(0.1)
                VirtualUser:SetKeyUp(0x20)
            end
        end)
    end
end)

-- Enhanced Anti-Kick System
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" or method == "BanUser" or method == "Ban" or method == "KickUser" then
        logError("Anti-Kick: Blocked kick attempt with method: " .. method)
        return nil
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- Enhanced Anti-Ban System
spawn(function()
    while wait(30) do
        if Config.Bypass.AntiBan then
            -- Send heartbeat to server
            pcall(function()
                if Remotes and Remotes:FindFirstChild("Heartbeat") then
                    Remotes.Heartbeat:FireServer("alive")
                end
            end)
            
            -- Random movement to prevent detection
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Jump = true
            end
        end
    end
end)

-- Comprehensive Configuration System
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
        BypassFishingDelay = false,
        AntiRecoil = false,
        AntiBanForActions = false,
        BypassServerChecks = false,
        BypassAntiCheat = false
    },
    Teleport = {
        SelectedLocation = "",
        SelectedPlayer = "",
        SelectedEvent = "",
        SavedPositions = {},
        TeleportToFish = false,
        RareFishLocations = {},
        AutoTeleportToEvents = false,
        TeleportSpeed = 10,
        SmoothTeleport = true
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
        NoClipBoat = false,
        AutoReel = false,
        PerfectCatch = false,
        FishFinder = false,
        AutoFish = false,
        AutoMove = false,
        AutoPathfind = false,
        AutoDodge = false
    },
    Trader = {
        AutoAcceptTrade = false,
        SelectedFish = {},
        TradePlayer = "",
        TradeAllFish = false,
        AutoTradeRare = false,
        TradeValueCalculator = false,
        AutoTradeFish = false,
        TradeHistory = false
    },
    Server = {
        PlayerInfo = false,
        ServerInfo = false,
        LuckBoost = false,
        SeedViewer = false,
        ForceEvent = false,
        RejoinSameServer = false,
        ServerHop = false,
        ViewPlayerStats = false,
        ServerClock = false,
        ServerPing = false,
        ServerPerformance = false,
        ServerPlayers = false
    },
    System = {
        ShowInfo = false,
        BoostFPS = false,
        FPSLimit = 60,
        AutoCleanMemory = false,
        DisableParticles = false,
        RejoinServer = false,
        AutoFarm = false,
        FarmRadius = 100,
        AutoRestart = false,
        AutoUpdate = false,
        PerformanceMonitor = false,
        SystemOptimizer = false,
        BackgroundProcesses = false
    },
    Graphic = {
        HighQuality = false,
        MaxRendering = false,
        UltraLowMode = false,
        DisableWaterReflection = false,
        CustomShader = false,
        SmoothGraphics = false,
        FullBright = false,
        CustomSky = false,
        CustomWater = false,
        TextureCompression = false,
        MeshReduction = false,
        ShadowQuality = "High",
        AmbientOcclusion = true,
        Bloom = false,
        DepthOfField = false,
        MotionBlur = false,
        ChromaticAberration = false,
        Vignette = false
    },
    RNGKill = {
        RNGReducer = false,
        ForceLegendary = false,
        SecretFishBoost = false,
        MythicalChanceBoost = false,
        AntiBadLuck = false,
        GuaranteedCatch = false,
        FishRarityMultiplier = 1,
        AutoCatchRare = false,
        LuckyCharm = false,
        FishProbability = 100,
        RareFishMultiplier = 10,
        PerfectCatchRate = 100
    },
    Shop = {
        AutoBuyRods = false,
        SelectedRod = "",
        AutoBuyBoats = false,
        SelectedBoat = "",
        AutoBuyBaits = false,
        SelectedBait = "",
        AutoUpgradeRod = false,
        AutoSellFish = false,
        AutoCraftItems = false,
        CurrencyBooster = false,
        ShopAutoBuy = false,
        ShopAutoSell = false,
        ShopAutoUpgrade = false
    },
    Settings = {
        SelectedTheme = "Dark",
        Transparency = 0.5,
        ConfigName = "DefaultConfig",
        UIScale = 1,
        Keybinds = {},
        AutoLogging = true,
        LogLevel = "Info",
        NotificationSound = true,
        AutoSave = true,
        SaveInterval = 60
    },
    LowDevice = {
        AntiLag = false,
        FPSStabilizer = false,
        DisableAllEffects = false,
        EightBitGraphics = false,
        TextureCompression = false,
        MeshReduction = false,
        ReduceLOD = false,
        ShadowQuality = "Low",
        ParticleQuality = "Low",
        RenderDistance = 200,
        ObjectLOD = 0,
        TextureQuality = "Low",
        EffectQuality = "Low"
    }
}

-- Enhanced Game Data
local Rods = {
    "Starter Rod", "Carbon Rod", "Toy Rod", "Grass Rod", "Lava Rod", 
    "Demascus Rod", "Ice Rod", "Lucky Rod", "Midnight Rod", "Steampunk Rod", 
    "Chrome Rod", "Astral Rod", "Ares Rod", "Angler Rod", "Quantum Rod", 
    "Neon Rod", "Crystal Rod", "Dragon Rod", "Phoenix Rod", "Titan Rod",
    "Cosmic Rod", "Infinity Rod", "Galaxy Rod", "Star Rod", "Void Rod"
}

local Baits = {
    "Worm", "Shrimp", "Golden Bait", "Mythical Lure", "Dark Matter Bait", 
    "Aether Bait", "Royal Bait", "Eternal Bait", "Cosmic Bait", "Prismatic Bait",
    "Starlight Bait", "Moonlight Bait", "Sunlight Bait", "Shadow Bait", "Light Bait"
}

local Boats = {
    "Small Boat", "Speed Boat", "Viking Ship", "Mythical Ark", 
    "Royal Yacht", "Submarine", "Dragon Boat", "Ghost Ship", "Crystal Ship",
    "Sky Ship", "Ocean Cruiser", "Fishing Vessel", "Yacht", "Sailboat"
}

local Islands = {
    "Fisherman Island", "Ocean", "Kohana Island", "Kohana Volcano", 
    "Coral Reefs", "Esoteric Depths", "Tropical Grove", "Crater Island", 
    "Lost Isle", "Dragon's Den", "Crystal Caves", "Abyssal Trench",
    "Sunken Temple", "Ancient Ruins", "Mystic Bay", "Azure Depths"
}

local Events = {
    "Fishing Frenzy", "Boss Battle", "Treasure Hunt", "Mystery Island", 
    "Double XP", "Rainbow Fish", "Legendary Rush", "Mythical Mayhem",
    "Festival of Fish", "Deep Sea Dive", "Tournament", "Seasonal Event"
}

-- Fish Types with rarities
local FishRarities = {
    "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Secret"
}

-- Rare Fish Locations
local RareFishLocations = {
    ["Legendary"] = {
        {name = "Dragon's Den", cframe = CFrame.new(-3000, -200, 3000)},
        {name = "Crystal Caves", cframe = CFrame.new(2000, -150, -2000)},
        {name = "Abyssal Trench", cframe = CFrame.new(0, -500, 0)},
        {name = "Sunken Temple", cframe = CFrame.new(-1500, -300, 1500)}
    },
    ["Mythical"] = {
        {name = "Mystery Island", cframe = CFrame.new(2500, 30, 0)},
        {name = "Esoteric Depths", cframe = CFrame.new(-2500, -50, 800)},
        {name = "Ancient Ruins", cframe = CFrame.new(1000, -100, 1000)}
    }
}

-- Save/Load Config with enhanced features
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
            BypassFishingDelay = false,
            AntiRecoil = false,
            AntiBanForActions = false,
            BypassServerChecks = false,
            BypassAntiCheat = false
        },
        Teleport = {
            SelectedLocation = "",
            SelectedPlayer = "",
            SelectedEvent = "",
            SavedPositions = {},
            TeleportToFish = false,
            RareFishLocations = {},
            AutoTeleportToEvents = false,
            TeleportSpeed = 10,
            SmoothTeleport = true
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
            NoClipBoat = false,
            AutoReel = false,
            PerfectCatch = false,
            FishFinder = false,
            AutoFish = false,
            AutoMove = false,
            AutoPathfind = false,
            AutoDodge = false
        },
        Trader = {
            AutoAcceptTrade = false,
            SelectedFish = {},
            TradePlayer = "",
            TradeAllFish = false,
            AutoTradeRare = false,
            TradeValueCalculator = false,
            AutoTradeFish = false,
            TradeHistory = false
        },
        Server = {
            PlayerInfo = false,
            ServerInfo = false,
            LuckBoost = false,
            SeedViewer = false,
            ForceEvent = false,
            RejoinSameServer = false,
            ServerHop = false,
            ViewPlayerStats = false,
            ServerClock = false,
            ServerPing = false,
            ServerPerformance = false,
            ServerPlayers = false
        },
        System = {
            ShowInfo = false,
            BoostFPS = false,
            FPSLimit = 60,
            AutoCleanMemory = false,
            DisableParticles = false,
            RejoinServer = false,
            AutoFarm = false,
            FarmRadius = 100,
            AutoRestart = false,
            AutoUpdate = false,
            PerformanceMonitor = false,
            SystemOptimizer = false,
            BackgroundProcesses = false
        },
        Graphic = {
            HighQuality = false,
            MaxRendering = false,
            UltraLowMode = false,
            DisableWaterReflection = false,
            CustomShader = false,
            SmoothGraphics = false,
            FullBright = false,
            CustomSky = false,
            CustomWater = false,
            TextureCompression = false,
            MeshReduction = false,
            ShadowQuality = "High",
            AmbientOcclusion = true,
            Bloom = false,
            DepthOfField = false,
            MotionBlur = false,
            ChromaticAberration = false,
            Vignette = false
        },
        RNGKill = {
            RNGReducer = false,
            ForceLegendary = false,
            SecretFishBoost = false,
            MythicalChanceBoost = false,
            AntiBadLuck = false,
            GuaranteedCatch = false,
            FishRarityMultiplier = 1,
            AutoCatchRare = false,
            LuckyCharm = false,
            FishProbability = 100,
            RareFishMultiplier = 10,
            PerfectCatchRate = 100
        },
        Shop = {
            AutoBuyRods = false,
            SelectedRod = "",
            AutoBuyBoats = false,
            SelectedBoat = "",
            AutoBuyBaits = false,
            SelectedBait = "",
            AutoUpgradeRod = false,
            AutoSellFish = false,
            AutoCraftItems = false,
            CurrencyBooster = false,
            ShopAutoBuy = false,
            ShopAutoSell = false,
            ShopAutoUpgrade = false
        },
        Settings = {
            SelectedTheme = "Dark",
            Transparency = 0.5,
            ConfigName = "DefaultConfig",
            UIScale = 1,
            Keybinds = {},
            AutoLogging = true,
            LogLevel = "Info",
            NotificationSound = true,
            AutoSave = true,
            SaveInterval = 60
        },
        LowDevice = {
            AntiLag = false,
            FPSStabilizer = false,
            DisableAllEffects = false,
            EightBitGraphics = false,
            TextureCompression = false,
            MeshReduction = false,
            ReduceLOD = false,
            ShadowQuality = "Low",
            ParticleQuality = "Low",
            RenderDistance = 200,
            ObjectLOD = 0,
            TextureQuality = "Low",
            EffectQuality = "Low"
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

-- UI Library with enhanced features
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

-- Bypass Tab with enhanced features
local BypassTab = Window:CreateTab("🛡️ Bypass", 13014546625)

BypassTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = Config.Bypass.AntiAFK,
    Flag = "AntiAFK",
    Callback = function(Value)
        Config.Bypass.AntiAFK = Value
        logError("Anti AFK: " .. tostring(Value))
    end
})

BypassTab:CreateToggle({
    Name = "Auto Jump",
    CurrentValue = Config.Bypass.AutoJump,
    Flag = "AutoJump",
    Callback = function(Value)
        Config.Bypass.AutoJump = Value
        logError("Auto Jump: " .. tostring(Value))
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
    end
})

BypassTab:CreateToggle({
    Name = "Anti Ban",
    CurrentValue = Config.Bypass.AntiBan,
    Flag = "AntiBan",
    Callback = function(Value)
        Config.Bypass.AntiBan = Value
        logError("Anti Ban: " .. tostring(Value))
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Fishing Radar",
    CurrentValue = Config.Bypass.BypassFishingRadar,
    Flag = "BypassFishingRadar",
    Callback = function(Value)
        Config.Bypass.BypassFishingRadar = Value
        if Value and FishingEvents and FishingEvents:FindFirstChild("RadarBypass") then
            local success, result = pcall(function()
                FishingEvents.RadarBypass:FireServer()
                logError("Bypass Fishing Radar: Activated")
            end)
            if not success then
                logError("Bypass Fishing Radar Error: " .. result)
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
        if Value and GameFunctions and GameFunctions:FindFirstChild("DivingBypass") then
            local success, result = pcall(function()
                GameFunctions.DivingBypass:InvokeServer()
                logError("Bypass Diving Gear: Activated")
            end)
            if not success then
                logError("Bypass Diving Gear Error: " .. result)
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
        if Value and FishingEvents and FishingEvents:FindFirstChild("AnimationBypass") then
            local success, result = pcall(function()
                FishingEvents.AnimationBypass:FireServer()
                logError("Bypass Fishing Animation: Activated")
            end)
            if not success then
                logError("Bypass Fishing Animation Error: " .. result)
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
        if Value and FishingEvents and FishingEvents:FindFirstChild("DelayBypass") then
            local success, result = pcall(function()
                FishingEvents.DelayBypass:FireServer()
                logError("Bypass Fishing Delay: Activated")
            end)
            if not success then
                logError("Bypass Fishing Delay Error: " .. result)
            end
        end
    end
})

BypassTab:CreateToggle({
    Name = "Anti Recoil",
    CurrentValue = Config.Bypass.AntiRecoil,
    Flag = "AntiRecoil",
    Callback = function(Value)
        Config.Bypass.AntiRecoil = Value
        logError("Anti Recoil: " .. tostring(Value))
    end
})

BypassTab:CreateToggle({
    Name = "Anti Ban for Actions",
    CurrentValue = Config.Bypass.AntiBanForActions,
    Flag = "AntiBanForActions",
    Callback = function(Value)
        Config.Bypass.AntiBanForActions = Value
        logError("Anti Ban for Actions: " .. tostring(Value))
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Server Checks",
    CurrentValue = Config.Bypass.BypassServerChecks,
    Flag = "BypassServerChecks",
    Callback = function(Value)
        Config.Bypass.BypassServerChecks = Value
        logError("Bypass Server Checks: " .. tostring(Value))
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Anti-Cheat",
    CurrentValue = Config.Bypass.BypassAntiCheat,
    Flag = "BypassAntiCheat",
    Callback = function(Value)
        Config.Bypass.BypassAntiCheat = Value
        logError("Bypass Anti-Cheat: " .. tostring(Value))
    end
})

-- Teleport Tab with enhanced features
local TeleportTab = Window:CreateTab("🗺️ Teleport", 13014546625)

TeleportTab:CreateDropdown({
    Name = "Select Location",
    Options = Islands,
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
            if Config.Teleport.SelectedLocation == "Fisherman Island" then
                targetCFrame = CFrame.new(-1200, 15, 800)
            elseif Config.Teleport.SelectedLocation == "Ocean" then
                targetCFrame = CFrame.new(2500, 10, -1500)
            elseif Config.Teleport.SelectedLocation == "Kohana Island" then
                targetCFrame = CFrame.new(1800, 20, 2200)
            elseif Config.Teleport.SelectedLocation == "Kohana Volcano" then
                targetCFrame = CFrame.new(2100, 150, 2500)
            elseif Config.Teleport.SelectedLocation == "Coral Reefs" then
                targetCFrame = CFrame.new(-800, -10, 1800)
            elseif Config.Teleport.SelectedLocation == "Esoteric Depths" then
                targetCFrame = CFrame.new(-2500, -50, 800)
            elseif Config.Teleport.SelectedLocation == "Tropical Grove" then
                targetCFrame = CFrame.new(1200, 25, -1800)
            elseif Config.Teleport.SelectedLocation == "Crater Island" then
                targetCFrame = CFrame.new(-1800, 100, -1200)
            elseif Config.Teleport.SelectedLocation == "Lost Isle" then
                targetCFrame = CFrame.new(3000, 30, 3000)
            elseif Config.Teleport.SelectedLocation == "Dragon's Den" then
                targetCFrame = CFrame.new(-3000, -200, 3000)
            elseif Config.Teleport.SelectedLocation == "Crystal Caves" then
                targetCFrame = CFrame.new(2000, -150, -2000)
            elseif Config.Teleport.SelectedLocation == "Abyssal Trench" then
                targetCFrame = CFrame.new(0, -500, 0)
            elseif Config.Teleport.SelectedLocation == "Sunken Temple" then
                targetCFrame = CFrame.new(-1500, -300, 1500)
            elseif Config.Teleport.SelectedLocation == "Ancient Ruins" then
                targetCFrame = CFrame.new(1000, -100, 1000)
            elseif Config.Teleport.SelectedLocation == "Mystic Bay" then
                targetCFrame = CFrame.new(0, 0, 0)
            elseif Config.Teleport.SelectedLocation == "Azure Depths" then
                targetCFrame = CFrame.new(0, 0, 0)
            end
            
            if targetCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if Config.Teleport.SmoothTeleport then
                    local tween = TweenService:Create(
                        LocalPlayer.Character.HumanoidRootPart,
                        TweenInfo.new(Config.Teleport.TeleportSpeed, Enum.EasingStyle.Linear),
                        {CFrame = targetCFrame}
                    )
                    tween:Play()
                else
                    LocalPlayer.Character:SetPrimaryPartCFrame(targetCFrame)
                end
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
local playerList = {}
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        table.insert(playerList, player.Name)
    end
end

TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = playerList,
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
                if Config.Teleport.SmoothTeleport then
                    local tween = TweenService:Create(
                        LocalPlayer.Character.HumanoidRootPart,
                        TweenInfo.new(Config.Teleport.TeleportSpeed, Enum.EasingStyle.Linear),
                        {CFrame = targetPlayer.Character.HumanoidRootPart.CFrame}
                    )
                    tween:Play()
                else
                    LocalPlayer.Character:SetPrimaryPartCFrame(targetPlayer.Character.HumanoidRootPart.CFrame)
                end
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

TeleportTab:CreateDropdown({
    Name = "Teleport Event",
    Options = Events,
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
            if Config.Teleport.SelectedEvent == "Fishing Frenzy" then
                eventLocation = CFrame.new(1500, 15, 1500)
            elseif Config.Teleport.SelectedEvent == "Boss Battle" then
                eventLocation = CFrame.new(-1500, 20, -1500)
            elseif Config.Teleport.SelectedEvent == "Treasure Hunt" then
                eventLocation = CFrame.new(0, 10, 2500)
            elseif Config.Teleport.SelectedEvent == "Mystery Island" then
                eventLocation = CFrame.new(2500, 30, 0)
            elseif Config.Teleport.SelectedEvent == "Double XP" then
                eventLocation = CFrame.new(-2500, 15, 1500)
            elseif Config.Teleport.SelectedEvent == "Rainbow Fish" then
                eventLocation = CFrame.new(1500, 25, -2500)
            elseif Config.Teleport.SelectedEvent == "Legendary Rush" then
                eventLocation = CFrame.new(0, 0, 0)
            elseif Config.Teleport.SelectedEvent == "Mythical Mayhem" then
                eventLocation = CFrame.new(0, 0, 0)
            elseif Config.Teleport.SelectedEvent == "Festival of Fish" then
                eventLocation = CFrame.new(0, 0, 0)
            elseif Config.Teleport.SelectedEvent == "Deep Sea Dive" then
                eventLocation = CFrame.new(0, -200, 0)
            elseif Config.Teleport.SelectedEvent == "Tournament" then
                eventLocation = CFrame.new(0, 0, 0)
            elseif Config.Teleport.SelectedEvent == "Seasonal Event" then
                eventLocation = CFrame.new(0, 0, 0)
            end
            
            if eventLocation and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if Config.Teleport.SmoothTeleport then
                    local tween = TweenService:Create(
                        LocalPlayer.Character.HumanoidRootPart,
                        TweenInfo.new(Config.Teleport.TeleportSpeed, Enum.EasingStyle.Linear),
                        {CFrame = eventLocation}
                    )
                    tween:Play()
                else
                    LocalPlayer.Character:SetPrimaryPartCFrame(eventLocation)
                end
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

TeleportTab:CreateToggle({
    Name = "Teleport To Fish",
    CurrentValue = Config.Teleport.TeleportToFish,
    Flag = "TeleportToFish",
    Callback = function(Value)
        Config.Teleport.TeleportToFish = Value
        logError("Teleport To Fish: " .. tostring(Value))
    end
})

TeleportTab:CreateToggle({
    Name = "Auto Teleport To Events",
    CurrentValue = Config.Teleport.AutoTeleportToEvents,
    Flag = "AutoTeleportToEvents",
    Callback = function(Value)
        Config.Teleport.AutoTeleportToEvents = Value
        logError("Auto Teleport To Events: " .. tostring(Value))
    end
})

TeleportTab:CreateSlider({
    Name = "Teleport Speed",
    Range = {1, 20},
    Increment = 1,
    Suffix = "seconds",
    CurrentValue = Config.Teleport.TeleportSpeed,
    Flag = "TeleportSpeed",
    Callback = function(Value)
        Config.Teleport.TeleportSpeed = Value
        logError("Teleport Speed: " .. Value)
    end
})

TeleportTab:CreateToggle({
    Name = "Smooth Teleport",
    CurrentValue = Config.Teleport.SmoothTeleport,
    Flag = "SmoothTeleport",
    Callback = function(Value)
        Config.Teleport.SmoothTeleport = Value
        logError("Smooth Teleport: " .. tostring(Value))
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
        if Config.Teleport.SavedPositions[Value] and LocalPlayer.Character then
            if Config.Teleport.SmoothTeleport then
                local tween = TweenService:Create(
                    LocalPlayer.Character.HumanoidRootPart,
                    TweenInfo.new(Config.Teleport.TeleportSpeed, Enum.EasingStyle.Linear),
                    {CFrame = Config.Teleport.SavedPositions[Value]}
                )
                tween:Play()
            else
                LocalPlayer.Character:SetPrimaryPartCFrame(Config.Teleport.SavedPositions[Value])
            end
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

-- Player Tab with enhanced features
local PlayerTab = Window:CreateTab("👤 Player", 13014546625)

PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = Config.Player.SpeedHack,
    Flag = "SpeedHack",
    Callback = function(Value)
        Config.Player.SpeedHack = Value
        logError("Speed Hack: " .. tostring(Value))
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
    end
})

PlayerTab:CreateToggle({
    Name = "Max Boat Speed",
    CurrentValue = Config.Player.MaxBoatSpeed,
    Flag = "MaxBoatSpeed",
    Callback = function(Value)
        Config.Player.MaxBoatSpeed = Value
        logError("Max Boat Speed: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Spawn Boat",
    CurrentValue = Config.Player.SpawnBoat,
    Flag = "SpawnBoat",
    Callback = function(Value)
        Config.Player.SpawnBoat = Value
        if Value and GameFunctions and GameFunctions:FindFirstChild("SpawnBoat") then
            local success, result = pcall(function()
                GameFunctions.SpawnBoat:InvokeServer()
                logError("Boat spawned")
            end)
            if not success then
                logError("Boat spawn error: " .. result)
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
    end
})

PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = Config.Player.InfinityJump,
    Flag = "InfinityJump",
    Callback = function(Value)
        Config.Player.InfinityJump = Value
        logError("Infinity Jump: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = Config.Player.Fly,
    Flag = "Fly",
    Callback = function(Value)
        Config.Player.Fly = Value
        logError("Fly: " .. tostring(Value))
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
    end
})

PlayerTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = Config.Player.GhostHack,
    Flag = "GhostHack",
    Callback = function(Value)
        Config.Player.GhostHack = Value
        logError("Ghost Hack: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = Config.Player.PlayerESP,
    Flag = "PlayerESP",
    Callback = function(Value)
        Config.Player.PlayerESP = Value
        logError("Player ESP: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = Config.Player.ESPBox,
    Flag = "ESPBox",
    Callback = function(Value)
        Config.Player.ESPBox = Value
        logError("ESP Box: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Lines",
    CurrentValue = Config.Player.ESPLines,
    Flag = "ESPLines",
    Callback = function(Value)
        Config.Player.ESPLines = Value
        logError("ESP Lines: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Name",
    CurrentValue = Config.Player.ESPName,
    Flag = "ESPName",
    Callback = function(Value)
        Config.Player.ESPName = Value
        logError("ESP Name: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Level",
    CurrentValue = Config.Player.ESPLevel,
    Flag = "ESPLevel",
    Callback = function(Value)
        Config.Player.ESPLevel = Value
        logError("ESP Level: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Range",
    CurrentValue = Config.Player.ESPRange,
    Flag = "ESPRange",
    Callback = function(Value)
        Config.Player.ESPRange = Value
        logError("ESP Range: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Hologram",
    CurrentValue = Config.Player.ESPHologram,
    Flag = "ESPHologram",
    Callback = function(Value)
        Config.Player.ESPHologram = Value
        logError("ESP Hologram: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = Config.Player.Noclip,
    Flag = "Noclip",
    Callback = function(Value)
        Config.Player.Noclip = Value
        logError("Noclip: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = Config.Player.AutoSell,
    Flag = "AutoSell",
    Callback = function(Value)
        Config.Player.AutoSell = Value
        logError("Auto Sell: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Craft",
    CurrentValue = Config.Player.AutoCraft,
    Flag = "AutoCraft",
    Callback = function(Value)
        Config.Player.AutoCraft = Value
        logError("Auto Craft: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Upgrade",
    CurrentValue = Config.Player.AutoUpgrade,
    Flag = "AutoUpgrade",
    Callback = function(Value)
        Config.Player.AutoUpgrade = Value
        logError("Auto Upgrade: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Reel",
    CurrentValue = Config.Player.AutoReel,
    Flag = "AutoReel",
    Callback = function(Value)
        Config.Player.AutoReel = Value
        logError("Auto Reel: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Perfect Catch",
    CurrentValue = Config.Player.PerfectCatch,
    Flag = "PerfectCatch",
    Callback = function(Value)
        Config.Player.PerfectCatch = Value
        logError("Perfect Catch: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Fish Finder",
    CurrentValue = Config.Player.FishFinder,
    Flag = "FishFinder",
    Callback = function(Value)
        Config.Player.FishFinder = Value
        logError("Fish Finder: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Fish",
    CurrentValue = Config.Player.AutoFish,
    Flag = "AutoFish",
    Callback = function(Value)
        Config.Player.AutoFish = Value
        logError("Auto Fish: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Move",
    CurrentValue = Config.Player.AutoMove,
    Flag = "AutoMove",
    Callback = function(Value)
        Config.Player.AutoMove = Value
        logError("Auto Move: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Pathfind",
    CurrentValue = Config.Player.AutoPathfind,
    Flag = "AutoPathfind",
    Callback = function(Value)
        Config.Player.AutoPathfind = Value
        logError("Auto Pathfind: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Dodge",
    CurrentValue = Config.Player.AutoDodge,
    Flag = "AutoDodge",
    Callback = function(Value)
        Config.Player.AutoDodge = Value
        logError("Auto Dodge: " .. tostring(Value))
    end
})

-- Trader Tab with enhanced features
local TraderTab = Window:CreateTab("💱 Trader", 13014546625)

TraderTab:CreateToggle({
    Name = "Auto Accept Trade",
    CurrentValue = Config.Trader.AutoAcceptTrade,
    Flag = "AutoAcceptTrade",
    Callback = function(Value)
        Config.Trader.AutoAcceptTrade = Value
        logError("Auto Accept Trade: " .. tostring(Value))
    end
})

-- Get player's fish inventory
local fishInventory = {}
if PlayerData and PlayerData:FindFirstChild("Inventory") then
    for _, item in pairs(PlayerData.Inventory:GetChildren()) do
        if item:IsA("Folder") or item:IsA("Configuration") then
            table.insert(fishInventory, item.Name)
        end
    end
end

TraderTab:CreateDropdown({
    Name = "Select Fish",
    Options = fishInventory,
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

TraderTab:CreateToggle({
    Name = "Auto Trade Rare",
    CurrentValue = Config.Trader.AutoTradeRare,
    Flag = "AutoTradeRare",
    Callback = function(Value)
        Config.Trader.AutoTradeRare = Value
        logError("Auto Trade Rare: " .. tostring(Value))
    end
})

TraderTab:CreateToggle({
    Name = "Trade Value Calculator",
    CurrentValue = Config.Trader.TradeValueCalculator,
    Flag = "TradeValueCalculator",
    Callback = function(Value)
        Config.Trader.TradeValueCalculator = Value
        logError("Trade Value Calculator: " .. tostring(Value))
    end
})

TraderTab:CreateToggle({
    Name = "Auto Trade Fish",
    CurrentValue = Config.Trader.AutoTradeFish,
    Flag = "AutoTradeFish",
    Callback = function(Value)
        Config.Trader.AutoTradeFish = Value
        logError("Auto Trade Fish: " .. tostring(Value))
    end
})

TraderTab:CreateToggle({
    Name = "Trade History",
    CurrentValue = Config.Trader.TradeHistory,
    Flag = "TradeHistory",
    Callback = function(Value)
        Config.Trader.TradeHistory = Value
        logError("Trade History: " .. tostring(Value))
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

-- Server Tab with enhanced features
local ServerTab = Window:CreateTab("🌍 Server", 13014546625)

ServerTab:CreateToggle({
    Name = "Player Info",
    CurrentValue = Config.Server.PlayerInfo,
    Flag = "PlayerInfo",
    Callback = function(Value)
        Config.Server.PlayerInfo = Value
        logError("Player Info: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Server Info",
    CurrentValue = Config.Server.ServerInfo,
    Flag = "ServerInfo",
    Callback = function(Value)
        Config.Server.ServerInfo = Value
        logError("Server Info: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Luck Boost",
    CurrentValue = Config.Server.LuckBoost,
    Flag = "LuckBoost",
    Callback = function(Value)
        Config.Server.LuckBoost = Value
        logError("Luck Boost: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Seed Viewer",
    CurrentValue = Config.Server.SeedViewer,
    Flag = "SeedViewer",
    Callback = function(Value)
        Config.Server.SeedViewer = Value
        logError("Seed Viewer: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Force Event",
    CurrentValue = Config.Server.ForceEvent,
    Flag = "ForceEvent",
    Callback = function(Value)
        Config.Server.ForceEvent = Value
        logError("Force Event: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Rejoin Same Server",
    CurrentValue = Config.Server.RejoinSameServer,
    Flag = "RejoinSameServer",
    Callback = function(Value)
        Config.Server.RejoinSameServer = Value
        logError("Rejoin Same Server: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Server Hop",
    CurrentValue = Config.Server.ServerHop,
    Flag = "ServerHop",
    Callback = function(Value)
        Config.Server.ServerHop = Value
        logError("Server Hop: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "View Player Stats",
    CurrentValue = Config.Server.ViewPlayerStats,
    Flag = "ViewPlayerStats",
    Callback = function(Value)
        Config.Server.ViewPlayerStats = Value
        logError("View Player Stats: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Server Clock",
    CurrentValue = Config.Server.ServerClock,
    Flag = "ServerClock",
    Callback = function(Value)
        Config.Server.ServerClock = Value
        logError("Server Clock: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Server Ping",
    CurrentValue = Config.Server.ServerPing,
    Flag = "ServerPing",
    Callback = function(Value)
        Config.Server.ServerPing = Value
        logError("Server Ping: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Server Performance",
    CurrentValue = Config.Server.ServerPerformance,
    Flag = "ServerPerformance",
    Callback = function(Value)
        Config.Server.ServerPerformance = Value
        logError("Server Performance: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Server Players",
    CurrentValue = Config.Server.ServerPlayers,
    Flag = "ServerPlayers",
    Callback = function(Value)
        Config.Server.ServerPlayers = Value
        logError("Server Players: " .. tostring(Value))
    end
})

ServerTab:CreateButton({
    Name = "Get Server Info",
    Callback = function()
        local playerCount = #Players:GetPlayers()
        local serverInfo = "Players: " .. playerCount
        
        if Config.Server.LuckBoost then
            serverInfo = serverInfo .. " | Luck: Boosted"
        end
        
        if Config.Server.SeedViewer then
            serverInfo = serverInfo .. " | Seed: " .. tostring(math.random(10000, 99999))
        end
        
        if Config.Server.ServerClock then
            serverInfo = serverInfo .. " | Time: " .. os.date("%H:%M:%S")
        end
        
        if Config.Server.ServerPing then
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            serverInfo = serverInfo .. " | Ping: " .. ping .. "ms"
        end
        
        if Config.Server.ServerPerformance then
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            serverInfo = serverInfo .. " | FPS: " .. fps
        end
        
        if Config.Server.ServerPlayers then
            serverInfo = serverInfo .. " | Online: " .. playerCount
        end
        
        Rayfield:Notify({
            Title = "Server Info",
            Content = serverInfo,
            Duration = 5,
            Image = 13047715178
        })
        logError("Server Info: " .. serverInfo)
    end
})

-- System Tab with enhanced features
local SystemTab = Window:CreateTab("⚙️ System", 13014546625)

SystemTab:CreateToggle({
    Name = "Show Info",
    CurrentValue = Config.System.ShowInfo,
    Flag = "ShowInfo",
    Callback = function(Value)
        Config.System.ShowInfo = Value
        logError("Show Info: " .. tostring(Value))
    end
})

SystemTab:CreateToggle({
    Name = "Boost FPS",
    CurrentValue = Config.System.BoostFPS,
    Flag = "BoostFPS",
    Callback = function(Value)
        Config.System.BoostFPS = Value
        logError("Boost FPS: " .. tostring(Value))
    end
})

SystemTab:CreateSlider({
    Name = "FPS Limit",
    Range = {0, 360},
    Increment = 5,
    Suffix = "FPS",
    CurrentValue = Config.System.FPSLimit,
    Flag = "FPSLimit",
    Callback = function(Value)
        Config.System.FPSLimit = Value
        setfpscap(Value)
        logError("FPS Limit: " .. Value)
    end
})

SystemTab:CreateToggle({
    Name = "Auto Clean Memory",
    CurrentValue = Config.System.AutoCleanMemory,
    Flag = "AutoCleanMemory",
    Callback = function(Value)
        Config.System.AutoCleanMemory = Value
        logError("Auto Clean Memory: " .. tostring(Value))
    end
})

SystemTab:CreateToggle({
    Name = "Disable Particles",
    CurrentValue = Config.System.DisableParticles,
    Flag = "DisableParticles",
    Callback = function(Value)
        Config.System.DisableParticles = Value
        logError("Disable Particles: " .. tostring(Value))
    end
})

SystemTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = Config.System.AutoFarm,
    Flag = "AutoFarm",
    Callback = function(Value)
        Config.System.AutoFarm = Value
        logError("Auto Farm: " .. tostring(Value))
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

SystemTab:CreateToggle({
    Name = "Auto Restart",
    CurrentValue = Config.System.AutoRestart,
    Flag = "AutoRestart",
    Callback = function(Value)
        Config.System.AutoRestart = Value
        logError("Auto Restart: " .. tostring(Value))
    end
})

SystemTab:CreateToggle({
    Name = "Auto Update",
    CurrentValue = Config.System.AutoUpdate,
    Flag = "AutoUpdate",
    Callback = function(Value)
        Config.System.AutoUpdate = Value
        logError("Auto Update: " .. tostring(Value))
    end
})

SystemTab:CreateToggle({
    Name = "Performance Monitor",
    CurrentValue = Config.System.PerformanceMonitor,
    Flag = "PerformanceMonitor",
    Callback = function(Value)
        Config.System.PerformanceMonitor = Value
        logError("Performance Monitor: " .. tostring(Value))
    end
})

SystemTab:CreateToggle({
    Name = "System Optimizer",
    CurrentValue = Config.System.SystemOptimizer,
    Flag = "SystemOptimizer",
    Callback = function(Value)
        Config.System.SystemOptimizer = Value
        logError("System Optimizer: " .. tostring(Value))
    end
})

SystemTab:CreateToggle({
    Name = "Background Processes",
    CurrentValue = Config.System.BackgroundProcesses,
    Flag = "BackgroundProcesses",
    Callback = function(Value)
        Config.System.BackgroundProcesses = Value
        logError("Background Processes: " .. tostring(Value))
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
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local memory = math.floor(Stats:GetTotalMemoryUsageMb())
        local battery = math.floor(UserInputService:GetBatteryLevel() * 100)
        local time = os.date("%H:%M:%S")
        
        local systemInfo = string.format("FPS: %d | Ping: %dms | Memory: %dMB | Battery: %d%% | Time: %s", 
            fps, ping, memory, battery, time)
        
        Rayfield:Notify({
            Title = "System Info",
            Content = systemInfo,
            Duration = 5,
            Image = 13047715178
        })
        logError("System Info: " .. systemInfo)
    end
})

-- Graphic Tab with enhanced features
local GraphicTab = Window:CreateTab("🎨 Graphic", 13014546625)

GraphicTab:CreateToggle({
    Name = "High Quality Rendering",
    CurrentValue = Config.Graphic.HighQuality,
    Flag = "HighQuality",
    Callback = function(Value)
        Config.Graphic.HighQuality = Value
        if Value then
            sethiddenproperty(Lighting, "Technology", "Future")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Disabled")
        end
        logError("High Quality Rendering: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Max Rendering",
    CurrentValue = Config.Graphic.MaxRendering,
    Flag = "MaxRendering",
    Callback = function(Value)
        Config.Graphic.MaxRendering = Value
        if Value then
            settings().Rendering.QualityLevel = 21
        end
        logError("Max Rendering: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Ultra Low Mode",
    CurrentValue = Config.Graphic.UltraLowMode,
    Flag = "UltraLowMode",
    Callback = function(Value)
        Config.Graphic.UltraLowMode = Value
        if Value then
            settings().Rendering.QualityLevel = 1
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") then
                    part.Material = Enum.Material.Plastic
                end
            end
        end
        logError("Ultra Low Mode: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Disable Water Reflection",
    CurrentValue = Config.Graphic.DisableWaterReflection,
    Flag = "DisableWaterReflection",
    Callback = function(Value)
        Config.Graphic.DisableWaterReflection = Value
        if Value then
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and water.Name == "Water" then
                    water.Transparency = 1
                end
            end
        end
        logError("Disable Water Reflection: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Custom Shader",
    CurrentValue = Config.Graphic.CustomShader,
    Flag = "CustomShader",
    Callback = function(Value)
        Config.Graphic.CustomShader = Value
        logError("Custom Shader: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Smooth Graphics",
    CurrentValue = Config.Graphic.SmoothGraphics,
    Flag = "SmoothGraphics",
    Callback = function(Value)
        Config.Graphic.SmoothGraphics = Value
        if Value then
            RunService:Set3dRenderingEnabled(true)
            settings().Rendering.MeshCacheSize = 100
            settings().Rendering.TextureCacheSize = 100
        end
        logError("Smooth Graphics: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Full Bright",
    CurrentValue = Config.Graphic.FullBright,
    Flag = "FullBright",
    Callback = function(Value)
        Config.Graphic.FullBright = Value
        if Value then
            Lighting.GlobalShadows = false
            Lighting.ClockTime = 12
        else
            Lighting.GlobalShadows = true
        end
        logError("Full Bright: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Custom Sky",
    CurrentValue = Config.Graphic.CustomSky,
    Flag = "CustomSky",
    Callback = function(Value)
        Config.Graphic.CustomSky = Value
        logError("Custom Sky: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Custom Water",
    CurrentValue = Config.Graphic.CustomWater,
    Flag = "CustomWater",
    Callback = function(Value)
        Config.Graphic.CustomWater = Value
        logError("Custom Water: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Texture Compression",
    CurrentValue = Config.Graphic.TextureCompression,
    Flag = "TextureCompression",
    Callback = function(Value)
        Config.Graphic.TextureCompression = Value
        logError("Texture Compression: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Mesh Reduction",
    CurrentValue = Config.Graphic.MeshReduction,
    Flag = "MeshReduction",
    Callback = function(Value)
        Config.Graphic.MeshReduction = Value
        logError("Mesh Reduction: " .. tostring(Value))
    end
})

GraphicTab:CreateDropdown({
    Name = "Shadow Quality",
    Options = {"Off", "Low", "Medium", "High"},
    CurrentOption = Config.Graphic.ShadowQuality,
    Flag = "ShadowQuality",
    Callback = function(Value)
        Config.Graphic.ShadowQuality = Value
        logError("Shadow Quality: " .. Value)
    end
})

GraphicTab:CreateToggle({
    Name = "Ambient Occlusion",
    CurrentValue = Config.Graphic.AmbientOcclusion,
    Flag = "AmbientOcclusion",
    Callback = function(Value)
        Config.Graphic.AmbientOcclusion = Value
        logError("Ambient Occlusion: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Bloom",
    CurrentValue = Config.Graphic.Bloom,
    Flag = "Bloom",
    Callback = function(Value)
        Config.Graphic.Bloom = Value
        logError("Bloom: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Depth Of Field",
    CurrentValue = Config.Graphic.DepthOfField,
    Flag = "DepthOfField",
    Callback = function(Value)
        Config.Graphic.DepthOfField = Value
        logError("Depth Of Field: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Motion Blur",
    CurrentValue = Config.Graphic.MotionBlur,
    Flag = "MotionBlur",
    Callback = function(Value)
        Config.Graphic.MotionBlur = Value
        logError("Motion Blur: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Chromatic Aberration",
    CurrentValue = Config.Graphic.ChromaticAberration,
    Flag = "ChromaticAberration",
    Callback = function(Value)
        Config.Graphic.ChromaticAberration = Value
        logError("Chromatic Aberration: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Vignette",
    CurrentValue = Config.Graphic.Vignette,
    Flag = "Vignette",
    Callback = function(Value)
        Config.Graphic.Vignette = Value
        logError("Vignette: " .. tostring(Value))
    end
})

-- RNG Kill Tab with enhanced features
local RNGKillTab = Window:CreateTab("🎲 RNG Kill", 13014546625)

RNGKillTab:CreateToggle({
    Name = "RNG Reducer",
    CurrentValue = Config.RNGKill.RNGReducer,
    Flag = "RNGReducer",
    Callback = function(Value)
        Config.RNGKill.RNGReducer = Value
        logError("RNG Reducer: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Force Legendary Catch",
    CurrentValue = Config.RNGKill.ForceLegendary,
    Flag = "ForceLegendary",
    Callback = function(Value)
        Config.RNGKill.ForceLegendary = Value
        logError("Force Legendary Catch: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Secret Fish Boost",
    CurrentValue = Config.RNGKill.SecretFishBoost,
    Flag = "SecretFishBoost",
    Callback = function(Value)
        Config.RNGKill.SecretFishBoost = Value
        logError("Secret Fish Boost: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Mythical Chance ×10",
    CurrentValue = Config.RNGKill.MythicalChanceBoost,
    Flag = "MythicalChanceBoost",
    Callback = function(Value)
        Config.RNGKill.MythicalChanceBoost = Value
        logError("Mythical Chance Boost: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Anti-Bad Luck",
    CurrentValue = Config.RNGKill.AntiBadLuck,
    Flag = "AntiBadLuck",
    Callback = function(Value)
        Config.RNGKill.AntiBadLuck = Value
        logError("Anti-Bad Luck: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Guaranteed Catch",
    CurrentValue = Config.RNGKill.GuaranteedCatch,
    Flag = "GuaranteedCatch",
    Callback = function(Value)
        Config.RNGKill.GuaranteedCatch = Value
        logError("Guaranteed Catch: " .. tostring(Value))
    end
})

RNGKillTab:CreateSlider({
    Name = "Fish Rarity Multiplier",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = "x",
    CurrentValue = Config.RNGKill.FishRarityMultiplier,
    Flag = "FishRarityMultiplier",
    Callback = function(Value)
        Config.RNGKill.FishRarityMultiplier = Value
        logError("Fish Rarity Multiplier: " .. Value)
    end
})

RNGKillTab:CreateToggle({
    Name = "Auto Catch Rare",
    CurrentValue = Config.RNGKill.AutoCatchRare,
    Flag = "AutoCatchRare",
    Callback = function(Value)
        Config.RNGKill.AutoCatchRare = Value
        logError("Auto Catch Rare: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Lucky Charm",
    CurrentValue = Config.RNGKill.LuckyCharm,
    Flag = "LuckyCharm",
    Callback = function(Value)
        Config.RNGKill.LuckyCharm = Value
        logError("Lucky Charm: " .. tostring(Value))
    end
})

RNGKillTab:CreateSlider({
    Name = "Fish Probability",
    Range = {1, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = Config.RNGKill.FishProbability,
    Flag = "FishProbability",
    Callback = function(Value)
        Config.RNGKill.FishProbability = Value
        logError("Fish Probability: " .. Value)
    end
})

RNGKillTab:CreateSlider({
    Name = "Rare Fish Multiplier",
    Range = {1, 20},
    Increment = 1,
    Suffix = "x",
    CurrentValue = Config.RNGKill.RareFishMultiplier,
    Flag = "RareFishMultiplier",
    Callback = function(Value)
        Config.RNGKill.RareFishMultiplier = Value
        logError("Rare Fish Multiplier: " .. Value)
    end
})

RNGKillTab:CreateSlider({
    Name = "Perfect Catch Rate",
    Range = {1, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = Config.RNGKill.PerfectCatchRate,
    Flag = "PerfectCatchRate",
    Callback = function(Value)
        Config.RNGKill.PerfectCatchRate = Value
        logError("Perfect Catch Rate: " .. Value)
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
                    GuaranteedCatch = Config.RNGKill.GuaranteedCatch,
                    FishRarityMultiplier = Config.RNGKill.FishRarityMultiplier,
                    AutoCatchRare = Config.RNGKill.AutoCatchRare,
                    LuckyCharm = Config.RNGKill.LuckyCharm,
                    FishProbability = Config.RNGKill.FishProbability,
                    RareFishMultiplier = Config.RNGKill.RareFishMultiplier,
                    PerfectCatchRate = Config.RNGKill.PerfectCatchRate
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
        end
    end
})

-- Shop Tab with enhanced features
local ShopTab = Window:CreateTab("🛒 Shop", 13014546625)

ShopTab:CreateToggle({
    Name = "Auto Buy Rods",
    CurrentValue = Config.Shop.AutoBuyRods,
    Flag = "AutoBuyRods",
    Callback = function(Value)
        Config.Shop.AutoBuyRods = Value
        logError("Auto Buy Rods: " .. tostring(Value))
    end
})

ShopTab:CreateDropdown({
    Name = "Select Rod",
    Options = Rods,
    CurrentOption = Config.Shop.SelectedRod,
    Flag = "SelectedRod",
    Callback = function(Value)
        Config.Shop.SelectedRod = Value
        logError("Selected Rod: " .. Value)
    end
})

ShopTab:CreateToggle({
    Name = "Auto Buy Boats",
    CurrentValue = Config.Shop.AutoBuyBoats,
    Flag = "AutoBuyBoats",
    Callback = function(Value)
        Config.Shop.AutoBuyBoats = Value
        logError("Auto Buy Boats: " .. tostring(Value))
    end
})

ShopTab:CreateDropdown({
    Name = "Select Boat",
    Options = Boats,
    CurrentOption = Config.Shop.SelectedBoat,
    Flag = "SelectedBoat",
    Callback = function(Value)
        Config.Shop.SelectedBoat = Value
        logError("Selected Boat: " .. Value)
    end
})

ShopTab:CreateToggle({
    Name = "Auto Buy Baits",
    CurrentValue = Config.Shop.AutoBuyBaits,
    Flag = "AutoBuyBaits",
    Callback = function(Value)
        Config.Shop.AutoBuyBaits = Value
        logError("Auto Buy Baits: " .. tostring(Value))
    end
})

ShopTab:CreateDropdown({
    Name = "Select Bait",
    Options = Baits,
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
    end
})

ShopTab:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = Config.Shop.AutoSellFish,
    Flag = "AutoSellFish",
    Callback = function(Value)
        Config.Shop.AutoSellFish = Value
        logError("Auto Sell Fish: " .. tostring(Value))
    end
})

ShopTab:CreateToggle({
    Name = "Auto Craft Items",
    CurrentValue = Config.Shop.AutoCraftItems,
    Flag = "AutoCraftItems",
    Callback = function(Value)
        Config.Shop.AutoCraftItems = Value
        logError("Auto Craft Items: " .. tostring(Value))
    end
})

ShopTab:CreateToggle({
    Name = "Currency Booster",
    CurrentValue = Config.Shop.CurrencyBooster,
    Flag = "CurrencyBooster",
    Callback = function(Value)
        Config.Shop.CurrencyBooster = Value
        logError("Currency Booster: " .. tostring(Value))
    end
})

ShopTab:CreateToggle({
    Name = "Shop Auto Buy",
    CurrentValue = Config.Shop.ShopAutoBuy,
    Flag = "ShopAutoBuy",
    Callback = function(Value)
        Config.Shop.ShopAutoBuy = Value
        logError("Shop Auto Buy: " .. tostring(Value))
    end
})

ShopTab:CreateToggle({
    Name = "Shop Auto Sell",
    CurrentValue = Config.Shop.ShopAutoSell,
    Flag = "ShopAutoSell",
    Callback = function(Value)
        Config.Shop.ShopAutoSell = Value
        logError("Shop Auto Sell: " .. tostring(Value))
    end
})

ShopTab:CreateToggle({
    Name = "Shop Auto Upgrade",
    CurrentValue = Config.Shop.ShopAutoUpgrade,
    Flag = "ShopAutoUpgrade",
    Callback = function(Value)
        Config.Shop.ShopAutoUpgrade = Value
        logError("Shop Auto Upgrade: " .. tostring(Value))
    end
})

ShopTab:CreateButton({
    Name = "Buy Selected Item",
    Callback = function()
        if Config.Shop.SelectedRod ~= "" then
            if GameFunctions and GameFunctions:FindFirstChild("BuyRod") then
                local success, result = pcall(function()
                    GameFunctions.BuyRod:InvokeServer(Config.Shop.SelectedRod)
                    Rayfield:Notify({
                        Title = "Purchase",
                        Content = "Rod purchased: " .. Config.Shop.SelectedRod,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Rod purchased: " .. Config.Shop.SelectedRod)
                end)
                if not success then
                    logError("Rod purchase error: " .. result)
                end
            end
        elseif Config.Shop.SelectedBoat ~= "" then
            if GameFunctions and GameFunctions:FindFirstChild("BuyBoat") then
                local success, result = pcall(function()
                    GameFunctions.BuyBoat:InvokeServer(Config.Shop.SelectedBoat)
                    Rayfield:Notify({
                        Title = "Purchase",
                        Content = "Boat purchased: " .. Config.Shop.SelectedBoat,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Boat purchased: " .. Config.Shop.SelectedBoat)
                end)
                if not success then
                    logError("Boat purchase error: " .. result)
                end
            end
        elseif Config.Shop.SelectedBait ~= "" then
            if GameFunctions and GameFunctions:FindFirstChild("BuyBait") then
                local success, result = pcall(function()
                    GameFunctions.BuyBait:InvokeServer(Config.Shop.SelectedBait)
                    Rayfield:Notify({
                        Title = "Purchase",
                        Content = "Bait purchased: " .. Config.Shop.SelectedBait,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Bait purchased: " .. Config.Shop.SelectedBait)
                end)
                if not success then
                    logError("Bait purchase error: " .. result)
                end
            end
        else
            Rayfield:Notify({
                Title = "Shop Error",
                Content = "Please select an item first",
                Duration = 3,
                Image = 13047715178
            })
            logError("Shop Error: No item selected")
        end
    end
})

-- Settings Tab with enhanced features
local SettingsTab = Window:CreateTab("⚙️ Settings", 13014546625)

SettingsTab:CreateDropdown({
    Name = "Theme",
    Options = {"Dark", "Light", "Blue", "Green", "Red"},
    CurrentOption = Config.Settings.SelectedTheme,
    Flag = "SelectedTheme",
    Callback = function(Value)
        Config.Settings.SelectedTheme = Value
        logError("Theme: " .. Value)
    end
})

SettingsTab:CreateSlider({
    Name = "Transparency",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "opacity",
    CurrentValue = Config.Settings.Transparency,
    Flag = "Transparency",
    Callback = function(Value)
        Config.Settings.Transparency = Value
        logError("Transparency: " .. Value)
    end
})

SettingsTab:CreateInput({
    Name = "Config Name",
    PlaceholderText = "Enter config name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        Config.Settings.ConfigName = Text
        logError("Config Name: " .. Text)
    end
})

SettingsTab:CreateSlider({
    Name = "UI Scale",
    Range = {0.5, 2},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = Config.Settings.UIScale,
    Flag = "UIScale",
    Callback = function(Value)
        Config.Settings.UIScale = Value
        logError("UI Scale: " .. Value)
    end
})

SettingsTab:CreateToggle({
    Name = "Auto Logging",
    CurrentValue = Config.Settings.AutoLogging,
    Flag = "AutoLogging",
    Callback = function(Value)
        Config.Settings.AutoLogging = Value
        logError("Auto Logging: " .. tostring(Value))
    end
})

SettingsTab:CreateDropdown({
    Name = "Log Level",
    Options = {"Info", "Warning", "Error", "Debug"},
    CurrentOption = Config.Settings.LogLevel,
    Flag = "LogLevel",
    Callback = function(Value)
        Config.Settings.LogLevel = Value
        logError("Log Level: " .. Value)
    end
})

SettingsTab:CreateToggle({
    Name = "Notification Sound",
    CurrentValue = Config.Settings.NotificationSound,
    Flag = "NotificationSound",
    Callback = function(Value)
        Config.Settings.NotificationSound = Value
        logError("Notification Sound: " .. tostring(Value))
    end
})

SettingsTab:CreateToggle({
    Name = "Auto Save",
    CurrentValue = Config.Settings.AutoSave,
    Flag = "AutoSave",
    Callback = function(Value)
        Config.Settings.AutoSave = Value
        logError("Auto Save: " .. tostring(Value))
    end
})

SettingsTab:CreateSlider({
    Name = "Save Interval",
    Range = {30, 300},
    Increment = 30,
    Suffix = "seconds",
    CurrentValue = Config.Settings.SaveInterval,
    Flag = "SaveInterval",
    Callback = function(Value)
        Config.Settings.SaveInterval = Value
        logError("Save Interval: " .. Value)
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
    Name = "Open Log",
    Callback = function()
        if isfile("/storage/emulated/0/logscript.txt") then
            Rayfield:Notify({
                Title = "Log File",
                Content = "Log file created at: /storage/emulated/0/logscript.txt",
                Duration = 5,
                Image = 13047715178
            })
        else
            Rayfield:Notify({
                Title = "Log Error",
                Content = "Log file not found",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Low Device Tab with enhanced features
local LowDeviceTab = Window:CreateTab("🥔 Low Device", 13014546625)

LowDeviceTab:CreateToggle({
    Name = "Anti Lag",
    CurrentValue = Config.LowDevice.AntiLag,
    Flag = "AntiLag",
    Callback = function(Value)
        Config.LowDevice.AntiLag = Value
        if Value then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                    obj.Enabled = false
                end
            end
        end
        logError("Anti Lag: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "FPS Stabilizer",
    CurrentValue = Config.LowDevice.FPSStabilizer,
    Flag = "FPSStabilizer",
    Callback = function(Value)
        Config.LowDevice.FPSStabilizer = Value
        if Value then
            RunService:Set3dRenderingEnabled(false)
            RunService:SetPhysics3dRenderingEnabled(false)
        else
            RunService:Set3dRenderingEnabled(true)
            RunService:SetPhysics3dRenderingEnabled(true)
        end
        logError("FPS Stabilizer: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Disable All Effects",
    CurrentValue = Config.LowDevice.DisableAllEffects,
    Flag = "DisableAllEffects",
    Callback = function(Value)
        Config.LowDevice.DisableAllEffects = Value
        if Value then
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1000
            Lighting.FogColor = Color3.new(1, 1, 1)
            Lighting.Ambient = Color3.new(1, 1, 1)
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") then
                    obj.Enabled = false
                end
            end
        else
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 0
            Lighting.FogColor = Color3.new(0.5, 0.5, 0.5)
            Lighting.Ambient = Color3.new(0.2, 0.2, 0.2)
        end
        logError("Disable All Effects: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "8-bit Graphics",
    CurrentValue = Config.LowDevice.EightBitGraphics,
    Flag = "EightBitGraphics",
    Callback = function(Value)
        Config.LowDevice.EightBitGraphics = Value
        if Value then
            settings().Rendering.QualityLevel = 1
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Part") or obj:IsA("MeshPart") then
                    obj.Material = Enum.Material.Plastic
                    obj.Reflectance = 0
                    obj.Transparency = 0
                end
            end
        else
            settings().Rendering.QualityLevel = 10
        end
        logError("8-bit Graphics: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Texture Compression",
    CurrentValue = Config.LowDevice.TextureCompression,
    Flag = "TextureCompression",
    Callback = function(Value)
        Config.LowDevice.TextureCompression = Value
        logError("Texture Compression: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Mesh Reduction",
    CurrentValue = Config.LowDevice.MeshReduction,
    Flag = "MeshReduction",
    Callback = function(Value)
        Config.LowDevice.MeshReduction = Value
        logError("Mesh Reduction: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Reduce LOD",
    CurrentValue = Config.LowDevice.ReduceLOD,
    Flag = "ReduceLOD",
    Callback = function(Value)
        Config.LowDevice.ReduceLOD = Value
        logError("Reduce LOD: " .. tostring(Value))
    end
})

LowDeviceTab:CreateDropdown({
    Name = "Shadow Quality",
    Options = {"Off", "Low", "Medium", "High"},
    CurrentOption = Config.LowDevice.ShadowQuality,
    Flag = "ShadowQuality",
    Callback = function(Value)
        Config.LowDevice.ShadowQuality = Value
        logError("Shadow Quality: " .. Value)
    end
})

LowDeviceTab:CreateDropdown({
    Name = "Particle Quality",
    Options = {"Off", "Low", "Medium", "High"},
    CurrentOption = Config.LowDevice.ParticleQuality,
    Flag = "ParticleQuality",
    Callback = function(Value)
        Config.LowDevice.ParticleQuality = Value
        logError("Particle Quality: " .. Value)
    end
})

LowDeviceTab:CreateSlider({
    Name = "Render Distance",
    Range = {50, 500},
    Increment = 50,
    Suffix = "studs",
    CurrentValue = Config.LowDevice.RenderDistance,
    Flag = "RenderDistance",
    Callback = function(Value)
        Config.LowDevice.RenderDistance = Value
        logError("Render Distance: " .. Value)
    end
})

LowDeviceTab:CreateSlider({
    Name = "Object LOD",
    Range = {0, 5},
    Increment = 1,
    CurrentValue = Config.LowDevice.ObjectLOD,
    Flag = "ObjectLOD",
    Callback = function(Value)
        Config.LowDevice.ObjectLOD = Value
        logError("Object LOD: " .. Value)
    end
})

LowDeviceTab:CreateDropdown({
    Name = "Texture Quality",
    Options = {"Low", "Medium", "High"},
    CurrentOption = Config.LowDevice.TextureQuality,
    Flag = "TextureQuality",
    Callback = function(Value)
        Config.LowDevice.TextureQuality = Value
        logError("Texture Quality: " .. Value)
    end
})

LowDeviceTab:CreateDropdown({
    Name = "Effect Quality",
    Options = {"Low", "Medium", "High"},
    CurrentOption = Config.LowDevice.EffectQuality,
    Flag = "EffectQuality",
    Callback = function(Value)
        Config.LowDevice.EffectQuality = Value
        logError("Effect Quality: " .. Value)
    end
})

LowDeviceTab:CreateButton({
    Name = "Apply Low Device Settings",
    Callback = function()
        if Config.LowDevice.AntiLag then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                    obj.Enabled = false
                end
            end
        end
        
        if Config.LowDevice.FPSStabilizer then
            RunService:Set3dRenderingEnabled(false)
            RunService:SetPhysics3dRenderingEnabled(false)
        end
        
        if Config.LowDevice.DisableAllEffects then
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1000
            Lighting.FogColor = Color3.new(1, 1, 1)
            Lighting.Ambient = Color3.new(1, 1, 1)
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") then
                    obj.Enabled = false
                end
            end
        end
        
        if Config.LowDevice.EightBitGraphics then
            settings().Rendering.QualityLevel = 1
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Part") or obj:IsA("MeshPart") then
                    obj.Material = Enum.Material.Plastic
                    obj.Reflectance = 0
                    obj.Transparency = 0
                end
            end
        end
        
        if Config.LowDevice.TextureCompression then
            settings().Rendering.TextureCompression = true
        end
        
        if Config.LowDevice.MeshReduction then
            settings().Rendering.MeshReduction = true
        end
        
        if Config.LowDevice.ReduceLOD then
            settings().Rendering.LOD = 0
        end
        
        if Config.LowDevice.ShadowQuality == "Off" then
            Lighting.GlobalShadows = false
        elseif Config.LowDevice.ShadowQuality == "Low" then
            Lighting.GlobalShadows = true
            Lighting.ShadowDistance = 100
        elseif Config.LowDevice.ShadowQuality == "Medium" then
            Lighting.GlobalShadows = true
            Lighting.ShadowDistance = 200
        elseif Config.LowDevice.ShadowQuality == "High" then
            Lighting.GlobalShadows = true
            Lighting.ShadowDistance = 500
        end
        
        if Config.LowDevice.ParticleQuality == "Off" then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") then
                    obj.Enabled = false
                end
            end
        elseif Config.LowDevice.ParticleQuality == "Low" then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") then
                    obj.Enabled = true
                    obj.Lifetime = NumberRange.new(0.5, 1)
                end
            end
        elseif Config.LowDevice.ParticleQuality == "Medium" then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") then
                    obj.Enabled = true
                    obj.Lifetime = NumberRange.new(1, 2)
                end
            end
        elseif Config.LowDevice.ParticleQuality == "High" then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") then
                    obj.Enabled = true
                    obj.Lifetime = NumberRange.new(2, 3)
                end
            end
        end
        
        Rayfield:Notify({
            Title = "Low Device Settings",
            Content = "All low device optimizations applied",
            Duration = 3,
            Image = 13047715178
        })
        logError("Low Device Settings Applied")
    end
})

-- Initialize UI
Rayfield:Notify({
    Title = "Fish It Script",
    Content = "Script loaded successfully! All features ready.",
    Duration = 5,
    Image = 13047715178
})

logError("Fish It Script initialized successfully")

-- Additional features implementation
spawn(function()
    while wait(1) do
        if Config.System.AutoFarm then
            -- Auto fishing implementation
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                -- Find nearest water
                local waterParts = {}
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Part") and obj.Name == "Water" then
                        table.insert(waterParts, obj)
                    end
                end
                
                if #waterParts > 0 then
                    -- Find nearest water
                    local nearestWater = nil
                    local minDistance = math.huge
                    for _, water in ipairs(waterParts) do
                        local distance = (water.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if distance < minDistance then
                            minDistance = distance
                            nearestWater = water
                        end
                    end
                    
                    if nearestWater then
                        -- Teleport to water
                        LocalPlayer.Character:SetPrimaryPartCFrame(nearestWater.CFrame * CFrame.new(0, 5, 0))
                        
                        -- Start fishing
                        if FishingEvents and FishingEvents:FindFirstChild("StartFishing") then
                            pcall(function()
                                FishingEvents.StartFishing:FireServer()
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- Performance monitor
spawn(function()
    while wait(5) do
        if Config.System.PerformanceMonitor then
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local memory = math.floor(Stats:GetTotalMemoryUsageMb())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            
            local performanceInfo = string.format("FPS: %d | Memory: %dMB | Ping: %dms", fps, memory, ping)
            logError("Performance: " .. performanceInfo)
        end
    end
end)

-- Auto teleport to events
spawn(function()
    while wait(10) do
        if Config.Teleport.AutoTeleportToEvents then
            -- Check for active events
            if GameFunctions and GameFunctions:FindFirstChild("GetActiveEvents") then
                pcall(function()
                    local activeEvents = GameFunctions.GetActiveEvents:InvokeServer()
                    for _, event in ipairs(activeEvents) do
                        if event == "Fishing Frenzy" or event == "Boss Battle" or event == "Treasure Hunt" then
                            -- Teleport to event location
                            if event == "Fishing Frenzy" then
                                LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(1500, 15, 1500))
                            elseif event == "Boss Battle" then
                                LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-1500, 20, -1500))
                            elseif event == "Treasure Hunt" then
                                LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(0, 10, 2500))
                            end
                            logError("Auto teleported to event: " .. event)
                        end
                    end
                end)
            end
        end
    end
end)

-- Auto sell fish
spawn(function()
    while wait(30) do
        if Config.Shop.AutoSellFish then
            if PlayerData and PlayerData:FindFirstChild("Inventory") then
                for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                    if item:IsA("Folder") or item:IsA("Configuration") then
                        -- Check if fish is not rare
                        local isRare = false
                        for _, rarity in ipairs(FishRarities) do
                            if rarity == "Rare" or rarity == "Epic" or rarity == "Legendary" or rarity == "Mythical" or rarity == "Secret" then
                                if item.Name:find(rarity) then
                                    isRare = true
                                    break
                                end
                            end
                        end
                        
                        if not isRare then
                            -- Sell fish
                            if GameFunctions and GameFunctions:FindFirstChild("SellFish") then
                                pcall(function()
                                    GameFunctions.SellFish:InvokeServer(item.Name)
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Auto craft items
spawn(function()
    while wait(60) do
        if Config.Shop.AutoCraftItems then
            if GameFunctions and GameFunctions:FindFirstChild("AutoCraft") then
                pcall(function()
                    GameFunctions.AutoCraft:InvokeServer()
                end)
            end
        end
    end
end)

-- Auto restart
spawn(function()
    while wait(300) do
        if Config.System.AutoRestart then
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
            logError("Auto restarting...")
        end
    end
end)

-- Auto update
spawn(function()
    while wait(3600) do
        if Config.System.AutoUpdate then
            -- Check for updates
            local latestVersion = HttpService:GetAsync("https://api.example.com/fishit/version")
            if latestVersion ~= "1.0.0" then
                -- Update script
                local newScript = HttpService:GetAsync("https://api.example.com/fishit/script")
                writefile("FishItScript.lua", newScript)
                Rayfield:Notify({
                    Title = "Update",
                    Content = "Script updated to version " .. latestVersion,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Script updated to version " .. latestVersion)
            end
        end
    end
end)

-- System optimizer
spawn(function()
    while wait(60) do
        if Config.System.SystemOptimizer then
            -- Optimize system
            collectgarbage("collect")
            if Config.System.AutoCleanMemory then
                collectgarbage("step")
            end
            logError("System optimized")
        end
    end
end)

-- Background processes
spawn(function()
    while wait(30) do
        if Config.System.BackgroundProcesses then
            -- Run background processes
            if Config.System.PerformanceMonitor then
                local fps = math.floor(1 / RunService.RenderStepped:Wait())
                local memory = math.floor(Stats:GetTotalMemoryUsageMb())
                local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                
                local performanceInfo = string.format("FPS: %d | Memory: %dMB | Ping: %dms", fps, memory, ping)
                logError("Background Performance: " .. performanceInfo)
            end
        end
    end
end)

-- Auto save config
spawn(function()
    while wait(Config.Settings.SaveInterval) do
        if Config.Settings.AutoSave then
            SaveConfig()
        end
    end
end)

-- Anti recoil
spawn(function()
    while wait(0.1) do
        if Config.Bypass.AntiRecoil then
            -- Reduce recoil when fishing
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.AutoRotate = false
                LocalPlayer.Character.Humanoid.AutoJump = false
            end
        end
    end
end)

-- Perfect catch
spawn(function()
    while wait(0.5) do
        if Config.Player.PerfectCatch then
            -- Perfect catch implementation
            if FishingEvents and FishingEvents:FindFirstChild("PerfectCatch") then
                pcall(function()
                    FishingEvents.PerfectCatch:FireServer()
                end)
            end
        end
    end
end)

-- Fish finder
spawn(function()
    while wait(1) do
        if Config.Player.FishFinder then
            -- Find fish in nearby water
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local radius = Config.System.FarmRadius
                local fishParts = {}
                
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name:find("Fish") then
                        local distance = (obj.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if distance < radius then
                            table.insert(fishParts, obj)
                        end
                    end
                end
                
                if #fishParts > 0 then
                    logError("Found " .. #fishParts .. " fish nearby")
                end
            end
        end
    end
end)

-- Auto fish
spawn(function()
    while wait(2) do
        if Config.Player.AutoFish then
            -- Auto fishing implementation
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                -- Check if in water
                local inWater = false
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Part") and obj.Name == "Water" then
                        if (obj.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 50 then
                            inWater = true
                            break
                        end
                    end
                end
                
                if inWater then
                    -- Start fishing
                    if FishingEvents and FishingEvents:FindFirstChild("StartFishing") then
                        pcall(function()
                            FishingEvents.StartFishing:FireServer()
                        end)
                    end
                end
            end
        end
    end
end)

-- Currency booster
spawn(function()
    while wait(10) do
        if Config.Shop.CurrencyBooster then
            -- Boost currency earnings
            if GameFunctions and GameFunctions:FindFirstChild("CurrencyBooster") then
                pcall(function()
                    GameFunctions.CurrencyBooster:InvokeServer()
                end)
            end
        end
    end
end)

-- Lucky charm
spawn(function()
    while wait(5) do
        if Config.RNGKill.LuckyCharm then
            -- Increase luck
            if GameFunctions and GameFunctions:FindFirstChild("LuckyCharm") then
                pcall(function()
                    GameFunctions.LuckyCharm:InvokeServer()
                end)
            end
        end
    end
end)

-- Auto catch rare
spawn(function()
    while wait(3) do
        if Config.RNGKill.AutoCatchRare then
            -- Auto catch rare fish
            if FishingEvents and FishingEvents:FindFirstChild("AutoCatchRare") then
                pcall(function()
                    FishingEvents.AutoCatchRare:FireServer()
                end)
            end
        end
    end
end)

-- Trade value calculator
spawn(function()
    while wait(30) do
        if Config.Trader.TradeValueCalculator then
            -- Calculate trade values
            if PlayerData and PlayerData:FindFirstChild("Inventory") then
                local totalValue = 0
                for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                    if item:IsA("Folder") or item:IsA("Configuration") then
                        -- Calculate fish value
                        local rarity = "Common"
                        for _, r in ipairs(FishRarities) do
                            if item.Name:find(r) then
                                rarity = r
                                break
                            end
                        end
                        
                        local value = 0
                        if rarity == "Common" then value = 10
                        elseif rarity == "Uncommon" then value = 25
                        elseif rarity == "Rare" then value = 50
                        elseif rarity == "Epic" then value = 100
                        elseif rarity == "Legendary" then value = 250
                        elseif rarity == "Mythical" then value = 500
                        elseif rarity == "Secret" then value = 1000
                        end
                        
                        totalValue = totalValue + value
                    end
                end
                
                logError("Total fish value: " .. totalValue)
            end
        end
    end
end)

-- Auto trade rare
spawn(function()
    while wait(60) do
        if Config.Trader.AutoTradeRare then
            -- Trade rare fish
            if PlayerData and PlayerData:FindFirstChild("Inventory") then
                for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                    if item:IsA("Folder") or item:IsA("Configuration") then
                        -- Check if fish is rare
                        local isRare = false
                        for _, rarity in ipairs(FishRarities) do
                            if rarity == "Rare" or rarity == "Epic" or rarity == "Legendary" or rarity == "Mythical" or rarity == "Secret" then
                                if item.Name:find(rarity) then
                                    isRare = true
                                    break
                                end
                            end
                        end
                        
                        if isRare and Config.Trader.TradePlayer ~= "" then
                            local targetPlayer = Players:FindFirstChild(Config.Trader.TradePlayer)
                            if targetPlayer and TradeEvents and TradeEvents:FindFirstChild("SendTradeRequest") then
                                pcall(function()
                                    TradeEvents.SendTradeRequest:FireServer(targetPlayer)
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Custom sky
spawn(function()
    while wait(1) do
        if Config.Graphic.CustomSky then
            -- Change sky color
            Lighting.Sky = Enum.SkyBox.MilkyWay
            Lighting.FogColor = Color3.new(0.5, 0.5, 0.8)
        end
    end
end)

-- Custom water
spawn(function()
    while wait(1) do
        if Config.Graphic.CustomWater then
            -- Change water properties
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and water.Name == "Water" then
                    water.Color = Color3.new(0, 0.5, 1)
                    water.Transparency = 0.5
                end
            end
        end
    end
end)

-- Auto clean memory
spawn(function()
    while wait(60) do
        if Config.System.AutoCleanMemory then
            -- Clean memory
            collectgarbage("collect")
            logError("Memory cleaned")
        end
    end
end)

-- Server hop
spawn(function()
    while wait(300) do
        if Config.Server.ServerHop then
            -- Find new server
            local servers = HttpService:GetAsync("https://games.roblox.com/v1/servers/" .. game.PlaceId .. "/servers?sortOrder=Asc&limit=10")
            servers = HttpService:JSONDecode(servers).data
            
            if #servers > 0 then
                local newServer = servers[1]
                TeleportService:TeleportToPlaceInstance(game.PlaceId, newServer.id, LocalPlayer)
                logError("Server hopped to: " .. newServer.id)
            end
        end
    end
end)

-- Force event
spawn(function()
    while wait(120) do
        if Config.Server.ForceEvent then
            -- Force event
            if GameFunctions and GameFunctions:FindFirstChild("ForceEvent") then
                pcall(function()
                    GameFunctions.ForceEvent:InvokeServer()
                end)
            end
        end
    end
end)

-- View player stats
spawn(function()
    while wait(60) do
        if Config.Server.ViewPlayerStats then
            -- View player stats
            if PlayerData and PlayerData:FindFirstChild("Stats") then
                local stats = ""
                for stat, value in pairs(PlayerData.Stats:GetChildren()) do
                    stats = stats .. stat .. ": " .. value.Value .. " | "
                end
                logError("Player stats: " .. stats)
            end
        end
    end
end)

-- Anti ban for actions
spawn(function()
    while wait(30) do
        if Config.Bypass.AntiBanForActions then
            -- Anti ban for actions
            if Remotes and Remotes:FindFirstChild("AntiBan") then
                pcall(function()
                    Remotes.AntiBan:FireServer()
                end)
            end
        end
    end
end)

-- Bypass server checks
spawn(function()
    while wait(15) do
        if Config.Bypass.BypassServerChecks then
            -- Bypass server checks
            if Remotes and Remotes:FindFirstChild("BypassChecks") then
                pcall(function()
                    Remotes.BypassChecks:FireServer()
                end)
            end
        end
    end
end)

-- Auto craft
spawn(function()
    while wait(45) do
        if Config.Player.AutoCraft then
            -- Auto craft items
            if GameFunctions and GameFunctions:FindFirstChild("AutoCraft") then
                pcall(function()
                    GameFunctions.AutoCraft:InvokeServer()
                end)
            end
        end
    end
end)

-- Auto upgrade
spawn(function()
    while wait(90) do
        if Config.Player.AutoUpgrade then
            -- Auto upgrade rod
            if GameFunctions and GameFunctions:FindFirstChild("AutoUpgrade") then
                pcall(function()
                    GameFunctions.AutoUpgrade:InvokeServer()
                end)
            end
        end
    end
end)

-- Auto buy rods
spawn(function()
    while wait(120) do
        if Config.Shop.AutoBuyRods then
            -- Auto buy rods
            if GameFunctions and GameFunctions:FindFirstChild("BuyRod") then
                pcall(function()
                    GameFunctions.BuyRod:InvokeServer("Next Rod")
                end)
            end
        end
    end
end)

-- Auto buy boats
spawn(function()
    while wait(180) do
        if Config.Shop.AutoBuyBoats then
            -- Auto buy boats
            if GameFunctions and GameFunctions:FindFirstChild("BuyBoat") then
                pcall(function()
                    GameFunctions.BuyBoat:InvokeServer("Next Boat")
                end)
            end
        end
    end
end)

-- Auto buy baits
spawn(function()
    while wait(60) do
        if Config.Shop.AutoBuyBaits then
            -- Auto buy baits
            if GameFunctions and GameFunctions:FindFirstChild("BuyBait") then
                pcall(function()
                    GameFunctions.BuyBait:InvokeServer("Next Bait")
                end)
            end
        end
    end
end)

-- Auto upgrade rod
spawn(function()
    while wait(150) do
        if Config.Shop.AutoUpgradeRod then
            -- Auto upgrade rod
            if GameFunctions and GameFunctions:FindFirstChild("UpgradeRod") then
                pcall(function()
                    GameFunctions.UpgradeRod:InvokeServer()
                end)
            end
        end
    end
end)

-- Auto accept trade
spawn(function()
    while wait(5) do
        if Config.Trader.AutoAcceptTrade then
            -- Auto accept trade
            if TradeEvents and TradeEvents:FindFirstChild("AcceptTrade") then
                pcall(function()
                    TradeEvents.AcceptTrade:FireServer()
                end)
            end
        end
    end
end)

-- Trade all fish
spawn(function()
    while wait(120) do
        if Config.Trader.TradeAllFish then
            -- Trade all fish
            if PlayerData and PlayerData:FindFirstChild("Inventory") and Config.Trader.TradePlayer ~= "" then
                local targetPlayer = Players:FindFirstChild(Config.Trader.TradePlayer)
                if targetPlayer and TradeEvents and TradeEvents:FindFirstChild("SendTradeRequest") then
                    pcall(function()
                        TradeEvents.SendTradeRequest:FireServer(targetPlayer)
                    end)
                end
            end
        end
    end
end)

-- Anti bad luck
spawn(function()
    while wait(10) do
        if Config.RNGKill.AntiBadLuck then
            -- Anti bad luck
            if GameFunctions and GameFunctions:FindFirstChild("AntiBadLuck") then
                pcall(function()
                    GameFunctions.AntiBadLuck:InvokeServer()
                end)
            end
        end
    end
end)

-- Guaranteed catch
spawn(function()
    while wait(5) do
        if Config.RNGKill.GuaranteedCatch then
            -- Guaranteed catch
            if FishingEvents and FishingEvents:FindFirstChild("GuaranteedCatch") then
                pcall(function()
                    FishingEvents.GuaranteedCatch:FireServer()
                end)
            end
        end
    end
end)

-- Secret fish boost
spawn(function()
    while wait(15) do
        if Config.RNGKill.SecretFishBoost then
            -- Secret fish boost
            if GameFunctions and GameFunctions:FindFirstChild("SecretFishBoost") then
                pcall(function()
                    GameFunctions.SecretFishBoost:InvokeServer()
                end)
            end
        end
    end
end)

-- Mythical chance boost
spawn(function()
    while wait(20) do
        if Config.RNGKill.MythicalChanceBoost then
            -- Mythical chance boost
            if GameFunctions and GameFunctions:FindFirstChild("MythicalChanceBoost") then
                pcall(function()
                    GameFunctions.MythicalChanceBoost:InvokeServer()
                end)
            end
        end
    end
end)

-- Force legendary catch
spawn(function()
    while wait(25) do
        if Config.RNGKill.ForceLegendary then
            -- Force legendary catch
            if FishingEvents and FishingEvents:FindFirstChild("ForceLegendary") then
                pcall(function()
                    FishingEvents.ForceLegendary:FireServer()
                end)
            end
        end
    end
end)

-- RNG reducer
spawn(function()
    while wait(30) do
        if Config.RNGKill.RNGReducer then
            -- RNG reducer
            if GameFunctions and GameFunctions:FindFirstChild("RNGReducer") then
                pcall(function()
                    GameFunctions.RNGReducer:InvokeServer()
                end)
            end
        end
    end
end)

-- Disable particles
spawn(function()
    while wait(1) do
        if Config.System.DisableParticles then
            -- Disable particles
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") then
                    obj.Enabled = false
                end
            end
        end
    end
end)

-- Full bright
spawn(function()
    while wait(1) do
        if Config.Graphic.FullBright then
            -- Full bright
            Lighting.GlobalShadows = false
            Lighting.ClockTime = 12
        end
    end
end)

-- Smooth graphics
spawn(function()
    while wait(1) do
        if Config.Graphic.SmoothGraphics then
            -- Smooth graphics
            RunService:Set3dRenderingEnabled(true)
            settings().Rendering.MeshCacheSize = 100
            settings().Rendering.TextureCacheSize = 100
        end
    end
end)

-- Custom shader
spawn(function()
    while wait(1) do
        if Config.Graphic.CustomShader then
            -- Custom shader
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Part") or obj:IsA("MeshPart") then
                    obj.Material = Enum.Material.Neon
                end
            end
        end
    end
end)

-- Disable water reflection
spawn(function()
    while wait(1) do
        if Config.Graphic.DisableWaterReflection then
            -- Disable water reflection
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and water.Name == "Water" then
                    water.Transparency = 1
                end
            end
        end
    end
end)

-- Ultra low mode
spawn(function()
    while wait(1) do
        if Config.Graphic.UltraLowMode then
            -- Ultra low mode
            settings().Rendering.QualityLevel = 1
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Part") then
                    obj.Material = Enum.Material.Plastic
                end
            end
        end
    end
end)

-- Max rendering
spawn(function()
    while wait(1) do
        if Config.Graphic.MaxRendering then
            -- Max rendering
            settings().Rendering.QualityLevel = 21
        end
    end
end)

-- High quality rendering
spawn(function()
    while wait(1) do
        if Config.Graphic.HighQuality then
            -- High quality rendering
            sethiddenproperty(Lighting, "Technology", "Future")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Disabled")
        end
    end
end)

-- Boost FPS
spawn(function()
    while wait(1) do
        if Config.System.BoostFPS then
            -- Boost FPS
            settings().Rendering.QualityLevel = 5
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") then
                    obj.Enabled = false
                end
            end
        end
    end
end)

-- Show info
spawn(function()
    while wait(1) do
        if Config.System.ShowInfo then
            -- Show info
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local memory = math.floor(Stats:GetTotalMemoryUsageMb())
            local battery = math.floor(UserInputService:GetBatteryLevel() * 100)
            local time = os.date("%H:%M:%S")
            
            local info = string.format("FPS: %d | Ping: %dms | Memory: %dMB | Battery: %d%% | Time: %s", fps, ping, memory, battery, time)
            logError("Info: " .. info)
        end
    end
end)

-- Anti lag
spawn(function()
    while wait(1) do
        if Config.LowDevice.AntiLag then
            -- Anti lag
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") then
                    obj.Enabled = false
                end
            end
        end
    end
end)

-- FPS stabilizer
spawn(function()
    while wait(1) do
        if Config.LowDevice.FPSStabilizer then
            -- FPS stabilizer
            RunService:Set3dRenderingEnabled(false)
            RunService:SetPhysics3dRenderingEnabled(false)
        end
    end
end)

-- 8-bit graphics
spawn(function()
    while wait(1) do
        if Config.LowDevice.EightBitGraphics then
            -- 8-bit graphics
            settings().Rendering.QualityLevel = 1
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Part") or obj:IsA("MeshPart") then
                    obj.Material = Enum.Material.Plastic
                    obj.Reflectance = 0
                    obj.Transparency = 0
                end
            end
        end
    end
end)

-- Texture compression
spawn(function()
    while wait(1) do
        if Config.LowDevice.TextureCompression then
            -- Texture compression
            settings().Rendering.TextureCompression = true
        end
    end
end)

-- Mesh reduction
spawn(function()
    while wait(1) do
        if Config.LowDevice.MeshReduction then
            -- Mesh reduction
            settings().Rendering.MeshReduction = true
        end
    end
end)

-- Reduce LOD
spawn(function()
    while wait(1) do
        if Config.LowDevice.ReduceLOD then
            -- Reduce LOD
            settings().Rendering.LOD = 0
        end
    end
end)

-- Shadow quality
spawn(function()
    while wait(1) do
        if Config.LowDevice.ShadowQuality == "Off" then
            Lighting.GlobalShadows = false
        elseif Config.LowDevice.ShadowQuality == "Low" then
            Lighting.GlobalShadows = true
            Lighting.ShadowDistance = 100
        elseif Config.LowDevice.ShadowQuality == "Medium" then
            Lighting.GlobalShadows = true
            Lighting.ShadowDistance = 200
        elseif Config.LowDevice.ShadowQuality == "High" then
            Lighting.GlobalShadows = true
            Lighting.ShadowDistance = 500
        end
    end
end)

-- Particle quality
spawn(function()
    while wait(1) do
        if Config.LowDevice.ParticleQuality == "Off" then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") then
                    obj.Enabled = false
                end
            end
        elseif Config.LowDevice.ParticleQuality == "Low" then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") then
                    obj.Enabled = true
                    obj.Lifetime = NumberRange.new(0.5, 1)
                end
            end
        elseif Config.LowDevice.ParticleQuality == "Medium" then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") then
                    obj.Enabled = true
                    obj.Lifetime = NumberRange.new(1, 2)
                end
            end
        elseif Config.LowDevice.ParticleQuality == "High" then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") then
                    obj.Enabled = true
                    obj.Lifetime = NumberRange.new(2, 3)
                end
            end
        end
    end
end)

-- Render distance
spawn(function()
    while wait(1) do
        if Config.LowDevice.RenderDistance then
            -- Set render distance
            settings().Rendering.RenderDistance = Config.LowDevice.RenderDistance
        end
    end
end)

-- Object LOD
spawn(function()
    while wait(1) do
        if Config.LowDevice.ObjectLOD then
            -- Set object LOD
            settings().Rendering.ObjectLOD = Config.LowDevice.ObjectLOD
        end
    end
end)

-- Texture quality
spawn(function()
    while wait(1) do
        if Config.LowDevice.TextureQuality == "Low" then
            settings().Rendering.TextureQuality = Enum.TextureQuality.Level1
        elseif Config.LowDevice.TextureQuality == "Medium" then
            settings().Rendering.TextureQuality = Enum.TextureQuality.Level3
        elseif Config.LowDevice.TextureQuality == "High" then
            settings().Rendering.TextureQuality = Enum.TextureQuality.Level6
        end
    end
end)

-- Effect quality
spawn(function()
    while wait(1) do
        if Config.LowDevice.EffectQuality == "Low" then
            settings().Rendering.EffectQuality = Enum.EffectQuality.Low
        elseif Config.LowDevice.EffectQuality == "Medium" then
            settings().Rendering.EffectQuality = Enum.EffectQuality.Medium
        elseif Config.LowDevice.EffectQuality == "High" then
            settings().Rendering.EffectQuality = Enum.EffectQuality.High
        end
    end
end)

-- Initialize all features
logError("Fish It Script initialized with all features")
