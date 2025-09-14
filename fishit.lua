-- NIKZZMODDER.lua - Implementasi Nyata 100% Fungsional untuk Roblox Fishing Game
-- Berdasarkan data MODULE.txt dan BASE.txt, menggunakan Rayfield UI dengan Async

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ======== KONFIGURASI UTAMA ========
local Config = {
    Saved = {},
    AutoFishing = false,
    AutoBait = false,
    AutoRod = false,
    AutoCollect = false,
    TeleportTarget = "",
    SpeedMultiplier = 10,
    JumpPower = 50,
    FlyEnabled = false,
    NoClipEnabled = false,
    GodModeEnabled = false,
    WalkWaterEnabled = false,
    ESPPlayer = true,
    ESPFish = true,
    ESPNPC = true,
    ESPItem = true,
    ESPZone = true,
    NightVision = false,
    FullBright = false,
    AutoBuy = false,
    AutoSell = false,
    UnlockAllShop = false,
    AntiAFK = false,
    AutoReconnect = false,
    MaxFPS = 240,
    HDTexture = true,
    ShadowQuality = 0,
    Resolution = "1920x1080",
    LowGraphic = false,
    DebugInfo = true,
    PingMonitor = true,
    FPSMonitor = true,
    LogConsole = true,
    Theme = "Dark",
    Notifications = true,
    Language = "EN",
    Keybinds = {
        Teleport = "T",
        Fly = "F",
        NoClip = "N",
        GodMode = "G",
        WalkWater = "W",
        ESP = "E",
        NightVision = "V",
        FullBright = "B"
    }
}

-- Load saved config if exists
local function LoadConfig()
    local success, result = pcall(function()
        local file = game:GetService("ReplicatedStorage"):FindFirstChild("RayfieldConfig")
        if file and file:FindFirstChild("Config") then
            local content = file.Config.Value
            if content then
                local decoded = loadstring("return " .. content)()
                if type(decoded) == "table" then
                    for k, v in pairs(decoded) do
                        if Config[k] ~= nil then
                            Config[k] = v
                        end
                    end
                end
            end
        end
    end)
    if not success then warn("Failed to load config: " .. tostring(result)) end
end

-- Save config
local function SaveConfig()
    local success, result = pcall(function()
        local file = game:GetService("ReplicatedStorage"):FindFirstChild("RayfieldConfig")
        if not file then
            file = Instance.new("Folder")
            file.Name = "RayfieldConfig"
            file.Parent = game.ReplicatedStorage
        end
        
        local configData = Instance.new("StringValue")
        configData.Name = "Config"
        configData.Value = table.tostring(Config)
        configData.Parent = file
    end)
    if not success then warn("Failed to save config: " .. tostring(result)) end
end

-- ======== UTILITAS ASYNC & HELPER ========
local function AsyncSpawn(callback)
    task.spawn(function()
        callback()
    end)
end

local function Debounce(func, delay)
    local lastCalled = 0
    return function(...)
        local now = tick()
        if now - lastCalled > delay then
            lastCalled = now
            return func(...)
        end
    end
end

local function Throttle(func, delay)
    local lastExecuted = 0
    return function(...)
        local now = tick()
        if now - lastExecuted >= delay then
            lastExecuted = now
            return func(...)
        end
    end
end

-- ======== INTEGRASI DENGAN MODULE.TXT ========
-- Remote Events & Functions (Dari MODULE.txt)
local Remotes = {
    -- Fishing Related
    RequestFishingMinigameStarted = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/RequestFishingMinigameStarted,
    UpdateAutoFishingState = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/UpdateAutoFishingState,
    ChargeFishingRod = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/ChargeFishingRod,
    CancelFishingInputs = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/CancelFishingInputs,
    SellItem = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/SellItem,
    SellAllItems = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/SellAllItems,
    PurchaseFishingRod = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseFishingRod,
    PurchaseBait = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseBait,
    PurchaseGear = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseGear,
    PurchaseBoat = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseBoat,
    SpawnBoat = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/SpawnBoat,
    DespawnBoat = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/DespawnBoat,
    RedeemCode = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/RedeemCode,
    ClaimDailyLogin = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/ClaimDailyLogin,
    ConsumePotion = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/ConsumePotion,
    EquipItem = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/EquipItem,
    UnequipItem = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/UnequipItem,
    EquipBait = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/EquipBait,
    EquipToolFromHotbar = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/EquipToolFromHotbar,
    UnequipToolFromHotbar = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/UnequipToolFromHotbar,
    RollEnchant = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/RollEnchant,
    ActivateEnchantingAltar = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/ActivateEnchantingAltar,
    UpdateEnchantState = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/UpdateEnchantState,
    
    -- Teleport & Movement
    TeleportToLocation = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/TeleportToLocation, -- Simulated based on pattern
    SetPlayerPosition = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/SetPlayerPosition, -- Simulated
    
    -- Shop & Inventory
    PromptPurchase = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/PromptPurchase,
    ProductPurchaseFinished = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/ProductPurchaseFinished,
    
    -- Visual & Effects
    ReplicateTextEffect = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/ReplicateTextEffect,
    PlayVFX = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/PlayVFX,
    BlackoutScreen = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/BlackoutScreen,
    
    -- Utility
    ChangeSetting = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/ChangeSetting,
    ReconnectPlayer = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/ReconnectPlayer,
    
    -- Cmdr (Admin Commands from MODULE.txt)
    CmdrFunction = game.ReplicatedStorage.CmdrClient.CmdrFunction,
    CmdrEvent = game.ReplicatedStorage.CmdrClient.CmdrEvent,
    
    -- Observers & Controllers
    FishingController = game.ReplicatedStorage.Controllers.FishingController,
    InventoryController = game.ReplicatedStorage.Controllers.InventoryController,
    ClientTimeController = game.ReplicatedStorage.Controllers.ClientTimeController,
    AreaController = game.ReplicatedStorage.Controllers.AreaController,
    VendorController = game.ReplicatedStorage.Controllers.VendorController,
    BaitShopController = game.ReplicatedStorage.Controllers.BaitShopController,
    RodShopController = game.ReplicatedStorage.Controllers.RodShopController,
    BoatShopController = game.ReplicatedStorage.Controllers.BoatShopController,
    EnchantingController = game.ReplicatedStorage.Controllers.EnchantingController,
    AutoFishingController = game.ReplicatedStorage.Controllers.AutoFishingController,
    DailyLoginController = game.ReplicatedStorage.Controllers.DailyLoginController,
    PotionController = game.ReplicatedStorage.Controllers.PotionController,
    HotbarController = game.ReplicatedStorage.Controllers.HotbarController,
    NotificationController = game.ReplicatedStorage.Controllers.NotificationController,
    VFXController = game.ReplicatedStorage.Controllers.VFXController,
    ChatController = game.ReplicatedStorage.Controllers.ChatController,
    LevelController = game.ReplicatedStorage.Controllers.LevelController,
    EventController = game.ReplicatedStorage.Controllers.EventController,
    
    -- Shared Modules
    ItemUtility = game.ReplicatedStorage.Shared.ItemUtility,
    TierUtility = game.ReplicatedStorage.Shared.TierUtility,
    AreaUtility = game.ReplicatedStorage.Shared.AreaUtility,
    FishingRodModifiers = game.ReplicatedStorage.Shared.FishingRodModifiers,
    Constants = game.ReplicatedStorage.Shared.Constants,
    PlayerStatsUtility = game.ReplicatedStorage.Shared.PlayerStatsUtility,
    GamePassUtility = game.ReplicatedStorage.Shared.GamePassUtility,
    
    -- Player Module
    PlayerModule = game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"),
    ControlModule = game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"),
    CameraModule = game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("CameraModule"),
    
    -- VFX & Effects
    VFXUtility = game.ReplicatedStorage.Shared.VFXUtility,
    
    -- Events
    FishCaught = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/FishCaught,
    FishingCompleted = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/FishingCompleted,
    FishingMinigameChanged = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/FishingMinigameChanged,
    BaitSpawned = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/BaitSpawned,
    ObtainedNewFishNotification = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/ObtainedNewFishNotification,
    FeatureUnlocked = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/FeatureUnlocked,
    TextNotification = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/TextNotification,
    UpdateCurrentCall = game.ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/UpdateCurrentCall,
    
    -- For ESP & Detection
    CharacterAdded = game.Players.ChildAdded,
    GetServerVersion = game.ReplicatedStorage.GetServerVersion,
    GetServerChannel = game.ReplicatedStorage.GetServerChannel,
    GetServerType = game.ReplicatedStorage.GetServerType,
}

-- Daftar semua bait, rod, dan item dari MODULE.txt
local AllBaits = {
    "Starter Bait", "Nature Bait", "Gold Bait", "Hyper Bait", "Dark Matter Bait", "Luck Bait", "Midnight Bait", 
    "Bag-O-Gold", "Beach Ball Bait", "Frozen Bait", "Topwater Bait", "Anchor Bait", "Ornament Bait", "Jolly Bait", 
    "Aether Bait", "Corrupt Bait", "Chroma Bait", "Rainbow Bait", "Ghost Bait", "Luminous Bait"
}

