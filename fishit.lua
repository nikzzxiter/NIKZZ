-- NIKZZMODDER.lua
-- Script Profesional untuk Roblox Fishing Game
-- Dibuat oleh Nikzz7z
-- Versi: 1.0.0
-- Tanggal: 2025-09-09

-- Base UI Rayfield dengan Async
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
-- Membuat window utama
local Window = Rayfield:CreateWindow({
    Name = "NIKZZMODDER - Ultimate Fishing Mod",
    LoadingTitle = "Memuat NIKZZMODDER...",
    LoadingSubtitle = "by Nikzz7z",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NIKZZMODDER",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Fungsi Logging
local function log(message, level)
    level = level or "INFO"
    local timestamp = os.date("%H:%M:%S")
    print(string.format("[NIKZZMODDER][%s][%s] %s", timestamp, level, message))
end

-- Fungsi Error Handling Async
local function safeAsync(callback, ...)
    task.spawn(function()
        local success, result = pcall(callback, ...)
        if not success then
            log("Error: " .. tostring(result), "ERROR")
        end
    end)
end

-- Fungsi Debounce
local function debounce(func, delay)
    local isRunning = false
    return function(...)
        if isRunning then return end
        isRunning = true
        task.spawn(function()
            func(...)
            task.wait(delay or 0.1)
            isRunning = false
        end)
    end
end

-- Fungsi Throttle
local function throttle(func, delay)
    local lastCall = 0
    return function(...)
        local now = tick()
        if now - lastCall >= delay then
            lastCall = now
            task.spawn(func, ...)
        end
    end
end

-- Inisialisasi Modul Penting
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Referensi Remote dan Module dari MODULE.txt
local Remotes = {
    -- Fishing Remotes
    FishCaught = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("FishCaught"),
    FishingCompleted = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("FishingCompleted"),
    FishingStopped = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("FishingStopped"),
    BaitSpawned = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("BaitSpawned"),
    PlayFishingEffect = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("PlayFishingEffect"),
    ReplicateCutscene = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("ReplicateCutscene"),
    StopCutscene = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("StopCutscene"),
    ActivateEnchantingAltar = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("ActivateEnchantingAltar"),
    UpdateEnchantState = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("UpdateEnchantState"),
    RollEnchant = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("RollEnchant"),
    IncrementOnboardingStep = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("IncrementOnboardingStep"),
    UpdateChargeState = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("UpdateChargeState"),
    PlayVFX = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("PlayVFX"),
    FishingMinigameChanged = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("FishingMinigameChanged"),
    ObtainedNewFishNotification = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("ObtainedNewFishNotification"),
    RollSkinCrate = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("RollSkinCrate"),
    EquipRodSkin = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("EquipRodSkin"),
    UnequipRodSkin = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("UnequipRodSkin"),
    EquipItem = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("EquipItem"),
    UnequipItem = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("UnequipItem"),
    EquipBait = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("EquipBait"),
    FavoriteItem = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("FavoriteItem"),
    FavoriteStateChanged = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("FavoriteStateChanged"),
    UnequipToolFromHotbar = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("UnequipToolFromHotbar"),
    EquipToolFromHotbar = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("EquipToolFromHotbar"),
    CancelPrompt = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("CancelPrompt"),
    FeatureUnlocked = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("FeatureUnlocked"),
    ChangeSetting = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("ChangeSetting"),
    BoatChanged = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("BoatChanged"),
    VerifyGroupReward = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("VerifyGroupReward"),
    RecievedDailyRewards = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("RecievedDailyRewards"),
    ReconnectPlayer = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("ReconnectPlayer"),
    ClaimNotification = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("ClaimNotification"),
    BlackoutScreen = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("BlackoutScreen"),
    ElevatorStateUpdated = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("ElevatorStateUpdated"),
    SpinWheel = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("SpinWheel"),
    
    -- Function Remotes
    PurchaseFishingRod = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("PurchaseFishingRod"),
    PurchaseBait = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("PurchaseBait"),
    PurchaseGear = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("PurchaseGear"),
    SellItem = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("SellItem"),
    SellAllItems = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("SellAllItems"),
    UpdateAutoFishingState = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("UpdateAutoFishingState"),
    ChargeFishingRod = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("ChargeFishingRod"),
    CancelFishingInputs = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("CancelFishingInputs"),
    RequestFishingMinigameStarted = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("RequestFishingMinigameStarted"),
    UpdateAutoSellThreshold = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("UpdateAutoSellThreshold"),
    UpdateFishingRadar = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("UpdateFishingRadar"),
    PurchaseSkinCrate = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("PurchaseSkinCrate"),
    PurchaseBoat = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("PurchaseBoat"),
    SpawnBoat = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("SpawnBoat"),
    DespawnBoat = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("DespawnBoat"),
    ConsumePotion = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("ConsumePotion"),
    RedeemChristmasItems = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("RedeemChristmasItems"),
    EquipOxygenTank = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("EquipOxygenTank"),
    UnequipOxygenTank = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("UnequipOxygenTank"),
    ClaimDailyLogin = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("ClaimDailyLogin"),
    CanSendTrade = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("CanSendTrade"),
    InitiateTrade = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("InitiateTrade"),
    AwaitTradeResponse = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("AwaitTradeResponse"),
    RedeemCode = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("RedeemCode"),
    LoadVFX = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("LoadVFX"),
    RequestSpin = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("RequestSpin"),
    PromptFavoriteGame = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("PromptFavoriteGame"),
    ActivateQuestLine = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF:WaitForChild("ActivateQuestLine"),
    
    -- Cmdr Remotes (untuk teleport)
    CmdrFunction = ReplicatedStorage.CmdrClient:WaitForChild("CmdrFunction"),
    CmdrEvent = ReplicatedStorage.CmdrClient:WaitForChild("CmdrEvent"),
    
    -- Game Pass Utility
    UserOwnsGamePass = ReplicatedStorage.Shared.GamePassUtility:WaitForChild("UserOwnsGamePass"),
    PromptGamePassPurchase = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE:WaitForChild("PromptGamePassPurchase"),
}

-- Daftar Rod dari MODULE.txt
local Rods = {
    "!!! Starter Rod",
    "!!! Lucky Rod",
    "!!! Gold Rod",
    "!!! Chrome Rod",
    "!!! Lava Rod",
    "!!! Hyper Rod",
    "!!! Magma Rod",
    "!!! Carbon Rod",
    "!!! Ice Rod",
    "!!! Midnight Rod",
    "!!! Gingerbread Rod",
    "!!! Candy Cane Rod",
    "!!! Christmas Tree Rod",
    "!!! Demascus Rod",
    "!!! Frozen Rod",
    "!!! Cute Rod",
    "!!! Angelic Rod",
    "!!! Astral Rod",
    "!!! Ares Rod",
    "!!! Ghoul Rod",
    "!!! Forsaken",
    "!!! Red Matter",
    "!!! Lightsaber",
    "!!! Crystalized",
    "!!! Earthly",
    "!!! Neptune's Trident",
    "!!! Polarized",
    "!!! Angler Rod",
    "!!! Heavenly",
    "!!! Blossom",
    "!!! Lightning",
    "!!! Loving",
    "!!! Aqua Prism",
    "!!! Aquatic",
    "!!! Aether Shard",
    "!!! Flower Garden",
    "!!! Amber",
    "!!! Abyssal Chroma",
    "!!! Ghostfinn Rod",
    "!!! Enlightened",
    "!!! Cursed",
    "!!! Galactic",
    "!!! Fiery",
    "!!! Pirate Octopus",
    "!!! Pinata",
    "!!! Purple Saber",
    "!!! Abyssfire",
    "!!! Planetary",
    "!!! Soulreaver",
    "!!! Disco",
    "!!! Timeless"
}

-- Daftar Bait dari MODULE.txt
local Baits = {
    "Starter Bait",
    "Nature Bait",
    "Gold Bait",
    "Hyper Bait",
    "Luck Bait",
    "Midnight Bait",
    "Chroma Bait",
    "Dark Matter Bait",
    "Topwater Bait",
    "Anchor Bait",
    "Bag-O-Gold",
    "Beach Ball Bait",
    "Frozen Bait",
    "Ornament Bait",
    "Jolly Bait",
    "Aether Bait",
    "Corrupt Bait"
}

-- Daftar Events dari MODULE.txt
local Events = {
    "Day",
    "Night",
    "Cloudy",
    "Mutated",
    "Wind",
    "Storm",
    "Increased Luck",
    "Shark Hunt",
    "Ghost Shark Hunt",
    "Sparkling Cove",
    "Snow",
    "Worm Hunt",
    "Radiant",
    "Admin - Shocked",
    "Admin - Black Hole",
    "Admin - Ghost Worm",
    "Admin - Meteor Rain",
    "Admin - Super Mutated",
    "Admin - Super Luck"
}

-- Daftar Islands/Areas dari MODULE.txt
local Islands = {
    "Lost Isle",
    "Crater Island",
    "Tropical Grove",
    "Kohana Volcano",
    "Esoteric Depths"
}

-- Daftar Boats dari MODULE.txt
local Boats = {
    "Fishing Boat",
    "Speed Boat",
    "Festive Duck",
    "Santa Sleigh",
    "Frozen Boat",
    "Mini Yacht",
    "Rubber Ducky",
    "Mega Hovercraft",
    "Cruiser Boat",
    "Mini Hoverboat",
    "Aura Boat",
    "Hyper Boat",
    "Jetski",
    "Kayak",
    "Alpha Floaty",
    "Small Boat",
    "DEV Evil Duck 9000",
    "Burger Boat",
    "Dinky Fishing Boat"
}

-- Daftar Gear/Items penting
local GearItems = {
    "Fishing Radar",
    "Diving Gear"
}

-- Variabel Global untuk Mod
local ModData = {
    SavedPosition = nil,
    AutoFishingActive = false,
    AutoFishingVersion = 1, -- 1 = instan, 2 = humanized
    CastingDelay = 1,
    CurrentFishingArea = nil,
    AntiAFKActive = false,
    AutoJumpActive = false,
    AutoJumpDelay = 5,
    GodModeActive = false,
    FlyActive = false,
    NoclipActive = false,
    InfiniteJumpActive = false,
    ESPPlayerActive = false,
    ESPFishActive = false,
    ESPChestActive = false,
    ESPNPCActive = false,
    ESPSharkActive = false,
    ESPEventObjectActive = false,
    ChamsActive = false,
    AutoBuyBaitActive = false,
    SelectedBait = "Starter Bait",
    BaitQuantity = 1,
    AutoBuyRodActive = false,
    AutoBuyGearActive = false,
    AutoSellFishActive = false,
    AutoSellChestActive = false,
    AutoMaxUpgradeActive = false,
    AntiLagActive = false,
    FPSEnabled = false,
    AutoCollectDropsActive = false,
    AutoClaimDailyActive = false,
    AutoSpinEventActive = false,
    WebhookURL = "",
    PotatoModeActive = false,
    TextureDisabled = false,
    ParticlesDisabled = false,
    WaterSimplified = false,
    FPSCap = 60,
    ShadowEnabled = true,
    WaterWaveEnabled = true,
    FullBrightEnabled = false,
    GraphicsQuality = 1,
    UIToggleKey = Enum.KeyCode.RightShift,
    Theme = "Dark",
    DebugMode = false,
    Version = "1.0.0"
}

-- Fungsi Utility
local Utility = {}

function Utility.GetBestRod()
    for i = #Rods, 1, -1 do
        local rodName = Rods[i]
        local rod = ReplicatedStorage.Items:FindFirstChild(rodName)
        if rod then
            return rod
        end
    end
    return ReplicatedStorage.Items:FindFirstChild("!!! Starter Rod")
end

function Utility.GetRodByName(name)
    return ReplicatedStorage.Items:FindFirstChild(name)
end

function Utility.GetBaitByName(name)
    return ReplicatedStorage.Baits:FindFirstChild(name)
end

function Utility.GetGearByName(name)
    return ReplicatedStorage.Items:FindFirstChild(name)
end

function Utility.GetIslandByName(name)
    return Workspace:FindFirstChild(name)
end

function Utility.GetEventByName(name)
    return ReplicatedStorage.Events:FindFirstChild(name)
end

function Utility.TeleportToPosition(position)
    if not position then return false end
    
    local character = LocalPlayer.Character
    if not character then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    humanoidRootPart.CFrame = CFrame.new(position)
    log("Teleported to position: " .. tostring(position))
    return true
end

function Utility.TeleportToIsland(islandName)
    local island = Utility.GetIslandByName(islandName)
    if not island then
        log("Island not found: " .. islandName, "WARNING")
        return false
    end
    
    local spawnPoint = island:FindFirstChild("SpawnLocation") or island:FindFirstChild("Spawn")
    if not spawnPoint then
        -- Cari part apa saja untuk teleport
        for _, part in ipairs(island:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                local position = part.Position + Vector3.new(0, 5, 0)
                Utility.TeleportToPosition(position)
                log("Teleported to island: " .. islandName)
                return true
            end
        end
        log("No suitable spawn point found in island: " .. islandName, "WARNING")
        return false
    end
    
    Utility.TeleportToPosition(spawnPoint.Position + Vector3.new(0, 5, 0))
    log("Teleported to island: " .. islandName)
    return true
end

function Utility.TeleportToPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        log("Target player not found or has no character", "WARNING")
        return false
    end
    
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then
        log("Target player has no HumanoidRootPart", "WARNING")
        return false
    end
    
    Utility.TeleportToPosition(targetHRP.Position + Vector3.new(0, 5, 0))
    log("Teleported to player: " .. targetPlayer.Name)
    return true
end

function Utility.EquipBestRod()
    local bestRod = Utility.GetBestRod()
    if not bestRod then
        log("No rods available to equip", "WARNING")
        return false
    end
    
    Remotes.EquipItem:FireServer(bestRod)
    log("Equipped best rod: " .. bestRod.Name)
    return true
end

function Utility.EquipItemByName(itemName)
    local item = ReplicatedStorage.Items:FindFirstChild(itemName)
    if not item then
        log("Item not found: " .. itemName, "WARNING")
        return false
    end
    
    Remotes.EquipItem:FireServer(item)
    log("Equipped item: " .. itemName)
    return true
end

function Utility.BuyItem(itemName, itemType)
    -- Cari item di kategori yang sesuai
    local item
    if itemType == "rod" then
        item = Utility.GetRodByName(itemName)
    elseif itemType == "bait" then
        item = Utility.GetBaitByName(itemName)
    elseif itemType == "gear" then
        item = Utility.GetGearByName(itemName)
    end
    
    if not item then
        log("Cannot find item to purchase: " .. itemName, "WARNING")
        return false
    end
    
    -- Tentukan remote berdasarkan tipe
    local purchaseRemote
    if itemType == "rod" then
        purchaseRemote = Remotes.PurchaseFishingRod
    elseif itemType == "bait" then
        purchaseRemote = Remotes.PurchaseBait
    elseif itemType == "gear" then
        purchaseRemote = Remotes.PurchaseGear
    end
    
    if not purchaseRemote then
        log("No purchase remote for item type: " .. itemType, "WARNING")
        return false
    end
    
    -- Lakukan pembelian
    local success, result = pcall(function()
        return purchaseRemote:InvokeServer(item)
    end)
    
    if success and result then
        log("Successfully purchased: " .. itemName)
        return true
    else
        log("Failed to purchase: " .. itemName, "ERROR")
        return false
    end
end

function Utility.SellAllFish()
    -- Asumsikan ada fungsi untuk menjual semua ikan
    local success, result = pcall(function()
        return Remotes.SellAllItems:InvokeServer("Fish")
    end)
    
    if success and result then
        log("Successfully sold all fish")
        return true
    else
        log("Failed to sell fish", "ERROR")
        return false
    end
end

function Utility.SellAllChests()
    local success, result = pcall(function()
        return Remotes.SellAllItems:InvokeServer("Chest")
    end)
    
    if success and result then
        log("Successfully sold all chests")
        return true
    else
        log("Failed to sell chests", "ERROR")
        return false
    end
end

function Utility.ClaimDailyReward()
    local success, result = pcall(function()
        return Remotes.ClaimDailyLogin:InvokeServer()
    end)
    
    if success and result then
        log("Successfully claimed daily reward")
        return true
    else
        log("Failed to claim daily reward", "ERROR")
        return false
    end
end

function Utility.SpinEvent()
    local success, result = pcall(function()
        return Remotes.RequestSpin:InvokeServer()
    end)
    
    if success and result then
        log("Successfully spun event wheel")
        return true
    else
        log("Failed to spin event wheel", "ERROR")
        return false
    end
end

function Utility.GetPlayersInServer()
    local players = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    return players
end

function Utility.GetPlayerByName(name)
    return Players:FindFirstChild(name)
end

-- Sistem Auto Fishing
local FishingSystem = {}

function FishingSystem.StartAutoFishing()
    if ModData.AutoFishingActive then return end
    
    ModData.AutoFishingActive = true
    log("Auto Fishing started (Version " .. ModData.AutoFishingVersion .. ")")
    
    task.spawn(function()
        while ModData.AutoFishingActive do
            -- Equip rod terbaik
            Utility.EquipBestRod()
            
            -- Equip bait terbaik jika ada
            for i = #Baits, 1, -1 do
                local baitName = Baits[i]
                local bait = Utility.GetBaitByName(baitName)
                if bait then
                    Remotes.EquipBait:FireServer(bait)
                    break
                end
            end
            
            -- Equip fishing radar jika belum
            if Utility.GetGearByName("Fishing Radar") then
                Utility.EquipItemByName("Fishing Radar")
            end
            
            -- Equip diving gear jika belum
            if Utility.GetGearByName("Diving Gear") then
                Utility.EquipItemByName("Diving Gear")
            end
            
            -- Simulasi casting
            -- Dalam game asli, ini akan memicu event fishing
            -- Kita asumsikan ada fungsi untuk memulai fishing
            local character = LocalPlayer.Character
            if character then
                local tool = character:FindFirstChildWhichIsA("Tool")
                if tool then
                    -- Coba aktifkan tool
                    if tool:FindFirstChild("Activate") then
                        tool.Activate:Fire()
                    end
                end
            end
            
            -- Jika versi 1 (instan), selesaikan langsung
            if ModData.AutoFishingVersion == 1 then
                -- Simulasi perfect catch
                task.wait(0.1)
                -- Kirim event fish caught
                Remotes.FishCaught:FireServer(true) -- true untuk perfect catch
                Remotes.FishingCompleted:FireServer()
            else
                -- Versi 2 (humanized) - tambahkan delay acak
                local delay = math.random(1, 3) + math.random()
                task.wait(delay)
                -- 80% chance perfect catch
                local isPerfect = math.random() < 0.8
                Remotes.FishCaught:FireServer(isPerfect)
                Remotes.FishingCompleted:FireServer()
            end
            
            -- Delay antar cast
            task.wait(ModData.CastingDelay)
        end
    end)
end

function FishingSystem.StopAutoFishing()
    ModData.AutoFishingActive = false
    log("Auto Fishing stopped")
    
    -- Batalkan input fishing jika ada
    Remotes.CancelFishingInputs:FireServer()
end

function FishingSystem.ToggleAutoFishing()
    if ModData.AutoFishingActive then
        FishingSystem.StopAutoFishing()
    else
        FishingSystem.StartAutoFishing()
    end
end

-- Sistem Anti AFK
local AntiAFKSystem = {}

function AntiAFKSystem.StartAntiAFK()
    if ModData.AntiAFKActive then return end
    
    ModData.AntiAFKActive = true
    log("Anti AFK started")
    
    task.spawn(function()
        while ModData.AntiAFKActive do
            -- Simulasi input untuk mencegah AFK
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:Move(Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)))
                end
            end
            
            task.wait(30) -- Setiap 30 detik
        end
    end)
end

function AntiAFKSystem.StopAntiAFK()
    ModData.AntiAFKActive = false
    log("Anti AFK stopped")
end

function AntiAFKSystem.ToggleAntiAFK()
    if ModData.AntiAFKActive then
        AntiAFKSystem.StopAntiAFK()
    else
        AntiAFKSystem.StartAntiAFK()
    end
end

-- Sistem Auto Jump
local AutoJumpSystem = {}

function AutoJumpSystem.StartAutoJump()
    if ModData.AutoJumpActive then return end
    
    ModData.AutoJumpActive = true
    log("Auto Jump started")
    
    task.spawn(function()
        while ModData.AutoJumpActive do
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Jump = true
                end
            end
            
            task.wait(ModData.AutoJumpDelay)
        end
    end)
end

function AutoJumpSystem.StopAutoJump()
    ModData.AutoJumpActive = false
    log("Auto Jump stopped")
end

function AutoJumpSystem.ToggleAutoJump()
    if ModData.AutoJumpActive then
        AutoJumpSystem.StopAutoJump()
    else
        AutoJumpSystem.StartAutoJump()
    end
end

-- Sistem Player Modifikasi
local PlayerSystem = {}

function PlayerSystem.SetWalkSpeed(speed)
    local character = LocalPlayer.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return false end
    
    humanoid.WalkSpeed = speed
    log("WalkSpeed set to: " .. speed)
    return true
end

function PlayerSystem.SetJumpPower(power)
    local character = LocalPlayer.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return false end
    
    humanoid.JumpPower = power
    log("JumpPower set to: " .. power)
    return true
end

function PlayerSystem.ToggleFly()
    ModData.FlyActive = not ModData.FlyActive
    
    if ModData.FlyActive then
        log("Fly enabled")
        
        -- Buat sistem fly
        local character = LocalPlayer.Character
        if not character then return end
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 10000
        bodyGyro.D = 1000
        bodyGyro.MaxTorque = Vector3.new(0, 40000, 0)
        bodyGyro.Parent = character:FindFirstChild("HumanoidRootPart")
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
        bodyVelocity.Parent = character:FindFirstChild("HumanoidRootPart")
        
        -- Bind input untuk kontrol fly
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.Space then
                bodyVelocity.Velocity = Vector3.new(0, 50, 0)
            elseif input.KeyCode == Enum.KeyCode.LeftControl then
                bodyVelocity.Velocity = Vector3.new(0, -50, 0)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftControl then
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end)
        
        -- Update velocity berdasarkan input
        RunService.Heartbeat:Connect(function()
            if not ModData.FlyActive then return end
            
            local moveVector = Vector3.new(0, 0, 0)
            local speed = 50
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + character.HumanoidRootPart.CFrame.LookVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - character.HumanoidRootPart.CFrame.LookVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - character.HumanoidRootPart.CFrame.RightVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + character.HumanoidRootPart.CFrame.RightVector * speed
            end
            
            bodyVelocity.Velocity = Vector3.new(moveVector.X, bodyVelocity.Velocity.Y, moveVector.Z)
        end)
    else
        log("Fly disabled")
        
        -- Hapus semua body movers
        local character = LocalPlayer.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, child in ipairs(hrp:GetChildren()) do
                    if child:IsA("BodyGyro") or child:IsA("BodyVelocity") then
                        child:Destroy()
                    end
                end
            end
        end
    end
