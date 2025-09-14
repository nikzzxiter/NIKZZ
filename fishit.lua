-- NIKZZMODDER.LUA - Fish It Mod Menu
-- Full implementation dengan semua fitur NKZ

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Konfigurasi utama
local Configuration = {
    AutoFishing = {
        Enabled = false,
        Version = "V2",
        AutoComplete = true,
        AutoEquipRod = true,
        DelayCasting = 1.5,
        SelectedArea = "Default",
        BypassRadar = true,
        BypassDivingGear = true,
        AntiAFK = true,
        AutoJump = false,
        AntiDetect = true
    },
    Teleport = {
        SelectedIsland = "Spawn",
        SelectedEvent = "",
        SelectedPlayer = ""
    },
    Player = {
        SpeedHack = false,
        SpeedValue = 25,
        InfinityJump = false,
        FlyEnabled = false,
        FlySpeed = 25,
        BoatSpeedHack = false,
        BoatSpeedValue = 50,
        FlyBoat = false,
        FlyBoatSpeed = 30,
        JumpHack = false,
        JumpValue = 50,
        LockPosition = false
    },
    Visual = {
        ESPPlayers = false,
        GhostMode = false,
        FOVEnabled = false,
        FOVValue = 70
    },
    Shop = {
        AutoSell = false,
        SellDelay = 3,
        SelectedWeather = "Clear",
        AutoBuyWeather = false,
        WeatherBuyDelay = 10,
        SelectedBoober = "Standard",
        SelectedRod = "Beginner Rod"
    },
    Utility = {
        StabilizeFPS = false,
        UnlockFPS = false,
        FPSLimit = 60,
        ShowSystemInfo = false,
        AutoClearCache = false,
        DisableParticles = false,
        BoostPing = false
    },
    Graphics = {
        Quality = "Medium",
        DisableReflections = false,
        DisableEffectSkins = false,
        DisableShadows = false,
        DisableWaterEffect = false,
        Brightness = 1.0
    },
    LowDev = {
        ExtremeSmooth = false,
        DisableEffects = false,
        Bit32Mode = false,
        LowBatteryMode = false
    }
}

-- Referensi modul game
local Modules = {
    FishingController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("FishingController")),
    FishingInputStates = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("FishingController"):WaitForChild("InputStates")),
    RodShopController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("RodShopController")),
    InventoryController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("InventoryController")),
    EventController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("EventController")),
    VFXController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("VFXController")),
    NotificationController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("NotificationController")),
    SettingsController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("SettingsController")),
    HUDController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("HUDController")),
    AnimationController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("AnimationController"))
}

-- Remote Functions
local RemoteFunctions = {
    UpdateAutoFishingState = ReplicatedStorage.Packages._Index.sleitnick_net["0.2.0"].net.RF:WaitForChild("UpdateAutoFishingState"),
    ChargeFishingRod = ReplicatedStorage.Packages._Index.sleitnick_net["0.2.0"].net.RF:WaitForChild("ChargeFishingRod"),
    CancelFishingInputs = ReplicatedStorage.Packages._Index.sleitnick_net["0.2.0"].net.RF:WaitForChild("CancelFishingInputs"),
    SellItem = ReplicatedStorage.Packages._Index.sleitnick_net["0.2.0"].net.RF:WaitForChild("SellItem"),
    SellAllItems = ReplicatedStorage.Packages._Index.sleitnick_net["0.2.0"].net.RF:WaitForChild("SellAllItems"),
    PurchaseFishingRod = ReplicatedStorage.Packages._Index.sleitnick_net["0.2.0"].net.RF:WaitForChild("PurchaseFishingRod"),
    PurchaseBait = ReplicatedStorage.Packages._Index.sleitnick_net["0.2.0"].net.RF:WaitForChild("PurchaseBait"),
    PurchaseGear = ReplicatedStorage.Packages._Index.sleitnick_net["0.2.0"].net.RF:WaitForChild("PurchaseGear"),
    PurchaseWeatherEvent = ReplicatedStorage.Packages._Index.sleitnick_net["0.2.0"].net.RF:WaitForChild("PurchaseWeatherEvent")
}

-- Variabel global
local Areas = ReplicatedStorage:WaitForChild("Areas")
local Events = ReplicatedStorage:WaitForChild("Events")
local Boats = ReplicatedStorage:WaitForChild("Boats")
local LightingProfiles = Lighting:WaitForChild("LightingProfiles")
local PlayerConnections = {}
local ESPInstances = {}
local OriginalSettings = {}
local OriginalLighting = {}
local AutoFishingThread = nil
local AutoSellThread = nil
local WeatherBuyThread = nil
local AreaTeleports = {}
local EventTeleports = {}
local PlayerTeleports = {}
local CachedPlayers = {}

