-- Base UI Rayfield dengan Async
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")
local Stats = game:GetService("Stats")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Konfigurasi
local Configuration = {
    SavedPosition = CFrame.new(),
    FishingRadarEquipped = false,
    DivingGearEquipped = false,
    AutoJumpInterval = 5,
    SpeedHackValue = 16,
    FlySpeed = 50,
    JumpPower = 50,
    FOVSettings = {Horizontal = 10, Vertical = 10},
    AutoSellDelay = 5,
    SelectedWeathers = {},
    FPSLimit = 60,
    Brightness = 0,
    GraphicsQuality = "Medium",
    ESPEnabled = false,
    GhostMode = false,
    BoatFlying = false,
    BoatSpeed = 50,
    SelectedIsland = "",
    SelectedEvent = "",
    SelectedPlayer = nil,
    LockPosition = false,
    AntiAFK = false,
    AntiDetect = false
}

-- Remote references
local Net = ReplicatedStorage.Packages._Index.sleitnick_net["0.2.0"].net
local RF = Net.RF
local RE = Net.RE

-- Remote functions
local UpdateAutoFishingState = RF:FindFirstChild("UpdateAutoFishingState")
local ChargeFishingRod = RF:FindFirstChild("ChargeFishingRod")
local CancelFishingInputs = RF:FindFirstChild("CancelFishingInputs")
local PurchaseFishingRod = RF:FindFirstChild("PurchaseFishingRod")
local PurchaseBait = RF:FindFirstChild("PurchaseBait")
local SellItem = RF:FindFirstChild("SellItem")
local SellAllItems = RF:FindFirstChild("SellAllItems")
local UpdateAutoSellThreshold = RF:FindFirstChild("UpdateAutoSellThreshold")
local PurchaseGear = RF:FindFirstChild("PurchaseGear")
local PurchaseSkinCrate = RF:FindFirstChild("PurchaseSkinCrate")

-- Remote events
local FishingCompleted = RE:FindFirstChild("FishingCompleted")
local FishingStopped = RE:FindFirstChild("FishingStopped")
local ObtainedNewFishNotification = RE:FindFirstChild("ObtainedNewFishNotification")
local PlayVFX = RE:FindFirstChild("PlayVFX")
local EquipBait = RE:FindFirstChild("EquipBait")
local EquipToolFromHotbar = RE:FindFirstChild("EquipToolFromHotbar")
local UnequipToolFromHotbar = RE:FindFirstChild("UnequipToolFromHotbar")

-- Controller references
local Controllers = ReplicatedStorage.Controllers
local AutoFishingController = Controllers:FindFirstChild("AutoFishingController")
local FishingController = Controllers:FindFirstChild("FishingController")
local AreaController = Controllers:FindFirstChild("AreaController")
local EventController = Controllers:FindFirstChild("EventController")
local InventoryController = Controllers:FindFirstChild("InventoryController")
local RodShopController = Controllers:FindFirstChild("RodShopController")
local BaitShopController = Controllers:FindFirstChild("BaitShopController")
local VendorController = Controllers:FindFirstChild("VendorController")
local HotbarController = Controllers:FindFirstChild("HotbarController")
local BoatShopController = Controllers:FindFirstChild("BoatShopController")
local VFXController = Controllers:FindFirstChild("VFXController")
local HUDController = Controllers:FindFirstChild("HUDController")
local SwimController = Controllers:FindFirstChild("SwimController")
local AFKController = Controllers:FindFirstChild("AFKController")
local ClientTimeController = Controllers:FindFirstChild("ClientTimeController")
local SettingsController = Controllers:FindFirstChild("SettingsController")
local PurchaseScreenBlackoutController = Controllers:FindFirstChild("PurchaseScreenBlackoutController")

-- Utility references
local Shared = ReplicatedStorage.Shared
local ItemUtility = Shared:FindFirstChild("ItemUtility")
local ValidEventNames = Shared:FindFirstChild("ValidEventNames")
local PlayerEvents = Shared:FindFirstChild("PlayerEvents")
local PlayerStatsUtility = Shared:FindFirstChild("PlayerStatsUtility")
local AreaUtility = Shared:FindFirstChild("AreaUtility")
local VFXUtility = Shared:FindFirstChild("VFXUtility")
local EventUtility = Shared:FindFirstChild("EventUtility")
local TimeConfiguration = Shared:FindFirstChild("TimeConfiguration")
local SystemMessage = Shared:FindFirstChild("SystemMessage")
local GamePassUtility = Shared:FindFirstChild("GamePassUtility")
local XPUtility = Shared:FindFirstChild("XPUtility")

-- Items references
local Items = ReplicatedStorage.Items
local FishingRadar = Items:FindFirstChild("Fishing Radar")
local DivingGear = Items:FindFirstChild("Diving Gear")

-- Areas references
local Areas = ReplicatedStorage.Areas
local AreaList = {
    "Treasure Room", "Sysphus Statue", "Crater Island", "Kohana", "Tropical Island", 
    "Weather Machine", "Coral Reef", "Enchant Room", "Esoteric Island", "Volcano", 
    "Lost Isle", "Fishermand Island"
}

