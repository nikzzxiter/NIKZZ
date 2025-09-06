-- NIKZZ SCRIPT - FISH IT by Nikzz Xit - REVISED EDITION
-- Version: 3.0.0
-- Last Updated: September 2025
-- Rayfield UI Version - COMPLETE REWORK

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local MarketService = game:GetService("MarketplaceService")

-- Auto Update System
local Version = "3.0.0"
local GitHubRaw = "https://raw.githubusercontent.com/NikzzXit/FishItHub/main/FishItHub_Rayfield.lua"
local GitHubVersion = "https://raw.githubusercontent.com/NikzzXit/FishItHub/main/version_rayfield.txt"

local function CheckForUpdates()
    local success, latestVersion = pcall(function()
        return game:HttpGet(GitHubVersion)
    end)
    
    if success and latestVersion and latestVersion ~= Version then
        Rayfield:Notify({
            Title = "Update Available!",
            Content = "New version " .. latestVersion .. " is available. Click to update!",
            Duration = 10,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Later",
                    Callback = function()
                    end
                },
                Download = {
                    Name = "Update Now",
                    Callback = function()
                        local success, newScript = pcall(function()
                            return game:HttpGet(GitHubRaw)
                        end)
                        
                        if success and newScript then
                            writefile("FishItHub_Rayfield_" .. latestVersion .. ".lua", newScript)
                            Rayfield:Notify({
                                Title = "Update Complete!",
                                Content = "New version saved as FishItHub_Rayfield_" .. latestVersion .. ".lua",
                                Duration = 5,
                                Image = 4483362458
                            })
                        end
                    end
                },
            },
        })
    end
end

spawn(CheckForUpdates)

-- Game Specific Variables
local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes", 10)
local Events = ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage:WaitForChild("Events", 10)

-- Find all game-specific remotes and modules
local FishingModule
local TradeModule
local WeatherModule
local EventModule

for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("ModuleScript") then
        if string.find(obj.Name:lower(), "fish") then
            FishingModule = require(obj)
        elseif string.find(obj.Name:lower(), "trade") then
            TradeModule = require(obj)
        elseif string.find(obj.Name:lower(), "weather") then
            WeatherModule = require(obj)
        elseif string.find(obj.Name:lower(), "event") then
            EventModule = require(obj)
        end
    end
end

-- Try to find remote events with multiple possible names
local CastLineRemote = Remotes:FindFirstChild("CastLine") or Remotes:FindFirstChild("CastFishingLine") or Remotes:FindFirstChild("FishingCast")
local CatchFishRemote = Remotes:FindFirstChild("CatchFish") or Remotes:FindFirstChild("ReelIn") or Remotes:FindFirstChild("Catch")
local PerfectCatchRemote = Remotes:FindFirstChild("PerfectCatch") or Remotes:FindFirstChild("Perfect") or Remotes:FindFirstChild("PerfectReel")
local SellFishRemote = Events:FindFirstChild("SellFish") or Events:FindFirstChild("SellAllFish") or Events:FindFirstChild("Sell")
local UpgradeRodRemote = Events:FindFirstChild("UpgradeRod") or Events:FindFirstChild("Upgrade") or Events:FindFirstChild("RodUpgrade")
local BuyBaitRemote = Events:FindFirstChild("BuyBait") or Events:FindFirstChild("PurchaseBait") or Events:FindFirstChild("BaitPurchase")
local RepairRodRemote = Events:FindFirstChild("RepairRod") or Events:FindFirstChild("Repair") or Events:FindFirstChild("RodRepair")
local RepairBoatRemote = Events:FindFirstChild("RepairBoat") or Events:FindFirstChild("BoatRepair")
local CollectChestRemote = Events:FindFirstChild("CollectChest") or Events:FindFirstChild("OpenChest") or Events:FindFirstChild("ChestCollect")
local ClaimDailyRemote = Events:FindFirstChild("ClaimDaily") or Events:FindFirstChild("DailyReward") or Events:FindFirstChild("DailyClaim")
local RankClaimRemote = Events:FindFirstChild("ClaimRank") or Events:FindFirstChild("RankReward") or Events:FindFirstChild("RankClaim")
local UpgradeBackpackRemote = Events:FindFirstChild("UpgradeBackpack") or Events:FindFirstChild("BackpackUpgrade")
local BuyRodRemote = Events:FindFirstChild("BuyRod") or Events:FindFirstChild("PurchaseRod") or Events:FindFirstChild("RodPurchase")
local TradeRequestRemote = Events:FindFirstChild("TradeRequest") or Events:FindFirstChild("RequestTrade")
local TradeAcceptRemote = Events:FindFirstChild("TradeAccept") or Events:FindFirstChild("AcceptTrade")
local TradeAddItemRemote = Events:FindFirstChild("TradeAddItem") or Events:FindFirstChild("AddTradeItem")
local TradeRemoveItemRemote = Events:FindFirstChild("TradeRemoveItem") or Events:FindFirstChild("RemoveTradeItem")
local TradeConfirmRemote = Events:FindFirstChild("TradeConfirm") or Events:FindFirstChild("ConfirmTrade")
local BuyWeatherRemote = Events:FindFirstChild("BuyWeather") or Events:FindFirstChild("PurchaseWeather")
local TeleportEventRemote = Events:FindFirstChild("TeleportEvent") or Events:FindFirstChild("EventTeleport")

-- UI Variables
local Window = Rayfield:CreateWindow({
    Name = "NIKZZ SCRIPT - FISH IT | v" .. Version,
    LoadingTitle = "NIKZZ SCRIPT - FISH IT",
    LoadingSubtitle = "by Nikzz Xit - REVISED",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FishItHubConfig",
        FileName = "FishItHub_Rayfield"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Fish It Hub",
        Subtitle = "Key System",
        Note = "No key required",
        FileName = "FishItHubKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = "Hello"
    }
})

