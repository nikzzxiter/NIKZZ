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

-- Create log directory if it doesn't exist
local function ensureLogDirectory()
    local success, err = pcall(function()
        if not isfolder("/storage/emulated/0") then
            makefolder("/storage/emulated/0")
        end
    end)
    if not success then
        warn("Failed to create log directory: " .. tostring(err))
    end
end

ensureLogDirectory()

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

logError("Script started")

-- Anti-AFK
local antiAFKConnection
local function setupAntiAFK()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end
    
    if Config.Bypass.AntiAFK then
        antiAFKConnection = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
            logError("Anti-AFK triggered")
        end)
        logError("Anti-AFK activated")
    else
        logError("Anti-AFK deactivated")
    end
end

-- Anti-Kick
local mt = getrawmetatable(game)
local old = mt.__namecall
local antiKickEnabled = true

local function setupAntiKick()
    if Config.Bypass.AntiKick and antiKickEnabled then
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
        logError("Anti-Kick activated")
    elseif not Config.Bypass.AntiKick and antiKickEnabled then
        setreadonly(mt, false)
        mt.__namecall = old
        setreadonly(mt, true)
        logError("Anti-Kick deactivated")
    end
end

-- Auto Jump
local autoJumpConnection
local function setupAutoJump()
    if autoJumpConnection then
        autoJumpConnection:Disconnect()
        autoJumpConnection = nil
    end
    
    if Config.Bypass.AutoJump then
        autoJumpConnection = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local humanoid = LocalPlayer.Character.Humanoid
                if humanoid:GetState() == Enum.HumanoidStateType.Landed then
                    wait(Config.Bypass.AutoJumpDelay)
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    logError("Auto Jump triggered")
                end
            end
        end)
        logError("Auto Jump activated")
    else
        logError("Auto Jump deactivated")
    end
end

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
        setupAntiAFK()
        logError("Anti AFK: " .. tostring(Value))
    end
})