end

function PlayerSystem.ToggleNoclip()
    ModData.NoclipActive = not ModData.NoclipActive
    
    if ModData.NoclipActive then
        log("Noclip enabled")
        
        local character = LocalPlayer.Character
        if not character then return end
        
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        log("Noclip disabled")
        
        local character = LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

function PlayerSystem.ToggleInfiniteJump()
    ModData.InfiniteJumpActive = not ModData.InfiniteJumpActive
    
    if ModData.InfiniteJumpActive then
        log("Infinite Jump enabled")
        
        -- Override humanoid state
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.StateChanged:Connect(function(oldState, newState)
                    if newState == Enum.HumanoidStateType.Jumping then
                        humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end)
            end
        end
    else
        log("Infinite Jump disabled")
    end
end

function PlayerSystem.ToggleGodMode()
    ModData.GodModeActive = not ModData.GodModeActive
    
    if ModData.GodModeActive then
        log("God Mode enabled")
        
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
                
                -- Block damage
                humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                    if humanoid.Health < humanoid.MaxHealth then
                        humanoid.Health = humanoid.MaxHealth
                    end
                end)
            end
        end
    else
        log("God Mode disabled")
        
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.MaxHealth = 100
                humanoid.Health = 100
            end
        end
    end
end

function PlayerSystem.ResetPlayer()
    log("Resetting player")
    LocalPlayer:LoadCharacter()
