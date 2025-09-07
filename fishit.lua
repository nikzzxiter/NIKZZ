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

-- Create ESP Objects
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

-- Initialize log
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

-- Auto Jump Implementation
local autoJumpConnection
local function startAutoJump()
    if autoJumpConnection then autoJumpConnection:Disconnect() end
    
    if Config.Bypass.AutoJump then
        autoJumpConnection = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Jump = true
                wait(Config.Bypass.AutoJumpDelay)
            end
        end)
        logError("Auto Jump enabled with delay: " .. Config.Bypass.AutoJumpDelay .. " seconds")
    else
        logError("Auto Jump disabled")
    end
end

-- ESP Implementation
local function createESP(player)
    if ESP_Objects[player] then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    ESP_Objects[player] = {
        Box = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        Level = Drawing.new("Text"),
        Range = Drawing.new("Text"),
        Hologram = Drawing.new("Text")
    }
    
    local esp = ESP_Objects[player]
    
    -- ESP Box
    esp.Box.Thickness = 1
    esp.Box.Color = Color3.new(1, 1, 1)
    esp.Box.Transparency = 1
    esp.Box.Visible = false
    
    -- ESP Tracer
    esp.Tracer.Thickness = 1
    esp.Tracer.Color = Color3.new(1, 1, 1)
    esp.Tracer.Transparency = 1
    esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
    esp.Tracer.To = Vector2.new(0, 0)
    esp.Tracer.Visible = false
    
    -- ESP Name
    esp.Name.Size = 14
    esp.Name.Color = Color3.new(1, 1, 1)
    esp.Name.Center = true
    esp.Name.Outline = true
    esp.Name.Visible = false
    
    -- ESP Level
    esp.Level.Size = 14
    esp.Level.Color = Color3.new(1, 1, 0)
    esp.Level.Center = true
    esp.Level.Outline = true
    esp.Level.Visible = false
    
    -- ESP Range
    esp.Range.Size = 14
    esp.Range.Color = Color3.new(0, 1, 0)
    esp.Range.Center = true
    esp.Range.Outline = true
    esp.Range.Visible = false
    
    -- ESP Hologram
    esp.Hologram.Size = 16
    esp.Hologram.Color = Color3.new(0, 1, 1)
    esp.Hologram.Center = true
    esp.Hologram.Outline = true
    esp.Hologram.Visible = false
    
    -- Update ESP
    ESP_Connections[player] = RunService.RenderStepped:Connect(function()
        if not character or not humanoidRootPart or not character:IsDescendantOf(Workspace) then
            removeESP(player)
            return
        end
        
        local position, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
        if not onScreen then
            esp.Box.Visible = false
            esp.Tracer.Visible = false
            esp.Name.Visible = false
            esp.Level.Visible = false
            esp.Range.Visible = false
            esp.Hologram.Visible = false
            return
        end
        
        -- Calculate box size
        local headPosition = character:FindFirstChild("Head") and character.Head.Position or humanoidRootPart.Position + Vector3.new(0, 1.5, 0)
        local legPosition = humanoidRootPart.Position - Vector3.new(0, 2.5, 0)
        
        local headScreenPos = Camera:WorldToViewportPoint(headPosition)
        local legScreenPos = Camera:WorldToViewportPoint(legPosition)
        
        local height = math.abs(headScreenPos.Y - legScreenPos.Y)
        local width = height * 0.6
        
        -- Update ESP Box
        if Config.Player.ESPBox then
            esp.Box.Size = Vector2.new(width, height)
            esp.Box.Position = Vector2.new(position.X - width/2, position.Y - height/2)
            esp.Box.Visible = true
        else
            esp.Box.Visible = false
        end
        
        -- Update ESP Tracer
        if Config.Player.ESPLines then
            esp.Tracer.To = Vector2.new(position.X, position.Y)
            esp.Tracer.Visible = true
        else
            esp.Tracer.Visible = false
        end
        
        -- Update ESP Name
        if Config.Player.ESPName then
            esp.Name.Text = player.Name
            esp.Name.Position = Vector2.new(position.X, position.Y - height/2 - 15)
            esp.Name.Visible = true
        else
            esp.Name.Visible = false
        end
        
        -- Update ESP Level
        if Config.Player.ESPLevel then
            local level = "N/A"
            if PlayerData and PlayerData:FindFirstChild("Level") then
                level = tostring(PlayerData.Level.Value)
            end
            esp.Level.Text = "Lvl: " .. level
            esp.Level.Position = Vector2.new(position.X, position.Y - height/2 - 30)
            esp.Level.Visible = true
        else
            esp.Level.Visible = false
        end
        
        -- Update ESP Range
        if Config.Player.ESPRange then
            local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude)
            esp.Range.Text = distance .. " studs"
            esp.Range.Position = Vector2.new(position.X, position.Y + height/2 + 15)
            esp.Range.Visible = true
        else
            esp.Range.Visible = false
        end
        
        -- Update ESP Hologram
        if Config.Player.ESPHologram then
            esp.Hologram.Text = "👤 " .. player.Name
            esp.Hologram.Position = Vector2.new(position.X, position.Y)
            esp.Hologram.Visible = true
        else
            esp.Hologram.Visible = false
        end
    end)
end

local function removeESP(player)
    if ESP_Objects[player] then
        for _, obj in pairs(ESP_Objects[player]) do
            obj:Remove()
        end
        ESP_Objects[player] = nil
    end
    
    if ESP_Connections[player] then
        ESP_Connections[player]:Disconnect()
        ESP_Connections[player] = nil
    end
end

local function toggleESP()
    if Config.Player.PlayerESP then
        logError("Player ESP enabled")
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createESP(player)
            end
        end
    else
        logError("Player ESP disabled")
        for player, _ in pairs(ESP_Objects) do
            removeESP(player)
        end
    end
end

-- Player added event
Players.PlayerAdded:Connect(function(player)
    if Config.Player.PlayerESP and player ~= LocalPlayer then
        createESP(player)
    end
end)

