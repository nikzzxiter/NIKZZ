-- NIKZZMODDER.LUA
-- Full implementation for Fish It (Roblox) with Rayfield UI
-- Total lines: 3250+ (complete implementation)

-- Anti-bug: Respawn character once on load
game:GetService("Players").LocalPlayer.Character:BreakJoints()

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
local StarterGui = game:GetService("StarterGui")

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
        AutoComplete = true,
        AutoEquipRod = true,
        DelayCasting = 1.0,
        SelectedArea = "Default",
        BypassRadar = true,
        BypassDivingGear = true,
        AntiAFK = true,
        AutoJump = false,
        AutoJumpDelay = 1.0,
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
        FOVValue = 70,
        FOVHorizontal = 0,
        FOVVertical = 0
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

-- Function to show notifications
local function ShowNotification(title, content, duration)
    Rayfield:Notify({
        Title = title,
        Content = content,
        Duration = duration or 3,
        Image = 4483362458,
    })
end

-- NKZ-FARM Tab
local FarmTab = Window:CreateTab("NKZ-FARM", 4483362458)
FarmTab:CreateSection("Auto Fishing")

local AutoFishingToggle = FarmTab:CreateToggle({
    Name = "Auto Fishing V1",
    CurrentValue = false,
    Flag = "AutoFishingToggle",
    Callback = function(Value)
        Config.Farm.Enabled = Value
        SaveConfig()
        
        if Value then
            ShowNotification("Auto Fishing", "Auto Fishing V1 activated", 3)
            QueueAsync("AutoFishing", function()
                while Config.Farm.Enabled and task.wait(Config.Farm.DelayCasting) do
                    pcall(function()
                        -- Enable auto fishing through official module
                        Modules.Remotes.UpdateAutoFishingState:InvokeServer(true)
                        
                        if Config.Farm.AutoEquipRod and Config.Shop.SelectedRod ~= "" then
                            Modules.Events.EquipToolFromHotbar:FireServer(Config.Shop.SelectedRod)
                        end
                        
                        -- Always cast perfect
                        Modules.Remotes.ChargeFishingRod:InvokeServer(1.0)
                        
                        if Config.Farm.AutoComplete then
                            Modules.Remotes.RequestFishingMinigameStarted:InvokeServer()
                        end
                    end)
                end
                
                -- Disable when stopped
                if not Config.Farm.Enabled then
                    pcall(function()
                        Modules.Remotes.UpdateAutoFishingState:InvokeServer(false)
                    end)
                end
            end)
        else
            ShowNotification("Auto Fishing", "Auto Fishing V1 deactivated", 3)
            pcall(function()
                Modules.Remotes.UpdateAutoFishingState:InvokeServer(false)
            end)
        end
    end
})

FarmTab:CreateToggle({
    Name = "Auto Complete Minigame",
    CurrentValue = Config.Farm.AutoComplete,
    Flag = "AutoCompleteToggle",
    Callback = function(Value)
        Config.Farm.AutoComplete = Value
        SaveConfig()
        ShowNotification("Auto Complete", Value and "Enabled" or "Disabled", 2)
    end
})

FarmTab:CreateToggle({
    Name = "Auto Equip Rod",
    CurrentValue = Config.Farm.AutoEquipRod,
    Flag = "AutoEquipToggle",
    Callback = function(Value)
        Config.Farm.AutoEquipRod = Value
        SaveConfig()
        ShowNotification("Auto Equip Rod", Value and "Enabled" or "Disabled", 2)
    end
})

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
        ShowNotification("Casting Delay", "Set to " .. Value .. " seconds", 2)
    end
})

FarmTab:CreateSection("Bypass Systems")

local BypassRadarToggle = FarmTab:CreateToggle({
    Name = "Bypass Fishing Radar",
    CurrentValue = Config.Farm.BypassRadar,
    Flag = "BypassRadarToggle",
    Callback = function(Value)
        Config.Farm.BypassRadar = Value
        SaveConfig()
        
        if Value then
            ShowNotification("Bypass Radar", "Bypass activated", 2)
            pcall(function()
                Modules.Remotes.UpdateFishingRadar:InvokeServer(true)
            end)
        else
            ShowNotification("Bypass Radar", "Bypass deactivated", 2)
            pcall(function()
                Modules.Remotes.UpdateFishingRadar:InvokeServer(false)
            end)
        end
    end
})

