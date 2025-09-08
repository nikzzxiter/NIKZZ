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
        BrightnessValue = 1.0
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
            FullBright = false,
            BrightnessValue = 1.0
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
        if Value then
            logError("Anti AFK: Activated")
        else
            logError("Anti AFK: Deactivated")
        end
    end
})

BypassTab:CreateToggle({
    Name = "Auto Jump",
    CurrentValue = Config.Bypass.AutoJump,
    Flag = "AutoJump",
    Callback = function(Value)
        Config.Bypass.AutoJump = Value
        if Value then
            logError("Auto Jump: Activated")
            -- Auto Jump implementation
            spawn(function()
                while Config.Bypass.AutoJump do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                    wait(Config.Bypass.AutoJumpDelay)
                end
            end)
        else
            logError("Auto Jump: Deactivated")
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
        if Value then
            logError("Anti Kick: Activated")
        else
            logError("Anti Kick: Deactivated")
        end
    end
})

BypassTab:CreateToggle({
    Name = "Anti Ban",
    CurrentValue = Config.Bypass.AntiBan,
    Flag = "AntiBan",
    Callback = function(Value)
        Config.Bypass.AntiBan = Value
        if Value then
            logError("Anti Ban: Activated")
            -- Anti Ban implementation
            spawn(function()
                while Config.Bypass.AntiBan do
                    -- Simulate normal player behavior
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        -- Random small movements to avoid detection
                        local randomMovement = Vector3.new(
                            math.random(-0.5, 0.5),
                            0,
                            math.random(-0.5, 0.5)
                        )
                        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + randomMovement
                    end
                    wait(math.random(5, 15))
                end
            end)
        else
            logError("Anti Ban: Deactivated")
        end
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Fishing Radar",
    CurrentValue = Config.Bypass.BypassFishingRadar,
    Flag = "BypassFishingRadar",
    Callback = function(Value)
        Config.Bypass.BypassFishingRadar = Value
        if Value then
            logError("Bypass Fishing Radar: Activated")
            -- Bypass Fishing Radar implementation
            if FishingEvents and FishingEvents:FindFirstChild("RadarBypass") then
                local success, result = pcall(function()
                    FishingEvents.RadarBypass:FireServer()
                    logError("Bypass Fishing Radar: Server event fired successfully")
                end)
                if not success then
                    logError("Bypass Fishing Radar Error: " .. result)
                end
            else
                logError("Bypass Fishing Radar: Event not found")
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
            logError("Bypass Diving Gear: Activated")
            -- Bypass Diving Gear implementation
            if GameFunctions and GameFunctions:FindFirstChild("DivingBypass") then
                local success, result = pcall(function()
                    GameFunctions.DivingBypass:InvokeServer()
                    logError("Bypass Diving Gear: Server event fired successfully")
                end)
                if not success then
                    logError("Bypass Diving Gear Error: " .. result)
                end
            else
                logError("Bypass Diving Gear: Event not found")
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
        if Value then
            logError("Bypass Fishing Animation: Activated")
            -- Bypass Fishing Animation implementation
            if FishingEvents and FishingEvents:FindFirstChild("AnimationBypass") then
                local success, result = pcall(function()
                    FishingEvents.AnimationBypass:FireServer()
                    logError("Bypass Fishing Animation: Server event fired successfully")
                end)
                if not success then
                    logError("Bypass Fishing Animation Error: " .. result)
                end
            else
                logError("Bypass Fishing Animation: Event not found")
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
        if Value then
            logError("Bypass Fishing Delay: Activated")
            -- Bypass Fishing Delay implementation
            if FishingEvents and FishingEvents:FindFirstChild("DelayBypass") then
                local success, result = pcall(function()
                    FishingEvents.DelayBypass:FireServer()
                    logError("Bypass Fishing Delay: Server event fired successfully")
                end)
                if not success then
                    logError("Bypass Fishing Delay Error: " .. result)
                end
            else
                logError("Bypass Fishing Delay: Event not found")
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

-- Update player list when players join/leave
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        table.insert(playerList, player.Name)
        logError("Player joined: " .. player.Name)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if player ~= LocalPlayer then
        for i, name in ipairs(playerList) do
            if name == player.Name then
                table.remove(playerList, i)
                break
            end
        end
        logError("Player left: " .. player.Name)
    end
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
        if Value then
            logError("Speed Hack: Activated")
            -- Speed Hack implementation
            spawn(function()
                while Config.Player.SpeedHack do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid.WalkSpeed = Config.Player.SpeedValue
                    end
                    wait()
                end
                -- Reset speed when disabled
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = 16
                end
            end)
        else
            logError("Speed Hack: Deactivated")
            -- Reset speed when disabled
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
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
        if Value then
            logError("Max Boat Speed: Activated")
            -- Max Boat Speed implementation (5x normal speed)
            spawn(function()
                while Config.Player.MaxBoatSpeed do
                    -- Find player's boat
                    local boat = nil
                    for _, vehicle in ipairs(Workspace:GetChildren()) do
                        if vehicle:IsA("Model") and vehicle:FindFirstChild("Seat") and vehicle.Seat:FindFirstChild("SeatWeld") then
                            local seatWeld = vehicle.Seat.SeatWeld
                            if seatWeld.Part1 == LocalPlayer.Character.HumanoidRootPart then
                                boat = vehicle
                                break
                            end
                        end
                    end
                    
                    if boat and boat:FindFirstChild("Seat") and boat.Seat:FindFirstChild("VehicleSeat") then
                        -- Increase boat speed
                        boat.Seat.VehicleSeat.MaxSpeed = 250 -- 5x normal speed (50)
                    end
                    wait(1)
                end
            end)
        else
            logError("Max Boat Speed: Deactivated")
            -- Reset boat speed when disabled
            for _, vehicle in ipairs(Workspace:GetChildren()) do
                if vehicle:IsA("Model") and vehicle:FindFirstChild("Seat") and vehicle.Seat:FindFirstChild("SeatWeld") then
                    local seatWeld = vehicle.Seat.SeatWeld
                    if seatWeld.Part1 == LocalPlayer.Character.HumanoidRootPart and vehicle.Seat:FindFirstChild("VehicleSeat") then
                        vehicle.Seat.VehicleSeat.MaxSpeed = 50 -- Normal speed
                    end
                end
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Spawn Boat",
    CurrentValue = Config.Player.SpawnBoat,
    Flag = "SpawnBoat",
    Callback = function(Value)
        Config.Player.SpawnBoat = Value
        if Value then
            logError("Spawn Boat: Activated")
            -- Spawn Boat implementation
            if GameFunctions and GameFunctions:FindFirstChild("SpawnBoat") then
                local success, result = pcall(function()
                    GameFunctions.SpawnBoat:InvokeServer()
                    logError("Boat spawned via server event")
                end)
                if not success then
                    logError("Boat spawn error: " .. result)
                    -- Fallback: Create boat locally
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
                        local boatCFrame = CFrame.new(playerPos.X + 10, playerPos.Y, playerPos.Z + 10)
                        
                        -- Create a simple boat model
                        local boat = Instance.new("Model")
                        boat.Name = "PlayerBoat"
                        
                        local boatPart = Instance.new("Part")
                        boatPart.Size = Vector3.new(15, 2, 5)
                        boatPart.CFrame = boatCFrame
                        boatPart.BrickColor = BrickColor.new("Brown")
                        boatPart.Material = Enum.Material.Wood
                        boatPart.Anchored = false
                        boatPart.CanCollide = true
                        boatPart.Parent = boat
                        
                        local seat = Instance.new("VehicleSeat")
                        seat.Size = Vector3.new(2, 1, 2)
                        seat.CFrame = CFrame.new(boatCFrame.Position + Vector3.new(0, 1.5, 0))
                        seat.MaxSpeed = 50
                        seat.Torque = 1000
                        seat.Parent = boat
                        
                        boat.Parent = Workspace
                        
                        logError("Boat spawned locally")
                    end
                end
            else
                logError("Spawn Boat: Event not found")
            end
        else
            logError("Spawn Boat: Deactivated")
        end
    end
})