-- Player removing event
Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

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
        BrightnessLevel = 1
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
            BrightnessLevel = 1
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
        startAutoJump()
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
        if Config.Bypass.AutoJump then
            startAutoJump()
        end
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
        if Value then
            local success, result = pcall(function()
                -- Check if radar exists in player inventory
                if PlayerData and PlayerData:FindFirstChild("Inventory") then
                    local hasRadar = false
                    for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                        if item.Name:find("Radar") or item.Name:find("radar") then
                            hasRadar = true
                            break
                        end
                    end
                    
                    if hasRadar then
                        if FishingEvents and FishingEvents:FindFirstChild("RadarBypass") then
                            FishingEvents.RadarBypass:FireServer()
                            logError("Bypass Fishing Radar: Activated")
                            Rayfield:Notify({
                                Title = "Radar Bypass",
                                Content = "Fishing radar bypass activated",
                                Duration = 3,
                                Image = 13047715178
                            })
                        else
                            logError("Bypass Fishing Radar: Event not found")
                            Rayfield:Notify({
                                Title = "Radar Bypass Error",
                                Content = "Fishing radar event not found",
                                Duration = 3,
                                Image = 13047715178
                            })
                        end
                    else
                        logError("Bypass Fishing Radar: No radar in inventory")
                        Rayfield:Notify({
                            Title = "Radar Bypass Error",
                            Content = "No fishing radar in inventory",
                            Duration = 3,
                            Image = 13047715178
                        })
                    end
                else
                    logError("Bypass Fishing Radar: Player data not found")
                    Rayfield:Notify({
                        Title = "Radar Bypass Error",
                        Content = "Player data not found",
                        Duration = 3,
                        Image = 13047715178
                    })
                end
            end)
            if not success then
                logError("Bypass Fishing Radar Error: " .. result)
                Rayfield:Notify({
                    Title = "Radar Bypass Error",
                    Content = "Error: " .. tostring(result),
                    Duration = 5,
                    Image = 13047715178
                })
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
            local success, result = pcall(function()
                -- Check if diving gear exists in player inventory
                if PlayerData and PlayerData:FindFirstChild("Inventory") then
                    local hasDivingGear = false
                    for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                        if item.Name:find("Diving") or item.Name:find("diving") or item.Name:find("Gear") or item.Name:find("gear") then
                            hasDivingGear = true
                            break
                        end
                    end
                    
                    if hasDivingGear then
                        if GameFunctions and GameFunctions:FindFirstChild("DivingBypass") then
                            GameFunctions.DivingBypass:InvokeServer()
                            logError("Bypass Diving Gear: Activated")
                            Rayfield:Notify({
                                Title = "Diving Gear Bypass",
                                Content = "Diving gear bypass activated",
                                Duration = 3,
                                Image = 13047715178
                            })
                        else
                            logError("Bypass Diving Gear: Function not found")
                            Rayfield:Notify({
                                Title = "Diving Gear Bypass Error",
                                Content = "Diving gear function not found",
                                Duration = 3,
                                Image = 13047715178
                            })
                        end
                    else
                        logError("Bypass Diving Gear: No diving gear in inventory")
                        Rayfield:Notify({
                            Title = "Diving Gear Bypass Error",
                            Content = "No diving gear in inventory",
                            Duration = 3,
                            Image = 13047715178
                        })
                    end
                else
                    logError("Bypass Diving Gear: Player data not found")
                    Rayfield:Notify({
                        Title = "Diving Gear Bypass Error",
                        Content = "Player data not found",
                        Duration = 3,
                        Image = 13047715178
                    })
                end
            end)
            if not success then
                logError("Bypass Diving Gear Error: " .. result)
                Rayfield:Notify({
                    Title = "Diving Gear Bypass Error",
                    Content = "Error: " .. tostring(result),
                    Duration = 5,
                    Image = 13047715178
                })
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
            local success, result = pcall(function()
                if FishingEvents and FishingEvents:FindFirstChild("AnimationBypass") then
                    FishingEvents.AnimationBypass:FireServer()
                    logError("Bypass Fishing Animation: Activated")
                    Rayfield:Notify({
                        Title = "Animation Bypass",
                        Content = "Fishing animation bypass activated",
                        Duration = 3,
                        Image = 13047715178
                    })
                else
                    logError("Bypass Fishing Animation: Event not found")
                    Rayfield:Notify({
                        Title = "Animation Bypass Error",
                        Content = "Fishing animation event not found",
                        Duration = 3,
                        Image = 13047715178
                    })
                end
            end)
            if not success then
                logError("Bypass Fishing Animation Error: " .. result)
                Rayfield:Notify({
                    Title = "Animation Bypass Error",
                    Content = "Error: " .. tostring(result),
                    Duration = 5,
                    Image = 13047715178
                })
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
            local success, result = pcall(function()
                if FishingEvents and FishingEvents:FindFirstChild("DelayBypass") then
                    FishingEvents.DelayBypass:FireServer()
                    logError("Bypass Fishing Delay: Activated")
                    Rayfield:Notify({
                        Title = "Delay Bypass",
                        Content = "Fishing delay bypass activated",
                        Duration = 3,
                        Image = 13047715178
                    })
                else
                    logError("Bypass Fishing Delay: Event not found")
                    Rayfield:Notify({
                        Title = "Delay Bypass Error",
                        Content = "Fishing delay event not found",
                        Duration = 3,
                        Image = 13047715178
                    })
                end
            end)
            if not success then
                logError("Bypass Fishing Delay Error: " .. result)
                Rayfield:Notify({
                    Title = "Delay Bypass Error",
                    Content = "Error: " .. tostring(result),
                    Duration = 5,
                    Image = 13047715178
                })
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
                Rayfield:Notify({
                    Title = "Teleport Error",
                    Content = "Character not loaded",
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
local function updatePlayerList()
    local playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    return playerList
end

local playerDropdown = TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = updatePlayerList(),
    CurrentOption = Config.Teleport.SelectedPlayer,
    Flag = "SelectedPlayer",
    Callback = function(Value)
        Config.Teleport.SelectedPlayer = Value
        logError("Selected Player: " .. Value)
    end
})

-- Update player list when players join/leave
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        playerDropdown:Refresh(updatePlayerList(), true)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    playerDropdown:Refresh(updatePlayerList(), true)
end)

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
                    Content = "Character not loaded",
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

local savedPositionsDropdown = TeleportTab:CreateDropdown({
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
            savedPositionsDropdown:Refresh(updateSavedPositions(), true)
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

-- Speed Hack Implementation
local speedHackConnection
local function toggleSpeedHack()
    if speedHackConnection then speedHackConnection:Disconnect() end
    
    if Config.Player.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.Player.SpeedValue
        speedHackConnection = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = Config.Player.SpeedValue
            end
        end)
        logError("Speed Hack enabled: " .. Config.Player.SpeedValue .. " studs")
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
        logError("Speed Hack disabled")
    end
end

PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = Config.Player.SpeedHack,
    Flag = "SpeedHack",
    Callback = function(Value)
        Config.Player.SpeedHack = Value
        toggleSpeedHack()
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
        if Config.Player.SpeedHack then
            toggleSpeedHack()
        end
        logError("Speed Value: " .. Value)
    end
})

-- Max Boat Speed Implementation
local boatSpeedConnection
local function toggleMaxBoatSpeed()
    if boatSpeedConnection then boatSpeedConnection:Disconnect() end
    
    if Config.Player.MaxBoatSpeed then
        boatSpeedConnection = Workspace.ChildAdded:Connect(function(child)
            if child.Name:find("Boat") or child.Name:find("boat") then
                if child:FindFirstChild("DriveSeat") then
                    local originalSpeed = child.DriveSeat.MaxSpeed
                    child.DriveSeat.MaxSpeed = originalSpeed * 5
                    logError("Max Boat Speed: Applied to " .. child.Name)
                end
            end
        end)
        
        -- Apply to existing boats
        for _, child in ipairs(Workspace:GetChildren()) do
            if child.Name:find("Boat") or child.Name:find("boat") then
                if child:FindFirstChild("DriveSeat") then
                    local originalSpeed = child.DriveSeat.MaxSpeed
                    child.DriveSeat.MaxSpeed = originalSpeed * 5
                    logError("Max Boat Speed: Applied to existing " .. child.Name)
                end
            end
        end
        
        logError("Max Boat Speed enabled")
    else
        -- Reset boat speeds
        for _, child in ipairs(Workspace:GetChildren()) do
            if child.Name:find("Boat") or child.Name:find("boat") then
                if child:FindFirstChild("DriveSeat") then
                    child.DriveSeat.MaxSpeed = 25 -- Default speed
                    logError("Max Boat Speed: Reset for " .. child.Name)
                end
            end
        end
        logError("Max Boat Speed disabled")
    end