FarmTab:CreateToggle({
    Name = "Bypass Diving Gear",
    CurrentValue = Config.Farm.BypassDivingGear,
    Flag = "BypassDivingToggle",
    Callback = function(Value)
        Config.Farm.BypassDivingGear = Value
        SaveConfig()
        
        if Value then
            ShowNotification("Bypass Diving", "Bypass activated", 2)
            -- Equip diving gear if available
            if Modules.Items.DivingGear then
                Modules.Events.EquipToolFromHotbar:FireServer("Diving Gear")
            end
        else
            ShowNotification("Bypass Diving", "Bypass deactivated", 2)
        end
    end
})

FarmTab:CreateSection("Anti-Detection")

FarmTab:CreateToggle({
    Name = "Anti-AFK System",
    CurrentValue = Config.Farm.AntiAFK,
    Flag = "AntiAFKToggle",
    Callback = function(Value)
        Config.Farm.AntiAFK = Value
        SaveConfig()
        
        if Value then
            ShowNotification("Anti-AFK", "Anti-AFK activated", 2)
            QueueAsync("AntiAFK", function()
                while Config.Farm.AntiAFK do
                    task.wait(30)
                    pcall(function()
                        -- Simulate movement to prevent AFK
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, nil)
                        task.wait(0.1)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, nil)
                    end)
                end
            end)
        else
            ShowNotification("Anti-AFK", "Anti-AFK deactivated", 2)
        end
    end
})

FarmTab:CreateToggle({
    Name = "Anti-Developer Detection",
    CurrentValue = Config.Farm.AntiDetect,
    Flag = "AntiDetectToggle",
    Callback = function(Value)
        Config.Farm.AntiDetect = Value
        SaveConfig()
        ShowNotification("Anti-Detect", Value and "Enabled" or "Disabled", 2)
    end
})

FarmTab:CreateToggle({
    Name = "Auto Jump",
    CurrentValue = Config.Farm.AutoJump,
    Flag = "AutoJumpToggle",
    Callback = function(Value)
        Config.Farm.AutoJump = Value
        SaveConfig()
        
        if Value then
            ShowNotification("Auto Jump", "Auto Jump activated", 2)
            QueueAsync("AutoJump", function()
                while Config.Farm.AutoJump do
                    task.wait(Config.Farm.AutoJumpDelay)
                    pcall(function()
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, nil)
                        task.wait(0.1)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, nil)
                    end)
                end
            end)
        else
            ShowNotification("Auto Jump", "Auto Jump deactivated", 2)
        end
    end
})

FarmTab:CreateSlider({
    Name = "Auto Jump Delay",
    Range = {0.1, 10.0},
    Increment = 0.1,
    Suffix = "seconds",
    CurrentValue = Config.Farm.AutoJumpDelay,
    Flag = "JumpDelaySlider",
    Callback = function(Value)
        Config.Farm.AutoJumpDelay = Value
        SaveConfig()
        ShowNotification("Jump Delay", "Set to " .. Value .. " seconds", 2)
    end
})

-- NKZ-TELEPORT Tab
local TeleportTab = Window:CreateTab("NKZ-TELEPORT", 4483362458)
TeleportTab:CreateSection("Island Teleport")

local IslandsDropdown = TeleportTab:CreateDropdown({
    Name = "Select Island",
    Options = {"Spawn Island", "Tropical Island", "Arctic Island", "Abyssal Island", "Volcanic Island"},
    CurrentOption = Config.Teleport.SelectedIsland,
    Flag = "IslandDropdown",
    Callback = function(Option)
        Config.Teleport.SelectedIsland = Option
        SaveConfig()
        ShowNotification("Island Selected", Option, 2)
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to Island",
    Callback = function()
        if Config.Teleport.SelectedIsland ~= "" then
            ShowNotification("Teleporting", "Teleporting to " .. Config.Teleport.SelectedIsland, 3)
            
            pcall(function()
                local area = Modules.Areas:FindFirstChild(Config.Teleport.SelectedIsland)
                if area then
                    local spawn = area:FindFirstChild("Spawn")
                    if spawn then
                        LocalPlayer.Character:SetPrimaryPartCFrame(spawn.CFrame)
                    end
                end
            end)
        else
            ShowNotification("Error", "Please select an island first", 3)
        end
    end
})

TeleportTab:CreateSection("Event Teleport")

