-- Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Game-specific variables
local FishItRemotes = ReplicatedStorage:WaitForChild("Remotes")
local FishItEvents = ReplicatedStorage:WaitForChild("Events")
local FishItModules = ReplicatedStorage:WaitForChild("Modules")
local FishItItems = ReplicatedStorage:WaitForChild("Items")

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Fish It Hub | September 2025",
    LoadingTitle = "Fish It Script",
    LoadingSubtitle = "by AI Assistant",
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
        Key = {"FISHIT2025"}
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
local RngKillTab = Window:CreateTab("RNG Kill", 4483362458)
local ShopTab = Window:CreateTab("Shop", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- Fish Farm Tab
local AutoFishSection = FishFarmTab:CreateSection("Auto Fish")
local AutoFishToggle = FishFarmTab:CreateToggle({
    Name = "Auto Fish",
    CurrentValue = false,
    Flag = "AutoFish",
    Callback = function(Value)
        _G.AutoFish = Value
        
        if _G.AutoFish then
            task.spawn(function()
                while _G.AutoFish and task.wait(0.1) do
                    pcall(function()
                        -- Check if player is holding a rod
                        local character = LocalPlayer.Character
                        if character and character:FindFirstChildOfClass("Tool") then
                            local tool = character:FindFirstChildOfClass("Tool")
                            if tool:FindFirstChild("Rod") then
                                -- Cast line
                                FishItRemotes.CastLine:FireServer()
                                
                                -- Wait for fish to bite
                                local biteEvent = FishItEvents.FishBite
                                local connection
                                connection = biteEvent.OnClientEvent:Connect(function()
                                    -- Reel in the fish
                                    FishItRemotes.ReelIn:FireServer()
                                    connection:Disconnect()
                                end)
                                
                                -- Wait a bit before next cast
                                task.wait(2)
                            end
                        end
                    end)
                end
            end)
        end
    end,
})

local WaterFishToggle = FishFarmTab:CreateToggle({
    Name = "Water Fish",
    CurrentValue = false,
    Flag = "WaterFish",
    Callback = function(Value)
        _G.WaterFish = Value
        
        if _G.WaterFish then
            task.spawn(function()
                while _G.WaterFish and task.wait(0.1) do
                    pcall(function()
                        -- Check if player is holding a rod
                        local character = LocalPlayer.Character
                        if character and character:FindFirstChildOfClass("Tool") then
                            local tool = character:FindFirstChildOfClass("Tool")
                            if tool:FindFirstChild("Rod") then
                                -- Force water detection even on land
                                local waterDetectionModule = require(FishItModules.WaterDetection)
                                local originalFunction = waterDetectionModule.CheckWater
                                waterDetectionModule.CheckWater = function()
                                    return true
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end,
})

local BypassRadarToggle = FishFarmTab:CreateToggle({
    Name = "Bypass Radar",
    CurrentValue = false,
    Flag = "BypassRadar",
    Callback = function(Value)
        _G.BypassRadar = Value
        
        if _G.BypassRadar then
            task.spawn(function()
                while _G.BypassRadar and task.wait(5) do
                    pcall(function()
                        -- Check if player has radar
                        local playerDataModule = require(FishItModules.PlayerData)
                        local playerData = playerDataModule.GetPlayerData(LocalPlayer)
                        if not playerData.Inventory.Radar then
                            -- Auto buy radar
                            FishItRemotes.BuyItem:FireServer("Radar", 1)
                        end
                        
                        -- Activate radar
                        FishItRemotes.ActivateRadar:FireServer(true)
                    end)
                end
            end)
        end
    end,
})

local BypassAirToggle = FishFarmTab:CreateToggle({
    Name = "Bypass Air",
    CurrentValue = false,
    Flag = "BypassAir",
    Callback = function(Value)
        _G.BypassAir = Value
        
        if _G.BypassAir then
            task.spawn(function()
                while _G.BypassAir and task.wait(5) do
                    pcall(function()
                        -- Check if player has air item
                        local playerDataModule = require(FishItModules.PlayerData)
                        local playerData = playerDataModule.GetPlayerData(LocalPlayer)
                        if not playerData.Inventory.AirTank then
                            -- Auto buy air tank
                            FishItRemotes.BuyItem:FireServer("AirTank", 1)
                        end
                        
                        -- Activate air tank
                        FishItRemotes.ActivateAirTank:FireServer(true)
                    end)
                end
            end)
        end
    end,
})

local DisableEffectToggle = FishFarmTab:CreateToggle({
    Name = "Disable Effect Fishing",
    CurrentValue = false,
    Flag = "DisableEffect",
    Callback = function(Value)
        _G.DisableEffect = Value
        
        if _G.DisableEffect then
            -- Disable particle effects
            for _, particle in pairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Trail") or particle:IsA("Beam") then
                    particle.Enabled = false
                end
            end
        else
            -- Re-enable particle effects
            for _, particle in pairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Trail") or particle:IsA("Beam") then
                    particle.Enabled = true
                end
            end
        end
    end,
})

local InstantFishingToggle = FishFarmTab:CreateToggle({
    Name = "Auto Instant Complicated Fishing",
    CurrentValue = false,
    Flag = "InstantFishing",
    Callback = function(Value)
        _G.InstantFishing = Value
        
        if _G.InstantFishing then
            task.spawn(function()
                while _G.InstantFishing and task.wait(0.1) do
                    pcall(function()
                        -- Modify fishing mechanics to make it instant
                        local fishingMechanicsModule = require(FishItModules.FishingMechanics)
                        local originalFunction = fishingMechanicsModule.StartFishingMinigame
                        fishingMechanicsModule.StartFishingMinigame = function()
                            -- Immediately complete the minigame
                            FishItRemotes.CompleteFishingMinigame:FireServer(true)
                        end
                    end)
                end
            end)
        end
    end,
})

local AutoSellSection = FishFarmTab:CreateSection("Auto Sell Fish")
local AutoSellToggle = FishFarmTab:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(Value)
        _G.AutoSell = Value
        
        if _G.AutoSell then
            task.spawn(function()
                while _G.AutoSell and task.wait(5) do
                    pcall(function()
                        -- Get player inventory
                        local playerDataModule = require(FishItModules.PlayerData)
                        local playerData = playerDataModule.GetPlayerData(LocalPlayer)
                        local fishToSell = {}
                        
                        -- Filter fish to sell (exclude favorites)
                        for fishName, fishData in pairs(playerData.Inventory.Fish) do
                            if not fishData.Favorite and (_G.SellMythical or not fishData.Mythical) and (_G.SellSecret or not fishData.Secret) then
                                table.insert(fishToSell, fishName)
                            end
                        end
                        
                        -- Sell fish
                        if #fishToSell > 0 then
                            for _, fishName in ipairs(fishToSell) do
                                FishItRemotes.SellFish:FireServer(fishName, fishData.Amount)
                                task.wait(_G.SellDelay or 1)
                            end
                        end
                    end)
                end
            end)
        end
    end,
})

local SellMythicalToggle = FishFarmTab:CreateToggle({
    Name = "Sell Mythical Fish",
    CurrentValue = false,
    Flag = "SellMythical",
    Callback = function(Value)
        _G.SellMythical = Value
    end,
})

local SellSecretToggle = FishFarmTab:CreateToggle({
    Name = "Sell Secret Fish",
    CurrentValue = false,
    Flag = "SellSecret",
    Callback = function(Value)
        _G.SellSecret = Value
    end,
})

local SellDelaySlider = FishFarmTab:CreateSlider({
    Name = "Delay Fish Sell",
    Range = {0, 10},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 1,
    Flag = "SellDelay",
    Callback = function(Value)
        _G.SellDelay = Value
    end,
})

local AntiSection = FishFarmTab:CreateSection("Anti System")
local AntiKickToggle = FishFarmTab:CreateToggle({
    Name = "Anti Kick Server",
    CurrentValue = false,
    Flag = "AntiKick",
    Callback = function(Value)
        _G.AntiKick = Value
        
        if _G.AntiKick then
            task.spawn(function()
                while _G.AntiKick and task.wait(30) do
                    pcall(function()
                        -- Send a heartbeat to prevent kick
                        FishItRemotes.Heartbeat:FireServer()
                    end)
                end
            end)
        end
    end,
})

local AntiDetectToggle = FishFarmTab:CreateToggle({
    Name = "Anti Detect System",
    CurrentValue = false,
    Flag = "AntiDetect",
    Callback = function(Value)
        _G.AntiDetect = Value
        
        if _G.AntiDetect then
            task.spawn(function()
                while _G.AntiDetect and task.wait(1) do
                    pcall(function()
                        -- Bypass anti-cheat detection
                        if getidentity then
                            local originalIdentity = getidentity()
                            setidentity(7) -- Spoof identity level
                        end
                    end)
                end
            end)
        end
    end,
})

local AntiAFKToggle = FishFarmTab:CreateToggle({
    Name = "Anti AFK & Auto Jump",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        _G.AntiAFK = Value
        
        if _G.AntiAFK then
            task.spawn(function()
                while _G.AntiAFK and task.wait(30) do
                    pcall(function()
                        -- Move character to prevent AFK kick
                        local character = LocalPlayer.Character
                        if character and character:FindFirstChild("Humanoid") then
                            character.Humanoid.Jump = true
                        end
                    end)
                end
            end)
        end
    end,
})

-- Teleport Tab
local MapsSection = TeleportTab:CreateSection("Teleport Maps")
local MapsDropdown = TeleportTab:CreateDropdown({
    Name = "Select Map",
    Options = {"Starter Island", "Pearl Island", "Volcano Bay", "Deep Sea Trench", "Sky Lagoon", "Coral Reef", "Ancient Temple"},
    CurrentOption = "Starter Island",
    MultipleOptions = false,
    Flag = "SelectedMap",
    Callback = function(Option)
        _G.SelectedMap = Option
    end,
})

local TeleportMapButton = TeleportTab:CreateButton({
    Name = "Teleport to Map",
    Callback = function()
        pcall(function()
            -- Get map locations
            local mapLocations = {
                ["Starter Island"] = CFrame.new(0, 10, 0),
                ["Pearl Island"] = CFrame.new(250, 15, 300),
                ["Volcano Bay"] = CFrame.new(-400, 20, -200),
                ["Deep Sea Trench"] = CFrame.new(100, -50, -500),
                ["Sky Lagoon"] = CFrame.new(0, 200, 0),
                ["Coral Reef"] = CFrame.new(300, 5, 400),
                ["Ancient Temple"] = CFrame.new(-300, 10, 300)
            }
            
            -- Teleport player
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = mapLocations[_G.SelectedMap]
            end
        end)
    end,
})

local PlayerSection = TeleportTab:CreateSection("Teleport Player")
local PlayersDropdown = TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = {},
    CurrentOption = "",
    MultipleOptions = false,
    Flag = "SelectedPlayer",
    Callback = function(Option)
        _G.SelectedPlayer = Option
    end,
})

