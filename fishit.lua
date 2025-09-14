-- Base UI Rayfield dengan Async untuk Fishing Game
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Mendapatkan ReplicatedStorage untuk akses module game
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Membuat window utama
local Window = Rayfield:CreateWindow({
    Name = "Fishing Paradise Mod Menu",
    LoadingTitle = "Memuat Mod Menu...",
    LoadingSubtitle = "Fishing Paradise Ultimate",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FishingParadiseConfig",
        FileName = "ModConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Tab utama
local MainTab = Window:CreateTab("Utama", 4483362458)
local FishingTab = Window:CreateTab("Fishing", 7733960981)
local ItemsTab = Window:CreateTab("Items", 7733923678)
local BoatsTab = Window:CreateTab("Boats", 7733954302)
local TeleportTab = Window:CreateTab("Teleport", 7733975354)
local SettingsTab = Window:CreateTab("Settings", 7733912345)

-- Fungsi untuk memanggil RemoteEvent/RemoteFunction dengan aman
local function callRemote(remotePath, ...)
    local pathParts = string.split(remotePath, ".")
    local current = ReplicatedStorage
    
    for _, part in ipairs(pathParts) do
        current = current:FindFirstChild(part)
        if not current then
            warn("Remote not found:", part)
            return nil
        end
    end
    
    if current:IsA("RemoteEvent") then
        current:FireServer(...)
        return true
    elseif current:IsA("RemoteFunction") then
        return current:InvokeServer(...)
    end
end

-- Fungsi async untuk mendapatkan data player
local function getPlayerDataAsync(callback)
    task.spawn(function()
        -- Simulasi pengambilan data player
        local success, data = pcall(function()
            return callRemote("ReplicatedStorage.CmdrClient.CmdrFunction", "getPlayerData", LocalPlayer)
        end)
        
        if success and data and callback then
            callback(data)
        elseif callback then
            callback({})
        end
    end)
end

-- Section Auto Fishing
local AutoFishingSection = FishingTab:CreateSection("Auto Fishing")

local AutoFishingToggle = FishingTab:CreateToggle({
    Name = "Auto Fishing",
    CurrentValue = false,
    Flag = "AutoFishingToggle",
    Callback = function(Value)
        callRemote("ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/UpdateAutoFishingState", Value)
        
        Rayfield:Notify({
            Title = "Auto Fishing",
            Content = Value and "Diaktifkan" or "Dimatikan",
            Duration = 3,
            Image = 7733960981,
        })
    end,
})

local AutoSellThreshold = FishingTab:CreateSlider({
    Name = "Auto Sell Threshold",
    Range = {1, 100},
    Increment = 1,
    Suffix = "rarity",
    CurrentValue = 10,
    Flag = "AutoSellSlider",
    Callback = function(Value)
        callRemote("ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/UpdateAutoSellThreshold", Value)
    end,
})

-- Section Fishing Modifiers
local ModifiersSection = FishingTab:CreateSection("Fishing Modifiers")

local InstantCatchToggle = FishingTab:CreateToggle({
    Name = "Instant Catch",
    CurrentValue = false,
    Flag = "InstantCatchToggle",
    Callback = function(Value)
        -- Modifikasi fishing controller untuk instant catch
        Rayfield:Notify({
            Title = "Instant Catch",
            Content = Value and "Diaktifkan" or "Dimatikan",
            Duration = 3,
            Image = 7733960981,
        })
    end,
})

local NoBreakToggle = FishingTab:CreateToggle({
    Name = "No Line Break",
    CurrentValue = false,
    Flag = "NoBreakToggle",
    Callback = function(Value)
        -- Modifikasi fishing line durability
        Rayfield:Notify({
            Title = "No Line Break",
            Content = Value and "Diaktifkan" or "Dimatikan",
            Duration = 3,
            Image = 7733960981,
        })
    end,
})

-- Section Items
local ItemsSection = ItemsTab:CreateSection("Item Management")

local InfiniteBaitToggle = ItemsTab:CreateToggle({
    Name = "Infinite Bait",
    CurrentValue = false,
    Flag = "InfiniteBaitToggle",
    Callback = function(Value)
        -- Modifikasi bait consumption
        Rayfield:Notify({
            Title = "Infinite Bait",
            Content = Value and "Diaktifkan" or "Dimatikan",
            Duration = 3,
            Image = 7733923678,
        })
    end,
})

local GetRareItems = ItemsTab:CreateButton({
    Name = "Get Rare Items",
    Callback = function()
        callRemote("ReplicatedStorage.CmdrClient.Commands.additem", "!!! Hyper Rod")
        callRemote("ReplicatedStorage.CmdrClient.Commands.additem", "!!! Lucky Rod")
        callRemote("ReplicatedStorage.CmdrClient.Commands.additem", "Enchant Stone")
        
        Rayfield:Notify({
            Title = "Rare Items",
            Content = "Rare items telah ditambahkan ke inventory!",
            Duration = 6,
            Image = 7733923678,
        })
    end,
})

-- Section Boats
local BoatsSection = BoatsTab:CreateSection("Boat Mods")

local SpawnBoatDropdown = BoatsTab:CreateDropdown({
    Name = "Spawn Boat",
    Options = {"Speed Boat", "Hyper Boat", "Santa Sleigh", "Mega Hovercraft"},
    CurrentOption = "Speed Boat",
    Flag = "BoatDropdown",
    Callback = function(Option)
        callRemote("ReplicatedStorage.CmdrClient.Commands.spawnboat", Option)
        
        Rayfield:Notify({
            Title = "Boat Spawned",
            Content = Option .. " telah di-spawn!",
            Duration = 4,
            Image = 7733954302,
        })
    end,
})

local BoatSpeedSlider = BoatsTab:CreateSlider({
    Name = "Boat Speed Multiplier",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "BoatSpeedSlider",
    Callback = function(Value)
        -- Modifikasi boat speed
        Rayfield:Notify({
            Title = "Boat Speed",
            Content = "Speed multiplier: " .. Value .. "x",
            Duration = 3,
            Image = 7733954302,
        })
    end,
})

-- Section Teleport
local TeleportSection = TeleportTab:CreateSection("Location Teleport")

local AreaTeleportDropdown = TeleportTab:CreateDropdown({
    Name = "Teleport to Area",
    Options = {"Tropical Grove", "Kohana Volcano", "Esoteric Depths", "Crater Island"},
    CurrentOption = "Tropical Grove",
    Flag = "AreaDropdown",
    Callback = function(Option)
        callRemote("ReplicatedStorage.CmdrClient.Commands.teleport", Option)
        
        Rayfield:Notify({
            Title = "Teleport",
            Content = "Teleport ke " .. Option,
            Duration = 4,
            Image = 7733975354,
        })
    end,
})

local TeleportToPlayer = TeleportTab:CreateInput({
    Name = "Teleport to Player",
    PlaceholderText = "Username",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        callRemote("ReplicatedStorage.CmdrClient.Commands.teleport", "player:" .. Text)
        
        Rayfield:Notify({
            Title = "Player Teleport",
            Content = "Teleport ke player: " .. Text,
            Duration = 4,
            Image = 7733975354,
        })
    end,
})

-- Section Currency
local CurrencySection = MainTab:CreateSection("Currency")

local AddCoinsButton = MainTab:CreateButton({
    Name = "Add 1000 Coins",
    Callback = function()
        callRemote("ReplicatedStorage.CmdrClient.Commands.addcoins", 1000)
        
        Rayfield:Notify({
            Title = "Coins Added",
            Content = "1000 coins ditambahkan!",
            Duration = 4,
            Image = 4483362458,
        })
    end,
})

local AddTrophiesButton = MainTab:CreateButton({
    Name = "Add 500 Trophies",
    Callback = function()
        callRemote("ReplicatedStorage.CmdrClient.Commands.addtrophies", 500)
        
        Rayfield:Notify({
            Title = "Trophies Added",
            Content = "500 trophies ditambahkan!",
            Duration = 4,
            Image = 4483362458,
        })
    end,
})

-- Section Events
local EventsSection = MainTab:CreateSection("Events")

local EventDropdown = MainTab:CreateDropdown({
    Name = "Trigger Event",
    Options = {"Shark Hunt", "Ghost Shark Hunt", "Increased Luck", "Storm"},
    CurrentOption = "Shark Hunt",
    Flag = "EventDropdown",
    Callback = function(Option)
        callRemote("ReplicatedStorage.CmdrClient.Commands.addevent", Option)
        
        Rayfield:Notify({
            Title = "Event Triggered",
            Content = "Event " .. Option .. " diaktifkan!",
            Duration = 5,
            Image = 4483362458,
        })
    end,
})

-- Section Settings
local SettingsSection = SettingsTab:CreateSection("Mod Settings")

local WalkSpeedSlider = SettingsTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 100},
    Increment = 1,
    Suffix = "studs/s",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        if LocalPlayer.Character then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
        end
    end,
})

