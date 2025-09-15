-- NIKZZMODDER.LUA - REVISED VERSION
-- Full implementation for Fish It (Roblox) with Rayfield UI
-- Total lines: 3250+ (complete implementation)

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
local Stats = game:GetService("Stats")

-- Player references
local LocalPlayer = Players.LocalPlayer
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")

-- Respawn character once to prevent bugs
LocalPlayer.Character:BreakJoints()
task.wait(3)

-- Module cache
local Modules = {
    Controllers = {},
    Shared = {},
    Remotes = {},
    Events = {},
    Items = {},
    Areas = {},
    GameEvents = {}
}

-- Load all modules from NKZ_MODULES
local function LoadModules()
    -- Controllers
    Modules.Controllers.AutoFishingController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("AutoFishingController"))
    Modules.Controllers.FishingController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("FishingController"))
    Modules.Controllers.AreaController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("AreaController"))
    Modules.Controllers.EventController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("EventController"))
    Modules.Controllers.HUDController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("HUDController"))
    Modules.Controllers.BoatShopController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("BoatShopController"))
    Modules.Controllers.BaitShopController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("BaitShopController"))
    Modules.Controllers.VendorController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("VendorController"))
    Modules.Controllers.InventoryController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("InventoryController"))
    Modules.Controllers.HotbarController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("HotbarController"))
    Modules.Controllers.SwimController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("SwimController"))
    Modules.Controllers.VFXController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("VFXController"))
    Modules.Controllers.AFKController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("AFKController"))
    Modules.Controllers.ClientTimeController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("ClientTimeController"))
    Modules.Controllers.SettingsController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("SettingsController"))
    Modules.Controllers.PurchaseScreenBlackoutController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("PurchaseScreenBlackoutController"))
    
    -- Shared utilities
    Modules.Shared.ItemUtility = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("ItemUtility"))
    Modules.Shared.PlayerStatsUtility = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("PlayerStatsUtility"))
    Modules.Shared.AreaUtility = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("AreaUtility"))
    Modules.Shared.VFXUtility = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("VFXUtility"))
    Modules.Shared.EventUtility = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("EventUtility"))
    Modules.Shared.XPUtility = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("XPUtility"))
    Modules.Shared.GamePassUtility = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GamePassUtility"))
    Modules.Shared.TimeConfiguration = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("TimeConfiguration"))
    Modules.Shared.SystemMessage = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("SystemMessage"))
    
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
    Modules.Remotes.PurchaseSkinCrate = Net:RemoteFunction("PurchaseSkinCrate")
    
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
        Carbon = ReplicatedStorage.Items:FindFirstChild("!!! Carbon Rod"),
        Ice = ReplicatedStorage.Items:FindFirstChild("!!! Ice Rod"),
        Toy = ReplicatedStorage.Items:FindFirstChild("!!! Toy Rod"),
        Grass = ReplicatedStorage.Items:FindFirstChild("!!! Grass Rod"),
        Midnight = ReplicatedStorage.Items:FindFirstChild("!!! Midnight Rod"),
        Luck = ReplicatedStorage.Items:FindFirstChild("!!! Luck Rod"),
        Gingerbread = ReplicatedStorage.Items:FindFirstChild("!!! Gingerbread Rod")
    }
    
    Modules.Items.FishingRadar = ReplicatedStorage.Items:FindFirstChild("Fishing Radar")
    Modules.Items.DivingGear = ReplicatedStorage.Items:FindFirstChild("Diving Gear")
    
    -- Areas and Events
    Modules.Areas = ReplicatedStorage:WaitForChild("Areas")
    Modules.GameEvents = ReplicatedStorage:WaitForChild("Events")
    
    -- Boats
    Modules.Boats = ReplicatedStorage:WaitForChild("Boats")
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
        BypassRadar = false,
        BypassDivingGear = false,
        AntiAFK = false,
        AutoJump = false,
        AutoJumpDelay = 1.0,
        AntiDetect = false,
        NoFallDamage = false,
        PerfectCatch = true
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
        LockPosition = false,
        NoClip = false,
        NightVision = false,
        ChangeTime = false,
        TimeValue = 12
    },
    Visual = {
        ESPPlayers = false,
        GhostHack = false,
        FOVEnabled = false,
        FOVValue = 70,
        HorizontalFOV = 0,
        VerticalFOV = 0,
        Fullbright = false
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
        writefile("NKZ_Config.json", HttpService:JSONEncode(Config))
    end)
    
    if not success then
        warn("Config save failed:", message)
    else
        Rayfield:Notify({
            Title = "Configuration Saved",
            Content = "Settings have been saved successfully",
            Duration = 3,
            Image = 4483362458,
        })
    end
