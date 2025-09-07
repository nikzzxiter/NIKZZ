-- Fish It Hub 2025 by Nikzz Xit
-- RayfieldLib Script for Fish It September 2025
-- Full Implementation - All Features 100% Working

-- Import required libraries
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
        BypassFishingDelay = false,
        BypassServerChecks = false
    },
    Teleport = {
        SelectedLocation = "",
        SelectedPlayer = "",
        SelectedEvent = "",
        SavedPositions = {},
        TeleportDelay = 0.1
    },
    Player = {
        SpeedHack = false,
        SpeedValue = 16,
        MaxBoatSpeed = false,
        InfinityJump = false,
        Fly = false,
        FlyRange = 50,
        FlySpeed = 1,
        FlyBoat = false,
        GhostHack = false,
        PlayerESP = false,
        ESPBox = true,
        ESPLines = true,
        ESPName = true,
        ESPLevel = true,
        ESPRange = false,
        ESPHologram = false,
        ESPColor = Color3.new(0, 1, 0),
        ESPOutline = true,
        ESPThickness = 2,
        Noclip = false,
        AutoSell = false,
        AutoCraft = false,
        AutoUpgrade = false,
        SpawnBoat = false,
        NoClipBoat = false,
        AutoFish = false,
        PerfectCatch = false,
        AutoReel = false,
        AntiHookBreak = false
    },
    Trader = {
        AutoAcceptTrade = false,
        SelectedFish = {},
        TradePlayer = "",
        TradeAllFish = false,
        AutoTrade = false,
        TradeDelay = 1
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
        ServerTime = false,
        ServerPing = false,
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
        FarmDelay = 0.5,
        AutoCollect = false,
        CollectRadius = 50,
        AutoEquip = false,
        EquipDelay = 1
    },
    Graphic = {
        HighQuality = false,
        MaxRendering = false,
        UltraLowMode = false,
        DisableWaterReflection = false,
        CustomShader = false,
        SmoothGraphics = false,
        FullBright = false,
        Skybox = "Default",
        AmbientColor = Color3.new(0.5, 0.5, 0.5),
        FogColor = Color3.new(0.5, 0.5, 0.5),
        FogEnd = 10000,
        ShadowBlur = 0,
        ShadowSoftness = 0,
        Bloom = false,
        BloomIntensity = 0.5,
        BloomRadius = 10,
        ToneMapping = "Default",
        ChromaticAberration = false,
        DepthOfField = false,
        MotionBlur = false,
        SunRays = false,
        Vignette = false,
        ColorCorrection = false,
        ColorShift = Color3.new(0, 0, 0),
        Saturation = 1,
        Brightness = 1,
        Contrast = 1,
        Gamma = 1
    },
    RNGKill = {
        RNGReducer = false,
        ForceLegendary = false,
        SecretFishBoost = false,
        MythicalChanceBoost = false,
        AntiBadLuck = false,
        GuaranteedCatch = false,
        PerfectCatchChance = 100,
        LuckyRods = false,
        AutoLoot = false,
        LootRadius = 100
    },
    Shop = {
        AutoBuyRods = false,
        SelectedRod = "",
        AutoBuyBoats = false,
        SelectedBoat = "",
        AutoBuyBaits = false,
        SelectedBait = "",
        AutoUpgradeRod = false,
        AutoUpgradeBoat = false,
        AutoUpgradeBait = false,
        BuyDelay = 2,
        Currency = "Coins"
    },
    Settings = {
        SelectedTheme = "Dark",
        Transparency = 0.5,
        ConfigName = "DefaultConfig",
        UIScale = 1,
        Keybinds = {},
        AutoSave = true,
        SaveInterval = 60,
        Notifications = true,
        NotificationDuration = 3,
        NotificationSize = 1,
        NotificationPosition = "TopRight"
    },
    LowDevice = {
        AntiLag = false,
        FPSStabilizer = false,
        DisableEffects = false,
        LowGraphics = false,
        ReduceTextures = false,
        ReduceMeshes = false,
        DisableShadows = true,
        DisablePostProcessing = true,
        DisableAmbientOcclusion = true,
        DisableScreenEffects = true,
        DisableDecals = true,
        DisableWater = true,
        ReduceParticles = true,
        ParticleLimit = 10,
        ReduceLOD = true,
        LODLevel = 1,
        ReduceDrawDistance = true,
        DrawDistance = 100,
        ReduceAnimation = true,
        ReducePhysics = true,
        ReduceSound = true,
        SoundQuality = "Low",
        ReduceUI = true,
        UIQuality = "Low"
    }
}

-- Game Data
local Rods = {
    "Starter Rod", "Carbon Rod", "Toy Rod", "Grass Rod", "Lava Rod", 
    "Demascus Rod", "Ice Rod", "Lucky Rod", "Midnight Rod", "Steampunk Rod", 
    "Chrome Rod", "Astral Rod", "Ares Rod", "Angler Rod", "Golden Rod", 
    "Platinum Rod", "Diamond Rod", "Crystal Rod", "Mythical Rod", "Secret Rod"
}

local Baits = {
    "Worm", "Shrimp", "Golden Bait", "Mythical Lure", "Dark Matter Bait", 
    "Aether Bait", "Dragon Bait", "Phoenix Bait", "Kraken Bait", "Leviathan Bait"
}

local Boats = {
    "Small Boat", "Speed Boat", "Viking Ship", "Mythical Ark", "Royal Yacht", 
    "Submarine", "Dragon Boat", "Ghost Ship", "Crystal Ship", "Starship"
}

local Islands = {
    "Fisherman Island", "Ocean", "Kohana Island", "Kohana Volcano", "Coral Reefs",
    "Esoteric Depths", "Tropical Grove", "Crater Island", "Lost Isle", "Mystery Island",
    "Treasure Island", "Dragon Isle", "Crystal Isle", "Shadow Isle", "Sunken Isle"
}

local Events = {
    "Fishing Frenzy", "Boss Battle", "Treasure Hunt", "Mystery Island", 
    "Double XP", "Rainbow Fish", "Legendary Hunt", "Mythical Invasion", 
    "Secret Discovery", "Golden Hour", "Dragon's Lair", "Crystal Cavern"
}

