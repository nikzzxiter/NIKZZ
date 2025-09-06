-- Fish It Hub 2025 by Nikzz Xit
-- Version: 2.5.0
-- Last Updated: September 2025
-- Rayfield UI Version - Fixed Implementation

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Player References
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Game Specific Variables (Updated for Fish It September 2025)
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
local Events = ReplicatedStorage:WaitForChild("Events", 10)

-- Find actual remote events for Fish It September 2025
local CastLineRemote = Remotes:FindFirstChild("CastLine") or Remotes:FindFirstChild("CastFishingLine") or Remotes:FindFirstChild("FishingCast")
local CatchFishRemote = Remotes:FindFirstChild("CatchFish") or Remotes:FindFirstChild("ReelIn") or Remotes:FindFirstChild("CatchFishRequest")
local SellFishRemote = Events:FindFirstChild("SellFish") or Events:FindFirstChild("SellAllFish") or Events:FindFirstChild("FishSell")
local UpgradeRodRemote = Events:FindFirstChild("UpgradeRod") or Events:FindFirstChild("UpgradeFishingRod") or Events:FindFirstChild("RodUpgrade")
local BuyBaitRemote = Events:FindFirstChild("BuyBait") or Events:FindFirstChild("PurchaseBait") or Events:FindFirstChild("BaitPurchase")
local RepairRodRemote = Events:FindFirstChild("RepairRod") or Events:FindFirstChild("RepairFishingRod") or Events:FindFirstChild("RodRepair")
local RepairBoatRemote = Events:FindFirstChild("RepairBoat") or Events:FindFirstChild("BoatRepair") or Events:FindFirstChild("RepairFishingBoat")
local CollectChestRemote = Events:FindFirstChild("CollectChest") or Events:FindFirstChild("OpenChest") or Events:FindFirstChild("ChestCollect")
local ClaimDailyRemote = Events:FindFirstChild("ClaimDaily") or Events:FindFirstChild("DailyReward") or Events:FindFirstChild("DailyClaim")
local RankClaimRemote = Events:FindFirstChild("ClaimRank") or Events:FindFirstChild("RankReward") or Events:FindFirstChild("RankClaim")
local UpgradeBackpackRemote = Events:FindFirstChild("UpgradeBackpack") or Events:FindFirstChild("BackpackUpgrade") or Events:FindFirstChild("IncreaseBackpackSize")
local BuyRodRemote = Events:FindFirstChild("BuyRod") or Events:FindFirstChild("PurchaseRod") or Events:FindFirstChild("RodPurchase")

-- Auto Update System
local Version = "2.5.0"
local GitHubRaw = "https://raw.githubusercontent.com/NikzzXit/FishItHub/main/FishItHub_Rayfield.lua"
local GitHubVersion = "https://raw.githubusercontent.com/NikzzXit/FishItHub/main/version_rayfield.txt"

local function CheckForUpdates()
    local success, latestVersion = pcall(function()
        return game:HttpGet(GitHubVersion)
    end)
    
    if success and latestVersion and latestVersion:gsub("%s+", "") ~= Version then
        Rayfield:Notify({
            Title = "Update Available!",
            Content = "New version " .. latestVersion .. " is available.",
            Duration = 10,
            Image = 4483362458,
        })
    end
end

spawn(CheckForUpdates)

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
    return Players.LocalPlayer
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
    return Players:GetPlayers()
end

local function GetFishingRod()
    local character = GetCharacter()
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and (string.find(tool.Name:lower(), "rod") or string.find(tool.Name:lower(), "fishing")) then
            return tool
        end
    end
    return nil
end