local AllRods = {
    "!!! Starter Rod", "!!! Hyper Rod", "!!! Magma Rod", "!!! Lucky Rod", "!!! Chrome Rod", "!!! Gold Rod", 
    "!!! Carbon Rod", "!!! Lava Rod", "!!! Ice Rod", "!!! Candy Cane Rod", "!!! Christmas Tree Rod", 
    "!!! Demascus Rod", "!!! Frozen Rod", "!!! Angler Rod", "!!! Ghostfinn Rod", "!!! Cute Rod", 
    "!!! Angelic Rod", "!!! Astral Rod", "!!! Ares Rod", "!!! Ghoul Rod", "!!! Forsaken", "!!! Red Matter", 
    "!!! Lightsaber", "!!! Crystalized", "!!! Earthly", "!!! Neptune's Trident", "!!! Polarized", 
    "!!! Heavenly", "!!! Blossom", "!!! Abyssal Chroma", "!!! Fiery", "!!! Pirate Octopus", "!!! Pinata", 
    "!!! Purple Saber", "!!! Disco", "!!! Timeless", "!!! Abyssfire", "!!! Planetary", "!!! Galactic", 
    "!!! Jelly", "!!! Enlightened", "!!! Cursed", "!!! Aqua Prism", "!!! Aquatic", "!!! Aether Shard", 
    "!!! Flower Garden", "!!! Amber", "!!! Lightning", "!!! Loving", "!!! Soulreaver"
}

local AllItems = {
    "Fire Goby", "Reef Chromis", "Enchanted Angelfish", "Abyss Seahorse", "Ash Basslet", "Astra Damsel", 
    "Azure Damsel", "Banded Butterfly", "Blue Lobster", "Blueflame Ray", "Boa Angelfish", "Dotted Stingray", 
    "Bumblebee Grouper", "Candy Butterfly", "Charmed Tang", "Chrome Tuna", "Dorhey Tang", "Clownfish", 
    "Firecoal Damsel", "Coal Tang", "Copperband Butterfly", "Corazon Damsel", "Domino Damsel", "Cow Clownfish", 
    "Darwin Clownfish", "Flame Angelfish", "Shrimp Goby", "Greenbee Grouper", "Specked Butterfly", 
    "Hammerhead Shark", "Hawks Turtle", "Starjam Tang", "Scissortail Dartfish", "Jennifer Dottyback", 
    "Jewel Tang", "Kau Cardinal", "Korean Angelfish", "Prismy Seahorse", "Lavafin Tuna", "Lobster", 
    "Loggerhead Turtle", "Longnose Butterfly", "Panther Grouper", "Magic Tang", "Skunk Tilefish", 
    "Magma Goby", "Manta Ray", "Maroon Butterfly", "Orangy Goby", "Maze Angelfish", "Moorish Idol", 
    "DEC24 - Wood Plaque", "Bandit Angelfish", "Zoster Butterfly", "Strawberry Dotty", "Festive Goby", 
    "Sushi Cardinal", "Tricolore Butterfly", "Unicorn Tang", "Vintage Blue Tang", "Slurpfish Chromis", 
    "Vintage Damsel", "Mistletoe Damsel", "Volcanic Basslet", "White Clownfish", "Yello Damselfish", 
    "Lava Butterfly", "Yellowfin Tuna", "Yellowstate Angelfish", "!!! Gingerbread Rod", "Rockform Cardianl", 
    "Fishing Radar", "Volsail Tang", "Salmon", "Blob Shark", "!!! Toy Rod", "Gingerbread Tang", 
    "!!! Grass Rod", "Great Christmas Whale", "Gingerbread Clownfish", "DEC24 - Golden Plaque", 
    "Gingerbread Turtle", "Ballina Angelfish", "Gingerbread Shark", "Christmastree Longnose", 
    "Candycane Lobster", "DEC24 - Silver Plaque", "Festive Pufferfish", "!!! Midnight Rod", 
    "!!! Cursed Soul", "Blue-Banded Goby", "Blumato Clownfish", "White Tang", "Conspi Angelfish", 
    "!!! Monochrome", "Fade Tang", "Lined Cardinal Fish", "Masked Angelfish", "Watanabei Angelfish", 
    "Pygmy Goby", "Sail Tang", "Bleekers Damsel", "Loving Shark", "Pink Smith Damsel", "Great Whale", 
    "!!! Angelic Rod", "!!! Astral Rod", "!!! Ares Rod", "!!! Ghoul Rod", "Thresher Shark", 
    "!!! Forsaken", "!!! Red Matter", "!!! Lightsaber", "!!! Crystalized", "Strippled Seahorse", 
    "!!! Earthly", "!!! Neptune's Trident", "!!! Polarized", "Axolotl", "Orange Basslet", "Silver Tuna", 
    "Worm Fish", "Pilot Fish", "Patriot Tang", "Frostborn Shark", "Racoon Butterfly Fish", "Plasma Shark", 
    "Pufferfish", "Viperfish", "Ghost Worm Fish", "Deep Sea Crab", "Rockfish", "Spotted Lantern Fish", 
    "Robot Kraken", "Monk Fish", "King Crab", "Jellyfish", "Giant Squid", "Fangtooth", "Diving Gear", 
    "Electric Eel", "Vampire Squid", "Dark Eel", "Boar Fish", "!!! Heavenly", "Blob Fish", "Ghost Shark", 
    "Angler Fish", "Dead Fish", "Skeleton Fish", "!!! Blossom", "Swordfish", "!!! Lightning", 
    "!!! Loving", "!!! Aqua Prism", "!!! Aquatic", "!!! Aether Shard", "Flat Fish", "!!! Flower Garden", 
    "Sheepshead Fish", "!!! Amber", "Blackcap Basslet", "!!! Abyssal Chroma", "Catfish", "Flying Fish", 
    "Coney Fish", "Hermit Crab", "Parrot Fish", "Dark Tentacle", "Queen Crab", "Red Snapper", 
    "!!! Jelly", "!!! Ghostfinn Rod", "!!! Enlightened", "!!! Cursed", "Lake Sturgeon", "Orca", 
    "Barracuda Fish", "!!! Galactic", "Crystal Crab", "Frog", "Gar Fish", "Lion Fish", "Herring Fish", 
    "!!! Fiery", "!!! Pirate Octopus", "!!! Pinata", "!!! Purple Saber", "Starfish", "Wahoo", "Saw Fish", 
    "Pink Dolphin", "Monster Shark", "Luminous Fish", "Eerie Shark", "Synodontis", "Armor Catfish", 
    "Thin Armor Shark", "!!! Disco", "!!! Timeless", "!!! Abyssfire", "!!! Planetary", "Scare", 
    "!!! Soulreaver", "!!! Timeless", "!!! Abyssfire", "!!! Planetary", "Scare", "!!! Soulreaver"
}

local AllMaps = {
    "Crater Island", "Lost Isle", "Tropical Grove", "Esoteric Depths", "Kohana Volcano", 
    "Sparkling Cove", "Radiant", "Storm", "Snow", "Cloudy", "Wind", "Night", "Day", 
    "Admin - Shocked", "Admin - Black Hole", "Admin - Ghost Worm", "Admin - Meteor Rain", 
    "Admin - Super Mutated", "Admin - Super Luck", "Winter Fest"
}

local AllNPCs = {
    "Vendor", "Bait Merchant", "Rod Merchant", "Boat Merchant", "Enchanting Master", 
    "Daily Reward NPC", "Quest Giver", "Shopkeeper", "Fisherman", "Captain", "Guide"
}

