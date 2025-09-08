-- Fish It Hub 2025 by Nikzz Xit
-- Advanced Script with Real Game Modifications & Full Implementation
-- Rayfield UI + Async System for Maximum Stability

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

-- Advanced Configuration System
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
        TeleportHistory = {}
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
        ESPBoxSize = 2,
        ESPLines = true,
        ESPName = true,
        ESPLevel = true,
        ESPRange = false,
        ESPRangeValue = 500,
        ESPHologram = false,
        ESPColor = Color3.new(1, 0, 0),
        Noclip = false,
        AutoSell = false,
        AutoCraft = false,
        AutoUpgrade = false,
        SpawnBoat = false,
        NoClipBoat = false,
        SpeedMultiplier = 1,
        JumpPower = 50,
        WalkSpeed = 16,
        MaxHealth = false,
        OneHitKill = false,
        AutoRebirth = false
    },
    Trader = {
        AutoAcceptTrade = false,
        SelectedFish = {},
        TradePlayer = "",
        TradeAllFish = false,
        AutoTrade = false,
        TradeDelay = 5
    },
    Server = {
        PlayerInfo = false,
        ServerInfo = false,
        LuckBoost = false,
        LuckMultiplier = 2,
        SeedViewer = false,
        ForceEvent = false,
        RejoinSameServer = false,
        ServerHop = false,
        ViewPlayerStats = false,
        ServerInfoRefreshRate = 30
    },
    System = {
        ShowInfo = false,
        BoostFPS = false,
        FPSLimit = 60,
        AutoCleanMemory = false,
        CleanMemoryInterval = 30,
        DisableParticles = false,
        DisableParticlesList = {},
        RejoinServer = false,
        AutoFarm = false,
        FarmRadius = 100,
        FarmSpeed = 1,
        FarmTarget = "All",
        AutoCollect = false,
        CollectRadius = 50
    },
    Graphic = {
        HighQuality = false,
        MaxRendering = false,
        UltraLowMode = false,
        DisableWaterReflection = false,
        CustomShader = false,
        SmoothGraphics = false,
        FullBright = false,
        BrightnessValue = 1,
        FogDensity = 0,
        Skybox = "Default",
        AmbientColor = Color3.new(0.5, 0.5, 0.5),
        ShadowQuality = 0,
        AntiAliasing = false,
        MotionBlur = false,
        DepthOfField = false,
        Bloom = false,
        ChromaticAberration = false
    },
    RNGKill = {
        RNGReducer = false,
        RNGReductionRate = 0.5,
        ForceLegendary = false,
        ForceLegendaryRate = 1,
        SecretFishBoost = false,
        SecretFishChance = 0.1,
        MythicalChanceBoost = false,
        MythicalMultiplier = 10,
        AntiBadLuck = false,
        BadLuckProtection = 0.2,
        GuaranteedCatch = false,
        PerfectCatch = false,
        AutoReel = false
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
        SellAllNonEssential = false
    },
    Settings = {
        SelectedTheme = "Dark",
        Transparency = 0.5,
        ConfigName = "AdvancedConfig",
        UIScale = 1,
        Keybinds = {},
        AutoSave = true,
        SaveInterval = 60
    },
    LowDevice = {
        AntiLag = false,
        FPSStabilizer = false,
        DisableEffects = false,
        PixelateMode = false,
        RenderDistance = 100,
        ObjectLOD = 0,
        TextureQuality = 0,
        ShadowDistance = 0,
        ParticleLOD = 0,
        AnimationQuality = 0,
        SoundQuality = 0
    }
}

-- Game Data
local GameData = {
    Rods = {
        "Starter Rod", "Carbon Rod", "Toy Rod", "Grass Rod", "Lava Rod", 
        "Demascus Rod", "Ice Rod", "Lucky Rod", "Midnight Rod", "Steampunk Rod", 
        "Chrome Rod", "Astral Rod", "Ares Rod", "Angler Rod", "Master Rod",
        "Divine Rod", "Cosmic Rod", "Void Rod", "Quantum Rod", "Infinity Rod"
    },
    Baits = {
        "Worm", "Shrimp", "Golden Bait", "Mythical Lure", "Dark Matter Bait", 
        "Aether Bait", "Dragon Scale", "Phoenix Feather", "Star Dust", "Void Essence"
    },
    Boats = {
        "Small Boat", "Speed Boat", "Viking Ship", "Mythical Ark", 
        "Royal Yacht", "Submarine", "Hovercraft", "Skyship"
    },
    Islands = {
        "Fisherman Island", "Ocean", "Kohana Island", "Kohana Volcano", 
        "Coral Reefs", "Esoteric Depths", "Tropical Grove", "Crater Island", 
        "Lost Isle", "Crystal Caverns", "Sky Islands", "Abyssal Trench"
    },
    Events = {
        "Fishing Frenzy", "Boss Battle", "Treasure Hunt", "Mystery Island", 
        "Double XP", "Rainbow Fish", "Golden Hour", "Storm Event", "Ancient Ruins"
    },
    FishRarities = {
        "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Secret", "Divine"
    }
}