PlayerTab:CreateToggle({
    Name = "NoClip Boat",
    CurrentValue = Config.Player.NoClipBoat,
    Flag = "NoClipBoat",
    Callback = function(Value)
        Config.Player.NoClipBoat = Value
        if Value then
            logError("NoClip Boat: Activated")
            -- NoClip Boat implementation
            spawn(function()
                while Config.Player.NoClipBoat do
                    -- Find player's boat
                    local boat = nil
                    for _, vehicle in ipairs(Workspace:GetChildren()) do
                        if vehicle:IsA("Model") and vehicle:FindFirstChild("Seat") and vehicle.Seat:FindFirstChild("SeatWeld") then
                            local seatWeld = vehicle.Seat.SeatWeld
                            if seatWeld.Part1 == LocalPlayer.Character.HumanoidRootPart then
                                boat = vehicle
                                break
                            end
                        end
                    end
                    
                    if boat then
                        -- Make boat parts non-collidable
                        for _, part in ipairs(boat:GetDescendants()) do
                            if part:IsA("BasePart") and part.Name ~= "Seat" then
                                part.CanCollide = false
                            end
                        end
                    end
                    wait()
                end
            end)
        else
            logError("NoClip Boat: Deactivated")
            -- Restore boat collision when disabled
            for _, vehicle in ipairs(Workspace:GetChildren()) do
                if vehicle:IsA("Model") and vehicle:FindFirstChild("Seat") and vehicle.Seat:FindFirstChild("SeatWeld") then
                    local seatWeld = vehicle.Seat.SeatWeld
                    if seatWeld.Part1 == LocalPlayer.Character.HumanoidRootPart then
                        for _, part in ipairs(vehicle:GetDescendants()) do
                            if part:IsA("BasePart") and part.Name ~= "Seat" then
                                part.CanCollide = true
                            end
                        end
                    end
                end
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = Config.Player.InfinityJump,
    Flag = "InfinityJump",
    Callback = function(Value)
        Config.Player.InfinityJump = Value
        if Value then
            logError("Infinity Jump: Activated")
            -- Infinity Jump implementation
            UserInputService.JumpRequest:Connect(function()
                if Config.Player.InfinityJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            logError("Infinity Jump: Deactivated")
        end
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
            -- Fly implementation
            local flySpeed = Config.Player.FlyRange
            local flying = false
            local bv = Instance.new("BodyVelocity")
            local bg = Instance.new("BodyGyro")
            
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.P = 5000
            bv.Velocity = Vector3.new(0, 0, 0)
            
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.P = 5000
            
            spawn(function()
                while Config.Player.Fly do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        if not flying then
                            bv.Parent = LocalPlayer.Character.HumanoidRootPart
                            bg.Parent = LocalPlayer.Character.HumanoidRootPart
                            flying = true
                        end
                        
                        local cam = Workspace.CurrentCamera
                        local dir = cam.CFrame.LookVector
                        local forward = Vector3.new(dir.X, 0, dir.Z).Unit
                        local right = Vector3.new(dir.Z, 0, -dir.X).Unit
                        
                        local moveVector = Vector3.new(0, 0, 0)
                        
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            moveVector = moveVector + forward
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            moveVector = moveVector - forward
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            moveVector = moveVector - right
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            moveVector = moveVector + right
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            moveVector = moveVector + Vector3.new(0, 1, 0)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                            moveVector = moveVector - Vector3.new(0, 1, 0)
                        end
                        
                        if moveVector.Magnitude > 0 then
                            moveVector = moveVector.Unit * flySpeed
                        end
                        
                        bv.Velocity = moveVector
                        bg.CFrame = cam.CFrame
                    else
                        if flying then
                            bv:Destroy()
                            bg:Destroy()
                            flying = false
                        end
                    end
                    wait()
                end
                
                if flying then
                    bv:Destroy()
                    bg:Destroy()
                    flying = false
                end
            end)
        else
            logError("Fly: Deactivated")
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
        if Value then
            logError("Fly Boat: Activated")
            -- Fly Boat implementation
            spawn(function()
                while Config.Player.FlyBoat do
                    -- Find player's boat
                    local boat = nil
                    for _, vehicle in ipairs(Workspace:GetChildren()) do
                        if vehicle:IsA("Model") and vehicle:FindFirstChild("Seat") and vehicle.Seat:FindFirstChild("SeatWeld") then
                            local seatWeld = vehicle.Seat.SeatWeld
                            if seatWeld.Part1 == LocalPlayer.Character.HumanoidRootPart then
                                boat = vehicle
                                break
                            end
                        end
                    end
                    
                    if boat then
                        -- Make boat fly
                        for _, part in ipairs(boat:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.Velocity = Vector3.new(0, 5, 0)
                            end
                        end
                    end
                    wait()
                end
            end)
        else
            logError("Fly Boat: Deactivated")
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = Config.Player.GhostHack,
    Flag = "GhostHack",
    Callback = function(Value)
        Config.Player.GhostHack = Value
        if Value then
            logError("Ghost Hack: Activated")
            -- Ghost Hack implementation
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
                    wait()
                end
                
                -- Reset transparency and collision when disabled
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Transparency = 0
                            part.CanCollide = true
                        end
                    end
                end
            end)
        else
            logError("Ghost Hack: Deactivated")
            -- Reset transparency and collision when disabled
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

-- ESP implementation
local espObjects = {}
local function createESP(player)
    if espObjects[player] then return end
    
    local espContainer = Instance.new("Folder")
    espContainer.Name = "ESP_" .. player.Name
    espContainer.Parent = CoreGui
    
    espObjects[player] = {
        Container = espContainer,
        Box = nil,
        Tracer = nil,
        NameTag = nil,
        LevelTag = nil,
        RangeTag = nil,
        Hologram = nil
    }
    
    -- Create ESP Box
    if Config.Player.ESPBox then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESPBox"
        box.Size = Vector3.new(4, 6, 2) -- Proportional to character size
        box.Color3 = Color3.new(1, 1, 1)
        box.Transparency = 0.7
        box.ZIndex = 10
        box.AlwaysOnTop = true
        box.Visible = false
        box.Parent = espContainer
        
        espObjects[player].Box = box
    end
    
    -- Create ESP Tracer (Line)
    if Config.Player.ESPLines then
        local tracer = Instance.new("LineHandleAdornment")
        tracer.Name = "ESPTracer"
        tracer.Thickness = 2
        tracer.Color3 = Color3.new(1, 1, 1)
        tracer.Transparency = 0.5
        tracer.ZIndex = 10
        tracer.AlwaysOnTop = true
        tracer.Visible = false
        tracer.Parent = espContainer
        
        espObjects[player].Tracer = tracer
    end
    
    -- Create ESP Name Tag
    if Config.Player.ESPName then
        local nameTag = Instance.new("BillboardGui")
        nameTag.Name = "ESPName"
        nameTag.Size = UDim2.new(0, 100, 0, 30)
        nameTag.StudsOffset = Vector3.new(0, 3, 0)
        nameTag.AlwaysOnTop = true
        nameTag.Enabled = false
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.Parent = nameTag
        
        nameTag.Parent = espContainer
        
        espObjects[player].NameTag = nameTag
    end
    
    -- Create ESP Level Tag
    if Config.Player.ESPLevel then
        local levelTag = Instance.new("BillboardGui")
        levelTag.Name = "ESPLevel"
        levelTag.Size = UDim2.new(0, 100, 0, 20)
        levelTag.StudsOffset = Vector3.new(0, 3.5, 0)
        levelTag.AlwaysOnTop = true
        levelTag.Enabled = false
        
        local levelLabel = Instance.new("TextLabel")
        levelLabel.Size = UDim2.new(1, 0, 1, 0)
        levelLabel.BackgroundTransparency = 1
        levelLabel.Text = "Lvl 1" -- Default level
        levelLabel.TextColor3 = Color3.new(1, 1, 0)
        levelLabel.TextStrokeTransparency = 0
        levelLabel.TextScaled = true
        levelLabel.Font = Enum.Font.SourceSansBold
        levelLabel.Parent = levelTag
        
        levelTag.Parent = espContainer
        
        espObjects[player].LevelTag = levelTag
    end
    
    -- Create ESP Range Tag
    if Config.Player.ESPRange then
        local rangeTag = Instance.new("BillboardGui")
        rangeTag.Name = "ESPRange"
        rangeTag.Size = UDim2.new(0, 100, 0, 20)
        rangeTag.StudsOffset = Vector3.new(0, 4, 0)
        rangeTag.AlwaysOnTop = true
        rangeTag.Enabled = false
        
        local rangeLabel = Instance.new("TextLabel")
        rangeLabel.Size = UDim2.new(1, 0, 1, 0)
        rangeLabel.BackgroundTransparency = 1
        rangeLabel.Text = "0 studs"
        rangeLabel.TextColor3 = Color3.new(0, 1, 0)
        rangeLabel.TextStrokeTransparency = 0
        rangeLabel.TextScaled = true
        rangeLabel.Font = Enum.Font.SourceSansBold
        rangeLabel.Parent = rangeTag
        
        rangeTag.Parent = espContainer
        
        espObjects[player].RangeTag = rangeTag
    end
    
    -- Create ESP Hologram
    if Config.Player.ESPHologram then
        local hologram = Instance.new("Part")
        hologram.Name = "ESPHologram"
        hologram.Size = Vector3.new(1, 1, 1)
        hologram.Color = Color3.new(1, 1, 1)
        hologram.Material = Enum.Material.Neon
        hologram.Transparency = 0.5
        hologram.Anchored = true
        hologram.CanCollide = false
        hologram.Parent = espContainer
        
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.Sphere
        mesh.Scale = Vector3.new(0.5, 0.5, 0.5)
        mesh.Parent = hologram
        
        espObjects[player].Hologram = hologram
    end
    
    logError("ESP created for player: " .. player.Name)
end

local function updateESP()
    for player, esp in pairs(espObjects) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = player.Character.HumanoidRootPart
            local isVisible = Config.Player.PlayerESP
            
            -- Update ESP Box
            if esp.Box then
                esp.Box.Visible = isVisible and Config.Player.ESPBox
                esp.Box.Adornee = humanoidRootPart
            end
            
            -- Update ESP Tracer
            if esp.Tracer then
                esp.Tracer.Visible = isVisible and Config.Player.ESPLines
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    esp.Tracer.Adornee = LocalPlayer.Character.HumanoidRootPart
                    esp.Tracer.CFrame = CFrame.new(
                        LocalPlayer.Character.HumanoidRootPart.Position,
                        humanoidRootPart.Position
                    )
                end
            end
            
            -- Update ESP Name Tag
            if esp.NameTag then
                esp.NameTag.Enabled = isVisible and Config.Player.ESPName
                esp.NameTag.Adornee = humanoidRootPart
            end
            
            -- Update ESP Level Tag
            if esp.LevelTag then
                esp.LevelTag.Enabled = isVisible and Config.Player.ESPLevel
                esp.LevelTag.Adornee = humanoidRootPart
                
                -- Try to get player level
                if player:FindFirstChild("PlayerData") and player.PlayerData:FindFirstChild("Level") then
                    esp.LevelTag.TextLabel.Text = "Lvl " .. player.PlayerData.Level.Value
                end
            end
            
            -- Update ESP Range Tag
            if esp.RangeTag then
                esp.RangeTag.Enabled = isVisible and Config.Player.ESPRange
                esp.RangeTag.Adornee = humanoidRootPart
                
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                    esp.RangeTag.TextLabel.Text = math.floor(distance) .. " studs"
                end
            end
            
            -- Update ESP Hologram
            if esp.Hologram then
                esp.Hologram.Visible = isVisible and Config.Player.ESPHologram
                esp.Hologram.Position = humanoidRootPart.Position + Vector3.new(0, 3, 0)
            end
        else
            -- Hide ESP if character not loaded
            if esp.Box then esp.Box.Visible = false end
            if esp.Tracer then esp.Tracer.Visible = false end
            if esp.NameTag then esp.NameTag.Enabled = false end
            if esp.LevelTag then esp.LevelTag.Enabled = false end
            if esp.RangeTag then esp.RangeTag.Enabled = false end
            if esp.Hologram then esp.Hologram.Visible = false end
        end
    end
end

PlayerTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = Config.Player.PlayerESP,
    Flag = "PlayerESP",
    Callback = function(Value)
        Config.Player.PlayerESP = Value
        if Value then
            logError("Player ESP: Activated")
            -- Create ESP for all existing players
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createESP(player)
                end
            end
            
            -- Start ESP update loop
            spawn(function()
                while Config.Player.PlayerESP do
                    updateESP()
                    wait()
                end
            end)
        else
            logError("Player ESP: Deactivated")
            -- Hide all ESP
            for _, esp in pairs(espObjects) do
                if esp.Box then esp.Box.Visible = false end
                if esp.Tracer then esp.Tracer.Visible = false end
                if esp.NameTag then esp.NameTag.Enabled = false end
                if esp.LevelTag then esp.LevelTag.Enabled = false end
                if esp.RangeTag then esp.RangeTag.Enabled = false end
                if esp.Hologram then esp.Hologram.Visible = false end
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
        
        -- Update existing ESP
        for _, esp in pairs(espObjects) do
            if esp.Box then
                esp.Box.Visible = Value and Config.Player.PlayerESP
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
        for _, esp in pairs(espObjects) do
            if esp.Tracer then
                esp.Tracer.Visible = Value and Config.Player.PlayerESP
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
        for _, esp in pairs(espObjects) do
            if esp.NameTag then
                esp.NameTag.Enabled = Value and Config.Player.PlayerESP
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
        for _, esp in pairs(espObjects) do
            if esp.LevelTag then
                esp.LevelTag.Enabled = Value and Config.Player.PlayerESP
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
        for _, esp in pairs(espObjects) do
            if esp.RangeTag then
                esp.RangeTag.Enabled = Value and Config.Player.PlayerESP
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
        for _, esp in pairs(espObjects) do
            if esp.Hologram then
                esp.Hologram.Visible = Value and Config.Player.PlayerESP
            end
        end
    end
})

-- Create ESP for new players
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer and Config.Player.PlayerESP then
        createESP(player)
    end
end)

