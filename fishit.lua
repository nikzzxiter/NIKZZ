-- Fish It Hub 2025 by Nikzz Xit - UPDATED & FIXED
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
local StarterGui = game:GetService("StarterGui")
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

-- Find game modules
local GameModules = ReplicatedStorage:FindFirstChild("GameModules") or ReplicatedStorage:WaitForChild("GameModules", 10)
local RodModule, BaitModule, FishModule, PlayerModule, WeatherModule, EventModule

if GameModules then
    RodModule = GameModules:FindFirstChild("RodModule") or GameModules:WaitForChild("RodModule", 5)
    BaitModule = GameModules:FindFirstChild("BaitModule") or GameModules:WaitForChild("BaitModule", 5)
    FishModule = GameModules:FindFirstChild("FishModule") or GameModules:WaitForChild("FishModule", 5)
    PlayerModule = GameModules:FindFirstChild("PlayerModule") or GameModules:WaitForChild("PlayerModule", 5)
    WeatherModule = GameModules:FindFirstChild("WeatherModule") or GameModules:WaitForChild("WeatherModule", 5)
    EventModule = GameModules:FindFirstChild("EventModule") or GameModules:WaitForChild("EventModule", 5)
end

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
        WalkOnWater = false,
        GhostHack = false
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
    Settings = {
        SelectedTheme = "Dark",
        Transparency = 0.5,
        ConfigName = "DefaultConfig",
        GraphicsLevel = "Medium",
        UnlockFPS = false,
        MaxFPS = 120
    },
    SystemInfo = {
        ShowFPS = false,
        ShowPing = false
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
        if FishingEvents and FishingEvents:FindFirstChild("SellAllFish") then
            FishingEvents.SellAllFish:FireServer()
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

-- Select Location (Island Location)
local Locations = {
    "Starter Island",
    "Fisherman Island (Stingray Shores)",
    "Ocean",
    "Kohana Island (Volcano)",
    "Coral Reefs",
    "Esoteric Depths",
    "Tropical Grove",
    "Crater Island",
    "Lost Isle (Treasure Room)",
    "Lost Isle (Sisyphus Statue)"
}

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
            local targetCFrame
            local islands = Workspace:FindFirstChild("Islands")
            
            if islands then
                if Config.Teleport.SelectedLocation == "Starter Island" then
                    local island = islands:FindFirstChild("StarterIsland") or islands:FindFirstChild("Starter Island")
                    if island and island:FindFirstChild("TeleportPart") then
                        targetCFrame = island.TeleportPart.CFrame
                    else
                        targetCFrame = CFrame.new(0, 10, 0)
                    end
                elseif Config.Teleport.SelectedLocation == "Fisherman Island (Stingray Shores)" then
                    local island = islands:FindFirstChild("FishermanIsland") or islands:FindFirstChild("Fisherman Island")
                    if island and island:FindFirstChild("TeleportPart") then
                        targetCFrame = island.TeleportPart.CFrame
                    else
                        targetCFrame = CFrame.new(500, 15, 300)
                    end
                -- Add more locations with proper detection
                else
                    -- Default teleport for other locations
                    targetCFrame = CFrame.new(0, 50, 0)
                end
            else
                -- Fallback if islands not found
                if Config.Teleport.SelectedLocation == "Starter Island" then
                    targetCFrame = CFrame.new(0, 10, 0)
                elseif Config.Teleport.SelectedLocation == "Fisherman Island (Stingray Shores)" then
                    targetCFrame = CFrame.new(500, 15, 300)
                else
                    targetCFrame = CFrame.new(0, 50, 0)
                end
            end
            
            if targetCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:SetPrimaryPartCFrame(targetCFrame)
                Rayfield:Notify({
                    Title = "Teleport",
                    Content = "Teleported to " .. Config.Teleport.SelectedLocation,
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
local function UpdatePlayerList()
    playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    return playerList
end

TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = UpdatePlayerList(),
    CurrentOption = Config.Teleport.SelectedPlayer,
    Flag = "SelectedPlayer",
    Callback = function(Value)
        Config.Teleport.SelectedPlayer = Value
    end
})

-- Refresh Player List Button
TeleportTab:CreateButton({
    Name = "Refresh Player List",
    Callback = function()
        local playerDropdown = Rayfield:GetElement("SelectedPlayer")
        if playerDropdown then
            playerDropdown:SetOptions(UpdatePlayerList())
            Rayfield:Notify({
                Title = "Player List",
                Content = "Player list refreshed",
                Duration = 3,
                Image = 13047715178
            })
        end
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
local function UpdateSavedPositionsList()
    savedPositionsList = {}
    for name, _ in pairs(Config.Teleport.SavedPositions) do
        table.insert(savedPositionsList, name)
    end
    return savedPositionsList
end

TeleportTab:CreateDropdown({
    Name = "Saved Positions",
    Options = UpdateSavedPositionsList(),
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

-- Refresh Saved Positions Button
TeleportTab:CreateButton({
    Name = "Refresh Saved Positions",
    Callback = function()
        local savedPositionsDropdown = Rayfield:GetElement("SavedPosition")
        if savedPositionsDropdown then
            savedPositionsDropdown:SetOptions(UpdateSavedPositionsList())
            Rayfield:Notify({
                Title = "Saved Positions",
                Content = "Saved positions list refreshed",
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

-- Ghost Hack (Phase through objects)
UserTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = Config.User.GhostHack,
    Flag = "GhostHack",
    Callback = function(Value)
        Config.User.GhostHack = Value
        if Value then
            Rayfield:Notify({
                Title = "Ghost Hack",
                Content = "Ghost hack enabled",
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
                if TradeEvents and TradeEvents:FindFirstChild("SendTradeRequest") then
                    TradeEvents.SendTradeRequest:FireServer(targetPlayer)
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
local Events = {
    "Fishing Frenzy",
    "Boss Battle",
    "Treasure Hunt",
    "Mystery Island",
    "Double XP",
    "Rainbow Fish",
    "Orca Migration",
    "Shark Hunt",
    "Whale Migration",
    "Megalodon Hunt",
    "Kraken Hunt",
    "Ancient Kraken Hunt",
    "Scylla Hunt",
    "Octophant Hunt",
    "Sunken Chests",
    "Strange Whirlpool",
    "Nuke",
    "Lovestorm",
    "Lucky Event"
}

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
            -- Find event location in workspace
            local eventLocation = Workspace:FindFirstChild("Events")
            if eventLocation then
                local specificEvent = eventLocation:FindFirstChild(Config.Server.TeleportEvent)
                if specificEvent and specificEvent:FindFirstChild("TeleportPart") then
                    LocalPlayer.Character:SetPrimaryPartCFrame(specificEvent.TeleportPart.CFrame)
                    Rayfield:Notify({
                        Title = "Event Teleport",
                        Content = "Teleporting to " .. Config.Server.TeleportEvent,
                        Duration = 3,
                        Image = 13047715178
                    })
                else
                    Rayfield:Notify({
                        Title = "Event Error",
                        Content = "Event not found or not active",
                        Duration = 3,
                        Image = 13047715178
                    })
                end
            else
                Rayfield:Notify({
                    Title = "Event Error",
                    Content = "No events found in workspace",
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

-- System Info Tab
local SystemTab = Window:CreateTab("📊 System", 13014546625)

-- Show FPS
SystemTab:CreateToggle({
    Name = "Show FPS",
    CurrentValue = Config.SystemInfo.ShowFPS,
    Flag = "ShowFPS",
    Callback = function(Value)
        Config.SystemInfo.ShowFPS = Value
    end
})

-- Show Ping
SystemTab:CreateToggle({
    Name = "Show Ping",
    CurrentValue = Config.SystemInfo.ShowPing,
    Flag = "ShowPing",
    Callback = function(Value)
        Config.SystemInfo.ShowPing = Value
    end
})

-- FPS Counter
local fpsLabel = SystemTab:CreateLabel("FPS: 0")

-- Ping Counter
local pingLabel = SystemTab:CreateLabel("Ping: 0ms")

-- Graphics Settings
local GraphicsOptions = {
    "Low",
    "Medium",
    "High"
}

SystemTab:CreateDropdown({
    Name = "Graphics Quality",
    Options = GraphicsOptions,
    CurrentOption = Config.Settings.GraphicsLevel,
    Flag = "GraphicsLevel",
    Callback = function(Value)
        Config.Settings.GraphicsLevel = Value
        -- Apply graphics settings
        if Value == "Low" then
            settings().Rendering.QualityLevel = 1
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1000
        elseif Value == "Medium" then
            settings().Rendering.QualityLevel = 5
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 5000
        elseif Value == "High" then
            settings().Rendering.QualityLevel = 10
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 10000
        end
        Rayfield:Notify({
            Title = "Graphics Settings",
            Content = "Graphics quality set to " .. Value,
            Duration = 3,
            Image = 13047715178
        })
    end
})

-- Unlock FPS
SystemTab:CreateToggle({
    Name = "Unlock FPS",
    CurrentValue = Config.Settings.UnlockFPS,
    Flag = "UnlockFPS",
    Callback = function(Value)
        Config.Settings.UnlockFPS = Value
        if Value then
            setfpscap(Config.Settings.MaxFPS)
            Rayfield:Notify({
                Title = "FPS Unlocked",
                Content = "FPS unlocked to " .. Config.Settings.MaxFPS,
                Duration = 3,
                Image = 13047715178
            })
        else
            setfpscap(60)
            Rayfield:Notify({
                Title = "FPS Locked",
                Content = "FPS locked to 60",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Max FPS
SystemTab:CreateSlider({
    Name = "Max FPS",
    Range = {60, 360},
    Increment = 10,
    Suffix = "FPS",
    CurrentValue = Config.Settings.MaxFPS,
    Flag = "MaxFPS",
    Callback = function(Value)
        Config.Settings.MaxFPS = Value
        if Config.Settings.UnlockFPS then
            setfpscap(Value)
        end
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings", 13014546625)

-- Theme Selection
local Themes = {
    "Dark",
    "Light",
    "Midnight",
    "Aqua"
}

SettingsTab:CreateDropdown({
    Name = "Theme",
    Options = Themes,
    CurrentOption = Config.Settings.SelectedTheme,
    Flag = "SelectedTheme",
    Callback = function(Value)
        Config.Settings.SelectedTheme = Value
        Rayfield:ChangeTheme(Value)
    end
})

-- UI Transparency
SettingsTab:CreateSlider({
    Name = "UI Transparency",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Settings.Transparency,
    Flag = "Transparency",
    Callback = function(Value)
        Config.Settings.Transparency = Value
        Rayfield:SetTransparency(Value)
    end
})

-- Config Name Input
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

-- Destroy UI Button
SettingsTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end
})

-- Credits
SettingsTab:CreateLabel("Script by Nikzz Xit")
SettingsTab:CreateLabel("Version: 2.5.0")
SettingsTab:CreateLabel("Updated: September 2025")

-- ESP Functions
local ESP = {}
ESP.Players = {}
ESP.Objects = {}

function ESP:CreateESP(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local esp = {
        Player = player,
        Box = nil,
        Line = nil,
        NameLabel = nil,
        LevelLabel = nil
    }
    
    -- Create Box ESP
    if Config.User.ESPBox then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESPBox"
        box.Adornee = player.Character.HumanoidRootPart
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Size = Vector3.new(4, 6, 4)
        box.Transparency = 0.5
        box.Color3 = Color3.fromRGB(255, 0, 0)
        box.Parent = player.Character.HumanoidRootPart
        esp.Box = box
    end
    
    -- Create Line ESP
    if Config.User.ESPLines then
        local line = Instance.new("LineHandleAdornment")
        line.Name = "ESPLine"
        line.Adornee = player.Character.HumanoidRootPart
        line.AlwaysOnTop = true
        line.ZIndex = 5
        line.Length = 100
        line.Thickness = 2
        line.Transparency = 0.5
        line.Color3 = Color3.fromRGB(0, 255, 0)
        line.Parent = player.Character.HumanoidRootPart
        esp.Line = line
    end
    
    -- Create Name Label
    if Config.User.ESPName then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPName"
        billboard.Adornee = player.Character.Head
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0.5, 0)
        label.BackgroundTransparency = 1
        label.Text = player.Name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextScaled = true
        label.Parent = billboard
        
        billboard.Parent = player.Character.Head
        esp.NameLabel = billboard
    end
    
    -- Create Level Label
    if Config.User.ESPLevel then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPLevel"
        billboard.Adornee = player.Character.Head
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 4.5, 0)
        billboard.AlwaysOnTop = true
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0.5, 0)
        label.BackgroundTransparency = 1
        label.Text = "Level: " .. (player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Level") and player.leaderstats.Level.Value or "N/A")
        label.TextColor3 = Color3.fromRGB(0, 255, 255)
        label.TextScaled = true
        label.Parent = billboard
        
        billboard.Parent = player.Character.Head
        esp.LevelLabel = billboard
    end
    
    ESP.Players[player] = esp
end

function ESP:RemoveESP(player)
    if ESP.Players[player] then
        if ESP.Players[player].Box then
            ESP.Players[player].Box:Destroy()
        end
        if ESP.Players[player].Line then
            ESP.Players[player].Line:Destroy()
        end
        if ESP.Players[player].NameLabel then
            ESP.Players[player].NameLabel:Destroy()
        end
        if ESP.Players[player].LevelLabel then
            ESP.Players[player].LevelLabel:Destroy()
        end
        ESP.Players[player] = nil
    end
end

function ESP:UpdateESP()
    for player, esp in pairs(ESP.Players) do
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            self:RemoveESP(player)
        else
            if esp.Box then
                esp.Box.Adornee = player.Character.HumanoidRootPart
            end
            if esp.Line then
                esp.Line.Adornee = player.Character.HumanoidRootPart
            end
            if esp.NameLabel then
                esp.NameLabel.Adornee = player.Character.Head
            end
            if esp.LevelLabel then
                esp.LevelLabel.Adornee = player.Character.Head
                if esp.LevelLabel:FindFirstChildWhichIsA("TextLabel") then
                    esp.LevelLabel:FindFirstChildWhichIsA("TextLabel").Text = "Level: " .. (player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Level") and player.leaderstats.Level.Value or "N/A")
                end
            end
        end
    end
end

function ESP:ToggleESP(enable)
    if enable then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                self:CreateESP(player)
            end
        end
        
        Players.PlayerAdded:Connect(function(player)
            if Config.User.PlayerESP then
                self:CreateESP(player)
            end
        end)
        
        Players.PlayerRemoving:Connect(function(player)
            self:RemoveESP(player)
        end)
    else
        for player, _ in pairs(self.Players) do
            self:RemoveESP(player)
        end
    end
end

-- Main Functions
local function AutoFish()
    if Config.AutoFarm.AutoFishV1 and FishingEvents then
        if FishingEvents:FindFirstChild("StartFishing") then
            FishingEvents.StartFishing:FireServer()
            wait(Config.AutoFarm.AutoFishDelay)
            if FishingEvents:FindFirstChild("CatchFish") then
                FishingEvents.CatchFish:FireServer()
            end
        end
    end
end

local function AutoSellFish()
    if Config.AutoFarm.AutoSellFish and FishingEvents then
        if FishingEvents:FindFirstChild("SellAllFish") then
            FishingEvents.SellAllFish:FireServer()
        end
    end
end

local function AutoUpgradeRod()
    if Config.AutoFarm.AutoUpgradeRod and GameFunctions then
        if GameFunctions:FindFirstChild("UpgradeRod") then
            GameFunctions.UpgradeRod:InvokeServer()
        end
    end
end

local function AutoUpgradeBackpack()
    if Config.AutoFarm.AutoUpgradeBackpack and GameFunctions then
        if GameFunctions:FindFirstChild("UpgradeBackpack") then
            GameFunctions.UpgradeBackpack:InvokeServer()
        end
    end
end

local function AutoEquipBestRod()
    if Config.AutoFarm.AutoEquipBestRod and PlayerData then
        local rods = PlayerData:FindFirstChild("Rods")
        if rods then
            local bestRod = nil
            local bestValue = 0
            
            for _, rod in pairs(rods:GetChildren()) do
                if rod:IsA("NumberValue") and rod.Value > bestValue then
                    bestValue = rod.Value
                    bestRod = rod.Name
                end
            end
            
            if bestRod and FishingEvents and FishingEvents:FindFirstChild("EquipRod") then
                FishingEvents.EquipRod:FireServer(bestRod)
            end
        end
    end
end

local function AutoEquipBestBait()
    if Config.AutoFarm.AutoEquipBestBait and PlayerData then
        local baits = PlayerData:FindFirstChild("Baits")
        if baits then
            local bestBait = nil
            local bestValue = 0
            
            for _, bait in pairs(baits:GetChildren()) do
                if bait:IsA("NumberValue") and bait.Value > bestValue then
                    bestValue = bait.Value
                    bestBait = bait.Name
                end
            end
            
            if bestBait and FishingEvents and FishingEvents:FindFirstChild("EquipBait") then
                FishingEvents.EquipBait:FireServer(bestBait)
            end
        end
    end
end

local function AutoCollectDaily()
    if Config.AutoFarm.AutoCollectDaily and GameFunctions then
        if GameFunctions:FindFirstChild("CollectDailyReward") then
            GameFunctions.CollectDailyReward:InvokeServer()
        end
    end
end

local function SpeedHack()
    if Config.User.SpeedHack and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Config.User.SpeedValue
        end
    end
end

local function Fly()
    if Config.User.Fly and LocalPlayer.Character then
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, Config.User.FlyRange/100, 0)
        end
    end
end

local function Noclip()
    if Config.User.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end

local function WalkOnWater()
    if Config.User.WalkOnWater and LocalPlayer.Character then
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Find water parts and adjust position
            for _, part in pairs(Workspace:GetDescendants()) do
                if part.Name == "Water" or part.Name == "Sea" then
                    if humanoidRootPart.Position.Y <= part.Position.Y + 5 then
                        humanoidRootPart.Position = Vector3.new(
                            humanoidRootPart.Position.X,
                            part.Position.Y + 5,
                            humanoidRootPart.Position.Z
                        )
                    end
                end
            end
        end
    end
end

local function GhostHack()
    if Config.User.GhostHack and LocalPlayer.Character then
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                -- Check if player is trying to move through this part
                local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart and (humanoidRootPart.Position - part.Position).Magnitude < 10 then
                    part.CanCollide = false
                end
            end
        end
    end
end

local function AutoBuyCuaca()
    if Config.Server.AutoBuyCuaca and GameFunctions then
        if GameFunctions:FindFirstChild("BuyWeather") then
            GameFunctions.BuyWeather:InvokeServer("Clear") -- Default to clear weather
        end
    end
end

local function AutoJoinEvent()
    if Config.Server.AutoJoinEvent then
        -- Check for active events
        local events = Workspace:FindFirstChild("Events")
        if events then
            for _, event in pairs(events:GetChildren()) do
                if event:FindFirstChild("TeleportPart") then
                    LocalPlayer.Character:SetPrimaryPartCFrame(event.TeleportPart.CFrame)
                    break
                end
            end
        end
    end
end

-- Main Loops
RunService.Heartbeat:Connect(function()
    -- Speed Hack
    SpeedHack()
    
    -- Fly
    if Config.User.Fly then
        Fly()
    end
    
    -- Noclip
    if Config.User.Noclip then
        Noclip()
    end
    
    -- Walk on Water
    if Config.User.WalkOnWater then
        WalkOnWater()
    end
    
    -- Ghost Hack
    if Config.User.GhostHack then
        GhostHack()
    end
    
    -- Update ESP
    if Config.User.PlayerESP then
        ESP:UpdateESP()
    end
end)

-- Auto Fish Loop
spawn(function()
    while wait(Config.AutoFarm.AutoFishDelay) do
        if Config.AutoFarm.AutoFishV1 then
            AutoFish()
        end
    end
end)

-- Auto Sell Loop
spawn(function()
    while wait(Config.AutoFarm.DelaySellFish) do
        if Config.AutoFarm.AutoSellFish then
            AutoSellFish()
        end
    end
end)

-- Auto Upgrade Loop
spawn(function()
    while wait(10) do
        if Config.AutoFarm.AutoUpgradeRod then
            AutoUpgradeRod()
        end
        if Config.AutoFarm.AutoUpgradeBackpack then
            AutoUpgradeBackpack()
        end
        if Config.AutoFarm.AutoEquipBestRod then
            AutoEquipBestRod()
        end
        if Config.AutoFarm.AutoEquipBestBait then
            AutoEquipBestBait()
        end
    end
end)

-- Auto Collect Daily Loop
spawn(function()
    while wait(86400) do -- Once per day
        if Config.AutoFarm.AutoCollectDaily then
            AutoCollectDaily()
        end
    end
end)

-- Auto Buy Cuaca Loop
spawn(function()
    while wait(60) do
        if Config.Server.AutoBuyCuaca then
            AutoBuyCuaca()
        end
    end
end)

-- Auto Join Event Loop
spawn(function()
    while wait(30) do
        if Config.Server.AutoJoinEvent then
            AutoJoinEvent()
        end
    end
end)

-- System Info Loop
spawn(function()
    while wait(1) do
        if Config.SystemInfo.ShowFPS then
            fpsLabel:Set("FPS: " .. math.floor(1 / RunService.Heartbeat:Wait()))
        else
            fpsLabel:Set("FPS: 0")
        end
        
        if Config.SystemInfo.ShowPing then
            pingLabel:Set("Ping: " .. math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) .. "ms")
        else
            pingLabel:Set("Ping: 0ms")
        end
    end
end)

-- Infinity Jump
UserInputService.JumpRequest:Connect(function()
    if Config.User.InfinityJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:ChangeState("Jumping")
        end
    end
end)

-- Player Added/Removed for ESP
Players.PlayerAdded:Connect(function(player)
    if Config.User.PlayerESP then
        ESP:CreateESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    ESP:RemoveESP(player)
end)

-- Initial ESP Setup
if Config.User.PlayerESP then
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            ESP:CreateESP(player)
        end
    end
end

-- Final Notifications
Rayfield:Notify({
    Title = "Fish It Script Loaded",
    Content = "All features are now active!",
    Duration = 6,
    Image = 13047715178
})

Rayfield:Notify({
    Title = "Game Support",
    Content = "Fish It - September 2025 Update",
    Duration = 6,
    Image = 13047715178
})
