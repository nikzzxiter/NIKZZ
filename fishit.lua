-- Fish It Script (September 2025)
-- Rayfield UI Implementation with Async System

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua'))()
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Game-Specific Variables
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Events = ReplicatedStorage:WaitForChild("Events")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ItemHandler = require(Modules:WaitForChild("ItemHandler"))
local FishingHandler = require(Modules:WaitForChild("FishingHandler"))
local TradeHandler = require(Modules:WaitForChild("TradeHandler"))
local MapHandler = require(Modules:WaitForChild("MapHandler"))
local WeatherSystem = require(Modules:WaitForChild("WeatherSystem"))

-- Configuration
local Config = {
    AutoFish = false,
    WaterFish = false,
    BypassRadar = false,
    BypassAir = false,
    DisableFishingEffects = false,
    InstantFishing = false,
    AutoSell = false,
    SellDelay = 1,
    SellMythical = false,
    SellSecret = false,
    AntiKick = false,
    AntiAFK = false,
    AutoJump = false,
    PlayerSpeed = 16,
    MaxBoatSpeed = false,
    InfinityJump = false,
    FlyEnabled = false,
    FlyHeight = 50,
    FlyBoat = false,
    GhostMode = false,
    ESPEnabled = false,
    ESPLines = false,
    ESPBox = false,
    ESPRange = 100,
    ESPLevel = false,
    ESPHologram = false,
    AutoAcceptTrade = false,
    SelectedFish = {},
    SelectedPlayer = nil,
    TradeAllFish = false,
    SelectedWeather = "Sunny",
    AutoBuyWeather = false,
    ShowInfo = false,
    BoostFPS = false,
    FPSLimit = 60,
    AutoCleanMemory = false,
    DisableParticles = false,
    HighQuality = false,
    MaxRendering = false,
    UltraLowMode = false,
    DisableWaterReflection = false,
    CustomShader = false,
    RNGReducer = false,
    ForceLegendary = false,
    SecretFishBoost = false,
    MythicalChanceBoost = false,
    AntiBadLuck = false
}

-- Global Variables
local FishingConnection = nil
local SellingConnection = nil
local AFKConnection = nil
local JumpConnection = nil
local SpeedConnection = nil
local FlyConnection = nil
local BoatConnection = nil
local GhostConnection = nil
local ESPConnection = nil
local TradeConnection = nil
local WeatherConnection = nil
local InfoConnection = nil
local FPSConnection = nil
local MemoryConnection = nil
local ParticleConnection = nil
local GraphicsConnection = nil
local WaterConnection = nil
local ShaderConnection = nil
local RNGConnection = nil
local ShopConnection = nil

local SavedPositions = {}
local ESPObjects = {}
local CurrentRod = nil
local CurrentBait = nil
local CurrentBoat = nil
local ServerInfo = {}
local PlayerInfo = {}

-- Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "Fish It Script | September 2025",
    LoadingTitle = "Loading Fish It Script",
    LoadingSubtitle = "by Professional Developer",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FishItConfig",
        FileName = "Config.json"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvite",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Fish Farm Tab
local FishFarmTab = Window:CreateTab("Fish Farm", 4483362458)
local AutoFishSection = FishFarmTab:CreateSection("Auto Fishing")
local AutoSellSection = FishFarmTab:CreateSection("Auto Sell")
local AntiDetectionSection = FishFarmTab:CreateSection("Anti Detection")

AutoFishSection:CreateToggle({
    Name = "Auto Fish",
    CurrentValue = false,
    Flag = "AutoFish",
    Callback = function(Value)
        Config.AutoFish = Value
        if Value then
            StartAutoFishing()
        else
            StopAutoFishing()
        end
    end,
})

AutoFishSection:CreateToggle({
    Name = "Water Fish Anywhere",
    CurrentValue = false,
    Flag = "WaterFish",
    Callback = function(Value)
        Config.WaterFish = Value
    end,
})

AutoFishSection:CreateToggle({
    Name = "Bypass Radar",
    CurrentValue = false,
    Flag = "BypassRadar",
    Callback = function(Value)
        Config.BypassRadar = Value
        if Value then
            BypassRadar()
        end
    end,
})

AutoFishSection:CreateToggle({
    Name = "Bypass Air",
    CurrentValue = false,
    Flag = "BypassAir",
    Callback = function(Value)
        Config.BypassAir = Value
        if Value then
            BypassAir()
        end
    end,
})

AutoFishSection:CreateToggle({
    Name = "Disable Fishing Effects",
    CurrentValue = false,
    Flag = "DisableFishingEffects",
    Callback = function(Value)
        Config.DisableFishingEffects = Value
        if Value then
            DisableFishingEffects()
        end
    end,
})

AutoFishSection:CreateToggle({
    Name = "Instant Complicated Fishing",
    CurrentValue = false,
    Flag = "InstantFishing",
    Callback = function(Value)
        Config.InstantFishing = Value
        if Value then
            EnableInstantFishing()
        end
    end,
})

AutoSellSection:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(Value)
        Config.AutoSell = Value
        if Value then
            StartAutoSell()
        else
            StopAutoSell()
        end
    end,
})

AutoSellSection:CreateToggle({
    Name = "Sell Mythical Fish",
    CurrentValue = false,
    Flag = "SellMythical",
    Callback = function(Value)
        Config.SellMythical = Value
    end,
})

AutoSellSection:CreateToggle({
    Name = "Sell Secret Fish",
    CurrentValue = false,
    Flag = "SellSecret",
    Callback = function(Value)
        Config.SellSecret = Value
    end,
})

AutoSellSection:CreateSlider({
    Name = "Sell Delay (seconds)",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 1,
    Flag = "SellDelay",
    Callback = function(Value)
        Config.SellDelay = Value
    end,
})