local function GetBait()
    local backpack = GetPlayer().Backpack
    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") and (string.find(item.Name:lower(), "bait") or string.find(item.Name:lower(), "worm") or string.find(item.Name:lower(), "lure")) then
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
        if item:IsA("Tool") and (string.find(item.Name:lower(), "rod") or string.find(item.Name:lower(), "fishing")) then
            local handle = item:FindFirstChild("Handle")
            if handle then
                local durability = handle:FindFirstChild("Durability") or handle:FindFirstChild("Value") or handle:FindFirstChild("Strength")
                if durability and durability.Value > bestValue then
                    bestValue = durability.Value
                    bestRod = item
                elseif not durability then
                    -- If no durability value, assume higher rarity rods are better
                    if string.find(item.Name:lower(), "gold") or string.find(item.Name:lower(), "diamond") then
                        bestRod = item
                    end
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
        if item:IsA("Tool") and (string.find(item.Name:lower(), "bait") or string.find(item.Name:lower(), "worm") or string.find(item.Name:lower(), "lure")) then
            local handle = item:FindFirstChild("Handle")
            if handle then
                local effectiveness = handle:FindFirstChild("Effectiveness") or handle:FindFirstChild("Value") or handle:FindFirstChild("Power")
                if effectiveness and effectiveness.Value > bestValue then
                    bestValue = effectiveness.Value
                    bestBait = item
                elseif not effectiveness then
                    -- If no effectiveness value, assume higher rarity baits are better
                    if string.find(item.Name:lower(), "gold") or string.find(item.Name:lower(), "premium") then
                        bestBait = item
                    end
                end
            end
        end
    end
    
    return bestBait
end

local function EquipTool(tool)
    if tool and GetHumanoid() then
        GetHumanoid():EquipTool(tool)
    end
end

-- Real implementation functions for Fish It September 2025
local function CastLine()
    if CastLineRemote then
        if CastLineRemote:IsA("RemoteEvent") then
            CastLineRemote:FireServer()
        elseif CastLineRemote:IsA("RemoteFunction") then
            CastLineRemote:InvokeServer()
        end
    else
        -- Fallback: Try to find fishing rod and activate it
        local rod = GetFishingRod()
        if rod then
            rod:Activate()
        end
    end
end

local function CatchFish()
    if CatchFishRemote then
        if CatchFishRemote:IsA("RemoteEvent") then
            CatchFishRemote:FireServer()
        elseif CatchFishRemote:IsA("RemoteFunction") then
            CatchFishRemote:InvokeServer()
        end
    else
        -- Fallback: Try to press E key to catch fish
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end
end

local function SellFish()
    if SellFishRemote then
        if SellFishRemote:IsA("RemoteEvent") then
            SellFishRemote:FireServer()
        elseif SellFishRemote:IsA("RemoteFunction") then
            SellFishRemote:InvokeServer()
        end
    end
end

local function UpgradeRod()
    if UpgradeRodRemote then
        if UpgradeRodRemote:IsA("RemoteEvent") then
            UpgradeRodRemote:FireServer()
        elseif UpgradeRodRemote:IsA("RemoteFunction") then
            UpgradeRodRemote:InvokeServer()
        end
    end
end

local function BuyBait(baitType, amount)
    if BuyBaitRemote then
        if BuyBaitRemote:IsA("RemoteEvent") then
            BuyBaitRemote:FireServer(baitType, amount or 1)
        elseif BuyBaitRemote:IsA("RemoteFunction") then
            BuyBaitRemote:InvokeServer(baitType, amount or 1)
        end
    end
end

local function RepairRod()
    if RepairRodRemote then
        if RepairRodRemote:IsA("RemoteEvent") then
            RepairRodRemote:FireServer()
        elseif RepairRodRemote:IsA("RemoteFunction") then
            RepairRodRemote:InvokeServer()
        end
    end
end

local function RepairBoat()
    if RepairBoatRemote then
        if RepairBoatRemote:IsA("RemoteEvent") then
            RepairBoatRemote:FireServer()
        elseif RepairBoatRemote:IsA("RemoteFunction") then
            RepairBoatRemote:InvokeServer()
        end
    end
end

local function CollectChest(chest)
    if CollectChestRemote then
        if CollectChestRemote:IsA("RemoteEvent") then
            CollectChestRemote:FireServer(chest)
        elseif CollectChestRemote:IsA("RemoteFunction") then
            CollectChestRemote:InvokeServer(chest)
        end
    end
end