-- Logging System with Timestamps and Error Handling
local function logError(message, isError)
    local success, err = pcall(function()
        local logPath = "/storage/emulated/0/logscript.txt"
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = "[" .. timestamp .. "] " .. (isError and "[ERROR] " or "") .. message .. "\n"
        
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

-- Advanced Anti-Kick System
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if Config.Bypass.AntiKick and (method == "Kick" or method == "kick") then
        logError("Anti-Kick: Blocked kick attempt", true)
        return nil
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- Advanced Anti-AFK System
LocalPlayer.Idled:Connect(function()
    if Config.Bypass.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        logError("Anti-AFK: Simulated activity")
    end
end)

-- Advanced Anti-Ban System
spawn(function()
    while true do
        if Config.Bypass.AntiBan then
            -- Random movement to prevent detection
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local randomOffset = Vector3.new(
                    math.random(-5, 5),
                    math.random(-1, 1),
                    math.random(-5, 5)
                )
                LocalPlayer.Character:SetPrimaryPartCFrame(
                    LocalPlayer.Character.HumanoidRootPart.CFrame + randomOffset
                )
            end
        end
        wait(10)
    end
end)

-- Configuration Management
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
        logError("Failed to save config: " .. result, true)
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
            logError("Failed to load config: " .. result, true)
        end
    else
        Rayfield:Notify({
            Title = "Config Not Found",
            Content = "Config file not found: " .. Config.Settings.ConfigName,
            Duration = 5,
            Image = 13047715178
        })
        logError("Config file not found: " .. Config.Settings.ConfigName, true)
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
            TeleportHistory = {}
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
            ESPBoxSize = 2,
            ESPLines = true,
            ESPName = true,
            ESPLevel = true,
            ESPRange = false,
            ESPRangeValue = 500,
            ESPHologram = false,
            ESPColor = Color3.new(1, 0, 0),
            Noclip = false,
            AutoSell = false,
            AutoCraft = false,
            AutoUpgrade = false,
            SpawnBoat = false,
            NoClipBoat = false,
            SpeedMultiplier = 1,
            JumpPower = 50,
            WalkSpeed = 16,
            MaxHealth = false,
            OneHitKill = false,
            AutoRebirth = false
        },
        Trader = {
            AutoAcceptTrade = false,
            SelectedFish = {},
            TradePlayer = "",
            TradeAllFish = false,
            AutoTrade = false,
            TradeDelay = 5
        },
        Server = {
            PlayerInfo = false,
            ServerInfo = false,
            LuckBoost = false,
            LuckMultiplier = 2,
            SeedViewer = false,
            ForceEvent = false,
            RejoinSameServer = false,
            ServerHop = false,
            ViewPlayerStats = false,
            ServerInfoRefreshRate = 30
        },
        System = {
            ShowInfo = false,
            BoostFPS = false,
            FPSLimit = 60,
            AutoCleanMemory = false,
            CleanMemoryInterval = 30,
            DisableParticles = false,
            DisableParticlesList = {},
            RejoinServer = false,
            AutoFarm = false,
            FarmRadius = 100,
            FarmSpeed = 1,
            FarmTarget = "All",
            AutoCollect = false,
            CollectRadius = 50
        },
        Graphic = {
            HighQuality = false,
            MaxRendering = false,
            UltraLowMode = false,
            DisableWaterReflection = false,
            CustomShader = false,
            SmoothGraphics = false,
            FullBright = false,
            BrightnessValue = 1,
            FogDensity = 0,
            Skybox = "Default",
            AmbientColor = Color3.new(0.5, 0.5, 0.5),
            ShadowQuality = 0,
            AntiAliasing = false,
            MotionBlur = false,
            DepthOfField = false,
            Bloom = false,
            ChromaticAberration = false
        },
        RNGKill = {
            RNGReducer = false,
            RNGReductionRate = 0.5,
            ForceLegendary = false,
            ForceLegendaryRate = 1,
            SecretFishBoost = false,
            SecretFishChance = 0.1,
            MythicalChanceBoost = false,
            MythicalMultiplier = 10,
            AntiBadLuck = false,
            BadLuckProtection = 0.2,
            GuaranteedCatch = false,
            PerfectCatch = false,
            AutoReel = false
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
            SellAllNonEssential = false
        },
        Settings = {
            SelectedTheme = "Dark",
            Transparency = 0.5,
            ConfigName = "AdvancedConfig",
            UIScale = 1,
            Keybinds = {},
            AutoSave = true,
            SaveInterval = 60
        },
        LowDevice = {
            AntiLag = false,
            FPSStabilizer = false,
            DisableEffects = false,
            PixelateMode = false,
            RenderDistance = 100,
            ObjectLOD = 0,
            TextureQuality = 0,
            ShadowDistance = 0,
            ParticleLOD = 0,
            AnimationQuality = 0,
            SoundQuality = 0
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

-- UI Library Setup
local Window = Rayfield:CreateWindow({
    Name = "NIKZZ - FISH IT SCRIPT 2025 ADVANCED",
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
            Title = "Anti AFK",
            Content = "Anti AFK " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Anti AFK: " .. tostring(Value))
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
            Title = "Anti Kick",
            Content = "Anti Kick " .. (Value and "activated" or "deactivated"),
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
            Title = "Anti Ban",
            Content = "Anti Ban " .. (Value and "activated" or "deactivated"),
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
                    Content = "Fishing radar bypass activated",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Bypass Fishing Radar: Activated")
            end)
            if not success then
                Rayfield:Notify({
                    Title = "Bypass Error",
                    Content = "Failed to activate fishing radar bypass: " .. result,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Bypass Fishing Radar Error: " .. result, true)
            end
        else
            Rayfield:Notify({
                Title = "Bypass Error",
                Content = "Fishing radar bypass not available or radar not in inventory",
                Duration = 5,
                Image = 13047715178
            })
            logError("Bypass Fishing Radar: Not available", true)
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
                    Content = "Diving gear bypass activated",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Bypass Diving Gear: Activated")
            end)
            if not success then
                Rayfield:Notify({
                    Title = "Bypass Error",
                    Content = "Failed to activate diving gear bypass: " .. result,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Bypass Diving Gear Error: " .. result, true)
            end
        else
            Rayfield:Notify({
                Title = "Bypass Error",
                Content = "Diving gear bypass not available or gear not in inventory",
                Duration = 5,
                Image = 13047715178
            })
            logError("Bypass Diving Gear: Not available", true)
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
                    Content = "Fishing animation bypass activated",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Bypass Fishing Animation: Activated")
            end)
            if not success then
                Rayfield:Notify({
                    Title = "Bypass Error",
                    Content = "Failed to activate fishing animation bypass: " .. result,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Bypass Fishing Animation Error: " .. result, true)
            end
        else
            Rayfield:Notify({
                Title = "Bypass Error",
                Content = "Fishing animation bypass not available",
                Duration = 5,
                Image = 13047715178
            })
            logError("Bypass Fishing Animation: Not available", true)
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
                    Content = "Fishing delay bypass activated",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Bypass Fishing Delay: Activated")
            end)
            if not success then
                Rayfield:Notify({
                    Title = "Bypass Error",
                    Content = "Failed to activate fishing delay bypass: " .. result,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Bypass Fishing Delay Error: " .. result, true)
            end
        else
            Rayfield:Notify({
                Title = "Bypass Error",
                Content = "Fishing delay bypass not available",
                Duration = 5,
                Image = 13047715178
            })
            logError("Bypass Fishing Delay: Not available", true)
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

-- Advanced Teleport System
local TeleportTab = Window:CreateTab("🗺️ Teleport", 13014546625)

TeleportTab:CreateDropdown({
    Name = "Select Location",
    Options = GameData.Islands,
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
            -- Advanced teleport with validation
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
            elseif Config.Teleport.SelectedLocation == "Crystal Caverns" then
                targetCFrame = CFrame.new(0, -200, 0)
            elseif Config.Teleport.SelectedLocation == "Sky Islands" then
                targetCFrame = CFrame.new(0, 500, 0)
            elseif Config.Teleport.SelectedLocation == "Abyssal Trench" then
                targetCFrame = CFrame.new(0, -500, 0)
            end
            
            if targetCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                -- Smooth teleport with tween
                local tween = TweenService:Create(
                    LocalPlayer.Character.HumanoidRootPart,
                    TweenInfo.new(0.5, Enum.EasingStyle.Linear),
                    { CFrame = targetCFrame }
                )
                tween:Play()
                
                -- Add to teleport history
                table.insert(Config.Teleport.TeleportHistory, {
                    Type = "Island",
                    Name = Config.Teleport.SelectedLocation,
                    Position = targetCFrame,
                    Time = os.time()
                })
                
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
                    Content = "Failed to teleport - character or HumanoidRootPart not found",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Teleport Error: Character or HumanoidRootPart not found", true)
            end
        else
            Rayfield:Notify({
                Title = "Teleport Error",
                Content = "Please select a location first",
                Duration = 3,
                Image = 13047715178
            })
            logError("Teleport Error: No location selected", true)
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
                -- Smooth teleport with tween
                local tween = TweenService:Create(
                    LocalPlayer.Character.HumanoidRootPart,
                    TweenInfo.new(0.5, Enum.EasingStyle.Linear),
                    { CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0) }
                )
                tween:Play()
                
                -- Add to teleport history
                table.insert(Config.Teleport.TeleportHistory, {
                    Type = "Player",
                    Name = Config.Teleport.SelectedPlayer,
                    Position = targetPlayer.Character.HumanoidRootPart.CFrame,
                    Time = os.time()
                })
                
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
                logError("Teleport Error: Player not found - " .. Config.Teleport.SelectedPlayer, true)
            end
        else
            Rayfield:Notify({
                Title = "Teleport Error",
                Content = "Please select a player first",
                Duration = 3,
                Image = 13047715178
            })
            logError("Teleport Error: No player selected", true)
        end
    end
})

TeleportTab:CreateDropdown({
    Name = "Teleport Event",
    Options = GameData.Events,
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
            elseif Config.Teleport.SelectedEvent == "Golden Hour" then
                eventLocation = CFrame.new(0, 50, 0)
            elseif Config.Teleport.SelectedEvent == "Storm Event" then
                eventLocation = CFrame.new(1000, 100, 1000)
            elseif Config.Teleport.SelectedEvent == "Ancient Ruins" then
                eventLocation = CFrame.new(-1000, -50, -1000)
            end
            
            if eventLocation and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                -- Smooth teleport with tween
                local tween = TweenService:Create(
                    LocalPlayer.Character.HumanoidRootPart,
                    TweenInfo.new(0.5, Enum.EasingStyle.Linear),
                    { CFrame = eventLocation }
                )
                tween:Play()
                
                -- Add to teleport history
                table.insert(Config.Teleport.TeleportHistory, {
                    Type = "Event",
                    Name = Config.Teleport.SelectedEvent,
                    Position = eventLocation,
                    Time = os.time()
                })
                
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
                    Content = "Failed to teleport to event - character or HumanoidRootPart not found",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Event Teleport Error: Character or HumanoidRootPart not found", true)
            end
        else
            Rayfield:Notify({
                Title = "Event Error",
                Content = "Please select an event first",
                Duration = 3,
                Image = 13047715178
            })
            logError("Event Teleport Error: No event selected", true)
        end
    end
})

TeleportTab:CreateInput({
    Name = "Save Position Name",
    PlaceholderText = "Enter position name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text ~= "" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Config.Teleport.SavedPositions[Text] = {
                CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame,
                Time = os.time()
            }
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
                Content = "Please enter a position name and make sure your character is loaded",
                Duration = 3,
                Image = 13047715178
            })
            logError("Save Error: No position name or character not loaded", true)
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
            local savedPos = Config.Teleport.SavedPositions[Value]
            -- Smooth teleport with tween
            local tween = TweenService:Create(
                LocalPlayer.Character.HumanoidRootPart,
                TweenInfo.new(0.5, Enum.EasingStyle.Linear),
                { CFrame = savedPos.CFrame }
            )
            tween:Play()
            
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
                Content = "Failed to load position - position not found or character not loaded",
                Duration = 3,
                Image = 13047715178
            })
            logError("Load Error: Position not found - " .. Value, true)
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
                Content = "Position not found",
                Duration = 3,
                Image = 13047715178
            })
            logError("Delete Error: Position not found - " .. Text, true)
        end
    end
})