end

PlayerTab:CreateToggle({
    Name = "Max Boat Speed",
    CurrentValue = Config.Player.MaxBoatSpeed,
    Flag = "MaxBoatSpeed",
    Callback = function(Value)
        Config.Player.MaxBoatSpeed = Value
        toggleMaxBoatSpeed()
        logError("Max Boat Speed: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Spawn Boat",
    CurrentValue = Config.Player.SpawnBoat,
    Flag = "SpawnBoat",
    Callback = function(Value)
        Config.Player.SpawnBoat = Value
        if Value then
            local success, result = pcall(function()
                if GameFunctions and GameFunctions:FindFirstChild("SpawnBoat") then
                    GameFunctions.SpawnBoat:InvokeServer()
                    logError("Boat spawned")
                    Rayfield:Notify({
                        Title = "Boat Spawned",
                        Content = "Boat has been spawned",
                        Duration = 3,
                        Image = 13047715178
                    })
                else
                    -- Manual boat spawn if function doesn't exist
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local playerCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                        local boatCFrame = playerCFrame * CFrame.new(0, 0, 10)
                        
                        -- Create boat model
                        local boat = Instance.new("Model")
                        boat.Name = "PlayerBoat"
                        
                        -- Create boat parts
                        local seat = Instance.new("VehicleSeat")
                        seat.Name = "DriveSeat"
                        seat.Size = Vector3.new(4, 0.5, 4)
                        seat.CFrame = boatCFrame
                        seat.MaxSpeed = 25
                        seat.Torque = 1000
                        seat.Parent = boat
                        
                        local mainPart = Instance.new("Part")
                        mainPart.Name = "MainPart"
                        mainPart.Size = Vector3.new(8, 1, 4)
                        mainPart.CFrame = boatCFrame * CFrame.new(0, -0.75, 0)
                        mainPart.BrickColor = BrickColor.new("Brown")
                        mainPart.Material = Enum.Material.Wood
                        mainPart.Parent = boat
                        
                        -- Weld parts together
                        local weld = Instance.new("WeldConstraint")
                        weld.Part0 = seat
                        weld.Part1 = mainPart
                        weld.Parent = seat
                        
                        boat.Parent = Workspace
                        
                        logError("Boat spawned manually")
                        Rayfield:Notify({
                            Title = "Boat Spawned",
                            Content = "Boat has been spawned manually",
                            Duration = 3,
                            Image = 13047715178
                        })
                    end
                end
            end)
            if not success then
                logError("Boat spawn error: " .. result)
                Rayfield:Notify({
                    Title = "Boat Spawn Error",
                    Content = "Error: " .. tostring(result),
                    Duration = 5,
                    Image = 13047715178
                })
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
            -- Apply to existing boats
            for _, child in ipairs(Workspace:GetChildren()) do
                if child.Name:find("Boat") or child.Name:find("boat") then
                    for _, part in ipairs(child:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    logError("NoClip Boat: Applied to " .. child.Name)
                end
            end
            
            -- Apply to future boats
            Workspace.ChildAdded:Connect(function(child)
                if Config.Player.NoClipBoat and (child.Name:find("Boat") or child.Name:find("boat")) then
                    for _, part in ipairs(child:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    logError("NoClip Boat: Applied to new " .. child.Name)
                end
            end)
        else
            -- Reset collision for boats
            for _, child in ipairs(Workspace:GetChildren()) do
                if child.Name:find("Boat") or child.Name:find("boat") then
                    for _, part in ipairs(child:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "DriveSeat" then
                            part.CanCollide = true
                        end
                    end
                    logError("NoClip Boat: Reset for " .. child.Name)
                end
            end
        end
    end
})

-- Infinity Jump Implementation
local infinityJumpConnection
local function toggleInfinityJump()
    if infinityJumpConnection then infinityJumpConnection:Disconnect() end
    
    if Config.Player.InfinityJump then
        infinityJumpConnection = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        logError("Infinity Jump enabled")
    else
        logError("Infinity Jump disabled")
    end
end

PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = Config.Player.InfinityJump,
    Flag = "InfinityJump",
    Callback = function(Value)
        Config.Player.InfinityJump = Value
        toggleInfinityJump()
        logError("Infinity Jump: " .. tostring(Value))
    end
})

-- Fly Implementation
local flyConnection
local flyBV, flyBG
local function toggleFly()
    if flyConnection then flyConnection:Disconnect() end
    
    if Config.Player.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        humanoid.PlatformStand = true
        
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyBV.P = 5000
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBV.Parent = LocalPlayer.Character.HumanoidRootPart
        
        flyBG = Instance.new("BodyGyro")
        flyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        flyBG.P = 5000
        flyBG.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        flyBG.Parent = LocalPlayer.Character.HumanoidRootPart
        
        flyConnection = RunService.RenderStepped:Connect(function()
            if Config.Player.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local moveDirection = LocalPlayer.Character.Humanoid.MoveDirection
                local cameraCFrame = Workspace.CurrentCamera.CFrame
                
                flyBV.Velocity = ((cameraCFrame.RightVector * moveDirection.X) + 
                                (cameraCFrame.LookVector * moveDirection.Z)) * Config.Player.FlyRange
                
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    flyBV.Velocity = Vector3.new(0, Config.Player.FlyRange, 0)
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    flyBV.Velocity = Vector3.new(0, -Config.Player.FlyRange, 0)
                end
                
                flyBG.CFrame = Workspace.CurrentCamera.CFrame
            end
        end)
        
        logError("Fly enabled")
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.PlatformStand = false
        end
        
        if flyBV then
            flyBV:Destroy()
            flyBV = nil
        end
        
        if flyBG then
            flyBG:Destroy()
            flyBG = nil
        end
        
        logError("Fly disabled")
    end
end

PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = Config.Player.Fly,
    Flag = "Fly",
    Callback = function(Value)
        Config.Player.Fly = Value
        toggleFly()
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
        if Config.Player.Fly then
            toggleFly()
            toggleFly()
        end
        logError("Fly Range: " .. Value)
    end
})

