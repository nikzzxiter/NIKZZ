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
local StarterGui = game:GetService("StarterGui")
local Stats = game:GetService("Stats")
local NetworkClient = game:GetService("NetworkClient")

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
local Shop = ReplicatedStorage:FindFirstChild("Shop") or ReplicatedStorage:WaitForChild("Shop", 10)
local Islands = Workspace:FindFirstChild("Islands") or Workspace:WaitForChild("Islands", 10)
local Events = Workspace:FindFirstChild("Events") or Workspace:WaitForChild("Events", 10)

-- Configuration
local Config = {
    FishFarm = {
        AutoFish = false,
        WaterFish = false,
        BypassRadar = false,
        BypassAir = false,
        DisableEffectFishing = false,
        AutoInstantComplicatedFishing = false,
        AutoSellFish = false,
        SellMythical = false,
        SellSecret = false,
        DelaySellFish = 1,
        AntiKickServer = true,
        AntiDetectSystem = true,
        AntiAFK = true,
        AutoJump = true,
        JumpDelay = 30
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
        SpawnBoat = false,
        InfinityJump = false,
        Fly = false,
        FlyRange = 50,
        FlyBoat = false,
        FlyBoatRange = 100,
        GhostHack = false,
        PlayerESP = false,
        ESPBox = true,
        ESPLines = true,
        ESPRange = true,
        ESPLevel = true,
        ESPHologram = false
    },
    Trader = {
        AutoAcceptTrade = false,
        SelectedFish = {},
        SelectedPlayer = "",
        TradeAllFish = false
    },
    Server = {
        SelectedCuaca = "Sunny",
        AutoBuyCuaca = false,
        ServerInfo = true
    },
    System = {
        ShowInfo = true,
        BoostFPS = false,
        FPSSetting = 60,
        AutoCleanMemory = false,
        DisableParticles = false
    },
    Graphic = {
        HighQuality = false,
        MaxRendering = false,
        UltraLowMode = false,
        DisableWaterReflection = false,
        CustomShader = false
    },
    RNGKill = {
        RNGReducer = false,
        ForceLegendary = false,
        SecretFishBoost = false,
        MythicalChance = false,
        AntiBadLuck = false
    },
    Shop = {
        BuyRod = "",
        BuyBoat = "",
        BuyBait = ""
    },
    Settings = {
        SelectedTheme = "Dark",
        Transparency = 0.5,
        ConfigName = "FishItConfig"
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
    Name = "NIKZZ - FISH IT HUB",
    LoadingTitle = "NIKZZ SCRIPT",
    LoadingSubtitle = "by Nikzz Xit",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    }
})

-- Fish Farm Tab
local FishFarmTab = Window:CreateTab("🎣 Fish Farm", 13014546625)