-- Update players list
task.spawn(function()
    while task.wait(5) do
        pcall(function()
            local playerList = {}
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    table.insert(playerList, player.Name)
                end
            end
            PlayersDropdown:SetOptions(playerList)
        end)
    end
end)

local TeleportPlayerButton = TeleportTab:CreateButton({
    Name = "Teleport to Player",
    Callback = function()
        pcall(function()
            local targetPlayer = Players:FindFirstChild(_G.SelectedPlayer)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                end
            end
        end)
    end,
})

local PositionSection = TeleportTab:CreateSection("Position Manager")
local SavePositionButton = TeleportTab:CreateButton({
    Name = "Save Position",
    Callback = function()
        pcall(function()
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                _G.SavedPosition = character.HumanoidRootPart.CFrame
                Rayfield:Notify({
                    Title = "Position Saved",
                    Content = "Your current position has been saved!",
                    Duration = 3,
                    Image = 4483362458,
                    Actions = {
                        Ignore = {
                            Name = "Okay!",
                            Callback = function()
                                print("The user tapped Okay!")
                            end
                        },
                    },
                })
            end
        end)
    end,
})

local LoadPositionButton = TeleportTab:CreateButton({
    Name = "Load Position",
    Callback = function()
        pcall(function()
            if _G.SavedPosition then
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = _G.SavedPosition
                    Rayfield:Notify({
                        Title = "Position Loaded",
                        Content = "You have been teleported to your saved position!",
                        Duration = 3,
                        Image = 4483362458,
                        Actions = {
                            Ignore = {
                                Name = "Okay!",
                                Callback = function()
                                    print("The user tapped Okay!")
                                end
                            },
                        },
                    })
                end
            else
                Rayfield:Notify({
                    Title = "No Position Saved",
                    Content = "Please save a position first!",
                    Duration = 3,
                    Image = 4483362458,
                    Actions = {
                        Ignore = {
                            Name = "Okay!",
                            Callback = function()
                                print("The user tapped Okay!")
                            end
                        },
                    },
                })
            end
        end)
    end,
})

local DeletePositionButton = TeleportTab:CreateButton({
    Name = "Delete Position",
    Callback = function()
        pcall(function()
            if _G.SavedPosition then
                _G.SavedPosition = nil
                Rayfield:Notify({
                    Title = "Position Deleted",
                    Content = "Your saved position has been deleted!",
                    Duration = 3,
                    Image = 4483362458,
                    Actions = {
                        Ignore = {
                            Name = "Okay!",
                            Callback = function()
                                print("The user tapped Okay!")
                            end
                        },
                    },
                })
            else
                Rayfield:Notify({
                    Title = "No Position Saved",
                    Content = "There is no saved position to delete!",
                    Duration = 3,
                    Image = 4483362458,
                    Actions = {
                        Ignore = {
                            Name = "Okay!",
                            Callback = function()
                                print("The user tapped Okay!")
                            end
                        },
                    },
                })
            end
        end)
    end,
})

-- Player Tab
local MovementSection = PlayerTab:CreateSection("Movement")
local SpeedHackToggle = PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHack",
    Callback = function(Value)
        _G.SpeedHack = Value
        
        if _G.SpeedHack then
            task.spawn(function()
                while _G.SpeedHack and task.wait(0.1) do
                    pcall(function()
                        local character = LocalPlayer.Character
                        if character and character:FindFirstChild("Humanoid") then
                            character.Humanoid.WalkSpeed = _G.SpeedHackValue or 50
                        end
                    end)
                end
            end)
        else
            pcall(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid.WalkSpeed = 16
                end
            end)
        end
    end,
})

local SpeedHackSlider = PlayerTab:CreateSlider({
    Name = "Speed Hack Setting",
    Range = {0, 500},
    Increment = 1,
    Suffix = " speed",
    CurrentValue = 50,
    Flag = "SpeedHackValue",
    Callback = function(Value)
        _G.SpeedHackValue = Value
    end,
})

local MaxBoatSpeedToggle = PlayerTab:CreateToggle({
    Name = "Max Boat Speed",
    CurrentValue = false,
    Flag = "MaxBoatSpeed",
    Callback = function(Value)
        _G.MaxBoatSpeed = Value
        
        if _G.MaxBoatSpeed then
            task.spawn(function()
                while _G.MaxBoatSpeed and task.wait(0.5) do
                    pcall(function()
                        -- Find player's boat
                        for _, boat in pairs(Workspace.Boats:GetChildren()) do
                            if boat:FindFirstChild("Owner") and boat.Owner.Value == LocalPlayer then
                                if boat:FindFirstChild("DriveSeat") and boat.DriveSeat:FindFirstChild("VehicleSeat") then
                                    boat.DriveSeat.VehicleSeat.MaxSpeed = 1000
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end,
})

local SpawnBoatButton = PlayerTab:CreateButton({
    Name = "Spawn Boat",
    Callback = function()
        pcall(function()
            -- Spawn the latest boat
            FishItRemotes.SpawnBoat:FireServer("Mythical Ark")
        end)
    end,
})

local InfinityJumpToggle = PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Flag = "InfinityJump",
    Callback = function(Value)
        _G.InfinityJump = Value
        
        if _G.InfinityJump then
            local connection
            connection = UserInputService.JumpRequest:Connect(function()
                if _G.InfinityJump then
                    local character = LocalPlayer.Character
                    if character and character:FindFirstChild("Humanoid") then
                        character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
            
            -- Store connection to disconnect later
            _G.InfinityJumpConnection = connection
        else
            if _G.InfinityJumpConnection then
                _G.InfinityJumpConnection:Disconnect()
            end
        end
    end,
})

local FlySection = PlayerTab:CreateSection("Fly")
local FlyToggle = PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        _G.Fly = Value
        
        if _G.Fly then
            task.spawn(function()
                local character = LocalPlayer.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then
                    return
                end
                
                local humanoidRootPart = character.HumanoidRootPart
                local flySpeed = _G.FlySpeed or 50
                
                -- Create body parts for flying
                local bodyGyro = Instance.new("BodyGyro")
                bodyGyro.P = 9e4
                bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bodyGyro.CFrame = humanoidRootPart.CFrame
                bodyGyro.Parent = humanoidRootPart
                
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bodyVelocity.Parent = humanoidRootPart
                
                -- Store references
                _G.FlyParts = {bodyGyro, bodyVelocity}
                
                -- Fly control
                local flyConnection
                flyConnection = RunService.Heartbeat:Connect(function()
                    if not _G.Fly then
                        flyConnection:Disconnect()
                        return
                    end
                    
                    pcall(function()
                        local direction = Vector3.new(0, 0, 0)
                        
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            direction = direction + (workspace.CurrentCamera.CFrame.LookVector * flySpeed)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            direction = direction - (workspace.CurrentCamera.CFrame.LookVector * flySpeed)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            direction = direction - (workspace.CurrentCamera.CFrame.RightVector * flySpeed)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            direction = direction + (workspace.CurrentCamera.CFrame.RightVector * flySpeed)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            direction = direction + Vector3.new(0, flySpeed, 0)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                            direction = direction - Vector3.new(0, flySpeed, 0)
                        end
                        
                        bodyVelocity.Velocity = direction
                        bodyGyro.CFrame = workspace.CurrentCamera.CFrame
                    end)
                end)
            end)
        else
            -- Clean up fly parts
            if _G.FlyParts then
                for _, part in ipairs(_G.FlyParts) do
                    if part and part.Parent then
                        part:Destroy()
                    end
                end
                _G.FlyParts = nil
            end
        end
    end,
})

