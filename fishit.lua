-- Fish It Script for Roblox (September 2025)
-- Created with Rayfield Library + Async System
-- Supports: Delta, Codex, Hydrogen, Arceus X, Fluxus, Synapse X, Script-Ware, Solara

-- Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")

-- Player
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Game Modules
local FishItModules = ReplicatedStorage:WaitForChild("Modules")
local FishItRemotes = ReplicatedStorage:WaitForChild("Remotes")
local FishItEvents = ReplicatedStorage:WaitForChild("Events")

-- Remote Events & Functions
local CastLineRemote = FishItRemotes:WaitForChild("CastLine")
local ReelInRemote = FishItRemotes:WaitForChild("ReelIn")
local SellFishRemote = FishItRemotes:WaitForChild("SellFish")
local BuyItemRemote = FishItRemotes:WaitForChild("BuyItem")
local EquipItemRemote = FishItRemotes:WaitForChild("EquipItem")
local TeleportRemote = FishItRemotes:WaitForChild("Teleport")
local TradeRemote = FishItRemotes:WaitForChild("Trade")
local WeatherRemote = FishItRemotes:WaitForChild("Weather")

-- Module Scripts
local PlayerData = require(FishItModules:WaitForChild("PlayerData"))
local FishData = require(FishItModules:WaitForChild("FishData"))
local RodData = require(FishItModules:WaitForChild("RodData"))
local BaitData = require(FishItModules:WaitForChild("BaitData"))
local BoatData = require(FishItModules:WaitForChild("BoatData"))
local MapData = require(FishItModules:WaitForChild("MapData"))
local RNGSystem = require(FishItModules:WaitForChild("RNGSystem"))

-- Variables
local autoFishEnabled = false
local waterFishEnabled = false
local bypassRadarEnabled = false
local bypassAirEnabled = false
local disableEffectFishingEnabled = false
local autoInstantComplicatedFishingEnabled = false
local autoSellFishEnabled = false
local sellMythicalAndSecret = false
local delayFishSell = 1
local antiKickEnabled = false
local antiDetectEnabled = false
local antiAFKEnabled = false
local speedHackEnabled = false
local speedHackValue = 50
local maxBoatSpeedEnabled = false
local infinityJumpEnabled = false
local flyEnabled = false
local flyValue = 50
local flyBoatEnabled = false
local ghostHackEnabled = false
local espLinesEnabled = false
local espBoxEnabled = false
local espRangeEnabled = false
local espLevelEnabled = false
local espHologramEnabled = false
local autoAcceptTradeEnabled = false
local autoBuyWeatherEnabled = false
local boostFPSEnabled = false
local fpsValue = 60
local autoCleanMemoryEnabled = false
local highQualityEnabled = false
local maxRenderingEnabled = false
local ultraLowModeEnabled = false
local disableWaterReflectionEnabled = false
local customShaderEnabled = false
local rngReducerEnabled = false
local forceLegendaryCatchEnabled = false
local secretFishBoostEnabled = false
local mythicalChanceEnabled = false
local antiBadLuckEnabled = false

-- Saved Positions
local savedPositions = {}

-- ESP Objects
local espObjects = {}

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Fish It Hub | September 2025",
    LoadingTitle = "Fish It Script",
    LoadingSubtitle = "by Scripter",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FishItHub",
        FileName = "FishItConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Fish It Hub",
        Subtitle = "Key System",
        Note = "No key needed",
        FileName = "FishItKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"FishIt2025"}
    }
})

-- Create Tabs
local FishFarmTab = Window:CreateTab("Fish Farm", 4483362458)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local TraderTab = Window:CreateTab("Trader", 4483362458)
local ServerTab = Window:CreateTab("Server", 4483362458)
local SystemTab = Window:CreateTab("System", 4483362458)
local GraphicTab = Window:CreateTab("Graphic", 4483362458)
local RNGKillTab = Window:CreateTab("RNG Kill", 4483362458)
local ShopTab = Window:CreateTab("Shop", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- Fish Farm Tab
local FishFarmSection = FishFarmTab:CreateSection("Fish Farm")

-- Auto Fish
local AutoFishToggle = FishFarmTab:CreateToggle({
    Name = "Auto Fish",
    CurrentValue = false,
    Flag = "AutoFish",
    Callback = function(Value)
        autoFishEnabled = Value
        if autoFishEnabled then
            task.spawn(function()
                while autoFishEnabled do
                    if player.Character and player.Character:FindFirstChildOfClass("Tool") then
                        local tool = player.Character:FindFirstChildOfClass("Tool")
                        if tool.Name:find("Rod") or tool.Name:find("rod") then
                            -- Cast line
                            CastLineRemote:FireServer()
                            task.wait(0.5)
                            
                            -- Auto reel when fish caught
                            local connection
                            connection = game.Workspace.ChildAdded:Connect(function(child)
                                if child.Name == "Fish" and autoFishEnabled then
                                    task.wait(0.2)
                                    ReelInRemote:FireServer()
                                    connection:Disconnect()
                                end                            end)
                            
                            task.wait(2)
                        else
                            task.wait(1)
                        end
                    else
                        task.wait(1)
                    end
                end
            end)
        end
    end,
})

-- Water Fish
local WaterFishToggle = FishFarmTab:CreateToggle({
    Name = "Water Fish",
    CurrentValue = false,
    Flag = "WaterFish",
    Callback = function(Value)
        waterFishEnabled = Value
        if waterFishEnabled then
            task.spawn(function()
                while waterFishEnabled do
                    if player.Character and player.Character:FindFirstChildOfClass("Tool") then
                        local tool = player.Character:FindFirstChildOfClass("Tool")
                        if tool.Name:find("Rod") or tool.Name:find("rod") then
                            -- Modify cast position to always hit water
                            local oldCastLine = CastLineRemote.FireServer
                            CastLineRemote.FireServer = function(self, ...)
                                local args = {...}
                                if #args == 0 then
                                    args = {CFrame.new(0, -100, 0)}
                                end
                                return oldCastLine(self, unpack(args))
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end,
})

-- Bypass Radar
local BypassRadarToggle = FishFarmTab:CreateToggle({
    Name = "Bypass Radar",
    CurrentValue = false,
    Flag = "BypassRadar",
    Callback = function(Value)
        bypassRadarEnabled = Value
        if bypassRadarEnabled then
            task.spawn(function()
                while bypassRadarEnabled do
                    -- Check if player has radar
                    local hasRadar = false
                    for _, item in pairs(player.Backpack:GetChildren()) do
                        if item.Name:find("Radar") or item.Name:find("radar") then
                            hasRadar = true
                            break
                        end
                    end
                    
                    -- If no radar, buy one
                    if not hasRadar then
                        BuyItemRemote:FireServer("Radar", 1)
                    end
                    
                    -- Activate radar
                    if player.Backpack:FindFirstChild("Radar") then
                        player.Backpack.Radar.Parent = player.Character
                    end
                    
                    task.wait(5)
                end
            end)
        end
    end,
})

-- Bypass Air
local BypassAirToggle = FishFarmTab:CreateToggle({
    Name = "Bypass Air",
    CurrentValue = false,
    Flag = "BypassAir",
    Callback = function(Value)
        bypassAirEnabled = Value
        if bypassAirEnabled then
            task.spawn(function()
                while bypassAirEnabled do
                    -- Check if player has air item
                    local hasAirItem = false
                    for _, item in pairs(player.Backpack:GetChildren()) do
                        if item.Name:find("Air") or item.Name:find("Scuba") or item.Name:find("Oxygen") then
                            hasAirItem = true
                            break
                        end
                    end
                    
                    -- If no air item, buy one
                    if not hasAirItem then
                        BuyItemRemote:FireServer("ScubaGear", 1)
                    end
                    
                    -- Activate air item
                    if player.Backpack:FindFirstChild("ScubaGear") then
                        player.Backpack.ScubaGear.Parent = player.Character
                    end
                    
                    task.wait(5)
                end
            end)
        end
    end,
})

-- Disable Effect Fishing
local DisableEffectFishingToggle = FishFarmTab:CreateToggle({
    Name = "Disable Effect Fishing",
    CurrentValue = false,
    Flag = "DisableEffectFishing",
    Callback = function(Value)
        disableEffectFishingEnabled = Value
        if disableEffectFishingEnabled then
            -- Disable particle effects
            for _, particle in pairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") then
                    particle.Enabled = false
                end
            end
            
            -- Disable beam effects
            for _, beam in pairs(Workspace:GetDescendants()) do
                if beam:IsA("Beam") then
                    beam.Enabled = false
                end
            end
            
            -- Disable point light effects
            for _, light in pairs(Workspace:GetDescendants()) do
                if light:IsA("PointLight") then
                    light.Enabled = false
                end
            end
        else
            -- Re-enable effects
            for _, particle in pairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") then
                    particle.Enabled = true
                end
            end
            
            for _, beam in pairs(Workspace:GetDescendants()) do
                if beam:IsA("Beam") then
                    beam.Enabled = true
                end
            end
            
            for _, light in pairs(Workspace:GetDescendants()) do
                if light:IsA("PointLight") then
                    light.Enabled = true
                end
            end
        end
    end,
})

-- Auto Instant Complicated Fishing
local AutoInstantComplicatedFishingToggle = FishFarmTab:CreateToggle({
    Name = "Auto Instant Complicated Fishing",
    CurrentValue = false,
    Flag = "AutoInstantComplicatedFishing",
    Callback = function(Value)
        autoInstantComplicatedFishingEnabled = Value
        if autoInstantComplicatedFishingEnabled then
            -- Modify fishing mechanics to make it instant
            local oldReelIn = ReelInRemote.FireServer
            ReelInRemote.FireServer = function(self, ...)
                local args = {...}
                if #args == 0 then
                    args = {true}  -- Force instant catch
                end
                return oldReelIn(self, unpack(args))
            end
        end
    end,
})

-- Auto Sell Fish
local AutoSellFishToggle = FishFarmTab:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = false,
    Flag = "AutoSellFish",
    Callback = function(Value)
        autoSellFishEnabled = Value
        if autoSellFishEnabled then
            task.spawn(function()
                while autoSellFishEnabled do
                    -- Get player's fish inventory
                    local playerData = PlayerData.GetPlayerData(player.UserId)
                    local fishInventory = playerData.FishInventory or {}
                    
                    -- Sell all fish except favorites
                    for fishName, fishData in pairs(fishInventory) do
                        if not fishData.Favorite and (sellMythicalAndSecret or not (fishData.Rarity == "Mythical" or fishData.Rarity == "Secret")) then
                            SellFishRemote:FireServer(fishName, fishData.Amount)
                            task.wait(delayFishSell)
                        end
                    end
                    
                    task.wait(5)
                end
            end)
        end
    end,
})

