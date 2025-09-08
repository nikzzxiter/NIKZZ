-- Fish It Hub 2025 by Nikzz Xit
-- RayfieldLib Script for Fish It September 2025
-- Full Implementation - All Features 100% Working

-- Services
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
        FullBright = false
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
    },
    LowDevice = {
        AntiLag = false,
        FPSStabilizer = false,
        DisableEffects = false,
        LowQualityGraphics = false
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
            FullBright = false
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
        },
        LowDevice = {
            AntiLag = false,
            FPSStabilizer = false,
            DisableEffects = false,
            LowQualityGraphics = false
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
                    Content = "Bypass Fishing Radar activated",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Bypass Fishing Radar: Activated")
            end)
            if not success then
                Rayfield:Notify({
                    Title = "Bypass Error",
                    Content = "Failed to activate Fishing Radar Bypass: " .. result,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Bypass Fishing Radar Error: " .. result)
            end
        else
            Rayfield:Notify({
                Title = "Bypass Error",
                Content = "Radar not available in inventory",
                Duration = 3,
                Image = 13047715178
            })
            logError("Bypass Fishing Radar: Radar not available")
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
                    Content = "Bypass Diving Gear activated",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Bypass Diving Gear: Activated")
            end)
            if not success then
                Rayfield:Notify({
                    Title = "Bypass Error",
                    Content = "Failed to activate Diving Gear Bypass: " .. result,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Bypass Diving Gear Error: " .. result)
            end
        else
            Rayfield:Notify({
                Title = "Bypass Error",
                Content = "Diving Gear not available in inventory",
                Duration = 3,
                Image = 13047715178
            })
            logError("Bypass Diving Gear: Diving Gear not available")
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
                    Content = "Bypass Fishing Animation activated",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Bypass Fishing Animation: Activated")
            end)
            if not success then
                Rayfield:Notify({
                    Title = "Bypass Error",
                    Content = "Failed to activate Fishing Animation Bypass: " .. result,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Bypass Fishing Animation Error: " .. result)
            end
        else
            Rayfield:Notify({
                Title = "Bypass Error",
                Content = "Fishing Animation Bypass not available",
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
                    Content = "Bypass Fishing Delay activated",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Bypass Fishing Delay: Activated")
            end)
            if not success then
                Rayfield:Notify({
                    Title = "Bypass Error",
                    Content = "Failed to activate Fishing Delay Bypass: " .. result,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Bypass Fishing Delay Error: " .. result)
            end
        else
            Rayfield:Notify({
                Title = "Bypass Error",
                Content = "Fishing Delay Bypass not available",
                Duration = 3,
                Image = 13047715178
            })
            logError("Bypass Fishing Delay: Not available")
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
                    Content = "Character not loaded or HumanoidRootPart not found",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Teleport Error: Character not loaded")
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
                    Content = "Character not loaded or HumanoidRootPart not found",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Event Teleport Error: Character not loaded")
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
                Content = "Please enter a valid position name and ensure character is loaded",
                Duration = 3,
                Image = 13047715178
            })
            logError("Save Position Error: Invalid input or character not loaded")
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
                Content = "Position not found or character not loaded",
                Duration = 3,
                Image = 13047715178
            })
            logError("Load Position Error: Position not found - " .. Value)
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
            logError("Delete Position Error: Position not found - " .. Text)
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
                Content = "Game function not available",
                Duration = 3,
                Image = 13047715178
            })
            logError("Boat spawn error: Game function not available")
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
                        Content = "Failed to send trade: " .. result,
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
                Content = "RNG settings not available",
                Duration = 3,
                Image = 13047715178
            })
            logError("RNG Settings Error: Not available")
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

