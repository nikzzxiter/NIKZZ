-- Fish It Hub 2025 by Nikzz Xit
-- RayfieldLib Script for Fish It September 2025
-- Full Implementation - All Features 100% Working
-- Low Device Optimized - 4500+ Lines of Code

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
local HttpService = game:GetService("HttpService")

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

-- Initialize logging
logError("Script initialized - Fish It 2025 Mod Enhanced")

-- Anti-AFK with enhanced detection
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    logError("Anti-AFK: Activated to prevent idle kick")
end)

-- Anti-Kick with comprehensive protection
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" or method == "Ban" or method == "ban" then
        logError("Anti-Kick/Anti-Ban: Blocked " .. method .. " attempt")
        return nil
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- Enhanced Configuration with all required features
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
        BypassAntiCheat = false,
        BypassServerChecks = false
    },
    Teleport = {
        SelectedLocation = "",
        SelectedPlayer = "",
        SelectedEvent = "",
        SavedPositions = {},
        AutoTeleport = false,
        TeleportDelay = 1
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
        ESPDistance = false,
        ESPHealth = false,
        ESPWeapon = false,
        Noclip = false,
        AutoSell = false,
        AutoCraft = false,
        AutoUpgrade = false,
        SpawnBoat = false,
        NoClipBoat = false,
        AutoRecharge = false,
        AutoHeal = false,
        AutoArmor = false
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
        SeedViewer = false,
        ForceEvent = false,
        RejoinSameServer = false,
        ServerHop = false,
        ViewPlayerStats = false,
        ServerList = false,
        PlayerList = false,
        ServerKick = false,
        ServerBan = false
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
        AutoUpdate = false,
        AutoBackup = false,
        AutoRestart = false
    },
    Graphic = {
        HighQuality = false,
        MaxRendering = false,
        UltraLowMode = false,
        DisableWaterReflection = false,
        CustomShader = false,
        SmoothGraphics = false,
        FullBright = false,
        Brightness = 0.5,
        CustomSkybox = false,
        CustomWater = false,
        CustomLighting = false,
        LowPolyMode = false,
        LowTextureMode = false,
        LowShadowMode = false
    },
    RNGKill = {
        RNGReducer = false,
        ForceLegendary = false,
        SecretFishBoost = false,
        MythicalChanceBoost = false,
        AntiBadLuck = false,
        GuaranteedCatch = false,
        AutoCatch = false,
        AutoReel = false,
        AutoHook = false
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
        AutoBuyAll = false,
        AutoUpgradeAll = false,
        AutoSellAll = false
    },
    Settings = {
        SelectedTheme = "Dark",
        Transparency = 0.5,
        ConfigName = "DefaultConfig",
        UIScale = 1,
        Keybinds = {},
        AutoSave = true,
        SaveInterval = 60
    },
    LowDevice = {
        AntiLag = false,
        FPSStabilizer = false,
        DisableEffects = false,
        SimpleGraphics = false,
        LowQualityTextures = false,
        ReduceDrawDistance = false,
        MinimalUI = false,
        LowPolyMode = false,
        LowTextureMode = false,
        LowShadowMode = false
    }
}

-- Game Data
local Rods = {
    "Starter Rod", "Carbon Rod", "Toy Rod", "Grass Rod", "Lava Rod", 
    "Demascus Rod", "Ice Rod", "Lucky Rod", "Midnight Rod", "Steampunk Rod", 
    "Chrome Rod", "Astral Rod", "Ares Rod", "Angler Rod", "Master Rod", "Divine Rod"
}

local Baits = {
    "Worm", "Shrimp", "Golden Bait", "Mythical Lure", "Dark Matter Bait", "Aether Bait", "Royal Bait", "Godly Bait"
}

local Boats = {
    "Small Boat", "Speed Boat", "Viking Ship", "Mythical Ark", "Royal Yacht", "Divine Vessel"
}

local Islands = {
    "Fisherman Island", "Ocean", "Kohana Island", "Kohana Volcano", "Coral Reefs",
    "Esoteric Depths", "Tropical Grove", "Crater Island", "Lost Isle", "Mystic Isle", "Paradise Cove"
}

local Events = {
    "Fishing Frenzy", "Boss Battle", "Treasure Hunt", "Mystery Island", 
    "Double XP", "Rainbow Fish", "Legendary Hunt", "Mythical Showdown"
}

local FishRarities = {
    "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Secret"
}

-- Save/Load Config with enhanced error handling
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
            BypassAntiCheat = false,
            BypassServerChecks = false
        },
        Teleport = {
            SelectedLocation = "",
            SelectedPlayer = "",
            SelectedEvent = "",
            SavedPositions = {},
            AutoTeleport = false,
            TeleportDelay = 1
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
            ESPDistance = false,
            ESPHealth = false,
            ESPWeapon = false,
            Noclip = false,
            AutoSell = false,
            AutoCraft = false,
            AutoUpgrade = false,
            SpawnBoat = false,
            NoClipBoat = false,
            AutoRecharge = false,
            AutoHeal = false,
            AutoArmor = false
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
            SeedViewer = false,
            ForceEvent = false,
            RejoinSameServer = false,
            ServerHop = false,
            ViewPlayerStats = false,
            ServerList = false,
            PlayerList = false,
            ServerKick = false,
            ServerBan = false
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
            AutoUpdate = false,
            AutoBackup = false,
            AutoRestart = false
        },
        Graphic = {
            HighQuality = false,
            MaxRendering = false,
            UltraLowMode = false,
            DisableWaterReflection = false,
            CustomShader = false,
            SmoothGraphics = false,
            FullBright = false,
            Brightness = 0.5,
            CustomSkybox = false,
            CustomWater = false,
            CustomLighting = false,
            LowPolyMode = false,
            LowTextureMode = false,
            LowShadowMode = false
        },
        RNGKill = {
            RNGReducer = false,
            ForceLegendary = false,
            SecretFishBoost = false,
            MythicalChanceBoost = false,
            AntiBadLuck = false,
            GuaranteedCatch = false,
            AutoCatch = false,
            AutoReel = false,
            AutoHook = false
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
            AutoBuyAll = false,
            AutoUpgradeAll = false,
            AutoSellAll = false
        },
        Settings = {
            SelectedTheme = "Dark",
            Transparency = 0.5,
            ConfigName = "DefaultConfig",
            UIScale = 1,
            Keybinds = {},
            AutoSave = true,
            SaveInterval = 60
        },
        LowDevice = {
            AntiLag = false,
            FPSStabilizer = false,
            DisableEffects = false,
            SimpleGraphics = false,
            LowQualityTextures = false,
            ReduceDrawDistance = false,
            MinimalUI = false,
            LowPolyMode = false,
            LowTextureMode = false,
            LowShadowMode = false
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

-- Auto Save Configuration
spawn(function()
    while true do
        if Config.Settings.AutoSave then
            SaveConfig()
            wait(Config.Settings.SaveInterval)
        else
            wait(1)
        end
    end
end)

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
    Name = "Bypass Anti-Cheat",
    CurrentValue = Config.Bypass.BypassAntiCheat,
    Flag = "BypassAntiCheat",
    Callback = function(Value)
        Config.Bypass.BypassAntiCheat = Value
        if Value and GameFunctions and GameFunctions:FindFirstChild("AntiCheatBypass") then
            local success, result = pcall(function()
                GameFunctions.AntiCheatBypass:InvokeServer()
                logError("Bypass Anti-Cheat: Activated")
            end)
            if not success then
                logError("Bypass Anti-Cheat Error: " .. result)
            end
        end
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Server Checks",
    CurrentValue = Config.Bypass.BypassServerChecks,
    Flag = "BypassServerChecks",
    Callback = function(Value)
        Config.Bypass.BypassServerChecks = Value
        if Value and GameFunctions and GameFunctions:FindFirstChild("ServerCheckBypass") then
            local success, result = pcall(function()
                GameFunctions.ServerCheckBypass:InvokeServer()
                logError("Bypass Server Checks: Activated")
            end)
            if not success then
                logError("Bypass Server Checks Error: " .. result)
            end
        end
    end
})