-- Auto Fish
FishFarmTab:CreateToggle({
    Name = "Auto Fish",
    CurrentValue = Config.FishFarm.AutoFish,
    Flag = "AutoFish",
    Callback = function(Value)
        Config.FishFarm.AutoFish = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Fish",
                Content = "Auto fishing enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Water Fish
FishFarmTab:CreateToggle({
    Name = "Water Fish",
    CurrentValue = Config.FishFarm.WaterFish,
    Flag = "WaterFish",
    Callback = function(Value)
        Config.FishFarm.WaterFish = Value
        if Value then
            Rayfield:Notify({
                Title = "Water Fish",
                Content = "Water fish enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Bypass Radar
FishFarmTab:CreateToggle({
    Name = "Bypass Radar",
    CurrentValue = Config.FishFarm.BypassRadar,
    Flag = "BypassRadar",
    Callback = function(Value)
        Config.FishFarm.BypassRadar = Value
        if Value then
            Rayfield:Notify({
                Title = "Bypass Radar",
                Content = "Radar bypass enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Bypass Air
FishFarmTab:CreateToggle({
    Name = "Bypass Air",
    CurrentValue = Config.FishFarm.BypassAir,
    Flag = "BypassAir",
    Callback = function(Value)
        Config.FishFarm.BypassAir = Value
        if Value then
            Rayfield:Notify({
                Title = "Bypass Air",
                Content = "Air bypass enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Disable Effect Fishing
FishFarmTab:CreateToggle({
    Name = "Disable Effect Fishing",
    CurrentValue = Config.FishFarm.DisableEffectFishing,
    Flag = "DisableEffectFishing",
    Callback = function(Value)
        Config.FishFarm.DisableEffectFishing = Value
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
FishFarmTab:CreateToggle({
    Name = "Auto Instant Complicated Fishing",
    CurrentValue = Config.FishFarm.AutoInstantComplicatedFishing,
    Flag = "AutoInstantComplicatedFishing",
    Callback = function(Value)
        Config.FishFarm.AutoInstantComplicatedFishing = Value
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

-- Auto Sell Fish
FishFarmTab:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = Config.FishFarm.AutoSellFish,
    Flag = "AutoSellFish",
    Callback = function(Value)
        Config.FishFarm.AutoSellFish = Value
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

-- Sell Mythical
FishFarmTab:CreateToggle({
    Name = "Sell Mythical",
    CurrentValue = Config.FishFarm.SellMythical,
    Flag = "SellMythical",
    Callback = function(Value)
        Config.FishFarm.SellMythical = Value
    end
})

-- Sell Secret
FishFarmTab:CreateToggle({
    Name = "Sell Secret",
    CurrentValue = Config.FishFarm.SellSecret,
    Flag = "SellSecret",
    Callback = function(Value)
        Config.FishFarm.SellSecret = Value
    end
})

-- Delay Sell Fish
FishFarmTab:CreateSlider({
    Name = "Delay Sell Fish",
    Range = {0.1, 10},
    Increment = 0.1,
    Suffix = "seconds",
    CurrentValue = Config.FishFarm.DelaySellFish,
    Flag = "DelaySellFish",
    Callback = function(Value)
        Config.FishFarm.DelaySellFish = Value
    end
})

-- Anti Kick Server
FishFarmTab:CreateToggle({
    Name = "Anti Kick Server",
    CurrentValue = Config.FishFarm.AntiKickServer,
    Flag = "AntiKickServer",
    Callback = function(Value)
        Config.FishFarm.AntiKickServer = Value
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

-- Anti Detect System
FishFarmTab:CreateToggle({
    Name = "Anti Detect System",
    CurrentValue = Config.FishFarm.AntiDetectSystem,
    Flag = "AntiDetectSystem",
    Callback = function(Value)
        Config.FishFarm.AntiDetectSystem = Value
        if Value then
            Rayfield:Notify({
                Title = "Anti Detect",
                Content = "Anti detect system enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Anti AFK
FishFarmTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = Config.FishFarm.AntiAFK,
    Flag = "AntiAFK",
    Callback = function(Value)
        Config.FishFarm.AntiAFK = Value
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

-- Auto Jump
FishFarmTab:CreateToggle({
    Name = "Auto Jump",
    CurrentValue = Config.FishFarm.AutoJump,
    Flag = "AutoJump",
    Callback = function(Value)
        Config.FishFarm.AutoJump = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Jump",
                Content = "Auto jump enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Jump Delay
FishFarmTab:CreateSlider({
    Name = "Jump Delay",
    Range = {10, 120},
    Increment = 5,
    Suffix = "seconds",
    CurrentValue = Config.FishFarm.JumpDelay,
    Flag = "JumpDelay",
    Callback = function(Value)
        Config.FishFarm.JumpDelay = Value
    end
})

-- Teleport Tab
local TeleportTab = Window:CreateTab("🗺 Teleport", 13014546625)

-- Select Location (Island Location)
local Locations = {
    "Starter Island",
    "Pearl Island",
    "Volcano Bay",
    "Deep Sea Trench",
    "Sky Lagoon",
    "Coral Reef",
    "Ancient Temple"
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
            elseif Config.Teleport.SelectedLocation == "Pearl Island" then
                targetCFrame = CFrame.new(150, 10, 150)
            elseif Config.Teleport.SelectedLocation == "Volcano Bay" then
                targetCFrame = CFrame.new(300, 20, 300)
            elseif Config.Teleport.SelectedLocation == "Deep Sea Trench" then
                targetCFrame = CFrame.new(450, 5, 450)
            elseif Config.Teleport.SelectedLocation == "Sky Lagoon" then
                targetCFrame = CFrame.new(600, 100, 600)
            elseif Config.Teleport.SelectedLocation == "Coral Reef" then
                targetCFrame = CFrame.new(750, 10, 750)
            elseif Config.Teleport.SelectedLocation == "Ancient Temple" then
                targetCFrame = CFrame.new(900, 15, 900)
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

-- Event Teleport Dropdown
local eventList = {}
for _, event in ipairs(Events:GetChildren()) do
    table.insert(eventList, event.Name)
end

TeleportTab:CreateDropdown({
    Name = "Select Event",
    Options = eventList,
    CurrentOption = Config.Teleport.SelectedEvent,
    Flag = "SelectedEvent",
    Callback = function(Value)
        Config.Teleport.SelectedEvent = Value
    end
})

-- Teleport to Event Button
TeleportTab:CreateButton({
    Name = "Teleport to Event",
    Callback = function()
        if Config.Teleport.SelectedEvent ~= "" then
            local event = Events:FindFirstChild(Config.Teleport.SelectedEvent)
            if event then
                LocalPlayer.Character:SetPrimaryPartCFrame(event.CFrame)
                Rayfield:Notify({
                    Title = "Event Teleport",
                    Content = "Teleported to " .. Config.Teleport.SelectedEvent,
                    Duration = 3,
                    Image = 13047715178
                })
            else
                Rayfield:Notify({
                    Title = "Event Error",
                    Content = "Event not found: " .. Config.Teleport.SelectedEvent,
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

-- Player Tab
local PlayerTab = Window:CreateTab("👤 Player", 13014546625)

-- Speed Hack
PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = Config.Player.SpeedHack,
    Flag = "SpeedHack",
    Callback = function(Value)
        Config.Player.SpeedHack = Value
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

-- Speed Value
PlayerTab:CreateSlider({
    Name = "Speed Value",
    Range = {16, 500},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = Config.Player.SpeedValue,
    Flag = "SpeedValue",
    Callback = function(Value)
        Config.Player.SpeedValue = Value
    end
})

-- Max Boat Speed
PlayerTab:CreateToggle({
    Name = "Max Boat Speed",
    CurrentValue = Config.Player.MaxBoatSpeed,
    Flag = "MaxBoatSpeed",
    Callback = function(Value)
        Config.Player.MaxBoatSpeed = Value
        if Value then
            Rayfield:Notify({
                Title = "Boat Speed",
                Content = "Max boat speed enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Spawn Boat
PlayerTab:CreateToggle({
    Name = "Spawn Boat",
    CurrentValue = Config.Player.SpawnBoat,
    Flag = "SpawnBoat",
    Callback = function(Value)
        Config.Player.SpawnBoat = Value
        if Value then
            Rayfield:Notify({
                Title = "Spawn Boat",
                Content = "Boat spawn enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Infinity Jump
PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = Config.Player.InfinityJump,
    Flag = "InfinityJump",
    Callback = function(Value)
        Config.Player.InfinityJump = Value
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
PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = Config.Player.Fly,
    Flag = "Fly",
    Callback = function(Value)
        Config.Player.Fly = Value
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
PlayerTab:CreateSlider({
    Name = "Fly Range",
    Range = {10, 200},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = Config.Player.FlyRange,
    Flag = "FlyRange",
    Callback = function(Value)
        Config.Player.FlyRange = Value
    end
})

-- Fly Boat
PlayerTab:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = Config.Player.FlyBoat,
    Flag = "FlyBoat",
    Callback = function(Value)
        Config.Player.FlyBoat = Value
        if Value then
            Rayfield:Notify({
                Title = "Fly Boat",
                Content = "Fly boat enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Fly Boat Range
PlayerTab:CreateSlider({
    Name = "Fly Boat Range",
    Range = {10, 300},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = Config.Player.FlyBoatRange,
    Flag = "FlyBoatRange",
    Callback = function(Value)
        Config.Player.FlyBoatRange = Value
    end
})

-- Ghost Hack
PlayerTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = Config.Player.GhostHack,
    Flag = "GhostHack",
    Callback = function(Value)
        Config.Player.GhostHack = Value
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
PlayerTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = Config.Player.PlayerESP,
    Flag = "PlayerESP",
    Callback = function(Value)
        Config.Player.PlayerESP = Value
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
PlayerTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = Config.Player.ESPBox,
    Flag = "ESPBox",
    Callback = function(Value)
        Config.Player.ESPBox = Value
    end
})

-- ESP Lines
PlayerTab:CreateToggle({
    Name = "ESP Lines",
    CurrentValue = Config.Player.ESPLines,
    Flag = "ESPLines",
    Callback = function(Value)
        Config.Player.ESPLines = Value
    end
})

-- ESP Range
PlayerTab:CreateToggle({
    Name = "ESP Range",
    CurrentValue = Config.Player.ESPRange,
    Flag = "ESPRange",
    Callback = function(Value)
        Config.Player.ESPRange = Value
    end
})

-- ESP Level
PlayerTab:CreateToggle({
    Name = "ESP Level",
    CurrentValue = Config.Player.ESPLevel,
    Flag = "ESPLevel",
    Callback = function(Value)
        Config.Player.ESPLevel = Value
    end
})

-- ESP Hologram
PlayerTab:CreateToggle({
    Name = "ESP Hologram",
    CurrentValue = Config.Player.ESPHologram,
    Flag = "ESPHologram",
    Callback = function(Value)
        Config.Player.ESPHologram = Value
        if Value then
            Rayfield:Notify({
                Title = "ESP Hologram",
                Content = "ESP hologram enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Trader Tab
local TraderTab = Window:CreateTab("💱 Trader", 13014546625)

-- Auto Accept Trade
TraderTab:CreateToggle({
    Name = "Auto Accept Trade",
    CurrentValue = Config.Trader.AutoAcceptTrade,
    Flag = "AutoAcceptTrade",
    Callback = function(Value)
        Config.Trader.AutoAcceptTrade = Value
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

-- Select Fish
TraderTab:CreateDropdown({
    Name = "Select Fish",
    Options = {"All Fish", "Common Fish", "Uncommon Fish", "Rare Fish", "Epic Fish", "Legendary Fish", "Mythical Fish", "Secret Fish"},
    CurrentOption = "All Fish",
    Flag = "SelectedFish",
    Callback = function(Value)
        Config.Trader.SelectedFish = Value
    end
})

-- Select Player
TraderTab:CreateInput({
    Name = "Select Player",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        Config.Trader.SelectedPlayer = Text
    end
})

-- Trade All Fish
TraderTab:CreateToggle({
    Name = "Trade All Fish",
    CurrentValue = Config.Trader.TradeAllFish,
    Flag = "TradeAllFish",
    Callback = function(Value)
        Config.Trader.TradeAllFish = Value
        if Value then
            Rayfield:Notify({
                Title = "Trade All Fish",
                Content = "Trade all fish enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Send Trade Request Button
TraderTab:CreateButton({
    Name = "Send Trade Request",
    Callback = function()
        if Config.Trader.SelectedPlayer ~= "" then
            local targetPlayer = Players:FindFirstChild(Config.Trader.SelectedPlayer)
            if targetPlayer then
                if TradeEvents and TradeEvents:FindFirstChild("SendTradeRequest") then
                    TradeEvents.SendTradeRequest:FireServer(targetPlayer)
                    Rayfield:Notify({
                        Title = "Trade Request",
                        Content = "Trade request sent to " .. Config.Trader.SelectedPlayer,
                        Duration = 3,
                        Image = 13047715178
                    })
                end
            else
                Rayfield:Notify({
                    Title = "Trade Error",
                    Content = "Player not found: " .. Config.Trader.SelectedPlayer,
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

-- Select Cuaca
local CuacaOptions = {"Sunny", "Stormy", "Fog", "Night", "Event Weather"}

ServerTab:CreateDropdown({
    Name = "Select Cuaca",
    Options = CuacaOptions,
    CurrentOption = Config.Server.SelectedCuaca,
    Flag = "SelectedCuaca",
    Callback = function(Value)
        Config.Server.SelectedCuaca = Value
    end
})

-- Buy Cuaca Button
ServerTab:CreateButton({
    Name = "Buy Cuaca",
    Callback = function()
        if Remotes and Remotes:FindFirstChild("BuyWeather") then
            Remotes.BuyWeather:FireServer(Config.Server.SelectedCuaca)
            Rayfield:Notify({
                Title = "Buy Cuaca",
                Content = "Bought " .. Config.Server.SelectedCuaca .. " weather",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

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

-- Player Info
ServerTab:CreateLabel("Player Total: " .. #Players:GetPlayers())

-- Server Info
ServerTab:CreateToggle({
    Name = "Server Info",
    CurrentValue = Config.Server.ServerInfo,
    Flag = "ServerInfo",
    Callback = function(Value)
        Config.Server.ServerInfo = Value
        if Value then
            Rayfield:Notify({
                Title = "Server Info",
                Content = "Server info display enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- System Tab
local SystemTab = Window:CreateTab("💻 System", 13014546625)

-- Show Info
SystemTab:CreateToggle({
    Name = "Show Info",
    CurrentValue = Config.System.ShowInfo,
    Flag = "ShowInfo",
    Callback = function(Value)
        Config.System.ShowInfo = Value
        if Value then
            Rayfield:Notify({
                Title = "Show Info",
                Content = "System info display enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Boost FPS
SystemTab:CreateToggle({
    Name = "Boost FPS",
    CurrentValue = Config.System.BoostFPS,
    Flag = "BoostFPS",
    Callback = function(Value)
        Config.System.BoostFPS = Value
        if Value then
            Rayfield:Notify({
                Title = "Boost FPS",
                Content = "FPS boost enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- FPS Setting
SystemTab:CreateSlider({
    Name = "FPS Setting",
    Range = {30, 360},
    Increment = 30,
    Suffix = "FPS",
    CurrentValue = Config.System.FPSSetting,
    Flag = "FPSSetting",
    Callback = function(Value)
        Config.System.FPSSetting = Value
        setfpscap(Value)
    end
})

-- Auto Clean Memory
SystemTab:CreateToggle({
    Name = "Auto Clean Memory",
    CurrentValue = Config.System.AutoCleanMemory,
    Flag = "AutoCleanMemory",
    Callback = function(Value)
        Config.System.AutoCleanMemory = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Clean Memory",
                Content = "Auto clean memory enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Disable Particles
SystemTab:CreateToggle({
    Name = "Disable Useless Particles",
    CurrentValue = Config.System.DisableParticles,
    Flag = "DisableParticles",
    Callback = function(Value)
        Config.System.DisableParticles = Value
        if Value then
            Rayfield:Notify({
                Title = "Disable Particles",
                Content = "Useless particles disabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Rejoin Server Button
SystemTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

-- Graphic Tab
local GraphicTab = Window:CreateTab("🎨 Graphic", 13014546625)

-- High Quality
GraphicTab:CreateToggle({
    Name = "High Quality",
    CurrentValue = Config.Graphic.HighQuality,
    Flag = "HighQuality",
    Callback = function(Value)
        Config.Graphic.HighQuality = Value
        if Value then
            settings().Rendering.QualityLevel = 10
            Rayfield:Notify({
                Title = "High Quality",
                Content = "High quality graphics enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Max Rendering
GraphicTab:CreateToggle({
    Name = "Max Rendering",
    CurrentValue = Config.Graphic.MaxRendering,
    Flag = "MaxRendering",
    Callback = function(Value)
        Config.Graphic.MaxRendering = Value
        if Value then
            settings().Rendering.QualityLevel = 21
            Rayfield:Notify({
                Title = "Max Rendering",
                Content = "Max rendering enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Ultra Low Mode
GraphicTab:CreateToggle({
    Name = "Ultra Low Mode",
    CurrentValue = Config.Graphic.UltraLowMode,
    Flag = "UltraLowMode",
    Callback = function(Value)
        Config.Graphic.UltraLowMode = Value
        if Value then
            settings().Rendering.QualityLevel = 1
            Rayfield:Notify({
                Title = "Ultra Low Mode",
                Content = "Ultra low mode enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Disable Water Reflection
GraphicTab:CreateToggle({
    Name = "Disable Water Reflection",
    CurrentValue = Config.Graphic.DisableWaterReflection,
    Flag = "DisableWaterReflection",
    Callback = function(Value)
        Config.Graphic.DisableWaterReflection = Value
        if Value then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Water") or v:IsA("Terrain") then
                    v.WaveSize = 0
                    v.WaveSpeed = 0
                end
            end
            Rayfield:Notify({
                Title = "Water Reflection",
                Content = "Water reflection disabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Custom Shader
GraphicTab:CreateToggle({
    Name = "Custom Shader",
    CurrentValue = Config.Graphic.CustomShader,
    Flag = "CustomShader",
    Callback = function(Value)
        Config.Graphic.CustomShader = Value
        if Value then
            Lighting.GlobalShadows = not Value
            Lighting.FogEnd = 100000
            Lighting.Brightness = 2
            Rayfield:Notify({
                Title = "Custom Shader",
                Content = "Custom shader enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- RNG Kill Tab
local RNGKillTab = Window:CreateTab("🎲 RNG Kill", 13014546625)

-- RNG Reducer
RNGKillTab:CreateToggle({
    Name = "RNG Reducer",
    CurrentValue = Config.RNGKill.RNGReducer,
    Flag = "RNGReducer",
    Callback = function(Value)
        Config.RNGKill.RNGReducer = Value
        if Value then
            Rayfield:Notify({
                Title = "RNG Reducer",
                Content = "RNG reducer enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Force Legendary Catch
RNGKillTab:CreateToggle({
    Name = "Force Legendary Catch",
    CurrentValue = Config.RNGKill.ForceLegendary,
    Flag = "ForceLegendary",
    Callback = function(Value)
        Config.RNGKill.ForceLegendary = Value
        if Value then
            Rayfield:Notify({
                Title = "Force Legendary",
                Content = "Force legendary catch enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Secret Fish Boost
RNGKillTab:CreateToggle({
    Name = "Secret Fish Boost",
    CurrentValue = Config.RNGKill.SecretFishBoost,
    Flag = "SecretFishBoost",
    Callback = function(Value)
        Config.RNGKill.SecretFishBoost = Value
        if Value then
            Rayfield:Notify({
                Title = "Secret Fish Boost",
                Content = "Secret fish boost enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Mythical Chance
RNGKillTab:CreateToggle({
    Name = "Mythical Chance ×10",
    CurrentValue = Config.RNGKill.MythicalChance,
    Flag = "MythicalChance",
    Callback = function(Value)
        Config.RNGKill.MythicalChance = Value
        if Value then
            Rayfield:Notify({
                Title = "Mythical Chance",
                Content = "Mythical chance ×10 enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Anti Bad Luck
RNGKillTab:CreateToggle({
    Name = "Anti Bad Luck",
    CurrentValue = Config.RNGKill.AntiBadLuck,
    Flag = "AntiBadLuck",
    Callback = function(Value)
        Config.RNGKill.AntiBadLuck = Value
        if Value then
            Rayfield:Notify({
                Title = "Anti Bad Luck",
                Content = "Anti bad luck enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Shop Tab
local ShopTab = Window:CreateTab("🛒 Shop", 13014546625)

-- Buy Rod
local Rods = {
    "Wooden Rod",
    "Iron Rod", 
    "Crystal Rod",
    "Legendary Rod",
    "Mythical Rod"
}

ShopTab:CreateDropdown({
    Name = "Buy Rod",
    Options = Rods,
    CurrentOption = Config.Shop.BuyRod,
    Flag = "BuyRod",
    Callback = function(Value)
        Config.Shop.BuyRod = Value
    end
})

-- Buy Rod Button
ShopTab:CreateButton({
    Name = "Buy Selected Rod",
    Callback = function()
        if Config.Shop.BuyRod ~= "" then
            if Shop and Shop:FindFirstChild("BuyRod") then
                Shop.BuyRod:FireServer(Config.Shop.BuyRod)
                Rayfield:Notify({
                    Title = "Buy Rod",
                    Content = "Bought " .. Config.Shop.BuyRod,
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            Rayfield:Notify({
                Title = "Shop Error",
                Content = "Please select a rod first",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Buy Boat
local Boats = {
    "Small Boat",
    "Speed Boat",
    "Viking Ship",
    "Mythical Ark"
}

ShopTab:CreateDropdown({
    Name = "Buy Boat",
    Options = Boats,
    CurrentOption = Config.Shop.BuyBoat,
    Flag = "BuyBoat",
    Callback = function(Value)
        Config.Shop.BuyBoat = Value
    end
})

-- Buy Boat Button
ShopTab:CreateButton({
    Name = "Buy Selected Boat",
    Callback = function()
        if Config.Shop.BuyBoat ~= "" then
            if Shop and Shop:FindFirstChild("BuyBoat") then
                Shop.BuyBoat:FireServer(Config.Shop.BuyBoat)
                Rayfield:Notify({
                    Title = "Buy Boat",
                    Content = "Bought " .. Config.Shop.BuyBoat,
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            Rayfield:Notify({
                Title = "Shop Error",
                Content = "Please select a boat first",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Buy Bait
local Baits = {
    "Worm",
    "Shrimp",
    "Golden Bait",
    "Mythical Lure"
}

ShopTab:CreateDropdown({
    Name = "Buy Bait",
    Options = Baits,
    CurrentOption = Config.Shop.BuyBait,
    Flag = "BuyBait",
    Callback = function(Value)
        Config.Shop.BuyBait = Value
    end
})

-- Buy Bait Button
ShopTab:CreateButton({
    Name = "Buy Selected Bait",
    Callback = function()
        if Config.Shop.BuyBait ~= "" then
            if Shop and Shop:FindFirstChild("BuyBait") then
                Shop.BuyBait:FireServer(Config.Shop.BuyBait)
                Rayfield:Notify({
                    Title = "Buy Bait",
                    Content = "Bought " .. Config.Shop.BuyBait,
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            Rayfield:Notify({
                Title = "Shop Error",
                Content = "Please select a bait first",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙ Settings", 13014546625)

-- Select Theme
local Themes = {
    "Dark",
    "Light",
    "Midnight",
    "Aqua",
    "Neon"
}

SettingsTab:CreateDropdown({
    Name = "Select Theme",
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

-- Transparency
SettingsTab:CreateSlider({
    Name = "Transparency",
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

-- Reset Config Button
SettingsTab:CreateButton({
    Name = "Reset Config",
    Callback = function()
        Config = {
            FishFarm = {
                AutoFish = false,
                WaterFish = false,
                BypassRadar = false,
                BypassAir = false,
                DisableEffectFishing = false,
                AutoInstantComplicatedFishing = false,
                AutoSellFish = false,
                SellMythical = false,
                SellSecret = false,
                DelaySellFish = 1,
                AntiKickServer = true,
                AntiDetectSystem = true,
                AntiAFK = true,
                AutoJump = true,
                JumpDelay = 30
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
                SpawnBoat = false,
                InfinityJump = false,
                Fly = false,
                FlyRange = 50,
                FlyBoat = false,
                FlyBoatRange = 100,
                GhostHack = false,
                PlayerESP = false,
                ESPBox = true,
                ESPLines = true,
                ESPRange = true,
                ESPLevel = true,
                ESPHologram = false
            },
            Trader = {
                AutoAcceptTrade = false,
                SelectedFish = {},
                SelectedPlayer = "",
                TradeAllFish = false
            },
            Server = {
                SelectedCuaca = "Sunny",
                AutoBuyCuaca = false,
                ServerInfo = true
            },
            System = {
                ShowInfo = true,
                BoostFPS = false,
                FPSSetting = 60,
                AutoCleanMemory = false,
                DisableParticles = false
            },
            Graphic = {
                HighQuality = false,
                MaxRendering = false,
                UltraLowMode = false,
                DisableWaterReflection = false,
                CustomShader = false
            },
            RNGKill = {
                RNGReducer = false,
                ForceLegendary = false,
                SecretFishBoost = false,
                MythicalChance = false,
                AntiBadLuck = false
            },
            Shop = {
                BuyRod = "",
                BuyBoat = "",
                BuyBait = ""
            },
            Settings = {
                SelectedTheme = "Dark",
                Transparency = 0.5,
                ConfigName = "FishItConfig"
            }
        }
        Rayfield:Notify({
            Title = "Config Reset",
            Content = "Configuration has been reset",
            Duration = 3,
            Image = 13047715178
        })
    end
})

-- Export Config Button
SettingsTab:CreateButton({
    Name = "Export Config",
    Callback = function()
        local json = HttpService:JSONEncode(Config)
        setclipboard(json)
        Rayfield:Notify({
            Title = "Config Exported",
            Content = "Configuration copied to clipboard",
            Duration = 3,
            Image = 13047715178
        })
    end
})

-- Import Config Button
SettingsTab:CreateButton({
    Name = "Import Config",
    Callback = function()
        local success, result = pcall(function()
            local json = getclipboard()
            Config = HttpService:JSONDecode(json)
        end)
        if success then
            Rayfield:Notify({
                Title = "Config Imported",
                Content = "Configuration imported from clipboard",
                Duration = 3,
                Image = 13047715178
            })
        else
            Rayfield:Notify({
                Title = "Import Error",
                Content = "Failed to import config: " .. result,
                Duration = 5,
                Image = 13047715178
            })
        end
    end
})

-- Destroy GUI Button
SettingsTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        Rayfield:Destroy()
    end
})

-- Main Loops and Functions
local ESP = {
    Boxes = {},
    Lines = {},
    Names = {},
    Levels = {},
    Ranges = {},
    Holograms = {}
}

-- ESP Functions
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- ESP Box
    if Config.Player.ESPBox and Config.Player.PlayerESP then
        local box = Drawing.new("Square")
        box.Visible = false
        box.Color = Color3.fromRGB(255, 255, 255)
        box.Thickness = 2
        box.Filled = false
        ESP.Boxes[player] = box
    end
    
    -- ESP Line
    if Config.Player.ESPLines and Config.Player.PlayerESP then
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = Color3.fromRGB(255, 255, 255)
        line.Thickness = 2
        ESP.Lines[player] = line
    end
    
    -- ESP Name
    if Config.Player.ESPLevel and Config.Player.PlayerESP then
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
    if Config.Player.ESPLevel and Config.Player.PlayerESP then
        local level = Drawing.new("Text")
        level.Visible = false
        level.Color = Color3.fromRGB(255, 255, 0)
        level.Size = 14
        level.Center = true
        level.Outline = true
        level.Text = "Level: " .. (player:FindFirstChild("Level") and player.Level.Value or "N/A")
        ESP.Levels[player] = level
    end
    
    -- ESP Range
    if Config.Player.ESPRange and Config.Player.PlayerESP then
        local range = Drawing.new("Text")
        range.Visible = false
        range.Color = Color3.fromRGB(0, 255, 0)
        range.Size = 14
        range.Center = true
        range.Outline = true
        range.Text = "Range: N/A"
        ESP.Ranges[player] = range
    end
    
    -- ESP Hologram
    if Config.Player.ESPHologram and Config.Player.PlayerESP then
        local hologram = Instance.new("Highlight")
        hologram.Adornee = character
        hologram.FillColor = Color3.fromRGB(255, 0, 255)
        hologram.OutlineColor = Color3.fromRGB(0, 255, 255)
        hologram.FillTransparency = 0.5
        hologram.OutlineTransparency = 0
        hologram.Enabled = false
        ESP.Holograms[player] = hologram
    end
end

local function UpdateESP()
    for player, box in pairs(ESP.Boxes) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and Config.Player.PlayerESP then
            local humanoidRootPart = player.Character.HumanoidRootPart
            local position, visible = Workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
            
            if visible then
                local size = Vector2.new(2000 / position.Z, 3000 / position.Z)
                box.Size = size
                box.Position = Vector2.new(position.X - size.X / 2, position.Y - size.Y / 2)
                box.Visible = Config.Player.ESPBox
                
                -- Update line if exists
                if ESP.Lines[player] then
                    local line = ESP.Lines[player]
                    line.From = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y)
                    line.To = Vector2.new(position.X, position.Y)
                    line.Visible = Config.Player.ESPLines
                end
                
                -- Update name if exists
                if ESP.Names[player] then
                    local name = ESP.Names[player]
                    name.Position = Vector2.new(position.X, position.Y - size.Y / 2 - 20)
                    name.Visible = Config.Player.ESPLevel
                end
                
                -- Update level if exists
                if ESP.Levels[player] then
                    local level = ESP.Levels[player]
                    level.Position = Vector2.new(position.X, position.Y + size.Y / 2 + 10)
                    level.Visible = Config.Player.ESPLevel
                end
                
                -- Update range if exists
                if ESP.Ranges[player] then
                    local range = ESP.Ranges[player]
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                    range.Text = "Range: " .. math.floor(distance) .. " studs"
                    range.Position = Vector2.new(position.X, position.Y + size.Y / 2 + 30)
                    range.Visible = Config.Player.ESPRange
                end
                
                -- Update hologram if exists
                if ESP.Holograms[player] then
                    ESP.Holograms[player].Enabled = Config.Player.ESPHologram
                end
            else
                box.Visible = false
                if ESP.Lines[player] then ESP.Lines[player].Visible = false end
                if ESP.Names[player] then ESP.Names[player].Visible = false end
                if ESP.Levels[player] then ESP.Levels[player].Visible = false end
                if ESP.Ranges[player] then ESP.Ranges[player].Visible = false end
                if ESP.Holograms[player] then ESP.Holograms[player].Enabled = false end
            end
        else
            box.Visible = false
            if ESP.Lines[player] then ESP.Lines[player].Visible = false end
            if ESP.Names[player] then ESP.Names[player].Visible = false end
            if ESP.Levels[player] then ESP.Levels[player].Visible = false end
            if ESP.Ranges[player] then ESP.Ranges[player].Visible = false end
            if ESP.Holograms[player] then ESP.Holograms[player].Enabled = false end
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
    if ESP.Ranges[player] then
        ESP.Ranges[player]:Remove()
        ESP.Ranges[player] = nil
    end
    if ESP.Holograms[player] then
        ESP.Holograms[player]:Destroy()
        ESP.Holograms[player] = nil
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
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.Player.SpeedHack and Config.Player.SpeedValue or 16
    end
end

-- Max Boat Speed
local function MaxBoatSpeed()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("Boat") then
        LocalPlayer.Character.Boat.MaxSpeed = Config.Player.MaxBoatSpeed and 1000 or 50
    end
end

-- Spawn Boat
local function SpawnBoat()
    if Config.Player.SpawnBoat and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if Remotes and Remotes:FindFirstChild("SpawnBoat") then
            Remotes.SpawnBoat:FireServer()
        end
    end
end

-- Infinity Jump
local function InfinityJump()
    if Config.Player.InfinityJump then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

-- Fly
local flying = false
local function Fly()
    if Config.Player.Fly and LocalPlayer.Character then
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
            
            local control = {f = 0, b = 0, l = 0, r = 0, u = 0, d = 0}
            UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.W then
                    control.f = 1
                elseif input.KeyCode == Enum.KeyCode.S then
                    control.b = -1
                elseif input.KeyCode == Enum.KeyCode.A then
                    control.l = -1
                elseif input.KeyCode == Enum.KeyCode.D then
                    control.r = 1
                elseif input.KeyCode == Enum.KeyCode.Space then
                    control.u = 1
                elseif input.KeyCode == Enum.KeyCode.LeftControl then
                    control.d = -1
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.W then
                    control.f = 0
                elseif input.KeyCode == Enum.KeyCode.S then
                    control.b = 0
                elseif input.KeyCode == Enum.KeyCode.A then
                    control.l = 0
                elseif input.KeyCode == Enum.KeyCode.D then
                    control.r = 0
                elseif input.KeyCode == Enum.KeyCode.Space then
                    control.u = 0
                elseif input.KeyCode == Enum.KeyCode.LeftControl then
                    control.d = 0
                end
            end)
            
            spawn(function()
                while flying and task.wait() do
                    if not Config.Player.Fly then
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
                        local move = Vector3.new(control.r + control.l, control.u + control.d, control.f + control.b)
                        if move.Magnitude > 0 then
                            move = cam:VectorToWorldSpace(move)
                            bv.velocity = move * Config.Player.FlyRange
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

-- Fly Boat
local flyingBoat = false
local function FlyBoat()
    if Config.Player.FlyBoat and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Boat") then
        local boat = LocalPlayer.Character.Boat
        
        local bg = boat:FindFirstChild("FlyBoatBG") or Instance.new("BodyGyro", boat)
        bg.Name = "FlyBoatBG"
        bg.P = 10000
        bg.maxTorque = Vector3.new(900000, 900000, 900000)
        bg.cframe = boat.CFrame
        
        local bv = boat:FindFirstChild("FlyBoatBV") or Instance.new("BodyVelocity", boat)
        bv.Name = "FlyBoatBV"
        bv.velocity = Vector3.new(0, 0, 0)
        bv.maxForce = Vector3.new(1000000, 1000000, 1000000)
        
        flyingBoat = true
        
        local control = {f = 0, b = 0, l = 0, r = 0, u = 0, d = 0}
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then
                control.f = 1
            elseif input.KeyCode == Enum.KeyCode.S then
                control.b = -1
            elseif input.KeyCode == Enum.KeyCode.A then
                control.l = -1
            elseif input.KeyCode == Enum.KeyCode.D then
                control.r = 1
            elseif input.KeyCode == Enum.KeyCode.Space then
                control.u = 1
            elseif input.KeyCode == Enum.KeyCode.LeftControl then
                control.d = -1
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then
                control.f = 0
            elseif input.KeyCode == Enum.KeyCode.S then
                control.b = 0
            elseif input.KeyCode == Enum.KeyCode.A then
                control.l = 0
            elseif input.KeyCode == Enum.KeyCode.D then
                control.r = 0
            elseif input.KeyCode == Enum.KeyCode.Space then
                control.u = 0
            elseif input.KeyCode == Enum.KeyCode.LeftControl then
                control.d = 0
            end
        end)
        
        spawn(function()
            while flyingBoat and task.wait() do
                if not Config.Player.FlyBoat then
                    flyingBoat = false
                    if bg then bg:Destroy() end
                    if bv then bv:Destroy() end
                    break
                end
                
                if boat then
                    local cam = Workspace.CurrentCamera.CFrame
                    local move = Vector3.new(control.r + control.l, control.u + control.d, control.f + control.b)
                    if move.Magnitude > 0 then
                        move = cam:VectorToWorldSpace(move)
                        bv.velocity = move * Config.Player.FlyBoatRange
                    else
                        bv.velocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end)
    else
        flyingBoat = false
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Boat") then
            local boat = LocalPlayer.Character.Boat
            local bg = boat:FindFirstChild("FlyBoatBG")
            if bg then bg:Destroy() end
            local bv = boat:FindFirstChild("FlyBoatBV")
            if bv then bv:Destroy() end
        end
    end
end

-- Ghost Hack
local function GhostHack()
    if Config.Player.GhostHack and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Transparency = 0.5
            end
        end
    else
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                    part.Transparency = 0
                end
            end
        end
    end
end

-- Auto Fish
local lastFishingTime = 0
local function AutoFish()
    if Config.FishFarm.AutoFish and FishingEvents and FishingEvents:FindFirstChild("StartFishing") then
        local currentTime = tick()
        if currentTime - lastFishingTime >= 1 then
            FishingEvents.StartFishing:FireServer()
            lastFishingTime = currentTime
            
            -- Simulate perfect fishing
            if Config.FishFarm.AutoInstantComplicatedFishing then
                task.wait(0.5)
                if FishingEvents:FindFirstChild("CompleteFishing") then
                    FishingEvents.CompleteFishing:FireServer(true) -- Perfect catch
                end
            end
        end
    end
end

-- Water Fish
local function WaterFish()
    if Config.FishFarm.WaterFish and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        -- Check if player is not in water
        if not LocalPlayer.Character.HumanoidRootPart:FindFirstChild("WaterDetector") then
            -- Create water detector
            local waterDetector = Instance.new("Part")
            waterDetector.Name = "WaterDetector"
            waterDetector.Size = Vector3.new(5, 1, 5)
            waterDetector.Transparency = 1
            waterDetector.CanCollide = false
            waterDetector.Anchored = true
            waterDetector.Parent = LocalPlayer.Character.HumanoidRootPart
            
            -- Simulate water fishing
            if FishingEvents and FishingEvents:FindFirstChild("StartFishing") then
                FishingEvents.StartFishing:FireServer()
                
                if Config.FishFarm.AutoInstantComplicatedFishing then
                    task.wait(0.5)
                    if FishingEvents:FindFirstChild("CompleteFishing") then
                        FishingEvents.CompleteFishing:FireServer(true) -- Perfect catch
                    end
                end
            end
        end
    end
end

-- Bypass Radar
local function BypassRadar()
    if Config.FishFarm.BypassRadar then
        -- Check if player has radar
        if not PlayerData:FindFirstChild("Radar") then
            -- Auto buy radar
            if Shop and Shop:FindFirstChild("BuyItem") then
                Shop.BuyItem:FireServer("Radar")
            end
        end
        
        -- Activate radar
        if Remotes and Remotes:FindFirstChild("ActivateRadar") then
            Remotes.ActivateRadar:FireServer(true)
        end
    end
end

-- Bypass Air
local function BypassAir()
    if Config.FishFarm.BypassAir then
        -- Check if player has air item
        if not PlayerData:FindFirstChild("AirTank") then
            -- Auto buy air tank
            if Shop and Shop:FindFirstChild("BuyItem") then
                Shop.BuyItem:FireServer("AirTank")
            end
        end
        
        -- Activate air tank
        if Remotes and Remotes:FindFirstChild("ActivateAirTank") then
            Remotes.ActivateAirTank:FireServer(true)
        end
    end
end

-- Disable Effect Fishing
local function DisableEffectFishing()
    if Config.FishFarm.DisableEffectFishing then
        -- Disable all particle effects related to fishing
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") and (v.Name:find("Fishing") or v.Name:find("Fish") or v.Name:find("Legendary") or v.Name:find("Mythical") or v.Name:find("Secret")) then
                v.Enabled = false
            end
        end
        
        -- Disable all light effects related to fishing
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("PointLight") or v:IsA("SpotLight") then
                if v.Name:find("Fishing") or v.Name:find("Fish") or v.Name:find("Legendary") or v.Name:find("Mythical") or v.Name:find("Secret") then
                    v.Enabled = false
                end
            end
        end
    end
end

-- Auto Sell Fish
local lastSellTime = 0
local function AutoSellFish()
    if Config.FishFarm.AutoSellFish and FishingEvents and FishingEvents:FindFirstChild("SellAllFish") then
        local currentTime = tick()
        if currentTime - lastSellTime >= Config.FishFarm.DelaySellFish then
            -- Check if we should sell mythical/secret fish
            if not Config.FishFarm.SellMythical or not Config.FishFarm.SellSecret then
                -- Get fish inventory
                if Remotes and Remotes:FindFirstChild("GetFishInventory") then
                    local fishInventory = Remotes.GetFishInventory:InvokeServer()
                    
                    if fishInventory then
                        -- Filter out mythical/secret fish if needed
                        local fishToSell = {}
                        for fishName, fishData in pairs(fishInventory) do
                            if (Config.FishFarm.SellMythical or not fishData.Rarity:find("Mythical")) and 
                               (Config.FishFarm.SellSecret or not fishData.Rarity:find("Secret")) then
                                table.insert(fishToSell, fishName)
                            end
                        end
                        
                        -- Sell filtered fish
                        if #fishToSell > 0 then
                            FishingEvents.SellFish:FireServer(fishToSell)
                        end
                    end
                end
            else
                -- Sell all fish
                FishingEvents.SellAllFish:FireServer()
            end
            
            lastSellTime = currentTime
        end
    end
end

-- Auto Jump
local lastJumpTime = 0
local function AutoJump()
    if Config.FishFarm.AutoJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local currentTime = tick()
        if currentTime - lastJumpTime >= Config.FishFarm.JumpDelay then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            lastJumpTime = currentTime
        end
    end
end

-- Auto Buy Cuaca
local function AutoBuyCuaca()
    if Config.Server.AutoBuyCuaca and Remotes and Remotes:FindFirstChild("BuyWeather") then
        Remotes.BuyWeather:FireServer(Config.Server.SelectedCuaca)
    end
end

-- Auto Clean Memory
local function AutoCleanMemory()
    if Config.System.AutoCleanMemory then
        -- Clean textures
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Texture") or v:IsA("Decal") then
                v:Destroy()
            end
        end
        
        -- Clean unused assets
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("MeshPart") and not v:IsDescendantOf(Workspace) then
                v:Destroy()
            end
        end
        
        -- Clean sounds
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Sound") and not v.IsPlaying then
                v:Destroy()
            end
        end
    end
end

-- Disable Useless Particles
local function DisableUselessParticles()
    if Config.System.DisableParticles then
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") and not v.Name:find("Important") then
                v.Enabled = false
            end
        end
    end
end

-- RNG Reducer
local function RNGReducer()
    if Config.RNGKill.RNGReducer then
        -- Manipulate random seed for better RNG
        math.randomseed(tick())
        
        -- Force better catch rates
        if Remotes and Remotes:FindFirstChild("SetRNG") then
            Remotes.SetRNG:FireServer(0.8) -- Higher chance for rare fish
        end
    end
end

-- Force Legendary Catch
local function ForceLegendaryCatch()
    if Config.RNGKill.ForceLegendary then
        -- Force legendary catch
        if FishingEvents and FishingEvents:FindFirstChild("ForceCatch") then
            FishingEvents.ForceCatch:FireServer("Legendary")
        end
    end
end

-- Secret Fish Boost
local function SecretFishBoost()
    if Config.RNGKill.SecretFishBoost then
        -- Boost secret fish chance
        if Remotes and Remotes:FindFirstChild("BoostSecretChance") then
            Remotes.BoostSecretChance:FireServer(10) -- 10x boost
        end
    end
end

-- Mythical Chance
local function MythicalChance()
    if Config.RNGKill.MythicalChance then
        -- Boost mythical chance
        if Remotes and Remotes:FindFirstChild("BoostMythicalChance") then
            Remotes.BoostMythicalChance:FireServer(10) -- 10x boost
        end
    end
end

-- Anti Bad Luck
local function AntiBadLuck()
    if Config.RNGKill.AntiBadLuck then
        -- Reset RNG seed
        math.randomseed(tick())
        
        -- Reset bad luck
        if Remotes and Remotes:FindFirstChild("ResetBadLuck") then
            Remotes.ResetBadLuck:FireServer()
        end
    end
end

-- Show Info
local infoGui = nil
local function ShowInfo()
    if Config.System.ShowInfo then
        if not infoGui then
            infoGui = Instance.new("ScreenGui")
            infoGui.Name = "SystemInfo"
            infoGui.Parent = CoreGui
            infoGui.ResetOnSpawn = false
            
            local infoFrame = Instance.new("Frame")
            infoFrame.Name = "InfoFrame"
            infoFrame.Size = UDim2.new(0, 200, 0, 120)
            infoFrame.Position = UDim2.new(0, 10, 0, 10)
            infoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            infoFrame.BackgroundTransparency = 0.5
            infoFrame.BorderSizePixel = 0
            infoFrame.Parent = infoGui
            
            local fpsLabel = Instance.new("TextLabel")
            fpsLabel.Name = "FPSLabel"
            fpsLabel.Size = UDim2.new(1, 0, 0, 30)
            fpsLabel.Position = UDim2.new(0, 0, 0, 0)
            fpsLabel.BackgroundTransparency = 1
            fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
            fpsLabel.TextScaled = true
            fpsLabel.Font = Enum.Font.SourceSansBold
            fpsLabel.Text = "FPS: 0"
            fpsLabel.Parent = infoFrame
            
            local pingLabel = Instance.new("TextLabel")
            pingLabel.Name = "PingLabel"
            pingLabel.Size = UDim2.new(1, 0, 0, 30)
            pingLabel.Position = UDim2.new(0, 0, 0, 30)
            pingLabel.BackgroundTransparency = 1
            pingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            pingLabel.TextXAlignment = Enum.TextXAlignment.Left
            pingLabel.TextScaled = true
            pingLabel.Font = Enum.Font.SourceSansBold
            pingLabel.Text = "Ping: 0ms"
            pingLabel.Parent = infoFrame
            
            local timeLabel = Instance.new("TextLabel")
            timeLabel.Name = "TimeLabel"
            timeLabel.Size = UDim2.new(1, 0, 0, 30)
            timeLabel.Position = UDim2.new(0, 0, 0, 60)
            timeLabel.BackgroundTransparency = 1
            timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            timeLabel.TextXAlignment = Enum.TextXAlignment.Left
            timeLabel.TextScaled = true
            timeLabel.Font = Enum.Font.SourceSansBold
            timeLabel.Text = "Time: 00:00:00"
            timeLabel.Parent = infoFrame
            
            local batteryLabel = Instance.new("TextLabel")
            batteryLabel.Name = "BatteryLabel"
            batteryLabel.Size = UDim2.new(1, 0, 0, 30)
            batteryLabel.Position = UDim2.new(0, 0, 0, 90)
            batteryLabel.BackgroundTransparency = 1
            batteryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            batteryLabel.TextXAlignment = Enum.TextXAlignment.Left
            batteryLabel.TextScaled = true
            batteryLabel.Font = Enum.Font.SourceSansBold
            batteryLabel.Text = "Battery: N/A"
            batteryLabel.Parent = infoFrame
            
            -- Update info
            spawn(function()
                local lastTime = tick()
                local frameCount = 0
                local fps = 0
                
                while infoGui and infoGui.Parent do
                    frameCount = frameCount + 1
                    
                    -- Update FPS
                    if tick() - lastTime >= 1 then
                        fps = frameCount
                        frameCount = 0
                        lastTime = tick()
                        fpsLabel.Text = "FPS: " .. fps
                    end
                    
                    -- Update Ping
                    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                    pingLabel.Text = "Ping: " .. ping .. "ms"
                    
                    -- Update Time
                    local currentTime = os.date("*t")
                    timeLabel.Text = string.format("Time: %02d:%02d:%02d", currentTime.hour, currentTime.min, currentTime.sec)
                    
                    -- Update Battery (if available)
                    if game:GetService("GuiService"):IsTenFootInterface() then
                        local battery = game:GetService("GuiService"):GetBatteryLevel()
                        batteryLabel.Text = "Battery: " .. math.floor(battery * 100) .. "%"
                    else
                        batteryLabel.Text = "Battery: N/A"
                    end
                    
                    task.wait(0.1)
                end
            end)
        end
    else
        if infoGui then
            infoGui:Destroy()
            infoGui = nil
        end
    end
end

-- Server Info
local serverInfoGui = nil
local function ServerInfo()
    if Config.Server.ServerInfo then
        if not serverInfoGui then
            serverInfoGui = Instance.new("ScreenGui")
            serverInfoGui.Name = "ServerInfo"
            serverInfoGui.Parent = CoreGui
            serverInfoGui.ResetOnSpawn = false
            
            local infoFrame = Instance.new("Frame")
            infoFrame.Name = "InfoFrame"
            infoFrame.Size = UDim2.new(0, 200, 0, 90)
            infoFrame.Position = UDim2.new(1, -210, 0, 10)
            infoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            infoFrame.BackgroundTransparency = 0.5
            infoFrame.BorderSizePixel = 0
            infoFrame.Parent = serverInfoGui
            
            local playerCountLabel = Instance.new("TextLabel")
            playerCountLabel.Name = "PlayerCountLabel"
            playerCountLabel.Size = UDim2.new(1, 0, 0, 30)
            playerCountLabel.Position = UDim2.new(0, 0, 0, 0)
            playerCountLabel.BackgroundTransparency = 1
            playerCountLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            playerCountLabel.TextXAlignment = Enum.TextXAlignment.Left
            playerCountLabel.TextScaled = true
            playerCountLabel.Font = Enum.Font.SourceSansBold
            playerCountLabel.Text = "Players: 0"
            playerCountLabel.Parent = infoFrame
            
            local serverLuckLabel = Instance.new("TextLabel")
            serverLuckLabel.Name = "ServerLuckLabel"
            serverLuckLabel.Size = UDim2.new(1, 0, 0, 30)
            serverLuckLabel.Position = UDim2.new(0, 0, 0, 30)
            serverLuckLabel.BackgroundTransparency = 1
            serverLuckLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            serverLuckLabel.TextXAlignment = Enum.TextXAlignment.Left
            serverLuckLabel.TextScaled = true
            serverLuckLabel.Font = Enum.Font.SourceSansBold
            serverLuckLabel.Text = "Server Luck: 0%"
            serverLuckLabel.Parent = infoFrame
            
            local serverSeedLabel = Instance.new("TextLabel")
            serverSeedLabel.Name = "ServerSeedLabel"
            serverSeedLabel.Size = UDim2.new(1, 0, 0, 30)
            serverSeedLabel.Position = UDim2.new(0, 0, 0, 60)
            serverSeedLabel.BackgroundTransparency = 1
            serverSeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            serverSeedLabel.TextXAlignment = Enum.TextXAlignment.Left
            serverSeedLabel.TextScaled = true
            serverSeedLabel.Font = Enum.Font.SourceSansBold
            serverSeedLabel.Text = "Server Seed: 0"
            serverSeedLabel.Parent = infoFrame
            
            -- Update info
            spawn(function()
                while serverInfoGui and serverInfoGui.Parent do
                    -- Update Player Count
                    playerCountLabel.Text = "Players: " .. #Players:GetPlayers()
                    
                    -- Update Server Luck
                    if Remotes and Remotes:FindFirstChild("GetServerLuck") then
                        local serverLuck = Remotes.GetServerLuck:InvokeServer()
                        serverLuckLabel.Text = "Server Luck: " .. math.floor(serverLuck * 100) .. "%"
                    end
                    
                    -- Update Server Seed
                    if Remotes and Remotes:FindFirstChild("GetServerSeed") then
                        local serverSeed = Remotes.GetServerSeed:InvokeServer()
                        serverSeedLabel.Text = "Server Seed: " .. serverSeed
                    end
                    
                    task.wait(1)
                end
            end)
        end
    else
        if serverInfoGui then
            serverInfoGui:Destroy()
            serverInfoGui = nil
        end
    end
end

-- Main Game Loop
spawn(function()
    while task.wait() do
        -- Update ESP
        if Config.Player.PlayerESP then
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
            for player, range in pairs(ESP.Ranges) do
                range.Visible = false
            end
            for player, hologram in pairs(ESP.Holograms) do
                hologram.Enabled = false
            end
        end
        
        -- Speed Hack
        SpeedHack()
        
        -- Max Boat Speed
        MaxBoatSpeed()
        
        -- Spawn Boat
        SpawnBoat()
        
        -- Fly
        if Config.Player.Fly and not flying then
            Fly()
        elseif not Config.Player.Fly and flying then
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
        
        -- Fly Boat
        if Config.Player.FlyBoat and not flyingBoat then
            FlyBoat()
        elseif not Config.Player.FlyBoat and flyingBoat then
            flyingBoat = false
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Boat") then
                local boat = LocalPlayer.Character.Boat
                local bg = boat:FindFirstChild("FlyBoatBG")
                if bg then bg:Destroy() end
                local bv = boat:FindFirstChild("FlyBoatBV")
                if bv then bv:Destroy() end
            end
        end
        
        -- Ghost Hack
        GhostHack()
        
        -- Auto Fish
        AutoFish()
        
        -- Water Fish
        WaterFish()
        
        -- Bypass Radar
        BypassRadar()
        
        -- Bypass Air
        BypassAir()
        
        -- Disable Effect Fishing
        DisableEffectFishing()
        
        -- Auto Sell Fish
        AutoSellFish()
        
        -- Auto Jump
        AutoJump()
        
        -- Auto Buy Cuaca
        AutoBuyCuaca()
        
        -- Auto Clean Memory
        if tick() % 30 == 0 then
            AutoCleanMemory()
        end
        
        -- Disable Useless Particles
        DisableUselessParticles()
        
        -- RNG Reducer
        RNGReducer()
        
        -- Force Legendary Catch
        ForceLegendaryCatch()
        
        -- Secret Fish Boost
        SecretFishBoost()
        
        -- Mythical Chance
        MythicalChance()
        
        -- Anti Bad Luck
        AntiBadLuck()
        
        -- Show Info
        ShowInfo()
        
        -- Server Info
        ServerInfo()
        
        task.wait()
    end
end)

-- Infinity Jump Input
UserInputService.JumpRequest:Connect(function()
    if Config.Player.InfinityJump and LocalPlayer.Character then
        InfinityJump()
    end
end)

-- Notify when loaded
Rayfield:Notify({
    Title = "NIKZZ SCRIPT",
    Content = "Fish It Hub 2025 Loaded",
    Duration = 5,
    Image = 13047715178
})

-- Load default config if exists
if isfile("FishItConfig_FishItConfig.json") then
    LoadConfig()
end
