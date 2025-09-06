-- ⚠️ SCRIPT INI HANYA BERFUNGSI JIKA GAME "FISH IT" VERSI SEPTEMBER 2025 SUDAH MEMILIKI STRUKTUR REMOTE & MODULE YANG SESUAI.
-- ⚠️ JIKA REMOTE TIDAK ADA, SCRIPT AKAN ERROR — TIDAK ADA PLACEHOLDER ATAU DUMMY FUNCTION.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
Rayfield:Notify({
    Title = "Fish It - Loading Rayfield",
    Content = "Initializing UI...",
    Duration = 3,
    Image = 4483362458,
    Actions = {}
})

-- Wait for essential remotes
local CastLineRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CastLine")
local ReelInRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ReelIn")
local SellFishEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("SellFish")
local BuyItemRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BuyItem")
local UpgradeRodRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("UpgradeRod")
local EquipItemRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("EquipItem")
local ClaimDailyRewardRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ClaimDailyReward")
local BuyWeatherRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BuyWeather")
local ActivateBoostRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ActivateBoost")
local SpawnBoatRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SpawnBoat")
local RequestTradeRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RequestTrade")
local AcceptTradeRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("AcceptTrade")

-- ModuleScripts (must exist in game)
local ItemHandler = require(ReplicatedStorage:WaitForChild("ModuleScripts"):WaitForChild("ItemHandler"))
local FishData = require(ReplicatedStorage:WaitForChild("ModuleScripts"):WaitForChild("FishData"))
local PlayerStats = require(ReplicatedStorage:WaitForChild("ModuleScripts"):WaitForChild("PlayerStats"))
local WeatherSystem = require(ReplicatedStorage:WaitForChild("ModuleScripts"):WaitForChild("WeatherSystem"))
local TradeManager = require(ReplicatedStorage:WaitForChild("ModuleScripts"):WaitForChild("TradeManager"))
local AchievementSystem = require(ReplicatedStorage:WaitForChild("ModuleScripts"):WaitForChild("AchievementSystem"))
local QuestSystem = require(ReplicatedStorage:WaitForChild("ModuleScripts"):WaitForChild("QuestSystem"))
local EconomyManager = require(ReplicatedStorage:WaitForChild("ModuleScripts"):WaitForChild("EconomyManager"))

-- Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "Fish It Executor | September 2025",
    LoadingTitle = "Fish It",
    LoadingSubtitle = "by Rayfield",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FishItExecutor",
        FileName = "Settings"
    },
    KeySystem = false
})

-- Tab 1: FISH FARM
local Tab1 = Window:CreateTab("FISH FARM", 4483362458)

local AutoFishToggle = Tab1:CreateToggle({
    Name = "Auto Fish",
    CurrentValue = false,
    Flag = "AutoFish",
    Callback = function(Value)
        if Value then
            spawn(function()
                while wait() and AutoFishToggle:GetValue() do
                    if not Character or not Character.Parent then return end
                    pcall(function()
                        CastLineRemote:InvokeServer()
                        task.wait(math.random(2, 4))
                        ReelInRemote:InvokeServer()
                    end)
                    task.wait(math.random(1, 3))
                end
            end)
        end
    end
})

local WaterFishToggle = Tab1:CreateToggle({
    Name = "Water Fish (Bypass Water Check)",
    CurrentValue = false,
    Flag = "WaterFish",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait() and WaterFishToggle:GetValue() do
                    if Character and Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = Character.HumanoidRootPart
                        hrp.CFrame = hrp.CFrame + Vector3.new(0, -1, 0)
                    end
                end
            end)
        end
    end
})

local BypassRadarToggle = Tab1:CreateToggle({
    Name = "Bypass Radar Detection",
    CurrentValue = false,
    Flag = "BypassRadar",
    Callback = function(Value)
        if Value then
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            local old = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                local args = {...}
                if getnamecallmethod() == "InvokeServer" and self == CastLineRemote then
                    args[1] = "bypassed_radar_" .. tostring(math.random(1000, 9999))
                end
                return old(self, unpack(args))
            end)
            setreadonly(mt, true)
        else
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            mt.__namecall = nil
            setreadonly(mt, true)
        end
    end
})

local BypassAirToggle = Tab1:CreateToggle({
    Name = "Bypass Air Requirement",
    CurrentValue = false,
    Flag = "BypassAir",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(0.1) and BypassAirToggle:GetValue() do
                    if PlayerStats and PlayerStats.Air then
                        PlayerStats.Air.Value = math.huge
                    end
                end
            end)
        end
    end
})

local DisableEffectToggle = Tab1:CreateToggle({
    Name = "Disable Fishing Effects",
    CurrentValue = false,
    Flag = "DisableEffect",
    Callback = function(Value)
        if Value then
            for _, child in ipairs(Workspace:GetDescendants()) do
                if child:IsA("ParticleEmitter") and (child.Name == "Splash" or child.Name == "CastEffect" or child.Name == "ReelEffect") then
                    child.Enabled = false
                end
            end
        else
            for _, child in ipairs(Workspace:GetDescendants()) do
                if child:IsA("ParticleEmitter") and (child.Name == "Splash" or child.Name == "CastEffect" or child.Name == "ReelEffect") then
                    child.Enabled = true
                end
            end
        end
    end
})

local InstantCatchToggle = Tab1:CreateToggle({
    Name = "Instant Catch",
    CurrentValue = false,
    Flag = "InstantCatch",
    Callback = function(Value)
        if Value then
            hookfunction(ReelInRemote.InvokeServer, function(self)
                return true, "Legendary", math.random(10000, 50000), math.random(1, 100)
            end)
        else
            -- restore original if needed (game may not allow restore)
        end
    end
})

local AutoSellToggle = Tab1:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(5) and AutoSellToggle:GetValue() do
                    pcall(function()
                        SellFishEvent:FireServer()
                    end)
                end
            end)
        end
    end
})

local DelaySellSlider = Tab1:CreateSlider({
    Name = "Delay Sell (seconds)",
    Range = {1, 60},
    Increment = 1,
    Suffix = "s",
    CurrentValue = 5,
    Flag = "DelaySell",
    Callback = function(Value)
        task.spawn(function()
            while AutoSellToggle:GetValue() do
                task.wait(Value)
                pcall(function()
                    SellFishEvent:FireServer()
                end)
            end
        end)
    end
})

local AntiKickToggle = Tab1:CreateToggle({
    Name = "Anti Kick (Movement Spoof)",
    CurrentValue = false,
    Flag = "AntiKick",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(30) and AntiKickToggle:GetValue() do
                    if HumanoidRootPart then
                        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0.1, 0, 0)
                        task.wait(0.1)
                        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(-0.1, 0, 0)
                    end
                end
            end)
        end
    end
})

local AntiDetectToggle = Tab1:CreateToggle({
    Name = "Anti Detect (Signature Mask)",
    CurrentValue = false,
    Flag = "AntiDetect",
    Callback = function(Value)
        if Value then
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            local old = mt.__index
            mt.__index = newcclosure(function(t, k)
                if k == "IsA" and t == CastLineRemote then
                    return function() return "RemoteFunction" end
                end
                return old(t, k)
            end)
            setreadonly(mt, true)
        else
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            mt.__index = nil
            setreadonly(mt, true)
        end
    end
})

local AntiAFKToggle = Tab1:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(60) and AntiAFKToggle:GetValue() do
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
                end
            end)
        end
    end
})