local FlySpeedSlider = PlayerTab:CreateSlider({
    Name = "Fly Settings",
    Range = {0, 200},
    Increment = 1,
    Suffix = " speed",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        _G.FlySpeed = Value
    end,
})

local FlyBoatToggle = PlayerTab:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = false,
    Flag = "FlyBoat",
    Callback = function(Value)
        _G.FlyBoat = Value
        
        if _G.FlyBoat then
            task.spawn(function()
                while _G.FlyBoat do
                    pcall(function()
                        -- Find player's boat
                        for _, boat in pairs(Workspace.Boats:GetChildren()) do
                            if boat:FindFirstChild("Owner") and boat.Owner.Value == LocalPlayer then
                                if boat:FindFirstChild("PrimaryPart") then
                                    -- Apply fly to boat
                                    local flySpeed = _G.FlyBoatSpeed or 50
                                    local direction = Vector3.new(0, 0, 0)
                                    
                                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                                        direction = direction + (workspace.CurrentCamera.CFrame.LookVector * flySpeed)
                                    end
                                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                                        direction = direction - (workspace.CurrentCamera.CFrame.LookVector * flySpeed)
                                    end
                                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                                        direction = direction - (workspace.CurrentCamera.CFrame.RightVector * flySpeed)
                                    end
                                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                                        direction = direction + (workspace.CurrentCamera.CFrame.RightVector * flySpeed)
                                    end
                                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                                        direction = direction + Vector3.new(0, flySpeed, 0)
                                    end
                                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                                        direction = direction - Vector3.new(0, flySpeed, 0)
                                    end
                                    
                                    boat.PrimaryPart.Velocity = direction
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end,
})

local FlyBoatSpeedSlider = PlayerTab:CreateSlider({
    Name = "Fly Boat Settings",
    Range = {0, 200},
    Increment = 1,
    Suffix = " speed",
    CurrentValue = 50,
    Flag = "FlyBoatSpeed",
    Callback = function(Value)
        _G.FlyBoatSpeed = Value
    end,
})

local GhostHackToggle = PlayerTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = false,
    Flag = "GhostHack",
    Callback = function(Value)
        _G.GhostHack = Value
        
        if _G.GhostHack then
            task.spawn(function()
                while _G.GhostHack do
                    pcall(function()
                        local character = LocalPlayer.Character
                        if character then
                            -- Make character transparent to others
                            for _, part in pairs(character:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.LocalTransparencyModifier = 0.5
                                    part.CanCollide = false
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        else
            pcall(function()
                local character = LocalPlayer.Character
                if character then
                    -- Reset character transparency
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.LocalTransparencyModifier = 0
                            part.CanCollide = true
                        end
                    end
                end
            end)
        end
    end,
})

local ESPSection = PlayerTab:CreateSection("ESP")
local ESPLinesToggle = PlayerTab:CreateToggle({
    Name = "ESP Lines",
    CurrentValue = false,
    Flag = "ESPLines",
    Callback = function(Value)
        _G.ESPLines = Value
        
        if _G.ESPLines then
            task.spawn(function()
                _G.ESPConnections = _G.ESPConnections or {}
                
                local function createESPLine(player)
                    if player == LocalPlayer then return end
                    
                    local character = player.Character
                    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                    
                    local line = Drawing.new("Line")
                    line.Thickness = 1
                    line.Color = Color3.new(1, 1, 1)
                    line.Transparency = 1
                    line.Visible = false
                    
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if not _G.ESPLines or not character or not character:FindFirstChild("HumanoidRootPart") then
                            line:Remove()
                            connection:Disconnect()
                            return
                        end
                        
                        local humanoidRootPart = character.HumanoidRootPart
                        local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
                        
                        if onScreen then
                            line.Visible = true
                            line.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                            line.To = Vector2.new(vector.X, vector.Y)
                        else
                            line.Visible = false
                        end
                    end)
                    
                    table.insert(_G.ESPConnections, connection)
                end
                
                -- Create ESP lines for existing players
                for _, player in pairs(Players:GetPlayers()) do
                    createESPLine(player)
                end
                
                -- Create ESP lines for new players
                local playerAddedConnection
                playerAddedConnection = Players.PlayerAdded:Connect(function(player)
                    if _G.ESPLines then
                        player.CharacterAdded:Connect(function()
                            createESPLine(player)
                        end)
                    end
                end)
                
                table.insert(_G.ESPConnections, playerAddedConnection)
            end)
        else
            -- Clean up ESP lines
            if _G.ESPConnections then
                for _, connection in ipairs(_G.ESPConnections) do
                    if connection then
                        connection:Disconnect()
                    end
                end
                _G.ESPConnections = nil
            end
        end
    end,
})

local ESPBoxToggle = PlayerTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = false,
    Flag = "ESPBox",
    Callback = function(Value)
        _G.ESPBox = Value
        
        if _G.ESPBox then
            task.spawn(function()
                _G.ESPBoxConnections = _G.ESPBoxConnections or {}
                
                local function createESPBox(player)
                    if player == LocalPlayer then return end
                    
                    local character = player.Character
                    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                    
                    local box = Drawing.new("Square")
                    box.Thickness = 1
                    box.Color = Color3.new(1, 1, 1)
                    box.Transparency = 1
                    box.Filled = false
                    box.Visible = false
                    
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if not _G.ESPBox or not character or not character:FindFirstChild("HumanoidRootPart") then
                            box:Remove()
                            connection:Disconnect()
                            return
                        end
                        
                        local humanoidRootPart = character.HumanoidRootPart
                        local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
                        
                        if onScreen then
                            local headPosition = character:FindFirstChild("Head") and character.Head.Position or humanoidRootPart.Position + Vector3.new(0, 1.5, 0)
                            local legPosition = humanoidRootPart.Position - Vector3.new(0, 2.5, 0)
                            
                            local headVector, headOnScreen = workspace.CurrentCamera:WorldToViewportPoint(headPosition)
                            local legVector, legOnScreen = workspace.CurrentCamera:WorldToViewportPoint(legPosition)
                            
                            if headOnScreen and legOnScreen then
                                box.Visible = true
                                box.Size = Vector2.new(30, (headVector.Y - legVector.Y))
                                box.Position = Vector2.new(vector.X - 15, legVector.Y)
                            else
                                box.Visible = false
                            end
                        else
                            box.Visible = false
                        end
                    end)
                    
                    table.insert(_G.ESPBoxConnections, connection)
                end
                
                -- Create ESP boxes for existing players
                for _, player in pairs(Players:GetPlayers()) do
                    createESPBox(player)
                end
                
                -- Create ESP boxes for new players
                local playerAddedConnection
                playerAddedConnection = Players.PlayerAdded:Connect(function(player)
                    if _G.ESPBox then
                        player.CharacterAdded:Connect(function()
                            createESPBox(player)
                        end)
                    end
                end)
                
                table.insert(_G.ESPBoxConnections, playerAddedConnection)
            end)
        else
            -- Clean up ESP boxes
            if _G.ESPBoxConnections then
                for _, connection in ipairs(_G.ESPBoxConnections) do
                    if connection then
                        connection:Disconnect()
                    end
                end
                _G.ESPBoxConnections = nil
            end
        end
    end,
})