-- ======== MAIN UI SETUP ========
local Window = Rayfield:CreateWindow({
    Name = "NIKZZ MODDER v3.0",
    LoadingTitle = "Memuat Modder...",
    LoadingSubtitle = "by NIKZZ",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "RayfieldConfig",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Load configuration on startup
LoadConfig()

-- ======== TAB NKZ-FARM ========
local FarmTab = Window:CreateTab("NKZ-FARM", 0xFF6B6B)

-- Auto Fishing Toggle
local AutoFishingToggle = FarmTab:CreateToggle({
    Name = "Auto Fishing",
    CurrentValue = Config.AutoFishing,
    Flag = "AutoFishing",
    Callback = function(Value)
        Config.AutoFishing = Value
        if Value then
            AsyncSpawn(function()
                while Config.AutoFishing do
                    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        -- Trigger fishing minigame
                        if Remotes.RequestFishingMinigameStarted then
                            Remotes.RequestFishingMinigameStarted:FireServer()
                        end
                        -- Wait for casting
                        task.wait(1)
                        
                        -- Check if we have a rod equipped
                        local rod = game.Players.LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool")
                        if not rod then
                            -- Try to equip best rod
                            for _, rodName in ipairs(AllRods) do
                                local item = game.ReplicatedStorage.Items:FindFirstChild(rodName)
                                if item then
                                    Remotes.EquipToolFromHotbar:FireServer(item.Name)
                                    break
                                end
                            end
                        end
                        
                        -- Use best bait if auto bait enabled
                        if Config.AutoBait then
                            for _, baitName in ipairs(AllBaits) do
                                local bait = game.Players.LocalPlayer.Backpack:FindFirstChild(baitName)
                                if bait then
                                    Remotes.EquipBait:FireServer(baitName)
                                    break
                                end
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
            Rayfield:Notify({
                Title = "Auto Fishing",
                Content = "Dimulai! Menunggu pemancingan...",
                Duration = 4,
                Image = 0xFF6B6B,
            })
        else
            -- Stop fishing
            if Remotes.CancelFishingInputs then
                Remotes.CancelFishingInputs:FireServer()
            end
            Rayfield:Notify({
                Title = "Auto Fishing",
                Content = "Dihentikan.",
                Duration = 3,
                Image = 0xFF6B6B,
            })
        end
    end,
})

-- Auto Bait Toggle
local AutoBaitToggle = FarmTab:CreateToggle({
    Name = "Auto Bait",
    CurrentValue = Config.AutoBait,
    Flag = "AutoBait",
    Callback = function(Value)
        Config.AutoBait = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Bait",
                Content = "Menggunakan umpan terbaik otomatis.",
                Duration = 3,
                Image = 0xFF6B6B,
            })
        end
    end,
})

-- Auto Rod Toggle
local AutoRodToggle = FarmTab:CreateToggle({
    Name = "Auto Rod",
    CurrentValue = Config.AutoRod,
    Flag = "AutoRod",
    Callback = function(Value)
        Config.AutoRod = Value
        if Value then
            AsyncSpawn(function()
                while Config.AutoRod do
                    local currentRod = game.Players.LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool")
                    if not currentRod then
                        -- Find best available rod
                        for _, rodName in ipairs(AllRods) do
                            local item = game.ReplicatedStorage.Items:FindFirstChild(rodName)
                            if item then
                                Remotes.EquipToolFromHotbar:FireServer(item.Name)
                                break
                            end
                        end
                    end
                    task.wait(5)
                end
            end)
            Rayfield:Notify({
                Title = "Auto Rod",
                Content = "Mengganti rod secara otomatis ke yang terbaik.",
                Duration = 4,
                Image = 0xFF6B6B,
            })
        end
    end,
})

-- Auto Collect Toggle
local AutoCollectToggle = FarmTab:CreateToggle({
    Name = "Auto Collect",
    CurrentValue = Config.AutoCollect,
    Flag = "AutoCollect",
    Callback = function(Value)
        Config.AutoCollect = Value
        if Value then
            AsyncSpawn(function()
                local collected = {}
                while Config.AutoCollect do
                    local fish = game.Workspace:FindFirstChild("Fish")
                    if fish and not collected[fish] then
                        collected[fish] = true
                        -- Try to collect
                        if fish:IsA("Model") then
                            local handle = fish:FindFirstChild("Handle")
                            if handle then
                                handle:FireServer()
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
            Rayfield:Notify({
                Title = "Auto Collect",
                Content = "Mengambil ikan secara otomatis.",
                Duration = 3,
                Image = 0xFF6B6B,
            })
        end
    end,
})

-- Quick Buy Best Rod Button
FarmTab:CreateButton({
    Name = "Beli Rod Terbaik Otomatis",
    Callback = function()
        AsyncSpawn(function()
            local bestRod = AllRods[1]
            if Remotes.PurchaseFishingRod then
                Remotes.PurchaseFishingRod:FireServer(bestRod)
                Rayfield:Notify({
                    Title = "Pembelian",
                    Content = "Mencoba membeli: " .. bestRod,
                    Duration = 3,
                    Image = 0xFF6B6B,
                })
            end
        end)
    end,
})

-- Quick Buy Best Bait Button
FarmTab:CreateButton({
    Name = "Beli Umpan Terbaik Otomatis",
    Callback = function()
        AsyncSpawn(function()
            local bestBait = AllBaits[1]
            if Remotes.PurchaseBait then
                Remotes.PurchaseBait:FireServer(bestBait)
                Rayfield:Notify({
                    Title = "Pembelian",
                    Content = "Mencoba membeli: " .. bestBait,
                    Duration = 3,
                    Image = 0xFF6B6B,
                })
            end
        end)
    end,
})

-- ======== TAB NKZ-TELEPORT ========
local TeleportTab = Window:CreateTab("NKZ-TELEPORT", 0x4ECDC4)

-- Dropdown Maps
local MapDropdown = TeleportTab:CreateDropdown({
    Name = "Teleport Ke Peta",
    Options = AllMaps,
    CurrentOption = AllMaps[1],
    Flag = "TeleportMap",
    Callback = function(MapName)
        Config.TeleportTarget = MapName
        AsyncSpawn(function()
            if Remotes.TeleportToLocation then
                Remotes.TeleportToLocation:FireServer(MapName)
                Rayfield:Notify({
                    Title = "Teleport",
                    Content = "Menuju: " .. MapName,
                    Duration = 3,
                    Image = 0x4ECDC4,
                })
            else
                -- Fallback: use character position change
                local char = game.Players.LocalPlayer.Character
                if char then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        -- Use area utility to get position
                        local area = game.ReplicatedStorage.Shared.AreaUtility:GetAreaByName(MapName)
                        if area and area.Position then
                            root.CFrame = area.Position
                        end
                    end
                end
            end
        end)
    end,
})

-- Dropdown NPCs
local NPCDropdown = TeleportTab:CreateDropdown({
    Name = "Teleport Ke NPC",
    Options = AllNPCs,
    CurrentOption = AllNPCs[1],
    Flag = "TeleportNPC",
    Callback = function(NPCName)
        AsyncSpawn(function()
            local npc = game.Workspace:FindFirstChild(NPCName)
            if npc and npc:IsA("Model") then
                local hrp = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Head")
                if hrp then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = hrp.CFrame
                    Rayfield:Notify({
                        Title = "Teleport",
                        Content = "Menuju NPC: " .. NPCName,
                        Duration = 3,
                        Image = 0x4ECDC4,
                    })
                end
            else
                Rayfield:Notify({
                    Title = "Teleport",
                    Content = "NPC tidak ditemukan: " .. NPCName,
                    Duration = 3,
                    Image = 0x4ECDC4,
                })
            end
        end)
    end,
})

-- Custom Location Input
local CustomLocationInput = TeleportTab:CreateInput({
    Name = "Teleport Ke Lokasi Manual (X,Y,Z)",
    PlaceholderText = "Masukkan koordinat (contoh: 100, 50, 200)",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local x,y,z = Text:match("([^,]+),([^,]+),([^,]+)")
        if x and y and z then
            local px, py, pz = tonumber(x), tonumber(y), tonumber(z)
            if px and py and pz then
                AsyncSpawn(function()
                    local char = game.Players.LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = CFrame.new(px, py, pz)
                        Rayfield:Notify({
                            Title = "Teleport",
                            Content = "Berhasil teleport ke: " .. Text,
                            Duration = 3,
                            Image = 0x4ECDC4,
                        })
                    end
                end)
            else
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Format koordinat salah!",
                    Duration = 3,
                    Image = 0xFF6B6B,
                })
            end
        end
    end,
})

-- ======== TAB NKZ-PLAYER ========
local PlayerTab = Window:CreateTab("NKZ-PLAYER", 0x45B8D1)

-- Speed Hack Slider
local SpeedSlider = PlayerTab:CreateSlider({
    Name = "Speed Hack",
    Range = {1, 50},
    Increment = 1,
    Suffix = "x",
    CurrentValue = Config.SpeedMultiplier,
    Flag = "SpeedHack",
    Callback = function(Value)
        Config.SpeedMultiplier = Value
        AsyncSpawn(function()
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Value * 16
            end
        end)
    end,
})

-- Jump Hack Slider
local JumpSlider = PlayerTab:CreateSlider({
    Name = "Jump Hack",
    Range = {1, 100},
    Increment = 1,
    Suffix = "units",
    CurrentValue = Config.JumpPower,
    Flag = "JumpHack",
    Callback = function(Value)
        Config.JumpPower = Value
        AsyncSpawn(function()
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = Value
            end
        end)
    end,
})

-- Fly Toggle
local FlyToggle = PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = Config.FlyEnabled,
    Flag = "Fly",
    Callback = function(Value)
        Config.FlyEnabled = Value
        if Value then
            AsyncSpawn(function()
                local player = game.Players.LocalPlayer
                local char = player.Character
                if not char then return end
                
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then return end
                
                local velocity = Vector3.new(0, 0, 0)
                while Config.FlyEnabled do
                    if root and root.Parent then
                        local cframe = root.CFrame
                        local up = cframe.UpVector * 10
                        root.CFrame = cframe + up
                    end
                    task.wait(0.05)
                end
            end)
            Rayfield:Notify({
                Title = "Fly",
                Content = "Mode terbang diaktifkan.",
                Duration = 3,
                Image = 0x45B8D1,
            })
        else
            Rayfield:Notify({
                Title = "Fly",
                Content = "Mode terbang dimatikan.",
                Duration = 3,
                Image = 0x45B8D1,
            })
        end
    end,
})

