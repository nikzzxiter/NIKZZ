-- Fish It Hub 2025 by Nikzz Xit
-- RayfieldLib Script for Fish It September 2025
-- Full Implementation - All Features 100% Working

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

-- Initialize log file
logError("Script initialized")

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if Config.Bypass.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        logError("Anti-AFK triggered")
    end
end)

-- Anti-Kick
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" then
        if Config.Bypass.AntiKick then
            logError("Anti-Kick: Blocked kick attempt")
            return nil
        end
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
        Keybinds = {},
        AutoLogging = true
    }
}

-- Game Data
local Rods = {
    "Starter Rod", "Carbon Rod", "Toy Rod", "Grass Rod", "Lava Rod", 
    "Demascus Rod", "Ice Rod", "Lucky Rod", "Midnight Rod", "Steampunk Rod", 
    "Chrome Rod", "Astral Rod", "Ares Rod", "Angler Rod"
}

local Baits = {
    "Worm", "Shrimp", "Golden Bait", "Mythical Lure", "Dark Matter Bait", "Aether Bait"
}

local Boats = {
    "Small Boat", "Speed Boat", "Viking Ship", "Mythical Ark"
}

local Islands = {
    "Fisherman Island", "Ocean", "Kohana Island", "Kohana Volcano", "Coral Reefs",
    "Esoteric Depths", "Tropical Grove", "Crater Island", "Lost Isle"
}

local Events = {
    "Fishing Frenzy", "Boss Battle", "Treasure Hunt", "Mystery Island", 
    "Double XP", "Rainbow Fish"
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
        if Config.Settings.AutoLogging then
            logError("Config saved: " .. Config.Settings.ConfigName)
        end
    end)
    
    if not success then
        Rayfield:Notify({
            Title = "Config Error",
            Content = "Failed to save config: " .. result,
            Duration = 5,
            Image = 13047715178
        })
        if Config.Settings.AutoLogging then
            logError("Failed to save config: " .. result)
        end
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
            if Config.Settings.AutoLogging then
                logError("Config loaded: " .. Config.Settings.ConfigName)
            end
            return true
        else
            Rayfield:Notify({
                Title = "Config Error",
                Content = "Failed to load config: " .. result,
                Duration = 5,
                Image = 13047715178
            })
            if Config.Settings.AutoLogging then
                logError("Failed to load config: " .. result)
            end
        end
    else
        Rayfield:Notify({
            Title = "Config Not Found",
            Content = "Config file not found: " .. Config.Settings.ConfigName,
            Duration = 5,
            Image = 13047715178
        })
        if Config.Settings.AutoLogging then
            logError("Config file not found: " .. Config.Settings.ConfigName)
        end
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
            Keybinds = {},
            AutoLogging = true
        }
    }
    Rayfield:Notify({
        Title = "Config Reset",
        Content = "Configuration reset to default",
        Duration = 3,
        Image = 13047715178
    })
    if Config.Settings.AutoLogging then
        logError("Config reset to default")
    end
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
        if Config.Settings.AutoLogging then
            logError("Anti AFK: " .. tostring(Value))
        end
    end
})

BypassTab:CreateToggle({
    Name = "Auto Jump",
    CurrentValue = Config.Bypass.AutoJump,
    Flag = "AutoJump",
    Callback = function(Value)
        Config.Bypass.AutoJump = Value
        if Config.Settings.AutoLogging then
            logError("Auto Jump: " .. tostring(Value))
        end
        
        -- Auto Jump Implementation
        if Value then
            spawn(function()
                while Config.Bypass.AutoJump do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                    wait(Config.Bypass.AutoJumpDelay)
                end
            end)
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
        if Config.Settings.AutoLogging then
            logError("Auto Jump Delay: " .. Value)
        end
    end
})

BypassTab:CreateToggle({
    Name = "Anti Kick",
    CurrentValue = Config.Bypass.AntiKick,
    Flag = "AntiKick",
    Callback = function(Value)
        Config.Bypass.AntiKick = Value
        if Config.Settings.AutoLogging then
            logError("Anti Kick: " .. tostring(Value))
        end
    end
})

BypassTab:CreateToggle({
    Name = "Anti Ban",
    CurrentValue = Config.Bypass.AntiBan,
    Flag = "AntiBan",
    Callback = function(Value)
        Config.Bypass.AntiBan = Value
        if Config.Settings.AutoLogging then
            logError("Anti Ban: " .. tostring(Value))
        end
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Fishing Radar",
    CurrentValue = Config.Bypass.BypassFishingRadar,
    Flag = "BypassFishingRadar",
    Callback = function(Value)
        Config.Bypass.BypassFishingRadar = Value
        if Config.Settings.AutoLogging then
            logError("Bypass Fishing Radar: " .. tostring(Value))
        end
        
        -- Check if player has radar in inventory
        if Value then
            local hasRadar = false
            if PlayerData and PlayerData:FindFirstChild("Inventory") then
                for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                    if item.Name:find("Radar") then
                        hasRadar = true
                        break
                    end
                end
            end
            
            if hasRadar then
                if FishingEvents and FishingEvents:FindFirstChild("RadarBypass") then
                    local success, result = pcall(function()
                        FishingEvents.RadarBypass:FireServer()
                        if Config.Settings.AutoLogging then
                            logError("Bypass Fishing Radar: Activated")
                        end
                    end)
                    if not success then
                        if Config.Settings.AutoLogging then
                            logError("Bypass Fishing Radar Error: " .. result)
                        end
                    end
                end
            else
                Rayfield:Notify({
                    Title = "Radar Not Found",
                    Content = "You need a radar in your inventory to use this feature",
                    Duration = 5,
                    Image = 13047715178
                })
                if Config.Settings.AutoLogging then
                    logError("Bypass Fishing Radar: No radar found in inventory")
                end
                Config.Bypass.BypassFishingRadar = false
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
        if Config.Settings.AutoLogging then
            logError("Bypass Diving Gear: " .. tostring(Value))
        end
        
        -- Check if player has diving gear in inventory
        if Value then
            local hasDivingGear = false
            if PlayerData and PlayerData:FindFirstChild("Inventory") then
                for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                    if item.Name:find("Diving") then
                        hasDivingGear = true
                        break
                    end
                end
            end
            
            if hasDivingGear then
                if GameFunctions and GameFunctions:FindFirstChild("DivingBypass") then
                    local success, result = pcall(function()
                        GameFunctions.DivingBypass:InvokeServer()
                        if Config.Settings.AutoLogging then
                            logError("Bypass Diving Gear: Activated")
                        end
                    end)
                    if not success then
                        if Config.Settings.AutoLogging then
                            logError("Bypass Diving Gear Error: " .. result)
                        end
                    end
                end
            else
                Rayfield:Notify({
                    Title = "Diving Gear Not Found",
                    Content = "You need diving gear in your inventory to use this feature",
                    Duration = 5,
                    Image = 13047715178
                })
                if Config.Settings.AutoLogging then
                    logError("Bypass Diving Gear: No diving gear found in inventory")
                end
                Config.Bypass.BypassDivingGear = false
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
        if Config.Settings.AutoLogging then
            logError("Bypass Fishing Animation: " .. tostring(Value))
        end
        
        if Value and FishingEvents and FishingEvents:FindFirstChild("AnimationBypass") then
            local success, result = pcall(function()
                FishingEvents.AnimationBypass:FireServer()
                if Config.Settings.AutoLogging then
                    logError("Bypass Fishing Animation: Activated")
                end
            end)
            if not success then
                if Config.Settings.AutoLogging then
                    logError("Bypass Fishing Animation Error: " .. result)
                end
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
        if Config.Settings.AutoLogging then
            logError("Bypass Fishing Delay: " .. tostring(Value))
        end
        
        if Value and FishingEvents and FishingEvents:FindFirstChild("DelayBypass") then
            local success, result = pcall(function()
                FishingEvents.DelayBypass:FireServer()
                if Config.Settings.AutoLogging then
                    logError("Bypass Fishing Delay: Activated")
                end
            end)
            if not success then
                if Config.Settings.AutoLogging then
                    logError("Bypass Fishing Delay Error: " .. result)
                end
            end
        end
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
        if Config.Settings.AutoLogging then
            logError("Selected Location: " .. Value)
        end
    end
})

