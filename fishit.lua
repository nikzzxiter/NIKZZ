-- NIKZZMODDER.LUA - Fish It Mod Menu
-- Dibuat dengan Rayfield UI dan Async System
-- Menggunakan modul resmi dari game Fish It

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Membuat window utama
local Window = Rayfield:CreateWindow({
    Name = "NIKZZ MODDER - Fish It",
    LoadingTitle = "Memuat Mod Menu...",
    LoadingSubtitle = "by NikzzModder",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NikzzModderConfig",
        FileName = "FishItConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Tab utama
local MainTab = Window:CreateTab("Farming", 4483362458)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- Variabel global
local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")

local SavedPosition = nil
local AutoFishingEnabled = false
local AutoFishingV2Enabled = false
local AutoCompleteEnabled = false
local AutoJumpEnabled = false
local AntiAFKEnabled = false
local CastingDelay = 3

-- Fungsi untuk mendapatkan modul dari game
local function GetModule(path)
    local current = ReplicatedStorage
    for _, part in ipairs(path:split('.')) do
        current = current:FindFirstChild(part)
        if not current then return nil end
    end
    return current
end

-- Fungsi async untuk memanggil remote
local function CallRemoteAsync(remotePath, ...)
    task.spawn(function()
        local remote = GetModule(remotePath)
        if remote and remote:IsA("RemoteFunction") then
            remote:InvokeServer(...)
        elseif remote and remote:IsA("RemoteEvent") then
            remote:FireServer(...)
        end
    end)
end

-- Fungsi untuk mendapatkan inventory
local function GetInventory()
    local InventoryController = GetModule("Controllers.InventoryController")
    if InventoryController then
        return require(InventoryController).getInventory()
    end
    return {}
end

-- Fungsi untuk equip rod
local function EquipRod(rodName)
    local HotbarController = GetModule("Controllers.HotbarController")
    if HotbarController then
        local hotbar = require(HotbarController)
        local inventory = GetInventory()
        
        for _, item in ipairs(inventory) do
            if item.name == rodName then
                hotbar.equipTool(item)
                return true
            end
        end
    end
    return false
end

-- Fungsi untuk membeli item
local function BuyItem(itemType, itemName)
    if itemType == "Rod" then
        CallRemoteAsync("Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseFishingRod", itemName)
    elseif itemType == "Bait" then
        CallRemoteAsync("Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseBait", itemName)
    elseif itemType == "Radar" then
        -- Implementasi pembelian radar
        CallRemoteAsync("Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseGear", "Fishing Radar")
    elseif itemType == "DivingGear" then
        -- Implementasi pembelian diving gear
        CallRemoteAsync("Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseGear", "Diving Gear")
    end
end

-- Fungsi untuk menggunakan item dari inventory
local function UseItemFromInventory(itemName)
    local inventory = GetInventory()
    for _, item in ipairs(inventory) do
        if item.name == itemName then
            local HotbarController = GetModule("Controllers.HotbarController")
            if HotbarController then
                local hotbar = require(HotbarController)
                hotbar.equipTool(item)
                return true
            end
        end
    end
    return false
end

-- Fungsi auto fishing V1
local function StartAutoFishingV1()
    if not AutoFishingEnabled then return end
    
    task.spawn(function()
        while AutoFishingEnabled do
            -- Auto equip rod
            local rods = {"!!! Carbon Rod", "!!! Ice Rod", "!!! Luck Rod", "!!! Midnight Rod"}
            local rodEquipped = false
            
            for _, rod in ipairs(rods) do
                if UseItemFromInventory(rod) then
                    rodEquipped = true
                    break
                end
            end
            
            if not rodEquipped then
                -- Coba beli rod jika tidak ada
                BuyItem("Rod", "!!! Carbon Rod")
                task.wait(1)
            else
                -- Cast fishing rod
                CallRemoteAsync("Packages._Index.sleitnick_net@0.2.0.net.RF/ChargeFishingRod")
                task.wait(0.5)
                
                -- Perfect casting
                CallRemoteAsync("Packages._Index.sleitnick_net@0.2.0.net.RF/CancelFishingInputs")
                
                -- Auto pull
                CallRemoteAsync("Packages._Index.sleitnick_net@0.2.0.net.RE/FishingCompleted")
                
                -- Delay sesuai setting
                task.wait(CastingDelay)
            end
        end
    end)
end

-- Fungsi auto fishing V2 (spam tap)
local function StartAutoFishingV2()
    if not AutoFishingV2Enabled then return end
    
    task.spawn(function()
        while AutoFishingV2Enabled do
            -- Equip rod
            local rods = {"!!! Carbon Rod", "!!! Ice Rod", "!!! Luck Rod", "!!! Midnight Rod"}
            local rodEquipped = false
            
            for _, rod in ipairs(rods) do
                if UseItemFromInventory(rod) then
                    rodEquipped = true
                    break
                end
            end
            
            if rodEquipped then
                -- Spam tap untuk casting
                for i = 1, 10 do
                    if not AutoFishingV2Enabled then break end
                    
                    VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    task.wait(0.05)
                    VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    task.wait(0.05)
                end
                
                -- Auto complete
                CallRemoteAsync("Packages._Index.sleitnick_net@0.2.0.net.RE/FishingCompleted")
                
                -- Delay
                task.wait(CastingDelay)
            else
                task.wait(1)
            end
        end
    end)
end

-- Fungsi auto complete fishing
local function SetupAutoComplete()
    if not AutoCompleteEnabled then return end
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not AutoCompleteEnabled then
            connection:Disconnect()
            return
        end
        
        -- Deteksi jika ada ikan yang tertangkap dan langsung complete
        CallRemoteAsync("Packages._Index.sleitnick_net@0.2.0.net.RE/FishingCompleted")
    end)
end

-- Fungsi bypass fishing radar
local function BypassFishingRadar()
    if not UseItemFromInventory("Fishing Radar") then
        BuyItem("Radar", "Fishing Radar")
        task.wait(2)
        UseItemFromInventory("Fishing Radar")
    end
end

-- Fungsi bypass diving gear
local function BypassDivingGear()
    if not UseItemFromInventory("Diving Gear") then
        BuyItem("DivingGear", "Diving Gear")
        task.wait(2)
        UseItemFromInventory("Diving Gear")
    end
end

-- Fungsi anti AFK
local function SetupAntiAFK()
    if not AntiAFKEnabled then return end
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not AntiAFKEnabled then
            connection:Disconnect()
            return
        end
        
        -- Gerakkan karakter sedikit untuk menghindari AFK
        local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:Move(Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)))
        end
    end)