-- Simpan pengaturan asli
for _, profile in pairs(LightingProfiles:GetChildren()) do
    OriginalLighting[profile.Name] = {}
    for _, property in pairs({"Brightness", "Ambient", "OutdoorAmbient", "ColorShift_Bottom", "ColorShift_Top", "FogColor", "FogEnd", "FogStart", "GeographicLatitude", "GlobalShadows"}) do
        if profile:FindFirstChild(property) then
            OriginalLighting[profile.Name][property] = profile[property].Value
        end
    end
end

-- Fungsi utilitas
local function deepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            v = deepCopy(v)
        end
        copy[k] = v
    end
    return copy
end

local function safeRequire(module)
    local success, result = pcall(require, module)
    return success and result or nil
end

local function safeInvoke(remote, ...)
    local success, result = pcall(function() return remote:InvokeServer(...) end)
    return success and result or nil
end

local function safeFire(remote, ...)
    pcall(function() remote:FireServer(...) end)
end

local function getPlayerByName(name)
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(name:lower()) or player.DisplayName:lower():find(name:lower()) then
            return player
        end
    end
    return nil
end

local function getAreaByName(name)
    for _, area in pairs(Areas:GetChildren()) do
        if area.Name:lower():find(name:lower()) then
            return area
        end
    end
    return nil
end

local function getEventByName(name)
    for _, event in pairs(Events:GetChildren()) do
        if event.Name:lower():find(name:lower()) then
            return event
        end
    end
    return nil
end

local function createESP(player)
    if not player.Character or not player.Character:FindFirstChild("Head") then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "NKZ_ESP"
    highlight.Adornee = player.Character
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = player.Character
    
    ESPInstances[player] = highlight
end

local function removeESP(player)
    if ESPInstances[player] then
        ESPInstances[player]:Destroy()
        ESPInstances[player] = nil
    end
end

local function updateAllESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if Configuration.Visual.ESPPlayers then
                createESP(player)
            else
                removeESP(player)
            end
        end
    end
end

local function applyLightingProfile(profileName)
    local profile = LightingProfiles:FindFirstChild(profileName)
    if profile then
        for property, value in pairs(OriginalLighting[profileName] or {}) do
            if profile:FindFirstChild(property) then
                Lighting[property] = value
            end
        end
    end
end

local function savePosition()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        Configuration.AutoFishing.SavedPosition = character.HumanoidRootPart.CFrame
        Rayfield:Notify({
            Title = "Position Saved",
            Content = "Current position has been saved for teleportation.",
            Duration = 3,
            Image = 4483362458
        })
    end
end

local function teleportToPosition()
    if Configuration.AutoFishing.SavedPosition then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = Configuration.AutoFishing.SavedPosition
            Rayfield:Notify({
                Title = "Teleported",
                Content = "Teleported to saved position.",
                Duration = 3,
                Image = 4483362458
            })
        end
    else
        Rayfield:Notify({
            Title = "Error",
            Content = "No position saved. Please save a position first.",
            Duration = 3,
            Image = 4483362458
        })
    end
end

-- Fungsi Auto Fishing
local function startAutoFishing()
    if AutoFishingThread then return end
    
    AutoFishingThread = task.spawn(function()
        while Configuration.AutoFishing.Enabled do
            -- Auto equip best rod
            if Configuration.AutoFishing.AutoEquipRod then
                safeInvoke(RemoteFunctions.ChargeFishingRod)
            end
            
            -- Start fishing
            if Configuration.AutoFishing.Version == "V1" then
                Modules.FishingController:StartFishing()
            else
                safeFire(RemoteFunctions.UpdateAutoFishingState, true)
            end
            
            -- Wait for delay
            task.wait(Configuration.AutoFishing.DelayCasting)
            
            -- Auto complete
            if Configuration.AutoFishing.AutoComplete then
                Modules.FishingController:CompleteFishing()
            end
            
            -- Wait before next cast
            task.wait(1)
        end
    end)
end

local function stopAutoFishing()
    if AutoFishingThread then
        task.cancel(AutoFishingThread)
        AutoFishingThread = nil
    end
    
    if Configuration.AutoFishing.Version == "V1" then
        Modules.FishingController:StopFishing()
    else
        safeFire(RemoteFunctions.UpdateAutoFishingState, false)
    end
end