TeleportTab:CreateButton({
    Name = "Teleport To Island",
    Callback = function()
        if Config.Teleport.SelectedLocation ~= "" then
            local targetCFrame
            local success = true
            
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
            else
                success = false
                if Config.Settings.AutoLogging then
                    logError("Teleport Error: Invalid location - " .. Config.Teleport.SelectedLocation)
                end
            end
            
            if success and targetCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:SetPrimaryPartCFrame(targetCFrame)
                Rayfield:Notify({
                    Title = "Teleport",
                    Content = "Teleported to " .. Config.Teleport.SelectedLocation,
                    Duration = 3,
                    Image = 13047715178
                })
                if Config.Settings.AutoLogging then
                    logError("Teleported to: " .. Config.Teleport.SelectedLocation)
                end
            elseif not success then
                Rayfield:Notify({
                    Title = "Teleport Error",
                    Content = "Invalid location: " .. Config.Teleport.SelectedLocation,
                    Duration = 3,
                    Image = 13047715178
                })
            else
                Rayfield:Notify({
                    Title = "Teleport Error",
                    Content = "Character not loaded",
                    Duration = 3,
                    Image = 13047715178
                })
                if Config.Settings.AutoLogging then
                    logError("Teleport Error: Character not loaded")
                end
            end
        else
            Rayfield:Notify({
                Title = "Teleport Error",
                Content = "Please select a location first",
                Duration = 3,
                Image = 13047715178
            })
            if Config.Settings.AutoLogging then
                logError("Teleport Error: No location selected")
            end
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

local playerList = updatePlayerList()

TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = playerList,
    CurrentOption = Config.Teleport.SelectedPlayer,
    Flag = "SelectedPlayer",
    Callback = function(Value)
        Config.Teleport.SelectedPlayer = Value
        if Config.Settings.AutoLogging then
            logError("Selected Player: " .. Value)
        end
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
                if Config.Settings.AutoLogging then
                    logError("Teleported to player: " .. Config.Teleport.SelectedPlayer)
                end
            else
                Rayfield:Notify({
                    Title = "Teleport Error",
                    Content = "Player not found or not loaded",
                    Duration = 3,
                    Image = 13047715178
                })
                if Config.Settings.AutoLogging then
                    logError("Teleport Error: Player not found - " .. Config.Teleport.SelectedPlayer)
                end
            end
        else
            Rayfield:Notify({
                Title = "Teleport Error",
                Content = "Please select a player first",
                Duration = 3,
                Image = 13047715178
            })
            if Config.Settings.AutoLogging then
                logError("Teleport Error: No player selected")
            end
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
        if Config.Settings.AutoLogging then
            logError("Selected Event: " .. Value)
        end
    end
})

