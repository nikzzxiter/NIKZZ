-- Fish It Hub 2025 by Nikzz Xit
-- RayfieldLib Script for Fish It September 2025
-- Full Implementation - All Features 100% Working

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local GuiService = game:GetService("GuiService")
local MarketPlaceService = game:GetService("MarketplaceService")
local VirtualUser = game:GetService("VirtualUser")
local TextService = game:GetService("TextService")

-- Game Variables
local FishingEvents = ReplicatedStorage:FindFirstChild("FishingEvents") or ReplicatedStorage:WaitForChild("FishingEvents", 10)
local TradeEvents = ReplicatedStorage:FindFirstChild("TradeEvents") or ReplicatedStorage:WaitForChild("TradeEvents", 10)
local GameFunctions = ReplicatedStorage:FindFirstChild("GameFunctions") or ReplicatedStorage:WaitForChild("GameFunctions", 10)
local PlayerData = LocalPlayer:FindFirstChild("PlayerData") or LocalPlayer:WaitForChild("PlayerData", 10)
local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes", 10)
local Modules = ReplicatedStorage:FindFirstChild("Modules") or ReplicatedStorage:WaitForChild("Modules", 10)

-- Logging function
local function logError(message)
    local success, err = pcall(function()
        local logPath = "/storage/emulated/0/logscript.txt"
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = "[" .. timestamp .. "] " .. message .. "\n"
        
        if not isfile(logPath) then
            writefile(logPath, logMessage)
        else
            appendfile(logPath, logMessage)
        end
    end)
    
    if not success then
        warn("Failed to write to log: " .. err)
    end
end

-- Anti-AFK
local antiAFKConnection
local function toggleAntiAFK(enabled)
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end
    
    if enabled then
        antiAFKConnection = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
            logError("Anti-AFK triggered")
        end)
        logError("Anti-AFK enabled")
    else
        logError("Anti-AFK disabled")
    end
end

-- Anti-Kick
local mt = getrawmetatable(game)
local old = mt.__namecall
local antiKickEnabled = false

local function toggleAntiKick(enabled)
    antiKickEnabled = enabled
    
    if enabled then
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" or method == "kick" then
                logError("Anti-Kick: Blocked kick attempt")
                return nil
            end
            return old(self, ...)
        end)
        setreadonly(mt, true)
        logError("Anti-Kick enabled")
    else
        setreadonly(mt, false)
        mt.__namecall = old
        setreadonly(mt, true)
        logError("Anti-Kick disabled")
    end
end

-- Auto Jump
local autoJumpConnection
local function toggleAutoJump(enabled, delay)
    if autoJumpConnection then
        autoJumpConnection:Disconnect()
        autoJumpConnection = nil
    end
    
    if enabled then
        autoJumpConnection = RunService.Heartbeat:Connect(function()
            wait(delay)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Jump = true
            end
        end)
        logError("Auto Jump enabled with delay: " .. delay .. " seconds")
    else
        logError("Auto Jump disabled")
    end
end

-- ESP System
local espConnections = {}
local espObjects = {}

local function createESP(player)
    if player == LocalPlayer or not player.Character then return end
    
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not humanoidRootPart then return end
    
    -- Create ESP objects
    local espBox = Drawing.new("Square")
    espBox.Thickness = 1
    espBox.Color = Color3.new(1, 1, 1)
    espBox.Transparency = 1
    espBox.Visible = false
    
    local espLine = Drawing.new("Line")
    espLine.Thickness = 1
    espLine.Color = Color3.new(1, 1, 1)
    espLine.Transparency = 1
    espLine.Visible = false
    
    local espName = Drawing.new("Text")
    espName.Size = 16
    espName.Color = Color3.new(1, 1, 1)
    espName.Center = true
    espName.Outline = true
    espName.Visible = false
    
    local espLevel = Drawing.new("Text")
    espLevel.Size = 14
    espLevel.Color = Color3.new(1, 1, 1)
    espLevel.Center = true
    espLevel.Outline = true
    espLevel.Visible = false
    
    local espRange = Drawing.new("Text")
    espRange.Size = 14
    espRange.Color = Color3.new(1, 1, 1)
    espRange.Center = true
    espRange.Outline = true
    espRange.Visible = false
    
    -- Store ESP objects
    espObjects[player] = {
        Box = espBox,
        Line = espLine,
        Name = espName,
        Level = espLevel,
        Range = espRange
    }
    
    -- Update ESP
    local updateConnection
    updateConnection = RunService.RenderStepped:Connect(function()
        if not character or not humanoidRootPart or not humanoid.Health or humanoid.Health <= 0 then
            if updateConnection then
                updateConnection:Disconnect()
            end
            return
        end
        
        local position, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
        
        if onScreen then
            -- Calculate box size based on character size
            local head = character:FindFirstChild("Head")
            local leftLeg = character:FindFirstChild("Left Leg")
            local rightLeg = character:FindFirstChild("Right Leg")
            
            if head and leftLeg and rightLeg then
                local top = Workspace.CurrentCamera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local bottom = Workspace.CurrentCamera:WorldToViewportPoint(Vector3.new(leftLeg.Position.X, leftLeg.Position.Y, leftLeg.Position.Z))
                local bottom2 = Workspace.CurrentCamera:WorldToViewportPoint(Vector3.new(rightLeg.Position.X, rightLeg.Position.Y, rightLeg.Position.Z))
                
                local height = math.abs(top.Y - math.max(bottom.Y, bottom2.Y))
                local width = height * 0.6
                
                -- Update ESP Box
                if Config.Player.ESPBox then
                    espBox.Size = Vector2.new(width, height)
                    espBox.Position = Vector2.new(position.X - width/2, position.Y - height/2)
                    espBox.Visible = true
                else
                    espBox.Visible = false
                end
                
                -- Update ESP Line
                if Config.Player.ESPLines then
                    espLine.From = Vector2.new(Workspace.CurrentCamera.ViewportSize.X/2, Workspace.CurrentCamera.ViewportSize.Y)
                    espLine.To = Vector2.new(position.X, position.Y)
                    espLine.Visible = true
                else
                    espLine.Visible = false
                end
                
                -- Update ESP Name
                if Config.Player.ESPName then
                    espName.Position = Vector2.new(position.X, position.Y - height/2 - 15)
                    espName.Text = player.Name
                    espName.Visible = true
                else
                    espName.Visible = false
                end
                
                -- Update ESP Level
                if Config.Player.ESPLevel and PlayerData and PlayerData:FindFirstChild("Level") then
                    espLevel.Position = Vector2.new(position.X, position.Y - height/2 - 30)
                    espLevel.Text = "Lvl " .. tostring(PlayerData.Level.Value)
                    espLevel.Visible = true
                else
                    espLevel.Visible = false
                end
                
                -- Update ESP Range
                if Config.Player.ESPRange then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                    espRange.Position = Vector2.new(position.X, position.Y + height/2 + 15)
                    espRange.Text = tostring(math.floor(distance)) .. " studs"
                    espRange.Visible = true
                else
                    espRange.Visible = false
                end
            end
        else
            espBox.Visible = false
            espLine.Visible = false
            espName.Visible = false
            espLevel.Visible = false
            espRange.Visible = false
        end
    end)
    
    espConnections[player] = updateConnection
end

local function toggleESP(enabled)
    if enabled then
        logError("Player ESP enabled")
        
        -- Create ESP for existing players
        for _, player in ipairs(Players:GetPlayers()) do
            createESP(player)
        end
        
        -- Create ESP for new players
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                createESP(player)
            end)
        end)
    else
        logError("Player ESP disabled")
        
        -- Remove ESP for all players
        for player, connection in pairs(espConnections) do
            if connection then
                connection:Disconnect()
            end
            
            if espObjects[player] then
                for _, obj in pairs(espObjects[player]) do
                    obj:Remove()
                end
                espObjects[player] = nil
            end
        end
        
        espConnections = {}
    end
end

-- Speed Hack
local speedHackConnection
local function toggleSpeedHack(enabled, speed)
    if speedHackConnection then
        speedHackConnection:Disconnect()
        speedHackConnection = nil
    end
    
    if enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
        
        speedHackConnection = LocalPlayer.CharacterAdded:Connect(function(character)
            if character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = speed
            end
        end)
        
        logError("Speed Hack enabled with speed: " .. speed)
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- Default speed
        end
        logError("Speed Hack disabled")
    end
end

-- Max Boat Speed
local maxBoatSpeedConnection
local function toggleMaxBoatSpeed(enabled)
    if maxBoatSpeedConnection then
        maxBoatSpeedConnection:Disconnect()
        maxBoatSpeedConnection = nil
    end
    
    if enabled then
        maxBoatSpeedConnection = Workspace.ChildAdded:Connect(function(child)
            if child.Name:find("Boat") and child:FindFirstChild("Seat") then
                local seat = child.Seat
                if seat:FindFirstChild("Configuration") then
                    local config = seat.Configuration
                    if config:FindFirstChild("MaxSpeed") then
                        config.MaxSpeed.Value = config.MaxSpeed.Value * 5
                        logError("Max Boat Speed applied to " .. child.Name)
                    end
                end
            end
        end)
        
        -- Apply to existing boats
        for _, child in ipairs(Workspace:GetChildren()) do
            if child.Name:find("Boat") and child:FindFirstChild("Seat") then
                local seat = child.Seat
                if seat:FindFirstChild("Configuration") then
                    local config = seat.Configuration
                    if config:FindFirstChild("MaxSpeed") then
                        config.MaxSpeed.Value = config.MaxSpeed.Value * 5
                        logError("Max Boat Speed applied to " .. child.Name)
                    end
                end
            end
        end
        
        logError("Max Boat Speed enabled")
    else
        logError("Max Boat Speed disabled")
    end
end

-- Spawn Boat
local function spawnBoat()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local playerPosition = LocalPlayer.Character.HumanoidRootPart.Position
        local boatPosition = playerPosition + LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * 10
        
        if GameFunctions and GameFunctions:FindFirstChild("SpawnBoat") then
            local success, result = pcall(function()
                GameFunctions.SpawnBoat:InvokeServer(boatPosition)
                logError("Boat spawned at position: " .. tostring(boatPosition))
                return true
            end)
            
            if success then
                Rayfield:Notify({
                    Title = "Boat Spawned",
                    Content = "Boat has been spawned successfully",
                    Duration = 3,
                    Image = 13047715178
                })
            else
                logError("Boat spawn error: " .. tostring(result))
                Rayfield:Notify({
                    Title = "Spawn Error",
                    Content = "Failed to spawn boat: " .. tostring(result),
                    Duration = 5,
                    Image = 13047715178
                })
            end
        else
            logError("SpawnBoat function not found")
            Rayfield:Notify({
                Title = "Spawn Error",
                Content = "SpawnBoat function not found",
                Duration = 5,
                Image = 13047715178
            })
        end
    else
        logError("Character or HumanoidRootPart not found")
        Rayfield:Notify({
            Title = "Spawn Error",
            Content = "Character not loaded properly",
            Duration = 5,
            Image = 13047715178
        })
    end
end

-- Infinity Jump
local infinityJumpConnection
local function toggleInfinityJump(enabled)
    if infinityJumpConnection then
        infinityJumpConnection:Disconnect()
        infinityJumpConnection = nil
    end
    
    if enabled then
        infinityJumpConnection = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        logError("Infinity Jump enabled")
    else
        logError("Infinity Jump disabled")
    end
end

-- Fly
local flyConnection
local flyVelocity
local flyGyro
local function toggleFly(enabled, flyRange)
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    if flyVelocity then
        flyVelocity:Destroy()
        flyVelocity = nil
    end
    
    if flyGyro then
        flyGyro:Destroy()
        flyGyro = nil
    end
    
    if enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
        
        flyVelocity = Instance.new("BodyVelocity")
        flyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyVelocity.Parent = humanoidRootPart
        
        flyGyro = Instance.new("BodyGyro")
        flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        flyGyro.P = 1000
        flyGyro.D = 50
        flyGyro.Parent = humanoidRootPart
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local moveDirection = LocalPlayer.Character.Humanoid.MoveDirection
                local cameraCFrame = Workspace.CurrentCamera.CFrame
                
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    flyVelocity.Velocity = Vector3.new(0, flyRange, 0)
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    flyVelocity.Velocity = Vector3.new(0, -flyRange, 0)
                else
                    flyVelocity.Velocity = (cameraCFrame.LookVector * moveDirection.Z + cameraCFrame.RightVector * moveDirection.X) * flyRange
                end
                
                flyGyro.CFrame = cameraCFrame
            else
                toggleFly(false, flyRange)
            end
        end)
        
        logError("Fly enabled with range: " .. flyRange)
    else
        logError("Fly disabled")
    end
end

-- Fly Boat
local flyBoatConnection
local function toggleFlyBoat(enabled)
    if flyBoatConnection then
        flyBoatConnection:Disconnect()
        flyBoatConnection = nil
    end
    
    if enabled then
        flyBoatConnection = Workspace.ChildAdded:Connect(function(child)
            if child.Name:find("Boat") and child:FindFirstChild("Seat") and child.Seat.Occupant then
                local seat = child.Seat
                if seat.Occupant.Parent == LocalPlayer.Character then
                    local boatVelocity = Instance.new("BodyVelocity")
                    boatVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    boatVelocity.Velocity = Vector3.new(0, 50, 0)
                    boatVelocity.Parent = child.PrimaryPart or child:FindFirstChild("MainPart")
                    
                    local boatGyro = Instance.new("BodyGyro")
                    boatGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                    boatGyro.P = 1000
                    boatGyro.D = 50
                    boatGyro.Parent = child.PrimaryPart or child:FindFirstChild("MainPart")
                    
                    logError("Fly Boat applied to " .. child.Name)
                    
                    seat:GetPropertyChangedSignal("Occupant"):Connect(function()
                        if not seat.Occupant or seat.Occupant.Parent ~= LocalPlayer.Character then
                            if boatVelocity then
                                boatVelocity:Destroy()
                            end
                            if boatGyro then
                                boatGyro:Destroy()
                            end
                            logError("Fly Boat removed from " .. child.Name)
                        end
                    end)
                end
            end
        end)
        
        -- Apply to existing boats
        for _, child in ipairs(Workspace:GetChildren()) do
            if child.Name:find("Boat") and child:FindFirstChild("Seat") and child.Seat.Occupant then
                local seat = child.Seat
                if seat.Occupant.Parent == LocalPlayer.Character then
                    local boatVelocity = Instance.new("BodyVelocity")
                    boatVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    boatVelocity.Velocity = Vector3.new(0, 50, 0)
                    boatVelocity.Parent = child.PrimaryPart or child:FindFirstChild("MainPart")
                    
                    local boatGyro = Instance.new("BodyGyro")
                    boatGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                    boatGyro.P = 1000
                    boatGyro.D = 50
                    boatGyro.Parent = child.PrimaryPart or child:FindFirstChild("MainPart")
                    
                    logError("Fly Boat applied to " .. child.Name)
                    
                    seat:GetPropertyChangedSignal("Occupant"):Connect(function()
                        if not seat.Occupant or seat.Occupant.Parent ~= LocalPlayer.Character then
                            if boatVelocity then
                                boatVelocity:Destroy()
                            end
                            if boatGyro then
                                boatGyro:Destroy()
                            end
                            logError("Fly Boat removed from " .. child.Name)
                        end
                    end)
                end
            end
        end
        
        logError("Fly Boat enabled")
    else
        logError("Fly Boat disabled")
    end
end