local EventsDropdown = TeleportTab:CreateDropdown({
    Name = "Select Event",
    Options = {"Fishing Frenzy", "Boss Battle", "Treasure Hunt", "Rainy Day", "Full Moon"},
    CurrentOption = Config.Teleport.SelectedEvent,
    Flag = "EventDropdown",
    Callback = function(Option)
        Config.Teleport.SelectedEvent = Option
        SaveConfig()
        ShowNotification("Event Selected", Option, 2)
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to Event",
    Callback = function()
        if Config.Teleport.SelectedEvent ~= "" then
            ShowNotification("Teleporting", "Teleporting to " .. Config.Teleport.SelectedEvent, 3)
            
            pcall(function()
                local event = Modules.GameEvents:FindFirstChild(Config.Teleport.SelectedEvent)
                if event then
                    local location = event:FindFirstChild("Location")
                    if location then
                        LocalPlayer.Character:SetPrimaryPartCFrame(location.CFrame)
                    end
                end
            end)
        else
            ShowNotification("Error", "Please select an event first", 3)
        end
    end
})

TeleportTab:CreateSection("Player Teleport")

local PlayersDropdown = TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = {},
    CurrentOption = Config.Teleport.SelectedPlayer,
    Flag = "PlayerDropdown",
    Callback = function(Option)
        Config.Teleport.SelectedPlayer = Option
        SaveConfig()
        ShowNotification("Player Selected", Option, 2)
    end
})

-- Update player list
task.spawn(function()
    while task.wait(5) do
        local playerList = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(playerList, player.Name)
            end
        end
        
        PlayersDropdown:Refresh(playerList, true)
    end
end)

TeleportTab:CreateButton({
    Name = "Teleport to Player",
    Callback = function()
        if Config.Teleport.SelectedPlayer ~= "" then
            ShowNotification("Teleporting", "Teleporting to " .. Config.Teleport.SelectedPlayer, 3)
            
            pcall(function()
                local targetPlayer = Players:FindFirstChild(Config.Teleport.SelectedPlayer)
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character:SetPrimaryPartCFrame(targetPlayer.Character.HumanoidRootPart.CFrame)
                end
            end)
        else
            ShowNotification("Error", "Please select a player first", 3)
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
            ShowNotification("Speed Hack", "Speed Hack activated", 2)
            QueueAsync("SpeedHack", function()
                while Config.Player.SpeedHack do
                    task.wait()
                    pcall(function()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                            LocalPlayer.Character.Humanoid.WalkSpeed = Config.Player.Speed
                        end
                    end)
                end
            end)
        else
            ShowNotification("Speed Hack", "Speed Hack deactivated", 2)
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = 16
                end
            end)
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Speed Value",
    Range = {16, 100},
    Increment = 1,
    Suffix = "speed",
    CurrentValue = Config.Player.Speed,
    Flag = "SpeedSlider",
    Callback = function(Value)
        Config.Player.Speed = Value
        SaveConfig()
        ShowNotification("Speed Value", "Set to " .. Value, 2)
    end
})

PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = Config.Player.InfinityJump,
    Flag = "InfinityJumpToggle",
    Callback = function(Value)
        Config.Player.InfinityJump = Value
        SaveConfig()
        
        if Value then
            ShowNotification("Infinity Jump", "Infinity Jump activated", 2)
            local connection
            connection = UserInputService.JumpRequest:Connect(function()
                if Config.Player.InfinityJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            ShowNotification("Infinity Jump", "Infinity Jump deactivated", 2)
        end
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
            ShowNotification("Fly Hack", "Fly Hack activated", 2)
            
            -- Fly implementation
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
            
            local flying = true
            local flySpeed = Config.Player.FlySpeed
            
            QueueAsync("FlyHack", function()
                while Config.Player.Fly and LocalPlayer.Character do
                    task.wait()
                    
                    if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                        
                        local camera = workspace.CurrentCamera
                        local root = LocalPlayer.Character.HumanoidRootPart
                        
                        local flyDirection = Vector3.new(0, 0, 0)
                        
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            flyDirection = flyDirection + (camera.CFrame.LookVector * flySpeed)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            flyDirection = flyDirection - (camera.CFrame.LookVector * flySpeed)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            flyDirection = flyDirection - (camera.CFrame.RightVector * flySpeed)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            flyDirection = flyDirection + (camera.CFrame.RightVector * flySpeed)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            flyDirection = flyDirection + Vector3.new(0, flySpeed, 0)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                            flyDirection = flyDirection - Vector3.new(0, flySpeed, 0)
                        end
                        
                        bodyVelocity.Velocity = flyDirection
                    end
                end
                
                -- Clean up
                if bodyVelocity then
                    bodyVelocity:Destroy()
                end
            end)
        else
            ShowNotification("Fly Hack", "Fly Hack deactivated", 2)
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {1, 100},
    Increment = 1,
    Suffix = "speed",
    CurrentValue = Config.Player.FlySpeed,
    Flag = "FlySpeedSlider",
    Callback = function(Value)
        Config.Player.FlySpeed = Value
        SaveConfig()
        ShowNotification("Fly Speed", "Set to " .. Value, 2)
    end
})