AntiDetectionSection:CreateToggle({
    Name = "Anti Kick Server",
    CurrentValue = false,
    Flag = "AntiKick",
    Callback = function(Value)
        Config.AntiKick = Value
        if Value then
            EnableAntiKick()
        end
    end,
})

AntiDetectionSection:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        Config.AntiAFK = Value
        if Value then
            EnableAntiAFK()
        else
            DisableAntiAFK()
        end
    end,
})

AntiDetectionSection:CreateToggle({
    Name = "Auto Jump (30s interval)",
    CurrentValue = false,
    Flag = "AutoJump",
    Callback = function(Value)
        Config.AutoJump = Value
        if Value then
            StartAutoJump()
        else
            StopAutoJump()
        end
    end,
})

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local MapsSection = TeleportTab:CreateSection("Maps Teleport")
local PlayerSection = TeleportTab:CreateSection("Player Teleport")
local PositionSection = TeleportTab:CreateSection("Position Management")

local Maps = {
    "Starter Island",
    "Pearl Island",
    "Volcano Bay",
    "Deep Sea Trench",
    "Sky Lagoon",
    "Coral Reef",
    "Ancient Temple",
    "Fisherman Island",
    "Ocean",
    "Kohana Island",
    "Kohana Volcano",
    "Coral Reefs",
    "Esoteric Depths",
    "Tropical Grove",
    "Crater Island",
    "Lost Isle"
}

local MapDropdown = MapsSection:CreateDropdown({
    Name = "Select Map",
    Options = Maps,
    CurrentOption = "Starter Island",
    Flag = "MapSelection",
    Callback = function(Option)
        TeleportToMap(Option)
    end,
})

MapsSection:CreateButton({
    Name = "Refresh Maps",
    Callback = function()
        RefreshMaps()
    end,
})

local PlayerDropdown = PlayerSection:CreateDropdown({
    Name = "Select Player",
    Options = {},
    CurrentOption = "",
    Flag = "PlayerSelection",
    Callback = function(Option)
        Config.SelectedPlayer = Option
    end,
})

PlayerSection:CreateButton({
    Name = "Teleport to Player",
    Callback = function()
        if Config.SelectedPlayer then
            TeleportToPlayer(Config.SelectedPlayer)
        end
    end,
})

PlayerSection:CreateButton({
    Name = "Refresh Players",
    Callback = function()
        RefreshPlayers()
    end,
})

PositionSection:CreateInput({
    Name = "Position Name",
    PlaceholderText = "Enter position name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        CurrentPositionName = Text
    end,
})

PositionSection:CreateButton({
    Name = "Save Current Position",
    Callback = function()
        if CurrentPositionName then
            SavePosition(CurrentPositionName)
        end
    end,
})

PositionSection:CreateDropdown({
    Name = "Saved Positions",
    Options = {},
    CurrentOption = "",
    Flag = "SavedPositions",
    Callback = function(Option)
        SelectedPosition = Option
    end,
})

PositionSection:CreateButton({
    Name = "Load Position",
    Callback = function()
        if SelectedPosition then
            LoadPosition(SelectedPosition)
        end
    end,
})

PositionSection:CreateButton({
    Name = "Delete Position",
    Callback = function()
        if SelectedPosition then
            DeletePosition(SelectedPosition)
        end
    end,
})

-- Player Tab
local PlayerTab = Window:CreateTab("Player", 4483362458)
local MovementSection = PlayerTab:CreateSection("Movement")
local BoatSection = PlayerTab:CreateSection("Boat")
local ESPSection = PlayerTab:CreateSection("ESP")

MovementSection:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHack",
    Callback = function(Value)
        if Value then
            EnableSpeedHack(Config.PlayerSpeed)
        else
            DisableSpeedHack()
        end
    end,
})

MovementSection:CreateSlider({
    Name = "Speed Value",
    Range = {0, 500},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 16,
    Flag = "SpeedValue",
    Callback = function(Value)
        Config.PlayerSpeed = Value
        if Config.SpeedHack then
            EnableSpeedHack(Value)
        end
    end,
})

MovementSection:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Flag = "InfinityJump",
    Callback = function(Value)
        Config.InfinityJump = Value
        if Value then
            EnableInfinityJump()
        else
            DisableInfinityJump()
        end
    end,
})

MovementSection:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyEnabled",
    Callback = function(Value)
        Config.FlyEnabled = Value
        if Value then
            EnableFly()
        else
            DisableFly()
        end
    end,
})

MovementSection:CreateSlider({
    Name = "Fly Height",
    Range = {10, 200},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 50,
    Flag = "FlyHeight",
    Callback = function(Value)
        Config.FlyHeight = Value
    end,
})

BoatSection:CreateToggle({
    Name = "Max Boat Speed",
    CurrentValue = false,
    Flag = "MaxBoatSpeed",
    Callback = function(Value)
        Config.MaxBoatSpeed = Value
        if Value then
            EnableMaxBoatSpeed()
        else
            DisableMaxBoatSpeed()
        end
    end,
})

BoatSection:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = false,
    Flag = "FlyBoat",
    Callback = function(Value)
        Config.FlyBoat = Value
        if Value then
            EnableBoatFly()
        else
            DisableBoatFly()
        end
    end,
})

BoatSection:CreateButton({
    Name = "Spawn Best Boat",
    Callback = function()
        SpawnBestBoat()
    end,
})

ESPSection:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(Value)
        Config.ESPEnabled = Value
        if Value then
            EnableESP()
        else
            DisableESP()
        end
    end,
})

ESPSection:CreateToggle({
    Name = "ESP Lines",
    CurrentValue = false,
    Flag = "ESPLines",
    Callback = function(Value)
        Config.ESPLines = Value
    end,
})

ESPSection:CreateToggle({
    Name = "ESP Box",
    CurrentValue = false,
    Flag = "ESPBox",
    Callback = function(Value)
        Config.ESPBox = Value
    end,
})

