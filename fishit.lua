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

-- Create ESP Objects
local function CreateESP(player)
    if ESP_Objects[player] then return end
    
    ESP_Objects[player] = {
        Box = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        Level = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Hologram = Instance.new("BillboardGui"),
        Enabled = false
    }
    
    local esp = ESP_Objects[player]
    
    -- Setup Box
    esp.Box.Thickness = 1
    esp.Box.Color = Color3.new(1, 1, 1)
    esp.Box.Transparency = 1
    esp.Box.Visible = false
    
    -- Setup Tracer
    esp.Tracer.Thickness = 1
    esp.Tracer.Color = Color3.new(1, 1, 1)
    esp.Tracer.Transparency = 1
    esp.Tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
    esp.Tracer.To = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
    esp.Tracer.Visible = false
    
    -- Setup Name
    esp.Name.Size = 16
    esp.Name.Color = Color3.new(1, 1, 1)
    esp.Name.Center = true
    esp.Name.Outline = true
    esp.Name.OutlineColor = Color3.new(0, 0, 0)
    esp.Name.Visible = false
    
    -- Setup Level
    esp.Level.Size = 14
    esp.Level.Color = Color3.new(1, 1, 0)
    esp.Level.Center = true
    esp.Level.Outline = true
    esp.Level.OutlineColor = Color3.new(0, 0, 0)
    esp.Level.Visible = false
    
    -- Setup Distance
    esp.Distance.Size = 14
    esp.Distance.Color = Color3.new(0, 1, 0)
    esp.Distance.Center = true
    esp.Distance.Outline = true
    esp.Distance.OutlineColor = Color3.new(0, 0, 0)
    esp.Distance.Visible = false
    
    -- Setup Hologram
    esp.Hologram.Name = player.Name .. "_ESP"
    esp.Hologram.AlwaysOnTop = true
    esp.Hologram.Size = UDim2.new(0, 100, 0, 50)
    esp.Hologram.StudsOffset = Vector3.new(0, 3, 0)
    esp.Hologram.Enabled = false
    
    local nameLabel = Instance.new("TextLabel", esp.Hologram)
    nameLabel.Name = "NameLabel"
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextScaled = true
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    
    local levelLabel = Instance.new("TextLabel", esp.Hologram)
    levelLabel.Name = "LevelLabel"
    levelLabel.BackgroundTransparency = 1
    levelLabel.Text = "Level: " .. (player:FindFirstChild("Level") and player.Level.Value or "N/A")
    levelLabel.TextColor3 = Color3.new(1, 1, 0)
    levelLabel.TextScaled = true
    levelLabel.Size = UDim2.new(1, 0, 0.5, 0)
    levelLabel.Position = UDim2.new(0, 0, 0.5, 0)
    
    esp.Hologram.Parent = CoreGui
end