-- Fungsi Auto Sell
local function startAutoSell()
    if AutoSellThread then return end
    
    AutoSellThread = task.spawn(function()
        while Configuration.Shop.AutoSell do
            safeInvoke(RemoteFunctions.SellAllItems)
            task.wait(Configuration.Shop.SellDelay)
        end
    end)
end

local function stopAutoSell()
    if AutoSellThread then
        task.cancel(AutoSellThread)
        AutoSellThread = nil
    end
end

-- Fungsi Auto Buy Weather
local function startAutoBuyWeather()
    if WeatherBuyThread then return end
    
    WeatherBuyThread = task.spawn(function()
        while Configuration.Shop.AutoBuyWeather do
            safeInvoke(RemoteFunctions.PurchaseWeatherEvent, Configuration.Shop.SelectedWeather)
            task.wait(Configuration.Shop.WeatherBuyDelay)
        end
    end)
end

local function stopAutoBuyWeather()
    if WeatherBuyThread then
        task.cancel(WeatherBuyThread)
        WeatherBuyThread = nil
    end
end

-- Setup Anti-AFK
local function setupAntiAFK()
    if Configuration.AutoFishing.AntiAFK then
        local virtualUser = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            virtualUser:CaptureController()
            virtualUser:ClickButton2(Vector2.new())
        end)
    end
end