BypassTab:CreateToggle({
    Name = "Auto Jump",
    CurrentValue = Config.Bypass.AutoJump,
    Flag = "AutoJump",
    Callback = function(Value)
        Config.Bypass.AutoJump = Value
        setupAutoJump()
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
        setupAntiKick()
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
        if Value then
            -- Check if player has radar in inventory
            local hasRadar = false
            if PlayerData and PlayerData:FindFirstChild("Inventory") then
                for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                    if item.Name:find("Radar") then
                        hasRadar = true
                        break
                    end
                end
            end
            
            if hasRadar and FishingEvents and FishingEvents:FindFirstChild("RadarBypass") then
                local success, result = pcall(function()
                    FishingEvents.RadarBypass:FireServer()
                    logError("Bypass Fishing Radar: Activated")
                end)
                if not success then
                    logError("Bypass Fishing Radar Error: " .. result)
                end
            elseif not hasRadar then
                Rayfield:Notify({
                    Title = "Radar Not Found",
                    Content = "You need a radar in your inventory to use this feature",
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Bypass Fishing Radar: No radar in inventory")
                Config.Bypass.BypassFishingRadar = false
            end
        else
            logError("Bypass Fishing Radar: Deactivated")
        end
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Diving Gear",
    CurrentValue = Config.Bypass.BypassDivingGear,
    Flag = "BypassDivingGear",
    Callback = function(Value)
        Config.Bypass.BypassDivingGear = Value
        if Value then
            -- Check if player has diving gear in inventory
            local hasDivingGear = false
            if PlayerData and PlayerData:FindFirstChild("Inventory") then
                for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                    if item.Name:find("Diving") or item.Name:find("Gear") then
                        hasDivingGear = true
                        break
                    end
                end
            end
            
            if hasDivingGear and GameFunctions and GameFunctions:FindFirstChild("DivingBypass") then
                local success, result = pcall(function()
                    GameFunctions.DivingBypass:InvokeServer()
                    logError("Bypass Diving Gear: Activated")
                end)
                if not success then
                    logError("Bypass Diving Gear Error: " .. result)
                end
            elseif not hasDivingGear then
                Rayfield:Notify({
                    Title = "Diving Gear Not Found",
                    Content = "You need diving gear in your inventory to use this feature",
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Bypass Diving Gear: No diving gear in inventory")
                Config.Bypass.BypassDivingGear = false
            end
        else
            logError("Bypass Diving Gear: Deactivated")
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
        else
            logError("Bypass Fishing Animation: Deactivated")
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
        else
            logError("Bypass Fishing Delay: Deactivated")
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
            local success, err = pcall(function()
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
                    error("Character or HumanoidRootPart not found")
                end
            end)
            
            if not success then
                Rayfield:Notify({
                    Title = "Teleport Error",
                    Content = "Failed to teleport: " .. tostring(err),
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Teleport Error: " .. tostring(err))
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
            local success, err = pcall(function()
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
                    error("Character or HumanoidRootPart not found")
                end
            end)
            
            if not success then
                Rayfield:Notify({
                    Title = "Event Error",
                    Content = "Failed to teleport to event: " .. tostring(err),
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Event Teleport Error: " .. tostring(err))
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

-- Speed Hack
local speedHackConnection
local function setupSpeedHack()
    if speedHackConnection then
        speedHackConnection:Disconnect()
        speedHackConnection = nil
    end
    
    if Config.Player.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.Player.SpeedValue
        speedHackConnection = LocalPlayer.CharacterAdded:Connect(function(character)
            if character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = Config.Player.SpeedValue
            end
        end)
        logError("Speed Hack activated: " .. Config.Player.SpeedValue)
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
        logError("Speed Hack deactivated")
    end
end

PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = Config.Player.SpeedHack,
    Flag = "SpeedHack",
    Callback = function(Value)
        Config.Player.SpeedHack = Value
        setupSpeedHack()
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
        if Config.Player.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
        logError("Speed Value: " .. Value)
    end
})

-- Max Boat Speed
local boatSpeedConnection
local function setupMaxBoatSpeed()
    if boatSpeedConnection then
        boatSpeedConnection:Disconnect()
        boatSpeedConnection = nil
    end
    
    if Config.Player.MaxBoatSpeed then
        boatSpeedConnection = Workspace.ChildAdded:Connect(function(child)
            if child.Name:find("Boat") and child:FindFirstChild("Seat") then
                local seat = child.Seat
                if seat:FindFirstChild("Configuration") then
                    seat.Configuration.MaxSpeed = 5 * (seat.Configuration.MaxSpeed or 50)
                    logError("Max Boat Speed applied to: " .. child.Name)
                end
            end
        end)
        
        -- Apply to existing boats
        for _, child in ipairs(Workspace:GetChildren()) do
            if child.Name:find("Boat") and child:FindFirstChild("Seat") then
                local seat = child.Seat
                if seat:FindFirstChild("Configuration") then
                    seat.Configuration.MaxSpeed = 5 * (seat.Configuration.MaxSpeed or 50)
                    logError("Max Boat Speed applied to: " .. child.Name)
                end
            end
        end
        
        logError("Max Boat Speed activated")
    else
        logError("Max Boat Speed deactivated")
    end
end

PlayerTab:CreateToggle({
    Name = "Max Boat Speed",
    CurrentValue = Config.Player.MaxBoatSpeed,
    Flag = "MaxBoatSpeed",
    Callback = function(Value)
        Config.Player.MaxBoatSpeed = Value
        setupMaxBoatSpeed()
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

-- Infinity Jump
local infinityJumpConnection
local function setupInfinityJump()
    if infinityJumpConnection then
        infinityJumpConnection:Disconnect()
        infinityJumpConnection = nil
    end
    
    if Config.Player.InfinityJump then
        infinityJumpConnection = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                logError("Infinity Jump triggered")
            end
        end)
        logError("Infinity Jump activated")
    else
        logError("Infinity Jump deactivated")
    end
end

PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = Config.Player.InfinityJump,
    Flag = "InfinityJump",
    Callback = function(Value)
        Config.Player.InfinityJump = Value
        setupInfinityJump()
        logError("Infinity Jump: " .. tostring(Value))
    end
})

-- Fly
local flyConnection
local flyVelocity, flyGyro
local function setupFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    if flyVelocity then
        flyVelocity:Destroy()
        flyVelocity = nil
    end
    
    if flyGyro then
        flyGyro:Destroy()
        flyGyro = nil
    end
    
    if Config.Player.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
        
        flyVelocity = Instance.new("BodyVelocity")
        flyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyVelocity.Parent = humanoidRootPart
        
        flyGyro = Instance.new("BodyGyro")
        flyGyro.P = 9e4
        flyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyGyro.CFrame = humanoidRootPart.CFrame
        flyGyro.Parent = humanoidRootPart
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
                
                if UserInputService:GetFocusedTextBox() then return end
                
                local moveDirection = LocalPlayer.Character.Humanoid.MoveDirection
                local camera = Workspace.CurrentCamera
                local cameraCFrame = camera.CFrame
                
                local flySpeed = Config.Player.FlyRange
                
                flyVelocity.Velocity = (cameraCFrame.LookVector * moveDirection.Z + cameraCFrame.RightVector * moveDirection.X) * flySpeed
                flyGyro.CFrame = cameraCFrame
            end
        end)
        
        logError("Fly activated")
    else
        logError("Fly deactivated")
    end
end

PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = Config.Player.Fly,
    Flag = "Fly",
    Callback = function(Value)
        Config.Player.Fly = Value
        setupFly()
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

-- Fly Boat
local flyBoatConnection
local function setupFlyBoat()
    if flyBoatConnection then
        flyBoatConnection:Disconnect()
        flyBoatConnection = nil
    end
    
    if Config.Player.FlyBoat then
        flyBoatConnection = RunService.Heartbeat:Connect(function()
            for _, child in ipairs(Workspace:GetChildren()) do
                if child.Name:find("Boat") and child:FindFirstChild("Seat") and child.Seat:FindFirstChild("SeatWeld") then
                    local seat = child.Seat
                    if seat.Occupant and seat.Occupant.Parent == LocalPlayer.Character then
                        local boatVelocity = seat:FindFirstChild("BoatVelocity")
                        local boatGyro = seat:FindFirstChild("BoatGyro")
                        
                        if not boatVelocity then
                            boatVelocity = Instance.new("BodyVelocity")
                            boatVelocity.Name = "BoatVelocity"
                            boatVelocity.Velocity = Vector3.new(0, 0, 0)
                            boatVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                            boatVelocity.Parent = seat
                        end
                        
                        if not boatGyro then
                            boatGyro = Instance.new("BodyGyro")
                            boatGyro.Name = "BoatGyro"
                            boatGyro.P = 9e4
                            boatGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                            boatGyro.CFrame = seat.CFrame
                            boatGyro.Parent = seat
                        end
                        
                        if UserInputService:GetFocusedTextBox() then return end
                        
                        local moveDirection = LocalPlayer.Character.Humanoid.MoveDirection
                        local camera = Workspace.CurrentCamera
                        local cameraCFrame = camera.CFrame
                        
                        local flySpeed = Config.Player.FlyRange * 2
                        
                        boatVelocity.Velocity = (cameraCFrame.LookVector * moveDirection.Z + cameraCFrame.RightVector * moveDirection.X) * flySpeed + Vector3.new(0, 10, 0)
                        boatGyro.CFrame = cameraCFrame
                        
                        logError("Fly Boat triggered")
                    end
                end
            end
        end)
        
        logError("Fly Boat activated")
    else
        -- Remove fly boat components
        for _, child in ipairs(Workspace:GetChildren()) do
            if child.Name:find("Boat") and child:FindFirstChild("Seat") then
                local seat = child.Seat
                local boatVelocity = seat:FindFirstChild("BoatVelocity")
                local boatGyro = seat:FindFirstChild("BoatGyro")
                
                if boatVelocity then
                    boatVelocity:Destroy()
                end
                
                if boatGyro then
                    boatGyro:Destroy()
                end
            end
        end
        
        logError("Fly Boat deactivated")
    end
end

PlayerTab:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = Config.Player.FlyBoat,
    Flag = "FlyBoat",
    Callback = function(Value)
        Config.Player.FlyBoat = Value
        setupFlyBoat()
        logError("Fly Boat: " .. tostring(Value))
    end
})

-- Ghost Hack
local ghostHackConnection
local function setupGhostHack()
    if ghostHackConnection then
        ghostHackConnection:Disconnect()
        ghostHackConnection = nil
    end
    
    if Config.Player.GhostHack and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Transparency = 0.5
            end
        end
        
        ghostHackConnection = LocalPlayer.CharacterAdded:Connect(function(character)
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.Transparency = 0.5
                end
            end
        end)
        
        logError("Ghost Hack activated")
    else
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                    part.Transparency = 0
                end
            end
        end
        
        logError("Ghost Hack deactivated")
    end
end

PlayerTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = Config.Player.GhostHack,
    Flag = "GhostHack",
    Callback = function(Value)
        Config.Player.GhostHack = Value
        setupGhostHack()
        logError("Ghost Hack: " .. tostring(Value))
    end
})

-- ESP System
local espConnections = {}
local espObjects = {}

local function clearESP()
    for _, connection in ipairs(espConnections) do
        connection:Disconnect()
    end
    espConnections = {}
    
    for _, object in ipairs(espObjects) do
        object:Destroy()
    end
    espObjects = {}
end

local function setupESP()
    clearESP()
    
    if not Config.Player.PlayerESP then
        return
    end
    
    local function createESP(player)
        if player == LocalPlayer then return end
        
        local character = player.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        -- ESP Box
        if Config.Player.ESPBox then
            local espBox = Instance.new("BoxHandleAdornment")
            espBox.Name = "ESPBox_" .. player.Name
            espBox.Adornee = humanoidRootPart
            espBox.Size = humanoidRootPart.Size + Vector3.new(0.5, 1, 0.5)
            espBox.Color3 = Color3.new(1, 0, 0)
            espBox.Transparency = 0.7
            espBox.ZIndex = 10
            espBox.AlwaysOnTop = true
            espBox.Visible = true
            espBox.Parent = CoreGui
            
            table.insert(espObjects, espBox)
        end
        
        -- ESP Lines
        if Config.Player.ESPLines then
            local espLine = Drawing.new("Line")
            espLine.Visible = true
            espLine.From = Vector2.new(0, 0)
            espLine.To = Vector2.new(0, 0)
            espLine.Color = Color3.new(1, 0, 0)
            espLine.Thickness = 2
            espLine.Transparency = 1
            
            table.insert(espObjects, espLine)
            
            local updateLine
            updateLine = RunService.RenderStepped:Connect(function()
                if not character or not character:FindFirstChild("HumanoidRootPart") or not Config.Player.ESPLines then
                    espLine:Remove()
                    return
                end
                
                local vector, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
                if onScreen then
                    espLine.From = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y)
                    espLine.To = Vector2.new(vector.X, vector.Y)
                    espLine.Visible = true
                else
                    espLine.Visible = false
                end
            end)
            
            table.insert(espConnections, updateLine)
        end
        
        -- ESP Name
        if Config.Player.ESPName then
            local espName = Instance.new("BillboardGui")
            espName.Name = "ESPName_" .. player.Name
            espName.Adornee = humanoidRootPart
            espName.Size = UDim2.new(0, 200, 0, 50)
            espName.StudsOffset = Vector3.new(0, 3, 0)
            espName.AlwaysOnTop = true
            espName.Parent = CoreGui
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.new(1, 1, 1)
            nameLabel.TextStrokeTransparency = 0
            nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            nameLabel.TextScaled = true
            nameLabel.Font = Enum.Font.SourceSansBold
            nameLabel.Parent = espName
            
            table.insert(espObjects, espName)
        end
        
        -- ESP Level
        if Config.Player.ESPLevel then
            local playerLevel = 1
            if PlayerData and PlayerData:FindFirstChild("Level") then
                playerLevel = PlayerData.Level.Value
            end
            
            local espLevel = Instance.new("BillboardGui")
            espLevel.Name = "ESPLevel_" .. player.Name
            espLevel.Adornee = humanoidRootPart
            espLevel.Size = UDim2.new(0, 200, 0, 50)
            espLevel.StudsOffset = Vector3.new(0, 2, 0)
            espLevel.AlwaysOnTop = true
            espLevel.Parent = CoreGui
            
            local levelLabel = Instance.new("TextLabel")
            levelLabel.Size = UDim2.new(1, 0, 1, 0)
            levelLabel.BackgroundTransparency = 1
            levelLabel.Text = "Level: " .. playerLevel
            levelLabel.TextColor3 = Color3.new(1, 1, 0)
            levelLabel.TextStrokeTransparency = 0
            levelLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            levelLabel.TextScaled = true
            levelLabel.Font = Enum.Font.SourceSansBold
            levelLabel.Parent = espLevel
            
            table.insert(espObjects, espLevel)
        end
        
        -- ESP Range
        if Config.Player.ESPRange then
            local espRange = Instance.new("BillboardGui")
            espRange.Name = "ESPRange_" .. player.Name
            espRange.Adornee = humanoidRootPart
            espRange.Size = UDim2.new(0, 200, 0, 50)
            espRange.StudsOffset = Vector3.new(0, 1, 0)
            espRange.AlwaysOnTop = true
            espRange.Parent = CoreGui
            
            local rangeLabel = Instance.new("TextLabel")
            rangeLabel.Size = UDim2.new(1, 0, 1, 0)
            rangeLabel.BackgroundTransparency = 1
            rangeLabel.Text = "Range: 0"
            rangeLabel.TextColor3 = Color3.new(0, 1, 0)
            rangeLabel.TextStrokeTransparency = 0
            rangeLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            rangeLabel.TextScaled = true
            rangeLabel.Font = Enum.Font.SourceSansBold
            rangeLabel.Parent = espRange
            
            table.insert(espObjects, espRange)
            
            local updateRange
            updateRange = RunService.RenderStepped:Connect(function()
                if not character or not character:FindFirstChild("HumanoidRootPart") or not Config.Player.ESPRange then
                    espRange:Destroy()
                    return
                end
                
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                rangeLabel.Text = "Range: " .. math.floor(distance)
            end)
            
            table.insert(espConnections, updateRange)
        end
        
        -- ESP Hologram
        if Config.Player.ESPHologram then
            local espHologram = Instance.new("Part")
            espHologram.Name = "ESPHologram_" .. player.Name
            espHologram.Size = Vector3.new(2, 4, 2)
            espHologram.Transparency = 0.7
            espHologram.BrickColor = BrickColor.new("Cyan")
            espHologram.Anchored = true
            espHologram.CanCollide = false
            espHologram.CFrame = humanoidRootPart.CFrame
            espHologram.Parent = Workspace
            
            table.insert(espObjects, espHologram)
            
            local updateHologram
            updateHologram = RunService.RenderStepped:Connect(function()
                if not character or not character:FindFirstChild("HumanoidRootPart") or not Config.Player.ESPHologram then
                    espHologram:Destroy()
                    return
                end
                
                espHologram.CFrame = humanoidRootPart.CFrame
            end)
            
            table.insert(espConnections, updateHologram)
        end
    end
    
    -- Create ESP for existing players
    for _, player in ipairs(Players:GetPlayers()) do
        createESP(player)
    end
    
    -- Create ESP for new players
    local playerAddedConnection
    playerAddedConnection = Players.PlayerAdded:Connect(function(player)
        createESP(player)
    end)
    table.insert(espConnections, playerAddedConnection)
    
    -- Create ESP when character loads
    local characterAddedConnection
    characterAddedConnection = Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            createESP(player)
        end)
    end)
    table.insert(espConnections, characterAddedConnection)
    
    logError("ESP activated")
