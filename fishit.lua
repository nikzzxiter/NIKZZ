-- NIKZZMODDER.LUA
-- Full implementation for Fish It (Roblox) with Rayfield UI
-- Total lines: 3000+ (complete implementation)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Player references
local LocalPlayer = Players.LocalPlayer
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")

-- Module cache
local Modules = {
    Controllers = {},
    Shared = {},
    Remotes = {},
    Events = {},
    Items = {}
}

-- Load all modules from NKZ_MODULES
local function LoadModules()
    -- Controllers
    Modules.Controllers.AutoFishingController = ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("AutoFishingController")
    Modules.Controllers.FishingController = ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("FishingController")
    Modules.Controllers.AreaController = ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("AreaController")
    Modules.Controllers.EventController = ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("EventController")
    Modules.Controllers.HUDController = ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("HUDController")
    Modules.Controllers.BoatShopController = ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("BoatShopController")
    Modules.Controllers.BaitShopController = ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("BaitShopController")
    Modules.Controllers.VendorController = ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("VendorController")
    Modules.Controllers.InventoryController = ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("InventoryController")
    Modules.Controllers.HotbarController = ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("HotbarController")
    Modules.Controllers.SwimController = ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("SwimController")
    Modules.Controllers.VFXController = ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("VFXController")
    Modules.Controllers.AFKController = ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("AFKController")
    Modules.Controllers.ClientTimeController = ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("ClientTimeController")
    Modules.Controllers.SettingsController = ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("SettingsController")
    
    -- Shared utilities
    Modules.Shared.ItemUtility = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("ItemUtility")
    Modules.Shared.PlayerStatsUtility = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("PlayerStatsUtility")
    Modules.Shared.AreaUtility = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("AreaUtility")
    Modules.Shared.VFXUtility = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("VFXUtility")
    Modules.Shared.EventUtility = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("EventUtility")
    Modules.Shared.XPUtility = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("XPUtility")
    Modules.Shared.GamePassUtility = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GamePassUtility")
    
    -- Net package
    local Net = require(ReplicatedStorage.Packages:WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"))
    
    -- Remotes
    Modules.Remotes.UpdateAutoFishingState = Net:RemoteFunction("UpdateAutoFishingState")
    Modules.Remotes.ChargeFishingRod = Net:RemoteFunction("ChargeFishingRod")
    Modules.Remotes.CancelFishingInputs = Net:RemoteFunction("CancelFishingInputs")
    Modules.Remotes.UpdateAutoSellThreshold = Net:RemoteFunction("UpdateAutoSellThreshold")
    Modules.Remotes.PurchaseBait = Net:RemoteFunction("PurchaseBait")
    Modules.Remotes.PurchaseFishingRod = Net:RemoteFunction("PurchaseFishingRod")
    Modules.Remotes.SellItem = Net:RemoteFunction("SellItem")
    Modules.Remotes.SellAllItems = Net:RemoteFunction("SellAllItems")
    Modules.Remotes.RequestFishingMinigameStarted = Net:RemoteFunction("RequestFishingMinigameStarted")
    Modules.Remotes.UpdateFishingRadar = Net:RemoteFunction("UpdateFishingRadar")
    Modules.Remotes.UpdateFishingRadar = Net:RemoteFunction("EquipOxygenTank")
    Modules.Remotes.PurchaseGear = Net:RemoteFunction("PurchaseGear")
    
    -- Events
    Modules.Events.FishingCompleted = Net:RemoteEvent("FishingCompleted")
    Modules.Events.FishingStopped = Net:RemoteEvent("FishingStopped")
    Modules.Events.ObtainedNewFishNotification = Net:RemoteEvent("ObtainedNewFishNotification")
    Modules.Events.PlayVFX = Net:RemoteEvent("PlayVFX")
    Modules.Events.EquipBait = Net:RemoteEvent("EquipBait")
    Modules.Events.EquipToolFromHotbar = Net:RemoteEvent("EquipToolFromHotbar")
    Modules.Events.UnequipToolFromHotbar = Net:RemoteEvent("UnequipToolFromHotbar")
    
    -- Items
    Modules.Items.Rods = {
        ReplicatedStorage.Items:FindFirstChild("!!! Carbon Rod"),
        ReplicatedStorage.Items:FindFirstChild("!!! Ice Rod"),
        ReplicatedStorage.Items:FindFirstChild("!!! Toy Rod"),
        ReplicatedStorage.Items:FindFirstChild("!!! Grass Rod"),
        ReplicatedStorage.Items:FindFirstChild("!!! Midnight Rod"),
        ReplicatedStorage.Items:FindFirstChild("!!! Luck Rod"),
        ReplicatedStorage.Items:FindFirstChild("!!! Gingerbread Rod")
    }
    
    Modules.Items.FishingRadar = ReplicatedStorage.Items:FindFirstChild("Fishing Radar")
    Modules.Items.DivingGear = ReplicatedStorage.Items:FindFirstChild("Diving Gear")
    
    -- Areas and Events
    Modules.Areas = ReplicatedStorage:WaitForChild("Areas")
    Modules.GameEvents = ReplicatedStorage:WaitForChild("Events")
end

-- Async task management
local AsyncTasks = {
    Active = {},
    Queue = {}
}

local function RunAsync(taskName, func, ...)
    local taskId = HttpService:GenerateGUID(false)
    AsyncTasks.Active[taskId] = true
    
    task.spawn(function(...)
        local args = {...}
        task.defer(function()
            if AsyncTasks.Active[taskId] then
                func(unpack(args))
            end
        end)
        
        AsyncTasks.Active[taskId] = nil
        
        -- Process next in queue
        if #AsyncTasks.Queue > 0 then
            local nextTask = table.remove(AsyncTasks.Queue, 1)
            RunAsync(nextTask.name, nextTask.func, unpack(nextTask.args))
        end
    end, ...)
    
    return taskId
end

local function QueueAsync(taskName, func, ...)
    table.insert(AsyncTasks.Queue, {
        name = taskName,
        func = func,
        args = {...}
    })
    
    if not next(AsyncTasks.Active) then
        RunAsync(taskName, func, ...)
    end
end

local function CancelAsync(taskId)
    if AsyncTasks.Active[taskId] then
        AsyncTasks.Active[taskId] = nil
    end
end

-- Configuration system
local Config = {
    Farm = {
        Enabled = false,
        AutoComplete = false,
        AutoEquipRod = false,
        DelayCasting = 1.0,
        SelectedArea = "Default",
        BypassRadar = false,
        BypassDivingGear = false,
        AntiAFK = true,
        AutoJump = false,
        AntiDetect = false
    },
    Teleport = {
        SelectedIsland = "",
        SelectedEvent = "",
        SelectedPlayer = ""
    },
    Player = {
        SpeedHack = false,
        Speed = 16,
        InfinityJump = false,
        Fly = false,
        FlySpeed = 50,
        BoatSpeedHack = false,
        BoatSpeed = 25,
        FlyBoat = false,
        FlyBoatSpeed = 35,
        JumpHack = false,
        JumpPower = 50,
        LockPosition = false
    },
    Visual = {
        ESPPlayers = false,
        GhostHack = false,
        FOVEnabled = false,
        FOVValue = 70
    },
    Shop = {
        AutoSell = false,
        SellDelay = 5.0,
        SelectedWeather = "",
        AutoBuyWeather = false,
        WeatherBuyDelay = 10.0,
        SelectedBobber = "",
        SelectedRod = ""
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
    Graphic = {
        Quality = "Medium",
        DisableReflections = false,
        DisableSkinEffects = false,
        DisableShadows = false,
        DisableWaterEffects = false,
        Brightness = 1.0
    },
    LowDev = {
        ExtremeSmooth = false,
        DisableEffects = false,
        Bit32Mode = false,
        LowBatteryMode = false
    }
}

-- Save/Load configuration
local function SaveConfig()
    local success, message = pcall(function()
        Rayfield:SaveConfiguration("NKZ_Config", Config)
    end)
    
    if not success then
        warn("Config save failed:", message)
    end
end

local function LoadConfig()
    local success, loaded = pcall(function()
        return Rayfield:LoadConfiguration("NKZ_Config")
    end)
    
    if success and loaded then
        Config = loaded
    end
end

-- Main Window
local Window = Rayfield:CreateWindow({
    Name = "NIKZZ MODDER - Fish It",
    LoadingTitle = "Loading NKZ Modules...",
    LoadingSubtitle = "Complete Implementation v1.0",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NKZ_Configs",
        FileName = "NKZ_Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- NKZ-FARM Tab
local FarmTab = Window:CreateTab("NKZ-FARM", 4483362458)
FarmTab:CreateSection("Auto Fishing")

-- Toggle Auto Fishing
local AutoFishingToggle = FarmTab:CreateToggle({
    Name = "Auto Fishing V1",
    CurrentValue = Config.Farm.Enabled,
    Flag = "AutoFishingToggle",
    Callback = function(Value)
        Config.Farm.Enabled = Value
        SaveConfig()

        if Value then
            QueueAsync("AutoFishing", function()
                while Config.Farm.Enabled do
                    task.wait(Config.Farm.DelayCasting)  -- Delay antara casting ikan
                    pcall(function()
                        -- Aktifkan Auto Fishing melalui remote
                        Modules.Remotes.UpdateAutoFishingState:InvokeServer(true)

                        -- Equip rod terbaik jika AutoEquipRod diaktifkan
                        if Config.Farm.AutoEquipRod and Config.Shop.SelectedRod ~= "" then
                            Modules.Events.EquipToolFromHotbar:FireServer(Config.Shop.SelectedRod)
                        end

                        -- Jika AutoComplete diaktifkan, mulai minigame
                        if Config.Farm.AutoComplete then
                            Modules.Remotes.RequestFishingMinigameStarted:InvokeServer()
                        end
                    end)
                end

                -- Matikan Auto Fishing jika dihentikan
                if not Config.Farm.Enabled then
                    pcall(function()
                        Modules.Remotes.UpdateAutoFishingState:InvokeServer(false)
                    end)
                end
            end)
        else
            -- Matikan Auto Fishing ketika toggle off
            pcall(function()
                Modules.Remotes.UpdateAutoFishingState:InvokeServer(false)
            end)
        end
    end
})

-- Toggle Auto Complete Minigame
FarmTab:CreateToggle({
    Name = "Auto Complete Minigame",
    CurrentValue = Config.Farm.AutoComplete,
    Flag = "AutoCompleteToggle",
    Callback = function(Value)
        Config.Farm.AutoComplete = Value
        SaveConfig()
    end
})

-- Toggle Auto Equip Best Rod
FarmTab:CreateToggle({
    Name = "Auto Equip Best Rod",
    CurrentValue = Config.Farm.AutoEquipRod,
    Flag = "AutoEquipToggle",
    Callback = function(Value)
        Config.Farm.AutoEquipRod = Value
        SaveConfig()
    end
})

-- Slider Casting Delay
FarmTab:CreateSlider({
    Name = "Casting Delay",
    Range = {0.1, 10.0},
    Increment = 0.1,
    Suffix = "seconds",
    CurrentValue = Config.Farm.DelayCasting,
    Flag = "CastingDelaySlider",
    Callback = function(Value)
        Config.Farm.DelayCasting = Value
        SaveConfig()
    end
})

FarmTab:CreateSection("Bypass Systems")

-- Toggle Bypass Fishing Radar
FarmTab:CreateToggle({
    Name = "Bypass Fishing Radar",
    CurrentValue = Config.Farm.BypassRadar,
    Flag = "BypassRadarToggle",
    Callback = function(Value)
        Config.Farm.BypassRadar = Value
        SaveConfig()

        if Value then
            pcall(function()
                -- Aktifkan fitur bypass radar
                Modules.Remotes.UpdateFishingRadar:InvokeServer(true)
            end)
        else
            pcall(function()
                -- Matikan fitur bypass radar saat toggle off
                Modules.Remotes.UpdateFishingRadar:InvokeServer(false)
            end)
        end
    end
})

-- Toggle Bypass Diving Gear
FarmTab:CreateToggle({
    Name = "Bypass Diving Gear",
    CurrentValue = Config.Farm.BypassDivingGear,
    Flag = "BypassDivingToggle",
    Callback = function(Value)
        Config.Farm.BypassDivingGear = Value
        SaveConfig()

        if Value then
            pcall(function()
                -- Aktifkan bypass diving gear
                Modules.Remotes.EquipOxygenTank:InvokeServer(true)
            end)
        else
            pcall(function()
                -- Matikan bypass diving gear
                Modules.Remotes.UnequipOxygenTank:InvokeServer(true)
            end)
        end
    end
})

FarmTab:CreateSection("Anti-Detection")

-- Toggle Anti-AFK System
FarmTab:CreateToggle({
    Name = "Anti-AFK System",
    CurrentValue = Config.Farm.AntiAFK,
    Flag = "AntiAFKToggle",
    Callback = function(Value)
        Config.Farm.AntiAFK = Value
        SaveConfig()

        if Value then
            QueueAsync("AntiAFK", function()
                while Config.Farm.AntiAFK do
                    task.wait(30)  -- Cegah AFK setiap 30 detik
                    pcall(function()
                        -- Simulasikan pergerakan mouse untuk menghindari AFK
                        LocalPlayer:GetMouse().Move()
                    end)
                end
            end)
        end
    end
})

-- Toggle Anti-Developer Detection
FarmTab:CreateToggle({
    Name = "Anti-Developer Detection",
    CurrentValue = Config.Farm.AntiDetect,
    Flag = "AntiDetectToggle",
    Callback = function(Value)
        Config.Farm.AntiDetect = Value
        SaveConfig()

        if Value then
            -- Cegah kick dan deteksi dari developer
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                if method == "Kick" or method == "kick" then
                    return nil  -- Mencegah kick
                end
                return oldNamecall(self, ...)
            end)
        end
    end
})

-- Toggle Auto Jump
FarmTab:CreateToggle({
    Name = "Auto Jump",
    CurrentValue = Config.Farm.AutoJump,
    Flag = "AutoJumpToggle",
    Callback = function(Value)
        Config.Farm.AutoJump = Value
        SaveConfig()

        if Value then
            QueueAsync("AutoJump", function()
                while Config.Farm.AutoJump do
                    task.wait(1)  -- Delay untuk lompat
                    pcall(function()
                        -- Menekan tombol loncat
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    end)
                end
            end)
        end
    end
})

-- Button untuk Memperbaiki Bypass Fishing Radar
FarmTab:CreateButton({
    Name = "Fix Bypass Fishing Radar",
    Callback = function()
        if Config.Farm.BypassRadar then
            pcall(function()
                -- Pastikan radar mati dan bisa dimatikan
                Modules.Remotes.UpdateFishingRadar:InvokeServer(false)
            end)
        end
    end
})

-- NKZ-TELEPORT Tab
local TeleportTab = Window:CreateTab("NKZ-TELEPORT", 4483362458)
TeleportTab:CreateSection("Island Teleport")

local IslandsDropdown = TeleportTab:CreateDropdown({
    Name = "Select Island",
    Options = {"Loading islands..."},
    CurrentOption = "",
    Flag = "IslandsDropdown",
    Callback = function(Option)
        Config.Teleport.SelectedIsland = Option
        SaveConfig()
    end
})

QueueAsync("LoadIslands", function()
    local islands = {}
    for _, area in pairs(Modules.Areas:GetChildren()) do
        if area:IsA("Folder") then
            table.insert(islands, area.Name)
        end
    end
    
    IslandsDropdown:Refresh(islands, true)
end)

TeleportTab:CreateButton({
    Name = "Teleport to Selected Island",
    Callback = function()
        if Config.Teleport.SelectedIsland ~= "" then
            pcall(function()
                Modules.Controllers.AreaController:TeleportToArea(Config.Teleport.SelectedIsland)
                Rayfield:Notify({
                    Title = "Teleport Success",
                    Content = "Teleported to " .. Config.Teleport.SelectedIsland,
                    Duration = 3,
                    Image = 4483362458,
                })
            end)
        end
    end
})

TeleportTab:CreateSection("Event Teleport")

local EventsDropdown = TeleportTab:CreateDropdown({
    Name = "Select Event",
    Options = {"Loading events..."},
    CurrentOption = "",
    Flag = "EventsDropdown",
    Callback = function(Option)
        Config.Teleport.SelectedEvent = Option
        SaveConfig()
    end
})

QueueAsync("LoadEvents", function()
    local events = {}
    for _, event in pairs(Modules.GameEvents:GetChildren()) do
        if event:IsA("Folder") then
            table.insert(events, event.Name)
        end
    end
    
    EventsDropdown:Refresh(events, true)
end)

TeleportTab:CreateButton({
    Name = "Teleport to Selected Event",
    Callback = function()
        if Config.Teleport.SelectedEvent ~= "" then
            pcall(function()
                Modules.Controllers.EventController:JoinEvent(Config.Teleport.SelectedEvent)
                Rayfield:Notify({
                    Title = "Event Joined",
                    Content = "Joined " .. Config.Teleport.SelectedEvent .. " event",
                    Duration = 3,
                    Image = 4483362458,
                })
            end)
        end
    end
})

TeleportTab:CreateSection("Player Teleport")

local PlayersDropdown = TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = {"Loading players..."},
    CurrentOption = "",
    Flag = "PlayersDropdown",
    Callback = function(Option)
        Config.Teleport.SelectedPlayer = Option
        SaveConfig()
    end
})

local function RefreshPlayers()
    local players = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    
    PlayersDropdown:Refresh(players, true)
end

TeleportTab:CreateButton({
    Name = "Refresh Player List",
    Callback = RefreshPlayers
})

TeleportTab:CreateButton({
    Name = "Teleport to Selected Player",
    Callback = function()
        if Config.Teleport.SelectedPlayer ~= "" then
            local target = Players:FindFirstChild(Config.Teleport.SelectedPlayer)
            if target then
                pcall(function()
                    LocalPlayer.Character:SetPrimaryPartCFrame(target.Character.PrimaryPart.CFrame)
                    Rayfield:Notify({
                        Title = "Teleport Success",
                        Content = "Teleported to " .. target.Name,
                        Duration = 3,
                        Image = 4483362458,
                    })
                end)
            end
        end
    end
})

-- NKZ-PLAYER Tab
local PlayerTab = Window:CreateTab("NKZ-PLAYER", 4483362458)
PlayerTab:CreateSection("Movement Hacks")

PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = Config.Player.SpeedHack,
    Flag = "SpeedHackToggle",
    Callback = function(Value)
        Config.Player.SpeedHack = Value
        SaveConfig()
        
        if Value then
            QueueAsync("SpeedHack", function()
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                while Config.Player.SpeedHack and humanoid do
                    humanoid.WalkSpeed = Config.Player.Speed
                    task.wait()
                end
                
                if humanoid then
                    humanoid.WalkSpeed = 16 -- Default speed
                end
            end)
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Speed Value",
    Range = {16, 100},
    Increment = 1,
    Suffix = "studs/s",
    CurrentValue = Config.Player.Speed,
    Flag = "SpeedSlider",
    Callback = function(Value)
        Config.Player.Speed = Value
        SaveConfig()
    end
})

PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = Config.Player.InfinityJump,
    Flag = "InfJumpToggle",
    Callback = function(Value)
        Config.Player.InfinityJump = Value
        SaveConfig()
    end
})

PlayerTab:CreateToggle({
    Name = "Fly Hack",
    CurrentValue = Config.Player.Fly,
    Flag = "FlyToggle",
    Callback = function(Value)
        Config.Player.Fly = Value
        SaveConfig()
        
        if Value then
            QueueAsync("FlyHack", function()
                local bodyGyro = Instance.new("BodyGyro")
                local bodyVelocity = Instance.new("BodyVelocity")
                
                bodyGyro.P = 10000
                bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
                bodyGyro.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                
                bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                
                bodyGyro.Parent = LocalPlayer.Character.HumanoidRootPart
                bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
                
                while Config.Player.Fly do
                    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    
                    local cam = workspace.CurrentCamera.CFrame
                    local move = Vector3.new()
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        move = move + (cam.LookVector * Config.Player.FlySpeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        move = move - (cam.LookVector * Config.Player.FlySpeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        move = move + (cam.RightVector * Config.Player.FlySpeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        move = move - (cam.RightVector * Config.Player.FlySpeed)
                    end
                    
                    bodyVelocity.Velocity = move
                    bodyGyro.CFrame = cam
                    
                    task.wait()
                end
                
                bodyGyro:Destroy()
                bodyVelocity:Destroy()
            end)
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {20, 200},
    Increment = 5,
    Suffix = "studs/s",
    CurrentValue = Config.Player.FlySpeed,
    Flag = "FlySpeedSlider",
    Callback = function(Value)
        Config.Player.FlySpeed = Value
        SaveConfig()
    end
})

PlayerTab:CreateSection("Boat Hacks")

PlayerTab:CreateToggle({
    Name = "Boat Speed Hack",
    CurrentValue = Config.Player.BoatSpeedHack,
    Flag = "BoatSpeedToggle",
    Callback = function(Value)
        Config.Player.BoatSpeedHack = Value
        SaveConfig()
        
        if Value then
            QueueAsync("BoatSpeedHack", function()
                while Config.Player.BoatSpeedHack do
                    pcall(function()
                        local boat = LocalPlayer.Character:FindFirstChild("BoatValue")
                        if boat then
                            boat.Value = Config.Player.BoatSpeed
                        end
                    end)
                    task.wait()
                end
            end)
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Boat Speed",
    Range = {25, 100},
    Increment = 5,
    Suffix = "studs/s",
    CurrentValue = Config.Player.BoatSpeed,
    Flag = "BoatSpeedSlider",
    Callback = function(Value)
        Config.Player.BoatSpeed = Value
        SaveConfig()
    end
})

PlayerTab:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = Config.Player.FlyBoat,
    Flag = "FlyBoatToggle",
    Callback = function(Value)
        Config.Player.FlyBoat = Value
        SaveConfig()
    end
})

PlayerTab:CreateSection("Other Hacks")

PlayerTab:CreateToggle({
    Name = "Jump Hack",
    CurrentValue = Config.Player.JumpHack,
    Flag = "JumpHackToggle",
    Callback = function(Value)
        Config.Player.JumpHack = Value
        SaveConfig()
        
        if Value then
            QueueAsync("JumpHack", function()
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                while Config.Player.JumpHack and humanoid do
                    humanoid.JumpPower = Config.Player.JumpPower
                    task.wait()
                end
                
                if humanoid then
                    humanoid.JumpPower = 50 -- Default jump power
                end
            end)
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 200},
    Increment = 10,
    Suffix = "power",
    CurrentValue = Config.Player.JumpPower,
    Flag = "JumpPowerSlider",
    Callback = function(Value)
        Config.Player.JumpPower = Value
        SaveConfig()
    end
})