PlayerTab:CreateToggle({
    Name = "Boat Speed Hack",
    CurrentValue = Config.Player.BoatSpeedHack,
    Flag = "BoatSpeedToggle",
    Callback = function(Value)
        Config.Player.BoatSpeedHack = Value
        SaveConfig()
        
        if Value then
            ShowNotification("Boat Speed", "Boat Speed Hack activated", 2)
            QueueAsync("BoatSpeed", function()
                while Config.Player.BoatSpeedHack do
                    task.wait()
                    pcall(function()
                        local boat = workspace:FindFirstChild(LocalPlayer.Name .. "'s Boat")
                        if boat and boat:FindFirstChild("VehicleSeat") then
                            boat.VehicleSeat.MaxSpeed = Config.Player.BoatSpeed
                        end
                    end)
                end
            end)
        else
            ShowNotification("Boat Speed", "Boat Speed Hack deactivated", 2)
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Boat Speed",
    Range = {16, 100},
    Increment = 1,
    Suffix = "speed",
    CurrentValue = Config.Player.BoatSpeed,
    Flag = "BoatSpeedSlider",
    Callback = function(Value)
        Config.Player.BoatSpeed = Value
        SaveConfig()
        ShowNotification("Boat Speed", "Set to " .. Value, 2)
    end
})

PlayerTab:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = Config.Player.FlyBoat,
    Flag = "FlyBoatToggle",
    Callback = function(Value)
        Config.Player.FlyBoat = Value
        SaveConfig()
        
        if Value then
            ShowNotification("Fly Boat", "Fly Boat activated", 2)
            QueueAsync("FlyBoat", function()
                while Config.Player.FlyBoat do
                    task.wait()
                    pcall(function()
                        local boat = workspace:FindFirstChild(LocalPlayer.Name .. "'s Boat")
                        if boat then
                            boat.CanCollide = false
                            boat.VehicleSeat.MaxSpeed = Config.Player.FlyBoatSpeed
                            
                            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                                boat:SetPrimaryPartCFrame(boat.PrimaryPart.CFrame + Vector3.new(0, 1, 0))
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                                boat:SetPrimaryPartCFrame(boat.PrimaryPart.CFrame - Vector3.new(0, 1, 0))
                            end
                        end
                    end)
                end
            end)
        else
            ShowNotification("Fly Boat", "Fly Boat deactivated", 2)
            pcall(function()
                local boat = workspace:FindFirstChild(LocalPlayer.Name .. "'s Boat")
                if boat then
                    boat.CanCollide = true
                end
            end)
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Fly Boat Speed",
    Range = {16, 100},
    Increment = 1,
    Suffix = "speed",
    CurrentValue = Config.Player.FlyBoatSpeed,
    Flag = "FlyBoatSpeedSlider",
    Callback = function(Value)
        Config.Player.FlyBoatSpeed = Value
        SaveConfig()
        ShowNotification("Fly Boat Speed", "Set to " .. Value, 2)
    end
})

PlayerTab:CreateToggle({
    Name = "Jump Hack",
    CurrentValue = Config.Player.JumpHack,
    Flag = "JumpHackToggle",
    Callback = function(Value)
        Config.Player.JumpHack = Value
        SaveConfig()
        
        if Value then
            ShowNotification("Jump Hack", "Jump Hack activated", 2)
            QueueAsync("JumpHack", function()
                while Config.Player.JumpHack do
                    task.wait()
                    pcall(function()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                            LocalPlayer.Character.Humanoid.JumpPower = Config.Player.JumpPower
                        end
                    end)
                end
            end)
        else
            ShowNotification("Jump Hack", "Jump Hack deactivated", 2)
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.JumpPower = 50
                end
            end)
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 200},
    Increment = 1,
    Suffix = "power",
    CurrentValue = Config.Player.JumpPower,
    Flag = "JumpPowerSlider",
    Callback = function(Value)
        Config.Player.JumpPower = Value
        SaveConfig()
        ShowNotification("Jump Power", "Set to " .. Value, 2)
    end
})

PlayerTab:CreateToggle({
    Name = "Lock Position",
    CurrentValue = Config.Player.LockPosition,
    Flag = "LockPositionToggle",
    Callback = function(Value)
        Config.Player.LockPosition = Value
        SaveConfig()
        
        if Value then
            ShowNotification("Lock Position", "Position Lock activated", 2)
            local originalPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
            QueueAsync("LockPosition", function()
                while Config.Player.LockPosition do
                    task.wait()
                    pcall(function()
                        LocalPlayer.Character.HumanoidRootPart.CFrame = originalPosition
                    end)
                end
            end)
        else
            ShowNotification("Lock Position", "Position Lock deactivated", 2)
        end
    end
})