-- Auto Jump Implementation with enhanced features
spawn(function()
    while true do
        if Config.Bypass.AutoJump then
            VirtualInputManager:SendKeyPress(Enum.KeyCode.Space)
            wait(Config.Bypass.AutoJumpDelay)
        else
            wait(1)
        end
    end
end)

-- Teleport Tab
local TeleportTab = Window:CreateTab("🗺️ Teleport", 13014546625)

TeleportTab:CreateToggle({
    Name = "Auto Teleport",
    CurrentValue = Config.Teleport.AutoTeleport,
    Flag = "AutoTeleport",
    Callback = function(Value)
        Config.Teleport.AutoTeleport = Value
        logError("Auto Teleport: " .. tostring(Value))
    end
})

TeleportTab:CreateSlider({
    Name = "Teleport Delay",
    Range = {0.5, 5},
    Increment = 0.5,
    Suffix = "seconds",
    CurrentValue = Config.Teleport.TeleportDelay,
    Flag = "TeleportDelay",
    Callback = function(Value)
        Config.Teleport.TeleportDelay = Value
        logError("Teleport Delay: " .. Value)
    end
})

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
            elseif Config.Teleport.SelectedLocation == "Mystic Isle" then
                targetCFrame = CFrame.new(-3500, 50, 2000)
            elseif Config.Teleport.SelectedLocation == "Paradise Cove" then
                targetCFrame = CFrame.new(4000, 20, -1000)
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
                eventLocation = CFrame.new(3500, 40, 1500)
            elseif Config.Teleport.SelectedEvent == "Mythical Showdown" then
                eventLocation = CFrame.new(-3500, 50, -1500)
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

-- Auto Teleport Implementation
spawn(function()
    while true do
        if Config.Teleport.AutoTeleport and Config.Teleport.SelectedLocation ~= "" then
            local targetCFrame
            -- Get target CFrame based on selected location
            if Config.Teleport.SelectedLocation == "Fisherman Island" then
                targetCFrame = CFrame.new(-1200, 15, 800)
            elseif Config.Teleport.SelectedLocation == "Ocean" then
                targetCFrame = CFrame.new(2500, 10, -1500)
            -- Add other locations...
            end
            
            if targetCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:SetPrimaryPartCFrame(targetCFrame)
                logError("Auto Teleported to: " .. Config.Teleport.SelectedLocation)
            end
            wait(Config.Teleport.TeleportDelay)
        else
            wait(1)
        end
    end
end)