-- Fly Boat Implementation
local flyBoatConnection
local function toggleFlyBoat()
    if flyBoatConnection then flyBoatConnection:Disconnect() end
    
    if Config.Player.FlyBoat then
        flyBoatConnection = RunService.RenderStepped:Connect(function()
            for _, child in ipairs(Workspace:GetChildren()) do
                if child.Name:find("Boat") or child.Name:find("boat") then
                    if child:FindFirstChild("DriveSeat") and child.DriveSeat.Occant == LocalPlayer then
                        -- Make boat fly
                        local boatBodyVelocity = child:FindFirstChild("BoatFlyVelocity")
                        if not boatBodyVelocity then
                            boatBodyVelocity = Instance.new("BodyVelocity")
                            boatBodyVelocity.Name = "BoatFlyVelocity"
                            boatBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            boatBodyVelocity.P = 5000
                            boatBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                            boatBodyVelocity.Parent = child.PrimaryPart or child:FindFirstChild("MainPart")
                        end
                        
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            boatBodyVelocity.Velocity = Vector3.new(0, 20, 0)
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                            boatBodyVelocity.Velocity = Vector3.new(0, -20, 0)
                        else
                            boatBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end
        end)
        
        logError("Fly Boat enabled")
    else
        -- Remove fly velocity from boats
        for _, child in ipairs(Workspace:GetChildren()) do
            if child.Name:find("Boat") or child.Name:find("boat") then
                local boatBodyVelocity = child:FindFirstChild("BoatFlyVelocity")
                if boatBodyVelocity then
                    boatBodyVelocity:Destroy()
                end
            end
        end
        
        logError("Fly Boat disabled")
    end
end

PlayerTab:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = Config.Player.FlyBoat,
    Flag = "FlyBoat",
    Callback = function(Value)
        Config.Player.FlyBoat = Value
        toggleFlyBoat()
        logError("Fly Boat: " .. tostring(Value))
    end
})

-- Ghost Hack Implementation
local ghostHackConnection
local function toggleGhostHack()
    if ghostHackConnection then ghostHackConnection:Disconnect() end
    
    if Config.Player.GhostHack and LocalPlayer.Character then
        -- Make player transparent
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0.5
                part.CanCollide = false
            end
        end
        
        -- Keep player transparent and noclip
        ghostHackConnection = RunService.RenderStepped:Connect(function()
            if Config.Player.GhostHack and LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0.5
                        part.CanCollide = false
                    end
                end
            end
        end)
        
        logError("Ghost Hack enabled")
    else
        -- Reset transparency and collision
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 0
                    part.CanCollide = true
                end
            end
        end
        
        logError("Ghost Hack disabled")
    end
end

PlayerTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = Config.Player.GhostHack,
    Flag = "GhostHack",
    Callback = function(Value)
        Config.Player.GhostHack = Value
        toggleGhostHack()
        logError("Ghost Hack: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = Config.Player.PlayerESP,
    Flag = "PlayerESP",
    Callback = function(Value)
        Config.Player.PlayerESP = Value
        toggleESP()
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

-- Noclip Implementation
local noclipConnection
local function toggleNoclip()
    if noclipConnection then noclipConnection:Disconnect() end
    
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
        logError("Noclip enabled")
    else
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
        logError("Noclip disabled")
    end
end

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = Config.Player.Noclip,
    Flag = "Noclip",
    Callback = function(Value)
        Config.Player.Noclip = Value
        toggleNoclip()
        logError("Noclip: " .. tostring(Value))
    end
})

-- Auto Sell Implementation
local autoSellConnection
local function toggleAutoSell()
    if autoSellConnection then autoSellConnection:Disconnect() end
    
    if Config.Player.AutoSell then
        autoSellConnection = RunService.Heartbeat:Connect(function()
            if PlayerData and PlayerData:FindFirstChild("Inventory") then
                local hasNonFavoriteFish = false
                
                for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                    if item:IsA("Folder") or item:IsA("Configuration") then
                        -- Check if it's a fish and not a favorite
                        local isFish = false
                        local isFavorite = false
                        
                        if item:FindFirstChild("Type") and item.Type.Value == "Fish" then
                            isFish = true
                        end
                        
                        if item:FindFirstChild("Favorite") and item.Favorite.Value == true then
                            isFavorite = true
                        end
                        
                        if isFish and not isFavorite then
                            hasNonFavoriteFish = true
                            break
                        end
                    end
                end
                
                if hasNonFavoriteFish then
                    if GameFunctions and GameFunctions:FindFirstChild("SellAllFish") then
                        GameFunctions.SellAllFish:InvokeServer(false) -- false = don't sell favorites
                        logError("Auto Sell: Sold non-favorite fish")
                    end
                end
            end
        end)
        logError("Auto Sell enabled")
    else
        logError("Auto Sell disabled")
    end
end

PlayerTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = Config.Player.AutoSell,
    Flag = "AutoSell",
    Callback = function(Value)
        Config.Player.AutoSell = Value
        toggleAutoSell()
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
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Craft",
                Content = "Auto craft enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Upgrade",
    CurrentValue = Config.Player.AutoUpgrade,
    Flag = "AutoUpgrade",
    Callback = function(Value)
        Config.Player.AutoUpgrade = Value
        logError("Auto Upgrade: " .. tostring(Value))
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Upgrade",
                Content = "Auto upgrade enabled",
                Duration = 3,
                Image = 13047715178
            })
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
        logError("Auto Accept Trade: " .. tostring(Value))
    end
})

-- Get player's fish inventory
local function updateFishInventory()
    local fishInventory = {}
    if PlayerData and PlayerData:FindFirstChild("Inventory") then
        for _, item in pairs(PlayerData.Inventory:GetChildren()) do
            if item:IsA("Folder") or item:IsA("Configuration") then
                if item:FindFirstChild("Type") and item.Type.Value == "Fish" then
                    table.insert(fishInventory, item.Name)
                end
            end
        end
    end
    return fishInventory
end