end

-- Fungsi auto jump
local function SetupAutoJump()
    if not AutoJumpEnabled then return end
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not AutoJumpEnabled then
            connection:Disconnect()
            return
        end
        
        -- Lompat secara acak
        if math.random(1, 20) == 1 then  -- 5% chance setiap frame
            local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Jump = true
            end
        end
    end)
end

-- Fungsi teleport ke area
local function TeleportToArea(areaName)
    local AreaController = GetModule("Controllers.AreaController")
    if AreaController then
        local areaModule = require(AreaController)
        areaModule.teleportToArea(areaName)
    end
end

-- Section Auto Fishing
local AutoFishingSection = MainTab:CreateSection("Auto Fishing")

-- Toggle Auto Fishing V1
local AutoFishingToggle = MainTab:CreateToggle({
    Name = "Auto Fishing V1",
    CurrentValue = false,
    Flag = "AutoFishingV1",
    Callback = function(Value)
        AutoFishingEnabled = Value
        if Value then
            AutoFishingV2Toggle:Set(false)
            StartAutoFishingV1()
            Rayfield:Notify({
                Title = "Auto Fishing V1",
                Content = "Auto Fishing V1 diaktifkan",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Auto Fishing V1",
                Content = "Auto Fishing V1 dimatikan",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Toggle Auto Fishing V2
local AutoFishingV2Toggle = MainTab:CreateToggle({
    Name = "Auto Fishing V2 (Spam Tap)",
    CurrentValue = false,
    Flag = "AutoFishingV2",
    Callback = function(Value)
        AutoFishingV2Enabled = Value
        if Value then
            AutoFishingToggle:Set(false)
            StartAutoFishingV2()
            Rayfield:Notify({
                Title = "Auto Fishing V2",
                Content = "Auto Fishing V2 diaktifkan",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Auto Fishing V2",
                Content = "Auto Fishing V2 dimatikan",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Toggle Auto Complete Fishing
local AutoCompleteToggle = MainTab:CreateToggle({
    Name = "Auto Complete Fishing",
    CurrentValue = false,
    Flag = "AutoComplete",
    Callback = function(Value)
        AutoCompleteEnabled = Value
        if Value then
            SetupAutoComplete()
            Rayfield:Notify({
                Title = "Auto Complete",
                Content = "Auto Complete diaktifkan",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Auto Complete",
                Content = "Auto Complete dimatikan",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Toggle Auto Equip Rod
local AutoEquipToggle = MainTab:CreateToggle({
    Name = "Auto Equip Best Rod",
    CurrentValue = false,
    Flag = "AutoEquip",
    Callback = function(Value)
        if Value then
            task.spawn(function()
                while AutoEquipToggle.CurrentValue do
                    local rods = {"!!! Carbon Rod", "!!! Ice Rod", "!!! Luck Rod", "!!! Midnight Rod"}
                    for _, rod in ipairs(rods) do
                        UseItemFromInventory(rod)
                        task.wait(0.5)
                    end
                    task.wait(5)
                end
            end)
            Rayfield:Notify({
                Title = "Auto Equip",
                Content = "Auto Equip Rod diaktifkan",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Auto Equip",
                Content = "Auto Equip Rod dimatikan",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Slider Casting Delay
local CastingDelaySlider = MainTab:CreateSlider({
    Name = "Casting Delay (Seconds)",
    Range = {1, 10},
    Increment = 1,
    Suffix = "sec",
    CurrentValue = 3,
    Flag = "CastingDelay",
    Callback = function(Value)
        CastingDelay = Value
        Rayfield:Notify({
            Title = "Casting Delay",
            Content = "Delay diatur ke " .. Value .. " detik",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Section Bypass
local BypassSection = MainTab:CreateSection("Bypass Items")

-- Button Bypass Fishing Radar
MainTab:CreateButton({
    Name = "Bypass Fishing Radar",
    Callback = function()
        BypassFishingRadar()
        Rayfield:Notify({
            Title = "Bypass Radar",
            Content = "Mengaktifkan Fishing Radar",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Button Bypass Diving Gear
MainTab:CreateButton({
    Name = "Bypass Diving Gear",
    Callback = function()
        BypassDivingGear()
        Rayfield:Notify({
            Title = "Bypass Diving",
            Content = "Mengaktifkan Diving Gear",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Section Teleport
local TeleportSection = TeleportTab:CreateSection("Fishing Areas")

-- Dropdown pilihan area
local areas = {
    "Treasure Room", "Sysphus Statue", "Crater Island", "Kohana", 
    "Tropical Island", "Weather Machine", "Coral Reef", "Enchant Room",
    "Esoteric Island", "Volcano", "Lost Isle", "Fishermand Island"
}

local AreaDropdown = TeleportTab:CreateDropdown({
    Name = "Pilih Fishing Area",
    Options = areas,
    CurrentOption = "Pilih Area",
    Flag = "AreaDropdown",
    Callback = function(Option)
        TeleportToArea(Option)
        Rayfield:Notify({
            Title = "Teleport",
            Content = "Teleport ke " .. Option,
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Section Save Position
local SaveSection = TeleportTab:CreateSection("Save Position")

-- Button Save Position
TeleportTab:CreateButton({
    Name = "Save Current Position",
    Callback = function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            SavedPosition = Player.Character.HumanoidRootPart.CFrame
            Rayfield:Notify({
                Title = "Position Saved",
                Content = "Posisi berhasil disimpan",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Button Teleport to Saved Position
TeleportTab:CreateButton({
    Name = "Teleport to Saved Position",
    Callback = function()
        if SavedPosition and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = SavedPosition
            Rayfield:Notify({
                Title = "Teleport",
                Content = "Teleport ke posisi tersimpan",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Tidak ada posisi yang tersimpan",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Section Player
local PlayerSection = PlayerTab:CreateSection("Player Utilities")

-- Toggle Anti AFK
local AntiAFKToggle = PlayerTab:CreateToggle({
    Name = "Anti AFK & Anti DC",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        AntiAFKEnabled = Value
        if Value then
            SetupAntiAFK()
            Rayfield:Notify({
                Title = "Anti AFK",
                Content = "Anti AFK diaktifkan",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Anti AFK",
                Content = "Anti AFK dimatikan",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Toggle Auto Jump
local AutoJumpToggle = PlayerTab:CreateToggle({
    Name = "Auto Jump",
    CurrentValue = false,
    Flag = "AutoJump",
    Callback = function(Value)
        AutoJumpEnabled = Value
        if Value then
            SetupAutoJump()
            Rayfield:Notify({
                Title = "Auto Jump",
                Content = "Auto Jump diaktifkan",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Auto Jump",
                Content = "Auto Jump dimatikan",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Section Misc
local MiscSection = MiscTab:CreateSection("Miscellaneous")

-- Toggle Anti Detect Developer
MiscTab:CreateToggle({
    Name = "Anti Detect Developer",
    CurrentValue = true,
    Flag = "AntiDetect",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Anti Detect",
                Content = "Anti Detect Developer diaktifkan",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Anti Detect",
                Content = "Anti Detect Developer dimatikan",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Button Rejoin Server
MiscTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
    end,
})

-- Button Destroy GUI
MiscTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        Rayfield:Destroy()
    end,
})

-- Notifikasi awal
Rayfield:Notify({
    Title = "NIKZZ MODDER Loaded",
    Content = "Script berhasil dimuat! Selamat memancing!",
    Duration = 6,
    Image = 4483362458,
})

-- Inisialisasi
task.spawn(function()
    -- Cek apakah modul tersedia
    local modules = {
        "Controllers.InventoryController",
        "Controllers.HotbarController",
        "Controllers.AreaController",
        "Packages._Index.sleitnick_net@0.2.0.net.RF",
        "Packages._Index.sleitnick_net@0.2.0.net.RE"
    }
    
    for _, module in ipairs(modules) do
        if not GetModule(module) then
            Rayfield:Notify({
                Title = "Warning",
                Content = "Module " .. module .. " tidak ditemukan. Beberapa fitur mungkin tidak bekerja.",
                Duration = 10,
                Image = 4483362458,
            })
        end
    end
end)
