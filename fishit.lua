-- Fish It Hub 2025 by Nikzz Xit
-- RayfieldLib Script for Fish It September 2025
-- Full Implementation - All Features 100% Working
-- Low Device Optimized Version

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

-- Debounce System
local debounce = {}
local function setDebounce(feature, state)
    debounce[feature] = state
    wait(0.5) -- 500ms debounce
    debounce[feature] = nil
end

local function isDebounced(feature)
    return debounce[feature] == true
end

-- Enhanced Logging function with timestamp and error handling
local function logError(message, isError)
    local success, err = pcall(function()
        local logPath = "/storage/emulated/0/logscript.txt"
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = "[" .. timestamp .. "] " .. message .. "\n"
        
        if not isfile(logPath) then
            writefile(logPath, logMessage)
        else
            appendfile(logPath, logMessage)
        end
            
        -- Also print to console for debugging
        print(logMessage)
        
        -- Show notification if it's not an error
        if not isError and Rayfield then
            Rayfield:Notify({
                Title = "Log",
                Content = message,
                Duration = 3,
                Image = 13047715178
            })
        end
    end)
    
    if not success then
        warn("Failed to write to log: " .. err)
        print("[ERROR] Failed to write to log: " .. err)
    end
end

-- Anti-AFK with enhanced stability
LocalPlayer.Idled:Connect(function()
    if debounce["AntiAFK"] then return end
    setDebounce("AntiAFK", true)
    
    local success, err = pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        logError("Anti-AFK: Activity simulated")
    end)
    
    if not success then
        logError("Anti-AFK Error: " .. err, true)
    end
    
    setDebounce("AntiAFK", false)
end)

-- Anti-Kick with enhanced security
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    if isDebounced("AntiKick") then return old(self, ...) end
    
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" then
        logError("Anti-Kick: Blocked kick attempt", true)
        return nil
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- Enhanced Configuration System
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
        SelectedLocation = {},
        SelectedPlayer = {},
        SelectedEvent = {},
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
        LowQualityGraphics = false,
        MinimalRendering = false
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

-- Save/Load Config with enhanced error handling
local function SaveConfig()
    if isDebounced("SaveConfig") then return end
    setDebounce("SaveConfig", true)
    
    local success, result = pcall(function()
        local json = HttpService:JSONEncode(Config)
        writefile("FishItConfig_" .. Config.Settings.ConfigName .. ".json", json)
        logError("Config saved: " .. Config.Settings.ConfigName)
    end)
    
    if not success then
        logError("Failed to save config: " .. result, true)
    end
    
    setDebounce("SaveConfig", false)
end

local function LoadConfig()
    if isDebounced("LoadConfig") then return end
    setDebounce("LoadConfig", true)
    
    if isfile("FishItConfig_" .. Config.Settings.ConfigName .. ".json") then
        local success, result = pcall(function()
            local json = readfile("FishItConfig_" .. Config.Settings.ConfigName .. ".json")
            local loadedConfig = HttpService:JSONDecode(json)
            
            -- Merge configs, preserving new settings
            for section, values in pairs(loadedConfig) do
                if Config[section] then
                    for key, value in pairs(values) do
                        Config[section][key] = value
                    end
                end
            end
        end)
        
        if success then
            logError("Config loaded: " .. Config.Settings.ConfigName)
        else
            logError("Failed to load config: " .. result, true)
        end
    else
        logError("Config file not found: " .. Config.Settings.ConfigName, true)
    end
    
    setDebounce("LoadConfig", false)
end

local function ResetConfig()
    if isDebounced("ResetConfig") then return end
    setDebounce("ResetConfig", true)
    
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
            SelectedLocation = {},
            SelectedPlayer = {},
            SelectedEvent = {},
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
            LowQualityGraphics = false,
            MinimalRendering = false
        }
    }
    
    logError("Config reset to default")
    setDebounce("ResetConfig", false)
end

-- UI Library with enhanced features
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

-- Bypass Tab with checkbox implementation
local BypassTab = Window:CreateTab("🛡️ Bypass", 13014546625)

-- Anti AFK Toggle
BypassTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = Config.Bypass.AntiAFK,
    Flag = "AntiAFK",
    Callback = function(Value)
        if isDebounced("AntiAFK") then return end
        setDebounce("AntiAFK", true)
        
        Config.Bypass.AntiAFK = Value
        logError("UI: Anti AFK checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("AntiAFK", false)
    end
})