-- Events references
local Events = ReplicatedStorage.Events
local EventList = {
    "Day", "Cloudy", "Mutated", "Wind", "Storm", "Night", "Increased Luck", "Shark Hunt",
    "Ghost Shark Hunt", "Sparkling Cove", "Snow", "Worm Hunt", "Admin - Shocked",
    "Admin - Black Hole", "Admin - Ghost Worm", "Admin - Meteor Rain", "Admin - Super Mutated",
    "Radiant", "Admin - Super Luck"
}

-- Boats references
local Boats = ReplicatedStorage.Boats
local BoatList = {
    "Speed Boat", "Fishing Boat", "Highfield Boat", "Jetski", "Kayak", "Alpha Floaty",
    "Dinky Fishing Boat", "Mini Yacht", "Hyper Boat", "Burger Boat", "Rubber Ducky",
    "Mega Hovercraft", "Cruiser Boat", "Mini Hoverboat", "Aura Boat", "Festive Duck",
    "Santa Sleigh", "Frozen Boat", "Small Boat"
}

-- Player list
local PlayerList = {}
local ESPObjects = {}

-- Membuat window utama
local Window = Rayfield:CreateWindow({
    Name = "NIKZZ MODDER - Fish It",
    LoadingTitle = "Memuat NIKZZ MODDER...",
    LoadingSubtitle = "by NIKZZ",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NIKZZConfig",
        FileName = "NIKZZConfig"
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

-- Tab NKZ-BYPASS
local BypassTab = Window:CreateTab("NKZ-BYPASS", 4483362458)

-- Tab NKZ-TELEPORT
local TeleportTab = Window:CreateTab("NKZ-TELEPORT", 4483362458)

-- Tab NKZ-PLAYER
local PlayerTab = Window:CreateTab("NKZ-PLAYER", 4483362458)

-- Tab NKZ-VISUAL
local VisualTab = Window:CreateTab("NKZ-VISUAL", 4483362458)

-- Tab NKZ-SHOP
local ShopTab = Window:CreateTab("NKZ-SHOP", 4483362458)

-- Tab NKZ-UTILITY
local UtilityTab = Window:CreateTab("NKZ-UTILITY", 4483362458)

-- Tab NKZ-GRAPHIC
local GraphicTab = Window:CreateTab("NKZ-GRAPHIC", 4483362458)

-- Fungsi async untuk memuat data berat tanpa lag
local function loadHeavyDataAsync(callback)
    task.spawn(function()
        -- Simulasi proses berat yang memakan waktu
        local fakeData = {}
        for i = 1, 10000 do
            table.insert(fakeData, {id = i, value = "Data " .. i})
            
            -- Yield secara periodik agar UI tetap responsif
            if i % 100 == 0 then
                task.wait()
            end
        end
        
        -- Panggil callback dengan data yang sudah dimuat
        if callback then
            callback(fakeData)
        end
    end)
end

-- Fungsi untuk mendapatkan daftar pemain
local function refreshPlayerList()
    PlayerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player then
            table.insert(PlayerList, player.Name)
        end
    end
    return PlayerList
end

-- Fungsi untuk teleport ke area
local function teleportToArea(areaName)
    if AreaController then
        local area = Areas:FindFirstChild(areaName)
        if area then
            local areaCFrame = area:FindFirstChild("CFrame") or area:FindFirstChild("SpawnLocation")
            if areaCFrame then
                local position = areaCFrame.Value.Position
                if AreaController.TeleportToArea then
                    AreaController.TeleportToArea:InvokeServer(areaName)
                else
                    HumanoidRootPart.CFrame = CFrame.new(position)
                end
                Rayfield:Notify({
                    Title = "Teleport",
                    Content = "Berhasil teleport ke " .. areaName,
                    Duration = 3,
                    Image = 4483362458,
                })
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Area tidak ditemukan: " .. areaName,
                Duration = 3,
                Image = 4483362458,
            })
        end
    else
        Rayfield:Notify({
            Title = "Error",
            Content = "AreaController tidak ditemukan",
            Duration = 3,
            Image = 4483362458,
        })
    end
end

-- Fungsi untuk teleport ke event
local function teleportToEvent(eventName)
    if EventController then
        local event = Events:FindFirstChild(eventName)
        if event then
            if EventController.TeleportToEvent then
                EventController.TeleportToEvent:InvokeServer(eventName)
                Rayfield:Notify({
                    Title = "Teleport",
                    Content = "Berhasil teleport ke event " .. eventName,
                    Duration = 3,
                    Image = 4483362458,
                })
            else
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Fungsi TeleportToEvent tidak ditemukan",
                    Duration = 3,
                    Image = 4483362458,
                })
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Event tidak ditemukan: " .. eventName,
                Duration = 3,
                Image = 4483362458,
            })
        end
    else
        Rayfield:Notify({
            Title = "Error",
            Content = "EventController tidak ditemukan",
            Duration = 3,
            Image = 4483362458,
        })
    end
end

-- Fungsi untuk teleport ke player
local function teleportToPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        Rayfield:Notify({
            Title = "Teleport",
            Content = "Berhasil teleport ke " .. playerName,
            Duration = 3,
            Image = 4483362458,
        })
    else
        Rayfield:Notify({
            Title = "Error",
            Content = "Player tidak ditemukan atau tidak memiliki karakter: " .. playerName,
            Duration = 3,
            Image = 4483362458,
        })
    end
end