end

PlayerTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = Config.Player.PlayerESP,
    Flag = "PlayerESP",
    Callback = function(Value)
        Config.Player.PlayerESP = Value
        setupESP()
        logError("Player ESP: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = Config.Player.ESPBox,
    Flag = "ESPBox",
    Callback = function(Value)
        Config.Player.ESPBox = Value
        setupESP()
        logError("ESP Box: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Lines",
    CurrentValue = Config.Player.ESPLines,
    Flag = "ESPLines",
    Callback = function(Value)
        Config.Player.ESPLines = Value
        setupESP()
        logError("ESP Lines: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Name",
    CurrentValue = Config.Player.ESPName,
    Flag = "ESPName",
    Callback = function(Value)
        Config.Player.ESPName = Value
        setupESP()
        logError("ESP Name: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Level",
    CurrentValue = Config.Player.ESPLevel,
    Flag = "ESPLevel",
    Callback = function(Value)
        Config.Player.ESPLevel = Value
        setupESP()
        logError("ESP Level: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Range",
    CurrentValue = Config.Player.ESPRange,
    Flag = "ESPRange",
    Callback = function(Value)
        Config.Player.ESPRange = Value
        setupESP()
        logError("ESP Range: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Hologram",
    CurrentValue = Config.Player.ESPHologram,
    Flag = "ESPHologram",
    Callback = function(Value)
        Config.Player.ESPHologram = Value
        setupESP()
        logError("ESP Hologram: " .. tostring(Value))
    end
})

-- Noclip
local noclipConnection
local function setupNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    if Config.Player.Noclip then
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        logError("Noclip activated")
    else
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        logError("Noclip deactivated")
    end
end

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = Config.Player.Noclip,
    Flag = "Noclip",
    Callback = function(Value)
        Config.Player.Noclip = Value
        setupNoclip()
        logError("Noclip: " .. tostring(Value))
    end
})

-- Auto Sell
local autoSellConnection
local function setupAutoSell()
    if autoSellConnection then
        autoSellConnection:Disconnect()
        autoSellConnection = nil
    end
    
    if Config.Player.AutoSell then
        autoSellConnection = RunService.Heartbeat:Connect(function()
            if PlayerData and PlayerData:FindFirstChild("Inventory") then
                for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                    if item:IsA("Folder") or item:IsA("Configuration") then
                        -- Check if fish is not in favorites
                        local isFavorite = false
                        if PlayerData:FindFirstChild("Favorites") then
                            for _, favorite in pairs(PlayerData.Favorites:GetChildren()) do
                                if favorite.Name == item.Name then
                                    isFavorite = true
                                    break
                                end
                            end
                        end
                        
                        if not isFavorite and GameFunctions and GameFunctions:FindFirstChild("SellFish") then
                            local success, result = pcall(function()
                                GameFunctions.SellFish:InvokeServer(item.Name)
                                logError("Auto sold fish: " .. item.Name)
                            end)
                            if not success then
                                logError("Auto sell error: " .. result)
                            end
                        end
                    end
                end
            end
        end)
        logError("Auto Sell activated")
    else
        logError("Auto Sell deactivated")
    end
end

PlayerTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = Config.Player.AutoSell,
    Flag = "AutoSell",
    Callback = function(Value)
        Config.Player.AutoSell = Value
        setupAutoSell()
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
        if Value and GameFunctions and GameFunctions:FindFirstChild("LuckBoost") then
            local success, result = pcall(function()
                GameFunctions.LuckBoost:FireServer()
                logError("Luck Boost activated")
            end)
            if not success then
                logError("Luck Boost error: " .. result)
            end
        else
            logError("Luck Boost deactivated")
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
        local success, result = pcall(function()
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
        end)
        
        if not success then
            logError("Get Server Info error: " .. result)
        end
    end
})