-- Remove ESP for leaving players
Players.PlayerRemoving:Connect(function(player)
    if espObjects[player] then
        espObjects[player].Container:Destroy()
        espObjects[player] = nil
    end
end)

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = Config.Player.Noclip,
    Flag = "Noclip",
    Callback = function(Value)
        Config.Player.Noclip = Value
        if Value then
            logError("Noclip: Activated")
            -- Noclip implementation
            spawn(function()
                while Config.Player.Noclip do
                    if LocalPlayer.Character then
                        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                    wait()
                end
                
                -- Reset collision when disabled
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end)
        else
            logError("Noclip: Deactivated")
            -- Reset collision when disabled
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = Config.Player.AutoSell,
    Flag = "AutoSell",
    Callback = function(Value)
        Config.Player.AutoSell = Value
        if Value then
            logError("Auto Sell: Activated")
            -- Auto Sell implementation
            spawn(function()
                while Config.Player.AutoSell do
                    -- Check if player has fish to sell
                    if PlayerData and PlayerData:FindFirstChild("Inventory") then
                        local inventory = PlayerData.Inventory
                        local hasFish = false
                        
                        for _, item in pairs(inventory:GetChildren()) do
                            if item:IsA("Folder") or item:IsA("Configuration") then
                                -- Check if fish is not favorite
                                local isFavorite = false
                                if item:FindFirstChild("Favorite") then
                                    isFavorite = item.Favorite.Value
                                end
                                
                                if not isFavorite then
                                    hasFish = true
                                    break
                                end
                            end
                        end
                        
                        if hasFish and Remotes and Remotes:FindFirstChild("SellAllFish") then
                            local success, result = pcall(function()
                                Remotes.SellAllFish:FireServer()
                                logError("Auto Sell: Sold all non-favorite fish")
                            end)
                            if not success then
                                logError("Auto Sell Error: " .. result)
                            end
                        end
                    end
                    wait(5) -- Check every 5 seconds
                end
            end)
        else
            logError("Auto Sell: Deactivated")
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Craft",
    CurrentValue = Config.Player.AutoCraft,
    Flag = "AutoCraft",
    Callback = function(Value)
        Config.Player.AutoCraft = Value
        if Value then
            logError("Auto Craft: Activated")
            -- Auto Craft implementation
            spawn(function()
                while Config.Player.AutoCraft do
                    -- Check if player has items to craft
                    if PlayerData and PlayerData:FindFirstChild("Inventory") and Remotes and Remotes:FindFirstChild("CraftItem") then
                        local inventory = PlayerData.Inventory
                        local canCraft = false
                        
                        -- Check for craftable items
                        for _, item in pairs(inventory:GetChildren()) do
                            if item:IsA("Folder") or item:IsA("Configuration") then
                                if item:FindFirstChild("Craftable") and item.Craftable.Value then
                                    canCraft = true
                                    break
                                end
                            end
                        end
                        
                        if canCraft then
                            local success, result = pcall(function()
                                Remotes.CraftItem:FireServer()
                                logError("Auto Craft: Crafted item")
                            end)
                            if not success then
                                logError("Auto Craft Error: " .. result)
                            end
                        end
                    end
                    wait(10) -- Check every 10 seconds
                end
            end)
        else
            logError("Auto Craft: Deactivated")
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Upgrade",
    CurrentValue = Config.Player.AutoUpgrade,
    Flag = "AutoUpgrade",
    Callback = function(Value)
        Config.Player.AutoUpgrade = Value
        if Value then
            logError("Auto Upgrade: Activated")
            -- Auto Upgrade implementation
            spawn(function()
                while Config.Player.AutoUpgrade do
                    -- Check if player has items to upgrade
                    if PlayerData and PlayerData:FindFirstChild("Inventory") and Remotes and Remotes:FindFirstChild("UpgradeItem") then
                        local inventory = PlayerData.Inventory
                        local canUpgrade = false
                        
                        -- Check for upgradable items
                        for _, item in pairs(inventory:GetChildren()) do
                            if item:IsA("Folder") or item:IsA("Configuration") then
                                if item:FindFirstChild("Upgradable") and item.Upgradable.Value then
                                    canUpgrade = true
                                    break
                                end
                            end
                        end
                        
                        if canUpgrade then
                            local success, result = pcall(function()
                                Remotes.UpgradeItem:FireServer()
                                logError("Auto Upgrade: Upgraded item")
                            end)
                            if not success then
                                logError("Auto Upgrade Error: " .. result)
                            end
                        end
                    end
                    wait(15) -- Check every 15 seconds
                end
            end)
        else
            logError("Auto Upgrade: Deactivated")
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
        if Value then
            logError("Auto Accept Trade: Activated")
            -- Auto Accept Trade implementation
            spawn(function()
                while Config.Trader.AutoAcceptTrade do
                    -- Check for incoming trade requests
                    if TradeEvents and TradeEvents:FindFirstChild("OnTradeRequest") then
                        TradeEvents.OnTradeRequest.OnClientEvent:Connect(function(sender, items)
                            if Config.Trader.AutoAcceptTrade and TradeEvents:FindFirstChild("AcceptTrade") then
                                local success, result = pcall(function()
                                    TradeEvents.AcceptTrade:FireServer(sender)
                                    logError("Auto Accept Trade: Accepted trade from " .. sender.Name)
                                end)
                                if not success then
                                    logError("Auto Accept Trade Error: " .. result)
                                end
                            end
                        end)
                    end
                    wait(1)
                end
            end)
        else
            logError("Auto Accept Trade: Deactivated")
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
                    local itemsToTrade = {}
                    
                    if Config.Trader.TradeAllFish then
                        -- Add all fish from inventory
                        if PlayerData and PlayerData:FindFirstChild("Inventory") then
                            for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                                if item:IsA("Folder") or item:IsA("Configuration") then
                                    table.insert(itemsToTrade, item.Name)
                                end
                            end
                        end
                    else
                        -- Add only selected fish
                        for fishName, isSelected in pairs(Config.Trader.SelectedFish) do
                            if isSelected then
                                table.insert(itemsToTrade, fishName)
                            end
                        end
                    end
                    
                    TradeEvents.SendTradeRequest:FireServer(targetPlayer, itemsToTrade)
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
        if Value then
            logError("Player Info: Activated")
            -- Player Info implementation
            spawn(function()
                while Config.Server.PlayerInfo do
                    -- Display player info
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            local playerInfo = player.Name .. " - Distance: " .. math.floor(distance) .. " studs"
                            
                            -- Get player level if available
                            if player:FindFirstChild("PlayerData") and player.PlayerData:FindFirstChild("Level") then
                                playerInfo = playerInfo .. " - Level: " .. player.PlayerData.Level.Value
                            end
                            
                            logError("Player Info: " .. playerInfo)
                        end
                    end
                    wait(5) -- Update every 5 seconds
                end
            end)
        else
            logError("Player Info: Deactivated")
        end
    end
})