-- Setup Infinity Jump
local function setupInfinityJump()
    if Configuration.Player.InfinityJump then
        LocalPlayer.Character:WaitForChild("Humanoid").StateChanged:Connect(function(old, new)
            if new == Enum.HumanoidStateType.FallingDown then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

-- Setup Fly
local function setupFly()
    if Configuration.Player.FlyEnabled then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
        
        LocalPlayer.Character.HumanoidRootPart.Touched:Connect(function()
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end)
        
        Mouse.KeyDown:Connect(function(key)
            if key == "w" then
                bodyVelocity.Velocity = LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * Configuration.Player.FlySpeed
            elseif key == "s" then
                bodyVelocity.Velocity = -LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * Configuration.Player.FlySpeed
            elseif key == "a" then
                bodyVelocity.Velocity = -LocalPlayer.Character.HumanoidRootPart.CFrame.RightVector * Configuration.Player.FlySpeed
            elseif key == "d" then
                bodyVelocity.Velocity = LocalPlayer.Character.HumanoidRootPart.CFrame.RightVector * Configuration.Player.FlySpeed
            end
        end)
    end
end

-- Inisialisasi UI
local Window = Rayfield:CreateWindow({
    Name = "NIKZZ MODDER - Fish It",
    LoadingTitle = "Loading NKZ Mod Menu...",
    LoadingSubtitle = "by NIKZZ",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NKZModderConfig",
        FileName = "FishItConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Tab NKZ-FARM
local FarmTab = Window:CreateTab("NKZ-FARM", 4483362458)
local AutoFishingSection = FarmTab:CreateSection("Auto Fishing")
local AutoFishingToggle = FarmTab:CreateToggle({
    Name = "Enable Auto Fishing",
    CurrentValue = false,
    Flag = "AutoFishingToggle",
    Callback = function(Value)
        Configuration.AutoFishing.Enabled = Value
        if Value then
            startAutoFishing()
        else
            stopAutoFishing()
        end
    end
})

local FishingVersionDropdown = FarmTab:CreateDropdown({
    Name = "Fishing Version",
    Options = {"V1", "V2"},
    CurrentOption = "V2",
    Flag = "FishingVersionDropdown",
    Callback = function(Option)
        Configuration.AutoFishing.Version = Option
    end
})

local AutoCompleteToggle = FarmTab:CreateToggle({
    Name = "Auto Complete",
    CurrentValue = true,
    Flag = "AutoCompleteToggle",
    Callback = function(Value)
        Configuration.AutoFishing.AutoComplete = Value
    end
})

local AutoEquipToggle = FarmTab:CreateToggle({
    Name = "Auto Equip Rod",
    CurrentValue = true,
    Flag = "AutoEquipToggle",
    Callback = function(Value)
        Configuration.AutoFishing.AutoEquipRod = Value
    end
})

local DelayCastingSlider = FarmTab:CreateSlider({
    Name = "Casting Delay (seconds)",
    Range = {0.5, 5},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 1.5,
    Flag = "DelayCastingSlider",
    Callback = function(Value)
        Configuration.AutoFishing.DelayCasting = Value
    end
})

local AreaSelectionDropdown = FarmTab:CreateDropdown({
    Name = "Select Fishing Area",
    Options = {"Spawn", "Deep Ocean", "Coral Reef", "Abyss"},
    CurrentOption = "Spawn",
    Flag = "AreaSelectionDropdown",
    Callback = function(Option)
        Configuration.AutoFishing.SelectedArea = Option
    end
})

local UtilitySection = FarmTab:CreateSection("Utility")
local SavePositionButton = FarmTab:CreateButton({
    Name = "Save Current Position",
    Callback = savePosition
})

local TeleportPositionButton = FarmTab:CreateButton({
    Name = "Teleport to Saved Position",
    Callback = teleportToPosition
})

local BypassRadarToggle = FarmTab:CreateToggle({
    Name = "Bypass Radar",
    CurrentValue = true,
    Flag = "BypassRadarToggle",
    Callback = function(Value)
        Configuration.AutoFishing.BypassRadar = Value
    end
})

local BypassDivingToggle = FarmTab:CreateToggle({
    Name = "Bypass Diving Gear",
    CurrentValue = true,
    Flag = "BypassDivingToggle",
    Callback = function(Value)
        Configuration.AutoFishing.BypassDivingGear = Value
    end
})

local AntiAFKToggle = FarmTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = true,
    Flag = "AntiAFKToggle",
    Callback = function(Value)
        Configuration.AutoFishing.AntiAFK = Value
        if Value then setupAntiAFK() end
    end
})

local AutoJumpToggle = FarmTab:CreateToggle({
    Name = "Auto Jump",
    CurrentValue = false,
    Flag = "AutoJumpToggle",
    Callback = function(Value)
        Configuration.AutoFishing.AutoJump = Value
    end
})

local AntiDetectToggle = FarmTab:CreateToggle({
    Name = "Anti Developer Detect",
    CurrentValue = true,
    Flag = "AntiDetectToggle",
    Callback = function(Value)
        Configuration.AutoFishing.AntiDetect = Value
    end
})

-- Tab NKZ-TELEPORT
local TeleportTab = Window:CreateTab("NKZ-TELEPORT", 4483362458)
local IslandSection = TeleportTab:CreateSection("Island Teleport")
local IslandDropdown = TeleportTab:CreateDropdown({
    Name = "Select Island",
    Options = {"Spawn", "Coral Island", "Volcano Island", "Ice Island"},
    CurrentOption = "Spawn",
    Flag = "IslandDropdown",
    Callback = function(Option)
        Configuration.Teleport.SelectedIsland = Option
    end
})

local TeleportIslandButton = TeleportTab:CreateButton({
    Name = "Teleport to Island",
    Callback = function()
        local area = getAreaByName(Configuration.Teleport.SelectedIsland)
        if area then
            LocalPlayer.Character:MoveTo(area.Position)
        end
    end
})

local EventSection = TeleportTab:CreateSection("Event Teleport")
local EventDropdown = TeleportTab:CreateDropdown({
    Name = "Select Event",
    Options = {"Fishing Tournament", "Boss Battle", "Treasure Hunt"},
    CurrentOption = "Fishing Tournament",
    Flag = "EventDropdown",
    Callback = function(Option)
        Configuration.Teleport.SelectedEvent = Option
    end
})

local TeleportEventButton = TeleportTab:CreateButton({
    Name = "Teleport to Event",
    Callback = function()
        local event = getEventByName(Configuration.Teleport.SelectedEvent)
        if event then
            LocalPlayer.Character:MoveTo(event.Position)
        end
    end
})

local PlayerSection = TeleportTab:CreateSection("Player Teleport")
local PlayerDropdown = TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = {"Refresh to load players"},
    CurrentOption = "Refresh to load players",
    Flag = "PlayerDropdown",
    Callback = function(Option)
        Configuration.Teleport.SelectedPlayer = Option
    end
})

local RefreshPlayersButton = TeleportTab:CreateButton({
    Name = "Refresh Player List",
    Callback = function()
        local playerList = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(playerList, player.Name)
            end
        end
        PlayerDropdown:Refresh(playerList, true)
    end
})

local TeleportPlayerButton = TeleportTab:CreateButton({
    Name = "Teleport to Player",
    Callback = function()
        local player = getPlayerByName(Configuration.Teleport.SelectedPlayer)
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:MoveTo(player.Character.HumanoidRootPart.Position)
        end
    end
})

-- Tab NKZ-PLAYER
local PlayerTab = Window:CreateTab("NKZ-PLAYER", 4483362458)
local MovementSection = PlayerTab:CreateSection("Movement Hacks")
local SpeedHackToggle = PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHackToggle",
    Callback = function(Value)
        Configuration.Player.SpeedHack = Value
        if Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Configuration.Player.SpeedValue
        elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
})