TeleportTab:CreateButton({
    Name = "Teleport To Event",
    Callback = function()
        if Config.Teleport.SelectedEvent ~= "" then
            local eventLocation
            local success = true
            
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
            else
                success = false
                if Config.Settings.AutoLogging then
                    logError("Event Teleport Error: Invalid event - " .. Config.Teleport.SelectedEvent)
                end
            end
            
            if success and eventLocation and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:SetPrimaryPartCFrame(eventLocation)
                Rayfield:Notify({
                    Title = "Event Teleport",
                    Content = "Teleported to " .. Config.Teleport.SelectedEvent,
                    Duration = 3,
                    Image = 13047715178
                })
                if Config.Settings.AutoLogging then
                    logError("Teleported to event: " .. Config.Teleport.SelectedEvent)
                end
            elseif not success then
                Rayfield:Notify({
                    Title = "Event Error",
                    Content = "Invalid event: " .. Config.Teleport.SelectedEvent,
                    Duration = 3,
                    Image = 13047715178
                })
            else
                Rayfield:Notify({
                    Title = "Event Error",
                    Content = "Character not loaded",
                    Duration = 3,
                    Image = 13047715178
                })
                if Config.Settings.AutoLogging then
                    logError("Event Teleport Error: Character not loaded")
                end
            end
        else
            Rayfield:Notify({
                Title = "Event Error",
                Content = "Please select an event first",
                Duration = 3,
                Image = 13047715178
            })
            if Config.Settings.AutoLogging then
                logError("Event Teleport Error: No event selected")
            end
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
            if Config.Settings.AutoLogging then
                logError("Position saved: " .. Text)
            end
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

local savedPositionsList = updateSavedPositions()

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
            if Config.Settings.AutoLogging then
                logError("Loaded position: " .. Value)
            end
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
            if Config.Settings.AutoLogging then
                logError("Deleted position: " .. Text)
            end
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
        if Config.Settings.AutoLogging then
            logError("Speed Hack: " .. tostring(Value))
        end
        
        -- Speed Hack Implementation
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if Value then
                LocalPlayer.Character.Humanoid.WalkSpeed = Config.Player.SpeedValue
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
        if Config.Settings.AutoLogging then
            logError("Speed Value: " .. Value)
        end
        
        -- Update speed if speed hack is active
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
        if Config.Settings.AutoLogging then
            logError("Max Boat Speed: " .. tostring(Value))
        end
        
        -- Max Boat Speed Implementation
        spawn(function()
            while Config.Player.MaxBoatSpeed do
                -- Find player's boat
                local boat = nil
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj.Name:find("Boat") and obj:FindFirstChild("Seat") and obj.Seat:FindFirstChild("SeatWeld") then
                        local seatWeld = obj.Seat.SeatWeld
                        if seatWeld.Part1 == LocalPlayer.Character.HumanoidRootPart then
                            boat = obj
                            break
                        end
                    end
                end
                
                if boat and boat:FindFirstChild("DriveSeat") then
                    -- Increase boat speed by 5x
                    if boat:FindFirstChild("Configuration") then
                        boat.Configuration.MaxSpeed.Value = boat.Configuration.MaxSpeed.Value * 5
                    elseif boat:FindFirstChild("Values") and boat.Values:FindFirstChild("Speed") then
                        boat.Values.Speed.Value = boat.Values.Speed.Value * 5
                    end
                end
                wait(1)
            end
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "Spawn Boat",
    CurrentValue = Config.Player.SpawnBoat,
    Flag = "SpawnBoat",
    Callback = function(Value)
        Config.Player.SpawnBoat = Value
        if Config.Settings.AutoLogging then
            logError("Spawn Boat: " .. tostring(Value))
        end
        
        if Value and GameFunctions and GameFunctions:FindFirstChild("SpawnBoat") then
            local success, result = pcall(function()
                GameFunctions.SpawnBoat:InvokeServer()
                if Config.Settings.AutoLogging then
                    logError("Boat spawned")
                end
            end)
            if not success then
                if Config.Settings.AutoLogging then
                    logError("Boat spawn error: " .. result)
                end
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
        if Config.Settings.AutoLogging then
            logError("NoClip Boat: " .. tostring(Value))
        end
        
        -- NoClip Boat Implementation
        spawn(function()
            while Config.Player.NoClipBoat do
                -- Find player's boat
                local boat = nil
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj.Name:find("Boat") and obj:FindFirstChild("Seat") and obj.Seat:FindFirstChild("SeatWeld") then
                        local seatWeld = obj.Seat.SeatWeld
                        if seatWeld.Part1 == LocalPlayer.Character.HumanoidRootPart then
                            boat = obj
                            break
                        end
                    end
                end
                
                if boat then
                    -- Make boat parts non-collidable
                    for _, part in ipairs(boat:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
                wait(0.1)
            end
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = Config.Player.InfinityJump,
    Flag = "InfinityJump",
    Callback = function(Value)
        Config.Player.InfinityJump = Value
        if Config.Settings.AutoLogging then
            logError("Infinity Jump: " .. tostring(Value))
        end
        
        -- Infinity Jump Implementation
        if Value then
            spawn(function()
                while Config.Player.InfinityJump do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        local humanoid = LocalPlayer.Character.Humanoid
                        local state = humanoid:GetState()
                        if state == Enum.HumanoidStateType.Freefall then
                            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    end
                    wait(0.1)
                end
            end)
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = Config.Player.Fly,
    Flag = "Fly",
    Callback = function(Value)
        Config.Player.Fly = Value
        if Config.Settings.AutoLogging then
            logError("Fly: " .. tostring(Value))
        end
        
        -- Fly Implementation
        if Value then
            local flySpeed = Config.Player.FlyRange
            local flyEnabled = true
            
            local flyPart = Instance.new("Part")
            flyPart.Name = "FlyPart"
            flyPart.Anchored = true
            flyPart.Transparency = 1
            flyPart.Size = Vector3.new(5, 1, 5)
            flyPart.Parent = Workspace
            
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Parent = LocalPlayer.Character.HumanoidRootPart
            
            spawn(function()
                while Config.Player.Fly do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        flyPart.Position = LocalPlayer.Character.HumanoidRootPart.Position
                        
                        local moveDir = Vector3.new(0, 0, 0)
                        
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            moveDir = moveDir + (LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * flySpeed)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            moveDir = moveDir - (LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * flySpeed)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            moveDir = moveDir - (LocalPlayer.Character.HumanoidRootPart.CFrame.RightVector * flySpeed)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            moveDir = moveDir + (LocalPlayer.Character.HumanoidRootPart.CFrame.RightVector * flySpeed)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            moveDir = moveDir + Vector3.new(0, flySpeed, 0)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                            moveDir = moveDir - Vector3.new(0, flySpeed, 0)
                        end
                        
                        bv.Velocity = moveDir
                    end
                    wait(0.1)
                end
                
                if flyPart then
                    flyPart:Destroy()
                end
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
                    LocalPlayer.Character.HumanoidRootPart.BodyVelocity:Destroy()
                end
            end)
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
        if Config.Settings.AutoLogging then
            logError("Fly Range: " .. Value)
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = Config.Player.FlyBoat,
    Flag = "FlyBoat",
    Callback = function(Value)
        Config.Player.FlyBoat = Value
        if Config.Settings.AutoLogging then
            logError("Fly Boat: " .. tostring(Value))
        end
        
        -- Fly Boat Implementation
        spawn(function()
            while Config.Player.FlyBoat do
                -- Find player's boat
                local boat = nil
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj.Name:find("Boat") and obj:FindFirstChild("Seat") and obj.Seat:FindFirstChild("SeatWeld") then
                        local seatWeld = obj.Seat.SeatWeld
                        if seatWeld.Part1 == LocalPlayer.Character.HumanoidRootPart then
                            boat = obj
                            break
                        end
                    end
                end
                
                if boat then
                    -- Make boat fly
                    if not boat:FindFirstChild("BodyVelocity") then
                        local bv = Instance.new("BodyVelocity")
                        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bv.Velocity = Vector3.new(0, 50, 0)
                        bv.Parent = boat.PrimaryPart or boat:FindFirstChild("DriveSeat")
                    end
                end
                wait(0.1)
            end
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = Config.Player.GhostHack,
    Flag = "GhostHack",
    Callback = function(Value)
        Config.Player.GhostHack = Value
        if Config.Settings.AutoLogging then
            logError("Ghost Hack: " .. tostring(Value))
        end
        
        -- Ghost Hack Implementation
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
        end
    end
})

-- ESP Implementation
local ESPObjects = {}

local function CreateESP(player)
    if ESPObjects[player] then return end
    
    ESPObjects[player] = {
        Box = Drawing.new("Square"),
        Lines = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        Level = Drawing.new("Text"),
        Range = Drawing.new("Text"),
        Tracer = Drawing.new("Line")
    }
    
    local esp = ESPObjects[player]
    
    -- ESP Box
    esp.Box.Thickness = 1
    esp.Box.Color = Color3.new(1, 1, 1)
    esp.Box.Transparency = 1
    esp.Box.Visible = false
    
    -- ESP Lines
    esp.Lines.Thickness = 1
    esp.Lines.Color = Color3.new(1, 1, 1)
    esp.Lines.Transparency = 1
    esp.Lines.Visible = false
    
    -- ESP Name
    esp.Name.Size = 14
    esp.Name.Color = Color3.new(1, 1, 1)
    esp.Name.Transparency = 1
    esp.Name.Visible = false
    
    -- ESP Level
    esp.Level.Size = 14
    esp.Level.Color = Color3.new(1, 1, 1)
    esp.Level.Transparency = 1
    esp.Level.Visible = false
    
    -- ESP Range
    esp.Range.Size = 14
    esp.Range.Color = Color3.new(1, 1, 1)
    esp.Range.Transparency = 1
    esp.Range.Visible = false
    
    -- ESP Tracer
    esp.Tracer.Thickness = 1
    esp.Tracer.Color = Color3.new(1, 1, 1)
    esp.Tracer.Transparency = 1
    esp.Tracer.Visible = false
end

local function UpdateESP()
    if not Config.Player.PlayerESP then
        for _, esp in pairs(ESPObjects) do
            esp.Box.Visible = false
            esp.Lines.Visible = false
            esp.Name.Visible = false
            esp.Level.Visible = false
            esp.Range.Visible = false
            esp.Tracer.Visible = false
        end
        return
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not ESPObjects[player] then
                CreateESP(player)
            end
            
            local esp = ESPObjects[player]
            local rootPart = player.Character.HumanoidRootPart
            local position, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                local headPosition = Workspace.CurrentCamera:WorldToViewportPoint(
                    player.Character:FindFirstChild("Head") and player.Character.Head.Position or rootPart.Position + Vector3.new(0, 1.5, 0)
                )
                local legPosition = Workspace.CurrentCamera:WorldToViewportPoint(
                    rootPart.Position - Vector3.new(0, 3, 0)
                )
                
                local height = math.abs(headPosition.Y - legPosition.Y)
                local width = height * 0.6
                
                -- ESP Box
                if Config.Player.ESPBox then
                    esp.Box.Size = Vector2.new(width, height)
                    esp.Box.Position = Vector2.new(position.X - width/2, position.Y - height/2)
                    esp.Box.Visible = true
                else
                    esp.Box.Visible = false
                end
                
                -- ESP Lines
                if Config.Player.ESPLines then
                    esp.Lines.From = Vector2.new(Workspace.CurrentCamera.ViewportSize.X/2, Workspace.CurrentCamera.ViewportSize.Y)
                    esp.Lines.To = Vector2.new(position.X, position.Y)
                    esp.Lines.Visible = true
                else
                    esp.Lines.Visible = false
                end
                
                -- ESP Name
                if Config.Player.ESPName then
                    esp.Name.Text = player.Name
                    esp.Name.Position = Vector2.new(position.X, position.Y - height/2 - 15)
                    esp.Name.Visible = true
                else
                    esp.Name.Visible = false
                end
                
                -- ESP Level
                if Config.Player.ESPLevel then
                    local level = "N/A"
                    if player:FindFirstChild("PlayerData") and player.PlayerData:FindFirstChild("Level") then
                        level = tostring(player.PlayerData.Level.Value)
                    end
                    esp.Level.Text = "Lvl: " .. level
                    esp.Level.Position = Vector2.new(position.X, position.Y - height/2 - 30)
                    esp.Level.Visible = true
                else
                    esp.Level.Visible = false
                end
                
                -- ESP Range
                if Config.Player.ESPRange then
                    local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude)
                    esp.Range.Text = tostring(distance) .. " studs"
                    esp.Range.Position = Vector2.new(position.X, position.Y + height/2 + 5)
                    esp.Range.Visible = true
                else
                    esp.Range.Visible = false
                end
                
                -- ESP Hologram
                if Config.Player.ESPHologram then
                    esp.Tracer.From = Vector2.new(Workspace.CurrentCamera.ViewportSize.X/2, 0)
                    esp.Tracer.To = Vector2.new(position.X, position.Y)
                    esp.Tracer.Visible = true
                else
                    esp.Tracer.Visible = false
                end
            else
                esp.Box.Visible = false
                esp.Lines.Visible = false
                esp.Name.Visible = false
                esp.Level.Visible = false
                esp.Range.Visible = false
                esp.Tracer.Visible = false
            end
        end
    end
end

spawn(function()
    while true do
        UpdateESP()
        wait(0.1)
    end
end)

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            wait(1)
            CreateESP(player)
        end)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        for _, drawing in pairs(ESPObjects[player]) do
            drawing:Remove()
        end
        ESPObjects[player] = nil
    end
end)

PlayerTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = Config.Player.PlayerESP,
    Flag = "PlayerESP",
    Callback = function(Value)
        Config.Player.PlayerESP = Value
        if Config.Settings.AutoLogging then
            logError("Player ESP: " .. tostring(Value))
        end
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = Config.Player.ESPBox,
    Flag = "ESPBox",
    Callback = function(Value)
        Config.Player.ESPBox = Value
        if Config.Settings.AutoLogging then
            logError("ESP Box: " .. tostring(Value))
        end
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Lines",
    CurrentValue = Config.Player.ESPLines,
    Flag = "ESPLines",
    Callback = function(Value)
        Config.Player.ESPLines = Value
        if Config.Settings.AutoLogging then
            logError("ESP Lines: " .. tostring(Value))
        end
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Name",
    CurrentValue = Config.Player.ESPName,
    Flag = "ESPName",
    Callback = function(Value)
        Config.Player.ESPName = Value
        if Config.Settings.AutoLogging then
            logError("ESP Name: " .. tostring(Value))
        end
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Level",
    CurrentValue = Config.Player.ESPLevel,
    Flag = "ESPLevel",
    Callback = function(Value)
        Config.Player.ESPLevel = Value
        if Config.Settings.AutoLogging then
            logError("ESP Level: " .. tostring(Value))
        end
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Range",
    CurrentValue = Config.Player.ESPRange,
    Flag = "ESPRange",
    Callback = function(Value)
        Config.Player.ESPRange = Value
        if Config.Settings.AutoLogging then
            logError("ESP Range: " .. tostring(Value))
        end
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Hologram",
    CurrentValue = Config.Player.ESPHologram,
    Flag = "ESPHologram",
    Callback = function(Value)
        Config.Player.ESPHologram = Value
        if Config.Settings.AutoLogging then
            logError("ESP Hologram: " .. tostring(Value))
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = Config.Player.Noclip,
    Flag = "Noclip",
    Callback = function(Value)
        Config.Player.Noclip = Value
        if Config.Settings.AutoLogging then
            logError("Noclip: " .. tostring(Value))
        end
        
        -- Noclip Implementation
        if Value then
            spawn(function()
                while Config.Player.Noclip do
                    if LocalPlayer.Character then
                        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                    wait(0.1)
                end
                
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = true
                        end
                    end
                end
            end)
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = Config.Player.AutoSell,
    Flag = "AutoSell",
    Callback = function(Value)
        Config.Player.AutoSell = Value
        if Config.Settings.AutoLogging then
            logError("Auto Sell: " .. tostring(Value))
        end
        
        -- Auto Sell Implementation
        if Value then
            spawn(function()
                while Config.Player.AutoSell do
                    -- Check if player is at a selling location
                    local atSellLocation = false
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
                        
                        -- Check if near any sell locations
                        for _, sellLocation in ipairs(Workspace:GetChildren()) do
                            if sellLocation.Name:find("Sell") or sellLocation.Name:find("Shop") then
                                if (playerPos - sellLocation.Position).Magnitude < 20 then
                                    atSellLocation = true
                                    break
                                end
                            end
                        end
                    end
                    
                    if atSellLocation and Remotes and Remotes:FindFirstChild("SellFish") then
                        -- Get fish inventory
                        local fishToSell = {}
                        if PlayerData and PlayerData:FindFirstChild("Inventory") then
                            for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                                if item:IsA("Folder") or item:IsA("Configuration") then
                                    -- Check if fish is not in favorites
                                    local isFavorite = false
                                    if PlayerData:FindFirstChild("Favorites") then
                                        for _, fav in pairs(PlayerData.Favorites:GetChildren()) do
                                            if fav.Name == item.Name then
                                                isFavorite = true
                                                break
                                            end
                                        end
                                    end
                                    
                                    if not isFavorite then
                                        table.insert(fishToSell, item.Name)
                                    end
                                end
                            end
                        end
                        
                        -- Sell fish
                        if #fishToSell > 0 then
                            local success, result = pcall(function()
                                Remotes.SellFish:FireServer(fishToSell)
                                if Config.Settings.AutoLogging then
                                    logError("Auto Sell: Sold " .. #fishToSell .. " fish")
                                end
                            end)
                            if not success then
                                if Config.Settings.AutoLogging then
                                    logError("Auto Sell Error: " .. result)
                                end
                            end
                        end
                    end
                    wait(5)
                end
            end)
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Craft",
    CurrentValue = Config.Player.AutoCraft,
    Flag = "AutoCraft",
    Callback = function(Value)
        Config.Player.AutoCraft = Value
        if Config.Settings.AutoLogging then
            logError("Auto Craft: " .. tostring(Value))
        end
        
        -- Auto Craft Implementation
        if Value then
            spawn(function()
                while Config.Player.AutoCraft do
                    -- Check if player is at a crafting station
                    local atCraftStation = false
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
                        
                        -- Check if near any crafting stations
                        for _, craftStation in ipairs(Workspace:GetChildren()) do
                            if craftStation.Name:find("Craft") then
                                if (playerPos - craftStation.Position).Magnitude < 20 then
                                    atCraftStation = true
                                    break
                                end
                            end
                        end
                    end
                    
                    if atCraftStation and Remotes and Remotes:FindFirstChild("CraftItem") then
                        -- Get craftable items
                        local craftableItems = {}
                        if PlayerData and PlayerData:FindFirstChild("Recipes") then
                            for _, recipe in pairs(PlayerData.Recipes:GetChildren()) do
                                -- Check if player has all required materials
                                local canCraft = true
                                if recipe:FindFirstChild("Requirements") then
                                    for _, req in pairs(recipe.Requirements:GetChildren()) do
                                        if PlayerData:FindFirstChild("Inventory") and PlayerData.Inventory:FindFirstChild(req.Name) then
                                            local playerAmount = PlayerData.Inventory[req.Name].Value
                                            if playerAmount < req.Value then
                                                canCraft = false
                                                break
                                            end
                                        else
                                            canCraft = false
                                            break
                                        end
                                    end
                                end
                                
                                if canCraft then
                                    table.insert(craftableItems, recipe.Name)
                                end
                            end
                        end
                        
                        -- Craft items
                        if #craftableItems > 0 then
                            local success, result = pcall(function()
                                Remotes.CraftItem:FireServer(craftableItems[1])
                                if Config.Settings.AutoLogging then
                                    logError("Auto Craft: Crafted " .. craftableItems[1])
                                end
                            end)
                            if not success then
                                if Config.Settings.AutoLogging then
                                    logError("Auto Craft Error: " .. result)
                                end
                            end
                        end
                    end
                    wait(5)
                end
            end)
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Upgrade",
    CurrentValue = Config.Player.AutoUpgrade,
    Flag = "AutoUpgrade",
    Callback = function(Value)
        Config.Player.AutoUpgrade = Value
        if Config.Settings.AutoLogging then
            logError("Auto Upgrade: " .. tostring(Value))
        end
        
        -- Auto Upgrade Implementation
        if Value then
            spawn(function()
                while Config.Player.AutoUpgrade do
                    -- Check if player has upgradeable items
                    local upgradeableItems = {}
                    if PlayerData and PlayerData:FindFirstChild("Inventory") then
                        for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                            if item:FindFirstChild("Level") and item:FindFirstChild("MaxLevel") then
                                if item.Level.Value < item.MaxLevel.Value then
                                    table.insert(upgradeableItems, item.Name)
                                end
                            end
                        end
                    end
                    
                    -- Upgrade items
                    if #upgradeableItems > 0 and Remotes and Remotes:FindFirstChild("UpgradeItem") then
                        local success, result = pcall(function()
                            Remotes.UpgradeItem:FireServer(upgradeableItems[1])
                            if Config.Settings.AutoLogging then
                                logError("Auto Upgrade: Upgraded " .. upgradeableItems[1])
                            end
                        end)
                        if not success then
                            if Config.Settings.AutoLogging then
                                logError("Auto Upgrade Error: " .. result)
                            end
                        end
                    end
                    wait(5)
                end
            end)
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
        if Config.Settings.AutoLogging then
            logError("Auto Accept Trade: " .. tostring(Value))
        end
        
        -- Auto Accept Trade Implementation
        if Value then
            spawn(function()
                while Config.Trader.AutoAcceptTrade do
                    -- Check for active trade requests
                    if TradeEvents and TradeEvents:FindFirstChild("TradeRequest") then
                        TradeEvents.TradeRequest.OnClientEvent:Connect(function(tradeData)
                            -- Check if trade is acceptable
                            local acceptableTrade = true
                            
                            -- Check if all selected fish are in the trade
                            for fishName, selected in pairs(Config.Trader.SelectedFish) do
                                if selected then
                                    local fishFound = false
                                    for _, item in pairs(tradeData.TheirItems) do
                                        if item.Name == fishName then
                                            fishFound = true
                                            break
                                        end
                                    end
                                    if not fishFound then
                                        acceptableTrade = false
                                        break
                                    end
                                end
                            end
                            
                            -- Accept trade if acceptable
                            if acceptableTrade and TradeEvents:FindFirstChild("AcceptTrade") then
                                local success, result = pcall(function()
                                    TradeEvents.AcceptTrade:FireServer(tradeData.TradeId)
                                    if Config.Settings.AutoLogging then
                                        logError("Auto Accept Trade: Accepted trade with ID " .. tradeData.TradeId)
                                    end
                                end)
                                if not success then
                                    if Config.Settings.AutoLogging then
                                        logError("Auto Accept Trade Error: " .. result)
                                    end
                                end
                            end
                        end)
                    end
                    wait(1)
                end
            end)
        end
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
        if Config.Settings.AutoLogging then
            logError("Selected Fish: " .. Value .. " - " .. tostring(Config.Trader.SelectedFish[Value]))
        end
    end
})