-- Fungsi untuk membeli item
local function purchaseItem(itemName, itemType)
    if itemType == "FishingRod" and PurchaseFishingRod then
        PurchaseFishingRod:InvokeServer(itemName)
    elseif itemType == "Bait" and PurchaseBait then
        PurchaseBait:InvokeServer(itemName)
    elseif itemType == "Gear" and PurchaseGear then
        PurchaseGear:InvokeServer(itemName)
    end
end

-- Fungsi untuk menggunakan item dari inventory
local function useItemFromInventory(itemName)
    if InventoryController and InventoryController.UseItem then
        InventoryController.UseItem:InvokeServer(itemName)
    elseif EquipToolFromHotbar then
        EquipToolFromHotbar:FireServer(itemName)
    end
end

-- Fungsi untuk menjual item
local function sellItems()
    if SellAllItems then
        SellAllItems:InvokeServer()
    elseif VendorController and VendorController.SellAllItems then
        VendorController.SellAllItems:InvokeServer()
    end
end

-- Fungsi untuk mengatur auto sell threshold
local function setAutoSellThreshold(threshold)
    if UpdateAutoSellThreshold then
        UpdateAutoSellThreshold:InvokeServer(threshold)
    end
end

-- Fungsi untuk memulai auto fishing
local function startAutoFishing()
    if UpdateAutoFishingState then
        UpdateAutoFishingState:InvokeServer(true)
    elseif AutoFishingController and AutoFishingController.StartAutoFishing then
        AutoFishingController.StartAutoFishing:InvokeServer()
    end
end

-- Fungsi untuk menghentikan auto fishing
local function stopAutoFishing()
    if UpdateAutoFishingState then
        UpdateAutoFishingState:InvokeServer(false)
    elseif AutoFishingController and AutoFishingController.StopAutoFishing then
        AutoFishingController.StopAutoFishing:InvokeServer()
    end
end

-- Fungsi untuk mengaktifkan ESP
local function activateESP()
    if Configuration.ESPEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Player and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Parent = player.Character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                ESPObjects[player.Name] = highlight
            end
        end
    else
        for playerName, highlight in pairs(ESPObjects) do
            highlight:Destroy()
        end
        ESPObjects = {}
    end
end

-- Fungsi untuk mengatur kualitas grafis
local function setGraphicsQuality(quality)
    if quality == "Maximum" then
        -- Maksimum quality settings
        settings().Rendering.QualityLevel = 50
        Lighting.GlobalShadows = true
        Lighting.ShadowSoftness = 0.1
        for _, descendant in ipairs(workspace:GetDescendants()) do
            if descendant:IsA("Part") then
                descendant.Material = Enum.Material.SmoothPlastic
            end
        end
    elseif quality == "Medium" then
        -- Medium quality settings
        settings().Rendering.QualityLevel = 15
        Lighting.GlobalShadows = true
        Lighting.ShadowSoftness = 0.5
    elseif quality == "Low" then
        -- Low quality settings
        settings().Rendering.QualityLevel = 1
        Lighting.GlobalShadows = false
    end
end

-- Fungsi untuk mengatur brightness
local function setBrightness(value)
    Lighting.Brightness = value
    Configuration.Brightness = value
end

-- Fungsi untuk mengatur FPS
local function setFPSLimit(limit)
    if setfpscap then
        setfpscap(limit)
        Configuration.FPSLimit = limit
    end
end

-- Fungsi untuk menstabilkan FPS
local function stabilizeFPS()
    local performanceStats = Stats:FindFirstChild("PerformanceStats")
    if performanceStats then
        local ping = performanceStats:FindFirstChild("Ping")
        local memory = performanceStats:FindFirstChild("Memory")
        
        if ping and memory then
            RunService.RenderStepped:Connect(function()
                if ping:GetValue() > 100 then
                    setFPSLimit(30)
                elseif memory:GetValue() > 80 then
                    game:GetService("Workspace").Camera.CameraType = Enum.CameraType.Custom
                else
                    setFPSLimit(Configuration.FPSLimit)
                end
            end)
        end
    end
end

-- Fungsi untuk membersihkan cache
local function clearCache()
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
            descendant.Enabled = false
        end
    end
    collectgarbage()
end

-- Fungsi untuk menonaktifkan partikel
local function disableParticles()
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false
        end
    end
end

-- Fungsi untuk menonaktifkan refleksi air
local function disableWaterReflection()
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("Part") and descendant.Material == Enum.Material.Water then
            descendant.Reflectance = 0
        end
    end
end