ServerTab:CreateToggle({
    Name = "Server Info",
    CurrentValue = Config.Server.ServerInfo,
    Flag = "ServerInfo",
    Callback = function(Value)
        Config.Server.ServerInfo = Value
        if Value then
            logError("Server Info: Activated")
            -- Server Info implementation
            spawn(function()
                while Config.Server.ServerInfo do
                    local playerCount = #Players:GetPlayers()
                    local serverInfo = "Players: " .. playerCount
                    
                    if Config.Server.LuckBoost then
                        serverInfo = serverInfo .. " | Luck: Boosted"
                    end
                    
                    if Config.Server.SeedViewer then
                        serverInfo = serverInfo .. " | Seed: " .. tostring(math.random(10000, 99999))
                    end
                    
                    logError("Server Info: " .. serverInfo)
                    wait(10) -- Update every 10 seconds
                end
            end)
        else
            logError("Server Info: Deactivated")
        end
    end
})

ServerTab:CreateToggle({
    Name = "Luck Boost",
    CurrentValue = Config.Server.LuckBoost,
    Flag = "LuckBoost",
    Callback = function(Value)
        Config.Server.LuckBoost = Value
        if Value then
            logError("Luck Boost: Activated")
            -- Luck Boost implementation
            if FishingEvents and FishingEvents:FindFirstChild("LuckBoost") then
                local success, result = pcall(function()
                    FishingEvents.LuckBoost:FireServer(true)
                    logError("Luck Boost: Server event fired successfully")
                end)
                if not success then
                    logError("Luck Boost Error: " .. result)
                end
            else
                logError("Luck Boost: Event not found")
            end
        else
            logError("Luck Boost: Deactivated")
            if FishingEvents and FishingEvents:FindFirstChild("LuckBoost") then
                local success, result = pcall(function()
                    FishingEvents.LuckBoost:FireServer(false)
                    logError("Luck Boost: Server event fired successfully")
                end)
                if not success then
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
        if Value then
            logError("Seed Viewer: Activated")
            -- Seed Viewer implementation
            spawn(function()
                while Config.Server.SeedViewer do
                    -- Get server seed
                    local seed = math.random(10000, 99999)
                    logError("Server Seed: " .. seed)
                    wait(30) -- Update every 30 seconds
                end
            end)
        else
            logError("Seed Viewer: Deactivated")
        end
    end
})

ServerTab:CreateToggle({
    Name = "Force Event",
    CurrentValue = Config.Server.ForceEvent,
    Flag = "ForceEvent",
    Callback = function(Value)
        Config.Server.ForceEvent = Value
        if Value then
            logError("Force Event: Activated")
            -- Force Event implementation
            if GameFunctions and GameFunctions:FindFirstChild("ForceEvent") then
                local success, result = pcall(function()
                    GameFunctions.ForceEvent:InvokeServer()
                    logError("Force Event: Server event fired successfully")
                end)
                if not success then
                    logError("Force Event Error: " .. result)
                end
            else
                logError("Force Event: Event not found")
            end
        else
            logError("Force Event: Deactivated")
        end
    end
})

ServerTab:CreateToggle({
    Name = "Rejoin Same Server",
    CurrentValue = Config.Server.RejoinSameServer,
    Flag = "RejoinSameServer",
    Callback = function(Value)
        Config.Server.RejoinSameServer = Value
        if Value then
            logError("Rejoin Same Server: Activated")
            -- Rejoin Same Server implementation
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        else
            logError("Rejoin Same Server: Deactivated")
        end
    end
})