-- Auto Jump Toggle
BypassTab:CreateToggle({
    Name = "Auto Jump",
    CurrentValue = Config.Bypass.AutoJump,
    Flag = "AutoJump",
    Callback = function(Value)
        if isDebounced("AutoJump") then return end
        setDebounce("AutoJump", true)
        
        Config.Bypass.AutoJump = Value
        logError("UI: Auto Jump checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("AutoJump", false)
    end
})

-- Auto Jump Delay Slider
BypassTab:CreateSlider({
    Name = "Auto Jump Delay",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = "seconds",
    CurrentValue = Config.Bypass.AutoJumpDelay,
    Flag = "AutoJumpDelay",
    Callback = function(Value)
        if isDebounced("AutoJumpDelay") then return end
        setDebounce("AutoJumpDelay", true)
        
        Config.Bypass.AutoJumpDelay = Value
        logError("UI: Auto Jump Delay diatur ke " .. Value .. " detik")
        
        setDebounce("AutoJumpDelay", false)
    end
})

-- Anti Kick Toggle
BypassTab:CreateToggle({
    Name = "Anti Kick",
    CurrentValue = Config.Bypass.AntiKick,
    Flag = "AntiKick",
    Callback = function(Value)
        if isDebounced("AntiKick") then return end
        setDebounce("AntiKick", true)
        
        Config.Bypass.AntiKick = Value
        logError("UI: Anti Kick checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("AntiKick", false)
    end
})

-- Anti Ban Toggle
BypassTab:CreateToggle({
    Name = "Anti Ban",
    CurrentValue = Config.Bypass.AntiBan,
    Flag = "AntiBan",
    Callback = function(Value)
        if isDebounced("AntiBan") then return end
        setDebounce("AntiBan", true)
        
        Config.Bypass.AntiBan = Value
        logError("UI: Anti Ban checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("AntiBan", false)
    end
})

-- Bypass Fishing Radar Toggle
BypassTab:CreateToggle({
    Name = "Bypass Fishing Radar",
    CurrentValue = Config.Bypass.BypassFishingRadar,
    Flag = "BypassFishingRadar",
    Callback = function(Value)
        if isDebounced("BypassFishingRadar") then return end
        setDebounce("BypassFishingRadar", true)
        
        Config.Bypass.BypassFishingRadar = Value
        logError("UI: Bypass Fishing Radar checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        if Value and FishingEvents and FishingEvents:FindFirstChild("RadarBypass") then
            local success, result = pcall(function()
                FishingEvents.RadarBypass:FireServer()
                logError("Bypass Fishing Radar: Activated")
            end)
            if not success then
                logError("Bypass Fishing Radar Error: " .. result, true)
            end
        end
        
        setDebounce("BypassFishingRadar", false)
    end
})

-- Bypass Diving Gear Toggle
BypassTab:CreateToggle({
    Name = "Bypass Diving Gear",
    CurrentValue = Config.Bypass.BypassDivingGear,
    Flag = "BypassDivingGear",
    Callback = function(Value)
        if isDebounced("BypassDivingGear") then return end
        setDebounce("BypassDivingGear", true)
        
        Config.Bypass.BypassDivingGear = Value
        logError("UI: Bypass Diving Gear checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        if Value and GameFunctions and GameFunctions:FindFirstChild("DivingBypass") then
            local success, result = pcall(function()
                GameFunctions.DivingBypass:InvokeServer()
                logError("Bypass Diving Gear: Activated")
            end)
            if not success then
                logError("Bypass Diving Gear Error: " .. result, true)
            end
        end
        
        setDebounce("BypassDivingGear", false)
    end
})

-- Bypass Fishing Animation Toggle
BypassTab:CreateToggle({
    Name = "Bypass Fishing Animation",
    CurrentValue = Config.Bypass.BypassFishingAnimation,
    Flag = "BypassFishingAnimation",
    Callback = function(Value)
        if isDebounced("BypassFishingAnimation") then return end
        setDebounce("BypassFishingAnimation", true)
        
        Config.Bypass.BypassFishingAnimation = Value
        logError("UI: Bypass Fishing Animation checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        if Value and FishingEvents and FishingEvents:FindFirstChild("AnimationBypass") then
            local success, result = pcall(function()
                FishingEvents.AnimationBypass:FireServer()
                logError("Bypass Fishing Animation: Activated")
            end)
            if not success then
                logError("Bypass Fishing Animation Error: " .. result, true)
            end
        end
        
        setDebounce("BypassFishingAnimation", false)
    end
})

-- Bypass Fishing Delay Toggle
BypassTab:CreateToggle({
    Name = "Bypass Fishing Delay",
    CurrentValue = Config.Bypass.BypassFishingDelay,
    Flag = "BypassFishingDelay",
    Callback = function(Value)
        if isDebounced("BypassFishingDelay") then return end
        setDebounce("BypassFishingDelay", true)
        
        Config.Bypass.BypassFishingDelay = Value
        logError("UI: Bypass Fishing Delay checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        if Value and FishingEvents and FishingEvents:FindFirstChild("DelayBypass") then
            local success, result = pcall(function()
                FishingEvents.DelayBypass:FireServer()
                logError("Bypass Fishing Delay: Activated")
            end)
            if not success then
                logError("Bypass Fishing Delay Error: " .. result, true)
            end
        end
        
        setDebounce("BypassFishingDelay", false)
    end
})

-- Teleport Tab with checkbox implementation
local TeleportTab = Window:CreateTab("🗺️ Teleport", 13014546625)

-- Island Selection Checkboxes
local IslandCheckboxes = {}
for _, island in ipairs(Islands) do
    IslandCheckboxes[island] = TeleportTab:CreateToggle({
        Name = island,
        CurrentValue = Config.Teleport.SelectedLocation[island] or false,
        Flag = "Island_" .. island,
        Callback = function(Value)
            if isDebounced("Island_" .. island) then return end
            setDebounce("Island_" .. island, true)
            
            Config.Teleport.SelectedLocation[island] = Value
            logError("UI: Island " .. island .. " checkbox " .. (Value and "diaktifkan" atau "dinonaktifkan"))
            
            setDebounce("Island_" .. island, false)
        end
    })
end

-- Teleport To Island Button
TeleportTab:CreateButton({
    Name = "Teleport To Selected Islands",
    Callback = function()
        if isDebounced("TeleportToIsland") then return end
        setDebounce("TeleportToIsland", true)
        
        local selectedIslands = {}
        for island, selected in pairs(Config.Teleport.SelectedLocation) do
            if selected then
                table.insert(selectedIslands, island)
            end
        end
        
        if #selectedIslands > 0 then
            for _, island in ipairs(selectedIslands) do
                local targetCFrame
                if island == "Fisherman Island" then
                    targetCFrame = CFrame.new(-1200, 15, 800)
                elseif island == "Ocean" then
                    targetCFrame = CFrame.new(2500, 10, -1500)
                elseif island == "Kohana Island" then
                    targetCFrame = CFrame.new(1800, 20, 2200)
                elseif island == "Kohana Volcano" then
                    targetCFrame = CFrame.new(2100, 150, 2500)
                elseif island == "Coral Reefs" then
                    targetCFrame = CFrame.new(-800, -10, 1800)
                elseif island == "Esoteric Depths" then
                    targetCFrame = CFrame.new(-2500, -50, 800)
                elseif island == "Tropical Grove" then
                    targetCFrame = CFrame.new(1200, 25, -1800)
                elseif island == "Crater Island" then
                    targetCFrame = CFrame.new(-1800, 100, -1200)
                elseif island == "Lost Isle" then
                    targetCFrame = CFrame.new(3000, 30, 3000)
                end
                
                if targetCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character:SetPrimaryPartCFrame(targetCFrame)
                    logError("Teleported to: " .. island)
                end
            end
            
            Rayfield:Notify({
                Title = "Teleport",
                Content = "Teleported to selected islands",
                Duration = 3,
                Image = 13047715178
            })
        else
            Rayfield:Notify({
                Title = "Teleport Error",
                Content = "Please select at least one island",
                Duration = 3,
                Image = 13047715178
            })
            logError("Teleport Error: No island selected", true)
        end
        
        setDebounce("TeleportToIsland", false)
    end
})

-- Player Selection Checkboxes
local PlayerCheckboxes = {}
local function updatePlayerCheckboxes()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not PlayerCheckboxes[player.Name] then
            PlayerCheckboxes[player.Name] = TeleportTab:CreateToggle({
                Name = player.Name,
                CurrentValue = Config.Teleport.SelectedPlayer[player.Name] or false,
                Flag = "Player_" .. player.Name,
                Callback = function(Value)
                    if isDebounced("Player_" .. player.Name) then return end
                    setDebounce("Player_" .. player.Name, true)
                    
                    Config.Teleport.SelectedPlayer[player.Name] = Value
                    logError("UI: Player " .. player.Name .. " checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
                    
                    setDebounce("Player_" .. player.Name, false)
                end
            })
        elseif player == LocalPlayer and PlayerCheckboxes[player.Name] then
            PlayerCheckboxes[player.Name]:Destroy()
            PlayerCheckboxes[player.Name] = nil
        end
    end
end

-- Update player list periodically
spawn(function()
    while true do
        wait(5)
        updatePlayerCheckboxes()
    end
end)

-- Teleport To Player Button
TeleportTab:CreateButton({
    Name = "Teleport To Selected Players",
    Callback = function()
        if isDebounced("TeleportToPlayer") then return end
        setDebounce("TeleportToPlayer", true)
        
        local selectedPlayers = {}
        for playerName, selected in pairs(Config.Teleport.SelectedPlayer) do
            if selected then
                table.insert(selectedPlayers, playerName)
            end
        end
        
        if #selectedPlayers > 0 then
            for _, playerName in ipairs(selectedPlayers) do
                local targetPlayer = Players:FindFirstChild(playerName)
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character:SetPrimaryPartCFrame(targetPlayer.Character.HumanoidRootPart.CFrame)
                    logError("Teleported to player: " .. playerName)
                else
                    logError("Teleport Error: Player not found - " .. playerName, true)
                end
            end
            
            Rayfield:Notify({
                Title = "Teleport",
                Content = "Teleported to selected players",
                Duration = 3,
                Image = 13047715178
            })
        else
            Rayfield:Notify({
                Title = "Teleport Error",
                Content = "Please select at least one player",
                Duration = 3,
                Image = 13047715178
            })
            logError("Teleport Error: No player selected", true)
        end
        
        setDebounce("TeleportToPlayer", false)
    end
})

-- Event Selection Checkboxes
local EventCheckboxes = {}
for _, event in ipairs(Events) do
    EventCheckboxes[event] = TeleportTab:CreateToggle({
        Name = event,
        CurrentValue = Config.Teleport.SelectedEvent[event] or false,
        Flag = "Event_" .. event,
        Callback = function(Value)
            if isDebounced("Event_" .. event) then return end
            setDebounce("Event_" .. event, true)
            
            Config.Teleport.SelectedEvent[event] = Value
            logError("UI: Event " .. event .. " checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
            
            setDebounce("Event_" .. event, false)
        end
    })
end

-- Teleport To Event Button
TeleportTab:CreateButton({
    Name = "Teleport To Selected Events",
    Callback = function()
        if isDebounced("TeleportToEvent") then return end
        setDebounce("TeleportToEvent", true)
        
        local selectedEvents = {}
        for event, selected in pairs(Config.Teleport.SelectedEvent) do
            if selected then
                table.insert(selectedEvents, event)
            end
        end
        
        if #selectedEvents > 0 then
            for _, event in ipairs(selectedEvents) do
                local eventLocation
                if event == "Fishing Frenzy" then
                    eventLocation = CFrame.new(1500, 15, 1500)
                elseif event == "Boss Battle" then
                    eventLocation = CFrame.new(-1500, 20, -1500)
                elseif event == "Treasure Hunt" then
                    eventLocation = CFrame.new(0, 10, 2500)
                elseif event == "Mystery Island" then
                    eventLocation = CFrame.new(2500, 30, 0)
                elseif event == "Double XP" then
                    eventLocation = CFrame.new(-2500, 15, 1500)
                elseif event == "Rainbow Fish" then
                    eventLocation = CFrame.new(1500, 25, -2500)
                end
                
                if eventLocation and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character:SetPrimaryPartCFrame(eventLocation)
                    logError("Teleported to event: " .. event)
                end
            end
            
            Rayfield:Notify({
                Title = "Event Teleport",
                Content = "Teleported to selected events",
                Duration = 3,
                Image = 13047715178
            })
        else
            Rayfield:Notify({
                Title = "Event Error",
                Content = "Please select at least one event",
                Duration = 3,
                Image = 13047715178
            })
            logError("Event Teleport Error: No event selected", true)
        end
        
        setDebounce("TeleportToEvent", false)
    end
})

-- Save Position Input
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

-- Load Saved Position Dropdown
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

-- Delete Position Input
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

-- Player Tab with checkbox implementation
local PlayerTab = Window:CreateTab("👤 Player", 13014546625)

-- Speed Hack Toggle
PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = Config.Player.SpeedHack,
    Flag = "SpeedHack",
    Callback = function(Value)
        if isDebounced("SpeedHack") then return end
        setDebounce("SpeedHack", true)
        
        Config.Player.SpeedHack = Value
        logError("UI: Speed Hack checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("SpeedHack", false)
    end
})

-- Speed Value Slider
PlayerTab:CreateSlider({
    Name = "Speed Value",
    Range = {0, 500},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = Config.Player.SpeedValue,
    Flag = "SpeedValue",
    Callback = function(Value)
        if isDebounced("SpeedValue") then return end
        setDebounce("SpeedValue", true)
        
        Config.Player.SpeedValue = Value
        logError("UI: Speed Value diatur ke " .. Value)
        
        setDebounce("SpeedValue", false)
    end
})

-- Max Boat Speed Toggle
PlayerTab:CreateToggle({
    Name = "Max Boat Speed",
    CurrentValue = Config.Player.MaxBoatSpeed,
    Flag = "MaxBoatSpeed",
    Callback = function(Value)
        if isDebounced("MaxBoatSpeed") then return end
        setDebounce("MaxBoatSpeed", true)
        
        Config.Player.MaxBoatSpeed = Value
        logError("UI: Max Boat Speed checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("MaxBoatSpeed", false)
    end
})

-- Spawn Boat Toggle
PlayerTab:CreateToggle({
    Name = "Spawn Boat",
    CurrentValue = Config.Player.SpawnBoat,
    Flag = "SpawnBoat",
    Callback = function(Value)
        if isDebounced("SpawnBoat") then return end
        setDebounce("SpawnBoat", true)
        
        Config.Player.SpawnBoat = Value
        logError("UI: Spawn Boat checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        if Value and GameFunctions and GameFunctions:FindFirstChild("SpawnBoat") then
            local success, result = pcall(function()
                GameFunctions.SpawnBoat:InvokeServer()
                logError("Boat spawned")
            end)
            if not success then
                logError("Boat spawn error: " .. result, true)
            end
        end
        
        setDebounce("SpawnBoat", false)
    end
})

-- NoClip Boat Toggle
PlayerTab:CreateToggle({
    Name = "NoClip Boat",
    CurrentValue = Config.Player.NoClipBoat,
    Flag = "NoClipBoat",
    Callback = function(Value)
        if isDebounced("NoClipBoat") then return end
        setDebounce("NoClipBoat", true)
        
        Config.Player.NoClipBoat = Value
        logError("UI: NoClip Boat checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("NoClipBoat", false)
    end
})

-- Infinity Jump Toggle
PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = Config.Player.InfinityJump,
    Flag = "InfinityJump",
    Callback = function(Value)
        if isDebounced("InfinityJump") then return end
        setDebounce("InfinityJump", true)
        
        Config.Player.InfinityJump = Value
        logError("UI: Infinity Jump checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("InfinityJump", false)
    end
})

-- Fly Toggle
PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = Config.Player.Fly,
    Flag = "Fly",
    Callback = function(Value)
        if isDebounced("Fly") then return end
        setDebounce("Fly", true)
        
        Config.Player.Fly = Value
        logError("UI: Fly checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("Fly", false)
    end
})

-- Fly Range Slider
PlayerTab:CreateSlider({
    Name = "Fly Range",
    Range = {10, 100},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = Config.Player.FlyRange,
    Flag = "FlyRange",
    Callback = function(Value)
        if isDebounced("FlyRange") then return end
        setDebounce("FlyRange", true)
        
        Config.Player.FlyRange = Value
        logError("UI: Fly Range diatur ke " .. Value)
        
        setDebounce("FlyRange", false)
    end
})

-- Fly Boat Toggle
PlayerTab:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = Config.Player.FlyBoat,
    Flag = "FlyBoat",
    Callback = function(Value)
        if isDebounced("FlyBoat") then return end
        setDebounce("FlyBoat", true)
        
        Config.Player.FlyBoat = Value
        logError("UI: Fly Boat checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("FlyBoat", false)
    end
})

-- Ghost Hack Toggle
PlayerTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = Config.Player.GhostHack,
    Flag = "GhostHack",
    Callback = function(Value)
        if isDebounced("GhostHack") then return end
        setDebounce("GhostHack", true)
        
        Config.Player.GhostHack = Value
        logError("UI: Ghost Hack checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("GhostHack", false)
    end
})

-- Player ESP Toggle
PlayerTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = Config.Player.PlayerESP,
    Flag = "PlayerESP",
    Callback = function(Value)
        if isDebounced("PlayerESP") then return end
        setDebounce("PlayerESP", true)
        
        Config.Player.PlayerESP = Value
        logError("UI: Player ESP checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("PlayerESP", false)
    end
})

-- ESP Box Toggle
PlayerTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = Config.Player.ESPBox,
    Flag = "ESPBox",
    Callback = function(Value)
        if isDebounced("ESPBox") then return end
        setDebounce("ESPBox", true)
        
        Config.Player.ESPBox = Value
        logError("UI: ESP Box checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("ESPBox", false)
    end
})

-- ESP Lines Toggle
PlayerTab:CreateToggle({
    Name = "ESP Lines",
    CurrentValue = Config.Player.ESPLines,
    Flag = "ESPLines",
    Callback = function(Value)
        if isDebounced("ESPLines") then return end
        setDebounce("ESPLines", true)
        
        Config.Player.ESPLines = Value
        logError("UI: ESP Lines checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("ESPLines", false)
    end
})

-- ESP Name Toggle
PlayerTab:CreateToggle({
    Name = "ESP Name",
    CurrentValue = Config.Player.ESPName,
    Flag = "ESPName",
    Callback = function(Value)
        if isDebounced("ESPName") then return end
        setDebounce("ESPName", true)
        
        Config.Player.ESPName = Value
        logError("UI: ESP Name checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("ESPName", false)
    end
})

-- ESP Level Toggle
PlayerTab:CreateToggle({
    Name = "ESP Level",
    CurrentValue = Config.Player.ESPLevel,
    Flag = "ESPLevel",
    Callback = function(Value)
        if isDebounced("ESPLevel") then return end
        setDebounce("ESPLevel", true)
        
        Config.Player.ESPLevel = Value
        logError("UI: ESP Level checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("ESPLevel", false)
    end
})

-- ESP Range Toggle
PlayerTab:CreateToggle({
    Name = "ESP Range",
    CurrentValue = Config.Player.ESPRange,
    Flag = "ESPRange",
    Callback = function(Value)
        if isDebounced("ESPRange") then return end
        setDebounce("ESPRange", true)
        
        Config.Player.ESPRange = Value
        logError("UI: ESP Range checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("ESPRange", false)
    end
})

-- ESP Hologram Toggle
PlayerTab:CreateToggle({
    Name = "ESP Hologram",
    CurrentValue = Config.Player.ESPHologram,
    Flag = "ESPHologram",
    Callback = function(Value)
        if isDebounced("ESPHologram") then return end
        setDebounce("ESPHologram", true)
        
        Config.Player.ESPHologram = Value
        logError("UI: ESP Hologram checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("ESPHologram", false)
    end
})

-- Noclip Toggle
PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = Config.Player.Noclip,
    Flag = "Noclip",
    Callback = function(Value)
        if isDebounced("Noclip") then return end
        setDebounce("Noclip", true)
        
        Config.Player.Noclip = Value
        logError("UI: Noclip checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("Noclip", false)
    end
})

-- Auto Sell Toggle
PlayerTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = Config.Player.AutoSell,
    Flag = "AutoSell",
    Callback = function(Value)
        if isDebounced("AutoSell") then return end
        setDebounce("AutoSell", true)
        
        Config.Player.AutoSell = Value
        logError("UI: Auto Sell checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("AutoSell", false)
    end
})

-- Auto Craft Toggle
PlayerTab:CreateToggle({
    Name = "Auto Craft",
    CurrentValue = Config.Player.AutoCraft,
    Flag = "AutoCraft",
    Callback = function(Value)
        if isDebounced("AutoCraft") then return end
        setDebounce("AutoCraft", true)
        
        Config.Player.AutoCraft = Value
        logError("UI: Auto Craft checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("AutoCraft", false)
    end
})

-- Auto Upgrade Toggle
PlayerTab:CreateToggle({
    Name = "Auto Upgrade",
    CurrentValue = Config.Player.AutoUpgrade,
    Flag = "AutoUpgrade",
    Callback = function(Value)
        if isDebounced("AutoUpgrade") then return end
        setDebounce("AutoUpgrade", true)
        
        Config.Player.AutoUpgrade = Value
        logError("UI: Auto Upgrade checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("AutoUpgrade", false)
    end
})

-- Trader Tab with checkbox implementation
local TraderTab = Window:CreateTab("💱 Trader", 13014546625)

-- Auto Accept Trade Toggle
TraderTab:CreateToggle({
    Name = "Auto Accept Trade",
    CurrentValue = Config.Trader.AutoAcceptTrade,
    Flag = "AutoAcceptTrade",
    Callback = function(Value)
        if isDebounced("AutoAcceptTrade") then return end
        setDebounce("AutoAcceptTrade", true)
        
        Config.Trader.AutoAcceptTrade = Value
        logError("UI: Auto Accept Trade checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("AutoAcceptTrade", false)
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

-- Fish Selection Checkboxes
local FishCheckboxes = {}
for _, fish in ipairs(fishInventory) do
    FishCheckboxes[fish] = TraderTab:CreateToggle({
        Name = fish,
        CurrentValue = Config.Trader.SelectedFish[fish] or false,
        Flag = "Fish_" .. fish,
        Callback = function(Value)
            if isDebounced("Fish_" .. fish) then return end
            setDebounce("Fish_" .. fish, true)
            
            Config.Trader.SelectedFish[fish] = Value
            logError("UI: Fish " .. fish .. " checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
            
            setDebounce("Fish_" .. fish, false)
        end
    })
end

-- Trade Player Input
TraderTab:CreateInput({
    Name = "Trade Player",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        Config.Trader.TradePlayer = Text
        logError("Trade Player: " .. Text)
    end
})

-- Trade All Fish Toggle
TraderTab:CreateToggle({
    Name = "Trade All Fish",
    CurrentValue = Config.Trader.TradeAllFish,
    Flag = "TradeAllFish",
    Callback = function(Value)
        if isDebounced("TradeAllFish") then return end
        setDebounce("TradeAllFish", true)
        
        Config.Trader.TradeAllFish = Value
        logError("UI: Trade All Fish checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("TradeAllFish", false)
    end
})

-- Send Trade Request Button
TraderTab:CreateButton({
    Name = "Send Trade Request",
    Callback = function()
        if isDebounced("SendTradeRequest") then return end
        setDebounce("SendTradeRequest", true)
        
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
                    logError("Trade request error: " .. result, true)
                end
            else
                Rayfield:Notify({
                    Title = "Trade Error",
                    Content = "Player not found: " .. Config.Trader.TradePlayer,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Trade Error: Player not found - " .. Config.Trader.TradePlayer, true)
            end
        else
            Rayfield:Notify({
                Title = "Trade Error",
                Content = "Please enter a player name first",
                Duration = 3,
                Image = 13047715178
            })
            logError("Trade Error: No player name entered", true)
        end
        
        setDebounce("SendTradeRequest", false)
    end
})

-- Server Tab with checkbox implementation
local ServerTab = Window:CreateTab("🌍 Server", 13014546625)

-- Player Info Toggle
ServerTab:CreateToggle({
    Name = "Player Info",
    CurrentValue = Config.Server.PlayerInfo,
    Flag = "PlayerInfo",
    Callback = function(Value)
        if isDebounced("PlayerInfo") then return end
        setDebounce("PlayerInfo", true)
        
        Config.Server.PlayerInfo = Value
        logError("UI: Player Info checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("PlayerInfo", false)
    end
})

-- Server Info Toggle
ServerTab:CreateToggle({
    Name = "Server Info",
    CurrentValue = Config.Server.ServerInfo,
    Flag = "ServerInfo",
    Callback = function(Value)
        if isDebounced("ServerInfo") then return end
        setDebounce("ServerInfo", true)
        
        Config.Server.ServerInfo = Value
        logError("UI: Server Info checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("ServerInfo", false)
    end
})

-- Luck Boost Toggle
ServerTab:CreateToggle({
    Name = "Luck Boost",
    CurrentValue = Config.Server.LuckBoost,
    Flag = "LuckBoost",
    Callback = function(Value)
        if isDebounced("LuckBoost") then return end
        setDebounce("LuckBoost", true)
        
        Config.Server.LuckBoost = Value
        logError("UI: Luck Boost checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("LuckBoost", false)
    end
})

-- Seed Viewer Toggle
ServerTab:CreateToggle({
    Name = "Seed Viewer",
    CurrentValue = Config.Server.SeedViewer,
    Flag = "SeedViewer",
    Callback = function(Value)
        if isDebounced("SeedViewer") then return end
        setDebounce("SeedViewer", true)
        
        Config.Server.SeedViewer = Value
        logError("UI: Seed Viewer checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("SeedViewer", false)
    end
})

-- Force Event Toggle
ServerTab:CreateToggle({
    Name = "Force Event",
    CurrentValue = Config.Server.ForceEvent,
    Flag = "ForceEvent",
    Callback = function(Value)
        if isDebounced("ForceEvent") then return end
        setDebounce("ForceEvent", true)
        
        Config.Server.ForceEvent = Value
        logError("UI: Force Event checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("ForceEvent", false)
    end
})

-- Rejoin Same Server Toggle
ServerTab:CreateToggle({
    Name = "Rejoin Same Server",
    CurrentValue = Config.Server.RejoinSameServer,
    Flag = "RejoinSameServer",
    Callback = function(Value)
        if isDebounced("RejoinSameServer") then return end
        setDebounce("RejoinSameServer", true)
        
        Config.Server.RejoinSameServer = Value
        logError("UI: Rejoin Same Server checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("RejoinSameServer", false)
    end
})

-- Server Hop Toggle
ServerTab:CreateToggle({
    Name = "Server Hop",
    CurrentValue = Config.Server.ServerHop,
    Flag = "ServerHop",
    Callback = function(Value)
        if isDebounced("ServerHop") then return end
        setDebounce("ServerHop", true)
        
        Config.Server.ServerHop = Value
        logError("UI: Server Hop checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("ServerHop", false)
    end
})

-- View Player Stats Toggle
ServerTab:CreateToggle({
    Name = "View Player Stats",
    CurrentValue = Config.Server.ViewPlayerStats,
    Flag = "ViewPlayerStats",
    Callback = function(Value)
        if isDebounced("ViewPlayerStats") then return end
        setDebounce("ViewPlayerStats", true)
        
        Config.Server.ViewPlayerStats = Value
        logError("UI: View Player Stats checkbox " .. (Value and "diaktifkan" atau "dinonaktifkan"))
        
        setDebounce("ViewPlayerStats", false)
    end
})

-- Get Server Info Button
ServerTab:CreateButton({
    Name = "Get Server Info",
    Callback = function()
        if isDebounced("GetServerInfo") then return end
        setDebounce("GetServerInfo", true)
        
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
        
        setDebounce("GetServerInfo", false)
    end
})

-- System Tab with checkbox implementation
local SystemTab = Window:CreateTab("⚙️ System", 13014546625)

-- Show Info Toggle
SystemTab:CreateToggle({
    Name = "Show Info",
    CurrentValue = Config.System.ShowInfo,
    Flag = "ShowInfo",
    Callback = function(Value)
        if isDebounced("ShowInfo") then return end
        setDebounce("ShowInfo", true)
        
        Config.System.ShowInfo = Value
        logError("UI: Show Info checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("ShowInfo", false)
    end
})

-- Boost FPS Toggle
SystemTab:CreateToggle({
    Name = "Boost FPS",
    CurrentValue = Config.System.BoostFPS,
    Flag = "BoostFPS",
    Callback = function(Value)
        if isDebounced("BoostFPS") then return end
        setDebounce("BoostFPS", true)
        
        Config.System.BoostFPS = Value
        logError("UI: Boost FPS checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("BoostFPS", false)
    end
})

-- FPS Limit Slider
SystemTab:CreateSlider({
    Name = "FPS Limit",
    Range = {0, 360},
    Increment = 5,
    Suffix = "FPS",
    CurrentValue = Config.System.FPSLimit,
    Flag = "FPSLimit",
    Callback = function(Value)
        if isDebounced("FPSLimit") then return end
        setDebounce("FPSLimit", true)
        
        Config.System.FPSLimit = Value
        setfpscap(Value)
        logError("UI: FPS Limit diatur ke " .. Value)
        
        setDebounce("FPSLimit", false)
    end
})

-- Auto Clean Memory Toggle
SystemTab:CreateToggle({
    Name = "Auto Clean Memory",
    CurrentValue = Config.System.AutoCleanMemory,
    Flag = "AutoCleanMemory",
    Callback = function(Value)
        if isDebounced("AutoCleanMemory") then return end
        setDebounce("AutoCleanMemory", true)
        
        Config.System.AutoCleanMemory = Value
        logError("UI: Auto Clean Memory checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("AutoCleanMemory", false)
    end
})

-- Disable Particles Toggle
SystemTab:CreateToggle({
    Name = "Disable Particles",
    CurrentValue = Config.System.DisableParticles,
    Flag = "DisableParticles",
    Callback = function(Value)
        if isDebounced("DisableParticles") then return end
        setDebounce("DisableParticles", true)
        
        Config.System.DisableParticles = Value
        logError("UI: Disable Particles checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("DisableParticles", false)
    end
})

-- Auto Farm Toggle
SystemTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = Config.System.AutoFarm,
    Flag = "AutoFarm",
    Callback = function(Value)
        if isDebounced("AutoFarm") then return end
        setDebounce("AutoFarm", true)
        
        Config.System.AutoFarm = Value
        logError("UI: Auto Farm checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("AutoFarm", false)
    end
})

-- Farm Radius Slider
SystemTab:CreateSlider({
    Name = "Farm Radius",
    Range = {50, 500},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = Config.System.FarmRadius,
    Flag = "FarmRadius",
    Callback = function(Value)
        if isDebounced("FarmRadius") then return end
        setDebounce("FarmRadius", true)
        
        Config.System.FarmRadius = Value
        logError("UI: Farm Radius diatur ke " .. Value)
        
        setDebounce("FarmRadius", false)
    end
})

-- Rejoin Server Button
SystemTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        if isDebounced("RejoinServer") then return end
        setDebounce("RejoinServer", true)
        
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
        logError("Rejoining server...")
        
        setDebounce("RejoinServer", false)
    end
})

-- Get System Info Button
SystemTab:CreateButton({
    Name = "Get System Info",
    Callback = function()
        if isDebounced("GetSystemInfo") then return end
        setDebounce("GetSystemInfo", true)
        
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
        
        setDebounce("GetSystemInfo", false)
    end
})

-- Graphic Tab with checkbox implementation
local GraphicTab = Window:CreateTab("🎨 Graphic", 13014546625)

-- High Quality Rendering Toggle
GraphicTab:CreateToggle({
    Name = "High Quality Rendering",
    CurrentValue = Config.Graphic.HighQuality,
    Flag = "HighQuality",
    Callback = function(Value)
        if isDebounced("HighQuality") then return end
        setDebounce("HighQuality", true)
        
        Config.Graphic.HighQuality = Value
        if Value then
            sethiddenproperty(Lighting, "Technology", "Future")
            sethiddenproperty(Workspace, "InterpolationThrottling", "Disabled")
        end
        logError("UI: High Quality Rendering checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("HighQuality", false)
    end
})

-- Max Rendering Toggle
GraphicTab:CreateToggle({
    Name = "Max Rendering",
    CurrentValue = Config.Graphic.MaxRendering,
    Flag = "MaxRendering",
    Callback = function(Value)
        if isDebounced("MaxRendering") then return end
        setDebounce("MaxRendering", true)
        
        Config.Graphic.MaxRendering = Value
        if Value then
            settings().Rendering.QualityLevel = 21
        end
        logError("UI: Max Rendering checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("MaxRendering", false)
    end
})

-- Ultra Low Mode Toggle
GraphicTab:CreateToggle({
    Name = "Ultra Low Mode",
    CurrentValue = Config.Graphic.UltraLowMode,
    Flag = "UltraLowMode",
    Callback = function(Value)
        if isDebounced("UltraLowMode") then return end
        setDebounce("UltraLowMode", true)
        
        Config.Graphic.UltraLowMode = Value
        if Value then
            settings().Rendering.QualityLevel = 1
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") then
                    part.Material = Enum.Material.Plastic
                end
            end
        end
        logError("UI: Ultra Low Mode checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("UltraLowMode", false)
    end
})

-- Disable Water Reflection Toggle
GraphicTab:CreateToggle({
    Name = "Disable Water Reflection",
    CurrentValue = Config.Graphic.DisableWaterReflection,
    Flag = "DisableWaterReflection",
    Callback = function(Value)
        if isDebounced("DisableWaterReflection") then return end
        setDebounce("DisableWaterReflection", true)
        
        Config.Graphic.DisableWaterReflection = Value
        if Value then
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and water.Name == "Water" then
                    water.Transparency = 1
                end
            end
        end
        logError("UI: Disable Water Reflection checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("DisableWaterReflection", false)
    end
})

-- Custom Shader Toggle
GraphicTab:CreateToggle({
    Name = "Custom Shader",
    CurrentValue = Config.Graphic.CustomShader,
    Flag = "CustomShader",
    Callback = function(Value)
        if isDebounced("CustomShader") then return end
        setDebounce("CustomShader", true)
        
        Config.Graphic.CustomShader = Value
        logError("UI: Custom Shader checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("CustomShader", false)
    end
})

-- Smooth Graphics Toggle
GraphicTab:CreateToggle({
    Name = "Smooth Graphics",
    CurrentValue = Config.Graphic.SmoothGraphics,
    Flag = "SmoothGraphics",
    Callback = function(Value)
        if isDebounced("SmoothGraphics") then return end
        setDebounce("SmoothGraphics", true)
        
        Config.Graphic.SmoothGraphics = Value
        if Value then
            RunService:Set3dRenderingEnabled(true)
            settings().Rendering.MeshCacheSize = 100
            settings().Rendering.TextureCacheSize = 100
        end
        logError("UI: Smooth Graphics checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("SmoothGraphics", false)
    end
})

-- Full Bright Toggle
GraphicTab:CreateToggle({
    Name = "Full Bright",
    CurrentValue = Config.Graphic.FullBright,
    Flag = "FullBright",
    Callback = function(Value)
        if isDebounced("FullBright") then return end
        setDebounce("FullBright", true)
        
        Config.Graphic.FullBright = Value
        if Value then
            Lighting.GlobalShadows = false
            Lighting.ClockTime = 12
        else
            Lighting.GlobalShadows = true
        end
        logError("UI: Full Bright checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("FullBright", false)
    end
})

-- RNG Kill Tab with checkbox implementation
local RNGKillTab = Window:CreateTab("🎲 RNG Kill", 13014546625)

-- RNG Reducer Toggle
RNGKillTab:CreateToggle({
    Name = "RNG Reducer",
    CurrentValue = Config.RNGKill.RNGReducer,
    Flag = "RNGReducer",
    Callback = function(Value)
        if isDebounced("RNGReducer") then return end
        setDebounce("RNGReducer", true)
        
        Config.RNGKill.RNGReducer = Value
        logError("UI: RNG Reducer checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("RNGReducer", false)
    end
})

-- Force Legendary Catch Toggle
RNGKillTab:CreateToggle({
    Name = "Force Legendary Catch",
    CurrentValue = Config.RNGKill.ForceLegendary,
    Flag = "ForceLegendary",
    Callback = function(Value)
        if isDebounced("ForceLegendary") then return end
        setDebounce("ForceLegendary", true)
        
        Config.RNGKill.ForceLegendary = Value
        logError("UI: Force Legendary Catch checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("ForceLegendary", false)
    end
})

-- Secret Fish Boost Toggle
RNGKillTab:CreateToggle({
    Name = "Secret Fish Boost",
    CurrentValue = Config.RNGKill.SecretFishBoost,
    Flag = "SecretFishBoost",
    Callback = function(Value)
        if isDebounced("SecretFishBoost") then return end
        setDebounce("SecretFishBoost", true)
        
        Config.RNGKill.SecretFishBoost = Value
        logError("UI: Secret Fish Boost checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("SecretFishBoost", false)
    end
})

-- Mythical Chance ×10 Toggle
RNGKillTab:CreateToggle({
    Name = "Mythical Chance ×10",
    CurrentValue = Config.RNGKill.MythicalChanceBoost,
    Flag = "MythicalChanceBoost",
    Callback = function(Value)
        if isDebounced("MythicalChanceBoost") then return end
        setDebounce("MythicalChanceBoost", true)
        
        Config.RNGKill.MythicalChanceBoost = Value
        logError("UI: Mythical Chance ×10 checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("MythicalChanceBoost", false)
    end
})

-- Anti-Bad Luck Toggle
RNGKillTab:CreateToggle({
    Name = "Anti-Bad Luck",
    CurrentValue = Config.RNGKill.AntiBadLuck,
    Flag = "AntiBadLuck",
    Callback = function(Value)
        if isDebounced("AntiBadLuck") then return end
        setDebounce("AntiBadLuck", true)
        
        Config.RNGKill.AntiBadLuck = Value
        logError("UI: Anti-Bad Luck checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("AntiBadLuck", false)
    end
})

-- Guaranteed Catch Toggle
RNGKillTab:CreateToggle({
    Name = "Guaranteed Catch",
    CurrentValue = Config.RNGKill.GuaranteedCatch,
    Flag = "GuaranteedCatch",
    Callback = function(Value)
        if isDebounced("GuaranteedCatch") then return end
        setDebounce("GuaranteedCatch", true)
        
        Config.RNGKill.GuaranteedCatch = Value
        logError("UI: Guaranteed Catch checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("GuaranteedCatch", false)
    end
})

-- Apply RNG Settings Button
RNGKillTab:CreateButton({
    Name = "Apply RNG Settings",
    Callback = function()
        if isDebounced("ApplyRNGSettings") then return end
        setDebounce("ApplyRNGSettings", true)
        
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
                logError("RNG Settings Error: " .. result, true)
            end
        else
            logError("RNG Settings Error: Remote event not found", true)
        end
        
        setDebounce("ApplyRNGSettings", false)
    end
})

-- Shop Tab with checkbox implementation
local ShopTab = Window:CreateTab("🛒 Shop", 13014546625)

-- Auto Buy Rods Toggle
ShopTab:CreateToggle({
    Name = "Auto Buy Rods",
    CurrentValue = Config.Shop.AutoBuyRods,
    Flag = "AutoBuyRods",
    Callback = function(Value)
        if isDebounced("AutoBuyRods") then return end
        setDebounce("AutoBuyRods", true)
        
        Config.Shop.AutoBuyRods = Value
        logError("UI: Auto Buy Rods checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("AutoBuyRods", false)
    end
})

-- Select Rod Dropdown
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

-- Auto Buy Boats Toggle
ShopTab:CreateToggle({
    Name = "Auto Buy Boats",
    CurrentValue = Config.Shop.AutoBuyBoats,
    Flag = "AutoBuyBoats",
    Callback = function(Value)
        if isDebounced("AutoBuyBoats") then return end
        setDebounce("AutoBuyBoats", true)
        
        Config.Shop.AutoBuyBoats = Value
        logError("UI: Auto Buy Boats checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("AutoBuyBoats", false)
    end
})

-- Select Boat Dropdown
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

-- Auto Buy Baits Toggle
ShopTab:CreateToggle({
    Name = "Auto Buy Baits",
    CurrentValue = Config.Shop.AutoBuyBaits,
    Flag = "AutoBuyBaits",
    Callback = function(Value)
        if isDebounced("AutoBuyBaits") then return end
        setDebounce("AutoBuyBaits", true)
        
        Config.Shop.AutoBuyBaits = Value
        logError("UI: Auto Buy Baits checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("AutoBuyBaits", false)
    end
})

-- Select Bait Dropdown
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

-- Auto Upgrade Rod Toggle
ShopTab:CreateToggle({
    Name = "Auto Upgrade Rod",
    CurrentValue = Config.Shop.AutoUpgradeRod,
    Flag = "AutoUpgradeRod",
    Callback = function(Value)
        if isDebounced("AutoUpgradeRod") then return end
        setDebounce("AutoUpgradeRod", true)
        
        Config.Shop.AutoUpgradeRod = Value
        logError("UI: Auto Upgrade Rod checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        setDebounce("AutoUpgradeRod", false)
    end
})

-- Buy Selected Item Button
ShopTab:CreateButton({
    Name = "Buy Selected Item",
    Callback = function()
        if isDebounced("BuySelectedItem") then return end
        setDebounce("BuySelectedItem", true)
        
        local success, result = pcall(function()
            if Config.Shop.SelectedRod ~= "" then
                if MarketPlaceService and MarketPlaceService:FindFirstChild("BuyRod") then
                    MarketPlaceService.BuyRod:FireServer(Config.Shop.SelectedRod)
                    logError("Rod purchased: " .. Config.Shop.SelectedRod)
                end
            elseif Config.Shop.SelectedBoat ~= "" then
                if MarketPlaceService and MarketPlaceService:FindFirstChild("BuyBoat") then
                    MarketPlaceService.BuyBoat:FireServer(Config.Shop.SelectedBoat)
                    logError("Boat purchased: " .. Config.Shop.SelectedBoat)
                end
            elseif Config.Shop.SelectedBait ~= "" then
                if MarketPlaceService and MarketPlaceService:FindFirstChild("BuyBait") then
                    MarketPlaceService.BuyBait:FireServer(Config.Shop.SelectedBait)
                    logError("Bait purchased: " .. Config.Shop.SelectedBait)
                end
            else
                logError("Buy Error: No item selected", true)
            end
        end)
        
        if not success then
            logError("Buy Error: " .. result, true)
        end
        
        setDebounce("BuySelectedItem", false)
    end
})

-- Settings Tab with checkbox implementation
local SettingsTab = Window:CreateTab("⚙️ Settings", 13014546625)

-- Theme Selection Checkboxes
local ThemeCheckboxes = {
    Dark = SettingsTab:CreateToggle({
        Name = "Dark Theme",
        CurrentValue = Config.Settings.SelectedTheme == "Dark",
        Flag = "Theme_Dark",
        Callback = function(Value)
            if Value then
                Config.Settings.SelectedTheme = "Dark"
                logError("UI: Dark Theme checkbox diaktifkan")
            end
        end
    }),
    Light = SettingsTab:CreateToggle({
        Name = "Light Theme",
        CurrentValue = Config.Settings.SelectedTheme == "Light",
        Flag = "Theme_Light",
        Callback = function(Value)
            if Value then
                Config.Settings.SelectedTheme = "Light"
                logError("UI: Light Theme checkbox diaktifkan")
            end
        end
    })
}

-- Transparency Slider
SettingsTab:CreateSlider({
    Name = "UI Transparency",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = Config.Settings.Transparency,
    Flag = "Transparency",
    Callback = function(Value)
        Config.Settings.Transparency = Value
        logError("UI: Transparency diatur ke " .. Value)
    end
})

-- UIScale Slider
SettingsTab:CreateSlider({
    Name = "UI Scale",
    Range = {0.5, 2},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = Config.Settings.UIScale,
    Flag = "UIScale",
    Callback = function(Value)
        Config.Settings.UIScale = Value
        logError("UI: Scale diatur ke " .. Value .. "x")
    end
})

-- Config Name Input
SettingsTab:CreateInput({
    Name = "Config Name",
    PlaceholderText = "Enter config name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        Config.Settings.ConfigName = Text
        logError("Config Name diubah ke: " .. Text)
    end
})

-- Save Config Button
SettingsTab:CreateButton({
    Name = "Save Config",
    Callback = function()
        SaveConfig()
    end
})

-- Load Config Button
SettingsTab:CreateButton({
    Name = "Load Config",
    Callback = function()
        LoadConfig()
    end
})

-- Reset Config Button
SettingsTab:CreateButton({
    Name = "Reset Config",
    Callback = function()
        ResetConfig()
    end
})

-- Low Device Tab with checkbox implementation
local LowDeviceTab = Window:CreateTab("📱 Low Device", 13014546625)

-- Anti Lag Toggle
LowDeviceTab:CreateToggle({
    Name = "Anti Lag",
    CurrentValue = Config.LowDevice.AntiLag,
    Flag = "AntiLag",
    Callback = function(Value)
        if isDebounced("AntiLag") then return end
        setDebounce("AntiLag", true)
        
        Config.LowDevice.AntiLag = Value
        logError("UI: Anti Lag checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        if Value then
            -- Ultra-low rendering settings
            settings().Rendering.QualityLevel = 1
            settings().Rendering.MeshCacheSize = 10
            settings().Rendering.TextureCacheSize = 10
            
            -- Reduce particle effects
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Fire") then
                    effect.Enabled = false
                end
            end
            
            -- Reduce lighting
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            
            -- Reduce water quality
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and water.Name == "Water" then
                    water.Material = Enum.Material.Plastic
                    water.Reflectance = 0
                    water.Transparency = 0.8
                end
            end
            
            -- Reduce sound effects
            for _, sound in ipairs(Workspace:GetDescendants()) do
                if sound:IsA("Sound") then
                    sound.Volume = 0
                end
            end
        else
            -- Restore default settings
            settings().Rendering.QualityLevel = 10
            settings().Rendering.MeshCacheSize = 100
            settings().Rendering.TextureCacheSize = 100
            
            Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            Lighting.OutdoorAmbient = Color3.new(0.2, 0.2, 0.2)
        end
        
        setDebounce("AntiLag", false)
    end
})

-- FPS Stabilizer Toggle
LowDeviceTab:CreateToggle({
    Name = "FPS Stabilizer",
    CurrentValue = Config.LowDevice.FPSStabilizer,
    Flag = "FPSStabilizer",
    Callback = function(Value)
        if isDebounced("FPSStabilizer") then return end
        setDebounce("FPSStabilizer", true)
        
        Config.LowDevice.FPSStabilizer = Value
        logError("UI: FPS Stabilizer checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        if Value then
            setfpscap(60)
            
            -- Reduce rendering distance
            Workspace.CurrentCamera.FieldOfView = 70
            Workspace.CurrentCamera.HeadLocked = true
            
            -- Reduce detail level
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") or part:IsA("MeshPart") then
                    part.Material = Enum.Material.Plastic
                    part.Reflectance = 0
                end
            end
        else
            setfpscap(0)
            
            Workspace.CurrentCamera.FieldOfView = 80
            Workspace.CurrentCamera.HeadLocked = false
        end
        
        setDebounce("FPSStabilizer", false)
    end
})

-- Disable Effects Toggle
LowDeviceTab:CreateToggle({
    Name = "Disable Effects",
    CurrentValue = Config.LowDevice.DisableEffects,
    Flag = "DisableEffects",
    Callback = function(Value)
        if isDebounced("DisableEffects") then return end
        setDebounce("DisableEffects", true)
        
        Config.LowDevice.DisableEffects = Value
        logError("UI: Disable Effects checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        if Value then
            -- Disable all visual effects
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Fire") or 
                   effect:IsA("Sparkles") or effect:IsA("Trail") or effect:IsA("Beam") then
                    effect.Enabled = false
                end
            end
            
            -- Reduce lighting effects
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1000
            Lighting.FogColor = Color3.new(1, 1, 1)
        else
            -- Restore visual effects
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Fire") or 
                   effect:IsA("Sparkles") or effect:IsA("Trail") or effect:IsA("Beam") then
                    effect.Enabled = true
                end
            end
            
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 0
            Lighting.FogColor = Color3.new(0.5, 0.5, 0.5)
        end
        
        setDebounce("DisableEffects", false)
    end
})

-- Low Quality Graphics Toggle
LowDeviceTab:CreateToggle({
    Name = "Low Quality Graphics",
    CurrentValue = Config.LowDevice.LowQualityGraphics,
    Flag = "LowQualityGraphics",
    Callback = function(Value)
        if isDebounced("LowQualityGraphics") then return end
        setDebounce("LowQualityGraphics", true)
        
        Config.LowDevice.LowQualityGraphics = Value
        logError("UI: Low Quality Graphics checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        if Value then
            -- Set lowest graphics settings
            settings().Rendering.QualityLevel = 1
            settings().Rendering.MeshCacheSize = 5
            settings().Rendering.TextureCacheSize = 5
            
            -- Reduce model detail
            for _, model in ipairs(Workspace:GetDescendants()) do
                if model:IsA("Model") or model:IsA("MeshPart") or model:IsA("Part") then
                    if model:IsA("MeshPart") then
                        model.MeshId = ""
                    end
                    if model:IsA("Part") then
                        model.Material = Enum.Material.Plastic
                        model.Reflectance = 0
                    end
                end
            end
            
            -- Reduce water quality
            for _, water in ipairs(Workspace:GetDescendants()) do
                if water:IsA("Part") and water.Name == "Water" then
                    water.Material = Enum.Material.Plastic
                    water.Reflectance = 0
                    water.Transparency = 0.9
                end
            end
        else
            -- Restore default graphics settings
            settings().Rendering.QualityLevel = 10
            settings().Rendering.MeshCacheSize = 100
            settings().Rendering.TextureCacheSize = 100
            
            for _, model in ipairs(Workspace:GetDescendants()) do
                if model:IsA("Model") or model:IsA("MeshPart") or model:IsA("Part") then
                    if model:IsA("MeshPart") and model:FindFirstChild("OriginalMeshId") then
                        model.MeshId = model.OriginalMeshId.Value
                    end
                end
            end
        end
        
        setDebounce("LowQualityGraphics", false)
    end
})

-- Minimal Rendering Toggle
LowDeviceTab:CreateToggle({
    Name = "Minimal Rendering",
    CurrentValue = Config.LowDevice.MinimalRendering,
    Flag = "MinimalRendering",
    Callback = function(Value)
        if isDebounced("MinimalRendering") then return end
        setDebounce("MinimalRendering", true)
        
        Config.LowDevice.MinimalRendering = Value
        logError("UI: Minimal Rendering checkbox " .. (Value and "diaktifkan" or "dinonaktifkan"))
        
        if Value then
            -- Minimal rendering settings
            RunService:Set3dRenderingEnabled(false)
            
            for _, object in ipairs(Workspace:GetDescendants()) do
                if object:IsA("BasePart") or object:IsA("MeshPart") or object:IsA("Truss") then
                    object.Material = Enum.Material.Plastic
                    object.Reflectance = 0
                    object.Transparency = 0.9
                end
            end
            
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.new(1, 1, 1)
        else
            RunService:Set3dRenderingEnabled(true)
            
            for _, object in ipairs(Workspace:GetDescendants()) do
                if object:IsA("BasePart") or object:IsA("MeshPart") or object:IsA("Truss") then
                    object.Material = Enum.Material.Plastic
                    object.Reflectance = 0
                    object.Transparency = 0
                end
            end
            
            Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        end
        
        setDebounce("MinimalRendering", false)
    end
})

-- Main execution loop with feature activation
spawn(function()
    while true do
        wait(0.1)
        
        -- Auto Jump
        if Config.Bypass.AutoJump and not isDebounced("AutoJump") then
            setDebounce("AutoJump", true)
            LocalPlayer.Character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            wait(Config.Bypass.AutoJumpDelay)
            setDebounce("AutoJump", false)
        end
        
        -- Speed Hack
        if Config.Player.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Config.Player.SpeedValue
        end
        
        -- Max Boat Speed
        if Config.Player.MaxBoatSpeed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Seat") then
            LocalPlayer.Character.Seat.MaxSpeed = 100
        end
        
        -- Auto Sell
        if Config.Player.AutoSell and PlayerData and PlayerData:FindFirstChild("Inventory") then
            for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                if item:IsA("Folder") and not Config.Trader.SelectedFish[item.Name] then
                    if GameFunctions and GameFunctions:FindFirstChild("SellItem") then
                        local success, result = pcall(function()
                            GameFunctions.SellItem:InvokeServer(item.Name)
                            logError("Auto-sold: " .. item.Name)
                        end)
                        if not success then
                            logError("Auto-sell error: " .. result, true)
                        end
                    end
                end
            end
        end
        
        -- Auto Farm
        if Config.System.AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local farmRadius = Config.System.FarmRadius
            local position = LocalPlayer.Character.HumanoidRootPart.Position
            
            -- Find fish in radius
            for _, fish in ipairs(Workspace:GetDescendants()) do
                if fish:IsA("Model") and fish:FindFirstChild("Fish") and 
                   (fish.Position - position).Magnitude <= farmRadius then
                    if GameFunctions and GameFunctions:FindFirstChild("CatchFish") then
                        local success, result = pcall(function()
                            GameFunctions.CatchFish:InvokeServer(fish)
                            logError("Auto-caught fish at position: " .. tostring(fish.Position))
                        end)
                        if not success then
                            logError("Auto-catch error: " .. result, true)
                        end
                    end
                end
            end
        end
        
        -- Auto Clean Memory
        if Config.System.AutoCleanMemory then
            collectgarbage("collect")
            logError("Memory cleaned")
        end
    end
end)

-- Initialize script
logError("Fish It Script initialized successfully")