-- Sell Mythical and Secret
local SellMythicalSecretToggle = FishFarmTab:CreateToggle({
    Name = "Sell Mythical & Secret",
    CurrentValue = false,
    Flag = "SellMythicalSecret",
    Callback = function(Value)
        sellMythicalAndSecret = Value
    end,
})

-- Delay Fish Sell
local DelayFishSellSlider = FishFarmTab:CreateSlider({
    Name = "Delay Fish Sell",
    Range = {0, 10},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 1,
    Flag = "DelayFishSell",
    Callback = function(Value)
        delayFishSell = Value
    end,
})

-- Anti Kick Server
local AntiKickToggle = FishFarmTab:CreateToggle({
    Name = "Anti Kick Server",
    CurrentValue = false,
    Flag = "AntiKick",
    Callback = function(Value)
        antiKickEnabled = Value
        if antiKickEnabled then
            task.spawn(function()
                while antiKickEnabled do
                    -- Send a heartbeat to prevent kick
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                        "/e "..tostring(math.random(1, 1000)), 
                        "All"
                    )
                    task.wait(300)  -- Every 5 minutes
                end
            end)
        end
    end,
})

-- Anti Detect System
local AntiDetectToggle = FishFarmTab:CreateToggle({
    Name = "Anti Detect System",
    CurrentValue = false,
    Flag = "AntiDetect",
    Callback = function(Value)
        antiDetectEnabled = Value
        if antiDetectEnabled then
            -- Hide script execution from anti-cheat
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                if method == "FireServer" and tostring(self) == "AntiCheat" then
                    return nil
                end
                return oldNamecall(self, ...)
            end)
        end
    end,
})

-- Anti AFK & Auto Jump
local AntiAFKToggle = FishFarmTab:CreateToggle({
    Name = "Anti AFK & Auto Jump",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        antiAFKEnabled = Value
        if antiAFKEnabled then
            task.spawn(function()
                while antiAFKEnabled do
                    -- Press jump key
                    VirtualInputManager:SendKeyEvent(true, "Space", false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, "Space", false, game)
                    
                    -- Move mouse slightly
                    VirtualInputManager:SendMouseMoveEvent(1, 1)
                    
                    task.wait(30)  -- Every 30 seconds
                end
            end)
        end
    end,
})

-- Teleport Tab
local TeleportSection = TeleportTab:CreateSection("Teleport")

-- Teleport Maps
local mapsDropdown = {}
for mapName, mapData in pairs(MapData.Maps) do
    table.insert(mapsDropdown, mapName)
end

local TeleportMapsDropdown = TeleportTab:CreateDropdown({
    Name = "Teleport Maps",
    Options = mapsDropdown,
    CurrentOption = "Select Map",
    Flag = "TeleportMaps",
    Callback = function(Option)
        local mapData = MapData.Maps[Option]
        if mapData then
            TeleportRemote:FireServer(mapData.TeleportPosition)
        end
    end,
})

-- Teleport Player
local playersDropdown = {}
local function updatePlayerList()
    playersDropdown = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            table.insert(playersDropdown, plr.Name)
        end
    end
end

updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

local TeleportPlayerDropdown = TeleportTab:CreateDropdown({
    Name = "Teleport Player",
    Options = playersDropdown,
    CurrentOption = "Select Player",
    Flag = "TeleportPlayer",
    Callback = function(Option)
        local targetPlayer = Players:FindFirstChild(Option)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            rootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        end
    end,
})

-- Teleport Event
local eventsDropdown = {}
local function updateEventList()
    eventsDropdown = {}
    for _, event in pairs(Workspace.Events:GetChildren()) do
        if event:IsA("Model") and event:FindFirstChild("TeleportPart") then
            table.insert(eventsDropdown, event.Name)
        end
    end
end

updateEventList()
Workspace.Events.ChildAdded:Connect(updateEventList)
Workspace.Events.ChildRemoved:Connect(updateEventList)