local ESPRangeToggle = PlayerTab:CreateToggle({
    Name = "ESP Range",
    CurrentValue = false,
    Flag = "ESPRange",
    Callback = function(Value)
        _G.ESPRange = Value
        
        if _G.ESPRange then
            task.spawn(function()
                _G.ESPRangeConnections = _G.ESPRangeConnections or {}
                
                local function createESPRange(player)
                    if player == LocalPlayer then return end
                    
                    local character = player.Character
                    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                    
                    local text = Drawing.new("Text")
                    text.Text = "0m"
                    text.Size = 14
                    text.Color = Color3.new(1, 1, 1)
                    text.Center = true
                    text.Outline = true
                    text.Visible = false
                    
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if not _G.ESPRange or not character or not character:FindFirstChild("HumanoidRootPart") then
                            text:Remove()
                            connection:Disconnect()
                            return
                        end
                        
                        local humanoidRootPart = character.HumanoidRootPart
                        local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
                        
                        if onScreen then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                            text.Text = math.floor(distance) .. "m"
                            text.Position = Vector2.new(vector.X, vector.Y - 20)
                            text.Visible = true
                        else
                            text.Visible = false
                        end
                    end)
                    
                    table.insert(_G.ESPRangeConnections, connection)
                end
                
                -- Create ESP ranges for existing players
                for _, player in pairs(Players:GetPlayers()) do
                    createESPRange(player)
                end
                
                -- Create ESP ranges for new players
                local playerAddedConnection
                playerAddedConnection = Players.PlayerAdded:Connect(function(player)
                    if _G.ESPRange then
                        player.CharacterAdded:Connect(function()
                            createESPRange(player)
                        end)
                    end
                end)
                
                table.insert(_G.ESPRangeConnections, playerAddedConnection)
            end)
        else
            -- Clean up ESP ranges
            if _G.ESPRangeConnections then
                for _, connection in ipairs(_G.ESPRangeConnections) do
                    if connection then
                        connection:Disconnect()
                    end
                end
                _G.ESPRangeConnections = nil
            end
        end
    end,
})

local ESPLevelToggle = PlayerTab:CreateToggle({
    Name = "ESP Level",
    CurrentValue = false,
    Flag = "ESPLevel",
    Callback = function(Value)
        _G.ESPLevel = Value
        
        if _G.ESPLevel then
            task.spawn(function()
                _G.ESPLevelConnections = _G.ESPLevelConnections or {}
                
                local function createESPLevel(player)
                    if player == LocalPlayer then return end
                    
                    local character = player.Character
                    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                    
                    local text = Drawing.new("Text")
                    text.Text = "Lv.1"
                    text.Size = 14
                    text.Color = Color3.new(1, 1, 1)
                    text.Center = true
                    text.Outline = true
                    text.Visible = false
                    
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if not _G.ESPLevel or not character or not character:FindFirstChild("HumanoidRootPart") then
                            text:Remove()
                            connection:Disconnect()
                            return
                        end
                        
                        local humanoidRootPart = character.HumanoidRootPart
                        local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
                        
                        if onScreen then
                            -- Get player level
                            local playerData = FishItModules.PlayerData.GetPlayerData(player)
                            local level = playerData and playerData.Level or 1
                            
                            text.Text = "Lv." .. level
                            text.Position = Vector2.new(vector.X, vector.Y + 20)
                            text.Visible = true
                        else
                            text.Visible = false
                        end
                    end)
                    
                    table.insert(_G.ESPLevelConnections, connection)
                end
                
                -- Create ESP levels for existing players
                for _, player in pairs(Players:GetPlayers()) do
                    createESPLevel(player)
                end
                
                -- Create ESP levels for new players
                local playerAddedConnection
                playerAddedConnection = Players.PlayerAdded:Connect(function(player)
                    if _G.ESPLevel then
                        player.CharacterAdded:Connect(function()
                            createESPLevel(player)
                        end)
                    end
                end)
                
                table.insert(_G.ESPLevelConnections, playerAddedConnection)
            end)
        else
            -- Clean up ESP levels
            if _G.ESPLevelConnections then
                for _, connection in ipairs(_G.ESPLevelConnections) do
                    if connection then
                        connection:Disconnect()
                    end
                end
                _G.ESPLevelConnections = nil
            end
        end
    end,
})

local ESPHologramToggle = PlayerTab:CreateToggle({
    Name = "ESP Hologram",
    CurrentValue = false,
    Flag = "ESPHologram",
    Callback = function(Value)
        _G.ESPHologram = Value
        
        if _G.ESPHologram then
            task.spawn(function()
                _G.ESPHologramConnections = _G.ESPHologramConnections or {}
                
                local function createESPHologram(player)
                    if player == LocalPlayer then return end
                    
                    local character = player.Character
                    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                    
                    local hologram = Instance.new("BillboardGui")
                    hologram.Name = "ESPHologram"
                    hologram.Adornee = character.HumanoidRootPart
                    hologram.Size = UDim2.new(0, 100, 0, 50)
                    hologram.StudsOffset = Vector3.new(0, 3, 0)
                    hologram.AlwaysOnTop = true
                    hologram.Parent = character.HumanoidRootPart
                    
                    local frame = Instance.new("Frame")
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundTransparency = 1
                    frame.Parent = hologram
                    
                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Text = player.Name
                    textLabel.TextColor3 = Color3.new(1, 1, 1)
                    textLabel.TextScaled = true
                    textLabel.Font = Enum.Font.SourceSansBold
                    textLabel.Parent = frame
                    
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if not _G.ESPHologram or not character or not character:FindFirstChild("HumanoidRootPart") then
                            hologram:Destroy()
                            connection:Disconnect()
                            return
                        end
                        
                        -- Rainbow effect
                        local hue = (tick() * 2) % 1
                        local color = Color3.fromHSV(hue, 1, 1)
                        textLabel.TextColor3 = color
                    end)
                    
                    table.insert(_G.ESPHologramConnections, connection)
                end
                
                -- Create ESP holograms for existing players
                for _, player in pairs(Players:GetPlayers()) do
                    createESPHologram(player)
                end
                
                -- Create ESP holograms for new players
                local playerAddedConnection
                playerAddedConnection = Players.PlayerAdded:Connect(function(player)
                    if _G.ESPHologram then
                        player.CharacterAdded:Connect(function()
                            createESPHologram(player)
                        end)
                    end
                end)
                
                table.insert(_G.ESPHologramConnections, playerAddedConnection)
            end)
        else
            -- Clean up ESP holograms
            if _G.ESPHologramConnections then
                for _, connection in ipairs(_G.ESPHologramConnections) do
                    if connection then
                        connection:Disconnect()
                    end
                end
                _G.ESPHologramConnections = nil
            end
            
            -- Remove existing holograms
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hologram = player.Character.HumanoidRootPart:FindFirstChild("ESPHologram")
                    if hologram then
                        hologram:Destroy()
                    end
                end
            end
        end
    end,
})

-- Trader Tab
local TradeSection = TraderTab:CreateSection("Auto Trade")
local AutoAcceptTradeToggle = TraderTab:CreateToggle({
    Name = "Auto Accept Trade",
    CurrentValue = false,
    Flag = "AutoAcceptTrade",
    Callback = function(Value)
        _G.AutoAcceptTrade = Value
        
        if _G.AutoAcceptTrade then
            task.spawn(function()
                while _G.AutoAcceptTrade do
                    pcall(function()
                        -- Check for incoming trade requests
                        local tradeRequest = FishItEvents.TradeRequest
                        local connection
                        connection = tradeRequest.OnClientEvent:Connect(function(fromPlayer)
                            -- Accept the trade
                            FishItRemotes.AcceptTrade:FireServer(fromPlayer)
                            connection:Disconnect()
                        end)
                    end)
                    task.wait(1)
                end
            end)
        end
    end,
})

local FishSelectionSection = TraderTab:CreateSection("Fish Selection")
local FishDropdown = TraderTab:CreateDropdown({
    Name = "Select Fish",
    Options = {},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "SelectedFish",
    Callback = function(Options)
        _G.SelectedFish = Options
    end,
})