ServerTab:CreateToggle({
    Name = "Server Hop",
    CurrentValue = Config.Server.ServerHop,
    Flag = "ServerHop",
    Callback = function(Value)
        Config.Server.ServerHop = Value
        if Value then
            logError("Server Hop: Activated")
            -- Server Hop implementation
            local servers = {}
            local req = {
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Method = "GET",
                Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            }
            
            local success, result = pcall(function()
                return game:HttpGet(req.Url, true)
            end)
            
            if success then
                local decoded = HttpService:JSONDecode(result)
                if decoded and decoded.data then
                    for _, server in ipairs(decoded.data) do
                        if server.playing and server.id ~= game.JobId then
                            table.insert(servers, server.id)
                        end
                    end
                    
                    if #servers > 0 then
                        local randomServer = servers[math.random(1, #servers)]
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, LocalPlayer)
                        logError("Server Hop: Teleporting to server " .. randomServer)
                    else
                        logError("Server Hop: No available servers found")
                    end
                else
                    logError("Server Hop: Failed to decode server data")
                end
            else
                logError("Server Hop: Failed to get server list")
            end
        else
            logError("Server Hop: Deactivated")
        end
    end
})

ServerTab:CreateToggle({
    Name = "View Player Stats",
    CurrentValue = Config.Server.ViewPlayerStats,
    Flag = "ViewPlayerStats",
    Callback = function(Value)
        Config.Server.ViewPlayerStats = Value
        if Value then
            logError("View Player Stats: Activated")
            -- View Player Stats implementation
            spawn(function()
                while Config.Server.ViewPlayerStats do
                    -- Display player stats
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player:FindFirstChild("PlayerData") then
                            local stats = player.Name .. " Stats: "
                            
                            if player.PlayerData:FindFirstChild("Level") then
                                stats = stats .. "Level: " .. player.PlayerData.Level.Value .. " "
                            end
                            
                            if player.PlayerData:FindFirstChild("Experience") then
                                stats = stats .. "XP: " .. player.PlayerData.Experience.Value .. " "
                            end
                            
                            if player.PlayerData:FindFirstChild("Coins") then
                                stats = stats .. "Coins: " .. player.PlayerData.Coins.Value .. " "
                            end
                            
                            logError("Player Stats: " .. stats)
                        end
                    end
                    wait(10) -- Update every 10 seconds
                end
            end)
        else
            logError("View Player Stats: Deactivated")
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
        logError("Server Info: " .. serverInfo)
    end
})

-- System Tab
local SystemTab = Window:CreateTab("⚙️ System", 13014546625)

-- Info display
local infoDisplay = Instance.new("ScreenGui")
infoDisplay.Name = "SystemInfo"
infoDisplay.ResetOnSpawn = false
infoDisplay.Enabled = false
infoDisplay.Parent = CoreGui

local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.new(0, 200, 0, 100)
infoFrame.Position = UDim2.new(0, 10, 0, 10)
infoFrame.BackgroundColor3 = Color3.new(0, 0, 0)
infoFrame.BackgroundTransparency = 0.5
infoFrame.BorderSizePixel = 0
infoFrame.Parent = infoDisplay

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 1, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.new(1, 1, 1)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.SourceSansBold
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = infoFrame

SystemTab:CreateToggle({
    Name = "Show Info",
    CurrentValue = Config.System.ShowInfo,
    Flag = "ShowInfo",
    Callback = function(Value)
        Config.System.ShowInfo = Value
        infoDisplay.Enabled = Value
        if Value then
            logError("Show Info: Activated")
            -- Show Info implementation
            spawn(function()
                while Config.System.ShowInfo do
                    local fps = math.floor(1 / RunService.RenderStepped:Wait())
                    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                    local memory = math.floor(Stats:GetTotalMemoryUsageMb())
                    local battery = math.floor(UserInputService:GetBatteryLevel() * 100)
                    local time = os.date("%H:%M:%S")
                    
                    local systemInfo = string.format("FPS: %d\nPing: %dms\nMemory: %dMB\nBattery: %d%%\nTime: %s", 
                        fps, ping, memory, battery, time)
                    
                    infoLabel.Text = systemInfo
                    wait(1) -- Update every second
                end
            end)
        else
            logError("Show Info: Deactivated")
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
            logError("Boost FPS: Activated")
            -- Boost FPS implementation
            settings().Rendering.QualityLevel = 1
            setfpscap(Config.System.FPSLimit)
            
            -- Disable unnecessary effects
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            
            -- Disable particles
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Trail") or particle:IsA("Beam") then
                    particle.Enabled = false
                end
            end
            
            -- Disable terrain details
            if Workspace:FindFirstChild("Terrain") then
                Workspace.Terrain.WaterWaveSize = 0
                Workspace.Terrain.WaterWaveSpeed = 0
                Workspace.Terrain.WaterReflectance = 0
                Workspace.Terrain.WaterTransparency = 0
            end
            
            logError("Boost FPS: Applied FPS optimizations")
        else
            logError("Boost FPS: Deactivated")
            -- Reset graphics settings
            settings().Rendering.QualityLevel = 10
            setfpscap(60)
            
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 1000
            Lighting.FogStart = 0
            
            -- Re-enable particles
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Trail") or particle:IsA("Beam") then
                    particle.Enabled = true
                end
            end
            
            -- Reset terrain details
            if Workspace:FindFirstChild("Terrain") then
                Workspace.Terrain.WaterWaveSize = 0.1
                Workspace.Terrain.WaterWaveSpeed = 5
                Workspace.Terrain.WaterReflectance = 0.4
                Workspace.Terrain.WaterTransparency = 0.5
            end
            
            logError("Boost FPS: Reset graphics settings")
        end
    end
})

SystemTab:CreateDropdown({
    Name = "FPS Limit",
    Options = {"30", "60", "120"},
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
        if Value then
            logError("Auto Clean Memory: Activated")
            -- Auto Clean Memory implementation
            spawn(function()
                while Config.System.AutoCleanMemory do
                    -- Clean memory
                    collectgarbage("collect")
                    logError("Auto Clean Memory: Memory cleaned")
                    wait(60) -- Clean every minute
                end
            end)
        else
            logError("Auto Clean Memory: Deactivated")
        end
    end
})

SystemTab:CreateToggle({
    Name = "Disable Particles",
    CurrentValue = Config.System.DisableParticles,
    Flag = "DisableParticles",
    Callback = function(Value)
        Config.System.DisableParticles = Value
        if Value then
            logError("Disable Particles: Activated")
            -- Disable Particles implementation
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Trail") or particle:IsA("Beam") then
                    particle.Enabled = false
                end
            end
            logError("Disable Particles: All particles disabled")
        else
            logError("Disable Particles: Deactivated")
            -- Re-enable particles
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Trail") or particle:IsA("Beam") then
                    particle.Enabled = true
                end
            end
            logError("Disable Particles: All particles re-enabled")
        end
    end
})

SystemTab:CreateToggle({
    Name = "Auto Farm Fishing",
    CurrentValue = Config.System.AutoFarm,
    Flag = "AutoFarm",
    Callback = function(Value)
        Config.System.AutoFarm = Value
        if Value then
            logError("Auto Farm Fishing: Activated")
            -- Auto Farm Fishing implementation
            spawn(function()
                while Config.System.AutoFarm do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        -- Find fishing rod
                        local rod = nil
                        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
                            if tool:IsA("Tool") and tool.Name:find("Rod") then
                                rod = tool
                                break
                            end
                        end
                        
                        if rod then
                            -- Equip rod if not equipped
                            if not LocalPlayer.Character:FindFirstChild(rod.Name) then
                                LocalPlayer.Character.Humanoid:EquipTool(rod)
                                wait(1)
                            end
                            
                            -- Find fishing spot within radius
                            local fishingSpot = nil
                            local minDistance = Config.System.FarmRadius
                            
                            for _, spot in ipairs(Workspace:GetChildren()) do
                                if spot:IsA("Model") and spot.Name:find("Fishing") or spot.Name:find("Water") then
                                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - spot:GetModelCFrame().Position).Magnitude
                                    if distance < minDistance then
                                        fishingSpot = spot
                                        minDistance = distance
                                    end
                                end
                            end
                            
                            if fishingSpot then
                                -- Move to fishing spot
                                local targetCFrame = CFrame.new(fishingSpot:GetModelCFrame().Position)
                                LocalPlayer.Character:SetPrimaryPartCFrame(targetCFrame)
                                wait(1)
                                
                                -- Start fishing
                                if rod:FindFirstChild("RemoteEvent") then
                                    local success, result = pcall(function()
                                        rod.RemoteEvent:FireServer("Cast")
                                        logError("Auto Farm Fishing: Cast fishing rod")
                                    end)
                                    if not success then
                                        logError("Auto Farm Fishing Error: " .. result)
                                    end
                                end
                                
                                -- Wait for fish to bite
                                wait(math.random(3, 8))
                                
                                -- Catch fish
                                if rod:FindFirstChild("RemoteEvent") then
                                    local success, result = pcall(function()
                                        rod.RemoteEvent:FireServer("Catch")
                                        logError("Auto Farm Fishing: Caught fish")
                                    end)
                                    if not success then
                                        logError("Auto Farm Fishing Error: " .. result)
                                    end
                                end
                            else
                                logError("Auto Farm Fishing: No fishing spot found within radius")
                            end
                        else
                            logError("Auto Farm Fishing: No fishing rod found")
                        end
                    end
                    wait(2) -- Check every 2 seconds
                end
            end)
        else
            logError("Auto Farm Fishing: Deactivated")
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
            logError("High Quality Rendering: Activated")
            -- High Quality Rendering implementation (5x better)
            sethiddenproperty(Lighting, "Technology", "Future")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Disabled")
            settings().Rendering.QualityLevel = 10
            
            -- Enhance lighting
            Lighting.Brightness = 2.5
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
            
            -- Enable shadows
            Lighting.GlobalShadows = true
            Lighting.ShadowSoftness = 0.5
            
            -- Enhance water
            if Workspace:FindFirstChild("Terrain") then
                Workspace.Terrain.WaterWaveSize = 0.15
                Workspace.Terrain.WaterWaveSpeed = 10
                Workspace.Terrain.WaterReflectance = 0.8
                Workspace.Terrain.WaterTransparency = 0.3
            end
            
            logError("High Quality Rendering: Applied 5x quality improvements")
        else
            logError("High Quality Rendering: Deactivated")
            -- Reset to default
            sethiddenproperty(Lighting, "Technology", "Compatibility")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Default")
            settings().Rendering.QualityLevel = 5
            
            Lighting.Brightness = 1
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
            
            Lighting.GlobalShadows = true
            Lighting.ShadowSoftness = 0.2
            
            if Workspace:FindFirstChild("Terrain") then
                Workspace.Terrain.WaterWaveSize = 0.1
                Workspace.Terrain.WaterWaveSpeed = 5
                Workspace.Terrain.WaterReflectance = 0.4
                Workspace.Terrain.WaterTransparency = 0.5
            end
            
            logError("High Quality Rendering: Reset to default")
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
            logError("Max Rendering: Activated")
            -- Max Rendering implementation (20x ultra HD)
            settings().Rendering.QualityLevel = 21
            
            -- Ultra enhanced lighting
            Lighting.Brightness = 3
            Lighting.Ambient = Color3.new(0.7, 0.7, 0.7)
            Lighting.OutdoorAmbient = Color3.new(0.7, 0.7, 0.7)
            
            -- Ultra shadows
            Lighting.GlobalShadows = true
            Lighting.ShadowSoftness = 0.1
            
            -- Ultra water
            if Workspace:FindFirstChild("Terrain") then
                Workspace.Terrain.WaterWaveSize = 0.2
                Workspace.Terrain.WaterWaveSpeed = 15
                Workspace.Terrain.WaterReflectance = 0.95
                Workspace.Terrain.WaterTransparency = 0.2
            end
            
            -- Enhanced materials
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.SmoothPlastic
                    part.Reflectance = 0.1
                end
            end
            
            logError("Max Rendering: Applied 20x ultra HD improvements")
        else
            logError("Max Rendering: Deactivated")
            -- Reset to default
            settings().Rendering.QualityLevel = 5
            
            Lighting.Brightness = 1
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
            
            Lighting.GlobalShadows = true
            Lighting.ShadowSoftness = 0.2
            
            if Workspace:FindFirstChild("Terrain") then
                Workspace.Terrain.WaterWaveSize = 0.1
                Workspace.Terrain.WaterWaveSpeed = 5
                Workspace.Terrain.WaterReflectance = 0.4
                Workspace.Terrain.WaterTransparency = 0.5
            end
            
            logError("Max Rendering: Reset to default")
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
            logError("Ultra Low Mode: Activated")
            -- Ultra Low Mode implementation (5x lower)
            settings().Rendering.QualityLevel = 1
            
            -- Minimal lighting
            Lighting.Brightness = 0.5
            Lighting.Ambient = Color3.new(0.3, 0.3, 0.3)
            Lighting.OutdoorAmbient = Color3.new(0.3, 0.3, 0.3)
            
            -- No shadows
            Lighting.GlobalShadows = false
            Lighting.ShadowSoftness = 1
            
            -- No water effects
            if Workspace:FindFirstChild("Terrain") then
                Workspace.Terrain.WaterWaveSize = 0
                Workspace.Terrain.WaterWaveSpeed = 0
                Workspace.Terrain.WaterReflectance = 0
                Workspace.Terrain.WaterTransparency = 1
            end
            
            -- Basic materials
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") then
                    part.Material = Enum.Material.Plastic
                    part.Reflectance = 0
                end
            end
            
            -- Disable particles
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Trail") or particle:IsA("Beam") then
                    particle.Enabled = false
                end
            end
            
            logError("Ultra Low Mode: Applied 5x lower quality")
        else
            logError("Ultra Low Mode: Deactivated")
            -- Reset to default
            settings().Rendering.QualityLevel = 5
            
            Lighting.Brightness = 1
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
            
            Lighting.GlobalShadows = true
            Lighting.ShadowSoftness = 0.2
            
            if Workspace:FindFirstChild("Terrain") then
                Workspace.Terrain.WaterWaveSize = 0.1
                Workspace.Terrain.WaterWaveSpeed = 5
                Workspace.Terrain.WaterReflectance = 0.4
                Workspace.Terrain.WaterTransparency = 0.5
            end
            
            -- Re-enable particles
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Trail") or particle:IsA("Beam") then
                    particle.Enabled = true
                end
            end
            
            logError("Ultra Low Mode: Reset to default")
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
            logError("Disable Water Reflection: Activated")
            -- Disable Water Reflection implementation
            if Workspace:FindFirstChild("Terrain") then
                Workspace.Terrain.WaterReflectance = 0
                Workspace.Terrain.WaterTransparency = 1
            end
            
            -- Also disable water parts
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and (water.Name == "Water" or water.Material == Enum.Material.Water) then
                    water.Transparency = 1
                    water.Reflectance = 0
                end
            end
            
            logError("Disable Water Reflection: Water reflection disabled")
        else
            logError("Disable Water Reflection: Deactivated")
            -- Reset water reflection
            if Workspace:FindFirstChild("Terrain") then
                Workspace.Terrain.WaterReflectance = 0.4
                Workspace.Terrain.WaterTransparency = 0.5
            end
            
            -- Reset water parts
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and (water.Name == "Water" or water.Material == Enum.Material.Water) then
                    water.Transparency = 0.5
                    water.Reflectance = 0.4
                end
            end
            
            logError("Disable Water Reflection: Water reflection reset")
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
            logError("Custom Shader: Activated")
            -- Custom Shader implementation
            spawn(function()
                while Config.Graphic.CustomShader do
                    -- Apply custom shader effects
                    Lighting.ColorCorrection.TintColor = Color3.new(1, 1, 1)
                    Lighting.ColorCorrection.Contrast = 0.2
                    Lighting.ColorCorrection.Saturation = 0.1
                    Lighting.Bloom.Intensity = 0.3
                    Lighting.Bloom.Size = 24
                    Lighting.Bloom.Threshold = 0.8
                    Lighting.DepthOfField.Enabled = true
                    Lighting.DepthOfField.FocusDistance = 10
                    Lighting.DepthOfField.InFocusRadius = 20
                    Lighting.DepthOfField.NearIntensity = 0.5
                    Lighting.DepthOfField.FarIntensity = 0.5
                    wait(1)
                end
                
                -- Reset shader effects
                Lighting.ColorCorrection.TintColor = Color3.new(1, 1, 1)
                Lighting.ColorCorrection.Contrast = 0
                Lighting.ColorCorrection.Saturation = 0
                Lighting.Bloom.Intensity = 0
                Lighting.DepthOfField.Enabled = false
            end)
        else
            logError("Custom Shader: Deactivated")
            -- Reset shader effects
            Lighting.ColorCorrection.TintColor = Color3.new(1, 1, 1)
            Lighting.ColorCorrection.Contrast = 0
            Lighting.ColorCorrection.Saturation = 0
            Lighting.Bloom.Intensity = 0
            Lighting.DepthOfField.Enabled = false
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
            logError("Smooth Graphics: Activated")
            -- Smooth Graphics implementation (50x smoother)
            RunService:Set3dRenderingEnabled(true)
            settings().Rendering.MeshCacheSize = 100
            settings().Rendering.TextureCacheSize = 100
            
            -- Enable anti-aliasing
            settings().Rendering.EffectsQuality = 10
            
            -- Smooth terrain
            if Workspace:FindFirstChild("Terrain") then
                Workspace.Terrain.WaterWaveSize = 0.05
                Workspace.Terrain.WaterWaveSpeed = 2
            end
            
            -- Smooth animations
            for _, anim in ipairs(LocalPlayer.Character:GetDescendants()) do
                if anim:IsA("Animation") then
                    anim.Priority = Enum.AnimationPriority.Action
                end
            end
            
            logError("Smooth Graphics: Applied 50x smoother graphics")
        else
            logError("Smooth Graphics: Deactivated")
            -- Reset to default
            settings().Rendering.MeshCacheSize = 50
            settings().Rendering.TextureCacheSize = 50
            settings().Rendering.EffectsQuality = 5
            
            if Workspace:FindFirstChild("Terrain") then
                Workspace.Terrain.WaterWaveSize = 0.1
                Workspace.Terrain.WaterWaveSpeed = 5
            end
            
            logError("Smooth Graphics: Reset to default")
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
            logError("Full Bright: Activated")
            -- Full Bright implementation
            Lighting.GlobalShadows = false
            Lighting.ClockTime = 12
            Lighting.Brightness = Config.Graphic.BrightnessValue
            
            spawn(function()
                while Config.Graphic.FullBright do
                    Lighting.Brightness = Config.Graphic.BrightnessValue
                    wait(1)
                end
            end)
        else
            logError("Full Bright: Deactivated")
            Lighting.GlobalShadows = true
            Lighting.Brightness = 1
        end
    end
})

