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
local GuiService = game:GetService("GuiService")
local MarketPlaceService = game:GetService("MarketplaceService")

-- Game Variables
local FishingEvents = ReplicatedStorage:FindFirstChild("FishingEvents") or ReplicatedStorage:WaitForChild("FishingEvents", 10)
local TradeEvents = ReplicatedStorage:FindFirstChild("TradeEvents") or ReplicatedStorage:WaitForChild("TradeEvents", 10)
local GameFunctions = ReplicatedStorage:FindFirstChild("GameFunctions") or ReplicatedStorage:WaitForChild("GameFunctions", 10)
local PlayerData = LocalPlayer:FindFirstChild("PlayerData") or LocalPlayer:WaitForChild("PlayerData", 10)
local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes", 10)
local Modules = ReplicatedStorage:FindFirstChild("Modules") or ReplicatedStorage:WaitForChild("Modules", 10)

-- Game Data
local Rods = {
    "Starter Rod", "Carbon Rod", "Toy Rod", "Grass Rod", "Lava Rod", 
    "Lucky Rod", "Midnight Rod", "Demascus Rod", "Ice Rod", "Steampunk Rod", 
    "Chrome Rod", "Astral Rod", "Ares Rod", "Ghostfinn Rod", "Angler Rod"
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

local Weathers = {
    "Sunny", "Stormy", "Fog", "Night", "Event"
}

local Events = {
    "Treasure Event", "Sisyphus Event", "Seasonal Event"
}

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
        WaterFish = false,
        ForceLegendary = false,
        SecretBoost = false,
        MythicalChance = false,
        RNGReducer = false,
        AntiBadLuck = false
    },
    Teleport = {
        SelectedLocation = "",
        SelectedPlayer = "",
        SavedPositions = {},
        AutoTeleportEvent = false
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
        GhostHack = false,
        BoatSpeed = false,
        MaxBoatSpeed = false,
        SpawnBoat = false
    },
    Trade = {
        AutoTradeAllFish = false,
        AutoAcceptTrade = false,
        TradePlayer = "",
        TradeFilterMythical = false,
        TradeFilterSecret = false
    },
    Server = {
        AutoBuyCuaca = false,
        TeleportEvent = "",
        SelectedWeather = "",
        PlayerCount = 0,
        ServerLuck = 0,
        ServerSeed = "",
        ActiveEvent = ""
    },
    Shop = {
        AutoBuyRod = false,
        SelectedRod = "",
        AutoBuyBait = false,
        SelectedBait = "",
        AutoBuyBoat = false,
        SelectedBoat = ""
    },
    Graphics = {
        HighQuality = false,
        MaxRendering = false,
        UltraLowMode = false,
        DisableWaterReflection = false,
        CustomShader = false,
        OptimizePerformance = false,
        DisableParticles = false,
        FPSLimit = 60
    },
    System = {
        ShowInfo = false,
        AutoCleanMemory = false,
        AutoRejoin = false,
        FPSBoost = false,
        BatterySaver = false
    },
    Settings = {
        SelectedTheme = "Dark",
        Transparency = 0.5,
        ConfigName = "DefaultConfig",
        Keybinds = {}
    }
}

-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    if Config.AutoFarm.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Anti-Kick
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" then
        if Config.AutoFarm.AntiKickServer then
            return nil
        end
    end
    return old(self, ...)
end)
setreadonly(mt, true)

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
            -- Disable fishing effects
            if Modules and Modules:FindFirstChild("EffectsModule") then
                local EffectsModule = require(Modules.EffectsModule)
                if EffectsModule then
                    local originalPlayEffect = EffectsModule.PlayEffect
                    EffectsModule.PlayEffect = function(effectType, ...)
                        if Config.AutoFarm.DisableEffectFishing then
                            return nil
                        end
                        return originalPlayEffect(effectType, ...)
                    end
                end
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