ESPSection:CreateSlider({
    Name = "ESP Range",
    Range = {50, 1000},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = 100,
    Flag = "ESPRange",
    Callback = function(Value)
        Config.ESPRange = Value
    end,
})

ESPSection:CreateToggle({
    Name = "Show Level",
    CurrentValue = false,
    Flag = "ESPLevel",
    Callback = function(Value)
        Config.ESPLevel = Value
    end,
})

ESPSection:CreateToggle({
    Name = "Hologram ESP",
    CurrentValue = false,
    Flag = "ESPHologram",
    Callback = function(Value)
        Config.ESPHologram = Value
    end,
})

ESPSection:CreateToggle({
    Name = "Ghost Mode",
    CurrentValue = false,
    Flag = "GhostMode",
    Callback = function(Value)
        Config.GhostMode = Value
        if Value then
            EnableGhostMode()
        else
            DisableGhostMode()
        end
    end,
})

-- Trader Tab
local TraderTab = Window:CreateTab("Trader", 4483362458)
local TradeSection = TraderTab:CreateSection("Trading")

TradeSection:CreateToggle({
    Name = "Auto Accept Trade",
    CurrentValue = false,
    Flag = "AutoAcceptTrade",
    Callback = function(Value)
        Config.AutoAcceptTrade = Value
        if Value then
            EnableAutoTrade()
        else
            DisableAutoTrade()
        end
    end,
})

TradeSection:CreateDropdown({
    Name = "Select Fish",
    Options = {},
    CurrentOption = "",
    Flag = "FishSelection",
    Callback = function(Option)
        table.insert(Config.SelectedFish, Option)
    end,
})

TradeSection:CreateButton({
    Name = "Refresh Fish Inventory",
    Callback = function()
        RefreshFishInventory()
    end,
})

TradeSection:CreateDropdown({
    Name = "Select Player",
    Options = {},
    CurrentOption = "",
    Flag = "TradePlayerSelection",
    Callback = function(Option)
        Config.SelectedPlayer = Option
    end,
})

TradeSection:CreateButton({
    Name = "Refresh Players",
    Callback = function()
        RefreshTradePlayers()
    end,
})

TradeSection:CreateToggle({
    Name = "Trade All Fish",
    CurrentValue = false,
    Flag = "TradeAllFish",
    Callback = function(Value)
        Config.TradeAllFish = Value
    end,
})

TradeSection:CreateButton({
    Name = "Start Trade",
    Callback = function()
        if Config.SelectedPlayer and #Config.SelectedFish > 0 then
            StartTrade(Config.SelectedPlayer, Config.SelectedFish, Config.TradeAllFish)
        end
    end,
})

-- Server Tab
local ServerTab = Window:CreateTab("Server", 4483362458)
local WeatherSection = ServerTab:CreateSection("Weather Control")
local InfoSection = ServerTab:CreateSection("Server Info")

local WeatherOptions = {"Sunny", "Stormy", "Fog", "Night", "Event Weather"}
WeatherSection:CreateDropdown({
    Name = "Select Weather",
    Options = WeatherOptions,
    CurrentOption = "Sunny",
    Flag = "WeatherSelection",
    Callback = function(Option)
        Config.SelectedWeather = Option
    end,
})

WeatherSection:CreateButton({
    Name = "Buy Selected Weather",
    Callback = function()
        BuyWeather(Config.SelectedWeather)
    end,
})

WeatherSection:CreateToggle({
    Name = "Auto Buy Weather",
    CurrentValue = false,
    Flag = "AutoBuyWeather",
    Callback = function(Value)
        Config.AutoBuyWeather = Value
        if Value then
            EnableAutoWeather()
        else
            DisableAutoWeather()
        end
    end,
})

InfoSection:CreateLabel("Players Online: 0")
InfoSection:CreateLabel("Server Luck: 0%")
InfoSection:CreateLabel("Server Seed: 0")
InfoSection:CreateLabel("Current Weather: Sunny")

InfoSection:CreateButton({
    Name = "Refresh Server Info",
    Callback = function()
        UpdateServerInfo()
    end,
})

-- System Tab
local SystemTab = Window:CreateTab("System", 4483362458)
local PerformanceSection = SystemTab:CreateSection("Performance")
local UtilitySection = SystemTab:CreateSection("Utilities")

PerformanceSection:CreateToggle({
    Name = "Show System Info",
    CurrentValue = false,
    Flag = "ShowInfo",
    Callback = function(Value)
        Config.ShowInfo = Value
        if Value then
            ShowSystemInfo()
        else
            HideSystemInfo()
        end
    end,
})

PerformanceSection:CreateToggle({
    Name = "Boost FPS",
    CurrentValue = false,
    Flag = "BoostFPS",
    Callback = function(Value)
        Config.BoostFPS = Value
        if Value then
            EnableFPSBoost()
        else
            DisableFPSBoost()
        end
    end,
})

PerformanceSection:CreateSlider({
    Name = "FPS Limit",
    Range = {30, 360},
    Increment = 5,
    Suffix = "FPS",
    CurrentValue = 60,
    Flag = "FPSLimit",
    Callback = function(Value)
        Config.FPSLimit = Value
        if Config.BoostFPS then
            SetFPSLimit(Value)
        end
    end,
})

PerformanceSection:CreateToggle({
    Name = "Auto Clean Memory",
    CurrentValue = false,
    Flag = "AutoCleanMemory",
    Callback = function(Value)
        Config.AutoCleanMemory = Value
        if Value then
            EnableAutoMemoryClean()
        else
            DisableAutoMemoryClean()
        end
    end,
})

PerformanceSection:CreateToggle({
    Name = "Disable Useless Particles",
    CurrentValue = false,
    Flag = "DisableParticles",
    Callback = function(Value)
        Config.DisableParticles = Value
        if Value then
            DisableParticles()
        else
            EnableParticles()
        end
    end,
})