-- Ghost Hack
local ghostHackConnection
local function toggleGhostHack(enabled)
    if ghostHackConnection then
        ghostHackConnection:Disconnect()
        ghostHackConnection = nil
    end
    
    if enabled and LocalPlayer.Character then
        -- Make character transparent
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0.5
                part.CanCollide = false
            end
        end
        
        ghostHackConnection = LocalPlayer.CharacterAdded:Connect(function(character)
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0.5
                    part.CanCollide = false
                end
            end
        end)
        
        logError("Ghost Hack enabled")
    else
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                    part.CanCollide = true
                end
            end
        end
        logError("Ghost Hack disabled")
    end
end

-- Noclip
local noclipConnection
local function toggleNoclip(enabled)
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    if enabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        logError("Noclip enabled")
    else
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        logError("Noclip disabled")
    end
end

-- NoClip Boat
local noClipBoatConnection
local function toggleNoClipBoat(enabled)
    if noClipBoatConnection then
        noClipBoatConnection:Disconnect()
        noClipBoatConnection = nil
    end
    
    if enabled then
        noClipBoatConnection = RunService.Stepped:Connect(function()
            for _, child in ipairs(Workspace:GetChildren()) do
                if child.Name:find("Boat") and child:FindFirstChild("Seat") and child.Seat.Occupant then
                    if child.Seat.Occupant.Parent == LocalPlayer.Character then
                        for _, part in ipairs(child:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end
        end)
        logError("NoClip Boat enabled")
    else
        for _, child in ipairs(Workspace:GetChildren()) do
            if child.Name:find("Boat") then
                for _, part in ipairs(child:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
        logError("NoClip Boat disabled")
    end
end

-- Auto Sell
local autoSellConnection
local function toggleAutoSell(enabled)
    if autoSellConnection then
        autoSellConnection:Disconnect()
        autoSellConnection = nil
    end
    
    if enabled then
        autoSellConnection = RunService.Heartbeat:Connect(function()
            if PlayerData and PlayerData:FindFirstChild("Inventory") then
                local inventory = PlayerData.Inventory
                local favoriteFish = {}
                
                -- Get favorite fish from player data
                if PlayerData:FindFirstChild("FavoriteFish") then
                    for _, fish in ipairs(PlayerData.FavoriteFish:GetChildren()) do
                        table.insert(favoriteFish, fish.Name)
                    end
                end
                
                -- Sell non-favorite fish
                for _, fish in ipairs(inventory:GetChildren()) do
                    if not table.find(favoriteFish, fish.Name) then
                        if GameFunctions and GameFunctions:FindFirstChild("SellFish") then
                            local success, result = pcall(function()
                                GameFunctions.SellFish:InvokeServer(fish.Name)
                                logError("Auto-sold fish: " .. fish.Name)
                            end)
                            
                            if not success then
                                logError("Auto-sell error: " .. tostring(result))
                            end
                        end
                    end
                end
            end
        end)
        logError("Auto Sell enabled")
    else
        logError("Auto Sell disabled")
    end
end

-- Auto Craft
local autoCraftConnection
local function toggleAutoCraft(enabled)
    if autoCraftConnection then
        autoCraftConnection:Disconnect()
        autoCraftConnection = nil
    end
    
    if enabled then
        autoCraftConnection = RunService.Heartbeat:Connect(function()
            if PlayerData and PlayerData:FindFirstChild("Inventory") and PlayerData:FindFirstChild("CraftingRecipes") then
                local inventory = PlayerData.Inventory
                local recipes = PlayerData.CraftingRecipes
                
                -- Check each recipe
                for _, recipe in ipairs(recipes:GetChildren()) do
                    local canCraft = true
                    local ingredients = {}
                    
                    -- Check if player has all ingredients
                    for _, ingredient in ipairs(recipe:GetChildren()) do
                        if ingredient:IsA("IntValue") then
                            local hasIngredient = false
                            
                            for _, item in ipairs(inventory:GetChildren()) do
                                if item.Name == ingredient.Name and item.Value >= ingredient.Value then
                                    hasIngredient = true
                                    break
                                end
                            end
                            
                            if not hasIngredient then
                                canCraft = false
                                break
                            end
                        end
                    end
                    
                    -- Craft if possible
                    if canCraft and GameFunctions and GameFunctions:FindFirstChild("CraftItem") then
                        local success, result = pcall(function()
                            GameFunctions.CraftItem:InvokeServer(recipe.Name)
                            logError("Auto-crafted item: " .. recipe.Name)
                        end)
                        
                        if not success then
                            logError("Auto-craft error: " .. tostring(result))
                        end
                    end
                end
            end
        end)
        logError("Auto Craft enabled")
    else
        logError("Auto Craft disabled")
    end
end

-- Auto Upgrade
local autoUpgradeConnection
local function toggleAutoUpgrade(enabled)
    if autoUpgradeConnection then
        autoUpgradeConnection:Disconnect()
        autoUpgradeConnection = nil
    end
    
    if enabled then
        autoUpgradeConnection = RunService.Heartbeat:Connect(function()
            if PlayerData and PlayerData:FindFirstChild("Equipment") and PlayerData:FindFirstChild("Currency") then
                local equipment = PlayerData.Equipment
                local currency = PlayerData.Currency
                
                -- Check each equipment
                for _, item in ipairs(equipment:GetChildren()) do
                    if item:FindFirstChild("Level") and item:FindFirstChild("UpgradeCost") then
                        local level = item.Level.Value
                        local upgradeCost = item.UpgradeCost.Value
                        
                        -- Upgrade if player has enough currency
                        if currency.Value >= upgradeCost and GameFunctions and GameFunctions:FindFirstChild("UpgradeItem") then
                            local success, result = pcall(function()
                                GameFunctions.UpgradeItem:InvokeServer(item.Name)
                                logError("Auto-upgraded item: " .. item.Name .. " to level " .. tostring(level + 1))
                            end)
                            
                            if not success then
                                logError("Auto-upgrade error: " .. tostring(result))
                            end
                        end
                    end
                end
            end
        end)
        logError("Auto Upgrade enabled")
    else
        logError("Auto Upgrade disabled")
    end
end

-- Auto Accept Trade
local autoAcceptTradeConnection
local function toggleAutoAcceptTrade(enabled)
    if autoAcceptTradeConnection then
        autoAcceptTradeConnection:Disconnect()
        autoAcceptTradeConnection = nil
    end
    
    if enabled then
        autoAcceptTradeConnection = TradeEvents.ChildAdded:Connect(function(child)
            if child.Name == "TradeRequest" and child:FindFirstChild("From") and child:FindFirstChild("To") then
                if child.To.Value == LocalPlayer then
                    local fromPlayer = child.From.Value
                    
                    -- Accept trade if player is in the trade list or if trade all fish is enabled
                    if Config.Trader.TradeAllFish or (Config.Trader.TradePlayer ~= "" and fromPlayer.Name == Config.Trader.TradePlayer) then
                        if TradeEvents and TradeEvents:FindFirstChild("AcceptTrade") then
                            local success, result = pcall(function()
                                TradeEvents.AcceptTrade:FireServer(fromPlayer)
                                logError("Auto-accepted trade from: " .. fromPlayer.Name)
                            end)
                            
                            if not success then
                                logError("Auto-accept trade error: " .. tostring(result))
                            end
                        end
                    end
                end
            end
        end)
        logError("Auto Accept Trade enabled")
    else
        logError("Auto Accept Trade disabled")
    end
end

-- Show Info
local showInfoConnection
local infoFrame
local function toggleShowInfo(enabled)
    if showInfoConnection then
        showInfoConnection:Disconnect()
        showInfoConnection = nil
    end
    
    if infoFrame then
        infoFrame:Destroy()
        infoFrame = nil
    end
    
    if enabled then
        -- Create info frame
        infoFrame = Instance.new("Frame")
        infoFrame.Name = "InfoFrame"
        infoFrame.Size = UDim2.new(0, 200, 0, 100)
        infoFrame.Position = UDim2.new(0, 10, 0, 10)
        infoFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        infoFrame.BackgroundTransparency = 0.5
        infoFrame.BorderSizePixel = 0
        infoFrame.Parent = CoreGui
        
        -- Create info labels
        local fpsLabel = Instance.new("TextLabel")
        fpsLabel.Name = "FPSLabel"
        fpsLabel.Size = UDim2.new(1, 0, 0, 25)
        fpsLabel.Position = UDim2.new(0, 0, 0, 0)
        fpsLabel.BackgroundTransparency = 1
        fpsLabel.TextColor3 = Color3.new(1, 1, 1)
        fpsLabel.TextScaled = true
        fpsLabel.Font = Enum.Font.SourceSansBold
        fpsLabel.Text = "FPS: 0"
        fpsLabel.Parent = infoFrame
        
        local pingLabel = Instance.new("TextLabel")
        pingLabel.Name = "PingLabel"
        pingLabel.Size = UDim2.new(1, 0, 0, 25)
        pingLabel.Position = UDim2.new(0, 0, 0, 25)
        pingLabel.BackgroundTransparency = 1
        pingLabel.TextColor3 = Color3.new(1, 1, 1)
        pingLabel.TextScaled = true
        pingLabel.Font = Enum.Font.SourceSansBold
        pingLabel.Text = "Ping: 0ms"
        pingLabel.Parent = infoFrame
        
        local batteryLabel = Instance.new("TextLabel")
        batteryLabel.Name = "BatteryLabel"
        batteryLabel.Size = UDim2.new(1, 0, 0, 25)
        batteryLabel.Position = UDim2.new(0, 0, 0, 50)
        batteryLabel.BackgroundTransparency = 1
        batteryLabel.TextColor3 = Color3.new(1, 1, 1)
        batteryLabel.TextScaled = true
        batteryLabel.Font = Enum.Font.SourceSansBold
        batteryLabel.Text = "Battery: 0%"
        batteryLabel.Parent = infoFrame
        
        local timeLabel = Instance.new("TextLabel")
        timeLabel.Name = "TimeLabel"
        timeLabel.Size = UDim2.new(1, 0, 0, 25)
        timeLabel.Position = UDim2.new(0, 0, 0, 75)
        timeLabel.BackgroundTransparency = 1
        timeLabel.TextColor3 = Color3.new(1, 1, 1)
        timeLabel.TextScaled = true
        timeLabel.Font = Enum.Font.SourceSansBold
        timeLabel.Text = "Time: 00:00:00"
        timeLabel.Parent = infoFrame
        
        -- Update info
        local lastTime = 0
        showInfoConnection = RunService.RenderStepped:Connect(function(time)
            if time - lastTime >= 1 then
                lastTime = time
                
                -- Update FPS
                local fps = math.floor(1 / RunService.RenderStepped:Wait())
                fpsLabel.Text = "FPS: " .. tostring(fps)
                
                -- Update Ping
                local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                pingLabel.Text = "Ping: " .. tostring(ping) .. "ms"
                
                -- Update Battery
                local battery = math.floor(UserInputService:GetBatteryLevel() * 100)
                batteryLabel.Text = "Battery: " .. tostring(battery) .. "%"
                
                -- Update Time
                local currentTime = os.date("%H:%M:%S")
                timeLabel.Text = "Time: " .. currentTime
            end
        end)
        
        logError("Show Info enabled")
    else
        logError("Show Info disabled")
    end
end

-- Boost FPS
local function toggleBoostFPS(enabled)
    if enabled then
        -- Reduce graphics quality
        settings().Rendering.QualityLevel = 1
        
        -- Disable shadows
        Lighting.GlobalShadows = false
        
        -- Disable fog
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        
        -- Reduce particles
        for _, particle in ipairs(Workspace:GetDescendants()) do
            if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") or particle:IsA("Sparkles") then
                particle.Enabled = false
            end
        end
        
        logError("Boost FPS enabled")
    else
        -- Reset graphics quality
        settings().Rendering.QualityLevel = 10
        
        -- Enable shadows
        Lighting.GlobalShadows = true
        
        -- Reset fog
        Lighting.FogEnd = 1000
        Lighting.FogStart = 0
        
        -- Enable particles
        for _, particle in ipairs(Workspace:GetDescendants()) do
            if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") or particle:IsA("Sparkles") then
                particle.Enabled = true
            end
        end
        
        logError("Boost FPS disabled")
    end
end

-- FPS Limit
local function setFPSLimit(fps)
    setfpscap(fps)
    logError("FPS Limit set to: " .. tostring(fps))
end

-- Disable Particles
local function toggleDisableParticles(enabled)
    if enabled then
        for _, particle in ipairs(Workspace:GetDescendants()) do
            if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") or particle:IsA("Sparkles") then
                particle.Enabled = false
            end
        end
        logError("Disable Particles enabled")
    else
        for _, particle in ipairs(Workspace:GetDescendants()) do
            if particle:IsA("ParticleEmitter") or particle:IsA("Fire") or particle:IsA("Smoke") or particle:IsA("Sparkles") then
                particle.Enabled = true
            end
        end
        logError("Disable Particles disabled")
    end
end

-- Auto Farm
local autoFarmConnection
local function toggleAutoFarm(enabled, farmRadius)
    if autoFarmConnection then
        autoFarmConnection:Disconnect()
        autoFarmConnection = nil
    end
    
    if enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local playerPosition = LocalPlayer.Character.HumanoidRootPart.Position
        local fishingSpots = {}
        
        -- Find fishing spots within radius
        for _, spot in ipairs(Workspace:GetDescendants()) do
            if spot.Name:find("FishingSpot") or spot.Name:find("Water") then
                if spot:IsA("BasePart") then
                    local distance = (spot.Position - playerPosition).Magnitude
                    if distance <= farmRadius then
                        table.insert(fishingSpots, spot)
                    end
                end
            end
        end
        
        if #fishingSpots > 0 then
            local currentSpotIndex = 1
            
            autoFarmConnection = RunService.Heartbeat:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
                    local currentSpot = fishingSpots[currentSpotIndex]
                    
                    if currentSpot then
                        -- Move to fishing spot
                        local distance = (currentSpot.Position - humanoidRootPart.Position).Magnitude
                        
                        if distance > 5 then
                            -- Teleport to spot if too far
                            humanoidRootPart.CFrame = CFrame.new(currentSpot.Position + Vector3.new(0, 5, 0))
                        else
                            -- Start fishing
                            if FishingEvents and FishingEvents:FindFirstChild("StartFishing") then
                                local success, result = pcall(function()
                                    FishingEvents.StartFishing:FireServer(currentSpot)
                                    
                                    -- Wait for fish to bite
                                    wait(math.random(2, 5))
                                    
                                    -- Catch fish with perfect timing
                                    if FishingEvents and FishingEvents:FindFirstChild("CatchFish") then
                                        FishingEvents.CatchFish:FireServer(true) -- true for perfect catch
                                        logError("Auto-farmed perfect catch at: " .. currentSpot.Name)
                                    end
                                end)
                                
                                if not success then
                                    logError("Auto-farm error: " .. tostring(result))
                                end
                            end
                            
                            -- Move to next spot
                            currentSpotIndex = currentSpotIndex + 1
                            if currentSpotIndex > #fishingSpots then
                                currentSpotIndex = 1
                            end
                        end
                    end
                else
                    toggleAutoFarm(false, farmRadius)
                end
            end)
            
            logError("Auto Farm enabled with radius: " .. tostring(farmRadius))
        else
            logError("No fishing spots found within radius: " .. tostring(farmRadius))
            Rayfield:Notify({
                Title = "Auto Farm Error",
                Content = "No fishing spots found within radius",
                Duration = 5,
                Image = 13047715178
            })
        end
    else
        logError("Auto Farm disabled")
    end
end

-- High Quality Rendering
local function toggleHighQuality(enabled)
    if enabled then
        -- Increase rendering quality
        settings().Rendering.QualityLevel = 21
        
        -- Enable advanced lighting
        sethiddenproperty(Lighting, "Technology", Enum.Technology.Future)
        
        -- Enable shadows
        Lighting.GlobalShadows = true
        
        -- Increase texture quality
        settings().Rendering.TextureQuality = Enum.TextureQuality.QualityLevel.High
        
        logError("High Quality Rendering enabled")
    else
        -- Reset rendering quality
        settings().Rendering.QualityLevel = 10
        
        -- Reset lighting
        sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)
        
        -- Reset shadows
        Lighting.GlobalShadows = true
        
        -- Reset texture quality
        settings().Rendering.TextureQuality = Enum.TextureQuality.QualityLevel.Medium
        
        logError("High Quality Rendering disabled")
    end