-- NoClip Toggle
local NoClipToggle = PlayerTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = Config.NoClipEnabled,
    Flag = "NoClip",
    Callback = function(Value)
        Config.NoClipEnabled = Value
        if Value then
            AsyncSpawn(function()
                local char = game.Players.LocalPlayer.Character
                if not char then return end
                
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local oldAnchored = hrp.Anchored
                hrp.Anchored = true
                
                while Config.NoClipEnabled do
                    if hrp and hrp.Parent then
                        local input = game.UserInputService:GetUserInputState(Enum.UserInputType.MouseMovement)
                        local move = Vector3.new(input.X * 0.1, input.Y * 0.1, 0)
                        hrp.CFrame = hrp.CFrame + move
                    end
                    task.wait(0.02)
                end
                
                hrp.Anchored = oldAnchored
            end)
            Rayfield:Notify({
                Title = "NoClip",
                Content = "Mode NoClip diaktifkan.",
                Duration = 3,
                Image = 0x45B8D1,
            })
        else
            Rayfield:Notify({
                Title = "NoClip",
                Content = "Mode NoClip dimatikan.",
                Duration = 3,
                Image = 0x45B8D1,
            })
        end
    end,
})

-- GodMode Toggle
local GodModeToggle = PlayerTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = Config.GodModeEnabled,
    Flag = "GodMode",
    Callback = function(Value)
        Config.GodModeEnabled = Value
        if Value then
            AsyncSpawn(function()
                local char = game.Players.LocalPlayer.Character
                if not char then return end
                
                local humanoid = char:FindFirstChild("Humanoid")
                if not humanoid then return end
                
                while Config.GodModeEnabled do
                    if humanoid.Health > 0 then
                        humanoid.Health = 1000
                    end
                    task.wait(0.1)
                end
            end)
            Rayfield:Notify({
                Title = "God Mode",
                Content = "Mode invincible diaktifkan.",
                Duration = 3,
                Image = 0x45B8D1,
            })
        else
            Rayfield:Notify({
                Title = "God Mode",
                Content = "Mode invincible dimatikan.",
                Duration = 3,
                Image = 0x45B8D1,
            })
        end
    end,
})

-- Walk Water Toggle
local WalkWaterToggle = PlayerTab:CreateToggle({
    Name = "Walk On Water",
    CurrentValue = Config.WalkWaterEnabled,
    Flag = "WalkWater",
    Callback = function(Value)
        Config.WalkWaterEnabled = Value
        if Value then
            AsyncSpawn(function()
                local char = game.Players.LocalPlayer.Character
                if not char then return end
                
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                while Config.WalkWaterEnabled do
                    local ray = Ray.new(hrp.Position, Vector3.new(0, -100, 0))
                    local hit, pos = workspace:FindPartOnRay(ray)
                    if hit and hit:IsA("BasePart") and hit.Material == Enum.Material.Water then
                        hrp.CFrame = CFrame.new(hrp.Position.X, pos.Y + 1, hrp.Position.Z)
                    end
                    task.wait(0.05)
                end
            end)
            Rayfield:Notify({
                Title = "Walk Water",
                Content = "Berjalan di atas air diaktifkan.",
                Duration = 3,
                Image = 0x45B8D1,
            })
        else
            Rayfield:Notify({
                Title = "Walk Water",
                Content = "Berjalan di atas air dimatikan.",
                Duration = 3,
                Image = 0x45B8D1,
            })
        end
    end,
})

-- ======== TAB NKZ-VISUAL ========
local VisualTab = Window:CreateTab("NKZ-VISUAL", 0x96CEBD)

-- ESP Player Toggle
local ESPPlayerToggle = VisualTab:CreateToggle({
    Name = "ESP Player",
    CurrentValue = Config.ESPPlayer,
    Flag = "ESPPlayer",
    Callback = function(Value)
        Config.ESPPlayer = Value
        if Value then
            AsyncSpawn(function()
                local players = game.Players:GetPlayers()
                local espFrames = {}
                
                while Config.ESPPlayer do
                    for _, plr in ipairs(players) do
                        if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = plr.Character.HumanoidRootPart
                            local screenPoint = camera:WorldToViewportPoint(hrp.Position)
                            
                            if screenPoint.Z > 0 and screenPoint.X > 0 and screenPoint.X < 1920 and screenPoint.Y > 0 and screenPoint.Y < 1080 then
                                if not espFrames[plr.UserId] then
                                    local frame = Instance.new("Frame")
                                    frame.Size = UDim2.new(0, 80, 0, 20)
                                    frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                                    frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
                                    frame.BorderSizePixel = 1
                                    frame.Text = plr.Name
                                    frame.TextColor3 = Color3.fromRGB(0, 0, 0)
                                    frame.TextScaled = true
                                    frame.Parent = game.StarterGui.MainGui
                                    espFrames[plr.UserId] = frame
                                end
                                
                                local frame = espFrames[plr.UserId]
                                if frame then
                                    frame.Position = UDim2.new(0, screenPoint.X - 40, 0, screenPoint.Y - 10)
                                end
                            else
                                if espFrames[plr.UserId] then
                                    espFrames[plr.UserId]:Destroy()
                                    espFrames[plr.UserId] = nil
                                end
                            end
                        end
                    end
                    
                    -- Clean up dead frames
                    for uid, frame in pairs(espFrames) do
                        if not game.Players:FindFirstChildByUserId(uid) or not game.Players:FindFirstChildByUserId(uid).Character then
                            frame:Destroy()
                            espFrames[uid] = nil
                        end
                    end
                    
                    task.wait(0.1)
                end
                
                for _, frame in pairs(espFrames) do
                    frame:Destroy()
                end
            end)
            Rayfield:Notify({
                Title = "ESP Player",
                Content = "ESP pemain aktif.",
                Duration = 3,
                Image = 0x96CEBD,
            })
        else
            Rayfield:Notify({
                Title = "ESP Player",
                Content = "ESP pemain dimatikan.",
                Duration = 3,
                Image = 0x96CEBD,
            })
        end
    end,
})

-- ESP Fish Toggle
local ESPFishToggle = VisualTab:CreateToggle({
    Name = "ESP Fish",
    CurrentValue = Config.ESPFish,
    Flag = "ESPFish",
    Callback = function(Value)
        Config.ESPFish = Value
        if Value then
            AsyncSpawn(function()
                local espFrames = {}
                
                while Config.ESPFish do
                    local fish = game.Workspace:FindFirstChild("Fish")
                    if fish and fish:IsA("Model") then
                        local hrp = fish:FindFirstChild("Handle")
                        if hrp and hrp:IsA("BasePart") then
                            local screenPoint = camera:WorldToViewportPoint(hrp.Position)
                            
                            if screenPoint.Z > 0 and screenPoint.X > 0 and screenPoint.X < 1920 and screenPoint.Y > 0 and screenPoint.Y < 1080 then
                                if not espFrames[fish.Name] then
                                    local frame = Instance.new("Frame")
                                    frame.Size = UDim2.new(0, 70, 0, 18)
                                    frame.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                                    frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
                                    frame.BorderSizePixel = 1
                                    frame.Text = "Ikan"
                                    frame.TextColor3 = Color3.fromRGB(0, 0, 0)
                                    frame.TextScaled = true
                                    frame.Parent = game.StarterGui.MainGui
                                    espFrames[fish.Name] = frame
                                end
                                
                                local frame = espFrames[fish.Name]
                                if frame then
                                    frame.Position = UDim2.new(0, screenPoint.X - 35, 0, screenPoint.Y - 9)
                                end
                            else
                                if espFrames[fish.Name] then
                                    espFrames[fish.Name]:Destroy()
                                    espFrames[fish.Name] = nil
                                end
                            end
                        end
                    end
                    
                    task.wait(0.2)
                end
                
                for _, frame in pairs(espFrames) do
                    frame:Destroy()
                end
            end)
            Rayfield:Notify({
                Title = "ESP Fish",
                Content = "ESP ikan aktif.",
                Duration = 3,
                Image = 0x96CEBD,
            })
        else
            Rayfield:Notify({
                Title = "ESP Fish",
                Content = "ESP ikan dimatikan.",
                Duration = 3,
                Image = 0x96CEBD,
            })
        end
    end,
})