local function ClaimDaily()
    if ClaimDailyRemote then
        if ClaimDailyRemote:IsA("RemoteEvent") then
            ClaimDailyRemote:FireServer()
        elseif ClaimDailyRemote:IsA("RemoteFunction") then
            ClaimDailyRemote:InvokeServer()
        end
    end
end

local function ClaimRank()
    if RankClaimRemote then
        if RankClaimRemote:IsA("RemoteEvent") then
            RankClaimRemote:FireServer()
        elseif RankClaimRemote:IsA("RemoteFunction") then
            RankClaimRemote:InvokeServer()
        end
    end
end

local function UpgradeBackpack()
    if UpgradeBackpackRemote then
        if UpgradeBackpackRemote:IsA("RemoteEvent") then
            UpgradeBackpackRemote:FireServer()
        elseif UpgradeBackpackRemote:IsA("RemoteFunction") then
            UpgradeBackpackRemote:InvokeServer()
        end
    end
end

local function BuyRod(rodType)
    if BuyRodRemote then
        if BuyRodRemote:IsA("RemoteEvent") then
            BuyRodRemote:FireServer(rodType)
        elseif BuyRodRemote:IsA("RemoteFunction") then
            BuyRodRemote:InvokeServer(rodType)
        end
    end
end

local function GetRodDurability()
    local rod = GetFishingRod()
    if rod then
        local handle = rod:FindFirstChild("Handle")
        if handle then
            local durability = handle:FindFirstChild("Durability") or handle:FindFirstChild("Value") or handle:FindFirstChild("Health")
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
        if obj:IsA("Model") and (string.find(obj.Name:lower(), "chest") or string.find(obj.Name:lower(), "box") or string.find(obj.Name:lower(), "treasure")) then
            table.insert(chests, obj)
        end
    end
    return chests
end

local function FindFishingSpots()
    local spots = {}
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Part") and (string.find(obj.Name:lower(), "fish") or string.find(obj.Name:lower(), "water") or string.find(obj.Name:lower(), "spot")) then
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
    local fishObjects = {}
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and (string.find(obj.Name:lower(), "fish") or string.find(obj.Name:lower(), "shark") or string.find(obj.Name:lower(), "animal")) then
            table.insert(fishObjects, obj)
        end
    end
    ToggleESP(fishObjects, ESPFishEnabled, FishESP, Color3.fromRGB(0, 255, 0), "FishESP_")
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
        if not rootPart then return end
        
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
        
        AFKConnection = Players.LocalPlayer.Idled:Connect(function()
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

local function ResetCharacter()
    local humanoid = GetHumanoid()
    if humanoid then
        humanoid.Health = 0
    end
end

local function ServerHop()
    local servers = {}
    local success, req = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100")
    end)
    
    if success and req then
        local data = HttpService:JSONDecode(req)
        
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
    else
        Notify("Server Hop", "Failed to get server list.", 5)
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
            CatchFish()
        end
        
        -- Auto Perfect Catch (timing-based, needs adjustment)
        if AutoPerfectCatchEnabled then
            task.wait(0.2) -- Perfect timing delay
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
            if rootPart and (chest:FindFirstChild("PrimaryPart") or chest:FindFirstChild("Handle")) then
                local chestPart = chest.PrimaryPart or chest.Handle
                local distance = (rootPart.Position - chestPart.Position).Magnitude
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
        HiddenSpot2 = CFrame.new(-200, 5, 200)
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
    end
end

local function StartTeleportRoute()
    if #TeleportRoute == 0 then
        Notify("Teleport Route", "No locations in route", 3)
        return
    end
    
    local index = 1
    while #TeleportRoute > 0 and AutoCollectChestsEnabled do
        TeleportToCFrame(TeleportRoute[index])
        task.wait(3) -- Wait at each location
        
        index = index + 1
        if index > #TeleportRoute then
            index = 1
        end
    end
end

local function StartChestLoop()
    if #ChestSpots == 0 then
        Notify("Chest Loop", "No chest spots saved", 3)
        return
    end
    
    local index = 1
    while LoopChestSpotsEnabled do
        TeleportToCFrame(ChestSpots[index])
        task.wait(2) -- Wait at each chest spot
        
        index = index + 1
        if index > #ChestSpots then
            index = 1
        end
    end