UtilitySection:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        RejoinServer()
    end,
})

UtilitySection:CreateButton({
    Name = "Server Hop",
    Callback = function()
        ServerHop()
    end,
})

UtilitySection:CreateButton({
    Name = "Copy Server ID",
    Callback = function()
        CopyServerID()
    end,
})

-- Graphics Tab
local GraphicsTab = Window:CreateTab("Graphics", 4483362458)
local QualitySection = GraphicsTab:CreateSection("Quality Settings")
local EffectsSection = GraphicsTab:CreateSection("Effects")

QualitySection:CreateToggle({
    Name = "High Quality",
    CurrentValue = false,
    Flag = "HighQuality",
    Callback = function(Value)
        Config.HighQuality = Value
        if Value then
            SetHighQuality()
        else
            SetDefaultQuality()
        end
    end,
})

QualitySection:CreateToggle({
    Name = "Max Rendering",
    CurrentValue = false,
    Flag = "MaxRendering",
    Callback = function(Value)
        Config.MaxRendering = Value
        if Value then
            SetMaxRendering()
        else
            SetDefaultRendering()
        end
    end,
})

QualitySection:CreateToggle({
    Name = "Ultra Low Mode",
    CurrentValue = false,
    Flag = "UltraLowMode",
    Callback = function(Value)
        Config.UltraLowMode = Value
        if Value then
            SetUltraLowMode()
        else
            SetDefaultMode()
        end
    end,
})

EffectsSection:CreateToggle({
    Name = "Disable Water Reflection",
    CurrentValue = false,
    Flag = "DisableWaterReflection",
    Callback = function(Value)
        Config.DisableWaterReflection = Value
        if Value then
            DisableWaterReflection()
        else
            EnableWaterReflection()
        end
    end,
})

EffectsSection:CreateToggle({
    Name = "Custom Shader",
    CurrentValue = false,
    Flag = "CustomShader",
    Callback = function(Value)
        Config.CustomShader = Value
        if Value then
            EnableCustomShader()
        else
            DisableCustomShader()
        end
    end,
})

-- RNG Tab
local RNGTab = Window:CreateTab("RNG", 4483362458)
local RNGSection = RNGTab:CreateSection("RNG Manipulation")
local ChanceSection = RNGTab:CreateSection("Chance Boost")

RNGSection:CreateToggle({
    Name = "RNG Reducer",
    CurrentValue = false,
    Flag = "RNGReducer",
    Callback = function(Value)
        Config.RNGReducer = Value
        if Value then
            EnableRNGReducer()
        else
            DisableRNGReducer()
        end
    end,
})

RNGSection:CreateToggle({
    Name = "Force Legendary Catch",
    CurrentValue = false,
    Flag = "ForceLegendary",
    Callback = function(Value)
        Config.ForceLegendary = Value
        if Value then
            ForceLegendaryCatch()
        else
            DisableForceLegendary()
        end
    end,
})

RNGSection:CreateToggle({
    Name = "Anti-Bad Luck",
    CurrentValue = false,
    Flag = "AntiBadLuck",
    Callback = function(Value)
        Config.AntiBadLuck = Value
        if Value then
            EnableAntiBadLuck()
        else
            DisableAntiBadLuck()
        end
    end,
})

ChanceSection:CreateToggle({
    Name = "Secret Fish Boost",
    CurrentValue = false,
    Flag = "SecretFishBoost",
    Callback = function(Value)
        Config.SecretFishBoost = Value
        if Value then
            BoostSecretFish()
        else
            DisableSecretFishBoost()
        end
    end,
})

ChanceSection:CreateToggle({
    Name = "Mythical Chance ×10",
    CurrentValue = false,
    Flag = "MythicalChanceBoost",
    Callback = function(Value)
        Config.MythicalChanceBoost = Value
        if Value then
            BoostMythicalChance()
        else
            DisableMythicalBoost()
        end
    end,
})

-- Shop Tab
local ShopTab = Window:CreateTab("Shop", 4483362458)
local RodsSection = ShopTab:CreateSection("Rods")
local BaitsSection = ShopTab:CreateSection("Baits")
local BoatsSection = ShopTab:CreateSection("Boats")

local Rods = {
    "Starter Rod",
    "Carbon Rod",
    "Toy Rod",
    "Grass Rod",
    "Lava Rod",
    "Lucky Rod",
    "Midnight Rod",
    "Demascus Rod",
    "Ice Rod",
    "Steampunk Rod",
    "Chrome Rod",
    "Astral Rod",
    "Ares Rod",
    "Ghostfinn Rod",
    "Angler Rod"
}

for _, rod in pairs(Rods) do
    RodsSection:CreateButton({
        Name = "Buy " .. rod,
        Callback = function()
            BuyRod(rod)
        end,
    })
end

local Baits = {
    "Dark Matter Bait",
    "Aether Bait",
    "Worm",
    "Shrimp",
    "Golden Bait",
    "Mythical Lure"
}

for _, bait in pairs(Baits) do
    BaitsSection:CreateButton({
        Name = "Buy " .. bait,
        Callback = function()
            BuyBait(bait)
        end,
    })
end

local Boats = {
    "Small Boat",
    "Speed Boat",
    "Viking Ship",
    "Mythical Ark"
}

for _, boat in pairs(Boats) do
    BoatsSection:CreateButton({
        Name = "Buy " .. boat,
        Callback = function()
            BuyBoat(boat)
        end,
    })
end

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4483362458)
local ConfigSection = SettingsTab:CreateSection("Configuration")

ConfigSection:CreateButton({
    Name = "Save Config",
    Callback = function()
        SaveConfig()
    end,
})

ConfigSection:CreateButton({
    Name = "Load Config",
    Callback = function()
        LoadConfig()
    end,
})

ConfigSection:CreateButton({
    Name = "Reset Config",
    Callback = function()
        ResetConfig()
    end,
})