end

function PlayerSystem.RejoinServer()
    log("Rejoining server")
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end

function PlayerSystem.ServerHop()
    log("Server hopping")
    -- Dapatkan list server
    local success, servers = pcall(function()
        return game:GetService("TeleportService"):GetPlayerPlaceInstanceAsync(LocalPlayer.UserId)
    end)
    
    if success and servers then
        -- Pilih server random selain yang sekarang
        local currentJobId = game.JobId
        local availableServers = {}
        
        for _, server in ipairs(servers) do
            if server.JobId ~= currentJobId then
                table.insert(availableServers, server)
            end
        end
        
        if #availableServers > 0 then
            local randomServer = availableServers[math.random(1, #availableServers)]
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, randomServer.JobId, LocalPlayer)
        else
            log("No other servers available, rejoining current server", "WARNING")
            PlayerSystem.RejoinServer()
        end
    else
        log("Failed to get server list, rejoining current server", "ERROR")
        PlayerSystem.RejoinServer()
    end
end

function PlayerSystem.ToggleSitStand()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if humanoid.Sit then
        humanoid.Sit = not humanoid.Sit
        log("Sit/Stand toggled: " .. tostring(humanoid.Sit))
    end
end

-- Sistem Visual (ESP, Chams, dll)
local VisualSystem = {}

function VisualSystem.CreateESPBox(target, color)
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = color
    box.Filled = false
    box.Transparency = 1
    box.Visible = true
    box.ZIndex = 10
    
    return box
end

function VisualSystem.CreateESPText(text, color)
    local espText = Drawing.new("Text")
    espText.Size = 14
    espText.Font = 2
    espText.Color = color
    espText.Center = true
    espText.Visible = true
    espText.ZIndex = 10
    
    return espText
end

function VisualSystem.CreateESPLine(color)
    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Color = color
    line.Transparency = 1
    line.Visible = true
    line.ZIndex = 10
    
    return line
end

function VisualSystem.UpdateESP()
    if not ModData.ESPPlayerActive and not ModData.ESPFishActive and not ModData.ESPChestActive and not ModData.ESPNPCActive and not ModData.ESPSharkActive and not ModData.ESPEventObjectActive then
        return
    end
    
    -- ESP untuk player
    if ModData.ESPPlayerActive then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos, onScreen = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        -- Buat/maintain ESP box
                        if not player.ESPBox then
                            player.ESPBox = VisualSystem.CreateESPBox(player, Color3.fromRGB(255, 255, 255))
                        end
                        
                        -- Buat/maintain ESP text
                        if not player.ESPText then
                            player.ESPText = VisualSystem.CreateESPText(player.Name, Color3.fromRGB(255, 255, 255))
                        end
                        
                        -- Buat/maintain ESP line (tracer)
                        if not player.ESPLine then
                            player.ESPLine = VisualSystem.CreateESPLine(Color3.fromRGB(255, 255, 255))
                        end
                        
                        -- Update posisi
                        local distance = (LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - hrp.Position).Magnitude
                        local boxSize = 10000 / distance
                        
                        player.ESPBox.Size = Vector2.new(boxSize, boxSize * 2)
                        player.ESPBox.Position = Vector2.new(pos.X - boxSize/2, pos.Y - boxSize)
                        
                        player.ESPText.Position = Vector2.new(pos.X, pos.Y - boxSize - 20)
                        player.ESPText.Text = player.Name .. " (" .. math.floor(distance) .. "m)"
                        
                        local screenCenter = Vector2.new(game:GetService("Workspace").CurrentCamera.ViewportSize.X / 2, game:GetService("Workspace").CurrentCamera.ViewportSize.Y)
                        player.ESPLine.From = screenCenter
                        player.ESPLine.To = Vector2.new(pos.X, pos.Y)
                        
                        player.ESPBox.Visible = true
                        player.ESPText.Visible = true
                        player.ESPLine.Visible = true
                    else
                        if player.ESPBox then player.ESPBox.Visible = false end
                        if player.ESPText then player.ESPText.Visible = false end
                        if player.ESPLine then player.ESPLine.Visible = false end
                    end
                end
            end
        end
    end
    
    -- ESP untuk ikan (contoh implementasi)
    if ModData.ESPFishActive then
        -- Cari semua ikan di workspace
        for _, fish in ipairs(Workspace:GetChildren()) do
            if fish.Name:match("Fish") or fish.Name:match("fish") then
                local primaryPart = fish:FindFirstChild("PrimaryPart") or fish:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    local pos, onScreen = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(primaryPart.Position)
                    if onScreen then
                        if not fish.ESPBox then
                            fish.ESPBox = VisualSystem.CreateESPBox(fish, Color3.fromRGB(0, 255, 0))
                        end
                        
                        if not fish.ESPText then
                            fish.ESPText = VisualSystem.CreateESPText("Fish", Color3.fromRGB(0, 255, 0))
                        end
                        
                        local distance = (LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - primaryPart.Position).Magnitude
                        local boxSize = 5000 / distance
                        
                        fish.ESPBox.Size = Vector2.new(boxSize, boxSize)
                        fish.ESPBox.Position = Vector2.new(pos.X - boxSize/2, pos.Y - boxSize/2)
                        
                        fish.ESPText.Position = Vector2.new(pos.X, pos.Y - boxSize - 10)
                        fish.ESPText.Text = "Fish (" .. math.floor(distance) .. "m)"
                        
                        fish.ESPBox.Visible = true
                        fish.ESPText.Visible = true
                    else
                        if fish.ESPBox then fish.ESPBox.Visible = false end
                        if fish.ESPText then fish.ESPText.Visible = false end
                    end
                end
            end
        end
    end
end

function VisualSystem.ToggleESPPlayer()
    ModData.ESPPlayerActive = not ModData.ESPPlayerActive
    log("ESP Player " .. (ModData.ESPPlayerActive and "enabled" or "disabled"))
    
    if not ModData.ESPPlayerActive then
        -- Bersihkan semua ESP player
        for _, player in ipairs(Players:GetPlayers()) do
            if player.ESPBox then
                player.ESPBox:Remove()
                player.ESPBox = nil
            end
            if player.ESPText then
                player.ESPText:Remove()
                player.ESPText = nil
            end
            if player.ESPLine then
                player.ESPLine:Remove()
                player.ESPLine = nil
            end
        end
    end
end

function VisualSystem.ToggleESPFish()
    ModData.ESPFishActive = not ModData.ESPFishActive
    log("ESP Fish " .. (ModData.ESPFishActive and "enabled" or "disabled"))
    
    if not ModData.ESPFishActive then
        -- Bersihkan semua ESP fish
        for _, fish in ipairs(Workspace:GetChildren()) do
            if fish.ESPBox then
                fish.ESPBox:Remove()
                fish.ESPBox = nil
            end
            if fish.ESPText then
                fish.ESPText:Remove()
                fish.ESPText = nil
            end
        end
    end
end

function VisualSystem.ToggleESPChest()
    ModData.ESPChestActive = not ModData.ESPChestActive
    log("ESP Chest " .. (ModData.ESPChestActive and "enabled" or "disabled"))
end

function VisualSystem.ToggleESPNPC()
    ModData.ESPNPCActive = not ModData.ESPNPCActive
    log("ESP NPC " .. (ModData.ESPNPCActive and "enabled" or "disabled"))
end

function VisualSystem.ToggleESPShark()
    ModData.ESPSharkActive = not ModData.ESPSharkActive
    log("ESP Shark " .. (ModData.ESPSharkActive and "enabled" or "disabled"))
end

function VisualSystem.ToggleESPEventObject()
    ModData.ESPEventObjectActive = not ModData.ESPEventObjectActive
    log("ESP Event Object " .. (ModData.ESPEventObjectActive and "enabled" or "disabled"))
end

function VisualSystem.ToggleChams()
    ModData.ChamsActive = not ModData.ChamsActive
    log("Chams " .. (ModData.ChamsActive and "enabled" or "disabled"))
    
    if ModData.ChamsActive then
        -- Terapkan efek chams ke semua model
        for _, model in ipairs(Workspace:GetChildren()) do
            if model:IsA("Model") and model ~= LocalPlayer.Character then
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.LocalTransparencyModifier = 0.5
                    end
                end
            end
        end
    else
        -- Kembalikan transparansi
        for _, model in ipairs(Workspace:GetChildren()) do
            if model:IsA("Model") then
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.LocalTransparencyModifier = 0
                    end
                end
            end
        end
    end
end

-- Sistem Shop Automation
local ShopSystem = {}

function ShopSystem.StartAutoBuyBait()
    if not ModData.AutoBuyBaitActive then return end
    
    log("Auto Buy Bait started for: " .. ModData.SelectedBait .. " (Quantity: " .. ModData.BaitQuantity .. ")")
    
    task.spawn(function()
        while ModData.AutoBuyBaitActive do
            local bait = Utility.GetBaitByName(ModData.SelectedBait)
            if bait then
                Utility.BuyItem(ModData.SelectedBait, "bait")
            else
                log("Bait not found: " .. ModData.SelectedBait, "WARNING")
            end
            
            task.wait(5) -- Tunggu 5 detik sebelum coba lagi
        end
    end)
end

function ShopSystem.StopAutoBuyBait()
    ModData.AutoBuyBaitActive = false
    log("Auto Buy Bait stopped")
end

function ShopSystem.ToggleAutoBuyBait()
    if ModData.AutoBuyBaitActive then
        ShopSystem.StopAutoBuyBait()
    else
        ModData.AutoBuyBaitActive = true
        ShopSystem.StartAutoBuyBait()
    end
end

function ShopSystem.StartAutoBuyRod()
    if not ModData.AutoBuyRodActive then return end
    
    log("Auto Buy Rod started")
    
    task.spawn(function()
        while ModData.AutoBuyRodActive do
            -- Cari rod terbaik yang belum dimiliki
            local boughtAny = false
            for i = #Rods, 1, -1 do
                local rodName = Rods[i]
                local rod = Utility.GetRodByName(rodName)
                if rod then
                    -- Cek apakah sudah memiliki rod ini
                    -- Asumsikan ada cara untuk mengecek inventori
                    -- Untuk sekarang, kita coba beli saja
                    local success = Utility.BuyItem(rodName, "rod")
                    if success then
                        boughtAny = true
                        break
                    end
                end
            end
            
            if not boughtAny then
                log("No more rods to buy", "INFO")
                ModData.AutoBuyRodActive = false
                break
            end
            
            task.wait(10) -- Tunggu 10 detik
        end
    end)
end

function ShopSystem.StopAutoBuyRod()
    ModData.AutoBuyRodActive = false
    log("Auto Buy Rod stopped")
end

function ShopSystem.ToggleAutoBuyRod()
    if ModData.AutoBuyRodActive then
        ShopSystem.StopAutoBuyRod()
    else
        ModData.AutoBuyRodActive = true
        ShopSystem.StartAutoBuyRod()
    end
end

function ShopSystem.StartAutoBuyGear()
    if not ModData.AutoBuyGearActive then return end
    
    log("Auto Buy Gear started")
    
    task.spawn(function()
        while ModData.AutoBuyGearActive do
            for _, gearName in ipairs(GearItems) do
                local gear = Utility.GetGearByName(gearName)
                if gear then
                    Utility.BuyItem(gearName, "gear")
                end
            end
            
            task.wait(15) -- Tunggu 15 detik
        end
    end)
end

function ShopSystem.StopAutoBuyGear()
    ModData.AutoBuyGearActive = false
    log("Auto Buy Gear stopped")
end

function ShopSystem.ToggleAutoBuyGear()
    if ModData.AutoBuyGearActive then
        ShopSystem.StopAutoBuyGear()
    else
        ModData.AutoBuyGearActive = true
        ShopSystem.StartAutoBuyGear()
    end
end

function ShopSystem.StartAutoSellFish()
    if not ModData.AutoSellFishActive then return end
    
    log("Auto Sell Fish started")
    
    task.spawn(function()
        while ModData.AutoSellFishActive do
            Utility.SellAllFish()
            task.wait(30) -- Jual setiap 30 detik
        end
    end)
end

function ShopSystem.StopAutoSellFish()
    ModData.AutoSellFishActive = false
    log("Auto Sell Fish stopped")
end

function ShopSystem.ToggleAutoSellFish()
    if ModData.AutoSellFishActive then
        ShopSystem.StopAutoSellFish()
    else
        ModData.AutoSellFishActive = true
        ShopSystem.StartAutoSellFish()
    end
end

function ShopSystem.StartAutoSellChest()
    if not ModData.AutoSellChestActive then return end
    
    log("Auto Sell Chest started")
    
    task.spawn(function()
        while ModData.AutoSellChestActive do
            Utility.SellAllChests()
            task.wait(30) -- Jual setiap 30 detik
        end
    end)
end

function ShopSystem.StopAutoSellChest()
    ModData.AutoSellChestActive = false
    log("Auto Sell Chest stopped")
end

function ShopSystem.ToggleAutoSellChest()
    if ModData.AutoSellChestActive then
        ShopSystem.StopAutoSellChest()
    else
        ModData.AutoSellChestActive = true
        ShopSystem.StartAutoSellChest()
    end
end

function ShopSystem.StartAutoMaxUpgrade()
    if not ModData.AutoMaxUpgradeActive then return end
    
    log("Auto Max Upgrade started")
    
    task.spawn(function()
        while ModData.AutoMaxUpgradeActive do
            -- Upgrade semua rod
            -- Asumsikan ada remote untuk upgrade
            -- Karena tidak ada di MODULE.txt, kita skip implementasi spesifik
            log("Auto Max Upgrade: Feature not fully implemented due to missing remote functions", "WARNING")
            
            task.wait(60) -- Coba setiap menit
        end
    end)
end

function ShopSystem.StopAutoMaxUpgrade()
    ModData.AutoMaxUpgradeActive = false
    log("Auto Max Upgrade stopped")
end

function ShopSystem.ToggleAutoMaxUpgrade()
    if ModData.AutoMaxUpgradeActive then
        ShopSystem.StopAutoMaxUpgrade()
    else
        ModData.AutoMaxUpgradeActive = true
        ShopSystem.StartAutoMaxUpgrade()
    end
end

function ShopSystem.TeleportToShop()
    -- Cari NPC shop
    for _, npc in ipairs(Workspace:GetChildren()) do
        if npc.Name:match("Shop") or npc.Name:match("Vendor") then
            local primaryPart = npc:FindFirstChild("PrimaryPart") or npc:FindFirstChildWhichIsA("BasePart")
            if primaryPart then
                Utility.TeleportToPosition(primaryPart.Position + Vector3.new(0, 5, 0))
                log("Teleported to shop: " .. npc.Name)
                return true
            end
        end
    end
    
    log("No shop found", "WARNING")
    return false
end

-- Sistem Utility
local UtilitySystem = {}

function UtilitySystem.StartAntiLag()
    if ModData.AntiLagActive then return end
    
    ModData.AntiLagActive = true
    log("Anti Lag started")
    
    task.spawn(function()
        while ModData.AntiLagActive do
            -- Bersihkan partikel dan efek
            for _, particle in ipairs(Workspace:GetChildren()) do
                if particle:IsA("ParticleEmitter") or particle.Name:match("Effect") or particle.Name:match("VFX") then
                    particle:Destroy()
                end
            end
            
            task.wait(10) -- Bersihkan setiap 10 detik
        end
    end)
end

function UtilitySystem.StopAntiLag()
    ModData.AntiLagActive = false
    log("Anti Lag stopped")
end

function UtilitySystem.ToggleAntiLag()
    if ModData.AntiLagActive then
        UtilitySystem.StopAntiLag()
    else
        UtilitySystem.StartAntiLag()
    end
end

function UtilitySystem.ToggleFPSCounter()
    ModData.FPSEnabled = not ModData.FPSEnabled
    log("FPS Counter " .. (ModData.FPSEnabled and "enabled" or "disabled"))
    
    if ModData.FPSEnabled then
        -- Buat FPS counter
        if not script.FPSCounter then
            script.FPSCounter = Drawing.new("Text")
            script.FPSCounter.Size = 18
            script.FPSCounter.Font = 2
            script.FPSCounter.Color = Color3.fromRGB(255, 255, 255)
            script.FPSCounter.Center = false
            script.FPSCounter.Visible = true
            script.FPSCounter.ZIndex = 100
        end
        
        -- Update FPS setiap frame
        RunService.Heartbeat:Connect(function()
            if not ModData.FPSEnabled then return end
            
            local fps = math.floor(1 / RunService.Heartbeat:Wait())
            script.FPSCounter.Text = "FPS: " .. fps
            script.FPSCounter.Position = Vector2.new(10, 10)
        end)
    else
        if script.FPSCounter then
            script.FPSCounter:Remove()
            script.FPSCounter = nil
        end
    end
end

function UtilitySystem.StartAutoCollectDrops()
    if not ModData.AutoCollectDropsActive then return end
    
    log("Auto Collect Drops started")
    
    task.spawn(function()
        while ModData.AutoCollectDropsActive do
            -- Cari item yang jatuh
            for _, item in ipairs(Workspace:GetChildren()) do
                if item.Name:match("Drop") or item.Name:match("Item") or item.Name:match("Coin") then
                    local primaryPart = item:FindFirstChild("PrimaryPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        -- Teleport ke item
                        Utility.TeleportToPosition(primaryPart.Position)
                        task.wait(0.5) -- Tunggu sebentar
                    end
                end
            end
            
            task.wait(5) -- Cek setiap 5 detik
        end
    end)
end

function UtilitySystem.StopAutoCollectDrops()
    ModData.AutoCollectDropsActive = false
    log("Auto Collect Drops stopped")
end

function UtilitySystem.ToggleAutoCollectDrops()
    if ModData.AutoCollectDropsActive then
        UtilitySystem.StopAutoCollectDrops()
    else
        ModData.AutoCollectDropsActive = true
        UtilitySystem.StartAutoCollectDrops()
    end
end

function UtilitySystem.StartAutoClaimDaily()
    if not ModData.AutoClaimDailyActive then return end
    
    log("Auto Claim Daily started")
    
    task.spawn(function()
        while ModData.AutoClaimDailyActive do
            Utility.ClaimDailyReward()
            task.wait(86400) -- Tunggu 24 jam
        end
    end)
end

function UtilitySystem.StopAutoClaimDaily()
    ModData.AutoClaimDailyActive = false
    log("Auto Claim Daily stopped")
end

function UtilitySystem.ToggleAutoClaimDaily()
    if ModData.AutoClaimDailyActive then
        UtilitySystem.StopAutoClaimDaily()
    else
        ModData.AutoClaimDailyActive = true
        UtilitySystem.StartAutoClaimDaily()
    end
end

function UtilitySystem.StartAutoSpinEvent()
    if not ModData.AutoSpinEventActive then return end
    
    log("Auto Spin Event started")
    
    task.spawn(function()
        while ModData.AutoSpinEventActive do
            Utility.SpinEvent()
            task.wait(3600) -- Spin setiap jam
        end
    end)
end

function UtilitySystem.StopAutoSpinEvent()
    ModData.AutoSpinEventActive = false
    log("Auto Spin Event stopped")
end

function UtilitySystem.ToggleAutoSpinEvent()
    if ModData.AutoSpinEventActive then
        UtilitySystem.StopAutoSpinEvent()
    else
        ModData.AutoSpinEventActive = true
        UtilitySystem.StartAutoSpinEvent()
    end
end

function UtilitySystem.SendToWebhook(message)
    if ModData.WebhookURL == "" then
        log("Webhook URL not set", "WARNING")
        return false
    end
    
    local data = {
        content = message,
        username = "NIKZZMODDER Logger",
        avatar_url = "https://i.imgur.com/4M34hi2.png"
    }
    
    local success, result = pcall(function()
        return HttpService:PostAsync(ModData.WebhookURL, HttpService:JSONEncode(data))
    end)
    
    if success then
        log("Message sent to webhook: " .. message)
        return true
    else
        log("Failed to send message to webhook: " .. tostring(result), "ERROR")
        return false
    end
end

-- Sistem Graphic
local GraphicSystem = {}

function GraphicSystem.ToggleShadow()
    ModData.ShadowEnabled = not ModData.ShadowEnabled
    log("Shadow " .. (ModData.ShadowEnabled and "enabled" or "disabled"))
    
    Lighting.GlobalShadows = ModData.ShadowEnabled
end

function GraphicSystem.ToggleWaterWave()
    ModData.WaterWaveEnabled = not ModData.WaterWaveEnabled
    log("Water Wave " .. (ModData.WaterWaveEnabled and "enabled" or "disabled"))
    
    -- Cari water di workspace
    for _, water in ipairs(Workspace:GetChildren()) do
        if water:IsA("Terrain") then
            -- Tidak bisa langsung mengatur wave di terrain
        elseif water.Name:match("Water") then
            for _, part in ipairs(water:GetChildren()) do
                if part:IsA("SpecialMesh") and part.MeshType == Enum.MeshType.Wave then
                    part.Enabled = ModData.WaterWaveEnabled
                end
            end
        end
    end
end

function GraphicSystem.ToggleFullBright()
    ModData.FullBrightEnabled = not ModData.FullBrightEnabled
    log("FullBright " .. (ModData.FullBrightEnabled and "enabled" or "disabled"))
    
    if ModData.FullBrightEnabled then
        Lighting.Brightness = 3
        Lighting.ExposureCompensation = 1
    else
        Lighting.Brightness = 1
        Lighting.ExposureCompensation = 0
    end
end

function GraphicSystem.SetGraphicsQuality(quality)
    ModData.GraphicsQuality = quality
    log("Graphics Quality set to: " .. quality)
    
    -- Sesuaikan pengaturan grafis
    if quality <= 0.3 then
        -- Very Low
        game:GetService("Lighting").Technology = Enum.Technology.ShadowMap
        game:GetService("Lighting").ShadowSoftness = 0
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").FogEnd = 50
        game:GetService("Lighting").FogStart = 0
        game:GetService("Lighting").GeographicLatitude = 0
        game:GetService("Lighting").ClockTime = 12
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        
        -- Kurangi detail
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Material = Enum.Material.SmoothPlastic
                    end
                end
            end
        end
    elseif quality <= 0.6 then
        -- Medium
        game:GetService("Lighting").Technology = Enum.Technology.Voxel
        game:GetService("Lighting").ShadowSoftness = 0.5
        game:GetService("Lighting").GlobalShadows = true
        game:GetService("Lighting").FogEnd = 500
        game:GetService("Lighting").FogStart = 0
        game:GetService("Lighting").GeographicLatitude = 23.5
        game:GetService("Lighting").ClockTime = 12
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(192, 192, 192)
    else
        -- High
        game:GetService("Lighting").Technology = Enum.Technology.Future
        game:GetService("Lighting").ShadowSoftness = 1
        game:GetService("Lighting").GlobalShadows = true
        game:GetService("Lighting").FogEnd = 1000
        game:GetService("Lighting").FogStart = 0
        game:GetService("Lighting").GeographicLatitude = 45
        game:GetService("Lighting").ClockTime = 12
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    end
end

function GraphicSystem.ChangeTime(time)
    log("Time changed to: " .. time)
    
    if time == "Day" then
        Lighting.ClockTime = 12
    elseif time == "Night" then
        Lighting.ClockTime = 0
    elseif time == "Sunset" then
        Lighting.ClockTime = 18
    elseif time == "Sunrise" then
        Lighting.ClockTime = 6
    end
end

-- Sistem LowDev
local LowDevSystem = {}

function LowDevSystem.TogglePotatoMode()
    ModData.PotatoModeActive = not ModData.PotatoModeActive
    log("Potato Mode " .. (ModData.PotatoModeActive and "enabled" or "disabled"))
    
    if ModData.PotatoModeActive then
        -- Render ultra rendah
        GraphicSystem.SetGraphicsQuality(0.1)
        ModData.TextureDisabled = true
        ModData.ParticlesDisabled = true
        ModData.WaterSimplified = true
        ModData.FPSCap = 30
        
        -- Terapkan semua optimasi
        LowDevSystem.ApplyTextureDisable()
        LowDevSystem.ApplyParticlesDisable()
        LowDevSystem.ApplyWaterSimplify()
        LowDevSystem.ApplyFPSCap()
    else
        -- Kembalikan ke pengaturan normal
        GraphicSystem.SetGraphicsQuality(1)
        ModData.TextureDisabled = false
        ModData.ParticlesDisabled = false
        ModData.WaterSimplified = false
        ModData.FPSCap = 60
        
        LowDevSystem.ApplyTextureDisable()
        LowDevSystem.ApplyParticlesDisable()
        LowDevSystem.ApplyWaterSimplify()
        LowDevSystem.ApplyFPSCap()
    end
end

function LowDevSystem.ApplyTextureDisable()
    if ModData.TextureDisabled then
        log("Textures disabled")
        
        -- Ganti semua material menjadi smooth plastic tanpa texture
        for _, descendant in ipairs(Workspace:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.Material = Enum.Material.SmoothPlastic
                descendant.TextureID = ""
            end
        end
    else
        log("Textures enabled")
        -- Tidak bisa mengembalikan texture asli tanpa menyimpannya terlebih dahulu
    end
end

function LowDevSystem.ApplyParticlesDisable()
    if ModData.ParticlesDisabled then
        log("Particles disabled")
        
        -- Nonaktifkan semua particle emitter
        for _, descendant in ipairs(Workspace:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false
            end
        end
    else
        log("Particles enabled")
        
        -- Aktifkan semua particle emitter
        for _, descendant in ipairs(Workspace:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = true
            end
        end
    end
end

function LowDevSystem.ApplyWaterSimplify()
    if ModData.WaterSimplified then
        log("Water simplified")
        
        -- Sederhanakan air
        for _, water in ipairs(Workspace:GetChildren()) do
            if water:IsA("Terrain") then
                -- Tidak bisa langsung mengatur terrain
            elseif water.Name:match("Water") then
                for _, part in ipairs(water:GetChildren()) do
                    if part:IsA("SpecialMesh") then
                        part:Destroy()
                    end
                    if part:IsA("BasePart") then
                        part.Material = Enum.Material.Neon
                        part.Transparency = 0.5
                    end
                end
            end
        end
    else
        log("Water returned to normal")
        -- Tidak bisa mengembalikan efek air asli tanpa menyimpannya terlebih dahulu
    end
end

function LowDevSystem.ApplyFPSCap()
    log("FPS capped to: " .. ModData.FPSCap)
    
    -- Batasi FPS dengan mengatur wait time
    if not script.FPSCapConnection then
        script.FPSCapConnection = RunService.Heartbeat:Connect(function()
            local targetFrameTime = 1 / ModData.FPSCap
            local currentFrameTime = tick() - (script.LastFrameTime or 0)
            
            if currentFrameTime < targetFrameTime then
                wait(targetFrameTime - currentFrameTime)
            end
            
            script.LastFrameTime = tick()
        end)
    end
end

function LowDevSystem.ToggleTextureDisable()
    ModData.TextureDisabled = not ModData.TextureDisabled
    LowDevSystem.ApplyTextureDisable()
end

function LowDevSystem.ToggleParticlesDisable()
    ModData.ParticlesDisabled = not ModData.ParticlesDisabled
    LowDevSystem.ApplyParticlesDisable()
end

function LowDevSystem.ToggleWaterSimplify()
    ModData.WaterSimplified = not ModData.WaterSimplified
    LowDevSystem.ApplyWaterSimplify()
end

function LowDevSystem.SetFPSCap(fps)
    ModData.FPSCap = fps
    LowDevSystem.ApplyFPSCap()
end

-- Sistem Settings
local SettingsSystem = {}

function SettingsSystem.SetUIToggleKey(key)
    ModData.UIToggleKey = key
    log("UI Toggle Key set to: " .. tostring(key))
    
    -- Bind key untuk toggle UI
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == ModData.UIToggleKey then
            Window:Toggle()
        end
    end)
end

function SettingsSystem.SaveConfig()
    -- Simpan konfigurasi ke file
    local success, result = pcall(function()
        return game:GetService("HttpService"):JSONEncode(ModData)
    end)
    
    if success then
        -- Simpan ke file lokal
        writefile("NIKZZMODDER_Config.json", result)
        log("Configuration saved successfully")
        
        Rayfield:Notify({
            Title = "NIKZZMODDER",
            Content = "Configuration saved successfully!",
            Duration = 3,
            Image = 4483362458,
        })
    else
        log("Failed to save configuration: " .. tostring(result), "ERROR")
        
        Rayfield:Notify({
            Title = "NIKZZMODDER",
            Content = "Failed to save configuration!",
            Duration = 3,
            Image = 4483362458,
        })
    end
end

function SettingsSystem.LoadConfig()
    -- Muat konfigurasi dari file
    local success, result = pcall(function()
        local fileContent = readfile("NIKZZMODDER_Config.json")
        return game:GetService("HttpService"):JSONDecode(fileContent)
    end)
    
    if success and result then
        -- Terapkan konfigurasi
        for key, value in pairs(result) do
            ModData[key] = value
        end
        
        log("Configuration loaded successfully")
        
        Rayfield:Notify({
            Title = "NIKZZMODDER",
            Content = "Configuration loaded successfully!",
            Duration = 3,
            Image = 4483362458,
        })
        
        -- Refresh UI
        SettingsSystem.RefreshUI()
    else
        log("Failed to load configuration: " .. tostring(result), "ERROR")
        
        Rayfield:Notify({
            Title = "NIKZZMODDER",
            Content = "Failed to load configuration!",
            Duration = 3,
            Image = 4483362458,
        })
    end
end

function SettingsSystem.SetTheme(theme)
    ModData.Theme = theme
    log("Theme set to: " .. theme)
    
    -- Terapkan tema
    if theme == "Light" then
        -- Light theme
        Window.BackgroundColor = Color3.fromRGB(240, 240, 240)
        Window.MainTextColor = Color3.fromRGB(0, 0, 0)
    elseif theme == "Dark" then
        -- Dark theme
        Window.BackgroundColor = Color3.fromRGB(30, 30, 30)
        Window.MainTextColor = Color3.fromRGB(255, 255, 255)
    elseif theme == "Custom" then
        -- Custom theme
        Window.BackgroundColor = Color3.fromRGB(50, 50, 70)
        Window.MainTextColor = Color3.fromRGB(200, 200, 255)
    end
end

function SettingsSystem.CheckForUpdates()
    log("Checking for updates...")
    
    -- Cek update (placeholder - dalam implementasi nyata, akan mengecek server)
    local currentVersion = ModData.Version
    local latestVersion = "1.0.0" -- Dalam implementasi nyata, dapatkan dari server
    
    if currentVersion ~= latestVersion then
        log("Update available: " .. latestVersion)
        
        Rayfield:Notify({
            Title = "NIKZZMODDER Update",
            Content = "New version available: " .. latestVersion .. "\nCurrent version: " .. currentVersion,
            Duration = 5,
            Image = 4483362458,
        })
    else
        log("No updates available")
        
        Rayfield:Notify({
            Title = "NIKZZMODDER",
            Content = "You are using the latest version!",
            Duration = 3,
            Image = 4483362458,
        })
    end
end

function SettingsSystem.ToggleDebugMode()
    ModData.DebugMode = not ModData.DebugMode
    log("Debug Mode " .. (ModData.DebugMode and "enabled" or "disabled"))
end

function SettingsSystem.RefreshUI()
    -- Refresh semua UI element
    log("Refreshing UI...")
    -- Dalam implementasi nyata, akan me-refresh semua toggle, slider, dll
end

-- Buat semua tab
local Tabs = {}

-- Tab 1: NKZ-FARM
Tabs.NKZ_FARM = Window:CreateTab("NKZ-FARM", 4483362458)

-- Section Auto Fishing
local FarmSection = Tabs.NKZ_FARM:CreateSection("Auto Fishing")

-- Toggle Auto Fishing
local AutoFishingToggle = Tabs.NKZ_FARM:CreateToggle({
    Name = "Auto Fishing",
    CurrentValue = false,
    Flag = "AutoFishingToggle",
    Callback = function(Value)
        if Value then
            FishingSystem.ToggleAutoFishing()
        else
            FishingSystem.StopAutoFishing()
        end
    end,
})

-- Dropdown versi Auto Fishing
local AutoFishingVersionDropdown = Tabs.NKZ_FARM:CreateDropdown({
    Name = "Auto Fishing Version",
    Options = {"V1 - Instant", "V2 - Humanized"},
    CurrentOption = "V1 - Instant",
    Flag = "AutoFishingVersion",
    Callback = function(Option)
        if Option == "V1 - Instant" then
            ModData.AutoFishingVersion = 1
        else
            ModData.AutoFishingVersion = 2
        end
        log("Auto Fishing Version set to: " .. Option)
    end,
})

-- Slider Casting Delay
local CastingDelaySlider = Tabs.NKZ_FARM:CreateSlider({
    Name = "Casting Delay (seconds)",
    Range = {1, 10},
    Increment = 1,
    Suffix = "s",
    CurrentValue = 1,
    Flag = "CastingDelay",
    Callback = function(Value)
        ModData.CastingDelay = Value
        log("Casting Delay set to: " .. Value .. " seconds")
    end,
})

-- Dropdown Fishing Area
local FishingAreaDropdown = Tabs.NKZ_FARM:CreateDropdown({
    Name = "Choose Fishing Area",
    Options = Islands,
    CurrentOption = Islands[1],
    Flag = "FishingArea",
    Callback = function(Option)
        ModData.CurrentFishingArea = Option
        log("Fishing Area set to: " .. Option)
    end,
})

-- Button Teleport to Fishing Area
local TeleportFishingAreaButton = Tabs.NKZ_FARM:CreateButton({
    Name = "Teleport to Fishing Area",
    Callback = function()
        if ModData.CurrentFishingArea then
            Utility.TeleportToIsland(ModData.CurrentFishingArea)
        else
            log("No fishing area selected", "WARNING")
        end
    end,
})

-- Button Save Position
local SavePositionButton = Tabs.NKZ_FARM:CreateButton({
    Name = "Save Current Position",
    Callback = function()
        local character = LocalPlayer.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                ModData.SavedPosition = hrp.Position
                log("Position saved: " .. tostring(ModData.SavedPosition))
                
                Rayfield:Notify({
                    Title = "NIKZZMODDER",
                    Content = "Position saved successfully!",
                    Duration = 3,
                    Image = 4483362458,
                })
            else
                log("HumanoidRootPart not found", "ERROR")
            end
        else
            log("Character not found", "ERROR")
        end
    end,
})

-- Button Teleport to Saved Position
local TeleportSavedPositionButton = Tabs.NKZ_FARM:CreateButton({
    Name = "Teleport to Saved Position",
    Callback = function()
        if ModData.SavedPosition then
            Utility.TeleportToPosition(ModData.SavedPosition)
        else
            log("No saved position", "WARNING")
            
            Rayfield:Notify({
                Title = "NIKZZMODDER",
                Content = "No saved position!",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Toggle Bypass Fishing Radar
local BypassRadarToggle = Tabs.NKZ_FARM:CreateToggle({
    Name = "Bypass Fishing Radar",
    CurrentValue = false,
    Flag = "BypassRadar",
    Callback = function(Value)
        if Value then
            -- Equip atau beli radar
            local radar = Utility.GetGearByName("Fishing Radar")
            if radar then
                Utility.EquipItemByName("Fishing Radar")
                log("Fishing Radar equipped")
            else
                -- Coba beli
                Utility.BuyItem("Fishing Radar", "gear")
                log("Attempted to purchase Fishing Radar")
            end
        end
    end,
})

-- Toggle Bypass Diving Gear
local BypassDivingGearToggle = Tabs.NKZ_FARM:CreateToggle({
    Name = "Bypass Diving Gear",
    CurrentValue = false,
    Flag = "BypassDivingGear",
    Callback = function(Value)
        if Value then
            -- Equip atau beli diving gear
            local gear = Utility.GetGearByName("Diving Gear")
            if gear then
                Utility.EquipItemByName("Diving Gear")
                log("Diving Gear equipped")
            else
                -- Coba beli
                Utility.BuyItem("Diving Gear", "gear")
                log("Attempted to purchase Diving Gear")
            end
        end
    end,
})

-- Toggle Anti AFK
local AntiAFKToggle = Tabs.NKZ_FARM:CreateToggle({
    Name = "Anti AFK / Anti Disconnect",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        if Value then
            AntiAFKSystem.StartAntiAFK()
        else
            AntiAFKSystem.StopAntiAFK()
        end
    end,
})

-- Slider Auto Jump Delay
local AutoJumpDelaySlider = Tabs.NKZ_FARM:CreateSlider({
    Name = "Auto Jump Delay (seconds)",
    Range = {1, 30},
    Increment = 1,
    Suffix = "s",
    CurrentValue = 5,
    Flag = "AutoJumpDelay",
    Callback = function(Value)
        ModData.AutoJumpDelay = Value
        log("Auto Jump Delay set to: " .. Value .. " seconds")
    end,
})

-- Toggle Auto Jump
local AutoJumpToggle = Tabs.NKZ_FARM:CreateToggle({
    Name = "Auto Jump",
    CurrentValue = false,
    Flag = "AutoJump",
    Callback = function(Value)
        if Value then
            AutoJumpSystem.StartAutoJump()
        else
            AutoJumpSystem.StopAutoJump()
        end
    end,
})

-- Toggle Anti Detect Developer
local AntiDetectToggle = Tabs.NKZ_FARM:CreateToggle({
    Name = "Anti Detect Developer",
    CurrentValue = false,
    Flag = "AntiDetect",
    Callback = function(Value)
        if Value then
            log("Anti Detect Developer enabled - activity obfuscation active")
            -- Implementasi obfuscation (placeholder)
            -- Dalam implementasi nyata, akan menyembunyikan pola farming
        else
            log("Anti Detect Developer disabled")
        end
    end,
})

-- Tab 2: NKZ-TELEPORT
Tabs.NKZ_TELEPORT = Window:CreateTab("NKZ-TELEPORT", 4483362458)

-- Section Island Teleport
local IslandSection = Tabs.NKZ_TELEPORT:CreateSection("Island Teleport")

-- Dropdown Choose Island
local IslandDropdown = Tabs.NKZ_TELEPORT:CreateDropdown({
    Name = "Choose Island",
    Options = Islands,
    CurrentOption = Islands[1],
    Flag = "SelectedIsland",
    Callback = function(Option)
        ModData.SelectedIsland = Option
        log("Island selected: " .. Option)
    end,
})

-- Button Teleport Island
local TeleportIslandButton = Tabs.NKZ_TELEPORT:CreateButton({
    Name = "Teleport to Island",
    Callback = function()
        if ModData.SelectedIsland then
            Utility.TeleportToIsland(ModData.SelectedIsland)
        else
            log("No island selected", "WARNING")
        end
    end,
})

-- Section Event Teleport
local EventSection = Tabs.NKZ_TELEPORT:CreateSection("Event Teleport")

-- Dropdown Choose Event
local EventDropdown = Tabs.NKZ_TELEPORT:CreateDropdown({
    Name = "Choose Event",
    Options = Events,
    CurrentOption = Events[1],
    Flag = "SelectedEvent",
    Callback = function(Option)
        ModData.SelectedEvent = Option
        log("Event selected: " .. Option)
    end,
})

-- Button Teleport Event
local TeleportEventButton = Tabs.NKZ_TELEPORT:CreateButton({
    Name = "Teleport to Event",
    Callback = function()
        if ModData.SelectedEvent then
            -- Cari lokasi event
            local event = Utility.GetEventByName(ModData.SelectedEvent)
            if event then
                -- Asumsikan event memiliki lokasi
                for _, part in ipairs(event:GetChildren()) do
                    if part:IsA("BasePart") then
                        Utility.TeleportToPosition(part.Position + Vector3.new(0, 5, 0))
                        log("Teleported to event: " .. ModData.SelectedEvent)
                        return
                    end
                end
                log("No location found for event: " .. ModData.SelectedEvent, "WARNING")
            else
                log("Event not found: " .. ModData.SelectedEvent, "WARNING")
            end
        else
            log("No event selected", "WARNING")
        end
    end,
})

-- Section Player Teleport
local PlayerSection = Tabs.NKZ_TELEPORT:CreateSection("Player Teleport")

-- Dropdown Select Player
local PlayerDropdown = Tabs.NKZ_TELEPORT:CreateDropdown({
    Name = "Select Player",
    Options = Utility.GetPlayersInServer(),
    CurrentOption = #Utility.GetPlayersInServer() > 0 and Utility.GetPlayersInServer()[1] or "No players",
    Flag = "SelectedPlayer",
    Callback = function(Option)
        ModData.SelectedPlayer = Option
        log("Player selected: " .. Option)
    end,
})

-- Button Refresh Player List
local RefreshPlayerButton = Tabs.NKZ_TELEPORT:CreateButton({
    Name = "Refresh Player List",
    Callback = function()
        local players = Utility.GetPlayersInServer()
        if #players == 0 then
            players = {"No players"}
        end
        PlayerDropdown:Refresh(players, true)
        ModData.SelectedPlayer = players[1]
        log("Player list refreshed")
    end,
})

-- Button Teleport to Player
local TeleportPlayerButton = Tabs.NKZ_TELEPORT:CreateButton({
    Name = "Teleport to Player",
    Callback = function()
        if ModData.SelectedPlayer and ModData.SelectedPlayer ~= "No players" then
            local targetPlayer = Utility.GetPlayerByName(ModData.SelectedPlayer)
            if targetPlayer then
                Utility.TeleportToPlayer(targetPlayer)
            else
                log("Player not found: " .. ModData.SelectedPlayer, "WARNING")
            end
        else
            log("No player selected", "WARNING")
        end
    end,
})

-- Tab 3: NKZ-PLAYER
Tabs.NKZ_PLAYER = Window:CreateTab("NKZ-PLAYER", 4483362458)

-- Section Player Modifications
local PlayerModSection = Tabs.NKZ_PLAYER:CreateSection("Player Modifications")

-- Slider WalkSpeed
local WalkSpeedSlider = Tabs.NKZ_PLAYER:CreateSlider({
    Name = "WalkSpeed",
    Range = {1, 200},
    Increment = 1,
    Suffix = "studs/s",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        PlayerSystem.SetWalkSpeed(Value)
    end,
})

-- Slider JumpPower
local JumpPowerSlider = Tabs.NKZ_PLAYER:CreateSlider({
    Name = "JumpPower",
    Range = {1, 300},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        PlayerSystem.SetJumpPower(Value)
    end,
})

-- Toggle Fly
local FlyToggle = Tabs.NKZ_PLAYER:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        PlayerSystem.ToggleFly()
    end,
})

-- Toggle Noclip
local NoclipToggle = Tabs.NKZ_PLAYER:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        PlayerSystem.ToggleNoclip()
    end,
})

-- Toggle Infinite Jump
local InfiniteJumpToggle = Tabs.NKZ_PLAYER:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(Value)
        PlayerSystem.ToggleInfiniteJump()
    end,
})

-- Toggle GodMode
local GodModeToggle = Tabs.NKZ_PLAYER:CreateToggle({
    Name = "GodMode",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(Value)
        PlayerSystem.ToggleGodMode()
    end,
})

-- Toggle Sit/Stand
local SitStandToggle = Tabs.NKZ_PLAYER:CreateToggle({
    Name = "Sit/Stand",
    CurrentValue = false,
    Flag = "SitStand",
    Callback = function(Value)
        PlayerSystem.ToggleSitStand()
    end,
})

-- Section Player Actions
local PlayerActionSection = Tabs.NKZ_PLAYER:CreateSection("Player Actions")

-- Button Reset Player
local ResetPlayerButton = Tabs.NKZ_PLAYER:CreateButton({
    Name = "Reset Player",
    Callback = function()
        PlayerSystem.ResetPlayer()
    end,
})

-- Button Rejoin Server
local RejoinServerButton = Tabs.NKZ_PLAYER:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        PlayerSystem.RejoinServer()
    end,
})