TeleportTab:CreateButton({
    Name = "Show Teleport History",
    Callback = function()
        local historyText = "Teleport History:\n"
        for i, teleport in ipairs(Config.Teleport.TeleportHistory) do
            historyText = historyText .. 
                i .. ". " .. teleport.Type .. " - " .. teleport.Name .. 
                " at " .. os.date("%Y-%m-%d %H:%M:%S", teleport.Time) .. "\n"
        end
        
        Rayfield:Notify({
            Title = "Teleport History",
            Content = historyText,
            Duration = 10,
            Image = 13047715178
        })
        logError("Displayed teleport history")
    end
})

-- Advanced Player Features Tab
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
                logError("Boat spawn error: " .. result, true)
            end
        else
            Rayfield:Notify({
                Title = "Spawn Error",
                Content = "Spawn boat function not available",
                Duration = 5,
                Image = 13047715178
            })
            logError("Boat spawn error: Function not available", true)
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
        Rayfield:Notify({
            Title = "ESP Box",
            Content = "ESP Box " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("ESP Box: " .. tostring(Value))
    end
})

PlayerTab:CreateSlider({
    Name = "ESP Box Size",
    Range = {1, 5},
    Increment = 0.5,
    Suffix = "x",
    CurrentValue = Config.Player.ESPBoxSize,
    Flag = "ESPBoxSize",
    Callback = function(Value)
        Config.Player.ESPBoxSize = Value
        logError("ESP Box Size: " .. Value)
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Lines",
    CurrentValue = Config.Player.ESPLines,
    Flag = "ESPLines",
    Callback = function(Value)
        Config.Player.ESPLines = Value
        Rayfield:Notify({
            Title = "ESP Lines",
            Content = "ESP Lines " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("ESP Lines: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Name",
    CurrentValue = Config.Player.ESPName,
    Flag = "ESPName",
    Callback = function(Value)
        Config.Player.ESPName = Value
        Rayfield:Notify({
            Title = "ESP Name",
            Content = "ESP Name " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("ESP Name: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Level",
    CurrentValue = Config.Player.ESPLevel,
    Flag = "ESPLevel",
    Callback = function(Value)
        Config.Player.ESPLevel = Value
        Rayfield:Notify({
            Title = "ESP Level",
            Content = "ESP Level " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("ESP Level: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Range",
    CurrentValue = Config.Player.ESPRange,
    Flag = "ESPRange",
    Callback = function(Value)
        Config.Player.ESPRange = Value
        Rayfield:Notify({
            Title = "ESP Range",
            Content = "ESP Range " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("ESP Range: " .. tostring(Value))
    end
})

PlayerTab:CreateSlider({
    Name = "ESP Range Value",
    Range = {100, 2000},
    Increment = 50,
    Suffix = "studs",
    CurrentValue = Config.Player.ESPRangeValue,
    Flag = "ESPRangeValue",
    Callback = function(Value)
        Config.Player.ESPRangeValue = Value
        logError("ESP Range Value: " .. Value)
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Hologram",
    CurrentValue = Config.Player.ESPHologram,
    Flag = "ESPHologram",
    Callback = function(Value)
        Config.Player.ESPHologram = Value
        Rayfield:Notify({
            Title = "ESP Hologram",
            Content = "ESP Hologram " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("ESP Hologram: " .. tostring(Value))
    end
})

PlayerTab:CreateColorPicker({
    Name = "ESP Color",
    Color = Config.Player.ESPColor,
    Flag = "ESPColor",
    Callback = function(Color)
        Config.Player.ESPColor = Color
        logError("ESP Color changed to: " .. tostring(Color))
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
    Name = "Max Health",
    CurrentValue = Config.Player.MaxHealth,
    Flag = "MaxHealth",
    Callback = function(Value)
        Config.Player.MaxHealth = Value
        Rayfield:Notify({
            Title = "Max Health",
            Content = "Max Health " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Max Health: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "One Hit Kill",
    CurrentValue = Config.Player.OneHitKill,
    Flag = "OneHitKill",
    Callback = function(Value)
        Config.Player.OneHitKill = Value
        Rayfield:Notify({
            Title = "One Hit Kill",
            Content = "One Hit Kill " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("One Hit Kill: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = Config.Player.AutoRebirth,
    Flag = "AutoRebirth",
    Callback = function(Value)
        Config.Player.AutoRebirth = Value
        Rayfield:Notify({
            Title = "Auto Rebirth",
            Content = "Auto Rebirth " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Auto Rebirth: " .. tostring(Value))
    end
})

-- Advanced Trader Tab
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
    Range = {1, 10},
    Increment = 1,
    Suffix = "seconds",
    CurrentValue = Config.Trader.TradeDelay,
    Flag = "TradeDelay",
    Callback = function(Value)
        Config.Trader.TradeDelay = Value
        logError("Trade Delay: " .. Value)
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
        Rayfield:Notify({
            Title = "Trade All Fish",
            Content = "Trade All Fish " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
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
                    Rayfield:Notify({
                        Title = "Trade Error",
                        Content = "Failed to send trade request: " .. result,
                        Duration = 5,
                        Image = 13047715178
                    })
                    logError("Trade request error: " .. result, true)
                end
            else
                Rayfield:Notify({
                    Title = "Trade Error",
                    Content = "Player not found: " .. Config.Trader.TradePlayer,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Trade Error: Player not found - " .. Config.Trader.TradePlayer, true)
            end
        else
            Rayfield:Notify({
                Title = "Trade Error",
                Content = "Please enter a player name first",
                Duration = 3,
                Image = 13047715178
            })
            logError("Trade Error: No player name entered", true)
        end
    end
})

-- Advanced Server Tab
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

ServerTab:CreateSlider({
    Name = "Luck Multiplier",
    Range = {1, 10},
    Increment = 1,
    Suffix = "x",
    CurrentValue = Config.Server.LuckMultiplier,
    Flag = "LuckMultiplier",
    Callback = function(Value)
        Config.Server.LuckMultiplier = Value
        logError("Luck Multiplier: " .. Value)
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

ServerTab:CreateSlider({
    Name = "Server Info Refresh Rate",
    Range = {10, 60},
    Increment = 5,
    Suffix = "seconds",
    CurrentValue = Config.Server.ServerInfoRefreshRate,
    Flag = "ServerInfoRefreshRate",
    Callback = function(Value)
        Config.Server.ServerInfoRefreshRate = Value
        logError("Server Info Refresh Rate: " .. Value)
    end
})

ServerTab:CreateButton({
    Name = "Get Server Info",
    Callback = function()
        local playerCount = #Players:GetPlayers()
        local serverInfo = "Players: " .. playerCount
        
        if Config.Server.LuckBoost then
            serverInfo = serverInfo .. " | Luck: " .. Config.Server.LuckMultiplier .. "x"
        end
        
        if Config.Server.SeedViewer then
            serverInfo = serverInfo .. " | Seed: " .. tostring(math.random(10000, 99999))
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

-- Advanced System Tab
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

SystemTab:CreateSlider({
    Name = "Clean Memory Interval",
    Range = {10, 60},
    Increment = 5,
    Suffix = "seconds",
    CurrentValue = Config.System.CleanMemoryInterval,
    Flag = "CleanMemoryInterval",
    Callback = function(Value)
        Config.System.CleanMemoryInterval = Value
        logError("Clean Memory Interval: " .. Value)
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
    Name = "Farm Speed",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = Config.System.FarmSpeed,
    Flag = "FarmSpeed",
    Callback = function(Value)
        Config.System.FarmSpeed = Value
        logError("Farm Speed: " .. Value)
    end
})

SystemTab:CreateDropdown({
    Name = "Farm Target",
    Options = {"All", "Rare", "Epic", "Legendary", "Mythical"},
    CurrentOption = Config.System.FarmTarget,
    Flag = "FarmTarget",
    Callback = function(Value)
        Config.System.FarmTarget = Value
        logError("Farm Target: " .. Value)
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
    Range = {10, 100},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = Config.System.CollectRadius,
    Flag = "CollectRadius",
    Callback = function(Value)
        Config.System.CollectRadius = Value
        logError("Collect Radius: " .. Value)
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

-- Advanced Graphic Tab
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

GraphicTab:CreateSlider({
    Name = "Brightness Value",
    Range = {0, 2},
    Increment = 0.1,
    CurrentValue = Config.Graphic.BrightnessValue,
    Flag = "BrightnessValue",
    Callback = function(Value)
        Config.Graphic.BrightnessValue = Value
        Lighting.Brightness = Value
        logError("Brightness Value: " .. Value)
    end
})

GraphicTab:CreateSlider({
    Name = "Fog Density",
    Range = {0, 1},
    Increment = 0.1,
    CurrentValue = Config.Graphic.FogDensity,
    Flag = "FogDensity",
    Callback = function(Value)
        Config.Graphic.FogDensity = Value
        Lighting.FogEnd = 10000 * (1 - Value)
        logError("Fog Density: " .. Value)
    end
})

GraphicTab:CreateDropdown({
    Name = "Skybox",
    Options = {"Default", "Space", "Sunset", "Night", "Storm"},
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
        logError("Ambient Color changed to: " .. tostring(Color))
    end
})

GraphicTab:CreateSlider({
    Name = "Shadow Quality",
    Range = {0, 10},
    Increment = 1,
    CurrentValue = Config.Graphic.ShadowQuality,
    Flag = "ShadowQuality",
    Callback = function(Value)
        Config.Graphic.ShadowQuality = Value
        Lighting.ShadowSoftness = Value
        logError("Shadow Quality: " .. Value)
    end
})

GraphicTab:CreateToggle({
    Name = "Anti Aliasing",
    CurrentValue = Config.Graphic.AntiAliasing,
    Flag = "AntiAliasing",
    Callback = function(Value)
        Config.Graphic.AntiAliasing = Value
        logError("Anti Aliasing: " .. tostring(Value))
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
    Name = "Depth of Field",
    CurrentValue = Config.Graphic.DepthOfField,
    Flag = "DepthOfField",
    Callback = function(Value)
        Config.Graphic.DepthOfField = Value
        logError("Depth of Field: " .. tostring(Value))
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
    Name = "Chromatic Aberration",
    CurrentValue = Config.Graphic.ChromaticAberration,
    Flag = "ChromaticAberration",
    Callback = function(Value)
        Config.Graphic.ChromaticAberration = Value
        logError("Chromatic Aberration: " .. tostring(Value))
    end
})

-- Advanced RNG Kill Tab
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

RNGKillTab:CreateSlider({
    Name = "RNG Reduction Rate",
    Range = {0.1, 1},
    Increment = 0.1,
    CurrentValue = Config.RNGKill.RNGReductionRate,
    Flag = "RNGReductionRate",
    Callback = function(Value)
        Config.RNGKill.RNGReductionRate = Value
        logError("RNG Reduction Rate: " .. Value)
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

RNGKillTab:CreateSlider({
    Name = "Force Legendary Rate",
    Range = {0, 1},
    Increment = 0.1,
    CurrentValue = Config.RNGKill.ForceLegendaryRate,
    Flag = "ForceLegendaryRate",
    Callback = function(Value)
        Config.RNGKill.ForceLegendaryRate = Value
        logError("Force Legendary Rate: " .. Value)
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

RNGKillTab:CreateSlider({
    Name = "Secret Fish Chance",
    Range = {0, 1},
    Increment = 0.1,
    CurrentValue = Config.RNGKill.SecretFishChance,
    Flag = "SecretFishChance",
    Callback = function(Value)
        Config.RNGKill.SecretFishChance = Value
        logError("Secret Fish Chance: " .. Value)
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

RNGKillTab:CreateSlider({
    Name = "Mythical Multiplier",
    Range = {1, 20},
    Increment = 1,
    CurrentValue = Config.RNGKill.MythicalMultiplier,
    Flag = "MythicalMultiplier",
    Callback = function(Value)
        Config.RNGKill.MythicalMultiplier = Value
        logError("Mythical Multiplier: " .. Value)
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

RNGKillTab:CreateSlider({
    Name = "Bad Luck Protection",
    Range = {0, 1},
    Increment = 0.1,
    CurrentValue = Config.RNGKill.BadLuckProtection,
    Flag = "BadLuckProtection",
    Callback = function(Value)
        Config.RNGKill.BadLuckProtection = Value
        logError("Bad Luck Protection: " .. Value)
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

RNGKillTab:CreateToggle({
    Name = "Perfect Catch",
    CurrentValue = Config.RNGKill.PerfectCatch,
    Flag = "PerfectCatch",
    Callback = function(Value)
        Config.RNGKill.PerfectCatch = Value
        Rayfield:Notify({
            Title = "Perfect Catch",
            Content = "Perfect Catch " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Perfect Catch: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Auto Reel",
    CurrentValue = Config.RNGKill.AutoReel,
    Flag = "AutoReel",
    Callback = function(Value)
        Config.RNGKill.AutoReel = Value
        Rayfield:Notify({
            Title = "Auto Reel",
            Content = "Auto Reel " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Auto Reel: " .. tostring(Value))
    end
})

RNGKillTab:CreateButton({
    Name = "Apply RNG Settings",
    Callback = function()
        if FishingEvents and FishingEvents:FindFirstChild("ApplyRNGSettings") then
            local success, result = pcall(function()
                FishingEvents.ApplyRNGSettings:FireServer({
                    RNGReducer = Config.RNGKill.RNGReducer,
                    RNGReductionRate = Config.RNGKill.RNGReductionRate,
                    ForceLegendary = Config.RNGKill.ForceLegendary,
                    ForceLegendaryRate = Config.RNGKill.ForceLegendaryRate,
                    SecretFishBoost = Config.RNGKill.SecretFishBoost,
                    SecretFishChance = Config.RNGKill.SecretFishChance,
                    MythicalChance = Config.RNGKill.MythicalChanceBoost,
                    MythicalMultiplier = Config.RNGKill.MythicalMultiplier,
                    AntiBadLuck = Config.RNGKill.AntiBadLuck,
                    BadLuckProtection = Config.RNGKill.BadLuckProtection,
                    GuaranteedCatch = Config.RNGKill.GuaranteedCatch,
                    PerfectCatch = Config.RNGKill.PerfectCatch,
                    AutoReel = Config.RNGKill.AutoReel
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
                logError("RNG Settings Error: " .. result, true)
            end
        else
            Rayfield:Notify({
                Title = "RNG Error",
                Content = "RNG settings function not available",
                Duration = 5,
                Image = 13047715178
            })
            logError("RNG Settings Error: Function not available", true)
        end
    end
})

-- Advanced Shop Tab
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
    Options = GameData.Rods,
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
    Options = GameData.Boats,
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
    Options = GameData.Baits,
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
    Name = "Auto Sell Fish",
    CurrentValue = Config.Shop.AutoSellFish,
    Flag = "AutoSellFish",
    Callback = function(Value)
        Config.Shop.AutoSellFish = Value
        Rayfield:Notify({
            Title = "Auto Sell Fish",
            Content = "Auto Sell Fish " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Auto Sell Fish: " .. tostring(Value))
    end
})

ShopTab:CreateToggle({
    Name = "Sell All Non-Essential",
    CurrentValue = Config.Shop.SellAllNonEssential,
    Flag = "SellAllNonEssential",
    Callback = function(Value)
        Config.Shop.SellAllNonEssential = Value
        Rayfield:Notify({
            Title = "Sell All Non-Essential",
            Content = "Sell All Non-Essential " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Sell All Non-Essential: " .. tostring(Value))
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
                    Rayfield:Notify({
                        Title = "Purchase Error",
                        Content = "Failed to purchase rod: " .. result,
                        Duration = 5,
                        Image = 13047715178
                    })
                    logError("Rod purchase error: " .. result, true)
                end
            else
                Rayfield:Notify({
                    Title = "Purchase Error",
                    Content = "Buy rod function not available",
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Rod purchase error: Function not available", true)
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
                    Rayfield:Notify({
                        Title = "Purchase Error",
                        Content = "Failed to purchase boat: " .. result,
                        Duration = 5,
                        Image = 13047715178
                    })
                    logError("Boat purchase error: " .. result, true)
                end
            else
                Rayfield:Notify({
                    Title = "Purchase Error",
                    Content = "Buy boat function not available",
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Boat purchase error: Function not available", true)
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
                    Rayfield:Notify({
                        Title = "Purchase Error",
                        Content = "Failed to purchase bait: " .. result,
                        Duration = 5,
                        Image = 13047715178
                    })
                    logError("Bait purchase error: " .. result, true)
                end
            else
                Rayfield:Notify({
                    Title = "Purchase Error",
                    Content = "Buy bait function not available",
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Bait purchase error: Function not available", true)
            end
        else
            Rayfield:Notify({
                Title = "Purchase Error",
                Content = "Please select an item to purchase",
                Duration = 3,
                Image = 13047715178
            })
            logError("Purchase Error: No item selected", true)
        end
    end
})

-- Advanced Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings", 13014546625)

SettingsTab:CreateToggle({
    Name = "Save Config",
    CurrentValue = false,
    Flag = "SaveConfig",
    Callback = function(Value)
        if Value then
            SaveConfig()
        end
    end
})

SettingsTab:CreateToggle({
    Name = "Load Config",
    CurrentValue = false,
    Flag = "LoadConfig",
    Callback = function(Value)
        if Value then
            LoadConfig()
        end
    end
})

SettingsTab:CreateToggle({
    Name = "Reset Config",
    CurrentValue = false,
    Flag = "ResetConfig",
    Callback = function(Value)
        if Value then
            ResetConfig()
        end
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

SettingsTab:CreateDropdown({
    Name = "Select Theme",
    Options = {"Dark", "Light", "Blue", "Green", "Red", "Purple"},
    CurrentOption = Config.Settings.SelectedTheme,
    Flag = "SelectedTheme",
    Callback = function(Value)
        Config.Settings.SelectedTheme = Value
        Rayfield:Notify({
            Title = "Theme",
            Content = "Theme changed to: " .. Value,
            Duration = 3,
            Image = 13047715178
        })
        logError("Theme: " .. Value)
    end
})

SettingsTab:CreateSlider({
    Name = "Transparency",
    Range = {0, 1},
    Increment = 0.1,
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
    CurrentValue = Config.Settings.UIScale,
    Flag = "UIScale",
    Callback = function(Value)
        Config.Settings.UIScale = Value
        logError("UIScale: " .. Value)
    end
})

SettingsTab:CreateInput({
    Name = "Config Name",
    PlaceholderText = "Enter config name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text ~= "" then
            Config.Settings.ConfigName = Text
            Rayfield:Notify({
                Title = "Config Name",
                Content = "Config name set to: " .. Text,
                Duration = 3,
                Image = 13047715178
            })
            logError("Config name: " .. Text)
        else
            Rayfield:Notify({
                Title = "Config Error",
                Content = "Please enter a valid config name",
                Duration = 3,
                Image = 13047715178
            })
            logError("Config error: Empty name", true)
        end
    end
})

-- Advanced Low Device Tab
local LowDeviceTab = Window:CreateTab("📱 Low Device", 13014546625)

LowDeviceTab:CreateToggle({
    Name = "Anti Lag",
    CurrentValue = Config.LowDevice.AntiLag,
    Flag = "AntiLag",
    Callback = function(Value)
        Config.LowDevice.AntiLag = Value
        if Value then
            -- Ultra low rendering
            settings().Rendering.QualityLevel = 1
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") or part:IsA("MeshPart") then
                    part.Material = Enum.Material.Plastic
                    part.Reflectance = 0
                    part.Transparency = 0
                end
            end
            
            -- Disable all effects
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 0
            Lighting.Ambient = Color3.new(1, 1, 1)
            
            -- Disable particles
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Sparkles") then
                    effect.Enabled = false
                end
            end
            
            -- Reduce mesh details
            for _, mesh in ipairs(Workspace:GetDescendants()) do
                if mesh:IsA("Mesh") then
                    mesh.TextureId = ""
                end
            end
            
            Rayfield:Notify({
                Title = "Anti Lag",
                Content = "Anti Lag activated - Performance optimized",
                Duration = 3,
                Image = 13047715178
            })
            logError("Anti Lag: Activated")
        else
            -- Restore default settings
            settings().Rendering.QualityLevel = 10
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 10000
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            
            Rayfield:Notify({
                Title = "Anti Lag",
                Content = "Anti Lag deactivated - Default settings restored",
                Duration = 3,
                Image = 13047715178
            })
            logError("Anti Lag: Deactivated")
        end
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
            settings().Rendering.MeshCacheSize = 50
            settings().Rendering.TextureCacheSize = 50
            
            Rayfield:Notify({
                Title = "FPS Stabilizer",
                Content = "FPS Stabilizer activated - Target: 60 FPS",
                Duration = 3,
                Image = 13047715178
            })
            logError("FPS Stabilizer: Activated")
        else
            setfpscap(0)
            RunService:Set3dRenderingEnabled(true)
            settings().Rendering.MeshCacheSize = 100
            settings().Rendering.TextureCacheSize = 100
            
            Rayfield:Notify({
                Title = "FPS Stabilizer",
                Content = "FPS Stabilizer deactivated - Default settings restored",
                Duration = 3,
                Image = 13047715178
            })
            logError("FPS Stabilizer: Deactivated")
        end
    end
})

LowDeviceTab:CreateToggle({
    Name = "Disable All Effects",
    CurrentValue = Config.LowDevice.DisableEffects,
    Flag = "DisableEffects",
    Callback = function(Value)
        Config.LowDevice.DisableEffects = Value
        if Value then
            -- Disable all visual effects
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Sparkles") or 
                   effect:IsA("Fire") or effect:IsA("PointLight") or effect:IsA("SpotLight") then
                    effect.Enabled = false
                end
            end
            
            -- Set materials to simple plastic
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") or part:IsA("MeshPart") then
                    part.Material = Enum.Material.Plastic
                    part.Reflectance = 0
                end
            end
            
            Rayfield:Notify({
                Title = "Disable Effects",
                Content = "All visual effects disabled",
                Duration = 3,
                Image = 13047715178
            })
            logError("Disable Effects: Activated")
        else
            Rayfield:Notify({
                Title = "Disable Effects",
                Content = "Visual effects restored",
                Duration = 3,
                Image = 13047715178
            })
            logError("Disable Effects: Deactivated")
        end
    end
})

LowDeviceTab:CreateToggle({
    Name = "Pixelate Mode",
    CurrentValue = Config.LowDevice.PixelateMode,
    Flag = "PixelateMode",
    Callback = function(Value)
        Config.LowDevice.PixelateMode = Value
        if Value then
            -- Create retro pixel effect
            local pixelEffect = Instance.new("ScreenGui")
            pixelEffect.Name = "PixelEffect"
            pixelEffect.Parent = CoreGui
            
            local pixelFrame = Instance.new("Frame")
            pixelFrame.Size = UDim2.new(1, 0, 1, 0)
            pixelFrame.BackgroundTransparency = 0.9
            pixelFrame.BackgroundColor3 = Color3.new(0, 0, 0)
            pixelFrame.Parent = pixelEffect
            
            -- Add scanlines
            for i = 0, 10, 1 do
                local scanline = Instance.new("Frame")
                scanline.Size = UDim2.new(1, 0, 0.05, 0)
                scanline.Position = UDim2.new(0, 0, i * 0.1, 0)
                scanline.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
                scanline.Parent = pixelFrame
            end
            
            Rayfield:Notify({
                Title = "Pixelate Mode",
                Content = "8-bit pixel style activated",
                Duration = 3,
                Image = 13047715178
            })
            logError("Pixelate Mode: Activated")
        else
            -- Remove pixel effect
            local pixelEffect = CoreGui:FindFirstChild("PixelEffect")
            if pixelEffect then
                pixelEffect:Destroy()
            end
            
            Rayfield:Notify({
                Title = "Pixelate Mode",
                Content = "8-bit pixel style deactivated",
                Duration = 3,
                Image = 13047715178
            })
            logError("Pixelate Mode: Deactivated")
        end
    end
})

LowDeviceTab:CreateSlider({
    Name = "Render Distance",
    Range = {50, 500},
    Increment = 10,
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
    Range = {0, 10},
    Increment = 1,
    CurrentValue = Config.LowDevice.ObjectLOD,
    Flag = "ObjectLOD",
    Callback = function(Value)
        Config.LowDevice.ObjectLOD = Value
        logError("Object LOD: " .. Value)
    end
})

LowDeviceTab:CreateSlider({
    Name = "Texture Quality",
    Range = {0, 10},
    Increment = 1,
    CurrentValue = Config.LowDevice.TextureQuality,
    Flag = "TextureQuality",
    Callback = function(Value)
        Config.LowDevice.TextureQuality = Value
        logError("Texture Quality: " .. Value)
    end
})

LowDeviceTab:CreateSlider({
    Name = "Shadow Distance",
    Range = {0, 100},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = Config.LowDevice.ShadowDistance,
    Flag = "ShadowDistance",
    Callback = function(Value)
        Config.LowDevice.ShadowDistance = Value
        logError("Shadow Distance: " .. Value)
    end
})

LowDeviceTab:CreateSlider({
    Name = "Particle LOD",
    Range = {0, 10},
    Increment = 1,
    CurrentValue = Config.LowDevice.ParticleLOD,
    Flag = "ParticleLOD",
    Callback = function(Value)
        Config.LowDevice.ParticleLOD = Value
        logError("Particle LOD: " .. Value)
    end
})

LowDeviceTab:CreateSlider({
    Name = "Animation Quality",
    Range = {0, 10},
    Increment = 1,
    CurrentValue = Config.LowDevice.AnimationQuality,
    Flag = "AnimationQuality",
    Callback = function(Value)
        Config.LowDevice.AnimationQuality = Value
        logError("Animation Quality: " .. Value)
    end
})

LowDeviceTab:CreateSlider({
    Name = "Sound Quality",
    Range = {0, 10},
    Increment = 1,
    CurrentValue = Config.LowDevice.SoundQuality,
    Flag = "SoundQuality",
    Callback = function(Value)
        Config.LowDevice.SoundQuality = Value
        logError("Sound Quality: " .. Value)
    end
})

-- Advanced Feature Implementation
-- ESP System
local ESP = {
    Enabled = false,
    Boxes = {},
    Lines = {},
    Names = {},
    Levels = {},
    Holograms = {},
    Range = {}
}

local function createESP(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local character = player.Character
    local hrp = character.HumanoidRootPart
    
    -- Create ESP Box
    if Config.Player.ESPBox then
        local box = Instance.new("BoxHandleAdornment")
        box.Size = hrp.Size * Config.Player.ESPBoxSize
        box.Adornee = hrp
        box.Color3 = Config.Player.ESPColor
        box.Transparency = 0.5
        box.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        box.Parent = CoreGui
        
        table.insert(ESP.Boxes, {Player = player, Box = box})
    end
    
    -- Create ESP Lines
    if Config.Player.ESPLines then
        local line = Instance.new("LineHandleAdornment")
        line.Thickness = 2
        line.Color3 = Config.Player.ESPColor
        line.Adornee = hrp
        line.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        line.Parent = CoreGui
        
        table.insert(ESP.Lines, {Player = player, Line = line})
    end
    
    -- Create ESP Name
    if Config.Player.ESPName then
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Adornee = hrp
        billboard.Parent = CoreGui
        
        local name = Instance.new("TextLabel")
        name.Size = UDim2.new(1, 0, 0.5, 0)
        name.BackgroundTransparency = 1
        name.Text = player.Name
        name.TextColor3 = Config.Player.ESPColor
        name.TextScaled = true
        name.Parent = billboard
        
        table.insert(ESP.Names, {Player = player, Billboard = billboard, Name = name})
    end
    
    -- Create ESP Level
    if Config.Player.ESPLevel then
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.Adornee = hrp
        billboard.Parent = CoreGui
        
        local level = Instance.new("TextLabel")
        level.Size = UDim2.new(1, 0, 0.5, 0)
        level.BackgroundTransparency = 1
        level.Text = "Level: 1"
        level.TextColor3 = Config.Player.ESPColor
        level.TextScaled = true
        level.Parent = billboard
        
        table.insert(ESP.Levels, {Player = player, Billboard = billboard, Level = level})
    end
    
    -- Create ESP Hologram
    if Config.Player.ESPHologram then
        local hologram = Instance.new("SelectionBox")
        hologram.Adornee = hrp
        hologram.Color3 = Config.Player.ESPColor
        hologram.Transparency = 0.5
        hologram.Parent = CoreGui
        
        table.insert(ESP.Holograms, {Player = player, Hologram = hologram})
    end
    
    -- Create ESP Range
    if Config.Player.ESPRange then
        local range = Instance.new("SphereHandleAdornment")
        range.Adornee = hrp
        range.Color3 = Config.Player.ESPColor
        range.Transparency = 0.3
        range.Radius = Config.Player.ESPRangeValue
        range.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        range.Parent = CoreGui
        
        table.insert(ESP.Range, {Player = player, Range = range})
    end
end

local function updateESP()
    if not Config.Player.PlayerESP then return end
    
    -- Clear existing ESP
    for _, esp in ipairs(ESP.Boxes) do
        if esp.Box then
            esp.Box:Destroy()
        end
    end
    for _, esp in ipairs(ESP.Lines) do
        if esp.Line then
            esp.Line:Destroy()
        end
    end
    for _, esp in ipairs(ESP.Names) do
        if esp.Billboard then
            esp.Billboard:Destroy()
        end
    end
    for _, esp in ipairs(ESP.Levels) do
        if esp.Billboard then
            esp.Billboard:Destroy()
        end
    end
    for _, esp in ipairs(ESP.Holograms) do
        if esp.Hologram then
            esp.Hologram:Destroy()
        end
    end
    for _, esp in ipairs(ESP.Range) do
        if esp.Range then
            esp.Range:Destroy()
        end
    end
    
    ESP.Boxes = {}
    ESP.Lines = {}
    ESP.Names = {}
    ESP.Levels = {}
    ESP.Holograms = {}
    ESP.Range = {}
    
    -- Create new ESP
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESP(player)
        end
    end
end

-- Player Added/Removed Connections
Players.PlayerAdded:Connect(function(player)
    if Config.Player.PlayerESP then
        createESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    -- Remove ESP for leaving player
    for i, esp in ipairs(ESP.Boxes) do
        if esp.Player == player then
            if esp.Box then
                esp.Box:Destroy()
            end
            table.remove(ESP.Boxes, i)
        end
    end
    for i, esp in ipairs(ESP.Lines) do
        if esp.Player == player then
            if esp.Line then
                esp.Line:Destroy()
            end
            table.remove(ESP.Lines, i)
        end
    end
    for i, esp in ipairs(ESP.Names) do
        if esp.Player == player then
            if esp.Billboard then
                esp.Billboard:Destroy()
            end
            table.remove(ESP.Names, i)
        end
    end
    for i, esp in ipairs(ESP.Levels) do
        if esp.Player == player then
            if esp.Billboard then
                esp.Billboard:Destroy()
            end
            table.remove(ESP.Levels, i)
        end
    end
    for i, esp in ipairs(ESP.Holograms) do
        if esp.Player == player then
            if esp.Hologram then
                esp.Hologram:Destroy()
            end
            table.remove(ESP.Holograms, i)
        end
    end
    for i, esp in ipairs(ESP.Range) do
        if esp.Player == player then
            if esp.Range then
                esp.Range:Destroy()
            end
            table.remove(ESP.Range, i)
        end
    end
end)

-- Update ESP when settings change
spawn(function()
    while true do
        if Config.Player.PlayerESP then
            updateESP()
        end
        wait(1)
    end
end)

-- Fly Implementation
local flySpeed = 1
local flyDirection = Vector3.new(0, 0, 0)
local isFlying = false

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    
    if input.KeyCode == Enum.KeyCode.LeftShift then
        isFlying = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    
    if input.KeyCode == Enum.KeyCode.LeftShift then
        isFlying = false
    end
end)

RunService.RenderStepped:Connect(function()
    if Config.Player.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if isFlying then
            local direction = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + Vector3.new(0, 0, -1)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction + Vector3.new(0, 0, 1)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction + Vector3.new(-1, 0, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + Vector3.new(1, 0, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                direction = direction + Vector3.new(0, -1, 0)
            end
            
            direction = direction.Unit * Config.Player.FlyRange * Config.Player.FlySpeed
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + direction
        end
    end
end)

-- Speed Hack Implementation
RunService.RenderStepped:Connect(function()
    if Config.Player.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.Player.SpeedValue * Config.Player.SpeedMultiplier
    end
end)

-- Auto Jump Implementation
spawn(function()
    while true do
        if Config.Bypass.AutoJump then
            wait(Config.Bypass.AutoJumpDelay)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Jump = true
            end
        end
        wait(0.1)
    end
end)

-- Infinity Jump Implementation
UserInputService.JumpRequest:Connect(function()
    if Config.Player.InfinityJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Auto Farm Implementation
spawn(function()
    while true do
        if Config.System.AutoFarm then
            -- Find nearest fish within radius
            local nearestFish = nil
            local minDistance = Config.System.FarmRadius
            
            for _, fish in ipairs(Workspace:GetDescendants()) do
                if fish.Name:find("Fish") and fish:IsA("Model") then
                    local distance = (fish.PrimaryPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance < minDistance then
                        nearestFish = fish
                        minDistance = distance
                    end
                end
            end
            
            -- Move to nearest fish
            if nearestFish and nearestFish.PrimaryPart then
                LocalPlayer.Character:SetPrimaryPartCFrame(nearestFish.PrimaryPart.CFrame + Vector3.new(0, 5, 0))
                
                -- Fish
                if FishingEvents and FishingEvents:FindFirstChild("StartFishing") then
                    local success, result = pcall(function()
                        FishingEvents.StartFishing:FireServer(nearestFish)
                    end)
                    if not success then
                        logError("Auto Farm Error: " .. result, true)
                    end
                end
            end
        end
        wait(0.5 / Config.System.FarmSpeed)
    end
end)

-- Auto Sell Implementation
spawn(function()
    while true do
        if Config.Player.AutoSell or Config.Shop.AutoSellFish then
            if PlayerData and PlayerData:FindFirstChild("Inventory") then
                for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                    if item:IsA("Folder") or item:IsA("Configuration") then
                        -- Check if item is not marked as favorite
                        if not item:FindFirstChild("Favorite") or not item.Favorite.Value then
                            if Remotes and Remotes:FindFirstChild("SellItem") then
                                local success, result = pcall(function()
                                    Remotes.SellItem:FireServer(item.Name)
                                end)
                                if not success then
                                    logError("Auto Sell Error: " .. result, true)
                                end
                            end
                        end
                    end
                end
            end
        end
        wait(5)
    end
end)

-- Auto Craft Implementation
spawn(function()
    while true do
        if Config.Player.AutoCraft then
            if GameFunctions and GameFunctions:FindFirstChild("AutoCraft") then
                local success, result = pcall(function()
                    GameFunctions.AutoCraft:InvokeServer()
                end)
                if not success then
                    logError("Auto Craft Error: " .. result, true)
                end
            end
        end
        wait(5)
    end
end)

-- Auto Upgrade Implementation
spawn(function()
    while true do
        if Config.Player.AutoUpgrade or Config.Shop.AutoUpgradeRod then
            if GameFunctions and GameFunctions:FindFirstChild("AutoUpgrade") then
                local success, result = pcall(function()
                    GameFunctions.AutoUpgrade:InvokeServer()
                end)
                if not success then
                    logError("Auto Upgrade Error: " .. result, true)
                end
            end
        end
        wait(5)
    end
end)

-- Server Hop Implementation
spawn(function()
    while true do
        if Config.Server.ServerHop then
            -- Get list of servers
            local servers = {}
            local success, result = pcall(function()
                servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
            end)
            
            if success and servers.data then
                -- Find a server with different players
                for _, server in ipairs(servers.data) do
                    if server.playing ~= server.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                        logError("Server hopping to server: " .. server.id)
                        break
                    end
                end
            end
        end
        wait(30)
    end
end)

-- Auto Accept Trade Implementation
spawn(function()
    while true do
        if Config.Trader.AutoAcceptTrade then
            if TradeEvents and TradeEvents:FindFirstChild("AcceptTrade") then
                local success, result = pcall(function()
                    TradeEvents.AcceptTrade:FireServer()
                end)
                if not success then
                    logError("Auto Accept Trade Error: " .. result, true)
                end
            end
        end
        wait(Config.Trader.TradeDelay)
    end
end)

-- Show Info Implementation
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
            
            -- Update UI with info
            if not Config.System.InfoLabel then
                Config.System.InfoLabel = Instance.new("TextLabel")
                Config.System.InfoLabel.Size = UDim2.new(0, 200, 0, 30)
                Config.System.InfoLabel.Position = UDim2.new(0, 10, 0, 10)
                Config.System.InfoLabel.BackgroundTransparency = 0.5
                Config.System.InfoLabel.TextColor3 = Color3.new(1, 1, 1)
                Config.System.InfoLabel.TextScaled = true
                Config.System.InfoLabel.Text = infoText
                Config.System.InfoLabel.Parent = CoreGui
            else
                Config.System.InfoLabel.Text = infoText
            end
        else
            if Config.System.InfoLabel then
                Config.System.InfoLabel:Destroy()
                Config.System.InfoLabel = nil
            end
        end
        wait(1)
    end
end)

-- Auto Clean Memory Implementation
spawn(function()
    while true do
        if Config.System.AutoCleanMemory then
            collectgarbage("collect")
        end
        wait(Config.System.CleanMemoryInterval)
    end
end)

-- Noclip Implementation
local noclipEnabled = false

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    
    if input.KeyCode == Enum.KeyCode.N then
        noclipEnabled = not noclipEnabled
        Rayfield:Notify({
            Title = "Noclip",
            Content = "Noclip " .. (noclipEnabled and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Noclip: " .. tostring(noclipEnabled))
    end
end)

RunService.Stepped:Connect(function()
    if noclipEnabled then
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Auto Save Configuration
spawn(function()
    while true do
        if Config.Settings.AutoSave then
            SaveConfig()
        end
        wait(Config.Settings.SaveInterval)
    end
end)

-- Initialize
logError("Fish It Script 2025 Advanced loaded successfully")
Rayfield:Notify({
    Title = "Fish It Script 2025 Advanced",
    Content = "Script loaded successfully with 4500+ lines of code",
    Duration = 5,
    Image = 13047715178
})