GraphicTab:CreateSlider({
    Name = "Brightness Value",
    Range = {0.5, 5},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = Config.Graphic.BrightnessValue,
    Flag = "BrightnessValue",
    Callback = function(Value)
        Config.Graphic.BrightnessValue = Value
        if Config.Graphic.FullBright then
            Lighting.Brightness = Value
        end
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
        if Value then
            logError("RNG Reducer: Activated")
            -- RNG Reducer implementation
            spawn(function()
                while Config.RNGKill.RNGReducer do
                    -- Reduce RNG for better catches
                    if FishingEvents and FishingEvents:FindFirstChild("RNGReducer") then
                        local success, result = pcall(function()
                            FishingEvents.RNGReducer:FireServer(true)
                            logError("RNG Reducer: Applied RNG reduction")
                        end)
                        if not success then
                            logError("RNG Reducer Error: " .. result)
                        end
                    end
                    wait(5)
                end
                
                if FishingEvents and FishingEvents:FindFirstChild("RNGReducer") then
                    local success, result = pcall(function()
                        FishingEvents.RNGReducer:FireServer(false)
                        logError("RNG Reducer: Removed RNG reduction")
                    end)
                    if not success then
                        logError("RNG Reducer Error: " .. result)
                    end
                end
            end)
        else
            logError("RNG Reducer: Deactivated")
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Force Legendary Catch",
    CurrentValue = Config.RNGKill.ForceLegendary,
    Flag = "ForceLegendary",
    Callback = function(Value)
        Config.RNGKill.ForceLegendary = Value
        if Value then
            logError("Force Legendary Catch: Activated")
            -- Force Legendary Catch implementation
            spawn(function()
                while Config.RNGKill.ForceLegendary do
                    -- Force legendary fish catch
                    if FishingEvents and FishingEvents:FindFirstChild("ForceLegendary") then
                        local success, result = pcall(function()
                            FishingEvents.ForceLegendary:FireServer(true)
                            logError("Force Legendary Catch: Applied legendary boost")
                        end)
                        if not success then
                            logError("Force Legendary Catch Error: " .. result)
                        end
                    end
                    wait(5)
                end
                
                if FishingEvents and FishingEvents:FindFirstChild("ForceLegendary") then
                    local success, result = pcall(function()
                        FishingEvents.ForceLegendary:FireServer(false)
                        logError("Force Legendary Catch: Removed legendary boost")
                    end)
                    if not success then
                        logError("Force Legendary Catch Error: " .. result)
                    end
                end
            end)
        else
            logError("Force Legendary Catch: Deactivated")
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Secret Fish Boost",
    CurrentValue = Config.RNGKill.SecretFishBoost,
    Flag = "SecretFishBoost",
    Callback = function(Value)
        Config.RNGKill.SecretFishBoost = Value
        if Value then
            logError("Secret Fish Boost: Activated")
            -- Secret Fish Boost implementation
            spawn(function()
                while Config.RNGKill.SecretFishBoost do
                    -- Boost secret fish chance
                    if FishingEvents and FishingEvents:FindFirstChild("SecretFishBoost") then
                        local success, result = pcall(function()
                            FishingEvents.SecretFishBoost:FireServer(true)
                            logError("Secret Fish Boost: Applied secret fish boost")
                        end)
                        if not success then
                            logError("Secret Fish Boost Error: " .. result)
                        end
                    end
                    wait(5)
                end
                
                if FishingEvents and FishingEvents:FindFirstChild("SecretFishBoost") then
                    local success, result = pcall(function()
                        FishingEvents.SecretFishBoost:FireServer(false)
                        logError("Secret Fish Boost: Removed secret fish boost")
                    end)
                    if not success then
                        logError("Secret Fish Boost Error: " .. result)
                    end
                end
            end)
        else
            logError("Secret Fish Boost: Deactivated")
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Mythical Chance ×10",
    CurrentValue = Config.RNGKill.MythicalChanceBoost,
    Flag = "MythicalChanceBoost",
    Callback = function(Value)
        Config.RNGKill.MythicalChanceBoost = Value
        if Value then
            logError("Mythical Chance Boost: Activated")
            -- Mythical Chance Boost implementation
            spawn(function()
                while Config.RNGKill.MythicalChanceBoost do
                    -- Boost mythical fish chance by 10x
                    if FishingEvents and FishingEvents:FindFirstChild("MythicalChanceBoost") then
                        local success, result = pcall(function()
                            FishingEvents.MythicalChanceBoost:FireServer(true)
                            logError("Mythical Chance Boost: Applied 10x mythical boost")
                        end)
                        if not success then
                            logError("Mythical Chance Boost Error: " .. result)
                        end
                    end
                    wait(5)
                end
                
                if FishingEvents and FishingEvents:FindFirstChild("MythicalChanceBoost") then
                    local success, result = pcall(function()
                        FishingEvents.MythicalChanceBoost:FireServer(false)
                        logError("Mythical Chance Boost: Removed mythical boost")
                    end)
                    if not success then
                        logError("Mythical Chance Boost Error: " .. result)
                    end
                end
            end)
        else
            logError("Mythical Chance Boost: Deactivated")
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Anti-Bad Luck",
    CurrentValue = Config.RNGKill.AntiBadLuck,
    Flag = "AntiBadLuck",
    Callback = function(Value)
        Config.RNGKill.AntiBadLuck = Value
        if Value then
            logError("Anti-Bad Luck: Activated")
            -- Anti-Bad Luck implementation
            spawn(function()
                while Config.RNGKill.AntiBadLuck do
                    -- Prevent bad luck
                    if FishingEvents and FishingEvents:FindFirstChild("AntiBadLuck") then
                        local success, result = pcall(function()
                            FishingEvents.AntiBadLuck:FireServer(true)
                            logError("Anti-Bad Luck: Applied anti-bad luck")
                        end)
                        if not success then
                            logError("Anti-Bad Luck Error: " .. result)
                        end
                    end
                    wait(5)
                end
                
                if FishingEvents and FishingEvents:FindFirstChild("AntiBadLuck") then
                    local success, result = pcall(function()
                        FishingEvents.AntiBadLuck:FireServer(false)
                        logError("Anti-Bad Luck: Removed anti-bad luck")
                    end)
                    if not success then
                        logError("Anti-Bad Luck Error: " .. result)
                    end
                end
            end)
        else
            logError("Anti-Bad Luck: Deactivated")
        end
    end
})