-- Button Server Hop
local ServerHopButton = Tabs.NKZ_PLAYER:CreateButton({
    Name = "Server Hop",
    Callback = function()
        PlayerSystem.ServerHop()
    end,
})

-- Tab 4: NKZ-VISUAL
Tabs.NKZ_VISUAL = Window:CreateTab("NKZ-VISUAL", 4483362458)

-- Section ESP
local ESPSection = Tabs.NKZ_VISUAL:CreateSection("ESP")

-- Toggle ESP Player
local ESPPlayerToggle = Tabs.NKZ_VISUAL:CreateToggle({
    Name = "ESP Player",
    CurrentValue = false,
    Flag = "ESPPlayer",
    Callback = function(Value)
        VisualSystem.ToggleESPPlayer()
    end,
})

-- Toggle ESP Fish
local ESPFishToggle = Tabs.NKZ_VISUAL:CreateToggle({
    Name = "ESP Fish",
    CurrentValue = false,
    Flag = "ESPFish",
    Callback = function(Value)
        VisualSystem.ToggleESPFish()
    end,
})

-- Toggle ESP Chest
local ESPChestToggle = Tabs.NKZ_VISUAL:CreateToggle({
    Name = "ESP Chest",
    CurrentValue = false,
    Flag = "ESPChest",
    Callback = function(Value)
        VisualSystem.ToggleESPChest()
    end,
})