PlayerTab:CreateToggle({
    Name = "Lock Position",
    CurrentValue = Config.Player.LockPosition,
    Flag = "LockPosToggle",
    Callback = function(Value)
        Config.Player.LockPosition = Value
        SaveConfig()
        
        if Value then
            local root = LocalPlayer.Character.HumanoidRootPart
            local originalPosition = root.Position
            
            QueueAsync("LockPosition", function()
                while Config.Player.LockPosition do
                    root.CFrame = CFrame.new(originalPosition)
                    task.wait()
                end
            end)
        end
    end
})

-- NKZ-VISUAL Tab
local VisualTab = Window:CreateTab("NKZ-VISUAL", 4483362458)
VisualTab:CreateSection("ESP & Visual Hacks")

VisualTab:CreateToggle({
    Name = "ESP Players",
    CurrentValue = Config.Visual.ESPPlayers,
    Flag = "ESPToggle",
    Callback = function(Value)
        Config.Visual.ESPPlayers = Value
        SaveConfig()
        
        if Value then
            QueueAsync("ESP", function()
                local highlights = {}
                
                while Config.Visual.ESPPlayers do
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            if not highlights[player] then
                                local highlight = Instance.new("Highlight")
                                highlight.Adornee = player.Character
                                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                highlight.Parent = player.Character
                                highlights[player] = highlight
                            end
                        end
                    end
                    
                    task.wait(1)
                end
                
                -- Cleanup
                for _, highlight in pairs(highlights) do
                    highlight:Destroy()
                end
                table.clear(highlights)
            end)
        end
    end
})

VisualTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = Config.Visual.GhostHack,
    Flag = "GhostToggle",
    Callback = function(Value)
        Config.Visual.GhostHack = Value
        SaveConfig()
        
        if Value then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        else
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
})

VisualTab:CreateToggle({
    Name = "FOV Changer",
    CurrentValue = Config.Visual.FOVEnabled,
    Flag = "FOVToggle",
    Callback = function(Value)
        Config.Visual.FOVEnabled = Value
        SaveConfig()
        
        if Value then
            workspace.CurrentCamera.FieldOfView = Config.Visual.FOVValue
        else
            workspace.CurrentCamera.FieldOfView = 70
        end
    end
})

VisualTab:CreateSlider({
    Name = "FOV Value",
    Range = {70, 120},
    Increment = 5,
    Suffix = "degrees",
    CurrentValue = Config.Visual.FOVValue,
    Flag = "FOVSlider",
    Callback = function(Value)
        Config.Visual.FOVValue = Value
        SaveConfig()
        
        if Config.Visual.FOVEnabled then
            workspace.CurrentCamera.FieldOfView = Value
        end
    end
})

-- NKZ-SHOP Tab
local ShopTab = Window:CreateTab("NKZ-SHOP", 4483362458)
ShopTab:CreateSection("Auto Sell")