-- Global Variables
local FishingEnabled = false
local AutoCastEnabled = false
local AutoCatchEnabled = false
local AutoPerfectCatchEnabled = false
local AutoSellEnabled = false
local AutoBaitSelectEnabled = false
local AutoCollectChestsEnabled = false
local AutoUpgradeRodEnabled = false
local AutoRepairRodEnabled = false
local AutoRepairBoatEnabled = false
local InfiniteOxygenEnabled = false
local NoclipEnabled = false
local FlyEnabled = false
local ESPFishEnabled = false
local ESPPlayersEnabled = false
local ESPChestsEnabled = false
local AutoBuyBaitEnabled = false
local AutoEquipRodEnabled = false
local AutoCollectDailyEnabled = false
local AutoRankClaimEnabled = false
local AutoUpgradeBackpackEnabled = false
local AutoBuyRodEnabled = false
local AutoEquipBestRodEnabled = false
local AutoEquipBestBaitEnabled = false
local AntiAFKEnabled = false
local LowGraphicsEnabled = false
local FPSUnlockerEnabled = false
local FishingRadarEnabled = false
local DisableEffectsEnabled = false
local AutoInstantEnabled = false
local GhostHackEnabled = false
local WalkOnWaterEnabled = false
local AutoTradeEnabled = false
local AutoAcceptTradeEnabled = false
local AutoBuyWeatherEnabled = false
local AutoTeleportEventEnabled = false

local FishingDelay = 1
local WalkSpeed = 16
local JumpPower = 50
local FlySpeed = 50
local SelectedBait = "Worm"
local SelectedRod = "Basic Rod"
local SelectedLocation = "Spawn"
local CustomLocations = {}
local TeleportRoute = {}
local ChestSpots = {}
local LoopChestSpotsEnabled = false
local AccentColor = Color3.fromRGB(0, 162, 255)
local UIHidden = false
local OriginalWalkSpeed = 16
local OriginalJumpPower = 50
local OriginalGraphicsQuality = 10
local CurrentFPS = 0
local CurrentPing = 0

local FishESP = {}
local PlayerESP = {}
local ChestESP = {}
local FishingConnection = nil
local ChestConnection = nil
local AFKConnection = nil
local NoclipConnection = nil
local FlyConnection = nil
local OxygenConnection = nil
local GraphicsConnection = nil
local FPSConnection = nil
local InfoConnection = nil
local RadarConnection = nil
local WaterWalkConnection = nil
local TradeConnection = nil
local WeatherConnection = nil
local EventConnection = nil

-- Utility Functions
local function Notify(title, content, duration)
    Rayfield:Notify({
        Title = title,
        Content = content,
        Duration = duration or 5,
        Image = 4483362458
    })
end

local function GetPlayer()
    return game.Players.LocalPlayer
end

local function GetCharacter()
    local player = GetPlayer()
    return player.Character or player.CharacterAdded:Wait()
end

local function GetHumanoid()
    local character = GetCharacter()
    return character:FindFirstChildOfClass("Humanoid")
end

local function GetRootPart()
    local character = GetCharacter()
    return character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 3)
end

local function TeleportTo(position)
    local rootPart = GetRootPart()
    if rootPart then
        rootPart.CFrame = CFrame.new(position)
    end
end

local function TeleportToCFrame(cframe)
    local rootPart = GetRootPart()
    if rootPart then
        rootPart.CFrame = cframe
    end
end

local function GetPlayers()
    return game.Players:GetPlayers()
end

local function GetFishingRod()
    local character = GetCharacter()
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and string.find(tool.Name:lower(), "rod") then
            return tool
        end
    end
    return nil
end

local function GetBait()
    local backpack = GetPlayer().Backpack
    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") and string.find(item.Name:lower(), "bait") then
            return item
        end
    end
    return nil
end

local function GetBestRod()
    local backpack = GetPlayer().Backpack
    local bestRod = nil
    local bestValue = 0
    
    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") and string.find(item.Name:lower(), "rod") then
            local handle = item:FindFirstChild("Handle")
            if handle then
                local durability = handle:FindFirstChild("Durability") or handle:FindFirstChild("Value")
                if durability and durability.Value > bestValue then
                    bestValue = durability.Value
                    bestRod = item
                end
            end
        end
    end
    
    return bestRod
end

local function GetBestBait()
    local backpack = GetPlayer().Backpack
    local bestBait = nil
    local bestValue = 0
    
    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") and string.find(item.Name:lower(), "bait") then
            local handle = item:FindFirstChild("Handle")
            if handle then
                local effectiveness = handle:FindFirstChild("Effectiveness") or handle:FindFirstChild("Value")
                if effectiveness and effectiveness.Value > bestValue then
                    bestValue = effectiveness.Value
                    bestBait = item
                end
            end
        end
    end
    
    return bestBait
end

local function EquipTool(tool)
    if tool then
        GetHumanoid():EquipTool(tool)
    end
end

local function CastLine()
    if CastLineRemote then
        CastLineRemote:FireServer()
    elseif FishingModule and FishingModule.CastLine then
        FishingModule.CastLine()
    else
        -- Fallback: Simulate click if remote not found
        local rod = GetFishingRod()
        if rod then
            rod:Activate()
        end
    end
end

local function CatchFish()
    if CatchFishRemote then
        CatchFishRemote:FireServer()
    elseif FishingModule and FishingModule.CatchFish then
        FishingModule.CatchFish()
    else
        -- Fallback: Simulate key press if remote not found
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end
end

local function PerfectCatch()
    if PerfectCatchRemote then
        PerfectCatchRemote:FireServer()
    elseif FishingModule and FishingModule.PerfectCatch then
        FishingModule.PerfectCatch()
    else
        -- Perfect catch simulation
        task.wait(0.2) -- Perfect timing
        CatchFish()
    end
end

local function SellFish()
    if SellFishRemote then
        SellFishRemote:FireServer()
    end
end

local function UpgradeRod()
    if UpgradeRodRemote then
        UpgradeRodRemote:FireServer()
    end