-- Toggle ESP NPC
local ESPNPCToggle = Tabs.NKZ_VISUAL:CreateToggle({
    Name = "ESP NPC",
    CurrentValue = false,
    Flag = "ESPNPC",
    Callback = function(Value)
        VisualSystem.ToggleESPNPC()
    end,
})

-- Toggle ESP Shark
local ESPSharkToggle = Tabs.NKZ_VISUAL:CreateToggle({
    Name = "ESP Shark",
    CurrentValue = false,
    Flag = "ESPShark",
    Callback = function(Value)
        VisualSystem.ToggleESPShark()
    end,
})

-- Toggle ESP Event Object
local ESPEventObjectToggle = Tabs.NKZ_VISUAL:CreateToggle({
    Name = "ESP Event Object",
    CurrentValue = false,
    Flag = "ESPEventObject",
    Callback = function(Value)
        VisualSystem.ToggleESPEventObject()
    end,
})

-- Toggle Chams
local ChamsToggle = Tabs.NKZ_VISUAL:CreateToggle({
    Name = "Chams",
    CurrentValue = false,
    Flag = "Chams",
    Callback = function(Value)
        VisualSystem.ToggleChams()
    end,
})

-- Update ESP setiap frame
RunService.Heartbeat:Connect(function()
    VisualSystem.UpdateESP()
end)