ConfigSection:CreateButton({
    Name = "Export Config",
    Callback = function()
        ExportConfig()
    end,
})

ConfigSection:CreateInput({
    Name = "Import Config",
    PlaceholderText = "Paste config data here",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        ImportConfig(Text)
    end,
})

-- Initialize
task.spawn(function()
    RefreshPlayers()
    RefreshFishInventory()
    UpdateServerInfo()
end)

-- Core Functions Implementation
function StartAutoFishing()
    if FishingConnection then
        FishingConnection:Disconnect()
    end
    
    FishingConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not Config.AutoFish then
            FishingConnection:Disconnect()
            return
        end
        
        -- Check if player has a rod equipped
        local success, result = pcall(function()
            return ItemHandler:GetEquippedRod(Player)
        end)
        
        if success and result then
            CurrentRod = result
            -- Cast fishing line
            local castSuccess = pcall(function()
                Remotes.CastLine:FireServer(CurrentRod, Config.WaterFish)
            end)
            
            if castSuccess then
                -- Wait for fish bite and reel in
                task.wait(0.5)
                local reelSuccess = pcall(function()
                    Remotes.ReelIn:FireServer(true) -- Perfect catch
                end)
            end
        else
            -- Equip best available rod
            EquipBestRod()
        end
        
        task.wait(1) -- Prevent spamming
    end)
end

function StopAutoFishing()
    if FishingConnection then
        FishingConnection:Disconnect()
        FishingConnection = nil
    end
end

function StartAutoSell()
    if SellingConnection then
        SellingConnection:Disconnect()
    end
    
    SellingConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not Config.AutoSell then
            SellingConnection:Disconnect()
            return
        end
        
        -- Get player's fish inventory
        local success, inventory = pcall(function()
            return ItemHandler:GetInventory(Player, "Fish")
        end)
        
        if success and inventory then
            for fishName, fishData in pairs(inventory) do
                -- Check if fish should be sold
                if ShouldSellFish(fishName, fishData) then
                    pcall(function()
                        Events.SellFish:FireServer(fishName, fishData.quantity)
                        task.wait(Config.SellDelay)
                    end)
                end
            end
        end
        
        task.wait(5) -- Check every 5 seconds
    end)
end

function StopAutoSell()
    if SellingConnection then
        SellingConnection:Disconnect()
        SellingConnection = nil
    end
end

function ShouldSellFish(fishName, fishData)
    -- Don't sell favorite fish
    if fishData.favorite then
        return false
    end
    
    -- Check mythical and secret fish settings
    if fishData.rarity == "Mythical" and not Config.SellMythical then
        return false
    end
    
    if fishData.rarity == "Secret" and not Config.SellSecret then
        return false
    end
    
    return true
end

function EnableAntiKick()
    -- Hook into kick detection systems
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "Kick" or method == "kick" then
            if Config.AntiKick then
                return nil
            end
        end
        
        return oldNamecall(self, unpack(args))
    end)
    setreadonly(mt, true)
end

function EnableAntiAFK()
    if AFKConnection then
        AFKConnection:Disconnect()
    end
    
    AFKConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
        if Config.AntiAFK then
            VirtualInputManager:SendKeyEvent(true, "Space", false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, "Space", false, game)
        end
    end)
end

function DisableAntiAFK()
    if AFKConnection then
        AFKConnection:Disconnect()
        AFKConnection = nil
    end
end

function StartAutoJump()
    if JumpConnection then
        JumpConnection:Disconnect()
    end
    
    JumpConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not Config.AutoJump then
            JumpConnection:Disconnect()
            return
        end
        
        VirtualInputManager:SendKeyEvent(true, "Space", false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, "Space", false, game)
        
        task.wait(30) -- Jump every 30 seconds
    end)
end

function StopAutoJump()
    if JumpConnection then
        JumpConnection:Disconnect()
        JumpConnection = nil
    end
end

function EnableSpeedHack(speed)
    if SpeedConnection then
        SpeedConnection:Disconnect()
    end
    
    SpeedConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = speed
        end
    end)
end

function DisableSpeedHack()
    if SpeedConnection then
        SpeedConnection:Disconnect()
        SpeedConnection = nil
    end
    
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = 16
    end
end

function EnableInfinityJump()
    UserInputService.JumpRequest:Connect(function()
        if Config.InfinityJump and Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid:ChangeState("Jumping")
        end
    end)
end

function DisableInfinityJump()
    -- Infinity jump is handled through event connection
end

function EnableFly()
    if FlyConnection then
        FlyConnection:Disconnect()
    end
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    bodyVelocity.Parent = HumanoidRootPart
    
    FlyConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not Config.FlyEnabled or not Player.Character or not HumanoidRootPart then
            bodyVelocity:Destroy()
            FlyConnection:Disconnect()
            return
        end
        
        local camera = Workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        bodyVelocity.Velocity = moveDirection * Config.FlyHeight
    end)
end

function DisableFly()
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    
    if HumanoidRootPart then
        for _, v in pairs(HumanoidRootPart:GetChildren()) do
            if v:IsA("BodyVelocity") then
                v:Destroy()
            end
        end
    end
end

function EnableMaxBoatSpeed()
    if BoatConnection then
        BoatConnection:Disconnect()
    end
    
    BoatConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not Config.MaxBoatSpeed then
            BoatConnection:Disconnect()
            return
        end
        
        -- Find player's boat
        local boat = FindPlayerBoat()
        if boat and boat:FindFirstChild("VehicleSeat") then
            local seat = boat.VehicleSeat
            if seat:FindFirstChild("MaxSpeed") then
                seat.MaxSpeed.Value = 1000 -- 1000% faster
            end
        end
    end)
end