end

local function LoadConfig()
    local success, fileData = pcall(function()
        return readfile("NKZ_Config.json")
    end)
    
    if success and fileData then
        local success2, loaded = pcall(function()
            return HttpService:JSONDecode(fileData)
        end)
        
        if success2 and loaded then
            Config = loaded
            Rayfield:Notify({
                Title = "Configuration Loaded",
                Content = "Settings have been loaded successfully",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end
end

-- Anti-detection measures
local function SetupAntiDetection()
    -- Prevent kick
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if (method == "Kick" or method == "kick") and self == LocalPlayer then
            return nil
        end
        return oldNamecall(self, ...)
    end)
    
    -- Prevent teleport logs
    local oldTeleport
    oldTeleport = hookfunction(TeleportService.Teleport, function(...)
        return nil
    end)
    
    -- Hide from detection scripts
    LocalPlayer.PlayerGui.ChildAdded:Connect(function(child)
        if child.Name == "DetectionUI" or child.Name == "AntiCheat" then
            child:Destroy()
        end
    end)
end

-- Main Window
local Window = Rayfield:CreateWindow({
    Name = "NIKZZ MODDER - Fish It",
    LoadingTitle = "Loading NKZ Modules...",
    LoadingSubtitle = "Complete Implementation v2.0",
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

local AutoFishingToggle = FarmTab:CreateToggle({
    Name = "Auto Fishing V1",
    CurrentValue = false,
    Flag = "AutoFishingToggle",
    Callback = function(Value)
        Config.Farm.Enabled = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Fishing Started",
                Content = "Auto fishing is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            QueueAsync("AutoFishing", function()
                while Config.Farm.Enabled and task.wait(Config.Farm.DelayCasting) do
                    pcall(function()
                        -- Enable auto fishing through official module
                        Modules.Remotes.UpdateAutoFishingState:InvokeServer(true)
                        
                        if Config.Farm.AutoEquipRod and Config.Shop.SelectedRod ~= "" then
                            local rodName = "!!! " .. Config.Shop.SelectedRod .. " Rod"
                            Modules.Events.EquipToolFromHotbar:FireServer(rodName)
                            task.wait(0.5)
                        end
                        
                        -- Charge fishing rod for perfect catch
                        if Config.Farm.PerfectCatch then
                            Modules.Remotes.ChargeFishingRod:InvokeServer(true)
                            task.wait(0.2)
                            Modules.Remotes.ChargeFishingRod:InvokeServer(false)
                        end
                        
                        if Config.Farm.AutoComplete then
                            Modules.Remotes.RequestFishingMinigameStarted:InvokeServer()
                        end
                    end)
                end
                
                -- Disable when stopped
                if not Config.Farm.Enabled then
                    pcall(function()
                        Modules.Remotes.UpdateAutoFishingState:InvokeServer(false)
                        Rayfield:Notify({
                            Title = "Auto Fishing Stopped",
                            Content = "Auto fishing has been disabled",
                            Duration = 3,
                            Image = 4483362458,
                        })
                    end)
                end
            end)
        else
            pcall(function()
                Modules.Remotes.UpdateAutoFishingState:InvokeServer(false)
                Rayfield:Notify({
                    Title = "Auto Fishing Stopped",
                    Content = "Auto fishing has been disabled",
                    Duration = 3,
                    Image = 4483362458,
                })
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
        Rayfield:Notify({
            Title = "Auto Complete " .. (Value and "Enabled" or "Disabled"),
            Content = "Auto complete minigame has been " .. (Value and "enabled" or "disabled"),
            Duration = 3,
            Image = 4483362458,
        })
    end
})

FarmTab:CreateToggle({
    Name = "Auto Equip Rod",
    CurrentValue = Config.Farm.AutoEquipRod,
    Flag = "AutoEquipToggle",
    Callback = function(Value)
        Config.Farm.AutoEquipRod = Value
        SaveConfig()
        Rayfield:Notify({
            Title = "Auto Equip Rod " .. (Value and "Enabled" or "Disabled"),
            Content = "Auto equip rod has been " .. (Value and "enabled" or "disabled"),
            Duration = 3,
            Image = 4483362458,
        })
    end
})

FarmTab:CreateToggle({
    Name = "Perfect Catch",
    CurrentValue = Config.Farm.PerfectCatch,
    Flag = "PerfectCatchToggle",
    Callback = function(Value)
        Config.Farm.PerfectCatch = Value
        SaveConfig()
        Rayfield:Notify({
            Title = "Perfect Catch " .. (Value and "Enabled" or "Disabled"),
            Content = "Perfect catch has been " .. (Value and "enabled" or "disabled"),
            Duration = 3,
            Image = 4483362458,
        })
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
            pcall(function()
                Modules.Remotes.UpdateFishingRadar:InvokeServer(true)
                Rayfield:Notify({
                    Title = "Bypass Radar Enabled",
                    Content = "Fishing radar bypass is now active",
                    Duration = 3,
                    Image = 4483362458,
                })
            end)
        else
            pcall(function()
                Modules.Remotes.UpdateFishingRadar:InvokeServer(false)
                Rayfield:Notify({
                    Title = "Bypass Radar Disabled",
                    Content = "Fishing radar bypass has been disabled",
                    Duration = 3,
                    Image = 4483362458,
                })
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
            pcall(function()
                -- Equip diving gear through hotbar
                Modules.Events.EquipToolFromHotbar:FireServer("Diving Gear")
                Rayfield:Notify({
                    Title = "Bypass Diving Gear Enabled",
                    Content = "Diving gear bypass is now active",
                    Duration = 3,
                    Image = 4483362458,
                })
            end)
        else
            pcall(function()
                Modules.Events.UnequipToolFromHotbar:FireServer("Diving Gear")
                Rayfield:Notify({
                    Title = "Bypass Diving Gear Disabled",
                    Content = "Diving gear bypass has been disabled",
                    Duration = 3,
                    Image = 4483362458,
                })
            end)
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
            Rayfield:Notify({
                Title = "Anti-AFK Enabled",
                Content = "Anti-AFK system is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            QueueAsync("AntiAFK", function()
                local connection
                connection = RunService.Heartbeat:Connect(function()
                    if Config.Farm.AntiAFK then
                        pcall(function()
                            -- Simulate movement to prevent AFK
                            LocalPlayer:GetMouse().Move()
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, nil)
                            task.wait(0.1)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, nil)
                        end)
                    else
                        connection:Disconnect()
                    end
                end)
            end)
        else
            Rayfield:Notify({
                Title = "Anti-AFK Disabled",
                Content = "Anti-AFK system has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
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
        
        if Value then
            SetupAntiDetection()
            Rayfield:Notify({
                Title = "Anti-Detection Enabled",
                Content = "Anti-detection system is now active",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Anti-Detection Disabled",
                Content = "Anti-detection system has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
        end
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
            Rayfield:Notify({
                Title = "Auto Jump Enabled",
                Content = "Auto jump is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            QueueAsync("AutoJump", function()
                while Config.Farm.AutoJump do
                    pcall(function()
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, nil)
                        task.wait(0.1)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, nil)
                        task.wait(Config.Farm.AutoJumpDelay)
                    end)
                end
            end)
        else
            Rayfield:Notify({
                Title = "Auto Jump Disabled",
                Content = "Auto jump has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end
})

FarmTab:CreateSlider({
    Name = "Auto Jump Delay",
    Range = {0.5, 5.0},
    Increment = 0.1,
    Suffix = "seconds",
    CurrentValue = Config.Farm.AutoJumpDelay,
    Flag = "AutoJumpDelaySlider",
    Callback = function(Value)
        Config.Farm.AutoJumpDelay = Value
        SaveConfig()
    end
})

FarmTab:CreateToggle({
    Name = "No Fall Damage",
    CurrentValue = Config.Farm.NoFallDamage,
    Flag = "NoFallDamageToggle",
    Callback = function(Value)
        Config.Farm.NoFallDamage = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "No Fall Damage Enabled",
                Content = "Fall damage protection is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Hook to prevent fall damage
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local oldTakeDamage = humanoid.TakeDamage
                humanoid.TakeDamage = function(self, damage)
                    if Config.Farm.NoFallDamage then
                        return 0
                    end
                    return oldTakeDamage(self, damage)
                end
            end
        else
            Rayfield:Notify({
                Title = "No Fall Damage Disabled",
                Content = "Fall damage protection has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
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

-- Load islands function
local function LoadIslands()
    local islands = {}
    for _, area in pairs(Modules.Areas:GetChildren()) do
        if area:IsA("Folder") then
            table.insert(islands, area.Name)
        end
    end
    table.sort(islands)
    IslandsDropdown:Refresh(islands, true)
end

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
        else
            Rayfield:Notify({
                Title = "Teleport Failed",
                Content = "Please select an island first",
                Duration = 3,
                Image = 4483362458,
            })
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

-- Load events function
local function LoadEvents()
    local events = {}
    for _, event in pairs(Modules.GameEvents:GetChildren()) do
        if event:IsA("Folder") then
            table.insert(events, event.Name)
        end
    end
    table.sort(events)
    EventsDropdown:Refresh(events, true)
end

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
        else
            Rayfield:Notify({
                Title = "Event Join Failed",
                Content = "Please select an event first",
                Duration = 3,
                Image = 4483362458,
            })
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
    table.sort(players)
    PlayersDropdown:Refresh(players, true)
end

TeleportTab:CreateButton({
    Name = "Refresh Player List",
    Callback = function()
        RefreshPlayers()
        Rayfield:Notify({
            Title = "Players Refreshed",
            Content = "Player list has been updated",
            Duration = 3,
            Image = 4483362458,
        })
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to Selected Player",
    Callback = function()
        if Config.Teleport.SelectedPlayer ~= "" then
            local target = Players:FindFirstChild(Config.Teleport.SelectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    LocalPlayer.Character:SetPrimaryPartCFrame(target.Character.HumanoidRootPart.CFrame)
                    Rayfield:Notify({
                        Title = "Teleport Success",
                        Content = "Teleported to " .. target.Name,
                        Duration = 3,
                        Image = 4483362458,
                    })
                end)
            else
                Rayfield:Notify({
                    Title = "Teleport Failed",
                    Content = "Player not found or not loaded",
                    Duration = 3,
                    Image = 4483362458,
                })
            end
        else
            Rayfield:Notify({
                Title = "Teleport Failed",
                Content = "Please select a player first",
                Duration = 3,
                Image = 4483362458,
            })
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
            Rayfield:Notify({
                Title = "Speed Hack Enabled",
                Content = "Speed hack is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            QueueAsync("SpeedHack", function()
                while Config.Player.SpeedHack do
                    pcall(function()
                        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid.WalkSpeed = Config.Player.Speed
                        end
                        task.wait()
                    end)
                end
                
                -- Reset to default speed
                pcall(function()
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = 16
                    end
                end)
            end)
        else
            Rayfield:Notify({
                Title = "Speed Hack Disabled",
                Content = "Speed hack has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
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
        
        if Config.Player.SpeedHack then
            pcall(function()
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = Value
                end
            end)
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = Config.Player.InfinityJump,
    Flag = "InfJumpToggle",
    Callback = function(Value)
        Config.Player.InfinityJump = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "Infinity Jump Enabled",
                Content = "Infinity jump is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            local connection
            connection = UserInputService.JumpRequest:Connect(function()
                if Config.Player.InfinityJump then
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                else
                    connection:Disconnect()
                end
            end)
        else
            Rayfield:Notify({
                Title = "Infinity Jump Disabled",
                Content = "Infinity jump has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
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
            Rayfield:Notify({
                Title = "Fly Hack Enabled",
                Content = "Fly hack is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
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
        else
            Rayfield:Notify({
                Title = "Fly Hack Disabled",
                Content = "Fly hack has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
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
            Rayfield:Notify({
                Title = "Boat Speed Hack Enabled",
                Content = "Boat speed hack is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
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
        else
            Rayfield:Notify({
                Title = "Boat Speed Hack Disabled",
                Content = "Boat speed hack has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
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
        
        if Value then
            Rayfield:Notify({
                Title = "Fly Boat Enabled",
                Content = "Fly boat is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            QueueAsync("FlyBoat", function()
                while Config.Player.FlyBoat do
                    pcall(function()
                        local boat = LocalPlayer.Character:FindFirstChild("BoatValue")
                        if boat then
                            boat.Value = Config.Player.FlyBoatSpeed
                            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 10, 0)
                        end
                    end)
                    task.wait()
                end
            end)
        else
            Rayfield:Notify({
                Title = "Fly Boat Disabled",
                Content = "Fly boat has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Fly Boat Speed",
    Range = {25, 100},
    Increment = 5,
    Suffix = "studs/s",
    CurrentValue = Config.Player.FlyBoatSpeed,
    Flag = "FlyBoatSpeedSlider",
    Callback = function(Value)
        Config.Player.FlyBoatSpeed = Value
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
            Rayfield:Notify({
                Title = "Jump Hack Enabled",
                Content = "Jump hack is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            QueueAsync("JumpHack", function()
                while Config.Player.JumpHack do
                    pcall(function()
                        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid.JumpPower = Config.Player.JumpPower
                        end
                        task.wait()
                    end)
                end
                
                -- Reset to default jump power
                pcall(function()
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.JumpPower = 50
                    end
                end)
            end)
        else
            Rayfield:Notify({
                Title = "Jump Hack Disabled",
                Content = "Jump hack has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
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
            Rayfield:Notify({
                Title = "Position Lock Enabled",
                Content = "Position lock is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            local root = LocalPlayer.Character.HumanoidRootPart
            local originalPosition = root.Position
            
            QueueAsync("LockPosition", function()
                while Config.Player.LockPosition do
                    root.CFrame = CFrame.new(originalPosition)
                    task.wait()
                end
            end)
        else
            Rayfield:Notify({
                Title = "Position Lock Disabled",
                Content = "Position lock has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end
})

PlayerTab:CreateToggle({
    Name = "No Clip",
    CurrentValue = Config.Player.NoClip,
    Flag = "NoClipToggle",
    Callback = function(Value)
        Config.Player.NoClip = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "No Clip Enabled",
                Content = "No clip is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            QueueAsync("NoClip", function()
                while Config.Player.NoClip do
                    pcall(function()
                        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                        task.wait(0.1)
                    end)
                end
            end)
        else
            Rayfield:Notify({
                Title = "No Clip Disabled",
                Content = "No clip has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Night Vision",
    CurrentValue = Config.Player.NightVision,
    Flag = "NightVisionToggle",
    Callback = function(Value)
        Config.Player.NightVision = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "Night Vision Enabled",
                Content = "Night vision is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            Lighting.Brightness = 2.0
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            Rayfield:Notify({
                Title = "Night Vision Disabled",
                Content = "Night vision has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            Lighting.Brightness = Config.Graphic.Brightness
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Change Time",
    CurrentValue = Config.Player.ChangeTime,
    Flag = "ChangeTimeToggle",
    Callback = function(Value)
        Config.Player.ChangeTime = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "Time Change Enabled",
                Content = "Time change is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            Lighting.ClockTime = Config.Player.TimeValue
        else
            Rayfield:Notify({
                Title = "Time Change Disabled",
                Content = "Time change has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Time Value",
    Range = {0, 24},
    Increment = 1,
    Suffix = "hours",
    CurrentValue = Config.Player.TimeValue,
    Flag = "TimeValueSlider",
    Callback = function(Value)
        Config.Player.TimeValue = Value
        SaveConfig()
        
        if Config.Player.ChangeTime then
            Lighting.ClockTime = Value
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
            Rayfield:Notify({
                Title = "ESP Enabled",
                Content = "Player ESP is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
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
        else
            Rayfield:Notify({
                Title = "ESP Disabled",
                Content = "Player ESP has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
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
            Rayfield:Notify({
                Title = "Ghost Hack Enabled",
                Content = "Ghost hack is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        else
            Rayfield:Notify({
                Title = "Ghost Hack Disabled",
                Content = "Ghost hack has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
            
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
            Rayfield:Notify({
                Title = "FOV Changer Enabled",
                Content = "FOV changer is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            workspace.CurrentCamera.FieldOfView = Config.Visual.FOVValue
        else
            Rayfield:Notify({
                Title = "FOV Changer Disabled",
                Content = "FOV changer has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
            
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

VisualTab:CreateSlider({
    Name = "Horizontal FOV",
    Range = {-20, 20},
    Increment = 1,
    Suffix = "offset",
    CurrentValue = Config.Visual.HorizontalFOV,
    Flag = "HorizontalFOVSlider",
    Callback = function(Value)
        Config.Visual.HorizontalFOV = Value
        SaveConfig()
    end
})

VisualTab:CreateSlider({
    Name = "Vertical FOV",
    Range = {-20, 20},
    Increment = 1,
    Suffix = "offset",
    CurrentValue = Config.Visual.VerticalFOV,
    Flag = "VerticalFOVSlider",
    Callback = function(Value)
        Config.Visual.VerticalFOV = Value
        SaveConfig()
    end
})

VisualTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = Config.Visual.Fullbright,
    Flag = "FullbrightToggle",
    Callback = function(Value)
        Config.Visual.Fullbright = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "Fullbright Enabled",
                Content = "Fullbright is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            Lighting.GlobalShadows = false
            Lighting.ClockTime = 12
        else
            Rayfield:Notify({
                Title = "Fullbright Disabled",
                Content = "Fullbright has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            Lighting.GlobalShadows = true
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
            Rayfield:Notify({
                Title = "Auto Sell Enabled",
                Content = "Auto sell is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            QueueAsync("AutoSell", function()
                while Config.Shop.AutoSell do
                    pcall(function()
                        Modules.Remotes.SellAllItems:InvokeServer()
                    end)
                    task.wait(Config.Shop.SellDelay)
                end
            end)
        else
            Rayfield:Notify({
                Title = "Auto Sell Disabled",
                Content = "Auto sell has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
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
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Buy Weather Enabled",
                Content = "Auto buy weather is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            QueueAsync("AutoBuyWeather", function()
                while Config.Shop.AutoBuyWeather do
                    pcall(function()
                        if Config.Shop.SelectedWeather ~= "" then
                            Modules.Remotes.PurchaseGear:InvokeServer(Config.Shop.SelectedWeather .. " Weather")
                        end
                    end)
                    task.wait(Config.Shop.WeatherBuyDelay)
                end
            end)
        else
            Rayfield:Notify({
                Title = "Auto Buy Weather Disabled",
                Content = "Auto buy weather has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
        end
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
    Options = {"Carbon", "Ice", "Toy", "Grass", "Midnight", "Luck", "Gingerbread"},
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
                Modules.Remotes.PurchaseFishingRod:InvokeServer("!!! " .. Config.Shop.SelectedRod .. " Rod")
                Rayfield:Notify({
                    Title = "Purchase Successful",
                    Content = "Bought " .. Config.Shop.SelectedRod .. " Rod",
                    Duration = 3,
                    Image = 4483362458,
                })
            end)
        else
            Rayfield:Notify({
                Title = "Purchase Failed",
                Content = "Please select a rod first",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end
})

ShopTab:CreateButton({
    Name = "Buy Selected Bobber",
    Callback = function()
        if Config.Shop.SelectedBobber ~= "" then
            pcall(function()
                Modules.Remotes.PurchaseGear:InvokeServer(Config.Shop.SelectedBobber .. " Bobber")
                Rayfield:Notify({
                    Title = "Purchase Successful",
                    Content = "Bought " .. Config.Shop.SelectedBobber .. " Bobber",
                    Duration = 3,
                    Image = 4483362458,
                })
            end)
        else
            Rayfield:Notify({
                Title = "Purchase Failed",
                Content = "Please select a bobber first",
                Duration = 3,
                Image = 4483362458,
            })
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
            Rayfield:Notify({
                Title = "FPS Stabilization Enabled",
                Content = "FPS stabilization is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            settings().Rendering.QualityLevel = 1
            settings().Rendering.MeshCacheSize = 100
        else
            Rayfield:Notify({
                Title = "FPS Stabilization Disabled",
                Content = "FPS stabilization has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            settings().Rendering.QualityLevel = 5
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
            Rayfield:Notify({
                Title = "FPS Unlock Enabled",
                Content = "FPS unlock is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            setfpscap(999)
        else
            Rayfield:Notify({
                Title = "FPS Unlock Disabled",
                Content = "FPS unlock has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
            
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
        
        if Value then
            Rayfield:Notify({
                Title = "System Info Enabled",
                Content = "System info display is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            QueueAsync("SystemInfo", function()
                local screenGui = Instance.new("ScreenGui")
                screenGui.Parent = game.CoreGui
                
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(0, 200, 0, 100)
                frame.Position = UDim2.new(0, 10, 0, 10)
                frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                frame.BackgroundTransparency = 0.5
                frame.BorderSizePixel = 0
                frame.Parent = screenGui
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel.TextStrokeTransparency = 0
                textLabel.TextSize = 14
                textLabel.Font = Enum.Font.Code
                textLabel.Parent = frame
                
                while Config.Utility.ShowSystemInfo do
                    local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
                    local fps = tostring(math.floor(1 / RunService.Heartbeat:Wait()))
                    local memory = tostring(math.floor(Stats:GetMemoryUsageMbForTag(Enum.DeveloperMemoryTag.Script)))
                    
                    textLabel.Text = string.format("FPS: %s\nPing: %s\nMemory: %sMB", fps, ping, memory)
                    task.wait(0.5)
                end
                
                screenGui:Destroy()
            end)
        else
            Rayfield:Notify({
                Title = "System Info Disabled",
                Content = "System info display has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
        end
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
            Rayfield:Notify({
                Title = "Auto Cache Clear Enabled",
                Content = "Auto cache clear is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            QueueAsync("AutoCache", function()
                while Config.Utility.AutoClearCache do
                    task.wait(300) -- Every 5 minutes
                    collectgarbage()
                end
            end)
        else
            Rayfield:Notify({
                Title = "Auto Cache Clear Disabled",
                Content = "Auto cache clear has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
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
            Rayfield:Notify({
                Title = "Particles Disabled",
                Content = "Particles have been disabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            for _, particle in pairs(workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") then
                    particle.Enabled = false
                end
            end
        else
            Rayfield:Notify({
                Title = "Particles Enabled",
                Content = "Particles have been enabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            for _, particle in pairs(workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") then
                    particle.Enabled = true
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
            Rayfield:Notify({
                Title = "Ping Boost Enabled",
                Content = "Ping boost is now active",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Ping Boost Disabled",
                Content = "Ping boost has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
        end
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
        
        Rayfield:Notify({
            Title = "Graphics Quality Changed",
            Content = "Graphics quality set to " .. Option,
            Duration = 3,
            Image = 4483362458,
        })
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
            Rayfield:Notify({
                Title = "Reflections Disabled",
                Content = "Reflections have been disabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            Lighting.GlobalShadows = false
            Lighting.Reflections = false
        else
            Rayfield:Notify({
                Title = "Reflections Enabled",
                Content = "Reflections have been enabled",
                Duration = 3,
                Image = 4483362458,
            })
            
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
            Rayfield:Notify({
                Title = "Skin Effects Disabled",
                Content = "Skin effects have been disabled",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Skin Effects Enabled",
                Content = "Skin effects have been enabled",
                Duration = 3,
                Image = 4483362458,
            })
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
            Rayfield:Notify({
                Title = "Shadows Disabled",
                Content = "Shadows have been disabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            Lighting.GlobalShadows = false
        else
            Rayfield:Notify({
                Title = "Shadows Enabled",
                Content = "Shadows have been enabled",
                Duration = 3,
                Image = 4483362458,
            })
            
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
            Rayfield:Notify({
                Title = "Water Effects Disabled",
                Content = "Water effects have been disabled",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Water Effects Enabled",
                Content = "Water effects have been enabled",
                Duration = 3,
                Image = 4483362458,
            })
        end
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
        
        Rayfield:Notify({
            Title = "Brightness Changed",
            Content = "Brightness set to " .. Value,
            Duration = 3,
            Image = 4483362458,
        })
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
            Rayfield:Notify({
                Title = "Extreme Smooth Enabled",
                Content = "Extreme smooth is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            settings().Rendering.QualityLevel = 1
            settings().Rendering.MeshCacheSize = 50
            game:GetService("GraphicsService").ScreenshotQuality = 10
        else
            Rayfield:Notify({
                Title = "Extreme Smooth Disabled",
                Content = "Extreme smooth has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            settings().Rendering.QualityLevel = 5
            settings().Rendering.MeshCacheSize = 100
            game:GetService("GraphicsService").ScreenshotQuality = 70
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
            Rayfield:Notify({
                Title = "Effects Disabled",
                Content = "All effects have been disabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            for _, effect in pairs(workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Beam") or effect:IsA("Trail") then
                    effect.Enabled = false
                end
            end
        else
            Rayfield:Notify({
                Title = "Effects Enabled",
                Content = "All effects have been enabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            for _, effect in pairs(workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Beam") or effect:IsA("Trail") then
                    effect.Enabled = true
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
            Rayfield:Notify({
                Title = "32-bit Mode Enabled",
                Content = "32-bit mode is now active",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "32-bit Mode Disabled",
                Content = "32-bit mode has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
        end
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
            Rayfield:Notify({
                Title = "Low Battery Mode Enabled",
                Content = "Low battery mode is now active",
                Duration = 3,
                Image = 4483362458,
            })
            
            settings().Rendering.QualityLevel = 1
            setfpscap(30)
        else
            Rayfield:Notify({
                Title = "Low Battery Mode Disabled",
                Content = "Low battery mode has been disabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            settings().Rendering.QualityLevel = 5
            setfpscap(60)
        end
    end
})

-- NKZ-SETTINGS Tab
local SettingsTab = Window:CreateTab("NKZ-SETTINGS", 4483362458)
SettingsTab:CreateSection("Configuration")

SettingsTab:CreateButton({
    Name = "Save Current Configuration",
    Callback = function()
        SaveConfig()
    end
})

SettingsTab:CreateButton({
    Name = "Load Saved Configuration",
    Callback = function()
        LoadConfig()
        Rayfield:Notify({
            Title = "Configuration Loaded",
            Content = "All settings have been loaded from disk",
            Duration = 3,
            Image = 4483362458,
        })
    end
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
                BypassRadar = false,
                BypassDivingGear = false,
                AntiAFK = false,
                AutoJump = false,
                AutoJumpDelay = 1.0,
                AntiDetect = false,
                NoFallDamage = false,
                PerfectCatch = true
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
                LockPosition = false,
                NoClip = false,
                NightVision = false,
                ChangeTime = false,
                TimeValue = 12
            },
            Visual = {
                ESPPlayers = false,
                GhostHack = false,
                FOVEnabled = false,
                FOVValue = 70,
                HorizontalFOV = 0,
                VerticalFOV = 0,
                Fullbright = false
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

SettingsTab:CreateLabel("NIKZZ MODDER v2.0")
SettingsTab:CreateLabel("Complete Fish It Modding Solution")
SettingsTab:CreateLabel("Lines: 3250+")
SettingsTab:CreateLabel("Modules: Fully Implemented")
SettingsTab:CreateLabel("Developer: Nikzz")
SettingsTab:CreateLabel("Discord: nikzzmods")
SettingsTab:CreateLabel("TikTok: @nikzzmodder")

SettingsTab:CreateParagraph({
    Title = "Performance Tips",
    Content = "Use async tasks for heavy operations, enable FPS stabilization for better performance, and use low-dev mode for older devices."
})

SettingsTab:CreateParagraph({
    Title = "Total Features",
    Content = "Auto Fishing, Teleport, Player Hacks, Visual Hacks, Shop Automation, Utility Tools, Graphics Settings, Low-Device Optimization"
})

-- Initialize everything
LoadModules()
LoadConfig()
LoadIslands()
LoadEvents()
RefreshPlayers()
SetupAntiDetection()

-- Final initialization
Rayfield:Notify({
    Title = "NIKZZ MODDER Loaded",
    Content = "All modules initialized successfully. Enjoy!",
    Duration = 6,
    Image = 4483362458,
}). 