-- Update fish list
task.spawn(function()
    while true do
        pcall(function()
            local fishList = {}
            local playerData = FishItModules.PlayerData.GetPlayerData(LocalPlayer)
            
            if playerData and playerData.Inventory and playerData.Inventory.Fish then
                for fishName, _ in pairs(playerData.Inventory.Fish) do
                    table.insert(fishList, fishName)
                end
            end
            
            Rayfield.UpdateDropdown("SelectedFish", fishList)
        end)
        task.wait(5)
    end
end)

local PlayerSelectionSection = TraderTab:CreateSection("Player Selection")
local TradePlayerDropdown = TraderTab:CreateDropdown({
    Name = "Select Player",
    Options = {},
    CurrentOption = {},
    MultipleOptions = false,
    Flag = "TradePlayer",
    Callback = function(Options)
        _G.TradePlayer = Options[1]
    end,
})

-- Update players list for trading
task.spawn(function()
    while true do
        pcall(function()
            local playerList = {}
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    table.insert(playerList, player.Name)
                end
            end
            Rayfield.UpdateDropdown("TradePlayer", playerList)
        end)
        task.wait(5)
    end
end)

local TradeAllButton = TraderTab:CreateButton({
    Name = "Trade All Fish",
    Callback = function()
        pcall(function()
            local targetPlayer = Players:FindFirstChild(_G.TradePlayer)
            if not targetPlayer then
                Rayfield:Notify({
                    Title = "Invalid Player",
                    Content = "Please select a valid player!",
                    Duration = 3,
                    Image = 4483362458,
                    Actions = {
                        Ignore = {
                            Name = "Okay!",
                            Callback = function()
                                print("The user tapped Okay!")
                            end
                        },
                    },
                })
                return
            end
            
            -- Start trade
            FishItRemotes.RequestTrade:FireServer(targetPlayer)
            
            -- Wait for trade to be accepted
            local tradeAccepted = false
            local connection
            connection = FishItEvents.TradeAccepted.OnClientEvent:Connect function(player)
                if player == targetPlayer then
                    tradeAccepted = true
                    connection:Disconnect()
                end
            end)
            
            -- Wait for trade window to open
            task.wait(1)
            
            -- Add all selected fish to trade
            if _G.SelectedFish and #_G.SelectedFish > 0 then
                for _, fishName in ipairs(_G.SelectedFish) do
                    FishItRemotes.AddFishToTrade:FireServer(fishName)
                    task.wait(0.1)
                end
                
                -- Confirm trade
                FishItRemotes.ConfirmTrade:FireServer()
            else
                Rayfield:Notify({
                    Title = "No Fish Selected",
                    Content = "Please select at least one fish to trade!",
                    Duration = 3,
                    Image = 4483362458,
                    Actions = {
                        Ignore = {
                            Name = "Okay!",
                            Callback = function()
                                print("The user tapped Okay!")
                            end
                        },
                    },
                })
            end
        end)
    end,
})

-- Server Tab
local WeatherSection = ServerTab:CreateSection("Weather Control")
local WeatherDropdown = ServerTab:CreateDropdown({
    Name = "Select Weather",
    Options = {"Sunny", "Stormy", "Fog", "Night", "Event Weather"},
    CurrentOption = {"Sunny"},
    MultipleOptions = false,
    Flag = "SelectedWeather",
    Callback = function(Options)
        _G.SelectedWeather = Options[1]
    end,
})

local BuyWeatherButton = ServerTab:CreateButton({
    Name = "Buy Weather",
    Callback = function()
        pcall(function()
            -- Buy the selected weather
            FishItRemotes.BuyWeather:FireServer(_G.SelectedWeather)
        end)
    end,
})

local AutoBuyWeatherToggle = ServerTab:CreateToggle({
    Name = "Auto Buy Weather",
    CurrentValue = false,
    Flag = "AutoBuyWeather",
    Callback = function(Value)
        _G.AutoBuyWeather = Value
        
        if _G.AutoBuyWeather then
            task.spawn(function()
                while _G.AutoBuyWeather do
                    pcall(function()
                        -- Check current weather
                        local currentWeather = Lighting:FindFirstChild("Weather") and Lighting.Weather.Value or "Sunny"
                        
                        -- If current weather is not the selected one, buy it
                        if currentWeather ~= _G.SelectedWeather then
                            FishItRemotes.BuyWeather:FireServer(_G.SelectedWeather)
                        end
                    end)
                    task.wait(60)
                end
            end)
        end
    end,
})

local InfoSection = ServerTab:CreateSection("Server Info")
local PlayerInfoLabel = ServerTab:CreateLabel("Player Info: Loading...")
local ServerInfoLabel = ServerTab:CreateLabel("Server Info: Loading...")

-- Update server info
task.spawn(function()
    while true do
        pcall(function()
            -- Update player count
            local playerCount = #Players:GetPlayers()
            Rayfield.UpdateLabel("PlayerInfoLabel", "Player Info: " .. playerCount .. " players online")
            
            -- Update server info
            local serverLuck = FishItModules.ServerData.GetServerLuck() or "0%"
            local serverSeed = FishItModules.ServerData.GetServerSeed() or "Unknown"
            Rayfield.UpdateLabel("ServerInfoLabel", "Server Info: Luck " .. serverLuck .. " | Seed " .. serverSeed)
        end)
        task.wait(5)
    end
end)

-- System Tab
local InfoDisplaySection = SystemTab:CreateSection("Info Display")
local ShowInfoToggle = SystemTab:CreateToggle({
    Name = "Show Information",
    CurrentValue = false,
    Flag = "ShowInfo",
    Callback = function(Value)
        _G.ShowInfo = Value
        
        if _G.ShowInfo then
            task.spawn(function()
                -- Create info display
                local infoGui = Instance.new("ScreenGui")
                infoGui.Name = "FishItInfo"
                infoGui.ResetOnSpawn = false
                infoGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
                
                local infoFrame = Instance.new("Frame")
                infoFrame.Name = "InfoFrame"
                infoFrame.Size = UDim2.new(0, 200, 0, 100)
                infoFrame.Position = UDim2.new(0, 10, 0, 10)
                infoFrame.BackgroundColor3 = Color3.new(0, 0, 0)
                infoFrame.BackgroundTransparency = 0.5
                infoFrame.BorderSizePixel = 0
                infoFrame.Parent = infoGui
                
                local fpsLabel = Instance.new("TextLabel")
                fpsLabel.Name = "FPSLabel"
                fpsLabel.Size = UDim2.new(1, 0, 0, 25)
                fpsLabel.Position = UDim2.new(0, 0, 0, 0)
                fpsLabel.BackgroundTransparency = 1
                fpsLabel.Text = "FPS: 60"
                fpsLabel.TextColor3 = Color3.new(1, 1, 1)
                fpsLabel.TextScaled = true
                fpsLabel.Font = Enum.Font.SourceSansBold
                fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
                fpsLabel.Parent = infoFrame
                
                local pingLabel = Instance.new("TextLabel")
                pingLabel.Name = "PingLabel"
                pingLabel.Size = UDim2.new(1, 0, 0, 25)
                pingLabel.Position = UDim2.new(0, 0, 0, 25)
                pingLabel.BackgroundTransparency = 1
                pingLabel.Text = "Ping: 0ms"
                pingLabel.TextColor3 = Color3.new(1, 1, 1)
                pingLabel.TextScaled = true
                pingLabel.Font = Enum.Font.SourceSansBold
                pingLabel.TextXAlignment = Enum.TextXAlignment.Left
                pingLabel.Parent = infoFrame
                
                local timeLabel = Instance.new("TextLabel")
                timeLabel.Name = "TimeLabel"
                timeLabel.Size = UDim2.new(1, 0, 0, 25)
                timeLabel.Position = UDim2.new(0, 0, 0, 50)
                timeLabel.BackgroundTransparency = 1
                timeLabel.Text = "Time: 00:00:00"
                timeLabel.TextColor3 = Color3.new(1, 1, 1)
                timeLabel.TextScaled = true
                timeLabel.Font = Enum.Font.SourceSansBold
                timeLabel.TextXAlignment = Enum.TextXAlignment.Left
                timeLabel.Parent = infoFrame
                
                local batteryLabel = Instance.new("TextLabel")
                batteryLabel.Name = "BatteryLabel"
                batteryLabel.Size = UDim2.new(1, 0, 0, 25)
                batteryLabel.Position = UDim2.new(0, 0, 0, 75)
                batteryLabel.BackgroundTransparency = 1
                batteryLabel.Text = "Battery: 100%"
                batteryLabel.TextColor3 = Color3.new(1, 1, 1)
                batteryLabel.TextScaled = true
                batteryLabel.Font = Enum.Font.SourceSansBold
                batteryLabel.TextXAlignment = Enum.TextXAlignment.Left
                batteryLabel.Parent = infoFrame
                
                -- Update info
                local lastTime = tick()
                local fps = 60
                local connection
                connection = RunService.Heartbeat:Connect(function()
                    if not _G.ShowInfo then
                        infoGui:Destroy()
                        connection:Disconnect()
                        return
                    end
                    
                    -- Update FPS
                    local currentTime = tick()
                    local deltaTime = currentTime - lastTime
                    fps = math.floor(1 / deltaTime)
                    lastTime = currentTime
                    fpsLabel.Text = "FPS: " .. fps
                    
                    -- Update Ping
                    local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
                    pingLabel.Text = "Ping: " .. ping .. "ms"
                    
                    -- Update Time
                    local time = os.date("*t")
                    timeLabel.Text = string.format("Time: %02d:%02d:%02d", time.hour, time.min, time.sec)
                    
                    -- Update Battery (if available)
                    if game:GetService("GuiService"):IsTenFootInterface() then
                        local battery = game:GetService("GuiService"):GetBatteryLevel()
                        batteryLabel.Text = "Battery: " .. math.floor(battery * 100) .. "%"
                    else
                        batteryLabel.Text = "Battery: N/A"
                    end
                end)
            end)
        end
    end,
})