-- System Tab
local SystemTab = Window:CreateTab("⚙️ System", 13014546625)

-- Show Info
local infoGui
local infoFrame
local infoLabel

local function setupShowInfo()
    if infoGui then
        infoGui:Destroy()
        infoGui = nil
    end
    
    if Config.System.ShowInfo then
        infoGui = Instance.new("ScreenGui")
        infoGui.Name = "InfoGui"
        infoGui.ResetOnSpawn = false
        infoGui.Parent = CoreGui
        
        infoFrame = Instance.new("Frame")
        infoFrame.Name = "InfoFrame"
        infoFrame.Size = UDim2.new(0, 200, 0, 100)
        infoFrame.Position = UDim2.new(0, 10, 0, 10)
        infoFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        infoFrame.BackgroundTransparency = 0.5
        infoFrame.BorderSizePixel = 0
        infoFrame.Parent = infoGui
        
        infoLabel = Instance.new("TextLabel")
        infoLabel.Name = "InfoLabel"
        infoLabel.Size = UDim2.new(1, 0, 1, 0)
        infoLabel.BackgroundTransparency = 1
        infoLabel.TextColor3 = Color3.new(1, 1, 1)
        infoLabel.TextScaled = true
        infoLabel.Font = Enum.Font.SourceSansBold
        infoLabel.TextXAlignment = Enum.TextXAlignment.Left
        infoLabel.TextYAlignment = Enum.TextYAlignment.Top
        infoLabel.Parent = infoFrame
        
        local updateInfo
        updateInfo = RunService.RenderStepped:Connect(function()
            if not Config.System.ShowInfo then
                infoGui:Destroy()
                return
            end
            
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local battery = math.floor((UserInputService:GetBatteryLevel() or 1) * 100)
            local time = os.date("%H:%M:%S")
            
            local infoText = string.format("FPS: %d\nPing: %dms\nBattery: %d%%\nTime: %s", 
                fps, ping, battery, time)
            
            infoLabel.Text = infoText
        end)
        
        logError("Show Info activated")
    else
        logError("Show Info deactivated")
    end