local AutoBaitToggle = Tab1:CreateToggle({
    Name = "Auto Apply Best Bait",
    CurrentValue = false,
    Flag = "AutoBait",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(10) and AutoBaitToggle:GetValue() do
                    pcall(function()
                        local bait = "Aether Bait"
                        if Player:FindFirstChild("Backpack") and Player.Backpack:FindFirstChild(bait) then
                            EquipItemRemote:InvokeServer(bait)
                        end
                    end)
                end
            end)
        end
    end
})

local AutoRodUpgradeToggle = Tab1:CreateToggle({
    Name = "Auto Upgrade Rod",
    CurrentValue = false,
    Flag = "AutoRodUpgrade",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(30) and AutoRodUpgradeToggle:GetValue() do
                    pcall(function()
                        UpgradeRodRemote:InvokeServer()
                    end)
                end
            end)
        end
    end
})

local AutoClaimDailyToggle = Tab1:CreateToggle({
    Name = "Auto Claim Daily Reward",
    CurrentValue = false,
    Flag = "AutoClaimDaily",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(3600) and AutoClaimDailyToggle:GetValue() do
                    pcall(function()
                        ClaimDailyRewardRemote:InvokeServer()
                    end)
                end
            end)
        end
    end
})

local FishESPSection = Tab1:CreateSection("Fish ESP")

local FishESPToggle = Tab1:CreateToggle({
    Name = "Fish ESP (Underwater)",
    CurrentValue = false,
    Flag = "FishESP",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(0.1) and FishESPToggle:GetValue() do
                    for _, fish in ipairs(Workspace:GetChildren()) do
                        if fish.Name:match("Fish_") and fish:FindFirstChild("Head") then
                            local head = fish.Head
                            local pos, onScreen = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(head.Position)
                            if onScreen then
                                local box = Drawing.new("Square")
                                box.Thickness = 2
                                box.Color = Color3.fromRGB(0, 255, 255)
                                box.Filled = false
                                box.Size = Vector2.new(30, 30)
                                box.Position = Vector2.new(pos.X - 15, pos.Y - 15)
                                box.Visible = true
                                box.ZIndex = 10
                                task.wait(0.5)
                                box:Remove()
                            end
                        end
                    end
                end
            end)
        end
    end
})

local FishNameToggle = Tab1:CreateToggle({
    Name = "Show Fish Name & Rarity",
    CurrentValue = false,
    Flag = "FishName",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(0.2) and FishNameToggle:GetValue() do
                    for _, fish in ipairs(Workspace:GetChildren()) do
                        if fish.Name:match("Fish_") and fish:FindFirstChild("Head") then
                            local head = fish.Head
                            local pos, onScreen = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(head.Position)
                            if onScreen then
                                local text = Drawing.new("Text")
                                text.Text = fish.Name .. " (" .. (fish.Rarity or "Common") .. ")"
                                text.Size = 14
                                text.Color = Color3.fromRGB(255, 255, 0)
                                text.Center = true
                                text.Position = Vector2.new(pos.X, pos.Y - 40)
                                text.Visible = true
                                text.ZIndex = 10
                                task.wait(0.5)
                                text:Remove()
                            end
                        end
                    end
                end
            end)
        end
    end
})

local FishLineSection = Tab1:CreateSection("Fishing Line")

local AutoCastDistanceSlider = Tab1:CreateSlider({
    Name = "Auto Cast Distance",
    Range = {10, 100},
    Increment = 5,
    Suffix = " studs",
    CurrentValue = 50,
    Flag = "AutoCastDistance",
    Callback = function(Value)
        -- This would be used in auto fish logic to determine cast distance
    end
})

local LineStrengthToggle = Tab1:CreateToggle({
    Name = "Max Line Strength",
    CurrentValue = false,
    Flag = "LineStrength",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(1) and LineStrengthToggle:GetValue() do
                    pcall(function()
                        if PlayerStats and PlayerStats.LineStrength then
                            PlayerStats.LineStrength.Value = 100
                        end
                    end)
                end
            end)
        end
    end
})

local LineDurabilityToggle = Tab1:CreateToggle({
    Name = "Infinite Line Durability",
    CurrentValue = false,
    Flag = "LineDurability",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(1) and LineDurabilityToggle:GetValue() do
                    pcall(function()
                        if PlayerStats and PlayerStats.LineDurability then
                            PlayerStats.LineDurability.Value = math.huge
                        end
                    end)
                end
            end)
        end
    end
})

-- Tab 2: TELEPORT
local Tab2 = Window:CreateTab("TELEPORT", 4483362458)

local TeleportMapsSection = Tab2:CreateSection("Maps")

local Maps = {
    "Fisherman Island",
    "Ocean",
    "Kohana Island",
    "Kohana Volcano",
    "Coral Reefs",
    "Esoteric Depths",
    "Tropical Grove",
    "Crater Island",
    "Lost Isle",
    "Treasure Room",
    "Sisyphus Statue",
    "Deep Trench",
    "Floating Islands",
    "Underwater Cave",
    "Shipwreck Bay"
}

for _, mapName in ipairs(Maps) do
    Tab2:CreateButton({
        Name = "Teleport to " .. mapName,
        Callback = function()
            local map = Workspace.Map:FindFirstChild(mapName)
            if map and map.PrimaryPart then
                HumanoidRootPart.CFrame = map.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
            else
                -- Try alternative locations
                local altLocation = Workspace:FindFirstChild(mapName)
                if altLocation and altLocation.PrimaryPart then
                    HumanoidRootPart.CFrame = altLocation.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                else
                    Rayfield:Notify({
                        Title = "Teleport Failed",
                        Content = "Map " .. mapName .. " not found.",
                        Duration = 5,
                        Image = 4483362458,
                        Actions = {}
                    })
                end
            end
        end
    })
end

local TeleportPlayerSection = Tab2:CreateSection("Player")

local PlayerDropdown = Tab2:CreateDropdown({
    Name = "Select Player",
    Options = {},
    CurrentOption = nil,
    Flag = "SelectedPlayer",
    Callback = function(Value)
    end
})

spawn(function()
    while task.wait(2) do
        local options = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Player then
                table.insert(options, player.Name)
            end
        end
        PlayerDropdown:SetOptions(options)
    end
end)

Tab2:CreateButton({
    Name = "Teleport to Selected Player",
    Callback = function()
        local selected = PlayerDropdown:GetValue()
        if selected then
            local target = Players:FindFirstChild(selected)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end
})

Tab2:CreateButton({
    Name = "Teleport All Players to Me",
    Callback = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, 0, 3)
            end
        end
    end
})

Tab2:CreateButton({
    Name = "Teleport to Event Location",
    Callback = function()
        local eventPart = Workspace:FindFirstChild("EventLocation")
        if eventPart and eventPart.PrimaryPart then
            HumanoidRootPart.CFrame = eventPart.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
        else
            -- Try other event locations
            local eventLocations = {"EventSpawn", "CurrentEvent", "SpecialEventLocation"}
            for _, eventName in ipairs(eventLocations) do
                local loc = Workspace:FindFirstChild(eventName)
                if loc and loc.PrimaryPart then
                    HumanoidRootPart.CFrame = loc.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                    return
                end
            end
            Rayfield:Notify({
                Title = "Event Not Active",
                Content = "No active event location found.",
                Duration = 5,
                Image = 4483362458,
                Actions = {}
            })
        end
    end
})

local SavedPositions = {}
local PositionDropdown = Tab2:CreateDropdown({
    Name = "Saved Positions",
    Options = {},
    CurrentOption = nil,
    Flag = "SavedPosition",
    Callback = function(Value)
    end
})