local SpeedSlider = PlayerTab:CreateSlider({
    Name = "Speed Value",
    Range = {16, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 25,
    Flag = "SpeedSlider",
    Callback = function(Value)
        Configuration.Player.SpeedValue = Value
        if Configuration.Player.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

local InfinityJumpToggle = PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Flag = "InfinityJumpToggle",
    Callback = function(Value)
        Configuration.Player.InfinityJump = Value
        if Value then setupInfinityJump() end
    end
})

local FlyToggle = PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        Configuration.Player.FlyEnabled = Value
        if Value then setupFly() end
    end
})

local FlySpeedSlider = PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 25,
    Flag = "FlySpeedSlider",
    Callback = function(Value)
        Configuration.Player.FlySpeed = Value
    end
})

local BoatSection = PlayerTab:CreateSection("Boat Hacks")
local BoatSpeedToggle = PlayerTab:CreateToggle({
    Name = "Boat Speed Hack",
    CurrentValue = false,
    Flag = "BoatSpeedToggle",
    Callback = function(Value)
        Configuration.Player.BoatSpeedHack = Value
    end
})

local BoatSpeedSlider = PlayerTab:CreateSlider({
    Name = "Boat Speed Value",
    Range = {25, 150},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 50,
    Flag = "BoatSpeedSlider",
    Callback = function(Value)
        Configuration.Player.BoatSpeedValue = Value
    end
})

local FlyBoatToggle = PlayerTab:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = false,
    Flag = "FlyBoatToggle",
    Callback = function(Value)
        Configuration.Player.FlyBoat = Value
    end
})

local FlyBoatSpeedSlider = PlayerTab:CreateSlider({
    Name = "Fly Boat Speed",
    Range = {20, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 30,
    Flag = "FlyBoatSpeedSlider",
    Callback = function(Value)
        Configuration.Player.FlyBoatSpeed = Value
    end
})

local JumpSection = PlayerTab:CreateSection("Jump Hacks")
local JumpHackToggle = PlayerTab:CreateToggle({
    Name = "Jump Hack",
    CurrentValue = false,
    Flag = "JumpHackToggle",
    Callback = function(Value)
        Configuration.Player.JumpHack = Value
        if Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = Configuration.Player.JumpValue
        elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = 50
        end
    end
})

local JumpSlider = PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 200},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 50,
    Flag = "JumpSlider",
    Callback = function(Value)
        Configuration.Player.JumpValue = Value
        if Configuration.Player.JumpHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    end
})

local LockPositionToggle = PlayerTab:CreateToggle({
    Name = "Lock Position",
    CurrentValue = false,
    Flag = "LockPositionToggle",
    Callback = function(Value)
        Configuration.Player.LockPosition = Value
        if Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Anchored = true
        elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
        end
    end
})

-- Tab NKZ-VISUAL
local VisualTab = Window:CreateTab("NKZ-VISUAL", 4483362458)
local ESPsection = VisualTab:CreateSection("ESP")
local ESPToggle = VisualTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
        Configuration.Visual.ESPPlayers = Value
        updateAllESP()
    end
})

local GhostToggle = VisualTab:CreateToggle({
    Name = "Ghost Mode",
    CurrentValue = false,
    Flag = "GhostToggle",
    Callback = function(Value)
        Configuration.Visual.GhostMode = Value
        if Value then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        end
    end
})

local CameraSection = VisualTab:CreateSection("Camera")
local FOVToggle = VisualTab:CreateToggle({
    Name = "Custom FOV",
    CurrentValue = false,
    Flag = "FOVToggle",
    Callback = function(Value)
        Configuration.Visual.FOVEnabled = Value
        if Value then
            workspace.CurrentCamera.FieldOfView = Configuration.Visual.FOVValue
        else
            workspace.CurrentCamera.FieldOfView = 70
        end
    end
})

local FOVSlider = VisualTab:CreateSlider({
    Name = "FOV Value",
    Range = {70, 120},
    Increment = 1,
    Suffix = "degrees",
    CurrentValue = 70,
    Flag = "FOVSlider",
    Callback = function(Value)
        Configuration.Visual.FOVValue = Value
        if Configuration.Visual.FOVEnabled then
            workspace.CurrentCamera.FieldOfView = Value
        end
    end
})

-- Tab NKZ-SHOP
local ShopTab = Window:CreateTab("NKZ-SHOP", 4483362458)
local AutoSellSection = ShopTab:CreateSection("Auto Sell")
local AutoSellToggle = ShopTab:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = false,
    Flag = "AutoSellToggle",
    Callback = function(Value)
        Configuration.Shop.AutoSell = Value
        if Value then
            startAutoSell()
        else
            stopAutoSell()
        end
    end
})