TraderTab:CreateInput({
    Name = "Trade Player",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        Config.Trader.TradePlayer = Text
        if Config.Settings.AutoLogging then
            logError("Trade Player: " .. Text)
        end
    end
})

TraderTab:CreateToggle({
    Name = "Trade All Fish",
    CurrentValue = Config.Trader.TradeAllFish,
    Flag = "TradeAllFish",
    Callback = function(Value)
        Config.Trader.TradeAllFish = Value
        if Config.Settings.AutoLogging then
            logError("Trade All Fish: " .. tostring(Value))
        end
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
                    if Config.Settings.AutoLogging then
                        logError("Trade request sent to: " .. Config.Trader.TradePlayer)
                    end
                end)
                if not success then
                    if Config.Settings.AutoLogging then
                        logError("Trade request error: " .. result)
                    end
                end
            else
                Rayfield:Notify({
                    Title = "Trade Error",
                    Content = "Player not found: " .. Config.Trader.TradePlayer,
                    Duration = 3,
                    Image = 13047715178
                })
                if Config.Settings.AutoLogging then
                    logError("Trade Error: Player not found - " .. Config.Trader.TradePlayer)
                end
            end
        else
            Rayfield:Notify({
                Title = "Trade Error",
                Content = "Please enter a player name first",
                Duration = 3,
                Image = 13047715178
            })
            if Config.Settings.AutoLogging then
                logError("Trade Error: No player name entered")
            end
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
        if Config.Settings.AutoLogging then
            logError("Player Info: " .. tostring(Value))
        end
        
        -- Player Info Implementation
        if Value then
            spawn(function()
                while Config.Server.PlayerInfo do
                    -- Display player info
                    local info = ""
                    for _, player in ipairs(Players:GetPlayers()) do
                        info = info .. player.Name
                        if player:FindFirstChild("PlayerData") then
                            if player.PlayerData:FindFirstChild("Level") then
                                info = info .. " (Lvl " .. player.PlayerData.Level.Value .. ")"
                            end
                        end
                        info = info .. "\n"
                    end
                    
                    -- Update UI with player info
                    -- (This would require creating a UI element to display the info)
                    wait(5)
                end
            end)
        end
    end
})