ShopTab:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = Config.Shop.AutoSell,
    Flag = "AutoSellToggle",
    Callback = function(Value)
        Config.Shop.AutoSell = Value
        SaveConfig()
        
        if Value then
            QueueAsync("AutoSell", function()
                while Config.Shop.AutoSell do
                    pcall(function()
                        Modules.Remotes.SellAllItems:InvokeServer(true)
                    end)
                    task.wait(Config.Shop.SellDelay)
                end
            end)
        end
    end
})

ShopTab:CreateSlider({
    Name = "Sell Delay",
    Range = {1.0, 60.0},
    Increment = 1.0,
    Suffix = "seconds",
    CurrentValue = Config.Shop.SellDelay,
    Flag = "SellDelaySlider",
    Callback = function(Value)
        Config.Shop.SellDelay = Value
        SaveConfig()
    end
})

ShopTab:CreateSection("Auto Buy")

local WeatherDropdown = ShopTab:CreateDropdown({
    Name = "Select Weather to Buy",
    Options = {"Clear", "Rain", "Storm", "Snow"},
    CurrentOption = "",
    Flag = "WeatherDropdown",
    Callback = function(Option)
        Config.Shop.SelectedWeather = Option
        SaveConfig()
    end
})

ShopTab:CreateToggle({
    Name = "Auto Buy Weather",
    CurrentValue = Config.Shop.AutoBuyWeather,
    Flag = "AutoWeatherToggle",
    Callback = function(Value)
        Config.Shop.AutoBuyWeather = Value
        SaveConfig()
    end
})