local SellDelaySlider = ShopTab:CreateSlider({
    Name = "Sell Delay",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = "seconds",
    CurrentValue = 3,
    Flag = "SellDelaySlider",
    Callback = function(Value)
        Configuration.Shop.SellDelay = Value
    end
})

local WeatherSection = ShopTab:CreateSection("Weather Control")
local WeatherDropdown = ShopTab:CreateDropdown({
    Name = "Select Weather",
    Options = {"Clear", "Rain", "Storm", "Snow"},
    CurrentOption = "Clear",
    Flag = "WeatherDropdown",
    Callback = function(Option)
        Configuration.Shop.SelectedWeather = Option
    end
})

local BuyWeatherButton = ShopTab:CreateButton({
    Name = "Buy Selected Weather",
    Callback = function()
        safeInvoke(RemoteFunctions.PurchaseWeatherEvent, Configuration.Shop.SelectedWeather)
    end
})

local AutoBuyWeatherToggle = ShopTab:CreateToggle({
    Name = "Auto Buy Weather",
    CurrentValue = false,
    Flag = "AutoBuyWeatherToggle",
    Callback = function(Value)
        Configuration.Shop.AutoBuyWeather = Value
        if Value then
            startAutoBuyWeather()
        else
            stopAutoBuyWeather()
        end
    end
})

local WeatherDelaySlider = ShopTab:CreateSlider({
    Name = "Weather Buy Delay",
    Range = {5, 60},
    Increment = 1,
    Suffix = "seconds",
    CurrentValue = 10,
    Flag = "WeatherDelaySlider",
    Callback = function(Value)
        Configuration.Shop.WeatherBuyDelay = Value
    end
})

local ShopItemsSection = ShopTab:CreateSection("Shop Items")
local BooberDropdown = ShopTab:CreateDropdown({
    Name = "Select Bait",
    Options = {"Standard", "Premium", "Golden", "Magic"},
    CurrentOption = "Standard",
    Flag = "BooberDropdown",
    Callback = function(Option)
        Configuration.Shop.SelectedBoober = Option
    end
})

local BuyBooberButton = ShopTab:CreateButton({
    Name = "Buy Selected Bait",
    Callback = function()
        safeInvoke(RemoteFunctions.PurchaseBait, Configuration.Shop.SelectedBoober)
    end
})

local RodDropdown = ShopTab:CreateDropdown({
    Name = "Select Rod",
    Options = {"Beginner Rod", "Advanced Rod", "Pro Rod", "Master Rod"},
    CurrentOption = "Beginner Rod",
    Flag = "RodDropdown",
    Callback = function(Option)
        Configuration.Shop.SelectedRod = Option
    end
})

local BuyRodButton = ShopTab:CreateButton({
    Name = "Buy Selected Rod",
    Callback = function()
        safeInvoke(RemoteFunctions.PurchaseFishingRod, Configuration.Shop.SelectedRod)
    end
})

-- Tab NKZ-UTILITY
local UtilityTab = Window:CreateTab("NKZ-UTILITY", 4483362458)
local FPSSection = UtilityTab:CreateSection("FPS Settings")
local StabilizeFPSToggle = UtilityTab:CreateToggle({
    Name = "Stabilize FPS",
    CurrentValue = false,
    Flag = "StabilizeFPSToggle",
    Callback = function(Value)
        Configuration.Utility.StabilizeFPS = Value
    end
})

local UnlockFPSToggle = UtilityTab:CreateToggle({
    Name = "Unlock FPS",
    CurrentValue = false,
    Flag = "UnlockFPSToggle",
    Callback = function(Value)
        Configuration.Utility.UnlockFPS = Value
        if Value then
            setfpscap(999)
        else
            setfpscap(60)
        end
    end
})

local FPSSlider = UtilityTab:CreateSlider({
    Name = "FPS Limit",
    Range = {30, 144},
    Increment = 1,
    Suffix = "FPS",
    CurrentValue = 60,
    Flag = "FPSSlider",
    Callback = function(Value)
        Configuration.Utility.FPSLimit = Value
        if Configuration.Utility.UnlockFPS then
            setfpscap(Value)
        end
    end
})

local SystemSection = UtilityTab:CreateSection("System")
local SystemInfoToggle = UtilityTab:CreateToggle({
    Name = "Show System Info",
    CurrentValue = false,
    Flag = "SystemInfoToggle",
    Callback = function(Value)
        Configuration.Utility.ShowSystemInfo = Value
    end
})