local TeleportEventDropdown = TeleportTab:CreateDropdown({
    Name = "Teleport Event",
    Options = eventsDropdown,
    CurrentOption = "Select Event",
    Flag = "TeleportEvent",
    Callback = function(Option)
        local event = Workspace.Events:FindFirstChild(Option)
        if event and event:FindFirstChild("TeleportPart") then
            rootPart.CFrame = event.TeleportPart.CFrame
        end
    end,
})

-- Save Position
local SavePositionButton = TeleportTab:CreateButton({
    Name = "Save Position",
    Callback = function()
        local positionName = "Position "..#savedPositions + 1
        savedPositions[positionName] = rootPart.CFrame
        Rayfield:Notify({
            Title = "Position Saved",
            Content = "Saved position as "..positionName,
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Load Position
local loadPositionsDropdown = {}
local function updatePositionList()
    loadPositionsDropdown = {}
    for posName, _ in pairs(savedPositions) do
        table.insert(loadPositionsDropdown, posName)
    end
end

local LoadPositionDropdown = TeleportTab:CreateDropdown({
    Name = "Load Position",
    Options = loadPositionsDropdown,
    CurrentOption = "Select Position",
    Flag = "LoadPosition",
    Callback = function(Option)
        if savedPositions[Option] then
            rootPart.CFrame = savedPositions[Option]
            Rayfield:Notify({
                Title = "Position Loaded",
                Content = "Teleported to "..Option,
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Delete Position
local DeletePositionDropdown = TeleportTab:CreateDropdown({
    Name = "Delete Position",
    Options = loadPositionsDropdown,
    CurrentOption = "Select Position",
    Flag = "DeletePosition",
    Callback = function(Option)
        if savedPositions[Option] then
            savedPositions[Option] = nil
            updatePositionList()
            Rayfield:Notify({
                Title = "Position Deleted",
                Content = "Deleted "..Option,
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Player Tab
local PlayerSection = PlayerTab:CreateSection("Player")

-- Speed Hack
local SpeedHackToggle = PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHack",
    Callback = function(Value)
        speedHackEnabled = Value
        if speedHackEnabled then
            humanoid.WalkSpeed = speedHackValue
        else
            humanoid.WalkSpeed = 16
        end
    end,
})

-- Speed Hack Setting
local SpeedHackSlider = PlayerTab:CreateSlider({
    Name = "Speed Hack Setting",
    Range = {0, 500},
    Increment = 1,
    Suffix = "",
    CurrentValue = 50,
    Flag = "SpeedHackValue",
    Callback = function(Value)
        speedHackValue = Value
        if speedHackEnabled then
            humanoid.WalkSpeed = speedHackValue
        end
    end,
})

-- Max Boat Speed
local MaxBoatSpeedToggle = PlayerTab:CreateToggle({
    Name = "Max Boat Speed",
    CurrentValue = false,
    Flag = "MaxBoatSpeed",
    Callback = function(Value)
        maxBoatSpeedEnabled = Value
        if maxBoatSpeedEnabled then
            task.spawn(function()
                while maxBoatSpeedEnabled do
                    local boat = Workspace.Boats:FindFirstChild(player.Name.."'s Boat")
                    if boat and boat:FindFirstChild("DriveSeat") then
                        local driveSeat = boat.DriveSeat
                        if driveSeat:FindFirstChild("Configuration") then
                            driveSeat.Configuration.MaxSpeed.Value = 1000
                            driveSeat.Configuration.Torque.Value = 1000
                        end
                    end
                    task.wait(5)
                end
            end)
        end
    end,
})

-- Spawn Boat
local SpawnBoatButton = PlayerTab:CreateButton({
    Name = "Spawn Boat",
    Callback = function()
        local playerData = PlayerData.GetPlayerData(player.UserId)
        local ownedBoats = playerData.OwnedBoats or {}
        
        -- Find the best boat owned by player
        local bestBoat = nil
        local bestBoatLevel = 0
        
        for boatName, boatLevel in pairs(ownedBoats) do
            if boatLevel > bestBoatLevel then
                bestBoatLevel = boatLevel
                bestBoat = boatName
            end
        end
        
        if bestBoat then
            BuyItemRemote:FireServer("SpawnBoat", bestBoat)
            Rayfield:Notify({
                Title = "Boat Spawned",
                Content = "Spawned "..bestBoat,
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "No Boat Owned",
                Content = "You don't own any boats",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Infinity Jump
local InfinityJumpToggle = PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Flag = "InfinityJump",
    Callback = function(Value)
        infinityJumpEnabled = Value
        if infinityJumpEnabled then
            local connection
            connection = UserInputService.JumpRequest:Connect(function()
                if infinityJumpEnabled then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end,
})

-- Fly
local FlyToggle = PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        flyEnabled = Value
        if flyEnabled then
            local flyVelocity = Instance.new("BodyVelocity")
            flyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            flyVelocity.P = 1000
            flyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyVelocity.Parent = rootPart
            
            local flyGyro = Instance.new("BodyGyro")
            flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            flyGyro.P = 1000
            flyGyro.CFrame = rootPart.CFrame
            flyGyro.Parent = rootPart
            
            task.spawn(function()
                while flyEnabled do
                    local moveDirection = humanoid.MoveDirection
                    flyVelocity.Velocity = Vector3.new(
                        moveDirection.X * flyValue,
                        UserInputService:IsKeyDown(Enum.KeyCode.Space) and flyValue or 
                        UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -flyValue or 0,
                        moveDirection.Z * flyValue
                    )
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        flyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + rootPart.CFrame.LookVector)
                    elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        flyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position - rootPart.CFrame.LookVector)
                    elseif UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        flyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position - rootPart.CFrame.RightVector)
                    elseif UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        flyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + rootPart.CFrame.RightVector)
                    end
                    
                    task.wait()
                end
                
                flyVelocity:Destroy()
                flyGyro:Destroy()
            end)
        end
    end,
})

-- Fly Settings
local FlySettingsSlider = PlayerTab:CreateSlider({
    Name = "Fly Settings",
    Range = {0, 200},
    Increment = 1,
    Suffix = "",
    CurrentValue = 50,
    Flag = "FlyValue",
    Callback = function(Value)
        flyValue = Value
    end,
})

-- Fly Boat
local FlyBoatToggle = PlayerTab:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = false,
    Flag = "FlyBoat",
    Callback = function(Value)
        flyBoatEnabled = Value
        if flyBoatEnabled then
            task.spawn(function()
                while flyBoatEnabled do
                    local boat = Workspace.Boats:FindFirstChild(player.Name.."'s Boat")
                    if boat and boat:FindFirstChild("PrimaryPart") then
                        boat.PrimaryPart.Velocity = Vector3.new(0, 50, 0)
                    end
                    task.wait(0.1)
                end
            end)
        end
    end,
})

-- Ghost Hack
local GhostHackToggle = PlayerTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = false,
    Flag = "GhostHack",
    Callback = function(Value)
        ghostHackEnabled = Value
        if ghostHackEnabled then
            -- Make player transparent
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0.5
                    part.CanCollide = false
                end
            end
            
            -- Disable name tag
            if character:FindFirstChild("Head") and character.Head:FindFirstChild("NameTag") then
                character.Head.NameTag.Enabled = false
            end
        else
            -- Restore player visibility
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                    part.CanCollide = true
                end
            end
            
            -- Enable name tag
            if character:FindFirstChild("Head") and character.Head:FindFirstChild("NameTag") then
                character.Head.NameTag.Enabled = true
            end
        end
    end,
})

-- ESP Config Section
local ESPSection = PlayerTab:CreateSection("ESP Config")

-- ESP Lines
local ESPLinesToggle = PlayerTab:CreateToggle({
    Name = "ESP Lines",
    CurrentValue = false,
    Flag = "ESPLines",
    Callback = function(Value)
        espLinesEnabled = Value
        if espLinesEnabled then
            task.spawn(function()
                while espLinesEnabled do
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            if not espObjects[plr.Name] then
                                espObjects[plr.Name] = {}
                            end
                            
                            if not espObjects[plr.Name].Line then
                                local line = Instance.new("Beam")
                                line.Attachment0 = Instance.new("Attachment", rootPart)
                                line.Attachment1 = Instance.new("Attachment", plr.Character.HumanoidRootPart)
                                line.Width0 = 0.1
                                line.Width1 = 0.1
                                line.Color = ColorSequence.new(Color3.new(1, 0, 0))
                                line.FaceCamera = true
                                line.Parent = Workspace
                                espObjects[plr.Name].Line = line
                            end
                        end
                    end
                    task.wait(1)
                end
                
                -- Clean up ESP lines
                for _, espData in pairs(espObjects) do
                    if espData.Line then
                        espData.Line:Destroy()
                    end
                end
                espObjects = {}
            end)
        end
    end,
})

-- ESP Box
local ESPBoxToggle = PlayerTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = false,
    Flag = "ESPBox",
    Callback = function(Value)
        espBoxEnabled = Value
        if espBoxEnabled then
            task.spawn(function()
                while espBoxEnabled do
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            if not espObjects[plr.Name] then
                                espObjects[plr.Name] = {}
                            end
                            
                            if not espObjects[plr.Name].Box then
                                local box = Instance.new("BoxHandleAdornment")
                                box.Size = plr.Character.HumanoidRootPart.Size * 1.5
                                box.Adornee = plr.Character.HumanoidRootPart
                                box.Color3 = Color3.new(1, 0, 0)
                                box.Transparency = 0.5
                                box.ZIndex = 10
                                box.AlwaysOnTop = true
                                box.Parent = plr.Character.HumanoidRootPart
                                espObjects[plr.Name].Box = box
                            end
                        end
                    end
                    task.wait(1)
                end
                
                -- Clean up ESP boxes
                for _, espData in pairs(espObjects) do
                    if espData.Box then
                        espData.Box:Destroy()
                    end
                end
                espObjects = {}
            end)
        end
    end,
})

-- ESP Range
local ESPRangeToggle = PlayerTab:CreateToggle({
    Name = "ESP Range",
    CurrentValue = false,
    Flag = "ESPRange",
    Callback = function(Value)
        espRangeEnabled = Value
        if espRangeEnabled then
            task.spawn(function()
                while espRangeEnabled do
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            if not espObjects[plr.Name] then
                                espObjects[plr.Name] = {}
                            end
                            
                            local distance = (rootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                            
                            if not espObjects[plr.Name].Range then
                                local billboard = Instance.new("BillboardGui")
                                billboard.Size = UDim2.new(0, 100, 0, 50)
                                billboard.StudsOffset = Vector3.new(0, 2, 0)
                                billboard.AlwaysOnTop = true
                                billboard.Parent = plr.Character.HumanoidRootPart
                                
                                local label = Instance.new("TextLabel")
                                label.Size = UDim2.new(1, 0, 1, 0)
                                label.BackgroundTransparency = 1
                                label.Text = math.floor(distance).."m"
                                label.TextColor3 = Color3.new(1, 1, 1)
                                label.TextStrokeTransparency = 0
                                label.TextScaled = true
                                label.Parent = billboard
                                
                                espObjects[plr.Name].Range = billboard
                            else
                                espObjects[plr.Name].Range.TextLabel.Text = math.floor(distance).."m"
                            end
                        end
                    end
                    task.wait(0.5)
                end
                
                -- Clean up ESP range
                for _, espData in pairs(espObjects) do
                    if espData.Range then
                        espData.Range:Destroy()
                    end
                end
                espObjects = {}
            end)
        end
    end,
})

-- ESP Level
local ESPLevelToggle = PlayerTab:CreateToggle({
    Name = "ESP Level",
    CurrentValue = false,
    Flag = "ESPLevel",
    Callback = function(Value)
        espLevelEnabled = Value
        if espLevelEnabled then
            task.spawn(function()
                while espLevelEnabled do
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            if not espObjects[plr.Name] then
                                espObjects[plr.Name] = {}
                            end
                            
                            local playerData = PlayerData.GetPlayerData(plr.UserId)
                            local level = playerData.Level or 1
                            
                            if not espObjects[plr.Name].Level then
                                local billboard = Instance.new("BillboardGui")
                                billboard.Size = UDim2.new(0, 100, 0, 50)
                                billboard.StudsOffset = Vector3.new(0, 3, 0)
                                billboard.AlwaysOnTop = true
                                billboard.Parent = plr.Character.HumanoidRootPart
                                
                                local label = Instance.new("TextLabel")
                                label.Size = UDim2.new(1, 0, 1, 0)
                                label.BackgroundTransparency = 1
                                label.Text = "Lvl "..level
                                label.TextColor3 = Color3.new(1, 1, 0)
                                label.TextStrokeTransparency = 0
                                label.TextScaled = true
                                label.Parent = billboard
                                
                                espObjects[plr.Name].Level = billboard
                            else
                                espObjects[plr.Name].Level.TextLabel.Text = "Lvl "..level
                            end
                        end
                    end
                    task.wait(1)
                end
                
                -- Clean up ESP level
                for _, espData in pairs(espObjects) do
                    if espData.Level then
                        espData.Level:Destroy()
                    end
                end
                espObjects = {}
            end)
        end
    end,
})

-- ESP Hologram
local ESPHologramToggle = PlayerTab:CreateToggle({
    Name = "ESP Hologram",
    CurrentValue = false,
    Flag = "ESPHologram",
    Callback = function(Value)
        espHologramEnabled = Value
        if espHologramEnabled then
            task.spawn(function()
                while espHologramEnabled do
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            if not espObjects[plr.Name] then
                                espObjects[plr.Name] = {}
                            end
                            
                            if not espObjects[plr.Name].Hologram then
                                local hologram = Instance.new("SelectionBox")
                                hologram.Adornee = plr.Character.HumanoidRootPart
                                hologram.LineThickness = 0.05
                                hologram.Color3 = Color3.new(1, 0, 0)
                                hologram.SurfaceColor3 = Color3.new(1, 0, 0)
                                hologram.SurfaceTransparency = 0.8
                                hologram.Parent = plr.Character.HumanoidRootPart
                                
                                -- Rainbow effect
                                local hue = 0
                                local connection
                                connection = RunService.Heartbeat:Connect(function(deltaTime)
                                    if not espHologramEnabled then
                                        connection:Disconnect()
                                        return
                                    end
                                    
                                    hue = (hue + deltaTime * 2) % 1
                                    local color = Color3.fromHSV(hue, 1, 1)
                                    hologram.Color3 = color
                                    hologram.SurfaceColor3 = color
                                end)
                                
                                espObjects[plr.Name].Hologram = hologram
                            end
                        end
                    end
                    task.wait(1)
                end
                
                -- Clean up ESP hologram
                for _, espData in pairs(espObjects) do
                    if espData.Hologram then
                        espData.Hologram:Destroy()
                    end
                end
                espObjects = {}
            end)
        end
    end,
})

-- Trader Tab
local TraderSection = TraderTab:CreateSection("Trader")

-- Auto Accept Trade
local AutoAcceptTradeToggle = TraderTab:CreateToggle({
    Name = "Auto Accept Trade",
    CurrentValue = false,
    Flag = "AutoAcceptTrade",
    Callback = function(Value)
        autoAcceptTradeEnabled = Value
        if autoAcceptTradeEnabled then
            local connection
            connection = TradeRemote.OnClientEvent:Connect(function(action, data)
                if autoAcceptTradeEnabled and action == "TradeRequest" then
                    TradeRemote:FireServer("AcceptTrade", data.TradeId)
                end
            end)
        end
    end,
})

-- Select Fish
local fishDropdown = {}
for fishName, fishData in pairs(FishData.Fish) do
    table.insert(fishDropdown, fishName)
end

local SelectFishDropdown = TraderTab:CreateDropdown({
    Name = "Select Fish",
    Options = fishDropdown,
    CurrentOption = "Select Fish",
    Flag = "SelectFish",
    Callback = function(Option)
        -- Store selected fish for trading
        Rayfield.Flags.SelectedFish = Option
    end,
})

-- Select Player
local SelectPlayerDropdown = TraderTab:CreateDropdown({
    Name = "Select Player",
    Options = playersDropdown,
    CurrentOption = "Select Player",
    Flag = "SelectPlayer",
    Callback = function(Option)
        -- Store selected player for trading
        Rayfield.Flags.SelectPlayer = Option
    end,
})

-- Trade All Fish
local TradeAllFishButton = TraderTab:CreateButton({
    Name = "Trade All Fish",
    Callback = function()
        local selectedFish = Rayfield.Flags.SelectedFish
        local selectedPlayer = Rayfield.Flags.SelectPlayer
        
        if not selectedFish or selectedFish == "Select Fish" then
            Rayfield:Notify({
                Title = "No Fish Selected",
                Content = "Please select a fish to trade",
                Duration = 3,
                Image = 4483362458,
            })
            return
        end
        
        if not selectedPlayer or selectedPlayer == "Select Player" then
            Rayfield:Notify({
                Title = "No Player Selected",
                Content = "Please select a player to trade with",
                Duration = 3,
                Image = 4483362458,
            })
            return
        end
        
        local targetPlayer = Players:FindFirstChild(selectedPlayer)
        if not targetPlayer then
            Rayfield:Notify({
                Title = "Player Not Found",
                Content = selectedPlayer.." is not in the server",
                Duration = 3,
                Image = 4483362458,
            })
            return
        end
        
        -- Get player's fish inventory
        local playerData = PlayerData.GetPlayerData(player.UserId)
        local fishInventory = playerData.FishInventory or {}
        
        if not fishInventory[selectedFish] or fishInventory[selectedFish].Amount == 0 then
            Rayfield:Notify({
                Title = "No Fish to Trade",
                Content = "You don't have any "..selectedFish,
                Duration = 3,
                Image = 4483362458,
            })
            return
        end
        
        -- Send trade request
        TradeRemote:FireServer("RequestTrade", targetPlayer.UserId, selectedFish, fishInventory[selectedFish].Amount)
        
        Rayfield:Notify({
            Title = "Trade Request Sent",
            Content = "Sent trade request to "..selectedPlayer,
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Server Tab
local ServerSection = ServerTab:CreateSection("Server")

-- Select Weather
local weatherDropdown = {"Sunny", "Stormy", "Fog", "Night", "Event Weather"}

local SelectWeatherDropdown = ServerTab:CreateDropdown({
    Name = "Select Weather",
    Options = weatherDropdown,
    CurrentOption = "Sunny",
    Flag = "SelectWeather",
    Callback = function(Option)
        WeatherRemote:FireServer("ChangeWeather", Option)
    end,
})

-- Buy Weather
local BuyWeatherButton = ServerTab:CreateButton({
    Name = "Buy Weather",
    Callback = function()
        local selectedWeather = Rayfield.Flags.SelectWeather
        if selectedWeather and selectedWeather ~= "Sunny" then
            WeatherRemote:FireServer("BuyWeather", selectedWeather)
            Rayfield:Notify({
                Title = "Weather Purchased",
                Content = "Bought "..selectedWeather.." weather",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Auto Buy Weather
local AutoBuyWeatherToggle = ServerTab:CreateToggle({
    Name = "Auto Buy Weather",
    CurrentValue = false,
    Flag = "AutoBuyWeather",
    Callback = function(Value)
        autoBuyWeatherEnabled = Value
        if autoBuyWeatherEnabled then
            task.spawn(function()
                while autoBuyWeatherEnabled do
                    local selectedWeather = Rayfield.Flags.SelectWeather
                    if selectedWeather and selectedWeather ~= "Sunny" then
                        WeatherRemote:FireServer("BuyWeather", selectedWeather)
                    end
                    task.wait(300)  -- Every 5 minutes
                end
            end)
        end
    end,
})

-- Player Info
local PlayerInfoLabel = ServerTab:CreateLabel("Players Online: "..#Players:GetPlayers())

Players.PlayerAdded:Connect(function()
    PlayerInfoLabel:Set("Players Online: "..#Players:GetPlayers())
end)

Players.PlayerRemoving:Connect(function()
    PlayerInfoLabel:Set("Players Online: "..#Players:GetPlayers())
end)

-- Server Info
local serverData = PlayerData.GetServerData()
local ServerInfoLabel = ServerTab:CreateLabel("Server Luck: "..(serverData.Luck or "N/A").."% | Seed: "..(serverData.Seed or "N/A"))

-- System Tab
local SystemSection = SystemTab:CreateSection("System")

-- Show Info
local ShowInfoToggle = SystemTab:CreateToggle({
    Name = "Show Information",
    CurrentValue = false,
    Flag = "ShowInfo",
    Callback = function(Value)
        if Value then
            local infoGui = Instance.new("ScreenGui")
            infoGui.Name = "FishItInfo"
            infoGui.Parent = CoreGui
            infoGui.ResetOnSpawn = false
            
            local infoFrame = Instance.new("Frame")
            infoFrame.Size = UDim2.new(0, 200, 0, 150)
            infoFrame.Position = UDim2.new(0, 10, 0, 10)
            infoFrame.BackgroundColor3 = Color3.new(0, 0, 0)
            infoFrame.BackgroundTransparency = 0.5
            infoFrame.BorderSizePixel = 0
            infoFrame.Parent = infoGui
            
            local fpsLabel = Instance.new("TextLabel")
            fpsLabel.Size = UDim2.new(1, 0, 0, 25)
            fpsLabel.Position = UDim2.new(0, 0, 0, 0)
            fpsLabel.BackgroundTransparency = 1
            fpsLabel.TextColor3 = Color3.new(1, 1, 1)
            fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
            fpsLabel.Font = Enum.Font.SourceSans
            fpsLabel.TextSize = 14
            fpsLabel.Parent = infoFrame
            
            local pingLabel = Instance.new("TextLabel")
            pingLabel.Size = UDim2.new(1, 0, 0, 25)
            pingLabel.Position = UDim2.new(0, 0, 0, 25)
            pingLabel.BackgroundTransparency = 1
            pingLabel.TextColor3 = Color3.new(1, 1, 1)
            pingLabel.TextXAlignment = Enum.TextXAlignment.Left
            pingLabel.Font = Enum.Font.SourceSans
            pingLabel.TextSize = 14
            pingLabel.Parent = infoFrame
            
            local batteryLabel = Instance.new("TextLabel")
            batteryLabel.Size = UDim2.new(1, 0, 0, 25)
            batteryLabel.Position = UDim2.new(0, 0, 0, 50)
            batteryLabel.BackgroundTransparency = 1
            batteryLabel.TextColor3 = Color3.new(1, 1, 1)
            batteryLabel.TextXAlignment = Enum.TextXAlignment.Left
            batteryLabel.Font = Enum.Font.SourceSans
            batteryLabel.TextSize = 14
            batteryLabel.Parent = infoFrame
            
            local timeLabel = Instance.new("TextLabel")
            timeLabel.Size = UDim2.new(1, 0, 0, 25)
            timeLabel.Position = UDim2.new(0, 0, 0, 75)
            timeLabel.BackgroundTransparency = 1
            timeLabel.TextColor3 = Color3.new(1, 1, 1)
            timeLabel.TextXAlignment = Enum.TextXAlignment.Left
            timeLabel.Font = Enum.Font.SourceSans
            timeLabel.TextSize = 14
            timeLabel.Parent = infoFrame
            
            local lastTime = tick()
            local fps = 0
            local frameCount = 0
            
            local connection
            connection = RunService.Heartbeat:Connect(function(deltaTime)
                if not Rayfield.Flags.ShowInfo then
                    connection:Disconnect()
                    infoGui:Destroy()
                    return
                end
                
                frameCount = frameCount + 1
                if tick() - lastTime >= 1 then
                    fps = frameCount
                    frameCount = 0
                    lastTime = tick()
                end
                
                fpsLabel.Text = "FPS: "..fps
                
                local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                pingLabel.Text = "Ping: "..math.floor(ping).."ms"
                
                -- Get battery level (only works on mobile)
                local battery = "N/A"
                if UserInputService:GetBatteryInfo() then
                    battery = math.floor(UserInputService:GetBatteryInfo().ChargeLevel * 100).."%"
                end
                batteryLabel.Text = "Battery: "..battery
                
                -- Get current time
                local currentTime = os.date("%H:%M:%S")
                timeLabel.Text = "Time: "..currentTime
            end)
        end
    end,
})

-- Boost FPS
local BoostFPSToggle = SystemTab:CreateToggle({
    Name = "Boost FPS",
    CurrentValue = false,
    Flag = "BoostFPS",
    Callback = function(Value)
        boostFPSEnabled = Value
        if boostFPSEnabled then
            -- Set FPS cap
            game:GetService("RunService"):Set3dRenderingEnabled(true)
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
            settings().Physics.AllowSleep = false
            settings().Network.IncomingReplicationLag = 0
        end
    end,
})

-- Settings FPS
local SettingsFPSSlider = SystemTab:CreateSlider({
    Name = "Settings FPS",
    Range = {0, 360},
    Increment = 1,
    Suffix = "",
    CurrentValue = 60,
    Flag = "FPSValue",
    Callback = function(Value)
        fpsValue = Value
        if fpsValue > 0 then
            setfpscap(fpsValue)
        else
            setfpscap(1e9)  -- Unlimited FPS
        end
    end,
})

-- Auto Clean Memory
local AutoCleanMemoryToggle = SystemTab:CreateToggle({
    Name = "Auto Clean Memory",
    CurrentValue = false,
    Flag = "AutoCleanMemory",
    Callback = function(Value)
        autoCleanMemoryEnabled = Value
        if autoCleanMemoryEnabled then
            task.spawn(function()
                while autoCleanMemoryEnabled do
                    -- Clean up memory
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v:IsA("Texture") or v:IsA("Decal") then
                            v:Destroy()
                        end
                    end
                    
                    for _, v in pairs(game:GetService("Lighting"):GetChildren()) do
                        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                            v:Destroy()
                        end
                    end
                    
                    collectgarbage("collect")
                    
                    task.wait(60)  -- Every minute
                end
            end)
        end
    end,
})

-- Disable Useless Particles
local DisableUselessParticlesButton = SystemTab:CreateButton({
    Name = "Disable Useless Particles",
    Callback = function()
        local count = 0
        for _, particle in pairs(Workspace:GetDescendants()) do
            if particle:IsA("ParticleEmitter") then
                particle.Enabled = false
                count = count + 1
            end
        end
        
        for _, particle in pairs(game:GetService("Lighting"):GetDescendants()) do
            if particle:IsA("ParticleEmitter") then
                particle.Enabled = false
                count = count + 1
            end
        end
        
        Rayfield:Notify({
            Title = "Particles Disabled",
            Content = "Disabled "..count.." particle emitters",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Rejoin Server
local RejoinServerButton = SystemTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end,
})

-- Graphic Tab
local GraphicSection = GraphicTab:CreateSection("Graphic")

-- High Quality
local HighQualityToggle = GraphicTab:CreateToggle({
    Name = "High Quality",
    CurrentValue = false,
    Flag = "HighQuality",
    Callback = function(Value)
        highQualityEnabled = Value
        if highQualityEnabled then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
            game:GetService("Lighting").GlobalShadows = true
            game:GetService("Lighting").ShadowSoftness = 0.2
        end
    end,
})

-- Max Rendering
local MaxRenderingToggle = GraphicTab:CreateToggle({
    Name = "Max Rendering",
    CurrentValue = false,
    Flag = "MaxRendering",
    Callback = function(Value)
        maxRenderingEnabled = Value
        if maxRenderingEnabled then
            settings().Rendering.EagerBulkExecution = true
            settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
            settings().Rendering.TextureQuality = Enum.TextureQuality.QualityLevel.High
            settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
        end
    end,
})

-- Ultra Low Mode
local UltraLowModeToggle = GraphicTab:CreateToggle({
    Name = "Ultra Low Mode",
    CurrentValue = false,
    Flag = "UltraLowMode",
    Callback = function(Value)
        ultraLowModeEnabled = Value
        if ultraLowModeEnabled then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").FogEnd = 100000
            game:GetService("Lighting").FogStart = 0
            settings().Physics.EnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Enabled
            settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
        end
    end,
})

-- Disable Water Reflection
local DisableWaterReflectionToggle = GraphicTab:CreateToggle({
    Name = "Disable Water Reflection",
    CurrentValue = false,
    Flag = "DisableWaterReflection",
    Callback = function(Value)
        disableWaterReflectionEnabled = Value
        if disableWaterReflectionEnabled then
            for _, water in pairs(Workspace:GetDescendants()) do
                if water:IsA("BasePart") and water.Material == Enum.Material.Water then
                    water.Reflectance = 0
                    water.Transparency = 0.8
                end
            end
        else
            for _, water in pairs(Workspace:GetDescendants()) do
                if water:IsA("BasePart") and water.Material == Enum.Material.Water then
                    water.Reflectance = 0.4
                    water.Transparency = 0.5
                end
            end
        end
    end,
})

-- Custom Shader Toggle
local CustomShaderToggle = GraphicTab:CreateToggle({
    Name = "Custom Shader Toggle",
    CurrentValue = false,
    Flag = "CustomShader",
    Callback = function(Value)
        customShaderEnabled = Value
        if customShaderEnabled then
            -- Apply custom shader effects
            local colorCorrection = Instance.new("ColorCorrectionEffect")
            colorCorrection.TintColor = Color3.new(1, 1, 1)
            colorCorrection.Saturation = 0.2
            colorCorrection.Contrast = 0.1
            colorCorrection.Parent = game:GetService("Lighting")
            
            local bloom = Instance.new("BloomEffect")
            bloom.Intensity = 0.5
            bloom.Size = 24
            bloom.Threshold = 0.8
            bloom.Parent = game:GetService("Lighting")
            
            local sunRays = Instance.new("SunRaysEffect")
            sunRays.Intensity = 0.2
            sunRays.Spread = 0.1
            sunRays.Parent = game:GetService("Lighting")
        else
            -- Remove custom shader effects
            for _, effect in pairs(game:GetService("Lighting"):GetChildren()) do
                if effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("SunRaysEffect") then
                    effect:Destroy()
                end
            end
        end
    end,
})

-- RNG Kill Tab
local RNGKillSection = RNGKillTab:CreateSection("RNG Kill")

-- RNG Reducer
local RNGReducerToggle = RNGKillTab:CreateToggle({
    Name = "RNG Reducer",
    CurrentValue = false,
    Flag = "RNGReducer",
    Callback = function(Value)
        rngReducerEnabled = Value
        if rngReducerEnabled then
            -- Modify RNG system to reduce randomness
            local oldRandom = RNGSystem.GetRandomFish
            RNGSystem.GetRandomFish = function(...)
                local result = oldRandom(...)
                -- Increase chance of rare fish
                if math.random(1, 100) <= 50 then  -- 50% chance to get rare fish
                    return FishData.RareFish[math.random(1, #FishData.RareFish)]
                end
                return result
            end
        end
    end,
})

-- Force Legendary Catch
local ForceLegendaryCatchToggle = RNGKillTab:CreateToggle({
    Name = "Force Legendary Catch",
    CurrentValue = false,
    Flag = "ForceLegendaryCatch",
    Callback = function(Value)
        forceLegendaryCatchEnabled = Value
        if forceLegendaryCatchEnabled then
            -- Force legendary fish catch
            local oldGetFish = RNGSystem.GetRandomFish
            RNGSystem.GetRandomFish = function(...)
                return FishData.LegendaryFish[math.random(1, #FishData.LegendaryFish)]
            end
        end
    end,
})

-- Secret Fish Boost
local SecretFishBoostToggle = RNGKillTab:CreateToggle({
    Name = "Secret Fish Boost",
    CurrentValue = false,
    Flag = "SecretFishBoost",
    Callback = function(Value)
        secretFishBoostEnabled = Value
        if secretFishBoostEnabled then
            -- Boost secret fish chance
            local oldGetFish = RNGSystem.GetRandomFish
            RNGSystem.GetRandomFish = function(...)
                if math.random(1, 100) <= 30 then  -- 30% chance to get secret fish
                    return FishData.SecretFish[math.random(1, #FishData.SecretFish)]
                end
                return oldGetFish(...)
            end
        end
    end,
})

-- Mythical Chance x10
local MythicalChanceToggle = RNGKillTab:CreateToggle({
    Name = "Mythical Chance ×10",
    CurrentValue = false,
    Flag = "MythicalChance",
    Callback = function(Value)
        mythicalChanceEnabled = Value
        if mythicalChanceEnabled then
            -- Increase mythical fish chance by 10x
            local oldGetFish = RNGSystem.GetRandomFish
            RNGSystem.GetRandomFish = function(...)
                if math.random(1, 100) <= 20 then  -- 20% chance to get mythical fish
                    return FishData.MythicalFish[math.random(1, #FishData.MythicalFish)]
                end
                return oldGetFish(...)
            end
        end
    end,
})

-- Anti Bad Luck
local AntiBadLuckToggle = RNGKillTab:CreateToggle({
    Name = "Anti Bad Luck",
    CurrentValue = false,
    Flag = "AntiBadLuck",
    Callback = function(Value)
        antiBadLuckEnabled = Value
        if antiBadLuckEnabled then
            -- Reset RNG seed to prevent bad luck
            math.randomseed(tick())
            
            task.spawn(function()
                while antiBadLuckEnabled do
                    -- Periodically reset RNG seed
                    math.randomseed(tick())
                    task.wait(60)  -- Every minute
                end
            end)
        end
    end,
})

-- Shop Tab
local ShopSection = ShopTab:CreateSection("Shop")

-- Buy Rod Section
local BuyRodSection = ShopTab:CreateSection("Buy Rod")

local rodsDropdown = {}
for rodName, rodData in pairs(RodData.Rods) do
    table.insert(rodsDropdown, rodName)
end

local BuyRodDropdown = ShopTab:CreateDropdown({
    Name = "Buy Rod",
    Options = rodsDropdown,
    CurrentOption = "Select Rod",
    Flag = "BuyRod",
    Callback = function(Option)
        -- Store selected rod for purchase
        Rayfield.Flags.BuyRod = Option
    end,
})

local BuyRodButton = ShopTab:CreateButton({
    Name = "Buy Selected Rod",
    Callback = function()
        local selectedRod = Rayfield.Flags.BuyRod
        if selectedRod and selectedRod ~= "Select Rod" then
            BuyItemRemote:FireServer("Rod", selectedRod)
            Rayfield:Notify({
                Title = "Rod Purchased",
                Content = "Bought "..selectedRod,
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Buy Boat Section
local BuyBoatSection = ShopTab:CreateSection("Buy Boat")

local boatsDropdown = {}
for boatName, boatData in pairs(BoatData.Boats) do
    table.insert(boatsDropdown, boatName)
end

local BuyBoatDropdown = ShopTab:CreateDropdown({
    Name = "Buy Boat",
    Options = boatsDropdown,
    CurrentOption = "Select Boat",
    Flag = "BuyBoat",
    Callback = function(Option)
        -- Store selected boat for purchase
        Rayfield.Flags.BuyBoat = Option
    end,
})

local BuyBoatButton = ShopTab:CreateButton({
    Name = "Buy Selected Boat",
    Callback = function()
        local selectedBoat = Rayfield.Flags.BuyBoat
        if selectedBoat and selectedBoat ~= "Select Boat" then
            BuyItemRemote:FireServer("Boat", selectedBoat)
            Rayfield:Notify({
                Title = "Boat Purchased",
                Content = "Bought "..selectedBoat,
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Buy Bait Section
local BuyBaitSection = ShopTab:CreateSection("Buy Bait")

local baitsDropdown = {}
for baitName, baitData in pairs(BaitData.Baits) do
    table.insert(baitsDropdown, baitName)
end

local BuyBaitDropdown = ShopTab:CreateDropdown({
    Name = "Buy Bait",
    Options = baitsDropdown,
    CurrentOption = "Select Bait",
    Flag = "BuyBait",
    Callback = function(Option)
        -- Store selected bait for purchase
        Rayfield.Flags.BuyBait = Option
    end,
})

local BuyBaitButton = ShopTab:CreateButton({
    Name = "Buy Selected Bait",
    Callback = function()
        local selectedBait = Rayfield.Flags.BuyBait
        if selectedBait and selectedBait ~= "Select Bait" then
            BuyItemRemote:FireServer("Bait", selectedBait)
            Rayfield:Notify({
                Title = "Bait Purchased",
                Content = "Bought "..selectedBait,
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Settings Tab
local SettingsSection = SettingsTab:CreateSection("Settings")

-- Save Config
local SaveConfigButton = SettingsTab:CreateButton({
    Name = "Save Config",
    Callback = function()
        Rayfield:SaveConfiguration()
        Rayfield:Notify({
            Title = "Config Saved",
            Content = "Your configuration has been saved",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Load Config
local LoadConfigButton = SettingsTab:CreateButton({
    Name = "Load Config",
    Callback = function()
        Rayfield:LoadConfiguration()
        Rayfield:Notify({
            Title = "Config Loaded",
            Content = "Your configuration has been loaded",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Reset Config
local ResetConfigButton = SettingsTab:CreateButton({
    Name = "Reset Config",
    Callback = function()
        Rayfield:ResetConfiguration()
        Rayfield:Notify({
            Title = "Config Reset",
            Content = "Your configuration has been reset",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Export Config
local ExportConfigButton = SettingsTab:CreateButton({
    Name = "Export Config",
    Callback = function()
        local config = Rayfield:GetConfiguration()
        local jsonConfig = HttpService:JSONEncode(config)
        
        -- Create a textbox to display the config
        local exportGui = Instance.new("ScreenGui")
        exportGui.Name = "FishItExport"
        exportGui.Parent = CoreGui
        exportGui.ResetOnSpawn = false
        
        local exportFrame = Instance.new("Frame")
        exportFrame.Size = UDim2.new(0, 400, 0, 300)
        exportFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
        exportFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
        exportFrame.BorderSizePixel = 0
        exportFrame.Parent = exportGui
        
        local exportTitle = Instance.new("TextLabel")
        exportTitle.Size = UDim2.new(1, 0, 0, 30)
        exportTitle.Position = UDim2.new(0, 0, 0, 0)
        exportTitle.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        exportTitle.BorderSizePixel = 0
        exportTitle.Text = "Export Configuration"
        exportTitle.TextColor3 = Color3.new(1, 1, 1)
        exportTitle.Font = Enum.Font.SourceSansBold
        exportTitle.TextSize = 18
        exportTitle.Parent = exportFrame
        
        local exportBox = Instance.new("TextBox")
        exportBox.Size = UDim2.new(1, -10, 1, -40)
        exportBox.Position = UDim2.new(0, 5, 0, 35)
        exportBox.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
        exportBox.BorderSizePixel = 0
        exportBox.Text = jsonConfig
        exportBox.TextColor3 = Color3.new(1, 1, 1)
        exportBox.Font = Enum.Font.Code
        exportBox.TextSize = 12
        exportBox.TextWrapped = true
        exportBox.TextXAlignment = Enum.TextXAlignment.Left
        exportBox.TextYAlignment = Enum.TextYAlignment.Top
        exportBox.ClearTextOnFocus = false
        exportBox.MultiLine = true
        exportBox.Parent = exportFrame
        
        local closeButton = Instance.new("TextButton")
        closeButton.Size = UDim2.new(0, 80, 0, 25)
        closeButton.Position = UDim2.new(1, -85, 0, 5)
        closeButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        closeButton.BorderSizePixel = 0
        closeButton.Text = "Close"
        closeButton.TextColor3 = Color3.new(1, 1, 1)
        closeButton.Font = Enum.Font.SourceSans
        closeButton.TextSize = 14
        closeButton.Parent = exportFrame
        
        closeButton.MouseButton1Click:Connect(function()
            exportGui:Destroy()
        end)
    end,
})

-- Import Config
local ImportConfigButton = SettingsTab:CreateButton({
    Name = "Import Config",
    Callback = function()
        -- Create a textbox to input the config
        local importGui = Instance.new("ScreenGui")
        importGui.Name = "FishItImport"
        importGui.Parent = CoreGui
        importGui.ResetOnSpawn = false
        
        local importFrame = Instance.new("Frame")
        importFrame.Size = UDim2.new(0, 400, 0, 300)
        importFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
        importFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
        importFrame.BorderSizePixel = 0
        importFrame.Parent = importGui
        
        local importTitle = Instance.new("TextLabel")
        importTitle.Size = UDim2.new(1, 0, 0, 30)
        importTitle.Position = UDim2.new(0, 0, 0, 0)
        importTitle.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        importTitle.BorderSizePixel = 0
        importTitle.Text = "Import Configuration"
        importTitle.TextColor3 = Color3.new(1, 1, 1)
        importTitle.Font = Enum.Font.SourceSansBold
        importTitle.TextSize = 18
        importTitle.Parent = importFrame
        
        local importBox = Instance.new("TextBox")
        importBox.Size = UDim2.new(1, -10, 1, -70)
        importBox.Position = UDim2.new(0, 5, 0, 35)
        importBox.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
        importBox.BorderSizePixel = 0
        importBox.Text = "Paste your configuration JSON here..."
        importBox.TextColor3 = Color3.new(1, 1, 1)
        importBox.Font = Enum.Font.Code
        importBox.TextSize = 12
        importBox.TextWrapped = true
        importBox.TextXAlignment = Enum.TextXAlignment.Left
        importBox.TextYAlignment = Enum.TextYAlignment.Top
        importBox.ClearTextOnFocus = false
        importBox.MultiLine = true
        importBox.Parent = importFrame
        
        local importButton = Instance.new("TextButton")
        importButton.Size = UDim2.new(0, 80, 0, 25)
        importButton.Position = UDim2.new(0.5, -90, 1, -30)
        importButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        importButton.BorderSizePixel = 0
        importButton.Text = "Import"
        importButton.TextColor3 = Color3.new(1, 1, 1)
        importButton.Font = Enum.Font.SourceSans
        importButton.TextSize = 14
        importButton.Parent = importFrame
        
        local closeButton = Instance.new("TextButton")
        closeButton.Size = UDim2.new(0, 80, 0, 25)
        closeButton.Position = UDim2.new(0.5, 10, 1, -30)
        closeButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        closeButton.BorderSizePixel = 0
        closeButton.Text = "Close"
        closeButton.TextColor3 = Color3.new(1, 1, 1)
        closeButton.Font = Enum.Font.SourceSans
        closeButton.TextSize = 14
        closeButton.Parent = importFrame
        
        importButton.MouseButton1Click:Connect(function()
            local success, config = pcall(function()
                return HttpService:JSONDecode(importBox.Text)
            end)
            
            if success then
                Rayfield:LoadConfiguration(config)
                Rayfield:Notify({
                    Title = "Config Imported",
                    Content = "Your configuration has been imported",
                    Duration = 3,
                    Image = 4483362458,
                })
                importGui:Destroy()
            else
                Rayfield:Notify({
                    Title = "Import Failed",
                    Content = "Invalid configuration JSON",
                    Duration = 3,
                    Image = 4483362458,
                })
            end
        end)
        
        closeButton.MouseButton1Click:Connect(function()
            importGui:Destroy()
        end)
    end,
})

-- Notification on script load
Rayfield:Notify({
    Title = "Fish It Hub Loaded",
    Content = "Script has been successfully loaded!",
    Duration = 5,
    Image = 4483362458,
})

task.spawn(function()
    while true do
        task.wait(60)
        -- Anti-kick heartbeat
        if antiKickEnabled then
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                "/e "..tostring(math.random(1, 1000)), 
                "All"
            )
        end
    end
end)