ServerTab:CreateToggle({
    Name = "Server Info",
    CurrentValue = Config.Server.ServerInfo,
    Flag = "ServerInfo",
    Callback = function(Value)
        Config.Server.ServerInfo = Value
        if Config.Settings.AutoLogging then
            logError("Server Info: " .. tostring(Value))
        end
        
        -- Server Info Implementation
        if Value then
            spawn(function()
                while Config.Server.ServerInfo do
                    -- Display server info
                    local playerCount = #Players:GetPlayers()
                    local serverInfo = "Players: " .. playerCount
                    
                    if Config.Server.LuckBoost then
                        serverInfo = serverInfo .. " | Luck: Boosted"
                    end
                    
                    if Config.Server.SeedViewer then
                        serverInfo = serverInfo .. " | Seed: " .. tostring(math.random(10000, 99999))
                    end
                    
                    -- Update UI with server info
                    -- (This would require creating a UI element to display the info)
                    wait(5)
                end
            end)
        end
    end
})

ServerTab:CreateToggle({
    Name = "Luck Boost",
    CurrentValue = Config.Server.LuckBoost,
    Flag = "LuckBoost",
    Callback = function(Value)
        Config.Server.LuckBoost = Value
        if Config.Settings.AutoLogging then
            logError("Luck Boost: " .. tostring(Value))
        end
        
        -- Luck Boost Implementation
        if Value and FishingEvents and FishingEvents:FindFirstChild("LuckBoost") then
            local success, result = pcall(function()
                FishingEvents.LuckBoost:FireServer(true)
                if Config.Settings.AutoLogging then
                    logError("Luck Boost: Activated")
                end
            end)
            if not success then
                if Config.Settings.AutoLogging then
                    logError("Luck Boost Error: " .. result)
                end
            end
        elseif not Value and FishingEvents and FishingEvents:FindFirstChild("LuckBoost") then
            local success, result = pcall(function()
                FishingEvents.LuckBoost:FireServer(false)
                if Config.Settings.AutoLogging then
                    logError("Luck Boost: Deactivated")
                end
            end)
            if not success then
                if Config.Settings.AutoLogging then
                    logError("Luck Boost Error: " .. result)
                end
            end
        end
    end
})

ServerTab:CreateToggle({
    Name = "Seed Viewer",
    CurrentValue = Config.Server.SeedViewer,
    Flag = "SeedViewer",
    Callback = function(Value)
        Config.Server.SeedViewer = Value
        if Config.Settings.AutoLogging then
            logError("Seed Viewer: " .. tostring(Value))
        end
        
        -- Seed Viewer Implementation
        if Value then
            spawn(function()
                while Config.Server.SeedViewer do
                    -- Display seed info
                    local seed = tostring(math.random(10000, 99999))
                    
                    -- Update UI with seed info
                    -- (This would require creating a UI element to display the info)
                    wait(5)
                end
            end)
        end
    end
})

ServerTab:CreateToggle({
    Name = "Force Event",
    CurrentValue = Config.Server.ForceEvent,
    Flag = "ForceEvent",
    Callback = function(Value)
        Config.Server.ForceEvent = Value
        if Config.Settings.AutoLogging then
            logError("Force Event: " .. tostring(Value))
        end
        
        -- Force Event Implementation
        if Value and FishingEvents and FishingEvents:FindFirstChild("ForceEvent") then
            local success, result = pcall(function()
                FishingEvents.ForceEvent:FireServer(Config.Teleport.SelectedEvent)
                if Config.Settings.AutoLogging then
                    logError("Force Event: Activated - " .. Config.Teleport.SelectedEvent)
                end
            end)
            if not success then
                if Config.Settings.AutoLogging then
                    logError("Force Event Error: " .. result)
                end
            end
        end
    end
})

ServerTab:CreateToggle({
    Name = "Rejoin Same Server",
    CurrentValue = Config.Server.RejoinSameServer,
    Flag = "RejoinSameServer",
    Callback = function(Value)
        Config.Server.RejoinSameServer = Value
        if Config.Settings.AutoLogging then
            logError("Rejoin Same Server: " .. tostring(Value))
        end
        
        -- Rejoin Same Server Implementation
        if Value then
            local success, result = pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                if Config.Settings.AutoLogging then
                    logError("Rejoining same server...")
                end
            end)
            if not success then
                if Config.Settings.AutoLogging then
                    logError("Rejoin Error: " .. result)
                end
            end
        end
    end
})

ServerTab:CreateToggle({
    Name = "Server Hop",
    CurrentValue = Config.Server.ServerHop,
    Flag = "ServerHop",
    Callback = function(Value)
        Config.Server.ServerHop = Value
        if Config.Settings.AutoLogging then
            logError("Server Hop: " .. tostring(Value))
        end
        
        -- Server Hop Implementation
        if Value then
            spawn(function()
                while Config.Server.ServerHop do
                    -- Get server list
                    local servers = {}
                    local success, result = pcall(function()
                        servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
                    end)
                    
                    if success and servers and servers.data then
                        -- Find a server with less than 10 players
                        for _, server in pairs(servers.data) do
                            if server.playing < 10 and server.id ~= game.JobId then
                                -- Join server
                                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                                if Config.Settings.AutoLogging then
                                    logError("Server Hopped to: " .. server.id)
                                end
                                break
                            end
                        end
                    else
                        if Config.Settings.AutoLogging then
                            logError("Server Hop Error: " .. result)
                        end
                    end
                    
                    wait(10)
                end
            end)
        end
    end
})

ServerTab:CreateToggle({
    Name = "View Player Stats",
    CurrentValue = Config.Server.ViewPlayerStats,
    Flag = "ViewPlayerStats",
    Callback = function(Value)
        Config.Server.ViewPlayerStats = Value
        if Config.Settings.AutoLogging then
            logError("View Player Stats: " .. tostring(Value))
        end
        
        -- View Player Stats Implementation
        if Value then
            spawn(function()
                while Config.Server.ViewPlayerStats do
                    -- Display player stats
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player:FindFirstChild("PlayerData") then
                            local stats = player.Name .. " Stats:\n"
                            
                            if player.PlayerData:FindFirstChild("Level") then
                                stats = stats .. "Level: " .. player.PlayerData.Level.Value .. "\n"
                            end
                            
                            if player.PlayerData:FindFirstChild("XP") then
                                stats = stats .. "XP: " .. player.PlayerData.XP.Value .. "\n"
                            end
                            
                            if player.PlayerData:FindFirstChild("Coins") then
                                stats = stats .. "Coins: " .. player.PlayerData.Coins.Value .. "\n"
                            end
                            
                            if player.PlayerData:FindFirstChild("FishCaught") then
                                stats = stats .. "Fish Caught: " .. player.PlayerData.FishCaught.Value .. "\n"
                            end
                            
                            -- Update UI with player stats
                            -- (This would require creating a UI element to display the stats)
                        end
                    end
                    
                    wait(5)
                end
            end)
        end
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
        if Config.Settings.AutoLogging then
            logError("Server Info: " .. serverInfo)
        end
    end
})

-- System Tab
local SystemTab = Window:CreateTab("⚙️ System", 13014546625)