-- Tab 5: NKZ-SHOP
Tabs.NKZ_SHOP = Window:CreateTab("NKZ-SHOP", 4483362458)

-- Section Auto Buy
local AutoBuySection = Tabs.NKZ_SHOP:CreateSection("Auto Buy")

-- Dropdown Choose Bait
local BaitDropdown = Tabs.NKZ_SHOP:CreateDropdown({
    Name = "Choose Bait",
    Options = Baits,
    CurrentOption = Baits[1],
    Flag = "SelectedBait",
    Callback = function(Option)
        ModData.SelectedBait = Option
        log("Bait selected: " .. Option)
    end,
})

-- Slider Bait Quantity
local BaitQuantitySlider = Tabs.NKZ_SHOP:CreateSlider({
    Name = "Bait Quantity",
    Range = {1, 100},
    Increment = 1,
    Suffix = "pcs",
    CurrentValue = 1,
    Flag = "BaitQuantity",
    Callback = function(Value)
        ModData.BaitQuantity = Value
        log("Bait Quantity set to: " .. Value)
    end,
})

-- Toggle Auto Buy Bait
local AutoBuyBaitToggle = Tabs.NKZ_SHOP:CreateToggle({
    Name = "Auto Buy Bait",
    CurrentValue = false,
    Flag = "AutoBuyBait",
    Callback = function(Value)
        ShopSystem.ToggleAutoBuyBait()
    end,
})

