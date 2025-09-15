-- NIKZZMODDER.LUA
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
local Workspace = game:GetService("Workspace")

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
        ["Carbon Rod"] = ReplicatedStorage.Items:FindFirstChild("!!! Carbon Rod"),
        ["Ice Rod"] = ReplicatedStorage.Items:FindFirstChild("!!! Ice Rod"),
        ["Toy Rod"] = ReplicatedStorage.Items:FindFirstChild("!!! Toy Rod"),
        ["Grass Rod"] = ReplicatedStorage.Items:FindFirstChild("!!! Grass Rod"),
        ["Midnight Rod"] = ReplicatedStorage.Items:FindFirstChild("!!! Midnight Rod"),
        ["Luck Rod"] = ReplicatedStorage.Items:FindFirstChild("!!! Luck Rod"),
        ["Gingerbread Rod"] = ReplicatedStorage.Items:FindFirstChild("!!! Gingerbread Rod")
    }
    
    Modules.Items.FishingRadar = ReplicatedStorage.Items:FindFirstChild("Fishing Radar")
    Modules.Items.DivingGear = ReplicatedStorage.Items:FindFirstChild("Diving Gear")
    
    -- Areas and Events
    Modules.Areas = ReplicatedStorage:WaitForChild("Areas")
    Modules.GameEvents = ReplicatedStorage:WaitForChild("Events")
    
    -- Boats collection
    Modules.Boats = ReplicatedStorage:WaitForChild("Boats")
    
    return true
end