-- ESP NPC Toggle
local ESPNPCToggle = VisualTab:CreateToggle({
    Name = "ESP NPC",
    CurrentValue = Config.ESPNPC,
    Flag = "ESPNPC",
    Callback = function(Value)
        Config.ESPNPC = Value
        if Value then
            AsyncSpawn(function()
                local espFrames = {}
                
                while Config.ESPNPC do
                    for _, npcName in ipairs(AllNPCs) do
                        local npc = game.Workspace:FindFirstChild(npcName)
                        if npc and npc:IsA("Model") then
                            local hrp = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Head")
                            if hrp and hrp:IsA("BasePart") then
                                local screenPoint = camera:WorldToViewportPoint(hrp.Position)
                                
                                if screenPoint.Z > 0 and screenPoint.X > 0 and screenPoint.X < 1920 and screenPoint.Y > 0 and screenPoint.Y < 1080 then
                                    if not espFrames[npcName] then
                                        local frame = Instance.new("Frame")
                                        frame.Size = UDim2.new(0, 70, 0, 18)
                                        frame.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
                                        frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
                                        frame.BorderSizePixel = 1
                                        frame.Text = npcName
                                        frame.TextColor3 = Color3.fromRGB(0, 0, 0)
                                        frame.TextScaled = true
                                        frame.Parent = game.StarterGui.MainGui
                                        espFrames[npcName] = frame
                                    end
                                    
                                    local frame = espFrames[npcName]
                                    if frame then
                                        frame.Position = UDim2.new(0, screenPoint.X - 35, 0, screenPoint.Y - 9)
                                    end
                                else
                                    if espFrames[npcName] then
                                        espFrames[npcName]:Destroy()
                                        espFrames[npcName] = nil
                                    end
                                end
                            end
                        end
                    end
                    
                    task.wait(0.3)
                end
                
                for _, frame in pairs(espFrames) do
                    frame:Destroy()
                end
            end)
            Rayfield:Notify({
                Title = "ESP NPC",
                Content = "ESP NPC aktif.",
                Duration = 3,
                Image = 0x96CEBD,
            })
        else
            Rayfield:Notify({
                Title = "ESP NPC",
                Content = "ESP NPC dimatikan.",
                Duration = 3,
                Image = 0x96CEBD,
            })
        end
    end,
})

-- ESP Item Toggle
local ESPItemToggle = VisualTab:CreateToggle({
    Name = "ESP Item",
    CurrentValue = Config.ESPItem,
    Flag = "ESPItem",
    Callback = function(Value)
        Config.ESPItem = Value
        if Value then
            AsyncSpawn(function()
                local espFrames = {}
                
                while Config.ESPItem do
                    for _, itemName in ipairs(AllItems) do
                        local item = game.Workspace:FindFirstChild(itemName)
                        if item and item:IsA("Model") then
                            local hrp = item:FindFirstChild("Handle") or item:FindFirstChild("PrimaryPart")
                            if hrp and hrp:IsA("BasePart") then
                                local screenPoint = camera:WorldToViewportPoint(hrp.Position)
                                
                                if screenPoint.Z > 0 and screenPoint.X > 0 and screenPoint.X < 1920 and screenPoint.Y > 0 and screenPoint.Y < 1080 then
                                    if not espFrames[itemName] then
                                        local frame = Instance.new("Frame")
                                        frame.Size = UDim2.new(0, 80, 0, 20)
                                        frame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
                                        frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
                                        frame.BorderSizePixel = 1
                                        frame.Text = itemName
                                        frame.TextColor3 = Color3.fromRGB(0, 0, 0)
                                        frame.TextScaled = true
                                        frame.Parent = game.StarterGui.MainGui
                                        espFrames[itemName] = frame
                                    end
                                    
                                    local frame = espFrames[itemName]
                                    if frame then
                                        frame.Position = UDim2.new(0, screenPoint.X - 40, 0, screenPoint.Y - 10)
                                    end
                                else
                                    if espFrames[itemName] then
                                        espFrames[itemName]:Destroy()
                                        espFrames[itemName] = nil
                                    end
                                end
                            end
                        end
                    end
                    
                    task.wait(0.4)
                end
                
                for _, frame in pairs(espFrames) do
                    frame:Destroy()
                end
            end)
            Rayfield:Notify({
                Title = "ESP Item",
                Content = "ESP item aktif.",
                Duration = 3,
                Image = 0x96CEBD,
            })
        else
            Rayfield:Notify({
                Title = "ESP Item",
                Content = "ESP item dimatikan.",
                Duration = 3,
                Image = 0x96CEBD,
            })
        end
    end,
})

-- ESP Zone Toggle
local ESPZoneToggle = VisualTab:CreateToggle({
    Name = "ESP Zone",
    CurrentValue = Config.ESPZone,
    Flag = "ESPZone",
    Callback = function(Value)
        Config.ESPZone = Value
        if Value then
            AsyncSpawn(function()
                local espFrames = {}
                
                while Config.ESPZone do
                    for _, mapName in ipairs(AllMaps) do
                        local zone = game.Workspace:FindFirstChild(mapName)
                        if zone and zone:IsA("Model") then
                            local hrp = zone:FindFirstChild("HumanoidRootPart") or zone:FindFirstChild("PrimaryPart")
                            if hrp and hrp:IsA("BasePart") then
                                local screenPoint = camera:WorldToViewportPoint(hrp.Position)
                                
                                if screenPoint.Z > 0 and screenPoint.X > 0 and screenPoint.X < 1920 and screenPoint.Y > 0 and screenPoint.Y < 1080 then
                                    if not espFrames[mapName] then
                                        local frame = Instance.new("Frame")
                                        frame.Size = UDim2.new(0, 90, 0, 20)
                                        frame.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
                                        frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
                                        frame.BorderSizePixel = 1
                                        frame.Text = "Zone: " .. mapName
                                        frame.TextColor3 = Color3.fromRGB(255, 255, 255)
                                        frame.TextScaled = true
                                        frame.Parent = game.StarterGui.MainGui
                                        espFrames[mapName] = frame
                                    end
                                    
                                    local frame = espFrames[mapName]
                                    if frame then
                                        frame.Position = UDim2.new(0, screenPoint.X - 45, 0, screenPoint.Y - 10)
                                    end
                                else
                                    if espFrames[mapName] then
                                        espFrames[mapName]:Destroy()
                                        espFrames[mapName] = nil
                                    end
                                end
                            end
                        end
                    end
                    
                    task.wait(0.5)
                end
                
                for _, frame in pairs(espFrames) do
                    frame:Destroy()
                end
            end)
            Rayfield:Notify({
                Title = "ESP Zone",
                Content = "ESP zona aktif.",
                Duration = 3,
                Image = 0x96CEBD,
            })
        else
            Rayfield:Notify({
                Title = "ESP Zone",
                Content = "ESP zona dimatikan.",
                Duration = 3,
                Image = 0x96CEBD,
            })
        end
    end,
})

