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
local MarketplaceService = game:GetService("MarketplaceService")
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

-- Cari module dan events yang diperlukan
local FishingModule
local PlayerStatsModule
local RodsModule
local BaitsModule
local WeatherModule
local EventsModule

for _, module in pairs(ReplicatedStorage:GetDescendants()) do
    if module:IsA("ModuleScript") then
        if string.find(module.Name:lower(), "fishing") then
            FishingModule = require(module)
        elseif string.find(module.Name:lower(), "player") and string.find(module.Name:lower(), "stat") then
            PlayerStatsModule = require(module)
        elseif string.find(module.Name:lower(), "rod") then
            RodsModule = require(module)
        elseif string.find(module.Name:lower(), "bait") then
            BaitsModule = require(module)
        elseif string.find(module.Name:lower(), "weather") then
            WeatherModule = require(module)
        elseif string.find(module.Name:lower(), "event") then
            EventsModule = require(module)
        end
    end
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
        AutoTeleportEvent = false
    },
    Graphics = {
        Quality = "Medium",
        UnlockFPS = false,
        TargetFPS = 120
    },
    Settings = {
        SelectedTheme = "Dark",
        Transparency = 0.5,
        ConfigName = "DefaultConfig"
    }
}

-- Variabel untuk sistem info
local PerformanceStats = {
    FPS = 0,
    Ping = 0
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
            if FishingEvents and FishingEvents:FindFirstChild("ToggleRadar") then
                FishingEvents.ToggleRadar:FireServer(true)
            end
            Rayfield:Notify({
                Title = "Fishing Radar",
                Content = "Fishing Radar enabled",
                Duration = 3,
                Image = 13047715178
            })
        else
            if FishingEvents and FishingEvents:FindFirstChild("ToggleRadar") then
                FishingEvents.ToggleRadar:FireServer(false)
            end
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
            -- Disable fishing effects
            if Workspace:FindFirstChild("FishingEffects") then
                Workspace.FishingEffects:Destroy()
            end
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
            -- Lock camera position
            LocalPlayer.Character:WaitForChild("Humanoid").CameraOffset = Vector3.new(0, 0, 0)
            Rayfield:Notify({
                Title = "Camera Lock",
                Content = "Camera position locked",
                Duration = 3,
                Image = 13047715178
            })
        else
            -- Unlock camera position
            LocalPlayer.Character:WaitForChild("Humanoid").CameraOffset = Vector3.new(0, 0, 0)
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
    "Intermediate Island",
    "Advanced Island",
    "Expert Island",
    "Master Island",
    "Legendary Island",
    "Mystic Island",
    "Abyssal Island",
    "Celestial Island",
    "Event Island",
    "Fisherman Island (Stingray Shores)",
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
            if Config.Teleport.SelectedLocation == "Starter Island" then
                targetCFrame = CFrame.new(0, 10, 0)
            elseif Config.Teleport.SelectedLocation == "Intermediate Island" then
                targetCFrame = CFrame.new(100, 10, 100)
            elseif Config.Teleport.SelectedLocation == "Fisherman Island (Stingray Shores)" then
                targetCFrame = CFrame.new(-500, 20, -300)
            elseif Config.Teleport.SelectedLocation == "Kohana Island (Volcano)" then
                targetCFrame = CFrame.new(1200, 50, 800)
            elseif Config.Teleport.SelectedLocation == "Coral Reefs" then
                targetCFrame = CFrame.new(-800, -10, 600)
            elseif Config.Teleport.SelectedLocation == "Esoteric Depths" then
                targetCFrame = CFrame.new(0, -100, 1500)
            elseif Config.Teleport.SelectedLocation == "Tropical Grove" then
                targetCFrame = CFrame.new(800, 15, -600)
            elseif Config.Teleport.SelectedLocation == "Crater Island" then
                targetCFrame = CFrame.new(-1200, 30, -1000)
            elseif Config.Teleport.SelectedLocation == "Lost Isle (Treasure Room)" then
                targetCFrame = CFrame.new(1600, 100, 1600)
            elseif Config.Teleport.SelectedLocation == "Lost Isle (Sisyphus Statue)" then
                targetCFrame = CFrame.new(1700, 100, 1700)
            else
                -- Default location
                targetCFrame = CFrame.new(0, 10, 0)
            end
            
            if targetCFrame then
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
end

UpdatePlayerList()
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

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
local function UpdateSavedPositionsList()
    savedPositionsList = {}
    for name, _ in pairs(Config.Teleport.SavedPositions) do
        table.insert(savedPositionsList, name)
    end
end

UpdateSavedPositionsList()

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
            UpdateSavedPositionsList()
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

-- Performance Info
UserTab:CreateLabel("FPS: " .. PerformanceStats.FPS)
UserTab:CreateLabel("Ping: " .. PerformanceStats.Ping .. " ms")

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

-- Auto Teleport to Event
ServerTab:CreateToggle({
    Name = "Auto Teleport to Event",
    CurrentValue = Config.Server.AutoTeleportEvent,
    Flag = "AutoTeleportEvent",
    Callback = function(Value)
        Config.Server.AutoTeleportEvent = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Teleport Event",
                Content = "Auto teleport to event enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Teleport to Event Button
ServerTab:CreateButton({
    Name = "Teleport to Event",
    Callback = function()
        if Config.Server.TeleportEvent ~= "" then
            -- This would typically teleport to the event location
            local eventLocation = CFrame.new(0, 10, 0) -- Default location
            
            if Config.Server.TeleportEvent == "Fishing Frenzy" then
                eventLocation = CFrame.new(500, 10, 500)
            elseif Config.Server.TeleportEvent == "Boss Battle" then
                eventLocation = CFrame.new(-500, 10, -500)
            -- Add more event locations as needed
            end
            
            LocalPlayer.Character:SetPrimaryPartCFrame(eventLocation)
            Rayfield:Notify({
                Title = "Event Teleport",
                Content = "Teleporting to " .. Config.Server.TeleportEvent,
                Duration = 3,
                Image = 13047715178
            })
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

-- Graphics Tab
local GraphicsTab = Window:CreateTab("🎨 Graphics", 13014546625)

-- Graphics Quality
GraphicsTab:CreateDropdown({
    Name = "Graphics Quality",
    Options = {"Low", "Medium", "High"},
    CurrentOption = Config.Graphics.Quality,
    Flag = "GraphicsQuality",
    Callback = function(Value)
        Config.Graphics.Quality = Value
        
        if Value == "Low" then
            -- Set low graphics
            settings().Rendering.QualityLevel = 1
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1000
        elseif Value == "Medium" then
            -- Set medium graphics
            settings().Rendering.QualityLevel = 5
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 5000
        elseif Value == "High" then
            -- Set high graphics
            settings().Rendering.QualityLevel = 10
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 10000
        end
        
        Rayfield:Notify({
            Title = "Graphics Quality",
            Content = "Graphics quality set to " .. Value,
            Duration = 3,
            Image = 13047715178
        })
    end
})

-- Unlock FPS
GraphicsTab:CreateToggle({
    Name = "Unlock FPS",
    CurrentValue = Config.Graphics.UnlockFPS,
    Flag = "UnlockFPS",
    Callback = function(Value)
        Config.Graphics.UnlockFPS = Value
        if Value then
            setfpscap(Config.Graphics.TargetFPS)
            Rayfield:Notify({
                Title = "Unlock FPS",
                Content = "FPS unlocked to " .. Config.Graphics.TargetFPS,
                Duration = 3,
                Image = 13047715178
            })
        else
            setfpscap(60)
        end
    end
})

-- Target FPS
GraphicsTab:CreateSlider({
    Name = "Target FPS",
    Range = {60, 240},
    Increment = 10,
    Suffix = "FPS",
    CurrentValue = Config.Graphics.TargetFPS,
    Flag = "TargetFPS",
    Callback = function(Value)
        Config.Graphics.TargetFPS = Value
        if Config.Graphics.UnlockFPS then
            setfpscap(Value)
        end
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings", 13014546625)

-- Config Name
SettingsTab:CreateInput({
    Name = "Config Name",
    PlaceholderText = "Enter config name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        Config.Settings.ConfigName = Text
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

-- UI Theme
SettingsTab:CreateDropdown({
    Name = "UI Theme",
    Options = {"Dark", "Light", "Blue", "Red", "Green", "Purple"},
    CurrentOption = Config.Settings.SelectedTheme,
    Flag = "UITheme",
    Callback = function(Value)
        Config.Settings.SelectedTheme = Value
        Rayfield:Notify({
            Title = "UI Theme",
            Content = "UI theme changed to " .. Value,
            Duration = 3,
            Image = 13047715178
        })
    end
})

-- UI Transparency
SettingsTab:CreateSlider({
    Name = "UI Transparency",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Settings.Transparency,
    Flag = "UITransparency",
    Callback = function(Value)
        Config.Settings.Transparency = Value
        Rayfield:SetTheme("Transparency", Value)
    end
})

-- Destroy UI Button
SettingsTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end
})

-- Rejoin Server Button
SettingsTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

-- Server Hop Button
SettingsTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local servers = {}
        local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100")
        local data = HttpService:JSONDecode(req)
        
        for _, server in ipairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        else
            Rayfield:Notify({
                Title = "Server Hop",
                Content = "No servers found",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Credits
SettingsTab:CreateLabel("Script by Nikzz Xit")
SettingsTab:CreateLabel("Version: 2.5.0")
SettingsTab:CreateLabel("Updated: September 2025")

-- Main Loops and Functions
local function AutoFish()
    if Config.AutoFarm.AutoFishV1 and FishingEvents then
        -- Check if player is fishing
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local fishingState = LocalPlayer.Character.Humanoid:GetState()
            
            if fishingState == Enum.HumanoidStateType.Fishing then
                -- Perfect fishing
                if FishingEvents:FindFirstChild("PerfectCatch") then
                    FishingEvents.PerfectCatch:FireServer()
                end
                
                -- Instant catch
                if Config.AutoFarm.AutoInstantComplicatedFishing and FishingEvents:FindFirstChild("InstantCatch") then
                    FishingEvents.InstantCatch:FireServer()
                end
            end
        end
    end
end

local function AutoSell()
    if Config.AutoFarm.AutoSellFish and FishingEvents and FishingEvents:FindFirstChild("SellAllFish") then
        FishingEvents.SellAllFish:FireServer()
    end
end

local function AutoUpgrade()
    if Config.AutoFarm.AutoUpgradeRod and GameFunctions and GameFunctions:FindFirstChild("UpgradeRod") then
        GameFunctions.UpgradeRod:InvokeServer()
    end
    
    if Config.AutoFarm.AutoUpgradeBackpack and GameFunctions and GameFunctions:FindFirstChild("UpgradeBackpack") then
        GameFunctions.UpgradeBackpack:InvokeServer()
    end
end

local function AutoEquip()
    if Config.AutoFarm.AutoEquipBestRod and GameFunctions and GameFunctions:FindFirstChild("EquipBestRod") then
        GameFunctions.EquipBestRod:InvokeServer()
    end
    
    if Config.AutoFarm.AutoEquipBestBait and GameFunctions and GameFunctions:FindFirstChild("EquipBestBait") then
        GameFunctions.EquipBestBait:InvokeServer()
    end
end

local function AutoCollectDaily()
    if Config.AutoFarm.AutoCollectDaily and GameFunctions and GameFunctions:FindFirstChild("CollectDailyReward") then
        GameFunctions.CollectDailyReward:InvokeServer()
    end
end

local function SpeedHack()
    if Config.User.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.User.SpeedValue
    elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end

local function InfinityJump()
    if Config.User.InfinityJump then
        UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState("Jumping")
            end
        end)
    end
end

local function Fly()
    if Config.User.Fly and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart then
            humanoid.PlatformStand = true
            
            local velocity = Instance.new("BodyVelocity")
            velocity.Velocity = Vector3.new(0, 0, 0)
            velocity.MaxForce = Vector3.new(100000, 100000, 100000)
            velocity.Parent = rootPart
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                
                if input.KeyCode == Enum.KeyCode.Space then
                    velocity.Velocity = Vector3.new(0, Config.User.FlyRange, 0)
                elseif input.KeyCode == Enum.KeyCode.LeftShift then
                    velocity.Velocity = Vector3.new(0, -Config.User.FlyRange, 0)
                elseif input.KeyCode == Enum.KeyCode.W then
                    velocity.Velocity = rootPart.CFrame.LookVector * Config.User.FlyRange
                elseif input.KeyCode == Enum.KeyCode.S then
                    velocity.Velocity = -rootPart.CFrame.LookVector * Config.User.FlyRange
                elseif input.KeyCode == Enum.KeyCode.A then
                    velocity.Velocity = -rootPart.CFrame.RightVector * Config.User.FlyRange
                elseif input.KeyCode == Enum.KeyCode.D then
                    velocity.Velocity = rootPart.CFrame.RightVector * Config.User.FlyRange
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                
                if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift then
                    velocity.Velocity = Vector3.new(0, 0, 0)
                elseif input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S then
                    velocity.Velocity = Vector3.new(0, 0, 0)
                elseif input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
                    velocity.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        end
    elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local velocity = rootPart:FindFirstChild("BodyVelocity")
            if velocity then
                velocity:Destroy()
            end
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
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
    end
end

local function GhostHack()
    if Config.User.GhostHack and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Transparency = 0.5
            end
        end
    elseif LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
                part.Transparency = 0
            end
        end
    end
end

local function PlayerESP()
    if Config.User.PlayerESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = player.Character.HumanoidRootPart
                    
                    -- Create ESP box
                    if Config.User.ESPBox then
                        local box = Drawing.new("Square")
                        box.Visible = true
                        box.Color = Color3.fromRGB(255, 255, 255)
                        box.Thickness = 2
                        box.Filled = false
                        
                        local function updateBox()
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local position, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                                if onScreen then
                                    box.Size = Vector2.new(1000 / position.Z, 2000 / position.Z)
                                    box.Position = Vector2.new(position.X - box.Size.X / 2, position.Y - box.Size.Y / 2)
                                    box.Visible = true
                                else
                                    box.Visible = false
                                end
                            else
                                box.Visible = false
                                box:Remove()
                            end
                        end
                        
                        RunService.RenderStepped:Connect(updateBox)
                    end
                    
                    -- Create ESP lines
                    if Config.User.ESPLines then
                        local line = Drawing.new("Line")
                        line.Visible = true
                        line.Color = Color3.fromRGB(255, 255, 255)
                        line.Thickness = 2
                        
                        local function updateLine()
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local position, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                                if onScreen then
                                    line.From = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y)
                                    line.To = Vector2.new(position.X, position.Y)
                                    line.Visible = true
                                else
                                    line.Visible = false
                                end
                            else
                                line.Visible = false
                                line:Remove()
                            end
                        end
                        
                        RunService.RenderStepped:Connect(updateLine)
                    end
                    
                    -- Create ESP name
                    if Config.User.ESPName then
                        local text = Drawing.new("Text")
                        text.Visible = true
                        text.Color = Color3.fromRGB(255, 255, 255)
                        text.Size = 16
                        text.Text = player.Name
                        
                        local function updateText()
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local position, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                                if onScreen then
                                    text.Position = Vector2.new(position.X, position.Y - 30)
                                    text.Visible = true
                                else
                                    text.Visible = false
                                end
                            else
                                text.Visible = false
                                text:Remove()
                            end
                        end
                        
                        RunService.RenderStepped:Connect(updateText)
                    end
                    
                    -- Create ESP level
                    if Config.User.ESPLevel then
                        local levelText = Drawing.new("Text")
                        levelText.Visible = true
                        levelText.Color = Color3.fromRGB(255, 255, 0)
                        levelText.Size = 16
                        
                        -- Get player level (this is a placeholder, you'll need to find the actual level property)
                        local level = "Lvl: ?"
                        if PlayerData and PlayerData:FindFirstChild("Level") then
                            level = "Lvl: " .. tostring(PlayerData.Level.Value)
                        end
                        
                        levelText.Text = level
                        
                        local function updateLevelText()
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local position, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                                if onScreen then
                                    levelText.Position = Vector2.new(position.X, position.Y - 45)
                                    levelText.Visible = true
                                else
                                    levelText.Visible = false
                                end
                            else
                                levelText.Visible = false
                                levelText:Remove()
                            end
                        end
                        
                        RunService.RenderStepped:Connect(updateLevelText)
                    end
                end
            end
        end
    end
end

local function AutoBuyCuaca()
    if Config.Server.AutoBuyCuaca and GameFunctions and GameFunctions:FindFirstChild("BuyWeather") then
        -- Buy all available weather
        for _, weather in ipairs({"Clear", "Rain", "Storm", "Void", "RedTides"}) do
            GameFunctions.BuyWeather:InvokeServer(weather)
        end
    end
end

local function UpdatePerformanceStats()
    -- Update FPS
    PerformanceStats.FPS = math.floor(1 / RunService.RenderStepped:Wait())
    
    -- Update Ping
    local stats = Stats.Network:FindFirstChild("ServerStatsItem")
    if stats then
        local ping = stats:FindFirstChild("Ping")
        if ping then
            PerformanceStats.Ping = math.floor(ping:GetValue())
        end
    end
end

-- Main game loop
RunService.Heartbeat:Connect(function()
    AutoFish()
    SpeedHack()
    Noclip()
    WalkOnWater()
    GhostHack()
    UpdatePerformanceStats()
end)

-- Timers for delayed functions
local autoSellTimer = 0
local autoUpgradeTimer = 0
local autoEquipTimer = 0
local autoCollectDailyTimer = 0
local autoBuyCuacaTimer = 0

RunService.RenderStepped:Connect(function(deltaTime)
    autoSellTimer = autoSellTimer + deltaTime
    autoUpgradeTimer = autoUpgradeTimer + deltaTime
    autoEquipTimer = autoEquipTimer + deltaTime
    autoCollectDailyTimer = autoCollectDailyTimer + deltaTime
    autoBuyCuacaTimer = autoBuyCuacaTimer + deltaTime
    
    if autoSellTimer >= Config.AutoFarm.DelaySellFish then
        AutoSell()
        autoSellTimer = 0
    end
    
    if autoUpgradeTimer >= 10 then -- Every 10 seconds
        AutoUpgrade()
        autoUpgradeTimer = 0
    end
    
    if autoEquipTimer >= 30 then -- Every 30 seconds
        AutoEquip()
        autoEquipTimer = 0
    end
    
    if autoCollectDailyTimer >= 60 then -- Every minute
        AutoCollectDaily()
        autoCollectDailyTimer = 0
    end
    
    if autoBuyCuacaTimer >= 300 then -- Every 5 minutes
        AutoBuyCuaca()
        autoBuyCuacaTimer = 0
    end
end)

-- Initialize
Rayfield:Notify({
    Title = "Fish It Script Loaded",
    Content = "Welcome to Nikzz Script for Fish It!",
    Duration = 5,
    Image = 13047715178
})

-- Final setup
if Config.Graphics.UnlockFPS then
    setfpscap(Config.Graphics.TargetFPS)
end

-- Set initial graphics quality
if Config.Graphics.Quality == "Low" then
    settings().Rendering.QualityLevel = 1
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1000
elseif Config.Graphics.Quality == "Medium" then
    settings().Rendering.QualityLevel = 5
    Lighting.GlobalShadows = true
    Lighting.FogEnd = 5000
elseif Config.Graphics.Quality == "High" then
    settings().Rendering.QualityLevel = 10
    Lighting.GlobalShadows = true
    Lighting.FogEnd = 10000
end

-- Load saved config if exists
if isfile("FishItConfig_" .. Config.Settings.ConfigName .. ".json") then
    LoadConfig()
end