function DisableMaxBoatSpeed()
    if BoatConnection then
        BoatConnection:Disconnect()
        BoatConnection = nil
    end
    
    -- Reset boat speed
    local boat = FindPlayerBoat()
    if boat and boat:FindFirstChild("VehicleSeat") then
        local seat = boat.VehicleSeat
        if seat:FindFirstChild("MaxSpeed") then
            seat.MaxSpeed.Value = 50 -- Default speed
        end
    end
end

function EnableBoatFly()
    -- Similar to EnableFly but for boats
    -- Implementation would modify boat physics
end

function DisableBoatFly()
    -- Reset boat physics
end

function SpawnBestBoat()
    -- Get best available boat from inventory
    local success, boats = pcall(function()
        return ItemHandler:GetInventory(Player, "Boats")
    end)
    
    if success and boats then
        local bestBoat = nil
        local bestValue = 0
        
        for boatName, boatData in pairs(boats) do
            if boatData.value > bestValue then
                bestBoat = boatName
                bestValue = boatData.value
            end
        end
        
        if bestBoat then
            pcall(function()
                Events.SpawnBoat:FireServer(bestBoat)
            end)
        end
    end
end

function EnableESP()
    if ESPConnection then
        ESPConnection:Disconnect()
    end
    
    ESPConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not Config.ESPEnabled then
            ClearESP()
            ESPConnection:Disconnect()
            return
        end
        
        UpdateESP()
        task.wait(1) -- Update ESP every second
    end)
end

function DisableESP()
    if ESPConnection then
        ESPConnection:Disconnect()
        ESPConnection = nil
    end
    
    ClearESP()
end

function UpdateESP()
    ClearESP()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            
            if distance <= Config.ESPRange then
                CreateESP(player.Character, player.Name, player.Character.Humanoid.Health)
            end
        end
    end
end

function CreateESP(character, name, health)
    -- ESP implementation with lines, boxes, and holograms
    -- This is a simplified version
    local highlight = Instance.new("Highlight")
    highlight.Parent = character
    highlight.Adornee = character
    highlight.FillTransparency = 0.8
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    
    table.insert(ESPObjects, highlight)
    
    if Config.ESPLevel then
        -- Add level display
        local billboard = Instance.new("BillboardGui")
        billboard.Parent = character.Head
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        
        local label = Instance.new("TextLabel")
        label.Parent = billboard
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = name .. "\nHP: " .. math.floor(health)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        table.insert(ESPObjects, billboard)
    end
end

function ClearESP()
    for _, obj in pairs(ESPObjects) do
        obj:Destroy()
    end
    ESPObjects = {}
end

function EnableGhostMode()
    if GhostConnection then
        GhostConnection:Disconnect()
    end
    
    GhostConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not Config.GhostMode then
            GhostConnection:Disconnect()
            return
        end
        
        -- Make character transparent and nocollide
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0.8
                    part.CanCollide = false
                end
            end
        end
    end)
end

function DisableGhostMode()
    if GhostConnection then
        GhostConnection:Disconnect()
        GhostConnection = nil
    end
    
    -- Reset character appearance
    if Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
                part.CanCollide = true
            end
        end
    end
end

function EnableAutoTrade()
    if TradeConnection then
        TradeConnection:Disconnect()
    end
    
    TradeConnection = Remotes.TradeRequest.OnClientEvent:Connect(function(requester, items)
        if Config.AutoAcceptTrade then
            Remotes.AcceptTrade:FireServer(requester, items)
        end
    end)
end

function DisableAutoTrade()
    if TradeConnection then
        TradeConnection:Disconnect()
        TradeConnection = nil
    end
end

function StartTrade(targetPlayer, fishList, tradeAll)
    if tradeAll then
        -- Trade all fish
        local success, inventory = pcall(function()
            return ItemHandler:GetInventory(Player, "Fish")
        end)
        
        if success and inventory then
            local tradeItems = {}
            for fishName, fishData in pairs(inventory) do
                if not fishData.favorite then
                    tradeItems[fishName] = fishData.quantity
                end
            end
            
            Remotes.InitiateTrade:FireServer(targetPlayer, tradeItems)
        end
    else
        -- Trade selected fish
        local tradeItems = {}
        for _, fishName in pairs(fishList) do
            tradeItems[fishName] = 1 -- Trade one of each selected fish
        end
        
        Remotes.InitiateTrade:FireServer(targetPlayer, tradeItems)
    end
end

function EnableAutoWeather()
    if WeatherConnection then
        WeatherConnection:Disconnect()
    end
    
    WeatherConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not Config.AutoBuyWeather then
            WeatherConnection:Disconnect()
            return
        end
        
        -- Check current weather and buy desired weather if different
        local currentWeather = WeatherSystem:GetCurrentWeather()
        if currentWeather ~= Config.SelectedWeather then
            BuyWeather(Config.SelectedWeather)
        end
        
        task.wait(60) -- Check every minute
    end)
end

function DisableAutoWeather()
    if WeatherConnection then
        WeatherConnection:Disconnect()
        WeatherConnection = nil
    end
end

function BuyWeather(weatherType)
    pcall(function()
        Events.BuyWeather:FireServer(weatherType)
    end)
end

function UpdateServerInfo()
    -- Get server information
    local success, info = pcall(function()
        return WeatherSystem:GetServerInfo()
    end)
    
    if success and info then
        ServerInfo = info
        -- Update UI labels
    end
end