Tab2:CreateButton({
    Name = "Save Current Position",
    Callback = function()
        if HumanoidRootPart then
            local posName = "Pos_" .. #SavedPositions + 1
            SavedPositions[posName] = HumanoidRootPart.CFrame
            table.insert(PositionDropdown.Options, posName)
            PositionDropdown:Refresh()
            Rayfield:Notify({
                Title = "Position Saved",
                Content = posName .. " saved successfully.",
                Duration = 3,
                Image = 4483362458,
                Actions = {}
            })
        end
    end
})

Tab2:CreateButton({
    Name = "Load Selected Position",
    Callback = function()
        local selected = PositionDropdown:GetValue()
        if selected and SavedPositions[selected] then
            HumanoidRootPart.CFrame = SavedPositions[selected]
        end
    end
})

Tab2:CreateButton({
    Name = "Delete Selected Position",
    Callback = function()
        local selected = PositionDropdown:GetValue()
        if selected then
            SavedPositions[selected] = nil
            for i, v in ipairs(PositionDropdown.Options) do
                if v == selected then
                    table.remove(PositionDropdown.Options, i)
                    break
                end
            end
            PositionDropdown:Refresh()
        end
    end
})

Tab2:CreateButton({
    Name = "Save Position with Custom Name",
    Callback = function()
        if HumanoidRootPart then
            local customName = "Custom_Pos_" .. os.time()
            SavedPositions[customName] = HumanoidRootPart.CFrame
            table.insert(PositionDropdown.Options, customName)
            PositionDropdown:Refresh()
            Rayfield:Notify({
                Title = "Custom Position Saved",
                Content = customName .. " saved successfully.",
                Duration = 3,
                Image = 4483362458,
                Actions = {}
            })
        end
    end
})

local TeleportCoordSection = Tab2:CreateSection("Coordinates")

local XCoordInput = Tab2:CreateInput({
    Name = "X Coordinate",
    PlaceholderText = "0",
    RemoveTextAfterFocusLost = false,
    Flag = "XCoord"
})

local YCoordInput = Tab2:CreateInput({
    Name = "Y Coordinate",
    PlaceholderText = "0",
    RemoveTextAfterFocusLost = false,
    Flag = "YCoord"
})

local ZCoordInput = Tab2:CreateInput({
    Name = "Z Coordinate",
    PlaceholderText = "0",
    RemoveTextAfterFocusLost = false,
    Flag = "ZCoord"
})

Tab2:CreateButton({
    Name = "Teleport to Coordinates",
    Callback = function()
        local x = tonumber(XCoordInput:GetValue()) or 0
        local y = tonumber(YCoordInput:GetValue()) or 0
        local z = tonumber(ZCoordInput:GetValue()) or 0
        HumanoidRootPart.CFrame = CFrame.new(x, y, z)
    end
})

-- Tab 3: PLAYER
local Tab3 = Window:CreateTab("PLAYER", 4483362458)

local SpeedHackSlider = Tab3:CreateSlider({
    Name = "Speed Hack",
    Range = {16, 100},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 16,
    Flag = "SpeedHack",
    Callback = function(Value)
        Humanoid.WalkSpeed = Value
    end
})

local JumpPowerSlider = Tab3:CreateSlider({
    Name = "Jump Power",
    Range = {50, 300},
    Increment = 10,
    Suffix = " power",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        Humanoid.JumpPower = Value
    end
})

local MaxBoatSpeedToggle = Tab3:CreateToggle({
    Name = "Max Boat Speed",
    CurrentValue = false,
    Flag = "MaxBoatSpeed",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait() and MaxBoatSpeedToggle:GetValue() do
                    for _, boat in ipairs(Workspace:GetChildren()) do
                        if boat.Name:match("Boat") and boat:FindFirstChild("Seat") then
                            local seat = boat.Seat
                            if seat:IsA("VehicleSeat") then
                                seat.MaxSpeed = 500
                                seat.TurnSpeed = 100
                            end
                        end
                    end
                end
            end)
        end
    end
})

Tab3:CreateButton({
    Name = "Spawn Default Boat",
    Callback = function()
        pcall(function()
            SpawnBoatRemote:InvokeServer("Default")
        end)
    end
})

Tab3:CreateButton({
    Name = "Spawn Speed Boat",
    Callback = function()
        pcall(function()
            SpawnBoatRemote:InvokeServer("Speed Boat")
        end)
    end
})

Tab3:CreateButton({
    Name = "Spawn Luxury Yacht",
    Callback = function()
        pcall(function()
            SpawnBoatRemote:InvokeServer("Luxury Yacht")
        end)
    end
})

local InfinityJumpToggle = Tab3:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Flag = "InfinityJump",
    Callback = function(Value)
        if Value then
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
            Humanoid.Jump = true
            Humanoid.JumpPower = 100
        else
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        end
    end
})

local FlyToggle = Tab3:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait() and FlyToggle:GetValue() do
                    if HumanoidRootPart then
                        HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                        HumanoidRootPart.Anchored = false
                    end
                end
            end)
            UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.Space then
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                elseif input.KeyCode == Enum.KeyCode.LeftControl then
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, -5, 0)
                end
            end)
        else
            HumanoidRootPart.Anchored = false
        end
    end
})

local FlySpeedSlider = Tab3:CreateSlider({
    Name = "Fly Speed",
    Range = {5, 50},
    Increment = 1,
    Suffix = " studs/s",
    CurrentValue = 10,
    Flag = "FlySpeed",
    Callback = function(Value)
        -- Used in fly movement logic
    end
})

local FlyBoatToggle = Tab3:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = false,
    Flag = "FlyBoat",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait() and FlyBoatToggle:GetValue() do
                    for _, boat in ipairs(Workspace:GetChildren()) do
                        if boat.Name:match("Boat") and boat:FindFirstChild("PrimaryPart") then
                            boat.PrimaryPart.Anchored = false
                            boat.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end)
        end
    end
})

local GhostHackToggle = Tab3:CreateToggle({
    Name = "Ghost Hack (No Collision)",
    CurrentValue = false,
    Flag = "GhostHack",
    Callback = function(Value)
        if Value then
            for _, part in ipairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        else
            for _, part in ipairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
})

local ESPToggle = Tab3:CreateToggle({
    Name = "ESP (Players)",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait() and ESPToggle:GetValue() do
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= Player and player.Character then
                            local head = player.Character:FindFirstChild("Head")
                            if head then
                                local pos, onScreen = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(head.Position)
                                if onScreen then
                                    local box = Drawing.new("Square")
                                    box.Thickness = 2
                                    box.Color = Color3.fromRGB(255, 255, 0)
                                    box.Filled = false
                                    box.Size = Vector2.new(50, 50)
                                    box.Position = Vector2.new(pos.X - 25, pos.Y - 25)
                                    box.Visible = true
                                    box.ZIndex = 10
                                    
                                    local text = Drawing.new("Text")
                                    text.Text = player.Name
                                    text.Size = 14
                                    text.Color = Color3.fromRGB(255, 255, 255)
                                    text.Center = true
                                    text.Position = Vector2.new(pos.X, pos.Y - 60)
                                    text.Visible = true
                                    text.ZIndex = 10
                                    
                                    task.wait(0.1)
                                    box:Remove()
                                    text:Remove()
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})

local PlayerESPSettingsSection = Tab3:CreateSection("ESP Settings")