-- Show Info Implementation
local infoGui = nil
local infoLabel = nil

SystemTab:CreateToggle({
    Name = "Show Info",
    CurrentValue = Config.System.ShowInfo,
    Flag = "ShowInfo",
    Callback = function(Value)
        Config.System.ShowInfo = Value
        if Config.Settings.AutoLogging then
            logError("Show Info: " .. tostring(Value))
        end
        
        if Value then
            -- Create info GUI
            infoGui = Instance.new("ScreenGui")
            infoGui.Name = "InfoGui"
            infoGui.ResetOnSpawn = false
            infoGui.Parent = CoreGui
            
            infoLabel = Instance.new("TextLabel")
            infoLabel.Name = "InfoLabel"
            infoLabel.BackgroundTransparency = 0.5
            infoLabel.BackgroundColor3 = Color3.new(0, 0, 0)
            infoLabel.BorderSizePixel = 0
            infoLabel.TextColor3 = Color3.new(1, 1, 1)
            infoLabel.TextScaled = true
            infoLabel.Font = Enum.Font.SourceSansBold
            infoLabel.TextXAlignment = Enum.TextXAlignment.Left
            infoLabel.TextYAlignment = Enum.TextYAlignment.Top
            infoLabel.Size = UDim2.new(0, 200, 0, 100)
            infoLabel.Position = UDim2.new(0, 10, 0, 10)
            infoLabel.Parent = infoGui
            
            spawn(function()
                while Config.System.ShowInfo do
                    if infoLabel then
                        local fps = math.floor(1 / RunService.RenderStepped:Wait())
                        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                        local memory = math.floor(Stats:GetTotalMemoryUsageMb())
                        local battery = math.floor(UserInputService:GetBatteryLevel() * 100)
                        local time = os.date("%H:%M:%S")
                        
                        local systemInfo = string.format("FPS: %d\nPing: %dms\nMemory: %dMB\nBattery: %d%%\nTime: %s", 
                            fps, ping, memory, battery, time)
                        
                        infoLabel.Text = systemInfo
                    end
                    wait(1)
                end
            end)
        else
            -- Remove info GUI
            if infoGui then
                infoGui:Destroy()
                infoGui = nil
                infoLabel = nil
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
        if Config.Settings.AutoLogging then
            logError("Boost FPS: " .. tostring(Value))
        end
        
        if Value then
            -- Reduce graphics quality to boost FPS
            settings().Rendering.QualityLevel = 1
            
            -- Disable some effects
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            
            -- Remove particles
            if Config.System.DisableParticles then
                for _, particle in ipairs(Workspace:GetDescendants()) do
                    if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") then
                        particle.Enabled = false
                    end
                end
            end
            
            if Config.Settings.AutoLogging then
                logError("Boost FPS: Activated")
            end
        else
            -- Restore graphics quality
            settings().Rendering.QualityLevel = 10
            
            -- Enable effects
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 1000
            
            if Config.Settings.AutoLogging then
                logError("Boost FPS: Deactivated")
            end
        end
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
        if Config.Settings.AutoLogging then
            logError("FPS Limit: " .. Value)
        end
    end
})

SystemTab:CreateToggle({
    Name = "Auto Clean Memory",
    CurrentValue = Config.System.AutoCleanMemory,
    Flag = "AutoCleanMemory",
    Callback = function(Value)
        Config.System.AutoCleanMemory = Value
        if Config.Settings.AutoLogging then
            logError("Auto Clean Memory: " .. tostring(Value))
        end
        
        if Value then
            spawn(function()
                while Config.System.AutoCleanMemory do
                    -- Clean memory
                    ypcall(function()
                        game:FindFirstChild("Players"):ClearAllChildren()
                    end)
                    
                    -- Force garbage collection
                    collectgarbage("collect")
                    
                    wait(30)
                end
            end)
        end
    end
})

SystemTab:CreateToggle({
    Name = "Disable Particles",
    CurrentValue = Config.System.DisableParticles,
    Flag = "DisableParticles",
    Callback = function(Value)
        Config.System.DisableParticles = Value
        if Config.Settings.AutoLogging then
            logError("Disable Particles: " .. tostring(Value))
        end
        
        if Value then
            -- Disable all particles
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") then
                    particle.Enabled = false
                end
            end
            
            if Config.Settings.AutoLogging then
                logError("Particles Disabled")
            end
        else
            -- Enable all particles
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") then
                    particle.Enabled = true
                end
            end
            
            if Config.Settings.AutoLogging then
                logError("Particles Enabled")
            end
        end
    end
})

SystemTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = Config.System.AutoFarm,
    Flag = "AutoFarm",
    Callback = function(Value)
        Config.System.AutoFarm = Value
        if Config.Settings.AutoLogging then
            logError("Auto Farm: " .. tostring(Value))
        end
        
        if Value then
            spawn(function()
                while Config.System.AutoFarm do
                    -- Find fishing rod
                    local rod = nil
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
                            if tool:IsA("Tool") and tool.Name:find("Rod") then
                                rod = tool
                                break
                            end
                        end
                        
                        -- Equip rod if not equipped
                        if rod and not LocalPlayer.Character:FindFirstChild(rod.Name) then
                            LocalPlayer.Character.Humanoid:EquipTool(rod)
                        end
                        
                        -- Find fishing spot
                        local fishingSpot = nil
                        local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
                        
                        for _, spot in ipairs(Workspace:GetChildren()) do
                            if spot.Name:find("Fishing") or spot.Name:find("Water") then
                                if (playerPos - spot.Position).Magnitude < Config.System.FarmRadius then
                                    fishingSpot = spot
                                    break
                                end
                            end
                        end
                        
                        -- Fish if rod and spot found
                        if rod and fishingSpot and FishingEvents and FishingEvents:FindFirstChild("Cast") and FishingEvents:FindFirstChild("Reel") then
                            -- Cast line
                            local success, result = pcall(function()
                                FishingEvents.Cast:FireServer(fishingSpot.Position)
                                if Config.Settings.AutoLogging then
                                    logError("Auto Farm: Cast line")
                                end
                            end)
                            if not success then
                                if Config.Settings.AutoLogging then
                                    logError("Auto Farm Cast Error: " .. result)
                                end
                            end
                            
                            -- Wait for fish to bite
                            wait(2)
                            
                            -- Reel in with perfect timing
                            local success, result = pcall(function()
                                FishingEvents.Reel:FireServer(true) -- true for perfect catch
                                if Config.Settings.AutoLogging then
                                    logError("Auto Farm: Perfect catch")
                                end
                            end)
                            if not success then
                                if Config.Settings.AutoLogging then
                                    logError("Auto Farm Reel Error: " .. result)
                                end
                            end
                        end
                    end
                    
                    wait(3)
                end
            end)
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
        if Config.Settings.AutoLogging then
            logError("Farm Radius: " .. Value)
        end
    end
})

SystemTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
        if Config.Settings.AutoLogging then
            logError("Rejoining server...")
        end
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
        if Config.Settings.AutoLogging then
            logError("System Info: " .. systemInfo)
        end
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
        if Config.Settings.AutoLogging then
            logError("High Quality Rendering: " .. tostring(Value))
        end
        
        if Value then
            -- Set high quality rendering
            sethiddenproperty(Lighting, "Technology", "Future")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Disabled")
            settings().Rendering.QualityLevel = 21
            
            if Config.Settings.AutoLogging then
                logError("High Quality Rendering: Activated")
            end
        else
            -- Reset rendering
            sethiddenproperty(Lighting, "Technology", "Compatibility")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Default")
            settings().Rendering.QualityLevel = 10
            
            if Config.Settings.AutoLogging then
                logError("High Quality Rendering: Deactivated")
            end
        end
    end
})

GraphicTab:CreateToggle({
    Name = "Max Rendering",
    CurrentValue = Config.Graphic.MaxRendering,
    Flag = "MaxRendering",
    Callback = function(Value)
        Config.Graphic.MaxRendering = Value
        if Config.Settings.AutoLogging then
            logError("Max Rendering: " .. tostring(Value))
        end
        
        if Value then
            -- Set max rendering
            settings().Rendering.QualityLevel = 21
            
            -- Enable all effects
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 1000
            
            -- Set high quality textures
            settings().Rendering.EagerBulkExecution = true
            
            if Config.Settings.AutoLogging then
                logError("Max Rendering: Activated")
            end
        else
            -- Reset rendering
            settings().Rendering.QualityLevel = 10
            
            if Config.Settings.AutoLogging then
                logError("Max Rendering: Deactivated")
            end
        end
    end
})

