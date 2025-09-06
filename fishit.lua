-- Fish It Hub 2025 by Nikzz Xit
-- RayfieldLib Script for Fish It September 2025

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

-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
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
        return nil
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- Game Variables
local FishingEvents = ReplicatedStorage:FindFirstChild("FishingEvents") or ReplicatedStorage:WaitForChild("FishingEvents", 10)
local TradeEvents = ReplicatedStorage:FindFirstChild("TradeEvents") or ReplicatedStorage:WaitForChild("TradeEvents", 10)
local GameFunctions = ReplicatedStorage:FindFirstChild("GameFunctions") or ReplicatedStorage:WaitForChild("GameFunctions", 10)
local PlayerData = LocalPlayer:FindFirstChild("PlayerData") or LocalPlayer:WaitForChild("PlayerData", 10)

-- Load Game Modules
local GameModules = {}
local function LoadModules()
    -- Fishing Module
    local FishingModule = require(ReplicatedStorage.Modules.FishingModule)
    GameModules.Fishing = FishingModule
    
    -- Player Data Module
    local PlayerDataModule = require(ReplicatedStorage.Modules.PlayerDataModule)
    GameModules.PlayerData = PlayerDataModule
    
    -- Trade Module
    local TradeModule = require(ReplicatedStorage.Modules.TradeModule)
    GameModules.Trade = TradeModule
    
    -- Shop Module
    local ShopModule = require(ReplicatedStorage.Modules.ShopModule)
    GameModules.Shop = ShopModule
    
    -- Event Module
    local EventModule = require(ReplicatedStorage.Modules.EventModule)
    GameModules.Event = EventModule
    
    -- Luck Module
    local LuckModule = require(ReplicatedStorage.Modules.LuckModule)
    GameModules.Luck = LuckModule
    
    -- Upgrade Module
    local UpgradeModule = require(ReplicatedStorage.Modules.UpgradeModule)
    GameModules.Upgrade = UpgradeModule
    
    Rayfield:Notify({
        Title = "Modules Loaded",
        Content = "All game modules successfully loaded",
        Duration = 3,
        Image = 13047715178
    })
end

-- Load all modules
pcall(LoadModules)

-- Configuration
local Config = {
    AutoFarm = {
        FishingRadar = false,
        AutoFishV1 = false,
        AutoFishDelay = 1,
        DisableEffectFishing = false,
        AutoInstantComplicatedFishing = false,
        AutoLockPositionCamera = false,
        SellAllFish = false,
        AutoSellFish = false,
        DelaySellFish = 5,
        AntiKickServer = true,
        AntiAFK = true,
        AutoUpgradeRod = false,
        AutoUpgradeBackpack = false,
        AutoEquipBestRod = false,
        AutoEquipBestBait = false,
        AutoCollectDaily = false
    },
    Teleport = {
        SelectedLocation = "",
        SelectedPlayer = "",
        SavedPositions = {}
    },
    User = {
        SpeedHack = false,
        SpeedValue = 16,
        InfinityJump = false,
        Fly = false,
        FlyRange = 50,
        PlayerESP = false,
        ESPBox = true,
        ESPLines = true,
        ESPName = true,
        ESPLevel = true,
        Noclip = false,
        WalkOnWater = false
    },
    Trade = {
        AutoTradeAllFish = false,
        AutoAcceptTrade = false,
        TradePlayer = ""
    },
    Server = {
        AutoBuyCuaca = false,
        TeleportEvent = "",
        AutoJoinEvent = false
    },
    Lucky = {
        LuckyBoost = false,
        NoTrash = false,
        DoubleRoll = false,
        SecretGuarantee = false,
        EventLuckSync = false
    },
    Settings = {
        SelectedTheme = "Dark",
        Transparency = 0.5,
        ConfigName = "DefaultConfig",
        GraphicsMode = "Medium",
        UnlockFPS = false,
        FPSLimit = 120
    }
}