-- Fungsi untuk menonaktifkan efek kulit
local function disableSkinEffects()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            for _, descendant in ipairs(player.Character:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") and descendant.Name:find("Skin") then
                    descendant.Enabled = false
                end
            end
        end
    end
end

-- Fungsi untuk menonaktifkan bayangan
local function disableShadows()
    Lighting.GlobalShadows = false
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("Part") then
            descendant.CastShadow = false
        end
    end
end

-- Fungsi untuk menonaktifkan efek air berlebihan
local function disableExcessiveWaterEffects()
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("Part") and descendant.Material == Enum.Material.Water then
            descendant.Transparency = 0.5
            descendant.Reflectance = 0
        end
    end
end

-- Fungsi untuk mengatur FOV kamera
local function setCameraFOV(horizontal, vertical)
    local camera = workspace.CurrentCamera
    if camera then
        camera.FieldOfView = 70 + horizontal
        -- Untuk vertical FOV, perlu penyesuaian khusus tergantung game
        if camera:FindFirstChild("VerticalFOV") then
            camera.VerticalFOV.Value = 45 + vertical
        end
    end
end

-- Fungsi untuk mengaktifkan ghost mode
local function setGhostMode(enabled)
    if enabled then
        Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Transparency = 0.5
            end
        end
    else
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
                part.Transparency = 0
            end
        end
    end
end

-- Fungsi untuk mengaktifkan fly
local function activateFly()
    local flyEnabled = false
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = HumanoidRootPart

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Space then
            bodyVelocity.Velocity = Vector3.new(bodyVelocity.Velocity.X, Configuration.FlySpeed, bodyVelocity.Velocity.Z)
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            bodyVelocity.Velocity = Vector3.new(bodyVelocity.Velocity.X, -Configuration.FlySpeed, bodyVelocity.Velocity.Z)
        end
    end)

    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift then
            bodyVelocity.Velocity = Vector3.new(bodyVelocity.Velocity.X, 0, bodyVelocity.Velocity.Z)
        end
    end)

    RunService.Heartbeat:Connect(function()
        if flyEnabled then
            local camera = workspace.CurrentCamera
            local moveDirection = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + camera.CFrame.RightVector
            end
            
            moveDirection = moveDirection.Unit * Configuration.FlySpeed
            bodyVelocity.Velocity = Vector3.new(moveDirection.X, bodyVelocity.Velocity.Y, moveDirection.Z)
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)

    return function(enabled)
        flyEnabled = enabled
        if enabled then
            bodyVelocity.MaxForce = Vector3.new(9.8 * 1000, 9.8 * 1000, 9.8 * 1000)
        else
            bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

-- Fungsi untuk mengaktifkan speed hack
local function activateSpeedHack()
    RunService.Heartbeat:Connect(function()
        if Humanoid and Configuration.SpeedHackValue > 16 then
            Humanoid.WalkSpeed = Configuration.SpeedHackValue
        elseif Humanoid then
            Humanoid.WalkSpeed = 16
        end
    end)
end