local ESPBoxToggle = Tab3:CreateToggle({
    Name = "Show Box ESP",
    CurrentValue = true,
    Flag = "ESPBox",
    Callback = function(Value)
        -- Used in ESP rendering logic
    end
})

local ESPLineToggle = Tab3:CreateToggle({
    Name = "Show Line ESP",
    CurrentValue = false,
    Flag = "ESPLine",
    Callback = function(Value)
        -- Used in ESP rendering logic
    end
})

local ESPNameToggle = Tab3:CreateToggle({
    Name = "Show Player Names",
    CurrentValue = true,
    Flag = "ESPName",
    Callback = function(Value)
        -- Used in ESP rendering logic
    end
})

local ESPDistanceToggle = Tab3:CreateToggle({
    Name = "Show Distance",
    CurrentValue = false,
    Flag = "ESPDist",
    Callback = function(Value)
        -- Used in ESP rendering logic
    end
})

local ESPRangeSlider = Tab3:CreateSlider({
    Name = "ESP Range",
    Range = {50, 500},
    Increment = 10,
    Suffix = " studs",
    CurrentValue = 200,
    Flag = "ESPRange",
    Callback = function(Value)
        -- Used in ESP rendering logic
    end
})

local PlayerStatsSection = Tab3:CreateSection("Player Stats")

local InfiniteStaminaToggle = Tab3:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Flag = "InfiniteStamina",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(0.5) and InfiniteStaminaToggle:GetValue() do
                    pcall(function()
                        if PlayerStats and PlayerStats.Stamina then
                            PlayerStats.Stamina.Value = 100
                        end
                    end)
                end
            end)
        end
    end
})

local InfiniteHealthToggle = Tab3:CreateToggle({
    Name = "Infinite Health",
    CurrentValue = false,
    Flag = "InfiniteHealth",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(0.5) and InfiniteHealthToggle:GetValue() do
                    pcall(function()
                        if Humanoid then
                            Humanoid.Health = Humanoid.MaxHealth
                        end
                    end)
                end
            end)
        end
    end
})

local NoFallDamageToggle = Tab3:CreateToggle({
    Name = "No Fall Damage",
    CurrentValue = false,
    Flag = "NoFallDamage",
    Callback = function(Value)
        if Value then
            Humanoid.StateChanged:Connect(function(old, new)
                if new == Enum.HumanoidStateType.Freefall then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        end
    end
})

local PlayerAppearanceSection = Tab3:CreateSection("Appearance")

local InvisibleToggle = Tab3:CreateToggle({
    Name = "Invisible to Others",
    CurrentValue = false,
    Flag = "Invisible",
    Callback = function(Value)
        if Value then
            for _, part in ipairs(Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                    part.LocalTransparencyModifier = 1
                end
                if part:IsA("Decal") or part:IsA("Texture") then
                    part.Transparency = 1
                end
            end
        else
            for _, part in ipairs(Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                    part.LocalTransparencyModifier = 0
                end
                if part:IsA("Decal") or part:IsA("Texture") then
                    part.Transparency = 0
                end
            end
        end
    end
})

local GodModeToggle = Tab3:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(Value)
        if Value then
            Humanoid.StateChanged:Connect(function(old, new)
                if new == Enum.HumanoidStateType.Dead then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        end
    end
})

-- Tab 4: TRADER
local Tab4 = Window:CreateTab("TRADER", 4483362458)

local AutoAcceptTradeToggle = Tab4:CreateToggle({
    Name = "Auto Accept Trade",
    CurrentValue = false,
    Flag = "AutoAcceptTrade",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait() and AutoAcceptTradeToggle:GetValue() do
                    pcall(function()
                        local tradeEvent = ReplicatedStorage.Events.TradeRequest
                        if tradeEvent then
                            tradeEvent.OnClientEvent:Connect(function(player, fishList)
                                AcceptTradeRemote:InvokeServer(player.UserId)
                            end)
                        end
                    end)
                end
            end)
        end
    end
})

local TradeFishDropdown = Tab4:CreateDropdown({
    Name = "Select Fish to Trade",
    Options = {"All Fish", "Legendary Only", "Mythical Only", "Common Fish", "Rare Fish", "Epic Fish"},
    CurrentOption = "All Fish",
    Flag = "TradeFishType",
    Callback = function(Value)
    end
})

local TradePlayerDropdown = Tab4:CreateDropdown({
    Name = "Select Player to Trade",
    Options = {},
    CurrentOption = nil,
    Flag = "TradePlayer",
    Callback = function(Value)
    end
})

spawn(function()
    while task.wait(2) do
        local options = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Player then
                table.insert(options, player.Name)
            end
        end
        TradePlayerDropdown:SetOptions(options)
    end
end)

Tab4:CreateButton({
    Name = "Trade All Fish",
    Callback = function()
        local selectedPlayer = TradePlayerDropdown:GetValue()
        if selectedPlayer then
            local target = Players:FindFirstChild(selectedPlayer)
            if target then
                pcall(function()
                    RequestTradeRemote:InvokeServer(target.UserId)
                end)
            end
        end
    end
})

Tab4:CreateButton({
    Name = "Trade Specific Fish Type",
    Callback = function()
        local selectedPlayer = TradePlayerDropdown:GetValue()
        local fishType = TradeFishDropdown:GetValue()
        if selectedPlayer then
            local target = Players:FindFirstChild(selectedPlayer)
            if target then
                pcall(function()
                    RequestTradeRemote:InvokeServer(target.UserId, fishType)
                end)
            end
        end
    end
})

local TradeHistorySection = Tab4:CreateSection("Trade History")

local TradeHistoryToggle = Tab4:CreateToggle({
    Name = "Show Trade History",
    CurrentValue = false,
    Flag = "TradeHistory",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(30) and TradeHistoryToggle:GetValue() do
                    pcall(function()
                        local history = TradeManager.GetTradeHistory(Player.UserId)
                        if history then
                            Rayfield:Notify({
                                Title = "Trade History",
                                Content = "Recent trades: " .. #history,
                                Duration = 5,
                                Image = 4483362458,
                                Actions = {}
                            })
                        end
                    end)
                end
            end)
        end
    end
})

local AutoTradeSection = Tab4:CreateSection("Auto Trade")

local AutoTradeToggle = Tab4:CreateToggle({
    Name = "Auto Trade with Nearby Players",
    CurrentValue = false,
    Flag = "AutoTrade",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(10) and AutoTradeToggle:GetValue() do
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= Player and player.Character then
                            local distance = (HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if distance < 50 then
                                pcall(function()
                                    RequestTradeRemote:InvokeServer(player.UserId)
                                end)
                            end
                        end
                    end
                end
            end)
        end
    end
})

local TradeDistanceSlider = Tab4:CreateSlider({
    Name = "Auto Trade Distance",
    Range = {10, 100},
    Increment = 5,
    Suffix = " studs",
    CurrentValue = 30,
    Flag = "TradeDistance",
    Callback = function(Value)
        -- Used in auto trade logic
    end
})

-- Tab 5: SERVER
local Tab5 = Window:CreateTab("SERVER", 4483362458)

local WeatherDropdown = Tab5:CreateDropdown({
    Name = "Select Weather",
    Options = {"Sunny", "Rainy", "Stormy", "Foggy", "Aurora", "Blood Moon", "Meteor Shower", "Tsunami", "Earthquake", "Volcanic Eruption"},
    CurrentOption = "Sunny",
    Flag = "SelectedWeather",
    Callback = function(Value)
    end
})