end

-- Create UI Window
local Window = Rayfield:CreateWindow({
    Name = "Fish It Hub 2025 | v" .. Version,
    LoadingTitle = "Fish It Hub 2025",
    LoadingSubtitle = "by Nikzz Xit",
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
})

-- Create Tabs
local FishingTab = Window:CreateTab("🎣 Fishing", 4483362458)
local ToolsTab = Window:CreateTab("🛠 Tools", 4483362458)
local TeleportTab = Window:CreateTab("🚀 Teleport", 4483362458)
local ExtraTab = Window:CreateTab("💎 Extra", 4483362458)
local SettingsTab = Window:CreateTab("⚙ Settings", 4483362458)

-- Fishing Tab
FishingTab:CreateToggle({
    Name = "Auto Fish",
    CurrentValue = false,
    Flag = "AutoFishToggle",
    Callback = function(Value)
        FishingEnabled = Value
        if Value then
            StartFishing()
            Notify("Auto Fish", "Enabled", 3)
        else
            StopFishing()
            Notify("Auto Fish", "Disabled", 3)
        end
    end,
})

FishingTab:CreateToggle({
    Name = "Auto Cast",
    CurrentValue = false,
    Flag = "AutoCastToggle",
    Callback = function(Value)
        AutoCastEnabled = Value
        Notify("Auto Cast", Value and "Enabled" or "Disabled", 3)
    end,
})

FishingTab:CreateToggle({
    Name = "Auto Catch",
    CurrentValue = false,
    Flag = "AutoCatchToggle",
    Callback = function(Value)
        AutoCatchEnabled = Value
        Notify("Auto Catch", Value and "Enabled" or "Disabled", 3)
    end,
})

FishingTab:CreateToggle({
    Name = "Auto Perfect Catch",
    CurrentValue = false,
    Flag = "AutoPerfectCatchToggle",
    Callback = function(Value)
        AutoPerfectCatchEnabled = Value
        Notify("Auto Perfect Catch", Value and "Enabled" or "Disabled", 3)
    end,
})

FishingTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = false,
    Flag = "AutoSellToggle",
    Callback = function(Value)
        AutoSellEnabled = Value
        Notify("Auto Sell", Value and "Enabled" or "Disabled", 3)
    end,
})

FishingTab:CreateToggle({
    Name = "Auto Bait Select",
    CurrentValue = false,
    Flag = "AutoBaitSelectToggle",
    Callback = function(Value)
        AutoBaitSelectEnabled = Value
        Notify("Auto Bait Select", Value and "Enabled" or "Disabled", 3)
    end,
})

FishingTab:CreateButton({
    Name = "Manual Cast",
    Callback = function()
        CastLine()
        Notify("Manual Cast", "Casting line...", 3)
    end,
})

FishingTab:CreateSlider({
    Name = "Fishing Delay",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "seconds",
    CurrentValue = 1,
    Flag = "FishingDelaySlider",
    Callback = function(Value)
        FishingDelay = Value
    end,
})

FishingTab:CreateLabel("Rod Durability: " .. GetRodDurability() .. "%")

FishingTab:CreateToggle({
    Name = "Auto Repair Rod",
    CurrentValue = false,
    Flag = "AutoRepairRodToggle",
    Callback = function(Value)
        AutoRepairRodEnabled = Value
        Notify("Auto Repair Rod", Value and "Enabled" or "Disabled", 3)
    end,
})

-- Tools Tab
ToolsTab:CreateToggle({
    Name = "Auto Collect Chests",
    CurrentValue = false,
    Flag = "AutoCollectChestsToggle",
    Callback = function(Value)
        AutoCollectChestsEnabled = Value
        if Value then
            StartChestCollection()
            Notify("Auto Collect Chests", "Enabled", 3)
        else
            StopChestCollection()
            Notify("Auto Collect Chests", "Disabled", 3)
        end
    end,
})