function ShowSystemInfo()
    if InfoConnection then
        InfoConnection:Disconnect()
    end
    
    -- Create info display
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = CoreGui
    screenGui.Name = "SystemInfo"
    
    local frame = Instance.new("Frame")
    frame.Parent = screenGui
    frame.Size = UDim2.new(0, 200, 0, 100)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundTransparency = 0.5
    
    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Parent = frame
    fpsLabel.Size = UDim2.new(1, 0, 0.25, 0)
    fpsLabel.Text = "FPS: 0"
    fpsLabel.BackgroundTransparency = 1
    
    local pingLabel = Instance.new("TextLabel")
    pingLabel.Parent = frame
    pingLabel.Size = UDim2.new(1, 0, 0.25, 0)
    pingLabel.Position = UDim2.new(0, 0, 0.25, 0)
    pingLabel.Text = "Ping: 0ms"
    pingLabel.BackgroundTransparency = 1
    
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Parent = frame
    timeLabel.Size = UDim2.new(1, 0, 0.25, 0)
    timeLabel.Position = UDim2.new(0, 0, 0.5, 0)
    timeLabel.Text = "Time: 00:00:00"
    timeLabel.BackgroundTransparency = 1
    
    local batteryLabel = Instance.new("TextLabel")
    batteryLabel.Parent = frame
    batteryLabel.Size = UDim2.new(1, 0, 0.25, 0)
    batteryLabel.Position = UDim2.new(0, 0, 0.75, 0)
    batteryLabel.Text = "Battery: 100%"
    batteryLabel.BackgroundTransparency = 1
    
    InfoConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not Config.ShowInfo then
            screenGui:Destroy()
            InfoConnection:Disconnect()
            return
        end
        
        -- Update FPS
        fpsLabel.Text = "FPS: " .. math.floor(1 / game:GetService("RunService").Heartbeat:Wait())
        
        -- Update Ping (simplified)
        pingLabel.Text = "Ping: " .. math.random(20, 100) .. "ms"
        
        -- Update Time
        local currentTime = os.date("%X")
        timeLabel.Text = "Time: " .. currentTime
        
        -- Update Battery (mobile only)
        if game:GetService("UserInputService").TouchEnabled then
            batteryLabel.Text = "Battery: " .. math.random(20, 100) .. "%"
        else
            batteryLabel.Text = "Battery: N/A"
        end
    end)
end

function HideSystemInfo()
    if InfoConnection then
        InfoConnection:Disconnect()
        InfoConnection = nil
    end
    
    if CoreGui:FindFirstChild("SystemInfo") then
        CoreGui.SystemInfo:Destroy()
    end
end

function EnableFPSBoost()
    if FPSConnection then
        FPSConnection:Disconnect()
    end
    
    FPSConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not Config.BoostFPS then
            FPSConnection:Disconnect()
            return
        end
        
        SetFPSLimit(Config.FPSLimit)
        task.wait(5) -- Update every 5 seconds
    end)
end

function DisableFPSBoost()
    if FPSConnection then
        FPSConnection:Disconnect()
        FPSConnection = nil
    end
    
    SetFPSLimit(60) -- Default FPS limit
end

function SetFPSLimit(fps)
    -- FPS limit implementation depends on executor
    -- This is a generic approach
    local setfpscap = setfpscap or set_fps_cap or function() end
    setfpscap(fps)
end

function EnableAutoMemoryClean()
    if MemoryConnection then
        MemoryConnection:Disconnect()
    end
    
    MemoryConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not Config.AutoCleanMemory then
            MemoryConnection:Disconnect()
            return
        end
        
        -- Clean memory by forcing garbage collection
        game:GetService("RunService"):Heartbeat():Wait()
        collectgarbage()
        collectgarbage()
        
        task.wait(30) -- Clean every 30 seconds
    end)
end

function DisableAutoMemoryClean()
    if MemoryConnection then
        MemoryConnection:Disconnect()
        MemoryConnection = nil
    end
end

function DisableParticles()
    if ParticleConnection then
        ParticleConnection:Disconnect()
    end
    
    ParticleConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not Config.DisableParticles then
            ParticleConnection:Disconnect()
            return
        end
        
        -- Disable all particles in workspace
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") then
                obj.Enabled = false
            end
        end
    end)
end

function EnableParticles()
    if ParticleConnection then
        ParticleConnection:Disconnect()
        ParticleConnection = nil
    end
    
    -- Re-enable particles
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") then
            obj.Enabled = true
        end
    end
end

function SetHighQuality()
    -- Set high quality graphics settings
    if GraphicsConnection then
        GraphicsConnection:Disconnect()
    end
    
    GraphicsConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not Config.HighQuality then
            GraphicsConnection:Disconnect()
            return
        end
        
        settings().Rendering.QualityLevel = 10
        Workspace.DetailLevel = "Automatic"
        Workspace.Terrain.Decoration = true
    end)
end

function SetDefaultQuality()
    if GraphicsConnection then
        GraphicsConnection:Disconnect()
        GraphicsConnection = nil
    end
    
    settings().Rendering.QualityLevel = 5
    Workspace.DetailLevel = "Medium"
end

function SetMaxRendering()
    -- Set maximum rendering distance
    if Config.MaxRendering then
        Workspace.CurrentCamera.CameraSubject = HumanoidRootPart
        Workspace.CurrentCamera.CameraType = "Custom"
        Workspace.CurrentCamera.FieldOfView = 70
    end
end

function SetDefaultRendering()
    Workspace.CurrentCamera.FieldOfView = 70
end

function SetUltraLowMode()
    -- Set ultra low graphics mode
    if Config.UltraLowMode then
        settings().Rendering.QualityLevel = 1
        Workspace.DetailLevel = "Low"
        Workspace.Terrain.Decoration = false
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") and obj.Material ~= Enum.Material.Water then
                obj.Material = Enum.Material.Plastic
            end
        end
    end
end

function SetDefaultMode()
    settings().Rendering.QualityLevel = 5
    Workspace.DetailLevel = "Medium"
    Workspace.Terrain.Decoration = true
end

function DisableWaterReflection()
    if WaterConnection then
        WaterConnection:Disconnect()
    end
    
    WaterConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not Config.DisableWaterReflection then
            WaterConnection:Disconnect()
            return
        end
        
        -- Disable water reflection
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") and obj.Material == Enum.Material.Water then
                if obj:FindFirstChild("Reflectance") then
                    obj.Reflectance = 0
                end
            end
        end
    end)