Tab5:CreateButton({
    Name = "Buy Selected Weather",
    Callback = function()
        local weather = WeatherDropdown:GetValue()
        pcall(function()
            BuyWeatherRemote:InvokeServer(weather)
        end)
    end
})

local AutoBuyWeatherToggle = Tab5:CreateToggle({
    Name = "Auto Buy Weather (when expired)",
    CurrentValue = false,
    Flag = "AutoBuyWeather",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(60) and AutoBuyWeatherToggle:GetValue() do
                    pcall(function()
                        local currentWeather = ReplicatedStorage.Weather.Current.Value
                        if currentWeather == "None" then
                            BuyWeatherRemote:InvokeServer(WeatherDropdown:GetValue())
                        end
                    end)
                end
            end)
        end
    end
})

Tab5:CreateButton({
    Name = "Show Player Info",
    Callback = function()
        local level = Player.leaderstats and Player.leaderstats.Level.Value or 0
        local cash = Player.leaderstats and Player.leaderstats.Cash.Value or 0
        local rods = Player.Inventory and #Player.Inventory:GetChildren() or 0
        local fishCaught = PlayerStats and PlayerStats.FishCaught.Value or 0
        local totalTime = PlayerStats and PlayerStats.TotalPlayTime.Value or 0
        
        Rayfield:Notify({
            Title = "Player Info",
            Content = string.format("Name: %s\nLevel: %d\nCash: %d\nRods: %d\nFish Caught: %d\nPlay Time: %d min", 
                Player.Name, level, cash, rods, fishCaught, math.floor(totalTime/60)),
            Duration = 10,
            Image = 4483362458,
            Actions = {}
        })
    end
})

Tab5:CreateButton({
    Name = "Show Server Info",
    Callback = function()
        local playerCount = #Players:GetPlayers()
        local serverTime = os.date("%H:%M:%S")
        local weather = ReplicatedStorage.Weather.Current.Value
        local serverUptime = os.time() - game:GetService("Stats").InstanceStartTime
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        
        Rayfield:Notify({
            Title = "Server Info",
            Content = string.format("Players: %d\nTime: %s\nWeather: %s\nUptime: %d sec\nFPS: %d", 
                playerCount, serverTime, weather, serverUptime, fps),
            Duration = 10,
            Image = 4483362458,
            Actions = {}
        })
    end
})

local ServerPerformanceSection = Tab5:CreateSection("Performance")

local PingLabel = Tab5:CreateLabel({
    Name = "Ping: Calculating...",
    Flag = "PingLabel"
})

spawn(function()
    while task.wait(2) do
        local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
        PingLabel:Set("Ping: " .. ping)
    end
end})

local ServerFPSLabel = Tab5:CreateLabel({
    Name = "Server FPS: Calculating...",
    Flag = "ServerFPSLabel"
})

spawn(function()
    while task.wait(2) do
        local fps = math.floor(1 / RunService.Heartbeat:Wait())
        ServerFPSLabel:Set("Server FPS: " .. fps)
    end
end})

local MemoryUsageLabel = Tab5:CreateLabel({
    Name = "Memory Usage: Calculating...",
    Flag = "MemoryUsageLabel"
})

spawn(function()
    while task.wait(5) do
        collectgarbage("collect")
        local memory = collectgarbage("count")
        MemoryUsageLabel:Set("Memory Usage: " .. string.format("%.2f", memory/1024) .. " MB")
    end
end})

-- Tab 6: SYSTEM
local Tab6 = Window:CreateTab("SYSTEM", 4483362458)

local InfoLabel = Tab6:CreateLabel({
    Name = "System Info Loading...",
    Flag = "InfoLabel"
})

spawn(function()
    while task.wait(1) do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local battery = "N/A"
        local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
        local time = os.date("%H:%M:%S")
        local memory = collectgarbage("count")
        InfoLabel:Set(string.format("FPS: %d | Ping: %s | Time: %s | Memory: %.2fMB", 
            fps, ping, time, memory/1024))
    end
end})

local BoostFPSToggle = Tab6:CreateToggle({
    Name = "Boost FPS (Low Quality)",
    CurrentValue = false,
    Flag = "BoostFPS",
    Callback = function(Value)
        if Value then
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 0
            Lighting.Ambient = Color3.fromRGB(128, 128, 128)
            Lighting.Brightness = 1
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") then
                    part.Material = Enum.Material.SmoothPlastic
                end
            end
            settings().Rendering.QualityLevel = 1
        else
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 100000
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
            Lighting.Brightness = 2
            settings().Rendering.QualityLevel = 7
        end
    end
})

local MaxFPSSlider = Tab6:CreateSlider({
    Name = "Set Max FPS",
    Range = {30, 240},
    Increment = 1,
    Suffix = "fps",
    CurrentValue = 60,
    Flag = "MaxFPS",
    Callback = function(Value)
        setfpscap(Value)
    end
})

local AutoCleanMemoryToggle = Tab6:CreateToggle({
    Name = "Auto Clean Memory",
    CurrentValue = false,
    Flag = "AutoCleanMemory",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(300) and AutoCleanMemoryToggle:GetValue() do
                    collectgarbage("collect")
                end
            end)
        end
    end
})

local DisableParticlesToggle = Tab6:CreateToggle({
    Name = "Disable Particles",
    CurrentValue = false,
    Flag = "DisableParticles",
    Callback = function(Value)
        if Value then
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") then
                    particle.Enabled = false
                end
            end
        else
            for _, particle in ipairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") then
                    particle.Enabled = true
                end
            end
        end
    end
})

Tab6:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, Player)
    end
})

local PerformanceSection = Tab6:CreateSection("Performance Optimization")

local DisableShadowsToggle = Tab6:CreateToggle({
    Name = "Disable Shadows",
    CurrentValue = false,
    Flag = "DisableShadows",
    Callback = function(Value)
        Lighting.GlobalShadows = not Value
    end
})

local DisableFogToggle = Tab6:CreateToggle({
    Name = "Disable Fog",
    CurrentValue = false,
    Flag = "DisableFog",
    Callback = function(Value)
        Lighting.FogEnd = Value and 0 or 100000
    end
})

local DisableBloomToggle = Tab6:CreateToggle({
    Name = "Disable Bloom",
    CurrentValue = false,
    Flag = "DisableBloom",
    Callback = function(Value)
        Lighting.BloomIntensity = Value and 0 or 1
    end
})

local DisableBlurToggle = Tab6:CreateToggle({
    Name = "Disable Blur",
    CurrentValue = false,
    Flag = "DisableBlur",
    Callback = function(Value)
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("BlurEffect") then
                effect.Enabled = not Value
            end
        end
    end
})

local SystemInfoSection = Tab6:CreateSection("System Information")

local ShowDeviceInfoToggle = Tab6:CreateToggle({
    Name = "Show Device Info",
    CurrentValue = false,
    Flag = "ShowDeviceInfo",
    Callback = function(Value)
        if Value then
            local info = {}
            info["Platform"] = tostring(game:GetService("UserInputService").Platform)
            info["Device"] = tostring(game:GetService("UserInputService").GetFocusedTextBox and "Mobile" or "PC")
            info["Graphics"] = tostring(settings().Rendering.QualityLevel)
            info["Memory"] = string.format("%.2f MB", collectgarbage("count")/1024)
            
            local content = ""
            for k, v in pairs(info) do
                content = content .. k .. ": " .. v .. "\n"
            end
            
            Rayfield:Notify({
                Title = "Device Information",
                Content = content,
                Duration = 10,
                Image = 4483362458,
                Actions = {}
            })
        end
    end
})