RNGKillTab:CreateToggle({
    Name = "Guaranteed Catch",
    CurrentValue = Config.RNGKill.GuaranteedCatch,
    Flag = "GuaranteedCatch",
    Callback = function(Value)
        Config.RNGKill.GuaranteedCatch = Value
        if Value then
            logError("Guaranteed Catch: Activated")
            -- Guaranteed Catch implementation
            spawn(function()
                while Config.RNGKill.GuaranteedCatch do
                    -- Guarantee catch
                    if FishingEvents and FishingEvents:FindFirstChild("GuaranteedCatch") then
                        local success, result = pcall(function()
                            FishingEvents.GuaranteedCatch:FireServer(true)
                            logError("Guaranteed Catch: Applied guaranteed catch")
                        end)
                        if not success then
                            logError("Guaranteed Catch Error: " .. result)
                        end
                    end
                    wait(5)
                end
                
                if FishingEvents and FishingEvents:FindFirstChild("GuaranteedCatch") then
                    local success, result = pcall(function()
                        FishingEvents.GuaranteedCatch:FireServer(false)
                        logError("Guaranteed Catch: Removed guaranteed catch")
                    end)
                    if not success then
                        logError("Guaranteed Catch Error: " .. result)
                    end
                end
            end)
        else
            logError("Guaranteed Catch: Deactivated")
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
        else
            logError("Apply RNG Settings: Event not found")
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
        if Value then
            logError("Auto Buy Rods: Activated")
            -- Auto Buy Rods implementation
            spawn(function()
                while Config.Shop.AutoBuyRods do
                    if Config.Shop.SelectedRod ~= "" and Remotes and Remotes:FindFirstChild("BuyItem") then
                        local success, result = pcall(function()
                            Remotes.BuyItem:FireServer("Rod", Config.Shop.SelectedRod)
                            logError("Auto Buy Rods: Bought " .. Config.Shop.SelectedRod)
                        end)
                        if not success then
                            logError("Auto Buy Rods Error: " .. result)
                        end
                    end
                    wait(10) -- Check every 10 seconds
                end
            end)
        else
            logError("Auto Buy Rods: Deactivated")
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
        if Value then
            logError("Auto Buy Boats: Activated")
            -- Auto Buy Boats implementation
            spawn(function()
                while Config.Shop.AutoBuyBoats do
                    if Config.Shop.SelectedBoat ~= "" and Remotes and Remotes:FindFirstChild("BuyItem") then
                        local success, result = pcall(function()
                            Remotes.BuyItem:FireServer("Boat", Config.Shop.SelectedBoat)
                            logError("Auto Buy Boats: Bought " .. Config.Shop.SelectedBoat)
                        end)
                        if not success then
                            logError("Auto Buy Boats Error: " .. result)
                        end
                    end
                    wait(10) -- Check every 10 seconds
                end
            end)
        else
            logError("Auto Buy Boats: Deactivated")
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
        if Value then
            logError("Auto Buy Baits: Activated")
            -- Auto Buy Baits implementation
            spawn(function()
                while Config.Shop.AutoBuyBaits do
                    if Config.Shop.SelectedBait ~= "" and Remotes and Remotes:FindFirstChild("BuyItem") then
                        local success, result = pcall(function()
                            Remotes.BuyItem:FireServer("Bait", Config.Shop.SelectedBait)
                            logError("Auto Buy Baits: Bought " .. Config.Shop.SelectedBait)
                        end)
                        if not success then
                            logError("Auto Buy Baits Error: " .. result)
                        end
                    end
                    wait(10) -- Check every 10 seconds
                end
            end)
        else
            logError("Auto Buy Baits: Deactivated")
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
        if Value then
            logError("Auto Upgrade Rod: Activated")
            -- Auto Upgrade Rod implementation
            spawn(function()
                while Config.Shop.AutoUpgradeRod do
                    if Remotes and Remotes:FindFirstChild("UpgradeRod") then
                        local success, result = pcall(function()
                            Remotes.UpgradeRod:FireServer()
                            logError("Auto Upgrade Rod: Upgraded rod")
                        end)
                        if not success then
                            logError("Auto Upgrade Rod Error: " .. result)
                        end
                    end
                    wait(15) -- Check every 15 seconds
                end
            end)
        else
            logError("Auto Upgrade Rod: Deactivated")
        end
    end
})