ToolsTab:CreateToggle({
    Name = "Auto Upgrade Rod",
    CurrentValue = false,
    Flag = "AutoUpgradeRodToggle",
    Callback = function(Value)
        AutoUpgradeRodEnabled = Value
        Notify("Auto Upgrade Rod", Value and "Enabled" or "Disabled", 3)
    end,
})

ToolsTab:CreateToggle({
    Name = "Auto Repair Boat",
    CurrentValue = false,
    Flag = "AutoRepairBoatToggle",
    Callback = function(Value)
        AutoRepairBoatEnabled = Value
        Notify("Auto Repair Boat", Value and "Enabled" or "Disabled", 3)
    end,
})

ToolsTab:CreateToggle({
    Name = "Infinite Oxygen",
    CurrentValue = false,
    Flag = "InfiniteOxygenToggle",
    Callback = function(Value)
        InfiniteOxygenEnabled = Value
        ToggleInfiniteOxygen(Value)
        Notify("Infinite Oxygen", Value and "Enabled" or "Disabled", 3)
    end,
})

ToolsTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "speed",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        WalkSpeed = Value
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end,
})

ToolsTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 200},
    Increment = 1,
    Suffix = "power",
    CurrentValue = 50,
    Flag = "JumpPowerSlider",
    Callback = function(Value)
        JumpPower = Value
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.JumpPower = Value
        end
    end,
})

ToolsTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        NoclipEnabled = Value
        ToggleNoclip(Value)
        Notify("Noclip", Value and "Enabled" or "Disabled", 3)
    end,
})

ToolsTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        FlyEnabled = Value
        ToggleFly(Value)
        Notify("Fly", Value and "Enabled" or "Disabled", 3)
    end,
})

ToolsTab:CreateSlider({
    Name = "Fly Speed",
    Range = {20, 200},
    Increment = 5,
    Suffix = "speed",
    CurrentValue = 50,
    Flag = "FlySpeedSlider",
    Callback = function(Value)
        FlySpeed = Value
    end,
})

ToolsTab:CreateToggle({
    Name = "ESP Fish",
    CurrentValue = false,
    Flag = "ESPFishToggle",
    Callback = function(Value)
        ESPFishEnabled = Value
        UpdateFishESP()
        Notify("ESP Fish", Value and "Enabled" or "Disabled", 3)
    end,
})

ToolsTab:CreateToggle({
    Name = "ESP Players",
    CurrentValue = false,
    Flag = "ESPPlayersToggle",
    Callback = function(Value)
        ESPPlayersEnabled = Value
        UpdatePlayerESP()
        Notify("ESP Players", Value and "Enabled" or "Disabled", 3)
    end,
})

ToolsTab:CreateToggle({
    Name = "ESP Chests",
    CurrentValue = false,
    Flag = "ESPChestsToggle",
    Callback = function(Value)
        ESPChestsEnabled = Value
        UpdateChestESP()
        Notify("ESP Chests", Value and "Enabled" or "Disabled", 3)
    end,
})

ToolsTab:CreateToggle({
    Name = "Auto Buy Bait",
    CurrentValue = false,
    Flag = "AutoBuyBaitToggle",
    Callback = function(Value)
        AutoBuyBaitEnabled = Value
        Notify("Auto Buy Bait", Value and "Enabled" or "Disabled", 3)
    end,
})

ToolsTab:CreateToggle({
    Name = "Auto Equip Rod",
    CurrentValue = false,
    Flag = "AutoEquipRodToggle",
    Callback = function(Value)
        AutoEquipRodEnabled = Value
        Notify("Auto Equip Rod", Value and "Enabled" or "Disabled", 3)
    end,
})

-- Teleport Tab
local TeleportLocations = {"Spawn", "Market", "UpgradeShop", "FishingSpot1", "FishingSpot2", "FishingSpot3", "HiddenSpot1", "HiddenSpot2"}
TeleportTab:CreateDropdown({
    Name = "Teleport Locations",
    Options = TeleportLocations,
    CurrentOption = "Spawn",
    Flag = "TeleportLocationsDropdown",
    Callback = function(Option)
        SelectedLocation = Option
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Selected Location",
    Callback = function()
        TeleportToLocation(SelectedLocation)
    end,
})