-- Fungsi untuk mengaktifkan infinite jump
local function activateInfiniteJump()
    UserInputService.JumpRequest:Connect(function()
        if Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

-- Fungsi untuk mengaktifkan boat speed hack
local function activateBoatSpeedHack()
    RunService.Heartbeat:Connect(function()
        local currentVehicle = Humanoid.SeatPart
        if currentVehicle and currentVehicle:FindFirstAncestorOfClass("VehicleSeat") then
            local vehicle = currentVehicle:FindFirstAncestorOfClass("VehicleSeat")
            if vehicle then
                vehicle.MaxSpeed = Configuration.BoatSpeed
            end
        end
    end)
end

-- Fungsi untuk mengaktifkan boat fly
local function activateBoatFly()
    RunService.Heartbeat:Connect(function()
        if Configuration.BoatFlying then
            local currentVehicle = Humanoid.SeatPart
            if currentVehicle and currentVehicle:FindFirstAncestorOfClass("VehicleSeat") then
                local vehicle = currentVehicle:FindFirstAncestorOfClass("VehicleSeat")
                if vehicle then
                    vehicle.CFrame = vehicle.CFrame + Vector3.new(0, 1, 0)
                end
            end
        end
    end)
end

-- Fungsi untuk mengaktifkan jump hack
local function activateJumpHack()
    RunService.Heartbeat:Connect(function()
        if Humanoid then
            Humanoid.JumpPower = Configuration.JumpPower
        end
    end)
end

-- Fungsi untuk mengaktifkan auto jump
local function activateAutoJump()
    spawn(function()
        while Configuration.AutoJumpInterval > 0 do
            wait(Configuration.AutoJumpInterval)
            if Humanoid then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

-- Fungsi untuk mengaktifkan anti-AFK
local function activateAntiAFK()
    if Configuration.AntiAFK then
        local virtualUser = game:GetService("VirtualUser")
        Player.Idled:Connect(function()
            virtualUser:CaptureController()
            virtualUser:ClickButton2(Vector2.new())
        end)
    end
end

-- Fungsi untuk mengaktifkan anti-detect
local function activateAntiDetect()
    if Configuration.AntiDetect then
        -- Menonaktifkan logging tertentu
        for _, connection in ipairs(getconnections(Player.Chatted)) do
            connection:Disable()
        end
        
        -- Menyembunyikan script dari detection
        if syn and syn.protect_gui then
            syn.protect_gui(Rayfield.Main)
        end
    end
end

-- Fungsi untuk mengunci posisi
local function lockPosition()
    if Configuration.LockPosition then
        HumanoidRootPart.Anchored = true
    else
        HumanoidRootPart.Anchored = false
    end
end

-- Fungsi untuk bypass fishing radar
local function bypassFishingRadar()
    if not Configuration.FishingRadarEquipped then
        -- Cek apakah radar ada di inventory
        local hasRadar = false
        if InventoryController and InventoryController.GetInventory then
            local inventory = InventoryController.GetInventory:InvokeServer()
            for _, item in ipairs(inventory) do
                if item.Name == "Fishing Radar" then
                    hasRadar = true
                    break
                end
            end
        end
        
        if not hasRadar then
            -- Beli radar jika tidak ada
            purchaseItem("Fishing Radar", "Gear")
            wait(1)
        end
        
        -- Gunakan radar
        useItemFromInventory("Fishing Radar")
        Configuration.FishingRadarEquipped = true
    end
end

-- Fungsi untuk bypass diving gear
local function bypassDivingGear()
    if not Configuration.DivingGearEquipped then
        -- Cek apakah diving gear ada di inventory
        local hasDivingGear = false
        if InventoryController and InventoryController.GetInventory then
            local inventory = InventoryController.GetInventory:InvokeServer()
            for _, item in ipairs(inventory) do
                if item.Name == "Diving Gear" then
                    hasDivingGear = true
                    break
                end
            end
        end
        
        if not hasDivingGear then
            -- Beli diving gear jika tidak ada
            purchaseItem("Diving Gear", "Gear")
            wait(1)
        end
        
        -- Gunakan diving gear
        useItemFromInventory("Diving Gear")
        Configuration.DivingGearEquipped = true
    end
end

-- Fungsi untuk auto sell fish
local function autoSellFish()
    spawn(function()
        while Configuration.AutoSellDelay > 0 do
            wait(Configuration.AutoSellDelay)
            sellItems()
        end
    end)
end

-- Fungsi untuk membeli cuaca
local function purchaseWeather(weatherName)
    if EventController and EventController.PurchaseWeather then
        EventController.PurchaseWeather:InvokeServer(weatherName)
    end
end

-- Fungsi untuk auto buy weather
local function autoBuyWeather()
    for _, weather in ipairs(Configuration.SelectedWeathers) do
        purchaseWeather(weather)
    end
end

-- Inisialisasi fitur
local toggleFly = activateFly()
activateSpeedHack()
activateInfiniteJump()
activateBoatSpeedHack()
activateBoatFly()
activateJumpHack()
activateAntiAFK()
activateAntiDetect()

-- UI Implementation

-- Section untuk NKZ-BYPASS
local BypassSection = BypassTab:CreateSection("Bypass Features")

local LockPositionToggle = BypassTab:CreateToggle({
    Name = "LOCK POSITION",
    CurrentValue = false,
    Flag = "LockPositionToggle",
    Callback = function(Value)
        Configuration.LockPosition = Value
        lockPosition()
    end,
})

local ChooseFishingAreaDropdown = BypassTab:CreateDropdown({
    Name = "CHOOSE FISHING AREA",
    Options = AreaList,
    CurrentOption = AreaList[1],
    Flag = "ChooseFishingAreaDropdown",
    Callback = function(Option)
        teleportToArea(Option)
    end,
})

local SavePositionButton = BypassTab:CreateButton({
    Name = "SAVE POSITION",
    Callback = function()
        Configuration.SavedPosition = HumanoidRootPart.CFrame
        Rayfield:Notify({
            Title = "Position Saved",
            Content = "Posisi berhasil disimpan",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

local TeleportToSavedPositionButton = BypassTab:CreateButton({
    Name = "TELEPORT TO SAVED POSITION",
    Callback = function()
        HumanoidRootPart.CFrame = Configuration.SavedPosition
        Rayfield:Notify({
            Title = "Teleport",
            Content = "Berhasil teleport ke posisi tersimpan",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

local BypassFishingRadarButton = BypassTab:CreateButton({
    Name = "BYPASS FISHING RADAR",
    Callback = function()
        bypassFishingRadar()
    end,
})

local BypassDivingGearButton = BypassTab:CreateButton({
    Name = "BYPASS DIVING GEAR",
    Callback = function()
        bypassDivingGear()
    end,
})

local AntiAFKToggle = BypassTab:CreateToggle({
    Name = "ANTI-AFK & ANTI-DC",
    CurrentValue = false,
    Flag = "AntiAFKToggle",
    Callback = function(Value)
        Configuration.AntiAFK = Value
        activateAntiAFK()
    end,
})

local AutoJumpSlider = BypassTab:CreateSlider({
    Name = "AUTO JUMP INTERVAL",
    Range = {0, 20},
    Increment = 1,
    Suffix = "seconds",
    CurrentValue = 5,
    Flag = "AutoJumpSlider",
    Callback = function(Value)
        Configuration.AutoJumpInterval = Value
        activateAutoJump()
    end,
})

local AntiDetectToggle = BypassTab:CreateToggle({
    Name = "ANTI-DETECT DEVELOPER",
    CurrentValue = false,
    Flag = "AntiDetectToggle",
    Callback = function(Value)
        Configuration.AntiDetect = Value
        activateAntiDetect()
    end,
})

-- Section untuk NKZ-TELEPORT
local TeleportSection = TeleportTab:CreateSection("Teleport Features")

local ChooseIslandDropdown = TeleportTab:CreateDropdown({
    Name = "CHOOSE ISLAND",
    Options = AreaList,
    CurrentOption = AreaList[1],
    Flag = "ChooseIslandDropdown",
    Callback = function(Option)
        Configuration.SelectedIsland = Option
    end,
})

local TeleportToIslandButton = TeleportTab:CreateButton({
    Name = "TELEPORT TO ISLAND",
    Callback = function()
        teleportToArea(Configuration.SelectedIsland)
    end,
})

local ChooseEventDropdown = TeleportTab:CreateDropdown({
    Name = "CHOOSE EVENT",
    Options = EventList,
    CurrentOption = EventList[1],
    Flag = "ChooseEventDropdown",
    Callback = function(Option)
        Configuration.SelectedEvent = Option
    end,
})

local TeleportToEventButton = TeleportTab:CreateButton({
    Name = "TELEPORT TO EVENT",
    Callback = function()
        teleportToEvent(Configuration.SelectedEvent)
    end,
})

local SelectPlayerDropdown = TeleportTab:CreateDropdown({
    Name = "SELECT PLAYER",
    Options = refreshPlayerList(),
    CurrentOption = "",
    Flag = "SelectPlayerDropdown",
    Callback = function(Option)
        Configuration.SelectedPlayer = Option
    end,
})

local TeleportToPlayerButton = TeleportTab:CreateButton({
    Name = "TELEPORT TO PLAYER",
    Callback = function()
        teleportToPlayer(Configuration.SelectedPlayer)
    end,
})

local RefreshPlayerListButton = TeleportTab:CreateButton({
    Name = "REFRESH PLAYER LIST",
    Callback = function()
        refreshPlayerList()
        SelectPlayerDropdown:Refresh(refreshPlayerList(), true)
    end,
})

-- Section untuk NKZ-PLAYER
local PlayerSection = PlayerTab:CreateSection("Player Features")

local ActiveSpeedHackToggle = PlayerTab:CreateToggle({
    Name = "ACTIVE SPEED HACK",
    CurrentValue = true,
    Flag = "ActiveSpeedHackToggle",
    Callback = function(Value)
        Configuration.SpeedHackValue = Value and 50 or 16
    end,
})

local SettingsSpeedSlider = PlayerTab:CreateSlider({
    Name = "SETTINGS SPEED",
    Range = {0, 1000},
    Increment = 10,
    Suffix = "units",
    CurrentValue = 50,
    Flag = "SettingsSpeedSlider",
    Callback = function(Value)
        Configuration.SpeedHackValue = Value
    end,
})

local InfinityJumpToggle = PlayerTab:CreateToggle({
    Name = "INFINITY JUMP",
    CurrentValue = true,
    Flag = "InfinityJumpToggle",
    Callback = function(Value)
        -- Already always active
    end,
})

local FlyLittleToggle = PlayerTab:CreateToggle({
    Name = "FLY LITTLE",
    CurrentValue = false,
    Flag = "FlyLittleToggle",
    Callback = function(Value)
        toggleFly(Value)
    end,
})

local FlySpeedSlider = PlayerTab:CreateSlider({
    Name = "FLY SPEED",
    Range = {0, 200},
    Increment = 5,
    Suffix = "units",
    CurrentValue = 50,
    Flag = "FlySpeedSlider",
    Callback = function(Value)
        Configuration.FlySpeed = Value
    end,
})

local BoatSpeedHackToggle = PlayerTab:CreateToggle({
    Name = "BOAT SPEED HACK",
    CurrentValue = true,
    Flag = "BoatSpeedHackToggle",
    Callback = function(Value)
        Configuration.BoatSpeed = Value and 100 or 50
    end,
})

local BoatFlyToggle = PlayerTab:CreateToggle({
    Name = "BOAT FLY",
    CurrentValue = false,
    Flag = "BoatFlyToggle",
    Callback = function(Value)
        Configuration.BoatFlying = Value
    end,
})

local JumpHackToggle = PlayerTab:CreateToggle({
    Name = "JUMP HACK",
    CurrentValue = true,
    Flag = "JumpHackToggle",
    Callback = function(Value)
        Configuration.JumpPower = Value and 100 or 50
    end,
})

local JumpHackSettingSlider = PlayerTab:CreateSlider({
    Name = "JUMP HACK SETTING",
    Range = {0, 500},
    Increment = 10,
    Suffix = "units",
    CurrentValue = 100,
    Flag = "JumpHackSettingSlider",
    Callback = function(Value)
        Configuration.JumpPower = Value
    end,
})

-- Section untuk NKZ-VISUAL
local VisualSection = VisualTab:CreateSection("Visual Features")

local ActiveESPPlayerToggle = VisualTab:CreateToggle({
    Name = "ACTIVE ESP PLAYER",
    CurrentValue = false,
    Flag = "ActiveESPPlayerToggle",
    Callback = function(Value)
        Configuration.ESPEnabled = Value
        activateESP()
    end,
})

local GhostHackToggle = VisualTab:CreateToggle({
    Name = "GHOST HACK",
    CurrentValue = false,
    Flag = "GhostHackToggle",
    Callback = function(Value)
        Configuration.GhostMode = Value
        setGhostMode(Value)
    end,
})

local FOVCameraToggle = VisualTab:CreateToggle({
    Name = "FOV CAMERA",
    CurrentValue = false,
    Flag = "FOVCameraToggle",
    Callback = function(Value)
        if Value then
            setCameraFOV(Configuration.FOVSettings.Horizontal, Configuration.FOVSettings.Vertical)
        else
            setCameraFOV(0, 0)
        end
    end,
})

local SettingsFOVCameraHorizontalSlider = VisualTab:CreateSlider({
    Name = "SETTINGS FOV CAMERA HORIZONTAL",
    Range = {0, 15},
    Increment = 1,
    Suffix = "units",
    CurrentValue = 10,
    Flag = "SettingsFOVCameraHorizontalSlider",
    Callback = function(Value)
        Configuration.FOVSettings.Horizontal = Value
        if FOVCameraToggle.CurrentValue then
            setCameraFOV(Value, Configuration.FOVSettings.Vertical)
        end
    end,
})

local SettingsFOVCameraVerticalSlider = VisualTab:CreateSlider({
    Name = "SETTINGS FOV CAMERA VERTICAL",
    Range = {0, 15},
    Increment = 1,
    Suffix = "units",
    CurrentValue = 10,
    Flag = "SettingsFOVCameraVerticalSlider",
    Callback = function(Value)
        Configuration.FOVSettings.Vertical = Value
        if FOVCameraToggle.CurrentValue then
            setCameraFOV(Configuration.FOVSettings.Horizontal, Value)
        end
    end,
})

-- Section untuk NKZ-SHOP
local ShopSection = ShopTab:CreateSection("Shop Features")

local AutoSellFishToggle = ShopTab:CreateToggle({
    Name = "AUTO SELL FISH",
    CurrentValue = false,
    Flag = "AutoSellFishToggle",
    Callback = function(Value)
        if Value then
            autoSellFish()
        end
    end,
})

local DelaySellSettingsSlider = ShopTab:CreateSlider({
    Name = "DELAY SELL SETTINGS",
    Range = {1, 60},
    Increment = 1,
    Suffix = "seconds",
    CurrentValue = 5,
    Flag = "DelaySellSettingsSlider",
    Callback = function(Value)
        Configuration.AutoSellDelay = Value
    end,
})

local SelectWeatherDropdown = ShopTab:CreateDropdown({
    Name = "SELECT WEATHER",
    Options = EventList,
    CurrentOption = EventList[1],
    Flag = "SelectWeatherDropdown",
    Callback = function(Option)
        if #Configuration.SelectedWeathers < 3 then
            table.insert(Configuration.SelectedWeathers, Option)
            Rayfield:Notify({
                Title = "Weather Selected",
                Content = Option .. " ditambahkan ke daftar beli",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Maksimal 3 cuaca yang dapat dipilih",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

local ButtonBuyWeatherButton = ShopTab:CreateButton({
    Name = "BUTTON BUY WEATHER",
    Callback = function()
        for _, weather in ipairs(Configuration.SelectedWeathers) do
            purchaseWeather(weather)
        end
    end,
})

local AutoBuyWeatherToggle = ShopTab:CreateToggle({
    Name = "AUTO BUY WEATHER",
    CurrentValue = false,
    Flag = "AutoBuyWeatherToggle",
    Callback = function(Value)
        if Value then
            spawn(function()
                while Value do
                    autoBuyWeather()
                    wait(60)
                end
            end)
        end
    end,
})

-- Section untuk NKZ-UTILITY
local UtilitySection = UtilityTab:CreateSection("Utility Features")

local StabilizeFPSToggle = UtilityTab:CreateToggle({
    Name = "STABILIZE FPS/ANTILAG",
    CurrentValue = false,
    Flag = "StabilizeFPSToggle",
    Callback = function(Value)
        if Value then
            stabilizeFPS()
        end
    end,
})

local UnlockHighFPSToggle = UtilityTab:CreateToggle({
    Name = "UNLOCK HIGH FPS",
    CurrentValue = false,
    Flag = "UnlockHighFPSToggle",
    Callback = function(Value)
        if Value and setfpscap then
            setfpscap(999)
        elseif setfpscap then
            setfpscap(60)
        end
    end,
})

local HighFPSSettingsSlider = UtilityTab:CreateSlider({
    Name = "HIGH FPS SETTINGS",
    Range = {30, 240},
    Increment = 10,
    Suffix = "FPS",
    CurrentValue = 60,
    Flag = "HighFPSSettingsSlider",
    Callback = function(Value)
        Configuration.FPSLimit = Value
        if setfpscap then
            setfpscap(Value)
        end
    end,
})

local ShowSystemInfoToggle = UtilityTab:CreateToggle({
    Name = "SHOW SYSTEM INFO",
    CurrentValue = false,
    Flag = "ShowSystemInfoToggle",
    Callback = function(Value)
        if Value then
            local performanceStats = Stats:FindFirstChild("PerformanceStats")
            if performanceStats then
                local ping = performanceStats:FindFirstChild("Ping")
                local memory = performanceStats:FindFirstChild("Memory")
                
                if ping and memory then
                    RunService.RenderStepped:Connect(function()
                        Rayfield:Notify({
                            Title = "System Info",
                            Content = "Ping: " .. ping:GetValue() .. "ms | Memory: " .. memory:GetValue() .. "MB",
                            Duration = 1,
                            Image = 4483362458,
                        })
                    end)
                end
            end
        end
    end,
})

local AutoClearCacheToggle = UtilityTab:CreateToggle({
    Name = "AUTO CLEAR CACHE",
    CurrentValue = false,
    Flag = "AutoClearCacheToggle",
    Callback = function(Value)
        if Value then
            spawn(function()
                while Value do
                    clearCache()
                    wait(300)
                end
            end)
        end
    end,
})

local DisableParticlesToggle = UtilityTab:CreateToggle({
    Name = "DISABLE PARTICLES",
    CurrentValue = false,
    Flag = "DisableParticlesToggle",
    Callback = function(Value)
        if Value then
            disableParticles()
        end
    end,
})

-- Section untuk NKZ-GRAPHIC
local GraphicSection = GraphicTab:CreateSection("Graphic Features")

local MaximumQualityButton = GraphicTab:CreateButton({
    Name = "MAXIMUM QUALITY",
    Callback = function()
        Configuration.GraphicsQuality = "Maximum"
        setGraphicsQuality("Maximum")
    end,
})

local MediumQualityButton = GraphicTab:CreateButton({
    Name = "MEDIUM QUALITY",
    Callback = function()
        Configuration.GraphicsQuality = "Medium"
        setGraphicsQuality("Medium")
    end,
})

local LowQualityButton = GraphicTab:CreateButton({
    Name = "LOW QUALITY",
    Callback = function()
        Configuration.GraphicsQuality = "Low"
        setGraphicsQuality("Low")
    end,
})

local DisableWaterReflectionToggle = GraphicTab:CreateToggle({
    Name = "DISABLE WATER REFLECTION",
    CurrentValue = false,
    Flag = "DisableWaterReflectionToggle",
    Callback = function(Value)
        if Value then
            disableWaterReflection()
        end
    end,
})

local DisableSkinEffectToggle = GraphicTab:CreateToggle({
    Name = "DISABLE SKIN EFFECT",
    CurrentValue = false,
    Flag = "DisableSkinEffectToggle",
    Callback = function(Value)
        if Value then
            disableSkinEffects()
        end
    end,
})

local DisableShadowsToggle = GraphicTab:CreateToggle({
    Name = "DISABLE SHADOWS",
    CurrentValue = false,
    Flag = "DisableShadowsToggle",
    Callback = function(Value)
        if Value then
            disableShadows()
        end
    end,
})

local DisableExcessiveWaterEffectToggle = GraphicTab:CreateToggle({
    Name = "DISABLE EXCESSIVE WATER EFFECT",
    CurrentValue = false,
    Flag = "DisableExcessiveWaterEffectToggle",
    Callback = function(Value)
        if Value then
            disableExcessiveWaterEffects()
        end
    end,
})

local BrightnessSettingsSlider = GraphicTab:CreateSlider({
    Name = "BRIGHTNESS SETTINGS",
    Range = {-10, 20},
    Increment = 1,
    Suffix = "units",
    CurrentValue = 0,
    Flag = "BrightnessSettingsSlider",
    Callback = function(Value)
        setBrightness(Value)
    end,
})

-- Inisialisasi data async
loadHeavyDataAsync(function(data)
    Rayfield:Notify({
        Title = "Data Loaded",
        Content = "Semua data berhasil dimuat",
        Duration = 3,
        Image = 4483362458,
    })
end)

-- Handler untuk perubahan karakter
Player.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = newCharacter:WaitForChild("Humanoid")
    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
    
    -- Re-apply settings
    lockPosition()
    setGhostMode(Configuration.GhostMode)
end)

-- Handler untuk perubahan server
game:GetService("ReplicatedStorage").ChildAdded:Connect(function(child)
    if child.Name == "Controllers" then
        -- Re-initialize controllers
        Controllers = child
        AutoFishingController = Controllers:FindFirstChild("AutoFishingController")
        FishingController = Controllers:FindFirstChild("FishingController")
        AreaController = Controllers:FindFirstChild("AreaController")
        EventController = Controllers:FindFirstChild("EventController")
        InventoryController = Controllers:FindFirstChild("InventoryController")
        RodShopController = Controllers:FindFirstChild("RodShopController")
        BaitShopController = Controllers:FindFirstChild("BaitShopController")
        VendorController = Controllers:FindFirstChild("VendorController")
        HotbarController = Controllers:FindFirstChild("HotbarController")
        BoatShopController = Controllers:FindFirstChild("BoatShopController")
        VFXController = Controllers:FindFirstChild("VFXController")
        HUDController = Controllers:FindFirstChild("HUDController")
        SwimController = Controllers:FindFirstChild("SwimController")
        AFKController = Controllers:FindFirstChild("AFKController")
        ClientTimeController = Controllers:FindFirstChild("ClientTimeController")
        SettingsController = Controllers:FindFirstChild("SettingsController")
        PurchaseScreenBlackoutController = Controllers:FindFirstChild("PurchaseScreenBlackoutController")
    end
end)

-- Notifikasi bahwa script berhasil dimuat
Rayfield:Notify({
    Title = "NIKZZ MODDER Loaded",
    Content = "Script berhasil dimuat dengan semua fitur!",
    Duration = 5,
    Image = 4483362458,
    Actions = {
        Ignore = {
            Name = "Okay",
            Callback = function()
            end
        },
    },
})

-- Menampilkan informasi di console
print("NIKZZ MODDER successfully loaded!")
print("Features: NKZ-BYPASS, NKZ-TELEPORT, NKZ-PLAYER, NKZ-VISUAL, NKZ-SHOP, NKZ-UTILITY, NKZ-GRAPHIC")
print("Total Lines: " .. tostring(debug.info(1, "l")))