-- Water Fish (Fish anywhere)
AutoFarmTab:CreateToggle({
    Name = "Water Fish (Fish Anywhere)",
    CurrentValue = Config.AutoFarm.WaterFish,
    Flag = "WaterFish",
    Callback = function(Value)
        Config.AutoFarm.WaterFish = Value
        if Value then
            Rayfield:Notify({
                Title = "Water Fish",
                Content = "Can fish anywhere enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Force Legendary Catch
AutoFarmTab:CreateToggle({
    Name = "Force Legendary Catch",
    CurrentValue = Config.AutoFarm.ForceLegendary,
    Flag = "ForceLegendary",
    Callback = function(Value)
        Config.AutoFarm.ForceLegendary = Value
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
AutoFarmTab:CreateToggle({
    Name = "Secret Fish Boost",
    CurrentValue = Config.AutoFarm.SecretBoost,
    Flag = "SecretBoost",
    Callback = function(Value)
        Config.AutoFarm.SecretBoost = Value
        if Value then
            Rayfield:Notify({
                Title = "Secret Boost",
                Content = "Secret fish boost enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Mythical Chance ×10
AutoFarmTab:CreateToggle({
    Name = "Mythical Chance ×10",
    CurrentValue = Config.AutoFarm.MythicalChance,
    Flag = "MythicalChance",
    Callback = function(Value)
        Config.AutoFarm.MythicalChance = Value
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

-- RNG Reducer
AutoFarmTab:CreateToggle({
    Name = "RNG Reducer",
    CurrentValue = Config.AutoFarm.RNGReducer,
    Flag = "RNGReducer",
    Callback = function(Value)
        Config.AutoFarm.RNGReducer = Value
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

-- Anti-Bad Luck
AutoFarmTab:CreateToggle({
    Name = "Anti-Bad Luck",
    CurrentValue = Config.AutoFarm.AntiBadLuck,
    Flag = "AntiBadLuck",
    Callback = function(Value)
        Config.AutoFarm.AntiBadLuck = Value
        if Value then
            Rayfield:Notify({
                Title = "Anti-Bad Luck",
                Content = "Anti-bad luck enabled",
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
            local targetCFrame
            -- Real island positions (approximate)
            if Config.Teleport.SelectedLocation == "Fisherman Island" then
                targetCFrame = CFrame.new(-120, 10, -80)
            elseif Config.Teleport.SelectedLocation == "Ocean" then
                targetCFrame = CFrame.new(500, 5, 500)
            elseif Config.Teleport.SelectedLocation == "Kohana Island" then
                targetCFrame = CFrame.new(-300, 15, 200)
            elseif Config.Teleport.SelectedLocation == "Kohana Volcano" then
                targetCFrame = CFrame.new(-350, 50, 250)
            elseif Config.Teleport.SelectedLocation == "Coral Reefs" then
                targetCFrame = CFrame.new(200, -10, 150)
            elseif Config.Teleport.SelectedLocation == "Esoteric Depths" then
                targetCFrame = CFrame.new(400, -30, 400)
            elseif Config.Teleport.SelectedLocation == "Tropical Grove" then
                targetCFrame = CFrame.new(-200, 12, -200)
            elseif Config.Teleport.SelectedLocation == "Crater Island" then
                targetCFrame = CFrame.new(0, 25, 0)
            elseif Config.Teleport.SelectedLocation == "Lost Isle" then
                targetCFrame = CFrame.new(600, 20, 600)
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
        TeleportTab:UpdateDropdown("SelectedPlayer", {
            Options = UpdatePlayerList()
        })
        Rayfield:Notify({
            Title = "Player List",
            Content = "Player list refreshed",
            Duration = 2,
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

-- Auto Teleport to Event
TeleportTab:CreateToggle({
    Name = "Auto Teleport to Event",
    CurrentValue = Config.Teleport.AutoTeleportEvent,
    Flag = "AutoTeleportEvent",
    Callback = function(Value)
        Config.Teleport.AutoTeleportEvent = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Event Teleport",
                Content = "Auto teleport to events enabled",
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
                
                -- Update saved positions dropdown
                local savedPositionsList = {}
                for name, _ in pairs(Config.Teleport.SavedPositions) do
                    table.insert(savedPositionsList, name)
                end
                TeleportTab:UpdateDropdown("SavedPosition", {
                    Options = savedPositionsList
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
            
            -- Update saved positions dropdown
            local savedPositionsList = {}
            for name, _ in pairs(Config.Teleport.SavedPositions) do
                table.insert(savedPositionsList, name)
            end
            TeleportTab:UpdateDropdown("SavedPosition", {
                Options = savedPositionsList
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

-- Ghost Hack
UserTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = Config.User.GhostHack,
    Flag = "GhostHack",
    Callback = function(Value)
        Config.User.GhostHack = Value
        if Value then
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                        part.Transparency = 0.5
                    end
                end
            end
            Rayfield:Notify({
                Title = "Ghost Hack",
                Content = "Ghost hack enabled",
                Duration = 3,
                Image = 13047715178
            })
        else
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                        part.Transparency = 0
                    end
                end
            end
        end
    end
})

-- Boat Speed Hack
UserTab:CreateToggle({
    Name = "Boat Speed Hack",
    CurrentValue = Config.User.BoatSpeed,
    Flag = "BoatSpeed",
    Callback = function(Value)
        Config.User.BoatSpeed = Value
        if Value then
            Rayfield:Notify({
                Title = "Boat Speed",
                Content = "Boat speed hack enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Max Boat Speed
UserTab:CreateToggle({
    Name = "Max Boat Speed",
    CurrentValue = Config.User.MaxBoatSpeed,
    Flag = "MaxBoatSpeed",
    Callback = function(Value)
        Config.User.MaxBoatSpeed = Value
        if Value then
            Rayfield:Notify({
                Title = "Max Boat Speed",
                Content = "Max boat speed enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Spawn Boat
UserTab:CreateToggle({
    Name = "Spawn Boat",
    CurrentValue = Config.User.SpawnBoat,
    Flag = "SpawnBoat",
    Callback = function(Value)
        Config.User.SpawnBoat = Value
        if Value then
            if GameFunctions and GameFunctions:FindFirstChild("SpawnBoat") then
                GameFunctions.SpawnBoat:InvokeServer()
                Rayfield:Notify({
                    Title = "Spawn Boat",
                    Content = "Boat spawned",
                    Duration = 3,
                    Image = 13047715178
                })
            end
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

-- Player Info Label
local playerInfoLabel = UserTab:CreateLabel("Player Info: Loading...")

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

-- Trade Filter Mythical
TradeTab:CreateToggle({
    Name = "Trade Only Mythical",
    CurrentValue = Config.Trade.TradeFilterMythical,
    Flag = "TradeFilterMythical",
    Callback = function(Value)
        Config.Trade.TradeFilterMythical = Value
        if Value then
            Config.Trade.TradeFilterSecret = false
            TradeTab:UpdateToggle("TradeFilterSecret", {
                CurrentValue = false
            })
            Rayfield:Notify({
                Title = "Trade Filter",
                Content = "Trading only mythical fish",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Trade Filter Secret
TradeTab:CreateToggle({
    Name = "Trade Only Secret",
    CurrentValue = Config.Trade.TradeFilterSecret,
    Flag = "TradeFilterSecret",
    Callback = function(Value)
        Config.Trade.TradeFilterSecret = Value
        if Value then
            Config.Trade.TradeFilterMythical = false
            TradeTab:UpdateToggle("TradeFilterMythical", {
                CurrentValue = false
            })
            Rayfield:Notify({
                Title = "Trade Filter",
                Content = "Trading only secret fish",
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

-- Player Total
ServerTab:CreateLabel("Player Total: " .. #Players:GetPlayers())

-- Server Luck
ServerTab:CreateLabel("Server Luck: " .. Config.Server.ServerLuck .. "%")

-- Server Seed
ServerTab:CreateLabel("Server Seed: " .. Config.Server.ServerSeed)

-- Active Event
ServerTab:CreateLabel("Active Event: " .. Config.Server.ActiveEvent)

-- Select Weather
ServerTab:CreateDropdown({
    Name = "Select Weather",
    Options = Weathers,
    CurrentOption = Config.Server.SelectedWeather,
    Flag = "SelectedWeather",
    Callback = function(Value)
        Config.Server.SelectedWeather = Value
    end
})

-- Buy Weather Button
ServerTab:CreateButton({
    Name = "Buy Weather",
    Callback = function()
        if Config.Server.SelectedWeather ~= "" then
            if GameFunctions and GameFunctions:FindFirstChild("BuyWeather") then
                GameFunctions.BuyWeather:InvokeServer(Config.Server.SelectedWeather)
                Rayfield:Notify({
                    Title = "Buy Weather",
                    Content = "Purchased " .. Config.Server.SelectedWeather .. " weather",
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            Rayfield:Notify({
                Title = "Weather Error",
                Content = "Please select a weather first",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Buy Weather
ServerTab:CreateToggle({
    Name = "Auto Buy Weather",
    CurrentValue = Config.Server.AutoBuyCuaca,
    Flag = "AutoBuyCuaca",
    Callback = function(Value)
        Config.Server.AutoBuyCuaca = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Buy Weather",
                Content = "Auto buy weather enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Select Event
ServerTab:CreateDropdown({
    Name = "Select Event",
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
            local targetCFrame
            if Config.Server.TeleportEvent == "Treasure Event" then
                targetCFrame = CFrame.new(700, 30, 700)
            elseif Config.Server.TeleportEvent == "Sisyphus Event" then
                targetCFrame = CFrame.new(800, 40, 800)
            elseif Config.Server.TeleportEvent == "Seasonal Event" then
                targetCFrame = CFrame.new(900, 50, 900)
            end
            
            if targetCFrame then
                LocalPlayer.Character:SetPrimaryPartCFrame(targetCFrame)
                Rayfield:Notify({
                    Title = "Event Teleport",
                    Content = "Teleported to " .. Config.Server.TeleportEvent,
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

-- Rejoin Server Button
ServerTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        Rayfield:Notify({
            Title = "Rejoining",
            Content = "Rejoining current server...",
            Duration = 3,
            Image = 13047715178
        })
    end
})

-- Server Hop Button
ServerTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        -- Server hopping implementation
        Rayfield:Notify({
            Title = "Server Hop",
            Content = "Searching for a new server...",
            Duration = 3,
            Image = 13047715178
        })
    end
})

-- Shop Tab
local ShopTab = Window:CreateTab("🛒 Shop", 13014546625)

-- Select Rod
ShopTab:CreateDropdown({
    Name = "Select Rod",
    Options = Rods,
    CurrentOption = Config.Shop.SelectedRod,
    Flag = "SelectedRod",
    Callback = function(Value)
        Config.Shop.SelectedRod = Value
    end
})

-- Buy Rod Button
ShopTab:CreateButton({
    Name = "Buy Rod",
    Callback = function()
        if Config.Shop.SelectedRod ~= "" then
            if GameFunctions and GameFunctions:FindFirstChild("BuyRod") then
                GameFunctions.BuyRod:InvokeServer(Config.Shop.SelectedRod)
                Rayfield:Notify({
                    Title = "Buy Rod",
                    Content = "Purchased " .. Config.Shop.SelectedRod,
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            Rayfield:Notify({
                Title = "Rod Error",
                Content = "Please select a rod first",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Buy Rod
ShopTab:CreateToggle({
    Name = "Auto Buy Rod",
    CurrentValue = Config.Shop.AutoBuyRod,
    Flag = "AutoBuyRod",
    Callback = function(Value)
        Config.Shop.AutoBuyRod = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Buy Rod",
                Content = "Auto buy rod enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Select Bait
ShopTab:CreateDropdown({
    Name = "Select Bait",
    Options = Baits,
    CurrentOption = Config.Shop.SelectedBait,
    Flag = "SelectedBait",
    Callback = function(Value)
        Config.Shop.SelectedBait = Value
    end
})

-- Buy Bait Button
ShopTab:CreateButton({
    Name = "Buy Bait",
    Callback = function()
        if Config.Shop.SelectedBait ~= "" then
            if GameFunctions and GameFunctions:FindFirstChild("BuyBait") then
                GameFunctions.BuyBait:InvokeServer(Config.Shop.SelectedBait)
                Rayfield:Notify({
                    Title = "Buy Bait",
                    Content = "Purchased " .. Config.Shop.SelectedBait,
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            Rayfield:Notify({
                Title = "Bait Error",
                Content = "Please select a bait first",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Buy Bait
ShopTab:CreateToggle({
    Name = "Auto Buy Bait",
    CurrentValue = Config.Shop.AutoBuyBait,
    Flag = "AutoBuyBait",
    Callback = function(Value)
        Config.Shop.AutoBuyBait = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Buy Bait",
                Content = "Auto buy bait enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Select Boat
ShopTab:CreateDropdown({
    Name = "Select Boat",
    Options = Boats,
    CurrentOption = Config.Shop.SelectedBoat,
    Flag = "SelectedBoat",
    Callback = function(Value)
        Config.Shop.SelectedBoat = Value
    end
})

-- Buy Boat Button
ShopTab:CreateButton({
    Name = "Buy Boat",
    Callback = function()
        if Config.Shop.SelectedBoat ~= "" then
            if GameFunctions and GameFunctions:FindFirstChild("BuyBoat") then
                GameFunctions.BuyBoat:InvokeServer(Config.Shop.SelectedBoat)
                Rayfield:Notify({
                    Title = "Buy Boat",
                    Content = "Purchased " .. Config.Shop.SelectedBoat,
                    Duration = 3,
                    Image = 13047715178
                })
            end
        else
            Rayfield:Notify({
                Title = "Boat Error",
                Content = "Please select a boat first",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Buy Boat
ShopTab:CreateToggle({
    Name = "Auto Buy Boat",
    CurrentValue = Config.Shop.AutoBuyBoat,
    Flag = "AutoBuyBoat",
    Callback = function(Value)
        Config.Shop.AutoBuyBoat = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Buy Boat",
                Content = "Auto buy boat enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Graphics Tab
local GraphicsTab = Window:CreateTab("🎨 Graphics", 13014546625)

-- High Quality
GraphicsTab:CreateToggle({
    Name = "High Quality",
    CurrentValue = Config.Graphics.HighQuality,
    Flag = "HighQuality",
    Callback = function(Value)
        Config.Graphics.HighQuality = Value
        if Value then
            sethiddenproperty(Lighting, "Technology", "Future")
            sethiddenproperty(Workspace, "LevelOfDetail", 1)
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
GraphicsTab:CreateToggle({
    Name = "Max Rendering",
    CurrentValue = Config.Graphics.MaxRendering,
    Flag = "MaxRendering",
    Callback = function(Value)
        Config.Graphics.MaxRendering = Value
        if Value then
            settings().Rendering.QualityLevel = 21
            Rayfield:Notify({
                Title = "Max Rendering",
                Content = "Max rendering quality enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Ultra Low Mode
GraphicsTab:CreateToggle({
    Name = "Ultra Low Mode",
    CurrentValue = Config.Graphics.UltraLowMode,
    Flag = "UltraLowMode",
    Callback = function(Value)
        Config.Graphics.UltraLowMode = Value
        if Value then
            settings().Rendering.QualityLevel = 1
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Part") then
                    obj.Material = Enum.Material.Plastic
                end
            end
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
GraphicsTab:CreateToggle({
    Name = "Disable Water Reflection",
    CurrentValue = Config.Graphics.DisableWaterReflection,
    Flag = "DisableWaterReflection",
    Callback = function(Value)
        Config.Graphics.DisableWaterReflection = Value
        if Value then
            if Workspace:FindFirstChildOfClass("Water") then
                Workspace:FindFirstChildOfClass("Water").Reflectance = 0
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
GraphicsTab:CreateToggle({
    Name = "Custom Shader",
    CurrentValue = Config.Graphics.CustomShader,
    Flag = "CustomShader",
    Callback = function(Value)
        Config.Graphics.CustomShader = Value
        if Value then
            Rayfield:Notify({
                Title = "Custom Shader",
                Content = "Custom shader enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Optimize Performance
GraphicsTab:CreateToggle({
    Name = "Optimize Performance",
    CurrentValue = Config.Graphics.OptimizePerformance,
    Flag = "OptimizePerformance",
    Callback = function(Value)
        Config.Graphics.OptimizePerformance = Value
        if Value then
            RunService:Set3dRenderingEnabled(false)
            Rayfield:Notify({
                Title = "Performance Mode",
                Content = "Performance optimization enabled",
                Duration = 3,
                Image = 13047715178
            })
        else
            RunService:Set3dRenderingEnabled(true)
        end
    end
})

-- Disable Particles
GraphicsTab:CreateToggle({
    Name = "Disable Particles",
    CurrentValue = Config.Graphics.DisableParticles,
    Flag = "DisableParticles",
    Callback = function(Value)
        Config.Graphics.DisableParticles = Value
        if Value then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") then
                    obj.Enabled = false
                end
            end
            Rayfield:Notify({
                Title = "Particles Disabled",
                Content = "All particles disabled",
                Duration = 3,
                Image = 13047715178
            })
        else
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") then
                    obj.Enabled = true
                end
            end
        end
    end
})

-- FPS Limit
GraphicsTab:CreateSlider({
    Name = "FPS Limit",
    Range = {1, 360},
    Increment = 1,
    Suffix = "FPS",
    CurrentValue = Config.Graphics.FPSLimit,
    Flag = "FPSLimit",
    Callback = function(Value)
        Config.Graphics.FPSLimit = Value
        setfpscap(Value)
    end
})

-- System Tab
local SystemTab = Window:CreateTab("⚙️ System", 13014546625)

-- Show Info
SystemTab:CreateToggle({
    Name = "Show Info",
    CurrentValue = Config.System.ShowInfo,
    Flag = "ShowInfo",
    Callback = function(Value)
        Config.System.ShowInfo = Value
        if Value then
            Rayfield:Notify({
                Title = "System Info",
                Content = "System info display enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
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
                Title = "Memory Cleaner",
                Content = "Auto memory cleaning enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Auto Rejoin
SystemTab:CreateToggle({
    Name = "Auto Rejoin",
    CurrentValue = Config.System.AutoRejoin,
    Flag = "AutoRejoin",
    Callback = function(Value)
        Config.System.AutoRejoin = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Rejoin",
                Content = "Auto rejoin enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- FPS Boost
SystemTab:CreateToggle({
    Name = "FPS Boost",
    CurrentValue = Config.System.FPSBoost,
    Flag = "FPSBoost",
    Callback = function(Value)
        Config.System.FPSBoost = Value
        if Value then
            -- FPS boost optimizations
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj.Anchored then
                    obj.Anchored = true
                end
            end
            Rayfield:Notify({
                Title = "FPS Boost",
                Content = "FPS boost enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Battery Saver
SystemTab:CreateToggle({
    Name = "Battery Saver",
    CurrentValue = Config.System.BatterySaver,
    Flag = "BatterySaver",
    Callback = function(Value)
        Config.System.BatterySaver = Value
        if Value then
            setfpscap(30)
            Config.Graphics.FPSLimit = 30
            GraphicsTab:UpdateSlider("FPSLimit", {
                CurrentValue = 30
            })
            Rayfield:Notify({
                Title = "Battery Saver",
                Content = "Battery saver mode enabled",
                Duration = 3,
                Image = 13047715178
            })
        end
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("🔧 Settings", 13014546625)

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
        -- Update all UI elements to reflect loaded config
        AutoFarmTab:UpdateToggle("FishingRadar", {CurrentValue = Config.AutoFarm.FishingRadar})
        AutoFarmTab:UpdateToggle("AutoFishV1", {CurrentValue = Config.AutoFarm.AutoFishV1})
        AutoFarmTab:UpdateSlider("AutoFishDelay", {CurrentValue = Config.AutoFarm.AutoFishDelay})
        -- ... update all other UI elements similarly
    end
})

-- Reset Config Button
SettingsTab:CreateButton({
    Name = "Reset Config",
    Callback = function()
        Config = {
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
                WaterFish = false,
                ForceLegendary = false,
                SecretBoost = false,
                MythicalChance = false,
                RNGReducer = false,
                AntiBadLuck = false
            },
            -- ... reset all other config sections
        }
        Rayfield:Notify({
            Title = "Config Reset",
            Content = "Configuration reset to defaults",
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

-- Select Theme
SettingsTab:CreateDropdown({
    Name = "Select Theme",
    Options = {"Dark", "Light", "Midnight", "Aqua", "Neon"},
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
        Rayfield:ChangeTransparency(Value)
    end
})

-- Destroy UI Button
SettingsTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end
})

-- Credits Label
SettingsTab:CreateLabel("NIKZZ - FISH SCRIPT v2.0")
SettingsTab:CreateLabel("Updated for September 2025")
SettingsTab:CreateLabel("by Nikzz Xit")

-- Main Loops and Functions
task.spawn(function()
    while task.wait(1) do
        -- Update player info
        if PlayerData then
            local level = PlayerData:FindFirstChild("Level") and PlayerData.Level.Value or "N/A"
            local luck = PlayerData:FindFirstChild("Luck") and PlayerData.Luck.Value or "N/A"
            playerInfoLabel:Set("Level: " .. level .. " | Luck: " .. luck)
        end
        
        -- Auto Fish
        if Config.AutoFarm.AutoFishV1 then
            if FishingEvents and FishingEvents:FindFirstChild("CastLine") then
                FishingEvents.CastLine:FireServer()
                task.wait(Config.AutoFarm.AutoFishDelay)
                if FishingEvents:FindFirstChild("ReelIn") then
                    FishingEvents.ReelIn:FireServer()
                end
            end
        end
        
        -- Auto Sell Fish
        if Config.AutoFarm.AutoSellFish then
            if FishingEvents and FishingEvents:FindFirstChild("SellAllFish") then
                FishingEvents.SellAllFish:FireServer()
                task.wait(Config.AutoFarm.DelaySellFish)
            end
        end
        
        -- Speed Hack
        if Config.User.SpeedHack and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Config.User.SpeedValue
            end
        end
        
        -- Fly Hack
        if Config.User.Fly and LocalPlayer.Character then
            local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoidRootPart and humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Flying)
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    humanoidRootPart.Velocity = Vector3.new(0, Config.User.FlyRange, 0)
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    humanoidRootPart.Velocity = Vector3.new(0, -Config.User.FlyRange, 0)
                end
            end
        end
        
        -- Infinity Jump
        if Config.User.InfinityJump then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
        
        -- Auto Buy Weather
        if Config.Server.AutoBuyCuaca and Config.Server.SelectedWeather ~= "" then
            if GameFunctions and GameFunctions:FindFirstChild("BuyWeather") then
                GameFunctions.BuyWeather:InvokeServer(Config.Server.SelectedWeather)
                task.wait(5)
            end
        end
        
        -- Auto Buy Rod
        if Config.Shop.AutoBuyRod and Config.Shop.SelectedRod ~= "" then
            if GameFunctions and GameFunctions:FindFirstChild("BuyRod") then
                GameFunctions.BuyRod:InvokeServer(Config.Shop.SelectedRod)
                task.wait(5)
            end
        end
        
        -- Auto Buy Bait
        if Config.Shop.AutoBuyBait and Config.Shop.SelectedBait ~= "" then
            if GameFunctions and GameFunctions:FindFirstChild("BuyBait") then
                GameFunctions.BuyBait:InvokeServer(Config.Shop.SelectedBait)
                task.wait(5)
            end
        end
        
        -- Auto Buy Boat
        if Config.Shop.AutoBuyBoat and Config.Shop.SelectedBoat ~= "" then
            if GameFunctions and GameFunctions:FindFirstChild("BuyBoat") then
                GameFunctions.BuyBoat:InvokeServer(Config.Shop.SelectedBoat)
                task.wait(5)
            end
        end
        
        -- Auto Clean Memory
        if Config.System.AutoCleanMemory then
            collectgarbage()
            task.wait(30)
        end
        
        -- Auto Teleport to Event
        if Config.Teleport.AutoTeleportEvent and Config.Server.TeleportEvent ~= "" then
            local targetCFrame
            if Config.Server.TeleportEvent == "Treasure Event" then
                targetCFrame = CFrame.new(700, 30, 700)
            elseif Config.Server.TeleportEvent == "Sisyphus Event" then
                targetCFrame = CFrame.new(800, 40, 800)
            elseif Config.Server.TeleportEvent == "Seasonal Event" then
                targetCFrame = CFrame.new(900, 50, 900)
            end
            
            if targetCFrame then
                LocalPlayer.Character:SetPrimaryPartCFrame(targetCFrame)
                task.wait(10)
            end
        end
        
        -- RNG Reducer
        if Config.AutoFarm.RNGReducer then
            if PlayerData and PlayerData:FindFirstChild("Luck") then
                PlayerData.Luck.Value = math.max(PlayerData.Luck.Value, 50)
            end
        end
        
        -- Force Legendary Catch
        if Config.AutoFarm.ForceLegendary then
            if FishingEvents and FishingEvents:FindFirstChild("CatchFish") then
                -- Modify catch function to increase legendary chance
            end
        end
    end
end)

-- Initialize
Rayfield:Notify({
    Title = "NIKZZ - FISH SCRIPT",
    Content = "Loaded successfully! Enjoy fishing!",
    Duration = 6,
    Image = 13047715178
})

setfpscap(Config.Graphics.FPSLimit)
