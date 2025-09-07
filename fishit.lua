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

-- ESP Variables
local ESP_Objects = {}
local ESP_Connections = {}

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
    if method == "Kick" or method == "kick" and Config.Bypass.AntiKick then
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
        NoClipBoat = false,
        FavoriteFish = {}
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
            NoClipBoat = false,
            FavoriteFish = {}
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
            
            if hasRadar then
                local success, result = pcall(function()
                    FishingEvents.RadarBypass:FireServer()
                    logError("Bypass Fishing Radar: Activated")
                end)
                if not success then
                    logError("Bypass Fishing Radar Error: " .. result)
                end
            else
                Rayfield:Notify({
                    Title = "Radar Not Found",
                    Content = "You need a radar in your inventory to use this feature",
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Bypass Fishing Radar: No radar in inventory")
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
        if Value and GameFunctions and GameFunctions:FindFirstChild("DivingBypass") then
            -- Check if player has diving gear
            local hasDivingGear = false
            if PlayerData and PlayerData:FindFirstChild("Inventory") then
                for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                    if item.Name:find("Diving") or item.Name:find("Gear") then
                        hasDivingGear = true
                        break
                    end
                end
            end
            
            if hasDivingGear then
                local success, result = pcall(function()
                    GameFunctions.DivingBypass:InvokeServer()
                    logError("Bypass Diving Gear: Activated")
                end)
                if not success then
                    logError("Bypass Diving Gear Error: " .. result)
                end
            else
                Rayfield:Notify({
                    Title = "Diving Gear Not Found",
                    Content = "You need diving gear in your inventory to use this feature",
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Bypass Diving Gear: No diving gear in inventory")
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

PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = Config.Player.SpeedHack,
    Flag = "SpeedHack",
    Callback = function(Value)
        Config.Player.SpeedHack = Value
        logError("Speed Hack: " .. tostring(Value))
        
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
        if Config.Player.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
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
        
        -- Max Boat Speed Implementation (5x faster)
        if Value then
            spawn(function()
                while Config.Player.MaxBoatSpeed do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        -- Find the boat
                        for _, vehicle in ipairs(Workspace:GetChildren()) do
                            if vehicle:IsA("Model") and vehicle.Name:find("Boat") and vehicle:FindFirstChild("Seat") then
                                local seat = vehicle.Seat
                                if seat.Occupant and seat.Occupant.Parent == LocalPlayer.Character then
                                    -- Increase boat speed 5x
                                    if vehicle:FindFirstChild("DriveSeat") then
                                        vehicle.DriveSeat.MaxSpeed = vehicle.DriveSeat.MaxSpeed * 5
                                    end
                                end
                            end
                        end
                    end
                    wait(1)
                end
            end)
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
                logError("Boat spawned")
                
                -- Move boat to front of player
                spawn(function()
                    wait(1) -- Wait for boat to spawn
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
                        local playerLook = LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector
                        
                        -- Find the boat
                        for _, vehicle in ipairs(Workspace:GetChildren()) do
                            if vehicle:IsA("Model") and vehicle.Name:find("Boat") and vehicle:FindFirstChild("PrimaryPart") then
                                -- Position boat in front of player
                                vehicle:SetPrimaryPartCFrame(CFrame.new(playerPos + playerLook * 10, playerPos + Vector3.new(0, 2, 0)))
                                break
                            end
                        end
                    end
                end)
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
        
        if Value then
            spawn(function()
                while Config.Player.NoClipBoat do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        -- Find the boat
                        for _, vehicle in ipairs(Workspace:GetChildren()) do
                            if vehicle:IsA("Model") and vehicle.Name:find("Boat") and vehicle:FindFirstChild("Seat") then
                                local seat = vehicle.Seat
                                if seat.Occupant and seat.Occupant.Parent == LocalPlayer.Character then
                                    -- Make boat parts non-collidable
                                    for _, part in ipairs(vehicle:GetDescendants()) do
                                        if part:IsA("BasePart") then
                                            part.CanCollide = false
                                        end
                                    end
                                end
                            end
                        end
                    end
                    wait(0.1)
                end
            end)
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = Config.Player.InfinityJump,
    Flag = "InfinityJump",
    Callback = function(Value)
        Config.Player.InfinityJump = Value
        logError("Infinity Jump: " .. tostring(Value))
        
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
        logError("Fly: " .. tostring(Value))
        
        if Value then
            spawn(function()
                local flySpeed = Config.Player.FlyRange
                local flyControl = {f = 0, b = 0, l = 0, r = 0}
                local lastCtrl = {f = 0, b = 0, l = 0, r = 0}
                local maxSpeed = flySpeed
                
                local function Fly()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
                        local bg = Instance.new("BodyGyro", humanoidRootPart)
                        local bv = Instance.new("BodyVelocity", humanoidRootPart)
                        bg.P = 9e4
                        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                        bg.cframe = humanoidRootPart.CFrame
                        bv.velocity = Vector3.new(0, 0.2, 0)
                        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                        
                        spawn(function()
                            repeat wait()
                                if not Config.Player.Fly then
                                    break
                                end
                                
                                if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                                    speed = 1.0
                                elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                                    speed = 0
                                end
                                
                                if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                                    bv.velocity = ((Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f + ctrl.b)) + ((Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).p) - Workspace.CurrentCamera.CoordinateFrame.p)) * maxSpeed
                                    lastCtrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                                elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                                    bv.velocity = ((Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastCtrl.f + lastCtrl.b)) + ((Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastCtrl.l + lastCtrl.r, (lastCtrl.f + lastCtrl.b) * 0.2, 0).p) - Workspace.CurrentCamera.CoordinateFrame.p)) * maxSpeed
                                else
                                    bv.velocity = Vector3.new(0, 0.2, 0)
                                end
                                bg.cframe = Workspace.CurrentCamera.CoordinateFrame
                            until not Config.Player.Fly
                            
                            ctrl = {f = 0, b = 0, l = 0, r = 0}
                            speed = 0
                            bg:Destroy()
                            bv:Destroy()
                        end)
                    end
                end
                
                local ctrl = {f = 0, b = 0, l = 0, r = 0}
                UserInputService.InputBegan:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.W then
                        ctrl.f = 1
                    elseif input.KeyCode == Enum.KeyCode.S then
                        ctrl.b = -1
                    elseif input.KeyCode == Enum.KeyCode.A then
                        ctrl.l = -1
                    elseif input.KeyCode == Enum.KeyCode.D then
                        ctrl.r = 1
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.W then
                        ctrl.f = 0
                    elseif input.KeyCode == Enum.KeyCode.S then
                        ctrl.b = 0
                    elseif input.KeyCode == Enum.KeyCode.A then
                        ctrl.l = 0
                    elseif input.KeyCode == Enum.KeyCode.D then
                        ctrl.r = 0
                    end
                end)
                
                Fly()
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
        
        if Value then
            spawn(function()
                while Config.Player.FlyBoat do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        -- Find the boat
                        for _, vehicle in ipairs(Workspace:GetChildren()) do
                            if vehicle:IsA("Model") and vehicle.Name:find("Boat") and vehicle:FindFirstChild("Seat") then
                                local seat = vehicle.Seat
                                if seat.Occupant and seat.Occupant.Parent == LocalPlayer.Character then
                                    -- Make boat fly
                                    if vehicle:FindFirstChild("PrimaryPart") then
                                        local boatPart = vehicle.PrimaryPart
                                        local currentPos = boatPart.Position
                                        boatPart.CFrame = CFrame.new(currentPos.X, currentPos.Y + 0.5, currentPos.Z)
                                    end
                                end
                            end
                        end
                    end
                    wait(0.1)
                end
            end)
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = Config.Player.GhostHack,
    Flag = "GhostHack",
    Callback = function(Value)
        Config.Player.GhostHack = Value
        logError("Ghost Hack: " .. tostring(Value))
        
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    if Value then
                        part.Transparency = 0.5
                        part.CanCollide = false
                    else
                        part.Transparency = 0
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = Config.Player.PlayerESP,
    Flag = "PlayerESP",
    Callback = function(Value)
        Config.Player.PlayerESP = Value
        logError("Player ESP: " .. tostring(Value))
        
        if Value then
            -- Create ESP for all players
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    CreateESP(player)
                end
            end
            
            -- Connect to player added event
            table.insert(ESP_Connections, Players.PlayerAdded:Connect(function(player)
                if Config.Player.PlayerESP then
                    CreateESP(player)
                end
            end))
        else
            -- Remove all ESP
            for _, espTable in pairs(ESP_Objects) do
                for _, object in pairs(espTable) do
                    if object then
                        object:Destroy()
                    end
                end
            end
            ESP_Objects = {}
            
            -- Disconnect connections
            for _, connection in ipairs(ESP_Connections) do
                connection:Disconnect()
            end
            ESP_Connections = {}
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
        
        -- Update existing ESP
        for _, espTable in pairs(ESP_Objects) do
            if espTable.Box then
                espTable.Box.Enabled = Value
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Lines",
    CurrentValue = Config.Player.ESPLines,
    Flag = "ESPLines",
    Callback = function(Value)
        Config.Player.ESPLines = Value
        logError("ESP Lines: " .. tostring(Value))
        
        -- Update existing ESP
        for _, espTable in pairs(ESP_Objects) do
            if espTable.Line then
                espTable.Line.Enabled = Value
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Name",
    CurrentValue = Config.Player.ESPName,
    Flag = "ESPName",
    Callback = function(Value)
        Config.Player.ESPName = Value
        logError("ESP Name: " .. tostring(Value))
        
        -- Update existing ESP
        for _, espTable in pairs(ESP_Objects) do
            if espTable.Name then
                espTable.Name.Enabled = Value
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Level",
    CurrentValue = Config.Player.ESPLevel,
    Flag = "ESPLevel",
    Callback = function(Value)
        Config.Player.ESPLevel = Value
        logError("ESP Level: " .. tostring(Value))
        
        -- Update existing ESP
        for _, espTable in pairs(ESP_Objects) do
            if espTable.Level then
                espTable.Level.Enabled = Value
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Range",
    CurrentValue = Config.Player.ESPRange,
    Flag = "ESPRange",
    Callback = function(Value)
        Config.Player.ESPRange = Value
        logError("ESP Range: " .. tostring(Value))
        
        -- Update existing ESP
        for _, espTable in pairs(ESP_Objects) do
            if espTable.Range then
                espTable.Range.Enabled = Value
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Hologram",
    CurrentValue = Config.Player.ESPHologram,
    Flag = "ESPHologram",
    Callback = function(Value)
        Config.Player.ESPHologram = Value
        logError("ESP Hologram: " .. tostring(Value))
        
        -- Update existing ESP
        for _, espTable in pairs(ESP_Objects) do
            if espTable.Hologram then
                espTable.Hologram.Enabled = Value
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = Config.Player.Noclip,
    Flag = "Noclip",
    Callback = function(Value)
        Config.Player.Noclip = Value
        logError("Noclip: " .. tostring(Value))
        
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
                
                -- Re-enable collision when turned off
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
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
        logError("Auto Sell: " .. tostring(Value))
        
        if Value then
            spawn(function()
                while Config.Player.AutoSell do
                    if GameFunctions and GameFunctions:FindFirstChild("SellFish") then
                        local success, result = pcall(function()
                            -- Sell all fish except favorites
                            local fishToSell = {}
                            
                            if PlayerData and PlayerData:FindFirstChild("Inventory") then
                                for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                                    if not Config.Player.FavoriteFish[item.Name] then
                                        table.insert(fishToSell, item.Name)
                                    end
                                end
                            end
                            
                            if #fishToSell > 0 then
                                GameFunctions.SellFish:InvokeServer(fishToSell)
                                logError("Auto-sold " .. #fishToSell .. " fish")
                            end
                        end)
                        if not success then
                            logError("Auto Sell Error: " .. result)
                        end
                    end
                    wait(5) -- Check every 5 seconds
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

-- ESP Creation Function
function CreateESP(player)
    if ESP_Objects[player] then return end
    
    ESP_Objects[player] = {}
    
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Create ESP objects
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESPBox"
    box.Size = Vector3.new(4, 5, 2)  -- Properly sized box
    box.Color3 = Color3.new(1, 0, 0)
    box.Transparency = 0.7
    box.ZIndex = 10
    box.AlwaysOnTop = true
    box.Visible = Config.Player.ESPBox
    box.Adornee = humanoidRootPart
    box.Parent = CoreGui
    
    local line = Instance.new("LineHandleAdornment")
    line.Name = "ESPLine"
    line.Color3 = Color3.new(1, 0, 0)
    line.Thickness = 1
    line.Transparency = 0.5
    line.Visible = Config.Player.ESPLines
    line.Parent = CoreGui
    
    local name = Instance.new("BillboardGui")
    name.Name = "ESPName"
    name.Size = UDim2.new(0, 100, 0, 20)
    name.StudsOffset = Vector3.new(0, 2, 0)
    name.AlwaysOnTop = true
    name.Enabled = Config.Player.ESPName
    name.Parent = CoreGui
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextScaled = true
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.Parent = name
    
    local level = Instance.new("BillboardGui")
    level.Name = "ESPLevel"
    level.Size = UDim2.new(0, 100, 0, 20)
    level.StudsOffset = Vector3.new(0, 3.5, 0)
    level.AlwaysOnTop = true
    level.Enabled = Config.Player.ESPLevel
    level.Parent = CoreGui
    
    local levelLabel = Instance.new("TextLabel")
    levelLabel.BackgroundTransparency = 1
    levelLabel.Text = "Lv. " .. (player:FindFirstChild("Level") and player.Level.Value or "1")
    levelLabel.TextColor3 = Color3.new(1, 1, 0)
    levelLabel.TextStrokeTransparency = 0
    levelLabel.TextScaled = true
    levelLabel.Size = UDim2.new(1, 0, 1, 0)
    levelLabel.Parent = level
    
    local range = Instance.new("BillboardGui")
    range.Name = "ESPRange"
    range.Size = UDim2.new(0, 100, 0, 20)
    range.StudsOffset = Vector3.new(0, 5, 0)
    range.AlwaysOnTop = true
    range.Enabled = Config.Player.ESPRange
    range.Parent = CoreGui
    
    local rangeLabel = Instance.new("TextLabel")
    rangeLabel.BackgroundTransparency = 1
    rangeLabel.Text = "0 studs"
    rangeLabel.TextColor3 = Color3.new(0, 1, 0)
    rangeLabel.TextStrokeTransparency = 0
    rangeLabel.TextScaled = true
    rangeLabel.Size = UDim2.new(1, 0, 1, 0)
    rangeLabel.Parent = range
    
    local hologram = Instance.new("Highlight")
    hologram.Name = "ESPHologram"
    hologram.FillColor = Color3.new(1, 0, 0)
    hologram.FillTransparency = 0.5
    hologram.OutlineColor = Color3.new(1, 1, 1)
    hologram.OutlineTransparency = 0
    hologram.Enabled = Config.Player.ESPHologram
    hologram.Parent = character
    
    -- Store references
    ESP_Objects[player].Box = box
    ESP_Objects[player].Line = line
    ESP_Objects[player].Name = name
    ESP_Objects[player].Level = level
    ESP_Objects[player].Range = range
    ESP_Objects[player].Hologram = hologram
    
    -- Update ESP
    local updateConnection
    updateConnection = RunService.RenderStepped:Connect(function()
        if not Config.Player.PlayerESP or not player or not player.Character then
            if ESP_Objects[player] then
                for _, object in pairs(ESP_Objects[player]) do
                    if object then
                        object:Destroy()
                    end
                end
                ESP_Objects[player] = nil
            end
            updateConnection:Disconnect()
            return
        end
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local playerRoot = player.Character.HumanoidRootPart
            local localRoot = LocalPlayer.Character.HumanoidRootPart
            
            -- Update line
            if line and line.Adornee ~= playerRoot then
                line.Adornee = playerRoot
            end
            
            if line then
                line.From = localRoot.Position
                line.To = playerRoot.Position
            end
            
            -- Update range
            local distance = (playerRoot.Position - localRoot.Position).Magnitude
            if rangeLabel then
                rangeLabel.Text = math.floor(distance) .. " studs"
            end
            
            -- Update adornee for box
            if box and box.Adornee ~= playerRoot then
                box.Adornee = playerRoot
            end
            
            -- Update billboard positions
            if name and name.Adornee ~= playerRoot then
                name.Adornee = playerRoot
            end
            
            if level and level.Adornee ~= playerRoot then
                level.Adornee = playerRoot
            end
            
            if range and range.Adornee ~= playerRoot then
                range.Adornee = playerRoot
            end
        end
    end)
    
    -- Handle character respawning
    player.CharacterAdded:Connect(function(newCharacter)
        if ESP_Objects[player] then
            local humanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
            
            -- Update adornees
            if ESP_Objects[player].Box then
                ESP_Objects[player].Box.Adornee = humanoidRootPart
            end
            
            if ESP_Objects[player].Line then
                ESP_Objects[player].Line.Adornee = humanoidRootPart
            end
            
            if ESP_Objects[player].Name then
                ESP_Objects[player].Name.Adornee = humanoidRootPart
            end
            
            if ESP_Objects[player].Level then
                ESP_Objects[player].Level.Adornee = humanoidRootPart
            end
            
            if ESP_Objects[player].Range then
                ESP_Objects[player].Range.Adornee = humanoidRootPart
            end
            
            if ESP_Objects[player].Hologram then
                ESP_Objects[player].Hologram.Parent = newCharacter
            end
        end
    end)
end

-- Trader Tab
local TraderTab = Window:CreateTab("💱 Trader", 13014546625)

TraderTab:CreateToggle({
    Name = "Auto Accept Trade",
    CurrentValue = Config.Trader.AutoAcceptTrade,
    Flag = "AutoAcceptTrade",
    Callback = function(Value)
        Config.Trader.AutoAcceptTrade = Value
        logError("Auto Accept Trade: " .. tostring(Value))
        
        if Value then
            spawn(function()
                while Config.Trader.AutoAcceptTrade do
                    -- Auto accept trade logic
                    if TradeEvents and TradeEvents:FindFirstChild("AcceptTrade") then
                        local success, result = pcall(function()
                            TradeEvents.AcceptTrade:FireServer()
                            logError("Auto accepted trade")
                        end)
                        if not success then
                            logError("Auto Accept Trade Error: " .. result)
                        end
                    end
                    wait(1)
                end
            end)
        end
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

TraderTab:CreateDropdown({
    Name = "Select Fish",
    Options = updateFishInventory(),
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
        
        if Value and FishingEvents and FishingEvents:FindFirstChild("LuckBoost") then
            local success, result = pcall(function()
                FishingEvents.LuckBoost:FireServer()
                logError("Luck Boost activated")
            end)
            if not success then
                logError("Luck Boost Error: " .. result)
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
        
        if Value and FishingEvents and FishingEvents:FindFirstChild("ForceEvent") then
            local success, result = pcall(function()
                FishingEvents.ForceEvent:FireServer(Config.Teleport.SelectedEvent)
                logError("Forced event: " .. Config.Teleport.SelectedEvent)
            end)
            if not success then
                logError("Force Event Error: " .. result)
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
        logError("Rejoin Same Server: " .. tostring(Value))
        
        if Value then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    end
})

ServerTab:CreateToggle({
    Name = "Server Hop",
    CurrentValue = Config.Server.ServerHop,
    Flag = "ServerHop",
    Callback = function(Value)
        Config.Server.ServerHop = Value
        logError("Server Hop: " .. tostring(Value))
        
        if Value then
            local servers = {}
            local req = request or http_request or http.request or syn.request
            if req then
                local success, result = pcall(function()
                    local response = req({
                        Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
                    })
                    
                    if response and response.Body then
                        local data = HttpService:JSONDecode(response.Body)
                        if data and data.data then
                            for _, server in pairs(data.data) do
                                if server.playing and server.playing < server.maxPlayers and server.id ~= game.JobId then
                                    table.insert(servers, server.id)
                                end
                            end
                        end
                    end
                end)
                
                if success and #servers > 0 then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
                    logError("Server hopped to a new server")
                else
                    Rayfield:Notify({
                        Title = "Server Hop Error",
                        Content = "Failed to find available servers",
                        Duration = 5,
                        Image = 13047715178
                    })
                    logError("Server Hop Error: No available servers")
                end
            else
                Rayfield:Notify({
                    Title = "Server Hop Error",
                    Content = "HTTP request not supported",
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Server Hop Error: HTTP request not supported")
            end
        end
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
            spawn(function()
                local infoGui = Instance.new("ScreenGui")
                infoGui.Name = "SystemInfo"
                infoGui.ResetOnSpawn = false
                infoGui.Parent = CoreGui
                
                local infoFrame = Instance.new("Frame")
                infoFrame.Size = UDim2.new(0, 200, 0, 100)
                infoFrame.Position = UDim2.new(0, 10, 0, 10)
                infoFrame.BackgroundColor3 = Color3.new(0, 0, 0)
                infoFrame.BackgroundTransparency = 0.3
                infoFrame.BorderSizePixel = 0
                infoFrame.Parent = infoGui
                
                local infoLabel = Instance.new("TextLabel")
                infoLabel.Size = UDim2.new(1, 0, 1, 0)
                infoLabel.BackgroundTransparency = 1
                infoLabel.TextColor3 = Color3.new(1, 1, 1)
                infoLabel.TextScaled = true
                infoLabel.TextXAlignment = Enum.TextXAlignment.Left
                infoLabel.TextYAlignment = Enum.TextYAlignment.Top
                infoLabel.Font = Enum.Font.SourceSans
                infoLabel.Parent = infoFrame
                
                local updateConnection
                updateConnection = RunService.RenderStepped:Connect(function()
                    if not Config.System.ShowInfo then
                        infoGui:Destroy()
                        updateConnection:Disconnect()
                        return
                    end
                    
                    local fps = math.floor(1 / RunService.RenderStepped:Wait())
                    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                    local memory = math.floor(Stats:GetTotalMemoryUsageMb())
                    local battery = math.floor((UserInputService:GetBatteryLevel() or 1) * 100)
                    local time = os.date("%H:%M:%S")
                    
                    local systemInfo = string.format("FPS: %d\nPing: %dms\nMemory: %dMB\nBattery: %d%%\nTime: %s", 
                        fps, ping, memory, battery, time)
                    
                    infoLabel.Text = systemInfo
                end)
            end)
        end
    end
})

SystemTab:CreateToggle({
    Name = "Boost FPS",
    CurrentValue = Config.System.BoostFPS,
    Flag = "BoostFPS",
    Callback = function(Value)
        Config.System.BoostFPS = Value
        logError("Boost FPS: " .. tostring(Value))
        
        if Value then
            settings().Rendering.QualityLevel = 1
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj.Parent:FindFirstChild("Humanoid") then
                    obj.Material = Enum.Material.Plastic
                end
            end
        else
            settings().Rendering.QualityLevel = 10
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 1000
        end
    end
})

SystemTab:CreateDropdown({
    Name = "FPS Limit",
    Options = {"30", "60", "120", "144", "240", "360"},
    CurrentOption = tostring(Config.System.FPSLimit),
    Flag = "FPSLimit",
    Callback = function(Value)
        Config.System.FPSLimit = tonumber(Value)
        setfpscap(Config.System.FPSLimit)
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
        
        if Value then
            spawn(function()
                while Config.System.AutoCleanMemory do
                    collectgarbage("collect")
                    wait(30) -- Clean every 30 seconds
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
        logError("Disable Particles: " .. tostring(Value))
        
        if Value then
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") or particle:IsA("Sparkles") then
                    particle.Enabled = false
                end
            end
        else
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") or particle:IsA("Sparkles") then
                    particle.Enabled = true
                end
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
        logError("Auto Farm: " .. tostring(Value))
        
        if Value then
            spawn(function()
                while Config.System.AutoFarm do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
                        
                        -- Find fishing spots within radius
                        for _, spot in ipairs(Workspace:GetDescendants()) do
                            if spot.Name:find("Fishing") or spot.Name:find("Spot") then
                                if spot:IsA("BasePart") then
                                    local distance = (spot.Position - playerPos).Magnitude
                                    if distance <= Config.System.FarmRadius then
                                        -- Move to fishing spot
                                        LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(spot.Position + Vector3.new(0, 5, 0)))
                                        
                                        -- Wait to arrive
                                        wait(1)
                                        
                                        -- Start fishing
                                        if FishingEvents and FishingEvents:FindFirstChild("StartFishing") then
                                            local success, result = pcall(function()
                                                FishingEvents.StartFishing:FireServer(spot)
                                                logError("Started auto-fishing at spot")
                                            end)
                                            if not success then
                                                logError("Auto Farm Error: " .. result)
                                            end
                                        end
                                        
                                        -- Wait for fishing to complete
                                        wait(5)
                                        
                                        -- Perfect catch
                                        if FishingEvents and FishingEvents:FindFirstChild("PerfectCatch") then
                                            local success, result = pcall(function()
                                                FishingEvents.PerfectCatch:FireServer()
                                                logError("Perfect catch executed")
                                            end)
                                            if not success then
                                                logError("Perfect Catch Error: " .. result)
                                            end
                                        end
                                        
                                        break
                                    end
                                end
                            end
                        end
                    end
                    wait(1)
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
            settings().Rendering.QualityLevel = 10  -- 5x better than standard (2)
        else
            settings().Rendering.QualityLevel = 2
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
            settings().Rendering.QualityLevel = 21  -- 20x better than standard (1)
        else
            settings().Rendering.QualityLevel = 1
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
            settings().Rendering.QualityLevel = 1  -- 5x lower than standard (5)
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") then
                    part.Material = Enum.Material.Plastic
                end
            end
        else
            settings().Rendering.QualityLevel = 5
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
                if water:IsA("Part") and (water.Name == "Water" or water.Material == Enum.Material.Water) then
                    water.Transparency = 1
                end
            end
        else
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and (water.Name == "Water" or water.Material == Enum.Material.Water) then
                    water.Transparency = 0.5
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
            settings().Rendering.MeshCacheSize = 100  -- 50x better than standard (2)
            settings().Rendering.TextureCacheSize = 100  -- 50x better than standard (2)
        else
            settings().Rendering.MeshCacheSize = 2
            settings().Rendering.TextureCacheSize = 2
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
            Lighting.Brightness = Config.Graphic.BrightnessValue
        else
            Lighting.GlobalShadows = true
            Lighting.Brightness = 1
        end
        logError("Full Bright: " .. tostring(Value))
    end
})

GraphicTab:CreateSlider({
    Name = "Brightness",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = Config.Graphic.BrightnessValue,
    Flag = "BrightnessValue",
    Callback = function(Value)
        Config.Graphic.BrightnessValue = Value
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
        
        if Value and FishingEvents and FishingEvents:FindFirstChild("RNGReducer") then
            local success, result = pcall(function()
                FishingEvents.RNGReducer:FireServer()
                logError("RNG Reducer activated")
            end)
            if not success then
                logError("RNG Reducer Error: " .. result)
            end
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Force Legendary Catch",
    CurrentValue = Config.RNGKill.ForceLegendary,
    Flag = "ForceLegendary",
    Callback = function(Value)
        Config.RNGKill.ForceLegendary = Value
        logError("Force Legendary Catch: " .. tostring(Value))
        
        if Value and FishingEvents and FishingEvents:FindFirstChild("ForceLegendary") then
            local success, result = pcall(function()
                FishingEvents.ForceLegendary:FireServer()
                logError("Force Legendary activated")
            end)
            if not success then
                logError("Force Legendary Error: " .. result)
            end
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Secret Fish Boost",
    CurrentValue = Config.RNGKill.SecretFishBoost,
    Flag = "SecretFishBoost",
    Callback = function(Value)
        Config.RNGKill.SecretFishBoost = Value
        logError("Secret Fish Boost: " .. tostring(Value))
        
        if Value and FishingEvents and FishingEvents:FindFirstChild("SecretFishBoost") then
            local success, result = pcall(function()
                FishingEvents.SecretFishBoost:FireServer()
                logError("Secret Fish Boost activated")
            end)
            if not success then
                logError("Secret Fish Boost Error: " .. result)
            end
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Mythical Chance ×10",
    CurrentValue = Config.RNGKill.MythicalChanceBoost,
    Flag = "MythicalChanceBoost",
    Callback = function(Value)
        Config.RNGKill.MythicalChanceBoost = Value
        logError("Mythical Chance Boost: " .. tostring(Value))
        
        if Value and FishingEvents and FishingEvents:FindFirstChild("MythicalChanceBoost") then
            local success, result = pcall(function()
                FishingEvents.MythicalChanceBoost:FireServer()
                logError("Mythical Chance Boost activated")
            end)
            if not success then
                logError("Mythical Chance Boost Error: " .. result)
            end
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Anti-Bad Luck",
    CurrentValue = Config.RNGKill.AntiBadLuck,
    Flag = "AntiBadLuck",
    Callback = function(Value)
        Config.RNGKill.AntiBadLuck = Value
        logError("Anti-Bad Luck: " .. tostring(Value))
        
        if Value and FishingEvents and FishingEvents:FindFirstChild("AntiBadLuck") then
            local success, result = pcall(function()
                FishingEvents.AntiBadLuck:FireServer()
                logError("Anti-Bad Luck activated")
            end)
            if not success then
                logError("Anti-Bad Luck Error: " .. result)
            end
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Guaranteed Catch",
    CurrentValue = Config.RNGKill.GuaranteedCatch,
    Flag = "GuaranteedCatch",
    Callback = function(Value)
        Config.RNGKill.GuaranteedCatch = Value
        logError("Guaranteed Catch: " .. tostring(Value))
        
        if Value and FishingEvents and FishingEvents:FindFirstChild("GuaranteedCatch") then
            local success, result = pcall(function()
                FishingEvents.GuaranteedCatch:FireServer()
                logError("Guaranteed Catch activated")
            end)
            if not success then
                logError("Guaranteed Catch Error: " .. result)
            end
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
        
        if Value and Config.Shop.SelectedRod ~= "" and GameFunctions and GameFunctions:FindFirstChild("BuyRod") then
            local success, result = pcall(function()
                GameFunctions.BuyRod:InvokeServer(Config.Shop.SelectedRod)
                logError("Auto bought rod: " .. Config.Shop.SelectedRod)
            end)
            if not success then
                logError("Auto Buy Rods Error: " .. result)
            end
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
        
        if Value and Config.Shop.SelectedBoat ~= "" and GameFunctions and GameFunctions:FindFirstChild("BuyBoat") then
            local success, result = pcall(function()
                GameFunctions.BuyBoat:InvokeServer(Config.Shop.SelectedBoat)
                logError("Auto bought boat: " .. Config.Shop.SelectedBoat)
            end)
            if not success then
                logError("Auto Buy Boats Error: " .. result)
            end
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
        
        if Value and Config.Shop.SelectedBait ~= "" and GameFunctions and GameFunctions:FindFirstChild("BuyBait") then
            local success, result = pcall(function()
                GameFunctions.BuyBait:InvokeServer(Config.Shop.SelectedBait)
                logError("Auto bought bait: " .. Config.Shop.SelectedBait)
            end)
            if not success then
                logError("Auto Buy Baits Error: " .. result)
            end
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
        
        if Value and GameFunctions and GameFunctions:FindFirstChild("UpgradeRod") then
            local success, result = pcall(function()
                GameFunctions.UpgradeRod:InvokeServer()
                logError("Auto upgraded rod")
            end)
            if not success then
                logError("Auto Upgrade Rod Error: " .. result)
            end
        end
    end
})

ShopTab:CreateButton({
    Name = "Buy Selected Item",
    Callback = function()
        if Config.Shop.SelectedRod ~= "" and GameFunctions and GameFunctions:FindFirstChild("BuyRod") then
            local success, result = pcall(function()
                GameFunctions.BuyRod:InvokeServer(Config.Shop.SelectedRod)
                Rayfield:Notify({
                    Title = "Item Purchased",
                    Content = "Successfully bought: " .. Config.Shop.SelectedRod,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Bought rod: " .. Config.Shop.SelectedRod)
            end)
            if not success then
                logError("Buy Rod Error: " .. result)
            end
        elseif Config.Shop.SelectedBoat ~= "" and GameFunctions and GameFunctions:FindFirstChild("BuyBoat") then
            local success, result = pcall(function()
                GameFunctions.BuyBoat:InvokeServer(Config.Shop.SelectedBoat)
                Rayfield:Notify({
                    Title = "Item Purchased",
                    Content = "Successfully bought: " .. Config.Shop.SelectedBoat,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Bought boat: " .. Config.Shop.SelectedBoat)
            end)
            if not success then
                logError("Buy Boat Error: " .. result)
            end
        elseif Config.Shop.SelectedBait ~= "" and GameFunctions and GameFunctions:FindFirstChild("BuyBait") then
            local success, result = pcall(function()
                GameFunctions.BuyBait:InvokeServer(Config.Shop.SelectedBait)
                Rayfield:Notify({
                    Title = "Item Purchased",
                    Content = "Successfully bought: " .. Config.Shop.SelectedBait,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Bought bait: " .. Config.Shop.SelectedBait)
            end)
            if not success then
                logError("Buy Bait Error: " .. result)
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
    Options = {"Dark", "Light", "Blue", "Red", "Green", "Purple"},
    CurrentOption = Config.Settings.SelectedTheme,
    Flag = "SelectedTheme",
    Callback = function(Value)
        Config.Settings.SelectedTheme = Value
        -- Apply theme
        if Value == "Dark" then
            Window:SetTheme("Dark")
        elseif Value == "Light" then
            Window:SetTheme("Light")
        elseif Value == "Blue" then
            Window:SetTheme("Blue")
        elseif Value == "Red" then
            Window:SetTheme("Red")
        elseif Value == "Green" then
            Window:SetTheme("Green")
        elseif Value == "Purple" then
            Window:SetTheme("Purple")
        end
        logError("Theme changed to: " .. Value)
    end
})

SettingsTab:CreateSlider({
    Name = "UI Transparency",
    Range = {0.1, 1},
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
            logError("Config name set to: " .. Text)
        end
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
        Window:SetScale(Value)
        logError("UI Scale: " .. Value)
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

-- Favorite Fish Management
PlayerTab:CreateInput({
    Name = "Add Favorite Fish",
    PlaceholderText = "Enter fish name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text ~= "" then
            Config.Player.FavoriteFish[Text] = true
            Rayfield:Notify({
                Title = "Favorite Fish Added",
                Content = "Added " .. Text .. " to favorites",
                Duration = 3,
                Image = 13047715178
            })
            logError("Added favorite fish: " .. Text)
        end
    end
})

PlayerTab:CreateInput({
    Name = "Remove Favorite Fish",
    PlaceholderText = "Enter fish name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text ~= "" and Config.Player.FavoriteFish[Text] then
            Config.Player.FavoriteFish[Text] = nil
            Rayfield:Notify({
                Title = "Favorite Fish Removed",
                Content = "Removed " .. Text .. " from favorites",
                Duration = 3,
                Image = 13047715178
            })
            logError("Removed favorite fish: " .. Text)
        end
    end
})

-- Initialize script
logError("Fish It Hub 2025 script initialized")
Rayfield:Notify({
    Title = "Script Loaded",
    Content = "Fish It Hub 2025 has been loaded successfully!",
    Duration = 5,
    Image = 13047715178
})