-- Toggle Auto Buy Rod
local AutoBuyRodToggle = Tabs.NKZ_SHOP:CreateToggle({
    Name = "Auto Buy Rod",
    CurrentValue = false,
    Flag = "AutoBuyRod",
    Callback = function(Value)
        ShopSystem.ToggleAutoBuyRod()
    end,
})

-- Toggle Auto Buy Gear
local AutoBuyGearToggle = Tabs.NKZ_SHOP:CreateToggle({
    Name = "Auto Buy Gear",
    CurrentValue = false,
    Flag = "AutoBuyGear",
    Callback = function(Value)
        ShopSystem.ToggleAutoBuyGear()
    end,
})

-- Section Auto Sell
local AutoSellSection = Tabs.NKZ_SHOP:CreateSection("Auto Sell")

-- Toggle Auto Sell Fish
local AutoSellFishToggle = Tabs.NKZ_SHOP:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = false,
    Flag = "AutoSellFish",
    Callback = function(Value)
        ShopSystem.ToggleAutoSellFish()
    end,
})

-- Toggle Auto Sell Chest
local AutoSellChestToggle = Tabs.NKZ_SHOP:CreateToggle({
    Name = "Auto Sell Chest",
    CurrentValue = false,
    Flag = "AutoSellChest",
    Callback = function(Value)
        ShopSystem.ToggleAutoSellChest()
    end,
})

-- Toggle Auto Max Upgrade
local AutoMaxUpgradeToggle = Tabs.NKZ_SHOP:CreateToggle({
    Name = "Auto Max Upgrade",
    CurrentValue = false,
    Flag = "AutoMaxUpgrade",
    Callback = function(Value)
        ShopSystem.ToggleAutoMaxUpgrade()
    end,
})

-- Button Shop Teleport
local ShopTeleportButton = Tabs.NKZ_SHOP:CreateButton({
    Name = "Teleport to Shop",
    Callback = function()
        ShopSystem.TeleportToShop()
    end,
})

-- Tab 6: NKZ-UTILITY
Tabs.NKZ_UTILITY = Window:CreateTab("NKZ-UTILITY", 4483362458)

-- Section Performance
local PerformanceSection = Tabs.NKZ_UTILITY:CreateSection("Performance")

-- Toggle Anti Lag
local AntiLagToggle = Tabs.NKZ_UTILITY:CreateToggle({
    Name = "Anti Lag",
    CurrentValue = false,
    Flag = "AntiLag",
    Callback = function(Value)
        UtilitySystem.ToggleAntiLag()
    end,
})

-- Toggle FPS Counter
local FPSToggle = Tabs.NKZ_UTILITY:CreateToggle({
    Name = "FPS Counter",
    CurrentValue = false,
    Flag = "FPSCounter",
    Callback = function(Value)
        UtilitySystem.ToggleFPSCounter()
    end,
})

-- Section Automation
local AutomationSection = Tabs.NKZ_UTILITY:CreateSection("Automation")

-- Toggle Auto Collect Drops
local AutoCollectDropsToggle = Tabs.NKZ_UTILITY:CreateToggle({
    Name = "Auto Collect Drops",
    CurrentValue = false,
    Flag = "AutoCollectDrops",
    Callback = function(Value)
        UtilitySystem.ToggleAutoCollectDrops()
    end,
})