end

local function BuyBait(baitType, amount)
    if BuyBaitRemote then
        BuyBaitRemote:FireServer(baitType, amount or 1)
    end
end

local function RepairRod()
    if RepairRodRemote then
        RepairRodRemote:FireServer()
    end
end

local function RepairBoat()
    if RepairBoatRemote then
        RepairBoatRemote:FireServer()
    end
end

local function CollectChest(chest)
    if CollectChestRemote then
        CollectChestRemote:FireServer(chest)
    end
end

local function ClaimDaily()
    if ClaimDailyRemote then
        ClaimDailyRemote:FireServer()
    end
end

local function ClaimRank()
    if RankClaimRemote then
        RankClaimRemote:FireServer()
    end
end

local function UpgradeBackpack()
    if UpgradeBackpackRemote then
        UpgradeBackpackRemote:FireServer()
    end
end

local function BuyRod(rodType)
    if BuyRodRemote then
        BuyRodRemote:FireServer(rodType)
    end
end

local function GetRodDurability()
    local rod = GetFishingRod()
    if rod then
        local handle = rod:FindFirstChild("Handle")
        if handle then
            local durability = handle:FindFirstChild("Durability") or handle:FindFirstChild("Value")
            if durability then
                return durability.Value
            end
        end
    end
    return 100
end

local function IsInWater()
    local character = GetCharacter()
    local rootPart = GetRootPart()
    if rootPart then
        local position = rootPart.Position
        return position.Y < 0 -- Simple check, might need adjustment
    end
    return false
end

local function FindChests()
    local chests = {}
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and string.find(obj.Name:lower(), "chest") then
            table.insert(chests, obj)
        end
    end
    return chests
end

local function FindFishingSpots()
    local spots = {}
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Part") and string.find(obj.Name:lower(), "fish") then
            table.insert(spots, obj)
        end
    end
    return spots
end

local function CreateESP(object, color, name)
    local highlight = Instance.new("Highlight")
    highlight.Name = name
    highlight.Adornee = object
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = CoreGui
    
    return highlight
end

local function RemoveESP(espName)
    for _, item in ipairs(CoreGui:GetChildren()) do
        if item.Name == espName then
            item:Destroy()
        end
    end
end

local function ClearAllESP()
    for _, esp in ipairs(FishESP) do
        if esp then
            esp:Destroy()
        end
    end
    FishESP = {}
    
    for _, esp in ipairs(PlayerESP) do
        if esp then
            esp:Destroy()
        end
    end
    PlayerESP = {}
    
    for _, esp in ipairs(ChestESP) do
        if esp then
            esp:Destroy()
        end
    end
    ChestESP = {}
end

local function ToggleESP(objects, enabled, espTable, color, baseName)
    if enabled then
        for _, obj in ipairs(objects) do
            if obj and obj.Parent then
                local esp = CreateESP(obj, color, baseName .. obj.Name)
                table.insert(espTable, esp)
            end
        end
    else
        for _, esp in ipairs(espTable) do
            if esp then
                esp:Destroy()
            end
        end
        espTable = {}
    end
end

local function UpdateFishESP()
    ToggleESP(Workspace:GetChildren(), ESPFishEnabled, FishESP, Color3.fromRGB(0, 255, 0), "FishESP_")
end

local function UpdatePlayerESP()
    ToggleESP(GetPlayers(), ESPPlayersEnabled, PlayerESP, Color3.fromRGB(255, 0, 0), "PlayerESP_")
end

local function UpdateChestESP()
    ToggleESP(FindChests(), ESPChestsEnabled, ChestESP, Color3.fromRGB(255, 215, 0), "ChestESP_")
end

local function ToggleNoclip(enabled)
    if enabled then
        if NoclipConnection then
            NoclipConnection:Disconnect()
        end
        
        NoclipConnection = RunService.Stepped:Connect(function()
            local character = GetCharacter()
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end
    end
end

local function ToggleFly(enabled)
    if enabled then
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.PlatformStand = true
        end
        
        if FlyConnection then
            FlyConnection:Disconnect()
        end
        
        local rootPart = GetRootPart()
        local velocity = Instance.new("BodyVelocity")
        velocity.Name = "FlyVelocity"
        velocity.MaxForce = Vector3.new(100000, 100000, 100000)
        velocity.Velocity = Vector3.new(0, 0, 0)
        velocity.Parent = rootPart
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            if not rootPart or not rootPart.Parent then
                if FlyConnection then
                    FlyConnection:Disconnect()
                end
                return
            end
            
            local camera = Workspace.CurrentCamera
            local direction = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                direction = direction - Vector3.new(0, 1, 0)
            end
            
            if direction.Magnitude > 0 then
                direction = direction.Unit * FlySpeed
            end
            
            velocity.Velocity = direction
        end)
    else
        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end
        
        local rootPart = GetRootPart()
        if rootPart then
            local velocity = rootPart:FindFirstChild("FlyVelocity")
            if velocity then
                velocity:Destroy()
            end
        end
        
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

local function ToggleInfiniteOxygen(enabled)
    if enabled then
        if OxygenConnection then
            OxygenConnection:Disconnect()
        end
        
        OxygenConnection = RunService.Heartbeat:Connect(function()
            local character = GetCharacter()
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.OxygenLevel = humanoid.MaxOxygenLevel
                end
            end
        end)
    else
        if OxygenConnection then
            OxygenConnection:Disconnect()
            OxygenConnection = nil
        end
    end
end

local function ToggleAntiAFK(enabled)
    if enabled then
        if AFKConnection then
            AFKConnection:Disconnect()
        end
        
        AFKConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
        end)
    else
        if AFKConnection then
            AFKConnection:Disconnect()
            AFKConnection = nil
        end
    end
end