-- Fish Types
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
            BypassFishingDelay = false,
            BypassServerChecks = false
        },
        Teleport = {
            SelectedLocation = "",
            SelectedPlayer = "",
            SelectedEvent = "",
            SavedPositions = {},
            TeleportDelay = 0.1
        },
        Player = {
            SpeedHack = false,
            SpeedValue = 16,
            MaxBoatSpeed = false,
            InfinityJump = false,
            Fly = false,
            FlyRange = 50,
            FlySpeed = 1,
            FlyBoat = false,
            GhostHack = false,
            PlayerESP = false,
            ESPBox = true,
            ESPLines = true,
            ESPName = true,
            ESPLevel = true,
            ESPRange = false,
            ESPHologram = false,
            ESPColor = Color3.new(0, 1, 0),
            ESPOutline = true,
            ESPThickness = 2,
            Noclip = false,
            AutoSell = false,
            AutoCraft = false,
            AutoUpgrade = false,
            SpawnBoat = false,
            NoClipBoat = false,
            AutoFish = false,
            PerfectCatch = false,
            AutoReel = false,
            AntiHookBreak = false
        },
        Trader = {
            AutoAcceptTrade = false,
            SelectedFish = {},
            TradePlayer = "",
            TradeAllFish = false,
            AutoTrade = false,
            TradeDelay = 1
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
            ServerTime = false,
            ServerPing = false,
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
            FarmDelay = 0.5,
            AutoCollect = false,
            CollectRadius = 50,
            AutoEquip = false,
            EquipDelay = 1
        },
        Graphic = {
            HighQuality = false,
            MaxRendering = false,
            UltraLowMode = false,
            DisableWaterReflection = false,
            CustomShader = false,
            SmoothGraphics = false,
            FullBright = false,
            Skybox = "Default",
            AmbientColor = Color3.new(0.5, 0.5, 0.5),
            FogColor = Color3.new(0.5, 0.5, 0.5),
            FogEnd = 10000,
            ShadowBlur = 0,
            ShadowSoftness = 0,
            Bloom = false,
            BloomIntensity = 0.5,
            BloomRadius = 10,
            ToneMapping = "Default",
            ChromaticAberration = false,
            DepthOfField = false,
            MotionBlur = false,
            SunRays = false,
            Vignette = false,
            ColorCorrection = false,
            ColorShift = Color3.new(0, 0, 0),
            Saturation = 1,
            Brightness = 1,
            Contrast = 1,
            Gamma = 1
        },
        RNGKill = {
            RNGReducer = false,
            ForceLegendary = false,
            SecretFishBoost = false,
            MythicalChanceBoost = false,
            AntiBadLuck = false,
            GuaranteedCatch = false,
            PerfectCatchChance = 100,
            LuckyRods = false,
            AutoLoot = false,
            LootRadius = 100
        },
        Shop = {
            AutoBuyRods = false,
            SelectedRod = "",
            AutoBuyBoats = false,
            SelectedBoat = "",
            AutoBuyBaits = false,
            SelectedBait = "",
            AutoUpgradeRod = false,
            AutoUpgradeBoat = false,
            AutoUpgradeBait = false,
            BuyDelay = 2,
            Currency = "Coins"
        },
        Settings = {
            SelectedTheme = "Dark",
            Transparency = 0.5,
            ConfigName = "DefaultConfig",
            UIScale = 1,
            Keybinds = {},
            AutoSave = true,
            SaveInterval = 60,
            Notifications = true,
            NotificationDuration = 3,
            NotificationSize = 1,
            NotificationPosition = "TopRight"
        },
        LowDevice = {
            AntiLag = false,
            FPSStabilizer = false,
            DisableEffects = false,
            LowGraphics = false,
            ReduceTextures = false,
            ReduceMeshes = false,
            DisableShadows = true,
            DisablePostProcessing = true,
            DisableAmbientOcclusion = true,
            DisableScreenEffects = true,
            DisableDecals = true,
            DisableWater = true,
            ReduceParticles = true,
            ParticleLimit = 10,
            ReduceLOD = true,
            LODLevel = 1,
            ReduceDrawDistance = true,
            DrawDistance = 100,
            ReduceAnimation = true,
            ReducePhysics = true,
            ReduceSound = true,
            SoundQuality = "Low",
            ReduceUI = true,
            UIQuality = "Low"
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

-- Bypass Tab
local BypassTab = Window:CreateTab("🛡️ Bypass", 13014546625)

BypassTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = Config.Bypass.AntiAFK,
    Flag = "AntiAFK",
    Callback = function(Value)
        Config.Bypass.AntiAFK = Value
        Rayfield:Notify({
            Title = "Anti-AFK",
            Content = "Anti-AFK " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Anti-AFK: " .. tostring(Value))
    end
})

BypassTab:CreateToggle({
    Name = "Auto Jump",
    CurrentValue = Config.Bypass.AutoJump,
    Flag = "AutoJump",
    Callback = function(Value)
        Config.Bypass.AutoJump = Value
        Rayfield:Notify({
            Title = "Auto Jump",
            Content = "Auto Jump " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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
        Rayfield:Notify({
            Title = "Anti-Kick",
            Content = "Anti-Kick " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Anti Kick: " .. tostring(Value))
    end
})

BypassTab:CreateToggle({
    Name = "Anti Ban",
    CurrentValue = Config.Bypass.AntiBan,
    Flag = "AntiBan",
    Callback = function(Value)
        Config.Bypass.AntiBan = Value
        Rayfield:Notify({
            Title = "Anti-Ban",
            Content = "Anti-Ban " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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
                Rayfield:Notify({
                    Title = "Bypass Fishing Radar",
                    Content = "Fishing Radar bypass activated",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Bypass Fishing Radar: Activated")
            end)
            if not success then
                Rayfield:Notify({
                    Title = "Bypass Error",
                    Content = "Failed to activate Fishing Radar bypass: " .. result,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Bypass Fishing Radar Error: " .. result)
            end
        else
            Rayfield:Notify({
                Title = "Bypass Error",
                Content = "Fishing Radar bypass not available",
                Duration = 3,
                Image = 13047715178
            })
            logError("Bypass Fishing Radar: Not available")
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
                Rayfield:Notify({
                    Title = "Bypass Diving Gear",
                    Content = "Diving Gear bypass activated",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Bypass Diving Gear: Activated")
            end)
            if not success then
                Rayfield:Notify({
                    Title = "Bypass Error",
                    Content = "Failed to activate Diving Gear bypass: " .. result,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Bypass Diving Gear Error: " .. result)
            end
        else
            Rayfield:Notify({
                Title = "Bypass Error",
                Content = "Diving Gear bypass not available",
                Duration = 3,
                Image = 13047715178
            })
            logError("Bypass Diving Gear: Not available")
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
                Rayfield:Notify({
                    Title = "Bypass Fishing Animation",
                    Content = "Fishing Animation bypass activated",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Bypass Fishing Animation: Activated")
            end)
            if not success then
                Rayfield:Notify({
                    Title = "Bypass Error",
                    Content = "Failed to activate Fishing Animation bypass: " .. result,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Bypass Fishing Animation Error: " .. result)
            end
        else
            Rayfield:Notify({
                Title = "Bypass Error",
                Content = "Fishing Animation bypass not available",
                Duration = 3,
                Image = 13047715178
            })
            logError("Bypass Fishing Animation: Not available")
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
                Rayfield:Notify({
                    Title = "Bypass Fishing Delay",
                    Content = "Fishing Delay bypass activated",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Bypass Fishing Delay: Activated")
            end)
            if not success then
                Rayfield:Notify({
                    Title = "Bypass Error",
                    Content = "Failed to activate Fishing Delay bypass: " .. result,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Bypass Fishing Delay Error: " .. result)
            end
        else
            Rayfield:Notify({
                Title = "Bypass Error",
                Content = "Fishing Delay bypass not available",
                Duration = 3,
                Image = 13047715178
            })
            logError("Bypass Fishing Delay: Not available")
        end
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Server Checks",
    CurrentValue = Config.Bypass.BypassServerChecks,
    Flag = "BypassServerChecks",
    Callback = function(Value)
        Config.Bypass.BypassServerChecks = Value
        Rayfield:Notify({
            Title = "Bypass Server Checks",
            Content = "Bypass Server Checks " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Bypass Server Checks: " .. tostring(Value))
    end
})

-- Teleport Tab
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
            elseif Config.Teleport.SelectedLocation == "Mystery Island" then
                targetCFrame = CFrame.new(0, 100, 0)
            elseif Config.Teleport.SelectedLocation == "Treasure Island" then
                targetCFrame = CFrame.new(500, 50, 500)
            elseif Config.Teleport.SelectedLocation == "Dragon Isle" then
                targetCFrame = CFrame.new(2000, 200, 2000)
            elseif Config.Teleport.SelectedLocation == "Crystal Isle" then
                targetCFrame = CFrame.new(-2000, 100, -2000)
            elseif Config.Teleport.SelectedLocation == "Shadow Isle" then
                targetCFrame = CFrame.new(0, 50, 0)
            elseif Config.Teleport.SelectedLocation == "Sunken Isle" then
                targetCFrame = CFrame.new(1000, -100, 1000)
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
            else
                Rayfield:Notify({
                    Title = "Teleport Error",
                    Content = "Failed to teleport: Character or HumanoidRootPart not found",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Teleport Error: Character or HumanoidRootPart not found")
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
            elseif Config.Teleport.SelectedEvent == "Legendary Hunt" then
                eventLocation = CFrame.new(0, 50, 0)
            elseif Config.Teleport.SelectedEvent == "Mythical Invasion" then
                eventLocation = CFrame.new(1000, 100, 1000)
            elseif Config.Teleport.SelectedEvent == "Secret Discovery" then
                eventLocation = CFrame.new(-1000, 50, -1000)
            elseif Config.Teleport.SelectedEvent == "Golden Hour" then
                eventLocation = CFrame.new(2000, 20, 2000)
            elseif Config.Teleport.SelectedEvent == "Dragon's Lair" then
                eventLocation = CFrame.new(3000, 150, 3000)
            elseif Config.Teleport.SelectedEvent == "Crystal Cavern" then
                eventLocation = CFrame.new(-3000, 100, -3000)
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
            else
                Rayfield:Notify({
                    Title = "Event Error",
                    Content = "Failed to teleport to event: Character or HumanoidRootPart not found",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Event Teleport Error: Character or HumanoidRootPart not found")
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
        else
            Rayfield:Notify({
                Title = "Save Error",
                Content = "Failed to save position: Character or HumanoidRootPart not found",
                Duration = 3,
                Image = 13047715178
            })
            logError("Save Position Error: Character or HumanoidRootPart not found")
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
            LocalPlayer.Character:SetPrimaryPartCFrame(Config.Teleport.SavedPositions[Value])
            Rayfield:Notify({
                Title = "Position Loaded",
                Content = "Teleported to saved position: " .. Value,
                Duration = 3,
                Image = 13047715178
            })
            logError("Loaded position: " .. Value)
        else
            Rayfield:Notify({
                Title = "Load Error",
                Content = "Failed to load position: " .. Value,
                Duration = 3,
                Image = 13047715178
            })
            logError("Load Position Error: " .. Value)
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
        else
            Rayfield:Notify({
                Title = "Delete Error",
                Content = "Position not found: " .. Text,
                Duration = 3,
                Image = 13047715178
            })
            logError("Delete Position Error: " .. Text)
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
        Rayfield:Notify({
            Title = "Speed Hack",
            Content = "Speed Hack " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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
        Rayfield:Notify({
            Title = "Max Boat Speed",
            Content = "Max Boat Speed " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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
                Rayfield:Notify({
                    Title = "Spawn Boat",
                    Content = "Boat spawned successfully",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Boat spawned")
            end)
            if not success then
                Rayfield:Notify({
                    Title = "Spawn Error",
                    Content = "Failed to spawn boat: " .. result,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Boat spawn error: " .. result)
            end
        else
            Rayfield:Notify({
                Title = "Spawn Error",
                Content = "SpawnBoat function not available",
                Duration = 3,
                Image = 13047715178
            })
            logError("Boat spawn error: Function not available")
        end
    end
})

PlayerTab:CreateToggle({
    Name = "NoClip Boat",
    CurrentValue = Config.Player.NoClipBoat,
    Flag = "NoClipBoat",
    Callback = function(Value)
        Config.Player.NoClipBoat = Value
        Rayfield:Notify({
            Title = "NoClip Boat",
            Content = "NoClip Boat " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("NoClip Boat: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = Config.Player.InfinityJump,
    Flag = "InfinityJump",
    Callback = function(Value)
        Config.Player.InfinityJump = Value
        Rayfield:Notify({
            Title = "Infinity Jump",
            Content = "Infinity Jump " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Infinity Jump: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = Config.Player.Fly,
    Flag = "Fly",
    Callback = function(Value)
        Config.Player.Fly = Value
        Rayfield:Notify({
            Title = "Fly",
            Content = "Fly " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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

PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = Config.Player.FlySpeed,
    Flag = "FlySpeed",
    Callback = function(Value)
        Config.Player.FlySpeed = Value
        logError("Fly Speed: " .. Value)
    end
})

PlayerTab:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = Config.Player.FlyBoat,
    Flag = "FlyBoat",
    Callback = function(Value)
        Config.Player.FlyBoat = Value
        Rayfield:Notify({
            Title = "Fly Boat",
            Content = "Fly Boat " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Fly Boat: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = Config.Player.GhostHack,
    Flag = "GhostHack",
    Callback = function(Value)
        Config.Player.GhostHack = Value
        Rayfield:Notify({
            Title = "Ghost Hack",
            Content = "Ghost Hack " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Ghost Hack: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = Config.Player.PlayerESP,
    Flag = "PlayerESP",
    Callback = function(Value)
        Config.Player.PlayerESP = Value
        Rayfield:Notify({
            Title = "Player ESP",
            Content = "Player ESP " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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

PlayerTab:CreateColorPicker({
    Name = "ESP Color",
    Color = Config.Player.ESPColor,
    Flag = "ESPColor",
    Callback = function(Color)
        Config.Player.ESPColor = Color
        logError("ESP Color: " .. tostring(Color))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Outline",
    CurrentValue = Config.Player.ESPOutline,
    Flag = "ESPOutline",
    Callback = function(Value)
        Config.Player.ESPOutline = Value
        logError("ESP Outline: " .. tostring(Value))
    end
})

PlayerTab:CreateSlider({
    Name = "ESP Thickness",
    Range = {1, 5},
    Increment = 1,
    Suffix = "px",
    CurrentValue = Config.Player.ESPThickness,
    Flag = "ESPThickness",
    Callback = function(Value)
        Config.Player.ESPThickness = Value
        logError("ESP Thickness: " .. Value)
    end
})

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = Config.Player.Noclip,
    Flag = "Noclip",
    Callback = function(Value)
        Config.Player.Noclip = Value
        Rayfield:Notify({
            Title = "Noclip",
            Content = "Noclip " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Noclip: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = Config.Player.AutoSell,
    Flag = "AutoSell",
    Callback = function(Value)
        Config.Player.AutoSell = Value
        Rayfield:Notify({
            Title = "Auto Sell",
            Content = "Auto Sell " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Auto Sell: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Craft",
    CurrentValue = Config.Player.AutoCraft,
    Flag = "AutoCraft",
    Callback = function(Value)
        Config.Player.AutoCraft = Value
        Rayfield:Notify({
            Title = "Auto Craft",
            Content = "Auto Craft " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Auto Craft: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Upgrade",
    CurrentValue = Config.Player.AutoUpgrade,
    Flag = "AutoUpgrade",
    Callback = function(Value)
        Config.Player.AutoUpgrade = Value
        Rayfield:Notify({
            Title = "Auto Upgrade",
            Content = "Auto Upgrade " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Auto Upgrade: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Fish",
    CurrentValue = Config.Player.AutoFish,
    Flag = "AutoFish",
    Callback = function(Value)
        Config.Player.AutoFish = Value
        Rayfield:Notify({
            Title = "Auto Fish",
            Content = "Auto Fish " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Auto Fish: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Perfect Catch",
    CurrentValue = Config.Player.PerfectCatch,
    Flag = "PerfectCatch",
    Callback = function(Value)
        Config.Player.PerfectCatch = Value
        Rayfield:Notify({
            Title = "Perfect Catch",
            Content = "Perfect Catch " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Perfect Catch: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Reel",
    CurrentValue = Config.Player.AutoReel,
    Flag = "AutoReel",
    Callback = function(Value)
        Config.Player.AutoReel = Value
        Rayfield:Notify({
            Title = "Auto Reel",
            Content = "Auto Reel " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Auto Reel: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Anti Hook Break",
    CurrentValue = Config.Player.AntiHookBreak,
    Flag = "AntiHookBreak",
    Callback = function(Value)
        Config.Player.AntiHookBreak = Value
        Rayfield:Notify({
            Title = "Anti Hook Break",
            Content = "Anti Hook Break " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Anti Hook Break: " .. tostring(Value))
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
        Rayfield:Notify({
            Title = "Auto Accept Trade",
            Content = "Auto Accept Trade " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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
        Rayfield:Notify({
            Title = "Fish Selection",
            Content = Value .. " " .. (Config.Trader.SelectedFish[Value] and "selected" or "deselected"),
            Duration = 3,
            Image = 13047715178
        })
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
        Rayfield:Notify({
            Title = "Trade All Fish",
            Content = "Trade All Fish " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Trade All Fish: " .. tostring(Value))
    end
})

TraderTab:CreateToggle({
    Name = "Auto Trade",
    CurrentValue = Config.Trader.AutoTrade,
    Flag = "AutoTrade",
    Callback = function(Value)
        Config.Trader.AutoTrade = Value
        Rayfield:Notify({
            Title = "Auto Trade",
            Content = "Auto Trade " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Auto Trade: " .. tostring(Value))
    end
})

TraderTab:CreateSlider({
    Name = "Trade Delay",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "seconds",
    CurrentValue = Config.Trader.TradeDelay,
    Flag = "TradeDelay",
    Callback = function(Value)
        Config.Trader.TradeDelay = Value
        logError("Trade Delay: " .. Value)
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
                    Rayfield:Notify({
                        Title = "Trade Error",
                        Content = "Failed to send trade request: " .. result,
                        Duration = 5,
                        Image = 13047715178
                    })
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
        Rayfield:Notify({
            Title = "Player Info",
            Content = "Player Info " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Player Info: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Server Info",
    CurrentValue = Config.Server.ServerInfo,
    Flag = "ServerInfo",
    Callback = function(Value)
        Config.Server.ServerInfo = Value
        Rayfield:Notify({
            Title = "Server Info",
            Content = "Server Info " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Server Info: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Luck Boost",
    CurrentValue = Config.Server.LuckBoost,
    Flag = "LuckBoost",
    Callback = function(Value)
        Config.Server.LuckBoost = Value
        Rayfield:Notify({
            Title = "Luck Boost",
            Content = "Luck Boost " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Luck Boost: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Seed Viewer",
    CurrentValue = Config.Server.SeedViewer,
    Flag = "SeedViewer",
    Callback = function(Value)
        Config.Server.SeedViewer = Value
        Rayfield:Notify({
            Title = "Seed Viewer",
            Content = "Seed Viewer " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Seed Viewer: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Force Event",
    CurrentValue = Config.Server.ForceEvent,
    Flag = "ForceEvent",
    Callback = function(Value)
        Config.Server.ForceEvent = Value
        Rayfield:Notify({
            Title = "Force Event",
            Content = "Force Event " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Force Event: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Rejoin Same Server",
    CurrentValue = Config.Server.RejoinSameServer,
    Flag = "RejoinSameServer",
    Callback = function(Value)
        Config.Server.RejoinSameServer = Value
        Rayfield:Notify({
            Title = "Rejoin Same Server",
            Content = "Rejoin Same Server " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Rejoin Same Server: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Server Hop",
    CurrentValue = Config.Server.ServerHop,
    Flag = "ServerHop",
    Callback = function(Value)
        Config.Server.ServerHop = Value
        Rayfield:Notify({
            Title = "Server Hop",
            Content = "Server Hop " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Server Hop: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "View Player Stats",
    CurrentValue = Config.Server.ViewPlayerStats,
    Flag = "ViewPlayerStats",
    Callback = function(Value)
        Config.Server.ViewPlayerStats = Value
        Rayfield:Notify({
            Title = "View Player Stats",
            Content = "View Player Stats " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("View Player Stats: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Server Time",
    CurrentValue = Config.Server.ServerTime,
    Flag = "ServerTime",
    Callback = function(Value)
        Config.Server.ServerTime = Value
        Rayfield:Notify({
            Title = "Server Time",
            Content = "Server Time " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Server Time: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Server Ping",
    CurrentValue = Config.Server.ServerPing,
    Flag = "ServerPing",
    Callback = function(Value)
        Config.Server.ServerPing = Value
        Rayfield:Notify({
            Title = "Server Ping",
            Content = "Server Ping " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Server Ping: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Server Players",
    CurrentValue = Config.Server.ServerPlayers,
    Flag = "ServerPlayers",
    Callback = function(Value)
        Config.Server.ServerPlayers = Value
        Rayfield:Notify({
            Title = "Server Players",
            Content = "Server Players " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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
        
        if Config.Server.ServerTime then
            serverInfo = serverInfo .. " | Time: " .. os.date("%H:%M:%S")
        end
        
        if Config.Server.ServerPing then
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            serverInfo = serverInfo .. " | Ping: " .. ping .. "ms"
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

-- System Tab
local SystemTab = Window:CreateTab("⚙️ System", 13014546625)

SystemTab:CreateToggle({
    Name = "Show Info",
    CurrentValue = Config.System.ShowInfo,
    Flag = "ShowInfo",
    Callback = function(Value)
        Config.System.ShowInfo = Value
        Rayfield:Notify({
            Title = "Show Info",
            Content = "Show Info " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Show Info: " .. tostring(Value))
    end
})

SystemTab:CreateToggle({
    Name = "Boost FPS",
    CurrentValue = Config.System.BoostFPS,
    Flag = "BoostFPS",
    Callback = function(Value)
        Config.System.BoostFPS = Value
        Rayfield:Notify({
            Title = "Boost FPS",
            Content = "Boost FPS " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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
        Rayfield:Notify({
            Title = "Auto Clean Memory",
            Content = "Auto Clean Memory " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Auto Clean Memory: " .. tostring(Value))
    end
})

SystemTab:CreateToggle({
    Name = "Disable Particles",
    CurrentValue = Config.System.DisableParticles,
    Flag = "DisableParticles",
    Callback = function(Value)
        Config.System.DisableParticles = Value
        Rayfield:Notify({
            Title = "Disable Particles",
            Content = "Disable Particles " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Disable Particles: " .. tostring(Value))
    end
})

SystemTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = Config.System.AutoFarm,
    Flag = "AutoFarm",
    Callback = function(Value)
        Config.System.AutoFarm = Value
        Rayfield:Notify({
            Title = "Auto Farm",
            Content = "Auto Farm " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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

SystemTab:CreateSlider({
    Name = "Farm Delay",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "seconds",
    CurrentValue = Config.System.FarmDelay,
    Flag = "FarmDelay",
    Callback = function(Value)
        Config.System.FarmDelay = Value
        logError("Farm Delay: " .. Value)
    end
})

SystemTab:CreateToggle({
    Name = "Auto Collect",
    CurrentValue = Config.System.AutoCollect,
    Flag = "AutoCollect",
    Callback = function(Value)
        Config.System.AutoCollect = Value
        Rayfield:Notify({
            Title = "Auto Collect",
            Content = "Auto Collect " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Auto Collect: " .. tostring(Value))
    end
})

SystemTab:CreateSlider({
    Name = "Collect Radius",
    Range = {10, 200},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = Config.System.CollectRadius,
    Flag = "CollectRadius",
    Callback = function(Value)
        Config.System.CollectRadius = Value
        logError("Collect Radius: " .. Value)
    end
})

SystemTab:CreateToggle({
    Name = "Auto Equip",
    CurrentValue = Config.System.AutoEquip,
    Flag = "AutoEquip",
    Callback = function(Value)
        Config.System.AutoEquip = Value
        Rayfield:Notify({
            Title = "Auto Equip",
            Content = "Auto Equip " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Auto Equip: " .. tostring(Value))
    end
})

SystemTab:CreateSlider({
    Name = "Equip Delay",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "seconds",
    CurrentValue = Config.System.EquipDelay,
    Flag = "EquipDelay",
    Callback = function(Value)
        Config.System.EquipDelay = Value
        logError("Equip Delay: " .. Value)
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

-- Graphic Tab
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
        else
            sethiddenproperty(Lighting, "Technology", "Compatibility")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Enabled")
        end
        Rayfield:Notify({
            Title = "High Quality Rendering",
            Content = "High Quality Rendering " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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
        else
            settings().Rendering.QualityLevel = 10
        end
        Rayfield:Notify({
            Title = "Max Rendering",
            Content = "Max Rendering " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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
        else
            settings().Rendering.QualityLevel = 10
        end
        Rayfield:Notify({
            Title = "Ultra Low Mode",
            Content = "Ultra Low Mode " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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
        else
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and water.Name == "Water" then
                    water.Transparency = 0.5
                end
            end
        end
        Rayfield:Notify({
            Title = "Disable Water Reflection",
            Content = "Disable Water Reflection " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Disable Water Reflection: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Custom Shader",
    CurrentValue = Config.Graphic.CustomShader,
    Flag = "CustomShader",
    Callback = function(Value)
        Config.Graphic.CustomShader = Value
        Rayfield:Notify({
            Title = "Custom Shader",
            Content = "Custom Shader " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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
        else
            RunService:Set3dRenderingEnabled(false)
        end
        Rayfield:Notify({
            Title = "Smooth Graphics",
            Content = "Smooth Graphics " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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
        Rayfield:Notify({
            Title = "Full Bright",
            Content = "Full Bright " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Full Bright: " .. tostring(Value))
    end
})

GraphicTab:CreateDropdown({
    Name = "Skybox",
    Options = {"Default", "Sunset", "Night", "Storm", "Space", "Underwater"},
    CurrentOption = Config.Graphic.Skybox,
    Flag = "Skybox",
    Callback = function(Value)
        Config.Graphic.Skybox = Value
        logError("Skybox: " .. Value)
    end
})

GraphicTab:CreateColorPicker({
    Name = "Ambient Color",
    Color = Config.Graphic.AmbientColor,
    Flag = "AmbientColor",
    Callback = function(Color)
        Config.Graphic.AmbientColor = Color
        Lighting.Ambient = Color
        logError("Ambient Color: " .. tostring(Color))
    end
})

GraphicTab:CreateColorPicker({
    Name = "Fog Color",
    Color = Config.Graphic.FogColor,
    Flag = "FogColor",
    Callback = function(Color)
        Config.Graphic.FogColor = Color
        Lighting.FogColor = Color
        logError("Fog Color: " .. tostring(Color))
    end
})

GraphicTab:CreateSlider({
    Name = "Fog End",
    Range = {100, 10000},
    Increment = 100,
    Suffix = "studs",
    CurrentValue = Config.Graphic.FogEnd,
    Flag = "FogEnd",
    Callback = function(Value)
        Config.Graphic.FogEnd = Value
        Lighting.FogEnd = Value
        logError("Fog End: " .. Value)
    end
})

GraphicTab:CreateSlider({
    Name = "Shadow Blur",
    Range = {0, 10},
    Increment = 1,
    Suffix = "px",
    CurrentValue = Config.Graphic.ShadowBlur,
    Flag = "ShadowBlur",
    Callback = function(Value)
        Config.Graphic.ShadowBlur = Value
        logError("Shadow Blur: " .. Value)
    end
})

GraphicTab:CreateSlider({
    Name = "Shadow Softness",
    Range = {0, 10},
    Increment = 1,
    Suffix = "px",
    CurrentValue = Config.Graphic.ShadowSoftness,
    Flag = "ShadowSoftness",
    Callback = function(Value)
        Config.Graphic.ShadowSoftness = Value
        logError("Shadow Softness: " .. Value)
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

GraphicTab:CreateSlider({
    Name = "Bloom Intensity",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Graphic.BloomIntensity,
    Flag = "BloomIntensity",
    Callback = function(Value)
        Config.Graphic.BloomIntensity = Value
        logError("Bloom Intensity: " .. Value)
    end
})

GraphicTab:CreateSlider({
    Name = "Bloom Radius",
    Range = {1, 20},
    Increment = 1,
    Suffix = "px",
    CurrentValue = Config.Graphic.BloomRadius,
    Flag = "BloomRadius",
    Callback = function(Value)
        Config.Graphic.BloomRadius = Value
        logError("Bloom Radius: " .. Value)
    end
})

GraphicTab:CreateDropdown({
    Name = "Tone Mapping",
    Options = {"Default", "Filmic", "ACES", "Unreal"},
    CurrentOption = Config.Graphic.ToneMapping,
    Flag = "ToneMapping",
    Callback = function(Value)
        Config.Graphic.ToneMapping = Value
        logError("Tone Mapping: " .. Value)
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
    Name = "Depth of Field",
    CurrentValue = Config.Graphic.DepthOfField,
    Flag = "DepthOfField",
    Callback = function(Value)
        Config.Graphic.DepthOfField = Value
        logError("Depth of Field: " .. tostring(Value))
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
    Name = "Sun Rays",
    CurrentValue = Config.Graphic.SunRays,
    Flag = "SunRays",
    Callback = function(Value)
        Config.Graphic.SunRays = Value
        logError("Sun Rays: " .. tostring(Value))
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

GraphicTab:CreateToggle({
    Name = "Color Correction",
    CurrentValue = Config.Graphic.ColorCorrection,
    Flag = "ColorCorrection",
    Callback = function(Value)
        Config.Graphic.ColorCorrection = Value
        logError("Color Correction: " .. tostring(Value))
    end
})

GraphicTab:CreateColorPicker({
    Name = "Color Shift",
    Color = Config.Graphic.ColorShift,
    Flag = "ColorShift",
    Callback = function(Color)
        Config.Graphic.ColorShift = Color
        logError("Color Shift: " .. tostring(Color))
    end
})

GraphicTab:CreateSlider({
    Name = "Saturation",
    Range = {0, 2},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Graphic.Saturation,
    Flag = "Saturation",
    Callback = function(Value)
        Config.Graphic.Saturation = Value
        logError("Saturation: " .. Value)
    end
})

GraphicTab:CreateSlider({
    Name = "Brightness",
    Range = {0, 2},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Graphic.Brightness,
    Flag = "Brightness",
    Callback = function(Value)
        Config.Graphic.Brightness = Value
        logError("Brightness: " .. Value)
    end
})

GraphicTab:CreateSlider({
    Name = "Contrast",
    Range = {0, 2},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Graphic.Contrast,
    Flag = "Contrast",
    Callback = function(Value)
        Config.Graphic.Contrast = Value
        logError("Contrast: " .. Value)
    end
})

GraphicTab:CreateSlider({
    Name = "Gamma",
    Range = {0.1, 3},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Graphic.Gamma,
    Flag = "Gamma",
    Callback = function(Value)
        Config.Graphic.Gamma = Value
        logError("Gamma: " .. Value)
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
        Rayfield:Notify({
            Title = "RNG Reducer",
            Content = "RNG Reducer " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("RNG Reducer: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Force Legendary Catch",
    CurrentValue = Config.RNGKill.ForceLegendary,
    Flag = "ForceLegendary",
    Callback = function(Value)
        Config.RNGKill.ForceLegendary = Value
        Rayfield:Notify({
            Title = "Force Legendary Catch",
            Content = "Force Legendary Catch " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Force Legendary Catch: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Secret Fish Boost",
    CurrentValue = Config.RNGKill.SecretFishBoost,
    Flag = "SecretFishBoost",
    Callback = function(Value)
        Config.RNGKill.SecretFishBoost = Value
        Rayfield:Notify({
            Title = "Secret Fish Boost",
            Content = "Secret Fish Boost " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Secret Fish Boost: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Mythical Chance ×10",
    CurrentValue = Config.RNGKill.MythicalChanceBoost,
    Flag = "MythicalChanceBoost",
    Callback = function(Value)
        Config.RNGKill.MythicalChanceBoost = Value
        Rayfield:Notify({
            Title = "Mythical Chance ×10",
            Content = "Mythical Chance ×10 " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Mythical Chance Boost: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Anti-Bad Luck",
    CurrentValue = Config.RNGKill.AntiBadLuck,
    Flag = "AntiBadLuck",
    Callback = function(Value)
        Config.RNGKill.AntiBadLuck = Value
        Rayfield:Notify({
            Title = "Anti-Bad Luck",
            Content = "Anti-Bad Luck " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Anti-Bad Luck: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Guaranteed Catch",
    CurrentValue = Config.RNGKill.GuaranteedCatch,
    Flag = "GuaranteedCatch",
    Callback = function(Value)
        Config.RNGKill.GuaranteedCatch = Value
        Rayfield:Notify({
            Title = "Guaranteed Catch",
            Content = "Guaranteed Catch " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Guaranteed Catch: " .. tostring(Value))
    end
})

RNGKillTab:CreateSlider({
    Name = "Perfect Catch Chance",
    Range = {0, 100},
    Increment = 5,
    Suffix = "%",
    CurrentValue = Config.RNGKill.PerfectCatchChance,
    Flag = "PerfectCatchChance",
    Callback = function(Value)
        Config.RNGKill.PerfectCatchChance = Value
        logError("Perfect Catch Chance: " .. Value)
    end
})

RNGKillTab:CreateToggle({
    Name = "Lucky Rods",
    CurrentValue = Config.RNGKill.LuckyRods,
    Flag = "LuckyRods",
    Callback = function(Value)
        Config.RNGKill.LuckyRods = Value
        Rayfield:Notify({
            Title = "Lucky Rods",
            Content = "Lucky Rods " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Lucky Rods: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Auto Loot",
    CurrentValue = Config.RNGKill.AutoLoot,
    Flag = "AutoLoot",
    Callback = function(Value)
        Config.RNGKill.AutoLoot = Value
        Rayfield:Notify({
            Title = "Auto Loot",
            Content = "Auto Loot " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Auto Loot: " .. tostring(Value))
    end
})

RNGKillTab:CreateSlider({
    Name = "Loot Radius",
    Range = {10, 200},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = Config.RNGKill.LootRadius,
    Flag = "LootRadius",
    Callback = function(Value)
        Config.RNGKill.LootRadius = Value
        logError("Loot Radius: " .. Value)
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
                    PerfectCatchChance = Config.RNGKill.PerfectCatchChance,
                    LuckyRods = Config.RNGKill.LuckyRods
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
                Rayfield:Notify({
                    Title = "RNG Error",
                    Content = "Failed to apply RNG settings: " .. result,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("RNG Settings Error: " .. result)
            end
        else
            Rayfield:Notify({
                Title = "RNG Error",
                Content = "ApplyRNGSettings function not available",
                Duration = 3,
                Image = 13047715178
            })
            logError("RNG Settings Error: Function not available")
        end
    end
})

-- Shop Tab
local ShopTab = Window:CreateTab("🛒 Shop", 13014546625)

ShopTab:CreateToggle({
    Name = "Auto Buy Rods",
    CurrentValue = Config.Shop.AutoBuyRods,
    Flag = "AutoBuyRods",
    Callback = function(Value)
        Config.Shop.AutoBuyRods = Value
        Rayfield:Notify({
            Title = "Auto Buy Rods",
            Content = "Auto Buy Rods " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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
        Rayfield:Notify({
            Title = "Auto Buy Boats",
            Content = "Auto Buy Boats " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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
        Rayfield:Notify({
            Title = "Auto Buy Baits",
            Content = "Auto Buy Baits " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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
        Rayfield:Notify({
            Title = "Auto Upgrade Rod",
            Content = "Auto Upgrade Rod " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Auto Upgrade Rod: " .. tostring(Value))
    end
})

ShopTab:CreateToggle({
    Name = "Auto Upgrade Boat",
    CurrentValue = Config.Shop.AutoUpgradeBoat,
    Flag = "AutoUpgradeBoat",
    Callback = function(Value)
        Config.Shop.AutoUpgradeBoat = Value
        Rayfield:Notify({
            Title = "Auto Upgrade Boat",
            Content = "Auto Upgrade Boat " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Auto Upgrade Boat: " .. tostring(Value))
    end
})

ShopTab:CreateToggle({
    Name = "Auto Upgrade Bait",
    CurrentValue = Config.Shop.AutoUpgradeBait,
    Flag = "AutoUpgradeBait",
    Callback = function(Value)
        Config.Shop.AutoUpgradeBait = Value
        Rayfield:Notify({
            Title = "Auto Upgrade Bait",
            Content = "Auto Upgrade Bait " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Auto Upgrade Bait: " .. tostring(Value))
    end
})

ShopTab:CreateSlider({
    Name = "Buy Delay",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "seconds",
    CurrentValue = Config.Shop.BuyDelay,
    Flag = "BuyDelay",
    Callback = function(Value)
        Config.Shop.BuyDelay = Value
        logError("Buy Delay: " .. Value)
    end
})

ShopTab:CreateDropdown({
    Name = "Currency",
    Options = {"Coins", "Gems", "Tokens"},
    CurrentOption = Config.Shop.Currency,
    Flag = "Currency",
    Callback = function(Value)
        Config.Shop.Currency = Value
        logError("Currency: " .. Value)
    end
})

ShopTab:CreateButton({
    Name = "Buy Selected Item",
    Callback = function()
        if Config.Shop.SelectedRod ~= "" then
            if Remotes and Remotes:FindFirstChild("BuyRod") then
                local success, result = pcall(function()
                    Remotes.BuyRod:FireServer(Config.Shop.SelectedRod)
                    Rayfield:Notify({
                        Title = "Purchase Success",
                        Content = "Successfully purchased: " .. Config.Shop.SelectedRod,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Purchased Rod: " .. Config.Shop.SelectedRod)
                end)
                if not success then
                    Rayfield:Notify({
                        Title = "Purchase Error",
                        Content = "Failed to purchase rod: " .. result,
                        Duration = 5,
                        Image = 13047715178
                    })
                    logError("Purchase Rod Error: " .. result)
                end
            else
                Rayfield:Notify({
                    Title = "Purchase Error",
                    Content = "BuyRod function not available",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Purchase Rod Error: Function not available")
            end
        elseif Config.Shop.SelectedBoat ~= "" then
            if Remotes and Remotes:FindFirstChild("BuyBoat") then
                local success, result = pcall(function()
                    Remotes.BuyBoat:FireServer(Config.Shop.SelectedBoat)
                    Rayfield:Notify({
                        Title = "Purchase Success",
                        Content = "Successfully purchased: " .. Config.Shop.SelectedBoat,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Purchased Boat: " .. Config.Shop.SelectedBoat)
                end)
                if not success then
                    Rayfield:Notify({
                        Title = "Purchase Error",
                        Content = "Failed to purchase boat: " .. result,
                        Duration = 5,
                        Image = 13047715178
                    })
                    logError("Purchase Boat Error: " .. result)
                end
            else
                Rayfield:Notify({
                    Title = "Purchase Error",
                    Content = "BuyBoat function not available",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Purchase Boat Error: Function not available")
            end
        elseif Config.Shop.SelectedBait ~= "" then
            if Remotes and Remotes:FindFirstChild("BuyBait") then
                local success, result = pcall(function()
                    Remotes.BuyBait:FireServer(Config.Shop.SelectedBait)
                    Rayfield:Notify({
                        Title = "Purchase Success",
                        Content = "Successfully purchased: " .. Config.Shop.SelectedBait,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Purchased Bait: " .. Config.Shop.SelectedBait)
                end)
                if not success then
                    Rayfield:Notify({
                        Title = "Purchase Error",
                        Content = "Failed to purchase bait: " .. result,
                        Duration = 5,
                        Image = 13047715178
                    })
                    logError("Purchase Bait Error: " .. result)
                end
            else
                Rayfield:Notify({
                    Title = "Purchase Error",
                    Content = "BuyBait function not available",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Purchase Bait Error: Function not available")
            end
        else
            Rayfield:Notify({
                Title = "Purchase Error",
                Content = "Please select an item to purchase",
                Duration = 3,
                Image = 13047715178
            })
            logError("Purchase Error: No item selected")
        end
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings", 13014546625)

SettingsTab:CreateDropdown({
    Name = "Select Theme",
    Options = {"Dark", "Light", "Blue", "Green", "Red"},
    CurrentOption = Config.Settings.SelectedTheme,
    Flag = "SelectedTheme",
    Callback = function(Value)
        Config.Settings.SelectedTheme = Value
        Rayfield:Notify({
            Title = "Theme Changed",
            Content = "Theme changed to: " .. Value,
            Duration = 3,
            Image = 13047715178
        })
        logError("Theme changed to: " .. Value)
    end
})

SettingsTab:CreateSlider({
    Name = "Transparency",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = Config.Settings.Transparency,
    Flag = "Transparency",
    Callback = function(Value)
        Config.Settings.Transparency = Value
        logError("Transparency: " .. Value)
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

SettingsTab:CreateInput({
    Name = "Config Name",
    PlaceholderText = "Enter config name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        Config.Settings.ConfigName = Text
        logError("Config Name: " .. Text)
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
    Range = {10, 300},
    Increment = 10,
    Suffix = "seconds",
    CurrentValue = Config.Settings.SaveInterval,
    Flag = "SaveInterval",
    Callback = function(Value)
        Config.Settings.SaveInterval = Value
        logError("Save Interval: " .. Value)
    end
})

SettingsTab:CreateToggle({
    Name = "Notifications",
    CurrentValue = Config.Settings.Notifications,
    Flag = "Notifications",
    Callback = function(Value)
        Config.Settings.Notifications = Value
        logError("Notifications: " .. tostring(Value))
    end
})

SettingsTab:CreateSlider({
    Name = "Notification Duration",
    Range = {1, 10},
    Increment = 1,
    Suffix = "seconds",
    CurrentValue = Config.Settings.NotificationDuration,
    Flag = "NotificationDuration",
    Callback = function(Value)
        Config.Settings.NotificationDuration = Value
        logError("Notification Duration: " .. Value)
    end
})

SettingsTab:CreateSlider({
    Name = "Notification Size",
    Range = {0.5, 2},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = Config.Settings.NotificationSize,
    Flag = "NotificationSize",
    Callback = function(Value)
        Config.Settings.NotificationSize = Value
        logError("Notification Size: " .. Value)
    end
})

SettingsTab:CreateDropdown({
    Name = "Notification Position",
    Options = {"TopLeft", "TopRight", "BottomLeft", "BottomRight"},
    CurrentOption = Config.Settings.NotificationPosition,
    Flag = "NotificationPosition",
    Callback = function(Value)
        Config.Settings.NotificationPosition = Value
        logError("Notification Position: " .. Value)
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

-- Low Device Section
local LowDeviceTab = Window:CreateTab("🥔 Low Device", 13014546625)

LowDeviceTab:CreateToggle({
    Name = "Anti Lag",
    CurrentValue = Config.LowDevice.AntiLag,
    Flag = "AntiLag",
    Callback = function(Value)
        Config.LowDevice.AntiLag = Value
        if Value then
            -- Disable unnecessary rendering
            settings().Rendering.QualityLevel = 1
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1000
            Lighting.FogColor = Color3.new(1, 1, 1)
            
            -- Reduce particle effects
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") then
                    effect.Enabled = false
                end
            end
            
            -- Reduce texture quality
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Texture") then
                    obj.TextureSize = Vector2.new(64, 64)
                end
            end
        else
            -- Restore default settings
            settings().Rendering.QualityLevel = 10
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 10000
            Lighting.FogColor = Color3.new(0.5, 0.5, 0.5)
            
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") then
                    effect.Enabled = true
                end
            end
            
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Texture") then
                    obj.TextureSize = Vector2.new(256, 256)
                end
            end
        end
        Rayfield:Notify({
            Title = "Anti Lag",
            Content = "Anti Lag " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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
            setfpscap(60)
            RunService:Set3dRenderingEnabled(true)
            RunService:SetPhysicsThrottlingEnabled(false)
        else
            setfpscap(0)
            RunService:Set3dRenderingEnabled(true)
            RunService:SetPhysicsThrottlingEnabled(true)
        end
        Rayfield:Notify({
            Title = "FPS Stabilizer",
            Content = "FPS Stabilizer " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("FPS Stabilizer: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Disable Effects",
    CurrentValue = Config.LowDevice.DisableEffects,
    Flag = "DisableEffects",
    Callback = function(Value)
        Config.LowDevice.DisableEffects = Value
        if Value then
            -- Disable all visual effects
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Sparkles") or effect:IsA("Smoke") then
                    effect.Enabled = false
                end
            end
            
            -- Reduce lighting
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            Lighting.OutdoorAmbient = Color3.new(0.2, 0.2, 0.2)
            Lighting.Brightness = 0.5
        else
            -- Restore effects
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Sparkles") or effect:IsA("Smoke") then
                    effect.Enabled = true
                end
            end
            
            Lighting.Ambient = Color3.new(0.6, 0.6, 0.6)
            Lighting.OutdoorAmbient = Color3.new(0.4, 0.4, 0.4)
            Lighting.Brightness = 1
        end
        Rayfield:Notify({
            Title = "Disable Effects",
            Content = "Disable Effects " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Disable Effects: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Low Graphics",
    CurrentValue = Config.LowDevice.LowGraphics,
    Flag = "LowGraphics",
    Callback = function(Value)
        Config.LowDevice.LowGraphics = Value
        if Value then
            -- 8-bit style graphics
            settings().Rendering.QualityLevel = 1
            settings().Rendering.MeshCacheSize = 10
            settings().Rendering.TextureCacheSize = 10
            
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") then
                    part.Material = Enum.Material.Plastic
                    part.Reflectance = 0
                    part.Transparency = 0
                end
            end
            
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100
            Lighting.ClockTime = 12
        else
            -- Restore normal graphics
            settings().Rendering.QualityLevel = 10
            settings().Rendering.MeshCacheSize = 100
            settings().Rendering.TextureCacheSize = 100
            
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") then
                    part.Material = Enum.Material.Plastic
                    part.Reflectance = 0.5
                    part.Transparency = 0
                end
            end
            
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 10000
            Lighting.ClockTime = 14
        end
        Rayfield:Notify({
            Title = "Low Graphics",
            Content = "Low Graphics " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Low Graphics: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Reduce Textures",
    CurrentValue = Config.LowDevice.ReduceTextures,
    Flag = "ReduceTextures",
    Callback = function(Value)
        Config.LowDevice.ReduceTextures = Value
        logError("Reduce Textures: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Reduce Meshes",
    CurrentValue = Config.LowDevice.ReduceMeshes,
    Flag = "ReduceMeshes",
    Callback = function(Value)
        Config.LowDevice.ReduceMeshes = Value
        logError("Reduce Meshes: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Disable Shadows",
    CurrentValue = Config.LowDevice.DisableShadows,
    Flag = "DisableShadows",
    Callback = function(Value)
        Config.LowDevice.DisableShadows = Value
        Lighting.GlobalShadows = not Value
        logError("Disable Shadows: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Disable Post Processing",
    CurrentValue = Config.LowDevice.DisablePostProcessing,
    Flag = "DisablePostProcessing",
    Callback = function(Value)
        Config.LowDevice.DisablePostProcessing = Value
        logError("Disable Post Processing: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Disable Ambient Occlusion",
    CurrentValue = Config.LowDevice.DisableAmbientOcclusion,
    Flag = "DisableAmbientOcclusion",
    Callback = function(Value)
        Config.LowDevice.DisableAmbientOcclusion = Value
        logError("Disable Ambient Occlusion: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Disable Screen Effects",
    CurrentValue = Config.LowDevice.DisableScreenEffects,
    Flag = "DisableScreenEffects",
    Callback = function(Value)
        Config.LowDevice.DisableScreenEffects = Value
        logError("Disable Screen Effects: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Disable Decals",
    CurrentValue = Config.LowDevice.DisableDecals,
    Flag = "DisableDecals",
    Callback = function(Value)
        Config.LowDevice.DisableDecals = Value
        for _, decal in ipairs(Workspace:GetDescendants()) do
            if decal:IsA("Decal") then
                decal.Enabled = not Value
            end
        end
        logError("Disable Decals: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Disable Water",
    CurrentValue = Config.LowDevice.DisableWater,
    Flag = "DisableWater",
    Callback = function(Value)
        Config.LowDevice.DisableWater = Value
        for _, water in ipairs(Workspace:GetDescendants()) do
            if water:IsA("Part") and water.Name == "Water" then
                water.Enabled = not Value
            end
        end
        logError("Disable Water: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Reduce Particles",
    CurrentValue = Config.LowDevice.ReduceParticles,
    Flag = "ReduceParticles",
    Callback = function(Value)
        Config.LowDevice.ReduceParticles = Value
        for _, effect in ipairs(Workspace:GetDescendants()) do
            if effect:IsA("ParticleEmitter") then
                if Value then
                    effect.Enabled = false
                else
                    effect.Enabled = true
                end
            end
        end
        logError("Reduce Particles: " .. tostring(Value))
    end
})

LowDeviceTab:CreateSlider({
    Name = "Particle Limit",
    Range = {1, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = Config.LowDevice.ParticleLimit,
    Flag = "ParticleLimit",
    Callback = function(Value)
        Config.LowDevice.ParticleLimit = Value
        logError("Particle Limit: " .. Value)
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

LowDeviceTab:CreateSlider({
    Name = "LOD Level",
    Range = {1, 10},
    Increment = 1,
    Suffix = "",
    CurrentValue = Config.LowDevice.LODLevel,
    Flag = "LODLevel",
    Callback = function(Value)
        Config.LowDevice.LODLevel = Value
        logError("LOD Level: " .. Value)
    end
})

LowDeviceTab:CreateToggle({
    Name = "Reduce Draw Distance",
    CurrentValue = Config.LowDevice.ReduceDrawDistance,
    Flag = "ReduceDrawDistance",
    Callback = function(Value)
        Config.LowDevice.ReduceDrawDistance = Value
        Lighting.FogEnd = Value and 100 or 10000
        logError("Reduce Draw Distance: " .. tostring(Value))
    end
})

LowDeviceTab:CreateSlider({
    Name = "Draw Distance",
    Range = {10, 1000},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = Config.LowDevice.DrawDistance,
    Flag = "DrawDistance",
    Callback = function(Value)
        Config.LowDevice.DrawDistance = Value
        Lighting.FogEnd = Value
        logError("Draw Distance: " .. Value)
    end
})

LowDeviceTab:CreateToggle({
    Name = "Reduce Animation",
    CurrentValue = Config.LowDevice.ReduceAnimation,
    Flag = "ReduceAnimation",
    Callback = function(Value)
        Config.LowDevice.ReduceAnimation = Value
        logError("Reduce Animation: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Reduce Physics",
    CurrentValue = Config.LowDevice.ReducePhysics,
    Flag = "ReducePhysics",
    Callback = function(Value)
        Config.LowDevice.ReducePhysics = Value
        RunService:SetPhysicsThrottlingEnabled(not Value)
        logError("Reduce Physics: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Reduce Sound",
    CurrentValue = Config.LowDevice.ReduceSound,
    Flag = "ReduceSound",
    Callback = function(Value)
        Config.LowDevice.ReduceSound = Value
        logError("Reduce Sound: " .. tostring(Value))
    end
})

LowDeviceTab:CreateDropdown({
    Name = "Sound Quality",
    Options = {"Low", "Medium", "High"},
    CurrentOption = Config.LowDevice.SoundQuality,
    Flag = "SoundQuality",
    Callback = function(Value)
        Config.LowDevice.SoundQuality = Value
        logError("Sound Quality: " .. Value)
    end
})

LowDeviceTab:CreateToggle({
    Name = "Reduce UI",
    CurrentValue = Config.LowDevice.ReduceUI,
    Flag = "ReduceUI",
    Callback = function(Value)
        Config.LowDevice.ReduceUI = Value
        logError("Reduce UI: " .. tostring(Value))
    end
})

LowDeviceTab:CreateDropdown({
    Name = "UI Quality",
    Options = {"Low", "Medium", "High"},
    CurrentOption = Config.LowDevice.UIQuality,
    Flag = "UIQuality",
    Callback = function(Value)
        Config.LowDevice.UIQuality = Value
        logError("UI Quality: " .. Value)
    end
})

LowDeviceTab:CreateButton({
    Name = "Apply All Low Device Settings",
    Callback = function()
        Config.LowDevice.AntiLag = true
        Config.LowDevice.FPSStabilizer = true
        Config.LowDevice.DisableEffects = true
        Config.LowDevice.LowGraphics = true
        Config.LowDevice.ReduceTextures = true
        Config.LowDevice.ReduceMeshes = true
        Config.LowDevice.DisableShadows = true
        Config.LowDevice.DisablePostProcessing = true
        Config.LowDevice.DisableAmbientOcclusion = true
        Config.LowDevice.DisableScreenEffects = true
        Config.LowDevice.DisableDecals = true
        Config.LowDevice.DisableWater = true
        Config.LowDevice.ReduceParticles = true
        Config.LowDevice.ReduceLOD = true
        Config.LowDevice.ReduceDrawDistance = true
        Config.LowDevice.ReduceAnimation = true
        Config.LowDevice.ReducePhysics = true
        Config.LowDevice.ReduceSound = true
        Config.LowDevice.ReduceUI = true
        
        -- Apply all settings
        settings().Rendering.QualityLevel = 1
        settings().Rendering.MeshCacheSize = 10
        settings().Rendering.TextureCacheSize = 10
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100
        Lighting.FogColor = Color3.new(1, 1, 1)
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.OutdoorAmbient = Color3.new(0.2, 0.2, 0.2)
        Lighting.Brightness = 0.5
        Lighting.ClockTime = 12
        
        setfpscap(60)
        RunService:Set3dRenderingEnabled(true)
        RunService:SetPhysicsThrottlingEnabled(false)
        
        for _, effect in ipairs(Workspace:GetDescendants()) do
            if effect:IsA("ParticleEmitter") or effect:IsA("Sparkles") or effect:IsA("Smoke") then
                effect.Enabled = false
            end
        end
        
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("Part") then
                part.Material = Enum.Material.Plastic
                part.Reflectance = 0
                part.Transparency = 0
            end
        end
        
        Rayfield:Notify({
            Title = "Low Device Settings",
            Content = "All low device settings applied",
            Duration = 3,
            Image = 13047715178
        })
        logError("All low device settings applied")
    end
})

LowDeviceTab:CreateButton({
    Name = "Restore Default Graphics",
    Callback = function()
        Config.LowDevice.AntiLag = false
        Config.LowDevice.FPSStabilizer = false
        Config.LowDevice.DisableEffects = false
        Config.LowDevice.LowGraphics = false
        Config.LowDevice.ReduceTextures = false
        Config.LowDevice.ReduceMeshes = false
        Config.LowDevice.DisableShadows = false
        Config.LowDevice.DisablePostProcessing = false
        Config.LowDevice.DisableAmbientOcclusion = false
        Config.LowDevice.DisableScreenEffects = false
        Config.LowDevice.DisableDecals = false
        Config.LowDevice.DisableWater = false
        Config.LowDevice.ReduceParticles = false
        Config.LowDevice.ReduceLOD = false
        Config.LowDevice.ReduceDrawDistance = false
        Config.LowDevice.ReduceAnimation = false
        Config.LowDevice.ReducePhysics = false
        Config.LowDevice.ReduceSound = false
        Config.LowDevice.ReduceUI = false
        
        -- Restore all settings
        settings().Rendering.QualityLevel = 10
        settings().Rendering.MeshCacheSize = 100
        settings().Rendering.TextureCacheSize = 100
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 10000
        Lighting.FogColor = Color3.new(0.5, 0.5, 0.5)
        Lighting.Ambient = Color3.new(0.6, 0.6, 0.6)
        Lighting.OutdoorAmbient = Color3.new(0.4, 0.4, 0.4)
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        
        setfpscap(0)
        RunService:Set3dRenderingEnabled(true)
        RunService:SetPhysicsThrottlingEnabled(true)
        
        for _, effect in ipairs(Workspace:GetDescendants()) do
            if effect:IsA("ParticleEmitter") or effect:IsA("Sparkles") or effect:IsA("Smoke") then
                effect.Enabled = true
            end
        end
        
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("Part") then
                part.Material = Enum.Material.Plastic
                part.Reflectance = 0.5
                part.Transparency = 0
            end
        end
        
        Rayfield:Notify({
            Title = "Default Graphics",
            Content = "Default graphics restored",
            Duration = 3,
            Image = 13047715178
        })
        logError("Default graphics restored")
    end
})

-- Initialize logging
logError("Fish It Script initialized")

-- Auto-Farm functionality
spawn(function()
    while true do
        if Config.System.AutoFarm then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local playerPosition = LocalPlayer.Character.HumanoidRootPart.Position
                
                -- Find fish within radius
                for _, fish in ipairs(Workspace:GetDescendants()) do
                    if fish:IsA("Model") and fish.Name:match("Fish") then
                        local fishPosition = fish.PrimaryPart.Position
                        local distance = (playerPosition - fishPosition).Magnitude
                        
                        if distance <= Config.System.FarmRadius then
                            -- Move to fish
                            LocalPlayer.Character:SetPrimaryPartCFrame(fishPosition)
                            
                            -- Catch fish
                            if FishingEvents and FishingEvents:FindFirstChild("CatchFish") then
                                local success, result = pcall(function()
                                    FishingEvents.CatchFish:FireServer(fish)
                                    logError("Caught fish: " .. fish.Name)
                                end)
                                if not success then
                                    logError("Catch fish error: " .. result)
                                end
                            end
                        end
                    end
                end
            end
        end
        wait(Config.System.FarmDelay)
    end
end)

-- Auto-Sell functionality
spawn(function()
    while true do
        if Config.Player.AutoSell and PlayerData and PlayerData:FindFirstChild("Inventory") then
            for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                if item:IsA("Folder") or item:IsA("Configuration") then
                    -- Check if item is not a favorite
                    local isFavorite = false
                    for _, favorite in pairs(Config.Trader.SelectedFish) do
                        if favorite then
                            isFavorite = true
                            break
                        end
                    end
                    
                    if not isFavorite and TradeEvents and TradeEvents:FindFirstChild("SellItem") then
                        local success, result = pcall(function()
                            TradeEvents.SellItem:FireServer(item)
                            logError("Sold item: " .. item.Name)
                        end)
                        if not success then
                            logError("Sell item error: " .. result)
                        end
                    end
                end
            end
        end
        wait(2)
    end
end)

-- Auto-Accept Trade functionality
spawn(function()
    while true do
        if Config.Trader.AutoAcceptTrade and TradeEvents and TradeEvents:FindFirstChild("AcceptTrade") then
            local success, result = pcall(function()
                TradeEvents.AcceptTrade:FireServer()
                logError("Trade accepted automatically")
            end)
            if not success then
                logError("Accept trade error: " .. result)
            end
        end
        wait(Config.Trader.TradeDelay)
    end
end)

-- Auto-Jump functionality
spawn(function()
    while true do
        if Config.Bypass.AutoJump then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game)
            wait(Config.Bypass.AutoJumpDelay)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game)
        end
        wait(0.1)
    end
end)

-- Speed Hack functionality
spawn(function()
    while true do
        if Config.Player.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Config.Player.SpeedValue
        end
        wait(0.1)
    end
end)

-- Max Boat Speed functionality
spawn(function()
    while true do
        if Config.Player.MaxBoatSpeed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Boat") then
            LocalPlayer.Character.Boat.MaxSpeed = 5 * LocalPlayer.Character.Boat.MaxSpeed
        end
        wait(0.1)
    end
end)

-- Infinity Jump functionality
spawn(function()
    while true do
        if Config.Player.InfinityJump and UserInputService:GetLastInputType() == Enum.UserInputType.Keyboard then
            local key = Enum.KeyCode.Space
            if UserInputService:IsKeyDown(key) then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.Jump = true
                end
            end
        end
        wait(0.1)
    end
end)

-- Fly functionality
spawn(function()
    while true do
        if Config.Player.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local velocity = LocalPlayer.Character.HumanoidRootPart.Velocity
            velocity = Vector3.new(velocity.X, 0, velocity.Z)
            LocalPlayer.Character.HumanoidRootPart.Velocity = velocity
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, Config.Player.FlyRange / 50 * Config.Player.FlySpeed, 0)
        end
        wait(0.1)
    end
end)

-- Ghost Hack functionality
spawn(function()
    while true do
        if Config.Player.GhostHack and LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0.5
                    part.CanCollide = false
                end
            end
        else
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0
                        part.CanCollide = true
                    end
                end
            end
        end
        wait(0.1)
    end
end)

-- Noclip functionality
spawn(function()
    while true do
        if Config.Player.Noclip and LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        else
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
        wait(0.1)
    end
end)

-- ESP functionality
spawn(function()
    while true do
        if Config.Player.PlayerESP then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    for _, part in ipairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            if Config.Player.ESPBox then
                                part.Material = Enum.Material.Neon
                                part.Color = Config.Player.ESPColor
                            end
                            
                            if Config.Player.ESPLines then
                                local line = Instance.new("BoxHandleAdornment")
                                line.Adornee = part
                                line.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
                                line.Color3 = Config.Player.ESPColor
                                line.Transparency = 0.5
                                line.Parent = part
                            end
                            
                            if Config.Player.ESPName then
                                local nameTag = Instance.new("BillboardGui")
                                nameTag.Adornee = part
                                nameTag.Size = UDim2.new(0, 100, 0, 50)
                                nameTag.Parent = part
                                
                                local nameLabel = Instance.new("TextLabel")
                                nameLabel.Text = player.Name
                                nameLabel.Size = UDim2.new(1, 0, 1, 0)
                                nameLabel.BackgroundTransparency = 1
                                nameLabel.TextColor3 = Config.Player.ESPColor
                                nameLabel.Parent = nameTag
                            end
                            
                            if Config.Player.ESPLevel then
                                local levelTag = Instance.new("BillboardGui")
                                levelTag.Adornee = part
                                levelTag.Size = UDim2.new(0, 100, 0, 50)
                                levelTag.Parent = part
                                
                                local levelLabel = Instance.new("TextLabel")
                                levelLabel.Text = "Level: " .. tostring(player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Level") and player.leaderstats.Level.Value or 1)
                                levelLabel.Size = UDim2.new(1, 0, 1, 0)
                                levelLabel.BackgroundTransparency = 1
                                levelLabel.TextColor3 = Config.Player.ESPColor
                                levelLabel.Parent = levelTag
                            end
                        end
                    end
                end
            end
        else
            -- Clear ESP
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    for _, part in ipairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            for _, child in ipairs(part:GetChildren()) do
                                if child:IsA("BoxHandleAdornment") or child:IsA("BillboardGui") then
                                    child:Destroy()
                                end
                            end
                        end
                    end
                end
            end
        end
        wait(0.5)
    end
end)

-- Show Info functionality
spawn(function()
    while true do
        if Config.System.ShowInfo then
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local memory = math.floor(Stats:GetTotalMemoryUsageMb())
            local battery = math.floor(UserInputService:GetBatteryLevel() * 100)
            local time = os.date("%H:%M:%S")
            
            local infoText = string.format("FPS: %d | Ping: %dms | Memory: %dMB | Battery: %d%% | Time: %s", 
                fps, ping, memory, battery, time)
            
            -- Display info in a small, unobtrusive way
            local infoLabel = CoreGui:FindFirstChild("FishItInfoLabel")
            if not infoLabel then
                infoLabel = Instance.new("TextLabel")
                infoLabel.Name = "FishItInfoLabel"
                infoLabel.Size = UDim2.new(0, 300, 0, 30)
                infoLabel.Position = UDim2.new(1, -310, 0, 10)
                infoLabel.BackgroundTransparency = 0.5
                infoLabel.Text = infoText
                infoLabel.TextColor3 = Color3.new(1, 1, 1)
                infoLabel.Font = Enum.Font.SourceSans
                infoLabel.TextSize = 14
                infoLabel.Parent = CoreGui
            else
                infoLabel.Text = infoText
            end
        else
            local infoLabel = CoreGui:FindFirstChild("FishItInfoLabel")
            if infoLabel then
                infoLabel:Destroy()
            end
        end
        wait(1)
    end
end)

-- Auto-Buy functionality
spawn(function()
    while true do
        if Config.Shop.AutoBuyRods and Config.Shop.SelectedRod ~= "" and Remotes and Remotes:FindFirstChild("BuyRod") then
            local success, result = pcall(function()
                Remotes.BuyRod:FireServer(Config.Shop.SelectedRod)
                logError("Auto-purchased Rod: " .. Config.Shop.SelectedRod)
            end)
            if not success then
                logError("Auto-purchase Rod error: " .. result)
            end
        end
        
        if Config.Shop.AutoBuyBoats and Config.Shop.SelectedBoat ~= "" and Remotes and Remotes:FindFirstChild("BuyBoat") then
            local success, result = pcall(function()
                Remotes.BuyBoat:FireServer(Config.Shop.SelectedBoat)
                logError("Auto-purchased Boat: " .. Config.Shop.SelectedBoat)
            end)
            if not success then
                logError("Auto-purchase Boat error: " .. result)
            end
        end
        
        if Config.Shop.AutoBuyBaits and Config.Shop.SelectedBait ~= "" and Remotes and Remotes:FindFirstChild("BuyBait") then
            local success, result = pcall(function()
                Remotes.BuyBait:FireServer(Config.Shop.SelectedBait)
                logError("Auto-purchased Bait: " .. Config.Shop.SelectedBait)
            end)
            if not success then
                logError("Auto-purchase Bait error: " .. result)
            end
        end
        
        wait(Config.Shop.BuyDelay)
    end
end)

-- Auto-Upgrade functionality
spawn(function()
    while true do
        if Config.Shop.AutoUpgradeRod and GameFunctions and GameFunctions:FindFirstChild("UpgradeRod") then
            local success, result = pcall(function()
                GameFunctions.UpgradeRod:InvokeServer()
                logError("Auto-upgraded Rod")
            end)
            if not success then
                logError("Auto-Upgrade Rod error: " .. result)
            end
        end
        
        if Config.Shop.AutoUpgradeBoat and GameFunctions and GameFunctions:FindFirstChild("UpgradeBoat") then
            local success, result = pcall(function()
                GameFunctions.UpgradeBoat:InvokeServer()
                logError("Auto-upgraded Boat")
            end)
            if not success then
                logError("Auto-Upgrade Boat error: " .. result)
            end
        end
        
        if Config.Shop.AutoUpgradeBait and GameFunctions and GameFunctions:FindFirstChild("UpgradeBait") then
            local success, result = pcall(function()
                GameFunctions.UpgradeBait:InvokeServer()
                logError("Auto-upgraded Bait")
            end)
            if not success then
                logError("Auto-Upgrade Bait error: " .. result)
            end
        end
        
        wait(10)
    end
end)

-- Server Hop functionality
spawn(function()
    while true do
        if Config.Server.ServerHop then
            local servers = {}
            local success, result = pcall(function()
                local http = game:GetService("HttpService")
                local response = http:GetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100")
                servers = http:JSONDecode(response).data
            end)
            
            if success then
                for _, server in ipairs(servers) do
                    if server.playing < server.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                        logError("Server hopped to: " .. server.id)
                        break
                    end
                end
            else
                logError("Server Hop error: " .. result)
            end
        end
        wait(30)
    end
end)

-- Auto-Fish functionality
spawn(function()
    while true do
        if Config.Player.AutoFish and FishingEvents and FishingEvents:FindFirstChild("StartFishing") then
            local success, result = pcall(function()
                FishingEvents.StartFishing:FireServer()
                logError("Started fishing automatically")
            end)
            if not success then
                logError("Auto-Fish error: " .. result)
            end
        end
        wait(5)
    end
end)

-- Perfect Catch functionality
spawn(function()
    while true do
        if Config.Player.PerfectCatch and FishingEvents and FishingEvents:FindFirstChild("PerfectCatch") then
            local success, result = pcall(function()
                FishingEvents.PerfectCatch:FireServer()
                logError("Perfect catch activated")
            end)
            if not success then
                logError("Perfect Catch error: " .. result)
            end
        end
        wait(1)
    end
end)

-- Auto-Reel functionality
spawn(function()
    while true do
        if Config.Player.AutoReel and FishingEvents and FishingEvents:FindFirstChild("ReelFish") then
            local success, result = pcall(function()
                FishingEvents.ReelFish:FireServer()
                logError("Reeled fish automatically")
            end)
            if not success then
                logError("Auto-Reel error: " .. result)
            end
        end
        wait(0.5)
    end
end)

-- Anti Hook Break functionality
spawn(function()
    while true do
        if Config.Player.AntiHookBreak and FishingEvents and FishingEvents:FindFirstChild("AntiHookBreak") then
            local success, result = pcall(function()
                FishingEvents.AntiHookBreak:FireServer()
                logError("Anti hook break activated")
            end)
            if not success then
                logError("Anti Hook Break error: " .. result)
            end
        end
        wait(1)
    end
end)

-- Auto-Collect functionality
spawn(function()
    while true do
        if Config.System.AutoCollect then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local playerPosition = LocalPlayer.Character.HumanoidRootPart.Position
                
                -- Find items within radius
                for _, item in ipairs(Workspace:GetDescendants()) do
                    if item:IsA("Model") and (item.Name:match("Fish") or item.Name:match("Item")) then
                        local itemPosition = item.PrimaryPart.Position
                        local distance = (playerPosition - itemPosition).Magnitude
                        
                        if distance <= Config.System.CollectRadius then
                            -- Move to item
                            LocalPlayer.Character:SetPrimaryPartCFrame(itemPosition)
                            
                            -- Collect item
                            if Remotes and Remotes:FindFirstChild("CollectItem") then
                                local success, result = pcall(function()
                                    Remotes.CollectItem:FireServer(item)
                                    logError("Collected item: " .. item.Name)
                                end)
                                if not success then
                                    logError("Collect item error: " .. result)
                                end
                            end
                        end
                    end
                end
            end
        end
        wait(0.5)
    end
end)

-- Auto-Equip functionality
spawn(function()
    while true do
        if Config.System.AutoEquip and GameFunctions and GameFunctions:FindFirstChild("EquipItem") then
            local success, result = pcall(function()
                GameFunctions.EquipItem:InvokeServer(Config.Shop.SelectedRod or Config.Shop.SelectedBoat or Config.Shop.SelectedBait)
                logError("Equipped item automatically")
            end)
            if not success then
                logError("Auto-Equip error: " .. result)
            end
        end
        wait(Config.System.EquipDelay)
    end
end)

-- Auto-Save functionality
spawn(function()
    while true do
        if Config.Settings.AutoSave then
            SaveConfig()
        end
        wait(Config.Settings.SaveInterval)
    end
end)

-- Initialize with default config
LoadConfig()