local PerformanceSection = SystemTab:CreateSection("Performance")
local BoostFPSToggle = SystemTab:CreateToggle({
    Name = "Boost FPS",
    CurrentValue = false,
    Flag = "BoostFPS",
    Callback = function(Value)
        _G.BoostFPS = Value
        
        if _G.BoostFPS then
            -- Set FPS to cap
            setfpscap(_G.FPSCap or 360)
            
            -- Disable unnecessary features
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").FogEnd = 9e9
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            
            -- Disable particles
            for _, particle in pairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Trail") or particle:IsA("Beam") then
                    particle.Enabled = false
                end
            end
        else
            -- Reset FPS cap
            setfpscap(60)
            
            -- Re-enable features
            game:GetService("Lighting").GlobalShadows = true
            game:GetService("Lighting").FogEnd = 1000
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level10
            
            -- Re-enable particles
            for _, particle in pairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Trail") or particle:IsA("Beam") then
                    particle.Enabled = true
                end
            end
        end
    end,
})

local FPSSlider = SystemTab:CreateSlider({
    Name = "Settings FPS",
    Range = {0, 360},
    Increment = 1,
    Suffix = " FPS",
    CurrentValue = 60,
    Flag = "FPSCap",
    Callback = function(Value)
        _G.FPSCap = Value
        if _G.BoostFPS then
            setfpscap(Value)
        end
    end,
})

local CleanMemoryButton = SystemTab:CreateButton({
    Name = "Clean Memory",
    Callback = function()
        pcall(function()
            -- Clean up memory
            collectgarbage("collect")
            
            -- Clear textures
            for _, obj in pairs(game:GetDescendants()) do
                if obj:IsA("ImageLabel") or obj:IsA("ImageButton") or obj:IsA("Decal") or obj:IsA("Texture") then
                    obj:Destroy()
                end
            end
            
            Rayfield:Notify({
                Title = "Memory Cleaned",
                Content = "Memory has been cleaned successfully!",
                Duration = 3,
                Image = 4483362458,
                Actions = {
                    Ignore = {
                        Name = "Okay!",
                        Callback = function()
                            print("The user tapped Okay!")
                        end
                    },
                },
            })
        end)
    end,
})

local AutoCleanMemoryToggle = SystemTab:CreateToggle({
    Name = "Auto Clean Memory",
    CurrentValue = false,
    Flag = "AutoCleanMemory",
    Callback = function(Value)
        _G.AutoCleanMemory = Value
        
        if _G.AutoCleanMemory then
            task.spawn(function()
                while _G.AutoCleanMemory do
                    pcall(function()
                        collectgarbage("collect")
                    end)
                    task.wait(300) -- Clean every 5 minutes
                end
            end)
        end
    end,
})

local DisableParticlesToggle = SystemTab:CreateToggle({
    Name = "Disable Useless Particles",
    CurrentValue = false,
    Flag = "DisableParticles",
    Callback = function(Value)
        _G.DisableParticles = Value
        
        if _G.DisableParticles then
            task.spawn(function()
                while _G.DisableParticles do
                    pcall(function()
                        -- Disable particles
                        for _, particle in pairs(Workspace:GetDescendants()) do
                            if particle:IsA("ParticleEmitter") or particle:IsA("Trail") or particle:IsA("Beam") then
                                particle.Enabled = false
                            end
                        end
                    end)
                    task.wait(5)
                end
            end)
        else
            -- Re-enable particles
            for _, particle in pairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Trail") or particle:IsA("Beam") then
                    particle.Enabled = true
                end
            end
        end
    end,
})

local ServerSection = SystemTab:CreateSection("Server")
local RejoinButton = SystemTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        pcall(function()
            -- Rejoin server
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
    end,
})

-- Graphic Tab
local QualitySection = GraphicTab:CreateSection("Quality Settings")
local HighQualityButton = GraphicTab:CreateButton({
    Name = "High Quality",
    Callback = function()
        pcall(function()
            -- Set high quality
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
            game:GetService("Lighting").GlobalShadows = true
            game:GetService("Lighting").Technology = Enum.Technology.Future
            game:GetService("Lighting").EnvironmentDiffuseScale = 1
            game:GetService("Lighting").EnvironmentSpecularScale = 1
        end)
    end,
})

local MaxRenderingButton = GraphicTab:CreateButton({
    Name = "Max Rendering",
    Callback = function()
        pcall(function()
            -- Set max rendering
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level27
            game:GetService("Lighting").GlobalShadows = true
            game:GetService("Lighting").Technology = Enum.Technology.Future
            game:GetService("Lighting").EnvironmentDiffuseScale = 1
            game:GetService("Lighting").EnvironmentSpecularScale = 1
            game:GetService("Lighting").GeographicLatitude = 0
            game:GetService("Lighting").ClockTime = 14
        end)
    end,
})

local UltraLowModeButton = GraphicTab:CreateButton({
    Name = "Ultra Low Mode",
    Callback = function()
        pcall(function()
            -- Set ultra low mode
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").Technology = Enum.Technology.Compatibility
            game:GetService("Lighting").EnvironmentDiffuseScale = 0
            game:GetService("Lighting").EnvironmentSpecularScale = 0
            game:GetService("Lighting").FogEnd = 9e9
            
            -- Disable particles
            for _, particle in pairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Trail") or particle:IsA("Beam") then
                    particle.Enabled = false
                end
            end
        end)
    end,
})

local WaterSection = GraphicTab:CreateSection("Water Settings")
local DisableWaterReflectionToggle = GraphicTab:CreateToggle({
    Name = "Disable Water Reflection",
    CurrentValue = false,
    Flag = "DisableWaterReflection",
    Callback = function(Value)
        _G.DisableWaterReflection = Value
        
        if _G.DisableWaterReflection then
            task.spawn(function()
                while _G.DisableWaterReflection do
                    pcall(function()
                        -- Disable water reflection
                        for _, water in pairs(Workspace:GetDescendants()) do
                            if water:IsA("Terrain") then
                                water.WaterReflectance = 0
                                water.WaterTransparency = 0.9
                                water.WaterWaveSize = 0.1
                                water.WaterWaveSpeed = 0
                            end
                        end
                    end)
                    task.wait(5)
                end
            end)
        else
            -- Reset water settings
            for _, water in pairs(Workspace:GetDescendants()) do
                if water:IsA("Terrain") then
                    water.WaterReflectance = 0.5
                    water.WaterTransparency = 0.5
                    water.WaterWaveSize = 0.5
                    water.WaterWaveSpeed = 5
                end
            end
        end
    end,
})

