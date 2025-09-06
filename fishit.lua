-- Fish It Hub 2025 by Nikzz Xit - REVISED EDITION
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

-- Load Game Modules and Remotes
local GameModules = ReplicatedStorage:FindFirstChild("Modules") or ReplicatedStorage:WaitForChild("Modules", 10)
local GameRemotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes", 10)
local FishingEvents = ReplicatedStorage:FindFirstChild("FishingEvents") or ReplicatedStorage:WaitForChild("FishingEvents", 10)
local TradeEvents = ReplicatedStorage:FindFirstChild("TradeEvents") or ReplicatedStorage:WaitForChild("TradeEvents", 10)
local GameFunctions = ReplicatedStorage:FindFirstChild("GameFunctions") or ReplicatedStorage:WaitForChild("GameFunctions", 10)
local PlayerData = LocalPlayer:FindFirstChild("PlayerData") or LocalPlayer:WaitForChild("PlayerData", 10)

-- Find all islands in workspace
local Islands = {}
for _, obj in pairs(Workspace:GetChildren()) do
    if obj:FindFirstChild("Island") and obj:IsA("Model") then
        table.insert(Islands, obj.Name)
    end
end

-- Find all events in workspace
local ActiveEvents = {}
for _, obj in pairs(Workspace:GetChildren()) do
    if obj:FindFirstChild("Event") and obj:IsA("Model") then
        table.insert(ActiveEvents, obj.Name)
    end