local function ToggleLowGraphics(enabled)
    if enabled then
        if GraphicsConnection then
            GraphicsConnection:Disconnect()
        end
        
        -- Store original settings
        OriginalGraphicsQuality = settings().Rendering.QualityLevel
        
        -- Set low graphics
        settings().Rendering.QualityLevel = 1
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
        
        GraphicsConnection = RunService.RenderStepped:Connect(function()
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
                    obj.Material = Enum.Material.Plastic
                    obj.Reflectance = 0
                end
            end
        end)
    else
        if GraphicsConnection then
            GraphicsConnection:Disconnect()
            GraphicsConnection = nil
        end
        
        -- Restore original settings
        settings().Rendering.QualityLevel = OriginalGraphicsQuality
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 1000000
    end
end

local function ToggleFPSUnlocker(enabled)
    if enabled then
        if FPSConnection then
            FPSConnection:Disconnect()
        end
        
        setfpscap(999)
        
        FPSConnection = RunService.RenderStepped:Connect(function()
            setfpscap(999)
        end)
    else
        if FPSConnection then
            FPSConnection:Disconnect()
            FPSConnection = nil
        end
        
        setfpscap(60)
    end
end

local function ToggleFishingRadar(enabled)
    if enabled then
        if RadarConnection then
            RadarConnection:Disconnect()
        end
        
        RadarConnection = RunService.Heartbeat:Connect(function()
            -- Activate fishing radar effect
            if FishingModule and FishingModule.ActivateRadar then
                FishingModule.ActivateRadar()
            end
        end)
    else
        if RadarConnection then
            RadarConnection:Disconnect()
            RadarConnection = nil
        end
    end
end

local function ToggleGhostHack(enabled)
    if enabled then
        -- Enable ghost hack (noclip through objects)
        ToggleNoclip(true)
        
        -- Make character transparent
        local character = GetCharacter()
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0.5
                end
            end
        end
    else
        ToggleNoclip(false)
        
        -- Restore character visibility
        local character = GetCharacter()
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end
        end
    end
end

local function ToggleWalkOnWater(enabled)
    if enabled then
        if WaterWalkConnection then
            WaterWalkConnection:Disconnect()
        end
        
        WaterWalkConnection = RunService.Heartbeat:Connect(function()
            local rootPart = GetRootPart()
            if rootPart and rootPart.Position.Y < 0 then
                -- Keep character above water
                rootPart.CFrame = CFrame.new(rootPart.Position.X, 5, rootPart.Position.Z)
            end
        end)
    else
        if WaterWalkConnection then
            WaterWalkConnection:Disconnect()
            WaterWalkConnection = nil
        end
    end
end

local function ToggleDisableEffects(enabled)
    if enabled then
        -- Disable special effects for rare/secret fish
        if FishingModule and FishingModule.DisableEffects then
            FishingModule.DisableEffects()
        end
    else
        -- Re-enable effects
        if FishingModule and FishingModule.EnableEffects then
            FishingModule.EnableEffects()
        end
    end
end

local function ToggleAutoTrade(enabled)
    if enabled then
        if TradeConnection then
            TradeConnection:Disconnect()
        end
        
        TradeConnection = RunService.Heartbeat:Connect(function()
            -- Auto accept trade requests
            if AutoAcceptTradeEnabled then
                if TradeModule and TradeModule.AcceptAllTrades then
                    TradeModule.AcceptAllTrades()
                elseif TradeAcceptRemote then
                    -- Simulate accepting all trade requests
                    -- This would need to be adjusted based on actual game implementation
                end
            end
            
            -- Auto complete trades
            if TradeModule and TradeModule.CompleteTrade then
                TradeModule.CompleteTrade()
            end
        end)
    else
        if TradeConnection then
            TradeConnection:Disconnect()
            TradeConnection = nil
        end
    end
end

local function ToggleAutoBuyWeather(enabled)
    if enabled then
        if WeatherConnection then
            WeatherConnection:Disconnect()
        end
        
        WeatherConnection = RunService.Heartbeat:Connect(function()
            -- Auto buy weather effects
            if WeatherModule and WeatherModule.BuyAllWeather then
                WeatherModule.BuyAllWeather()
            elseif BuyWeatherRemote then
                -- Simulate buying all weather effects
                BuyWeatherRemote:FireServer("ClearSkies")
                BuyWeatherRemote:FireServer("Overcast")
                BuyWeatherRemote:FireServer("Rain")
                BuyWeatherRemote:FireServer("Thunderstorm")
                BuyWeatherRemote:FireServer("VoidStorm")
                BuyWeatherRemote:FireServer("RedTides")
            end
        end)
    else
        if WeatherConnection then
            WeatherConnection:Disconnect()
            WeatherConnection = nil
        end
    end
end

local function ToggleAutoTeleportEvent(enabled)
    if enabled then
        if EventConnection then
            EventConnection:Disconnect()
        end
        
        EventConnection = RunService.Heartbeat:Connect(function()
            -- Check for active events and teleport to them
            local activeEvents = {}
            
            if EventModule and EventModule.GetActiveEvents then
                activeEvents = EventModule.GetActiveEvents()
            end
            
            if #activeEvents > 0 then
                -- Teleport to the first active event
                if TeleportEventRemote then
                    TeleportEventRemote:FireServer(activeEvents[1])
                elseif EventModule and EventModule.TeleportToEvent then
                    EventModule.TeleportToEvent(activeEvents[1])
                end
            end
        end)
    else
        if EventConnection then
            EventConnection:Disconnect()
            EventConnection = nil
        end
    end
end

local function ResetCharacter()
    local humanoid = GetHumanoid()
    if humanoid then
        humanoid.Health = 0
    end
end