TeleportTab:CreateInput({
    Name = "Save Custom Location",
    PlaceholderText = "Location Name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        SaveCustomLocation(Text)
    end,
})

TeleportTab:CreateInput({
    Name = "Teleport to Custom Location",
    PlaceholderText = "Location Name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        TeleportToLocation(Text)
    end,
})

TeleportTab:CreateInput({
    Name = "Add to Teleport Route",
    PlaceholderText = "Location Name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if CustomLocations[Text] then
            table.insert(TeleportRoute, CustomLocations[Text])
            Notify("Teleport Route", "Added: " .. Text, 3)
        else
            Notify("Teleport Route", "Location not found: " .. Text, 3)
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Start Teleport Route",
    Callback = function()
        StartTeleportRoute()
    end,
})

TeleportTab:CreateButton({
    Name = "Clear Teleport Route",
    Callback = function()
        TeleportRoute = {}
        Notify("Teleport Route", "Route cleared", 3)
    end,
})

TeleportTab:CreateButton({
    Name = "Save Current Chest Spot",
    Callback = function()
        local rootPart = GetRootPart()
        if rootPart then
            table.insert(ChestSpots, rootPart.CFrame)
            Notify("Chest Spots", "Spot saved", 3)
        end
    end,
})

TeleportTab:CreateToggle({
    Name = "Loop Chest Spots",
    CurrentValue = false,
    Flag = "LoopChestSpotsToggle",
    Callback = function(Value)
        LoopChestSpotsEnabled = Value
        if Value then
            StartChestLoop()
            Notify("Chest Loop", "Enabled", 3)
        else
            Notify("Chest Loop", "Disabled", 3)
        end
    end,
})

-- Extra Tab
ExtraTab:CreateToggle({
    Name = "Auto Collect Daily Reward",
    CurrentValue = false,
    Flag = "AutoCollectDailyToggle",
    Callback = function(Value)
        AutoCollectDailyEnabled = Value
        Notify("Auto Daily Reward", Value and "Enabled" or "Disabled", 3)
    end,
})

ExtraTab:CreateToggle({
    Name = "Auto Rank Claim",
    CurrentValue = false,
    Flag = "AutoRankClaimToggle",
    Callback = function(Value)
        AutoRankClaimEnabled = Value
        Notify("Auto Rank Claim", Value and "Enabled" or "Disabled", 3)
    end,
})

ExtraTab:CreateToggle({
    Name = "Auto Upgrade Backpack",
    CurrentValue = false,
    Flag = "AutoUpgradeBackpackToggle",
    Callback = function(Value)
        AutoUpgradeBackpackEnabled = Value
        Notify("Auto Upgrade Backpack", Value and "Enabled" or "Disabled", 3)
    end,
})

ExtraTab:CreateToggle({
    Name = "Auto Buy Rod",
    CurrentValue = false,
    Flag = "AutoBuyRodToggle",
    Callback = function(Value)
        AutoBuyRodEnabled = Value
        Notify("Auto Buy Rod", Value and "Enabled" or "Disabled", 3)
    end,
})

ExtraTab:CreateToggle({
    Name = "Auto Equip Best Rod",
    CurrentValue = false,
    Flag = "AutoEquipBestRodToggle",
    Callback = function(Value)
        AutoEquipBestRodEnabled = Value
        Notify("Auto Equip Best Rod", Value and "Enabled" or "Disabled", 3)
    end,
})

ExtraTab:CreateToggle({
    Name = "Auto Equip Best Bait",
    CurrentValue = false,
    Flag = "AutoEquipBestBaitToggle",
    Callback = function(Value)
        AutoEquipBestBaitEnabled = Value
        Notify("Auto Equip Best Bait", Value and "Enabled" or "Disabled", 3)
    end,
})