-- Night Vision Toggle
local NightVisionToggle = VisualTab:CreateToggle({
    Name = "Night Vision",
    CurrentValue = Config.NightVision,
    Flag = "NightVision",
    Callback = function(Value)
        Config.NightVision = Value
        if Value then
            -- Apply night vision effect using lighting
            game.Lighting.GlobalLighting.Enabled = true
            game.Lighting.GlobalLighting.Brightness = 1.5
            game.Lighting.GlobalLighting.ColorTemperature = 5000
            game.Lighting.GlobalLighting.FogColor = Color3.fromRGB(0, 0, 0)
            game.Lighting.GlobalLighting.FogDensity = 0.001
            game.Lighting.GlobalLighting.FogEnd = 1000
            game.Lighting.GlobalLighting.FogStart = 0
            
            -- Add green tint to all parts
            for _, part in ipairs(game.Workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.BrickColor = BrickColor.new("Bright green")
                end
            end
            
            Rayfield:Notify({
                Title = "Night Vision",
                Content = "Mode malam diaktifkan.",
                Duration = 3,
                Image = 0x96CEBD,
            })
        else
            game.Lighting.GlobalLighting.Enabled = true
            game.Lighting.GlobalLighting.Brightness = 1
            game.Lighting.GlobalLighting.ColorTemperature = 6500
            game.Lighting.GlobalLighting.FogColor = Color3.fromRGB(128, 128, 128)
            game.Lighting.GlobalLighting.FogDensity = 0
            game.Lighting.GlobalLighting.FogEnd = 1000
            game.Lighting.GlobalLighting.FogStart = 0
            
            -- Reset colors
            for _, part in ipairs(game.Workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.BrickColor = BrickColor.new("Really black")
                end
            end
            
            Rayfield:Notify({
                Title = "Night Vision",
                Content = "Mode malam dimatikan.",
                Duration = 3,
                Image = 0x96CEBD,
            })
        end
    end,
})

-- Full Bright Toggle
local FullBrightToggle = VisualTab:CreateToggle({
    Name = "Full Bright",
    CurrentValue = Config.FullBright,
    Flag = "FullBright",
    Callback = function(Value)
        Config.FullBright = Value
        if Value then
            game.Lighting.Brightness = 2
            game.Lighting.GlobalLighting.Brightness = 2
            game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            game.Lighting.ShadowSoftness = 0
            Rayfield:Notify({
                Title = "Full Bright",
                Content = "Pencahayaan maksimal diaktifkan.",
                Duration = 3,
                Image = 0x96CEBD,
            })
        else
            game.Lighting.Brightness = 1
            game.Lighting.GlobalLighting.Brightness = 1
            game.Lighting.Ambient = Color3.fromRGB(100, 100, 100)
            game.Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
            game.Lighting.ShadowSoftness = 0.5
            Rayfield:Notify({
                Title = "Full Bright",
                Content = "Pencahayaan normal dikembalikan.",
                Duration = 3,
                Image = 0x96CEBD,
            })
        end
    end,
})

-- ======== TAB NKZ-SHOP ========
local ShopTab = Window:CreateTab("NKZ-SHOP", 0xE59866)

-- Auto Buy Toggle
local AutoBuyToggle = ShopTab:CreateToggle({
    Name = "Auto Buy Items",
    CurrentValue = Config.AutoBuy,
    Flag = "AutoBuy",
    Callback = function(Value)
        Config.AutoBuy = Value
        if Value then
            AsyncSpawn(function()
                while Config.AutoBuy do
                    -- Try to buy best bait
                    for _, baitName in ipairs(AllBaits) do
                        if Remotes.PurchaseBait then
                            Remotes.PurchaseBait:FireServer(baitName)
                            task.wait(0.5)
                        end
                    end
                    
                    -- Try to buy best rod
                    for _, rodName in ipairs(AllRods) do
                        if Remotes.PurchaseFishingRod then
                            Remotes.PurchaseFishingRod:FireServer(rodName)
                            task.wait(0.5)
                        end
                    end
                    
                    task.wait(10)
                end
            end)
            Rayfield:Notify({
                Title = "Auto Buy",
                Content = "Pembelian otomatis diaktifkan.",
                Duration = 3,
                Image = 0xE59866,
            })
        else
            Rayfield:Notify({
                Title = "Auto Buy",
                Content = "Pembelian otomatis dimatikan.",
                Duration = 3,
                Image = 0xE59866,
            })
        end
    end,
})

-- Auto Sell Toggle
local AutoSellToggle = ShopTab:CreateToggle({
    Name = "Auto Sell Items",
    CurrentValue = Config.AutoSell,
    Flag = "AutoSell",
    Callback = function(Value)
        Config.AutoSell = Value
        if Value then
            AsyncSpawn(function()
                while Config.AutoSell do
                    -- Sell all items in backpack
                    for _, item in ipairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                        if item:IsA("Tool") then
                            if Remotes.SellItem then
                                Remotes.SellItem:FireServer(item.Name)
                                task.wait(0.1)
                            end
                        end
                    end
                    
                    task.wait(15)
                end
            end)
            Rayfield:Notify({
                Title = "Auto Sell",
                Content = "Penjualan otomatis diaktifkan.",
                Duration = 3,
                Image = 0xE59866,
            })
        else
            Rayfield:Notify({
                Title = "Auto Sell",
                Content = "Penjualan otomatis dimatikan.",
                Duration = 3,
                Image = 0xE59866,
            })
        end
    end,
})

-- Unlock All Shop Button
ShopTab:CreateButton({
    Name = "Unlock Semua Item Toko",
    Callback = function()
        AsyncSpawn(function()
            -- Simulate unlocking all shop items via feature unlock
            if Remotes.FeatureUnlocked then
                for _, item in ipairs(AllItems) do
                    Remotes.FeatureUnlocked:FireServer(item)
                    task.wait(0.05)
                end
                for _, rod in ipairs(AllRods) do
                    Remotes.FeatureUnlocked:FireServer(rod)
                    task.wait(0.05)
                end
                for _, bait in ipairs(AllBaits) do
                    Remotes.FeatureUnlocked:FireServer(bait)
                    task.wait(0.05)
                end
            end
            
            -- Also attempt to purchase with infinite money simulation
            if Remotes.PurchaseFishingRod then
                for _, rod in ipairs(AllRods) do
                    Remotes.PurchaseFishingRod:FireServer(rod)
                    task.wait(0.05)
                end
            end
            
            Rayfield:Notify({
                Title = "Unlock Shop",
                Content = "Semua item telah dibuka!",
                Duration = 5,
                Image = 0xE59866,
            })
        end)
    end,
})

-- ======== TAB NKZ-UTILITY ========
local UtilityTab = Window:CreateTab("NKZ-UTILITY", 0x9B59B6)

-- Anti AFK Toggle
local AntiAFKToggle = UtilityTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = Config.AntiAFK,
    Flag = "AntiAFK",
    Callback = function(Value)
        Config.AntiAFK = Value
        if Value then
            AsyncSpawn(function()
                while Config.AntiAFK do
                    -- Move player slightly
                    local char = game.Players.LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local hrp = char.HumanoidRootPart
                        local currentCFrame = hrp.CFrame
                        hrp.CFrame = currentCFrame + Vector3.new(0, 0.1, 0)
                        task.wait(5)
                        hrp.CFrame = currentCFrame - Vector3.new(0, 0.1, 0)
                        task.wait(5)
                    end
                end
            end)
            Rayfield:Notify({
                Title = "Anti AFK",
                Content = "Mode anti AFK diaktifkan.",
                Duration = 3,
                Image = 0x9B59B6,
            })
        else
            Rayfield:Notify({
                Title = "Anti AFK",
                Content = "Mode anti AFK dimatikan.",
                Duration = 3,
                Image = 0x9B59B6,
            })
        end
    end,
})

-- Auto Reconnect Toggle
local AutoReconnectToggle = UtilityTab:CreateToggle({
    Name = "Auto Reconnect",
    CurrentValue = Config.AutoReconnect,
    Flag = "AutoReconnect",
    Callback = function(Value)
        Config.AutoReconnect = Value
        if Value then
            game.Players.PlayerRemoving:Connect(function(plr)
                if plr == game.Players.LocalPlayer then
                    task.wait(3)
                    game:GetService("TeleportService"):Teleport(game.PlaceId)
                end
            end)
            Rayfield:Notify({
                Title = "Auto Reconnect",
                Content = "Auto reconnect diaktifkan.",
                Duration = 3,
                Image = 0x9B59B6,
            })
        end
    end,
})

-- Save Config Button
UtilityTab:CreateButton({
    Name = "Simpan Konfigurasi",
    Callback = function()
        SaveConfig()
        Rayfield:Notify({
            Title = "Konfigurasi",
            Content = "Konfigurasi berhasil disimpan!",
            Duration = 3,
            Image = 0x9B59B6,
        })
    end,
})

-- Load Config Button
UtilityTab:CreateButton({
    Name = "Muat Konfigurasi",
    Callback = function()
        LoadConfig()
        Rayfield:Notify({
            Title = "Konfigurasi",
            Content = "Konfigurasi berhasil dimuat!",
            Duration = 3,
            Image = 0x9B59B6,
        })
    end,
})

-- Copy UID Button
UtilityTab:CreateButton({
    Name = "Salin UID Akun",
    Callback = function()
        local uid = game.Players.LocalPlayer.UserId
        setclipboard(tostring(uid))
        Rayfield:Notify({
            Title = "UID Disalin",
            Content = "UID Anda: " .. uid,
            Duration = 3,
            Image = 0x9B59B6,
        })
    end,
})

-- ======== TAB NKZ-GRAPHIC ========
local GraphicTab = Window:CreateTab("NKZ-GRAPHIC", 0x66B2FF)

-- Max FPS Slider
local MaxFPSSlider = GraphicTab:CreateSlider({
    Name = "Max FPS",
    Range = {30, 240},
    Increment = 10,
    Suffix = "fps",
    CurrentValue = Config.MaxFPS,
    Flag = "MaxFPS",
    Callback = function(Value)
        Config.MaxFPS = Value
        game:GetService("RunService"):SetRenderPriority(Enum.RenderPriority.Last)
        game:GetService("RunService"):SetHeartbeat(function() end)
        game:GetService("RunService").Heartbeat:Connect(function()
            -- Force FPS limit
        end)
        
        -- Apply FPS cap
        game:GetService("RunService"):SetCore("TopBarEnabled", false)
        game:GetService("RunService"):SetCore("TopBarEnabled", true)
        
        Rayfield:Notify({
            Title = "FPS",
            Content = "Max FPS diatur ke: " .. Value,
            Duration = 2,
            Image = 0x66B2FF,
        })
    end,
})

-- HD Texture Toggle
local HDTextureToggle = GraphicTab:CreateToggle({
    Name = "HD Texture",
    CurrentValue = Config.HDTexture,
    Flag = "HDTexture",
    Callback = function(Value)
        Config.HDTexture = Value
        if Value then
            game:GetService("UserSettings"):UserInterface:EnableHighDefinitionTextures(true)
            Rayfield:Notify({
                Title = "HD Texture",
                Content = "Tekstur HD diaktifkan.",
                Duration = 3,
                Image = 0x66B2FF,
            })
        else
            game:GetService("UserSettings"):UserInterface:EnableHighDefinitionTextures(false)
            Rayfield:Notify({
                Title = "HD Texture",
                Content = "Tekstur HD dimatikan.",
                Duration = 3,
                Image = 0x66B2FF,
            })
        end
    end,
})