local function ServerHop()
    local servers = {}
    local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100")
    local data = game:GetService("HttpService"):JSONDecode(req)
    
    for _, server in ipairs(data.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            table.insert(servers, server.id)
        end
    end
    
    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
    else
        Notify("Server Hop", "No servers available to hop to.", 5)
    end
end

local function RejoinServer()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end

-- Fishing Functions
local function StartFishing()
    if FishingConnection then
        FishingConnection:Disconnect()
    end
    
    FishingConnection = RunService.Heartbeat:Connect(function()
        if not FishingEnabled then
            FishingConnection:Disconnect()
            return
        end
        
        -- Auto Cast
        if AutoCastEnabled then
            CastLine()
        end
        
        -- Auto Catch
        if AutoCatchEnabled then
            if AutoPerfectCatchEnabled then
                PerfectCatch()
            else
                CatchFish()
            end
        end
        
        -- Auto Instant Catch
        if AutoInstantEnabled then
            task.wait(0.05) -- Minimal delay for instant catch
            CatchFish()
        end
        
        -- Auto Sell
        if AutoSellEnabled then
            SellFish()
        end
        
        -- Auto Bait Select
        if AutoBaitSelectEnabled then
            local bait = GetBait()
            if bait then
                EquipTool(bait)
            end
        end
        
        -- Auto Repair Rod
        if AutoRepairRodEnabled then
            local durability = GetRodDurability()
            if durability < 20 then -- Threshold for repair
                RepairRod()
            end
        end
        
        task.wait(FishingDelay)
    end)
end

local function StopFishing()
    if FishingConnection then
        FishingConnection:Disconnect()
        FishingConnection = nil
    end
end

-- Chest Collection Functions
local function StartChestCollection()
    if ChestConnection then
        ChestConnection:Disconnect()
    end
    
    ChestConnection = RunService.Heartbeat:Connect(function()
        if not AutoCollectChestsEnabled then
            ChestConnection:Disconnect()
            return
        end
        
        local chests = FindChests()
        for _, chest in ipairs(chests) do
            local rootPart = GetRootPart()
            if rootPart and chest:FindFirstChild("PrimaryPart") then
                local distance = (rootPart.Position - chest.PrimaryPart.Position).Magnitude
                if distance < 50 then
                    CollectChest(chest)
                end
            end
        end
        
        task.wait(1)
    end)
end

local function StopChestCollection()
    if ChestConnection then
        ChestConnection:Disconnect()
        ChestConnection = nil
    end
end

-- Auto Upgrade Functions
local function StartAutoUpgrade()
    if AutoUpgradeRodEnabled then
        UpgradeRod()
    end
    
    if AutoUpgradeBackpackEnabled then
        UpgradeBackpack()
    end
    
    if AutoBuyRodEnabled then
        BuyRod(SelectedRod)
    end
    
    if AutoBuyBaitEnabled then
        BuyBait(SelectedBait, 10)
    end
    
    if AutoEquipBestRodEnabled then
        local bestRod = GetBestRod()
        EquipTool(bestRod)
    end
    
    if AutoEquipBestBaitEnabled then
        local bestBait = GetBestBait()
        EquipTool(bestBait)
    end
    
    if AutoCollectDailyEnabled then
        ClaimDaily()
    end
    
    if AutoRankClaimEnabled then
        ClaimRank()
    end
end

-- Teleport Functions
local function TeleportToLocation(locationName)
    local locations = {
        Spawn = CFrame.new(0, 10, 0),
        Market = CFrame.new(100, 10, 0),
        UpgradeShop = CFrame.new(-100, 10, 0),
        FishingSpot1 = CFrame.new(50, 5, 50),
        FishingSpot2 = CFrame.new(-50, 5, 50),
        FishingSpot3 = CFrame.new(50, 5, -50),
        HiddenSpot1 = CFrame.new(200, 5, 200),
        HiddenSpot2 = CFrame.new(-200, 5, 200),
        FishermanIsland = CFrame.new(300, 10, 300),
        StingrayShores = CFrame.new(400, 10, 400),
        Ocean = CFrame.new(500, 5, 500),
        KohanaIsland = CFrame.new(600, 20, 600),
        Volcano = CFrame.new(700, 30, 700),
        CoralReefs = CFrame.new(800, 5, 800),
        EsotericDepths = CFrame.new(900, -10, 900),
        TropicalGrove = CFrame.new(1000, 10, 1000),
        CraterIsland = CFrame.new(1100, 15, 1100),
        LostIsle = CFrame.new(1200, 10, 1200),
        TreasureRoom = CFrame.new(1300, 10, 1300),
        SisyphusStatue = CFrame.new(1400, 10, 1400)
    }
    
    if locations[locationName] then
        TeleportToCFrame(locations[locationName])
        Notify("Teleport", "Teleported to " .. locationName, 3)
    elseif CustomLocations[locationName] then
        TeleportToCFrame(CustomLocations[locationName])
        Notify("Teleport", "Teleported to " .. locationName, 3)
    else
        Notify("Teleport", "Location not found: " .. locationName, 3)
    end
end

local function SaveCustomLocation(name)
    local rootPart = GetRootPart()
    if rootPart then
        CustomLocations[name] = rootPart.CFrame
        Notify("Location Saved", "Saved as: " .. name, 3)
        return true
    end
    return false
end

local function DeleteCustomLocation(name)
    if CustomLocations[name] then
        CustomLocations[name] = nil
        Notify("Location Deleted", "Deleted: " .. name, 3)
        return true
    end
    return false
end

-- Info Display Functions
local function StartInfoDisplay()
    if InfoConnection then
        InfoConnection:Disconnect()
    end
    
    InfoConnection = RunService.RenderStepped:Connect(function()
        -- Update FPS
        CurrentFPS = math.floor(1 / RunService.RenderStepped:Wait())
        
        -- Update Ping
        local stats = Stats:FindFirstChild("PerformanceStats")
        if stats then
            local ping = stats:FindFirstChild("Ping")
            if ping then
                CurrentPing = math.floor(ping:GetValue())
            end
        end
        
        -- Update window title with info
        Window:SetWindowName("NIKZZ SCRIPT - FISH IT | v" .. Version .. " | FPS: " .. CurrentFPS .. " | Ping: " .. CurrentPing .. "ms")
    end)
end

local function StopInfoDisplay()
    if InfoConnection then
        InfoConnection:Disconnect()
        InfoConnection = nil
    end
    Window:SetWindowName("NIKZZ SCRIPT - FISH IT | v" .. Version)
end

-- UI Creation
local AutoFarmTab = Window:CreateTab("Auto Farm", 4483362458)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local UserTab = Window:CreateTab("User", 4483362458)
local TradeTab = Window:CreateTab("Trade", 4483362458)
local ServerTab = Window:CreateTab("Server", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- Auto Farm Section
local FishingSection = AutoFarmTab:CreateSection("Fishing")
local AutoFishingToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Fishing",
    CurrentValue = false,
    Flag = "AutoFishingToggle",
    Callback = function(value)
        FishingEnabled = value
        if value then
            StartFishing()
        else
            StopFishing()
        end
    end
})

local AutoCastToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Cast",
    CurrentValue = false,
    Flag = "AutoCastToggle",
    Callback = function(value)
        AutoCastEnabled = value
    end
})

local AutoCatchToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Catch",
    CurrentValue = false,
    Flag = "AutoCatchToggle",
    Callback = function(value)
        AutoCatchEnabled = value
    end
})

local AutoPerfectCatchToggle = AutoFarmTab:CreateToggle({
    Name = "Always Perfect Catch",
    CurrentValue = false,
    Flag = "AutoPerfectCatchToggle",
    Callback = function(value)
        AutoPerfectCatchEnabled = value
    end
})

local FishingDelaySlider = AutoFarmTab:CreateSlider({
    Name = "Fishing Delay",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "seconds",
    CurrentValue = 1,
    Flag = "FishingDelaySlider",
    Callback = function(value)
        FishingDelay = value
    end
})

local FishingRadarToggle = AutoFarmTab:CreateToggle({
    Name = "Fishing Radar",
    CurrentValue = false,
    Flag = "FishingRadarToggle",
    Callback = function(value)
        FishingRadarEnabled = value
        ToggleFishingRadar(value)
    end
})

local DisableEffectsToggle = AutoFarmTab:CreateToggle({
    Name = "Disable Effects",
    CurrentValue = false,
    Flag = "DisableEffectsToggle",
    Callback = function(value)
        DisableEffectsEnabled = value
        ToggleDisableEffects(value)
    end
})

local AutoInstantToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Instant Catch",
    CurrentValue = false,
    Flag = "AutoInstantToggle",
    Callback = function(value)
        AutoInstantEnabled = value
    end
})

local AutoSellToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = false,
    Flag = "AutoSellToggle",
    Callback = function(value)
        AutoSellEnabled = value
    end
})

local AutoBaitSelectToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Bait Select",
    CurrentValue = false,
    Flag = "AutoBaitSelectToggle",
    Callback = function(value)
        AutoBaitSelectEnabled = value
    end
})

local AutoRepairRodToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Repair Rod",
    CurrentValue = false,
    Flag = "AutoRepairRodToggle",
    Callback = function(value)
        AutoRepairRodEnabled = value
    end
})

local AutoRepairBoatToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Repair Boat",
    CurrentValue = false,
    Flag = "AutoRepairBoatToggle",
    Callback = function(value)
        AutoRepairBoatEnabled = value
    end
})

local AutoCollectChestsToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Collect Chests",
    CurrentValue = false,
    Flag = "AutoCollectChestsToggle",
    Callback = function(value)
        AutoCollectChestsEnabled = value
        if value then
            StartChestCollection()
        else
            StopChestCollection()
        end
    end
})

local UpgradeSection = AutoFarmTab:CreateSection("Auto Upgrade")
local AutoUpgradeRodToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Upgrade Rod",
    CurrentValue = false,
    Flag = "AutoUpgradeRodToggle",
    Callback = function(value)
        AutoUpgradeRodEnabled = value
    end
})

local AutoUpgradeBackpackToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Upgrade Backpack",
    CurrentValue = false,
    Flag = "AutoUpgradeBackpackToggle",
    Callback = function(value)
        AutoUpgradeBackpackEnabled = value
    end
})

local AutoBuyRodToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Buy Rod",
    CurrentValue = false,
    Flag = "AutoBuyRodToggle",
    Callback = function(value)
        AutoBuyRodEnabled = value
    end
})

local AutoBuyBaitToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Buy Bait",
    CurrentValue = false,
    Flag = "AutoBuyBaitToggle",
    Callback = function(value)
        AutoBuyBaitEnabled = value
    end
})

local AutoEquipBestRodToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Equip Best Rod",
    CurrentValue = false,
    Flag = "AutoEquipBestRodToggle",
    Callback = function(value)
        AutoEquipBestRodEnabled = value
    end
})

local AutoEquipBestBaitToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Equip Best Bait",
    CurrentValue = false,
    Flag = "AutoEquipBestBaitToggle",
    Callback = function(value)
        AutoEquipBestBaitEnabled = value
    end
})

local AutoCollectDailyToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Collect Daily",
    CurrentValue = false,
    Flag = "AutoCollectDailyToggle",
    Callback = function(value)
        AutoCollectDailyEnabled = value
    end
})

local AutoRankClaimToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Claim Rank",
    CurrentValue = false,
    Flag = "AutoRankClaimToggle",
    Callback = function(value)
        AutoRankClaimEnabled = value
    end
})

local BaitDropdown = AutoFarmTab:CreateDropdown({
    Name = "Select Bait",
    Options = {"Worm", "Shrimp", "Squid", "Special Bait", "Golden Bait"},
    CurrentOption = "Worm",
    Flag = "BaitDropdown",
    Callback = function(option)
        SelectedBait = option
    end
})

local RodDropdown = AutoFarmTab:CreateDropdown({
    Name = "Select Rod",
    Options = {"Basic Rod", "Wooden Rod", "Iron Rod", "Golden Rod", "Diamond Rod", "Legendary Rod"},
    CurrentOption = "Basic Rod",
    Flag = "RodDropdown",
    Callback = function(option)
        SelectedRod = option
    end
})