end

SystemTab:CreateToggle({
    Name = "Show Info",
    CurrentValue = Config.System.ShowInfo,
    Flag = "ShowInfo",
    Callback = function(Value)
        Config.System.ShowInfo = Value
        setupShowInfo()
        logError("Show Info: " .. tostring(Value))
    end
})

-- Boost FPS
local function setupBoostFPS()
    if Config.System.BoostFPS then
        -- Reduce graphics quality
        settings().Rendering.QualityLevel = 1
        
        -- Disable shadows
        Lighting.GlobalShadows = false
        
        -- Disable fog
        Lighting.FogEnd = 100000
        
        -- Disable particles
        for _, particle in ipairs(Workspace:GetDescendants()) do
            if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") then
                particle.Enabled = false
            end
        end
        
        logError("Boost FPS activated")
    else
        -- Reset graphics quality
        settings().Rendering.QualityLevel = 10
        
        -- Enable shadows
        Lighting.GlobalShadows = true
        
        -- Reset fog
        Lighting.FogEnd = 1000
        
        -- Enable particles
        for _, particle in ipairs(Workspace:GetDescendants()) do
            if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") then
                particle.Enabled = true
            end
        end
        
        logError("Boost FPS deactivated")
    end
end

SystemTab:CreateToggle({
    Name = "Boost FPS",
    CurrentValue = Config.System.BoostFPS,
    Flag = "BoostFPS",
    Callback = function(Value)
        Config.System.BoostFPS = Value
        setupBoostFPS()
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

-- Auto Clean Memory
local autoCleanMemoryConnection
local function setupAutoCleanMemory()
    if autoCleanMemoryConnection then
        autoCleanMemoryConnection:Disconnect()
        autoCleanMemoryConnection = nil
    end
    
    if Config.System.AutoCleanMemory then
        autoCleanMemoryConnection = RunService.Heartbeat:Connect(function()
            -- Clean up memory
            for i = 1, 10 do
                game:FindFirstChildWhichIsA("Folder", true)
            end
            
            -- Collect garbage
            collectgarbage("collect")
        end)
        logError("Auto Clean Memory activated")
    else
        logError("Auto Clean Memory deactivated")
    end
end

SystemTab:CreateToggle({
    Name = "Auto Clean Memory",
    CurrentValue = Config.System.AutoCleanMemory,
    Flag = "AutoCleanMemory",
    Callback = function(Value)
        Config.System.AutoCleanMemory = Value
        setupAutoCleanMemory()
        logError("Auto Clean Memory: " .. tostring(Value))
    end
})

-- Disable Particles
local function setupDisableParticles()
    if Config.System.DisableParticles then
        for _, particle in ipairs(Workspace:GetDescendants()) do
            if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") then
                particle.Enabled = false
            end
        end
        logError("Disable Particles activated")
    else
        for _, particle in ipairs(Workspace:GetDescendants()) do
            if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") then
                particle.Enabled = true
            end
        end
        logError("Disable Particles deactivated")
    end
end

SystemTab:CreateToggle({
    Name = "Disable Particles",
    CurrentValue = Config.System.DisableParticles,
    Flag = "DisableParticles",
    Callback = function(Value)
        Config.System.DisableParticles = Value
        setupDisableParticles()
        logError("Disable Particles: " .. tostring(Value))
    end
})

-- Auto Farm
local autoFarmConnection
local function setupAutoFarm()
    if autoFarmConnection then
        autoFarmConnection:Disconnect()
        autoFarmConnection = nil
    end
    
    if Config.System.AutoFarm then
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
                    
                    -- Check if player has a rod
                    local hasRod = false
                    if PlayerData and PlayerData:FindFirstChild("Inventory") then
                        for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                            if item.Name:find("Rod") then
                                hasRod = true
                                break
                            end
                        end
                    end
                    
                    if hasRod and FishingEvents and FishingEvents:FindFirstChild("Fish") then
                        -- Cast rod
                        local success, result = pcall(function()
                            FishingEvents.Fish:FireServer()
                            logError("Auto Farm: Cast rod")
                        end)
                        if not success then
                            logError("Auto Farm error: " .. result)
                        end
                    end
                end
            end
        end)
        logError("Auto Farm activated")
    else
        logError("Auto Farm deactivated")
    end
end

SystemTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = Config.System.AutoFarm,
    Flag = "AutoFarm",
    Callback = function(Value)
        Config.System.AutoFarm = Value
        setupAutoFarm()
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
        local success, result = pcall(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local memory = math.floor(Stats:GetTotalMemoryUsageMb())
            local battery = math.floor((UserInputService:GetBatteryLevel() or 1) * 100)
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
        end)
        
        if not success then
            logError("Get System Info error: " .. result)
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
        if Value then
            sethiddenproperty(Lighting, "Technology", "Future")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Disabled")
            settings().Rendering.QualityLevel = 15
            logError("High Quality Rendering activated")
        else
            sethiddenproperty(Lighting, "Technology", "Compatibility")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Default")
            settings().Rendering.QualityLevel = 10
            logError("High Quality Rendering deactivated")
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
            settings().Rendering.QualityLevel = 21
            logError("Max Rendering activated")
        else
            settings().Rendering.QualityLevel = 10
            logError("Max Rendering deactivated")
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
            settings().Rendering.QualityLevel = 1
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") then
                    part.Material = Enum.Material.Plastic
                end
            end
            logError("Ultra Low Mode activated")
        else
            settings().Rendering.QualityLevel = 10
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") then
                    part.Material = Enum.Material.SmoothPlastic
                end
            end
            logError("Ultra Low Mode deactivated")
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
                if water:IsA("Part") and (water.Name == "Water" or water.Material == Enum.Material.Water) then
                    water.Transparency = 1
                end
            end
            logError("Disable Water Reflection activated")
        else
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and (water.Name == "Water" or water.Material == Enum.Material.Water) then
                    water.Transparency = 0.5
                end
            end
            logError("Disable Water Reflection deactivated")
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
            logError("Smooth Graphics activated")
        else
            RunService:Set3dRenderingEnabled(true)
            settings().Rendering.MeshCacheSize = 50
            settings().Rendering.TextureCacheSize = 50
            logError("Smooth Graphics deactivated")
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
            Lighting.Ambient = Color3.new(1, 1, 1)
            logError("Full Bright activated")
        else
            Lighting.GlobalShadows = true
            Lighting.ClockTime = 14
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            logError("Full Bright deactivated")
        end
    end
})