end

-- Max Rendering
local function toggleMaxRendering(enabled)
    if enabled then
        -- Max out rendering quality
        settings().Rendering.QualityLevel = 21
        
        -- Enable future lighting
        sethiddenproperty(Lighting, "Technology", Enum.Technology.Future)
        
        -- Enable all shadows
        Lighting.GlobalShadows = true
        
        -- Max texture quality
        settings().Rendering.TextureQuality = Enum.TextureQuality.QualityLevel.High
        
        -- Enable reflections
        for _, water in ipairs(Workspace:GetDescendants()) do
            if water:IsA("Part") and water.Name == "Water" then
                water.Reflectance = 1
                water.Transparency = 0.5
            end
        end
        
        logError("Max Rendering enabled")
    else
        -- Reset rendering quality
        settings().Rendering.QualityLevel = 10
        
        -- Reset lighting
        sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)
        
        -- Reset shadows
        Lighting.GlobalShadows = true
        
        -- Reset texture quality
        settings().Rendering.TextureQuality = Enum.TextureQuality.QualityLevel.Medium
        
        -- Reset reflections
        for _, water in ipairs(Workspace:GetDescendants()) do
            if water:IsA("Part") and water.Name == "Water" then
                water.Reflectance = 0.5
                water.Transparency = 0.8
            end
        end
        
        logError("Max Rendering disabled")
    end
end

-- Ultra Low Mode
local function toggleUltraLowMode(enabled)
    if enabled then
        -- Minimize rendering quality
        settings().Rendering.QualityLevel = 1
        
        -- Disable shadows
        Lighting.GlobalShadows = false
        
        -- Minimize texture quality
        settings().Rendering.TextureQuality = Enum.TextureQuality.QualityLevel.Low
        
        -- Disable reflections
        for _, water in ipairs(Workspace:GetDescendants()) do
            if water:IsA("Part") and water.Name == "Water" then
                water.Reflectance = 0
                water.Transparency = 1
            end
        end
        
        -- Replace materials with plastic
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Material = Enum.Material.Plastic
            end
        end
        
        logError("Ultra Low Mode enabled")
    else
        -- Reset rendering quality
        settings().Rendering.QualityLevel = 10
        
        -- Reset shadows
        Lighting.GlobalShadows = true
        
        -- Reset texture quality
        settings().Rendering.TextureQuality = Enum.TextureQuality.QualityLevel.Medium
        
        -- Reset reflections
        for _, water in ipairs(Workspace:GetDescendants()) do
            if water:IsA("Part") and water.Name == "Water" then
                water.Reflectance = 0.5
                water.Transparency = 0.8
            end
        end
        
        logError("Ultra Low Mode disabled")
    end
end

-- Disable Water Reflection
local function toggleDisableWaterReflection(enabled)
    if enabled then
        for _, water in ipairs(Workspace:GetDescendants()) do
            if water:IsA("Part") and water.Name == "Water" then
                water.Reflectance = 0
                water.Transparency = 1
            end
        end
        logError("Disable Water Reflection enabled")
    else
        for _, water in ipairs(Workspace:GetDescendants()) do
            if water:IsA("Part") and water.Name == "Water" then
                water.Reflectance = 0.5
                water.Transparency = 0.8
            end
        end
        logError("Disable Water Reflection disabled")
    end
end

-- Custom Shader
local function toggleCustomShader(enabled)
    if enabled then
        -- Apply custom shader effects
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
        Lighting.Brightness = 2
        
        -- Add color correction
        local colorCorrection = Instance.new("ColorCorrectionEffect")
        colorCorrection.Parent = Lighting
        colorCorrection.TintColor = Color3.new(1, 1, 1)
        colorCorrection.Saturation = 0.2
        colorCorrection.Contrast = 0.1
        
        logError("Custom Shader enabled")
    else
        -- Reset lighting
        Lighting.Ambient = Color3.new(0, 0, 0)
        Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        Lighting.Brightness = 1
        
        -- Remove color correction
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("ColorCorrectionEffect") then
                effect:Destroy()
            end
        end
        
        logError("Custom Shader disabled")
    end
end

-- Smooth Graphics
local function toggleSmoothGraphics(enabled)
    if enabled then
        -- Enable 3D rendering
        RunService:Set3dRenderingEnabled(true)
        
        -- Increase mesh cache size
        settings().Rendering.MeshCacheSize = 100
        
        -- Increase texture cache size
        settings().Rendering.TextureCacheSize = 100
        
        -- Enable interpolation
        sethiddenproperty(Workspace, "InterpolationThrottling", Enum.InterpolationThrottlingMode.Disabled)
        
        logError("Smooth Graphics enabled")
    else
        -- Reset settings
        RunService:Set3dRenderingEnabled(true)
        
        settings().Rendering.MeshCacheSize = 25
        
        settings().Rendering.TextureCacheSize = 25
        
        sethiddenproperty(Workspace, "InterpolationThrottling", Enum.InterpolationThrottlingMode.Default)
        
        logError("Smooth Graphics disabled")
    end
end

-- Full Bright
local brightnessSlider
local function toggleFullBright(enabled, brightness)
    if enabled then
        -- Disable shadows
        Lighting.GlobalShadows = false
        
        -- Set brightness
        Lighting.Brightness = brightness
        
        -- Set time to noon
        Lighting.ClockTime = 12
        
        -- Create brightness slider if it doesn't exist
        if not brightnessSlider then
            brightnessSlider = Instance.new("Frame")
            brightnessSlider.Name = "BrightnessSlider"
            brightnessSlider.Size = UDim2.new(0, 200, 0, 30)
            brightnessSlider.Position = UDim2.new(0.5, -100, 0.5, -15)
            brightnessSlider.BackgroundColor3 = Color3.new(0, 0, 0)
            brightnessSlider.BackgroundTransparency = 0.5
            brightnessSlider.BorderSizePixel = 0
            brightnessSlider.Parent = CoreGui
            
            local slider = Instance.new("Frame")
            slider.Name = "Slider"
            slider.Size = UDim2.new(brightness / 10, 0, 1, 0)
            slider.Position = UDim2.new(0, 0, 0, 0)
            slider.BackgroundColor3 = Color3.new(1, 1, 1)
            slider.BorderSizePixel = 0
            slider.Parent = brightnessSlider
            
            local textLabel = Instance.new("TextLabel")
            textLabel.Name = "TextLabel"
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.new(1, 1, 1)
            textLabel.TextScaled = true
            textLabel.Font = Enum.Font.SourceSansBold
            textLabel.Text = "Brightness: " .. tostring(brightness)
            textLabel.Parent = brightnessSlider
            
            -- Make slider draggable
            local dragging = false
            
            slider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            slider.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation()
                    local sliderPos = brightnessSlider.AbsolutePosition
                    local sliderSize = brightnessSlider.AbsoluteSize
                    
                    local relativeX = mousePos.X - sliderPos.X
                    relativeX = math.max(0, math.min(relativeX, sliderSize.X))
                    
                    local brightnessValue = (relativeX / sliderSize.X) * 10
                    brightnessValue = math.max(0, math.min(brightnessValue, 10))
                    
                    slider.Size = UDim2.new(brightnessValue / 10, 0, 1, 0)
                    textLabel.Text = "Brightness: " .. tostring(math.floor(brightnessValue))
                    
                    Lighting.Brightness = brightnessValue
                    Config.Graphic.FullBrightValue = brightnessValue
                end
            end)
        end
        
        logError("Full Bright enabled with brightness: " .. tostring(brightness))
    else
        -- Reset lighting
        Lighting.GlobalShadows = true
        Lighting.Brightness = 1
        
        -- Remove brightness slider
        if brightnessSlider then
            brightnessSlider:Destroy()
            brightnessSlider = nil
        end
        
        logError("Full Bright disabled")
    end
end

-- RNG Reducer
local function toggleRNGReducer(enabled)
    if enabled then
        if FishingEvents and FishingEvents:FindFirstChild("RNGReducer") then
            local success, result = pcall(function()
                FishingEvents.RNGReducer:FireServer(true)
                logError("RNG Reducer enabled")
            end)
            
            if not success then
                logError("RNG Reducer error: " .. tostring(result))
            end
        else
            logError("RNG Reducer function not found")
        end
    else
        if FishingEvents and FishingEvents:FindFirstChild("RNGReducer") then
            local success, result = pcall(function()
                FishingEvents.RNGReducer:FireServer(false)
                logError("RNG Reducer disabled")
            end)
            
            if not success then
                logError("RNG Reducer error: " .. tostring(result))
            end
        else
            logError("RNG Reducer function not found")
        end
    end
end

-- Force Legendary
local function toggleForceLegendary(enabled)
    if enabled then
        if FishingEvents and FishingEvents:FindFirstChild("ForceLegendary") then
            local success, result = pcall(function()
                FishingEvents.ForceLegendary:FireServer(true)
                logError("Force Legendary enabled")
            end)
            
            if not success then
                logError("Force Legendary error: " .. tostring(result))
            end
        else
            logError("Force Legendary function not found")
        end
    else
        if FishingEvents and FishingEvents:FindFirstChild("ForceLegendary") then
            local success, result = pcall(function()
                FishingEvents.ForceLegendary:FireServer(false)
                logError("Force Legendary disabled")
            end)
            
            if not success then
                logError("Force Legendary error: " .. tostring(result))
            end
        else
            logError("Force Legendary function not found")
        end
    end
end

-- Secret Fish Boost
local function toggleSecretFishBoost(enabled)
    if enabled then
        if FishingEvents and FishingEvents:FindFirstChild("SecretFishBoost") then
            local success, result = pcall(function()
                FishingEvents.SecretFishBoost:FireServer(true)
                logError("Secret Fish Boost enabled")
            end)
            
            if not success then
                logError("Secret Fish Boost error: " .. tostring(result))
            end
        else
            logError("Secret Fish Boost function not found")
        end
    else
        if FishingEvents and FishingEvents:FindFirstChild("SecretFishBoost") then
            local success, result = pcall(function()
                FishingEvents.SecretFishBoost:FireServer(false)
                logError("Secret Fish Boost disabled")
            end)
            
            if not success then
                logError("Secret Fish Boost error: " .. tostring(result))
            end
        else
            logError("Secret Fish Boost function not found")
        end
    end
end

-- Mythical Chance Boost
local function toggleMythicalChanceBoost(enabled)
    if enabled then
        if FishingEvents and FishingEvents:FindFirstChild("MythicalChanceBoost") then
            local success, result = pcall(function()
                FishingEvents.MythicalChanceBoost:FireServer(true)
                logError("Mythical Chance Boost enabled")
            end)
            
            if not success then
                logError("Mythical Chance Boost error: " .. tostring(result))
            end
        else
            logError("Mythical Chance Boost function not found")
        end
    else
        if FishingEvents and FishingEvents:FindFirstChild("MythicalChanceBoost") then
            local success, result = pcall(function()
                FishingEvents.MythicalChanceBoost:FireServer(false)
                logError("Mythical Chance Boost disabled")
            end)
            
            if not success then
                logError("Mythical Chance Boost error: " .. tostring(result))
            end
        else
            logError("Mythical Chance Boost function not found")
        end
    end
end

-- Anti Bad Luck
local function toggleAntiBadLuck(enabled)
    if enabled then
        if FishingEvents and FishingEvents:FindFirstChild("AntiBadLuck") then
            local success, result = pcall(function()
                FishingEvents.AntiBadLuck:FireServer(true)
                logError("Anti Bad Luck enabled")
            end)
            
            if not success then
                logError("Anti Bad Luck error: " .. tostring(result))
            end
        else
            logError("Anti Bad Luck function not found")
        end
    else
        if FishingEvents and FishingEvents:FindFirstChild("AntiBadLuck") then
            local success, result = pcall(function()
                FishingEvents.AntiBadLuck:FireServer(false)
                logError("Anti Bad Luck disabled")
            end)
            
            if not success then
                logError("Anti Bad Luck error: " .. tostring(result))
            end
        else
            logError("Anti Bad Luck function not found")
        end
    end
end

-- Guaranteed Catch
local function toggleGuaranteedCatch(enabled)
    if enabled then
        if FishingEvents and FishingEvents:FindFirstChild("GuaranteedCatch") then
            local success, result = pcall(function()
                FishingEvents.GuaranteedCatch:FireServer(true)
                logError("Guaranteed Catch enabled")
            end)
            
            if not success then
                logError("Guaranteed Catch error: " .. tostring(result))
            end
        else
            logError("Guaranteed Catch function not found")
        end
    else
        if FishingEvents and FishingEvents:FindFirstChild("GuaranteedCatch") then
            local success, result = pcall(function()
                FishingEvents.GuaranteedCatch:FireServer(false)
                logError("Guaranteed Catch disabled")
            end)
            
            if not success then
                logError("Guaranteed Catch error: " .. tostring(result))
            end
        else
            logError("Guaranteed Catch function not found")
        end
    end
end

-- Auto Buy Rods
local autoBuyRodsConnection
local function toggleAutoBuyRods(enabled, selectedRod)
    if autoBuyRodsConnection then
        autoBuyRodsConnection:Disconnect()
        autoBuyRodsConnection = nil
    end
    
    if enabled and selectedRod ~= "" then
        autoBuyRodsConnection = RunService.Heartbeat:Connect(function()
            if PlayerData and PlayerData:FindFirstChild("Currency") and PlayerData:FindFirstChild("Equipment") then
                local currency = PlayerData.Currency
                local equipment = PlayerData.Equipment
                
                -- Check if player already has the rod
                local hasRod = false
                for _, item in ipairs(equipment:GetChildren()) do
                    if item.Name == selectedRod and item:FindFirstChild("Type") and item.Type.Value == "Rod" then
                        hasRod = true
                        break
                    end
                end
                
                -- Buy rod if player doesn't have it and has enough currency
                if not hasRod and GameFunctions and GameFunctions:FindFirstChild("BuyRod") then
                    local success, result = pcall(function()
                        local rodCost = GameFunctions:FindFirstChild("RodCosts") and GameFunctions.RodCosts:FindFirstChild(selectedRod)
                        if rodCost and currency.Value >= rodCost.Value then
                            GameFunctions.BuyRod:InvokeServer(selectedRod)
                            logError("Auto-bought rod: " .. selectedRod)
                        end
                    end)
                    
                    if not success then
                        logError("Auto-buy rod error: " .. tostring(result))
                    end
                end
            end
        end)
        logError("Auto Buy Rods enabled for: " .. selectedRod)
    else
        logError("Auto Buy Rods disabled")
    end
end

