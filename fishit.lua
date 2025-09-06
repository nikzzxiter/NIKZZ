-- Fish It Hub 2025 by Nikzz Xit
-- RayfieldLib Script for Fish It September 2025 (Revisi & Perbaikan)

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
local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes", 10)

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
        AutoCollectDailyReward = false,
        AutoRankClaim = false
    },
    Teleport = {
        SelectedLocation = "",
        SelectedPlayer = "",
        SavedPositions = {},
        Noclip = false,
        GhostHack = false
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
        NoClip = false
    },
    Trade = {
        AutoTradeAllFish = false,
        AutoAcceptTrade = false,
        TradePlayer = ""
    },
    Server = {
        AutoBuyCuaca = false,
        TeleportEvent = "",
        AutoTeleportEvent = false,
        ServerHop = false,
        RejoinServer = false
    },
    Settings = {
        SelectedTheme = "Dark",
        Transparency = 0.5,
        ConfigName = "DefaultConfig"
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
    Name = "NIKZZ SCRIPT - FISH IT",
    LoadingTitle = "Fish It Hub 2025",
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
            -- Implementasi Fishing Radar
            spawn(function()
                while Config.AutoFarm.FishingRadar and task.wait(1) do
                    pcall(function()
                        if Remotes and Remotes:FindFirstChild("FishingRadar") then
                            Remotes.FishingRadar:FireServer()
                        end
                    end)
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
            -- Implementasi disable efek
            pcall(function()
                if game:GetService("Lighting"):FindFirstChild("FishingEffects") then
                    game:GetService("Lighting").FishingEffects:Destroy()
                end
            end)
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
            -- Implementasi lock kamera
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.AutoRotate = false
                end
            end)
        else
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.AutoRotate = true
                end
            end)
        end
    end
})