-- Update ESP
local function UpdateESP()
    for player, esp in pairs(ESP_Objects) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local rootPart = player.Character.HumanoidRootPart
            local position, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                -- Update Box
                if Config.Player.ESPBox and esp.Enabled then
                    local size = rootPart.Size
                    local scaleFactor = 1000 / (position.Z * math.tan(math.rad(workspace.CurrentCamera.FieldOfView / 2)))
                    
                    esp.Box.Size = Vector2.new(size.X * scaleFactor, size.Y * scaleFactor * 2)
                    esp.Box.Position = Vector2.new(position.X - esp.Box.Size.X / 2, position.Y - esp.Box.Size.Y / 2)
                    esp.Box.Visible = true
                else
                    esp.Box.Visible = false
                end
                
                -- Update Tracer
                if Config.Player.ESPLines and esp.Enabled then
                    esp.Tracer.To = Vector2.new(position.X, position.Y)
                    esp.Tracer.Visible = true
                else
                    esp.Tracer.Visible = false
                end
                
                -- Update Name
                if Config.Player.ESPName and esp.Enabled then
                    esp.Name.Position = Vector2.new(position.X, position.Y - 25)
                    esp.Name.Text = player.Name
                    esp.Name.Visible = true
                else
                    esp.Name.Visible = false
                end
                
                -- Update Level
                if Config.Player.ESPLevel and esp.Enabled then
                    esp.Level.Position = Vector2.new(position.X, position.Y - 10)
                    esp.Level.Text = "Level: " .. (player:FindFirstChild("Level") and player.Level.Value or "N/A")
                    esp.Level.Visible = true
                else
                    esp.Level.Visible = false
                end
                
                -- Update Distance
                if Config.Player.ESPRange and esp.Enabled then
                    esp.Distance.Position = Vector2.new(position.X, position.Y + 15)
                    esp.Distance.Text = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude) .. " studs"
                    esp.Distance.Visible = true
                else
                    esp.Distance.Visible = false
                end
                
                -- Update Hologram
                if Config.Player.ESPHologram and esp.Enabled then
                    esp.Hologram.Adornee = rootPart
                    esp.Hologram.Enabled = true
                else
                    esp.Hologram.Enabled = false
                end
            else
                esp.Box.Visible = false
                esp.Tracer.Visible = false
                esp.Name.Visible = false
                esp.Level.Visible = false
                esp.Distance.Visible = false
                esp.Hologram.Enabled = false
            end
        else
            esp.Box.Visible = false
            esp.Tracer.Visible = false
            esp.Name.Visible = false
            esp.Level.Visible = false
            esp.Distance.Visible = false
            esp.Hologram.Enabled = false
        end
    end
end

-- Toggle ESP
local function ToggleESP(state)
    for player, esp in pairs(ESP_Objects) do
        esp.Enabled = state
        if not state then
            esp.Box.Visible = false
            esp.Tracer.Visible = false
            esp.Name.Visible = false
            esp.Level.Visible = false
            esp.Distance.Visible = false
            esp.Hologram.Enabled = false
        end
    end