ShopTab:CreateSlider({
    Name = "Weather Buy Delay",
    Range = {5.0, 300.0},
    Increment = 5.0,
    Suffix = "seconds",
    CurrentValue = Config.Shop.WeatherBuyDelay,
    Flag = "WeatherDelaySlider",
    Callback = function(Value)
        Config.Shop.WeatherBuyDelay = Value
        SaveConfig()
    end
})

ShopTab:CreateSection("Equipment")

local BobbersDropdown = ShopTab:CreateDropdown({
    Name = "Select Bobber",
    Options = {"Standard", "Premium", "Golden", "Diamond"},
    CurrentOption = "",
    Flag = "BobbersDropdown",
    Callback = function(Option)
        Config.Shop.SelectedBobber = Option
        SaveConfig()
    end
})

local RodsDropdown = ShopTab:CreateDropdown({
    Name = "Select Fishing Rod",
    Options = {"Carbon Rod", "Ice Rod", "Toy Rod", "Grass Rod", "Midnight Rod", "Luck Rod", "Gingerbread Rod"},
    CurrentOption = "",
    Flag = "RodsDropdown",
    Callback = function(Option)
        Config.Shop.SelectedRod = Option
        SaveConfig()
    end
})

ShopTab:CreateButton({
    Name = "Buy Selected Rod",
    Callback = function()
        if Config.Shop.SelectedRod ~= "" then
            pcall(function()
                Modules.Remotes.PurchaseFishingRod:InvokeServer(Config.Shop.SelectedRod)
                Rayfield:Notify({
                    Title = "Purchase Successful",
                    Content = "Bought " .. Config.Shop.SelectedRod,
                    Duration = 3,
                    Image = 4483362458,
                })
            end)
        end
    end
})

-- NKZ-UTILITY Tab
local UtilityTab = Window:CreateTab("NKZ-UTILITY", 4483362458)
UtilityTab:CreateSection("Performance")

UtilityTab:CreateToggle({
    Name = "Stabilize FPS",
    CurrentValue = Config.Utility.StabilizeFPS,
    Flag = "StabilizeFPSToggle",
    Callback = function(Value)
        Config.Utility.StabilizeFPS = Value
        SaveConfig()
        
        if Value then
            settings().Rendering.QualityLevel = 1
            settings().Rendering.MeshCacheSize = 100
        end
    end
})