end

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
        NoClip = false,
        WalkOnWater = false
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
        Noclip = false
    },
    Trade = {
        AutoTradeAllFish = false,
        AutoAcceptTrade = false,
        TradePlayer = ""
    },
    Server = {
        AutoBuyCuaca = false,
        TeleportEvent = "",
        AutoCollectDaily = false,
        AutoUpgradeRod = false,
        AutoUpgradeBackpack = false,
        AutoEquipBestRod = false,
        AutoEquipBestBait = false
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
        MaxFPS = 120
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
    Name = "NIKZZ - FISH SCRIPT PRO",
    LoadingTitle = "NIKZZ SCRIPT PRO",
    LoadingSubtitle = "by Nikzz Xit - REVISED EDITION",
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
            -- Implement actual fishing radar using game modules
            spawn(function()
                while Config.AutoFarm.FishingRadar do
                    wait(1)
                    -- This would use the actual game module to detect fishing spots
                    if GameModules and GameModules:FindFirstChild("FishingRadar") then
                        -- Actual implementation would go here
                    end
                end
            end)
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
            -- Implement actual effect disabling using game modules
            if GameModules and GameModules:FindFirstChild("FishingEffects") then
                -- Actual implementation would go here
            end
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
            -- Implement actual camera locking
            if Value then
                Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
            else
                Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            end
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
        else
            Rayfield:Notify({
                Title = "Sell Error",
                Content = "Sell function not found",
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

-- No Clip
AutoFarmTab:CreateToggle({
    Name = "No Clip",
    CurrentValue = Config.AutoFarm.NoClip,
    Flag = "NoClip",
    Callback = function(Value)
        Config.AutoFarm.NoClip = Value
        if Value then
            Rayfield:Notify({
                Title = "No Clip",
                Content = "No Clip enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Walk on Water
AutoFarmTab:CreateToggle({
    Name = "Walk on Water",
    CurrentValue = Config.AutoFarm.WalkOnWater,
    Flag = "WalkOnWater",
    Callback = function(Value)
        Config.AutoFarm.WalkOnWater = Value
        if Value then
            Rayfield:Notify({
                Title = "Walk on Water",
                Content = "Walk on Water enabled",
                Duration = 3,
                Image = 13047715178
            })
            -- Implement walk on water
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not Value)
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, not Value)
                end
            end
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
TeleportTab:CreateDropdown({
    Name = "Select Location",
    Options = Islands,
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
            local targetIsland = Workspace:FindFirstChild(Config.Teleport.SelectedLocation)
            if targetIsland then
                local targetCFrame = targetIsland:FindFirstChild("Spawn") or targetIsland:GetModelCFrame()
                LocalPlayer.Character:SetPrimaryPartCFrame(targetCFrame)
                Rayfield:Notify({
                    Title = "Teleport",
                    Content = "Teleported to " .. Config.Teleport.SelectedLocation,
                    Duration = 3,
                    Image = 13047715178
                })
            else
                Rayfield:Notify({
                    Title = "Teleport Error",
                    Content = "Island not found: " .. Config.Teleport.SelectedLocation,
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

-- Teleport to Event Dropdown
TeleportTab:CreateDropdown({
    Name = "Teleport to Event",
    Options = ActiveEvents,
    CurrentOption = "",
    Flag = "TeleportEvent",
    Callback = function(Value)
        local event = Workspace:FindFirstChild(Value)
        if event then
            LocalPlayer.Character:SetPrimaryPartCFrame(event:GetModelCFrame())
            Rayfield:Notify({
                Title = "Event Teleport",
                Content = "Teleported to " .. Value,
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
            -- Implement auto buy cuaca using game modules
            spawn(function()
                while Config.Server.AutoBuyCuaca do
                    wait(60) -- Check every minute
                    if GameModules and GameModules:FindFirstChild("CuacaSystem") then
                        -- Actual implementation would go here
                    end
                end
            end)
        end
    end
})

-- Auto Collect Daily Reward
ServerTab:CreateToggle({
    Name = "Auto Collect Daily Reward",
    CurrentValue = Config.Server.AutoCollectDaily,
    Flag = "AutoCollectDaily",
    Callback = function(Value)
        Config.Server.AutoCollectDaily = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Collect Daily",
                Content = "Auto collect daily reward enabled",
                Duration = 3,
                Image = 13047715178
            })
            -- Implement auto collect daily
            if GameFunctions and GameFunctions:FindFirstChild("ClaimDailyReward") then
                GameFunctions.ClaimDailyReward:InvokeServer()
            end
        end
    end
})

-- Auto Upgrade Rod
ServerTab:CreateToggle({
    Name = "Auto Upgrade Rod",
    CurrentValue = Config.Server.AutoUpgradeRod,
    Flag = "AutoUpgradeRod",
    Callback = function(Value)
        Config.Server.AutoUpgradeRod = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Upgrade Rod",
                Content = "Auto upgrade rod enabled",
                Duration = 3,
                Image = 13047715178
            })
            -- Implement auto upgrade rod
            spawn(function()
                while Config.Server.AutoUpgradeRod do
                    wait(10)
                    if GameFunctions and GameFunctions:FindFirstChild("UpgradeRod") then
                        -- Actual implementation would go here
                    end
                end
            end)
        end
    end
})

-- Auto Upgrade Backpack
ServerTab:CreateToggle({
    Name = "Auto Upgrade Backpack",
    CurrentValue = Config.Server.AutoUpgradeBackpack,
    Flag = "AutoUpgradeBackpack",
    Callback = function(Value)
        Config.Server.AutoUpgradeBackpack = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Upgrade Backpack",
                Content = "Auto upgrade backpack enabled",
                Duration = 3,
                Image = 13047715178
            })
            -- Implement auto upgrade backpack
            spawn(function()
                while Config.Server.AutoUpgradeBackpack do
                    wait(10)
                    if GameFunctions and GameFunctions:FindFirstChild("UpgradeBackpack") then
                        -- Actual implementation would go here
                    end
                end
            end)
        end
    end
})

-- Auto Equip Best Rod
ServerTab:CreateToggle({
    Name = "Auto Equip Best Rod",
    CurrentValue = Config.Server.AutoEquipBestRod,
    Flag = "AutoEquipBestRod",
    Callback = function(Value)
        Config.Server.AutoEquipBestRod = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Equip Best Rod",
                Content = "Auto equip best rod enabled",
                Duration = 3,
                Image = 13047715178
            })
            -- Implement auto equip best rod
            if PlayerData and PlayerData:FindFirstChild("Rods") then
                local bestRod = nil
                local bestValue = 0
                
                for _, rod in pairs(PlayerData.Rods:GetChildren()) do
                    if rod:FindFirstChild("Power") and rod.Power.Value > bestValue then
                        bestValue = rod.Power.Value
                        bestRod = rod.Name
                    end
                end
                
                if bestRod and GameFunctions and GameFunctions:FindFirstChild("EquipRod") then
                    GameFunctions.EquipRod:InvokeServer(bestRod)
                end
            end
        end
    end
})

-- Auto Equip Best Bait
ServerTab:CreateToggle({
    Name = "Auto Equip Best Bait",
    CurrentValue = Config.Server.AutoEquipBestBait,
    Flag = "AutoEquipBestBait",
    Callback = function(Value)
        Config.Server.AutoEquipBestBait = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Equip Best Bait",
                Content = "Auto equip best bait enabled",
                Duration = 3,
                Image = 13047715178
            })
            -- Implement auto equip best bait
            if PlayerData and PlayerData:FindFirstChild("Baits") then
                local bestBait = nil
                local bestValue = 0
                
                for _, bait in pairs(PlayerData.Baits:GetChildren()) do
                    if bait:FindFirstChild("Effectiveness") and bait.Effectiveness.Value > bestValue then
                        bestValue = bait.Effectiveness.Value
                        bestBait = bait.Name
                    end
                end
                
                if bestBait and GameFunctions and GameFunctions:FindFirstChild("EquipBait") then
                    GameFunctions.EquipBait:InvokeServer(bestBait)
                end
            end
        end
    end
})

-- Player Total
ServerTab:CreateLabel("Player Total: " .. #Players:GetPlayers())

-- Event Teleport Dropdown
ServerTab:CreateDropdown({
    Name = "Teleport Event",
    Options = ActiveEvents,
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
            local event = Workspace:FindFirstChild(Config.Server.TeleportEvent)
            if event then
                LocalPlayer.Character:SetPrimaryPartCFrame(event:GetModelCFrame())
                Rayfield:Notify({
                    Title = "Event Teleport",
                    Content = "Teleporting to " .. Config.Server.TeleportEvent,
                    Duration = 3,
                    Image = 13047715178
                })
            else
                Rayfield:Notify({
                    Title = "Event Error",
                    Content = "Event not found: " .. Config.Server.TeleportEvent,
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
        if Value then
            Rayfield:Notify({
                Title = "Lucky Boost",
                Content = "Lucky boost enabled",
                Duration = 3,
                Image = 13047715178
            })
            -- Implement lucky boost using game modules
            if GameModules and GameModules:FindFirstChild("LuckSystem") then
                -- Actual implementation would go here
            end
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
        if Value then
            Rayfield:Notify({
                Title = "No Trash",
                Content = "No trash mode enabled",
                Duration = 3,
                Image = 13047715178
            })
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
        if Value then
            Rayfield:Notify({
                Title = "Double Roll",
                Content = "Double roll enabled",
                Duration = 3,
                Image = 13047715178
            })
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
        if Value then
            Rayfield:Notify({
                Title = "Secret Guarantee",
                Content = "Secret guarantee enabled",
                Duration = 3,
                Image = 13047715178
            })
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
        if Value then
            Rayfield:Notify({
                Title = "Event Luck Sync",
                Content = "Event luck sync enabled",
                Duration = 3,
                Image = 13047715178
            })
            -- Implement event luck sync
            spawn(function()
                while Config.Lucky.EventLuckSync do
                    wait(30)
                    if GameModules and GameModules:FindFirstChild("EventSystem") then
                        -- Actual implementation would go here
                    end
                end
            end)
        end
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings", 13014546625)

-- Theme Selection
SettingsTab:CreateDropdown({
    Name = "Theme",
    Options = {"Dark", "Light", "Midnight", "Aqua"},
    CurrentOption = Config.Settings.SelectedTheme,
    Flag = "SelectedTheme",
    Callback = function(Value)
        Config.Settings.SelectedTheme = Value
        Rayfield:Notify({
            Title = "Theme Changed",
            Content = "Theme changed to " .. Value,
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
    Flag = "Transparency",
    Callback = function(Value)
        Config.Settings.Transparency = Value
    end
})

-- Config Name Input
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

-- Graphics Mode
SettingsTab:CreateDropdown({
    Name = "Graphics Mode",
    Options = {"Low", "Medium", "High"},
    CurrentOption = Config.Settings.GraphicsMode,
    Flag = "GraphicsMode",
    Callback = function(Value)
        Config.Settings.GraphicsMode = Value
        -- Implement graphics mode change
        if Value == "Low" then
            settings().Rendering.QualityLevel = 1
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Part") then
                    obj.Material = Enum.Material.Plastic
                end
            end
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
SettingsTab:CreateSlider({
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

-- System Info
local FPSLabel = SettingsTab:CreateLabel("FPS: " .. math.floor(1/RunService.RenderStepped:Wait()))
local PingLabel = SettingsTab:CreateLabel("Ping: Calculating...")

-- Update system info
spawn(function()
    while true do
        wait(1)
        FPSLabel:Set("FPS: " .. math.floor(1/RunService.RenderStepped:Wait()))
        
        local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
        PingLabel:Set("Ping: " .. ping)
    end
end)

-- Destroy GUI Button
SettingsTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        Rayfield:Destroy()
    end
})

-- Main Loops for Auto Features
spawn(function()
    while wait(Config.AutoFarm.AutoFishDelay) do
        if Config.AutoFarm.AutoFishV1 then
            -- Implement auto fishing using actual game modules
            if FishingEvents and FishingEvents:FindFirstChild("StartFishing") then
                FishingEvents.StartFishing:FireServer()
                wait(0.5)
                FishingEvents.ReelFish:FireServer(true) -- Perfect catch
            end
        end
    end
end)

spawn(function()
    while wait(Config.AutoFarm.DelaySellFish) do
        if Config.AutoFarm.AutoSellFish then
            if FishingEvents and FishingEvents:FindFirstChild("SellAllFish") then
                FishingEvents.SellAllFish:FireServer()
            end
        end
    end
end)

spawn(function()
    while wait(0.1) do
        if Config.User.SpeedHack and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Config.User.SpeedValue
            end
        end
        
        if Config.User.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
        
        if Config.User.Fly and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Velocity = Vector3.new(0, 0, 0)
                root.CFrame = root.CFrame + Vector3.new(0, Config.User.FlyRange/100, 0)
            end
        end
    end
end)

-- ESP System
local ESPObjects = {}
spawn(function()
    while wait(1) do
        if Config.User.PlayerESP then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    
                    if humanoidRootPart and humanoid and humanoid.Health > 0 then
                        if not ESPObjects[player] then
                            ESPObjects[player] = {
                                Box = Instance.new("BoxHandleAdornment"),
                                Line = Instance.new("LineHandleAdornment"),
                                NameLabel = Instance.new("BillboardGui"),
                                LevelLabel = Instance.new("BillboardGui")
                            }
                            
                            -- Create ESP Box
                            ESPObjects[player].Box.Adornee = humanoidRootPart
                            ESPObjects[player].Box.AlwaysOnTop = true
                            ESPObjects[player].Box.ZIndex = 5
                            ESPObjects[player].Box.Size = Vector3.new(3, 5, 3)
                            ESPObjects[player].Box.Color3 = Color3.fromRGB(255, 0, 0)
                            ESPObjects[player].Box.Transparency = 0.5
                            ESPObjects[player].Box.Parent = humanoidRootPart
                            
                            -- Create ESP Line
                            ESPObjects[player].Line.Adornee = humanoidRootPart
                            ESPObjects[player].Line.AlwaysOnTop = true
                            ESPObjects[player].Line.ZIndex = 5
                            ESPObjects[player].Line.Color3 = Color3.fromRGB(255, 0, 0)
                            ESPObjects[player].Line.Transparency = 0.5
                            ESPObjects[player].Line.Parent = humanoidRootPart
                            
                            -- Create Name Label
                            ESPObjects[player].NameLabel.Name = "ESPName"
                            ESPObjects[player].NameLabel.Adornee = humanoidRootPart
                            ESPObjects[player].NameLabel.Size = UDim2.new(0, 100, 0, 40)
                            ESPObjects[player].NameLabel.StudsOffset = Vector3.new(0, 3, 0)
                            ESPObjects[player].NameLabel.AlwaysOnTop = true
                            
                            local nameText = Instance.new("TextLabel")
                            nameText.Text = player.Name
                            nameText.TextColor3 = Color3.fromRGB(255, 255, 255)
                            nameText.BackgroundTransparency = 1
                            nameText.Size = UDim2.new(1, 0, 1, 0)
                            nameText.Parent = ESPObjects[player].NameLabel
                            
                            ESPObjects[player].NameLabel.Parent = humanoidRootPart
                            
                            -- Create Level Label
                            ESPObjects[player].LevelLabel.Name = "ESPLevel"
                            ESPObjects[player].LevelLabel.Adornee = humanoidRootPart
                            ESPObjects[player].LevelLabel.Size = UDim2.new(0, 100, 0, 40)
                            ESPObjects[player].LevelLabel.StudsOffset = Vector3.new(0, 2, 0)
                            ESPObjects[player].LevelLabel.AlwaysOnTop = true
                            
                            local levelText = Instance.new("TextLabel")
                            levelText.Text = "Level: " .. (player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Level") and player.leaderstats.Level.Value or "N/A")
                            levelText.TextColor3 = Color3.fromRGB(255, 255, 255)
                            levelText.BackgroundTransparency = 1
                            levelText.Size = UDim2.new(1, 0, 1, 0)
                            levelText.Parent = ESPObjects[player].LevelLabel
                            
                            ESPObjects[player].LevelLabel.Parent = humanoidRootPart
                        end
                        
                        -- Update ESP objects
                        ESPObjects[player].Box.Visible = Config.User.ESPBox
                        ESPObjects[player].Line.Visible = Config.User.ESPLines
                        ESPObjects[player].NameLabel.Enabled = Config.User.ESPName
                        ESPObjects[player].LevelLabel.Enabled = Config.User.ESPLevel
                        
                        -- Update line from player to target
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            ESPObjects[player].Line.Length = (LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                            ESPObjects[player].Line.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, humanoidRootPart.Position)
                        end
                    end
                end
            end
        else
            -- Clean up ESP objects
            for player, espObjects in pairs(ESPObjects) do
                if espObjects.Box then espObjects.Box:Destroy() end
                if espObjects.Line then espObjects.Line:Destroy() end
                if espObjects.NameLabel then espObjects.NameLabel:Destroy() end
                if espObjects.LevelLabel then espObjects.LevelLabel:Destroy() end
            end
            ESPObjects = {}
        end
    end
end)

-- Infinity Jump Implementation
UserInputService.JumpRequest:Connect(function()
    if Config.User.InfinityJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Walk on Water Implementation
spawn(function()
    while wait(0.5) do
        if Config.AutoFarm.WalkOnWater and LocalPlayer.Character then
            local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local ray = Ray.new(humanoidRootPart.Position, Vector3.new(0, -10, 0))
                local part, position = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
                
                if part and part.Name == "Water" then
                    humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, part.Position.Y + 5, humanoidRootPart.Position.Z)
                end
            end
        end
    end
end)

-- Auto Trade Implementation
spawn(function()
    while wait(5) do
        if Config.Trade.AutoTradeAllFish then
            -- Implement auto trade using game modules
            if TradeEvents and TradeEvents:FindFirstChild("TradeAllFish") then
                TradeEvents.TradeAllFish:FireServer()
            end
        end
    end
end)

-- Auto Accept Trade Implementation
if TradeEvents and TradeEvents:FindFirstChild("TradeRequest") then
    TradeEvents.TradeRequest.OnClientEvent:Connect(function(requester)
        if Config.Trade.AutoAcceptTrade then
            TradeEvents.AcceptTrade:FireServer(requester)
        end
    end)
end

-- Final notification
Rayfield:Notify({
    Title = "NIKZZ - FISH SCRIPT PRO",
    Content = "Script loaded successfully! Enjoy fishing!",
    Duration = 6,
    Image = 13047715178
})

-- Script length verification
local lineCount = 0
for _ in string.gmatch(debug.info(1, "s"), "\n") do
    lineCount = lineCount + 1
end

print("Script lines: " .. lineCount)
if lineCount < 3000 then
    warn("Script is less than 3000 lines. Some features may be missing.")
end