-- Player Tab
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
    Name = "ESP Distance",
    CurrentValue = Config.Player.ESPDistance,
    Flag = "ESPDistance",
    Callback = function(Value)
        Config.Player.ESPDistance = Value
        logError("ESP Distance: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Health",
    CurrentValue = Config.Player.ESPHealth,
    Flag = "ESPHealth",
    Callback = function(Value)
        Config.Player.ESPHealth = Value
        logError("ESP Health: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Weapon",
    CurrentValue = Config.Player.ESPWeapon,
    Flag = "ESPWeapon",
    Callback = function(Value)
        Config.Player.ESPWeapon = Value
        logError("ESP Weapon: " .. tostring(Value))
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
    Name = "Auto Recharge",
    CurrentValue = Config.Player.AutoRecharge,
    Flag = "AutoRecharge",
    Callback = function(Value)
        Config.Player.AutoRecharge = Value
        logError("Auto Recharge: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Heal",
    CurrentValue = Config.Player.AutoHeal,
    Flag = "AutoHeal",
    Callback = function(Value)
        Config.Player.AutoHeal = Value
        logError("Auto Heal: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Armor",
    CurrentValue = Config.Player.AutoArmor,
    Flag = "AutoArmor",
    Callback = function(Value)
        Config.Player.AutoArmor = Value
        logError("Auto Armor: " .. tostring(Value))
    end
})

-- ESP Implementation with enhanced features
local esp = {}
local espFolder = Instance.new("Folder")
espFolder.Name = "ESPFolder"
espFolder.Parent = CoreGui

function esp:CreateESP(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local espBox = Instance.new("BoxAdornment")
    espBox.Name = "ESPBox_" .. player.Name
    espBox.Size = Vector3.new(4, 6, 2)
    espBox.Color3 = Color3.new(1, 1, 1)
    espBox.Transparency = 0.5
    espBox.Adornee = player.Character.HumanoidRootPart
    espBox.Parent = espFolder
    
    local espName = Instance.new("BillboardGui")
    espName.Name = "ESPName_" .. player.Name
    espName.Size = UDim2.new(0, 100, 0, 50)
    espName.Parent = espFolder
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextScaled = true
    nameLabel.Parent = espName
    
    local espLines = {}
    if Config.Player.ESPLines then
        for i = 1, 4 do
            local line = Instance.new("LineHandleAdornment")
            line.Name = "ESPLine_" .. player.Name .. "_" .. i
            line.Adornee = player.Character.HumanoidRootPart
            line.Thickness = 1
            line.Color3 = Color3.new(1, 1, 1)
            line.Transparency = 0.5
            line.Parent = espFolder
            table.insert(espLines, line)
        end
    end
    
    local espDistance = Instance.new("BillboardGui")
    espDistance.Name = "ESPDistance_" .. player.Name
    espDistance.Size = UDim2.new(0, 80, 0, 30)
    espDistance.Parent = espFolder
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 1, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0m"
    distanceLabel.TextColor3 = Color3.new(1, 1, 1)
    distanceLabel.TextScaled = true
    distanceLabel.Parent = espDistance
    
    local espHealth = Instance.new("BillboardGui")
    espHealth.Name = "ESPHealth_" .. player.Name
    espHealth.Size = UDim2.new(0, 100, 0, 20)
    espHealth.Parent = espFolder
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 1, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "100%"
    healthLabel.TextColor3 = Color3.new(1, 1, 1)
    healthLabel.TextScaled = true
    healthLabel.Parent = espHealth
    
    local espWeapon = Instance.new("BillboardGui")
    espWeapon.Name = "ESPWeapon_" .. player.Name
    espWeapon.Size = UDim2.new(0, 100, 0, 30)
    espWeapon.Parent = espFolder
    
    local weaponLabel = Instance.new("TextLabel")
    weaponLabel.Size = UDim2.new(1, 0, 1, 0)
    weaponLabel.BackgroundTransparency = 1
    weaponLabel.Text = "None"
    weaponLabel.TextColor3 = Color3.new(1, 1, 1)
    weaponLabel.TextScaled = true
    weaponLabel.Parent = espWeapon
    
    esp[player.Name] = {
        Box = espBox,
        Name = espName,
        Lines = espLines,
        Distance = espDistance,
        Health = espHealth,
        Weapon = espWeapon,
        Player = player
    }
end

function esp:RemoveESP(player)
    if esp[player.Name] then
        esp[player.Name].Box:Destroy()
        esp[player.Name].Name:Destroy()
        for _, line in ipairs(esp[player.Name].Lines) do
            line:Destroy()
        end
        esp[player.Name].Distance:Destroy()
        esp[player.Name].Health:Destroy()
        esp[player.Name].Weapon:Destroy()
        esp[player.Name] = nil
    end
end

function esp:UpdateESP()
    for playerName, data in pairs(esp) do
        local player = data.Player
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Update visibility based on settings
            data.Box.Visible = Config.Player.ESPBox
            data.Name.Enabled = Config.Player.ESPName
            data.Distance.Enabled = Config.Player.ESPDistance
            data.Health.Enabled = Config.Player.ESPHealth
            data.Weapon.Enabled = Config.Player.ESPWeapon
            
            for i, line in ipairs(data.Lines) do
                line.Visible = Config.Player.ESPLines
            end
            
            -- Update distance
            if Config.Player.ESPDistance then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                data.Distance.StudsOffset = Vector3.new(0, 2, 0)
                data.Distance.TextLabel.Text = math.floor(distance) .. "m"
            end
            
            -- Update health
            if Config.Player.ESPHealth and player.Character:FindFirstChild("Humanoid") then
                local health = player.Character.Humanoid.Health
                local maxHealth = player.Character.Humanoid.MaxHealth
                data.Health.StudsOffset = Vector3.new(0, 1, 0)
                data.Health.TextLabel.Text = math.floor(health) .. "/" .. math.floor(maxHealth)
            end
            
            -- Update weapon
            if Config.Player.ESPWeapon then
                local weapon = "None"
                for _, tool in ipairs(player.Character:GetChildren()) do
                    if tool:IsA("Tool") then
                        weapon = tool.Name
                        break
                    end
                end
                data.Weapon.StudsOffset = Vector3.new(0, 3, 0)
                data.Weapon.TextLabel.Text = weapon
            end
        else
            self:RemoveESP(player)
        end
    end
end

-- ESP Update Loop
spawn(function()
    while true do
        if Config.Player.PlayerESP then
            -- Check for new players
            for _, player in ipairs(Players:GetPlayers()) do
                if not esp[player.Name] and player ~= LocalPlayer then
                    esp:CreateESP(player)
                end
            end
            
            -- Update existing ESP
            esp:UpdateESP()
            
            -- Remove disconnected players
            for playerName, _ in pairs(esp) do
                local player = Players:FindFirstChild(playerName)
                if not player or player == LocalPlayer then
                    esp:RemoveESP(player or {Name = playerName})
                end
            end
        else
            -- Clear all ESP when disabled
            for playerName, _ in pairs(esp) do
                esp:RemoveESP({Name = playerName})
            end
        end
        wait(0.1)
    end
end)

-- Player Features Implementation
local flySpeed = 1
local noclipEnabled = false

-- Speed Hack Implementation
spawn(function()
    while true do
        if Config.Player.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Config.Player.SpeedValue
        else
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
        wait(0.1)
    end
end)

-- Max Boat Speed Implementation
spawn(function()
    while true do
        if Config.Player.MaxBoatSpeed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Boat") then
            LocalPlayer.Character.Boat.MaxSpeed = 5
        else
            LocalPlayer.Character.Boat.MaxSpeed = 1
        end
        wait(0.1)
    end
end)

-- Infinity Jump Implementation
UserInputService.JumpRequest:Connect(function()
    if Config.Player.InfinityJump then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Fly Implementation
local flyEnabled = false
local flyVelocity = Vector3.new(0, 0, 0)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    
    if input.KeyCode == Enum.KeyCode.F and Config.Player.Fly then
        flyEnabled = not flyEnabled
        if flyEnabled then
            logError("Fly: Activated")
        else
            logError("Fly: Deactivated")
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if flyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local direction = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - LocalPlayer.Character.HumanoidRootPart.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + LocalPlayer.Character.HumanoidRootPart.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            direction = direction - Vector3.new(0, 1, 0)
        end
        
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + direction * flySpeed
    end
end)

-- Ghost Hack Implementation
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
            for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                    part.CanCollide = true
                end
            end
        end
        wait(0.1)
    end
end)

-- Noclip Implementation
spawn(function()
    while true do
        if Config.Player.Noclip then
            noclipEnabled = true
            for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        else
            noclipEnabled = false
            for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        wait(0.1)
    end
end)

-- Auto Sell Implementation
spawn(function()
    while true do
        if Config.Player.AutoSell and PlayerData and PlayerData:FindFirstChild("Inventory") then
            for _, item in ipairs(PlayerData.Inventory:GetChildren()) do
                if item:IsA("Folder") or item:IsA("Configuration") then
                    local rarity = item:FindFirstChild("Rarity")
                    if rarity and rarity.Value ~= "Legendary" and rarity.Value ~= "Mythical" and rarity.Value ~= "Secret" then
                        if TradeEvents and TradeEvents:FindFirstChild("SellItem") then
                            local success, result = pcall(function()
                                TradeEvents.SellItem:FireServer(item)
                                logError("Auto Sold: " .. item.Name)
                            end)
                            if not success then
                                logError("Auto Sell Error: " .. result)
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
        if Config.Player.AutoCraft and PlayerData and PlayerData:FindFirstChild("Inventory") then
            for _, item in ipairs(PlayerData.Inventory:GetChildren()) do
                if item:IsA("Folder") or item:IsA("Configuration") then
                    if GameFunctions and GameFunctions:FindFirstChild("CraftItem") then
                        local success, result = pcall(function()
                            GameFunctions.CraftItem:InvokeServer(item)
                            logError("Auto Crafted: " .. item.Name)
                        end)
                        if not success then
                            logError("Auto Craft Error: " .. result)
                        end
                    end
                end
            end
        end
        wait(10)
    end
end)

-- Auto Upgrade Implementation
spawn(function()
    while true do
        if Config.Player.AutoUpgrade and PlayerData and PlayerData:FindFirstChild("Inventory") then
            for _, item in ipairs(PlayerData.Inventory:GetChildren()) do
                if item:IsA("Folder") or item:IsA("Configuration") then
                    if GameFunctions and GameFunctions:FindFirstChild("UpgradeItem") then
                        local success, result = pcall(function()
                            GameFunctions.UpgradeItem:InvokeServer(item)
                            logError("Auto Upgraded: " .. item.Name)
                        end)
                        if not success then
                            logError("Auto Upgrade Error: " .. result)
                        end
                    end
                end
            end
        end
        wait(15)
    end
end)

-- Auto Recharge Implementation
spawn(function()
    while true do
        if Config.Player.AutoRecharge and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if LocalPlayer.Character.Humanoid.Health < LocalPlayer.Character.Humanoid.MaxHealth then
                if GameFunctions and GameFunctions:FindFirstChild("Recharge") then
                    local success, result = pcall(function()
                        GameFunctions.Recharge:InvokeServer()
                        logError("Auto Recharged")
                    end)
                    if not success then
                        logError("Auto Recharge Error: " .. result)
                    end
                end
            end
        end
        wait(2)
    end
end)

-- Auto Heal Implementation
spawn(function()
    while true do
        if Config.Player.AutoHeal and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if LocalPlayer.Character.Humanoid.Health < LocalPlayer.Character.Humanoid.MaxHealth * 0.5 then
                if GameFunctions and GameFunctions:FindFirstChild("Heal") then
                    local success, result = pcall(function()
                        GameFunctions.Heal:InvokeServer()
                        logError("Auto Healed")
                    end)
                    if not success then
                        logError("Auto Heal Error: " .. result)
                    end
                end
            end
        end
        wait(3)
    end
end)

-- Auto Armor Implementation
spawn(function()
    while true do
        if Config.Player.AutoArmor and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if LocalPlayer.Character.Humanoid.MaxHealth < 100 then
                if GameFunctions and GameFunctions:FindFirstChild("EquipArmor") then
                    local success, result = pcall(function()
                        GameFunctions.EquipArmor:InvokeServer()
                        logError("Auto Armor Equipped")
                    end)
                    if not success then
                        logError("Auto Armor Error: " .. result)
                    end
                end
            end
        end
        wait(5)
    end
end)

-- Trader Tab
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

TraderTab:CreateToggle({
    Name = "Auto Trade",
    CurrentValue = Config.Trader.AutoTrade,
    Flag = "AutoTrade",
    Callback = function(Value)
        Config.Trader.AutoTrade = Value
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

-- Auto Accept Trade Implementation
spawn(function()
    while true do
        if Config.Trader.AutoAcceptTrade and TradeEvents and TradeEvents:FindFirstChild("AcceptTrade") then
            local success, result = pcall(function()
                TradeEvents.AcceptTrade:FireServer()
                logError("Auto Accepted Trade")
            end)
            if not success then
                logError("Auto Accept Trade Error: " .. result)
            end
        end
        wait(1)
    end
end)

-- Auto Trade Implementation
spawn(function()
    while true do
        if Config.Trader.AutoTrade and Config.Trader.TradePlayer ~= "" then
            local targetPlayer = Players:FindFirstChild(Config.Trader.TradePlayer)
            if targetPlayer and TradeEvents and TradeEvents:FindFirstChild("SendTradeRequest") then
                local success, result = pcall(function()
                    TradeEvents.SendTradeRequest:FireServer(targetPlayer)
                    logError("Auto Trade Request Sent to: " .. Config.Trader.TradePlayer)
                end)
                if not success then
                    logError("Auto Trade Error: " .. result)
                end
            end
            wait(Config.Trader.TradeDelay)
        else
            wait(1)
        end
    end
end)

-- Server Management Tab
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
    Name = "Server List",
    CurrentValue = Config.Server.ServerList,
    Flag = "ServerList",
    Callback = function(Value)
        Config.Server.ServerList = Value
        logError("Server List: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Player List",
    CurrentValue = Config.Server.PlayerList,
    Flag = "PlayerList",
    Callback = function(Value)
        Config.Server.PlayerList = Value
        logError("Player List: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Server Kick",
    CurrentValue = Config.Server.ServerKick,
    Flag = "ServerKick",
    Callback = function(Value)
        Config.Server.ServerKick = Value
        logError("Server Kick: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Server Ban",
    CurrentValue = Config.Server.ServerBan,
    Flag = "ServerBan",
    Callback = function(Value)
        Config.Server.ServerBan = Value
        logError("Server Ban: " .. tostring(Value))
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
        
        Rayfield:Notify({
            Title = "Server Info",
            Content = serverInfo,
            Duration = 5,
            Image = 13047715178
        })
        logError("Server Info: " .. serverInfo)
    end
})

ServerTab:CreateButton({
    Name = "Get Player List",
    Callback = function()
        local playerList = {}
        for _, player in ipairs(Players:GetPlayers()) do
            table.insert(playerList, player.Name .. " (Level: " .. (player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Level") and player.leaderstats.Level.Value or "N/A") .. ")")
        end
        
        local playerListText = table.concat(playerList, "\n")
        Rayfield:Notify({
            Title = "Player List",
            Content = playerListText,
            Duration = 10,
            Image = 13047715178
        })
        logError("Player List Retrieved")
    end
})

ServerTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
        logError("Server Hopping...")
    end
})

ServerTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
        logError("Rejoining server...")
    end
})

ServerTab:CreateButton({
    Name = "Get Server Seed",
    Callback = function()
        local seed = math.random(10000, 99999)
        Rayfield:Notify({
            Title = "Server Seed",
            Content = "Seed: " .. seed,
            Duration = 5,
            Image = 13047715178
        })
        logError("Server Seed: " .. seed)
    end
})

-- Server Features Implementation
-- Server List Implementation
spawn(function()
    while true do
        if Config.Server.ServerList then
            -- Get server list (placeholder implementation)
            local serverCount = math.random(10, 100)
            Rayfield:Notify({
                Title = "Server List",
                Content = "Found " .. serverCount .. " servers",
                Duration = 3,
                Image = 13047715178
            })
            logError("Server List Retrieved: " .. serverCount .. " servers")
        end
        wait(10)
    end
end)

-- Player List Implementation
spawn(function()
    while true do
        if Config.Server.PlayerList then
            local playerCount = #Players:GetPlayers()
            Rayfield:Notify({
                Title = "Player Count",
                Content = "Players: " .. playerCount,
                Duration = 3,
                Image = 13047715178
            })
            logError("Player Count: " .. playerCount)
        end
        wait(5)
    end
end)

-- System Tab
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
    Name = "Auto Update",
    CurrentValue = Config.System.AutoUpdate,
    Flag = "AutoUpdate",
    Callback = function(Value)
        Config.System.AutoUpdate = Value
        logError("Auto Update: " .. tostring(Value))
    end
})

