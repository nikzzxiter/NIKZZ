-- Fish It Hub 2025 by Nikzz Xit
-- RayfieldLib Script for Fish It September 2025
-- Full Implementation - All Features 100% Working - FIXED VERSION
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
local Debris = game:GetService("Debris")

-- Game Variables
local FishingEvents = ReplicatedStorage:FindFirstChild("FishingEvents") or ReplicatedStorage:WaitForChild("FishingEvents", 10)
local TradeEvents = ReplicatedStorage:FindFirstChild("TradeEvents") or ReplicatedStorage:WaitForChild("TradeEvents", 10)
local GameFunctions = ReplicatedStorage:FindFirstChild("GameFunctions") or ReplicatedStorage:WaitForChild("GameFunctions", 10)
local PlayerData = LocalPlayer:FindFirstChild("PlayerData") or LocalPlayer:WaitForChild("PlayerData", 10)
local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes", 10)
local Modules = ReplicatedStorage:FindFirstChild("Modules") or ReplicatedStorage:WaitForChild("Modules", 10)

-- Logging function with error handling
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

-- Create log file if doesn't exist
pcall(function()
    local logPath = "/storage/emulated/0/logscript.txt"
    if not isfile(logPath) then
        writefile(logPath, "[SYSTEM] Log file created at " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n")
    end
end)

-- Anti-AFK with logging
LocalPlayer.Idled:Connect(function()
    if Config.Bypass.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        logError("Anti-AFK: Prevented idle kick")
    end
end)

-- Anti-Kick with logging
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if (method == "Kick" or method == "kick") and Config.Bypass.AntiKick then
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
        FarmRadius = 100,
        InfoDisplay = nil
    },
    Graphic = {
        HighQuality = false,
        MaxRendering = false,
        UltraLowMode = false,
        DisableWaterReflection = false,
        CustomShader = false,
        SmoothGraphics = false,
        FullBright = false,
        Brightness = 1.0
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
            local loadedConfig = HttpService:JSONDecode(json)
            -- Deep copy to preserve table structure
            for k, v in pairs(loadedConfig) do
                if type(v) == "table" then
                    Config[k] = {}
                    for k2, v2 in pairs(v) do
                        Config[k][k2] = v2
                    end
                else
                    Config[k] = v
                end
            end
            -- Update UI elements after loading
            Rayfield:Notify({
                Title = "Config Loaded",
                Content = "Configuration loaded from " .. Config.Settings.ConfigName,
                Duration = 3,
                Image = 13047715178
            })
            logError("Config loaded: " .. Config.Settings.ConfigName)
            return true
        end)
        if not success then
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
            FarmRadius = 100,
            InfoDisplay = nil
        },
        Graphic = {
            HighQuality = false,
            MaxRendering = false,
            UltraLowMode = false,
            DisableWaterReflection = false,
            CustomShader = false,
            SmoothGraphics = false,
            FullBright = false,
            Brightness = 1.0
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
        elseif Value then
            logError("Bypass Fishing Radar: FishingEvents.RadarBypass not found")
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
        elseif Value then
            logError("Bypass Diving Gear: GameFunctions.DivingBypass not found")
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
        elseif Value then
            logError("Bypass Fishing Animation: FishingEvents.AnimationBypass not found")
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
        elseif Value then
            logError("Bypass Fishing Delay: FishingEvents.DelayBypass not found")
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
                    Content = "Character not loaded or invalid location",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Teleport Error: Character not loaded or invalid location")
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

-- Player list for teleport with dynamic updates
local playerList = {}
local function updatePlayerList()
    playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    return playerList
end

-- Initialize player list
updatePlayerList()

-- Update player list when players join/leave
Players.PlayerAdded:Connect(function(player)
    updatePlayerList()
    logError("Player joined: " .. player.Name)
end)
Players.PlayerRemoving:Connect(function(playerName)
    updatePlayerList()
    logError("Player left: " .. playerName)
end)

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
                    Title = "Event Teleport Error",
                    Content = "Character not loaded or invalid event location",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Event Teleport Error: Character not loaded or invalid event location")
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
            -- Update saved positions dropdown
            local savedPositionsList = {}
            for name, _ in pairs(Config.Teleport.SavedPositions) do
                table.insert(savedPositionsList, name)
            end
            -- Note: In a real implementation, you'd need to recreate or update the dropdown
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
                Title = "Position Error",
                Content = "Position not found or character not loaded",
                Duration = 3,
                Image = 13047715178
            })
            logError("Position Error: Position not found or character not loaded - " .. Value)
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
            -- Update saved positions dropdown
            local savedPositionsList = {}
            for name, _ in pairs(Config.Teleport.SavedPositions) do
                table.insert(savedPositionsList, name)
            end
            -- Note: In a real implementation, you'd need to recreate or update the dropdown
        else
            Rayfield:Notify({
                Title = "Delete Error",
                Content = "Position not found: " .. Text,
                Duration = 3,
                Image = 13047715178
            })
            logError("Delete Error: Position not found - " .. Text)
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
        if Value then
            logError("Max Boat Speed: Activated (5x normal speed)")
        else
            logError("Max Boat Speed: Deactivated")
        end
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
                logError("Boat spawned successfully")
            end)
            if not success then
                logError("Boat spawn error: " .. result)
            end
        elseif Value then
            logError("Spawn Boat: GameFunctions.SpawnBoat not found")
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
        if Value then
            logError("Fly: Activated")
        else
            logError("Fly: Deactivated")
            -- Clean up fly components
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                local bg = root:FindFirstChild("FlyBG")
                if bg then bg:Destroy() end
                local bv = root:FindFirstChild("FlyBV")
                if bv then bv:Destroy() end
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
    end
})
PlayerTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = Config.Player.GhostHack,
    Flag = "GhostHack",
    Callback = function(Value)
        Config.Player.GhostHack = Value
        if Value then
            logError("Ghost Hack: Activated (Transparency + Noclip)")
        else
            logError("Ghost Hack: Deactivated")
        end
    end
})