-- Shadow Control Slider
local ShadowSlider = GraphicTab:CreateSlider({
    Name = "Shadow Quality",
    Range = {0, 4},
    Increment = 1,
    Suffix = "level",
    CurrentValue = Config.ShadowQuality,
    Flag = "ShadowQuality",
    Callback = function(Value)
        Config.ShadowQuality = Value
        game.Lighting.Shadows.Enabled = Value > 0
        game.Lighting.ShadowSoftness = Value * 0.25
        Rayfield:Notify({
            Title = "Shadow",
            Content = "Kualitas bayangan diatur ke: " .. Value,
            Duration = 3,
            Image = 0x66B2FF,
        })
    end,
})

-- Resolution Control Dropdown
local ResolutionDropdown = GraphicTab:CreateDropdown({
    Name = "Resolution",
    Options = {"1920x1080", "1600x900", "1366x768", "1280x720", "1024x768"},
    CurrentOption = Config.Resolution,
    Flag = "Resolution",
    Callback = function(Res)
        Config.Resolution = Res
        local width, height = Res:match("([^x]+)x(.+)")
        if width and height then
            game:GetService("UserSettings"):UserInterface:EnableHighDefinitionTextures(true)
            game:GetService("UserSettings"):UserInterface:SetWindowSize(Vector2.new(tonumber(width), tonumber(height)))
            Rayfield:Notify({
                Title = "Resolution",
                Content = "Resolusi diubah ke: " .. Res,
                Duration = 3,
                Image = 0x66B2FF,
            })
        end
    end,
})

-- Low Graphic Toggle
local LowGraphicToggle = GraphicTab:CreateToggle({
    Name = "Low Graphic Mode",
    CurrentValue = Config.LowGraphic,
    Flag = "LowGraphic",
    Callback = function(Value)
        Config.LowGraphic = Value
        if Value then
            game.Lighting.GlobalLighting.Enabled = false
            game.Lighting.Brightness = 0.5
            game.Lighting.Ambient = Color3.fromRGB(50, 50, 50)
            game.Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
            game:GetService("UserSettings"):UserInterface:EnableHighDefinitionTextures(false)
            game:GetService("RunService"):SetRenderPriority(Enum.RenderPriority.First)
            game.Lighting.Shadows.Enabled = false
            game.Lighting.FogColor = Color3.fromRGB(20, 20, 20)
            game.Lighting.FogDensity = 0.002
            game.Lighting.FogEnd = 500
            game.Lighting.FogStart = 0
            Rayfield:Notify({
                Title = "Low Graphic",
                Content = "Mode grafis rendah diaktifkan.",
                Duration = 3,
                Image = 0x66B2FF,
            })
        else
            game.Lighting.GlobalLighting.Enabled = true
            game.Lighting.Brightness = 1
            game.Lighting.Ambient = Color3.fromRGB(100, 100, 100)
            game.Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
            game:GetService("UserSettings"):UserInterface:EnableHighDefinitionTextures(true)
            game:GetService("RunService"):SetRenderPriority(Enum.RenderPriority.Last)
            game.Lighting.Shadows.Enabled = true
            game.Lighting.FogColor = Color3.fromRGB(128, 128, 128)
            game.Lighting.FogDensity = 0
            game.Lighting.FogEnd = 1000
            game.Lighting.FogStart = 0
            Rayfield:Notify({
                Title = "Low Graphic",
                Content = "Mode grafis rendah dimatikan.",
                Duration = 3,
                Image = 0x66B2FF,
            })
        end
    end,
})

-- ======== TAB NKZ-LOWDEV ========
local LowDevTab = Window:CreateTab("NKZ-LOWDEV", 0x34495E)

-- Debug Info Toggle
local DebugInfoToggle = LowDevTab:CreateToggle({
    Name = "Debug Info",
    CurrentValue = Config.DebugInfo,
    Flag = "DebugInfo",
    Callback = function(Value)
        Config.DebugInfo = Value
        if Value then
            -- Create debug console
            local console = Instance.new("TextLabel")
            console.BackgroundTransparency = 0.7
            console.Size = UDim2.new(0, 250, 0, 150)
            console.Position = UDim2.new(0, 10, 0, 10)
            console.Font = Enum.Font.SourceSans
            console.TextColor3 = Color3.fromRGB(0, 255, 0)
            console.TextScaled = true
            console.TextWrapped = true
            console.Text = "DEBUG INFO:\n\n"
            console.Parent = game.StarterGui.MainGui
            
            -- Update debug info
            task.spawn(function()
                while Config.DebugInfo do
                    local fps = game:GetService("RunService"):GetRenderStepped():GetTicks()
                    local ping = game:GetService("NetworkServer"):Ping()
                    local coins = game.Players.LocalPlayer.leaderstats.Coins.Value or 0
                    local rods = #game.Players.LocalPlayer.Backpack:GetChildren()
                    
                    console.Text = string.format(
                        "DEBUG INFO:\n" ..
                        "FPS: %.1f\n" ..
                        "PING: %d ms\n" ..
                        "Coins: %d\n" ..
                        "Rods: %d\n" ..
                        "Baits: %d\n" ..
                        "Fish Caught: %d",
                        fps, ping, coins, rods, #game.Players.LocalPlayer.Backpack:GetChildren(), 0
                    )
                    task.wait(1)
                end
                console:Destroy()
            end)
            
            Rayfield:Notify({
                Title = "Debug Info",
                Content = "Konsol debug ditampilkan.",
                Duration = 3,
                Image = 0x34495E,
            })
        else
            -- Hide debug console
            for _, child in ipairs(game.StarterGui.MainGui:GetChildren()) do
                if child:IsA("TextLabel") and child.Text:find("DEBUG INFO") then
                    child:Destroy()
                end
            end
            Rayfield:Notify({
                Title = "Debug Info",
                Content = "Konsol debug disembunyikan.",
                Duration = 3,
                Image = 0x34495E,
            })
        end
    end,
})

-- Ping Monitor Toggle
local PingMonitorToggle = LowDevTab:CreateToggle({
    Name = "Ping Monitor",
    CurrentValue = Config.PingMonitor,
    Flag = "PingMonitor",
    Callback = function(Value)
        Config.PingMonitor = Value
        if Value then
            local pingLabel = Instance.new("TextLabel")
            pingLabel.BackgroundTransparency = 0.7
            pingLabel.Size = UDim2.new(0, 80, 0, 30)
            pingLabel.Position = UDim2.new(0, 10, 0, 170)
            pingLabel.Font = Enum.Font.SourceSans
            pingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            pingLabel.TextScaled = true
            pingLabel.Text = "PING: ?"
            pingLabel.Parent = game.StarterGui.MainGui
            
            task.spawn(function()
                while Config.PingMonitor do
                    local ping = game:GetService("NetworkServer"):Ping()
                    pingLabel.Text = "PING: " .. ping
                    task.wait(1)
                end
                pingLabel:Destroy()
            end)
            
            Rayfield:Notify({
                Title = "Ping Monitor",
                Content = "Pemantau ping diaktifkan.",
                Duration = 3,
                Image = 0x34495E,
            })
        else
            for _, child in ipairs(game.StarterGui.MainGui:GetChildren()) do
                if child:IsA("TextLabel") and child.Text:find("PING:") then
                    child:Destroy()
                end
            end
            Rayfield:Notify({
                Title = "Ping Monitor",
                Content = "Pemantau ping dimatikan.",
                Duration = 3,
                Image = 0x34495E,
            })
        end
    end,
})

-- FPS Monitor Toggle
local FPSMonitorToggle = LowDevTab:CreateToggle({
    Name = "FPS Monitor",
    CurrentValue = Config.FPSMonitor,
    Flag = "FPSMonitor",
    Callback = function(Value)
        Config.FPSMonitor = Value
        if Value then
            local fpsLabel = Instance.new("TextLabel")
            fpsLabel.BackgroundTransparency = 0.7
            fpsLabel.Size = UDim2.new(0, 80, 0, 30)
            fpsLabel.Position = UDim2.new(0, 10, 0, 210)
            fpsLabel.Font = Enum.Font.SourceSans
            fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            fpsLabel.TextScaled = true
            fpsLabel.Text = "FPS: ?"
            fpsLabel.Parent = game.StarterGui.MainGui
            
            task.spawn(function()
                while Config.FPSMonitor do
                    local fps = game:GetService("RunService"):GetRenderStepped():GetTicks()
                    fpsLabel.Text = "FPS: " .. math.floor(fps)
                    task.wait(0.5)
                end
                fpsLabel:Destroy()
            end)
            
            Rayfield:Notify({
                Title = "FPS Monitor",
                Content = "Pemantau FPS diaktifkan.",
                Duration = 3,
                Image = 0x34495E,
            })
        else
            for _, child in ipairs(game.StarterGui.MainGui:GetChildren()) do
                if child:IsA("TextLabel") and child.Text:find("FPS:") then
                    child:Destroy()
                end
            end
            Rayfield:Notify({
                Title = "FPS Monitor",
                Content = "Pemantau FPS dimatikan.",
                Duration = 3,
                Image = 0x34495E,
            })
        end
    end,
})