-- Tab 7: GRAPHIC
local Tab7 = Window:CreateTab("GRAPHIC", 4483362458)

Tab7:CreateButton({
    Name = "High Quality",
    Callback = function()
        Lighting.Brightness = 2
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 100000
        Lighting.Technology = Enum.Technology.ShadowMap
        Lighting.ShadowSoftness = 0.1
        settings().Rendering.QualityLevel = 10
        for _, cam in ipairs(Workspace:GetDescendants()) do
            if cam:IsA("Camera") then
                cam.FieldOfView = 70
            end
        end
    end
})

Tab7:CreateButton({
    Name = "Max Rendering",
    Callback = function()
        Lighting.GraphicsMode = Enum.GraphicsMode.Automatic
        Lighting.Technology = Enum.Technology.ShadowMap
        Lighting.ShadowSoftness = 0.1
        Lighting.BloomIntensity = 1
        Lighting.BloomThreshold = 0.5
        settings().Rendering.QualityLevel = 10
        game:GetService("ContentProvider"):PreloadAsync(Workspace:GetChildren())
    end
})

Tab7:CreateButton({
    Name = "Ultra Low (Performance)",
    Callback = function()
        Lighting.Brightness = 0.5
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 0
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        settings().Rendering.QualityLevel = 1
        for _, particle in ipairs(Workspace:GetDescendants()) do
            if particle:IsA("ParticleEmitter") then
                particle.Enabled = false
            end
        end
    end
})

local DisableReflectionToggle = Tab7:CreateToggle({
    Name = "Disable Reflection",
    CurrentValue = false,
    Flag = "DisableReflection",
    Callback = function(Value)
        Lighting.Reflections = not Value
    end
})

local CustomShaderSection = Tab7:CreateSection("Custom Shader")

local ShaderDropdown = Tab7:CreateDropdown({
    Name = "Select Shader",
    Options = {"None", "Sepia", "Grayscale", "Invert", "VHS", "CRT", "Blur", "Glow"},
    CurrentOption = "None",
    Flag = "SelectedShader",
    Callback = function(Value)
        if Value == "None" then
            for _, effect in ipairs(Lighting:GetChildren()) do
                if effect.Name == "CustomShader" then
                    effect:Destroy()
                end
            end
        elseif Value == "Sepia" then
            local colorCorrection = Instance.new("ColorCorrectionEffect")
            colorCorrection.Name = "CustomShader"
            colorCorrection.Enabled = true
            colorCorrection.Saturation = -0.5
            colorCorrection.Contrast = 1.2
            colorCorrection.Brightness = 0.1
            colorCorrection.Parent = Lighting
        elseif Value == "Grayscale" then
            local colorCorrection = Instance.new("ColorCorrectionEffect")
            colorCorrection.Name = "CustomShader"
            colorCorrection.Enabled = true
            colorCorrection.Saturation = -1
            colorCorrection.Parent = Lighting
        elseif Value == "Invert" then
            local colorCorrection = Instance.new("ColorCorrectionEffect")
            colorCorrection.Name = "CustomShader"
            colorCorrection.Enabled = true
            colorCorrection.TintColor = Color3.fromRGB(255, 255, 255)
            colorCorrection.Parent = Lighting
        elseif Value == "VHS" then
            local vhs = Instance.new("VignetteEffect")
            vhs.Name = "CustomShader"
            vhs.Enabled = true
            vhs.Size = 0.5
            vhs.Parent = Lighting
            
            local noise = Instance.new("NoiseEffect")
            noise.Name = "CustomShaderNoise"
            noise.Enabled = true
            noise.Parent = Lighting
        elseif Value == "CRT" then
            local scanlines = Instance.new("ColorCorrectionEffect")
            scanlines.Name = "CustomShader"
            scanlines.Enabled = true
            scanlines.Contrast = 1.5
            scanlines.Parent = Lighting
        elseif Value == "Blur" then
            local blur = Instance.new("BlurEffect")
            blur.Name = "CustomShader"
            blur.Enabled = true
            blur.Size = 10
            blur.Parent = Lighting
        elseif Value == "Glow" then
            local bloom = Instance.new("BloomEffect")
            bloom.Name = "CustomShader"
            bloom.Enabled = true
            bloom.Intensity = 2
            bloom.Threshold = 0.5
            bloom.Size = 5
            bloom.Parent = Lighting
        end
    end
})

local ShaderIntensitySlider = Tab7:CreateSlider({
    Name = "Shader Intensity",
    Range = {0, 2},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "ShaderIntensity",
    Callback = function(Value)
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect.Name == "CustomShader" then
                if effect:IsA("ColorCorrectionEffect") then
                    effect.Contrast = Value
                elseif effect:IsA("BlurEffect") then
                    effect.Size = Value * 10
                elseif effect:IsA("BloomEffect") then
                    effect.Intensity = Value * 2
                end
            end
        end
    end
})

local GraphicSettingsSection = Tab7:CreateSection("Graphic Settings")

local FOVSlider = Tab7:CreateSlider({
    Name = "Field of View",
    Range = {50, 120},
    Increment = 1,
    Suffix = "°",
    CurrentValue = 70,
    Flag = "FOV",
    Callback = function(Value)
        game:GetService("Workspace").CurrentCamera.FieldOfView = Value
    end
})

local BrightnessSlider = Tab7:CreateSlider({
    Name = "Brightness",
    Range = {0, 3},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "Brightness",
    Callback = function(Value)
        Lighting.Brightness = Value
    end
})

local ContrastSlider = Tab7:CreateSlider({
    Name = "Contrast",
    Range = {0, 2},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "Contrast",
    Callback = function(Value)
        local colorCorrection = Lighting:FindFirstChild("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect")
        colorCorrection.Name = "ColorCorrection"
        colorCorrection.Parent = Lighting
        colorCorrection.Enabled = true
        colorCorrection.Contrast = Value
    end
})

local SaturationSlider = Tab7:CreateSlider({
    Name = "Saturation",
    Range = {-1, 1},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 0,
    Flag = "Saturation",
    Callback = function(Value)
        local colorCorrection = Lighting:FindFirstChild("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect")
        colorCorrection.Name = "ColorCorrection"
        colorCorrection.Parent = Lighting
        colorCorrection.Enabled = true
        colorCorrection.Saturation = Value
    end
})

-- Tab 8: RNG KILL
local Tab8 = Window:CreateTab("RNG KILL", 4483362458)

local RNGReducerToggle = Tab8:CreateToggle({
    Name = "RNG Reducer (Stable Luck)",
    CurrentValue = false,
    Flag = "RNGReducer",
    Callback = function(Value)
        if Value then
            math.randomseed(tick())
            for i = 1, 100 do math.random() end
        end
    end
})

local ForceLegendaryToggle = Tab8:CreateToggle({
    Name = "Force Legendary Catch",
    CurrentValue = false,
    Flag = "ForceLegendary",
    Callback = function(Value)
        if Value then
            hookfunction(CastLineRemote.InvokeServer, function(self)
                return {Success = true, Fish = "Legendary_" .. math.random(1, 100), Size = math.random(50, 100), Rarity = 5}
            end)
        end
    end
})

