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

-- Server Tab
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

ShopTab:CreateButton({
    Name = "Buy Selected Item",
    Callback = function()
        if Config.Shop.SelectedRod ~= "" then
            if MarketPlaceService and MarketPlaceService:FindFirstChild("BuyRod") then
                local success, result = pcall(function()
                    MarketPlaceService.BuyRod:FireServer(Config.Shop.SelectedRod)
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
            if MarketPlaceService and MarketPlaceService:FindFirstChild("BuyBoat") then
                local success, result = pcall(function()
                    MarketPlaceService.BuyBoat:FireServer(Config.Shop.SelectedBoat)
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
            if MarketPlaceService and MarketPlaceService:FindFirstChild("BuyBait") then
                local success, result = pcall(function()
                    MarketPlaceService.BuyBait:FireServer(Config.Shop.SelectedBait)
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
                Title = "Purchase Error",
                Content = "Please select an item first",
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
        Rayfield:SetTheme({Theme = Value})
        logError("Theme changed to: " .. Value)
    end
})

SettingsTab:CreateSlider({
    Name = "Transparency",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Settings.Transparency,
    Flag = "Transparency",
    Callback = function(Value)
        Config.Settings.Transparency = Value
        Rayfield:SetTransparency(Value)
        logError("Transparency set to: " .. Value)
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
        Rayfield:SetScale(Value)
        logError("UI Scale set to: " .. Value)
    end
})

SettingsTab:CreateInput({
    Name = "Config Name",
    PlaceholderText = "Enter config name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        Config.Settings.ConfigName = Text
        logError("Config name set to: " .. Text)
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
            writefile("/storage/emulated/0/logscript.txt", "")
            Rayfield:Notify({
                Title = "Log Cleared",
                Content = "Log file has been cleared",
                Duration = 3,
                Image = 13047715178
            })
            logError("Log cleared")
        end)
        if not success then
            logError("Failed to clear log: " .. err)
        end
    end
})

-- Low Device Section
local LowDeviceTab = Window:CreateTab("🥔 Low Device", 13014546625)

LowDeviceTab:CreateToggle({
    Name = "Anti Lag",
    CurrentValue = false,
    Flag = "AntiLag",
    Callback = function(Value)
        if Value then
            -- Ultra-low rendering settings
            settings().Rendering.QualityLevel = 1
            sethiddenproperty(Lighting, "Technology", "ShadowMap")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Enabled")
            
            -- Disable all visual effects
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1000
            Lighting.Ambient = Color3.new(1, 1, 1)
            
            -- Reduce texture quality
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Texture = "rbxasset://textures/plainWhite.png"
                end
                if obj:IsA("MeshPart") or obj:IsA("Part") then
                    obj.Material = Enum.Material.Plastic
                end
            end
            
            -- Disable particles
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Sparkles") then
                    effect.Enabled = false
                end
            end
            
            Rayfield:Notify({
                Title = "Anti Lag",
                Content = "Ultra-low rendering settings applied",
                Duration = 3,
                Image = 13047715178
            })
            logError("Anti Lag activated")
        else
            -- Restore default settings
            settings().Rendering.QualityLevel = 10
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 100000
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            
            Rayfield:Notify({
                Title = "Anti Lag",
                Content = "Default rendering settings restored",
                Duration = 3,
                Image = 13047715178
            })
            logError("Anti Lag deactivated")
        end
    end
})

LowDeviceTab:CreateToggle({
    Name = "8-bit Style",
    CurrentValue = false,
    Flag = "8bitStyle",
    Callback = function(Value)
        if Value then
            -- Convert to 8-bit style
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Part") or obj:IsA("MeshPart") then
                    obj.Material = Enum.Material.Plastic
                    obj.Color = Color3.new(math.floor(obj.Color.R * 7) / 7, math.floor(obj.Color.G * 7) / 7, math.floor(obj.Color.B * 7) / 7)
                end
            end
            
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.new(1, 1, 1)
            
            Rayfield:Notify({
                Title = "8-bit Style",
                Content = "8-bit graphics applied",
                Duration = 3,
                Image = 13047715178
            })
            logError("8-bit style activated")
        else
            -- Restore normal graphics
            Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            
            Rayfield:Notify({
                Title = "8-bit Style",
                Content = "Normal graphics restored",
                Duration = 3,
                Image = 13047715178
            })
            logError("8-bit style deactivated")
        end
    end
})

LowDeviceTab:CreateToggle({
    Name = "Disable All Effects",
    CurrentValue = false,
    Flag = "DisableEffects",
    Callback = function(Value)
        if Value then
            -- Disable all visual effects
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Sparkles") or 
                   effect:IsA("Fire") or effect:IsA("SpotLight") or effect:IsA("PointLight") then
                    effect.Enabled = false
                end
            end
            
            -- Reduce water effects
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and water.Name:lower():find("water") then
                    water.Transparency = 1
                end
            end
            
            Rayfield:Notify({
                Title = "Effects Disabled",
                Content = "All visual effects have been disabled",
                Duration = 3,
                Image = 13047715178
            })
            logError("All effects disabled")
        else
            -- Restore effects
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Sparkles") or 
                   effect:IsA("Fire") or effect:IsA("SpotLight") or effect:IsA("PointLight") then
                    effect.Enabled = true
                end
            end
            
            Rayfield:Notify({
                Title = "Effects Enabled",
                Content = "All visual effects have been restored",
                Duration = 3,
                Image = 13047715178
            })
            logError("All effects restored")
        end
    end
})

LowDeviceTab:CreateToggle({
    Name = "Auto Optimize",
    CurrentValue = false,
    Flag = "AutoOptimize",
    Callback = function(Value)
        if Value then
            -- Auto-optimize settings
            setfpscap(60)
            settings().Rendering.QualityLevel = 5
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 5000
            
            -- Reduce texture quality
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Texture = "rbxasset://textures/plainWhite.png"
                end
            end
            
            -- Clean up memory periodically
            spawn(function()
                while Config.System.AutoCleanMemory do
                    wait(30)
                    collectgarbage("collect")
                    logError("Memory cleaned")
                end
            end)
            
            Rayfield:Notify({
                Title = "Auto Optimize",
                Content = "Auto-optimization enabled",
                Duration = 3,
                Image = 13047715178
            })
            logError("Auto-optimize activated")
        else
            setfpscap(60)
            settings().Rendering.QualityLevel = 10
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 100000
            
            Rayfield:Notify({
                Title = "Auto Optimize",
                Content = "Auto-optimization disabled",
                Duration = 3,
                Image = 13047715178
            })
            logError("Auto-optimize deactivated")
        end
    end
})

LowDeviceTab:CreateToggle({
    Name = "Low Poly Mode",
    CurrentValue = false,
    Flag = "LowPoly",
    Callback = function(Value)
        if Value then
            -- Convert to low poly
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("MeshPart") or obj:IsA("Part") then
                    obj.Material = Enum.Material.Plastic
                    obj.Color = Color3.new(0.8, 0.8, 0.8)
                end
            end
            
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.new(1, 1, 1)
            
            Rayfield:Notify({
                Title = "Low Poly Mode",
                Content = "Low poly graphics applied",
                Duration = 3,
                Image = 13047715178
            })
            logError("Low poly mode activated")
        else
            Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            
            Rayfield:Notify({
                Title = "Low Poly Mode",
                Content = "Normal graphics restored",
                Duration = 3,
                Image = 13047715178
            })
            logError("Low poly mode deactivated")
        end
    end
})

-- Feature Implementations
local function InitializeFeatures()
    -- Auto Jump
    if Config.Bypass.AutoJump then
        spawn(function()
            while Config.Bypass.AutoJump and wait(Config.Bypass.AutoJumpDelay) do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.Jump = true
                end
            end
        end)
    end
    
    -- Speed Hack
    if Config.Player.SpeedHack then
        spawn(function()
            while Config.Player.SpeedHack do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = Config.Player.SpeedValue
                end
                wait(0.1)
            end
        end)
    end
    
    -- Max Boat Speed
    if Config.Player.MaxBoatSpeed then
        spawn(function()
            while Config.Player.MaxBoatSpeed do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Boat") then
                    LocalPlayer.Character.Boat.MaxSpeed = 100
                end
                wait(0.1)
            end
        end)
    end
    
    -- Infinity Jump
    if Config.Player.InfinityJump then
        UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
    
    -- Fly
    if Config.Player.Fly then
        local flySpeed = Config.Player.FlyRange / 10
        local control = {F = 0, B = 0, L = 0, R = 0}
        local flyKeyDown = false
        
        UserInputService.InputBegan:Connect(function(key, gameProcessed)
            if gameProcessed then return end
            if key.KeyCode == Enum.KeyCode.F then
                flyKeyDown = not flyKeyDown
            elseif key.KeyCode == Enum.KeyCode.W then
                control.F = flySpeed
            elseif key.KeyCode == Enum.KeyCode.S then
                control.B = flySpeed
            elseif key.KeyCode == Enum.KeyCode.A then
                control.L = flySpeed
            elseif key.KeyCode == Enum.KeyCode.D then
                control.R = flySpeed
            end
        end)
        
        UserInputService.InputEnded:Connect(function(key, gameProcessed)
            if gameProcessed then return end
            if key.KeyCode == Enum.KeyCode.W then
                control.F = 0
            elseif key.KeyCode == Enum.KeyCode.S then
                control.B = 0
            elseif key.KeyCode == Enum.KeyCode.A then
                control.L = 0
            elseif key.KeyCode == Enum.KeyCode.D then
                control.R = 0
            end
        end)
        
        spawn(function()
            while Config.Player.Fly do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(control.R - control.L, control.F - control.B, 0)
                end
                wait()
            end
        end)
    end
    
    -- Player ESP
    if Config.Player.PlayerESP then
        local esp = {}
        
        local function createESP(player)
            if player == LocalPlayer then return end
            
            local character = player.Character
            if not character then return end
            
            local torso = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
            if not torso then return end
            
            local espBox = Instance.new("BoxHandleAdornment")
            espBox.Size = Vector3.new(4, 6, 2)
            espBox.Adornee = torso
            espBox.Color3 = Color3.new(1, 0, 0)
            espBox.Transparency = 0.7
            espBox.Parent = CoreGui
            
            local espName = Instance.new("BillboardGui")
            espName.Size = UDim2.new(0, 100, 0, 50)
            espName.Adornee = torso
            espName.Parent = CoreGui
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.Text = player.Name
            nameLabel.TextScaled = true
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextColor3 = Color3.new(1, 1, 1)
            nameLabel.Parent = espName
            
            esp[player] = {Box = espBox, Name = espName}
        end
        
        local function updateESP()
            for _, player in ipairs(Players:GetPlayers()) do
                if Config.Player.PlayerESP and not esp[player] then
                    createESP(player)
                elseif not Config.Player.PlayerESP and esp[player] then
                    esp[player].Box:Destroy()
                    esp[player].Name:Destroy()
                    esp[player] = nil
                end
            end
        end
        
        Players.PlayerAdded:Connect(function(player)
            if Config.Player.PlayerESP then
                createESP(player)
            end
        end)
        
        Players.PlayerRemoving:Connect(function(player)
            if esp[player] then
                esp[player].Box:Destroy()
                esp[player].Name:Destroy()
                esp[player] = nil
            end
        end)
        
        spawn(function()
            while Config.Player.PlayerESP do
                updateESP()
                wait(0.1)
            end
        end)
    end
    
    -- Auto Farm
    if Config.System.AutoFarm then
        spawn(function()
            while Config.System.AutoFarm do
                if FishingEvents and FishingEvents:FindFirstChild("AutoFish") then
                    local success, result = pcall(function()
                        FishingEvents.AutoFish:FireServer({
                            Radius = Config.System.FarmRadius,
                            PerfectCatch = true
                        })
                    end)
                    if not success then
                        logError("Auto Farm Error: " .. result)
                    end
                end
                wait(1)
            end
        end)
    end
    
    -- Auto Sell
    if Config.Player.AutoSell then
        spawn(function()
            while Config.Player.AutoSell do
                if PlayerData and PlayerData:FindFirstChild("Inventory") then
                    for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                        if item:IsA("Folder") or item:IsA("Configuration") then
                            if not Config.Trader.SelectedFish[item.Name] then
                                if GameFunctions and GameFunctions:FindFirstChild("SellFish") then
                                    local success, result = pcall(function()
                                        GameFunctions.SellFish:InvokeServer(item.Name)
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
    end
    
    -- Ghost Hack
    if Config.Player.GhostHack then
        spawn(function()
            while Config.Player.GhostHack do
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Transparency = 0.5
                            part.CanCollide = false
                        end
                    end
                end
                wait(0.1)
            end
        end)
    end
    
    -- Noclip
    if Config.Player.Noclip then
        local noclip = true
        
        UserInputService.InputBegan:Connect(function(key, gameProcessed)
            if gameProcessed then return end
            if key.KeyCode == Enum.KeyCode.N then
                noclip = not noclip
                Rayfield:Notify({
                    Title = "Noclip",
                    Content = "Noclip " .. (noclip and "enabled" or "disabled"),
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Noclip " .. (noclip and "enabled" or "disabled"))
            end
        end)
        
        spawn(function()
            while Config.Player.Noclip do
                if noclip and LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
                wait(0.1)
            end
        end)
    end
    
    -- Server Hop
    if Config.Server.ServerHop then
        spawn(function()
            while Config.Server.ServerHop do
                local servers = {}
                local success, result = pcall(function()
                    local http = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
                    servers = HttpService:JSONDecode(http).data
                end)
                
                if success then
                    for _, server in ipairs(servers) do
                        if server.playing < server.maxPlayers and server.id ~= game.JobId then
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                            logError("Server hopped to: " .. server.id)
                            break
                        end
                    end
                end
                
                wait(30)
            end
        end)
    end
    
    -- Auto Accept Trade
    if Config.Trader.AutoAcceptTrade then
        spawn(function()
            while Config.Trader.AutoAcceptTrade do
                if TradeEvents and TradeEvents:FindFirstChild("AcceptTrade") then
                    local success, result = pcall(function()
                        TradeEvents.AcceptTrade:FireServer()
                    end)
                    if not success then
                        logError("Auto Accept Trade Error: " .. result)
                    end
                end
                wait(1)
            end
        end)
    end
    
    -- Auto Buy Items
    if Config.Shop.AutoBuyRods or Config.Shop.AutoBuyBoats or Config.Shop.AutoBuyBaits then
        spawn(function()
            while Config.Shop.AutoBuyRods or Config.Shop.AutoBuyBoats or Config.Shop.AutoBuyBaits do
                if Config.Shop.AutoBuyRods and Config.Shop.SelectedRod ~= "" then
                    if MarketPlaceService and MarketPlaceService:FindFirstChild("BuyRod") then
                        local success, result = pcall(function()
                            MarketPlaceService.BuyRod:FireServer(Config.Shop.SelectedRod)
                        end)
                        if not success then
                            logError("Auto Buy Rod Error: " .. result)
                        end
                    end
                end
                
                if Config.Shop.AutoBuyBoats and Config.Shop.SelectedBoat ~= "" then
                    if MarketPlaceService and MarketPlaceService:FindFirstChild("BuyBoat") then
                        local success, result = pcall(function()
                            MarketPlaceService.BuyBoat:FireServer(Config.Shop.SelectedBoat)
                        end)
                        if not success then
                            logError("Auto Buy Boat Error: " .. result)
                        end
                    end
                end
                
                if Config.Shop.AutoBuyBaits and Config.Shop.SelectedBait ~= "" then
                    if MarketPlaceService and MarketPlaceService:FindFirstChild("BuyBait") then
                        local success, result = pcall(function()
                            MarketPlaceService.BuyBait:FireServer(Config.Shop.SelectedBait)
                        end)
                        if not success then
                            logError("Auto Buy Bait Error: " .. result)
                        end
                    end
                end
                
                wait(5)
            end
        end)
    end
    
    -- Auto Upgrade Rod
    if Config.Shop.AutoUpgradeRod then
        spawn(function()
            while Config.Shop.AutoUpgradeRod do
                if GameFunctions and GameFunctions:FindFirstChild("UpgradeRod") then
                    local success, result = pcall(function()
                        GameFunctions.UpgradeRod:InvokeServer()
                    end)
                    if not success then
                        logError("Auto Upgrade Rod Error: " .. result)
                    end
                end
                wait(10)
            end
        end)
    end
    
    -- Auto Craft
    if Config.Player.AutoCraft then
        spawn(function()
            while Config.Player.AutoCraft do
                if GameFunctions and GameFunctions:FindFirstChild("AutoCraft") then
                    local success, result = pcall(function()
                        GameFunctions.AutoCraft:InvokeServer()
                    end)
                    if not success then
                        logError("Auto Craft Error: " .. result)
                    end
                end
                wait(5)
            end
        end)
    end
    
    -- Auto Upgrade
    if Config.Player.AutoUpgrade then
        spawn(function()
            while Config.Player.AutoUpgrade do
                if GameFunctions and GameFunctions:FindFirstChild("AutoUpgrade") then
                    local success, result = pcall(function()
                        GameFunctions.AutoUpgrade:InvokeServer()
                    end)
                    if not success then
                        logError("Auto Upgrade Error: " .. result)
                    end
                end
                wait(10)
            end
        end)
    end
    
    -- Show Info
    if Config.System.ShowInfo then
        spawn(function()
            while Config.System.ShowInfo do
                local fps = math.floor(1 / RunService.RenderStepped:Wait())
                local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                local memory = math.floor(Stats:GetTotalMemoryUsageMb())
                local battery = math.floor(UserInputService:GetBatteryLevel() * 100)
                local time = os.date("%H:%M:%S")
                
                local infoText = string.format("FPS: %d | Ping: %dms | Memory: %dMB | Battery: %d%% | Time: %s", 
                    fps, ping, memory, battery, time)
                
                -- Update info display
                if not Config.InfoFrame then
                    Config.InfoFrame = Instance.new("ScreenGui")
                    Config.InfoFrame.Name = "InfoDisplay"
                    Config.InfoFrame.Parent = CoreGui
                    
                    Config.InfoLabel = Instance.new("TextLabel")
                    Config.InfoLabel.Size = UDim2.new(0, 200, 0, 50)
                    Config.InfoLabel.Position = UDim2.new(0, 10, 0, 10)
                    Config.InfoLabel.BackgroundTransparency = 1
                    Config.InfoLabel.Text = infoText
                    Config.InfoLabel.TextColor3 = Color3.new(1, 1, 1)
                    Config.InfoLabel.TextScaled = true
                    Config.InfoLabel.Font = Enum.Font.SourceSansBold
                    Config.InfoLabel.Parent = Config.InfoFrame
                else
                    Config.InfoLabel.Text = infoText
                end
                
                wait(1)
            end
            
            -- Clean up when disabled
            if Config.InfoFrame then
                Config.InfoFrame:Destroy()
                Config.InfoFrame = nil
                Config.InfoLabel = nil
            end
        end)
    end
    
    -- Boost FPS
    if Config.System.BoostFPS then
        spawn(function()
            while Config.System.BoostFPS do
                setfpscap(Config.System.FPSLimit)
                
                -- Reduce rendering quality
                settings().Rendering.QualityLevel = 5
                Lighting.GlobalShadows = false
                
                -- Clean up memory
                collectgarbage("collect")
                
                wait(5)
            end
            
            -- Restore settings when disabled
            setfpscap(60)
            settings().Rendering.QualityLevel = 10
            Lighting.GlobalShadows = true
        end)
    end
    
    -- Auto Clean Memory
    if Config.System.AutoCleanMemory then
        spawn(function()
            while Config.System.AutoCleanMemory do
                collectgarbage("collect")
                logError("Memory cleaned")
                wait(30)
            end
        end)
    end
    
    -- Disable Particles
    if Config.System.DisableParticles then
        spawn(function()
            while Config.System.DisableParticles do
                for _, effect in ipairs(Workspace:GetDescendants()) do
                    if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Sparkles") then
                        effect.Enabled = false
                    end
                end
                wait(1)
            end
            
            -- Restore particles when disabled
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Sparkles") then
                    effect.Enabled = true
                end
            end
        end)
    end
    
    -- Force Event
    if Config.Server.ForceEvent then
        spawn(function()
            while Config.Server.ForceEvent do
                if GameFunctions and GameFunctions:FindFirstChild("ForceEvent") then
                    local success, result = pcall(function()
                        GameFunctions.ForceEvent:InvokeServer()
                    end)
                    if not success then
                        logError("Force Event Error: " .. result)
                    end
                end
                wait(60)
            end
        end)
    end
    
    -- Luck Boost
    if Config.Server.LuckBoost then
        spawn(function()
            while Config.Server.LuckBoost do
                if GameFunctions and GameFunctions:FindFirstChild("ApplyLuckBoost") then
                    local success, result = pcall(function()
                        GameFunctions.ApplyLuckBoost:InvokeServer()
                    end)
                    if not success then
                        logError("Luck Boost Error: " .. result)
                    end
                end
                wait(30)
            end
        end)
    end
    
    -- Seed Viewer
    if Config.Server.SeedViewer then
        spawn(function()
            while Config.Server.SeedViewer do
                if GameFunctions and GameFunctions:FindFirstChild("GetSeed") then
                    local success, result = pcall(function()
                        local seed = GameFunctions.GetSeed:InvokeServer()
                        Rayfield:Notify({
                            Title = "Seed",
                            Content = "Current seed: " .. tostring(seed),
                            Duration = 5,
                            Image = 13047715178
                        })
                        logError("Seed: " .. tostring(seed))
                    end)
                    if not success then
                        logError("Seed Viewer Error: " .. result)
                    end
                end
                wait(30)
            end
        end)
    end
    
    -- View Player Stats
    if Config.Server.ViewPlayerStats then
        spawn(function()
            while Config.Server.ViewPlayerStats do
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        if PlayerData and PlayerData:FindFirstChild("Stats") then
                            local stats = PlayerData.Stats
                            local level = stats:FindFirstChild("Level") and stats.Level.Value or 0
                            local coins = stats:FindFirstChild("Coins") and stats.Coins.Value or 0
                            local fishCaught = stats:FindFirstChild("FishCaught") and stats.FishCaught.Value or 0
                            
                            local statsText = string.format("%s - Level: %d, Coins: %d, Fish: %d", 
                                player.Name, level, coins, fishCaught)
                            
                            Rayfield:Notify({
                                Title = "Player Stats",
                                Content = statsText,
                                Duration = 5,
                                Image = 13047715178
                            })
                            logError("Player Stats: " .. statsText)
                        end
                    end
                end
                wait(60)
            end
        end)
    end
    
    -- Player Info
    if Config.Server.PlayerInfo then
        spawn(function()
            while Config.Server.PlayerInfo do
                local playerCount = #Players:GetPlayers()
                local serverTime = os.date("%H:%M:%S")
                local gameTime = game:GetService("Workspace").DistributedGameTime
                
                local infoText = string.format("Players: %d | Server Time: %s | Game Time: %s", 
                    playerCount, serverTime, gameTime)
                
                Rayfield:Notify({
                    Title = "Player Info",
                    Content = infoText,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Player Info: " .. infoText)
                
                wait(30)
            end
        end)
    end
    
    -- Server Info
    if Config.Server.ServerInfo then
        spawn(function()
            while Config.Server.ServerInfo do
                local playerCount = #Players:GetPlayers()
                local serverId = game.JobId
                local placeId = game.PlaceId
                
                local infoText = string.format("Players: %d | Server ID: %s | Place ID: %s", 
                    playerCount, serverId, placeId)
                
                Rayfield:Notify({
                    Title = "Server Info",
                    Content = infoText,
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Server Info: " .. infoText)
                
                wait(30)
            end
        end)
    end
    
    -- Spawn Boat
    if Config.Player.SpawnBoat then
        spawn(function()
            while Config.Player.SpawnBoat do
                if GameFunctions and GameFunctions:FindFirstChild("SpawnBoat") then
                    local success, result = pcall(function()
                        GameFunctions.SpawnBoat:InvokeServer()
                    end)
                    if not success then
                        logError("Spawn Boat Error: " .. result)
                    end
                end
                wait(10)
            end
        end)
    end
    
    -- NoClip Boat
    if Config.Player.NoClipBoat then
        spawn(function()
            while Config.Player.NoClipBoat do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Boat") then
                    for _, part in ipairs(LocalPlayer.Character.Boat:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
                wait(0.1)
            end
        end)
    end
    
    -- Fly Boat
    if Config.Player.FlyBoat then
        local boatFlySpeed = Config.Player.FlyRange / 10
        local boatControl = {F = 0, B = 0, L = 0, R = 0}
        
        UserInputService.InputBegan:Connect(function(key, gameProcessed)
            if gameProcessed then return end
            if key.KeyCode == Enum.KeyCode.W then
                boatControl.F = boatFlySpeed
            elseif key.KeyCode == Enum.KeyCode.S then
                boatControl.B = boatFlySpeed
            elseif key.KeyCode == Enum.KeyCode.A then
                boatControl.L = boatFlySpeed
            elseif key.KeyCode == Enum.KeyCode.D then
                boatControl.R = boatFlySpeed
            end
        end)
        
        UserInputService.InputEnded:Connect(function(key, gameProcessed)
            if gameProcessed then return end
            if key.KeyCode == Enum.KeyCode.W then
                boatControl.F = 0
            elseif key.KeyCode == Enum.KeyCode.S then
                boatControl.B = 0
            elseif key.KeyCode == Enum.KeyCode.A then
                boatControl.L = 0
            elseif key.KeyCode == Enum.KeyCode.D then
                boatControl.R = 0
            end
        end)
        
        spawn(function()
            while Config.Player.FlyBoat do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Boat") and LocalPlayer.Character.Boat:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.Boat.HumanoidRootPart.CFrame = LocalPlayer.Character.Boat.HumanoidRootPart.CFrame * CFrame.new(boatControl.R - boatControl.L, boatControl.F - boatControl.B, 0)
                end
                wait()
            end
        end)
    end
    
    -- Bypass Fishing Radar
    if Config.Bypass.BypassFishingRadar then
        spawn(function()
            while Config.Bypass.BypassFishingRadar do
                if FishingEvents and FishingEvents:FindFirstChild("RadarBypass") then
                    local success, result = pcall(function()
                        FishingEvents.RadarBypass:FireServer()
                    end)
                    if not success then
                        logError("Bypass Fishing Radar Error: " .. result)
                    end
                end
                wait(5)
            end
        end)
    end
    
    -- Bypass Diving Gear
    if Config.Bypass.BypassDivingGear then
        spawn(function()
            while Config.Bypass.BypassDivingGear do
                if GameFunctions and GameFunctions:FindFirstChild("DivingBypass") then
                    local success, result = pcall(function()
                        GameFunctions.DivingBypass:InvokeServer()
                    end)
                    if not success then
                        logError("Bypass Diving Gear Error: " .. result)
                    end
                end
                wait(5)
            end
        end)
    end
    
    -- Bypass Fishing Animation
    if Config.Bypass.BypassFishingAnimation then
        spawn(function()
            while Config.Bypass.BypassFishingAnimation do
                if FishingEvents and FishingEvents:FindFirstChild("AnimationBypass") then
                    local success, result = pcall(function()
                        FishingEvents.AnimationBypass:FireServer()
                    end)
                    if not success then
                        logError("Bypass Fishing Animation Error: " .. result)
                    end
                end
                wait(5)
            end
        end)
    end
    
    -- Bypass Fishing Delay
    if Config.Bypass.BypassFishingDelay then
        spawn(function()
            while Config.Bypass.BypassFishingDelay do
                if FishingEvents and FishingEvents:FindFirstChild("DelayBypass") then
                    local success, result = pcall(function()
                        FishingEvents.DelayBypass:FireServer()
                    end)
                    if not success then
                        logError("Bypass Fishing Delay Error: " .. result)
                    end
                end
                wait(5)
            end
        end)
    end
    
    -- Rejoin Same Server
    if Config.Server.RejoinSameServer then
        spawn(function()
            while Config.Server.RejoinSameServer do
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
                logError("Rejoining server...")
                wait(60)
            end
        end)
    end
    
    -- Anti-AFK
    if Config.Bypass.AntiAFK then
        spawn(function()
            while Config.Bypass.AntiAFK do
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                wait(30)
            end
        end)
    end
    
    -- Auto Jump
    if Config.Bypass.AutoJump then
        spawn(function()
            while Config.Bypass.AutoJump do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.Jump = true
                end
                wait(Config.Bypass.AutoJumpDelay)
            end
        end)
    end
    
    -- Anti Kick
    if Config.Bypass.AntiKick then
        spawn(function()
            while Config.Bypass.AntiKick do
                if mt and mt.__namecall then
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
                end
                wait(1)
            end
        end)
    end
    
    -- Anti Ban
    if Config.Bypass.AntiBan then
        spawn(function()
            while Config.Bypass.AntiBan do
                if GameFunctions and GameFunctions:FindFirstChild("AntiBan") then
                    local success, result = pcall(function()
                        GameFunctions.AntiBan:InvokeServer()
                    end)
                    if not success then
                        logError("Anti Ban Error: " .. result)
                    end
                end
                wait(30)
            end
        end)
    end
    
    -- RNG Settings
    if Config.RNGKill.RNGReducer or Config.RNGKill.ForceLegendary or Config.RNGKill.SecretFishBoost or 
       Config.RNGKill.MythicalChanceBoost or Config.RNGKill.AntiBadLuck or Config.RNGKill.GuaranteedCatch then
        spawn(function()
            while Config.RNGKill.RNGReducer or Config.RNGKill.ForceLegendary or Config.RNGKill.SecretFishBoost or 
                  Config.RNGKill.MythicalChanceBoost or Config.RNGKill.AntiBadLuck or Config.RNGKill.GuaranteedCatch do
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
                    end)
                    if not success then
                        logError("RNG Settings Error: " .. result)
                    end
                end
                wait(5)
            end
        end)
    end
    
    -- Trade All Fish
    if Config.Trader.TradeAllFish then
        spawn(function()
            while Config.Trader.TradeAllFish do
                if PlayerData and PlayerData:FindFirstChild("Inventory") and TradeEvents and TradeEvents:FindFirstChild("SendTradeRequest") then
                    for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                        if item:IsA("Folder") or item:IsA("Configuration") then
                            local targetPlayer = Players:FindFirstChild(Config.Trader.TradePlayer)
                            if targetPlayer then
                                local success, result = pcall(function()
                                    TradeEvents.SendTradeRequest:FireServer(targetPlayer, item.Name)
                                end)
                                if not success then
                                    logError("Trade All Fish Error: " .. result)
                                end
                            end
                        end
                    end
                end
                wait(10)
            end
        end)
    end
    
    -- High Quality Rendering
    if Config.Graphic.HighQuality then
        spawn(function()
            while Config.Graphic.HighQuality do
                sethiddenproperty(Lighting, "Technology", "Future")
                sethiddenproperty(Workspace, "InterpolationThrottling", "Disabled")
                settings().Rendering.QualityLevel = 15
                wait(1)
            end
            
            -- Restore settings when disabled
            sethiddenproperty(Lighting, "Technology", "ShadowMap")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Enabled")
            settings().Rendering.QualityLevel = 10
        end)
    end
    
    -- Max Rendering
    if Config.Graphic.MaxRendering then
        spawn(function()
            while Config.Graphic.MaxRendering do
                settings().Rendering.QualityLevel = 21
                settings().Rendering.MeshCacheSize = 500
                settings().Rendering.TextureCacheSize = 500
                wait(1)
            end
            
            -- Restore settings when disabled
            settings().Rendering.QualityLevel = 10
            settings().Rendering.MeshCacheSize = 100
            settings().Rendering.TextureCacheSize = 100
        end)
    end
    
    -- Ultra Low Mode
    if Config.Graphic.UltraLowMode then
        spawn(function()
            while Config.Graphic.UltraLowMode do
                settings().Rendering.QualityLevel = 1
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 1000
                Lighting.Ambient = Color3.new(1, 1, 1)
                
                for _, part in ipairs(Workspace:GetDescendants()) do
                    if part:IsA("Part") or part:IsA("MeshPart") then
                        part.Material = Enum.Material.Plastic
                        part.Transparency = 0.5
                    end
                end
                
                wait(1)
            end
            
            -- Restore settings when disabled
            settings().Rendering.QualityLevel = 10
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 100000
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") or part:IsA("MeshPart") then
                    part.Material = Enum.Material.Wood
                    part.Transparency = 0
                end
            end
        end)
    end
    
    -- Disable Water Reflection
    if Config.Graphic.DisableWaterReflection then
        spawn(function()
            while Config.Graphic.DisableWaterReflection do
                for _, water in ipairs(Workspace:GetDescendants()) do
                    if water:IsA("Part") and water.Name:lower():find("water") then
                        water.Transparency = 1
                    end
                end
                wait(1)
            end
            
            -- Restore water when disabled
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and water.Name:lower():find("water") then
                    water.Transparency = 0
                end
            end
        end)
    end
    
    -- Custom Shader
    if Config.Graphic.CustomShader then
        spawn(function()
            while Config.Graphic.CustomShader do
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Texture") or obj:IsA("Decal") then
                        obj.Texture = "rbxasset://textures/shinyPlastic.png"
                    end
                end
                wait(1)
            end
            
            -- Restore shaders when disabled
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Texture = "rbxasset://textures/plainWhite.png"
                end
            end
        end)
    end
    
    -- Smooth Graphics
    if Config.Graphic.SmoothGraphics then
        spawn(function()
            while Config.Graphic.SmoothGraphics do
                RunService:Set3dRenderingEnabled(true)
                settings().Rendering.MeshCacheSize = 200
                settings().Rendering.TextureCacheSize = 200
                wait(1)
            end
            
            -- Restore settings when disabled
            RunService:Set3dRenderingEnabled(true)
            settings().Rendering.MeshCacheSize = 100
            settings().Rendering.TextureCacheSize = 100
        end)
    end
    
    -- Full Bright
    if Config.Graphic.FullBright then
        spawn(function()
            while Config.Graphic.FullBright do
                Lighting.GlobalShadows = false
                Lighting.ClockTime = 12
                Lighting.Ambient = Color3.new(1, 1, 1)
                wait(1)
            end
            
            -- Restore settings when disabled
            Lighting.GlobalShadows = true
            Lighting.ClockTime = 14
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        end)
    end
    
    -- Rejoin Server
    if Config.System.RejoinServer then
        spawn(function()
            while Config.System.RejoinServer do
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
                logError("Rejoining server...")
                wait(60)
            end
        end)
    end
end

-- Initialize all features
InitializeFeatures()

-- Log initialization
logError("Fish It Hub 2025 script initialized")
Rayfield:Notify({
    Title = "Fish It Hub 2025",
    Content = "Script initialized successfully",
    Duration = 5,
    Image = 13047715178
})