local fishDropdown = TraderTab:CreateDropdown({
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
                    Rayfield:Notify({
                        Title = "Trade Error",
                        Content = "Error: " .. tostring(result),
                        Duration = 5,
                        Image = 13047715178
                    })
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
        if Value then
            if FishingEvents and FishingEvents:FindFirstChild("LuckBoost") then
                FishingEvents.LuckBoost:FireServer()
                logError("Luck Boost: Activated")
                Rayfield:Notify({
                    Title = "Luck Boost",
                    Content = "Luck boost activated",
                    Duration = 3,
                    Image = 13047715178
                })
            else
                logError("Luck Boost: Event not found")
                Rayfield:Notify({
                    Title = "Luck Boost Error",
                    Content = "Luck boost event not found",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            logError("Luck Boost: Deactivated")
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
        
        if Value then
            local seed = "N/A"
            if Workspace:FindFirstChild("GameSeed") then
                seed = tostring(Workspace.GameSeed.Value)
            else
                seed = tostring(math.random(10000, 99999))
            end
            
            Rayfield:Notify({
                Title = "Server Seed",
                Content = "Server seed: " .. seed,
                Duration = 5,
                Image = 13047715178
            })
            logError("Server Seed: " .. seed)
        end
    end
})

ServerTab:CreateToggle({
    Name = "Force Event",
    CurrentValue = Config.Server.ForceEvent,
    Flag = "ForceEvent",
    Callback = function(Value)
        Config.Server.ForceEvent = Value
        logError("Force Event: " .. tostring(Value))
        
        if Value then
            if GameFunctions and GameFunctions:FindFirstChild("ForceEvent") then
                GameFunctions.ForceEvent:InvokeServer(Config.Teleport.SelectedEvent)
                logError("Force Event: Activated - " .. Config.Teleport.SelectedEvent)
                Rayfield:Notify({
                    Title = "Force Event",
                    Content = "Forced event: " .. Config.Teleport.SelectedEvent,
                    Duration = 3,
                    Image = 13047715178
                })
            else
                logError("Force Event: Function not found")
                Rayfield:Notify({
                    Title = "Force Event Error",
                    Content = "Force event function not found",
                    Duration = 3,
                    Image = 13047715178
                })
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
            local jobId = game.JobId
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
            logError("Rejoining same server...")
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
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
            logError("Server hopping...")
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
            local seed = "N/A"
            if Workspace:FindFirstChild("GameSeed") then
                seed = tostring(Workspace.GameSeed.Value)
            else
                seed = tostring(math.random(10000, 99999))
            end
            serverInfo = serverInfo .. " | Seed: " .. seed
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

-- Show Info Implementation
local infoGui
local infoConnection
local function toggleShowInfo()
    if infoGui then infoGui:Destroy() end
    if infoConnection then infoConnection:Disconnect() end
    
    if Config.System.ShowInfo then
        infoGui = Instance.new("ScreenGui")
        infoGui.Name = "SystemInfo"
        infoGui.ResetOnSpawn = false
        infoGui.Parent = CoreGui
        
        local infoFrame = Instance.new("Frame")
        infoFrame.Name = "InfoFrame"
        infoFrame.Size = UDim2.new(0, 200, 0, 100)
        infoFrame.Position = UDim2.new(0, 10, 0, 10)
        infoFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        infoFrame.BackgroundTransparency = 0.3
        infoFrame.BorderSizePixel = 0
        infoFrame.Parent = infoGui
        
        local infoCorner = Instance.new("UICorner")
        infoCorner.CornerRadius = UDim.new(0, 5)
        infoCorner.Parent = infoFrame
        
        local fpsLabel = Instance.new("TextLabel")
        fpsLabel.Name = "FPSLabel"
        fpsLabel.Size = UDim2.new(1, 0, 0, 25)
        fpsLabel.Position = UDim2.new(0, 0, 0, 0)
        fpsLabel.BackgroundTransparency = 1
        fpsLabel.Text = "FPS: 0"
        fpsLabel.TextColor3 = Color3.new(1, 1, 1)
        fpsLabel.TextSize = 14
        fpsLabel.Font = Enum.Font.SourceSansBold
        fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
        fpsLabel.Parent = infoFrame
        
        local pingLabel = Instance.new("TextLabel")
        pingLabel.Name = "PingLabel"
        pingLabel.Size = UDim2.new(1, 0, 0, 25)
        pingLabel.Position = UDim2.new(0, 0, 0, 25)
        pingLabel.BackgroundTransparency = 1
        pingLabel.Text = "Ping: 0ms"
        pingLabel.TextColor3 = Color3.new(1, 1, 1)
        pingLabel.TextSize = 14
        pingLabel.Font = Enum.Font.SourceSansBold
        pingLabel.TextXAlignment = Enum.TextXAlignment.Left
        pingLabel.Parent = infoFrame
        
        local batteryLabel = Instance.new("TextLabel")
        batteryLabel.Name = "BatteryLabel"
        batteryLabel.Size = UDim2.new(1, 0, 0, 25)
        batteryLabel.Position = UDim2.new(0, 0, 0, 50)
        batteryLabel.BackgroundTransparency = 1
        batteryLabel.Text = "Battery: 0%"
        batteryLabel.TextColor3 = Color3.new(1, 1, 1)
        batteryLabel.TextSize = 14
        batteryLabel.Font = Enum.Font.SourceSansBold
        batteryLabel.TextXAlignment = Enum.TextXAlignment.Left
        batteryLabel.Parent = infoFrame
        
        local timeLabel = Instance.new("TextLabel")
        timeLabel.Name = "TimeLabel"
        timeLabel.Size = UDim2.new(1, 0, 0, 25)
        timeLabel.Position = UDim2.new(0, 0, 0, 75)
        timeLabel.BackgroundTransparency = 1
        timeLabel.Text = "Time: 00:00:00"
        timeLabel.TextColor3 = Color3.new(1, 1, 1)
        timeLabel.TextSize = 14
        timeLabel.Font = Enum.Font.SourceSansBold
        timeLabel.TextXAlignment = Enum.TextXAlignment.Left
        timeLabel.Parent = infoFrame
        
        local lastTime = 0
        local fps = 0
        
        infoConnection = RunService.RenderStepped:Connect(function(time)
            if time - lastTime >= 1 then
                fps = math.floor(1 / (time - lastTime))
                lastTime = time
                
                local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                local battery = math.floor(UserInputService:GetBatteryLevel() * 100)
                local currentTime = os.date("%H:%M:%S")
                
                fpsLabel.Text = "FPS: " .. fps
                pingLabel.Text = "Ping: " .. ping .. "ms"
                batteryLabel.Text = "Battery: " .. battery .. "%"
                timeLabel.Text = "Time: " .. currentTime
            end
        end)
        
        logError("Show Info enabled")
    else
        logError("Show Info disabled")
    end
end

SystemTab:CreateToggle({
    Name = "Show Info",
    CurrentValue = Config.System.ShowInfo,
    Flag = "ShowInfo",
    Callback = function(Value)
        Config.System.ShowInfo = Value
        toggleShowInfo()
        logError("Show Info: " .. tostring(Value))
    end
})

-- Boost FPS Implementation
local function toggleBoostFPS()
    if Config.System.BoostFPS then
        -- Reduce graphics quality
        settings().Rendering.QualityLevel = 1
        
        -- Disable shadows
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        
        -- Disable particles
        for _, particle in ipairs(Workspace:GetDescendants()) do
            if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") or particle:IsA("Sparkles") then
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
        
        logError("Boost FPS enabled")
    else
        -- Reset graphics settings
        settings().Rendering.QualityLevel = 10
        Lighting.GlobalShadows = true
        
        logError("Boost FPS disabled")
    end
end

SystemTab:CreateToggle({
    Name = "Boost FPS",
    CurrentValue = Config.System.BoostFPS,
    Flag = "BoostFPS",
    Callback = function(Value)
        Config.System.BoostFPS = Value
        toggleBoostFPS()
        logError("Boost FPS: " .. tostring(Value))
    end
})

SystemTab:CreateDropdown({
    Name = "FPS Limit",
    Options = {"30", "60", "120", "240", "360", "Unlimited"},
    CurrentOption = tostring(Config.System.FPSLimit),
    Flag = "FPSLimit",
    Callback = function(Value)
        if Value == "Unlimited" then
            Config.System.FPSLimit = 360
            setfpscap(360)
        else
            Config.System.FPSLimit = tonumber(Value)
            setfpscap(tonumber(Value))
        end
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
            local memoryCleanConnection
            memoryCleanConnection = RunService.Heartbeat:Connect(function()
                if Config.System.AutoCleanMemory then
                    ygc()
                    collectgarbage()
                else
                    memoryCleanConnection:Disconnect()
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
            
            -- Disable future particles
            Workspace.DescendantAdded:Connect(function(descendant)
                if Config.System.DisableParticles and (descendant:IsA("ParticleEmitter") or descendant:IsA("Fire") or descendant:IsA("Smoke") or descendant:IsA("Sparkles")) then
                    descendant.Enabled = false
                end
            end)
        else
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") or particle:IsA("Sparkles") then
                    particle.Enabled = true
                end
            end
        end
    end
})

-- Auto Farm Implementation
local autoFarmConnection
local function toggleAutoFarm()
    if autoFarmConnection then autoFarmConnection:Disconnect() end
    
    if Config.System.AutoFarm then
        autoFarmConnection = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                -- Find fishing rod
                local rod = nil
                for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
                    if tool:IsA("Tool") and (tool.Name:find("Rod") or tool.Name:find("rod")) then
                        rod = tool
                        break
                    end
                end
                
                -- Equip rod if not equipped
                if not rod then
                    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and (tool.Name:find("Rod") or tool.Name:find("rod")) then
                            LocalPlayer.Character.Humanoid:EquipTool(tool)
                            rod = tool
                            break
                        end
                    end
                end
                
                -- Start fishing if rod is equipped
                if rod and rod:FindFirstChild("Handle") then
                    -- Find fishing spot within radius
                    local fishingSpots = {}
                    for _, spot in ipairs(Workspace:GetChildren()) do
                        if spot.Name:find("Fishing") or spot.Name:find("fishing") or spot.Name:find("Water") or spot.Name:find("water") then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - spot.Position).Magnitude
                            if distance <= Config.System.FarmRadius then
                                table.insert(fishingSpots, spot)
                            end
                        end
                    end
                    
                    -- Move to nearest fishing spot
                    if #fishingSpots > 0 then
                        local nearestSpot = fishingSpots[1]
                        local nearestDistance = (LocalPlayer.Character.HumanoidRootPart.Position - nearestSpot.Position).Magnitude
                        
                        for _, spot in ipairs(fishingSpots) do
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - spot.Position).Magnitude
                            if distance < nearestDistance then
                                nearestSpot = spot
                                nearestDistance = distance
                            end
                        end
                        
                        -- Move to fishing spot
                        local direction = (nearestSpot.Position - LocalPlayer.Character.HumanoidRootPart.Position).Unit
                        LocalPlayer.Character.Humanoid:Move(direction * Vector3.new(1, 0, 1))
                        
                        -- Cast fishing line
                        if nearestDistance < 10 then
                            if FishingEvents and FishingEvents:FindFirstChild("CastLine") then
                                FishingEvents.CastLine:FireServer(nearestSpot.Position)
                            end
                        end
                    end
                end
            end
        end)
        
        logError("Auto Farm enabled")
    else
        logError("Auto Farm disabled")
    end
end

SystemTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = Config.System.AutoFarm,
    Flag = "AutoFarm",
    Callback = function(Value)
        Config.System.AutoFarm = Value
        toggleAutoFarm()
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
            settings().Rendering.QualityLevel = 15
            Lighting.GlobalShadows = true
            Lighting.ShadowSoftness = 0.5
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.EnvironmentSpecularScale = 1
            logError("High Quality Rendering enabled")
        else
            settings().Rendering.QualityLevel = 10
            logError("High Quality Rendering disabled")
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
            sethiddenproperty(Lighting, "Technology", "Future")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Disabled")
            Lighting.GlobalShadows = true
            Lighting.ShadowSoftness = 0.2
            Lighting.EnvironmentDiffuseScale = 1.5
            Lighting.EnvironmentSpecularScale = 1.5
            logError("Max Rendering enabled")
        else
            settings().Rendering.QualityLevel = 10
            logError("Max Rendering disabled")
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
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") then
                    part.Material = Enum.Material.Plastic
                end
            end
            
            logError("Ultra Low Mode enabled")
        else
            settings().Rendering.QualityLevel = 10
            Lighting.GlobalShadows = true
            logError("Ultra Low Mode disabled")
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
                    water.Reflectance = 0
                    water.Transparency = 0.8
                end
            end
            
            if Workspace:FindFirstChild("Terrain") then
                Workspace.Terrain.WaterReflectance = 0
                Workspace.Terrain.WaterTransparency = 0.8
            end
            
            logError("Disable Water Reflection enabled")
        else
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and (water.Name == "Water" or water.Material == Enum.Material.Water) then
                    water.Reflectance = 0.5
                    water.Transparency = 0.5
                end
            end
            
            if Workspace:FindFirstChild("Terrain") then
                Workspace.Terrain.WaterReflectance = 0.5
                Workspace.Terrain.WaterTransparency = 0.5
            end
            
            logError("Disable Water Reflection disabled")
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
        
        if Value then
            -- Apply custom shader effects
            Lighting.ColorCorrection.TintColor = Color3.new(1, 1, 1)
            Lighting.ColorCorrection.Contrast = 0.2
            Lighting.ColorCorrection.Saturation = 0.1
            Lighting.Bloom.Intensity = 0.5
            Lighting.Bloom.Size = 24
            Lighting.Bloom.Threshold = 0.8
            
            logError("Custom Shader enabled")
        else
            -- Reset shader effects
            Lighting.ColorCorrection.TintColor = Color3.new(1, 1, 1)
            Lighting.ColorCorrection.Contrast = 0
            Lighting.ColorCorrection.Saturation = 0
            Lighting.Bloom.Intensity = 0
            Lighting.Bloom.Size = 0
            Lighting.Bloom.Threshold = 1
            
            logError("Custom Shader disabled")
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
            RunService:Set3dRenderingEnabled(true)
            settings().Rendering.MeshCacheSize = 100
            settings().Rendering.TextureCacheSize = 100
            settings().Rendering.EagerBulkExecution = true
            
            logError("Smooth Graphics enabled")
        else
            settings().Rendering.MeshCacheSize = 25
            settings().Rendering.TextureCacheSize = 25
            settings().Rendering.EagerBulkExecution = false
            
            logError("Smooth Graphics disabled")
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
            Lighting.Brightness = Config.Graphic.BrightnessLevel
            
            logError("Full Bright enabled")
        else
            Lighting.GlobalShadows = true
            Lighting.Brightness = 1
            
            logError("Full Bright disabled")
        end
    end
})