-- Save/Load Config
local function SaveConfig()
    local json = HttpService:JSONEncode(Config)
    writefile("FishItConfig_" .. Config.Settings.ConfigName .. ".json", json)
    Rayfield:Notify({
        Title = "Config Saved",
        Content = "Configuration saved as " .. Config.Settings.ConfigName,
        Duration = 3,
        Image = 13047715178
    })
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
            return true
        else
            Rayfield:Notify({
                Title = "Config Error",
                Content = "Failed to load config: " .. result,
                Duration = 5,
                Image = 13047715178
            })
        end
    else
        Rayfield:Notify({
            Title = "Config Not Found",
            Content = "Config file not found: " .. Config.Settings.ConfigName,
            Duration = 5,
            Image = 13047715178
        })
    end
    return false
end

-- UI Library
local Window = Rayfield:CreateWindow({
    Name = "NIKZZ - FISH SCRIPT",
    LoadingTitle = "NIKZZ SCRIPT",
    LoadingSubtitle = "by Nikzz Xit",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    }
})

-- Auto Farm Tab
local AutoFarmTab = Window:CreateTab("🐟 Auto Farm", 13014546625)

-- Fishing Radar
AutoFarmTab:CreateToggle({
    Name = "Fishing Radar",
    CurrentValue = Config.AutoFarm.FishingRadar,
    Flag = "FishingRadar",
    Callback = function(Value)
        Config.AutoFarm.FishingRadar = Value
        if Value then
            Rayfield:Notify({
                Title = "Fishing Radar",
                Content = "Fishing Radar enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Fish V1 (Perfect Fishing)
AutoFarmTab:CreateToggle({
    Name = "Auto Fish V1 (Perfect Fishing)",
    CurrentValue = Config.AutoFarm.AutoFishV1,
    Flag = "AutoFishV1",
    Callback = function(Value)
        Config.AutoFarm.AutoFishV1 = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Fish V1",
                Content = "Perfect Fishing enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Fish Delay
AutoFarmTab:CreateSlider({
    Name = "Auto Fish Delay",
    Range = {0, 10},
    Increment = 0.1,
    Suffix = "seconds",
    CurrentValue = Config.AutoFarm.AutoFishDelay,
    Flag = "AutoFishDelay",
    Callback = function(Value)
        Config.AutoFarm.AutoFishDelay = Value
    end
})

-- Disable Effect Fishing
AutoFarmTab:CreateToggle({
    Name = "Disable Effect Fishing",
    CurrentValue = Config.AutoFarm.DisableEffectFishing,
    Flag = "DisableEffectFishing",
    Callback = function(Value)
        Config.AutoFarm.DisableEffectFishing = Value
        if Value then
            Rayfield:Notify({
                Title = "Fishing Effects",
                Content = "Fishing effects disabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Instant Complicated Fishing
AutoFarmTab:CreateToggle({
    Name = "Auto Instant Complicated Fishing",
    CurrentValue = Config.AutoFarm.AutoInstantComplicatedFishing,
    Flag = "AutoInstantComplicatedFishing",
    Callback = function(Value)
        Config.AutoFarm.AutoInstantComplicatedFishing = Value
        if Value then
            Rayfield:Notify({
                Title = "Complicated Fishing",
                Content = "Instant complicated fishing enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Lock Position Camera
AutoFarmTab:CreateToggle({
    Name = "Auto Lock Position Camera",
    CurrentValue = Config.AutoFarm.AutoLockPositionCamera,
    Flag = "AutoLockPositionCamera",
    Callback = function(Value)
        Config.AutoFarm.AutoLockPositionCamera = Value
        if Value then
            Rayfield:Notify({
                Title = "Camera Lock",
                Content = "Camera position locked",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Sell All Fish Button
AutoFarmTab:CreateButton({
    Name = "Sell All Fish",
    Callback = function()
        if GameModules.Fishing and GameModules.Fishing.SellAllFish then
            GameModules.Fishing.SellAllFish()
            Rayfield:Notify({
                Title = "Sell Fish",
                Content = "All fish sold",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Sell Fish
AutoFarmTab:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = Config.AutoFarm.AutoSellFish,
    Flag = "AutoSellFish",
    Callback = function(Value)
        Config.AutoFarm.AutoSellFish = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Sell",
                Content = "Auto selling fish enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Delay Sell Fish
AutoFarmTab:CreateSlider({
    Name = "Delay Sell Fish",
    Range = {1, 60},
    Increment = 1,
    Suffix = "seconds",
    CurrentValue = Config.AutoFarm.DelaySellFish,
    Flag = "DelaySellFish",
    Callback = function(Value)
        Config.AutoFarm.DelaySellFish = Value
    end
})

-- Auto Upgrade Rod
AutoFarmTab:CreateToggle({
    Name = "Auto Upgrade Rod",
    CurrentValue = Config.AutoFarm.AutoUpgradeRod,
    Flag = "AutoUpgradeRod",
    Callback = function(Value)
        Config.AutoFarm.AutoUpgradeRod = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Upgrade Rod",
                Content = "Auto upgrade rod enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Upgrade Backpack
AutoFarmTab:CreateToggle({
    Name = "Auto Upgrade Backpack",
    CurrentValue = Config.AutoFarm.AutoUpgradeBackpack,
    Flag = "AutoUpgradeBackpack",
    Callback = function(Value)
        Config.AutoFarm.AutoUpgradeBackpack = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Upgrade Backpack",
                Content = "Auto upgrade backpack enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Equip Best Rod
AutoFarmTab:CreateToggle({
    Name = "Auto Equip Best Rod",
    CurrentValue = Config.AutoFarm.AutoEquipBestRod,
    Flag = "AutoEquipBestRod",
    Callback = function(Value)
        Config.AutoFarm.AutoEquipBestRod = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Equip Best Rod",
                Content = "Auto equip best rod enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Equip Best Bait
AutoFarmTab:CreateToggle({
    Name = "Auto Equip Best Bait",
    CurrentValue = Config.AutoFarm.AutoEquipBestBait,
    Flag = "AutoEquipBestBait",
    Callback = function(Value)
        Config.AutoFarm.AutoEquipBestBait = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Equip Best Bait",
                Content = "Auto equip best bait enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Collect Daily Reward
AutoFarmTab:CreateToggle({
    Name = "Auto Collect Daily Reward",
    CurrentValue = Config.AutoFarm.AutoCollectDaily,
    Flag = "AutoCollectDaily",
    Callback = function(Value)
        Config.AutoFarm.AutoCollectDaily = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Collect Daily",
                Content = "Auto collect daily reward enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Anti Kick Server
AutoFarmTab:CreateToggle({
    Name = "Anti Kick Server",
    CurrentValue = Config.AutoFarm.AntiKickServer,
    Flag = "AntiKickServer",
    Callback = function(Value)
        Config.AutoFarm.AntiKickServer = Value
        if Value then
            Rayfield:Notify({
                Title = "Anti Kick",
                Content = "Anti kick protection enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Anti AFK
AutoFarmTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = Config.AutoFarm.AntiAFK,
    Flag = "AntiAFK",
    Callback = function(Value)
        Config.AutoFarm.AntiAFK = Value
        if Value then
            Rayfield:Notify({
                Title = "Anti AFK",
                Content = "Anti AFK enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Teleport Tab
local TeleportTab = Window:CreateTab("🗺 Teleport", 13014546625)

-- Get all islands from workspace
local function GetIslands()
    local islands = {}
    for _, island in pairs(Workspace.Islands:GetChildren()) do
        if island:IsA("Model") and island:FindFirstChild("TeleportPart") then
            table.insert(islands, island.Name)
        end
    end
    return islands
end

-- Select Location (Island Location)
local Locations = GetIslands()

TeleportTab:CreateDropdown({
    Name = "Select Location",
    Options = Locations,
    CurrentOption = Config.Teleport.SelectedLocation,
    Flag = "SelectedLocation",
    Callback = function(Value)
        Config.Teleport.SelectedLocation = Value
    end
})

-- Teleport To Island Button
TeleportTab:CreateButton({
    Name = "Teleport To Island",
    Callback = function()
        if Config.Teleport.SelectedLocation ~= "" then
            local targetIsland = Workspace.Islands:FindFirstChild(Config.Teleport.SelectedLocation)
            if targetIsland and targetIsland:FindFirstChild("TeleportPart") then
                LocalPlayer.Character:SetPrimaryPartCFrame(targetIsland.TeleportPart.CFrame)
                Rayfield:Notify({
                    Title = "Teleport",
                    Content = "Teleported to " .. Config.Teleport.SelectedLocation,
                    Duration = 3,
                    Image = 13047715178
                })
            else
                Rayfield:Notify({
                    Title = "Teleport Error",
                    Content = "Island not found or no teleport part",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            Rayfield:Notify({
                Title = "Teleport Error",
                Content = "Please select a location first",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Player List for Teleport
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
    end
})

-- Teleport To Player Button
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
            else
                Rayfield:Notify({
                    Title = "Teleport Error",
                    Content = "Player not found or not loaded",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            Rayfield:Notify({
                Title = "Teleport Error",
                Content = "Please select a player first",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Save Position
TeleportTab:CreateInput({
    Name = "Save Position Name",
    PlaceholderText = "Enter position name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text ~= "" then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Config.Teleport.SavedPositions[Text] = LocalPlayer.Character.HumanoidRootPart.CFrame
                Rayfield:Notify({
                    Title = "Position Saved",
                    Content = "Position saved as: " .. Text,
                    Duration = 3,
                    Image = 13047715178
                })
            end
        end
    end
})

-- Load Saved Positions Dropdown
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
        if Config.Teleport.SavedPositions[Value] then
            LocalPlayer.Character:SetPrimaryPartCFrame(Config.Teleport.SavedPositions[Value])
            Rayfield:Notify({
                Title = "Position Loaded",
                Content = "Teleported to saved position: " .. Value,
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Delete Position
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
        end
    end
})

-- User Tab
local UserTab = Window:CreateTab("👤 User", 13014546625)

-- Speed Hack
UserTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = Config.User.SpeedHack,
    Flag = "SpeedHack",
    Callback = function(Value)
        Config.User.SpeedHack = Value
        if Value then
            Rayfield:Notify({
                Title = "Speed Hack",
                Content = "Speed hack enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

UserTab:CreateSlider({
    Name = "Speed Value",
    Range = {16, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = Config.User.SpeedValue,
    Flag = "SpeedValue",
    Callback = function(Value)
        Config.User.SpeedValue = Value
    end
})

-- Infinity Jump
UserTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = Config.User.InfinityJump,
    Flag = "InfinityJump",
    Callback = function(Value)
        Config.User.InfinityJump = Value
        if Value then
            Rayfield:Notify({
                Title = "Infinity Jump",
                Content = "Infinity jump enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Fly
UserTab:CreateToggle({
    Name = "Fly",
    CurrentValue = Config.User.Fly,
    Flag = "Fly",
    Callback = function(Value)
        Config.User.Fly = Value
        if Value then
            Rayfield:Notify({
                Title = "Fly",
                Content = "Fly enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Fly Range
UserTab:CreateSlider({
    Name = "Fly Range",
    Range = {10, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = Config.User.FlyRange,
    Flag = "FlyRange",
    Callback = function(Value)
        Config.User.FlyRange = Value
    end
})

-- Noclip
UserTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = Config.User.Noclip,
    Flag = "Noclip",
    Callback = function(Value)
        Config.User.Noclip = Value
        if Value then
            Rayfield:Notify({
                Title = "Noclip",
                Content = "Noclip enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Walk on Water
UserTab:CreateToggle({
    Name = "Walk on Water",
    CurrentValue = Config.User.WalkOnWater,
    Flag = "WalkOnWater",
    Callback = function(Value)
        Config.User.WalkOnWater = Value
        if Value then
            Rayfield:Notify({
                Title = "Walk on Water",
                Content = "Walk on water enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Player ESP
UserTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = Config.User.PlayerESP,
    Flag = "PlayerESP",
    Callback = function(Value)
        Config.User.PlayerESP = Value
        if Value then
            Rayfield:Notify({
                Title = "Player ESP",
                Content = "Player ESP enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- ESP Box
UserTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = Config.User.ESPBox,
    Flag = "ESPBox",
    Callback = function(Value)
        Config.User.ESPBox = Value
    end
})

-- ESP Lines
UserTab:CreateToggle({
    Name = "ESP Lines",
    CurrentValue = Config.User.ESPLines,
    Flag = "ESPLines",
    Callback = function(Value)
        Config.User.ESPLines = Value
    end
})

-- ESP Name
UserTab:CreateToggle({
    Name = "ESP Name",
    CurrentValue = Config.User.ESPName,
    Flag = "ESPName",
    Callback = function(Value)
        Config.User.ESPName = Value
    end
})

-- ESP Level
UserTab:CreateToggle({
    Name = "ESP Level",
    CurrentValue = Config.User.ESPLevel,
    Flag = "ESPLevel",
    Callback = function(Value)
        Config.User.ESPLevel = Value
    end
})

-- Trade Tab
local TradeTab = Window:CreateTab("💱 Trade", 13014546625)

-- Auto Trade All Fish
TradeTab:CreateToggle({
    Name = "Auto Trade All Fish",
    CurrentValue = Config.Trade.AutoTradeAllFish,
    Flag = "AutoTradeAllFish",
    Callback = function(Value)
        Config.Trade.AutoTradeAllFish = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Trade",
                Content = "Auto trade all fish enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Accept Trade
TradeTab:CreateToggle({
    Name = "Auto Accept Trade",
    CurrentValue = Config.Trade.AutoAcceptTrade,
    Flag = "AutoAcceptTrade",
    Callback = function(Value)
        Config.Trade.AutoAcceptTrade = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Accept Trade",
                Content = "Auto accept trade enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Trade Player Input
TradeTab:CreateInput({
    Name = "Trade Player",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        Config.Trade.TradePlayer = Text
    end
})

-- Trade Player Button
TradeTab:CreateButton({
    Name = "Send Trade Request",
    Callback = function()
        if Config.Trade.TradePlayer ~= "" then
            local targetPlayer = Players:FindFirstChild(Config.Trade.TradePlayer)
            if targetPlayer then
                if GameModules.Trade and GameModules.Trade.SendTradeRequest then
                    GameModules.Trade.SendTradeRequest(targetPlayer)
                    Rayfield:Notify({
                        Title = "Trade Request",
                        Content = "Trade request sent to " .. Config.Trade.TradePlayer,
                        Duration = 3,
                        Image = 13047715178
                    })
                end
            else
                Rayfield:Notify({
                    Title = "Trade Error",
                    Content = "Player not found: " .. Config.Trade.TradePlayer,
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            Rayfield:Notify({
                Title = "Trade Error",
                Content = "Please enter a player name first",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Server Tab
local ServerTab = Window:CreateTab("🌍 Server", 13014546625)

-- Auto Buy Cuaca
ServerTab:CreateToggle({
    Name = "Auto Buy Cuaca",
    CurrentValue = Config.Server.AutoBuyCuaca,
    Flag = "AutoBuyCuaca",
    Callback = function(Value)
        Config.Server.AutoBuyCuaca = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Buy Cuaca",
                Content = "Auto buy cuaca enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Join Event
ServerTab:CreateToggle({
    Name = "Auto Join Event",
    CurrentValue = Config.Server.AutoJoinEvent,
    Flag = "AutoJoinEvent",
    Callback = function(Value)
        Config.Server.AutoJoinEvent = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Join Event",
                Content = "Auto join event enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Player Total
ServerTab:CreateLabel("Player Total: " .. #Players:GetPlayers())

-- Event Teleport Dropdown
local Events = {}
if GameModules.Event then
    for eventName, _ in pairs(GameModules.Event.GetActiveEvents()) do
        table.insert(Events, eventName)
    end
end

ServerTab:CreateDropdown({
    Name = "Teleport Event",
    Options = Events,
    CurrentOption = Config.Server.TeleportEvent,
    Flag = "TeleportEvent",
    Callback = function(Value)
        Config.Server.TeleportEvent = Value
    end
})

-- Teleport to Event Button
ServerTab:CreateButton({
    Name = "Teleport to Event",
    Callback = function()
        if Config.Server.TeleportEvent ~= "" then
            if GameModules.Event and GameModules.Event.TeleportToEvent then
                GameModules.Event.TeleportToEvent(Config.Server.TeleportEvent)
                Rayfield:Notify({
                    Title = "Event Teleport",
                    Content = "Teleporting to " .. Config.Server.TeleportEvent,
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            Rayfield:Notify({
                Title = "Event Error",
                Content = "Please select an event first",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Lucky Tab
local LuckyTab = Window:CreateTab("🍀 Lucky", 13014546625)

-- Lucky Boost
LuckyTab:CreateToggle({
    Name = "Lucky Boost",
    CurrentValue = Config.Lucky.LuckyBoost,
    Flag = "LuckyBoost",
    Callback = function(Value)
        Config.Lucky.LuckyBoost = Value
        if Value and GameModules.Luck then
            GameModules.Luck.SetLuckyBoost(true)
            Rayfield:Notify({
                Title = "Lucky Boost",
                Content = "Lucky boost enabled",
                Duration = 3,
                Image = 13047715178
            })
        elseif GameModules.Luck then
            GameModules.Luck.SetLuckyBoost(false)
        end
    end
})

-- No Trash
LuckyTab:CreateToggle({
    Name = "No Trash",
    CurrentValue = Config.Lucky.NoTrash,
    Flag = "NoTrash",
    Callback = function(Value)
        Config.Lucky.NoTrash = Value
        if Value and GameModules.Luck then
            GameModules.Luck.SetNoTrash(true)
            Rayfield:Notify({
                Title = "No Trash",
                Content = "No trash enabled",
                Duration = 3,
                Image = 13047715178
            })
        elseif GameModules.Luck then
            GameModules.Luck.SetNoTrash(false)
        end
    end
})

-- Double Roll
LuckyTab:CreateToggle({
    Name = "Double Roll",
    CurrentValue = Config.Lucky.DoubleRoll,
    Flag = "DoubleRoll",
    Callback = function(Value)
        Config.Lucky.DoubleRoll = Value
        if Value and GameModules.Luck then
            GameModules.Luck.SetDoubleRoll(true)
            Rayfield:Notify({
                Title = "Double Roll",
                Content = "Double roll enabled",
                Duration = 3,
                Image = 13047715178
            })
        elseif GameModules.Luck then
            GameModules.Luck.SetDoubleRoll(false)
        end
    end
})

-- Secret Guarantee
LuckyTab:CreateToggle({
    Name = "Secret Guarantee",
    CurrentValue = Config.Lucky.SecretGuarantee,
    Flag = "SecretGuarantee",
    Callback = function(Value)
        Config.Lucky.SecretGuarantee = Value
        if Value and GameModules.Luck then
            GameModules.Luck.SetSecretGuarantee(true)
            Rayfield:Notify({
                Title = "Secret Guarantee",
                Content = "Secret guarantee enabled",
                Duration = 3,
                Image = 13047715178
            })
        elseif GameModules.Luck then
            GameModules.Luck.SetSecretGuarantee(false)
        end
    end
})

-- Event Luck Sync
LuckyTab:CreateToggle({
    Name = "Event Luck Sync",
    CurrentValue = Config.Lucky.EventLuckSync,
    Flag = "EventLuckSync",
    Callback = function(Value)
        Config.Lucky.EventLuckSync = Value
        if Value and GameModules.Luck then
            GameModules.Luck.SetEventLuckSync(true)
            Rayfield:Notify({
                Title = "Event Luck Sync",
                Content = "Event luck sync enabled",
                Duration = 3,
                Image = 13047715178
            })
        elseif GameModules.Luck then
            GameModules.Luck.SetEventLuckSync(false)
        end
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙ Settings", 13014546625)

-- Select Tema
local Themes = {
    "Dark",
    "Light",
    "Midnight",
    "Aqua",
    "Neon"
}

SettingsTab:CreateDropdown({
    Name = "Select Tema",
    Options = Themes,
    CurrentOption = Config.Settings.SelectedTheme,
    Flag = "SelectedTheme",
    Callback = function(Value)
        Config.Settings.SelectedTheme = Value
        Rayfield:ChangeTheme(Value)
        Rayfield:Notify({
            Title = "Theme Changed",
            Content = "Theme set to " .. Value,
            Duration = 3,
            Image = 13047715178
        })
    end
})

-- Transparansi
SettingsTab:CreateSlider({
    Name = "Transparansi",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "opacity",
    CurrentValue = Config.Settings.Transparency,
    Flag = "Transparency",
    Callback = function(Value)
        Config.Settings.Transparency = Value
        Rayfield:SetTransparency(Value)
    end
})

-- Graphics Mode
SettingsTab:CreateDropdown({
    Name = "Graphics Mode",
    Options = {"Low", "Medium", "High"},
    CurrentOption = Config.Settings.GraphicsMode,
    Flag = "GraphicsMode",
    Callback = function(Value)
        Config.Settings.GraphicsMode = Value
        if Value == "Low" then
            settings().Rendering.QualityLevel = 1
        elseif Value == "Medium" then
            settings().Rendering.QualityLevel = 5
        elseif Value == "High" then
            settings().Rendering.QualityLevel = 10
        end
        Rayfield:Notify({
            Title = "Graphics Mode",
            Content = "Graphics mode set to " .. Value,
            Duration = 3,
            Image = 13047715178
        })
    end
})

-- Unlock FPS
SettingsTab:CreateToggle({
    Name = "Unlock FPS",
    CurrentValue = Config.Settings.UnlockFPS,
    Flag = "UnlockFPS",
    Callback = function(Value)
        Config.Settings.UnlockFPS = Value
        if Value then
            setfpscap(Config.Settings.FPSLimit)
            Rayfield:Notify({
                Title = "Unlock FPS",
                Content = "FPS unlocked to " .. Config.Settings.FPSLimit,
                Duration = 3,
                Image = 13047715178
            })
        else
            setfpscap(60)
        end
    end
})

-- FPS Limit
SettingsTab:CreateSlider({
    Name = "FPS Limit",
    Range = {60, 360},
    Increment = 10,
    Suffix = "FPS",
    CurrentValue = Config.Settings.FPSLimit,
    Flag = "FPSLimit",
    Callback = function(Value)
        Config.Settings.FPSLimit = Value
        if Config.Settings.UnlockFPS then
            setfpscap(Value)
        end
    end
})

-- Config Name
SettingsTab:CreateInput({
    Name = "Config Name",
    PlaceholderText = "Enter config name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text ~= "" then
            Config.Settings.ConfigName = Text
        end
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

-- System Info
local FPSLabel = SettingsTab:CreateLabel("FPS: " .. math.floor(1 / RunService.RenderStepped:Wait()))
local PingLabel = SettingsTab:CreateLabel("Ping: Calculating...")

-- Destroy GUI Button
SettingsTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        Rayfield:Destroy()
    end
})

-- Main Functions
local function AutoFish()
    if Config.AutoFarm.AutoFishV1 then
        if GameModules.Fishing then
            GameModules.Fishing.CastRod()
            wait(Config.AutoFarm.AutoFishDelay)
            GameModules.Fishing.ReelRod(true) -- Perfect catch
            if Config.AutoFarm.AutoInstantComplicatedFishing then
                GameModules.Fishing.InstantCatch()
            end
        end
    end
end

local function AutoSellFish()
    if Config.AutoFarm.AutoSellFish then
        if GameModules.Fishing then
            GameModules.Fishing.SellAllFish()
            wait(Config.AutoFarm.DelaySellFish)
        end
    end
end

local function AutoUpgrade()
    if Config.AutoFarm.AutoUpgradeRod and GameModules.Upgrade then
        GameModules.Upgrade.UpgradeRod()
    end
    
    if Config.AutoFarm.AutoUpgradeBackpack and GameModules.Upgrade then
        GameModules.Upgrade.UpgradeBackpack()
    end
end

local function AutoEquip()
    if Config.AutoFarm.AutoEquipBestRod and GameModules.Fishing then
        GameModules.Fishing.EquipBestRod()
    end
    
    if Config.AutoFarm.AutoEquipBestBait and GameModules.Fishing then
        GameModules.Fishing.EquipBestBait()
    end
end

local function AutoCollectDaily()
    if Config.AutoFarm.AutoCollectDaily and GameModules.Shop then
        GameModules.Shop.ClaimDailyReward()
    end
end

local function AutoBuyCuaca()
    if Config.Server.AutoBuyCuaca and GameModules.Shop then
        GameModules.Shop.BuyWeatherItem()
    end
end

local function AutoJoinEvent()
    if Config.Server.AutoJoinEvent and GameModules.Event then
        GameModules.Event.JoinActiveEvent()
    end
end

local function SpeedHack()
    if Config.User.SpeedHack and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Config.User.SpeedValue
        end
    end
end

local function Fly()
    if Config.User.Fly and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Flying)
        end
    end
end

local function Noclip()
    if Config.User.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

local function WalkOnWater()
    if Config.User.WalkOnWater and LocalPlayer.Character then
        -- Implementation for walking on water
    end
end

local function PlayerESP()
    if Config.User.PlayerESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                -- ESP implementation
            end
        end
    end
end

local function InfinityJump()
    if Config.User.InfinityJump then
        UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end
end

-- Main Loops
RunService.Heartbeat:Connect(function()
    SpeedHack()
    Fly()
    Noclip()
    WalkOnWater()
end)

RunService.Stepped:Connect(function()
    if Config.AutoFarm.AutoFishV1 then
        AutoFish()
    end
    
    if Config.AutoFarm.AutoSellFish then
        AutoSellFish()
    end
    
    if Config.AutoFarm.AutoUpgradeRod or Config.AutoFarm.AutoUpgradeBackpack then
        AutoUpgrade()
    end
    
    if Config.AutoFarm.AutoEquipBestRod or Config.AutoFarm.AutoEquipBestBait then
        AutoEquip()
    end
    
    if Config.AutoFarm.AutoCollectDaily then
        AutoCollectDaily()
    end
    
    if Config.Server.AutoBuyCuaca then
        AutoBuyCuaca()
    end
    
    if Config.Server.AutoJoinEvent then
        AutoJoinEvent()
    end
    
    if Config.User.PlayerESP then
        PlayerESP()
    end
end)

-- FPS and Ping Update
spawn(function()
    while wait(1) do
        FPSLabel:Set("FPS: " .. math.floor(1 / RunService.RenderStepped:Wait()))
        local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
        PingLabel:Set("Ping: " .. ping)
    end
end)

-- Player List Update
Players.PlayerAdded:Connect(function(player)
    table.insert(playerList, player.Name)
end)

Players.PlayerRemoving:Connect(function(player)
    for i, name in ipairs(playerList) do
        if name == player.Name then
            table.remove(playerList, i)
            break
        end
    end
end)

-- Initialization Complete
Rayfield:Notify({
    Title = "Script Loaded",
    Content = "Fish It Hub 2025 successfully loaded!",
    Duration = 5,
    Image = 13047715178
})