-- Toggle Auto Claim Daily
local AutoClaimDailyToggle = Tabs.NKZ_UTILITY:CreateToggle({
    Name = "Auto Claim Daily",
    CurrentValue = false,
    Flag = "AutoClaimDaily",
    Callback = function(Value)
        UtilitySystem.ToggleAutoClaimDaily()
    end,
})

-- Toggle Auto Spin Event
local AutoSpinEventToggle = Tabs.NKZ_UTILITY:CreateToggle({
    Name = "Auto Spin Event",
    CurrentValue = false,
    Flag = "AutoSpinEvent",
    Callback = function(Value)
        UtilitySystem.ToggleAutoSpinEvent()
    end,
})

-- Section Webhook
local WebhookSection = Tabs.NKZ_UTILITY:CreateSection("Webhook")

-- Input Webhook URL
local WebhookInput = Tabs.NKZ_UTILITY:CreateInput({
    Name = "Discord Webhook URL",
    PlaceholderText = "Enter webhook URL...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        ModData.WebhookURL = Text
        log("Webhook URL set")
    end,
})

-- Button Test Webhook
local TestWebhookButton = Tabs.NKZ_UTILITY:CreateButton({
    Name = "Test Webhook",
    Callback = function()
        UtilitySystem.SendToWebhook("NIKZZMODDER Test Message - Script is working!")
    end,
})

-- Section Config
local ConfigSection = Tabs.NKZ_UTILITY:CreateSection("Configuration")

-- Button Save Config
local SaveConfigButton = Tabs.NKZ_UTILITY:CreateButton({
    Name = "Save Configuration",
    Callback = function()
        SettingsSystem.SaveConfig()
    end,
})

-- Button Load Config
local LoadConfigButton = Tabs.NKZ_UTILITY:CreateButton({
    Name = "Load Configuration",
    Callback = function()
        SettingsSystem.LoadConfig()
    end,
})

-- Tab 7: NKZ-GRAPHIC
Tabs.NKZ_GRAPHIC = Window:CreateTab("NKZ-GRAPHIC", 4483362458)

-- Section Graphics
local GraphicsSection = Tabs.NKZ_GRAPHIC:CreateSection("Graphics")

-- Toggle Shadow
local ShadowToggle = Tabs.NKZ_GRAPHIC:CreateToggle({
    Name = "Toggle Shadow",
    CurrentValue = true,
    Flag = "Shadow",
    Callback = function(Value)
        GraphicSystem.ToggleShadow()
    end,
})

-- Toggle Water Wave
local WaterWaveToggle = Tabs.NKZ_GRAPHIC:CreateToggle({
    Name = "Toggle Water Wave",
    CurrentValue = true,
    Flag = "WaterWave",
    Callback = function(Value)
        GraphicSystem.ToggleWaterWave()
    end,
})

-- Toggle FullBright
local FullBrightToggle = Tabs.NKZ_GRAPHIC:CreateToggle({
    Name = "FullBright",
    CurrentValue = false,
    Flag = "FullBright",
    Callback = function(Value)
        GraphicSystem.ToggleFullBright()
    end,
})

-- Slider Graphics Quality
local GraphicsQualitySlider = Tabs.NKZ_GRAPHIC:CreateSlider({
    Name = "Graphics Quality",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = 1,
    Flag = "GraphicsQuality",
    Callback = function(Value)
        GraphicSystem.SetGraphicsQuality(Value)
    end,
})

-- Dropdown Time Changer
local TimeDropdown = Tabs.NKZ_GRAPHIC:CreateDropdown({
    Name = "Time Changer",
    Options = {"Day", "Night", "Sunset", "Sunrise"},
    CurrentOption = "Day",
    Flag = "Time",
    Callback = function(Option)
        GraphicSystem.ChangeTime(Option)
    end,
})

-- Tab 8: NKZ-LOWDEV
Tabs.NKZ_LOWDEV = Window:CreateTab("NKZ-LOWDEV", 4483362458)

-- Section LowDev Mode
local LowDevSection = Tabs.NKZ_LOWDEV:CreateSection("LowDev Mode")

-- Toggle Potato Mode
local PotatoModeToggle = Tabs.NKZ_LOWDEV:CreateToggle({
    Name = "Potato Mode",
    CurrentValue = false,
    Flag = "PotatoMode",
    Callback = function(Value)
        LowDevSystem.TogglePotatoMode()
    end,
})

-- Toggle Disable Texture
local TextureDisableToggle = Tabs.NKZ_LOWDEV:CreateToggle({
    Name = "Disable Texture",
    CurrentValue = false,
    Flag = "TextureDisable",
    Callback = function(Value)
        LowDevSystem.ToggleTextureDisable()
    end,
})

-- Toggle Disable Particles
local ParticlesDisableToggle = Tabs.NKZ_LOWDEV:CreateToggle({
    Name = "Disable Particles",
    CurrentValue = false,
    Flag = "ParticlesDisable",
    Callback = function(Value)
        LowDevSystem.ToggleParticlesDisable()
    end,
})

-- Toggle Simplify Water
local WaterSimplifyToggle = Tabs.NKZ_LOWDEV:CreateToggle({
    Name = "Simplify Water",
    CurrentValue = false,
    Flag = "WaterSimplify",
    Callback = function(Value)
        LowDevSystem.ToggleWaterSimplify()
    end,
})

-- Dropdown Limit FPS
local FPSCapDropdown = Tabs.NKZ_LOWDEV:CreateDropdown({
    Name = "Limit FPS",
    Options = {"30 FPS", "60 FPS", "120 FPS"},
    CurrentOption = "60 FPS",
    Flag = "FPSCap",
    Callback = function(Option)
        if Option == "30 FPS" then
            LowDevSystem.SetFPSCap(30)
        elseif Option == "60 FPS" then
            LowDevSystem.SetFPSCap(60)
        else
            LowDevSystem.SetFPSCap(120)
        end
    end,
})

-- Tab 9: NKZ-SETTINGS
Tabs.NKZ_SETTINGS = Window:CreateTab("NKZ-SETTINGS", 4483362458)

-- Section UI Settings
local UISettingsSection = Tabs.NKZ_SETTINGS:CreateSection("UI Settings")

-- Dropdown UI Toggle Keybind
local UIToggleKeyDropdown = Tabs.NKZ_SETTINGS:CreateDropdown({
    Name = "UI Toggle Keybind",
    Options = {"RightShift", "RightControl", "Delete", "End", "F9", "F10"},
    CurrentOption = "RightShift",
    Flag = "UIToggleKey",
    Callback = function(Option)
        if Option == "RightShift" then
            SettingsSystem.SetUIToggleKey(Enum.KeyCode.RightShift)
        elseif Option == "RightControl" then
            SettingsSystem.SetUIToggleKey(Enum.KeyCode.RightControl)
        elseif Option == "Delete" then
            SettingsSystem.SetUIToggleKey(Enum.KeyCode.Delete)
        elseif Option == "End" then
            SettingsSystem.SetUIToggleKey(Enum.KeyCode.End)
        elseif Option == "F9" then
            SettingsSystem.SetUIToggleKey(Enum.KeyCode.F9)
        else
            SettingsSystem.SetUIToggleKey(Enum.KeyCode.F10)
        end
    end,
})

-- Dropdown Theme Selector
local ThemeDropdown = Tabs.NKZ_SETTINGS:CreateDropdown({
    Name = "Theme Selector",
    Options = {"Light", "Dark", "Custom"},
    CurrentOption = "Dark",
    Flag = "Theme",
    Callback = function(Option)
        SettingsSystem.SetTheme(Option)
    end,
})

-- Section System
local SystemSection = Tabs.NKZ_SETTINGS:CreateSection("System")

-- Button Save UI Layout
local SaveUILayoutButton = Tabs.NKZ_SETTINGS:CreateButton({
    Name = "Save UI Layout",
    Callback = function()
        SettingsSystem.SaveConfig()
    end,
})

-- Button Check for Updates
local CheckUpdatesButton = Tabs.NKZ_SETTINGS:CreateButton({
    Name = "Check for Updates",
    Callback = function()
        SettingsSystem.CheckForUpdates()
    end,
})

-- Toggle Debug Mode
local DebugModeToggle = Tabs.NKZ_SETTINGS:CreateToggle({
    Name = "Debug Mode",
    CurrentValue = false,
    Flag = "DebugMode",
    Callback = function(Value)
        SettingsSystem.ToggleDebugMode()
    end,
})

-- Section About
local AboutSection = Tabs.NKZ_SETTINGS:CreateSection("About")

-- Label Info
Tabs.NKZ_SETTINGS:CreateLabel("NIKZZMODDER - Ultimate Fishing Mod")
Tabs.NKZ_SETTINGS:CreateLabel("Version: " .. ModData.Version)
Tabs.NKZ_SETTINGS:CreateLabel("Created by: Nikzz7z")
Tabs.NKZ_SETTINGS:CreateLabel("Last Updated: 2025-09-09")
Tabs.NKZ_SETTINGS:CreateLabel(" ")
Tabs.NKZ_SETTINGS:CreateLabel("Features:")
Tabs.NKZ_SETTINGS:CreateLabel("- 100% Stable & Lightweight")
Tabs.NKZ_SETTINGS:CreateLabel("- Async Implementation")
Tabs.NKZ_SETTINGS:CreateLabel("- No Lag on Low-End Devices")
Tabs.NKZ_SETTINGS:CreateLabel("- Comprehensive Fishing Automation")
Tabs.NKZ_SETTINGS:CreateLabel("- Advanced Player Modifications")
Tabs.NKZ_SETTINGS:CreateLabel("- ESP & Visual Enhancements")
Tabs.NKZ_SETTINGS:CreateLabel("- Shop Automation")
Tabs.NKZ_SETTINGS:CreateLabel("- Performance Optimization")
Tabs.NKZ_SETTINGS:CreateLabel("- LowDev Mode for Weak Devices")
Tabs.NKZ_SETTINGS:CreateLabel(" ")
Tabs.NKZ_SETTINGS:CreateLabel("Note: Use at your own risk.")
Tabs.NKZ_SETTINGS:CreateLabel("This script is for educational purposes only.")

-- Load configuration
Rayfield:LoadConfiguration()

-- Inisialisasi
log("NIKZZMODDER loaded successfully!")
log("Version: " .. ModData.Version)
log("Created by: Nikzz7z")

-- Notifikasi startup
Rayfield:Notify({
    Title = "NIKZZMODDER",
    Content = "Loaded successfully! Press RightShift to toggle UI.",
    Duration = 5,
    Image = 4483362458,
})

-- Bind default UI toggle key
SettingsSystem.SetUIToggleKey(ModData.UIToggleKey)

-- Set tema default
SettingsSystem.SetTheme(ModData.Theme)

-- Peringatan jika dalam mode debug
if ModData.DebugMode then
    log("DEBUG MODE ENABLED - Detailed logging active", "WARNING")
end

-- Script selesai
log("NIKZZMODDER initialization completed!")