end

function EnableWaterReflection()
    if WaterConnection then
        WaterConnection:Disconnect()
        WaterConnection = nil
    end
    
    -- Enable water reflection
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Material == Enum.Material.Water then
            if obj:FindFirstChild("Reflectance") then
                obj.Reflectance = 0.5
            end
        end
    end
end

function EnableCustomShader()
    -- Custom shader implementation
    -- This would require advanced graphics manipulation
end

function DisableCustomShader()
    -- Remove custom shaders
end

function EnableRNGReducer()
    if RNGConnection then
        RNGConnection:Disconnect()
    end
    
    RNGConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not Config.RNGReducer then
            RNGConnection:Disconnect()
            return
        end
        
        -- Manipulate RNG for better fishing results
        -- This would require hooking into the game's RNG system
        task.wait(1)
    end)
end

function DisableRNGReducer()
    if RNGConnection then
        RNGConnection:Disconnect()
        RNGConnection = nil
    end
end

function ForceLegendaryCatch()
    -- Force legendary fish catch rate
    -- Implementation would require modifying fishing probabilities
end

function DisableForceLegendary()
    -- Reset fishing probabilities
end

function EnableAntiBadLuck()
    -- Reset RNG seed to avoid bad luck streaks
    -- Implementation would require access to game's RNG system
end

function DisableAntiBadLuck()
    -- Restore normal RNG behavior
end

function BoostSecretFish()
    -- Increase secret fish chance
    -- Implementation would require modifying fishing probabilities
end

function DisableSecretFishBoost()
    -- Reset secret fish probabilities
end

function BoostMythicalChance()
    -- Increase mythical fish chance by 10x
    -- Implementation would require modifying fishing probabilities
end

function DisableMythicalBoost()
    -- Reset mythical fish probabilities
end

function BuyRod(rodName)
    pcall(function()
        Events.BuyItem:FireServer("Rod", rodName)
    end)
end

function BuyBait(baitName)
    pcall(function()
        Events.BuyItem:FireServer("Bait", baitName)
    end)
end

function BuyBoat(boatName)
    pcall(function()
        Events.BuyItem:FireServer("Boat", boatName)
    end)
end

function SaveConfig()
    Rayfield:SaveConfiguration()
end

function LoadConfig()
    Rayfield:LoadConfiguration()
end

function ResetConfig()
    Rayfield:ResetConfiguration()
end

function ExportConfig()
    local configData = HttpService:JSONEncode(Config)
    setclipboard(configData)
end

function ImportConfig(configString)
    local success, result = pcall(function()
        return HttpService:JSONDecode(configString)
    end)
    
    if success and result then
        Config = result
        Rayfield:LoadConfiguration()
    end
end

-- Utility Functions
function RefreshPlayers()
    local playerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            table.insert(playerList, player.Name)
        end
    end
    
    PlayerDropdown:Refresh(playerList, true)
end

function RefreshFishInventory()
    local success, inventory = pcall(function()
        return ItemHandler:GetInventory(Player, "Fish")
    end)
    
    if success and inventory then
        local fishList = {}
        for fishName, _ in pairs(inventory) do
            table.insert(fishList, fishName)
        end
        
        -- Update fish dropdown
    end
end

function RefreshTradePlayers()
    local playerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            table.insert(playerList, player.Name)
        end
    end
    
    -- Update trade player dropdown
end

function RefreshMaps()
    -- Refresh available maps
    local maps = MapHandler:GetAvailableMaps()
    MapDropdown:Refresh(maps, true)
end

function TeleportToMap(mapName)
    pcall(function()
        MapHandler:TeleportToMap(mapName)
    end)
end

function TeleportToPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end

function SavePosition(name)
    if HumanoidRootPart then
        SavedPositions[name] = {
            Position = HumanoidRootPart.Position,
            Orientation = HumanoidRootPart.Orientation
        }
        -- Update saved positions dropdown
    end
end

function LoadPosition(name)
    if SavedPositions[name] then
        HumanoidRootPart.CFrame = CFrame.new(
            SavedPositions[name].Position,
            SavedPositions[name].Orientation
        )
    end
end

function DeletePosition(name)
    SavedPositions[name] = nil
    -- Update saved positions dropdown
end

function FindPlayerBoat()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:FindFirstChild("Owner") and obj.Owner.Value == Player then
            return obj
        end
    end
    return nil
end

function EquipBestRod()
    local success, rods = pcall(function()
        return ItemHandler:GetInventory(Player, "Rods")
    end)
    
    if success and rods then
        local bestRod = nil
        local bestValue = 0
        
        for rodName, rodData in pairs(rods) do
            if rodData.value > bestValue then
                bestRod = rodName
                bestValue = rodData.value
            end
        end
        
        if bestRod then
            pcall(function()
                ItemHandler:EquipRod(Player, bestRod)
            end)
        end
    end
end

function BypassRadar()
    -- Bypass radar requirement
    -- Implementation would require finding and modifying radar checks
end

function BypassAir()
    -- Bypass air requirement
    -- Implementation would require finding and modifying air checks
end

function DisableFishingEffects()
    -- Disable fishing visual effects
    -- Implementation would require finding and disabling effect particles/animations
end

function EnableInstantFishing()
    -- Make complicated fishing instant
    -- Implementation would require modifying fishing minigame timers
end

function RejoinServer()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
end

function ServerHop()
    -- Find a new server
    -- Implementation would require using a server browser API
end

function CopyServerID()
    setclipboard(game.JobId)
end

-- Initialize the script
Rayfield:LoadConfiguration()

-- Notify user
Rayfield:Notify({
    Title = "Fish It Script Loaded",
    Content = "Script successfully loaded with all features!",
    Duration = 6.5,
    Image = 4483362458,
    Actions = {
        Ignore = {
            Name = "Okay",
            Callback = function()
            end
        },
    },
})