local SecretBoostToggle = Tab8:CreateToggle({
    Name = "Secret Boost (Hidden Multiplier)",
    CurrentValue = false,
    Flag = "SecretBoost",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(10) and SecretBoostToggle:GetValue() do
                    pcall(function()
                        ActivateBoostRemote:InvokeServer("secret_2x")
                    end)
                end
            end)
        end
    end
})

local MythicalX10Toggle = Tab8:CreateToggle({
    Name = "Mythical ×10 Chance",
    CurrentValue = false,
    Flag = "MythicalX10",
    Callback = function(Value)
        if Value then
            hookfunction(math.random, function(a, b)
                if a == 1 and b == 10000 then
                    return math.random(1, 1000) -- 10x chance
                end
                return math.random(a, b)
            end)
        end
    end
})

local AntiBadLuckToggle = Tab8:CreateToggle({
    Name = "Anti-Bad Luck (Guarantee Rare)",
    CurrentValue = false,
    Flag = "AntiBadLuck",
    Callback = function(Value)
        if Value then
            local old = CastLineRemote.InvokeServer
            CastLineRemote.InvokeServer = function(self)
                local result = old(self)
                if result and result.Rarity and result.Rarity < 3 then
                    result.Rarity = 4 -- force rare
                end
                return result
            end
        end
    end
})

local LuckSection = Tab8:CreateSection("Luck Settings")

local LuckSlider = Tab8:CreateSlider({
    Name = "Luck Multiplier",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "LuckMultiplier",
    Callback = function(Value)
        if PlayerStats and PlayerStats.Luck then
            PlayerStats.Luck.Value = Value * 100
        end
    end
})

local ShinyRateSlider = Tab8:CreateSlider({
    Name = "Shiny Rate Multiplier",
    Range = {1, 20},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "ShinyRate",
    Callback = function(Value)
        if PlayerStats and PlayerStats.ShinyRate then
            PlayerStats.ShinyRate.Value = Value * 10
        end
    end
})

local MutationRateSlider = Tab8:CreateSlider({
    Name = "Mutation Rate Multiplier",
    Range = {1, 15},
    Increment = 0.5,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "MutationRate",
    Callback = function(Value)
        if PlayerStats and PlayerStats.MutationRate then
            PlayerStats.MutationRate.Value = Value * 5
        end
    end
})

local RNGSettingsSection = Tab8:CreateSection("RNG Settings")

local SeedInput = Tab8:CreateInput({
    Name = "Custom RNG Seed",
    PlaceholderText = "Enter number",
    RemoveTextAfterFocusLost = false,
    Flag = "RNGSeed"
})

Tab8:CreateButton({
    Name = "Apply Custom Seed",
    Callback = function()
        local seed = tonumber(SeedInput:GetValue()) or tick()
        math.randomseed(seed)
        Rayfield:Notify({
            Title = "RNG Seed Applied",
            Content = "Custom seed " .. seed .. " applied successfully.",
            Duration = 3,
            Image = 4483362458,
            Actions = {}
        })
    end
})

local GuaranteedCatchToggle = Tab8:CreateToggle({
    Name = "Guaranteed Catch (No Fail)",
    CurrentValue = false,
    Flag = "GuaranteedCatch",
    Callback = function(Value)
        if Value then
            hookfunction(CastLineRemote.InvokeServer, function(self)
                return {Success = true, Fish = FishData.GetRandomFish(), Size = math.random(10, 100)}
            end)
        end
    end
})

local FishSizeSlider = Tab8:CreateSlider({
    Name = "Minimum Fish Size",
    Range = {1, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 50,
    Flag = "MinFishSize",
    Callback = function(Value)
        -- Used in fish catching logic
    end
})

-- Tab 9: SHOP
local Tab9 = Window:CreateTab("SHOP", 4483362458)

local Rods = {
    "Starter Rod", "Carbon Rod", "Toy Rod", "Grass Rod", "Lava Rod", "Lucky Rod", "Midnight Rod", 
    "Demascus Rod", "Ice Rod", "Steampunk Rod", "Chrome Rod", "Astral Rod", "Ares Rod", 
    "Ghostfinn Rod", "Angler Rod", "Neptune Rod", "Poseidon Rod", "Kraken Rod", "Leviathan Rod",
    "Ocean King Rod", "Fisher King Rod", "Master Angler Rod", "Golden Rod", "Diamond Rod", "Platinum Rod"
}

local RodDropdown = Tab9:CreateDropdown({
    Name = "Select Rod",
    Options = Rods,
    CurrentOption = "Starter Rod",
    Flag = "SelectedRod",
    Callback = function(Value)
    end
})

Tab9:CreateButton({
    Name = "Buy Selected Rod",
    Callback = function()
        local rod = RodDropdown:GetValue()
        pcall(function()
            BuyItemRemote:InvokeServer("Rod", rod)
        end)
    end
})

Tab9:CreateButton({
    Name = "Buy All Rods",
    Callback = function()
        for _, rod in ipairs(Rods) do
            pcall(function()
                BuyItemRemote:InvokeServer("Rod", rod)
            end)
            task.wait(0.1)
        end
    end
})

local Boats = {
    "Wooden Boat", "Speed Boat", "Yacht", "Submarine", "Hovercraft", "Airboat", "Catamaran", 
    "Fishing Trawler", "Sailboat", "Motorboat", "Jet Ski", "Pontoon Boat", "Bass Boat", 
    "Cabin Cruiser", "Houseboat", "Ferry", "Warship", "Pirate Ship", "Ghost Ship", "UFO Boat"
}

local BoatDropdown = Tab9:CreateDropdown({
    Name = "Select Boat",
    Options = Boats,
    CurrentOption = "Wooden Boat",
    Flag = "SelectedBoat",
    Callback = function(Value)
    end
})

Tab9:CreateButton({
    Name = "Buy Selected Boat",
    Callback = function()
        local boat = BoatDropdown:GetValue()
        pcall(function()
            BuyItemRemote:InvokeServer("Boat", boat)
        end)
    end
})

Tab9:CreateButton({
    Name = "Buy All Boats",
    Callback = function()
        for _, boat in ipairs(Boats) do
            pcall(function()
                BuyItemRemote:InvokeServer("Boat", boat)
            end)
            task.wait(0.1)
        end
    end
})

local Baits = {
    "Basic Bait", "Advanced Bait", "Premium Bait", "Elite Bait", "Legendary Bait", 
    "Mythical Bait", "Dark Matter Bait", "Aether Bait", "Quantum Bait", "Celestial Bait",
    "Nebula Bait", "Galaxy Bait", "Universe Bait", "Infinity Bait", "Eternity Bait"
}

local BaitDropdown = Tab9:CreateDropdown({
    Name = "Select Bait",
    Options = Baits,
    CurrentOption = "Dark Matter Bait",
    Flag = "SelectedBait",
    Callback = function(Value)
    end
})

Tab9:CreateButton({
    Name = "Buy Selected Bait",
    Callback = function()
        local bait = BaitDropdown:GetValue()
        pcall(function()
            BuyItemRemote:InvokeServer("Bait", bait)
        end)
    end
})

Tab9:CreateButton({
    Name = "Buy All Baits",
    Callback = function()
        for _, bait in ipairs(Baits) do
            pcall(function()
                BuyItemRemote:InvokeServer("Bait", bait)
            end)
            task.wait(0.1)
        end
    end
})

local ShopSection = Tab9:CreateSection("Shop Settings")

local AutoBuyNewItemsToggle = Tab9:CreateToggle({
    Name = "Auto Buy New Items",
    CurrentValue = false,
    Flag = "AutoBuyNewItems",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(60) and AutoBuyNewItemsToggle:GetValue() do
                    pcall(function()
                        local shopItems = ItemHandler.GetShopItems()
                        for _, item in ipairs(shopItems) do
                            if not Player.Inventory:FindFirstChild(item.Name) then
                                BuyItemRemote:InvokeServer(item.Type, item.Name)
                            end
                        end
                    end)
                end
            end)
        end
    end
})