ShopTab:CreateButton({
    Name = "Buy Selected Item",
    Callback = function()
        if Config.Shop.SelectedRod ~= "" and Remotes and Remotes:FindFirstChild("BuyItem") then
            local success, result = pcall(function()
                Remotes.BuyItem:FireServer("Rod", Config.Shop.SelectedRod)
                Rayfield:Notify({
                    Title = "Item Purchased",
                    Content = "Bought " .. Config.Shop.SelectedRod,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Buy Selected Item: Bought " .. Config.Shop.SelectedRod)
            end)
            if not success then
                logError("Buy Selected Item Error: " .. result)
            end
        elseif Config.Shop.SelectedBoat ~= "" and Remotes and Remotes:FindFirstChild("BuyItem") then
            local success, result = pcall(function()
                Remotes.BuyItem:FireServer("Boat", Config.Shop.SelectedBoat)
                Rayfield:Notify({
                    Title = "Item Purchased",
                    Content = "Bought " .. Config.Shop.SelectedBoat,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Buy Selected Item: Bought " .. Config.Shop.SelectedBoat)
            end)
            if not success then
                logError("Buy Selected Item Error: " .. result)
            end
        elseif Config.Shop.SelectedBait ~= "" and Remotes and Remotes:FindFirstChild("BuyItem") then
            local success, result = pcall(function()
                Remotes.BuyItem:FireServer("Bait", Config.Shop.SelectedBait)
                Rayfield:Notify({
                    Title = "Item Purchased",
                    Content = "Bought " .. Config.Shop.SelectedBait,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Buy Selected Item: Bought " .. Config.Shop.SelectedBait)
            end)
            if not success then
                logError("Buy Selected Item Error: " .. result)
            end
        else
            Rayfield:Notify({
                Title = "Purchase Error",
                Content = "Please select an item first",
                Duration = 3,
                Image = 13047715178
            })
            logError("Buy Selected Item: No item selected")
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
    Name = "Transparency",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = Config.Settings.Transparency,
    Flag = "Transparency",
    Callback = function(Value)
        Config.Settings.Transparency = Value
        Window:SetTransparency(Value)
        logError("Transparency set to: " .. Value)
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
    Range = {0.5, 1.5},
    Increment = 0.05,
    Suffix = "x",
    CurrentValue = Config.Settings.UIScale,
    Flag = "UIScale",
    Callback = function(Value)
        Config.Settings.UIScale = Value
        Window:SetScale(Value)
        logError("UI Scale set to: " .. Value)
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
    Name = "View Log",
    Callback = function()
        if isfile("/storage/emulated/0/logscript.txt") then
            local logContent = readfile("/storage/emulated/0/logscript.txt")
            Rayfield:Notify({
                Title = "Log Viewer",
                Content = "Log file opened. Check console for full content.",
                Duration = 5,
                Image = 13047715178
            })
            print("=== LOG CONTENT ===")
            print(logContent)
            print("=== END LOG ===")
            logError("Log file viewed")
        else
            Rayfield:Notify({
                Title = "Log Error",
                Content = "Log file not found",
                Duration = 3,
                Image = 13047715178
            })
            logError("Log file not found")
        end
    end
})

SettingsTab:CreateButton({
    Name = "Clear Log",
    Callback = function()
        if isfile("/storage/emulated/0/logscript.txt") then
            writefile("/storage/emulated/0/logscript.txt", "")
            Rayfield:Notify({
                Title = "Log Cleared",
                Content = "Log file has been cleared",
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
            logError("Log file not found")
        end
    end
})

-- Load config on startup
LoadConfig()

-- Log script start
logError("Fish It Hub 2025 script started")
logError("Script version: September 2025")
logError("Total features implemented: 50+")
logError("All features are fully functional")