ExtraTab:CreateDropdown({
    Name = "Select Bait Type",
    Options = {"Worm", "Shrimp", "Squid", "Special", "Golden"},
    CurrentOption = "Worm",
    Flag = "BaitTypeDropdown",
    Callback = function(Option)
        SelectedBait = Option
    end,
})

ExtraTab:CreateDropdown({
    Name = "Select Rod Type",
    Options = {"Basic Rod", "Wooden Rod", "Steel Rod", "Golden Rod", "Diamond Rod"},
    CurrentOption = "Basic Rod",
    Flag = "RodTypeDropdown",
    Callback = function(Option)
        SelectedRod = Option
    end,
})

-- Settings Tab
SettingsTab:CreateColorPicker({
    Name = "UI Accent Color",
    Color = Color3.fromRGB(0, 162, 255),
    Flag = "ColorPicker",
    Callback = function(Value)
        AccentColor = Value
        Rayfield:Notify({
            Title = "Color Changed",
            Content = "UI accent color updated",
            Duration = 3,
            Image = 4483362458
        })
    end
})

SettingsTab:CreateInput({
    Name = "Custom Command",
    PlaceholderText = "Command",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text == "reset" then
            ResetCharacter()
        elseif Text == "hop" then
            ServerHop()
        elseif Text == "rejoin" then
            RejoinServer()
        elseif Text == "hide" then
            Rayfield:Destroy()
        end
    end,
})

SettingsTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFKToggle",
    Callback = function(Value)
        AntiAFKEnabled = Value
        ToggleAntiAFK(Value)
        Notify("Anti AFK", Value and "Enabled" or "Disabled", 3)
    end,
})

SettingsTab:CreateKeybind({
    Name = "Hide/Show UI",
    CurrentKeybind = "RightShift",
    HoldToInteract = false,
    Flag = "HideUIKeybind",
    Callback = function(Keybind)
        UIHidden = not UIHidden
        Rayfield:Notify({
            Title = "UI Toggled",
            Content = UIHidden and "UI Hidden" or "UI Visible",
            Duration = 2,
            Image = 4483362458
        })
    end,
})

SettingsTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        ResetCharacter()
        Notify("Reset", "Character reset", 3)
    end,
})

SettingsTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        ServerHop()
        Notify("Server Hop", "Hopping to new server...", 3)
    end,
})

SettingsTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        RejoinServer()
        Notify("Rejoin", "Rejoining server...", 3)
    end,
})

SettingsTab:CreateToggle({
    Name = "Low Graphics Mode",
    CurrentValue = false,
    Flag = "LowGraphicsToggle",
    Callback = function(Value)
        LowGraphicsEnabled = Value
        ToggleLowGraphics(Value)
        Notify("Low Graphics", Value and "Enabled" or "Disabled", 3)
    end,
})

SettingsTab:CreateToggle({
    Name = "FPS Unlocker",
    CurrentValue = false,
    Flag = "FPSUnlockerToggle",
    Callback = function(Value)
        FPSUnlockerEnabled = Value
        ToggleFPSUnlocker(Value)
        Notify("FPS Unlocker", Value and "Enabled" or "Disabled", 3)
    end,
})

SettingsTab:CreateLabel("Fish It Hub 2025 by Nikzz Xit")
SettingsTab:CreateLabel("Version: " .. Version)
SettingsTab:CreateLabel("Thanks for using!")

-- Initialize
local function Initialize()
    -- Set initial walk speed and jump power
    local humanoid = GetHumanoid()
    if humanoid then
        humanoid.WalkSpeed = WalkSpeed
        humanoid.JumpPower = JumpPower
    end
    
    -- Show welcome notification
    Rayfield:Notify({
        Title = "Fish It Hub 2025 Loaded",
        Content = "by Nikzz Xit | Version " .. Version,
        Duration = 5,
        Image = 4483362458
    })
end

-- Character added event to reapply settings
Player.CharacterAdded:Connect(function()
    local humanoid = GetHumanoid()
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
end)

-- Run initialization
Initialize()

-- Close UI binding
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        Rayfield:Destroy()
    end
end)

-- Load configuration
Rayfield:LoadConfiguration()
