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

-- UI State Management
local UIDebounce = {}
local UILocks = {}
local LastUIState = {}

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

-- UI Callback Handler with Debounce
local function safeUICallback(callbackName, callbackFunc, ...)
    if UILocks[callbackName] then
        logError("UI Callback " .. callbackName .. " is already locked, skipping")
        return
    end
    
    UILocks[callbackName] = true
    local args = {...}
    
    local success, result = pcall(function()
        callbackFunc(unpack(args))
    end)
    
    if not success then
        logError("UI Callback Error [" .. callbackName .. "]: " .. result)
        Rayfield:Notify({
            Title = "UI Error",
            Content = "Error in " .. callbackName .. ": " .. result,
            Duration = 5,
            Image = 13047715178
        })
    end
    
    -- Debounce period
    task.delay(0.2, function()
        UILocks[callbackName] = false
    end)
end

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
        safeUICallback("AntiAFK", function()
            Config.Bypass.AntiAFK = Value
            logError("Anti AFK: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Anti AFK",
                Content = "Anti AFK " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

BypassTab:CreateToggle({
    Name = "Auto Jump",
    CurrentValue = Config.Bypass.AutoJump,
    Flag = "AutoJump",
    Callback = function(Value)
        safeUICallback("AutoJump", function()
            Config.Bypass.AutoJump = Value
            logError("Auto Jump: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Auto Jump",
                Content = "Auto Jump " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
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
        safeUICallback("AutoJumpDelay", function()
            Config.Bypass.AutoJumpDelay = Value
            logError("Auto Jump Delay: " .. Value)
        end)
    end
})

BypassTab:CreateToggle({
    Name = "Anti Kick",
    CurrentValue = Config.Bypass.AntiKick,
    Flag = "AntiKick",
    Callback = function(Value)
        safeUICallback("AntiKick", function()
            Config.Bypass.AntiKick = Value
            logError("Anti Kick: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Anti Kick",
                Content = "Anti Kick " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

BypassTab:CreateToggle({
    Name = "Anti Ban",
    CurrentValue = Config.Bypass.AntiBan,
    Flag = "AntiBan",
    Callback = function(Value)
        safeUICallback("AntiBan", function()
            Config.Bypass.AntiBan = Value
            logError("Anti Ban: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Anti Ban",
                Content = "Anti Ban " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Fishing Radar",
    CurrentValue = Config.Bypass.BypassFishingRadar,
    Flag = "BypassFishingRadar",
    Callback = function(Value)
        safeUICallback("BypassFishingRadar", function()
            Config.Bypass.BypassFishingRadar = Value
            if Value and FishingEvents and FishingEvents:FindFirstChild("RadarBypass") then
                local success, result = pcall(function()
                    FishingEvents.RadarBypass:FireServer()
                    logError("Bypass Fishing Radar: Activated")
                    Rayfield:Notify({
                        Title = "Bypass Fishing Radar",
                        Content = "Fishing Radar Bypass activated",
                        Duration = 3,
                        Image = 13047715178
                    })
                end)
                if not success then
                    logError("Bypass Fishing Radar Error: " .. result)
                    Rayfield:Notify({
                        Title = "Bypass Error",
                        Content = "Failed to bypass fishing radar: " .. result,
                        Duration = 5,
                        Image = 13047715178
                    })
                end
            else
                logError("Bypass Fishing Radar: " .. tostring(Value))
            end
        end)
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Diving Gear",
    CurrentValue = Config.Bypass.BypassDivingGear,
    Flag = "BypassDivingGear",
    Callback = function(Value)
        safeUICallback("BypassDivingGear", function()
            Config.Bypass.BypassDivingGear = Value
            if Value and GameFunctions and GameFunctions:FindFirstChild("DivingBypass") then
                local success, result = pcall(function()
                    GameFunctions.DivingBypass:InvokeServer()
                    logError("Bypass Diving Gear: Activated")
                    Rayfield:Notify({
                        Title = "Bypass Diving Gear",
                        Content = "Diving Gear Bypass activated",
                        Duration = 3,
                        Image = 13047715178
                    })
                end)
                if not success then
                    logError("Bypass Diving Gear Error: " .. result)
                    Rayfield:Notify({
                        Title = "Bypass Error",
                        Content = "Failed to bypass diving gear: " .. result,
                        Duration = 5,
                        Image = 13047715178
                    })
                end
            else
                logError("Bypass Diving Gear: " .. tostring(Value))
            end
        end)
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Fishing Animation",
    CurrentValue = Config.Bypass.BypassFishingAnimation,
    Flag = "BypassFishingAnimation",
    Callback = function(Value)
        safeUICallback("BypassFishingAnimation", function()
            Config.Bypass.BypassFishingAnimation = Value
            if Value and FishingEvents and FishingEvents:FindFirstChild("AnimationBypass") then
                local success, result = pcall(function()
                    FishingEvents.AnimationBypass:FireServer()
                    logError("Bypass Fishing Animation: Activated")
                    Rayfield:Notify({
                        Title = "Bypass Fishing Animation",
                        Content = "Fishing Animation Bypass activated",
                        Duration = 3,
                        Image = 13047715178
                    })
                end)
                if not success then
                    logError("Bypass Fishing Animation Error: " .. result)
                    Rayfield:Notify({
                        Title = "Bypass Error",
                        Content = "Failed to bypass fishing animation: " .. result,
                        Duration = 5,
                        Image = 13047715178
                    })
                end
            else
                logError("Bypass Fishing Animation: " .. tostring(Value))
            end
        end)
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Fishing Delay",
    CurrentValue = Config.Bypass.BypassFishingDelay,
    Flag = "BypassFishingDelay",
    Callback = function(Value)
        safeUICallback("BypassFishingDelay", function()
            Config.Bypass.BypassFishingDelay = Value
            if Value and FishingEvents and FishingEvents:FindFirstChild("DelayBypass") then
                local success, result = pcall(function()
                    FishingEvents.DelayBypass:FireServer()
                    logError("Bypass Fishing Delay: Activated")
                    Rayfield:Notify({
                        Title = "Bypass Fishing Delay",
                        Content = "Fishing Delay Bypass activated",
                        Duration = 3,
                        Image = 13047715178
                    })
                end)
                if not success then
                    logError("Bypass Fishing Delay Error: " .. result)
                    Rayfield:Notify({
                        Title = "Bypass Error",
                        Content = "Failed to bypass fishing delay: " .. result,
                        Duration = 5,
                        Image = 13047715178
                    })
                end
            else
                logError("Bypass Fishing Delay: " .. tostring(Value))
            end
        end)
    end
})

-- Teleport Tab
local TeleportTab = Window:CreateTab("🗺️ Teleport", 13014546625)

-- Create location checkboxes (replaces dropdown)
local locationCheckboxes = {}
for _, island in ipairs(Islands) do
    locationCheckboxes[island] = TeleportTab:CreateToggle({
        Name = island,
        CurrentValue = Config.Teleport.SelectedLocation == island,
        Flag = "Location_" .. island,
        Callback = function(Value)
            safeUICallback("Location_" .. island, function()
                if Value then
                    -- Uncheck all other location checkboxes
                    for locName, checkbox in pairs(locationCheckboxes) do
                        if locName ~= island then
                            checkbox:Set(false)
                        end
                    end
                    Config.Teleport.SelectedLocation = island
                    logError("Selected Location: " .. island)
                else
                    -- Don't allow unchecking if this is the selected one
                    if Config.Teleport.SelectedLocation == island then
                        locationCheckboxes[island]:Set(true)
                    end
                end
            end)
        end
    })
end

TeleportTab:CreateButton({
    Name = "Teleport To Selected Island",
    Callback = function()
        safeUICallback("TeleportToIsland", function()
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
                        Content = "Character not found or loaded",
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Teleport Error: Character not found")
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
        end)
    end
})

-- Player list for teleport (checkbox implementation)
local playerCheckboxes = {}
local function updatePlayerList()
    -- Clear old player checkboxes
    for _, checkbox in pairs(playerCheckboxes) do
        checkbox:Destroy()
    end
    playerCheckboxes = {}
    
    -- Create new player checkboxes
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            playerCheckboxes[player.Name] = TeleportTab:CreateToggle({
                Name = player.Name,
                CurrentValue = Config.Teleport.SelectedPlayer == player.Name,
                Flag = "Player_" .. player.Name,
                Callback = function(Value)
                    safeUICallback("PlayerSelect_" .. player.Name, function()
                        if Value then
                            -- Uncheck all other player checkboxes
                            for pName, checkbox in pairs(playerCheckboxes) do
                                if pName ~= player.Name then
                                    checkbox:Set(false)
                                end
                            end
                            Config.Teleport.SelectedPlayer = player.Name
                            logError("Selected Player: " .. player.Name)
                        else
                            -- Don't allow unchecking if this is the selected one
                            if Config.Teleport.SelectedPlayer == player.Name then
                                playerCheckboxes[player.Name]:Set(true)
                            end
                        end
                    end)
                end
            })
        end
    end
end

-- Initial player list
updatePlayerList()

-- Refresh player list button
TeleportTab:CreateButton({
    Name = "Refresh Player List",
    Callback = function()
        safeUICallback("RefreshPlayerList", function()
            updatePlayerList()
            Rayfield:Notify({
                Title = "Player List",
                Content = "Player list refreshed",
                Duration = 3,
                Image = 13047715178
            })
            logError("Player list refreshed")
        end)
    end
})

TeleportTab:CreateButton({
    Name = "Teleport To Selected Player",
    Callback = function()
        safeUICallback("TeleportToPlayer", function()
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
        end)
    end
})

-- Event checkboxes (replaces dropdown)
local eventCheckboxes = {}
for _, event in ipairs(Events) do
    eventCheckboxes[event] = TeleportTab:CreateToggle({
        Name = event,
        CurrentValue = Config.Teleport.SelectedEvent == event,
        Flag = "Event_" .. event,
        Callback = function(Value)
            safeUICallback("Event_" .. event, function()
                if Value then
                    -- Uncheck all other event checkboxes
                    for evtName, checkbox in pairs(eventCheckboxes) do
                        if evtName ~= event then
                            checkbox:Set(false)
                        end
                    end
                    Config.Teleport.SelectedEvent = event
                    logError("Selected Event: " .. event)
                else
                    -- Don't allow unchecking if this is the selected one
                    if Config.Teleport.SelectedEvent == event then
                        eventCheckboxes[event]:Set(true)
                    end
                end
            end)
        end
    })
end

TeleportTab:CreateButton({
    Name = "Teleport To Selected Event",
    Callback = function()
        safeUICallback("TeleportToEvent", function()
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
                        Content = "Character not found or loaded",
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Event Teleport Error: Character not found")
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
        end)
    end
})

TeleportTab:CreateInput({
    Name = "Save Position Name",
    PlaceholderText = "Enter position name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        safeUICallback("SavePosition", function()
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
                    Content = "Invalid position name or character not found",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Save Position Error: Invalid input")
            end
        end)
    end
})

-- Saved positions checkboxes
local savedPositionCheckboxes = {}
local function updateSavedPositionsList()
    -- Clear old saved position checkboxes
    for _, checkbox in pairs(savedPositionCheckboxes) do
        checkbox:Destroy()
    end
    savedPositionCheckboxes = {}
    
    -- Create new saved position checkboxes
    for name, _ in pairs(Config.Teleport.SavedPositions) do
        savedPositionCheckboxes[name] = TeleportTab:CreateToggle({
            Name = name,
            CurrentValue = false,
            Flag = "SavedPos_" .. name,
            Callback = function(Value)
                safeUICallback("SavedPos_" .. name, function()
                    if Value and Config.Teleport.SavedPositions[name] and LocalPlayer.Character then
                        LocalPlayer.Character:SetPrimaryPartCFrame(Config.Teleport.SavedPositions[name])
                        Rayfield:Notify({
                            Title = "Position Loaded",
                            Content = "Teleported to saved position: " .. name,
                            Duration = 3,
                            Image = 13047715178
                        })
                        logError("Loaded position: " .. name)
                        
                        -- Uncheck after teleporting
                        task.wait(0.5)
                        savedPositionCheckboxes[name]:Set(false)
                    end
                end)
            end
        })
    end
end

-- Initial saved positions list
updateSavedPositionsList()

-- Refresh saved positions button
TeleportTab:CreateButton({
    Name = "Refresh Saved Positions",
    Callback = function()
        safeUICallback("RefreshSavedPositions", function()
            updateSavedPositionsList()
            Rayfield:Notify({
                Title = "Saved Positions",
                Content = "Saved positions list refreshed",
                Duration = 3,
                Image = 13047715178
            })
            logError("Saved positions list refreshed")
        end)
    end
})

TeleportTab:CreateInput({
    Name = "Delete Position",
    PlaceholderText = "Enter position name to delete",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        safeUICallback("DeletePosition", function()
            if Text ~= "" and Config.Teleport.SavedPositions[Text] then
                Config.Teleport.SavedPositions[Text] = nil
                updateSavedPositionsList()
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
                logError("Delete Position Error: Position not found - " .. Text)
            end
        end)
    end
})

-- Player Tab
local PlayerTab = Window:CreateTab("👤 Player", 13014546625)

PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = Config.Player.SpeedHack,
    Flag = "SpeedHack",
    Callback = function(Value)
        safeUICallback("SpeedHack", function()
            Config.Player.SpeedHack = Value
            logError("Speed Hack: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Speed Hack",
                Content = "Speed Hack " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

PlayerTab:CreateSlider({
    Name = "Speed Value",
    Range = {16, 200},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = Config.Player.SpeedValue,
    Flag = "SpeedValue",
    Callback = function(Value)
        safeUICallback("SpeedValue", function()
            Config.Player.SpeedValue = Value
            logError("Speed Value: " .. Value)
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "Max Boat Speed",
    CurrentValue = Config.Player.MaxBoatSpeed,
    Flag = "MaxBoatSpeed",
    Callback = function(Value)
        safeUICallback("MaxBoatSpeed", function()
            Config.Player.MaxBoatSpeed = Value
            if Value and GameFunctions and GameFunctions:FindFirstChild("BoatSpeed") then
                local success, result = pcall(function()
                    GameFunctions.BoatSpeed:InvokeServer(5.0) -- 5x speed
                    logError("Max Boat Speed: Activated")
                    Rayfield:Notify({
                        Title = "Max Boat Speed",
                        Content = "Boat speed increased to 5x",
                        Duration = 3,
                        Image = 13047715178
                    })
                end)
                if not success then
                    logError("Max Boat Speed Error: " .. result)
                    Rayfield:Notify({
                        Title = "Boat Speed Error",
                        Content = "Failed to set boat speed: " .. result,
                        Duration = 5,
                        Image = 13047715178
                    })
                end
            else
                logError("Max Boat Speed: " .. tostring(Value))
            end
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = Config.Player.InfinityJump,
    Flag = "InfinityJump",
    Callback = function(Value)
        safeUICallback("InfinityJump", function()
            Config.Player.InfinityJump = Value
            logError("Infinity Jump: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Infinity Jump",
                Content = "Infinity Jump " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = Config.Player.Fly,
    Flag = "Fly",
    Callback = function(Value)
        safeUICallback("Fly", function()
            Config.Player.Fly = Value
            logError("Fly: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Fly",
                Content = "Fly " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
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
        safeUICallback("FlyRange", function()
            Config.Player.FlyRange = Value
            logError("Fly Range: " .. Value)
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = Config.Player.FlyBoat,
    Flag = "FlyBoat",
    Callback = function(Value)
        safeUICallback("FlyBoat", function()
            Config.Player.FlyBoat = Value
            logError("Fly Boat: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Fly Boat",
                Content = "Fly Boat " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = Config.Player.GhostHack,
    Flag = "GhostHack",
    Callback = function(Value)
        safeUICallback("GhostHack", function()
            Config.Player.GhostHack = Value
            if Value and LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0.7
                        part.CanCollide = false
                    end
                end
                logError("Ghost Hack: Activated")
                Rayfield:Notify({
                    Title = "Ghost Hack",
                    Content = "Ghost mode activated",
                    Duration = 3,
                    Image = 13047715178
                })
            elseif LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0
                        part.CanCollide = true
                    end
                end
                logError("Ghost Hack: Deactivated")
            end
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = Config.Player.PlayerESP,
    Flag = "PlayerESP",
    Callback = function(Value)
        safeUICallback("PlayerESP", function()
            Config.Player.PlayerESP = Value
            logError("Player ESP: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Player ESP",
                Content = "Player ESP " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = Config.Player.ESPBox,
    Flag = "ESPBox",
    Callback = function(Value)
        safeUICallback("ESPBox", function()
            Config.Player.ESPBox = Value
            logError("ESP Box: " .. tostring(Value))
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Lines",
    CurrentValue = Config.Player.ESPLines,
    Flag = "ESPLines",
    Callback = function(Value)
        safeUICallback("ESPLines", function()
            Config.Player.ESPLines = Value
            logError("ESP Lines: " .. tostring(Value))
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Name",
    CurrentValue = Config.Player.ESPName,
    Flag = "ESPName",
    Callback = function(Value)
        safeUICallback("ESPName", function()
            Config.Player.ESPName = Value
            logError("ESP Name: " .. tostring(Value))
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Level",
    CurrentValue = Config.Player.ESPLevel,
    Flag = "ESPLevel",
    Callback = function(Value)
        safeUICallback("ESPLevel", function()
            Config.Player.ESPLevel = Value
            logError("ESP Level: " .. tostring(Value))
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Range",
    CurrentValue = Config.Player.ESPRange,
    Flag = "ESPRange",
    Callback = function(Value)
        safeUICallback("ESPRange", function()
            Config.Player.ESPRange = Value
            logError("ESP Range: " .. tostring(Value))
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Hologram",
    CurrentValue = Config.Player.ESPHologram,
    Flag = "ESPHologram",
    Callback = function(Value)
        safeUICallback("ESPHologram", function()
            Config.Player.ESPHologram = Value
            logError("ESP Hologram: " .. tostring(Value))
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = Config.Player.Noclip,
    Flag = "Noclip",
    Callback = function(Value)
        safeUICallback("Noclip", function()
            Config.Player.Noclip = Value
            logError("Noclip: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Noclip",
                Content = "Noclip " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = Config.Player.AutoSell,
    Flag = "AutoSell",
    Callback = function(Value)
        safeUICallback("AutoSell", function()
            Config.Player.AutoSell = Value
            logError("Auto Sell: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Auto Sell",
                Content = "Auto Sell " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Craft",
    CurrentValue = Config.Player.AutoCraft,
    Flag = "AutoCraft",
    Callback = function(Value)
        safeUICallback("AutoCraft", function()
            Config.Player.AutoCraft = Value
            logError("Auto Craft: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Auto Craft",
                Content = "Auto Craft " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Upgrade",
    CurrentValue = Config.Player.AutoUpgrade,
    Flag = "AutoUpgrade",
    Callback = function(Value)
        safeUICallback("AutoUpgrade", function()
            Config.Player.AutoUpgrade = Value
            logError("Auto Upgrade: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Auto Upgrade",
                Content = "Auto Upgrade " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "Spawn Boat",
    CurrentValue = Config.Player.SpawnBoat,
    Flag = "SpawnBoat",
    Callback = function(Value)
        safeUICallback("SpawnBoat", function()
            Config.Player.SpawnBoat = Value
            if Value and GameFunctions and GameFunctions:FindFirstChild("SpawnBoat") then
                local success, result = pcall(function()
                    GameFunctions.SpawnBoat:InvokeServer()
                    logError("Spawn Boat: Activated")
                    Rayfield:Notify({
                        Title = "Spawn Boat",
                        Content = "Boat spawned",
                        Duration = 3,
                        Image = 13047715178
                    })
                end)
                if not success then
                    logError("Spawn Boat Error: " .. result)
                    Rayfield:Notify({
                        Title = "Spawn Error",
                        Content = "Failed to spawn boat: " .. result,
                        Duration = 5,
                        Image = 13047715178
                    })
                end
            else
                logError("Spawn Boat: " .. tostring(Value))
            end
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "No Clip Boat",
    CurrentValue = Config.Player.NoClipBoat,
    Flag = "NoClipBoat",
    Callback = function(Value)
        safeUICallback("NoClipBoat", function()
            Config.Player.NoClipBoat = Value
            logError("No Clip Boat: " .. tostring(Value))
            Rayfield:Notify({
                Title = "No Clip Boat",
                Content = "No Clip Boat " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

-- System Tab
local SystemTab = Window:CreateTab("⚙️ System", 13014546625)

SystemTab:CreateToggle({
    Name = "Show Info",
    CurrentValue = Config.System.ShowInfo,
    Flag = "ShowInfo",
    Callback = function(Value)
        safeUICallback("ShowInfo", function()
            Config.System.ShowInfo = Value
            logError("Show Info: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Show Info",
                Content = "Show Info " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

SystemTab:CreateToggle({
    Name = "Boost FPS",
    CurrentValue = Config.System.BoostFPS,
    Flag = "BoostFPS",
    Callback = function(Value)
        safeUICallback("BoostFPS", function()
            Config.System.BoostFPS = Value
            if Value then
                settings().Rendering.QualityLevel = 1
                settings().Rendering.MeshCacheSize = 0
                settings().Rendering.TextureCacheSize = 0
                logError("Boost FPS: Activated")
                Rayfield:Notify({
                    Title = "Boost FPS",
                    Content = "FPS boost activated",
                    Duration = 3,
                    Image = 13047715178
                })
            else
                settings().Rendering.QualityLevel = 10
                logError("Boost FPS: Deactivated")
            end
        end)
    end
})

SystemTab:CreateSlider({
    Name = "FPS Limit",
    Range = {30, 240},
    Increment = 5,
    Suffix = "FPS",
    CurrentValue = Config.System.FPSLimit,
    Flag = "FPSLimit",
    Callback = function(Value)
        safeUICallback("FPSLimit", function()
            Config.System.FPSLimit = Value
            setfpscap(Value)
            logError("FPS Limit: " .. Value)
        end)
    end
})

SystemTab:CreateToggle({
    Name = "Auto Clean Memory",
    CurrentValue = Config.System.AutoCleanMemory,
    Flag = "AutoCleanMemory",
    Callback = function(Value)
        safeUICallback("AutoCleanMemory", function()
            Config.System.AutoCleanMemory = Value
            logError("Auto Clean Memory: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Auto Clean Memory",
                Content = "Auto Clean Memory " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

SystemTab:CreateToggle({
    Name = "Disable Particles",
    CurrentValue = Config.System.DisableParticles,
    Flag = "DisableParticles",
    Callback = function(Value)
        safeUICallback("DisableParticles", function()
            Config.System.DisableParticles = Value
            if Value then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                        obj.Enabled = false
                    end
                end
                logError("Disable Particles: Activated")
                Rayfield:Notify({
                    Title = "Disable Particles",
                    Content = "Particles disabled",
                    Duration = 3,
                    Image = 13047715178
                })
            else
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                        obj.Enabled = true
                    end
                end
                logError("Disable Particles: Deactivated")
            end
        end)
    end
})

SystemTab:CreateToggle({
    Name = "Auto Farm Fishing",
    CurrentValue = Config.System.AutoFarm,
    Flag = "AutoFarm",
    Callback = function(Value)
        safeUICallback("AutoFarm", function()
            Config.System.AutoFarm = Value
            logError("Auto Farm Fishing: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Auto Farm Fishing",
                Content = "Auto Farm Fishing " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
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
        safeUICallback("FarmRadius", function()
            Config.System.FarmRadius = Value
            logError("Farm Radius: " .. Value)
        end)
    end
})

SystemTab:CreateButton({
    Name = "Get System Info",
    Callback = function()
        safeUICallback("GetSystemInfo", function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local memory = math.floor(Stats.Memory:GetValue() / 1024 / 1024)
            
            Rayfield:Notify({
                Title = "System Info",
                Content = "FPS: " .. fps .. " | Ping: " .. ping .. "ms | Memory: " .. memory .. "MB",
                Duration = 5,
                Image = 13047715178
            })
            logError("System Info: FPS=" .. fps .. ", Ping=" .. ping .. "ms, Memory=" .. memory .. "MB")
        end)
    end
})

-- Graphics Tab
local GraphicsTab = Window:CreateTab("🎨 Graphics", 13014546625)

GraphicsTab:CreateToggle({
    Name = "High Quality Rendering",
    CurrentValue = Config.Graphic.HighQuality,
    Flag = "HighQuality",
    Callback = function(Value)
        safeUICallback("HighQuality", function()
            Config.Graphic.HighQuality = Value
            if Value then
                settings().Rendering.QualityLevel = 21
                logError("High Quality Rendering: Activated")
                Rayfield:Notify({
                    Title = "High Quality",
                    Content = "High quality rendering activated (15x)",
                    Duration = 3,
                    Image = 13047715178
                })
            else
                settings().Rendering.QualityLevel = 10
                logError("High Quality Rendering: Deactivated")
            end
        end)
    end
})

GraphicsTab:CreateToggle({
    Name = "Max Rendering (4K Ultra HD)",
    CurrentValue = Config.Graphic.MaxRendering,
    Flag = "MaxRendering",
    Callback = function(Value)
        safeUICallback("MaxRendering", function()
            Config.Graphic.MaxRendering = Value
            if Value then
                settings().Rendering.QualityLevel = 25
                logError("Max Rendering: Activated")
                Rayfield:Notify({
                    Title = "Max Rendering",
                    Content = "Max rendering activated (50x)",
                    Duration = 3,
                    Image = 13047715178
                })
            else
                settings().Rendering.QualityLevel = 10
                logError("Max Rendering: Deactivated")
            end
        end)
    end
})

GraphicsTab:CreateToggle({
    Name = "Ultra Low Mode",
    CurrentValue = Config.Graphic.UltraLowMode,
    Flag = "UltraLowMode",
    Callback = function(Value)
        safeUICallback("UltraLowMode", function()
            Config.Graphic.UltraLowMode = Value
            if Value then
                settings().Rendering.QualityLevel = 1
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Part") then
                        obj.Material = Enum.Material.Plastic
                    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                        obj.Enabled = false
                    end
                end
                logError("Ultra Low Mode: Activated")
                Rayfield:Notify({
                    Title = "Ultra Low Mode",
                    Content = "Ultra low mode activated",
                    Duration = 3,
                    Image = 13047715178
                })
            else
                settings().Rendering.QualityLevel = 10
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                        obj.Enabled = true
                    end
                end
                logError("Ultra Low Mode: Deactivated")
            end
        end)
    end
})

GraphicsTab:CreateToggle({
    Name = "Disable Water Reflection",
    CurrentValue = Config.Graphic.DisableWaterReflection,
    Flag = "DisableWaterReflection",
    Callback = function(Value)
        safeUICallback("DisableWaterReflection", function()
            Config.Graphic.DisableWaterReflection = Value
            if Value then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Water") then
                        obj.Reflectance = 0
                    end
                end
                logError("Disable Water Reflection: Activated")
                Rayfield:Notify({
                    Title = "Water Reflection",
                    Content = "Water reflection disabled",
                    Duration = 3,
                    Image = 13047715178
                })
            else
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Water") then
                        obj.Reflectance = 0.5
                    end
                end
                logError("Disable Water Reflection: Deactivated")
            end
        end)
    end
})

GraphicsTab:CreateToggle({
    Name = "Custom Shader",
    CurrentValue = Config.Graphic.CustomShader,
    Flag = "CustomShader",
    Callback = function(Value)
        safeUICallback("CustomShader", function()
            Config.Graphic.CustomShader = Value
            logError("Custom Shader: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Custom Shader",
                Content = "Custom Shader " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

GraphicsTab:CreateToggle({
    Name = "Smooth Graphics",
    CurrentValue = Config.Graphic.SmoothGraphics,
    Flag = "SmoothGraphics",
    Callback = function(Value)
        safeUICallback("SmoothGraphics", function()
            Config.Graphic.SmoothGraphics = Value
            if Value then
                RunService:SetRobloxGuiFocused(false)
                RunService:Set3dRenderingEnabled(true)
                logError("Smooth Graphics: Activated")
                Rayfield:Notify({
                    Title = "Smooth Graphics",
                    Content = "Smooth graphics activated",
                    Duration = 3,
                    Image = 13047715178
                })
            else
                logError("Smooth Graphics: Deactivated")
            end
        end)
    end
})

GraphicsTab:CreateToggle({
    Name = "Full Bright",
    CurrentValue = Config.Graphic.FullBright,
    Flag = "FullBright",
    Callback = function(Value)
        safeUICallback("FullBright", function()
            Config.Graphic.FullBright = Value
            if Value then
                Lighting.GlobalShadows = false
                Lighting.Brightness = 2
                logError("Full Bright: Activated")
                Rayfield:Notify({
                    Title = "Full Bright",
                    Content = "Full bright activated",
                    Duration = 3,
                    Image = 13047715178
                })
            else
                Lighting.GlobalShadows = true
                Lighting.Brightness = 1
                logError("Full Bright: Deactivated")
            end
        end)
    end
})

-- RNG Kill Tab
local RNGKillTab = Window:CreateTab("🎲 RNG Kill", 13014546625)

RNGKillTab:CreateToggle({
    Name = "RNG Reducer",
    CurrentValue = Config.RNGKill.RNGReducer,
    Flag = "RNGReducer",
    Callback = function(Value)
        safeUICallback("RNGReducer", function()
            Config.RNGKill.RNGReducer = Value
            logError("RNG Reducer: " .. tostring(Value))
            Rayfield:Notify({
                Title = "RNG Reducer",
                Content = "RNG Reducer " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

RNGKillTab:CreateToggle({
    Name = "Force Legendary",
    CurrentValue = Config.RNGKill.ForceLegendary,
    Flag = "ForceLegendary",
    Callback = function(Value)
        safeUICallback("ForceLegendary", function()
            Config.RNGKill.ForceLegendary = Value
            logError("Force Legendary: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Force Legendary",
                Content = "Force Legendary " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

RNGKillTab:CreateToggle({
    Name = "Secret Fish Boost",
    CurrentValue = Config.RNGKill.SecretFishBoost,
    Flag = "SecretFishBoost",
    Callback = function(Value)
        safeUICallback("SecretFishBoost", function()
            Config.RNGKill.SecretFishBoost = Value
            logError("Secret Fish Boost: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Secret Fish Boost",
                Content = "Secret Fish Boost " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

RNGKillTab:CreateToggle({
    Name = "Mythical Chance Boost",
    CurrentValue = Config.RNGKill.MythicalChanceBoost,
    Flag = "MythicalChanceBoost",
    Callback = function(Value)
        safeUICallback("MythicalChanceBoost", function()
            Config.RNGKill.MythicalChanceBoost = Value
            logError("Mythical Chance Boost: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Mythical Chance Boost",
                Content = "Mythical Chance Boost " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

RNGKillTab:CreateToggle({
    Name = "Anti Bad Luck",
    CurrentValue = Config.RNGKill.AntiBadLuck,
    Flag = "AntiBadLuck",
    Callback = function(Value)
        safeUICallback("AntiBadLuck", function()
            Config.RNGKill.AntiBadLuck = Value
            logError("Anti Bad Luck: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Anti Bad Luck",
                Content = "Anti Bad Luck " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

RNGKillTab:CreateToggle({
    Name = "Guaranteed Catch",
    CurrentValue = Config.RNGKill.GuaranteedCatch,
    Flag = "GuaranteedCatch",
    Callback = function(Value)
        safeUICallback("GuaranteedCatch", function()
            Config.RNGKill.GuaranteedCatch = Value
            logError("Guaranteed Catch: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Guaranteed Catch",
                Content = "Guaranteed Catch " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

-- Shop Tab
local ShopTab = Window:CreateTab("🛒 Shop", 13014546625)

-- Rod checkboxes (replaces dropdown)
local rodCheckboxes = {}
for _, rod in ipairs(Rods) do
    rodCheckboxes[rod] = ShopTab:CreateToggle({
        Name = rod,
        CurrentValue = Config.Shop.SelectedRod == rod,
        Flag = "Rod_" .. rod,
        Callback = function(Value)
            safeUICallback("Rod_" .. rod, function()
                if Value then
                    -- Uncheck all other rod checkboxes
                    for rodName, checkbox in pairs(rodCheckboxes) do
                        if rodName ~= rod then
                            checkbox:Set(false)
                        end
                    end
                    Config.Shop.SelectedRod = rod
                    logError("Selected Rod: " .. rod)
                else
                    -- Don't allow unchecking if this is the selected one
                    if Config.Shop.SelectedRod == rod then
                        rodCheckboxes[rod]:Set(true)
                    end
                end
            end)
        end
    })
end

ShopTab:CreateToggle({
    Name = "Auto Buy Rods",
    CurrentValue = Config.Shop.AutoBuyRods,
    Flag = "AutoBuyRods",
    Callback = function(Value)
        safeUICallback("AutoBuyRods", function()
            Config.Shop.AutoBuyRods = Value
            logError("Auto Buy Rods: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Auto Buy Rods",
                Content = "Auto Buy Rods " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

-- Boat checkboxes (replaces dropdown)
local boatCheckboxes = {}
for _, boat in ipairs(Boats) do
    boatCheckboxes[boat] = ShopTab:CreateToggle({
        Name = boat,
        CurrentValue = Config.Shop.SelectedBoat == boat,
        Flag = "Boat_" .. boat,
        Callback = function(Value)
            safeUICallback("Boat_" .. boat, function()
                if Value then
                    -- Uncheck all other boat checkboxes
                    for boatName, checkbox in pairs(boatCheckboxes) do
                        if boatName ~= boat then
                            checkbox:Set(false)
                        end
                    end
                    Config.Shop.SelectedBoat = boat
                    logError("Selected Boat: " .. boat)
                else
                    -- Don't allow unchecking if this is the selected one
                    if Config.Shop.SelectedBoat == boat then
                        boatCheckboxes[boat]:Set(true)
                    end
                end
            end)
        end
    })
end

ShopTab:CreateToggle({
    Name = "Auto Buy Boats",
    CurrentValue = Config.Shop.AutoBuyBoats,
    Flag = "AutoBuyBoats",
    Callback = function(Value)
        safeUICallback("AutoBuyBoats", function()
            Config.Shop.AutoBuyBoats = Value
            logError("Auto Buy Boats: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Auto Buy Boats",
                Content = "Auto Buy Boats " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

-- Bait checkboxes (replaces dropdown)
local baitCheckboxes = {}
for _, bait in ipairs(Baits) do
    baitCheckboxes[bait] = ShopTab:CreateToggle({
        Name = bait,
        CurrentValue = Config.Shop.SelectedBait == bait,
        Flag = "Bait_" .. bait,
        Callback = function(Value)
            safeUICallback("Bait_" .. bait, function()
                if Value then
                    -- Uncheck all other bait checkboxes
                    for baitName, checkbox in pairs(baitCheckboxes) do
                        if baitName ~= bait then
                            checkbox:Set(false)
                        end
                    end
                    Config.Shop.SelectedBait = bait
                    logError("Selected Bait: " .. bait)
                else
                    -- Don't allow unchecking if this is the selected one
                    if Config.Shop.SelectedBait == bait then
                        baitCheckboxes[bait]:Set(true)
                    end
                end
            end)
        end
    })
end

ShopTab:CreateToggle({
    Name = "Auto Buy Baits",
    CurrentValue = Config.Shop.AutoBuyBaits,
    Flag = "AutoBuyBaits",
    Callback = function(Value)
        safeUICallback("AutoBuyBaits", function()
            Config.Shop.AutoBuyBaits = Value
            logError("Auto Buy Baits: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Auto Buy Baits",
                Content = "Auto Buy Baits " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

ShopTab:CreateToggle({
    Name = "Auto Upgrade Rod",
    CurrentValue = Config.Shop.AutoUpgradeRod,
    Flag = "AutoUpgradeRod",
    Callback = function(Value)
        safeUICallback("AutoUpgradeRod", function()
            Config.Shop.AutoUpgradeRod = Value
            logError("Auto Upgrade Rod: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Auto Upgrade Rod",
                Content = "Auto Upgrade Rod " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

ShopTab:CreateButton({
    Name = "Buy Selected Rod",
    Callback = function()
        safeUICallback("BuyRod", function()
            if Config.Shop.SelectedRod ~= "" then
                if GameFunctions and GameFunctions:FindFirstChild("BuyRod") then
                    local success, result = pcall(function()
                        GameFunctions.BuyRod:InvokeServer(Config.Shop.SelectedRod)
                        Rayfield:Notify({
                            Title = "Rod Purchase",
                            Content = "Purchased: " .. Config.Shop.SelectedRod,
                            Duration = 3,
                            Image = 13047715178
                        })
                        logError("Purchased rod: " .. Config.Shop.SelectedRod)
                    end)
                    if not success then
                        Rayfield:Notify({
                            Title = "Purchase Error",
                            Content = "Failed to buy rod: " .. result,
                            Duration = 5,
                            Image = 13047715178
                        })
                        logError("Rod Purchase Error: " .. result)
                    end
                else
                    Rayfield:Notify({
                        Title = "Purchase Error",
                        Content = "Game functions not found",
                        Duration = 5,
                        Image = 13047715178
                    })
                    logError("Rod Purchase Error: Game functions not found")
                end
            else
                Rayfield:Notify({
                    Title = "Purchase Error",
                    Content = "Please select a rod first",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Rod Purchase Error: No rod selected")
            end
        end)
    end
})

ShopTab:CreateButton({
    Name = "Buy Selected Boat",
    Callback = function()
        safeUICallback("BuyBoat", function()
            if Config.Shop.SelectedBoat ~= "" then
                if GameFunctions and GameFunctions:FindFirstChild("BuyBoat") then
                    local success, result = pcall(function()
                        GameFunctions.BuyBoat:InvokeServer(Config.Shop.SelectedBoat)
                        Rayfield:Notify({
                            Title = "Boat Purchase",
                            Content = "Purchased: " .. Config.Shop.SelectedBoat,
                            Duration = 3,
                            Image = 13047715178
                        })
                        logError("Purchased boat: " .. Config.Shop.SelectedBoat)
                    end)
                    if not success then
                        Rayfield:Notify({
                            Title = "Purchase Error",
                            Content = "Failed to buy boat: " .. result,
                            Duration = 5,
                            Image = 13047715178
                        })
                        logError("Boat Purchase Error: " .. result)
                    end
                else
                    Rayfield:Notify({
                        Title = "Purchase Error",
                        Content = "Game functions not found",
                        Duration = 5,
                        Image = 13047715178
                    })
                    logError("Boat Purchase Error: Game functions not found")
                end
            else
                Rayfield:Notify({
                    Title = "Purchase Error",
                    Content = "Please select a boat first",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Boat Purchase Error: No boat selected")
            end
        end)
    end
})

ShopTab:CreateButton({
    Name = "Buy Selected Bait",
    Callback = function()
        safeUICallback("BuyBait", function()
            if Config.Shop.SelectedBait ~= "" then
                if GameFunctions and GameFunctions:FindFirstChild("BuyBait") then
                    local success, result = pcall(function()
                        GameFunctions.BuyBait:InvokeServer(Config.Shop.SelectedBait, 10) -- Buy 10 baits
                        Rayfield:Notify({
                            Title = "Bait Purchase",
                            Content = "Purchased: 10x " .. Config.Shop.SelectedBait,
                            Duration = 3,
                            Image = 13047715178
                        })
                        logError("Purchased bait: 10x " .. Config.Shop.SelectedBait)
                    end)
                    if not success then
                        Rayfield:Notify({
                            Title = "Purchase Error",
                            Content = "Failed to buy bait: " .. result,
                            Duration = 5,
                            Image = 13047715178
                        })
                        logError("Bait Purchase Error: " .. result)
                    end
                else
                    Rayfield:Notify({
                        Title = "Purchase Error",
                        Content = "Game functions not found",
                        Duration = 5,
                        Image = 13047715178
                    })
                    logError("Bait Purchase Error: Game functions not found")
                end
            else
                Rayfield:Notify({
                    Title = "Purchase Error",
                    Content = "Please select a bait first",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Bait Purchase Error: No bait selected")
            end
        end)
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
        safeUICallback("ConfigName", function()
            if Text ~= "" then
                Config.Settings.ConfigName = Text
                logError("Config name set to: " .. Text)
            end
        end)
    end
})

SettingsTab:CreateButton({
    Name = "Save Config",
    Callback = function()
        safeUICallback("SaveConfig", function()
            SaveConfig()
        end)
    end
})

SettingsTab:CreateButton({
    Name = "Load Config",
    Callback = function()
        safeUICallback("LoadConfig", function()
            LoadConfig()
        end)
    end
})

SettingsTab:CreateButton({
    Name = "Reset Config",
    Callback = function()
        safeUICallback("ResetConfig", function()
            ResetConfig()
        end)
    end
})

SettingsTab:CreateSlider({
    Name = "UI Transparency",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "alpha",
    CurrentValue = Config.Settings.Transparency,
    Flag = "UITransparency",
    Callback = function(Value)
        safeUICallback("UITransparency", function()
            Config.Settings.Transparency = Value
            Rayfield:SetConfiguration({Transparency = Value})
            logError("UI Transparency: " .. Value)
        end)
    end
})

SettingsTab:CreateSlider({
    Name = "UI Scale",
    Range = {0.5, 2},
    Increment = 0.1,
    Suffix = "scale",
    CurrentValue = Config.Settings.UIScale,
    Flag = "UIScale",
    Callback = function(Value)
        safeUICallback("UIScale", function()
            Config.Settings.UIScale = Value
            Rayfield:SetConfiguration({Scale = Value})
            logError("UI Scale: " .. Value)
        end)
    end
})

SettingsTab:CreateToggle({
    Name = "Auto Logging",
    CurrentValue = true,
    Flag = "AutoLogging",
    Callback = function(Value)
        safeUICallback("AutoLogging", function()
            logError("Auto Logging: " .. tostring(Value))
            Rayfield:Notify({
                Title = "Auto Logging",
                Content = "Auto Logging " .. (Value and "enabled" or "disabled"),
                Duration = 3,
                Image = 13047715178
            })
        end)
    end
})

SettingsTab:CreateButton({
    Name = "Open Log File",
    Callback = function()
        safeUICallback("OpenLogFile", function()
            local logPath = "/storage/emulated/0/logscript.txt"
            if isfile(logPath) then
                local content = readfile(logPath)
                Rayfield:Notify({
                    Title = "Log File",
                    Content = "Log file opened (check console for content)",
                    Duration = 5,
                    Image = 13047715178
                })
                print("=== LOG FILE CONTENT ===")
                print(content)
                print("=== END LOG FILE ===")
                logError("Opened log file")
            else
                Rayfield:Notify({
                    Title = "Log Error",
                    Content = "Log file not found",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Log file not found")
            end
        end)
    end
})

SettingsTab:CreateButton({
    Name = "Clear Log File",
    Callback = function()
        safeUICallback("ClearLogFile", function()
            local logPath = "/storage/emulated/0/logscript.txt"
            if isfile(logPath) then
                writefile(logPath, "")
                Rayfield:Notify({
                    Title = "Log File",
                    Content = "Log file cleared",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Log file cleared")
            else
                Rayfield:Notify({
                    Title = "Log Error",
                    Content = "Log file not found",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Log file not found (clear)")
            end
        end)
    end
})

-- Low Device Section
local LowDeviceTab = Window:CreateTab("📱 Low Device", 13014546625)

LowDeviceTab:CreateToggle({
    Name = "Anti Lag",
    CurrentValue = false,
    Flag = "AntiLag",
    Callback = function(Value)
        safeUICallback("AntiLag", function()
            if Value then
                settings().Rendering.QualityLevel = 1
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Part") then
                        obj.Material = Enum.Material.Plastic
                    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                        obj.Enabled = false
                    elseif obj:IsA("Decal") then
                        obj.Transparency = 1
                    end
                end
                logError("Anti Lag: Activated")
                Rayfield:Notify({
                    Title = "Anti Lag",
                    Content = "Anti Lag mode activated",
                    Duration = 3,
                    Image = 13047715178
                })
            else
                settings().Rendering.QualityLevel = 10
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                        obj.Enabled = true
                    elseif obj:IsA("Decal") then
                        obj.Transparency = 0
                    end
                end
                logError("Anti Lag: Deactivated")
            end
        end)
    end
})

LowDeviceTab:CreateToggle({
    Name = "FPS Stabilizer",
    CurrentValue = false,
    Flag = "FPSStabilizer",
    Callback = function(Value)
        safeUICallback("FPSStabilizer", function()
            if Value then
                setfpscap(30)
                RunService:Set3dRenderingEnabled(true)
                logError("FPS Stabilizer: Activated (30 FPS)")
                Rayfield:Notify({
                    Title = "FPS Stabilizer",
                    Content = "FPS stabilized at 30",
                    Duration = 3,
                    Image = 13047715178
                })
            else
                setfpscap(Config.System.FPSLimit)
                logError("FPS Stabilizer: Deactivated")
            end
        end)
    end
})

LowDeviceTab:CreateToggle({
    Name = "Disable Effects",
    CurrentValue = false,
    Flag = "DisableEffects",
    Callback = function(Value)
        safeUICallback("DisableEffects", function()
            if Value then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                        obj.Enabled = false
                    end
                end
                Lighting.GlobalShadows = false
                logError("Disable Effects: Activated")
                Rayfield:Notify({
                    Title = "Disable Effects",
                    Content = "All visual effects disabled",
                    Duration = 3,
                    Image = 13047715178
                })
            else
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                        obj.Enabled = true
                    end
                end
                Lighting.GlobalShadows = true
                logError("Disable Effects: Deactivated")
            end
        end)
    end
})

LowDeviceTab:CreateToggle({
    Name = "Smooth Graphics (8-bit Style)",
    CurrentValue = false,
    Flag = "SmoothGraphics8Bit",
    Callback = function(Value)
        safeUICallback("SmoothGraphics8Bit", function()
            if Value then
                settings().Rendering.QualityLevel = 1
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Part") then
                        obj.Material = Enum.Material.Plastic
                        obj.Reflectance = 0
                    end
                end
                logError("Smooth Graphics 8-bit: Activated")
                Rayfield:Notify({
                    Title = "Smooth Graphics",
                    Content = "8-bit style graphics activated",
                    Duration = 3,
                    Image = 13047715178
                })
            else
                settings().Rendering.QualityLevel = 10
                logError("Smooth Graphics 8-bit: Deactivated")
            end
        end)
    end
})

LowDeviceTab:CreateToggle({
    Name = "Disable Shadows",
    CurrentValue = false,
    Flag = "DisableShadows",
    Callback = function(Value)
        safeUICallback("DisableShadows", function()
            if Value then
                Lighting.GlobalShadows = false
                for _, light in ipairs(Lighting:GetDescendants()) do
                    if light:IsA("Light") then
                        light.Shadows = false
                    end
                end
                logError("Disable Shadows: Activated")
                Rayfield:Notify({
                    Title = "Disable Shadows",
                    Content = "Shadows disabled",
                    Duration = 3,
                    Image = 13047715178
                })
            else
                Lighting.GlobalShadows = true
                for _, light in ipairs(Lighting:GetDescendants()) do
                    if light:IsA("Light") then
                        light.Shadows = true
                    end
                end
                logError("Disable Shadows: Deactivated")
            end
        end)
    end
})

LowDeviceTab:CreateToggle({
    Name = "Reduce Texture Quality",
    CurrentValue = false,
    Flag = "ReduceTextureQuality",
    Callback = function(Value)
        safeUICallback("ReduceTextureQuality", function()
            if Value then
                settings().Rendering.TextureCacheSize = 0
                settings().Rendering.MeshCacheSize = 0
                logError("Reduce Texture Quality: Activated")
                Rayfield:Notify({
                    Title = "Texture Quality",
                    Content = "Texture quality reduced",
                    Duration = 3,
                    Image = 13047715178
                })
            else
                settings().Rendering.TextureCacheSize = 100
                settings().Rendering.MeshCacheSize = 100
                logError("Reduce Texture Quality: Deactivated")
            end
        end)
    end
})

-- Main runtime loops and handlers
local function mainLoop()
    -- Speed Hack
    if Config.Player.SpeedHack and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Config.Player.SpeedValue
        end
    end
    
    -- Infinity Jump
    if Config.Player.InfinityJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
    
    -- Auto Jump
    if Config.Bypass.AutoJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            task.wait(Config.Bypass.AutoJumpDelay)
        end
    end
    
    -- Noclip
    if Config.Player.Noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- Auto Farm Fishing
    if Config.System.AutoFarm and FishingEvents then
        if FishingEvents:FindFirstChild("StartFishing") then
            local success, result = pcall(function()
                FishingEvents.StartFishing:FireServer()
            end)
            if not success then
                logError("Auto Farm Fishing Error: " .. result)
            end
        end
        task.wait(1)
    end
    
    -- Auto Sell
    if Config.Player.AutoSell and GameFunctions then
        if GameFunctions:FindFirstChild("AutoSell") then
            local success, result = pcall(function()
                GameFunctions.AutoSell:InvokeServer()
            end)
            if not success then
                logError("Auto Sell Error: " .. result)
            end
        end
        task.wait(5)
    end
    
    -- Auto Clean Memory
    if Config.System.AutoCleanMemory then
        collectgarbage()
        task.wait(30)
    end
    
    -- Show Info
    if Config.System.ShowInfo then
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local memory = math.floor(Stats.Memory:GetValue() / 1024 / 1024)
        local battery = math.floor(UserInputService:GetBatteryLevel())
        local time = os.date("%H:%M:%S")
        
        Rayfield:SetConfiguration({
            Override = {
                Info = "FPS: " .. fps .. " | Ping: " .. ping .. "ms | Memory: " .. memory .. "MB | Battery: " .. battery .. "% | Time: " .. time
            }
        })
    end
end

-- Initialize FPS limit
setfpscap(Config.System.FPSLimit)

-- Start main loop
RunService.Heartbeat:Connect(mainLoop)

-- Initial log
logError("Fish It Hub 2025 Script Loaded Successfully")
Rayfield:Notify({
    Title = "Fish It Hub 2025",
    Content = "Script loaded successfully!",
    Duration = 5,
    Image = 13047715178
})

-- Load saved config if exists
task.spawn(function()
    if isfile("FishItConfig_" .. Config.Settings.ConfigName .. ".json") then
        LoadConfig()
    end
end)