local UpgradeButton = AutoFarmTab:CreateButton({
    Name = "Run Upgrades Once",
    Callback = function()
        StartAutoUpgrade()
    end
})

-- Teleport Section
local LocationsSection = TeleportTab:CreateSection("Locations")
local LocationDropdown = TeleportTab:CreateDropdown({
    Name = "Select Location",
    Options = {
        "Spawn", "Market", "UpgradeShop", "FishingSpot1", "FishingSpot2", "FishingSpot3", 
        "HiddenSpot1", "HiddenSpot2", "FishermanIsland", "StingrayShores", "Ocean", 
        "KohanaIsland", "Volcano", "CoralReefs", "EsotericDepths", "TropicalGrove", 
        "CraterIsland", "LostIsle", "TreasureRoom", "SisyphusStatue"
    },
    CurrentOption = "Spawn",
    Flag = "LocationDropdown",
    Callback = function(option)
        SelectedLocation = option
    end
})

local TeleportButton = TeleportTab:CreateButton({
    Name = "Teleport to Location",
    Callback = function()
        TeleportToLocation(SelectedLocation)
    end
})

local CustomLocationsSection = TeleportTab:CreateSection("Custom Locations")
local SaveLocationInput = TeleportTab:CreateInput({
    Name = "Location Name",
    PlaceholderText = "Enter location name",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        -- This is just for input, saving happens on button click
    end
})

local SaveLocationButton = TeleportTab:CreateButton({
    Name = "Save Current Location",
    Callback = function()
        local name = SaveLocationInput:GetValue()
        if name and name ~= "" then
            SaveCustomLocation(name)
            
            -- Update dropdown
            local options = {}
            for k, _ in pairs(CustomLocations) do
                table.insert(options, k)
            end
            CustomLocationDropdown:Refresh(options, true)
        else
            Notify("Error", "Please enter a location name", 3)
        end
    end
})

local CustomLocationDropdown = TeleportTab:CreateDropdown({
    Name = "Custom Locations",
    Options = {},
    CurrentOption = "",
    Flag = "CustomLocationDropdown",
    Callback = function(option)
        SelectedLocation = option
    end
})

local DeleteLocationButton = TeleportTab:CreateButton({
    Name = "Delete Selected Location",
    Callback = function()
        if SelectedLocation and CustomLocations[SelectedLocation] then
            DeleteCustomLocation(SelectedLocation)
            
            -- Update dropdown
            local options = {}
            for k, _ in pairs(CustomLocations) do
                table.insert(options, k)
            end
            CustomLocationDropdown:Refresh(options, true)
        else
            Notify("Error", "No location selected or location doesn't exist", 3)
        end
    end
})

-- User Section
local MovementSection = UserTab:CreateSection("Movement")
local WalkSpeedSlider = UserTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(value)
        WalkSpeed = value
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
})

local JumpPowerSlider = UserTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 200},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 50,
    Flag = "JumpPowerSlider",
    Callback = function(value)
        JumpPower = value
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.JumpPower = value
        end
    end
})

local FlyToggle = UserTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(value)
        FlyEnabled = value
        ToggleFly(value)
    end
})

local FlySpeedSlider = UserTab:CreateSlider({
    Name = "Fly Speed",
    Range = {20, 200},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = 50,
    Flag = "FlySpeedSlider",
    Callback = function(value)
        FlySpeed = value
    end
})

local NoclipToggle = UserTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(value)
        NoclipEnabled = value
        ToggleNoclip(value)
    end
})

local GhostHackToggle = UserTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = false,
    Flag = "GhostHackToggle",
    Callback = function(value)
        GhostHackEnabled = value
        ToggleGhostHack(value)
    end
})

local WalkOnWaterToggle = UserTab:CreateToggle({
    Name = "Walk on Water",
    CurrentValue = false,
    Flag = "WalkOnWaterToggle",
    Callback = function(value)
        WalkOnWaterEnabled = value
        ToggleWalkOnWater(value)
    end
})

local InfiniteJumpToggle = UserTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJumpToggle",
    Callback = function(value)
        if value then
            UserInputService.JumpRequest:Connect(function()
                local humanoid = GetHumanoid()
                if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end
})

local InfiniteOxygenToggle = UserTab:CreateToggle({
    Name = "Infinite Oxygen",
    CurrentValue = false,
    Flag = "InfiniteOxygenToggle",
    Callback = function(value)
        InfiniteOxygenEnabled = value
        ToggleInfiniteOxygen(value)
    end
})

local ESPSection = UserTab:CreateSection("ESP")
local ESPFishToggle = UserTab:CreateToggle({
    Name = "Fish ESP",
    CurrentValue = false,
    Flag = "ESPFishToggle",
    Callback = function(value)
        ESPFishEnabled = value
        UpdateFishESP()
    end
})

local ESPPlayersToggle = UserTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "ESPPlayersToggle",
    Callback = function(value)
        ESPPlayersEnabled = value
        UpdatePlayerESP()
    end
})

local ESPChestsToggle = UserTab:CreateToggle({
    Name = "Chest ESP",
    CurrentValue = false,
    Flag = "ESPChestsToggle",
    Callback = function(value)
        ESPChestsEnabled = value
        UpdateChestESP()
    end
})

local ClearESPButton = UserTab:CreateButton({
    Name = "Clear All ESP",
    Callback = function()
        ClearAllESP()
        ESPFishEnabled = false
        ESPPlayersEnabled = false
        ESPChestsEnabled = false
        ESPFishToggle:Set(false)
        ESPPlayersToggle:Set(false)
        ESPChestsToggle:Set(false)
    end
})

-- Trade Section
local TradeAutoSection = TradeTab:CreateSection("Auto Trade")
local AutoTradeToggle = TradeTab:CreateToggle({
    Name = "Auto Trade",
    CurrentValue = false,
    Flag = "AutoTradeToggle",
    Callback = function(value)
        AutoTradeEnabled = value
        ToggleAutoTrade(value)
    end
})