local ShaderSection = GraphicTab:CreateSection("Shader Settings")
local CustomShaderToggle = GraphicTab:CreateToggle({
    Name = "Custom Shader Toggle",
    CurrentValue = false,
    Flag = "CustomShader",
    Callback = function(Value)
        _G.CustomShader = Value
        
        if _G.CustomShader then
            task.spawn(function()
                -- Apply custom shader
                local lighting = game:GetService("Lighting")
                local bloom = Instance.new("BloomEffect")
                bloom.Intensity = 0.5
                bloom.Size = 24
                bloom.Threshold = 0.8
                bloom.Parent = lighting
                
                local colorCorrection = Instance.new("ColorCorrectionEffect")
                colorCorrection.TintColor = Color3.new(1, 1, 1)
                colorCorrection.Contrast = 0.1
                colorCorrection.Brightness = 0.1
                colorCorrection.Saturation = 0.1
                colorCorrection.Parent = lighting
                
                local sunRays = Instance.new("SunRaysEffect")
                sunRays.Intensity = 0.1
                sunRays.Spread = 0.1
                sunRays.Parent = lighting
                
                _G.ShaderEffects = {bloom, colorCorrection, sunRays}
            end)
        else
            -- Remove custom shader
            if _G.ShaderEffects then
                for _, effect in ipairs(_G.ShaderEffects) do
                    if effect and effect.Parent then
                        effect:Destroy()
                    end
                end
                _G.ShaderEffects = nil
            end
        end
    end,
})