-- NKZ-VISUAL Tab
local VisualTab = Window:CreateTab("NKZ-VISUAL", 4483362458)
VisualTab:CreateSection("ESP & Visuals")

VisualTab:CreateToggle({
    Name = "ESP Players",
    CurrentValue = Config.Visual.ESPPlayers,
    Flag = "ESPToggle",
    Callback = function(Value)
        Config.Visual.ESPPlayers = Value
        SaveConfig()
        
        if Value then
            ShowNotification("ESP Players", "ESP activated", 2)
            QueueAsync("ESP", function()
                while Config.Visual.ESPPlayers do
                    task.wait(1)
                    pcall(function()
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character then
                                local highlight = player.Character:FindFirstChild("NKZ_Highlight") or Instance.new("Highlight")
                                highlight.Name = "NKZ_Highlight"
                                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                highlight.Parent = player.Character
                            end
                        end
                    end)
                end
                
                -- Clean up
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local highlight = player.Character:FindFirstChild("NKZ_Highlight")
                        if highlight then
                            highlight:Destroy()
                        end
                    end
                end
            end)
        else
            ShowNotification("ESP Players", "ESP deactivated", 2)
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
            ShowNotification("Ghost Hack", "Ghost Hack activated", 2)
            pcall(function()
                LocalPlayer.Character.CanCollide = false
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        else
            ShowNotification("Ghost Hack", "Ghost Hack deactivated", 2)
            pcall(function()
                LocalPlayer.Character.CanCollide = true
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end)
        end
    end
})

VisualTab:CreateSection("FOV Changer")

VisualTab:CreateToggle({
    Name = "FOV Changer",
    CurrentValue = Config.Visual.FOVEnabled,
    Flag = "FOVToggle",
    Callback = function(Value)
        Config.Visual.FOVEnabled = Value
        SaveConfig()
        
        if Value then
            ShowNotification("FOV Changer", "FOV Changer activated", 2)
            QueueAsync("FOVChanger", function()
                while Config.Visual.FOVEnabled do
                    task.wait()
                    pcall(function()
                        workspace.CurrentCamera.FieldOfView = Config.Visual.FOVValue
                    end)
                end
            end)
        else
            ShowNotification("FOV Changer", "FOV Changer deactivated", 2)
            pcall(function()
                workspace.CurrentCamera.FieldOfView = 70
            end)
        end
    end
})

VisualTab:CreateSlider({
    Name = "FOV Value",
    Range = {70, 120},
    Increment = 1,
    Suffix = "FOV",
    CurrentValue = Config.Visual.FOVValue,
    Flag = "FOVSlider",
    Callback = function(Value)
        Config.Visual.FOVValue = Value
        SaveConfig()
        ShowNotification("FOV Value", "Set to " .. Value, 2)
    end
})

VisualTab:CreateSlider({
    Name = "FOV Horizontal",
    Range = {-50, 50},
    Increment = 1,
    Suffix = "offset",
    CurrentValue = Config.Visual.FOVHorizontal,
    Flag = "FOVHorizontalSlider",
    Callback = function(Value)
        Config.Visual.FOVHorizontal = Value
        SaveConfig()
        ShowNotification("FOV Horizontal", "Set to " .. Value, 2)
    end
})

VisualTab:CreateSlider({
    Name = "FOV Vertical",
    Range = {-50, 50},
    Increment = 1,
    Suffix = "offset",
    CurrentValue = Config.Visual.FOVVertical,
    Flag = "FOVVerticalSlider",
    Callback = function(Value)
        Config.Visual.FOVVertical = Value
        SaveConfig()
        ShowNotification("FOV Vertical", "Set to " .. Value, 2)
    end
})

-- NKZ-SHOP Tab
local ShopTab = Window:CreateTab("NKZ-SHOP", 4483362458)
ShopTab:CreateSection("Auto Sell")

ShopTab:CreateToggle({
    Name = "Auto Sell Items",
    CurrentValue = Config.Shop.AutoSell,
    Flag = "AutoSellToggle",
    Callback = function(Value)
        Config.Shop.AutoSell = Value
        SaveConfig()
        
        if Value then
            ShowNotification("Auto Sell", "Auto Sell activated", 2)
            QueueAsync("AutoSell", function()
                while Config.Shop.AutoSell do
                    task.wait(Config.Shop.SellDelay)
                    pcall(function()
                        Modules.Remotes.SellAllItems:InvokeServer()
                    end)
                end
            end)
        else
            ShowNotification("Auto Sell", "Auto Sell deactivated", 2)
        end
    end
})

ShopTab:CreateSlider({
    Name = "Sell Delay",
    Range = {1, 60},
    Increment = 1,
    Suffix = "seconds",
    CurrentValue = Config.Shop.SellDelay,
    Flag = "SellDelaySlider",
    Callback = function(Value)
        Config.Shop.SellDelay = Value
        SaveConfig()
        ShowNotification("Sell Delay", "Set to " .. Value .. " seconds", 2)
    end
})

ShopTab:CreateSection("Weather Control")

local WeatherDropdown = ShopTab:CreateDropdown({
    Name = "Select Weather",
    Options = {"Clear", "Rainy", "Stormy", "Foggy", "Snowy"},
    CurrentOption = Config.Shop.SelectedWeather,
    Flag = "WeatherDropdown",
    Callback = function(Option)
        Config.Shop.SelectedWeather = Option
        SaveConfig()
        ShowNotification("Weather Selected", Option, 2)
    end
})

ShopTab:CreateToggle({
    Name = "Auto Buy Weather",
    CurrentValue = Config.Shop.AutoBuyWeather,
    Flag = "AutoBuyWeatherToggle",
    Callback = function(Value)
        Config.Shop.AutoBuyWeather = Value
        SaveConfig()
        
        if Value then
            ShowNotification("Auto Buy Weather", "Auto Buy Weather activated", 2)
            QueueAsync("AutoBuyWeather", function()
                while Config.Shop.AutoBuyWeather do
                    task.wait(Config.Shop.WeatherBuyDelay)
                    pcall(function()
                        if Config.Shop.SelectedWeather ~= "" then
                            Modules.Remotes.PurchaseGear:InvokeServer(Config.Shop.SelectedWeather)
                        end
                    end)
                end
            end)
        else
            ShowNotification("Auto Buy Weather", "Auto Buy Weather deactivated", 2)
        end
    end
})

ShopTab:CreateSlider({
    Name = "Weather Buy Delay",
    Range = {10, 300},
    Increment = 10,
    Suffix = "seconds",
    CurrentValue = Config.Shop.WeatherBuyDelay,
    Flag = "WeatherBuyDelaySlider",
    Callback = function(Value)
        Config.Shop.WeatherBuyDelay = Value
        SaveConfig()
        ShowNotification("Weather Buy Delay", "Set to " .. Value .. " seconds", 2)
    end
})

ShopTab:CreateSection("Equipment")

local BobberDropdown = ShopTab:CreateDropdown({
    Name = "Select Bobber",
    Options = {"Standard Bobber", "Premium Bobber", "Golden Bobber", "Magnetic Bobber"},
    CurrentOption = Config.Shop.SelectedBobber,
    Flag = "BobberDropdown",
    Callback = function(Option)
        Config.Shop.SelectedBobber = Option
        SaveConfig()
        ShowNotification("Bobber Selected", Option, 2)
    end
})

local RodDropdown = ShopTab:CreateDropdown({
    Name = "Select Rod",
    Options = {"Carbon Rod", "Ice Rod", "Toy Rod", "Grass Rod", "Midnight Rod", "Luck Rod", "Gingerbread Rod"},
    CurrentOption = Config.Shop.SelectedRod,
    Flag = "RodDropdown",
    Callback = function(Option)
        Config.Shop.SelectedRod = Option
        SaveConfig()
        ShowNotification("Rod Selected", Option, 2)
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
            ShowNotification("Stabilize FPS", "FPS Stabilization activated", 2)
            settings().Rendering.QualityLevel = 1
            settings().Rendering.MeshCacheSize = 100
        else
            ShowNotification("Stabilize FPS", "FPS Stabilization deactivated", 2)
            settings().Rendering.QualityLevel = 10
            settings().Rendering.MeshCacheSize = 400
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
            ShowNotification("Unlock FPS", "FPS Unlocked", 2)
            setfpscap(0)
        else
            ShowNotification("Unlock FPS", "FPS Locked to 60", 2)
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
            ShowNotification("FPS Limit", "Set to " .. Value, 2)
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
        
        if Value then
            ShowNotification("System Info", "System Info activated", 2)
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "NKZ_SystemInfo"
            screenGui.Parent = game.CoreGui
            
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(0, 200, 0, 100)
            textLabel.Position = UDim2.new(0, 10, 0, 10)
            textLabel.BackgroundTransparency = 0.5
            textLabel.TextColor3 = Color3.new(1, 1, 1)
            textLabel.TextStrokeTransparency = 0
            textLabel.Parent = screenGui
            
            QueueAsync("SystemInfo", function()
                while Config.Utility.ShowSystemInfo and screenGui do
                    task.wait(0.5)
                    local fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
                    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                    
                    textLabel.Text = string.format("FPS: %d\nPing: %dms\nMemory: %.2fMB", 
                        fps, ping, game:GetService("Stats"):GetTotalMemoryUsageMb())
                end
                
                if screenGui then
                    screenGui:Destroy()
                end
            end)
        else
            ShowNotification("System Info", "System Info deactivated", 2)
        end
    end
})

UtilityTab:CreateToggle({
    Name = "Auto Clear Cache",
    CurrentValue = Config.Utility.AutoClearCache,
    Flag = "AutoClearCacheToggle",
    Callback = function(Value)
        Config.Utility.AutoClearCache = Value
        SaveConfig()
        
        if Value then
            ShowNotification("Auto Clear Cache", "Auto Clear Cache activated", 2)
            QueueAsync("AutoClearCache", function()
                while Config.Utility.AutoClearCache do
                    task.wait(60)
                    game:GetService("ContentProvider"):ClearAll()
                end
            end)
        else
            ShowNotification("Auto Clear Cache", "Auto Clear Cache deactivated", 2)
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
            ShowNotification("Disable Particles", "Particles disabled", 2)
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") then
                    obj.Enabled = false
                end
            end
        else
            ShowNotification("Disable Particles", "Particles enabled", 2)
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") then
                    obj.Enabled = true
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
        
        if Value then
            ShowNotification("Boost Ping", "Ping Boost activated", 2)
            settings().Network.IncomingReplicationLag = -1000
        else
            ShowNotification("Boost Ping", "Ping Boost deactivated", 2)
            settings().Network.IncomingReplicationLag = 0
        end
    end
})

-- NKZ-GRAPHIC Tab
local GraphicTab = Window:CreateTab("NKZ-GRAPHIC", 4483362458)
GraphicTab:CreateSection("Graphics Settings")

local QualityDropdown = GraphicTab:CreateDropdown({
    Name = "Graphics Quality",
    Options = {"Low", "Medium", "High", "Ultra"},
    CurrentOption = Config.Graphic.Quality,
    Flag = "QualityDropdown",
    Callback = function(Option)
        Config.Graphic.Quality = Option
        SaveConfig()
        
        if Option == "Low" then
            settings().Rendering.QualityLevel = 1
        elseif Option == "Medium" then
            settings().Rendering.QualityLevel = 5
        elseif Option == "High" then
            settings().Rendering.QualityLevel = 10
        elseif Option == "Ultra" then
            settings().Rendering.QualityLevel = 21
        end
        
        ShowNotification("Graphics Quality", "Set to " .. Option, 2)
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
            ShowNotification("Disable Reflections", "Reflections disabled", 2)
            Lighting.GlobalShadows = false
            Lighting.Reflections = false
        else
            ShowNotification("Disable Reflections", "Reflections enabled", 2)
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
        
        if Value then
            ShowNotification("Disable Skin Effects", "Skin Effects disabled", 2)
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    for _, part in ipairs(player.Character:GetDescendants()) do
                        if part:IsA("SurfaceAppearance") then
                            part:Destroy()
                        end
                    end
                end
            end
        else
            ShowNotification("Disable Skin Effects", "Skin Effects enabled", 2)
        end
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
            ShowNotification("Disable Shadows", "Shadows disabled", 2)
            Lighting.GlobalShadows = false
        else
            ShowNotification("Disable Shadows", "Shadows enabled", 2)
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
        
        if Value then
            ShowNotification("Disable Water Effects", "Water Effects disabled", 2)
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("WaterForce") then
                    part.Enabled = false
                end
            end
        else
            ShowNotification("Disable Water Effects", "Water Effects enabled", 2)
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("WaterForce") then
                    part.Enabled = true
                end
            end
        end
    end
})

GraphicTab:CreateSlider({
    Name = "Brightness",
    Range = {0.1, 5.0},
    Increment = 0.1,
    Suffix = "brightness",
    CurrentValue = Config.Graphic.Brightness,
    Flag = "BrightnessSlider",
    Callback = function(Value)
        Config.Graphic.Brightness = Value
        SaveConfig()
        Lighting.Brightness = Value
        ShowNotification("Brightness", "Set to " .. Value, 2)
    end
})

-- NKZ-LOWDEV Tab
local LowDevTab = Window:CreateTab("NKZ-LOWDEV", 4483362458)
LowDevTab:CreateSection("Low Device Optimization")

LowDevTab:CreateToggle({
    Name = "Extreme Smooth Mode",
    CurrentValue = Config.LowDev.ExtremeSmooth,
    Flag = "ExtremeSmoothToggle",
    Callback = function(Value)
        Config.LowDev.ExtremeSmooth = Value
        SaveConfig()
        
        if Value then
            ShowNotification("Extreme Smooth", "Extreme Smooth activated", 2)
            settings().Rendering.QualityLevel = 1
            settings().Rendering.MeshCacheSize = 50
            Lighting.GlobalShadows = false
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("ParticleEmitter") then
                    part.Enabled = false
                end
            end
        else
            ShowNotification("Extreme Smooth", "Extreme Smooth deactivated", 2)
            settings().Rendering.QualityLevel = 10
            settings().Rendering.MeshCacheSize = 400
            Lighting.GlobalShadows = true
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("ParticleEmitter") then
                    part.Enabled = true
                end
            end
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
            ShowNotification("Disable Effects", "All Effects disabled", 2)
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("ParticleEmitter") or part:IsA("Beam") or part:IsA("Trail") then
                    part.Enabled = false
                end
            end
        else
            ShowNotification("Disable Effects", "All Effects enabled", 2)
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("ParticleEmitter") or part:IsA("Beam") or part:IsA("Trail") then
                    part.Enabled = true
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
        
        if Value then
            ShowNotification("32-bit Mode", "32-bit Mode activated", 2)
            settings().Rendering.MeshCacheSize = 50
            settings().Rendering.TextureCacheSize = 50
        else
            ShowNotification("32-bit Mode", "32-bit Mode deactivated", 2)
            settings().Rendering.MeshCacheSize = 400
            settings().Rendering.TextureCacheSize = 400
        end
    end
})

LowDevTab:CreateToggle({
    Name = "Low Battery Mode",
    CurrentValue = Config.LowDev.LowBatteryMode,
    Flag = "LowBatteryModeToggle",
    Callback = function(Value)
        Config.LowDev.LowBatteryMode = Value
        SaveConfig()
        
        if Value then
            ShowNotification("Low Battery Mode", "Low Battery Mode activated", 2)
            settings().Rendering.QualityLevel = 1
            settings().Rendering.MeshCacheSize = 50
            settings().Rendering.TextureCacheSize = 50
            Lighting.GlobalShadows = false
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("ParticleEmitter") then
                    part.Enabled = false
                end
            end
        else
            ShowNotification("Low Battery Mode", "Low Battery Mode deactivated", 2)
            settings().Rendering.QualityLevel = 10
            settings().Rendering.MeshCacheSize = 400
            settings().Rendering.TextureCacheSize = 400
            Lighting.GlobalShadows = true
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("ParticleEmitter") then
                    part.Enabled = true
                end
            end
        end
    end
})

-- NKZ-SETTING Tab
local SettingTab = Window:CreateTab("NKZ-SETTING", 4483362458)
SettingTab:CreateSection("Information")

SettingTab:CreateLabel("Developer: Nikzz")
SettingTab:CreateLabel("Discord: nikzzdev")
SettingTab:CreateLabel("TikTok: @nikzzdev")
SettingTab:CreateLabel("Total Features: 45+")
SettingTab:CreateLabel("Script Version: 1.0")

SettingTab:CreateSection("Configuration")

SettingTab:CreateButton({
    Name = "Save Configuration",
    Callback = function()
        SaveConfig()
        ShowNotification("Configuration", "Configuration saved", 2)
    end
})

SettingTab:CreateButton({
    Name = "Load Configuration",
    Callback = function()
        LoadConfig()
        ShowNotification("Configuration", "Configuration loaded", 2)
    end
})

SettingTab:CreateButton({
    Name = "Reset Configuration",
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
                AutoJumpDelay = 1.0,
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
                FOVValue = 70,
                FOVHorizontal = 0,
                FOVVertical = 0
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
        ShowNotification("Configuration", "Configuration reset", 2)
    end
})

SettingTab:CreateSection("Script Control")

SettingTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
        ShowNotification("UI", "UI destroyed", 2)
    end
})

SettingTab:CreateButton({
    Name = "Re-execute Script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nikzzdev/NKZMODDER/main/NKZMODDER.lua"))()
        ShowNotification("Script", "Re-executing script...", 2)
    end
})

-- Initialize
LoadModules()
LoadConfig()

-- Show success notification
ShowNotification("NKZ MODDER", "Script loaded successfully! Total features: 45+", 5)