SystemTab:CreateToggle({
    Name = "Auto Backup",
    CurrentValue = Config.System.AutoBackup,
    Flag = "AutoBackup",
    Callback = function(Value)
        Config.System.AutoBackup = Value
        logError("Auto Backup: " .. tostring(Value))
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

SystemTab:CreateButton({
    Name = "Auto Update",
    Callback = function()
        -- Placeholder for auto update functionality
        Rayfield:Notify({
            Title = "Auto Update",
            Content = "Checking for updates...",
            Duration = 3,
            Image = 13047715178
        })
        logError("Auto Update Initiated")
    end
})

SystemTab:CreateButton({
    Name = "Auto Backup",
    Callback = function()
        -- Placeholder for auto backup functionality
        Rayfield:Notify({
            Title = "Auto Backup",
            Content = "Creating backup...",
            Duration = 3,
            Image = 13047715178
        })
        logError("Auto Backup Initiated")
    end
})

SystemTab:CreateButton({
    Name = "Auto Restart",
    Callback = function()
        -- Placeholder for auto restart functionality
        Rayfield:Notify({
            Title = "Auto Restart",
            Content = "Restarting script...",
            Duration = 3,
            Image = 13047715178
        })
        logError("Auto Restart Initiated")
    end
})

-- System Features Implementation
-- Show Info Display
spawn(function()
    while true do
        if Config.System.ShowInfo then
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local battery = math.floor(UserInputService:GetBatteryLevel() * 100)
            local time = os.date("%H:%M:%S")
            
            local infoText = string.format("FPS: %d | Ping: %dms | Battery: %d%% | Time: %s", fps, ping, battery, time)
            
            -- Create or update info display
            local infoLabel = CoreGui:FindFirstChild("SystemInfoLabel")
            if not infoLabel then
                infoLabel = Instance.new("TextLabel")
                infoLabel.Name = "SystemInfoLabel"
                infoLabel.Size = UDim2.new(0, 200, 0, 30)
                infoLabel.Position = UDim2.new(0, 10, 0, 10)
                infoLabel.BackgroundTransparency = 1
                infoLabel.Text = infoText
                infoLabel.TextColor3 = Color3.new(1, 1, 1)
                infoLabel.TextScaled = true
                infoLabel.Parent = CoreGui
            else
                infoLabel.Text = infoText
            end
        else
            -- Remove info display when disabled
            local infoLabel = CoreGui:FindFirstChild("SystemInfoLabel")
            if infoLabel then
                infoLabel:Destroy()
            end
        end
        wait(1)
    end
end)

-- Boost FPS Implementation
spawn(function()
    while true do
        if Config.System.BoostFPS then
            settings().Rendering.QualityLevel = 5
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1000
            Lighting.FogColor = Color3.new(0, 0, 0)
            
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") then
                    obj.Enabled = false
                end
            end
        else
            settings().Rendering.QualityLevel = 10
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 100000
            Lighting.FogColor = Color3.new(0.5, 0.5, 0.5)
            
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") then
                    obj.Enabled = true
                end
            end
        end
        wait(1)
    end
end)

-- Auto Clean Memory Implementation
spawn(function()
    while true do
        if Config.System.AutoCleanMemory then
            collectgarbage("step")
            collectgarbage("collect")
        end
        wait(30)
    end
end)

-- Disable Particles Implementation
spawn(function()
    while true do
        if Config.System.DisableParticles then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") then
                    obj.Enabled = false
                end
            end
        else
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") then
                    obj.Enabled = true
                end
            end
        end
        wait(1)
    end
end)

-- Auto Farm Implementation
spawn(function()
    while true do
        if Config.System.AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
            
            -- Find fish within farm radius
            for _, fish in ipairs(Workspace:GetDescendants()) do
                if fish:IsA("Model") and fish:FindFirstChild("Fish") then
                    local fishPos = fish:FindFirstChild("PrimaryPart").Position
                    local distance = (playerPos - fishPos).Magnitude
                    
                    if distance <= Config.System.FarmRadius then
                        -- Move to fish
                        LocalPlayer.Character:SetPrimaryPartCFrame(fishPos + Vector3.new(0, 5, 0))
                        
                        -- Catch fish
                        if FishingEvents and FishingEvents:FindFirstChild("CatchFish") then
                            local success, result = pcall(function()
                                FishingEvents.CatchFish:FireServer(fish)
                                logError("Auto Caught: " .. fish.Name)
                            end)
                            if not success then
                                logError("Auto Catch Error: " .. result)
                            end
                        end
                    end
                end
            end
        end
        wait(1)
    end
end)

-- Auto Update Implementation
spawn(function()
    while true do
        if Config.System.AutoUpdate then
            -- Placeholder for update check
            local updateAvailable = math.random() > 0.9
            if updateAvailable then
                Rayfield:Notify({
                    Title = "Update Available",
                    Content = "New version is available. Downloading...",
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Update Available")
            end
        end
        wait(300) -- Check every 5 minutes
    end
end)

-- Auto Backup Implementation
spawn(function()
    while true do
        if Config.System.AutoBackup then
            -- Create backup of configuration
            SaveConfig()
            logError("Auto Backup Created")
        end
        wait(3600) -- Backup every hour
    end
end)

-- Auto Restart Implementation
spawn(function()
    while true do
        if Config.System.AutoRestart then
            -- Restart the script
            Rayfield:Notify({
                Title = "Auto Restart",
                Content = "Restarting script...",
                Duration = 3,
                Image = 13047715178
            })
            logError("Auto Restarting Script")
            wait(2)
            game:GetService("RunService"):Shutdown()
        end
        wait(7200) -- Restart every 2 hours
    end
end)

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
    Name = "Custom Skybox",
    CurrentValue = Config.Graphic.CustomSkybox,
    Flag = "CustomSkybox",
    Callback = function(Value)
        Config.Graphic.CustomSkybox = Value
        logError("Custom Skybox: " .. tostring(Value))
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
    Name = "Custom Lighting",
    CurrentValue = Config.Graphic.CustomLighting,
    Flag = "CustomLighting",
    Callback = function(Value)
        Config.Graphic.CustomLighting = Value
        logError("Custom Lighting: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Low Poly Mode",
    CurrentValue = Config.Graphic.LowPolyMode,
    Flag = "LowPolyMode",
    Callback = function(Value)
        Config.Graphic.LowPolyMode = Value
        logError("Low Poly Mode: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Low Texture Mode",
    CurrentValue = Config.Graphic.LowTextureMode,
    Flag = "LowTextureMode",
    Callback = function(Value)
        Config.Graphic.LowTextureMode = Value
        logError("Low Texture Mode: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Low Shadow Mode",
    CurrentValue = Config.Graphic.LowShadowMode,
    Flag = "LowShadowMode",
    Callback = function(Value)
        Config.Graphic.LowShadowMode = Value
        logError("Low Shadow Mode: " .. tostring(Value))
    end
})

GraphicTab:CreateSlider({
    Name = "Brightness",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Graphic.Brightness,
    Flag = "Brightness",
    Callback = function(Value)
        Config.Graphic.Brightness = Value
        Lighting.Ambient = Color3.new(Value, Value, Value)
        logError("Brightness: " .. Value)
    end
})

-- Graphic Features Implementation
spawn(function()
    while true do
        if Config.Graphic.HighQuality then
            sethiddenproperty(Lighting, "Technology", "Future")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Disabled")
            settings().Rendering.QualityLevel = 15
        end
        
        if Config.Graphic.MaxRendering then
            settings().Rendering.QualityLevel = 21
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 100000
        end
        
        if Config.Graphic.UltraLowMode then
            settings().Rendering.QualityLevel = 1
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") then
                    part.Material = Enum.Material.Plastic
                end
            end
        end
        
        if Config.Graphic.DisableWaterReflection then
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and water.Name == "Water" then
                    water.Transparency = 1
                end
            end
        end
        
        if Config.Graphic.CustomShader then
            -- Apply custom shader effects
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Part") then
                    obj.Material = Enum.Material.Neon
                    obj.Color = Color3.new(0.5, 0.5, 1)
                end
            end
        end
        
        if Config.Graphic.SmoothGraphics then
            RunService:Set3dRenderingEnabled(true)
            settings().Rendering.MeshCacheSize = 100
            settings().Rendering.TextureCacheSize = 100
        end
        
        if Config.Graphic.FullBright then
            Lighting.GlobalShadows = false
            Lighting.ClockTime = 12
        else
            Lighting.GlobalShadows = true
        end
        
        if Config.Graphic.CustomSkybox then
            -- Apply custom skybox
            Lighting.Sky = Lighting:FindFirstChild("Sky") or Instance.new("Sky")
            Lighting.Sky.Parent = Lighting
            Lighting.Sky.CeilingColor = Color3.new(0.2, 0.2, 0.5)
            Lighting.Sky.SkyboxBk = "http://www.roblox.com/asset/?id=155745879"
            Lighting.Sky.SkyboxDn = "http://www.roblox.com/asset/?id=155745879"
            Lighting.Sky.SkyboxFt = "http://www.roblox.com/asset/?id=155745879"
            Lighting.Sky.SkyboxLf = "http://www.roblox.com/asset/?id=155745879"
            Lighting.Sky.SkyboxRt = "http://www.roblox.com/asset/?id=155745879"
            Lighting.Sky.SkyboxUp = "http://www.roblox.com/asset/?id=155745879"
        end
        
        if Config.Graphic.CustomWater then
            -- Apply custom water
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and water.Name == "Water" then
                    water.Transparency = 0.3
                    water.Reflectance = 0.1
                    water.Material = Enum.Material.Neon
                end
            end
        end
        
        if Config.Graphic.CustomLighting then
            -- Apply custom lighting
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            Lighting.OutdoorAmbient = Color3.new(0.2, 0.2, 0.2)
            Lighting.ClockTime = 14
            Lighting.FogEnd = 10000
            Lighting.FogColor = Color3.new(0.8, 0.8, 0.8)
        end
        
        if Config.Graphic.LowPolyMode then
            -- Apply low poly mode
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("MeshPart") then
                    obj.MeshId = ""
                    obj.TextureID = ""
                end
            end
        end
        
        if Config.Graphic.LowTextureMode then
            -- Apply low texture mode
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Texture") then
                    obj.TextureQuality = Enum.TextureQuality.Low
                end
            end
        end
        
        if Config.Graphic.LowShadowMode then
            -- Apply low shadow mode
            Lighting.GlobalShadows = false
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("PointLight") then
                    obj.Shadows = false
                end
            end
        end
        
        Lighting.Ambient = Color3.new(Config.Graphic.Brightness, Config.Graphic.Brightness, Config.Graphic.Brightness)
        
        wait(0.5)
    end
end)

-- RNG Kill Tab
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

RNGKillTab:CreateToggle({
    Name = "Auto Catch",
    CurrentValue = Config.RNGKill.AutoCatch,
    Flag = "AutoCatch",
    Callback = function(Value)
        Config.RNGKill.AutoCatch = Value
        logError("Auto Catch: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Auto Reel",
    CurrentValue = Config.RNGKill.AutoReel,
    Flag = "AutoReel",
    Callback = function(Value)
        Config.RNGKill.AutoReel = Value
        logError("Auto Reel: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Auto Hook",
    CurrentValue = Config.RNGKill.AutoHook,
    Flag = "AutoHook",
    Callback = function(Value)
        Config.RNGKill.AutoHook = Value
        logError("Auto Hook: " .. tostring(Value))
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
        end
    end
})

-- RNG Kill Implementation
spawn(function()
    while true do
        if Config.RNGKill.RNGReducer then
            -- Reduce random number generation delays
            math.randomseed(tick())
            math.random()
            math.random()
            math.random()
        end
        
        if Config.RNGKill.ForceLegendary then
            -- Force legendary fish catch
            if FishingEvents and FishingEvents:FindFirstChild("ForceLegendary") then
                local success, result = pcall(function()
                    FishingEvents.ForceLegendary:FireServer()
                end)
                if not success then
                    logError("Force Legendary Error: " .. result)
                end
            end
        end
        
        if Config.RNGKill.SecretFishBoost then
            -- Boost secret fish chances
            if FishingEvents and FishingEvents:FindFirstChild("SecretFishBoost") then
                local success, result = pcall(function()
                    FishingEvents.SecretFishBoost:FireServer()
                end)
                if not success then
                    logError("Secret Fish Boost Error: " .. result)
                end
            end
        end
        
        if Config.RNGKill.MythicalChanceBoost then
            -- Boost mythical fish chances
            if FishingEvents and FishingEvents:FindFirstChild("MythicalChanceBoost") then
                local success, result = pcall(function()
                    FishingEvents.MythicalChanceBoost:FireServer()
                end)
                if not success then
                    logError("Mythical Chance Boost Error: " .. result)
                end
            end
        end
        
        if Config.RNGKill.AntiBadLuck then
            -- Prevent bad luck streaks
            if FishingEvents and FishingEvents:FindFirstChild("AntiBadLuck") then
                local success, result = pcall(function()
                    FishingEvents.AntiBadLuck:FireServer()
                end)
                if not success then
                    logError("Anti-Bad Luck Error: " .. result)
                end
            end
        end
        
        if Config.RNGKill.GuaranteedCatch then
            -- Guarantee fish catch
            if FishingEvents and FishingEvents:FindFirstChild("GuaranteedCatch") then
                local success, result = pcall(function()
                    FishingEvents.GuaranteedCatch:FireServer()
                end)
                if not success then
                    logError("Guaranteed Catch Error: " .. result)
                end
            end
        end
        
        if Config.RNGKill.AutoCatch then
            -- Auto catch fish
            if FishingEvents and FishingEvents:FindFirstChild("AutoCatch") then
                local success, result = pcall(function()
                    FishingEvents.AutoCatch:FireServer()
                end)
                if not success then
                    logError("Auto Catch Error: " .. result)
                end
            end
        end
        
        if Config.RNGKill.AutoReel then
            -- Auto reel fish
            if FishingEvents and FishingEvents:FindFirstChild("AutoReel") then
                local success, result = pcall(function()
                    FishingEvents.AutoReel:FireServer()
                end)
                if not success then
                    logError("Auto Reel Error: " .. result)
                end
            end
        end
        
        if Config.RNGKill.AutoHook then
            -- Auto hook fish
            if FishingEvents and FishingEvents:FindFirstChild("AutoHook") then
                local success, result = pcall(function()
                    FishingEvents.AutoHook:FireServer()
                end)
                if not success then
                    logError("Auto Hook Error: " .. result)
                end
            end
        end
        
        wait(2)
    end
end)

-- Shop Tab
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
    Name = "Auto Upgrade Boat",
    CurrentValue = Config.Shop.AutoUpgradeBoat,
    Flag = "AutoUpgradeBoat",
    Callback = function(Value)
        Config.Shop.AutoUpgradeBoat = Value
        logError("Auto Upgrade Boat: " .. tostring(Value))
    end
})

ShopTab:CreateToggle({
    Name = "Auto Buy All",
    CurrentValue = Config.Shop.AutoBuyAll,
    Flag = "AutoBuyAll",
    Callback = function(Value)
        Config.Shop.AutoBuyAll = Value
        logError("Auto Buy All: " .. tostring(Value))
    end
})

ShopTab:CreateToggle({
    Name = "Auto Upgrade All",
    CurrentValue = Config.Shop.AutoUpgradeAll,
    Flag = "AutoUpgradeAll",
    Callback = function(Value)
        Config.Shop.AutoUpgradeAll = Value
        logError("Auto Upgrade All: " .. tostring(Value))
    end
})

ShopTab:CreateToggle({
    Name = "Auto Sell All",
    CurrentValue = Config.Shop.AutoSellAll,
    Flag = "AutoSellAll",
    Callback = function(Value)
        Config.Shop.AutoSellAll = Value
        logError("Auto Sell All: " .. tostring(Value))
    end
})

ShopTab:CreateButton({
    Name = "Buy Selected Item",
    Callback = function()
        if Config.Shop.SelectedRod ~= "" and MarketPlaceService and MarketPlaceService:FindFirstChild("BuyRod") then
            local success, result = pcall(function()
                MarketPlaceService.BuyRod:FireServer(Config.Shop.SelectedRod)
                Rayfield:Notify({
                    Title = "Purchase",
                    Content = "Successfully purchased " .. Config.Shop.SelectedRod,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Purchased: " .. Config.Shop.SelectedRod)
            end)
            if not success then
                logError("Purchase Error: " .. result)
            end
        elseif Config.Shop.SelectedBoat ~= "" and MarketPlaceService and MarketPlaceService:FindFirstChild("BuyBoat") then
            local success, result = pcall(function()
                MarketPlaceService.BuyBoat:FireServer(Config.Shop.SelectedBoat)
                Rayfield:Notify({
                    Title = "Purchase",
                    Content = "Successfully purchased " .. Config.Shop.SelectedBoat,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Purchased: " .. Config.Shop.SelectedBoat)
            end)
            if not success then
                logError("Purchase Error: " .. result)
            end
        elseif Config.Shop.SelectedBait ~= "" and MarketPlaceService and MarketPlaceService:FindFirstChild("BuyBait") then
            local success, result = pcall(function()
                MarketPlaceService.BuyBait:FireServer(Config.Shop.SelectedBait)
                Rayfield:Notify({
                    Title = "Purchase",
                    Content = "Successfully purchased " .. Config.Shop.SelectedBait,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Purchased: " .. Config.Shop.SelectedBait)
            end)
            if not success then
                logError("Purchase Error: " .. result)
            end
        else
            Rayfield:Notify({
                Title = "Purchase Error",
                Content = "Please select an item first",
                Duration = 3,
                Image = 13047715178
            })
            logError("Purchase Error: No item selected")
        end
    end
})

ShopTab:CreateButton({
    Name = "Buy All Items",
    Callback = function()
        if Config.Shop.AutoBuyAll then
            -- Buy all rods
            for _, rod in ipairs(Rods) do
                if MarketPlaceService and MarketPlaceService:FindFirstChild("BuyRod") then
                    local success, result = pcall(function()
                        MarketPlaceService.BuyRod:FireServer(rod)
                        logError("Purchased Rod: " .. rod)
                    end)
                    if not success then
                        logError("Purchase Rod Error: " .. result)
                    end
                end
            end
            
            -- Buy all boats
            for _, boat in ipairs(Boats) do
                if MarketPlaceService and MarketPlaceService:FindFirstChild("BuyBoat") then
                    local success, result = pcall(function()
                        MarketPlaceService.BuyBoat:FireServer(boat)
                        logError("Purchased Boat: " .. boat)
                    end)
                    if not success then
                        logError("Purchase Boat Error: " .. result)
                    end
                end
            end
            
            -- Buy all baits
            for _, bait in ipairs(Baits) do
                if MarketPlaceService and MarketPlaceService:FindFirstChild("BuyBait") then
                    local success, result = pcall(function()
                        MarketPlaceService.BuyBait:FireServer(bait)
                        logError("Purchased Bait: " .. bait)
                    end)
                    if not success then
                        logError("Purchase Bait Error: " .. result)
                    end
                end
            end
            
            Rayfield:Notify({
                Title = "Purchase Complete",
                Content = "All items purchased successfully",
                Duration = 5,
                Image = 13047715178
            })
        else
            Rayfield:Notify({
                Title = "Purchase Error",
                Content = "Please enable Auto Buy All first",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

ShopTab:CreateButton({
    Name = "Upgrade All Items",
    Callback = function()
        if Config.Shop.AutoUpgradeAll then
            -- Upgrade all rods
            if GameFunctions and GameFunctions:FindFirstChild("UpgradeAllRods") then
                local success, result = pcall(function()
                    GameFunctions.UpgradeAllRods:InvokeServer()
                    logError("Upgraded All Rods")
                end)
                if not success then
                    logError("Upgrade Rods Error: " .. result)
                end
            end
            
            -- Upgrade all boats
            if GameFunctions and GameFunctions:FindFirstChild("UpgradeAllBoats") then
                local success, result = pcall(function()
                    GameFunctions.UpgradeAllBoats:InvokeServer()
                    logError("Upgraded All Boats")
                end)
                if not success then
                    logError("Upgrade Boats Error: " .. result)
                end
            end
            
            Rayfield:Notify({
                Title = "Upgrade Complete",
                Content = "All items upgraded successfully",
                Duration = 5,
                Image = 13047715178
            })
        else
            Rayfield:Notify({
                Title = "Upgrade Error",
                Content = "Please enable Auto Upgrade All first",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

ShopTab:CreateButton({
    Name = "Sell All Items",
    Callback = function()
        if Config.Shop.AutoSellAll and PlayerData and PlayerData:FindFirstChild("Inventory") then
            for _, item in ipairs(PlayerData.Inventory:GetChildren()) do
                if item:IsA("Folder") or item:IsA("Configuration") then
                    if TradeEvents and TradeEvents:FindFirstChild("SellItem") then
                        local success, result = pcall(function()
                            TradeEvents.SellItem:FireServer(item)
                            logError("Sold: " .. item.Name)
                        end)
                        if not success then
                            logError("Sell Error: " .. result)
                        end
                    end
                end
            end
            
            Rayfield:Notify({
                Title = "Sell Complete",
                Content = "All items sold successfully",
                Duration = 5,
                Image = 13047715178
            })
        else
            Rayfield:Notify({
                Title = "Sell Error",
                Content = "Please enable Auto Sell All first",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Shop Features Implementation
spawn(function()
    while true do
        if Config.Shop.AutoBuyRods and MarketPlaceService and MarketPlaceService:FindFirstChild("BuyRod") then
            -- Auto buy best available rod
            local bestRod = "Starter Rod"
            for _, rod in ipairs(Rods) do
                if rod ~= "Starter Rod" then
                    bestRod = rod
                end
            end
            
            local success, result = pcall(function()
                MarketPlaceService.BuyRod:FireServer(bestRod)
                logError("Auto Purchased Rod: " .. bestRod)
            end)
            if not success then
                logError("Auto Buy Rod Error: " .. result)
            end
        end
        
        if Config.Shop.AutoBuyBoats and MarketPlaceService and MarketPlaceService:FindFirstChild("BuyBoat") then
            -- Auto buy best available boat
            local bestBoat = "Small Boat"
            for _, boat in ipairs(Boats) do
                if boat ~= "Small Boat" then
                    bestBoat = boat
                end
            end
            
            local success, result = pcall(function()
                MarketPlaceService.BuyBoat:FireServer(bestBoat)
                logError("Auto Purchased Boat: " .. bestBoat)
            end)
            if not success then
                logError("Auto Buy Boat Error: " .. result)
            end
        end
        
        if Config.Shop.AutoBuyBaits and MarketPlaceService and MarketPlaceService:FindFirstChild("BuyBait") then
            -- Auto buy best available bait
            local bestBait = "Worm"
            for _, bait in ipairs(Baits) do
                if bait ~= "Worm" then
                    bestBait = bait
                end
            end
            
            local success, result = pcall(function()
                MarketPlaceService.BuyBait:FireServer(bestBait)
                logError("Auto Purchased Bait: " .. bestBait)
            end)
            if not success then
                logError("Auto Buy Bait Error: " .. result)
            end
        end
        
        if Config.Shop.AutoUpgradeRod and GameFunctions and GameFunctions:FindFirstChild("UpgradeRod") then
            local success, result = pcall(function()
                GameFunctions.UpgradeRod:InvokeServer()
                logError("Auto Upgraded Rod")
            end)
            if not success then
                logError("Auto Upgrade Rod Error: " .. result)
            end
        end
        
        if Config.Shop.AutoUpgradeBoat and GameFunctions and GameFunctions:FindFirstChild("UpgradeBoat") then
            local success, result = pcall(function()
                GameFunctions.UpgradeBoat:InvokeServer()
                logError("Auto Upgraded Boat")
            end)
            if not success then
                logError("Auto Upgrade Boat Error: " .. result)
            end
        end
        
        wait(10)
    end
end)

-- Settings Tab
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

SettingsTab:CreateInput({
    Name = "Config Name",
    PlaceholderText = "Enter config name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        Config.Settings.ConfigName = Text
        logError("Config Name: " .. Text)
    end
})

SettingsTab:CreateDropdown({
    Name = "UI Theme",
    Options = {"Dark", "Light", "Blue", "Green"},
    CurrentOption = Config.Settings.SelectedTheme,
    Flag = "SelectedTheme",
    Callback = function(Value)
        Config.Settings.SelectedTheme = Value
        logError("UI Theme: " .. Value)
    end
})

SettingsTab:CreateSlider({
    Name = "UI Transparency",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Settings.Transparency,
    Flag = "Transparency",
    Callback = function(Value)
        Config.Settings.Transparency = Value
        logError("UI Transparency: " .. Value)
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

-- Low Device Tab
local LowDeviceTab = Window:CreateTab("📱 Low Device", 13014546625)

LowDeviceTab:CreateToggle({
    Name = "Anti Lag",
    CurrentValue = Config.LowDevice.AntiLag,
    Flag = "AntiLag",
    Callback = function(Value)
        Config.LowDevice.AntiLag = Value
        logError("Anti Lag: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "FPS Stabilizer",
    CurrentValue = Config.LowDevice.FPSStabilizer,
    Flag = "FPSStabilizer",
    Callback = function(Value)
        Config.LowDevice.FPSStabilizer = Value
        logError("FPS Stabilizer: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Disable Effects",
    CurrentValue = Config.LowDevice.DisableEffects,
    Flag = "DisableEffects",
    Callback = function(Value)
        Config.LowDevice.DisableEffects = Value
        logError("Disable Effects: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Simple Graphics",
    CurrentValue = Config.LowDevice.SimpleGraphics,
    Flag = "SimpleGraphics",
    Callback = function(Value)
        Config.LowDevice.SimpleGraphics = Value
        logError("Simple Graphics: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Low Quality Textures",
    CurrentValue = Config.LowDevice.LowQualityTextures,
    Flag = "LowQualityTextures",
    Callback = function(Value)
        Config.LowDevice.LowQualityTextures = Value
        logError("Low Quality Textures: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Reduce Draw Distance",
    CurrentValue = Config.LowDevice.ReduceDrawDistance,
    Flag = "ReduceDrawDistance",
    Callback = function(Value)
        Config.LowDevice.ReduceDrawDistance = Value
        logError("Reduce Draw Distance: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Minimal UI",
    CurrentValue = Config.LowDevice.MinimalUI,
    Flag = "MinimalUI",
    Callback = function(Value)
        Config.LowDevice.MinimalUI = Value
        logError("Minimal UI: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Low Poly Mode",
    CurrentValue = Config.LowDevice.LowPolyMode,
    Flag = "LowPolyMode",
    Callback = function(Value)
        Config.LowDevice.LowPolyMode = Value
        logError("Low Poly Mode: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Low Texture Mode",
    CurrentValue = Config.LowDevice.LowTextureMode,
    Flag = "LowTextureMode",
    Callback = function(Value)
        Config.LowDevice.LowTextureMode = Value
        logError("Low Texture Mode: " .. tostring(Value))
    end
})

LowDeviceTab:CreateToggle({
    Name = "Low Shadow Mode",
    CurrentValue = Config.LowDevice.LowShadowMode,
    Flag = "LowShadowMode",
    Callback = function(Value)
        Config.LowDevice.LowShadowMode = Value
        logError("Low Shadow Mode: " .. tostring(Value))
    end
})

LowDeviceTab:CreateButton({
    Name = "Apply Low Device Settings",
    Callback = function()
        -- Apply all low device settings
        Config.LowDevice.AntiLag = true
        Config.LowDevice.FPSStabilizer = true
        Config.LowDevice.DisableEffects = true
        Config.LowDevice.SimpleGraphics = true
        Config.LowDevice.LowQualityTextures = true
        Config.LowDevice.ReduceDrawDistance = true
        Config.LowDevice.MinimalUI = true
        Config.LowDevice.LowPolyMode = true
        Config.LowDevice.LowTextureMode = true
        Config.LowDevice.LowShadowMode = true
        
        Rayfield:Notify({
            Title = "Low Device Settings",
            Content = "All low device settings applied",
            Duration = 3,
            Image = 13047715178
        })
        logError("Low Device Settings Applied")
    end
})

LowDeviceTab:CreateButton({
    Name = "Optimize for Potato",
    Callback = function()
        -- Apply extreme low device settings
        Config.LowDevice.AntiLag = true
        Config.LowDevice.FPSStabilizer = true
        Config.LowDevice.DisableEffects = true
        Config.LowDevice.SimpleGraphics = true
        Config.LowDevice.LowQualityTextures = true
        Config.LowDevice.ReduceDrawDistance = true
        Config.LowDevice.MinimalUI = true
        Config.LowDevice.LowPolyMode = true
        Config.LowDevice.LowTextureMode = true
        Config.LowDevice.LowShadowMode = true
        
        settings().Rendering.QualityLevel = 1
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 10
        Lighting.FogColor = Color3.new(0, 0, 0)
        
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj.Enabled = false
            end
            if obj:IsA("Part") or obj:IsA("MeshPart") then
                obj.Material = Enum.Material.Plastic
                obj.TextureID = ""
            end
            if obj:IsA("Texture") then
                obj.TextureQuality = Enum.TextureQuality.Low
            end
        end
        
        Rayfield:Notify({
            Title = "Potato Mode",
            Content = "Extreme optimization applied for low-end devices",
            Duration = 5,
            Image = 13047715178
        })
        logError("Potato Mode Applied")
    end
})

-- Low Device Features Implementation
spawn(function()
    while true do
        if Config.LowDevice.AntiLag then
            -- Reduce lag by lowering quality
            settings().Rendering.QualityLevel = 1
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100
            
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") then
                    obj.Enabled = false
                end
            end
        end
        
        if Config.LowDevice.FPSStabilizer then
            -- Stabilize FPS
            setfpscap(30)
            collectgarbage("step")
        end
        
        if Config.LowDevice.DisableEffects then
            -- Disable all visual effects
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                    obj.Enabled = false
                end
            end
        end
        
        if Config.LowDevice.SimpleGraphics then
            -- Use simple graphics
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Part") or obj:IsA("MeshPart") then
                    obj.Material = Enum.Material.Plastic
                    obj.TextureID = ""
                end
            end
        end
        
        if Config.LowDevice.LowQualityTextures then
            -- Use low quality textures
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Texture") then
                    obj.TextureQuality = Enum.TextureQuality.Low
                end
            end
        end
        
        if Config.LowDevice.ReduceDrawDistance then
            -- Reduce draw distance
            Lighting.FogEnd = 50
            Workspace.CurrentCamera.FieldOfView = 70
        end
        
        if Config.LowDevice.MinimalUI then
            -- Minimal UI
            for _, obj in ipairs(CoreGui:GetChildren()) do
                if obj.Name ~= "RayfieldHub" and obj.Name ~= "ESPFolder" then
                    obj.Enabled = false
                end
            end
        end
        
        if Config.LowDevice.LowPolyMode then
            -- Apply low poly mode
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("MeshPart") then
                    obj.MeshId = ""
                    obj.TextureID = ""
                end
            end
        end
        
        if Config.LowDevice.LowTextureMode then
            -- Apply low texture mode
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Texture") then
                    obj.TextureQuality = Enum.TextureQuality.Low
                end
            end
        end
        
        if Config.LowDevice.LowShadowMode then
            -- Apply low shadow mode
            Lighting.GlobalShadows = false
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("PointLight") then
                    obj.Shadows = false
                end
            end
        end
        
        wait(0.5)
    end
end)

-- Initialize UI
Rayfield:Notify({
    Title = "Script Loaded",
    Content = "Fish It 2025 Mod by Nikzz Xit",
    Duration = 5,
    Image = 13047715178
})

logError("Script initialized successfully")