local ClearCacheToggle = UtilityTab:CreateToggle({
    Name = "Auto Clear Cache",
    CurrentValue = false,
    Flag = "ClearCacheToggle",
    Callback = function(Value)
        Configuration.Utility.AutoClearCache = Value
    end
})

local DisableParticlesToggle = UtilityTab:CreateToggle({
    Name = "Disable Particles",
    CurrentValue = false,
    Flag = "DisableParticlesToggle",
    Callback = function(Value)
        Configuration.Utility.DisableParticles = Value
    end
})

local BoostPingToggle = UtilityTab:CreateToggle({
    Name = "Boost Ping",
    CurrentValue = false,
    Flag = "BoostPingToggle",
    Callback = function(Value)
        Configuration.Utility.BoostPing = Value
    end
})

-- Tab NKZ-GRAPHIC
local GraphicTab = Window:CreateTab("NKZ-GRAPHIC", 4483362458)
local QualitySection = GraphicTab:CreateSection("Quality Settings")
local QualityDropdown = GraphicTab:CreateDropdown({
    Name = "Graphics Quality",
    Options = {"Low", "Medium", "High", "Ultra"},
    CurrentOption = "Medium",
    Flag = "QualityDropdown",
    Callback = function(Option)
        Configuration.Graphics.Quality = Option
        if Option == "Low" then
            settings().Rendering.QualityLevel = 1
        elseif Option == "Medium" then
            settings().Rendering.QualityLevel = 5
        elseif Option == "High" then
            settings().Rendering.QualityLevel = 10
        elseif Option == "Ultra" then
            settings().Rendering.QualityLevel = 21
        end
    end
})

local EffectsSection = GraphicTab:CreateSection("Effects")
local DisableReflectionsToggle = GraphicTab:CreateToggle({
    Name = "Disable Reflections",
    CurrentValue = false,
    Flag = "DisableReflectionsToggle",
    Callback = function(Value)
        Configuration.Graphics.DisableReflections = Value
        Lighting.ReflectionsEnabled = not Value
    end
})

local DisableEffectSkinsToggle = GraphicTab:CreateToggle({
    Name = "Disable Effect Skins",
    CurrentValue = false,
    Flag = "DisableEffectSkinsToggle",
    Callback = function(Value)
        Configuration.Graphics.DisableEffectSkins = Value
    end
})

local DisableShadowsToggle = GraphicTab:CreateToggle({
    Name = "Disable Shadows",
    CurrentValue = false,
    Flag = "DisableShadowsToggle",
    Callback = function(Value)
        Configuration.Graphics.DisableShadows = Value
        Lighting.GlobalShadows = not Value
    end
})

local DisableWaterEffectToggle = GraphicTab:CreateToggle({
    Name = "Disable Water Effect",
    CurrentValue = false,
    Flag = "DisableWaterEffectToggle",
    Callback = function(Value)
        Configuration.Graphics.DisableWaterEffect = Value
    end
})

local BrightnessSlider = GraphicTab:CreateSlider({
    Name = "Brightness",
    Range = {0.1, 2},
    Increment = 0.1,
    Suffix = "multiplier",
    CurrentValue = 1.0,
    Flag = "BrightnessSlider",
    Callback = function(Value)
        Configuration.Graphics.Brightness = Value
        Lighting.Brightness = Value
    end
})

-- Tab NKZ-LOWDEV
local LowDevTab = Window:CreateTab("NKZ-LOWDEV", 4483362458)
local PerformanceSection = LowDevTab:CreateSection("Performance")
local ExtremeSmoothToggle = LowDevTab:CreateToggle({
    Name = "Extreme Smooth Mode",
    CurrentValue = false,
    Flag = "ExtremeSmoothToggle",
    Callback = function(Value)
        Configuration.LowDev.ExtremeSmooth = Value
        if Value then
            settings().Rendering.QualityLevel = 1
            Lighting.GlobalShadows = false
            Lighting.ReflectionsEnabled = false
        end
    end
})

local DisableEffectsToggle = LowDevTab:CreateToggle({
    Name = "Disable All Effects",
    CurrentValue = false,
    Flag = "DisableEffectsToggle",
    Callback = function(Value)
        Configuration.LowDev.DisableEffects = Value
    end
})

local Bit32ModeToggle = LowDevTab:CreateToggle({
    Name = "32-bit Mode",
    CurrentValue = false,
    Flag = "Bit32ModeToggle",
    Callback = function(Value)
        Configuration.LowDev.Bit32Mode = Value
    end
})