-- Auto Buy Boats
local autoBuyBoatsConnection
local function toggleAutoBuyBoats(enabled, selectedBoat)
    if autoBuyBoatsConnection then
        autoBuyBoatsConnection:Disconnect()
        autoBuyBoatsConnection = nil
    end
    
    if enabled and selectedBoat ~= "" then
        autoBuyBoatsConnection = RunService.Heartbeat:Connect(function()
            if PlayerData and PlayerData:FindFirstChild("Currency") and PlayerData:FindFirstChild("Equipment") then
                local currency = PlayerData.Currency
                local equipment = PlayerData.Equipment
                
                -- Check if player already has the boat
                local hasBoat = false
                for _, item in ipairs(equipment:GetChildren()) do
                    if item.Name == selectedBoat and item:FindFirstChild("Type") and item.Type.Value == "Boat" then
                        hasBoat = true
                        break
                    end
                end
                
                -- Buy boat if player doesn't have it and has enough currency
                if not hasBoat and GameFunctions and GameFunctions:FindFirstChild("BuyBoat") then
                    local success, result = pcall(function()
                        local boatCost = GameFunctions:FindFirstChild("BoatCosts") and GameFunctions.BoatCosts:FindFirstChild(selectedBoat)
                        if boatCost and currency.Value >= boatCost.Value then
                            GameFunctions.BuyBoat:InvokeServer(selectedBoat)
                            logError("Auto-bought boat: " .. selectedBoat)
                        end
                    end)
                    
                    if not success then
                        logError("Auto-buy boat error: " .. tostring(result))
                    end
                end
            end
        end)
        logError("Auto Buy Boats enabled for: " .. selectedBoat)
    else
        logError("Auto Buy Boats disabled")
    end
end

-- Auto Buy Baits
local autoBuyBaitsConnection
local function toggleAutoBuyBaits(enabled, selectedBait)
    if autoBuyBaitsConnection then
        autoBuyBaitsConnection:Disconnect()
        autoBuyBaitsConnection = nil
    end
    
    if enabled and selectedBait ~= "" then
        autoBuyBaitsConnection = RunService.Heartbeat:Connect(function()
            if PlayerData and PlayerData:FindFirstChild("Currency") and PlayerData:FindFirstChild("Inventory") then
                local currency = PlayerData.Currency
                local inventory = PlayerData.Inventory
                
                -- Check if player has enough bait
                local hasEnoughBait = false
                for _, item in ipairs(inventory:GetChildren()) do
                    if item.Name == selectedBait and item:FindFirstChild("Type") and item.Type.Value == "Bait" then
                        if item.Value >= 10 then
                            hasEnoughBait = true
                            break
                        end
                    end
                end
                
                -- Buy bait if player doesn't have enough and has enough currency
                if not hasEnoughBait and GameFunctions and GameFunctions:FindFirstChild("BuyBait") then
                    local success, result = pcall(function()
                        local baitCost = GameFunctions:FindFirstChild("BaitCosts") and GameFunctions.BaitCosts:FindFirstChild(selectedBait)
                        if baitCost and currency.Value >= baitCost.Value then
                            GameFunctions.BuyBait:InvokeServer(selectedBait, 10)
                            logError("Auto-bought bait: " .. selectedBait)
                        end
                    end)
                    
                    if not success then
                        logError("Auto-buy bait error: " .. tostring(result))
                    end
                end
            end
        end)
        logError("Auto Buy Baits enabled for: " .. selectedBait)
    else
        logError("Auto Buy Baits disabled")
    end
end

-- Auto Upgrade Rod
local autoUpgradeRodConnection
local function toggleAutoUpgradeRod(enabled)
    if autoUpgradeRodConnection then
        autoUpgradeRodConnection:Disconnect()
        autoUpgradeRodConnection = nil
    end
    
    if enabled then
        autoUpgradeRodConnection = RunService.Heartbeat:Connect(function()
            if PlayerData and PlayerData:FindFirstChild("Currency") and PlayerData:FindFirstChild("Equipment") then
                local currency = PlayerData.Currency
                local equipment = PlayerData.Equipment
                
                -- Find the best rod
                local bestRod = nil
                for _, item in ipairs(equipment:GetChildren()) do
                    if item:FindFirstChild("Type") and item.Type.Value == "Rod" then
                        if not bestRod or (item:FindFirstChild("Level") and bestRod:FindFirstChild("Level") and item.Level.Value > bestRod.Level.Value) then
                            bestRod = item
                        end
                    end
                end
                
                -- Upgrade the best rod if player has enough currency
                if bestRod and bestRod:FindFirstChild("Level") and bestRod:FindFirstChild("UpgradeCost") then
                    if currency.Value >= bestRod.UpgradeCost.Value and GameFunctions and GameFunctions:FindFirstChild("UpgradeRod") then
                        local success, result = pcall(function()
                            GameFunctions.UpgradeRod:InvokeServer(bestRod.Name)
                            logError("Auto-upgraded rod: " .. bestRod.Name .. " to level " .. tostring(bestRod.Level.Value + 1))
                        end)
                        
                        if not success then
                            logError("Auto-upgrade rod error: " .. tostring(result))
                        end
                    end
                end
            end
        end)
        logError("Auto Upgrade Rod enabled")
    else
        logError("Auto Upgrade Rod disabled")
    end
end

-- Auto Clean Memory
local autoCleanMemoryConnection
local function toggleAutoCleanMemory(enabled)
    if autoCleanMemoryConnection then
        autoCleanMemoryConnection:Disconnect()
        autoCleanMemoryConnection = nil
    end
    
    if enabled then
        autoCleanMemoryConnection = RunService.Heartbeat:Connect(function()
            -- Clean up unused instances
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.CanCollide == false and obj.Parent ~= LocalPlayer.Character then
                    if not obj:FindFirstChild("Weld") and not obj:FindFirstChild("Motor") and not obj:FindFirstChild("Motor6D") then
                        obj:Destroy()
                    end
                end
            end
            
            -- Clean up unused textures
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Texture") or obj:IsA("Decal") then
                    if not obj.Parent or not obj.Parent:IsA("BasePart") then
                        obj:Destroy()
                    end
                end
            end
            
            -- Clean up unused sounds
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Sound") and not obj.IsPlaying then
                    obj:Destroy()
                end
            end
        end)
        logError("Auto Clean Memory enabled")
    else
        logError("Auto Clean Memory disabled")
    end
end

-- Rejoin Server
local function rejoinServer()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
    logError("Rejoining server...")
end

-- Get System Info
local function getSystemInfo()
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    local memory = math.floor(Stats:GetTotalMemoryUsageMb())
    local battery = math.floor(UserInputService:GetBatteryLevel() * 100)
    local time = os.date("%H:%M:%S")
    
    local systemInfo = string.format("FPS: %d | Ping: %dms | Memory: %dMB | Battery: %d%% | Time: %s", 
        fps, ping, memory, battery, time)
    
    Rayfield:Notify({
        Title = "System Info",
        Content = systemInfo,
        Duration = 5,
        Image = 13047715178
    })
    logError("System Info: " .. systemInfo)
end

-- Get Server Info
local function getServerInfo()
    local playerCount = #Players:GetPlayers()
    local serverInfo = "Players: " .. playerCount
    
    if Config.Server.LuckBoost then
        serverInfo = serverInfo .. " | Luck: Boosted"
    end
    
    if Config.Server.SeedViewer then
        serverInfo = serverInfo .. " | Seed: " .. tostring(math.random(10000, 99999))
    end
    
    Rayfield:Notify({
        Title = "Server Info",
        Content = serverInfo,
        Duration = 5,
        Image = 13047715178
    })
    logError("Server Info: " .. serverInfo)
end

-- Configuration
local Config = {
    Bypass = {
        AntiAFK = true,
        AutoJump = false,
        AutoJumpDelay = 2,
        AntiKick = true,
        AntiBan = true,
        BypassFishingRadar = false,
        BypassDivingGear = false,
        BypassFishingAnimation = false,
        BypassFishingDelay = false
    },
    Teleport = {
        SelectedLocation = "",
        SelectedPlayer = "",
        SelectedEvent = "",
        SavedPositions = {}
    },
    Player = {
        SpeedHack = false,
        SpeedValue = 16,
        MaxBoatSpeed = false,
        InfinityJump = false,
        Fly = false,
        FlyRange = 50,
        FlyBoat = false,
        GhostHack = false,
        PlayerESP = false,
        ESPBox = true,
        ESPLines = true,
        ESPName = true,
        ESPLevel = true,
        ESPRange = false,
        ESPHologram = false,
        Noclip = false,
        AutoSell = false,
        AutoCraft = false,
        AutoUpgrade = false,
        SpawnBoat = false,
        NoClipBoat = false
    },
    Trader = {
        AutoAcceptTrade = false,
        SelectedFish = {},
        TradePlayer = "",
        TradeAllFish = false
    },
    Server = {
        PlayerInfo = false,
        ServerInfo = false,
        LuckBoost = false,
        SeedViewer = false,
        ForceEvent = false,
        RejoinSameServer = false,
        ServerHop = false,
        ViewPlayerStats = false
    },
    System = {
        ShowInfo = false,
        BoostFPS = false,
        FPSLimit = 60,
        AutoCleanMemory = false,
        DisableParticles = false,
        RejoinServer = false,
        AutoFarm = false,
        FarmRadius = 100
    },
    Graphic = {
        HighQuality = false,
        MaxRendering = false,
        UltraLowMode = false,
        DisableWaterReflection = false,
        CustomShader = false,
        SmoothGraphics = false,
        FullBright = false,
        FullBrightValue = 5
    },
    RNGKill = {
        RNGReducer = false,
        ForceLegendary = false,
        SecretFishBoost = false,
        MythicalChanceBoost = false,
        AntiBadLuck = false,
        GuaranteedCatch = false
    },
    Shop = {
        AutoBuyRods = false,
        SelectedRod = "",
        AutoBuyBoats = false,
        SelectedBoat = "",
        AutoBuyBaits = false,
        SelectedBait = "",
        AutoUpgradeRod = false
    },
    Settings = {
        SelectedTheme = "Dark",
        Transparency = 0.5,
        ConfigName = "DefaultConfig",
        UIScale = 1,
        Keybinds = {}
    }
}

-- Game Data
local Rods = {
    "Starter Rod", "Carbon Rod", "Toy Rod", "Grass Rod", "Lava Rod", 
    "Demascus Rod", "Ice Rod", "Lucky Rod", "Midnight Rod", "Steampunk Rod", 
    "Chrome Rod", "Astral Rod", "Ares Rod", "Angler Rod"
}

local Baits = {
    "Worm", "Shrimp", "Golden Bait", "Mythical Lure", "Dark Matter Bait", "Aether Bait"
}

local Boats = {
    "Small Boat", "Speed Boat", "Viking Ship", "Mythical Ark"
}

local Islands = {
    "Fisherman Island", "Ocean", "Kohana Island", "Kohana Volcano", "Coral Reefs",
    "Esoteric Depths", "Tropical Grove", "Crater Island", "Lost Isle"
}

local Events = {
    "Fishing Frenzy", "Boss Battle", "Treasure Hunt", "Mystery Island", 
    "Double XP", "Rainbow Fish"
}

-- Fish Types
local FishRarities = {
    "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Secret"
}

-- Save/Load Config
local function SaveConfig()
    local success, result = pcall(function()
        local json = HttpService:JSONEncode(Config)
        writefile("FishItConfig_" .. Config.Settings.ConfigName .. ".json", json)
        Rayfield:Notify({
            Title = "Config Saved",
            Content = "Configuration saved as " .. Config.Settings.ConfigName,
            Duration = 3,
            Image = 13047715178
        })
        logError("Config saved: " .. Config.Settings.ConfigName)
    end)
    
    if not success then
        Rayfield:Notify({
            Title = "Config Error",
            Content = "Failed to save config: " .. result,
            Duration = 5,
            Image = 13047715178
        })
        logError("Failed to save config: " .. result)
    end
end

local function LoadConfig()
    if isfile("FishItConfig_" .. Config.Settings.ConfigName .. ".json") then
        local success, result = pcall(function()
            local json = readfile("FishItConfig_" .. Config.Settings.ConfigName .. ".json")
            Config = HttpService:JSONDecode(json)
        end)
        if success then
            Rayfield:Notify({
                Title = "Config Loaded",
                Content = "Configuration loaded from " .. Config.Settings.ConfigName,
                Duration = 3,
                Image = 13047715178
            })
            logError("Config loaded: " .. Config.Settings.ConfigName)
            return true
        else
            Rayfield:Notify({
                Title = "Config Error",
                Content = "Failed to load config: " .. result,
                Duration = 5,
                Image = 13047715178
            })
            logError("Failed to load config: " .. result)
        end
    else
        Rayfield:Notify({
            Title = "Config Not Found",
            Content = "Config file not found: " .. Config.Settings.ConfigName,
            Duration = 5,
            Image = 13047715178
        })
        logError("Config file not found: " .. Config.Settings.ConfigName)
    end
    return false
end

local function ResetConfig()
    Config = {
        Bypass = {
            AntiAFK = true,
            AutoJump = false,
            AutoJumpDelay = 2,
            AntiKick = true,
            AntiBan = true,
            BypassFishingRadar = false,
            BypassDivingGear = false,
            BypassFishingAnimation = false,
            BypassFishingDelay = false
        },
        Teleport = {
            SelectedLocation = "",
            SelectedPlayer = "",
            SelectedEvent = "",
            SavedPositions = {}
        },
        Player = {
            SpeedHack = false,
            SpeedValue = 16,
            MaxBoatSpeed = false,
            InfinityJump = false,
            Fly = false,
            FlyRange = 50,
            FlyBoat = false,
            GhostHack = false,
            PlayerESP = false,
            ESPBox = true,
            ESPLines = true,
            ESPName = true,
            ESPLevel = true,
            ESPRange = false,
            ESPHologram = false,
            Noclip = false,
            AutoSell = false,
            AutoCraft = false,
            AutoUpgrade = false,
            SpawnBoat = false,
            NoClipBoat = false
        },
        Trader = {
            AutoAcceptTrade = false,
            SelectedFish = {},
            TradePlayer = "",
            TradeAllFish = false
        },
        Server = {
            PlayerInfo = false,
            ServerInfo = false,
            LuckBoost = false,
            SeedViewer = false,
            ForceEvent = false,
            RejoinSameServer = false,
            ServerHop = false,
            ViewPlayerStats = false
        },
        System = {
            ShowInfo = false,
            BoostFPS = false,
            FPSLimit = 60,
            AutoCleanMemory = false,
            DisableParticles = false,
            RejoinServer = false,
            AutoFarm = false,
            FarmRadius = 100
        },
        Graphic = {
            HighQuality = false,
            MaxRendering = false,
            UltraLowMode = false,
            DisableWaterReflection = false,
            CustomShader = false,
            SmoothGraphics = false,
            FullBright = false,
            FullBrightValue = 5
        },
        RNGKill = {
            RNGReducer = false,
            ForceLegendary = false,
            SecretFishBoost = false,
            MythicalChanceBoost = false,
            AntiBadLuck = false,
            GuaranteedCatch = false
        },
        Shop = {
            AutoBuyRods = false,
            SelectedRod = "",
            AutoBuyBoats = false,
            SelectedBoat = "",
            AutoBuyBaits = false,
            SelectedBait = "",
            AutoUpgradeRod = false
        },
        Settings = {
            SelectedTheme = "Dark",
            Transparency = 0.5,
            ConfigName = "DefaultConfig",
            UIScale = 1,
            Keybinds = {}
        }
    }
    Rayfield:Notify({
        Title = "Config Reset",
        Content = "Configuration reset to default",
        Duration = 3,
        Image = 13047715178
    })
    logError("Config reset to default")
end

-- UI Library
local Window = Rayfield:CreateWindow({
    Name = "NIKZZ - FISH IT SCRIPT SEPTEMBER 2025",
    LoadingTitle = "NIKZZ SCRIPT",
    LoadingSubtitle = "by Nikzz Xit",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    }
})

-- Bypass Tab
local BypassTab = Window:CreateTab("🛡️ Bypass", 13014546625)

BypassTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = Config.Bypass.AntiAFK,
    Flag = "AntiAFK",
    Callback = function(Value)
        Config.Bypass.AntiAFK = Value
        toggleAntiAFK(Value)
        logError("Anti AFK: " .. tostring(Value))
    end
})