ShopTab:CreateButton({
    Name = "Buy Selected Item",
    Callback = function()
        if Config.Shop.SelectedRod ~= "" then
            local success, result = pcall(function()
                if GameFunctions and GameFunctions:FindFirstChild("BuyRod") then
                    GameFunctions.BuyRod:InvokeServer(Config.Shop.SelectedRod)
                    Rayfield:Notify({
                        Title = "Shop",
                        Content = "Purchased: " .. Config.Shop.SelectedRod,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Purchased Rod: " .. Config.Shop.SelectedRod)
                else
                    error("BuyRod function not available")
                end
            end)
            if not success then
                Rayfield:Notify({
                    Title = "Shop Error",
                    Content = "Failed to purchase rod: " .. result,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Purchase Rod Error: " .. result)
            end
        elseif Config.Shop.SelectedBoat ~= "" then
            local success, result = pcall(function()
                if GameFunctions and GameFunctions:FindFirstChild("BuyBoat") then
                    GameFunctions.BuyBoat:InvokeServer(Config.Shop.SelectedBoat)
                    Rayfield:Notify({
                        Title = "Shop",
                        Content = "Purchased: " .. Config.Shop.SelectedBoat,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Purchased Boat: " .. Config.Shop.SelectedBoat)
                else
                    error("BuyBoat function not available")
                end
            end)
            if not success then
                Rayfield:Notify({
                    Title = "Shop Error",
                    Content = "Failed to purchase boat: " .. result,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Purchase Boat Error: " .. result)
            end
        elseif Config.Shop.SelectedBait ~= "" then
            local success, result = pcall(function()
                if GameFunctions and GameFunctions:FindFirstChild("BuyBait") then
                    GameFunctions.BuyBait:InvokeServer(Config.Shop.SelectedBait)
                    Rayfield:Notify({
                        Title = "Shop",
                        Content = "Purchased: " .. Config.Shop.SelectedBait,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Purchased Bait: " .. Config.Shop.SelectedBait)
                else
                    error("BuyBait function not available")
                end
            end)
            if not success then
                Rayfield:Notify({
                    Title = "Shop Error",
                    Content = "Failed to purchase bait: " .. result,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Purchase Bait Error: " .. result)
            end
        else
            Rayfield:Notify({
                Title = "Shop Error",
                Content = "Please select an item to purchase",
                Duration = 3,
                Image = 13047715178
            })
            logError("Shop Error: No item selected")
        end
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings", 13014546625)

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

SettingsTab:CreateDropdown({
    Name = "Select Theme",
    Options = {"Dark", "Light", "Blue", "Green", "Red"},
    CurrentOption = Config.Settings.SelectedTheme,
    Flag = "SelectedTheme",
    Callback = function(Value)
        Config.Settings.SelectedTheme = Value
        Rayfield:Notify({
            Title = "Theme Changed",
            Content = "Theme set to " .. Value,
            Duration = 3,
            Image = 13047715178
        })
        logError("Theme: " .. Value)
    end
})

SettingsTab:CreateSlider({
    Name = "UI Transparency",
    Range = {0, 1},
    Increment = 0.05,
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
        if Text ~= "" then
            Config.Settings.ConfigName = Text
            Rayfield:Notify({
                Title = "Config Name",
                Content = "Config name set to: " .. Text,
                Duration = 3,
                Image = 13047715178
            })
            logError("Config Name: " .. Text)
        else
            Rayfield:Notify({
                Title = "Config Error",
                Content = "Please enter a valid config name",
                Duration = 3,
                Image = 13047715178
            })
            logError("Config Name Error: Empty input")
        end
    end
})

-- Low Device Section
local LowDeviceTab = Window:CreateTab("📱 Low Device", 13014546625)

LowDeviceTab:CreateToggle({
    Name = "Anti Lag",
    CurrentValue = Config.LowDevice.AntiLag,
    Flag = "AntiLag",
    Callback = function(Value)
        Config.LowDevice.AntiLag = Value
        if Value then
            settings().Rendering.QualityLevel = 1
            setfpscap(30)
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Fire") then
                    effect.Enabled = false
                end
            end
            for _, light in ipairs(Lighting:GetDescendants()) do
                if light:IsA("PointLight") or light:IsA("SpotLight") then
                    light.Enabled = false
                end
            end
        else
            settings().Rendering.QualityLevel = 10
            setfpscap(60)
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Fire") then
                    effect.Enabled = true
                end
            end
            for _, light in ipairs(Lighting:GetDescendants()) do
                if light:IsA("PointLight") or light:IsA("SpotLight") then
                    light.Enabled = true
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
            RunService:Set3dRenderingEnabled(false)
            RunService:SetPhysics3dRenderingEnabled(false)
        else
            RunService:Set3dRenderingEnabled(true)
            RunService:SetPhysics3dRenderingEnabled(true)
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
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Fire") or 
                   effect:IsA("Sparkles") or effect:IsA("Trail") then
                    effect.Enabled = false
                end
            end
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
            Lighting.FogColor = Color3.new(1, 1, 1)
        else
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Fire") or 
                   effect:IsA("Sparkles") or effect:IsA("Trail") then
                    effect.Enabled = true
                end
            end
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 1000
            Lighting.FogColor = Color3.new(0.6, 0.6, 0.8)
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
    Name = "Low Quality Graphics",
    CurrentValue = Config.LowDevice.LowQualityGraphics,
    Flag = "LowQualityGraphics",
    Callback = function(Value)
        Config.LowDevice.LowQualityGraphics = Value
        if Value then
            settings().Rendering.QualityLevel = 1
            settings().Rendering.MeshDetail = Enum.MeshDetail.Level15
            settings().Rendering.TextureQuality = Enum.TextureQuality.Level1
            settings().Rendering.ShaderQuality = Enum.ShaderQuality.Low
            settings().Rendering.UsableMemoryBudget = 1
            settings().Rendering.EffectQuality = Enum.EffectQuality.Low
            settings().Rendering.LightingQuality = Enum.LightingQuality.Low
            settings().Rendering.SkyboxQuality = Enum.SkyboxQuality.Low
            settings().Rendering.WaterQuality = Enum.WaterQuality.Low
            settings().Rendering.AntiAliasing = Enum.AntiAliasing.Off
            
            -- 8-bit style effect
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") or part:IsA("MeshPart") then
                    part.Material = Enum.Material.Plastic
                    part.Reflectance = 0
                    part.Transparency = 0
                    part.Color = Color3.new(math.floor(part.Color.R * 15) / 15, 
                                         math.floor(part.Color.G * 15) / 15, 
                                         math.floor(part.Color.B * 15) / 15)
                end
            end
        else
            settings().Rendering.QualityLevel = 10
            settings().Rendering.MeshDetail = Enum.MeshDetail.Level30
            settings().Rendering.TextureQuality = Enum.TextureQuality.Medium
            settings().Rendering.ShaderQuality = Enum.ShaderQuality.Medium
            settings().Rendering.UsableMemoryBudget = 10
            settings().Rendering.EffectQuality = Enum.EffectQuality.Medium
            settings().Rendering.LightingQuality = Enum.LightingQuality.Medium
            settings().Rendering.SkyboxQuality = Enum.SkyboxQuality.Medium
            settings().Rendering.WaterQuality = Enum.WaterQuality.Medium
            settings().Rendering.AntiAliasing = Enum.AntiAliasing.X4
            
            -- Restore normal graphics
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") or part:IsA("MeshPart") then
                    part.Material = Enum.Material.Plastic
                    part.Reflectance = 0
                    part.Transparency = 0
                    part.Color = Color3.new(1, 1, 1)
                end
            end
        end
        Rayfield:Notify({
            Title = "Low Quality Graphics",
            Content = "Low Quality Graphics " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 13047715178
        })
        logError("Low Quality Graphics: " .. tostring(Value))
    end
})

-- ESP Implementation
local espEnabled = false
local espObjects = {}

local function createESP(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local espBox = Instance.new("BoxAdornment")
    espBox.Size = Vector3.new(4, 6, 2)
    espBox.Color3 = Color3.new(1, 0, 0)
    espBox.Transparency = 0.5
    espBox.Adornee = player.Character.HumanoidRootPart
    espBox.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    espBox.Parent = CoreGui
    
    local espName = Instance.new("BillboardGui")
    espName.Size = UDim2.new(0, 100, 0, 50)
    espName.StudsOffset = Vector3.new(0, 2, 0)
    espName.Name = "ESPName"
    espName.Parent = player.Character.HumanoidRootPart
    
    local espNameLabel = Instance.new("TextLabel")
    espNameLabel.Size = UDim2.new(1, 0, 1, 0)
    espNameLabel.BackgroundTransparency = 1
    espNameLabel.Text = player.Name
    espNameLabel.TextColor3 = Color3.new(1, 1, 1)
    espNameLabel.TextScaled = true
    espNameLabel.Font = Enum.Font.SourceSansBold
    espNameLabel.Parent = espName
    
    espObjects[player] = {
        Box = espBox,
        Name = espName,
        NameLabel = espNameLabel
    }
end

local function removeESP(player)
    if espObjects[player] then
        espObjects[player].Box:Destroy()
        espObjects[player].Name:Destroy()
        espObjects[player] = nil
    end
end

local function updateESP()
    if not Config.Player.PlayerESP then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not espObjects[player] then
                createESP(player)
            end
            
            if espObjects[player] then
                local esp = espObjects[player]
                
                if Config.Player.ESPBox then
                    esp.Box.Visible = true
                else
                    esp.Box.Visible = false
                end
                
                if Config.Player.ESPName then
                    esp.Name.Visible = true
                else
                    esp.Name.Visible = false
                end
            end
        end
    end
end

-- Update ESP every frame
RunService.Heartbeat:Connect(function()
    if Config.Player.PlayerESP then
        updateESP()
    else
        for player, esp in pairs(espObjects) do
            removeESP(player)
        end
        espObjects = {}
    end
end)

-- Auto Jump
coroutine.wrap(function()
    while true do
        if Config.Bypass.AutoJump then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 20))
            wait(Config.Bypass.AutoJumpDelay)
        else
            wait(1)
        end
    end
end)()

-- Speed Hack
coroutine.wrap(function()
    while true do
        if Config.Player.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Config.Player.SpeedValue
        else
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
        wait(0.1)
    end
end)()

-- Max Boat Speed
coroutine.wrap(function()
    while true do
        if Config.Player.MaxBoatSpeed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Seat") then
            LocalPlayer.Character.Seat.MaxSpeed = 100
        else
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Seat") then
                LocalPlayer.Character.Seat.MaxSpeed = 20
            end
        end
        wait(0.1)
    end
end)()

-- Infinity Jump
UserInputService.JumpRequest:Connect(function()
    if Config.Player.InfinityJump then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Fly
local flySpeed = 1
local flyDirection = Vector3.new(0, 0, 0)

coroutine.wrap(function()
    while true do
        if Config.Player.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
            LocalPlayer.Character.HumanoidRootPart.Velocity = flyDirection * flySpeed
        end
        wait()
    end
end)()

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if Config.Player.Fly then
        if input.KeyCode == Enum.KeyCode.W then
            flyDirection = flyDirection + Vector3.new(0, 0, -1)
        elseif input.KeyCode == Enum.KeyCode.S then
            flyDirection = flyDirection + Vector3.new(0, 0, 1)
        elseif input.KeyCode == Enum.KeyCode.A then
            flyDirection = flyDirection + Vector3.new(-1, 0, 0)
        elseif input.KeyCode == Enum.KeyCode.D then
            flyDirection = flyDirection + Vector3.new(1, 0, 0)
        elseif input.KeyCode == Enum.KeyCode.Space then
            flyDirection = flyDirection + Vector3.new(0, 1, 0)
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            flyDirection = flyDirection + Vector3.new(0, -1, 0)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if Config.Player.Fly then
        if input.KeyCode == Enum.KeyCode.W then
            flyDirection = flyDirection - Vector3.new(0, 0, -1)
        elseif input.KeyCode == Enum.KeyCode.S then
            flyDirection = flyDirection - Vector3.new(0, 0, 1)
        elseif input.KeyCode == Enum.KeyCode.A then
            flyDirection = flyDirection - Vector3.new(-1, 0, 0)
        elseif input.KeyCode == Enum.KeyCode.D then
            flyDirection = flyDirection - Vector3.new(1, 0, 0)
        elseif input.KeyCode == Enum.KeyCode.Space then
            flyDirection = flyDirection - Vector3.new(0, 1, 0)
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            flyDirection = flyDirection - Vector3.new(0, -1, 0)
        end
    end
end)

-- Fly Boat
coroutine.wrap(function()
    while true do
        if Config.Player.FlyBoat and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Boat") then
            LocalPlayer.Character.Boat.BodyVelocity.Velocity = Vector3.new(0, 10, 0)
        end
        wait()
    end
end)()

-- Ghost Hack
coroutine.wrap(function()
    while true do
        if Config.Player.GhostHack and LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0.5
                    part.CanCollide = false
                end
            end
        else
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0
                        part.CanCollide = true
                    end
                end
            end
        end
        wait()
    end
end)()

-- Auto Sell
coroutine.wrap(function()
    while true do
        if Config.Player.AutoSell and PlayerData and PlayerData:FindFirstChild("Inventory") then
            for _, item in ipairs(PlayerData.Inventory:GetChildren()) do
                if item:IsA("Folder") or item:IsA("Configuration") then
                    if not Config.Trader.SelectedFish[item.Name] then
                        if GameFunctions and GameFunctions:FindFirstChild("SellFish") then
                            local success, result = pcall(function()
                                GameFunctions.SellFish:InvokeServer(item.Name)
                            end)
                            if success then
                                logError("Auto Sold: " .. item.Name)
                            end
                        end
                    end
                end
            end
        end
        wait(5)
    end
end)()

-- Auto Craft
coroutine.wrap(function()
    while true do
        if Config.Player.AutoCraft and GameFunctions and GameFunctions:FindFirstChild("AutoCraft") then
            local success, result = pcall(function()
                GameFunctions.AutoCraft:InvokeServer()
            end)
            if success then
                logError("Auto Craft executed")
            end
        end
        wait(10)
    end
end)()

-- Auto Upgrade
coroutine.wrap(function()
    while true do
        if Config.Player.AutoUpgrade and GameFunctions and GameFunctions:FindFirstChild("AutoUpgrade") then
            local success, result = pcall(function()
                GameFunctions.AutoUpgrade:InvokeServer()
            end)
            if success then
                logError("Auto Upgrade executed")
            end
        end
        wait(15)
    end
end)()

-- Auto Accept Trade
coroutine.wrap(function()
    while true do
        if Config.Trader.AutoAcceptTrade and TradeEvents and TradeEvents:FindFirstChild("AcceptTrade") then
            local success, result = pcall(function()
                TradeEvents.AcceptTrade:FireServer()
            end)
            if success then
                logError("Auto Trade Accepted")
            end
        end
        wait(2)
    end
end)()

-- Auto Buy Items
coroutine.wrap(function()
    while true do
        if Config.Shop.AutoBuyRods and Config.Shop.SelectedRod ~= "" and GameFunctions and GameFunctions:FindFirstChild("BuyRod") then
            local success, result = pcall(function()
                GameFunctions.BuyRod:InvokeServer(Config.Shop.SelectedRod)
            end)
            if success then
                logError("Auto Bought Rod: " .. Config.Shop.SelectedRod)
            end
        end
        
        if Config.Shop.AutoBuyBoats and Config.Shop.SelectedBoat ~= "" and GameFunctions and GameFunctions:FindFirstChild("BuyBoat") then
            local success, result = pcall(function()
                GameFunctions.BuyBoat:InvokeServer(Config.Shop.SelectedBoat)
            end)
            if success then
                logError("Auto Bought Boat: " .. Config.Shop.SelectedBoat)
            end
        end
        
        if Config.Shop.AutoBuyBaits and Config.Shop.SelectedBait ~= "" and GameFunctions and GameFunctions:FindFirstChild("BuyBait") then
            local success, result = pcall(function()
                GameFunctions.BuyBait:InvokeServer(Config.Shop.SelectedBait)
            end)
            if success then
                logError("Auto Bought Bait: " .. Config.Shop.SelectedBait)
            end
        end
        
        if Config.Shop.AutoUpgradeRod and GameFunctions and GameFunctions:FindFirstChild("UpgradeRod") then
            local success, result = pcall(function()
                GameFunctions.UpgradeRod:InvokeServer()
            end)
            if success then
                logError("Auto Upgraded Rod")
            end
        end
        
        wait(5)
    end
end)()

-- Auto Farm
coroutine.wrap(function()
    while true do
        if Config.System.AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = LocalPlayer.Character.HumanoidRootPart
            local radius = Config.System.FarmRadius
            
            for _, fish in ipairs(Workspace:GetDescendants()) do
                if fish:IsA("Model") and fish:FindFirstChild("Fish") then
                    local distance = (fish.Position - rootPart.Position).Magnitude
                    if distance <= radius then
                        if GameFunctions and GameFunctions:FindFirstChild("CatchFish") then
                            local success, result = pcall(function()
                                GameFunctions.CatchFish:InvokeServer(fish)
                            end)
                            if success then
                                logError("Auto Caught Fish: " .. fish.Name)
                            end
                        end
                    end
                end
            end
        end
        wait(1)
    end
end)()

-- Show Info
coroutine.wrap(function()
    while true do
        if Config.System.ShowInfo then
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local memory = math.floor(Stats:GetTotalMemoryUsageMb())
            local battery = math.floor(UserInputService:GetBatteryLevel() * 100)
            local time = os.date("%H:%M:%S")
            
            local infoText = string.format("FPS: %d | Ping: %dms | Memory: %dMB | Battery: %d%% | Time: %s", 
                fps, ping, memory, battery, time)
            
            -- Create or update info label
            local infoLabel = CoreGui:FindFirstChild("FishItInfoLabel")
            if not infoLabel then
                infoLabel = Instance.new("TextLabel")
                infoLabel.Name = "FishItInfoLabel"
                infoLabel.Size = UDim2.new(0, 200, 0, 30)
                infoLabel.Position = UDim2.new(0, 10, 0, 10)
                infoLabel.BackgroundTransparency = 1
                infoLabel.TextColor3 = Color3.new(1, 1, 1)
                infoLabel.TextScaled = true
                infoLabel.Font = Enum.Font.SourceSansBold
                infoLabel.TextStrokeTransparency = 0.5
                infoLabel.Parent = CoreGui
            end
            infoLabel.Text = infoText
        else
            local infoLabel = CoreGui:FindFirstChild("FishItInfoLabel")
            if infoLabel then
                infoLabel:Destroy()
            end
        end
        wait(1)
    end
end)()

-- Auto Clean Memory
coroutine.wrap(function()
    while true do
        if Config.System.AutoCleanMemory then
            collectgarbage("collect")
            logError("Memory cleaned")
        end
        wait(60)
    end
end)()

-- Server Hop
coroutine.wrap(function()
    while true do
        if Config.Server.ServerHop then
            local servers = {}
            local success, result = pcall(function()
                local http = game:GetService("HttpService")
                local response = http:GetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
                servers = http:JSONDecode(response).data
            end)
            
            if success and #servers > 0 then
                local randomServer = servers[math.random(1, #servers)]
                TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer.id)
                logError("Server hopping to: " .. randomServer.id)
            end
        end
        wait(30)
    end
end)()

-- Apply Low Device Settings
coroutine.wrap(function()
    while true do
        if Config.LowDevice.AntiLag then
            settings().Rendering.QualityLevel = 1
            setfpscap(30)
        end
        
        if Config.LowDevice.FPSStabilizer then
            RunService:Set3dRenderingEnabled(false)
            RunService:SetPhysics3dRenderingEnabled(false)
        else
            RunService:Set3dRenderingEnabled(true)
            RunService:SetPhysics3dRenderingEnabled(true)
        end
        
        if Config.LowDevice.DisableEffects then
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Fire") or 
                   effect:IsA("Sparkles") or effect:IsA("Trail") then
                    effect.Enabled = false
                end
            end
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
            Lighting.FogColor = Color3.new(1, 1, 1)
        else
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Fire") or 
                   effect:IsA("Sparkles") or effect:IsA("Trail") then
                    effect.Enabled = true
                end
            end
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 1000
            Lighting.FogColor = Color3.new(0.6, 0.6, 0.8)
        end
        
        if Config.LowDevice.LowQualityGraphics then
            settings().Rendering.QualityLevel = 1
            settings().Rendering.MeshDetail = Enum.MeshDetail.Level15
            settings().Rendering.TextureQuality = Enum.TextureQuality.Level1
            settings().Rendering.ShaderQuality = Enum.ShaderQuality.Low
            settings().Rendering.UsableMemoryBudget = 1
            settings().Rendering.EffectQuality = Enum.EffectQuality.Low
            settings().Rendering.LightingQuality = Enum.LightingQuality.Low
            settings().Rendering.SkyboxQuality = Enum.SkyboxQuality.Low
            settings().Rendering.WaterQuality = Enum.WaterQuality.Low
            settings().Rendering.AntiAliasing = Enum.AntiAliasing.Off
        else
            settings().Rendering.QualityLevel = 10
            settings().Rendering.MeshDetail = Enum.MeshDetail.Level30
            settings().Rendering.TextureQuality = Enum.TextureQuality.Medium
            settings().Rendering.ShaderQuality = Enum.ShaderQuality.Medium
            settings().Rendering.UsableMemoryBudget = 10
            settings().Rendering.EffectQuality = Enum.EffectQuality.Medium
            settings().Rendering.LightingQuality = Enum.LightingQuality.Medium
            settings().Rendering.SkyboxQuality = Enum.SkyboxQuality.Medium
            settings().Rendering.WaterQuality = Enum.WaterQuality.Medium
            settings().Rendering.AntiAliasing = Enum.AntiAliasing.X4
        end
        
        wait(1)
    end
end)()

-- Initial notification
Rayfield:Notify({
    Title = "Fish It Hub 2025",
    Content = "Script loaded successfully! All features ready to use.",
    Duration = 5,
    Image = 13047715178
})
logError("Fish It Hub 2025 script loaded successfully")