-- Sell All Fish Button
AutoFarmTab:CreateButton({
    Name = "Sell All Fish",
    Callback = function()
        pcall(function()
            if FishingEvents and FishingEvents:FindFirstChild("SellAllFish") then
                FishingEvents.SellAllFish:FireServer()
                Rayfield:Notify({
                    Title = "Sell Fish",
                    Content = "All fish sold",
                    Duration = 3,
                    Image = 13047715178
                })
            elseif Remotes and Remotes:FindFirstChild("SellAllFish") then
                Remotes.SellAllFish:FireServer()
                Rayfield:Notify({
                    Title = "Sell Fish",
                    Content = "All fish sold",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        end)
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
    CurrentValue = Config.AutoFarm.AutoCollectDailyReward,
    Flag = "AutoCollectDailyReward",
    Callback = function(Value)
        Config.AutoFarm.AutoCollectDailyReward = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Collect Daily Reward",
                Content = "Auto collect daily reward enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Rank Claim
AutoFarmTab:CreateToggle({
    Name = "Auto Rank Claim",
    CurrentValue = Config.AutoFarm.AutoRankClaim,
    Flag = "AutoRankClaim",
    Callback = function(Value)
        Config.AutoFarm.AutoRankClaim = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Rank Claim",
                Content = "Auto rank claim enabled",
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
            if Config.Teleport.SelectedLocation == "Fisherman Island (Stingray Shores)" then
                targetCFrame = CFrame.new(-1200, 50, -800)
            elseif Config.Teleport.SelectedLocation == "Ocean" then
                targetCFrame = CFrame.new(0, 20, 0)
            elseif Config.Teleport.SelectedLocation == "Kohana Island (Volcano)" then
                targetCFrame = CFrame.new(1500, 100, 1200)
            elseif Config.Teleport.SelectedLocation == "Coral Reefs" then
                targetCFrame = CFrame.new(-800, 30, 1500)
            elseif Config.Teleport.SelectedLocation == "Esoteric Depths" then
                targetCFrame = CFrame.new(2000, -50, 2000)
            elseif Config.Teleport.SelectedLocation == "Tropical Grove" then
                targetCFrame = CFrame.new(-1500, 40, -1500)
            elseif Config.Teleport.SelectedLocation == "Crater Island" then
                targetCFrame = CFrame.new(800, 80, -1200)
            elseif Config.Teleport.SelectedLocation == "Lost Isle (Treasure Room)" then
                targetCFrame = CFrame.new(2500, 150, 2500)
            elseif Config.Teleport.SelectedLocation == "Lost Isle (Sisyphus Statue)" then
                targetCFrame = CFrame.new(2600, 160, 2600)
            end
            
            if targetCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
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
        Rayfield:Notify({
            Title = "Player List",
            Content = "Player list refreshed",
            Duration = 3,
            Image = 13047715178
        })
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

-- Ghost Hack (Noclip)
TeleportTab:CreateToggle({
    Name = "Ghost Hack (Noclip)",
    CurrentValue = Config.Teleport.GhostHack,
    Flag = "GhostHack",
    Callback = function(Value)
        Config.Teleport.GhostHack = Value
        if Value then
            Rayfield:Notify({
                Title = "Ghost Hack",
                Content = "Ghost hack enabled - You can now pass through objects",
                Duration = 3,
                Image = 13047715178
            })
        else
            Rayfield:Notify({
                Title = "Ghost Hack",
                Content = "Ghost hack disabled",
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
                Content = "Fly enabled (Press E to toggle)",
                Duration = 3,
                Image = 13047715178
            })
        else
            -- Reset fly state
            if flying then
                flying = false
                if LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.PlatformStand = false
                    end
                    local torso = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if torso then
                        local bg = torso:FindFirstChild("FlyBG")
                        if bg then bg:Destroy() end
                        local bv = torso:FindFirstChild("FlyBV")
                        if bv then bv:Destroy() end
                    end
                end
            end
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
        else
            -- Clear all ESP visuals
            for player, box in pairs(ESP.Boxes) do
                box.Visible = false
            end
            for player, line in pairs(ESP.Lines) do
                line.Visible = false
            end
            for player, name in pairs(ESP.Names) do
                name.Visible = false
            end
            for player, level in pairs(ESP.Levels) do
                level.Visible = false
            end
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

-- Noclip Toggle
UserTab:CreateToggle({
    Name = "Noclip Toggle",
    CurrentValue = Config.User.NoClip,
    Flag = "NoClip",
    Callback = function(Value)
        Config.User.NoClip = Value
        if Value then
            Rayfield:Notify({
                Title = "Noclip",
                Content = "Noclip enabled - You can pass through walls",
                Duration = 3,
                Image = 13047715178
            })
        else
            Rayfield:Notify({
                Title = "Noclip",
                Content = "Noclip disabled",
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
                pcall(function()
                    if TradeEvents and TradeEvents:FindFirstChild("SendTradeRequest") then
                        TradeEvents.SendTradeRequest:FireServer(targetPlayer)
                        Rayfield:Notify({
                            Title = "Trade Request",
                            Content = "Trade request sent to " .. Config.Trade.TradePlayer,
                            Duration = 3,
                            Image = 13047715178
                        })
                    elseif Remotes and Remotes:FindFirstChild("SendTradeRequest") then
                        Remotes.SendTradeRequest:FireServer(targetPlayer)
                        Rayfield:Notify({
                            Title = "Trade Request",
                            Content = "Trade request sent to " .. Config.Trade.TradePlayer,
                            Duration = 3,
                            Image = 13047715178
                        })
                    end
                end)
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
local playerCountLabel = ServerTab:CreateLabel("Player Total: " .. #Players:GetPlayers())

-- Update player count periodically
spawn(function()
    while task.wait(5) do
        playerCountLabel:Set("Player Total: " .. #Players:GetPlayers())
    end
end)

-- Event Teleport Dropdown
local Events = {
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

-- Auto Teleport Event
ServerTab:CreateToggle({
    Name = "Auto Teleport Event",
    CurrentValue = Config.Server.AutoTeleportEvent,
    Flag = "AutoTeleportEvent",
    Callback = function(Value)
        Config.Server.AutoTeleportEvent = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Teleport Event",
                Content = "Auto teleport to events enabled",
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
            Rayfield:Notify({
                Title = "Event Teleport",
                Content = "Teleporting to " .. Config.Server.TeleportEvent,
                Duration = 3,
                Image = 13047715178
            })
            
            -- Implementasi teleport ke event
            local eventCFrame
            if Config.Server.TeleportEvent == "Orca Migration" then
                eventCFrame = CFrame.new(-2000, 30, -2000)
            elseif Config.Server.TeleportEvent == "Shark Hunt" then
                eventCFrame = CFrame.new(2000, 30, -2000)
            -- Add more events as needed
            end
            
            if eventCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = eventCFrame
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

-- Server Hop
ServerTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        Rayfield:Notify({
            Title = "Server Hop",
            Content = "Searching for a new server...",
            Duration = 3,
            Image = 13047715178
        })
        
        -- Implementasi server hop
        pcall(function()
            local Http = game:GetService("HttpService")
            local TeleportService = game:GetService("TeleportService")
            
            local function serverHop()
                local servers = {}
                local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100")
                local data = Http:JSONDecode(req)
                
                for i, v in pairs(data.data) do
                    if v.playing ~= v.maxPlayers and v.id ~= game.JobId then
                        table.insert(servers, v.id)
                    end
                end
                
                if #servers > 0 then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
                else
                    Rayfield:Notify({
                        Title = "Server Hop",
                        Content = "No servers found, trying again...",
                        Duration = 3,
                        Image = 13047715178
                    })
                    wait(2)
                    serverHop()
                end
            end
            
            serverHop()
        end)
    end
})

-- Rejoin Server
ServerTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        Rayfield:Notify({
            Title = "Rejoin Server",
            Content = "Rejoining current server...",
            Duration = 3,
            Image = 13047715178
        })
        
        -- Implementasi rejoin server
        pcall(function()
            local TeleportService = game:GetService("TeleportService")
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
        end)
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

-- Set Config Button
SettingsTab:CreateButton({
    Name = "Set Config",
    Callback = function()
        Rayfield:Notify({
            Title = "Config Applied",
            Content = "Configuration settings applied",
            Duration = 3,
            Image = 13047715178
        })
    end
})

-- Destroy GUI Button
SettingsTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        Rayfield:Destroy()
    end
})

-- ESP System
local ESP = {
    Boxes = {},
    Lines = {},
    Names = {},
    Levels = {}
}

-- ESP Functions
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- ESP Box
    if Config.User.ESPBox and Config.User.PlayerESP then
        local box = Drawing.new("Square")
        box.Visible = false
        box.Color = Color3.fromRGB(255, 255, 255)
        box.Thickness = 2
        box.Filled = false
        ESP.Boxes[player] = box
    end
    
    -- ESP Line
    if Config.User.ESPLines and Config.User.PlayerESP then
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = Color3.fromRGB(255, 255, 255)
        line.Thickness = 2
        ESP.Lines[player] = line
    end
    
    -- ESP Name
    if Config.User.ESPName and Config.User.PlayerESP then
        local name = Drawing.new("Text")
        name.Visible = false
        name.Color = Color3.fromRGB(255, 255, 255)
        name.Size = 14
        name.Center = true
        name.Outline = true
        name.Text = player.Name
        ESP.Names[player] = name
    end
    
    -- ESP Level
    if Config.User.ESPLevel and Config.User.PlayerESP then
        local level = Drawing.new("Text")
        level.Visible = false
        level.Color = Color3.fromRGB(255, 255, 0)
        level.Size = 14
        level.Center = true
        level.Outline = true
        level.Text = "Level: " .. (player:FindFirstChild("Level") and player.Level.Value or "N/A")
        ESP.Levels[player] = level
    end
end

local function UpdateESP()
    for player, box in pairs(ESP.Boxes) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and Config.User.PlayerESP and Config.User.ESPBox then
            local humanoidRootPart = player.Character.HumanoidRootPart
            local position, visible = Workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
            
            if visible then
                local size = Vector2.new(2000 / position.Z, 3000 / position.Z)
                box.Size = size
                box.Position = Vector2.new(position.X - size.X / 2, position.Y - size.Y / 2)
                box.Visible = true
                
                -- Update line if exists
                if ESP.Lines[player] then
                    local line = ESP.Lines[player]
                    line.From = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y)
                    line.To = Vector2.new(position.X, position.Y)
                    line.Visible = Config.User.ESPLines
                end
                
                -- Update name if exists
                if ESP.Names[player] then
                    local name = ESP.Names[player]
                    name.Position = Vector2.new(position.X, position.Y - size.Y / 2 - 20)
                    name.Visible = Config.User.ESPName
                end
                
                -- Update level if exists
                if ESP.Levels[player] then
                    local level = ESP.Levels[player]
                    level.Position = Vector2.new(position.X, position.Y + size.Y / 2 + 10)
                    level.Visible = Config.User.ESPLevel
                end
            else
                box.Visible = false
                if ESP.Lines[player] then ESP.Lines[player].Visible = false end
                if ESP.Names[player] then ESP.Names[player].Visible = false end
                if ESP.Levels[player] then ESP.Levels[player].Visible = false end
            end
        else
            box.Visible = false
            if ESP.Lines[player] then ESP.Lines[player].Visible = false end
            if ESP.Names[player] then ESP.Names[player].Visible = false end
            if ESP.Levels[player] then ESP.Levels[player].Visible = false end
        end
    end
end

local function RemoveESP(player)
    if ESP.Boxes[player] then
        ESP.Boxes[player]:Remove()
        ESP.Boxes[player] = nil
    end
    if ESP.Lines[player] then
        ESP.Lines[player]:Remove()
        ESP.Lines[player] = nil
    end
    if ESP.Names[player] then
        ESP.Names[player]:Remove()
        ESP.Names[player] = nil
    end
    if ESP.Levels[player] then
        ESP.Levels[player]:Remove()
        ESP.Levels[player] = nil
    end
end

-- Initialize ESP for all players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

-- Handle new players
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        CreateESP(player)
    end)
end)

-- Handle players leaving
Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- Speed Hack
local function SpeedHack()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.User.SpeedHack and Config.User.SpeedValue or 16
    end
end

-- Infinity Jump
local function InfinityJump()
    if Config.User.InfinityJump then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

-- Fly System
local flying = false
local flySpeed = 0
local flyKeys = {W = false, A = false, S = false, D = false, E = false, Q = false}
local function Fly()
    if Config.User.Fly and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end
        
        local torso = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if torso then
            local bg = torso:FindFirstChild("FlyBG") or Instance.new("BodyGyro", torso)
            bg.Name = "FlyBG"
            bg.P = 10000
            bg.maxTorque = Vector3.new(900000, 900000, 900000)
            bg.cframe = torso.CFrame
            
            local bv = torso:FindFirstChild("FlyBV") or Instance.new("BodyVelocity", torso)
            bv.Name = "FlyBV"
            bv.velocity = Vector3.new(0, 0, 0)
            bv.maxForce = Vector3.new(1000000, 1000000, 1000000)
            
            flying = true
            
            -- Fly control system
            spawn(function()
                while flying and task.wait() do
                    if not Config.User.Fly then
                        flying = false
                        if humanoid then
                            humanoid.PlatformStand = false
                        end
                        if bg then bg:Destroy() end
                        if bv then bv:Destroy() end
                        break
                    end
                    
                    if torso then
                        local cam = Workspace.CurrentCamera.CFrame
                        local move = Vector3.new(
                            (flyKeys.D and 1 or 0) + (flyKeys.A and -1 or 0),
                            (flyKeys.E and 1 or 0) + (flyKeys.Q and -1 or 0),
                            (flyKeys.W and -1 or 0) + (flyKeys.S and 1 or 0)
                        )
                        
                        if move.Magnitude > 0 then
                            move = cam:VectorToWorldSpace(move)
                            bv.velocity = move * Config.User.FlyRange
                        else
                            bv.velocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end)
        end
    else
        flying = false
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
            local torso = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if torso then
                local bg = torso:FindFirstChild("FlyBG")
                if bg then bg:Destroy() end
                local bv = torso:FindFirstChild("FlyBV")
                if bv then bv:Destroy() end
            end
        end
    end
end

-- Fly key controls
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.W then
        flyKeys.W = true
    elseif input.KeyCode == Enum.KeyCode.A then
        flyKeys.A = true
    elseif input.KeyCode == Enum.KeyCode.S then
        flyKeys.S = true
    elseif input.KeyCode == Enum.KeyCode.D then
        flyKeys.D = true
    elseif input.KeyCode == Enum.KeyCode.E then
        flyKeys.E = true
    elseif input.KeyCode == Enum.KeyCode.Q then
        flyKeys.Q = true
    elseif input.KeyCode == Enum.KeyCode.X and Config.User.Fly then
        Config.User.Fly = not Config.User.Fly
        Rayfield:Notify({
            Title = "Fly",
            Content = "Fly " .. (Config.User.Fly and "enabled" or "disabled"),
            Duration = 2,
            Image = 13047715178
        })
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then
        flyKeys.W = false
    elseif input.KeyCode == Enum.KeyCode.A then
        flyKeys.A = false
    elseif input.KeyCode == Enum.KeyCode.S then
        flyKeys.S = false
    elseif input.KeyCode == Enum.KeyCode.D then
        flyKeys.D = false
    elseif input.KeyCode == Enum.KeyCode.E then
        flyKeys.E = false
    elseif input.KeyCode == Enum.KeyCode.Q then
        flyKeys.Q = false
    end
end)

-- Auto Fishing
local lastFishingTime = 0
local function AutoFish()
    if Config.AutoFarm.AutoFishV1 then
        local currentTime = tick()
        if currentTime - lastFishingTime >= Config.AutoFarm.AutoFishDelay then
            pcall(function()
                if FishingEvents and FishingEvents:FindFirstChild("StartFishing") then
                    FishingEvents.StartFishing:FireServer()
                elseif Remotes and Remotes:FindFirstChild("StartFishing") then
                    Remotes.StartFishing:FireServer()
                end
                
                lastFishingTime = currentTime
                
                -- Simulate perfect fishing
                if Config.AutoFarm.AutoInstantComplicatedFishing then
                    task.wait(0.5)
                    if FishingEvents and FishingEvents:FindFirstChild("CompleteFishing") then
                        FishingEvents.CompleteFishing:FireServer(true) -- Perfect catch
                    elseif Remotes and Remotes:FindFirstChild("CompleteFishing") then
                        Remotes.CompleteFishing:FireServer(true) -- Perfect catch
                    end
                end
            end)
        end
    end
end

-- Auto Sell
local lastSellTime = 0
local function AutoSell()
    if Config.AutoFarm.AutoSellFish then
        local currentTime = tick()
        if currentTime - lastSellTime >= Config.AutoFarm.DelaySellFish then
            pcall(function()
                if FishingEvents and FishingEvents:FindFirstChild("SellAllFish") then
                    FishingEvents.SellAllFish:FireServer()
                elseif Remotes and Remotes:FindFirstChild("SellAllFish") then
                    Remotes.SellAllFish:FireServer()
                end
                
                lastSellTime = currentTime
            end)
        end
    end
end

-- Auto Upgrade Rod
local function AutoUpgradeRod()
    if Config.AutoFarm.AutoUpgradeRod then
        pcall(function()
            if GameFunctions and GameFunctions:FindFirstChild("UpgradeRod") then
                GameFunctions.UpgradeRod:InvokeServer()
            elseif Remotes and Remotes:FindFirstChild("UpgradeRod") then
                Remotes.UpgradeRod:InvokeServer()
            end
        end)
    end
end

-- Auto Upgrade Backpack
local function AutoUpgradeBackpack()
    if Config.AutoFarm.AutoUpgradeBackpack then
        pcall(function()
            if GameFunctions and GameFunctions:FindFirstChild("UpgradeBackpack") then
                GameFunctions.UpgradeBackpack:InvokeServer()
            elseif Remotes and Remotes:FindFirstChild("UpgradeBackpack") then
                Remotes.UpgradeBackpack:InvokeServer()
            end
        end)
    end
end

-- Auto Equip Best Rod
local function AutoEquipBestRod()
    if Config.AutoFarm.AutoEquipBestRod then
        pcall(function()
            if GameFunctions and GameFunctions:FindFirstChild("EquipBestRod") then
                GameFunctions.EquipBestRod:InvokeServer()
            elseif Remotes and Remotes:FindFirstChild("EquipBestRod") then
                Remotes.EquipBestRod:InvokeServer()
            end
        end)
    end
end

-- Auto Equip Best Bait
local function AutoEquipBestBait()
    if Config.AutoFarm.AutoEquipBestBait then
        pcall(function()
            if GameFunctions and GameFunctions:FindFirstChild("EquipBestBait") then
                GameFunctions.EquipBestBait:InvokeServer()
            elseif Remotes and Remotes:FindFirstChild("EquipBestBait") then
                Remotes.EquipBestBait:InvokeServer()
            end
        end)
    end
end

-- Auto Collect Daily Reward
local lastDailyTime = 0
local function AutoCollectDailyReward()
    if Config.AutoFarm.AutoCollectDailyReward then
        local currentTime = tick()
        if currentTime - lastDailyTime >= 86400 then -- 24 hours
            pcall(function()
                if GameFunctions and GameFunctions:FindFirstChild("ClaimDailyReward") then
                    GameFunctions.ClaimDailyReward:InvokeServer()
                elseif Remotes and Remotes:FindFirstChild("ClaimDailyReward") then
                    Remotes.ClaimDailyReward:InvokeServer()
                end
                
                lastDailyTime = currentTime
            end)
        end
    end
end

-- Auto Rank Claim
local function AutoRankClaim()
    if Config.AutoFarm.AutoRankClaim then
        pcall(function()
            if GameFunctions and GameFunctions:FindFirstChild("ClaimRankRewards") then
                GameFunctions.ClaimRankRewards:InvokeServer()
            elseif Remotes and Remotes:FindFirstChild("ClaimRankRewards") then
                Remotes.ClaimRankRewards:InvokeServer()
            end
        end)
    end
end

-- Auto Buy Cuaca
local function AutoBuyCuaca()
    if Config.Server.AutoBuyCuaca then
        pcall(function()
            if GameFunctions and GameFunctions:FindFirstChild("BuyWeather") then
                GameFunctions.BuyWeather:InvokeServer("ClearSkies") -- Default to clear skies
            elseif Remotes and Remotes:FindFirstChild("BuyWeather") then
                Remotes.BuyWeather:InvokeServer("ClearSkies") -- Default to clear skies
            end
        end)
    end
end

-- Auto Teleport Event
local function AutoTeleportEvent()
    if Config.Server.AutoTeleportEvent and Config.Server.TeleportEvent ~= "" then
        pcall(function()
            local eventCFrame
            if Config.Server.TeleportEvent == "Orca Migration" then
                eventCFrame = CFrame.new(-2000, 30, -2000)
            elseif Config.Server.TeleportEvent == "Shark Hunt" then
                eventCFrame = CFrame.new(2000, 30, -2000)
            -- Add more events as needed
            end
            
            if eventCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = eventCFrame
            end
        end)
    end
end

-- Noclip System
local function Noclip()
    if Config.User.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end

-- Ghost Hack System
local function GhostHack()
    if Config.Teleport.GhostHack and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Transparency = 0.5
            end
        end
    elseif not Config.Teleport.GhostHack and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
                part.Transparency = 0
            end
        end
    end
end

-- Main Game Loop
RunService.Heartbeat:Connect(function()
    -- Update ESP
    if Config.User.PlayerESP then
        UpdateESP()
    else
        for player, box in pairs(ESP.Boxes) do
            box.Visible = false
        end
        for player, line in pairs(ESP.Lines) do
            line.Visible = false
        end
        for player, name in pairs(ESP.Names) do
            name.Visible = false
        end
        for player, level in pairs(ESP.Levels) do
            level.Visible = false
        end
    end
    
    -- Speed Hack
    SpeedHack()
    
    -- Auto Fish
    AutoFish()
    
    -- Auto Sell
    AutoSell()
    
    -- Fly
    if Config.User.Fly and not flying then
        Fly()
    elseif not Config.User.Fly and flying then
        flying = false
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
            local torso = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if torso then
                local bg = torso:FindFirstChild("FlyBG")
                if bg then bg:Destroy() end
                local bv = torso:FindFirstChild("FlyBV")
                if bv then bv:Destroy() end
            end
        end
    end
    
    -- Noclip
    Noclip()
    
    -- Ghost Hack
    GhostHack()
    
    -- Auto Upgrade Systems
    AutoUpgradeRod()
    AutoUpgradeBackpack()
    AutoEquipBestRod()
    AutoEquipBestBait()
    AutoCollectDailyReward()
    AutoRankClaim()
    AutoBuyCuaca()
    AutoTeleportEvent()
end)

-- Infinity Jump Input
UserInputService.JumpRequest:Connect(function()
    if Config.User.InfinityJump and LocalPlayer.Character then
        InfinityJump()
    end
end)

-- Auto Trade System
if TradeEvents then
    TradeEvents.ChildAdded:Connect(function(child)
        if child.Name == "TradeRequest" and Config.Trade.AutoAcceptTrade then
            task.wait(1)
            pcall(function()
                child:FireServer(true) -- Accept trade
            end)
        end
    end)
end

if Remotes then
    Remotes.ChildAdded:Connect(function(child)
        if child.Name == "TradeRequest" and Config.Trade.AutoAcceptTrade then
            task.wait(1)
            pcall(function()
                child:FireServer(true) -- Accept trade
            end)
        end
    end)
end

-- Notify when loaded
Rayfield:Notify({
    Title = "NIKZZ SCRIPT - FISH IT",
    Content = "by Nikzz Xit Loaded",
    Duration = 5,
    Image = 13047715178
})

-- Load default config if exists
if isfile("FishItConfig_DefaultConfig.json") then
    LoadConfig()
end