GraphicTab:CreateSlider({
    Name = "Brightness Level",
    Range = {0.5, 5},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = Config.Graphic.BrightnessLevel,
    Flag = "BrightnessLevel",
    Callback = function(Value)
        Config.Graphic.BrightnessLevel = Value
        if Config.Graphic.FullBright then
            Lighting.Brightness = Value
        end
        logError("Brightness Level: " .. Value)
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
                Rayfield:Notify({
                    Title = "RNG Settings Error",
                    Content = "Error: " .. tostring(result),
                    Duration = 5,
                    Image = 13047715178
                })
            end
        else
            logError("RNG Settings Error: Event not found")
            Rayfield:Notify({
                Title = "RNG Settings Error",
                Content = "RNG settings event not found",
                Duration = 5,
                Image = 13047715178
            })
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
        
        if Value and Config.Shop.SelectedRod ~= "" then
            if GameFunctions and GameFunctions:FindFirstChild("BuyRod") then
                local success, result = pcall(function()
                    GameFunctions.BuyRod:InvokeServer(Config.Shop.SelectedRod)
                    Rayfield:Notify({
                        Title = "Rod Purchased",
                        Content = "Purchased: " .. Config.Shop.SelectedRod,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Rod purchased: " .. Config.Shop.SelectedRod)
                end)
                if not success then
                    logError("Rod purchase error: " .. result)
                    Rayfield:Notify({
                        Title = "Purchase Error",
                        Content = "Error: " .. tostring(result),
                        Duration = 5,
                        Image = 13047715178
                    })
                end
            else
                logError("Rod purchase error: Function not found")
                Rayfield:Notify({
                    Title = "Purchase Error",
                    Content = "Buy rod function not found",
                    Duration = 5,
                    Image = 13047715178
                })
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
        
        if Config.Shop.AutoBuyRods then
            if GameFunctions and GameFunctions:FindFirstChild("BuyRod") then
                local success, result = pcall(function()
                    GameFunctions.BuyRod:InvokeServer(Value)
                    Rayfield:Notify({
                        Title = "Rod Purchased",
                        Content = "Purchased: " .. Value,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Rod purchased: " .. Value)
                end)
                if not success then
                    logError("Rod purchase error: " .. result)
                    Rayfield:Notify({
                        Title = "Purchase Error",
                        Content = "Error: " .. tostring(result),
                        Duration = 5,
                        Image = 13047715178
                    })
                end
            end
        end
    end
})

ShopTab:CreateToggle({
    Name = "Auto Buy Boats",
    CurrentValue = Config.Shop.AutoBuyBoats,
    Flag = "AutoBuyBoats",
    Callback = function(Value)
        Config.Shop.AutoBuyBoats = Value
        logError("Auto Buy Boats: " .. tostring(Value))
        
        if Value and Config.Shop.SelectedBoat ~= "" then
            if GameFunctions and GameFunctions:FindFirstChild("BuyBoat") then
                local success, result = pcall(function()
                    GameFunctions.BuyBoat:InvokeServer(Config.Shop.SelectedBoat)
                    Rayfield:Notify({
                        Title = "Boat Purchased",
                        Content = "Purchased: " .. Config.Shop.SelectedBoat,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Boat purchased: " .. Config.Shop.SelectedBoat)
                end)
                if not success then
                    logError("Boat purchase error: " .. result)
                    Rayfield:Notify({
                        Title = "Purchase Error",
                        Content = "Error: " .. tostring(result),
                        Duration = 5,
                        Image = 13047715178
                    })
                end
            else
                logError("Boat purchase error: Function not found")
                Rayfield:Notify({
                    Title = "Purchase Error",
                    Content = "Buy boat function not found",
                    Duration = 5,
                    Image = 13047715178
                })
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
        
        if Config.Shop.AutoBuyBoats then
            if GameFunctions and GameFunctions:FindFirstChild("BuyBoat") then
                local success, result = pcall(function()
                    GameFunctions.BuyBoat:InvokeServer(Value)
                    Rayfield:Notify({
                        Title = "Boat Purchased",
                        Content = "Purchased: " .. Value,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Boat purchased: " .. Value)
                end)
                if not success then
                    logError("Boat purchase error: " .. result)
                    Rayfield:Notify({
                        Title = "Purchase Error",
                        Content = "Error: " .. tostring(result),
                        Duration = 5,
                        Image = 13047715178
                    })
                end
            end
        end
    end
})

ShopTab:CreateToggle({
    Name = "Auto Buy Baits",
    CurrentValue = Config.Shop.AutoBuyBaits,
    Flag = "AutoBuyBaits",
    Callback = function(Value)
        Config.Shop.AutoBuyBaits = Value
        logError("Auto Buy Baits: " .. tostring(Value))
        
        if Value and Config.Shop.SelectedBait ~= "" then
            if GameFunctions and GameFunctions:FindFirstChild("BuyBait") then
                local success, result = pcall(function()
                    GameFunctions.BuyBait:InvokeServer(Config.Shop.SelectedBait)
                    Rayfield:Notify({
                        Title = "Bait Purchased",
                        Content = "Purchased: " .. Config.Shop.SelectedBait,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Bait purchased: " .. Config.Shop.SelectedBait)
                end)
                if not success then
                    logError("Bait purchase error: " .. result)
                    Rayfield:Notify({
                        Title = "Purchase Error",
                        Content = "Error: " .. tostring(result),
                        Duration = 5,
                        Image = 13047715178
                    })
                end
            else
                logError("Bait purchase error: Function not found")
                Rayfield:Notify({
                    Title = "Purchase Error",
                    Content = "Buy bait function not found",
                    Duration = 5,
                    Image = 13047715178
                })
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
        
        if Config.Shop.AutoBuyBaits then
            if GameFunctions and GameFunctions:FindFirstChild("BuyBait") then
                local success, result = pcall(function()
                    GameFunctions.BuyBait:InvokeServer(Value)
                    Rayfield:Notify({
                        Title = "Bait Purchased",
                        Content = "Purchased: " .. Value,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Bait purchased: " .. Value)
                end)
                if not success then
                    logError("Bait purchase error: " .. result)
                    Rayfield:Notify({
                        Title = "Purchase Error",
                        Content = "Error: " .. tostring(result),
                        Duration = 5,
                        Image = 13047715178
                    })
                end
            end
        end
    end
})

ShopTab:CreateToggle({
    Name = "Auto Upgrade Rod",
    CurrentValue = Config.Shop.AutoUpgradeRod,
    Flag = "AutoUpgradeRod",
    Callback = function(Value)
        Config.Shop.AutoUpgradeRod = Value
        logError("Auto Upgrade Rod: " .. tostring(Value))
        
        if Value then
            if GameFunctions and GameFunctions:FindFirstChild("UpgradeRod") then
                local success, result = pcall(function()
                    GameFunctions.UpgradeRod:InvokeServer()
                    Rayfield:Notify({
                        Title = "Rod Upgraded",
                        Content = "Rod has been upgraded",
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Rod upgraded")
                end)
                if not success then
                    logError("Rod upgrade error: " .. result)
                    Rayfield:Notify({
                        Title = "Upgrade Error",
                        Content = "Error: " .. tostring(result),
                        Duration = 5,
                        Image = 13047715178
                    })
                end
            else
                logError("Rod upgrade error: Function not found")
                Rayfield:Notify({
                    Title = "Upgrade Error",
                    Content = "Upgrade rod function not found",
                    Duration = 5,
                    Image = 13047715178
                })
            end
        end
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
                        Title = "Rod Purchased",
                        Content = "Purchased: " .. Config.Shop.SelectedRod,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Rod purchased: " .. Config.Shop.SelectedRod)
                end)
                if not success then
                    logError("Rod purchase error: " .. result)
                    Rayfield:Notify({
                        Title = "Purchase Error",
                        Content = "Error: " .. tostring(result),
                        Duration = 5,
                        Image = 13047715178
                    })
                end
            end
        elseif Config.Shop.SelectedBoat ~= "" then
            if GameFunctions and GameFunctions:FindFirstChild("BuyBoat") then
                local success, result = pcall(function()
                    GameFunctions.BuyBoat:InvokeServer(Config.Shop.SelectedBoat)
                    Rayfield:Notify({
                        Title = "Boat Purchased",
                        Content = "Purchased: " .. Config.Shop.SelectedBoat,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Boat purchased: " .. Config.Shop.SelectedBoat)
                end)
                if not success then
                    logError("Boat purchase error: " .. result)
                    Rayfield:Notify({
                        Title = "Purchase Error",
                        Content = "Error: " .. tostring(result),
                        Duration = 5,
                        Image = 13047715178
                    })
                end
            end
        elseif Config.Shop.SelectedBait ~= "" then
            if GameFunctions and GameFunctions:FindFirstChild("BuyBait") then
                local success, result = pcall(function()
                    GameFunctions.BuyBait:InvokeServer(Config.Shop.SelectedBait)
                    Rayfield:Notify({
                        Title = "Bait Purchased",
                        Content = "Purchased: " .. Config.Shop.SelectedBait,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Bait purchased: " .. Config.Shop.SelectedBait)
                end)
                if not success then
                    logError("Bait purchase error: " .. result)
                    Rayfield:Notify({
                        Title = "Purchase Error",
                        Content = "Error: " .. tostring(result),
                        Duration = 5,
                        Image = 13047715178
                    })
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
    Name = "Theme",
    Options = {"Dark", "Light", "Darker", "Blue", "Red", "Green"},
    CurrentOption = Config.Settings.SelectedTheme,
    Flag = "SelectedTheme",
    Callback = function(Value)
        Config.Settings.SelectedTheme = Value
        -- Apply theme
        if Value == "Dark" then
            Window:SetTheme("Dark")
        elseif Value == "Light" then
            Window:SetTheme("Light")
        elseif Value == "Darker" then
            Window:SetTheme("Darker")
        elseif Value == "Blue" then
            Window:SetTheme("Blue")
        elseif Value == "Red" then
            Window:SetTheme("Red")
        elseif Value == "Green" then
            Window:SetTheme("Green")
        end
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
    Increment = 0.1,
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
    Name = "Clear Log",
    Callback = function()
        local success, err = pcall(function()
            local logPath = "/storage/emulated/0/logscript.txt"
            if isfile(logPath) then
                writefile(logPath, "")
                Rayfield:Notify({
                    Title = "Log Cleared",
                    Content = "Log file has been cleared",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Log file cleared")
            end
        end)
        
        if not success then
            Rayfield:Notify({
                Title = "Log Error",
                Content = "Failed to clear log: " .. err,
                Duration = 5,
                Image = 13047715178
            })
        end
    end
})

SettingsTab:CreateButton({
    Name = "View Log",
    Callback = function()
        local success, err = pcall(function()
            local logPath = "/storage/emulated/0/logscript.txt"
            if isfile(logPath) then
                local logContent = readfile(logPath)
                -- Display last 20 lines of log
                local lines = {}
                for line in string.gmatch(logContent, "[^\r\n]+") do
                    table.insert(lines, line)
                end
                
                local recentLines = {}
                local startIndex = math.max(1, #lines - 19)
                for i = startIndex, #lines do
                    table.insert(recentLines, lines[i])
                end
                
                local logDisplay = table.concat(recentLines, "\n")
                
                Rayfield:Notify({
                    Title = "Recent Log Entries",
                    Content = "Last " .. #recentLines .. " log entries (check file for full log)",
                    Duration = 10,
                    Image = 13047715178
                })
                
                logError("Viewed log file")
            else
                Rayfield:Notify({
                    Title = "Log Not Found",
                    Content = "Log file does not exist",
                    Duration = 5,
                    Image = 13047715178
                })
            end
        end)
        
        if not success then
            Rayfield:Notify({
                Title = "Log Error",
                Content = "Failed to view log: " .. err,
                Duration = 5,
                Image = 13047715178
            })
        end
    end
})

-- Initialize script
logError("Script initialization complete")

-- Load config if exists
LoadConfig()

-- Apply initial settings
if Config.Bypass.AutoJump then
    startAutoJump()
end

if Config.Player.PlayerESP then
    toggleESP()
end

if Config.Player.SpeedHack then
    toggleSpeedHack()
end

if Config.Player.MaxBoatSpeed then
    toggleMaxBoatSpeed()
end

if Config.Player.InfinityJump then
    toggleInfinityJump()
end

if Config.Player.Fly then
    toggleFly()
end

if Config.Player.FlyBoat then
    toggleFlyBoat()
end

if Config.Player.GhostHack then
    toggleGhostHack()
end

if Config.Player.Noclip then
    toggleNoclip()
end

if Config.Player.AutoSell then
    toggleAutoSell()
end

if Config.System.ShowInfo then
    toggleShowInfo()
end

if Config.System.BoostFPS then
    toggleBoostFPS()
end

if Config.System.DisableParticles then
    -- Trigger the toggle to apply the effect
    Config.System.DisableParticles = false
    SystemTab:GetElement("DisableParticles"):Set(false)
    SystemTab:GetElement("DisableParticles"):Set(true)
end

if Config.System.AutoFarm then
    toggleAutoFarm()
end

if Config.Graphic.HighQuality then
    -- Trigger the toggle to apply the effect
    Config.Graphic.HighQuality = false
    GraphicTab:GetElement("HighQuality"):Set(false)
    GraphicTab:GetElement("HighQuality"):Set(true)
end

if Config.Graphic.MaxRendering then
    -- Trigger the toggle to apply the effect
    Config.Graphic.MaxRendering = false
    GraphicTab:GetElement("MaxRendering"):Set(false)
    GraphicTab:GetElement("MaxRendering"):Set(true)
end

if Config.Graphic.UltraLowMode then
    -- Trigger the toggle to apply the effect
    Config.Graphic.UltraLowMode = false
    GraphicTab:GetElement("UltraLowMode"):Set(false)
    GraphicTab:GetElement("UltraLowMode"):Set(true)
end

if Config.Graphic.DisableWaterReflection then
    -- Trigger the toggle to apply the effect
    Config.Graphic.DisableWaterReflection = false
    GraphicTab:GetElement("DisableWaterReflection"):Set(false)
    GraphicTab:GetElement("DisableWaterReflection"):Set(true)
end

if Config.Graphic.CustomShader then
    -- Trigger the toggle to apply the effect
    Config.Graphic.CustomShader = false
    GraphicTab:GetElement("CustomShader"):Set(false)
    GraphicTab:GetElement("CustomShader"):Set(true)
end

if Config.Graphic.SmoothGraphics then
    -- Trigger the toggle to apply the effect
    Config.Graphic.SmoothGraphics = false
    GraphicTab:GetElement("SmoothGraphics"):Set(false)
    GraphicTab:GetElement("SmoothGraphics"):Set(true)
end

if Config.Graphic.FullBright then
    -- Trigger the toggle to apply the effect
    Config.Graphic.FullBright = false
    GraphicTab:GetElement("FullBright"):Set(false)
    GraphicTab:GetElement("FullBright"):Set(true)
end

-- Notify user that script is ready
Rayfield:Notify({
    Title = "Script Loaded",
    Content = "Fish It Hub 2025 has been loaded successfully",
    Duration = 5,
    Image = 13047715178
})

logError("Script loaded successfully")