-- RNG Kill Tab
local RNGSection = RngKillTab:CreateSection("RNG Manipulation")
local RNGReducerToggle = RngKillTab:CreateToggle({
    Name = "RNG Reducer",
    CurrentValue = false,
    Flag = "RNGReducer",
    Callback = function(Value)
        _G.RNGReducer = Value
        
        if _G.RNGReducer then
            task.spawn(function()
                while _G.RNGReducer do
                    pcall(function()
                        -- Modify RNG to reduce difficulty
                        local originalRandom = math.random
                        math.random = function(min, max)
                            if not max then
                                return min
                            else
                                -- Bias towards higher values
                                return originalRandom(math.floor(min + (max - min) * 0.7), max)
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        else
            -- Reset RNG
            math.random = _G.OriginalRandom or math.random
        end
    end,
})

local ForceLegendaryToggle = RngKillTab:CreateToggle({
    Name = "Force Legendary Catch",
    CurrentValue = false,
    Flag = "ForceLegendary",
    Callback = function(Value)
        _G.ForceLegendary = Value
        
        if _G.ForceLegendary then
            task.spawn(function()
                while _G.ForceLegendary do
                    pcall(function()
                        -- Modify fish rarity calculation
                        local originalFunction = FishItModules.FishingMechanics.CalculateFishRarity
                        FishItModules.FishingMechanics.CalculateFishRarity = function()
                            return "Legendary"
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end,
})

local SecretFishBoostToggle = RngKillTab:CreateToggle({
    Name = "Secret Fish Boost",
    CurrentValue = false,
    Flag = "SecretFishBoost",
    Callback = function(Value)
        _G.SecretFishBoost = Value
        
        if _G.SecretFishBoost then
            task.spawn(function()
                while _G.SecretFishBoost do
                    pcall(function()
                        -- Modify secret fish chance
                        local originalFunction = FishItModules.FishingMechanics.CalculateSecretChance
                        FishItModules.FishingMechanics.CalculateSecretChance = function()
                            return 0.5 -- 50% chance
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end,
})

local MythicalChanceToggle = RngKillTab:CreateToggle({
    Name = "Mythical Chance ×10",
    CurrentValue = false,
    Flag = "MythicalChance",
    Callback = function(Value)
        _G.MythicalChance = Value
        
        if _G.MythicalChance then
            task.spawn(function()
                while _G.MythicalChance do
                    pcall(function()
                        -- Modify mythical fish chance
                        local originalFunction = FishItModules.FishingMechanics.CalculateMythicalChance
                        FishItModules.FishingMechanics.CalculateMythicalChance = function()
                            local baseChance = originalFunction()
                            return baseChance * 10 -- 10x chance
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end,
})

local AntiBadLuckToggle = RngKillTab:CreateToggle({
    Name = "Anti-Bad Luck",
    CurrentValue = false,
    Flag = "AntiBadLuck",
    Callback = function(Value)
        _G.AntiBadLuck = Value
        
        if _G.AntiBadLuck then
            task.spawn(function()
                while _G.AntiBadLuck do
                    pcall(function()
                        -- Reset RNG seed
                        local originalRandomseed = math.randomseed
                        math.randomseed = function(seed)
                            originalRandomseed(tick())
                        end
                        
                        -- Force good luck
                        FishItRemotes.SetLuck:FireServer(100)
                    end)
                    task.wait(60)
                end
            end)
        end
    end,
})

-- Shop Tab
local RodSection = ShopTab:CreateSection("Buy Rod")
local RodDropdown = ShopTab:CreateDropdown({
    Name = "Select Rod",
    Options = {"Starter Rod", "Carbon Rod", "Toy Rod", "Grass Rod", "Lava Rod", "Lucky Rod", "Midnight Rod", "Demascus Rod", "Ice Rod", "Steampunk Rod", "Chrome Rod", "Astral Rod", "Ares Rod", "Ghostfinn Rod", "Angler Rod"},
    CurrentOption = {"Starter Rod"},
    MultipleOptions = false,
    Flag = "SelectedRod",
    Callback = function(Options)
        _G.SelectedRod = Options[1]
    end,
})

local BuyRodButton = ShopTab:CreateButton({
    Name = "Buy Rod",
    Callback = function()
        pcall(function()
            -- Buy the selected rod
            FishItRemotes.BuyRod:FireServer(_G.SelectedRod)
        end)
    end,
})

local BoatSection = ShopTab:CreateSection("Buy Boat")
local BoatDropdown = ShopTab:CreateDropdown({
    Name = "Select Boat",
    Options = {"Small Boat", "Speed Boat", "Viking Ship", "Mythical Ark"},
    CurrentOption = {"Small Boat"},
    MultipleOptions = false,
    Flag = "SelectedBoat",
    Callback = function(Options)
        _G.SelectedBoat = Options[1]
    end,
})

local BuyBoatButton = ShopTab:CreateButton({
    Name = "Buy Boat",
    Callback = function()
        pcall(function()
            -- Buy the selected boat
            FishItRemotes.BuyBoat:FireServer(_G.SelectedBoat)
        end)
    end,
})

local BaitSection = ShopTab:CreateSection("Buy Bait")
local BaitDropdown = ShopTab:CreateDropdown({
    Name = "Select Bait",
    Options = {"Worm", "Shrimp", "Golden Bait", "Mythical Lure", "Dark Matter Bait", "Aether Bait"},
    CurrentOption = {"Worm"},
    MultipleOptions = false,
    Flag = "SelectedBait",
    Callback = function(Options)
        _G.SelectedBait = Options[1]
    end,
})

local BaitAmountSlider = ShopTab:CreateSlider({
    Name = "Bait Amount",
    Range = {1, 100},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "BaitAmount",
    Callback = function(Value)
        _G.BaitAmount = Value
    end,
})

local BuyBaitButton = ShopTab:CreateButton({
    Name = "Buy Bait",
    Callback = function()
        pcall(function()
            -- Buy the selected bait
            FishItRemotes.BuyBait:FireServer(_G.SelectedBait, _G.BaitAmount or 1)
        end)
    end,
})

-- Settings Tab
local ConfigSection = SettingsTab:CreateSection("Configuration")
local SaveConfigButton = SettingsTab:CreateButton({
    Name = "Save Config",
    Callback = function()
        pcall(function()
            -- Get all toggle states
            local config = {
                AutoFish = _G.AutoFish or false,
                WaterFish = _G.WaterFish or false,
                BypassRadar = _G.BypassRadar or false,
                BypassAir = _G.BypassAir or false,
                DisableEffect = _G.DisableEffect or false,
                InstantFishing = _G.InstantFishing or false,
                AutoSell = _G.AutoSell or false,
                SellMythical = _G.SellMythical or false,
                SellSecret = _G.SellSecret or false,
                SellDelay = _G.SellDelay or 1,
                AntiKick = _G.AntiKick or false,
                AntiDetect = _G.AntiDetect or false,
                AntiAFK = _G.AntiAFK or false,
                SpeedHack = _G.SpeedHack or false,
                SpeedHackValue = _G.SpeedHackValue or 50,
                MaxBoatSpeed = _G.MaxBoatSpeed or false,
                InfinityJump = _G.InfinityJump or false,
                Fly = _G.Fly or false,
                FlySpeed = _G.FlySpeed or 50,
                FlyBoat = _G.FlyBoat or false,
                FlyBoatSpeed = _G.FlyBoatSpeed or 50,
                GhostHack = _G.GhostHack or false,
                ESPLines = _G.ESPLines or false,
                ESPBox = _G.ESPBox or false,
                ESPRange = _G.ESPRange or false,
                ESPLevel = _G.ESPLevel or false,
                ESPHologram = _G.ESPHologram or false,
                AutoAcceptTrade = _G.AutoAcceptTrade or false,
                AutoBuyWeather = _G.AutoBuyWeather or false,
                ShowInfo = _G.ShowInfo or false,
                BoostFPS = _G.BoostFPS or false,
                FPSCap = _G.FPSCap or 60,
                AutoCleanMemory = _G.AutoCleanMemory or false,
                DisableParticles = _G.DisableParticles or false,
                DisableWaterReflection = _G.DisableWaterReflection or false,
                CustomShader = _G.CustomShader or false,
                RNGReducer = _G.RNGReducer or false,
                ForceLegendary = _G.ForceLegendary or false,
                SecretFishBoost = _G.SecretFishBoost or false,
                MythicalChance = _G.MythicalChance or false,
                AntiBadLuck = _G.AntiBadLuck or false
            }
            
            -- Save config
            writefile("FishItConfig.json", HttpService:JSONEncode(config))
            
            Rayfield:Notify({
                Title = "Config Saved",
                Content = "Your configuration has been saved successfully!",
                Duration = 3,
                Image = 4483362458,
                Actions = {
                    Ignore = {
                        Name = "Okay!",
                        Callback = function()
                            print("The user tapped Okay!")
                        end
                    },
                },
            })
        end)
    end,
})

local LoadConfigButton = SettingsTab:CreateButton({
    Name = "Load Config",
    Callback = function()
        pcall(function()
            -- Check if config file exists
            if isfile("FishItConfig.json") then
                -- Load config
                local config = HttpService:JSONDecode(readfile("FishItConfig.json"))
                
                -- Apply config
                for key, value in pairs(config) do
                    _G[key] = value
                    
                    -- Update UI elements
                    if Rayfield.Flags[key] then
                        Rayfield.Flags[key] = value
                    end
                end
                
                Rayfield:Notify({
                    Title = "Config Loaded",
                    Content = "Your configuration has been loaded successfully!",
                    Duration = 3,
                    Image = 4483362458,
                    Actions = {
                        Ignore = {
                            Name = "Okay!",
                            Callback = function()
                                print("The user tapped Okay!")
                            end
                        },
                    },
                })
            else
                Rayfield:Notify({
                    Title = "No Config Found",
                    Content = "Please save a configuration first!",
                    Duration = 3,
                    Image = 4483362458,
                    Actions = {
                        Ignore = {
                            Name = "Okay!",
                            Callback = function()
                                print("The user tapped Okay!")
                            end
                        },
                    },
                })
            end
        end)
    end,
})

local ResetConfigButton = SettingsTab:CreateButton({
    Name = "Reset Config",
    Callback = function()
        pcall(function()
            -- Reset all toggles
            for key, _ in pairs(Rayfield.Flags) do
                if key ~= "SellDelay" and key ~= "SpeedHackValue" and key ~= "FlySpeed" and key ~= "FlyBoatSpeed" and key ~= "FPSCap" and key ~= "BaitAmount" then
                    Rayfield.Flags[key] = false
                    _G[key] = false
                end
            end
            
            -- Reset sliders
            Rayfield.Flags["SellDelay"] = 1
            Rayfield.Flags["SpeedHackValue"] = 50
            Rayfield.Flags["FlySpeed"] = 50
            Rayfield.Flags["FlyBoatSpeed"] = 50
            Rayfield.Flags["FPSCap"] = 60
            Rayfield.Flags["BaitAmount"] = 1
            
            _G.SellDelay = 1
            _G.SpeedHackValue = 50
            _G.FlySpeed = 50
            _G.FlyBoatSpeed = 50
            _G.FPSCap = 60
            _G.BaitAmount = 1
            
            Rayfield:Notify({
                Title = "Config Reset",
                Content = "Your configuration has been reset to default!",
                Duration = 3,
                Image = 4483362458,
                Actions = {
                    Ignore = {
                        Name = "Okay!",
                        Callback = function()
                            print("The user tapped Okay!")
                        end
                    },
                },
            })
        end)
    end,
})

local ExportConfigButton = SettingsTab:CreateButton({
    Name = "Export Config",
    Callback = function()
        pcall(function()
            -- Get all toggle states
            local config = {
                AutoFish = _G.AutoFish or false,
                WaterFish = _G.WaterFish or false,
                BypassRadar = _G.BypassRadar or false,
                BypassAir = _G.BypassAir or false,
                DisableEffect = _G.DisableEffect or false,
                InstantFishing = _G.InstantFishing or false,
                AutoSell = _G.AutoSell or false,
                SellMythical = _G.SellMythical or false,
                SellSecret = _G.SellSecret or false,
                SellDelay = _G.SellDelay or 1,
                AntiKick = _G.AntiKick or false,
                AntiDetect = _G.AntiDetect or false,
                AntiAFK = _G.AntiAFK or false,
                SpeedHack = _G.SpeedHack or false,
                SpeedHackValue = _G.SpeedHackValue or 50,
                MaxBoatSpeed = _G.MaxBoatSpeed or false,
                InfinityJump = _G.InfinityJump or false,
                Fly = _G.Fly or false,
                FlySpeed = _G.FlySpeed or 50,
                FlyBoat = _G.FlyBoat or false,
                FlyBoatSpeed = _G.FlyBoatSpeed or 50,
                GhostHack = _G.GhostHack or false,
                ESPLines = _G.ESPLines or false,
                ESPBox = _G.ESPBox or false,
                ESPRange = _G.ESPRange or false,
                ESPLevel = _G.ESPLevel or false,
                ESPHologram = _G.ESPHologram or false,
                AutoAcceptTrade = _G.AutoAcceptTrade or false,
                AutoBuyWeather = _G.AutoBuyWeather or false,
                ShowInfo = _G.ShowInfo or false,
                BoostFPS = _G.BoostFPS or false,
                FPSCap = _G.FPSCap or 60,
                AutoCleanMemory = _G.AutoCleanMemory or false,
                DisableParticles = _G.DisableParticles or false,
                DisableWaterReflection = _G.DisableWaterReflection or false,
                CustomShader = _G.CustomShader or false,
                RNGReducer = _G.RNGReducer or false,
                ForceLegendary = _G.ForceLegendary or false,
                SecretFishBoost = _G.SecretFishBoost or false,
                MythicalChance = _G.MythicalChance or false,
                AntiBadLuck = _G.AntiBadLuck or false
            }
            
            -- Export config to clipboard
            setclipboard(HttpService:JSONEncode(config))
            
            Rayfield:Notify({
                Title = "Config Exported",
                Content = "Your configuration has been copied to clipboard!",
                Duration = 3,
                Image = 4483362458,
                Actions = {
                    Ignore = {
                        Name = "Okay!",
                        Callback = function()
                            print("The user tapped Okay!")
                        end
                    },
                },
            })
        end)
    end,
})

local ImportConfigButton = SettingsTab:CreateButton({
    Name = "Import Config",
    Callback = function()
        pcall(function()
            -- Get config from clipboard
            local config = HttpService:JSONDecode(getclipboard())
            
            -- Apply config
            for key, value in pairs(config) do
                _G[key] = value
                
                -- Update UI elements
                if Rayfield.Flags[key] then
                    Rayfield.Flags[key] = value
                end
            end
            
            Rayfield:Notify({
                Title = "Config Imported",
                Content = "Your configuration has been imported successfully!",
                Duration = 3,
                Image = 4483362458,
                Actions = {
                    Ignore = {
                        Name = "Okay!",
                        Callback = function()
                            print("The user tapped Okay!")
                        end
                    },
                },
            })
        end)
    end,
})

-- Notification
Rayfield:Notify({
    Title = "Fish It Hub Loaded",
    Content = "The script has been loaded successfully!",
    Duration = 5,
    Image = 4483362458,
    Actions = {
        Ignore = {
            Name = "Okay!",
            Callback = function()
                print("The user tapped Okay!")
            end
        },
    },
})