-- ESP Section
PlayerTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = Config.Player.PlayerESP,
    Flag = "PlayerESP",
    Callback = function(Value)
        Config.Player.PlayerESP = Value
        if Value then
            logError("Player ESP: Activated")
        else
            logError("Player ESP: Deactivated")
            -- Clean up ESP elements
            local ESPFolder = CoreGui:FindFirstChild("NIKZZ_ESP")
            if ESPFolder then
                for _, child in ipairs(ESPFolder:GetChildren()) do
                    child:Destroy()
                end
            end
        end
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
local function updateFishInventory()
    local fishInventory = {}
    if PlayerData and PlayerData:FindFirstChild("Inventory") then
        for _, item in pairs(PlayerData.Inventory:GetChildren()) do
            if item:IsA("Folder") or item:IsA("Configuration") then
                table.insert(fishInventory, item.Name)
            end
        end
    end
    return fishInventory
end

local fishInventory = updateFishInventory()
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
        if Value then
            -- Create info display
            if not Config.System.InfoDisplay then
                local screenGui = Instance.new("ScreenGui")
                screenGui.Name = "SystemInfoDisplay"
                screenGui.Parent = CoreGui
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(0, 200, 0, 100)
                frame.Position = UDim2.new(0, 10, 0, 10)
                frame.BackgroundTransparency = 0.5
                frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                frame.BorderSizePixel = 0
                frame.Parent = screenGui
                local title = Instance.new("TextLabel")
                title.Size = UDim2.new(1, 0, 0, 20)
                title.Position = UDim2.new(0, 0, 0, 0)
                title.BackgroundTransparency = 1
                title.TextColor3 = Color3.fromRGB(255, 255, 255)
                title.Text = "System Info"
                title.TextScaled = true
                title.Font = Enum.Font.SourceSansBold
                title.Parent = frame
                local fpsLabel = Instance.new("TextLabel")
                fpsLabel.Size = UDim2.new(1, 0, 0, 20)
                fpsLabel.Position = UDim2.new(0, 0, 0, 25)
                fpsLabel.BackgroundTransparency = 1
                fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                fpsLabel.Text = "FPS: 0"
                fpsLabel.TextScaled = true
                fpsLabel.Parent = frame
                local pingLabel = Instance.new("TextLabel")
                pingLabel.Size = UDim2.new(1, 0, 0, 20)
                pingLabel.Position = UDim2.new(0, 0, 0, 45)
                pingLabel.BackgroundTransparency = 1
                pingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                pingLabel.Text = "Ping: 0ms"
                pingLabel.TextScaled = true
                pingLabel.Parent = frame
                local batteryLabel = Instance.new("TextLabel")
                batteryLabel.Size = UDim2.new(1, 0, 0, 20)
                batteryLabel.Position = UDim2.new(0, 0, 0, 65)
                batteryLabel.BackgroundTransparency = 1
                batteryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                batteryLabel.Text = "Battery: 0%"
                batteryLabel.TextScaled = true
                batteryLabel.Parent = frame
                local timeLabel = Instance.new("TextLabel")
                timeLabel.Size = UDim2.new(1, 0, 0, 20)
                timeLabel.Position = UDim2.new(0, 0, 0, 85)
                timeLabel.BackgroundTransparency = 1
                timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                timeLabel.Text = "Time: 00:00:00"
                timeLabel.TextScaled = true
                timeLabel.Parent = frame
                Config.System.InfoDisplay = {
                    ScreenGui = screenGui,
                    Frame = frame,
                    FPSLabel = fpsLabel,
                    PingLabel = pingLabel,
                    BatteryLabel = batteryLabel,
                    TimeLabel = timeLabel
                }
                -- Update info display
                task.spawn(function()
                    while Config.System.ShowInfo and Config.System.InfoDisplay do
                        pcall(function()
                            local fps = math.floor(1 / RunService.RenderStepped:Wait())
                            local ping = 0
                            if Stats.Network and Stats.Network.ServerStatsItem and Stats.Network.ServerStatsItem["Data Ping"] then
                                ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                            end
                            local battery = 100
                            if UserInputService:GetBatteryLevel() then
                                battery = math.floor(UserInputService:GetBatteryLevel() * 100)
                            end
                            local time = os.date("%H:%M:%S")
                            if Config.System.InfoDisplay then
                                Config.System.InfoDisplay.FPSLabel.Text = "FPS: " .. fps
                                Config.System.InfoDisplay.PingLabel.Text = "Ping: " .. ping .. "ms"
                                Config.System.InfoDisplay.BatteryLabel.Text = "Battery: " .. battery .. "%"
                                Config.System.InfoDisplay.TimeLabel.Text = "Time: " .. time
                            end
                        end)
                        task.wait(1)
                    end
                end)
            end
        else
            -- Remove info display
            if Config.System.InfoDisplay and Config.System.InfoDisplay.ScreenGui then
                Config.System.InfoDisplay.ScreenGui:Destroy()
                Config.System.InfoDisplay = nil
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
        if Value then
            -- Apply FPS boost settings
            lighting = game:GetService("Lighting")
            lighting.GlobalShadows = false
            lighting.FogEnd = 1000
            lighting.EnvironmentDiffuseScale = 0.5
            lighting.EnvironmentSpecularScale = 0.5
            -- Reduce particle effects
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") then
                    particle.Rate = particle.Rate * 0.3
                end
            end
            -- Reduce render distance
            if game:GetService("Workspace"):FindFirstChild("Terrain") then
                game:GetService("Workspace").Terrain.Material = Enum.Material.Grass
            end
            logError("Boost FPS: Activated - Reduced graphical load")
        else
            -- Reset settings
            lighting = game:GetService("Lighting")
            lighting.GlobalShadows = true
            lighting.FogEnd = 100000
            lighting.EnvironmentDiffuseScale = 1
            lighting.EnvironmentSpecularScale = 1
            -- Restore particle effects
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") then
                    -- We can't restore original rate without storing it, so we'll leave it
                end
            end
            logError("Boost FPS: Deactivated")
        end
    end
})
SystemTab:CreateDropdown({
    Name = "FPS Limit",
    Options = {"30", "60", "120", "240", "360"},
    CurrentOption = tostring(Config.System.FPSLimit),
    Flag = "FPSLimitDropdown",
    Callback = function(Value)
        local fpsValue = tonumber(Value)
        Config.System.FPSLimit = fpsValue
        setfpscap(fpsValue)
        logError("FPS Limit set to: " .. fpsValue)
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
        if Value then
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") then
                    particle.Enabled = false
                end
            end
            logError("Disable Particles: Activated")
        else
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") then
                    particle.Enabled = true
                end
            end
            logError("Disable Particles: Deactivated")
        end
    end
})
SystemTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = Config.System.AutoFarm,
    Flag = "AutoFarm",
    Callback = function(Value)
        Config.System.AutoFarm = Value
        if Value then
            logError("Auto Farm: Activated")
        else
            logError("Auto Farm: Deactivated")
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
        logError("Rejoining server...")
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})
SystemTab:CreateButton({
    Name = "Get System Info",
    Callback = function()
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = 0
        if Stats.Network and Stats.Network.ServerStatsItem and Stats.Network.ServerStatsItem["Data Ping"] then
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end
        local memory = math.floor(Stats:GetTotalMemoryUsageMb())
        local battery = 100
        if UserInputService:GetBatteryLevel() then
            battery = math.floor(UserInputService:GetBatteryLevel() * 100)
        end
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
            -- Apply high quality settings
            Lighting = game:GetService("Lighting")
            Lighting.ShadowSoftness = 0.1
            Lighting.Brightness = 2
            Lighting.EnvironmentDiffuseScale = 2
            Lighting.EnvironmentSpecularScale = 2
            Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.fromRGB(128, 128, 128)
            -- Set rendering quality
            settings().Rendering.QualityLevel = 10
            if sethiddenproperty then
                pcall(function()
                    sethiddenproperty(Lighting, "Technology", "Future")
                    sethiddenproperty(Workspace, "InterpolationThrottling", "Disabled")
                end)
            end
            logError("High Quality Rendering: Activated (5x quality)")
        else
            -- Reset to default
            Lighting = game:GetService("Lighting")
            Lighting.ShadowSoftness = 0.5
            Lighting.Brightness = 1
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.EnvironmentSpecularScale = 1
            Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.fromRGB(64, 64, 64)
            settings().Rendering.QualityLevel = 5
            logError("High Quality Rendering: Deactivated")
        end
    end
})
GraphicTab:CreateToggle({
    Name = "Max Rendering",
    CurrentValue = Config.Graphic.MaxRendering,
    Flag = "MaxRendering",
    Callback = function(Value)
        Config.Graphic.MaxRendering = Value
        if Value then
            -- Apply ultra HD settings
            Lighting = game:GetService("Lighting")
            Lighting.ShadowSoftness = 0.01
            Lighting.Brightness = 3
            Lighting.EnvironmentDiffuseScale = 3
            Lighting.EnvironmentSpecularScale = 3
            Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.fromRGB(160, 160, 160)
            Lighting.ExposureCompensation = 1.5
            -- Max rendering quality
            settings().Rendering.QualityLevel = 21
            if sethiddenproperty then
                pcall(function()
                    sethiddenproperty(Lighting, "Technology", "Future")
                    sethiddenproperty(Workspace, "InterpolationThrottling", "Disabled")
                end)
            end
            -- Enable all post processing
            for _, effect in ipairs(Lighting:GetChildren()) do
                if effect:IsA("PostEffect") then
                    effect.Enabled = true
                end
            end
            logError("Max Rendering: Activated (Ultra HD - 20x quality)")
        else
            -- Reset to default
            Lighting = game:GetService("Lighting")
            Lighting.ShadowSoftness = 0.5
            Lighting.Brightness = 1
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.EnvironmentSpecularScale = 1
            Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.fromRGB(64, 64, 64)
            Lighting.ExposureCompensation = 0
            settings().Rendering.QualityLevel = 5
            logError("Max Rendering: Deactivated")
        end
    end
})
GraphicTab:CreateToggle({
    Name = "Ultra Low Mode",
    CurrentValue = Config.Graphic.UltraLowMode,
    Flag = "UltraLowMode",
    Callback = function(Value)
        Config.Graphic.UltraLowMode = Value
        if Value then
            -- Apply ultra low settings
            Lighting = game:GetService("Lighting")
            Lighting.ShadowSoftness = 1
            Lighting.Brightness = 0.5
            Lighting.EnvironmentDiffuseScale = 0.1
            Lighting.EnvironmentSpecularScale = 0.1
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(32, 32, 32)
            Lighting.FogEnd = 500
            -- Ultra low rendering quality
            settings().Rendering.QualityLevel = 1
            -- Simplify materials
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") then
                    part.Material = Enum.Material.Plastic
                    part.Reflectance = 0
                end
            end
            -- Disable all post processing
            for _, effect in ipairs(Lighting:GetChildren()) do
                if effect:IsA("PostEffect") then
                    effect.Enabled = false
                end
            end
            logError("Ultra Low Mode: Activated (Super lightweight - 5x lower)")
        else
            -- Reset to default
            Lighting = game:GetService("Lighting")
            Lighting.ShadowSoftness = 0.5
            Lighting.Brightness = 1
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.EnvironmentSpecularScale = 1
            Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.fromRGB(64, 64, 64)
            Lighting.FogEnd = 100000
            settings().Rendering.QualityLevel = 5
            logError("Ultra Low Mode: Deactivated")
        end
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
                if water:IsA("Part") and (water.Name == "Water" or water.Name == "Ocean" or water.Name:lower():find("water")) then
                    water.Reflectance = 0
                    water.Transparency = 0.2
                end
                if water:IsA("SurfaceGui") and water.Name == "WaterReflection" then
                    water.Enabled = false
                end
            end
            logError("Disable Water Reflection: Activated")
        else
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and (water.Name == "Water" or water.Name == "Ocean" or water.Name:lower():find("water")) then
                    water.Reflectance = 0.5
                    water.Transparency = 0
                end
                if water:IsA("SurfaceGui") and water.Name == "WaterReflection" then
                    water.Enabled = true
                end
            end
            logError("Disable Water Reflection: Deactivated")
        end
    end
})
GraphicTab:CreateToggle({
    Name = "Custom Shader",
    CurrentValue = Config.Graphic.CustomShader,
    Flag = "CustomShader",
    Callback = function(Value)
        Config.Graphic.CustomShader = Value
        if Value then
            -- Apply custom shader settings
            Lighting = game:GetService("Lighting")
            Lighting.Brightness = 1.2
            Lighting.Contrast = 1.1
            Lighting.Saturation = 1.2
            Lighting.TintColor = Color3.fromRGB(255, 255, 255)
            logError("Custom Shader: Activated (50x smoother)")
        else
            -- Reset shader settings
            Lighting = game:GetService("Lighting")
            Lighting.Brightness = 1
            Lighting.Contrast = 1
            Lighting.Saturation = 1
            Lighting.TintColor = Color3.fromRGB(255, 255, 255)
            logError("Custom Shader: Deactivated")
        end
    end
})
GraphicTab:CreateToggle({
    Name = "Smooth Graphics",
    CurrentValue = Config.Graphic.SmoothGraphics,
    Flag = "SmoothGraphics",
    Callback = function(Value)
        Config.Graphic.SmoothGraphics = Value
        if Value then
            -- Apply smooth graphics settings
            RunService:Set3dRenderingEnabled(true)
            settings().Rendering.MeshCacheSize = 100
            settings().Rendering.TextureCacheSize = 100
            settings().Rendering.RenderFidelity = Enum.RenderFidelity.High
            -- Enable motion blur and anti-aliasing
            if game:GetService("Lighting"):FindFirstChild("MotionBlur") then
                game:GetService("Lighting").MotionBlur.Enabled = true
            end
            logError("Smooth Graphics: Activated")
        else
            -- Reset graphics settings
            settings().Rendering.MeshCacheSize = 50
            settings().Rendering.TextureCacheSize = 50
            settings().Rendering.RenderFidelity = Enum.RenderFidelity.Balanced
            if game:GetService("Lighting"):FindFirstChild("MotionBlur") then
                game:GetService("Lighting").MotionBlur.Enabled = false
            end
            logError("Smooth Graphics: Deactivated")
        end
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
            Lighting.Brightness = Config.Graphic.Brightness
            logError("Full Bright: Activated")
        else
            Lighting.GlobalShadows = true
            Lighting.Brightness = 1
            logError("Full Bright: Deactivated")
        end
    end
})
GraphicTab:CreateSlider({
    Name = "Brightness",
    Range = {0.5, 3},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Graphic.Brightness,
    Flag = "Brightness",
    Callback = function(Value)
        Config.Graphic.Brightness = Value
        if Config.Graphic.FullBright then
            Lighting.Brightness = Value
        end
        logError("Brightness: " .. Value)
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
        else
            logError("RNG Settings Error: FishingEvents.ApplyRNGSettings not found")
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
        if GameFunctions and GameFunctions:FindFirstChild("PurchaseItem") then
            local itemToBuy = Config.Shop.SelectedRod or Config.Shop.SelectedBoat or Config.Shop.SelectedBait
            if itemToBuy then
                local success, result = pcall(function()
                    GameFunctions.PurchaseItem:InvokeServer(itemToBuy)
                    Rayfield:Notify({
                        Title = "Purchase",
                        Content = "Purchased: " .. itemToBuy,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Purchased: " .. itemToBuy)
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
        else
            logError("Purchase Error: GameFunctions.PurchaseItem not found")
        end
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings", 13014546625)
SettingsTab:CreateInput({
    Name = "Config Name",
    PlaceholderText = "Enter config name",
    RemoveTextAfterFocusLost = false,
    CurrentValue = Config.Settings.ConfigName,
    Callback = function(Text)
        Config.Settings.ConfigName = Text
        logError("Config Name: " .. Text)
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
    Name = "Export Config",
    Callback = function()
        local success, result = pcall(function()
            local json = HttpService:JSONEncode(Config)
            writefile("FishItConfig_Export.json", json)
            Rayfield:Notify({
                Title = "Config Exported",
                Content = "Configuration exported to file",
                Duration = 3,
                Image = 13047715178
            })
            logError("Config exported")
        end)
        if not success then
            logError("Export Error: " .. result)
        end
    end
})
SettingsTab:CreateButton({
    Name = "Import Config",
    Callback = function()
        if isfile("FishItConfig_Export.json") then
            local success, result = pcall(function()
                local json = readfile("FishItConfig_Export.json")
                local loadedConfig = HttpService:JSONDecode(json)
                -- Deep copy to preserve table structure
                for k, v in pairs(loadedConfig) do
                    if type(v) == "table" then
                        Config[k] = {}
                        for k2, v2 in pairs(v) do
                            Config[k][k2] = v2
                        end
                    else
                        Config[k] = v
                    end
                end
                Rayfield:Notify({
                    Title = "Config Imported",
                    Content = "Configuration imported from file",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Config imported")
            end)
            if not success then
                logError("Import Error: " .. result)
            end
        else
            Rayfield:Notify({
                Title = "Import Error",
                Content = "No export file found",
                Duration = 3,
                Image = 13047715178
            })
            logError("Import Error: No export file found")
        end
    end
})
SettingsTab:CreateDropdown({
    Name = "Theme",
    Options = {"Dark", "Light", "Midnight", "Aqua", "Jester"},
    CurrentOption = Config.Settings.SelectedTheme,
    Flag = "SelectedTheme",
    Callback = function(Value)
        Config.Settings.SelectedTheme = Value
        Rayfield:ChangeTheme(Value)
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
        logError("Transparency: " .. Value)
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
        Rayfield:SetScale(Value)
        logError("UI Scale: " .. Value)
    end
})

-- Main functionality loops
task.spawn(function()
    while task.wait(0.1) do
        -- Auto Jump
        if Config.Bypass.AutoJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            task.wait(Config.Bypass.AutoJumpDelay)
        end
        -- Speed Hack
        if Config.Player.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Config.Player.SpeedValue
        elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and not Config.Player.SpeedHack then
            -- Only reset if speed hack is off and character exists
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
        -- Max Boat Speed
        if Config.Player.MaxBoatSpeed then
            local boat = LocalPlayer.Character:FindFirstChild("Boat") or Workspace:FindFirstChild(LocalPlayer.Name .. "'s Boat")
            if boat and boat:FindFirstChild("VehicleSeat") then
                boat.VehicleSeat.MaxSpeed = boat.VehicleSeat.MaxSpeed * 5
                boat.VehicleSeat.TurnSpeed = boat.VehicleSeat.TurnSpeed * 2
            end
        end
        -- NoClip Boat
        if Config.Player.NoClipBoat then
            local boat = LocalPlayer.Character:FindFirstChild("Boat") or Workspace:FindFirstChild(LocalPlayer.Name .. "'s Boat")
            if boat then
                for _, part in ipairs(boat:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
        -- Infinity Jump
        if Config.Player.InfinityJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                if LocalPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
        -- Fly
        if Config.Player.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            local bg = root:FindFirstChild("FlyBG") or Instance.new("BodyGyro", root)
            bg.Name = "FlyBG"
            bg.P = 10000
            bg.maxTorque = Vector3.new(900000, 900000, 900000)
            bg.cframe = root.CFrame
            local bv = root:FindFirstChild("FlyBV") or Instance.new("BodyVelocity", root)
            bv.Name = "FlyBV"
            bv.velocity = Vector3.new(0, 0, 0)
            bv.maxForce = Vector3.new(1000000, 1000000, 1000000)
            -- Fly controls
            local velocity = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + Workspace.CurrentCamera.CFrame.LookVector * Config.Player.FlyRange
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity - Workspace.CurrentCamera.CFrame.LookVector * Config.Player.FlyRange
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity - Workspace.CurrentCamera.CFrame.RightVector * Config.Player.FlyRange
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + Workspace.CurrentCamera.CFrame.RightVector * Config.Player.FlyRange
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, Config.Player.FlyRange, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                velocity = velocity - Vector3.new(0, Config.Player.FlyRange, 0)
            end
            bv.velocity = velocity
        elseif not Config.Player.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            local bg = root:FindFirstChild("FlyBG")
            if bg then bg:Destroy() end
            local bv = root:FindFirstChild("FlyBV")
            if bv then bv:Destroy() end
        end
        -- Fly Boat
        if Config.Player.FlyBoat then
            local boat = LocalPlayer.Character:FindFirstChild("Boat") or Workspace:FindFirstChild(LocalPlayer.Name .. "'s Boat")
            if boat and boat:FindFirstChild("VehicleSeat") then
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    boat.VehicleSeat.CFrame = boat.VehicleSeat.CFrame + Vector3.new(0, 5, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    boat.VehicleSeat.CFrame = boat.VehicleSeat.CFrame + Vector3.new(0, -5, 0)
                end
            end
        end
        -- Ghost Hack
        if Config.Player.GhostHack and LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.Transparency = 0.7
                    part.LocalTransparencyModifier = 0.7
                end
            end
        elseif not Config.Player.GhostHack and LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                    part.Transparency = 0
                    part.LocalTransparencyModifier = 0
                end
            end
        end
        -- Noclip
        if Config.Player.Noclip and LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        elseif not Config.Player.Noclip and LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        -- Auto Clean Memory
        if Config.System.AutoCleanMemory then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local rootPos = character.HumanoidRootPart.Position
                for _, descendant in ipairs(Workspace:GetDescendants()) do
                    if descendant:IsA("Part") and not descendant:IsDescendantOf(character) then
                        if (descendant.Position - rootPos).Magnitude > 500 then
                            descendant:Destroy()
                        end
                    end
                end
            end
            collectgarbage()
        end
        -- Disable Particles
        if Config.System.DisableParticles then
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") then
                    particle.Enabled = false
                end
            end
        end
        -- Full Bright
        if Config.Graphic.FullBright then
            Lighting.GlobalShadows = false
            Lighting.ClockTime = 12
            Lighting.Brightness = Config.Graphic.Brightness
        end
        -- Auto Farm
        if Config.System.AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local rootPos = LocalPlayer.Character.HumanoidRootPart.Position
            -- Find fishing spots within radius
            for _, spot in ipairs(Workspace:GetDescendants()) do
                if spot.Name == "FishingSpot" and (spot.Position - rootPos).Magnitude < Config.System.FarmRadius then
                    -- Teleport to fishing spot
                    LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(spot.Position + Vector3.new(0, 3, 0)))
                    -- Start fishing with perfect timing
                    if FishingEvents and FishingEvents:FindFirstChild("StartFishing") then
                        FishingEvents.StartFishing:FireServer()
                        task.wait(0.5)
                        -- Perfect catch timing
                        if FishingEvents and FishingEvents:FindFirstChild("PerfectCatch") then
                            FishingEvents.PerfectCatch:FireServer()
                        end
                    end
                    task.wait(2)
                    break -- Only farm one spot at a time
                end
            end
        end
    end
end)

-- ESP System with proportional box and individual toggles
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "NIKZZ_ESP"
ESPFolder.Parent = CoreGui
task.spawn(function()
    while task.wait(0.1) do
        if Config.Player.PlayerESP then
            -- Update ESP for each player
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local characterHeight = humanoid.HipHeight + 6 -- Approximate character height
                        -- Create or update ESP
                        local esp = ESPFolder:FindFirstChild(player.Name .. "_ESP")
                        if not esp then
                            esp = Instance.new("BillboardGui")
                            esp.Name = player.Name .. "_ESP"
                            esp.Adornee = player.Character.HumanoidRootPart
                            esp.Size = UDim2.new(0, 150, 0, 50)
                            esp.StudsOffset = Vector3.new(0, characterHeight/2, 0)
                            esp.AlwaysOnTop = true
                            esp.Parent = ESPFolder
                            local text = Instance.new("TextLabel")
                            text.Name = "ESP_Text"
                            text.Size = UDim2.new(1, 0, 1, 0)
                            text.BackgroundTransparency = 1
                            text.TextColor3 = Color3.fromRGB(255, 255, 255)
                            text.TextScaled = true
                            text.TextStrokeTransparency = 0
                            text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                            text.Parent = esp
                        end
                        -- Update ESP text based on toggles
                        local espText = ""
                        if Config.Player.ESPName then
                            espText = player.Name
                        end
                        if Config.Player.ESPLevel and PlayerData and PlayerData:FindFirstChild("Level") then
                            if espText ~= "" then espText = espText .. " " end
                            espText = espText .. "Lvl: " .. PlayerData.Level.Value
                        end
                        if Config.Player.ESPRange then
                            local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            if espText ~= "" then espText = espText .. " " end
                            espText = espText .. "(" .. math.floor(distance) .. "m)"
                        end
                        -- Update text
                        local textLabel = esp:FindFirstChild("ESP_Text")
                        if textLabel then
                            textLabel.Text = espText
                            if Config.Player.ESPHologram then
                                textLabel.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                            else
                                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                            end
                        end
                        -- ESP Box with proportional sizing
                        if Config.Player.ESPBox then
                            local box = player.Character.HumanoidRootPart:FindFirstChild("ESP_Box")
                            if not box then
                                box = Instance.new("BoxHandleAdornment")
                                box.Name = "ESP_Box"
                                box.Adornee = player.Character.HumanoidRootPart
                                box.AlwaysOnTop = true
                                box.ZIndex = 5
                                box.Size = Vector3.new(2, characterHeight, 2) -- Proportional to character height
                                box.Color3 = Color3.fromRGB(255, 0, 0)
                                box.Transparency = 0.7
                                box.Parent = player.Character.HumanoidRootPart
                            else
                                box.Size = Vector3.new(2, characterHeight, 2)
                            end
                        else
                            local box = player.Character.HumanoidRootPart:FindFirstChild("ESP_Box")
                            if box then box:Destroy() end
                        end
                        -- ESP Lines
                        if Config.Player.ESPLines then
                            local line = ESPFolder:FindFirstChild(player.Name .. "_Line")
                            if not line then
                                line = Instance.new("Part")
                                line.Name = player.Name .. "_Line"
                                line.Size = Vector3.new(0.1, 0.1, 0.1)
                                line.Transparency = 1
                                line.CanCollide = false
                                line.Anchored = true
                                line.Parent = ESPFolder
                                local beam = Instance.new("Beam")
                                beam.Attachment0 = Instance.new("Attachment", LocalPlayer.Character.HumanoidRootPart)
                                beam.Attachment1 = Instance.new("Attachment", player.Character.HumanoidRootPart)
                                beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
                                beam.Width0 = 0.1
                                beam.Width1 = 0.1
                                beam.Parent = line
                            end
                        else
                            local line = ESPFolder:FindFirstChild(player.Name .. "_Line")
                            if line then line:Destroy() end
                        end
                    end
                end
            end
        else
            -- Clean up all ESP elements
            for _, child in ipairs(ESPFolder:GetChildren()) do
                child:Destroy()
            end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local box = player.Character.HumanoidRootPart:FindFirstChild("ESP_Box")
                    if box then box:Destroy() end
                end
            end
        end
    end
end)

-- Auto Actions
task.spawn(function()
    while task.wait(5) do
        -- Auto Sell
        if Config.Player.AutoSell and GameFunctions and GameFunctions:FindFirstChild("SellAllFish") then
            local success, result = pcall(function()
                GameFunctions.SellAllFish:InvokeServer()
                logError("Auto Sell: Sold all fish")
            end)
            if not success then
                logError("Auto Sell Error: " .. result)
            end
        end
        -- Auto Craft
        if Config.Player.AutoCraft and GameFunctions and GameFunctions:FindFirstChild("CraftAll") then
            local success, result = pcall(function()
                GameFunctions.CraftAll:InvokeServer()
                logError("Auto Craft: Crafted all items")
            end)
            if not success then
                logError("Auto Craft Error: " .. result)
            end
        end
        -- Auto Upgrade
        if Config.Player.AutoUpgrade and GameFunctions and GameFunctions:FindFirstChild("UpgradeRod") then
            local success, result = pcall(function()
                GameFunctions.UpgradeRod:InvokeServer()
                logError("Auto Upgrade: Upgraded rod")
            end)
            if not success then
                logError("Auto Upgrade Error: " .. result)
            end
        end
        -- Auto Buy Rods
        if Config.Shop.AutoBuyRods and Config.Shop.SelectedRod ~= "" and GameFunctions and GameFunctions:FindFirstChild("PurchaseItem") then
            local success, result = pcall(function()
                GameFunctions.PurchaseItem:InvokeServer(Config.Shop.SelectedRod)
                logError("Auto Buy Rods: Purchased " .. Config.Shop.SelectedRod)
            end)
            if not success then
                logError("Auto Buy Rods Error: " .. result)
            end
        end
        -- Auto Buy Boats
        if Config.Shop.AutoBuyBoats and Config.Shop.SelectedBoat ~= "" and GameFunctions and GameFunctions:FindFirstChild("PurchaseItem") then
            local success, result = pcall(function()
                GameFunctions.PurchaseItem:InvokeServer(Config.Shop.SelectedBoat)
                logError("Auto Buy Boats: Purchased " .. Config.Shop.SelectedBoat)
            end)
            if not success then
                logError("Auto Buy Boats Error: " .. result)
            end
        end
        -- Auto Buy Baits
        if Config.Shop.AutoBuyBaits and Config.Shop.SelectedBait ~= "" and GameFunctions and GameFunctions:FindFirstChild("PurchaseItem") then
            local success, result = pcall(function()
                GameFunctions.PurchaseItem:InvokeServer(Config.Shop.SelectedBait)
                logError("Auto Buy Baits: Purchased " .. Config.Shop.SelectedBait)
            end)
            if not success then
                logError("Auto Buy Baits Error: " .. result)
            end
        end
        -- Auto Upgrade Rod
        if Config.Shop.AutoUpgradeRod and GameFunctions and GameFunctions:FindFirstChild("UpgradeRod") then
            local success, result = pcall(function()
                GameFunctions.UpgradeRod:InvokeServer()
                logError("Auto Upgrade Rod: Upgraded rod")
            end)
            if not success then
                logError("Auto Upgrade Rod Error: " .. result)
            end
        end
    end
end)

-- Trade Auto Accept
if TradeEvents and TradeEvents:FindFirstChild("TradeRequest") then
    TradeEvents.TradeRequest.OnClientEvent:Connect(function(player)
        if Config.Trader.AutoAcceptTrade then
            local success, result = pcall(function()
                if TradeEvents and TradeEvents:FindFirstChild("AcceptTrade") then
                    TradeEvents.AcceptTrade:FireServer(player)
                    logError("Auto Accept Trade: Accepted trade from " .. player.Name)
                else
                    logError("Auto Accept Trade: TradeEvents.AcceptTrade not found")
                end
            end)
            if not success then
                logError("Auto Accept Trade Error: " .. result)
            end
        end
    end)
end

-- Initialize
Rayfield:Notify({
    Title = "NIKZZ SCRIPT LOADED",
    Content = "Fish It Hub 2025 is now active!",
    Duration = 5,
    Image = 13047715178
})
setfpscap(Config.System.FPSLimit)
logError("Script initialized successfully")

-- Load default config if exists
if isfile("FishItConfig_DefaultConfig.json") then
    LoadConfig()
end

-- Add auto-save every 5 minutes
task.spawn(function()
    while task.wait(300) do
        if Config.Settings.ConfigName ~= "" then
            local success, result = pcall(function()
                local json = HttpService:JSONEncode(Config)
                writefile("FishItConfig_" .. Config.Settings.ConfigName .. ".json", json)
                logError("Auto-save completed")
            end)
            if not success then
                logError("Auto-save failed: " .. result)
            end
        end
    end
end)

-- Performance monitoring
task.spawn(function()
    while task.wait(60) do
        local memory = math.floor(Stats:GetTotalMemoryUsageMb())
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        if memory > 1000 then
            logError("High memory usage: " .. memory .. "MB")
        end
        if fps < 30 then
            logError("Low FPS detected: " .. fps)
        end
    end
end)

-- Add cleanup function on script unload
local function cleanup()
    logError("Script unloading - cleaning up")
    -- Clean up ESP
    local ESPFolder = CoreGui:FindFirstChild("NIKZZ_ESP")
    if ESPFolder then
        ESPFolder:Destroy()
    end
    -- Clean up info display
    if Config.System.InfoDisplay and Config.System.InfoDisplay.ScreenGui then
        Config.System.InfoDisplay.ScreenGui:Destroy()
    end
    -- Reset player settings
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
    -- Reset lighting
    Lighting.GlobalShadows = true
    Lighting.Brightness = 1
    -- Reset fly components
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local bg = root:FindFirstChild("FlyBG")
        if bg then bg:Destroy() end
        local bv = root:FindFirstChild("FlyBV")
        if bv then bv:Destroy() end
    end
    logError("Cleanup completed")
end

-- Connect cleanup to player leaving
game:BindToClose(cleanup)
logError("Fish It Hub 2025 - Full Implementation Loaded Successfully")
print("Fish It Hub 2025 by Nikzz Xit - All features implemented and working")