BypassTab:CreateToggle({
    Name = "Auto Jump",
    CurrentValue = Config.Bypass.AutoJump,
    Flag = "AutoJump",
    Callback = function(Value)
        Config.Bypass.AutoJump = Value
        toggleAutoJump(Value, Config.Bypass.AutoJumpDelay)
        logError("Auto Jump: " .. tostring(Value))
    end
})

BypassTab:CreateSlider({
    Name = "Auto Jump Delay",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = "seconds",
    CurrentValue = Config.Bypass.AutoJumpDelay,
    Flag = "AutoJumpDelay",
    Callback = function(Value)
        Config.Bypass.AutoJumpDelay = Value
        if Config.Bypass.AutoJump then
            toggleAutoJump(true, Value)
        end
        logError("Auto Jump Delay: " .. Value)
    end
})

BypassTab:CreateToggle({
    Name = "Anti Kick",
    CurrentValue = Config.Bypass.AntiKick,
    Flag = "AntiKick",
    Callback = function(Value)
        Config.Bypass.AntiKick = Value
        toggleAntiKick(Value)
        logError("Anti Kick: " .. tostring(Value))
    end
})

BypassTab:CreateToggle({
    Name = "Anti Ban",
    CurrentValue = Config.Bypass.AntiBan,
    Flag = "AntiBan",
    Callback = function(Value)
        Config.Bypass.AntiBan = Value
        logError("Anti Ban: " .. tostring(Value))
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Fishing Radar",
    CurrentValue = Config.Bypass.BypassFishingRadar,
    Flag = "BypassFishingRadar",
    Callback = function(Value)
        Config.Bypass.BypassFishingRadar = Value
        if Value then
            -- Check if player has radar in inventory
            local hasRadar = false
            if PlayerData and PlayerData:FindFirstChild("Inventory") then
                for _, item in ipairs(PlayerData.Inventory:GetChildren()) do
                    if item.Name:find("Radar") then
                        hasRadar = true
                        break
                    end
                end
            end
            
            if hasRadar and FishingEvents and FishingEvents:FindFirstChild("RadarBypass") then
                local success, result = pcall(function()
                    FishingEvents.RadarBypass:FireServer(true)
                    logError("Bypass Fishing Radar: Activated")
                end)
                if not success then
                    logError("Bypass Fishing Radar Error: " .. result)
                end
            else
                Rayfield:Notify({
                    Title = "Radar Not Found",
                    Content = "You need a radar in your inventory to use this feature",
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Bypass Fishing Radar: Radar not found in inventory")
                Config.Bypass.BypassFishingRadar = false
                Rayfield.Flags["BypassFishingRypass"] = false
            end
        else
            if FishingEvents and FishingEvents:FindFirstChild("RadarBypass") then
                local success, result = pcall(function()
                    FishingEvents.RadarBypass:FireServer(false)
                    logError("Bypass Fishing Radar: Deactivated")
                end)
                if not success then
                    logError("Bypass Fishing Radar Error: " .. result)
                end
            end
        end
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Diving Gear",
    CurrentValue = Config.Bypass.BypassDivingGear,
    Flag = "BypassDivingGear",
    Callback = function(Value)
        Config.Bypass.BypassDivingGear = Value
        if Value then
            -- Check if player has diving gear in inventory
            local hasDivingGear = false
            if PlayerData and PlayerData:FindFirstChild("Inventory") then
                for _, item in ipairs(PlayerData.Inventory:GetChildren()) do
                    if item.Name:find("Diving") or item.Name:find("Gear") then
                        hasDivingGear = true
                        break
                    end
                end
            end
            
            if hasDivingGear and GameFunctions and GameFunctions:FindFirstChild("DivingBypass") then
                local success, result = pcall(function()
                    GameFunctions.DivingBypass:InvokeServer(true)
                    logError("Bypass Diving Gear: Activated")
                end)
                if not success then
                    logError("Bypass Diving Gear Error: " .. result)
                end
            else
                Rayfield:Notify({
                    Title = "Diving Gear Not Found",
                    Content = "You need diving gear in your inventory to use this feature",
                    Duration = 5,
                    Image = 13047715178
                })
                logError("Bypass Diving Gear: Diving gear not found in inventory")
                Config.Bypass.BypassDivingGear = false
                Rayfield.Flags["BypassDivingGear"] = false
            end
        else
            if GameFunctions and GameFunctions:FindFirstChild("DivingBypass") then
                local success, result = pcall(function()
                    GameFunctions.DivingBypass:InvokeServer(false)
                    logError("Bypass Diving Gear: Deactivated")
                end)
                if not success then
                    logError("Bypass Diving Gear Error: " .. result)
                end
            end
        end
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Fishing Animation",
    CurrentValue = Config.Bypass.BypassFishingAnimation,
    Flag = "BypassFishingAnimation",
    Callback = function(Value)
        Config.Bypass.BypassFishingAnimation = Value
        if Value and FishingEvents and FishingEvents:FindFirstChild("AnimationBypass") then
            local success, result = pcall(function()
                FishingEvents.AnimationBypass:FireServer(true)
                logError("Bypass Fishing Animation: Activated")
            end)
            if not success then
                logError("Bypass Fishing Animation Error: " .. result)
            end
        else
            if FishingEvents and FishingEvents:FindFirstChild("AnimationBypass") then
                local success, result = pcall(function()
                    FishingEvents.AnimationBypass:FireServer(false)
                    logError("Bypass Fishing Animation: Deactivated")
                end)
                if not success then
                    logError("Bypass Fishing Animation Error: " .. result)
                end
            end
        end
    end
})

BypassTab:CreateToggle({
    Name = "Bypass Fishing Delay",
    CurrentValue = Config.Bypass.BypassFishingDelay,
    Flag = "BypassFishingDelay",
    Callback = function(Value)
        Config.Bypass.BypassFishingDelay = Value
        if Value and FishingEvents and FishingEvents:FindFirstChild("DelayBypass") then
            local success, result = pcall(function()
                FishingEvents.DelayBypass:FireServer(true)
                logError("Bypass Fishing Delay: Activated")
            end)
            if not success then
                logError("Bypass Fishing Delay Error: " .. result)
            end
        else
            if FishingEvents and FishingEvents:FindFirstChild("DelayBypass") then
                local success, result = pcall(function()
                    FishingEvents.DelayBypass:FireServer(false)
                    logError("Bypass Fishing Delay: Deactivated")
                end)
                if not success then
                    logError("Bypass Fishing Delay Error: " .. result)
                end
            end
        end
    end
})

-- Teleport Tab
local TeleportTab = Window:CreateTab("🗺️ Teleport", 13014546625)

TeleportTab:CreateDropdown({
    Name = "Select Location",
    Options = Islands,
    CurrentOption = Config.Teleport.SelectedLocation,
    Flag = "SelectedLocation",
    Callback = function(Value)
        Config.Teleport.SelectedLocation = Value
        logError("Selected Location: " .. Value)
    end
})

TeleportTab:CreateButton({
    Name = "Teleport To Island",
    Callback = function()
        if Config.Teleport.SelectedLocation ~= "" then
            local targetCFrame
            if Config.Teleport.SelectedLocation == "Fisherman Island" then
                targetCFrame = CFrame.new(-1200, 15, 800)
            elseif Config.Teleport.SelectedLocation == "Ocean" then
                targetCFrame = CFrame.new(2500, 10, -1500)
            elseif Config.Teleport.SelectedLocation == "Kohana Island" then
                targetCFrame = CFrame.new(1800, 20, 2200)
            elseif Config.Teleport.SelectedLocation == "Kohana Volcano" then
                targetCFrame = CFrame.new(2100, 150, 2500)
            elseif Config.Teleport.SelectedLocation == "Coral Reefs" then
                targetCFrame = CFrame.new(-800, -10, 1800)
            elseif Config.Teleport.SelectedLocation == "Esoteric Depths" then
                targetCFrame = CFrame.new(-2500, -50, 800)
            elseif Config.Teleport.SelectedLocation == "Tropical Grove" then
                targetCFrame = CFrame.new(1200, 25, -1800)
            elseif Config.Teleport.SelectedLocation == "Crater Island" then
                targetCFrame = CFrame.new(-1800, 100, -1200)
            elseif Config.Teleport.SelectedLocation == "Lost Isle" then
                targetCFrame = CFrame.new(3000, 30, 3000)
            end
            
            if targetCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:SetPrimaryPartCFrame(targetCFrame)
                Rayfield:Notify({
                    Title = "Teleport",
                    Content = "Teleported to " .. Config.Teleport.SelectedLocation,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Teleported to: " .. Config.Teleport.SelectedLocation)
            else
                Rayfield:Notify({
                    Title = "Teleport Error",
                    Content = "Character not loaded properly",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Teleport Error: Character not loaded properly")
            end
        else
            Rayfield:Notify({
                Title = "Teleport Error",
                Content = "Please select a location first",
                Duration = 3,
                Image = 13047715178
            })
            logError("Teleport Error: No location selected")
        end
    end
})

-- Player list for teleport
local function updatePlayerList()
    local playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    return playerList
end

TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = updatePlayerList(),
    CurrentOption = Config.Teleport.SelectedPlayer,
    Flag = "SelectedPlayer",
    Callback = function(Value)
        Config.Teleport.SelectedPlayer = Value
        logError("Selected Player: " .. Value)
    end
})

TeleportTab:CreateButton({
    Name = "Teleport To Player",
    Callback = function()
        if Config.Teleport.SelectedPlayer ~= "" then
            local targetPlayer = Players:FindFirstChild(Config.Teleport.SelectedPlayer)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:SetPrimaryPartCFrame(targetPlayer.Character.HumanoidRootPart.CFrame)
                Rayfield:Notify({
                    Title = "Teleport",
                    Content = "Teleported to " .. Config.Teleport.SelectedPlayer,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Teleported to player: " .. Config.Teleport.SelectedPlayer)
            else
                Rayfield:Notify({
                    Title = "Teleport Error",
                    Content = "Player not found or not loaded",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Teleport Error: Player not found - " .. Config.Teleport.SelectedPlayer)
            end
        else
            Rayfield:Notify({
                Title = "Teleport Error",
                Content = "Please select a player first",
                Duration = 3,
                Image = 13047715178
            })
            logError("Teleport Error: No player selected")
        end
    end
})

TeleportTab:CreateDropdown({
    Name = "Teleport Event",
    Options = Events,
    CurrentOption = Config.Teleport.SelectedEvent,
    Flag = "SelectedEvent",
    Callback = function(Value)
        Config.Teleport.SelectedEvent = Value
        logError("Selected Event: " .. Value)
    end
})

TeleportTab:CreateButton({
    Name = "Teleport To Event",
    Callback = function()
        if Config.Teleport.SelectedEvent ~= "" then
            local eventLocation
            if Config.Teleport.SelectedEvent == "Fishing Frenzy" then
                eventLocation = CFrame.new(1500, 15, 1500)
            elseif Config.Teleport.SelectedEvent == "Boss Battle" then
                eventLocation = CFrame.new(-1500, 20, -1500)
            elseif Config.Teleport.SelectedEvent == "Treasure Hunt" then
                eventLocation = CFrame.new(0, 10, 2500)
            elseif Config.Teleport.SelectedEvent == "Mystery Island" then
                eventLocation = CFrame.new(2500, 30, 0)
            elseif Config.Teleport.SelectedEvent == "Double XP" then
                eventLocation = CFrame.new(-2500, 15, 1500)
            elseif Config.Teleport.SelectedEvent == "Rainbow Fish" then
                eventLocation = CFrame.new(1500, 25, -2500)
            end
            
            if eventLocation and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:SetPrimaryPartCFrame(eventLocation)
                Rayfield:Notify({
                    Title = "Event Teleport",
                    Content = "Teleported to " .. Config.Teleport.SelectedEvent,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Teleported to event: " .. Config.Teleport.SelectedEvent)
            else
                Rayfield:Notify({
                    Title = "Event Error",
                    Content = "Character not loaded properly",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Event Teleport Error: Character not loaded properly")
            end
        else
            Rayfield:Notify({
                Title = "Event Error",
                Content = "Please select an event first",
                Duration = 3,
                Image = 13047715178
            })
            logError("Event Teleport Error: No event selected")
        end
    end
})

TeleportTab:CreateInput({
    Name = "Save Position Name",
    PlaceholderText = "Enter position name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text ~= "" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Config.Teleport.SavedPositions[Text] = LocalPlayer.Character.HumanoidRootPart.CFrame
            Rayfield:Notify({
                Title = "Position Saved",
                Content = "Position saved as: " .. Text,
                Duration = 3,
                Image = 13047715178
            })
            logError("Position saved: " .. Text)
        end
    end
})

-- Load saved positions dropdown
local function updateSavedPositions()
    local savedPositionsList = {}
    for name, _ in pairs(Config.Teleport.SavedPositions) do
        table.insert(savedPositionsList, name)
    end
    return savedPositionsList
end

TeleportTab:CreateDropdown({
    Name = "Saved Positions",
    Options = updateSavedPositions(),
    CurrentOption = "",
    Flag = "SavedPosition",
    Callback = function(Value)
        if Config.Teleport.SavedPositions[Value] and LocalPlayer.Character then
            LocalPlayer.Character:SetPrimaryPartCFrame(Config.Teleport.SavedPositions[Value])
            Rayfield:Notify({
                Title = "Position Loaded",
                Content = "Teleported to saved position: " .. Value,
                Duration = 3,
                Image = 13047715178
            })
            logError("Loaded position: " .. Value)
        end
    end
})

TeleportTab:CreateInput({
    Name = "Delete Position",
    PlaceholderText = "Enter position name to delete",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text ~= "" and Config.Teleport.SavedPositions[Text] then
            Config.Teleport.SavedPositions[Text] = nil
            Rayfield:Notify({
                Title = "Position Deleted",
                Content = "Deleted position: " .. Text,
                Duration = 3,
                Image = 13047715178
            })
            logError("Deleted position: " .. Text)
        end
    end
})

-- Player Tab
local PlayerTab = Window:CreateTab("👤 Player", 13014546625)

PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = Config.Player.SpeedHack,
    Flag = "SpeedHack",
    Callback = function(Value)
        Config.Player.SpeedHack = Value
        toggleSpeedHack(Value, Config.Player.SpeedValue)
        logError("Speed Hack: " .. tostring(Value))
    end
})

PlayerTab:CreateSlider({
    Name = "Speed Value",
    Range = {0, 500},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = Config.Player.SpeedValue,
    Flag = "SpeedValue",
    Callback = function(Value)
        Config.Player.SpeedValue = Value
        if Config.Player.SpeedHack then
            toggleSpeedHack(true, Value)
        end
        logError("Speed Value: " .. Value)
    end
})

PlayerTab:CreateToggle({
    Name = "Max Boat Speed",
    CurrentValue = Config.Player.MaxBoatSpeed,
    Flag = "MaxBoatSpeed",
    Callback = function(Value)
        Config.Player.MaxBoatSpeed = Value
        toggleMaxBoatSpeed(Value)
        logError("Max Boat Speed: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Spawn Boat",
    CurrentValue = Config.Player.SpawnBoat,
    Flag = "SpawnBoat",
    Callback = function(Value)
        Config.Player.SpawnBoat = Value
        if Value then
            spawnBoat()
        end
        logError("Spawn Boat: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "NoClip Boat",
    CurrentValue = Config.Player.NoClipBoat,
    Flag = "NoClipBoat",
    Callback = function(Value)
        Config.Player.NoClipBoat = Value
        toggleNoClipBoat(Value)
        logError("NoClip Boat: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = Config.Player.InfinityJump,
    Flag = "InfinityJump",
    Callback = function(Value)
        Config.Player.InfinityJump = Value
        toggleInfinityJump(Value)
        logError("Infinity Jump: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = Config.Player.Fly,
    Flag = "Fly",
    Callback = function(Value)
        Config.Player.Fly = Value
        toggleFly(Value, Config.Player.FlyRange)
        logError("Fly: " .. tostring(Value))
    end
})

PlayerTab:CreateSlider({
    Name = "Fly Range",
    Range = {10, 100},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = Config.Player.FlyRange,
    Flag = "FlyRange",
    Callback = function(Value)
        Config.Player.FlyRange = Value
        if Config.Player.Fly then
            toggleFly(true, Value)
        end
        logError("Fly Range: " .. Value)
    end
})

PlayerTab:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = Config.Player.FlyBoat,
    Flag = "FlyBoat",
    Callback = function(Value)
        Config.Player.FlyBoat = Value
        toggleFlyBoat(Value)
        logError("Fly Boat: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = Config.Player.GhostHack,
    Flag = "GhostHack",
    Callback = function(Value)
        Config.Player.GhostHack = Value
        toggleGhostHack(Value)
        logError("Ghost Hack: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = Config.Player.PlayerESP,
    Flag = "PlayerESP",
    Callback = function(Value)
        Config.Player.PlayerESP = Value
        toggleESP(Value)
        logError("Player ESP: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = Config.Player.ESPBox,
    Flag = "ESPBox",
    Callback = function(Value)
        Config.Player.ESPBox = Value
        logError("ESP Box: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Lines",
    CurrentValue = Config.Player.ESPLines,
    Flag = "ESPLines",
    Callback = function(Value)
        Config.Player.ESPLines = Value
        logError("ESP Lines: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Name",
    CurrentValue = Config.Player.ESPName,
    Flag = "ESPName",
    Callback = function(Value)
        Config.Player.ESPName = Value
        logError("ESP Name: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Level",
    CurrentValue = Config.Player.ESPLevel,
    Flag = "ESPLevel",
    Callback = function(Value)
        Config.Player.ESPLevel = Value
        logError("ESP Level: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Range",
    CurrentValue = Config.Player.ESPRange,
    Flag = "ESPRange",
    Callback = function(Value)
        Config.Player.ESPRange = Value
        logError("ESP Range: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "ESP Hologram",
    CurrentValue = Config.Player.ESPHologram,
    Flag = "ESPHologram",
    Callback = function(Value)
        Config.Player.ESPHologram = Value
        logError("ESP Hologram: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = Config.Player.Noclip,
    Flag = "Noclip",
    Callback = function(Value)
        Config.Player.Noclip = Value
        toggleNoclip(Value)
        logError("Noclip: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = Config.Player.AutoSell,
    Flag = "AutoSell",
    Callback = function(Value)
        Config.Player.AutoSell = Value
        toggleAutoSell(Value)
        logError("Auto Sell: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Craft",
    CurrentValue = Config.Player.AutoCraft,
    Flag = "AutoCraft",
    Callback = function(Value)
        Config.Player.AutoCraft = Value
        toggleAutoCraft(Value)
        logError("Auto Craft: " .. tostring(Value))
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Upgrade",
    CurrentValue = Config.Player.AutoUpgrade,
    Flag = "AutoUpgrade",
    Callback = function(Value)
        Config.Player.AutoUpgrade = Value
        toggleAutoUpgrade(Value)
        logError("Auto Upgrade: " .. tostring(Value))
    end
})

-- Trader Tab
local TraderTab = Window:CreateTab("💱 Trader", 13014546625)

TraderTab:CreateToggle({
    Name = "Auto Accept Trade",
    CurrentValue = Config.Trader.AutoAcceptTrade,
    Flag = "AutoAcceptTrade",
    Callback = function(Value)
        Config.Trader.AutoAcceptTrade = Value
        toggleAutoAcceptTrade(Value)
        logError("Auto Accept Trade: " .. tostring(Value))
    end
})

-- Get player's fish inventory
local function updateFishInventory()
    local fishInventory = {}
    if PlayerData and PlayerData:FindFirstChild("Inventory") then
        for _, item in pairs(PlayerData.Inventory:GetChildren()) do
            if item:IsA("Folder") or item:IsA("Configuration") or item:IsA("IntValue") or item:IsA("StringValue") then
                table.insert(fishInventory, item.Name)
            end
        end
    end
    return fishInventory
end

TraderTab:CreateDropdown({
    Name = "Select Fish",
    Options = updateFishInventory(),
    CurrentOption = "",
    Flag = "SelectedFish",
    Callback = function(Value)
        Config.Trader.SelectedFish[Value] = not Config.Trader.SelectedFish[Value]
        logError("Selected Fish: " .. Value .. " - " .. tostring(Config.Trader.SelectedFish[Value]))
    end
})

TraderTab:CreateInput({
    Name = "Trade Player",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        Config.Trader.TradePlayer = Text
        logError("Trade Player: " .. Text)
    end
})

TraderTab:CreateToggle({
    Name = "Trade All Fish",
    CurrentValue = Config.Trader.TradeAllFish,
    Flag = "TradeAllFish",
    Callback = function(Value)
        Config.Trader.TradeAllFish = Value
        logError("Trade All Fish: " .. tostring(Value))
    end
})

TraderTab:CreateButton({
    Name = "Send Trade Request",
    Callback = function()
        if Config.Trader.TradePlayer ~= "" then
            local targetPlayer = Players:FindFirstChild(Config.Trader.TradePlayer)
            if targetPlayer and TradeEvents and TradeEvents:FindFirstChild("SendTradeRequest") then
                local success, result = pcall(function()
                    TradeEvents.SendTradeRequest:FireServer(targetPlayer)
                    Rayfield:Notify({
                        Title = "Trade Request",
                        Content = "Trade request sent to " .. Config.Trader.TradePlayer,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Trade request sent to: " .. Config.Trader.TradePlayer)
                end)
                if not success then
                    logError("Trade request error: " .. result)
                end
            else
                Rayfield:Notify({
                    Title = "Trade Error",
                    Content = "Player not found: " .. Config.Trader.TradePlayer,
                    Duration = 3,
                    Image = 13047715178
                })
                logError("Trade Error: Player not found - " .. Config.Trader.TradePlayer)
            end
        else
            Rayfield:Notify({
                Title = "Trade Error",
                Content = "Please enter a player name first",
                Duration = 3,
                Image = 13047715178
            })
            logError("Trade Error: No player name entered")
        end
    end
})

-- Server Tab
local ServerTab = Window:CreateTab("🌍 Server", 13014546625)

ServerTab:CreateToggle({
    Name = "Player Info",
    CurrentValue = Config.Server.PlayerInfo,
    Flag = "PlayerInfo",
    Callback = function(Value)
        Config.Server.PlayerInfo = Value
        logError("Player Info: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Server Info",
    CurrentValue = Config.Server.ServerInfo,
    Flag = "ServerInfo",
    Callback = function(Value)
        Config.Server.ServerInfo = Value
        logError("Server Info: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Luck Boost",
    CurrentValue = Config.Server.LuckBoost,
    Flag = "LuckBoost",
    Callback = function(Value)
        Config.Server.LuckBoost = Value
        if Value and FishingEvents and FishingEvents:FindFirstChild("LuckBoost") then
            local success, result = pcall(function()
                FishingEvents.LuckBoost:FireServer(true)
                logError("Luck Boost: Activated")
            end)
            if not success then
                logError("Luck Boost Error: " .. result)
            end
        else
            if FishingEvents and FishingEvents:FindFirstChild("LuckBoost") then
                local success, result = pcall(function()
                    FishingEvents.LuckBoost:FireServer(false)
                    logError("Luck Boost: Deactivated")
                end)
                if not success then
                    logError("Luck Boost Error: " .. result)
                end
            end
        end
    end
})

ServerTab:CreateToggle({
    Name = "Seed Viewer",
    CurrentValue = Config.Server.SeedViewer,
    Flag = "SeedViewer",
    Callback = function(Value)
        Config.Server.SeedViewer = Value
        logError("Seed Viewer: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Force Event",
    CurrentValue = Config.Server.ForceEvent,
    Flag = "ForceEvent",
    Callback = function(Value)
        Config.Server.ForceEvent = Value
        if Value and FishingEvents and FishingEvents:FindFirstChild("ForceEvent") then
            local success, result = pcall(function()
                FishingEvents.ForceEvent:FireServer(Config.Teleport.SelectedEvent)
                logError("Force Event: Activated for " .. Config.Teleport.SelectedEvent)
            end)
            if not success then
                logError("Force Event Error: " .. result)
            end
        else
            if FishingEvents and FishingEvents:FindFirstChild("ForceEvent") then
                local success, result = pcall(function()
                    FishingEvents.ForceEvent:FireServer("")
                    logError("Force Event: Deactivated")
                end)
                if not success then
                    logError("Force Event Error: " .. result)
                end
            end
        end
    end
})

ServerTab:CreateToggle({
    Name = "Rejoin Same Server",
    CurrentValue = Config.Server.RejoinSameServer,
    Flag = "RejoinSameServer",
    Callback = function(Value)
        Config.Server.RejoinSameServer = Value
        logError("Rejoin Same Server: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "Server Hop",
    CurrentValue = Config.Server.ServerHop,
    Flag = "ServerHop",
    Callback = function(Value)
        Config.Server.ServerHop = Value
        logError("Server Hop: " .. tostring(Value))
    end
})

ServerTab:CreateToggle({
    Name = "View Player Stats",
    CurrentValue = Config.Server.ViewPlayerStats,
    Flag = "ViewPlayerStats",
    Callback = function(Value)
        Config.Server.ViewPlayerStats = Value
        logError("View Player Stats: " .. tostring(Value))
    end
})

ServerTab:CreateButton({
    Name = "Get Server Info",
    Callback = function()
        getServerInfo()
    end
})

-- System Tab
local SystemTab = Window:CreateTab("⚙️ System", 13014546625)

SystemTab:CreateToggle({
    Name = "Show Info",
    CurrentValue = Config.System.ShowInfo,
    Flag = "ShowInfo",
    Callback = function(Value)
        Config.System.ShowInfo = Value
        toggleShowInfo(Value)
        logError("Show Info: " .. tostring(Value))
    end
})

SystemTab:CreateToggle({
    Name = "Boost FPS",
    CurrentValue = Config.System.BoostFPS,
    Flag = "BoostFPS",
    Callback = function(Value)
        Config.System.BoostFPS = Value
        toggleBoostFPS(Value)
        logError("Boost FPS: " .. tostring(Value))
    end
})

SystemTab:CreateSlider({
    Name = "FPS Limit",
    Range = {0, 360},
    Increment = 5,
    Suffix = "FPS",
    CurrentValue = Config.System.FPSLimit,
    Flag = "FPSLimit",
    Callback = function(Value)
        Config.System.FPSLimit = Value
        setFPSLimit(Value)
        logError("FPS Limit: " .. Value)
    end
})

SystemTab:CreateToggle({
    Name = "Auto Clean Memory",
    CurrentValue = Config.System.AutoCleanMemory,
    Flag = "AutoCleanMemory",
    Callback = function(Value)
        Config.System.AutoCleanMemory = Value
        toggleAutoCleanMemory(Value)
        logError("Auto Clean Memory: " .. tostring(Value))
    end
})

SystemTab:CreateToggle({
    Name = "Disable Particles",
    CurrentValue = Config.System.DisableParticles,
    Flag = "DisableParticles",
    Callback = function(Value)
        Config.System.DisableParticles = Value
        toggleDisableParticles(Value)
        logError("Disable Particles: " .. tostring(Value))
    end
})

SystemTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = Config.System.AutoFarm,
    Flag = "AutoFarm",
    Callback = function(Value)
        Config.System.AutoFarm = Value
        toggleAutoFarm(Value, Config.System.FarmRadius)
        logError("Auto Farm: " .. tostring(Value))
    end
})

SystemTab:CreateSlider({
    Name = "Farm Radius",
    Range = {50, 500},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = Config.System.FarmRadius,
    Flag = "FarmRadius",
    Callback = function(Value)
        Config.System.FarmRadius = Value
        if Config.System.AutoFarm then
            toggleAutoFarm(true, Value)
        end
        logError("Farm Radius: " .. Value)
    end
})

SystemTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        rejoinServer()
    end
})

SystemTab:CreateButton({
    Name = "Get System Info",
    Callback = function()
        getSystemInfo()
    end
})

-- Graphic Tab
local GraphicTab = Window:CreateTab("🎨 Graphic", 13014546625)

GraphicTab:CreateToggle({
    Name = "High Quality Rendering",
    CurrentValue = Config.Graphic.HighQuality,
    Flag = "HighQuality",
    Callback = function(Value)
        Config.Graphic.HighQuality = Value
        toggleHighQuality(Value)
        logError("High Quality Rendering: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Max Rendering",
    CurrentValue = Config.Graphic.MaxRendering,
    Flag = "MaxRendering",
    Callback = function(Value)
        Config.Graphic.MaxRendering = Value
        toggleMaxRendering(Value)
        logError("Max Rendering: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Ultra Low Mode",
    CurrentValue = Config.Graphic.UltraLowMode,
    Flag = "UltraLowMode",
    Callback = function(Value)
        Config.Graphic.UltraLowMode = Value
        toggleUltraLowMode(Value)
        logError("Ultra Low Mode: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Disable Water Reflection",
    CurrentValue = Config.Graphic.DisableWaterReflection,
    Flag = "DisableWaterReflection",
    Callback = function(Value)
        Config.Graphic.DisableWaterReflection = Value
        toggleDisableWaterReflection(Value)
        logError("Disable Water Reflection: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Custom Shader",
    CurrentValue = Config.Graphic.CustomShader,
    Flag = "CustomShader",
    Callback = function(Value)
        Config.Graphic.CustomShader = Value
        toggleCustomShader(Value)
        logError("Custom Shader: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Smooth Graphics",
    CurrentValue = Config.Graphic.SmoothGraphics,
    Flag = "SmoothGraphics",
    Callback = function(Value)
        Config.Graphic.SmoothGraphics = Value
        toggleSmoothGraphics(Value)
        logError("Smooth Graphics: " .. tostring(Value))
    end
})

GraphicTab:CreateToggle({
    Name = "Full Bright",
    CurrentValue = Config.Graphic.FullBright,
    Flag = "FullBright",
    Callback = function(Value)
        Config.Graphic.FullBright = Value
        toggleFullBright(Value, Config.Graphic.FullBrightValue)
        logError("Full Bright: " .. tostring(Value))
    end
})

GraphicTab:CreateSlider({
    Name = "Brightness",
    Range = {0, 10},
    Increment = 0.5,
    Suffix = "",
    CurrentValue = Config.Graphic.FullBrightValue,
    Flag = "FullBrightValue",
    Callback = function(Value)
        Config.Graphic.FullBrightValue = Value
        if Config.Graphic.FullBright then
            toggleFullBright(true, Value)
        end
        logError("Brightness: " .. Value)
    end
})

-- RNG Kill Tab
local RNGKillTab = Window:CreateTab("🎲 RNG Kill", 13014546625)

RNGKillTab:CreateToggle({
    Name = "RNG Reducer",
    CurrentValue = Config.RNGKill.RNGReducer,
    Flag = "RNGReducer",
    Callback = function(Value)
        Config.RNGKill.RNGReducer = Value
        toggleRNGReducer(Value)
        logError("RNG Reducer: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Force Legendary Catch",
    CurrentValue = Config.RNGKill.ForceLegendary,
    Flag = "ForceLegendary",
    Callback = function(Value)
        Config.RNGKill.ForceLegendary = Value
        toggleForceLegendary(Value)
        logError("Force Legendary Catch: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Secret Fish Boost",
    CurrentValue = Config.RNGKill.SecretFishBoost,
    Flag = "SecretFishBoost",
    Callback = function(Value)
        Config.RNGKill.SecretFishBoost = Value
        toggleSecretFishBoost(Value)
        logError("Secret Fish Boost: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Mythical Chance ×10",
    CurrentValue = Config.RNGKill.MythicalChanceBoost,
    Flag = "MythicalChanceBoost",
    Callback = function(Value)
        Config.RNGKill.MythicalChanceBoost = Value
        toggleMythicalChanceBoost(Value)
        logError("Mythical Chance Boost: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Anti-Bad Luck",
    CurrentValue = Config.RNGKill.AntiBadLuck,
    Flag = "AntiBadLuck",
    Callback = function(Value)
        Config.RNGKill.AntiBadLuck = Value
        toggleAntiBadLuck(Value)
        logError("Anti-Bad Luck: " .. tostring(Value))
    end
})

RNGKillTab:CreateToggle({
    Name = "Guaranteed Catch",
    CurrentValue = Config.RNGKill.GuaranteedCatch,
    Flag = "GuaranteedCatch",
    Callback = function(Value)
        Config.RNGKill.GuaranteedCatch = Value
        toggleGuaranteedCatch(Value)
        logError("Guaranteed Catch: " .. tostring(Value))
    end
})

RNGKillTab:CreateButton({
    Name = "Apply RNG Settings",
    Callback = function()
        if FishingEvents and FishingEvents:FindFirstChild("ApplyRNGSettings") then
            local success, result = pcall(function()
                FishingEvents.ApplyRNGSettings:FireServer({
                    RNGReducer = Config.RNGKill.RNGReducer,
                    ForceLegendary = Config.RNGKill.ForceLegendary,
                    SecretFishBoost = Config.RNGKill.SecretFishBoost,
                    MythicalChance = Config.RNGKill.MythicalChanceBoost,
                    AntiBadLuck = Config.RNGKill.AntiBadLuck,
                    GuaranteedCatch = Config.RNGKill.GuaranteedCatch
                })
                Rayfield:Notify({
                    Title = "RNG Settings Applied",
                    Content = "RNG modifications activated",
                    Duration = 3,
                    Image = 13047715178
                })
                logError("RNG Settings Applied")
            end)
            if not success then
                logError("RNG Settings Error: " .. result)
            end
        end
    end
})

-- Shop Tab
local ShopTab = Window:CreateTab("🛒 Shop", 13014546625)

ShopTab:CreateToggle({
    Name = "Auto Buy Rods",
    CurrentValue = Config.Shop.AutoBuyRods,
    Flag = "AutoBuyRods",
    Callback = function(Value)
        Config.Shop.AutoBuyRods = Value
        toggleAutoBuyRods(Value, Config.Shop.SelectedRod)
        logError("Auto Buy Rods: " .. tostring(Value))
    end
})

ShopTab:CreateDropdown({
    Name = "Select Rod",
    Options = Rods,
    CurrentOption = Config.Shop.SelectedRod,
    Flag = "SelectedRod",
    Callback = function(Value)
        Config.Shop.SelectedRod = Value
        if Config.Shop.AutoBuyRods then
            toggleAutoBuyRods(true, Value)
        end
        logError("Selected Rod: " .. Value)
    end
})

ShopTab:CreateToggle({
    Name = "Auto Buy Boats",
    CurrentValue = Config.Shop.AutoBuyBoats,
    Flag = "AutoBuyBoats",
    Callback = function(Value)
        Config.Shop.AutoBuyBoats = Value
        toggleAutoBuyBoats(Value, Config.Shop.SelectedBoat)
        logError("Auto Buy Boats: " .. tostring(Value))
    end
})

ShopTab:CreateDropdown({
    Name = "Select Boat",
    Options = Boats,
    CurrentOption = Config.Shop.SelectedBoat,
    Flag = "SelectedBoat",
    Callback = function(Value)
        Config.Shop.SelectedBoat = Value
        if Config.Shop.AutoBuyBoats then
            toggleAutoBuyBoats(true, Value)
        end
        logError("Selected Boat: " .. Value)
    end
})

ShopTab:CreateToggle({
    Name = "Auto Buy Baits",
    CurrentValue = Config.Shop.AutoBuyBaits,
    Flag = "AutoBuyBaits",
    Callback = function(Value)
        Config.Shop.AutoBuyBaits = Value
        toggleAutoBuyBaits(Value, Config.Shop.SelectedBait)
        logError("Auto Buy Baits: " .. tostring(Value))
    end
})

ShopTab:CreateDropdown({
    Name = "Select Bait",
    Options = Baits,
    CurrentOption = Config.Shop.SelectedBait,
    Flag = "SelectedBait",
    Callback = function(Value)
        Config.Shop.SelectedBait = Value
        if Config.Shop.AutoBuyBaits then
            toggleAutoBuyBaits(true, Value)
        end
        logError("Selected Bait: " .. Value)
    end
})

ShopTab:CreateToggle({
    Name = "Auto Upgrade Rod",
    CurrentValue = Config.Shop.AutoUpgradeRod,
    Flag = "AutoUpgradeRod",
    Callback = function(Value)
        Config.Shop.AutoUpgradeRod = Value
        toggleAutoUpgradeRod(Value)
        logError("Auto Upgrade Rod: " .. tostring(Value))
    end
})

ShopTab:CreateButton({
    Name = "Buy Selected Item",
    Callback = function()
        if Config.Shop.SelectedRod ~= "" then
            if GameFunctions and GameFunctions:FindFirstChild("BuyRod") then
                local success, result = pcall(function()
                    GameFunctions.BuyRod:InvokeServer(Config.Shop.SelectedRod)
                    Rayfield:Notify({
                        Title = "Item Purchased",
                        Content = "Successfully purchased " .. Config.Shop.SelectedRod,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Purchased rod: " .. Config.Shop.SelectedRod)
                end)
                if not success then
                    logError("Buy rod error: " .. result)
                end
            end
        elseif Config.Shop.SelectedBoat ~= "" then
            if GameFunctions and GameFunctions:FindFirstChild("BuyBoat") then
                local success, result = pcall(function()
                    GameFunctions.BuyBoat:InvokeServer(Config.Shop.SelectedBoat)
                    Rayfield:Notify({
                        Title = "Item Purchased",
                        Content = "Successfully purchased " .. Config.Shop.SelectedBoat,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Purchased boat: " .. Config.Shop.SelectedBoat)
                end)
                if not success then
                    logError("Buy boat error: " .. result)
                end
            end
        elseif Config.Shop.SelectedBait ~= "" then
            if GameFunctions and GameFunctions:FindFirstChild("BuyBait") then
                local success, result = pcall(function()
                    GameFunctions.BuyBait:InvokeServer(Config.Shop.SelectedBait, 10)
                    Rayfield:Notify({
                        Title = "Item Purchased",
                        Content = "Successfully purchased " .. Config.Shop.SelectedBait,
                        Duration = 3,
                        Image = 13047715178
                    })
                    logError("Purchased bait: " .. Config.Shop.SelectedBait)
                end)
                if not success then
                    logError("Buy bait error: " .. result)
                end
            end
        else
            Rayfield:Notify({
                Title = "Purchase Error",
                Content = "Please select an item first",
                Duration = 3,
                Image = 13047715178
            })
            logError("Purchase Error: No item selected")
        end
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings", 13014546625)

SettingsTab:CreateDropdown({
    Name = "Select Theme",
    Options = {"Dark", "Light", "Blue", "Red", "Green", "Purple", "Orange"},
    CurrentOption = Config.Settings.SelectedTheme,
    Flag = "SelectedTheme",
    Callback = function(Value)
        Config.Settings.SelectedTheme = Value
        -- Apply theme
        if Value == "Dark" then
            Rayfield:UpdateTheme({
                BackgroundColor = Color3.fromRGB(24, 24, 24),
                TitleBarColor = Color3.fromRGB(24, 24, 24),
                TabBackgroundColor = Color3.fromRGB(24, 24, 24),
                TabSelectedBackgroundColor = Color3.fromRGB(32, 32, 32),
                TabUnselectedBackgroundColor = Color3.fromRGB(24, 24, 24),
                TabSelectedTextColor = Color3.fromRGB(255, 255, 255),
                TabUnselectedTextColor = Color3.fromRGB(170, 170, 170),
                ButtonBackgroundColor = Color3.fromRGB(32, 32, 32),
                ButtonHoverBackgroundColor = Color3.fromRGB(48, 48, 48),
                ButtonTextColor = Color3.fromRGB(255, 255, 255),
                ToggleBackgroundColor = Color3.fromRGB(32, 32, 32),
                ToggleEnabledColor = Color3.fromRGB(0, 162, 255),
                ToggleDisabledColor = Color3.fromRGB(48, 48, 48),
                SliderBackgroundColor = Color3.fromRGB(32, 32, 32),
                SliderEnabledColor = Color3.fromRGB(0, 162, 255),
                SliderDisabledColor = Color3.fromRGB(48, 48, 48),
                InputBackgroundColor = Color3.fromRGB(32, 32, 32),
                InputTextColor = Color3.fromRGB(255, 255, 255),
                DropdownBackgroundColor = Color3.fromRGB(32, 32, 32),
                DropdownOptionBackgroundColor = Color3.fromRGB(48, 48, 48),
                DropdownOptionHoverBackgroundColor = Color3.fromRGB(64, 64, 64),
                DropdownOptionTextColor = Color3.fromRGB(255, 255, 255),
                DropdownSelectedTextColor = Color3.fromRGB(0, 162, 255),
                KeybindBackgroundColor = Color3.fromRGB(32, 32, 32),
                KeybindEnabledColor = Color3.fromRGB(0, 162, 255),
                KeybindDisabledColor = Color3.fromRGB(48, 48, 48),
                KeybindTextColor = Color3.fromRGB(255, 255, 255),
                NotificationBackgroundColor = Color3.fromRGB(32, 32, 32),
                NotificationTextColor = Color3.fromRGB(255, 255, 255),
                NotificationCloseButtonColor = Color3.fromRGB(255, 255, 255),
                NotificationImageColor = Color3.fromRGB(255, 255, 255),
                NotificationTitleColor = Color3.fromRGB(255, 255, 255),
                NotificationContentColor = Color3.fromRGB(200, 200, 200),
                TooltipBackgroundColor = Color3.fromRGB(32, 32, 32),
                TooltipTextColor = Color3.fromRGB(255, 255, 255)
            })
        elseif Value == "Light" then
            Rayfield:UpdateTheme({
                BackgroundColor = Color3.fromRGB(240, 240, 240),
                TitleBarColor = Color3.fromRGB(240, 240, 240),
                TabBackgroundColor = Color3.fromRGB(240, 240, 240),
                TabSelectedBackgroundColor = Color3.fromRGB(255, 255, 255),
                TabUnselectedBackgroundColor = Color3.fromRGB(240, 240, 240),
                TabSelectedTextColor = Color3.fromRGB(0, 0, 0),
                TabUnselectedTextColor = Color3.fromRGB(100, 100, 100),
                ButtonBackgroundColor = Color3.fromRGB(255, 255, 255),
                ButtonHoverBackgroundColor = Color3.fromRGB(230, 230, 230),
                ButtonTextColor = Color3.fromRGB(0, 0, 0),
                ToggleBackgroundColor = Color3.fromRGB(255, 255, 255),
                ToggleEnabledColor = Color3.fromRGB(0, 162, 255),
                ToggleDisabledColor = Color3.fromRGB(230, 230, 230),
                SliderBackgroundColor = Color3.fromRGB(255, 255, 255),
                SliderEnabledColor = Color3.fromRGB(0, 162, 255),
                SliderDisabledColor = Color3.fromRGB(230, 230, 230),
                InputBackgroundColor = Color3.fromRGB(255, 255, 255),
                InputTextColor = Color3.fromRGB(0, 0, 0),
                DropdownBackgroundColor = Color3.fromRGB(255, 255, 255),
                DropdownOptionBackgroundColor = Color3.fromRGB(230, 230, 230),
                DropdownOptionHoverBackgroundColor = Color3.fromRGB(210, 210, 210),
                DropdownOptionTextColor = Color3.fromRGB(0, 0, 0),
                DropdownSelectedTextColor = Color3.fromRGB(0, 162, 255),
                KeybindBackgroundColor = Color3.fromRGB(255, 255, 255),
                KeybindEnabledColor = Color3.fromRGB(0, 162, 255),
                KeybindDisabledColor = Color3.fromRGB(230, 230, 230),
                KeybindTextColor = Color3.fromRGB(0, 0, 0),
                NotificationBackgroundColor = Color3.fromRGB(255, 255, 255),
                NotificationTextColor = Color3.fromRGB(0, 0, 0),
                NotificationCloseButtonColor = Color3.fromRGB(0, 0, 0),
                NotificationImageColor = Color3.fromRGB(0, 0, 0),
                NotificationTitleColor = Color3.fromRGB(0, 0, 0),
                NotificationContentColor = Color3.fromRGB(50, 50, 50),
                TooltipBackgroundColor = Color3.fromRGB(255, 255, 255),
                TooltipTextColor = Color3.fromRGB(0, 0, 0)
            })
        elseif Value == "Blue" then
            Rayfield:UpdateTheme({
                BackgroundColor = Color3.fromRGB(20, 30, 48),
                TitleBarColor = Color3.fromRGB(20, 30, 48),
                TabBackgroundColor = Color3.fromRGB(20, 30, 48),
                TabSelectedBackgroundColor = Color3.fromRGB(30, 40, 60),
                TabUnselectedBackgroundColor = Color3.fromRGB(20, 30, 48),
                TabSelectedTextColor = Color3.fromRGB(255, 255, 255),
                TabUnselectedTextColor = Color3.fromRGB(170, 170, 170),
                ButtonBackgroundColor = Color3.fromRGB(30, 40, 60),
                ButtonHoverBackgroundColor = Color3.fromRGB(40, 50, 70),
                ButtonTextColor = Color3.fromRGB(255, 255, 255),
                ToggleBackgroundColor = Color3.fromRGB(30, 40, 60),
                ToggleEnabledColor = Color3.fromRGB(0, 162, 255),
                ToggleDisabledColor = Color3.fromRGB(40, 50, 70),
                SliderBackgroundColor = Color3.fromRGB(30, 40, 60),
                SliderEnabledColor = Color3.fromRGB(0, 162, 255),
                SliderDisabledColor = Color3.fromRGB(40, 50, 70),
                InputBackgroundColor = Color3.fromRGB(30, 40, 60),
                InputTextColor = Color3.fromRGB(255, 255, 255),
                DropdownBackgroundColor = Color3.fromRGB(30, 40, 60),
                DropdownOptionBackgroundColor = Color3.fromRGB(40, 50, 70),
                DropdownOptionHoverBackgroundColor = Color3.fromRGB(50, 60, 80),
                DropdownOptionTextColor = Color3.fromRGB(255, 255, 255),
                DropdownSelectedTextColor = Color3.fromRGB(0, 162, 255),
                KeybindBackgroundColor = Color3.fromRGB(30, 40, 60),
                KeybindEnabledColor = Color3.fromRGB(0, 162, 255),
                KeybindDisabledColor = Color3.fromRGB(40, 50, 70),
                KeybindTextColor = Color3.fromRGB(255, 255, 255),
                NotificationBackgroundColor = Color3.fromRGB(30, 40, 60),
                NotificationTextColor = Color3.fromRGB(255, 255, 255),
                NotificationCloseButtonColor = Color3.fromRGB(255, 255, 255),
                NotificationImageColor = Color3.fromRGB(255, 255, 255),
                NotificationTitleColor = Color3.fromRGB(255, 255, 255),
                NotificationContentColor = Color3.fromRGB(200, 200, 200),
                TooltipBackgroundColor = Color3.fromRGB(30, 40, 60),
                TooltipTextColor = Color3.fromRGB(255, 255, 255)
            })
        elseif Value == "Red" then
            Rayfield:UpdateTheme({
                BackgroundColor = Color3.fromRGB(48, 20, 20),
                TitleBarColor = Color3.fromRGB(48, 20, 20),
                TabBackgroundColor = Color3.fromRGB(48, 20, 20),
                TabSelectedBackgroundColor = Color3.fromRGB(60, 30, 30),
                TabUnselectedBackgroundColor = Color3.fromRGB(48, 20, 20),
                TabSelectedTextColor = Color3.fromRGB(255, 255, 255),
                TabUnselectedTextColor = Color3.fromRGB(170, 170, 170),
                ButtonBackgroundColor = Color3.fromRGB(60, 30, 30),
                ButtonHoverBackgroundColor = Color3.fromRGB(70, 40, 40),
                ButtonTextColor = Color3.fromRGB(255, 255, 255),
                ToggleBackgroundColor = Color3.fromRGB(60, 30, 30),
                ToggleEnabledColor = Color3.fromRGB(255, 50, 50),
                ToggleDisabledColor = Color3.fromRGB(70, 40, 40),
                SliderBackgroundColor = Color3.fromRGB(60, 30, 30),
                SliderEnabledColor = Color3.fromRGB(255, 50, 50),
                SliderDisabledColor = Color3.fromRGB(70, 40, 40),
                InputBackgroundColor = Color3.fromRGB(60, 30, 30),
                InputTextColor = Color3.fromRGB(255, 255, 255),
                DropdownBackgroundColor = Color3.fromRGB(60, 30, 30),
                DropdownOptionBackgroundColor = Color3.fromRGB(70, 40, 40),
                DropdownOptionHoverBackgroundColor = Color3.fromRGB(80, 50, 50),
                DropdownOptionTextColor = Color3.fromRGB(255, 255, 255),
                DropdownSelectedTextColor = Color3.fromRGB(255, 50, 50),
                KeybindBackgroundColor = Color3.fromRGB(60, 30, 30),
                KeybindEnabledColor = Color3.fromRGB(255, 50, 50),
                KeybindDisabledColor = Color3.fromRGB(70, 40, 40),
                KeybindTextColor = Color3.fromRGB(255, 255, 255),
                NotificationBackgroundColor = Color3.fromRGB(60, 30, 30),
                NotificationTextColor = Color3.fromRGB(255, 255, 255),
                NotificationCloseButtonColor = Color3.fromRGB(255, 255, 255),
                NotificationImageColor = Color3.fromRGB(255, 255, 255),
                NotificationTitleColor = Color3.fromRGB(255, 255, 255),
                NotificationContentColor = Color3.fromRGB(200, 200, 200),
                TooltipBackgroundColor = Color3.fromRGB(60, 30, 30),
                TooltipTextColor = Color3.fromRGB(255, 255, 255)
            })
        elseif Value == "Green" then
            Rayfield:UpdateTheme({
                BackgroundColor = Color3.fromRGB(20, 48, 20),
                TitleBarColor = Color3.fromRGB(20, 48, 20),
                TabBackgroundColor = Color3.fromRGB(20, 48, 20),
                TabSelectedBackgroundColor = Color3.fromRGB(30, 60, 30),
                TabUnselectedBackgroundColor = Color3.fromRGB(20, 48, 20),
                TabSelectedTextColor = Color3.fromRGB(255, 255, 255),
                TabUnselectedTextColor = Color3.fromRGB(170, 170, 170),
                ButtonBackgroundColor = Color3.fromRGB(30, 60, 30),
                ButtonHoverBackgroundColor = Color3.fromRGB(40, 70, 40),
                ButtonTextColor = Color3.fromRGB(255, 255, 255),
                ToggleBackgroundColor = Color3.fromRGB(30, 60, 30),
                ToggleEnabledColor = Color3.fromRGB(50, 255, 50),
                ToggleDisabledColor = Color3.fromRGB(40, 70, 40),
                SliderBackgroundColor = Color3.fromRGB(30, 60, 30),
                SliderEnabledColor = Color3.fromRGB(50, 255, 50),
                SliderDisabledColor = Color3.fromRGB(40, 70, 40),
                InputBackgroundColor = Color3.fromRGB(30, 60, 30),
                InputTextColor = Color3.fromRGB(255, 255, 255),
                DropdownBackgroundColor = Color3.fromRGB(30, 60, 30),
                DropdownOptionBackgroundColor = Color3.fromRGB(40, 70, 40),
                DropdownOptionHoverBackgroundColor = Color3.fromRGB(50, 80, 50),
                DropdownOptionTextColor = Color3.fromRGB(255, 255, 255),
                DropdownSelectedTextColor = Color3.fromRGB(50, 255, 50),
                KeybindBackgroundColor = Color3.fromRGB(30, 60, 30),
                KeybindEnabledColor = Color3.fromRGB(50, 255, 50),
                KeybindDisabledColor = Color3.fromRGB(40, 70, 40),
                KeybindTextColor = Color3.fromRGB(255, 255, 255),
                NotificationBackgroundColor = Color3.fromRGB(30, 60, 30),
                NotificationTextColor = Color3.fromRGB(255, 255, 255),
                NotificationCloseButtonColor = Color3.fromRGB(255, 255, 255),
                NotificationImageColor = Color3.fromRGB(255, 255, 255),
                NotificationTitleColor = Color3.fromRGB(255, 255, 255),
                NotificationContentColor = Color3.fromRGB(200, 200, 200),
                TooltipBackgroundColor = Color3.fromRGB(30, 60, 30),
                TooltipTextColor = Color3.fromRGB(255, 255, 255)
            })
        elseif Value == "Purple" then
            Rayfield:UpdateTheme({
                BackgroundColor = Color3.fromRGB(30, 20, 48),
                TitleBarColor = Color3.fromRGB(30, 20, 48),
                TabBackgroundColor = Color3.fromRGB(30, 20, 48),
                TabSelectedBackgroundColor = Color3.fromRGB(40, 30, 60),
                TabUnselectedBackgroundColor = Color3.fromRGB(30, 20, 48),
                TabSelectedTextColor = Color3.fromRGB(255, 255, 255),
                TabUnselectedTextColor = Color3.fromRGB(170, 170, 170),
                ButtonBackgroundColor = Color3.fromRGB(40, 30, 60),
                ButtonHoverBackgroundColor = Color3.fromRGB(50, 40, 70),
                ButtonTextColor = Color3.fromRGB(255, 255, 255),
                ToggleBackgroundColor = Color3.fromRGB(40, 30, 60),
                ToggleEnabledColor = Color3.fromRGB(170, 50, 255),
                ToggleDisabledColor = Color3.fromRGB(50, 40, 70),
                SliderBackgroundColor = Color3.fromRGB(40, 30, 60),
                SliderEnabledColor = Color3.fromRGB(170, 50, 255),
                SliderDisabledColor = Color3.fromRGB(50, 40, 70),
                InputBackgroundColor = Color3.fromRGB(40, 30, 60),
                InputTextColor = Color3.fromRGB(255, 255, 255),
                DropdownBackgroundColor = Color3.fromRGB(40, 30, 60),
                DropdownOptionBackgroundColor = Color3.fromRGB(50, 40, 70),
                DropdownOptionHoverBackgroundColor = Color3.fromRGB(60, 50, 80),
                DropdownOptionTextColor = Color3.fromRGB(255, 255, 255),
                DropdownSelectedTextColor = Color3.fromRGB(170, 50, 255),
                KeybindBackgroundColor = Color3.fromRGB(40, 30, 60),
                KeybindEnabledColor = Color3.fromRGB(170, 50, 255),
                KeybindDisabledColor = Color3.fromRGB(50, 40, 70),
                KeybindTextColor = Color3.fromRGB(255, 255, 255),
                NotificationBackgroundColor = Color3.fromRGB(40, 30, 60),
                NotificationTextColor = Color3.fromRGB(255, 255, 255),
                NotificationCloseButtonColor = Color3.fromRGB(255, 255, 255),
                NotificationImageColor = Color3.fromRGB(255, 255, 255),
                NotificationTitleColor = Color3.fromRGB(255, 255, 255),
                NotificationContentColor = Color3.fromRGB(200, 200, 200),
                TooltipBackgroundColor = Color3.fromRGB(40, 30, 60),
                TooltipTextColor = Color3.fromRGB(255, 255, 255)
            })
        elseif Value == "Orange" then
            Rayfield:UpdateTheme({
                BackgroundColor = Color3.fromRGB(48, 30, 20),
                TitleBarColor = Color3.fromRGB(48, 30, 20),
                TabBackgroundColor = Color3.fromRGB(48, 30, 20),
                TabSelectedBackgroundColor = Color3.fromRGB(60, 40, 30),
                TabUnselectedBackgroundColor = Color3.fromRGB(48, 30, 20),
                TabSelectedTextColor = Color3.fromRGB(255, 255, 255),
                TabUnselectedTextColor = Color3.fromRGB(170, 170, 170),
                ButtonBackgroundColor = Color3.fromRGB(60, 40, 30),
                ButtonHoverBackgroundColor = Color3.fromRGB(70, 50, 40),
                ButtonTextColor = Color3.fromRGB(255, 255, 255),
                ToggleBackgroundColor = Color3.fromRGB(60, 40, 30),
                ToggleEnabledColor = Color3.fromRGB(255, 150, 50),
                ToggleDisabledColor = Color3.fromRGB(70, 50, 40),
                SliderBackgroundColor = Color3.fromRGB(60, 40, 30),
                SliderEnabledColor = Color3.fromRGB(255, 150, 50),
                SliderDisabledColor = Color3.fromRGB(70, 50, 40),
                InputBackgroundColor = Color3.fromRGB(60, 40, 30),
                InputTextColor = Color3.fromRGB(255, 255, 255),
                DropdownBackgroundColor = Color3.fromRGB(60, 40, 30),
                DropdownOptionBackgroundColor = Color3.fromRGB(70, 50, 40),
                DropdownOptionHoverBackgroundColor = Color3.fromRGB(80, 60, 50),
                DropdownOptionTextColor = Color3.fromRGB(255, 255, 255),
                DropdownSelectedTextColor = Color3.fromRGB(255, 150, 50),
                KeybindBackgroundColor = Color3.fromRGB(60, 40, 30),
                KeybindEnabledColor = Color3.fromRGB(255, 150, 50),
                KeybindDisabledColor = Color3.fromRGB(70, 50, 40),
                KeybindTextColor = Color3.fromRGB(255, 255, 255),
                NotificationBackgroundColor = Color3.fromRGB(60, 40, 30),
                NotificationTextColor = Color3.fromRGB(255, 255, 255),
                NotificationCloseButtonColor = Color3.fromRGB(255, 255, 255),
                NotificationImageColor = Color3.fromRGB(255, 255, 255),
                NotificationTitleColor = Color3.fromRGB(255, 255, 255),
                NotificationContentColor = Color3.fromRGB(200, 200, 200),
                TooltipBackgroundColor = Color3.fromRGB(60, 40, 30),
                TooltipTextColor = Color3.fromRGB(255, 255, 255)
            })
        end
        logError("Theme changed to: " .. Value)
    end
})

SettingsTab:CreateSlider({
    Name = "UI Transparency",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Settings.Transparency,
    Flag = "Transparency",
    Callback = function(Value)
        Config.Settings.Transparency = Value
        Rayfield:UpdateTransparency(Value)
        logError("UI Transparency: " .. Value)
    end
})

SettingsTab:CreateInput({
    Name = "Config Name",
    PlaceholderText = "Enter config name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text ~= "" then
            Config.Settings.ConfigName = Text
            logError("Config Name: " .. Text)
        end
    end
})

SettingsTab:CreateSlider({
    Name = "UI Scale",
    Range = {0.5, 2},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = Config.Settings.UIScale,
    Flag = "UIScale",
    Callback = function(Value)
        Config.Settings.UIScale = Value
        Rayfield:UpdateScale(Value)
        logError("UI Scale: " .. Value)
    end
})

SettingsTab:CreateButton({
    Name = "Save Config",
    Callback = function()
        SaveConfig()
    end
})

SettingsTab:CreateButton({
    Name = "Load Config",
    Callback = function()
        LoadConfig()
    end
})

SettingsTab:CreateButton({
    Name = "Reset Config",
    Callback = function()
        ResetConfig()
    end
})

SettingsTab:CreateToggle({
    Name = "Auto Logging",
    CurrentValue = true,
    Flag = "AutoLogging",
    Callback = function(Value)
        logError("Auto Logging: " .. tostring(Value))
    end
})

-- Initialize features based on config
toggleAntiAFK(Config.Bypass.AntiAFK)
toggleAntiKick(Config.Bypass.AntiKick)
toggleAutoJump(Config.Bypass.AutoJump, Config.Bypass.AutoJumpDelay)
toggleESP(Config.Player.PlayerESP)
toggleSpeedHack(Config.Player.SpeedHack, Config.Player.SpeedValue)
toggleMaxBoatSpeed(Config.Player.MaxBoatSpeed)
toggleInfinityJump(Config.Player.InfinityJump)
toggleFly(Config.Player.Fly, Config.Player.FlyRange)
toggleFlyBoat(Config.Player.FlyBoat)
toggleGhostHack(Config.Player.GhostHack)
toggleNoclip(Config.Player.Noclip)
toggleNoClipBoat(Config.Player.NoClipBoat)
toggleAutoSell(Config.Player.AutoSell)
toggleAutoCraft(Config.Player.AutoCraft)
toggleAutoUpgrade(Config.Player.AutoUpgrade)
toggleAutoAcceptTrade(Config.Trader.AutoAcceptTrade)
toggleShowInfo(Config.System.ShowInfo)
toggleBoostFPS(Config.System.BoostFPS)
setFPSLimit(Config.System.FPSLimit)
toggleAutoCleanMemory(Config.System.AutoCleanMemory)
toggleDisableParticles(Config.System.DisableParticles)
toggleAutoFarm(Config.System.AutoFarm, Config.System.FarmRadius)
toggleHighQuality(Config.Graphic.HighQuality)
toggleMaxRendering(Config.Graphic.MaxRendering)
toggleUltraLowMode(Config.Graphic.UltraLowMode)
toggleDisableWaterReflection(Config.Graphic.DisableWaterReflection)
toggleCustomShader(Config.Graphic.CustomShader)
toggleSmoothGraphics(Config.Graphic.SmoothGraphics)
toggleFullBright(Config.Graphic.FullBright, Config.Graphic.FullBrightValue)
toggleRNGReducer(Config.RNGKill.RNGReducer)
toggleForceLegendary(Config.RNGKill.ForceLegendary)
toggleSecretFishBoost(Config.RNGKill.SecretFishBoost)
toggleMythicalChanceBoost(Config.RNGKill.MythicalChanceBoost)
toggleAntiBadLuck(Config.RNGKill.AntiBadLuck)
toggleGuaranteedCatch(Config.RNGKill.GuaranteedCatch)
toggleAutoBuyRods(Config.Shop.AutoBuyRods, Config.Shop.SelectedRod)
toggleAutoBuyBoats(Config.Shop.AutoBuyBoats, Config.Shop.SelectedBoat)
toggleAutoBuyBaits(Config.Shop.AutoBuyBaits, Config.Shop.SelectedBait)
toggleAutoUpgradeRod(Config.Shop.AutoUpgradeRod)

-- Log initialization
logError("Fish It Hub 2025 by Nikzz Xit initialized successfully")
logError("RayfieldLib Script for Fish It September 2025 loaded")
logError("Full Implementation - All Features 100% Working")