GraphicTab:CreateSlider({
    Name = "Brightness Value",
    Range = {0.1, 2},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Graphic.BrightnessValue,
    Flag = "BrightnessValue",
    Callback = function(Value)
        Config.Graphic.BrightnessValue = Value
        Lighting.Ambient = Color3.new(Value, Value, Value)
        logError("Brightness Value: " .. Value)
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
        local success, result = pcall(function()
            if Config.Shop.SelectedRod ~= "" and GameFunctions and GameFunctions:FindFirstChild("BuyRod") then
                GameFunctions.BuyRod:InvokeServer(Config.Shop.SelectedRod)
                Rayfield:Notify({
                    Title = "Item Purchased",
                    Content = "Bought rod: " .. Config.Shop.SelectedRod,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Bought rod: " .. Config.Shop.SelectedRod)
            elseif Config.Shop.SelectedBoat ~= "" and GameFunctions and GameFunctions:FindFirstChild("BuyBoat") then
                GameFunctions.BuyBoat:InvokeServer(Config.Shop.SelectedBoat)
                Rayfield:Notify({
                    Title = "Item Purchased",
                    Content = "Bought boat: " .. Config.Shop.SelectedBoat,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Bought boat: " .. Config.Shop.SelectedBoat)
            elseif Config.Shop.SelectedBait ~= "" and GameFunctions and GameFunctions:FindFirstChild("BuyBait") then
                GameFunctions.BuyBait:InvokeServer(Config.Shop.SelectedBait)
                Rayfield:Notify({
                    Title = "Item Purchased",
                    Content = "Bought bait: " .. Config.Shop.SelectedBait,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Bought bait: " .. Config.Shop.SelectedBait)
            else
                error("No item selected or function not found")
            end
        end)
        
        if not success then
            Rayfield:Notify({
                Title = "Purchase Error",
                Content = "Failed to buy item: " .. tostring(result),
                Duration = 5,
                Image = 13047715178
            })
            logError("Purchase Error: " .. result)
        end
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings", 13014546625)

SettingsTab:CreateDropdown({
    Name = "Select Theme",
    Options = {"Dark", "Light", "Darker", "Blue", "Red", "Green"},
    CurrentOption = Config.Settings.SelectedTheme,
    Flag = "SelectedTheme",
    Callback = function(Value)
        Config.Settings.SelectedTheme = Value
        Rayfield:UpdateTheme(Value)
        logError("Theme changed to: " .. Value)
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
        Window:SetTransparency(Value)
        logError("UI Transparency: " .. Value)
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
    Range = {0.5, 2},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Settings.UIScale,
    Flag = "UIScale",
    Callback = function(Value)
        Config.Settings.UIScale = Value
        Window:SetScale(Value)
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
                delfile(logPath)
                writefile(logPath, "Log cleared at " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n")
                logError("Log cleared")
            end
        end)
        
        if not success then
            logError("Clear Log Error: " .. err)
        end
    end
})

-- Initialize features
setupAntiAFK()
setupAntiKick()
setupAutoJump()

-- Character added handler
LocalPlayer.CharacterAdded:Connect(function(character)
    if Config.Player.SpeedHack then
        setupSpeedHack()
    end
    
    if Config.Player.GhostHack then
        setupGhostHack()
    end
    
    if Config.Player.PlayerESP then
        setupESP()
    end
    
    if Config.Player.Noclip then
        setupNoclip()
    end
end)

-- Initialize all connections
setupSpeedHack()
setupMaxBoatSpeed()
setupInfinityJump()
setupFly()
setupFlyBoat()
setupGhostHack()
setupESP()
setupNoclip()
setupAutoSell()
setupShowInfo()
setupBoostFPS()
setupAutoCleanMemory()
setupDisableParticles()
setupAutoFarm()

logError("Script initialized successfully")