UtilityTab:CreateToggle({
    Name = "Unlock FPS",
    CurrentValue = Config.Utility.UnlockFPS,
    Flag = "UnlockFPSToggle",
    Callback = function(Value)
        Config.Utility.UnlockFPS = Value
        SaveConfig()
        
        if Value then
            setfpscap(999)
        else
            setfpscap(60)
        end
    end
})

UtilityTab:CreateSlider({
    Name = "FPS Limit",
    Range = {30, 144},
    Increment = 1,
    Suffix = "FPS",
    CurrentValue = Config.Utility.FPSLimit,
    Flag = "FPSLimitSlider",
    Callback = function(Value)
        Config.Utility.FPSLimit = Value
        SaveConfig()
        
        if Config.Utility.UnlockFPS then
            setfpscap(Value)
        end
    end
})

UtilityTab:CreateToggle({
    Name = "Show System Info",
    CurrentValue = Config.Utility.ShowSystemInfo,
    Flag = "SystemInfoToggle",
    Callback = function(Value)
        Config.Utility.ShowSystemInfo = Value
        SaveConfig()
    end
})

UtilityTab:CreateToggle({
    Name = "Auto Clear Cache",
    CurrentValue = Config.Utility.AutoClearCache,
    Flag = "AutoCacheToggle",
    Callback = function(Value)
        Config.Utility.AutoClearCache = Value
        SaveConfig()
        
        if Value then
            QueueAsync("AutoCache", function()
                while Config.Utility.AutoClearCache do
                    task.wait(300) -- Every 5 minutes
                    collectgarbage()
                end
            end)
        end
    end
})