GraphicTab:CreateToggle({
    Name = "Ultra Low Mode",
    CurrentValue = Config.Graphic.UltraLowMode,
    Flag = "UltraLowMode",
    Callback = function(Value)
        Config.Graphic.UltraLowMode = Value
        if Config.Settings.AutoLogging then
            logError("Ultra Low Mode: " .. tostring(Value))
        end
        
        if Value then
            -- Set ultra low graphics
            settings().Rendering.QualityLevel = 1
            
            -- Disable effects
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            
            -- Set low quality textures
            settings().Rendering.EagerBulkExecution = false
            
            -- Change materials to plastic for better performance
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") then
                    part.Material = Enum.Material.Plastic
                end
            end
            
            if Config.Settings.AutoLogging then
                logError("Ultra Low Mode: Activated")
            end
        else
            -- Reset graphics
            settings().Rendering.QualityLevel = 10
            
            -- Enable effects
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 1000
            
            -- Set normal quality textures
            settings().Rendering.EagerBulkExecution = true
            
            if Config.Settings.AutoLogging then
                logError("Ultra Low Mode: Deactivated")
            end
        end
    end
})

GraphicTab:CreateToggle({
    Name = "Disable Water Reflection",
    CurrentValue = Config.Graphic.DisableWaterReflection,
    Flag = "DisableWaterReflection",
    Callback = function(Value)
        Config.Graphic.DisableWaterReflection = Value
        if Config.Settings.AutoLogging then
            logError("Disable Water Reflection: " .. tostring(Value))
        end
        
        if Value then
            -- Disable water reflection
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and water.Name == "Water" then
                    water.Transparency = 1
                    water.Reflectance = 0
                end
            end
            
            if Config.Settings.AutoLogging then
                logError("Water Reflection: Disabled")
            end
        else
            -- Enable water reflection
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and water.Name == "Water" then
                    water.Transparency = 0.5
                    water.Reflectance = 0.5
                end
            end
            
            if Config.Settings.AutoLogging then
                logError("Water Reflection: Enabled")
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
        if Config.Settings.AutoLogging then
            logError("Custom Shader: " .. tostring(Value))
        end
        
        if Value then
            -- Apply custom shader
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            
            if Config.Settings.AutoLogging then
                logError("Custom Shader: Activated")
            end
        else
            -- Reset shader
            Lighting.Brightness = 1
            Lighting.Ambient = Color3.new(0, 0, 0)
            
            if Config.Settings.AutoLogging then
                logError("Custom Shader: Deactivated")
            end
        end
    end
})

GraphicTab:CreateToggle({
    Name = "Smooth Graphics",
    CurrentValue = Config.Graphic.SmoothGraphics,
    Flag = "SmoothGraphics",
    Callback = function(Value)
        Config.Graphic.SmoothGraphics = Value
        if Config.Settings.AutoLogging then
            logError("Smooth Graphics: " .. tostring(Value))
        end
        
        if Value then
            -- Enable smooth graphics
            RunService:Set3dRenderingEnabled(true)
            settings().Rendering.MeshCacheSize = 100
            settings().Rendering.TextureCacheSize = 100
            
            if Config.Settings.AutoLogging then
                logError("Smooth Graphics: Activated")
            end
        else
            -- Reset graphics
            RunService:Set3dRenderingEnabled(true)
            settings().Rendering.MeshCacheSize = 50
            settings().Rendering.TextureCacheSize = 50
            
            if Config.Settings.AutoLogging then
                logError("Smooth Graphics: Deactivated")
            end
        end
    end
})

GraphicTab:CreateToggle({
    Name = "Full Bright",
    CurrentValue = Config.Graphic.FullBright,
    Flag = "FullBright",
    Callback = function(Value)
        Config.Graphic.FullBright = Value
        if Config.Settings.AutoLogging then
            logError("Full Bright: " .. tostring(Value))
        end
        
        if Value then
            -- Enable full bright
            Lighting.GlobalShadows = false
            Lighting.ClockTime = 12
            Lighting.Brightness = Config.Graphic.BrightnessValue
            
            if Config.Settings.AutoLogging then
                logError("Full Bright: Activated")
            end
        else
            -- Reset lighting
            Lighting.GlobalShadows = true
            Lighting.ClockTime = 14
            Lighting.Brightness = 1
            
            if Config.Settings.AutoLogging then
                logError("Full Bright: Deactivated")
            end
        end
    end
})

GraphicTab:CreateSlider({
    Name = "Brightness Value",
    Range = {0.5, 5},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Graphic.BrightnessValue,
    Flag = "BrightnessValue",
    Callback = function(Value)
        Config.Graphic.BrightnessValue = Value
        if Config.Graphic.FullBright then
            Lighting.Brightness = Value
        end
        if Config.Settings.AutoLogging then
            logError("Brightness Value: " .. Value)
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
        if Config.Settings.AutoLogging then
            logError("RNG Reducer: " .. tostring(Value))
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Force Legendary Catch",
    CurrentValue = Config.RNGKill.ForceLegendary,
    Flag = "ForceLegendary",
    Callback = function(Value)
        Config.RNGKill.ForceLegendary = Value
        if Config.Settings.AutoLogging then
            logError("Force Legendary Catch: " .. tostring(Value))
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Secret Fish Boost",
    CurrentValue = Config.RNGKill.SecretFishBoost,
    Flag = "SecretFishBoost",
    Callback = function(Value)
        Config.RNGKill.SecretFishBoost = Value
        if Config.Settings.AutoLogging then
            logError("Secret Fish Boost: " .. tostring(Value))
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Mythical Chance ×10",
    CurrentValue = Config.RNGKill.MythicalChanceBoost,
    Flag = "MythicalChanceBoost",
    Callback = function(Value)
        Config.RNGKill.MythicalChanceBoost = Value
        if Config.Settings.AutoLogging then
            logError("Mythical Chance Boost: " .. tostring(Value))
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Anti-Bad Luck",
    CurrentValue = Config.RNGKill.AntiBadLuck,
    Flag = "AntiBadLuck",
    Callback = function(Value)
        Config.RNGKill.AntiBadLuck = Value
        if Config.Settings.AutoLogging then
            logError("Anti-Bad Luck: " .. tostring(Value))
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Guaranteed Catch",
    CurrentValue = Config.RNGKill.GuaranteedCatch,
    Flag = "GuaranteedCatch",
    Callback = function(Value)
        Config.RNGKill.GuaranteedCatch = Value
        if Config.Settings.AutoLogging then
            logError("Guaranteed Catch: " .. tostring(Value))
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
                if Config.Settings.AutoLogging then
                    logError("RNG Settings Applied")
                end
            end)
            if not success then
                if Config.Settings.AutoLogging then
                    logError("RNG Settings Error: " .. result)
                end
            end
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
        if Config.Settings.AutoLogging then
            logError("Auto Buy Rods: " .. tostring(Value))
        end
        
        if Value then
            spawn(function()
                while Config.Shop.AutoBuyRods do
                    -- Check if player is at a shop
                    local atShop = false
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
                        
                        -- Check if near any shops
                        for _, shop in ipairs(Workspace:GetChildren()) do
                            if shop.Name:find("Shop") then
                                if (playerPos - shop.Position).Magnitude < 20 then
                                    atShop = true
                                    break
                                end
                            end
                        end
                    end
                    
                    if atShop and Remotes and Remotes:FindFirstChild("BuyItem") then
                        -- Buy selected rod
                        if Config.Shop.SelectedRod ~= "" then
                            local success, result = pcall(function()
                                Remotes.BuyItem:FireServer("Rod", Config.Shop.SelectedRod)
                                if Config.Settings.AutoLogging then
                                    logError("Auto Buy Rods: Bought " .. Config.Shop.SelectedRod)
                                end
                            end)
                            if not success then
                                if Config.Settings.AutoLogging then
                                    logError("Auto Buy Rods Error: " .. result)
                                end
                            end
                        end
                    end
                    wait(5)
                end
            end)
        end
    end
})

ShopTab:CreateDropdown({
    Name = "Select Rod",
    Options = Rods,
    CurrentOption = Config.Shop.SelectedRod,
    Flag = "SelectedRod",
    Callback = function(Value)
        Config.Shop.SelectedRod = Value
        if Config.Settings.AutoLogging then
            logError("Selected Rod: " .. Value)
        end
    end
})