local AutoAcceptTradeToggle = TradeTab:CreateToggle({
    Name = "Auto Accept Trade",
    CurrentValue = false,
    Flag = "AutoAcceptTradeToggle",
    Callback = function(value)
        AutoAcceptTradeEnabled = value
    end
})

-- Server Section
local ServerFeaturesSection = ServerTab:CreateSection("Server Features")
local AutoBuyWeatherToggle = ServerTab:CreateToggle({
    Name = "Auto Buy Weather",
    CurrentValue = false,
    Flag = "AutoBuyWeatherToggle",
    Callback = function(value)
        AutoBuyWeatherEnabled = value
        ToggleAutoBuyWeather(value)
    end
})

local AutoTeleportEventToggle = ServerTab:CreateToggle({
    Name = "Auto Teleport to Events",
    CurrentValue = false,
    Flag = "AutoTeleportEventToggle",
    Callback = function(value)
        AutoTeleportEventEnabled = value
        ToggleAutoTeleportEvent(value)
    end
})

local AntiAFKToggle = ServerTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFKToggle",
    Callback = function(value)
        AntiAFKEnabled = value
        ToggleAntiAFK(value)
    end
})

local ServerActionsSection = ServerTab:CreateSection("Server Actions")
local RejoinButton = ServerTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        RejoinServer()
    end
})

local ServerHopButton = ServerTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        ServerHop()
    end
})

local ResetCharacterButton = ServerTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        ResetCharacter()
    end
})

-- Settings Section
local GraphicsSection = SettingsTab:CreateSection("Graphics")
local LowGraphicsToggle = SettingsTab:CreateToggle({
    Name = "Low Graphics Mode",
    CurrentValue = false,
    Flag = "LowGraphicsToggle",
    Callback = function(value)
        LowGraphicsEnabled = value
        ToggleLowGraphics(value)
    end
})

local FPSUnlockerToggle = SettingsTab:CreateToggle({
    Name = "Unlock FPS (120+)",
    CurrentValue = false,
    Flag = "FPSUnlockerToggle",
    Callback = function(value)
        FPSUnlockerEnabled = value
        ToggleFPSUnlocker(value)
    end
})

local InfoDisplayToggle = SettingsTab:CreateToggle({
    Name = "Show FPS & Ping",
    CurrentValue = false,
    Flag = "InfoDisplayToggle",
    Callback = function(value)
        if value then
            StartInfoDisplay()
        else
            StopInfoDisplay()
        end
    end
})

local UISection = SettingsTab:CreateSection("UI Settings")
local UIThemeDropdown = SettingsTab:CreateDropdown({
    Name = "UI Theme",
    Options = {"Dark", "Light", "Blue", "Red", "Green", "Purple"},
    CurrentOption = "Dark",
    Flag = "UIThemeDropdown",
    Callback = function(option)
        AccentColor = Color3.fromRGB(0, 162, 255) -- Default blue
        if option == "Light" then
            AccentColor = Color3.fromRGB(240, 240, 240)
        elseif option == "Red" then
            AccentColor = Color3.fromRGB(255, 0, 0)
        elseif option == "Green" then
            AccentColor = Color3.fromRGB(0, 255, 0)
        elseif option == "Purple" then
            AccentColor = Color3.fromRGB(162, 0, 255)
        end
        -- Note: Rayfield UI doesn't have a direct way to change theme color in this version
    end
})

local HideUIButton = SettingsTab:CreateButton({
    Name = "Hide/Show UI",
    Callback = function()
        UIHidden = not UIHidden
        Rayfield:Toggle(not UIHidden)
    end
})

local DestroyUIButton = SettingsTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end
})

-- Initialize UI
local function InitializeUI()
    -- Set initial values
    local humanoid = GetHumanoid()
    if humanoid then
        WalkSpeedSlider:Set(humanoid.WalkSpeed)
        JumpPowerSlider:Set(humanoid.JumpPower)
    end
    
    -- Start info display if enabled
    if InfoDisplayToggle.CurrentValue then
        StartInfoDisplay()
    end
    
    Notify("Fish It Hub Loaded", "Successfully loaded Fish It Hub v" .. Version, 5)
end

-- Initialize the UI
InitializeUI()

-- Cleanup on script termination
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(character)
    -- Reapply settings when character respawns
    task.wait(2) -- Wait for character to fully load
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = WalkSpeed
        humanoid.JumpPower = JumpPower
    end
    
    if FlyEnabled then
        ToggleFly(true)
    end
    
    if NoclipEnabled then
        ToggleNoclip(true)
    end
    
    if GhostHackEnabled then
        ToggleGhostHack(true)
    end
    
    if WalkOnWaterEnabled then
        ToggleWalkOnWater(true)
    end
    
    if InfiniteOxygenEnabled then
        ToggleInfiniteOxygen(true)
    end
end)

-- Auto-execute features based on saved settings
if AutoFishingToggle.CurrentValue then
    StartFishing()
end

if AutoCollectChestsToggle.CurrentValue then
    StartChestCollection()
end

if FishingRadarToggle.CurrentValue then
    ToggleFishingRadar(true)
end

if DisableEffectsToggle.CurrentValue then
    ToggleDisableEffects(true)
end

if AutoTradeToggle.CurrentValue then
    ToggleAutoTrade(true)
end

if AutoBuyWeatherToggle.CurrentValue then
    ToggleAutoBuyWeather(true)
end

if AutoTeleportEventToggle.CurrentValue then
    ToggleAutoTeleportEvent(true)
end

if LowGraphicsToggle.CurrentValue then
    ToggleLowGraphics(true)
end

if FPSUnlockerToggle.CurrentValue then
    ToggleFPSUnlocker(true)
end

if AntiAFKToggle.CurrentValue then
    ToggleAntiAFK(true)
end

-- Final notification
Notify("Fish It Hub Ready", "All features are now available!", 3)