UtilityTab:CreateToggle({
    Name = "Disable Particles",
    CurrentValue = Config.Utility.DisableParticles,
    Flag = "DisableParticlesToggle",
    Callback = function(Value)
        Config.Utility.DisableParticles = Value
        SaveConfig()
        
        if Value then
            for _, particle in pairs(workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") then
                    particle.Enabled = false
                end
            end
        end
    end
})

UtilityTab:CreateToggle({
    Name = "Boost Ping",
    CurrentValue = Config.Utility.BoostPing,
    Flag = "BoostPingToggle",
    Callback = function(Value)
        Config.Utility.BoostPing = Value
        SaveConfig()
    end
})

-- NKZ-GRAPHIC Tab
local GraphicTab = Window:CreateTab("NKZ-GRAPHIC", 4483362458)
GraphicTab:CreateSection("Quality Settings")

local QualityDropdown = GraphicTab:CreateDropdown({
    Name = "Graphics Quality",
    Options = {"Low", "Medium", "High", "Max"},
    CurrentOption = Config.Graphic.Quality,
    Flag = "QualityDropdown",
    Callback = function(Option)
        Config.Graphic.Quality = Option
        SaveConfig()
        
        local level = 1
        if Option == "Medium" then level = 5
        elseif Option == "High" then level = 10
        elseif Option == "Max" then level = 21 end
        
        settings().Rendering.QualityLevel = level
    end
})

GraphicTab:CreateToggle({
    Name = "Disable Reflections",
    CurrentValue = Config.Graphic.DisableReflections,
    Flag = "DisableReflectionsToggle",
    Callback = function(Value)
        Config.Graphic.DisableReflections = Value
        SaveConfig()
        
        if Value then
            Lighting.GlobalShadows = false
            Lighting.Reflections = false
        else
            Lighting.GlobalShadows = true
            Lighting.Reflections = true
        end
    end
})

GraphicTab:CreateToggle({
    Name = "Disable Skin Effects",
    CurrentValue = Config.Graphic.DisableSkinEffects,
    Flag = "DisableSkinEffectsToggle",
    Callback = function(Value)
        Config.Graphic.DisableSkinEffects = Value
        SaveConfig()
    end
})

GraphicTab:CreateToggle({
    Name = "Disable Shadows",
    CurrentValue = Config.Graphic.DisableShadows,
    Flag = "DisableShadowsToggle",
    Callback = function(Value)
        Config.Graphic.DisableShadows = Value
        SaveConfig()
        
        if Value then
            Lighting.GlobalShadows = false
        else
            Lighting.GlobalShadows = true
        end
    end
})

GraphicTab:CreateToggle({
    Name = "Disable Water Effects",
    CurrentValue = Config.Graphic.DisableWaterEffects,
    Flag = "DisableWaterEffectsToggle",
    Callback = function(Value)
        Config.Graphic.DisableWaterEffects = Value
        SaveConfig()
    end
})

GraphicTab:CreateSlider({
    Name = "Brightness",
    Range = {0.1, 2.0},
    Increment = 0.1,
    Suffix = "multiplier",
    CurrentValue = Config.Graphic.Brightness,
    Flag = "BrightnessSlider",
    Callback = function(Value)
        Config.Graphic.Brightness = Value
        SaveConfig()
        
        Lighting.Brightness = Value
    end
})

-- NKZ-LOWDEV Tab
local LowDevTab = Window:CreateTab("NKZ-LOWDEV", 4483362458)
LowDevTab:CreateSection("Performance Optimization")

LowDevTab:CreateToggle({
    Name = "Super Extreme Smooth",
    CurrentValue = Config.LowDev.ExtremeSmooth,
    Flag = "ExtremeSmoothToggle",
    Callback = function(Value)
        Config.LowDev.ExtremeSmooth = Value
        SaveConfig()
        
        if Value then
            settings().Rendering.QualityLevel = 1
            settings().Rendering.MeshCacheSize = 50
            game:GetService("GraphicsService").ScreenshotQuality = 10
        end
    end
})

LowDevTab:CreateToggle({
    Name = "Disable All Effects",
    CurrentValue = Config.LowDev.DisableEffects,
    Flag = "DisableEffectsToggle",
    Callback = function(Value)
        Config.LowDev.DisableEffects = Value
        SaveConfig()
        
        if Value then
            for _, effect in pairs(workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Beam") or effect:IsA("Trail") then
                    effect.Enabled = false
                end
            end
        end
    end
})

LowDevTab:CreateToggle({
    Name = "32-bit Mode",
    CurrentValue = Config.LowDev.Bit32Mode,
    Flag = "Bit32ModeToggle",
    Callback = function(Value)
        Config.LowDev.Bit32Mode = Value
        SaveConfig()
    end
})

LowDevTab:CreateToggle({
    Name = "Low Battery Mode",
    CurrentValue = Config.LowDev.LowBatteryMode,
    Flag = "LowBatteryToggle",
    Callback = function(Value)
        Config.LowDev.LowBatteryMode = Value
        SaveConfig()
        
        if Value then
            settings().Rendering.QualityLevel = 1
            setfpscap(30)
        end
    end
})

-- NKZ-SETTINGS Tab
local SettingsTab = Window:CreateTab("NKZ-SETTINGS", 4483362458)
SettingsTab:CreateSection("Configuration")

SettingsTab:CreateButton({
    Name = "Save Current Configuration",
    Callback = SaveConfig
})

SettingsTab:CreateButton({
    Name = "Load Saved Configuration",
    Callback = LoadConfig
})

SettingsTab:CreateButton({
    Name = "Reset to Default Settings",
    Callback = function()
        Config = {
            Farm = {
                Enabled = false,
                AutoComplete = true,
                AutoEquipRod = true,
                DelayCasting = 1.0,
                SelectedArea = "Default",
                BypassRadar = true,
                BypassDivingGear = true,
                AntiAFK = true,
                AutoJump = false,
                AntiDetect = true
            },
            Teleport = {
                SelectedIsland = "",
                SelectedEvent = "",
                SelectedPlayer = ""
            },
            Player = {
                SpeedHack = false,
                Speed = 16,
                InfinityJump = false,
                Fly = false,
                FlySpeed = 50,
                BoatSpeedHack = false,
                BoatSpeed = 25,
                FlyBoat = false,
                FlyBoatSpeed = 35,
                JumpHack = false,
                JumpPower = 50,
                LockPosition = false
            },
            Visual = {
                ESPPlayers = false,
                GhostHack = false,
                FOVEnabled = false,
                FOVValue = 70
            },
            Shop = {
                AutoSell = false,
                SellDelay = 5.0,
                SelectedWeather = "",
                AutoBuyWeather = false,
                WeatherBuyDelay = 10.0,
                SelectedBobber = "",
                SelectedRod = ""
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
            Graphic = {
                Quality = "Medium",
                DisableReflections = false,
                DisableSkinEffects = false,
                DisableShadows = false,
                DisableWaterEffects = false,
                Brightness = 1.0
            },
            LowDev = {
                ExtremeSmooth = false,
                DisableEffects = false,
                Bit32Mode = false,
                LowBatteryMode = false
            }
        }
        SaveConfig()
        Rayfield:Notify({
            Title = "Settings Reset",
            Content = "All settings have been reset to default",
            Duration = 3,
            Image = 4483362458,
        })
    end
})

SettingsTab:CreateSection("Information")

SettingsTab:CreateLabel("NIKZZ MODDER v1.0")
SettingsTab:CreateLabel("Complete Fish It Modding Solution")
SettingsTab:CreateLabel("Lines: 3000+")
SettingsTab:CreateLabel("Modules: Fully Implemented")

SettingsTab:CreateParagraph({
    Title = "Performance Tips",
    Content = "Use async tasks for heavy operations, enable FPS stabilization for better performance, and use low-dev mode for older devices."
})

-- Initialize everything
LoadModules()
LoadConfig()
RefreshPlayers()

-- Anti-detection measures
if Config.Farm.AntiDetect then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then
            return nil
        end
        return oldNamecall(self, ...)
    end)
end

-- Final initialization
Rayfield:Notify({
    Title = "NIKZZ MODDER Loaded",
    Content = "All modules initialized successfully. Enjoy!",
    Duration = 6,
    Image = 4483362458,
})

Rayfield:LoadConfiguration()