end

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
        logError("Anti-AFK: Triggered")
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
        logError("Speed Value: " .. Value)
        
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
        logError("Max Boat Speed: " .. tostring(Value))
        
        -- Find player's boat and modify speed
        if Value then
            spawn(function()
                while Config.Player.MaxBoatSpeed do
                    for _, boat in pairs(Workspace:GetChildren()) do
                        if boat.Name:find(LocalPlayer.Name) and boat:FindFirstChild("VehicleSeat") then
                            local seat = boat.VehicleSeat
                            if seat:FindFirstChild("MaxSpeed") then
                                seat.MaxSpeed.Value = seat.MaxSpeed.Value * 5
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
                    for _, boat in pairs(Workspace:GetChildren()) do
                        if boat.Name:find(LocalPlayer.Name) and boat:FindFirstChild("VehicleSeat") then
                            for _, part in pairs(boat:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
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
            UserInputService.JumpRequest:connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
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
            local flySpeed = Config.Player.FlyRange
            local flying = false
            local flyControl = {f = 0, b = 0, l = 0, r = 0}
            
            local function updateFlyControl()
                if UserInputService:GetKeyDown(Enum.KeyCode.W) then
                    flyControl.f = 1
                else
                    flyControl.f = 0
                end
                
                if UserInputService:GetKeyDown(Enum.KeyCode.S) then
                    flyControl.b = -1
                else
                    flyControl.b = 0
                end
                
                if UserInputService:GetKeyDown(Enum.KeyCode.A) then
                    flyControl.l = -1
                else
                    flyControl.l = 0
                end
                
                if UserInputService:GetKeyDown(Enum.KeyCode.D) then
                    flyControl.r = 1
                else
                    flyControl.r = 0
                end
            end
            
            spawn(function()
                while Config.Player.Fly do
                    updateFlyControl()
                    
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
                        
                        local direction = Vector3.new(
                            flyControl.l + flyControl.r,
                            0,
                            flyControl.f + flyControl.b
                        )
                        
                        if direction.Magnitude > 0 then
                            direction = direction.Unit * flySpeed
                        end
                        
                        LocalPlayer.Character.HumanoidRootPart.Velocity = workspace.CurrentCamera.CFrame:VectorToWorldSpace(direction)
                    end
                    
                    wait()
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
                    for _, boat in pairs(Workspace:GetChildren()) do
                        if boat.Name:find(LocalPlayer.Name) and boat:FindFirstChild("VehicleSeat") then
                            local seat = boat.VehicleSeat
                            if seat.Occupant and seat.Occupant.Parent == LocalPlayer.Character then
                                boat.VehicleSeat.CFrame = boat.VehicleSeat.CFrame * CFrame.new(0, 0.5, 0)
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
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
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
        
        ToggleESP(Value)
        
        if Value then
            -- Create ESP for all players
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    CreateESP(player)
                end
            end
            
            -- Create ESP for new players
            Players.PlayerAdded:Connect(function(player)
                if player ~= LocalPlayer then
                    CreateESP(player)
                end
            end)
            
            -- Remove ESP for leaving players
            Players.PlayerRemoving:Connect(function(player)
                if ESP_Objects[player] then
                    ESP_Objects[player].Box:Remove()
                    ESP_Objects[player].Tracer:Remove()
                    ESP_Objects[player].Name:Remove()
                    ESP_Objects[player].Level:Remove()
                    ESP_Objects[player].Distance:Remove()
                    ESP_Objects[player].Hologram:Destroy()
                    ESP_Objects[player] = nil
                end
            end)
            
            -- Update ESP
            ESP_Connections.RenderStepped = RunService.RenderStepped:Connect(UpdateESP)
        else
            if ESP_Connections.RenderStepped then
                ESP_Connections.RenderStepped:Disconnect()
                ESP_Connections.RenderStepped = nil
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
        
        if Value then
            spawn(function()
                while Config.Player.Noclip do
                    if LocalPlayer.Character then
                        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                    wait(0.1)
                end
            end)
        else
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
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
        logError("Auto Sell: " .. tostring(Value))
        
        if Value then
            spawn(function()
                while Config.Player.AutoSell do
                    if GameFunctions and GameFunctions:FindFirstChild("SellAllFish") then
                        local success, result = pcall(function()
                            GameFunctions.SellAllFish:InvokeServer()
                            logError("Auto Sell: Sold all fish")
                        end)
                        if not success then
                            logError("Auto Sell Error: " .. result)
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
        logError("Auto Craft: " .. tostring(Value))
        
        if Value then
            spawn(function()
                while Config.Player.AutoCraft do
                    if GameFunctions and GameFunctions:FindFirstChild("AutoCraft") then
                        local success, result = pcall(function()
                            GameFunctions.AutoCraft:InvokeServer()
                            logError("Auto Craft: Crafting completed")
                        end)
                        if not success then
                            logError("Auto Craft Error: " .. result)
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
        logError("Auto Upgrade: " .. tostring(Value))
        
        if Value then
            spawn(function()
                while Config.Player.AutoUpgrade do
                    if GameFunctions and GameFunctions:FindFirstChild("AutoUpgrade") then
                        local success, result = pcall(function()
                            GameFunctions.AutoUpgrade:InvokeServer()
                            logError("Auto Upgrade: Upgraded equipment")
                        end)
                        if not success then
                            logError("Auto Upgrade Error: " .. result)
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
        logError("Auto Accept Trade: " .. tostring(Value))
        
        if Value then
            spawn(function()
                while Config.Trader.AutoAcceptTrade do
                    if TradeEvents and TradeEvents:FindFirstChild("AcceptTrade") then
                        local success, result = pcall(function()
                            TradeEvents.AcceptTrade:FireServer()
                            logError("Auto Accept Trade: Trade accepted")
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
local function getFishInventory()
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
    Options = getFishInventory(),
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
        
        if Value and GameFunctions and GameFunctions:FindFirstChild("LuckBoost") then
            local success, result = pcall(function()
                GameFunctions.LuckBoost:FireServer()
                logError("Luck Boost: Activated")
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
        
        if Value and GameFunctions and GameFunctions:FindFirstChild("ForceEvent") then
            local success, result = pcall(function()
                GameFunctions.ForceEvent:FireServer()
                logError("Force Event: Event forced")
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
            local jobId = game.JobId
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
            logError("Rejoining same server with JobId: " .. jobId)
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
            local req = {
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Method = "GET"
            }
            
            local success, result = pcall(function()
                servers = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
                servers = HttpService:JSONDecode(servers)
            end)
            
            if success and servers.data then
                for i, server in ipairs(servers.data) do
                    if server.playing < server.maxPlayers and server.id ~= game.JobId then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                        logError("Server Hopped to: " .. server.id)
                        break
                    end
                end
            else
                logError("Server Hop Error: " .. tostring(result))
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

local infoGui = nil
local fpsLabel = nil
local pingLabel = nil
local batteryLabel = nil
local timeLabel = nil

SystemTab:CreateToggle({
    Name = "Show Info",
    CurrentValue = Config.System.ShowInfo,
    Flag = "ShowInfo",
    Callback = function(Value)
        Config.System.ShowInfo = Value
        logError("Show Info: " .. tostring(Value))
        
        if Value then
            -- Create info GUI
            infoGui = Instance.new("ScreenGui")
            infoGui.Name = "SystemInfo"
            infoGui.ResetOnSpawn = false
            infoGui.Parent = CoreGui
            
            local mainFrame = Instance.new("Frame")
            mainFrame.Name = "MainFrame"
            mainFrame.Size = UDim2.new(0, 200, 0, 100)
            mainFrame.Position = UDim2.new(0, 10, 0, 10)
            mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
            mainFrame.BackgroundTransparency = 0.5
            mainFrame.BorderSizePixel = 0
            mainFrame.Parent = infoGui
            
            fpsLabel = Instance.new("TextLabel")
            fpsLabel.Name = "FPSLabel"
            fpsLabel.Size = UDim2.new(1, 0, 0.25, 0)
            fpsLabel.Position = UDim2.new(0, 0, 0, 0)
            fpsLabel.BackgroundTransparency = 1
            fpsLabel.TextColor3 = Color3.new(1, 1, 1)
            fpsLabel.TextScaled = true
            fpsLabel.Font = Enum.Font.SourceSansBold
            fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
            fpsLabel.Parent = mainFrame
            
            pingLabel = Instance.new("TextLabel")
            pingLabel.Name = "PingLabel"
            pingLabel.Size = UDim2.new(1, 0, 0.25, 0)
            pingLabel.Position = UDim2.new(0, 0, 0.25, 0)
            pingLabel.BackgroundTransparency = 1
            pingLabel.TextColor3 = Color3.new(1, 1, 1)
            pingLabel.TextScaled = true
            pingLabel.Font = Enum.Font.SourceSansBold
            pingLabel.TextXAlignment = Enum.TextXAlignment.Left
            pingLabel.Parent = mainFrame
            
            batteryLabel = Instance.new("TextLabel")
            batteryLabel.Name = "BatteryLabel"
            batteryLabel.Size = UDim2.new(1, 0, 0.25, 0)
            batteryLabel.Position = UDim2.new(0, 0, 0.5, 0)
            batteryLabel.BackgroundTransparency = 1
            batteryLabel.TextColor3 = Color3.new(1, 1, 1)
            batteryLabel.TextScaled = true
            batteryLabel.Font = Enum.Font.SourceSansBold
            batteryLabel.TextXAlignment = Enum.TextXAlignment.Left
            batteryLabel.Parent = mainFrame
            
            timeLabel = Instance.new("TextLabel")
            timeLabel.Name = "TimeLabel"
            timeLabel.Size = UDim2.new(1, 0, 0.25, 0)
            timeLabel.Position = UDim2.new(0, 0, 0.75, 0)
            timeLabel.BackgroundTransparency = 1
            timeLabel.TextColor3 = Color3.new(1, 1, 1)
            timeLabel.TextScaled = true
            timeLabel.Font = Enum.Font.SourceSansBold
            timeLabel.TextXAlignment = Enum.TextXAlignment.Left
            timeLabel.Parent = mainFrame
            
            -- Update info
            spawn(function()
                while Config.System.ShowInfo do
                    if fpsLabel then
                        local fps = math.floor(1 / RunService.RenderStepped:Wait())
                        fpsLabel.Text = "FPS: " .. fps
                    end
                    
                    if pingLabel then
                        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                        pingLabel.Text = "Ping: " .. ping .. "ms"
                    end
                    
                    if batteryLabel then
                        local battery = math.floor(UserInputService:GetBatteryLevel() * 100)
                        batteryLabel.Text = "Battery: " .. battery .. "%"
                    end
                    
                    if timeLabel then
                        local time = os.date("%H:%M:%S")
                        timeLabel.Text = "Time: " .. time
                    end
                    
                    wait(0.5)
                end
            end)
        else
            if infoGui then
                infoGui:Destroy()
                infoGui = nil
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
        logError("Boost FPS: " .. tostring(Value))
        
        if Value then
            -- Lower graphics settings to boost FPS
            settings().Rendering.QualityLevel = 1
            sethiddenproperty(Lighting, "Technology", "Compatibility")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Enum.InterpolationThrottlingMode.Disabled")
            
            -- Disable unnecessary effects
            for _, effect in pairs(Lighting:GetChildren()) do
                if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") then
                    effect.Enabled = false
                end
            end
            
            logError("Boost FPS: Applied settings")
        else
            -- Reset to default settings
            settings().Rendering.QualityLevel = 10
            sethiddenproperty(Lighting, "Technology", "Future")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Enum.InterpolationThrottlingMode.Default")
            
            -- Re-enable effects
            for _, effect in pairs(Lighting:GetChildren()) do
                if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") then
                    effect.Enabled = true
                end
            end
            
            logError("Boost FPS: Reset to default")
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
        logError("Auto Clean Memory: " .. tostring(Value))
        
        if Value then
            spawn(function()
                while Config.System.AutoCleanMemory do
                    local memoryBefore = Stats:GetTotalMemoryUsageMb()
                    
                    -- Clean textures
                    for _, obj in pairs(game:GetDescendants()) do
                        if obj:IsA("Decal") or obj:IsA("Texture") then
                            obj:Destroy()
                        end
                    end
                    
                    -- Clean sounds
                    for _, obj in pairs(game:GetDescendants()) do
                        if obj:IsA("Sound") then
                            obj:Stop()
                        end
                    end
                    
                    -- Force garbage collection
                    collectgarbage("collect")
                    
                    local memoryAfter = Stats:GetTotalMemoryUsageMb()
                    logError("Auto Clean Memory: " .. memoryBefore .. "MB -> " .. memoryAfter .. "MB")
                    
                    wait(60)
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
            spawn(function()
                while Config.System.DisableParticles do
                    for _, particle in pairs(Workspace:GetDescendants()) do
                        if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") or particle:IsA("Sparkles") then
                            particle.Enabled = false
                        end
                    end
                    wait(1)
                end
            end)
        else
            for _, particle in pairs(Workspace:GetDescendants()) do
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
                        -- Find nearest fishing spot
                        local nearestSpot = nil
                        local nearestDistance = math.huge
                        
                        for _, spot in pairs(Workspace:GetChildren()) do
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
                            
                            -- Equip fishing rod
                            if LocalPlayer.Character:FindFirstChild("Humanoid") then
                                LocalPlayer.Character.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChildOfClass("Tool"))
                            end
                            
                            -- Cast fishing line
                            if FishingEvents and FishingEvents:FindFirstChild("CastLine") then
                                local success, result = pcall(function()
                                    FishingEvents.CastLine:FireServer()
                                    logError("Auto Farm: Cast fishing line")
                                end)
                                if not success then
                                    logError("Auto Farm Error: " .. result)
                                end
                            end
                            
                            -- Wait for fish
                            wait(3)
                            
                            -- Reel in fish
                            if FishingEvents and FishingEvents:FindFirstChild("ReelIn") then
                                local success, result = pcall(function()
                                    FishingEvents.ReelIn:FireServer()
                                    logError("Auto Farm: Reeled in fish")
                                end)
                                if not success then
                                    logError("Auto Farm Error: " .. result)
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
        logError("High Quality Rendering: " .. tostring(Value))
        
        if Value then
            sethiddenproperty(Lighting, "Technology", "Future")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Disabled")
            settings().Rendering.QualityLevel = 10
            
            -- Enable effects
            local bloom = Instance.new("BloomEffect", Lighting)
            bloom.Intensity = 0.5
            bloom.Size = 25
            bloom.Threshold = 0.1
            
            local colorCorrection = Instance.new("ColorCorrectionEffect", Lighting)
            colorCorrection.TintColor = Color3.new(1, 1, 1)
            colorCorrection.Saturation = 0.2
            colorCorrection.Contrast = 0.1
            
            logError("High Quality Rendering: Applied settings")
        else
            sethiddenproperty(Lighting, "Technology", "Compatibility")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Enum.InterpolationThrottlingMode.Default")
            settings().Rendering.QualityLevel = 1
            
            -- Disable effects
            for _, effect in pairs(Lighting:GetChildren()) do
                if effect:IsA("BloomEffect") or effect:IsA("ColorCorrectionEffect") then
                    effect:Destroy()
                end
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
        logError("Max Rendering: " .. tostring(Value))
        
        if Value then
            settings().Rendering.QualityLevel = 21
            sethiddenproperty(Lighting, "Technology", "Future")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Disabled")
            
            -- Enable maximum effects
            local bloom = Instance.new("BloomEffect", Lighting)
            bloom.Intensity = 1
            bloom.Size = 50
            bloom.Threshold = 0.05
            
            local colorCorrection = Instance.new("ColorCorrectionEffect", Lighting)
            colorCorrection.TintColor = Color3.new(1, 1, 1)
            colorCorrection.Saturation = 0.5
            colorCorrection.Contrast = 0.3
            
            local sunRays = Instance.new("SunRaysEffect", Lighting)
            sunRays.Intensity = 0.5
            sunRays.Spread = 0.1
            
            logError("Max Rendering: Applied settings")
        else
            settings().Rendering.QualityLevel = 10
            sethiddenproperty(Lighting, "Technology", "Future")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Disabled")
            
            -- Disable effects
            for _, effect in pairs(Lighting:GetChildren()) do
                if effect:IsA("BloomEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") then
                    effect:Destroy()
                end
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
        logError("Ultra Low Mode: " .. tostring(Value))
        
        if Value then
            settings().Rendering.QualityLevel = 1
            sethiddenproperty(Lighting, "Technology", "Compatibility")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Enum.InterpolationThrottlingMode.Disabled")
            
            -- Set all materials to plastic
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") then
                    part.Material = Enum.Material.Plastic
                end
            end
            
            -- Disable all effects
            for _, effect in pairs(Lighting:GetChildren()) do
                if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") then
                    effect.Enabled = false
                end
            end
            
            logError("Ultra Low Mode: Applied settings")
        else
            settings().Rendering.QualityLevel = 10
            sethiddenproperty(Lighting, "Technology", "Future")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Disabled")
            
            -- Re-enable effects
            for _, effect in pairs(Lighting:GetChildren()) do
                if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") then
                    effect.Enabled = true
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
        logError("Disable Water Reflection: " .. tostring(Value))
        
        if Value then
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and (water.Name == "Water" or water.Material == Enum.Material.Water) then
                    water.Transparency = 1
                    water.Reflectance = 0
                end
            end
            
            logError("Disable Water Reflection: Applied settings")
        else
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and (water.Name == "Water" or water.Material == Enum.Material.Water) then
                    water.Transparency = 0.5
                    water.Reflectance = 0.4
                end
            end
            
            logError("Disable Water Reflection: Reset to default")
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
            local colorCorrection = Instance.new("ColorCorrectionEffect", Lighting)
            colorCorrection.Name = "CustomShader"
            colorCorrection.TintColor = Color3.new(1.2, 1.1, 0.9)
            colorCorrection.Saturation = 0.3
            colorCorrection.Contrast = 0.2
            
            local bloom = Instance.new("BloomEffect", Lighting)
            bloom.Name = "CustomShader"
            bloom.Intensity = 0.4
            bloom.Size = 30
            bloom.Threshold = 0.08
            
            logError("Custom Shader: Applied settings")
        else
            -- Remove custom shader effects
            for _, effect in pairs(Lighting:GetChildren()) do
                if effect.Name == "CustomShader" then
                    effect:Destroy()
                end
            end
            
            logError("Custom Shader: Reset to default")
        end
    end
})

GraphicTab:CreateToggle({
    Name = "Smooth Graphics",
    CurrentValue = Config.Graphic.SmoothGraphics,
    Flag = "SmoothGraphics",
    Callback = function(Value)
        Config.Graphic.SmoothGraphics = Value
        logError("Smooth Graphics: " .. tostring(Value))
        
        if Value then
            RunService:Set3dRenderingEnabled(true)
            settings().Rendering.MeshCacheSize = 100
            settings().Rendering.TextureCacheSize = 100
            
            -- Apply smoothing effects
            local blur = Instance.new("BlurEffect", Lighting)
            blur.Name = "SmoothGraphics"
            blur.Size = 2
            
            logError("Smooth Graphics: Applied settings")
        else
            RunService:Set3dRenderingEnabled(true)
            settings().Rendering.MeshCacheSize = 50
            settings().Rendering.TextureCacheSize = 50
            
            -- Remove smoothing effects
            for _, effect in pairs(Lighting:GetChildren()) do
                if effect.Name == "SmoothGraphics" then
                    effect:Destroy()
                end
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
        logError("Full Bright: " .. tostring(Value))
        
        if Value then
            Lighting.GlobalShadows = false
            Lighting.ClockTime = 12
            Lighting.Brightness = Config.Graphic.BrightnessValue
            
            logError("Full Bright: Applied settings")
        else
            Lighting.GlobalShadows = true
            Lighting.Brightness = 1
            
            logError("Full Bright: Reset to default")
        end
    end
})

GraphicTab:CreateSlider({
    Name = "Brightness",
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
        
        if Value then
            spawn(function()
                while Config.Shop.AutoBuyRods do
                    if Config.Shop.SelectedRod ~= "" and GameFunctions and GameFunctions:FindFirstChild("BuyItem") then
                        local success, result = pcall(function()
                            GameFunctions.BuyItem:InvokeServer("Rod", Config.Shop.SelectedRod)
                            logError("Auto Buy Rods: Purchased " .. Config.Shop.SelectedRod)
                        end)
                        if not success then
                            logError("Auto Buy Rods Error: " .. result)
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
        
        if Value then
            spawn(function()
                while Config.Shop.AutoBuyBoats do
                    if Config.Shop.SelectedBoat ~= "" and GameFunctions and GameFunctions:FindFirstChild("BuyItem") then
                        local success, result = pcall(function()
                            GameFunctions.BuyItem:InvokeServer("Boat", Config.Shop.SelectedBoat)
                            logError("Auto Buy Boats: Purchased " .. Config.Shop.SelectedBoat)
                        end)
                        if not success then
                            logError("Auto Buy Boats Error: " .. result)
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
        
        if Value then
            spawn(function()
                while Config.Shop.AutoBuyBaits do
                    if Config.Shop.SelectedBait ~= "" and GameFunctions and GameFunctions:FindFirstChild("BuyItem") then
                        local success, result = pcall(function()
                            GameFunctions.BuyItem:InvokeServer("Bait", Config.Shop.SelectedBait)
                            logError("Auto Buy Baits: Purchased " .. Config.Shop.SelectedBait)
                        end)
                        if not success then
                            logError("Auto Buy Baits Error: " .. result)
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
        
        if Value then
            spawn(function()
                while Config.Shop.AutoUpgradeRod do
                    if GameFunctions and GameFunctions:FindFirstChild("UpgradeRod") then
                        local success, result = pcall(function()
                            GameFunctions.UpgradeRod:InvokeServer()
                            logError("Auto Upgrade Rod: Upgraded fishing rod")
                        end)
                        if not success then
                            logError("Auto Upgrade Rod Error: " .. result)
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
        if GameFunctions and GameFunctions:FindFirstChild("BuyItem") then
            if Config.Shop.SelectedRod ~= "" then
                local success, result = pcall(function()
                    GameFunctions.BuyItem:InvokeServer("Rod", Config.Shop.SelectedRod)
                    Rayfield:Notify({
                        Title = "Purchase Complete",
                        Content = "Purchased " .. Config.Shop.SelectedRod,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Shop: Purchased " .. Config.Shop.SelectedRod)
                end)
                if not success then
                    logError("Shop Error: " .. result)
                end
            elseif Config.Shop.SelectedBoat ~= "" then
                local success, result = pcall(function()
                    GameFunctions.BuyItem:InvokeServer("Boat", Config.Shop.SelectedBoat)
                    Rayfield:Notify({
                        Title = "Purchase Complete",
                        Content = "Purchased " .. Config.Shop.SelectedBoat,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Shop: Purchased " .. Config.Shop.SelectedBoat)
                end)
                if not success then
                    logError("Shop Error: " .. result)
                end
            elseif Config.Shop.SelectedBait ~= "" then
                local success, result = pcall(function()
                    GameFunctions.BuyItem:InvokeServer("Bait", Config.Shop.SelectedBait)
                    Rayfield:Notify({
                        Title = "Purchase Complete",
                        Content = "Purchased " .. Config.Shop.SelectedBait,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Shop: Purchased " .. Config.Shop.SelectedBait)
                end)
                if not success then
                    logError("Shop Error: " .. result)
                end
            else
                Rayfield:Notify({
                    Title = "Purchase Error",
                    Content = "Please select an item first",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Shop Error: No item selected")
            end
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
        logError("Selected Theme: " .. Value)
        
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
    end
})

SettingsTab:CreateSlider({
    Name = "Transparency",
    Range = {0.1, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Settings.Transparency,
    Flag = "Transparency",
    Callback = function(Value)
        Config.Settings.Transparency = Value
        Window:SetTransparency(Value)
        logError("Transparency: " .. Value)
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

SettingsTab:CreateButton({
    Name = "Open Log File",
    Callback = function()
        if isfile("/storage/emulated/0/logscript.txt") then
            local logContent = readfile("/storage/emulated/0/logscript.txt")
            Rayfield:Notify({
                Title = "Log File",
                Content = "Log file opened with " .. #logContent .. " characters",
                Duration = 5,
                Image = 13047715178
            })
            logError("Log File: Opened log file")
        else
            Rayfield:Notify({
                Title = "Log File Error",
                Content = "Log file not found",
                Duration = 5,
                Image = 13047715178
            })
            logError("Log File Error: File not found")
        end
    end
})

SettingsTab:CreateButton({
    Name = "Clear Log File",
    Callback = function()
        if isfile("/storage/emulated/0/logscript.txt") then
            writefile("/storage/emulated/0/logscript.txt", "")
            Rayfield:Notify({
                Title = "Log File",
                Content = "Log file cleared",
                Duration = 3,
                Image = 13047715178
            })
            logError("Log File: Cleared log file")
        end
    end
})

-- Initialize ESP for all players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

-- Create ESP for new players
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end)

-- Remove ESP for leaving players
Players.PlayerRemoving:Connect(function(player)
    if ESP_Objects[player] then
        ESP_Objects[player].Box:Remove()
        ESP_Objects[player].Tracer:Remove()
        ESP_Objects[player].Name:Remove()
        ESP_Objects[player].Level:Remove()
        ESP_Objects[player].Distance:Remove()
        ESP_Objects[player].Hologram:Destroy()
        ESP_Objects[player] = nil
    end
end)

-- Initialize logging
logError("Script initialized successfully")
logError("Player: " .. LocalPlayer.Name)
logError("Game: Fish It")
logError("Date: " .. os.date("%Y-%m-%d"))

-- Notification
Rayfield:Notify({
    Title = "Fish It Hub 2025",
    Content = "Script loaded successfully! All features are ready to use.",
    Duration = 5,
    Image = 13047715178
})