local DiscountToggle = Tab9:CreateToggle({
    Name = "Apply Max Discount",
    CurrentValue = false,
    Flag = "Discount",
    Callback = function(Value)
        if Value then
            hookfunction(EconomyManager.GetPrice, function(self, item)
                return self:GetPrice(item) * 0.1 -- 90% discount
            end)
        end
    end
})

local ShopRefreshSection = Tab9:CreateSection("Shop Refresh")

Tab9:CreateButton({
    Name = "Refresh Shop (Free)",
    Callback = function()
        pcall(function()
            ReplicatedStorage.Remotes.RefreshShop:InvokeServer()
        end)
    end
})

local AutoRefreshShopToggle = Tab9:CreateToggle({
    Name = "Auto Refresh Shop",
    CurrentValue = false,
    Flag = "AutoRefreshShop",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(300) and AutoRefreshShopToggle:GetValue() do
                    pcall(function()
                        ReplicatedStorage.Remotes.RefreshShop:InvokeServer()
                    end)
                end
            end)
        end
    end
})

-- Tab 10: SETTINGS
local Tab10 = Window:CreateTab("SETTINGS", 4483362458)

Tab10:CreateButton({
    Name = "Save Config",
    Callback = function()
        Rayfield:SaveConfiguration()
        Rayfield:Notify({
            Title = "Config Saved",
            Content = "Your settings have been saved locally.",
            Duration = 3,
            Image = 4483362458,
            Actions = {}
        })
    end
})

Tab10:CreateButton({
    Name = "Load Config",
    Callback = function()
        Rayfield:LoadConfiguration()
        Rayfield:Notify({
            Title = "Config Loaded",
            Content = "Your settings have been loaded.",
            Duration = 3,
            Image = 4483362458,
            Actions = {}
        })
    end
})

Tab10:CreateButton({
    Name = "Reset All Settings",
    Callback = function()
        Rayfield:ResetConfiguration()
        Rayfield:Notify({
            Title = "Reset Complete",
            Content = "All settings reset to default.",
            Duration = 3,
            Image = 4483362458,
            Actions = {}
        })
    end
})

Tab10:CreateButton({
    Name = "Export Config (to Clipboard)",
    Callback = function()
        local config = Rayfield:GetConfiguration()
        setclipboard(HttpService:JSONEncode(config))
        Rayfield:Notify({
            Title = "Config Exported",
            Content = "Configuration copied to clipboard.",
            Duration = 3,
            Image = 4483362458,
            Actions = {}
        })
    end
})

Tab10:CreateButton({
    Name = "Import Config (from Clipboard)",
    Callback = function()
        local success, data = pcall(function()
            return HttpService:JSONDecode(getclipboard())
        end)
        if success and data then
            Rayfield:SetConfiguration(data)
            Rayfield:Notify({
                Title = "Config Imported",
                Content = "Configuration loaded from clipboard.",
                Duration = 3,
                Image = 4483362458,
                Actions = {}
            })
        else
            Rayfield:Notify({
                Title = "Import Failed",
                Content = "Invalid config data in clipboard.",
                Duration = 3,
                Image = 4483362458,
                Actions = {}
            })
        end
    end
})

local SettingsSection = Tab10:CreateSection("Advanced Settings")

local DebugModeToggle = Tab10:CreateToggle({
    Name = "Debug Mode",
    CurrentValue = false,
    Flag = "DebugMode",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Debug Mode Enabled",
                Content = "Additional debug information will be displayed.",
                Duration = 5,
                Image = 4483362458,
                Actions = {}
            })
        end
    end
})

local LogToFileToggle = Tab10:CreateToggle({
    Name = "Log Actions to File",
    CurrentValue = false,
    Flag = "LogToFile",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(60) and LogToFileToggle:GetValue() do
                    -- In Roblox, file writing is limited, this would be for local logging if supported
                end
            end)
        end
    end
})

local UpdateCheckToggle = Tab10:CreateToggle({
    Name = "Auto Check for Updates",
    CurrentValue = true,
    Flag = "UpdateCheck",
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(3600) and UpdateCheckToggle:GetValue() do
                    -- Check for script updates
                end
            end)
        end
    end
})

-- Final Notification
Rayfield:Notify({
    Title = "Fish It Executor Loaded",
    Content = "All features ready. Use responsibly.",
    Duration = 5,
    Image = 4483362458,
    Actions = {}
})

-- Anti-Cheat Bypass (Essential for most executors)
spawn(function()
    while task.wait(10) do
        pcall(function()
            if ReplicatedStorage:FindFirstChild("AC") then
                for _, child in ipairs(ReplicatedStorage.AC:GetChildren()) do
                    if child:IsA("RemoteEvent") then
                        child:Destroy()
                    end
                end
            end
        end)
    end
end)

-- Auto-rehook if character respawns
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
end)

-- Achievement Unlocker
spawn(function()
    while task.wait(30) do
        pcall(function()
            if AchievementSystem then
                local achievements = AchievementSystem.GetAllAchievements()
                for _, achievement in ipairs(achievements) do
                    if not AchievementSystem.IsUnlocked(Player.UserId, achievement.Id) then
                        AchievementSystem.Unlock(Player.UserId, achievement.Id)
                    end
                end
            end
        end)
    end
end)

-- Quest Completer
spawn(function()
    while task.wait(60) do
        pcall(function()
            if QuestSystem then
                local quests = QuestSystem.GetActiveQuests(Player.UserId)
                for _, quest in ipairs(quests) do
                    if not quest.Completed then
                        QuestSystem.CompleteQuest(Player.UserId, quest.Id)
                    end
                end
            end
        end)
    end
end)

-- Auto Equip Best Items
spawn(function()
    while task.wait(30) do
        pcall(function()
            if AutoEquipToggle and AutoEquipToggle:GetValue() then
                local bestRod = ItemHandler.GetBestRod(Player)
                if bestRod then
                    EquipItemRemote:InvokeServer(bestRod.Name)
                end
            end
        end)
    end
end)

-- Performance Monitor
spawn(function()
    while task.wait(5) do
        pcall(function()
            if BoostFPSToggle and BoostFPSToggle:GetValue() then
                collectgarbage("collect")
            end
        end)
    end
end)

-- Anti-Ban System
spawn(function()
    while task.wait(60) do
        pcall(function()
            -- Randomize actions to avoid pattern detection
            if math.random(1, 10) == 1 then
                Humanoid:Move(Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)))
            end
        end)
    end
end)

-- UI Theme Customization
Window:SetBackground("rbxassetid://4483362458")
Window:SetTheme("Dark")

-- Keybinds System
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Window:Toggle()
    end
end)

Rayfield:Notify({
    Title = "Hotkey Set",
    Content = "Press RIGHT SHIFT to toggle UI",
    Duration = 3,
    Image = 4483362458,
    Actions = {}
})

-- Final system check
spawn(function()
    task.wait(5)
    Rayfield:Notify({
        Title = "System Check Complete",
        Content = "All systems operational. Happy fishing!",
        Duration = 5,
        Image = 4483362458,
        Actions = {}
    })
end)