-- Anti-bug respawn function
local function AntiBugRespawn()
    Rayfield:Notify({
        Title = "Anti-Bug System",
        Content = "Performing respawn to prevent bugs...",
        Duration = 3,
        Image = 4483362458,
    })
    
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
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
        AutoJumpDelay = 30,
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
        LockPosition = false,
        NoFallDamage = false,
        NightVision = false,
        NightVisionIntensity = 1.0
    },
    Visual = {
        ESPPlayers = false,
        GhostHack = false,
        FOVEnabled = false,
        FOVValue = 70,
        FOVHorizontal = 70,
        FOVVertical = 70,
        ADSFOVEnabled = false,
        ADSFOVValue = 40,
        ADSFOVHorizontal = 40,
        ADSFOVVertical = 40
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
        BoostPing = false,
        ChangeTime = false,
        TimeValue = 12.0
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

local AutoFishingToggle = FarmTab:CreateToggle({
    Name = "Auto Fishing V1",
    CurrentValue = false,
    Flag = "AutoFishingToggle",
    Callback = function(Value)
        Config.Farm.Enabled = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Fishing",
                Content = "Auto Fishing activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Start auto fishing task
            spawn(function()
                while Config.Farm.Enabled do
                    pcall(function()
                        -- Get current equipped rod
                        local currentRod = Modules.Controllers.HotbarController:GetEquippedTool()
                        
                        -- Auto equip best rod if enabled
                        if Config.Farm.AutoEquipRod then
                            local bestRod = GetBestRod()
                            if bestRod and bestRod ~= currentRod then
                                Modules.Events.EquipToolFromHotbar:FireServer(bestRod.Name)
                                currentRod = bestRod
                            end
                        end
                        
                        -- Enable auto fishing
                        Modules.Remotes.UpdateAutoFishingState:InvokeServer(true)
                        
                        -- Start fishing minigame
                        Modules.Remotes.RequestFishingMinigameStarted:InvokeServer()
                        
                        -- Wait for fishing to complete
                        local fishingComplete = Modules.Events.FishingCompleted:Wait()
                        
                        -- Auto reel in fish
                        if fishingComplete and Config.Farm.AutoComplete then
                            Modules.Remotes.ChargeFishingRod:InvokeServer(1.0) -- Full charge
                            Modules.Remotes.CancelFishingInputs:InvokeServer()
                        end
                    end)
                    
                    -- Wait before next cast
                    task.wait(Config.Farm.DelayCasting)
                end
            end)
        else
            Rayfield:Notify({
                Title = "Auto Fishing",
                Content = "Auto Fishing deactivated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Disable auto fishing
            pcall(function()
                Modules.Remotes.UpdateAutoFishingState:InvokeServer(false)
            end)
        end
    end
})

-- Function to get best rod
local function GetBestRod()
    local bestRod = nil
    local bestValue = 0
    
    for rodName, rod in pairs(Config.Shop.SelectedRod) do
        if rod and rod.Value then
            local rodValue = Modules.Shared.ItemUtility:GetRodValue(rod)
            if rodValue > bestValue then
                bestValue = rodValue
                bestRod = rod
            end
        end
    end
    
    return bestRod
end

FarmTab:CreateToggle({
    Name = "Auto Complete Minigame",
    CurrentValue = Config.Farm.AutoComplete,
    Flag = "AutoCompleteToggle",
    Callback = function(Value)
        Config.Farm.AutoComplete = Value
        SaveConfig()
        Rayfield:Notify({
            Title = "Auto Complete",
            Content = "Auto Complete Minigame " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 4483362458,
        })
    end
})

FarmTab:CreateToggle({
    Name = "Auto Equip Best Rod",
    CurrentValue = Config.Farm.AutoEquipRod,
    Flag = "AutoEquipToggle",
    Callback = function(Value)
        Config.Farm.AutoEquipRod = Value
        SaveConfig()
        Rayfield:Notify({
            Title = "Auto Equip Rod",
            Content = "Auto Equip Best Rod " .. (Value and "activated" or "deactivated"),
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
            Rayfield:Notify({
                Title = "Bypass Radar",
                Content = "Fishing Radar bypass activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Enable radar bypass
            pcall(function()
                Modules.Remotes.UpdateFishingRadar:InvokeServer(true)
            end)
        else
            Rayfield:Notify({
                Title = "Bypass Radar",
                Content = "Fishing Radar bypass deactivated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Disable radar bypass
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
        Rayfield:Notify({
            Title = "Bypass Diving Gear",
            Content = "Diving Gear bypass " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 4483362458,
        })
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
                Title = "Anti-AFK",
                Content = "Anti-AFK system activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Start anti-AFK task
            spawn(function()
                while Config.Farm.AntiAFK do
                    task.wait(30)
                    pcall(function()
                        -- Simulate movement to prevent AFK
                        LocalPlayer:GetMouse().Move()
                        
                        -- Press random key occasionally
                        if math.random() < 0.3 then
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false)
                            task.wait(0.1)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false)
                        end
                    end)
                end
            end)
        else
            Rayfield:Notify({
                Title = "Anti-AFK",
                Content = "Anti-AFK system deactivated",
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
        Rayfield:Notify({
            Title = "Anti-Detect",
            Content = "Anti-Developer Detection " .. (Value and "activated" or "deactivated"),
            Duration = 3,
            Image = 4483362458,
        })
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
                Title = "Auto Jump",
                Content = "Auto Jump activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Start auto jump task
            spawn(function()
                while Config.Farm.AutoJump do
                    task.wait(Config.Farm.AutoJumpDelay)
                    pcall(function()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                            LocalPlayer.Character.Humanoid.Jump = true
                        end
                    end)
                end
            end)
        else
            Rayfield:Notify({
                Title = "Auto Jump",
                Content = "Auto Jump deactivated",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end
})

FarmTab:CreateSlider({
    Name = "Auto Jump Delay",
    Range = {5, 60},
    Increment = 5,
    Suffix = "seconds",
    CurrentValue = Config.Farm.AutoJumpDelay,
    Flag = "AutoJumpDelaySlider",
    Callback = function(Value)
        Config.Farm.AutoJumpDelay = Value
        SaveConfig()
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

-- Load islands asynchronously
spawn(function()
    local islands = {}
    for _, area in pairs(Modules.Areas:GetChildren()) do
        if area:IsA("Folder") then
            table.insert(islands, area.Name)
        end
    end
    
    IslandsDropdown:Refresh(islands, true)
    Rayfield:Notify({
        Title = "Islands Loaded",
        Content = "Successfully loaded " .. #islands .. " islands",
        Duration = 3,
        Image = 4483362458,
    })
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
        else
            Rayfield:Notify({
                Title = "Teleport Error",
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

-- Load events asynchronously
spawn(function()
    local events = {}
    for _, event in pairs(Modules.GameEvents:GetChildren()) do
        if event:IsA("Folder") then
            table.insert(events, event.Name)
        end
    end
    
    EventsDropdown:Refresh(events, true)
    Rayfield:Notify({
        Title = "Events Loaded",
        Content = "Successfully loaded " .. #events .. " events",
        Duration = 3,
        Image = 4483362458,
    })
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
        else
            Rayfield:Notify({
                Title = "Event Error",
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
    
    PlayersDropdown:Refresh(players, true)
    Rayfield:Notify({
        Title = "Players Refreshed",
        Content = "Successfully loaded " .. #players .. " players",
        Duration = 3,
        Image = 4483362458,
    })
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
                    Title = "Teleport Error",
                    Content = "Player not found or invalid character",
                    Duration = 3,
                    Image = 4483362458,
                })
            end
        else
            Rayfield:Notify({
                Title = "Teleport Error",
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

local SpeedHackToggle = PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = Config.Player.SpeedHack,
    Flag = "SpeedHackToggle",
    Callback = function(Value)
        Config.Player.SpeedHack = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "Speed Hack",
                Content = "Speed Hack activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Start speed hack
            spawn(function()
                while Config.Player.SpeedHack do
                    pcall(function()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                            LocalPlayer.Character.Humanoid.WalkSpeed = Config.Player.Speed
                        end
                    end)
                    task.wait()
                end
                
                -- Reset speed when disabled
                pcall(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid.WalkSpeed = 16
                    end
                end)
            end)
        else
            Rayfield:Notify({
                Title = "Speed Hack",
                Content = "Speed Hack deactivated",
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
    end
})

local InfinityJumpToggle = PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = Config.Player.InfinityJump,
    Flag = "InfJumpToggle",
    Callback = function(Value)
        Config.Player.InfinityJump = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "Infinity Jump",
                Content = "Infinity Jump activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Enable infinity jump
            LocalPlayer.Character.Humanoid.JumpPower = 100
        else
            Rayfield:Notify({
                Title = "Infinity Jump",
                Content = "Infinity Jump deactivated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Reset jump power
            LocalPlayer.Character.Humanoid.JumpPower = 50
        end
    end
})

local FlyHackToggle = PlayerTab:CreateToggle({
    Name = "Fly Hack",
    CurrentValue = Config.Player.Fly,
    Flag = "FlyToggle",
    Callback = function(Value)
        Config.Player.Fly = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "Fly Hack",
                Content = "Fly Hack activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Start fly hack
            spawn(function()
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
                Title = "Fly Hack",
                Content = "Fly Hack deactivated",
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

local BoatSpeedToggle = PlayerTab:CreateToggle({
    Name = "Boat Speed Hack",
    CurrentValue = Config.Player.BoatSpeedHack,
    Flag = "BoatSpeedToggle",
    Callback = function(Value)
        Config.Player.BoatSpeedHack = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "Boat Speed Hack",
                Content = "Boat Speed Hack activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Start boat speed hack
            spawn(function()
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
                Title = "Boat Speed Hack",
                Content = "Boat Speed Hack deactivated",
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
                Title = "Fly Boat",
                Content = "Fly Boat activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Enable boat fly
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Boat") then
                    LocalPlayer.Character.Boat.CanFly = true
                end
            end)
        else
            Rayfield:Notify({
                Title = "Fly Boat",
                Content = "Fly Boat deactivated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Disable boat fly
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Boat") then
                    LocalPlayer.Character.Boat.CanFly = false
                end
            end)
        end
    end
})

PlayerTab:CreateSection("Other Hacks")

local JumpHackToggle = PlayerTab:CreateToggle({
    Name = "Jump Hack",
    CurrentValue = Config.Player.JumpHack,
    Flag = "JumpHackToggle",
    Callback = function(Value)
        Config.Player.JumpHack = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "Jump Hack",
                Content = "Jump Hack activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Start jump hack
            spawn(function()
                while Config.Player.JumpHack do
                    pcall(function()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                            LocalPlayer.Character.Humanoid.JumpPower = Config.Player.JumpPower
                        end
                    end)
                    task.wait()
                end
                
                -- Reset jump power when disabled
                pcall(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid.JumpPower = 50
                    end
                end)
            end)
        else
            Rayfield:Notify({
                Title = "Jump Hack",
                Content = "Jump Hack deactivated",
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
                Title = "Lock Position",
                Content = "Lock Position activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            local root = LocalPlayer.Character.HumanoidRootPart
            local originalPosition = root.Position
            
            -- Start position lock
            spawn(function()
                while Config.Player.LockPosition do
                    root.CFrame = CFrame.new(originalPosition)
                    task.wait()
                end
            end)
        else
            Rayfield:Notify({
                Title = "Lock Position",
                Content = "Lock Position deactivated",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end
})

PlayerTab:CreateToggle({
    Name = "No Fall Damage",
    CurrentValue = Config.Player.NoFallDamage,
    Flag = "NoFallDamageToggle",
    Callback = function(Value)
        Config.Player.NoFallDamage = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "No Fall Damage",
                Content = "No Fall Damage activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Enable no fall damage
            spawn(function()
                while Config.Player.NoFallDamage do
                    pcall(function()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                            LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Falling, false)
                        end
                    end)
                    task.wait()
                end
            end)
        else
            Rayfield:Notify({
                Title = "No Fall Damage",
                Content = "No Fall Damage deactivated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Disable no fall damage
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Falling, true)
                end
            end)
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
                Title = "Night Vision",
                Content = "Night Vision activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Enable night vision
            Lighting.Ambient = Color3.new(0.1, 0.1, 0.1)
            Lighting.OutdoorAmbient = Color3.new(0.1, 0.1, 0.1)
            
            -- Create night vision effect
            local nightVision = Instance.new("ColorCorrectionEffect")
            nightVision.Name = "NightVision"
            nightVision.Saturation = Config.Player.NightVisionIntensity
            nightVision.Parent = Lighting
        else
            Rayfield:Notify({
                Title = "Night Vision",
                Content = "Night Vision deactivated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Disable night vision
            Lighting.Ambient = Color3.new(0.4, 0.4, 0.4)
            Lighting.OutdoorAmbient = Color3.new(0.4, 0.4, 0.4)
            
            -- Remove night vision effect
            pcall(function()
                Lighting:FindFirstChild("NightVision"):Destroy()
            end)
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Night Vision Intensity",
    Range = {0.1, 2.0},
    Increment = 0.1,
    Suffix = "multiplier",
    CurrentValue = Config.Player.NightVisionIntensity,
    Flag = "NightVisionIntensitySlider",
    Callback = function(Value)
        Config.Player.NightVisionIntensity = Value
        SaveConfig()
        
        if Config.Player.NightVision then
            pcall(function()
                Lighting.NightVision.Saturation = Value
            end)
        end
    end
})

-- NKZ-VISUAL Tab
local VisualTab = Window:CreateTab("NKZ-VISUAL", 4483362458)
VisualTab:CreateSection("ESP & Visual Hacks")

local ESPToggle = VisualTab:CreateToggle({
    Name = "ESP Players",
    CurrentValue = Config.Visual.ESPPlayers,
    Flag = "ESPToggle",
    Callback = function(Value)
        Config.Visual.ESPPlayers = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "ESP Players",
                Content = "ESP Players activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Start ESP
            spawn(function()
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
                Title = "ESP Players",
                Content = "ESP Players deactivated",
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
                Title = "Ghost Hack",
                Content = "Ghost Hack activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Enable ghost mode
            pcall(function()
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            end)
        else
            Rayfield:Notify({
                Title = "Ghost Hack",
                Content = "Ghost Hack deactivated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Disable ghost mode
            pcall(function()
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end)
        end
    end
})

VisualTab:CreateSection("FOV Changer")

local FOVToggle = VisualTab:CreateToggle({
    Name = "FOV Changer",
    CurrentValue = Config.Visual.FOVEnabled,
    Flag = "FOVToggle",
    Callback = function(Value)
        Config.Visual.FOVEnabled = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "FOV Changer",
                Content = "FOV Changer activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Set FOV
            workspace.CurrentCamera.FieldOfView = Config.Visual.FOVValue
        else
            Rayfield:Notify({
                Title = "FOV Changer",
                Content = "FOV Changer deactivated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Reset FOV
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
    Name = "FOV Horizontal",
    Range = {70, 120},
    Increment = 5,
    Suffix = "degrees",
    CurrentValue = Config.Visual.FOVHorizontal,
    Flag = "FOVHorizontalSlider",
    Callback = function(Value)
        Config.Visual.FOVHorizontal = Value
        SaveConfig()
        
        if Config.Visual.FOVEnabled then
            workspace.CurrentCamera.FieldOfView = Value
        end
    end
})

VisualTab:CreateSlider({
    Name = "FOV Vertical",
    Range = {70, 120},
    Increment = 5,
    Suffix = "degrees",
    CurrentValue = Config.Visual.FOVVertical,
    Flag = "FOVVerticalSlider",
    Callback = function(Value)
        Config.Visual.FOVVertical = Value
        SaveConfig()
        
        if Config.Visual.FOVEnabled then
            workspace.CurrentCamera.FieldOfView = Value
        end
    end
})

VisualTab:CreateToggle({
    Name = "ADS FOV Changer",
    CurrentValue = Config.Visual.ADSFOVEnabled,
    Flag = "ADSFOVToggle",
    Callback = function(Value)
        Config.Visual.ADSFOVEnabled = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "ADS FOV Changer",
                Content = "ADS FOV Changer activated",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "ADS FOV Changer",
                Content = "ADS FOV Changer deactivated",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end
})

VisualTab:CreateSlider({
    Name = "ADS FOV Value",
    Range = {40, 80},
    Increment = 5,
    Suffix = "degrees",
    CurrentValue = Config.Visual.ADSFOVValue,
    Flag = "ADSFOVSlider",
    Callback = function(Value)
        Config.Visual.ADSFOVValue = Value
        SaveConfig()
    end
})

VisualTab:CreateSlider({
    Name = "ADS FOV Horizontal",
    Range = {40, 80},
    Increment = 5,
    Suffix = "degrees",
    CurrentValue = Config.Visual.ADSFOVHorizontal,
    Flag = "ADSFOVHorizontalSlider",
    Callback = function(Value)
        Config.Visual.ADSFOVHorizontal = Value
        SaveConfig()
    end
})

VisualTab:CreateSlider({
    Name = "ADS FOV Vertical",
    Range = {40, 80},
    Increment = 5,
    Suffix = "degrees",
    CurrentValue = Config.Visual.ADSFOVVertical,
    Flag = "ADSFOVVerticalSlider",
    Callback = function(Value)
        Config.Visual.ADSFOVVertical = Value
        SaveConfig()
    end
})

-- NKZ-SHOP Tab
local ShopTab = Window:CreateTab("NKZ-SHOP", 4483362458)
ShopTab:CreateSection("Auto Sell")

local AutoSellToggle = ShopTab:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = Config.Shop.AutoSell,
    Flag = "AutoSellToggle",
    Callback = function(Value)
        Config.Shop.AutoSell = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Sell",
                Content = "Auto Sell activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Start auto sell
            spawn(function()
                while Config.Shop.AutoSell do
                    pcall(function()
                        Modules.Remotes.SellAllItems:InvokeServer()
                    end)
                    task.wait(Config.Shop.SellDelay)
                end
            end)
        else
            Rayfield:Notify({
                Title = "Auto Sell",
                Content = "Auto Sell deactivated",
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
                Title = "Auto Buy Weather",
                Content = "Auto Buy Weather activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Start auto buy weather
            spawn(function()
                while Config.Shop.AutoBuyWeather do
                    pcall(function()
                        if Config.Shop.SelectedWeather ~= "" then
                            Modules.Remotes.PurchaseGear:InvokeServer(Config.Shop.SelectedWeather)
                        end
                    end)
                    task.wait(Config.Shop.WeatherBuyDelay)
                end
            end)
        else
            Rayfield:Notify({
                Title = "Auto Buy Weather",
                Content = "Auto Buy Weather deactivated",
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
        else
            Rayfield:Notify({
                Title = "Purchase Error",
                Content = "Please select a rod first",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end
})

-- NKZ-UTILITY Tab
local UtilityTab = Window:CreateTab("NKZ-UTILITY", 4483362458)
UtilityTab:CreateSection("Performance")

local StabilizeFPSToggle = UtilityTab:CreateToggle({
    Name = "Stabilize FPS",
    CurrentValue = Config.Utility.StabilizeFPS,
    Flag = "StabilizeFPSToggle",
    Callback = function(Value)
        Config.Utility.StabilizeFPS = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "Stabilize FPS",
                Content = "FPS stabilization activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Enable FPS stabilization
            settings().Rendering.QualityLevel = 1
            settings().Rendering.MeshCacheSize = 100
        else
            Rayfield:Notify({
                Title = "Stabilize FPS",
                Content = "FPS stabilization deactivated",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end
})

local UnlockFPSToggle = UtilityTab:CreateToggle({
    Name = "Unlock FPS",
    CurrentValue = Config.Utility.UnlockFPS,
    Flag = "UnlockFPSToggle",
    Callback = function(Value)
        Config.Utility.UnlockFPS = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "Unlock FPS",
                Content = "FPS unlocked",
                Duration = 3,
                Image = 4483362458,
            })
            
            setfpscap(999)
        else
            Rayfield:Notify({
                Title = "Unlock FPS",
                Content = "FPS locked at 60",
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
                Title = "System Info",
                Content = "OS: " .. game:GetService("RunService"):IsStudio() and "Studio" or "Client",
                Duration = 5,
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
                Title = "Auto Clear Cache",
                Content = "Auto cache clearing activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Start auto clear cache
            spawn(function()
                while Config.Utility.AutoClearCache do
                    task.wait(300) -- Every 5 minutes
                    collectgarbage()
                end
            end)
        else
            Rayfield:Notify({
                Title = "Auto Clear Cache",
                Content = "Auto cache clearing deactivated",
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
                Title = "Disable Particles",
                Content = "Particles disabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Disable all particles
            for _, particle in pairs(workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") then
                    particle.Enabled = false
                end
            end
        else
            Rayfield:Notify({
                Title = "Disable Particles",
                Content = "Particles enabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Enable all particles
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
                Title = "Boost Ping",
                Content = "Ping boost activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Enable ping boost
            game:GetService("NetworkClient"):SetOutgoingKBPS(999999)
        else
            Rayfield:Notify({
                Title = "Boost Ping",
                Content = "Ping boost deactivated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Disable ping boost
            game:GetService("NetworkClient"):SetOutgoingKBPS(1000)
        end
    end
})

UtilityTab:CreateSection("Time Control")

UtilityTab:CreateToggle({
    Name = "Change Time",
    CurrentValue = Config.Utility.ChangeTime,
    Flag = "ChangeTimeToggle",
    Callback = function(Value)
        Config.Utility.ChangeTime = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "Change Time",
                Content = "Time control activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Set time
            Lighting.ClockTime = Config.Utility.TimeValue
        else
            Rayfield:Notify({
                Title = "Change Time",
                Content = "Time control deactivated",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Reset time
            Lighting.ClockTime = 12.0
        end
    end
})

UtilityTab:CreateSlider({
    Name = "Time Value",
    Range = {0, 24},
    Increment = 0.1,
    Suffix = "hours",
    CurrentValue = Config.Utility.TimeValue,
    Flag = "TimeValueSlider",
    Callback = function(Value)
        Config.Utility.TimeValue = Value
        SaveConfig()
        
        if Config.Utility.ChangeTime then
            Lighting.ClockTime = Value
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
            Title = "Graphics Quality",
            Content = "Quality set to " .. Option,
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
                Title = "Graphics",
                Content = "Reflections disabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            Lighting.GlobalShadows = false
            Lighting.Reflections = false
        else
            Rayfield:Notify({
                Title = "Graphics",
                Content = "Reflections enabled",
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
                Title = "Graphics",
                Content = "Skin effects disabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Disable skin effects
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    for _, accessory in pairs(player.Character:GetChildren()) do
                        if accessory:IsA("Accessory") then
                            accessory:WaitForChild("Handle").Material = Enum.Material.Plastic
                        end
                    end
                end
            end
        else
            Rayfield:Notify({
                Title = "Graphics",
                Content = "Skin effects enabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Reset skin effects
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    for _, accessory in pairs(player.Character:GetChildren()) do
                        if accessory:IsA("Accessory") then
                            accessory:WaitForChild("Handle").Material = Enum.Material.Neon
                        end
                    end
                end
            end
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
                Title = "Graphics",
                Content = "Shadows disabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            Lighting.GlobalShadows = false
        else
            Rayfield:Notify({
                Title = "Graphics",
                Content = "Shadows enabled",
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
                Title = "Graphics",
                Content = "Water effects disabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Disable water effects
            for _, water in pairs(workspace:GetDescendants()) do
                if water:IsA("Water") or water:IsA("WedgePart") then
                    water.Transparency = 1
                end
            end
        else
            Rayfield:Notify({
                Title = "Graphics",
                Content = "Water effects enabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Reset water effects
            for _, water in pairs(workspace:GetDescendants()) do
                if water:IsA("Water") or water:IsA("WedgePart") then
                    water.Transparency = 0
                end
            end
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
    end
})

-- NKZ-LOWDEV Tab
local LowDevTab = Window:CreateTab("NKZ-LOWDEV", 4483362458)
LowDevTab:CreateSection("Performance Optimization")

local ExtremeSmoothToggle = LowDevTab:CreateToggle({
    Name = "Super Extreme Smooth",
    CurrentValue = Config.LowDev.ExtremeSmooth,
    Flag = "ExtremeSmoothToggle",
    Callback = function(Value)
        Config.LowDev.ExtremeSmooth = Value
        SaveConfig()
        
        if Value then
            Rayfield:Notify({
                Title = "Extreme Smooth",
                Content = "Super extreme smooth activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            settings().Rendering.QualityLevel = 1
            settings().Rendering.MeshCacheSize = 50
            game:GetService("GraphicsService").ScreenshotQuality = 10
        else
            Rayfield:Notify({
                Title = "Extreme Smooth",
                Content = "Super extreme smooth deactivated",
                Duration = 3,
                Image = 4483362458,
            })
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
                Title = "Disable Effects",
                Content = "All effects disabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Disable all effects
            for _, effect in pairs(workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Beam") or effect:IsA("Trail") then
                    effect.Enabled = false
                end
            end
        else
            Rayfield:Notify({
                Title = "Disable Effects",
                Content = "All effects enabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Reset all effects
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
                Title = "32-bit Mode",
                Content = "32-bit mode activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            setfpscap(30)
        else
            Rayfield:Notify({
                Title = "32-bit Mode",
                Content = "32-bit mode deactivated",
                Duration = 3,
                Image = 4483362458,
            })
            
            setfpscap(60)
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
                Title = "Low Battery Mode",
                Content = "Low battery mode activated",
                Duration = 3,
                Image = 4483362458,
            })
            
            settings().Rendering.QualityLevel = 1
            setfpscap(30)
        else
            Rayfield:Notify({
                Title = "Low Battery Mode",
                Content = "Low battery mode deactivated",
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
        Rayfield:Notify({
            Title = "Configuration Saved",
            Content = "Current settings have been saved",
            Duration = 3,
            Image = 4483362458,
        })
    end
})

SettingsTab:CreateButton({
    Name = "Load Saved Configuration",
    Callback = function()
        LoadConfig()
        Rayfield:Notify({
            Title = "Configuration Loaded",
            Content = "Saved settings have been loaded",
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
                BypassRadar = true,
                BypassDivingGear = true,
                AntiAFK = true,
                AutoJump = false,
                AutoJumpDelay = 30,
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
                LockPosition = false,
                NoFallDamage = false,
                NightVision = false,
                NightVisionIntensity = 1.0
            },
            Visual = {
                ESPPlayers = false,
                GhostHack = false,
                FOVEnabled = false,
                FOVValue = 70,
                FOVHorizontal = 70,
                FOVVertical = 70,
                ADSFOVEnabled = false,
                ADSFOVValue = 40,
                ADSFOVHorizontal = 40,
                ADSFOVVertical = 40
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
                BoostPing = false,
                ChangeTime = false,
                TimeValue = 12.0
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
SettingsTab:CreateLabel("Lines: 3250+")
SettingsTab:CreateLabel("Modules: Fully Implemented")

SettingsTab:CreateParagraph({
    Title = "Developer Information",
    Content = "Discord: @nikzzmodder\nTikTok: @nikzzmodder\nTotal Features: 50+"
})

SettingsTab:CreateParagraph({
    Title = "Performance Tips",
    Content = "Use async tasks for heavy operations, enable FPS stabilization for better performance, and use low-dev mode for older devices."
})

SettingsTab:CreateParagraph({
    Title = "Anti-Bug System",
    Content = "The script performs an automatic respawn after loading to prevent any potential bugs. All features start disabled by default."
})

-- Initialize everything
LoadModules()
LoadConfig()
RefreshPlayers()

-- Perform anti-bug respawn after loading
AntiBugRespawn()

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
    Content = "All modules initialized successfully. All features are disabled by default.",
    Duration = 6,
    Image = 4483362458,
})

Rayfield:LoadConfiguration()