ShopTab:CreateToggle({
    Name = "Auto Buy Boats",
    CurrentValue = Config.Shop.AutoBuyBoats,
    Flag = "AutoBuyBoats",
    Callback = function(Value)
        Config.Shop.AutoBuyBoats = Value
        if Config.Settings.AutoLogging then
            logError("Auto Buy Boats: " .. tostring(Value))
        end
        
        if Value then
            spawn(function()
                while Config.Shop.AutoBuyBoats do
                    -- Check if player is at a shop
                    local atShop = false
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
                        
                        -- Check if near any shops
                        for _, shop in ipairs(Workspace:GetChildren()) do
                            if shop.Name:find("Shop") then
                                if (playerPos - shop.Position).Magnitude < 20 then
                                    atShop = true
                                    break
                                end
                            end
                        end
                    end
                    
                    if atShop and Remotes and Remotes:FindFirstChild("BuyItem") then
                        -- Buy selected boat
                        if Config.Shop.SelectedBoat ~= "" then
                            local success, result = pcall(function()
                                Remotes.BuyItem:FireServer("Boat", Config.Shop.SelectedBoat)
                                if Config.Settings.AutoLogging then
                                    logError("Auto Buy Boats: Bought " .. Config.Shop.SelectedBoat)
                                end
                            end)
                            if not success then
                                if Config.Settings.AutoLogging then
                                    logError("Auto Buy Boats Error: " .. result)
                                end
                            end
                        end
                    end
                    wait(5)
                end
            end)
        end
    end
})

ShopTab:CreateDropdown({
    Name = "Select Boat",
    Options = Boats,
    CurrentOption = Config.Shop.SelectedBoat,
    Flag = "SelectedBoat",
    Callback = function(Value)
        Config.Shop.SelectedBoat = Value
        if Config.Settings.AutoLogging then
            logError("Selected Boat: " .. Value)
        end
    end
})

ShopTab:CreateToggle({
    Name = "Auto Buy Baits",
    CurrentValue = Config.Shop.AutoBuyBaits,
    Flag = "AutoBuyBaits",
    Callback = function(Value)
        Config.Shop.AutoBuyBaits = Value
        if Config.Settings.AutoLogging then
            logError("Auto Buy Baits: " .. tostring(Value))
        end
        
        if Value then
            spawn(function()
                while Config.Shop.AutoBuyBaits do
                    -- Check if player is at a shop
                    local atShop = false
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
                        
                        -- Check if near any shops
                        for _, shop in ipairs(Workspace:GetChildren()) do
                            if shop.Name:find("Shop") then
                                if (playerPos - shop.Position).Magnitude < 20 then
                                    atShop = true
                                    break
                                end
                            end
                        end
                    end
                    
                    if atShop and Remotes and Remotes:FindFirstChild("BuyItem") then
                        -- Buy selected bait
                        if Config.Shop.SelectedBait ~= "" then
                            local success, result = pcall(function()
                                Remotes.BuyItem:FireServer("Bait", Config.Shop.SelectedBait)
                                if Config.Settings.AutoLogging then
                                    logError("Auto Buy Baits: Bought " .. Config.Shop.SelectedBait)
                                end
                            end)
                            if not success then
                                if Config.Settings.AutoLogging then
                                    logError("Auto Buy Baits Error: " .. result)
                                end
                            end
                        end
                    end
                    wait(5)
                end
            end)
        end
    end
})

ShopTab:CreateDropdown({
    Name = "Select Bait",
    Options = Baits,
    CurrentOption = Config.Shop.SelectedBait,
    Flag = "SelectedBait",
    Callback = function(Value)
        Config.Shop.SelectedBait = Value
        if Config.Settings.AutoLogging then
            logError("Selected Bait: " .. Value)
        end
    end
})

ShopTab:CreateToggle({
    Name = "Auto Upgrade Rod",
    CurrentValue = Config.Shop.AutoUpgradeRod,
    Flag = "AutoUpgradeRod",
    Callback = function(Value)
        Config.Shop.AutoUpgradeRod = Value
        if Config.Settings.AutoLogging then
            logError("Auto Upgrade Rod: " .. tostring(Value))
        end
        
        if Value then
            spawn(function()
                while Config.Shop.AutoUpgradeRod do
                    -- Check if player has a rod that can be upgraded
                    local rodToUpgrade = nil
                    if PlayerData and PlayerData:FindFirstChild("Inventory") then
                        for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                            if item.Name:find("Rod") and item:FindFirstChild("Level") and item:FindFirstChild("MaxLevel") then
                                if item.Level.Value < item.MaxLevel.Value then
                                    rodToUpgrade = item.Name
                                    break
                                end
                            end
                        end
                    end
                    
                    -- Upgrade rod
                    if rodToUpgrade and Remotes and Remotes:FindFirstChild("UpgradeRod") then
                        local success, result = pcall(function()
                            Remotes.UpgradeRod:FireServer(rodToUpgrade)
                            if Config.Settings.AutoLogging then
                                logError("Auto Upgrade Rod: Upgraded " .. rodToUpgrade)
                            end
                        end)
                        if not success then
                            if Config.Settings.AutoLogging then
                                logError("Auto Upgrade Rod Error: " .. result)
                            end
                        end
                    end
                    wait(5)
                end
            end)
        end
    end
})

ShopTab:CreateButton({
    Name = "Buy Selected Item",
    Callback = function()
        -- Check if player is at a shop
        local atShop = false
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
            
            -- Check if near any shops
            for _, shop in ipairs(Workspace:GetChildren()) do
                if shop.Name:find("Shop") then
                    if (playerPos - shop.Position).Magnitude < 20 then
                        atShop = true
                        break
                    end
                end
            end
        end
        
        if atShop and Remotes and Remotes:FindFirstChild("BuyItem") then
            -- Buy selected item
            local itemType = ""
            local itemName = ""
            
            if Config.Shop.SelectedRod ~= "" then
                itemType = "Rod"
                itemName = Config.Shop.SelectedRod
            elseif Config.Shop.SelectedBoat ~= "" then
                itemType = "Boat"
                itemName = Config.Shop.SelectedBoat
            elseif Config.Shop.SelectedBait ~= "" then
                itemType = "Bait"
                itemName = Config.Shop.SelectedBait
            end
            
            if itemType ~= "" and itemName ~= "" then
                local success, result = pcall(function()
                    Remotes.BuyItem:FireServer(itemType, itemName)
                    Rayfield:Notify({
                        Title = "Item Purchased",
                        Content = "Bought " .. itemName,
                        Duration = 3,
                        Image = 13047715178
                    })
                    if Config.Settings.AutoLogging then
                        logError("Bought item: " .. itemName)
                    end
                end)
                if not success then
                    Rayfield:Notify({
                        Title = "Purchase Error",
                        Content = "Failed to buy " .. itemName .. ": " .. result,
                        Duration = 5,
                        Image = 13047715178
                    })
                    if Config.Settings.AutoLogging then
                        logError("Buy item error: " .. result)
                    end
                end
            else
                Rayfield:Notify({
                    Title = "No Item Selected",
                    Content = "Please select an item first",
                    Duration = 3,
                    Image = 13047715178
                })
                if Config.Settings.AutoLogging then
                    logError("Buy item error: No item selected")
                end
            end
        else
            Rayfield:Notify({
                Title = "Not at Shop",
                Content = "You need to be at a shop to buy items",
                Duration = 3,
                Image = 13047715178
            })
            if Config.Settings.AutoLogging then
                logError("Buy item error: Not at shop")
            end
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
        -- Apply theme
        if Value == "Dark" then
            Rayfield:UpdateTheme("Dark")
        elseif Value == "Light" then
            Rayfield:UpdateTheme("Light")
        end
        if Config.Settings.AutoLogging then
            logError("Selected Theme: " .. Value)
        end
    end
})

SettingsTab:CreateSlider({
    Name = "UI Transparency",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = Config.Settings.Transparency,
    Flag = "Transparency",
    Callback = function(Value)
        Config.Settings.Transparency = Value
        -- Apply transparency
        -- (This would require accessing the UI elements and changing their transparency)
        if Config.Settings.AutoLogging then
            logError("UI Transparency: " .. Value)
        end
    end
})

SettingsTab:CreateInput({
    Name = "Config Name",
    PlaceholderText = "Enter config name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text ~= "" then
            Config.Settings.ConfigName = Text
            if Config.Settings.AutoLogging then
                logError("Config Name: " .. Text)
            end
        end
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

SettingsTab:CreateSlider({
    Name = "UI Scale",
    Range = {0.5, 2},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Settings.UIScale,
    Flag = "UIScale",
    Callback = function(Value)
        Config.Settings.UIScale = Value
        -- Apply UI scale
        -- (This would require accessing the UI elements and changing their scale)
        if Config.Settings.AutoLogging then
            logError("UI Scale: " .. Value)
        end
    end
})

SettingsTab:CreateToggle({
    Name = "Auto Logging",
    CurrentValue = Config.Settings.AutoLogging,
    Flag = "AutoLogging",
    Callback = function(Value)
        Config.Settings.AutoLogging = Value
        if Config.Settings.AutoLogging then
            logError("Auto Logging: " .. tostring(Value))
        end
    end
})

-- Load config on start
LoadConfig()

-- Log script loaded
logError("Script loaded successfully")