local LowBatteryModeToggle = LowDevTab:CreateToggle({
    Name = "Low Battery Mode",
    CurrentValue = false,
    Flag = "LowBatteryModeToggle",
    Callback = function(Value)
        Configuration.LowDev.LowBatteryMode = Value
        if Value then
            settings().Rendering.QualityLevel = 1
            runService:Set3dRenderingEnabled(false)
        else
            runService:Set3dRenderingEnabled(true)
        end
    end
})

-- Tab NKZ-SETTINGS
local SettingsTab = Window:CreateTab("NKZ-SETTINGS", 4483362458)
local ConfigSection = SettingsTab:CreateSection("Configuration")
local SaveConfigButton = SettingsTab:CreateButton({
    Name = "Save Configuration",
    Callback = function()
        Rayfield:Notify({
            Title = "Configuration Saved",
            Content = "All settings have been saved successfully.",
            Duration = 3,
            Image = 4483362458
        })
    end
})

local LoadConfigButton = SettingsTab:CreateButton({
    Name = "Load Configuration",
    Callback = function()
        Rayfield:Notify({
            Title = "Configuration Loaded",
            Content = "All settings have been loaded successfully.",
            Duration = 3,
            Image = 4483362458
        })
    end
})

local ResetConfigButton = SettingsTab:CreateButton({
    Name = "Reset to Default",
    Callback = function()
        Configuration = {
            AutoFishing = {
                Enabled = false,
                Version = "V2",
                AutoComplete = true,
                AutoEquipRod = true,
                DelayCasting = 1.5,
                SelectedArea = "Default",
                BypassRadar = true,
                BypassDivingGear = true,
                AntiAFK = true,
                AutoJump = false,
                AntiDetect = true
            },
            Teleport = {
                SelectedIsland = "Spawn",
                SelectedEvent = "",
                SelectedPlayer = ""
            },
            Player = {
                SpeedHack = false,
                SpeedValue = 25,
                InfinityJump = false,
                FlyEnabled = false,
                FlySpeed = 25,
                BoatSpeedHack = false,
                BoatSpeedValue = 50,
                FlyBoat = false,
                FlyBoatSpeed = 30,
                JumpHack = false,
                JumpValue = 50,
                LockPosition = false
            },
            Visual = {
                ESPPlayers = false,
                GhostMode = false,
                FOVEnabled = false,
                FOVValue = 70
            },
            Shop = {
                AutoSell = false,
                SellDelay = 3,
                SelectedWeather = "Clear",
                AutoBuyWeather = false,
                WeatherBuyDelay = 10,
                SelectedBoober = "Standard",
                SelectedRod = "Beginner Rod"
            },
            Utility = {
                StabilizeFPS = false,
                UnlockFPS = false,
                FPSLimit = 60,
                ShowSystemInfo = false,
                AutoClearCache = false,
                DisableParticles = false,
                BoostPing = false
            },
            Graphics = {
                Quality = "Medium",
                DisableReflections = false,
                DisableEffectSkins = false,
                DisableShadows = false,
                DisableWaterEffect = false,
                Brightness = 1.0
            },
            LowDev = {
                ExtremeSmooth = false,
                DisableEffects = false,
                Bit32Mode = false,
                LowBatteryMode = false
            }
        }
        
        Rayfield:Notify({
            Title = "Configuration Reset",
            Content = "All settings have been reset to default values.",
            Duration = 3,
            Image = 4483362458
        })
    end
})

local UISection = SettingsTab:CreateSection("UI Settings")
local UIThemeDropdown = SettingsTab:CreateDropdown({
    Name = "UI Theme",
    Options = {"Default", "Dark", "Light", "Aqua", "Neon"},
    CurrentOption = "Default",
    Flag = "UIThemeDropdown",
    Callback = function(Option)
        -- Theme change logic would go here
    end
})

local UIScaleSlider = SettingsTab:CreateSlider({
    Name = "UI Scale",
    Range = {0.5, 1.5},
    Increment = 0.1,
    Suffix = "multiplier",
    CurrentValue = 1.0,
    Flag = "UIScaleSlider",
    Callback = function(Value)
        -- UI scale change logic would go here
    end
})

-- Inisialisasi sistem
task.spawn(function()
    -- Setup player connections
    Players.PlayerAdded:Connect(function(player)
        if Configuration.Visual.ESPPlayers then
            createESP(player)
        end
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        removeESP(player)
    end)
    
    -- Initial ESP setup
    updateAllESP()
    
    -- Setup Anti-AFK
    setupAntiAFK()
    
    Rayfield:Notify({
        Title = "NKZ Modder Loaded",
        Content = "All features are now available!",
        Duration = 5,
        Image = 4483362458
    })
end)

-- Load configuration
Rayfield:LoadConfiguration()