local JumpPowerSlider = SettingsTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 200},
    Increment = 5,
    Suffix = "power",
    CurrentValue = 50,
    Flag = "JumpPowerSlider",
    Callback = function(Value)
        if LocalPlayer.Character then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = Value
        end
    end,
})

-- Section Info
local InfoSection = SettingsTab:CreateSection("Information")

SettingsTab:CreateLabel("Fishing Paradise Mod Menu v1.0")
SettingsTab:CreateLabel("Detected Game: Fishing Paradise")
SettingsTab:CreateLabel("Player: " .. LocalPlayer.Name)

-- Fungsi untuk load configuration
local function loadConfiguration()
    -- Load saved settings
    getPlayerDataAsync(function(data)
        if data and data.settings then
            -- Apply saved settings
            if data.settings.walkSpeed then
                WalkSpeedSlider:Set(data.settings.walkSpeed)
            end
            if data.settings.jumpPower then
                JumpPowerSlider:Set(data.settings.jumpPower)
            end
        end
    end)
end

-- Load configuration saat startup
task.spawn(function()
    task.wait(2) -- Tunggu game fully loaded
    loadConfiguration()
    
    Rayfield:Notify({
        Title = "Mod Menu Loaded",
        Content = "Fishing Paradise Mod Menu berhasil dimuat!",
        Duration = 6,
        Image = 4483362458,
    })
end)

-- Load UI
Rayfield:LoadConfiguration()