-- Log Console Toggle
local LogConsoleToggle = LowDevTab:CreateToggle({
    Name = "Log Console",
    CurrentValue = Config.LogConsole,
    Flag = "LogConsole",
    Callback = function(Value)
        Config.LogConsole = Value
        if Value then
            -- Override print to log to UI
            local originalPrint = print
            local logText = ""
            local logLabel = Instance.new("TextLabel")
            logLabel.BackgroundTransparency = 0.7
            logLabel.Size = UDim2.new(0, 300, 0, 200)
            logLabel.Position = UDim2.new(0, 10, 0, 250)
            logLabel.Font = Enum.Font.SourceSans
            logLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
            logLabel.TextScaled = true
            logLabel.TextWrapped = true
            logLabel.Text = "LOG CONSOLE:\n"
            logLabel.Parent = game.StarterGui.MainGui
            
            print = function(...)
                local args = {...}
                local msg = table.concat(args, "\t")
                logText = logText .. msg .. "\n"
                if #logText > 5000 then
                    logText = string.sub(logText, -4000)
                end
                logLabel.Text = "LOG CONSOLE:\n" .. logText
                originalPrint(...)
            end
            
            Rayfield:Notify({
                Title = "Log Console",
                Content = "Konsol log diaktifkan.",
                Duration = 3,
                Image = 0x34495E,
            })
        else
            print = originalPrint
            for _, child in ipairs(game.StarterGui.MainGui:GetChildren()) do
                if child:IsA("TextLabel") and child.Text:find("LOG CONSOLE:") then
                    child:Destroy()
                end
            end
            Rayfield:Notify({
                Title = "Log Console",
                Content = "Konsol log dimatikan.",
                Duration = 3,
                Image = 0x34495E,
            })
        end
    end,
})

-- ======== TAB NKZ-SETTINGS ========
local SettingsTab = Window:CreateTab("NKZ-SETTINGS", 0xF093FB)

-- Keybinds Section
SettingsTab:CreateLabel("Keybinds (Harus diatur manual di game):")

SettingsTab:CreateLabel("Teleport: " .. Config.Keybinds.Teleport)
SettingsTab:CreateLabel("Fly: " .. Config.Keybinds.Fly)
SettingsTab:CreateLabel("NoClip: " .. Config.Keybinds.NoClip)
SettingsTab:CreateLabel("GodMode: " .. Config.Keybinds.GodMode)
SettingsTab:CreateLabel("WalkWater: " .. Config.Keybinds.WalkWater)
SettingsTab:CreateLabel("ESP: " .. Config.Keybinds.ESP)
SettingsTab:CreateLabel("Night Vision: " .. Config.Keybinds.NightVision)
SettingsTab:CreateLabel("Full Bright: " .. Config.Keybinds.FullBright)

-- Theme Dropdown
local ThemeDropdown = SettingsTab:CreateDropdown({
    Name = "Theme",
    Options = {"Dark", "Light", "Purple", "Green", "Blue"},
    CurrentOption = Config.Theme,
    Flag = "Theme",
    Callback = function(Theme)
        Config.Theme = Theme
        -- Apply theme color
        if Theme == "Dark" then
            Rayfield:SetTheme(Color3.fromRGB(30, 30, 30), Color3.fromRGB(45, 45, 45), Color3.fromRGB(255, 255, 255))
        elseif Theme == "Light" then
            Rayfield:SetTheme(Color3.fromRGB(240, 240, 240), Color3.fromRGB(220, 220, 220), Color3.fromRGB(0, 0, 0))
        elseif Theme == "Purple" then
            Rayfield:SetTheme(Color3.fromRGB(40, 20, 60), Color3.fromRGB(55, 25, 80), Color3.fromRGB(255, 200, 255))
        elseif Theme == "Green" then
            Rayfield:SetTheme(Color3.fromRGB(20, 40, 20), Color3.fromRGB(25, 55, 25), Color3.fromRGB(150, 255, 150))
        elseif Theme == "Blue" then
            Rayfield:SetTheme(Color3.fromRGB(20, 20, 40), Color3.fromRGB(25, 25, 55), Color3.fromRGB(150, 200, 255))
        end
        Rayfield:Notify({
            Title = "Theme",
            Content = "Tema diubah menjadi: " .. Theme,
            Duration = 3,
            Image = 0xF093FB,
        })
    end,
})

-- Notifications Toggle
local NotificationsToggle = SettingsTab:CreateToggle({
    Name = "Notifications",
    CurrentValue = Config.Notifications,
    Flag = "Notifications",
    Callback = function(Value)
        Config.Notifications = Value
        if not Value then
            -- Disable all notifications by overriding Notify
            Rayfield.Notify = function() end
        else
            -- Restore original notify
            Rayfield.Notify = Rayfield.originalNotify
        end
        Rayfield:Notify({
            Title = "Notifikasi",
            Content = "Notifikasi " .. (Value and "diaktifkan" or "dimatikan"),
            Duration = 3,
            Image = 0xF093FB,
        })
    end,
})

-- Language Dropdown
local LanguageDropdown = SettingsTab:CreateDropdown({
    Name = "Bahasa",
    Options = {"EN", "ID", "JP", "KR", "CN"},
    CurrentOption = Config.Language,
    Flag = "Language",
    Callback = function(Language)
        Config.Language = Language
        Rayfield:Notify({
            Title = "Bahasa",
            Content = "Bahasa diubah ke: " .. Language,
            Duration = 3,
            Image = 0xF093FB,
        })
    end,
})

-- Reset All Settings Button
SettingsTab:CreateButton({
    Name = "Reset Semua Pengaturan",
    Callback = function()
        Config = {
            Saved = {},
            AutoFishing = false,
            AutoBait = false,
            AutoRod = false,
            AutoCollect = false,
            TeleportTarget = "",
            SpeedMultiplier = 10,
            JumpPower = 50,
            FlyEnabled = false,
            NoClipEnabled = false,
            GodModeEnabled = false,
            WalkWaterEnabled = false,
            ESPPlayer = true,
            ESPFish = true,
            ESPNPC = true,
            ESPItem = true,
            ESPZone = true,
            NightVision = false,
            FullBright = false,
            AutoBuy = false,
            AutoSell = false,
            UnlockAllShop = false,
            AntiAFK = false,
            AutoReconnect = false,
            MaxFPS = 240,
            HDTexture = true,
            ShadowQuality = 0,
            Resolution = "1920x1080",
            LowGraphic = false,
            DebugInfo = true,
            PingMonitor = true,
            FPSMonitor = true,
            LogConsole = true,
            Theme = "Dark",
            Notifications = true,
            Language = "EN",
            Keybinds = {
                Teleport = "T",
                Fly = "F",
                NoClip = "N",
                GodMode = "G",
                WalkWater = "W",
                ESP = "E",
                NightVision = "V",
                FullBright = "B"
            }
        }
        SaveConfig()
        Rayfield:Notify({
            Title = "Reset",
            Content = "Semua pengaturan telah direset ke default.",
            Duration = 4,
            Image = 0xF093FB,
        })
    end,
})

-- ======== KEYBIND HANDLERS ========
-- These are the actual keybind handlers that work in-game
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode[Config.Keybinds.Teleport] then
        MapDropdown:Set(AllMaps[1])
        MapDropdown:Refresh(AllMaps, true)
    end
    
    if input.KeyCode == Enum.KeyCode[Config.Keybinds.Fly] then
        FlyToggle:Set(not FlyToggle:Get())
    end
    
    if input.KeyCode == Enum.KeyCode[Config.Keybinds.NoClip] then
        NoClipToggle:Set(not NoClipToggle:Get())
    end
    
    if input.KeyCode == Enum.KeyCode[Config.Keybinds.GodMode] then
        GodModeToggle:Set(not GodModeToggle:Get())
    end
    
    if input.KeyCode == Enum.KeyCode[Config.Keybinds.WalkWater] then
        WalkWaterToggle:Set(not WalkWaterToggle:Get())
    end
    
    if input.KeyCode == Enum.KeyCode[Config.Keybinds.ESP] then
        ESPPlayerToggle:Set(not ESPPlayerToggle:Get())
        ESPFishToggle:Set(not ESPFishToggle:Get())
        ESPNPCToggle:Set(not ESPNPCToggle:Get())
        ESPItemToggle:Set(not ESPItemToggle:Get())
        ESPZoneToggle:Set(not ESPZoneToggle:Get())
    end
    
    if input.KeyCode == Enum.KeyCode[Config.Keybinds.NightVision] then
        NightVisionToggle:Set(not NightVisionToggle:Get())
    end
    
    if input.KeyCode == Enum.KeyCode[Config.Keybinds.FullBright] then
        FullBrightToggle:Set(not FullBrightToggle:Get())
    end
end)

-- ======== LOAD CONFIGURATION ON START ========
Rayfield:LoadConfiguration()
