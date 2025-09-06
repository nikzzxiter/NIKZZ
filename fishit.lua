-- Rayfield UI Library untuk Fish It
-- Versi September 2025
-- Dibuat untuk berbagai executor (Android & PC)

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Window utama
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
        Note = "No key system needed",
        FileName = "FishItKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"FishIt2025"}
    }
})

-- Variabel global
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Variabel untuk fitur
local autoFishEnabled = false
local waterFishEnabled = false
local bypassRadarEnabled = false
local bypassAirEnabled = false
local disableEffectFishing = false
local autoInstantFishing = false
local autoSellFishEnabled = false
local sellMythics = false
local sellSecrets = false
local delayFishSell = 1
local antiKickEnabled = false
local antiDetectEnabled = false
local antiAFKEnabled = false
local speedHackEnabled = false
local speedHackValue = 50
local maxBoatSpeedEnabled = false
local infinityJumpEnabled = false
local flyEnabled = false
local flySpeed = 50
local flyBoatEnabled = false
local ghostHackEnabled = false
local espLinesEnabled = false
local espBoxEnabled = false
local espRangeEnabled = false
local espLevelEnabled = false
local espHologramEnabled = false
local autoAcceptTrade = false
local selectedFishForTrade = {}
local selectedPlayerForTrade = nil
local tradeAllFish = false
local autoBuyWeather = false
local selectedWeather = "Sunny"
local boostFPSEnabled = false
local fpsValue = 60
local autoCleanMemory = false
local disableUselessParticles = false
local rngReducerEnabled = false
local forceLegendaryCatch = false
local secretFishBoost = false
local mythicalChance = false
local antiBadLuck = false

-- Fungsi untuk mendapatkan modul game
local function getGameModule(moduleName)
    local success, result = pcall(function()
        return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild(moduleName))
    end)
    if success then
        return result
    else
        warn("Failed to get module:", moduleName, "Error:", result)
        return nil
    end
end

-- Fungsi untuk mendapatkan remote event/function
local function getRemote(remoteName, isFunction)
    local success, result = pcall(function()
        if isFunction then
            return ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild(remoteName)
        else
            return ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild(remoteName)
        end
    end)
    if success then
        return result
    else
        warn("Failed to get remote:", remoteName, "Error:", result)
        return nil
    end
end

-- Fungsi untuk auto fish
local function autoFish()
    if not autoFishEnabled then return end
    
    local rod = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if not rod or not rod:FindFirstChild("Values") or not rod.Values:FindFirstChild("IsRod") then return end
    
    -- Cek apakah pemegang pancing
    if rod.Values.IsRod.Value == true then
        -- Lempar pancing
        local castLineRemote = getRemote("CastLine")
        if castLineRemote then
            castLineRemote:FireServer()
        end
        
        task.wait(1) -- Tunggu ikan menggigit
        
        -- Tarik pancing
        local reelInRemote = getRemote("ReelIn")
        if reelInRemote then
            reelInRemote:FireServer(true) -- true untuk perfect catch
        end
    end
    
    task.wait(0.5) -- Delay sebelum memancing lagi
end

-- Fungsi untuk water fish
local function waterFish()
    if not waterFishEnabled then return end
    
    -- Modifikasi posisi pancing untuk selalu di air
    local rod = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if rod and rod:FindFirstChild("Handle") then
        local handle = rod.Handle
        local originalCFrame = handle.CFrame
        
        -- Buat posisi handle selalu di atas air
        local waterLevel = Workspace:FindFirstChild("Water") and Workspace.Water.Position.Y or 0
        local newCFrame = CFrame.new(handle.Position.X, waterLevel + 2, handle.Position.Z)
        
        handle.CFrame = newCFrame
    end
end

-- Fungsi untuk bypass radar
local function bypassRadar()
    if not bypassRadarEnabled then return end
    
    -- Cek apakah pemain sudah memiliki radar
    local hasRadar = false
    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
        if item.Name:find("Radar") then
            hasRadar = true
            break
        end
    end
    
    -- Jika tidak memiliki radar, beli otomatis
    if not hasRadar then
        local buyItemRemote = getRemote("BuyItem")
        if buyItemRemote then
            buyItemRemote:FireServer("Fish Radar", 1)
        end
    end
    
    -- Aktifkan radar
    local activateRadarRemote = getRemote("ActivateRadar")
    if activateRadarRemote then
        activateRadarRemote:FireServer(true)
    end
end

-- Fungsi untuk bypass air
local function bypassAir()
    if not bypassAirEnabled then return end
    
    -- Cek apakah pemain sudah memiliki item berenang
    local hasSwimItem = false
    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
        if item.Name:find("Flippers") or item.Name:find("Scuba") then
            hasSwimItem = true
            break
        end
    end
    
    -- Jika tidak memiliki item berenang, beli otomatis
    if not hasSwimItem then
        local buyItemRemote = getRemote("BuyItem")
        if buyItemRemote then
            buyItemRemote:FireServer("Flippers", 1)
        end
    end
    
    -- Equip item berenang
    local swimItem = LocalPlayer.Backpack:FindFirstChild("Flippers") or LocalPlayer.Backpack:FindFirstChild("Scuba")
    if swimItem then
        LocalPlayer.Character.Humanoid:EquipTool(swimItem)
    end
end

-- Fungsi untuk disable effect fishing
local function disableFishingEffects()
    if not disableEffectFishing then return end
    
    -- Hapus efek visual dari ikan langka/mitos/rahasia
    for _, effect in pairs(Workspace:GetChildren()) do
        if effect.Name:find("Effect") and effect:IsA("ParticleEmitter") or effect:IsA("PointLight") then
            effect.Enabled = false
        end
    end
    
    -- H efek dari karakter pemain
    if LocalPlayer.Character then
        for _, effect in pairs(LocalPlayer.Character:GetChildren()) do
            if effect.Name:find("Effect") and effect:IsA("ParticleEmitter") or effect:IsA("PointLight") then
                effect.Enabled = false
            end
        end
    end
end

-- Fungsi untuk auto instant complicated fishing
local function autoInstantFishing()
    if not autoInstantFishing then return end
    
    -- Modifikasi nilai fishing untuk membuat ikan naik dengan cepat
    local rod = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if rod and rod:FindFirstChild("Values") and rod.Values:FindFirstChild("FishingValue") then
        rod.Values.FishingValue.Value = 100 -- Nilai maksimal untuk menangkap ikan dengan cepat
    end
end

-- Fungsi untuk auto sell fish
local function autoSellFish()
    if not autoSellFishEnabled then return end
    
    -- Dapatkan inventory ikan
    local inventoryRemote = getRemote("GetInventory")
    if inventoryRemote then
        inventoryRemote:InvokeServer(function(inventory)
            -- Filter ikan yang akan dijual
            local fishToSell = {}
            for fishName, fishData in pairs(inventory.Fish or {}) do
                -- Cek apakah ikan favorit
                local isFavorite = false
                for _, favFish in pairs(LocalPlayer.PlayerGui:WaitForChild("Inventory").FavoritedFish:GetChildren()) do
                    if favFish.Value == fishName then
                        isFavorite = true
                        break
                    end
                end
                
                -- Jika bukan favorit, tambahkan ke daftar jual
                if not isFavorite then
                    -- Cek apakah ikan mitos/rahasia dan apakah harus dijual
                    local isMythic = fishData.Rarity == "Mythic"
                    local isSecret = fishData.Rarity == "Secret"
                    
                    if (isMythic and sellMythics) or (isSecret and sellSecrets) or (not isMythic and not isSecret) then
                        table.insert(fishToSell, fishName)
                    end
                end
            end
            
            -- Jual ikan satu per satu dengan delay
            for _, fishName in pairs(fishToSell) do
                local sellFishRemote = getRemote("SellFish")
                if sellFishRemote then
                    sellFishRemote:FireServer(fishName, fishData.Amount)
                    task.wait(delayFishSell)
                end
            end
        end)
    end
end

-- Fungsi anti kick
local function antiKick()
    if not antiKickEnabled then return end
    
    -- Simpan posisi awal
    local originalPosition = LocalPlayer.Character.HumanoidRootPart.Position
    
    -- Set interval untuk menggerakkan karakter sedikit
    while antiKickEnabled do
        task.wait(300) -- 5 menit
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Gerakkan karakter sedikit
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0.1, 0)
            task.wait(0.1)
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -0.1, 0)
        end
    end
end

-- Fungsi anti detect
local function antiDetect()
    if not antiDetectEnabled then return end
    
    -- Sembunyikan aktivitas mencurigakan
    -- Ini adalah implementasi sederhana, dalam kenyataannya lebih kompleks
    while antiDetectEnabled do
        task.wait(5)
        
        -- Reset beberapa nilai untuk menghindari deteksi
        local stats = LocalPlayer:FindFirstChild("leaderstats")
        if stats then
            -- Simpan nilai asli
            local originalValues = {}
            for _, stat in pairs(stats:GetChildren()) do
                if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                    originalValues[stat.Name] = stat.Value
                end
            end
            
            -- Tunggu sebentar
            task.wait(0.1)
            
            -- Kembalikan nilai asli
            for statName, statValue in pairs(originalValues) do
                local stat = stats:FindFirstChild(statName)
                if stat then
                    stat.Value = statValue
                end
            end
        end
    end
end

-- Fungsi anti AFK
local function antiAFK()
    if not antiAFKEnabled then return end
    
    -- Gerakkan karakter atau tekan tombol secara berkala
    while antiAFKEnabled do
        task.wait(30) -- 30 detik
        
        -- Tekan tombol W sebentar
        VirtualInputManager:SendKeyEvent(true, "W", false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, "W", false, game)
        
        -- Loncatkan karakter
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Jump = true
        end
    end
end

-- Fungsi speed hack
local function speedHack()
    if not speedHackEnabled then return end
    
    -- Modifikasi kecepatan karakter
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speedHackValue
    end
end

-- Fungsi max boat speed
local function maxBoatSpeed()
    if not maxBoatSpeedEnabled then return end
    
    -- Cari boat yang dikendarai pemain
    for _, boat in pairs(Workspace.Boats:GetChildren()) do
        if boat:FindFirstChild("Owner") and boat.Owner.Value == LocalPlayer then
            -- Modifikasi kecepatan boat
            if boat:FindFirstChild("Values") and boat.Values:FindFirstChild("Speed") then
                boat.Values.Speed.Value = 1000 -- 1000% lebih cepat
            end
        end
    end
end

-- Fungsi spawn boat
local function spawnBoat()
    -- Dapatkan boat terbaru
    local getBoatsRemote = getRemote("GetBoats")
    if getBoatsRemote then
        getBoatsRemote:InvokeServer(function(boats)
            -- Cari boat terbaru
            local latestBoat = nil
            for _, boat in pairs(boats) do
                if not latestBoat or boat.ReleaseDate > latestBoat.ReleaseDate then
                    latestBoat = boat
                end
            end
            
            -- Spawn boat terbaru
            if latestBoat then
                local spawnBoatRemote = getRemote("SpawnBoat")
                if spawnBoatRemote then
                    spawnBoatRemote:FireServer(latestBoat.Name)
                end
            end
        end)
    end
end

-- Fungsi infinity jump
local function infinityJump()
    if not infinityJumpEnabled then return end
    
    -- Modifikasi state jump karakter
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end

-- Fungsi fly
local function fly()
    if not flyEnabled then return end
    
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Buat body velocity untuk terbang
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.P = 5000
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = rootPart
    
    -- Buat body gyro untuk kontrol arah
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 5000
    bg.Parent = rootPart
    
    -- Fungsi untuk mengontrol terbang
    local flyControl
    flyControl = RunService.Heartbeat:Connect(function()
        if not flyEnabled then
            bv:Destroy()
            bg:Destroy()
            flyControl:Disconnect()
            return
        end
        
        -- Dapatkan input dari keyboard
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + Vector3.new(0, 0, -1)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection + Vector3.new(0, 0, 1)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection + Vector3.new(-1, 0, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + Vector3.new(1, 0, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection + Vector3.new(0, -1, 0)
        end
        
        -- Normalisasi vektor dan terapkan kecepatan
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
            bv.Velocity = moveDirection * flySpeed
        else
            bv.Velocity = Vector3.new(0, 0, 0)
        end
        
        -- Perbarui gyro untuk menghadap ke arah kamera
        bg.CFrame = Workspace.CurrentCamera.CFrame
    end)
end

-- Fungsi fly boat
local function flyBoat()
    if not flyBoatEnabled then return end
    
    -- Cari boat yang dikendarai pemain
    for _, boat in pairs(Workspace.Boats:GetChildren()) do
        if boat:FindFirstChild("Owner") and boat.Owner.Value == LocalPlayer then
            -- Buat body velocity untuk terbang
            local boatPart = boat:FindFirstChild("PrimaryPart") or boat:FindFirstChild("Main")
            if boatPart then
                local bv = boatPart:FindFirstChild("FlyVelocity") or Instance.new("BodyVelocity")
                bv.Name = "FlyVelocity"
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.P = 5000
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.Parent = boatPart
                
                -- Fungsi untuk mengontrol terbang boat
                local flyBoatControl
                flyBoatControl = RunService.Heartbeat:Connect(function()
                    if not flyBoatEnabled then
                        bv:Destroy()
                        flyBoatControl:Disconnect()
                        return
                    end
                    
                    -- Dapatkan input dari keyboard
                    local moveDirection = Vector3.new(0, 0, 0)
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection = moveDirection + Vector3.new(0, 0, -1)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection = moveDirection + Vector3.new(0, 0, 1)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection = moveDirection + Vector3.new(-1, 0, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection = moveDirection + Vector3.new(1, 0, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection = moveDirection + Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                        moveDirection = moveDirection + Vector3.new(0, -1, 0)
                    end
                    
                    -- Normalisasi vektor dan terapkan kecepatan
                    if moveDirection.Magnitude > 0 then
                        moveDirection = moveDirection.Unit
                        bv.Velocity = moveDirection * flySpeed
                    else
                        bv.Velocity = Vector3.new(0, 0, 0)
                    end
                end)
            end
        end
    end
end

-- Fungsi ghost hack
local function ghostHack()
    if not ghostHackEnabled then return end
    
    -- Buat karakter transparan dan bisa menembus objek
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 0.5
                part.CanCollide = false
            end
        end
    end
end

-- Fungsi ESP
local function createESP(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = player.Character.HumanoidRootPart
    
    -- Buat billboard untuk ESP
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.Adornee = rootPart
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = Workspace.CurrentCamera
    
    -- Buat label untuk nama dan level
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.Parent = billboard
    
    -- Buat label untuk level
    local levelLabel = Instance.new("TextLabel")
    levelLabel.BackgroundTransparency = 1
    levelLabel.Text = "Level: " .. (player:FindFirstChild("Data") and player.Data:FindFirstChild("Level") and player.Data.Level.Value or "N/A")
    levelLabel.TextColor3 = Color3.new(1, 1, 1)
    levelLabel.TextScaled = true
    levelLabel.Size = UDim2.new(1, 0, 0.5, 0)
    levelLabel.Position = UDim2.new(0, 0, 0.5, 0)
    levelLabel.Parent = billboard
    
    -- Buat box ESP
    if espBoxEnabled then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESPBox_" .. player.Name
        box.Adornee = player.Character.HumanoidRootPart
        box.Size = player.Character.HumanoidRootPart.Size
        box.Color3 = Color3.new(1, 0, 0)
        box.Transparency = 0.7
        box.ZIndex = 10
        box.AlwaysOnTop = true
        box.Visible = true
        box.Parent = player.Character.HumanoidRootPart
    end
    
    -- Buat line ESP
    if espLinesEnabled then
        local line = Instance.new("Beam")
        line.Name = "ESPLine_" .. player.Name
        line.Attachment0 = Instance.new("Attachment", Workspace.CurrentCamera)
        line.Attachment1 = Instance.new("Attachment", rootPart)
        line.Color = ColorSequence.new(Color3.new(1, 0, 0))
        line.Width0 = 0.1
        line.Width1 = 0.1
        line.FaceCamera = true
        line.Parent = Workspace.CurrentCamera
    end
    
    -- Buat hologram ESP dengan efek rainbow
    if espHologramEnabled then
        local hologram = Instance.new("Highlight")
        hologram.Name = "ESPHologram_" .. player.Name
        hologram.Adornee = player.Character
        hologram.FillColor = Color3.new(1, 0, 0)
        hologram.OutlineColor = Color3.new(1, 1, 1)
        hologram.FillTransparency = 0.5
        hologram.OutlineTransparency = 0
        hologram.Parent = player.Character
        
        -- Efek rainbow
        local hue = 0
        local rainbowConnection
        rainbowConnection = RunService.Heartbeat:Connect(function(deltaTime)
            if not espHologramEnabled or not hologram or not hologram.Parent then
                if rainbowConnection then
                    rainbowConnection:Disconnect()
                end
                return
            end
            
            hue = (hue + deltaTime * 2) % 1
            local color = Color3.fromHSV(hue, 1, 1)
            hologram.FillColor = color
        end)
    end
end

-- Fungsi untuk menghapus ESP
local function removeESP(player)
    -- Hapus billboard
    local billboard = Workspace.CurrentCamera:FindFirstChild("ESP_" .. player.Name)
    if billboard then
        billboard:Destroy()
    end
    
    -- Hapus box
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local box = player.Character.HumanoidRootPart:FindFirstChild("ESPBox_" .. player.Name)
        if box then
            box:Destroy()
        end
    end
    
    -- Hapus line
    local line = Workspace.CurrentCamera:FindFirstChild("ESPLine_" .. player.Name)
    if line then
        line:Destroy()
    end
    
    -- Hapus hologram
    if player.Character then
        local hologram = player.Character:FindFirstChild("ESPHologram_" .. player.Name)
        if hologram then
            hologram:Destroy()
        end
    end
end

-- Fungsi auto accept trade
local function autoAcceptTrade()
    if not autoAcceptTrade then return end
    
    -- Cek apakah ada permintaan trade
    local tradeRequest = LocalPlayer.PlayerGui:FindFirstChild("TradeRequest")
    if tradeRequest and tradeRequest.Visible then
        -- Terima trade
        local acceptButton = tradeRequest:FindFirstChild("Accept")
        if acceptButton then
            -- Simulasi klik
            local fireEvent = acceptButton.MouseButton1Click
            if fireEvent then
                fireEvent:Fire()
            end
        end
    end
end

-- Fungsi untuk mendapatkan cuaca
local function getWeather()
    local getWeatherRemote = getRemote("GetWeather")
    if getWeatherRemote then
        getWeatherRemote:InvokeServer(function(weather)
            return weather
        end)
    end
    return nil
end

-- Fungsi untuk membeli cuaca
local function buyWeather(weatherType)
    local buyWeatherRemote = getRemote("BuyWeather")
    if buyWeatherRemote then
        buyWeatherRemote:FireServer(weatherType)
    end
end

-- Fungsi untuk mengubah cuaca
local function changeWeather(weatherType)
    local changeWeatherRemote = getRemote("ChangeWeather")
    if changeWeatherRemote then
        changeWeatherRemote:FireServer(weatherType)
    end
end

-- Fungsi untuk mendapatkan info server
local function getServerInfo()
    local serverInfoRemote = getRemote("GetServerInfo")
    if serverInfoRemote then
        serverInfoRemote:InvokeServer(function(info)
            return info
        end)
    end
    return nil
end

-- Fungsi untuk boost FPS
local function boostFPS()
    if not boostFPSEnabled then return end
    
    -- Set FPS cap
    local fpsCap = fpsValue or 60
    setfpscap(fpsCap)
    
    -- Nonaktifkan beberapa efek visual untuk meningkatkan performa
    if autoCleanMemory then
        -- Bersihkan memori
        collectgarbage("collect")
    end
    
    if disableUselessParticles then
        -- Nonaktifkan partikel yang tidak perlu
        for _, particle in pairs(Workspace:GetDescendants()) do
            if particle:IsA("ParticleEmitter") and particle.Name ~= "ImportantParticle" then
                particle.Enabled = false
            end
        end
    end
end

-- Fungsi untuk high quality
local function setHighQuality()
    -- Atur pengaturan grafis ke kualitas tinggi
    game:GetService("Lighting").GlobalShadows = true
    game:GetService("Lighting").EnvironmentDiffuseScale = 1
    game:GetService("Lighting").EnvironmentSpecularScale = 1
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
end

-- Fungsi untuk max rendering
local function setMaxRendering()
    -- Atur rendering ke maksimal
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
    game:GetService("Lighting").Brightness = 2
    game:GetService("Lighting").Contrast = 1
    game:GetService("Lighting").Saturation = 1
    game:GetService("Lighting").TintColor = Color3.new(1, 1, 1)
end

-- Fungsi untuk ultra low mode
local function setUltraLowMode()
    -- Atur pengaturan grafis ke minimum
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").EnvironmentDiffuseScale = 0
    game:GetService("Lighting").EnvironmentSpecularScale = 0
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    
    -- Nonaktifkan semua partikel
    for _, particle in pairs(Workspace:GetDescendants()) do
        if particle:IsA("ParticleEmitter") then
            particle.Enabled = false
        end
    end
end

-- Fungsi untuk disable water reflection
local function disableWaterReflection()
    -- Nonaktifkan refleksi air
    for _, water in pairs(Workspace:GetChildren()) do
        if water.Name:find("Water") and water:IsA("Part") or water:IsA("MeshPart") then
            water.Material = Enum.Material.Plastic
            water.Reflectance = 0
        end
    end
end

-- Fungsi untuk RNG reducer
local function rngReducer()
    if not rngReducerEnabled then return end
    
    -- Modifikasi RNG untuk meningkatkan peluang mendapatkan ikan langka
    local rngModule = getGameModule("RNG")
    if rngModule then
        -- Simpan fungsi asli
        local originalRandom = rngModule.Random
        
        -- Ganti dengan fungsi baru yang meningkatkan peluang
        rngModule.Random = function(min, max)
            -- Berikan peluang lebih tinggi untuk nilai tinggi
            local result = originalRandom(min, max)
            if result < (max - min) * 0.7 then
                result = originalRandom((max - min) * 0.7, max)
            end
            return result
        end
    end
end

-- Fungsi untuk force legendary catch
local function forceLegendaryCatch()
    if not forceLegendaryCatch then return end
    
    -- Modifikasi sistem penangkapan ikan untuk memaksa mendapatkan ikan legendary
    local fishingModule = getGameModule("Fishing")
    if fishingModule then
        -- Simpan fungsi asli
        local originalCalculateCatch = fishingModule.CalculateCatch
        
        -- Ganti dengan fungsi baru yang memaksa ikan legendary
        fishingModule.CalculateCatch = function(rod, bait, location)
            -- Selalu kembalikan ikan legendary
            return {
                Name = "Legendary Fish",
                Rarity = "Legendary",
                Value = 10000,
                XP = 1000
            }
        end
    end
end

-- Fungsi untuk secret fish boost
local function secretFishBoost()
    if not secretFishBoost then return end
    
    -- Modifikasi RNG untuk meningkatkan peluang mendapatkan ikan rahasia
    local fishingModule = getGameModule("Fishing")
    if fishingModule then
        -- Simpan fungsi asli
        local originalCalculateSecretChance = fishingModule.CalculateSecretChance
        
        -- Ganti dengan fungsi baru yang meningkatkan peluang
        fishingModule.CalculateSecretChance = function()
            return 0.5 -- 50% peluang mendapatkan ikan rahasia
        end
    end
end

-- Fungsi untuk mythical chance
local function mythicalChance()
    if not mythicalChance then return end
    
    -- Modifikasi RNG untuk meningkatkan peluang mendapatkan ikan mitos
    local fishingModule = getGameModule("Fishing")
    if fishingModule then
        -- Simpan fungsi asli
        local originalCalculateMythicalChance = fishingModule.CalculateMythicalChance
        
        -- Ganti dengan fungsi baru yang meningkatkan peluang
        fishingModule.CalculateMythicalChance = function()
            return 0.1 -- 10% peluang mendapatkan ikan mitos (10x lebih tinggi)
        end
    end
end

-- Fungsi untuk anti bad luck
local function antiBadLuck()
    if not antiBadLuck then return end
    
    -- Reset RNG seed
    local rngModule = getGameModule("RNG")
    if rngModule then
        rngModule:ResetSeed()
    end
end

-- Fungsi untuk membeli rod
local function buyRod(rodName)
    local buyItemRemote = getRemote("BuyItem")
    if buyItemRemote then
        buyItemRemote:FireServer(rodName, 1)
    end
end

-- Fungsi untuk membeli boat
local function buyBoat(boatName)
    local buyItemRemote = getRemote("BuyItem")
    if buyItemRemote then
        buyItemRemote:FireServer(boatName, 1)
    end
end

-- Fungsi untuk membeli bait
local function buyBait(baitName, amount)
    local buyItemRemote = getRemote("BuyItem")
    if buyItemRemote then
        buyItemRemote:FireServer(baitName, amount or 1)
    end
end

-- Fungsi untuk teleport ke map
local function teleportToMap(mapName)
    -- Cari lokasi map di workspace
    local mapLocation = nil
    for _, location in pairs(Workspace.MapLocations:GetChildren()) do
        if location.Name == mapName then
            mapLocation = location
            break
        end
    end
    
    if mapLocation and mapLocation:IsA("Model") and mapLocation.PrimaryPart then
        -- Teleport pemain ke lokasi map
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = mapLocation.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
        end
    end
end

-- Fungsi untuk teleport ke player
local function teleportToPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        end
    end
end

-- Fungsi untuk teleport ke event
local function teleportToEvent(eventName)
    -- Cari lokasi event di workspace
    local eventLocation = nil
    for _, location in pairs(Workspace.EventLocations:GetChildren()) do
        if location.Name == eventName then
            eventLocation = location
            break
        end
    end
    
    if eventLocation and eventLocation:IsA("Model") and eventLocation.PrimaryPart then
        -- Teleport pemain ke lokasi event
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = eventLocation.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
        end
    end
end

-- Fungsi untuk menyimpan posisi
local function savePosition(positionName)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local position = LocalPlayer.Character.HumanoidRootPart.CFrame
        
        -- Simpan posisi di dalam LocalPlayer
        local savedPositions = LocalPlayer:FindFirstChild("SavedPositions") or Instance.new("Folder")
        savedPositions.Name = "SavedPositions"
        savedPositions.Parent = LocalPlayer
        
        local positionValue = savedPositions:FindFirstChild(positionName) or Instance.new("CFrameValue")
        positionValue.Name = positionName
        positionValue.Value = position
        positionValue.Parent = savedPositions
        
        Rayfield:Notify({
            Title = "Position Saved",
            Content = "Position '" .. positionName .. "' has been saved!",
            Duration = 3,
            Image = 4483362458
        })
    end
end

-- Fungsi untuk memuat posisi
local function loadPosition(positionName)
    local savedPositions = LocalPlayer:FindFirstChild("SavedPositions")
    if savedPositions then
        local positionValue = savedPositions:FindFirstChild(positionName)
        if positionValue then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = positionValue.Value
                
                Rayfield:Notify({
                    Title = "Position Loaded",
                    Content = "Teleported to position '" .. positionName .. "'!",
                    Duration = 3,
                    Image = 4483362458
                })
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Position '" .. positionName .. "' not found!",
                Duration = 3,
                Image = 4483362458
            })
        end
    else
        Rayfield:Notify({
            Title = "Error",
            Content = "No saved positions found!",
            Duration = 3,
            Image = 4483362458
        })
    end
end

-- Fungsi untuk menghapus posisi
local function deletePosition(positionName)
    local savedPositions = LocalPlayer:FindFirstChild("SavedPositions")
    if savedPositions then
        local positionValue = savedPositions:FindFirstChild(positionName)
        if positionValue then
            positionValue:Destroy()
            
            Rayfield:Notify({
                Title = "Position Deleted",
                Content = "Position '" .. positionName .. "' has been deleted!",
                Duration = 3,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Position '" .. positionName .. "' not found!",
                Duration = 3,
                Image = 4483362458
            })
        end
    else
        Rayfield:Notify({
            Title = "Error",
            Content = "No saved positions found!",
            Duration = 3,
            Image = 4483362458
        })
    end
end

-- Fungsi untuk mendapatkan daftar event aktif
local function getActiveEvents()
    local events = {}
    
    -- Cek event di workspace
    for _, event in pairs(Workspace.Events:GetChildren()) do
        if event:IsA("Model") and event:FindFirstChild("IsActive") and event.IsActive.Value then
            table.insert(events, event.Name)
        end
    end
    
    return events
end

-- Fungsi untuk mendapatkan daftar player di server
local function getServerPlayers()
    local players = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    
    return players
end

-- Fungsi untuk mendapatkan daftar ikan di inventory
local function getInventoryFish()
    local fish = {}
    
    local inventoryRemote = getRemote("GetInventory")
    if inventoryRemote then
        inventoryRemote:InvokeServer(function(inventory)
            for fishName, fishData in pairs(inventory.Fish or {}) do
                table.insert(fish, fishName)
            end
        end)
    end
    
    return fish
end

-- Fungsi untuk mendapatkan daftar posisi yang tersimpan
local function getSavedPositions()
    local positions = {}
    
    local savedPositions = LocalPlayer:FindFirstChild("SavedPositions")
    if savedPositions then
        for _, position in pairs(savedPositions:GetChildren()) do
            if position:IsA("CFrameValue") then
                table.insert(positions, position.Name)
            end
        end
    end
    
    return positions
end

-- Fungsi untuk mendapatkan daftar map yang tersedia
local function getAvailableMaps()
    local maps = {}
    
    -- Daftar map berdasarkan informasi yang diberikan
    table.insert(maps, "Starter Island")
    table.insert(maps, "Pearl Island")
    table.insert(maps, "Volcano Bay")
    table.insert(maps, "Deep Sea Trench")
    table.insert(maps, "Sky Lagoon")
    table.insert(maps, "Coral Reef")
    table.insert(maps, "Ancient Temple")
    
    return maps
end

-- Fungsi untuk mendapatkan daftar rod yang tersedia
local function getAvailableRods()
    local rods = {}
    
    -- Daftar rod berdasarkan informasi yang diberikan
    table.insert(rods, "Starter Rod")
    table.insert(rods, "Carbon Rod")
    table.insert(rods, "Toy Rod")
    table.insert(rods, "Grass Rod")
    table.insert(rods, "Lava Rod")
    table.insert(rods, "Lucky Rod")
    table.insert(rods, "Midnight Rod")
    table.insert(rods, "Demascus Rod")
    table.insert(rods, "Ice Rod")
    table.insert(rods, "Steampunk Rod")
    table.insert(rods, "Chrome Rod")
    table.insert(rods, "Astral Rod")
    table.insert(rods, "Ares Rod")
    table.insert(rods, "Ghostfinn Rod")
    table.insert(rods, "Angler Rod")
    
    return rods
end

-- Fungsi untuk mendapatkan daftar boat yang tersedia
local function getAvailableBoats()
    local boats = {}
    
    -- Daftar boat berdasarkan informasi yang diberikan
    table.insert(boats, "Small Boat")
    table.insert(boats, "Speed Boat")
    table.insert(boats, "Viking Ship")
    table.insert(boats, "Mythical Ark")
    
    return boats
end

-- Fungsi untuk mendapatkan daftar bait yang tersedia
local function getAvailableBaits()
    local baits = {}
    
    -- Daftar bait berdasarkan informasi yang diberikan
    table.insert(baits, "Worm")
    table.insert(baits, "Shrimp")
    table.insert(baits, "Golden Bait")
    table.insert(baits, "Mythical Lure")
    table.insert(baits, "Dark Matter Bait")
    table.insert(baits, "Aether Bait")
    
    return baits
end

-- Fungsi untuk mendapatkan daftar cuaca yang tersedia
local function getAvailableWeathers()
    local weathers = {}
    
    -- Daftar cuaca berdasarkan informasi yang diberikan
    table.insert(weathers, "Sunny")
    table.insert(weathers, "Stormy")
    table.insert(weathers, "Fog")
    table.insert(weathers, "Night")
    table.insert(weathers, "Event Weather")
    
    return weathers
end

-- Tab Fish Farm
local FishFarmTab = Window:CreateTab("Fish Farm", 4483362458)

local AutoFishSection = FishFarmTab:CreateSection("Auto Fish")
AutoFishEnabledToggle = FishFarmTab:CreateToggle({
    Name = "Auto Fish",
    CurrentValue = false,
    Flag = "AutoFishEnabled",
    Callback = function(Value)
        autoFishEnabled = Value
        if Value then
            -- Mulai loop auto fish
            task.spawn(function()
                while autoFishEnabled do
                    autoFish()
                    task.wait(0.5)
                end
            end)
        end
    end,
})

WaterFishEnabledToggle = FishFarmTab:CreateToggle({
    Name = "Water Fish",
    CurrentValue = false,
    Flag = "WaterFishEnabled",
    Callback = function(Value)
        waterFishEnabled = Value
        if Value then
            -- Mulai loop water fish
            task.spawn(function()
                while waterFishEnabled do
                    waterFish()
                    task.wait(0.1)
                end
            end)
        end
    end,
})

BypassRadarEnabledToggle = FishFarmTab:CreateToggle({
    Name = "Bypass Radar",
    CurrentValue = false,
    Flag = "BypassRadarEnabled",
    Callback = function(Value)
        bypassRadarEnabled = Value
        if Value then
            bypassRadar()
        end
    end,
})

BypassAirEnabledToggle = FishFarmTab:CreateToggle({
    Name = "Bypass Air",
    CurrentValue = false,
    Flag = "BypassAirEnabled",
    Callback = function(Value)
        bypassAirEnabled = Value
        if Value then
            bypassAir()
        end
    end,
})

DisableEffectFishingToggle = FishFarmTab:CreateToggle({
    Name = "Disable Effect Fishing",
    CurrentValue = false,
    Flag = "DisableEffectFishing",
    Callback = function(Value)
        disableEffectFishing = Value
        if Value then
            -- Mulai loop disable effect fishing
            task.spawn(function()
                while disableEffectFishing do
                    disableFishingEffects()
                    task.wait(1)
                end
            end)
        end
    end,
})

AutoInstantFishingToggle = FishFarmTab:CreateToggle({
    Name = "Auto Instant Complicated Fishing",
    CurrentValue = false,
    Flag = "AutoInstantFishing",
    Callback = function(Value)
        autoInstantFishing = Value
        if Value then
            -- Mulai loop auto instant fishing
            task.spawn(function()
                while autoInstantFishing do
                    autoInstantFishing()
                    task.wait(0.1)
                end
            end)
        end
    end,
})

local AutoSellSection = FishFarmTab:CreateSection("Auto Sell Fish")

AutoSellFishEnabledToggle = FishFarmTab:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = false,
    Flag = "AutoSellFishEnabled",
    Callback = function(Value)
        autoSellFishEnabled = Value
        if Value then
            -- Mulai loop auto sell fish
            task.spawn(function()
                while autoSellFishEnabled do
                    autoSellFish()
                    task.wait(5) -- Cek setiap 5 detik
                end
            end)
        end
    end,
})

SellMythicsToggle = FishFarmTab:CreateToggle({
    Name = "Sell Mythics",
    CurrentValue = false,
    Flag = "SellMythics",
    Callback = function(Value)
        sellMythics = Value
    end,
})

SellSecretsToggle = FishFarmTab:CreateToggle({
    Name = "Sell Secrets",
    CurrentValue = false,
    Flag = "SellSecrets",
    Callback = function(Value)
        sellSecrets = Value
    end,
})

DelayFishSellSlider = FishFarmTab:CreateSlider({
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

local AntiSection = FishFarmTab:CreateSection("Anti")

AntiKickEnabledToggle = FishFarmTab:CreateToggle({
    Name = "Anti Kick Server",
    CurrentValue = false,
    Flag = "AntiKickEnabled",
    Callback = function(Value)
        antiKickEnabled = Value
        if Value then
            task.spawn(antiKick)
        end
    end,
})

AntiDetectEnabledToggle = FishFarmTab:CreateToggle({
    Name = "Anti Detect System",
    CurrentValue = false,
    Flag = "AntiDetectEnabled",
    Callback = function(Value)
        antiDetectEnabled = Value
        if Value then
            task.spawn(antiDetect)
        end
    end,
})

AntiAFKEnabledToggle = FishFarmTab:CreateToggle({
    Name = "Anti AFK & Auto Jump",
    CurrentValue = false,
    Flag = "AntiAFKEnabled",
    Callback = function(Value)
        antiAFKEnabled = Value
        if Value then
            task.spawn(antiAFK)
        end
    end,
})

-- Tab Teleport
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

local TeleportMapsSection = TeleportTab:CreateSection("Teleport Maps")

local maps = getAvailableMaps()
local selectedMap = maps[1] or "Starter Island"

MapDropdown = TeleportTab:CreateDropdown({
    Name = "Select Map",
    Options = maps,
    CurrentOption = selectedMap,
    Flag = "SelectedMap",
    Callback = function(Option)
        selectedMap = Option
    end,
})

TeleportMapButton = TeleportTab:CreateButton({
    Name = "Teleport to Map",
    Callback = function()
        teleportToMap(selectedMap)
    end,
})

local TeleportPlayerSection = TeleportTab:CreateSection("Teleport Player")

local players = getServerPlayers()
local selectedPlayer = players[1] or ""

PlayerDropdown = TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = players,
    CurrentOption = selectedPlayer,
    Flag = "SelectedPlayer",
    Callback = function(Option)
        selectedPlayer = Option
    end,
})

RefreshPlayerButton = TeleportTab:CreateButton({
    Name = "Refresh Player List",
    Callback = function()
        local newPlayers = getServerPlayers()
        PlayerDropdown:Refresh(newPlayers, true)
        if #newPlayers > 0 then
            selectedPlayer = newPlayers[1]
        end
    end,
})

TeleportPlayerButton = TeleportTab:CreateButton({
    Name = "Teleport to Player",
    Callback = function()
        teleportToPlayer(selectedPlayer)
    end,
})

local TeleportEventSection = TeleportTab:CreateSection("Teleport Event")

local events = getActiveEvents()
local selectedEvent = events[1] or ""

EventDropdown = TeleportTab:CreateDropdown({
    Name = "Select Event",
    Options = events,
    CurrentOption = selectedEvent,
    Flag = "SelectedEvent",
    Callback = function(Option)
        selectedEvent = Option
    end,
})

RefreshEventButton = TeleportTab:CreateButton({
    Name = "Refresh Event List",
    Callback = function()
        local newEvents = getActiveEvents()
        EventDropdown:Refresh(newEvents, true)
        if #newEvents > 0 then
            selectedEvent = newEvents[1]
        end
    end,
})

TeleportEventButton = TeleportTab:CreateButton({
    Name = "Teleport to Event",
    Callback = function()
        teleportToEvent(selectedEvent)
    end,
})

local PositionSection = TeleportTab:CreateSection("Position Management")

PositionNameInput = TeleportTab:CreateInput({
    Name = "Position Name",
    PlaceholderText = "Enter position name",
    RemoveTextAfterFocusLost = false,
    Flag = "PositionName",
    Callback = function(Text)
        -- Simpan nama posisi
    end,
})

SavePositionButton = TeleportTab:CreateButton({
    Name = "Save Position",
    Callback = function()
        local positionName = Rayfield.Flags["PositionName"].Value
        if positionName and positionName ~= "" then
            savePosition(positionName)
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Please enter a position name!",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

local savedPositions = getSavedPositions()
local selectedSavedPosition = savedPositions[1] or ""

SavedPositionDropdown = TeleportTab:CreateDropdown({
    Name = "Select Saved Position",
    Options = savedPositions,
    CurrentOption = selectedSavedPosition,
    Flag = "SelectedSavedPosition",
    Callback = function(Option)
        selectedSavedPosition = Option
    end,
})

RefreshSavedPositionButton = TeleportTab:CreateButton({
    Name = "Refresh Saved Positions",
    Callback = function()
        local newSavedPositions = getSavedPositions()
        SavedPositionDropdown:Refresh(newSavedPositions, true)
        if #newSavedPositions > 0 then
            selectedSavedPosition = newSavedPositions[1]
        end
    end,
})

LoadPositionButton = TeleportTab:CreateButton({
    Name = "Load Position",
    Callback = function()
        loadPosition(selectedSavedPosition)
    end,
})

DeletePositionButton = TeleportTab:CreateButton({
    Name = "Delete Position",
    Callback = function()
        deletePosition(selectedSavedPosition)
        -- Refresh daftar posisi
        local newSavedPositions = getSavedPositions()
        SavedPositionDropdown:Refresh(newSavedPositions, true)
        if #newSavedPositions > 0 then
            selectedSavedPosition = newSavedPositions[1]
        end
    end,
})

-- Tab Player
local PlayerTab = Window:CreateTab("Player", 4483362458)

local MovementSection = PlayerTab:CreateSection("Movement")

SpeedHackEnabledToggle = PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHackEnabled",
    Callback = function(Value)
        speedHackEnabled = Value
        if Value then
            -- Mulai loop speed hack
            task.spawn(function()
                while speedHackEnabled do
                    speedHack()
                    task.wait(0.1)
                end
            end)
            
            -- Kembalikan kecepatan normal jika dimatikan
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    end,
})

SpeedHackSlider = PlayerTab:CreateSlider({
    Name = "Speed Hack Setting",
    Range = {0, 500},
    Increment = 1,
    Suffix = "",
    CurrentValue = 50,
    Flag = "SpeedHackValue",
    Callback = function(Value)
        speedHackValue = Value
    end,
})

MaxBoatSpeedEnabledToggle = PlayerTab:CreateToggle({
    Name = "Max Boat Speed",
    CurrentValue = false,
    Flag = "MaxBoatSpeedEnabled",
    Callback = function(Value)
        maxBoatSpeedEnabled = Value
        if Value then
            -- Mulai loop max boat speed
            task.spawn(function()
                while maxBoatSpeedEnabled do
                    maxBoatSpeed()
                    task.wait(1)
                end
            end)
        end
    end,
})

SpawnBoatButton = PlayerTab:CreateButton({
    Name = "Spawn Boat",
    Callback = function()
        spawnBoat()
    end,
})

InfinityJumpEnabledToggle = PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Flag = "InfinityJumpEnabled",
    Callback = function(Value)
        infinityJumpEnabled = Value
        if Value then
            -- Mulai loop infinity jump
            LocalPlayer.Character.Humanoid.StateChanged:Connect(function(oldState, newState)
                if infinityJumpEnabled and newState == Enum.HumanoidStateType.Landed then
                    infinityJump()
                end
            end)
        end
    end,
})

local FlySection = PlayerTab:CreateSection("Fly")

FlyEnabledToggle = PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyEnabled",
    Callback = function(Value)
        flyEnabled = Value
        if Value then
            fly()
        end
    end,
})

FlySpeedSlider = PlayerTab:CreateSlider({
    Name = "Fly Settings",
    Range = {0, 200},
    Increment = 1,
    Suffix = "",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        flySpeed = Value
    end,
})

FlyBoatEnabledToggle = PlayerTab:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = false,
    Flag = "FlyBoatEnabled",
    Callback = function(Value)
        flyBoatEnabled = Value
        if Value then
            flyBoat()
        end
    end,
})

local GhostSection = PlayerTab:CreateSection("Ghost")

GhostHackEnabledToggle = PlayerTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = false,
    Flag = "GhostHackEnabled",
    Callback = function(Value)
        ghostHackEnabled = Value
        if Value then
            ghostHack()
        else
            -- Kembalikan karakter ke normal
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})

local ESPSection = PlayerTab:CreateSection("ESP")

ESPLinesEnabledToggle = PlayerTab:CreateToggle({
    Name = "ESP Lines",
    CurrentValue = false,
    Flag = "ESPLinesEnabled",
    Callback = function(Value)
        espLinesEnabled = Value
        if Value then
            -- Buat ESP untuk semua player
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createESP(player)
                end
            end
        else
            -- Hapus ESP untuk semua player
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    removeESP(player)
                end
            end
        end
    end,
})

ESPBoxEnabledToggle = PlayerTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = false,
    Flag = "ESPBoxEnabled",
    Callback = function(Value)
        espBoxEnabled = Value
        if Value then
            -- Buat ESP untuk semua player
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createESP(player)
                end
            end
        else
            -- Hapus ESP untuk semua player
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    removeESP(player)
                end
            end
        end
    end,
})

ESPRangeEnabledToggle = PlayerTab:CreateToggle({
    Name = "ESP Range",
    CurrentValue = false,
    Flag = "ESPRangeEnabled",
    Callback = function(Value)
        espRangeEnabled = Value
        if Value then
            -- Buat ESP untuk semua player
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createESP(player)
                end
            end
        else
            -- Hapus ESP untuk semua player
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    removeESP(player)
                end
            end
        end
    end,
})

ESPLevelEnabledToggle = PlayerTab:CreateToggle({
    Name = "ESP Level",
    CurrentValue = false,
    Flag = "ESPLevelEnabled",
    Callback = function(Value)
        espLevelEnabled = Value
        if Value then
            -- Buat ESP untuk semua player
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createESP(player)
                end
            end
        else
            -- Hapus ESP untuk semua player
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    removeESP(player)
                end
            end
        end
    end,
})

ESPHologramEnabledToggle = PlayerTab:CreateToggle({
    Name = "ESP Hologram (Rainbow)",
    CurrentValue = false,
    Flag = "ESPHologramEnabled",
    Callback = function(Value)
        espHologramEnabled = Value
        if Value then
            -- Buat ESP untuk semua player
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createESP(player)
                end
            end
        else
            -- Hapus ESP untuk semua player
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    removeESP(player)
                end
            end
        end
    end,
})

-- Event untuk player baru
Players.PlayerAdded:Connect(function(player)
    if espLinesEnabled or espBoxEnabled or espRangeEnabled or espLevelEnabled or espHologramEnabled then
        createESP(player)
    end
end)

-- Event untuk player yang pergi
Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- Tab Trader
local TraderTab = Window:CreateTab("Trader", 4483362458)

local AutoTradeSection = TraderTab:CreateSection("Auto Trade")

AutoAcceptTradeToggle = TraderTab:CreateToggle({
    Name = "Auto Accept Trade",
    CurrentValue = false,
    Flag = "AutoAcceptTrade",
    Callback = function(Value)
        autoAcceptTrade = Value
        if Value then
            -- Mulai loop auto accept trade
            task.spawn(function()
                while autoAcceptTrade do
                    autoAcceptTrade()
                    task.wait(1)
                end
            end)
        end
    end,
})

local SelectFishSection = TraderTab:CreateSection("Select Fish")

local fish = getInventoryFish()
local selectedFish = fish[1] or ""

FishDropdown = TraderTab:CreateDropdown({
    Name = "Select Fish",
    Options = fish,
    CurrentOption = selectedFish,
    Flag = "SelectedFish",
    Callback = function(Option)
        selectedFish = Option
    end,
})

RefreshFishButton = TraderTab:CreateButton({
    Name = "Refresh Fish List",
    Callback = function()
        local newFish = getInventoryFish()
        FishDropdown:Refresh(newFish, true)
        if #newFish > 0 then
            selectedFish = newFish[1]
        end
    end,
})

AddFishButton = TraderTab:CreateButton({
    Name = "Add Fish to Trade",
    Callback = function()
        if selectedFish and selectedFish ~= "" then
            table.insert(selectedFishForTrade, selectedFish)
            Rayfield:Notify({
                Title = "Fish Added",
                Content = selectedFish .. " added to trade list!",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

ClearFishButton = TraderTab:CreateButton({
    Name = "Clear Fish List",
    Callback = function()
        selectedFishForTrade = {}
        Rayfield:Notify({
            Title = "Fish List Cleared",
            Content = "All fish removed from trade list!",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

local SelectPlayerSection = TraderTab:CreateSection("Select Player")

PlayerTradeDropdown = TraderTab:CreateDropdown({
    Name = "Select Player",
    Options = getServerPlayers(),
    CurrentOption = "",
    Flag = "SelectedPlayerForTrade",
    Callback = function(Option)
        selectedPlayerForTrade = Option
    end,
})

RefreshPlayerTradeButton = TraderTab:CreateButton({
    Name = "Refresh Player List",
    Callback = function()
        local newPlayers = getServerPlayers()
        PlayerTradeDropdown:Refresh(newPlayers, true)
    end,
})

local TradeSection = TraderTab:CreateSection("Trade")

TradeAllFishToggle = TraderTab:CreateToggle({
    Name = "Trade All Fish",
    CurrentValue = false,
    Flag = "TradeAllFish",
    Callback = function(Value)
        tradeAllFish = Value
    end,
})

SendTradeButton = TraderTab:CreateButton({
    Name = "Send Trade Request",
    Callback = function()
        if selectedPlayerForTrade and selectedPlayerForTrade ~= "" then
            local tradeRemote = getRemote("SendTradeRequest")
            if tradeRemote then
                if tradeAllFish then
                    -- Trade semua ikan
                    local inventoryRemote = getRemote("GetInventory")
                    if inventoryRemote then
                        inventoryRemote:InvokeServer(function(inventory)
                            local allFish = {}
                            for fishName, fishData in pairs(inventory.Fish or {}) do
                                table.insert(allFish, {Name = fishName, Amount = fishData.Amount})
                            end
                            
                            tradeRemote:FireServer(selectedPlayerForTrade, allFish)
                        end)
                    end
                else
                    -- Trade hanya ikan yang dipilih
                    if #selectedFishForTrade > 0 then
                        local fishToTrade = {}
                        for _, fishName in pairs(selectedFishForTrade) do
                            table.insert(fishToTrade, {Name = fishName, Amount = 1})
                        end
                        
                        tradeRemote:FireServer(selectedPlayerForTrade, fishToTrade)
                    else
                        Rayfield:Notify({
                            Title = "Error",
                            Content = "No fish selected for trade!",
                            Duration = 3,
                            Image = 4483362458
                        })
                    end
                end
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "No player selected for trade!",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

-- Tab Server
local ServerTab = Window:CreateTab("Server", 4483362458)

local WeatherSection = ServerTab:CreateSection("Weather")

local weathers = getAvailableWeathers()
local selectedWeather = weathers[1] or "Sunny"

WeatherDropdown = ServerTab:CreateDropdown({
    Name = "Select Weather",
    Options = weathers,
    CurrentOption = selectedWeather,
    Flag = "SelectedWeather",
    Callback = function(Option)
        selectedWeather = Option
    end,
})

BuyWeatherButton = ServerTab:CreateButton({
    Name = "Buy Weather",
    Callback = function()
        buyWeather(selectedWeather)
    end,
})

ChangeWeatherButton = ServerTab:CreateButton({
    Name = "Change Weather",
    Callback = function()
        changeWeather(selectedWeather)
    end,
})

AutoBuyWeatherToggle = ServerTab:CreateToggle({
    Name = "Auto Buy Weather",
    CurrentValue = false,
    Flag = "AutoBuyWeather",
    Callback = function(Value)
        autoBuyWeather = Value
        if Value then
            -- Mulai loop auto buy weather
            task.spawn(function()
                while autoBuyWeather do
                    buyWeather(selectedWeather)
                    task.wait(60) -- Cek setiap menit
                end
            end)
        end
    end,
})

local ServerInfoSection = ServerTab:CreateSection("Server Info")

PlayerInfoLabel = ServerTab:CreateLabel("Players Online: " .. #Players:GetPlayers())

ServerInfoLabel = ServerTab:CreateLabel("Server Info: Loading...")

RefreshServerInfoButton = ServerTab:CreateButton({
    Name = "Refresh Server Info",
    Callback = function()
        PlayerInfoLabel:Set("Players Online: " .. #Players:GetPlayers())
        
        local serverInfo = getServerInfo()
        if serverInfo then
            local infoText = "Server Luck: " .. (serverInfo.Luck or "N/A") .. "%\n"
            infoText = infoText .. "Server Seed: " .. (serverInfo.Seed or "N/A")
            ServerInfoLabel:Set(infoText)
        else
            ServerInfoLabel:Set("Server Info: Failed to load")
        end
    end,
})

-- Tab System
local SystemTab = Window:CreateTab("System", 4483362458)

local InfoSection = SystemTab:CreateSection("System Information")

FPSLabel = SystemTab:CreateLabel("FPS: 0")
BatteryLabel = SystemTab:CreateLabel("Battery: N/A")
PingLabel = SystemTab:CreateLabel("Ping: 0ms")
TimeLabel = SystemTab:CreateLabel("Time: 00:00:00")

-- Update info sistem
task.spawn(function()
    while true do
        -- Update FPS
        local fps = 1 / RunService.Heartbeat:Wait()
        FPSLabel:Set("FPS: " .. math.floor(fps))
        
        -- Update Battery (hanya untuk mobile)
        if game:GetService("GuiService"):IsTenFootInterface() then
            local battery = game:GetService("UserInputService"):GetBatteryLevel()
            if battery then
                BatteryLabel:Set("Battery: " .. math.floor(battery * 100) .. "%")
            end
        end
        
        -- Update Ping
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        PingLabel:Set("Ping: " .. ping .. "ms")
        
        -- Update Time
        local currentTime = os.date("%H:%M:%S")
        TimeLabel:Set("Time: " .. currentTime)
        
        task.wait(1)
    end
end)

local PerformanceSection = SystemTab:CreateSection("Performance")

BoostFPSEnabledToggle = SystemTab:CreateToggle({
    Name = "Boost FPS",
    CurrentValue = false,
    Flag = "BoostFPSEnabled",
    Callback = function(Value)
        boostFPSEnabled = Value
        if Value then
            -- Mulai loop boost FPS
            task.spawn(function()
                while boostFPSEnabled do
                    boostFPS()
                    task.wait(5)
                end
            end)
        end
    end,
})

FPSSlider = SystemTab:CreateSlider({
    Name = "Settings FPS",
    Range = {0, 360},
    Increment = 1,
    Suffix = " FPS",
    CurrentValue = 60,
    Flag = "FPSValue",
    Callback = function(Value)
        fpsValue = Value
        if boostFPSEnabled then
            setfpscap(fpsValue)
        end
    end,
})

AutoCleanMemoryToggle = SystemTab:CreateToggle({
    Name = "Auto Clean Memory",
    CurrentValue = false,
    Flag = "AutoCleanMemory",
    Callback = function(Value)
        autoCleanMemory = Value
    end,
})

DisableUselessParticlesToggle = SystemTab:CreateToggle({
    Name = "Disable Useless Particles",
    CurrentValue = false,
    Flag = "DisableUselessParticles",
    Callback = function(Value)
        disableUselessParticles = Value
        if Value then
            -- Nonaktifkan partikel yang tidak perlu
            for _, particle in pairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") and particle.Name ~= "ImportantParticle" then
                    particle.Enabled = false
                end
            end
        end
    end,
})

RejoinServerButton = SystemTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end,
})

-- Tab Graphic
local GraphicTab = Window:CreateTab("Graphic", 4483362458)

local QualitySection = GraphicTab:CreateSection("Quality Settings")

HighQualityButton = GraphicTab:CreateButton({
    Name = "High Quality",
    Callback = function()
        setHighQuality()
    end,
})

MaxRenderingButton = GraphicTab:CreateButton({
    Name = "Max Rendering",
    Callback = function()
        setMaxRendering()
    end,
})

UltraLowModeButton = GraphicTab:CreateButton({
    Name = "Ultra Low Mode",
    Callback = function()
        setUltraLowMode()
    end,
})

local WaterSection = GraphicTab:CreateSection("Water Settings")

DisableWaterReflectionButton = GraphicTab:CreateButton({
    Name = "Disable Water Reflection",
    Callback = function()
        disableWaterReflection()
    end,
})

local ShaderSection = GraphicTab:CreateSection("Shader Settings")

CustomShaderToggle = GraphicTab:CreateToggle({
    Name = "Custom Shader Toggle",
    CurrentValue = false,
    Flag = "CustomShaderToggle",
    Callback = function(Value)
        -- Implementasi custom shader
        -- Ini adalah contoh sederhana, implementasi sebenarnya lebih kompleks
        if Value then
            -- Terapkan custom shader
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
        else
            -- Kembalikan ke default
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
        end
    end,
})

-- Tab RNG Kill
local RNGKillTab = Window:CreateTab("RNG Kill", 4483362458)

local RNGSection = RNGKillTab:CreateSection("RNG Manipulation")

RNGReducerToggle = RNGKillTab:CreateToggle({
    Name = "RNG Reducer",
    CurrentValue = false,
    Flag = "RNGReducerEnabled",
    Callback = function(Value)
        rngReducerEnabled = Value
        if Value then
            rngReducer()
        end
    end,
})

ForceLegendaryCatchToggle = RNGKillTab:CreateToggle({
    Name = "Force Legendary Catch",
    CurrentValue = false,
    Flag = "ForceLegendaryCatch",
    Callback = function(Value)
        forceLegendaryCatch = Value
        if Value then
            forceLegendaryCatch()
        end
    end,
})

SecretFishBoostToggle = RNGKillTab:CreateToggle({
    Name = "Secret Fish Boost",
    CurrentValue = false,
    Flag = "SecretFishBoost",
    Callback = function(Value)
        secretFishBoost = Value
        if Value then
            secretFishBoost()
        end
    end,
})

MythicalChanceToggle = RNGKillTab:CreateToggle({
    Name = "Mythical Chance ×10",
    CurrentValue = false,
    Flag = "MythicalChance",
    Callback = function(Value)
        mythicalChance = Value
        if Value then
            mythicalChance()
        end
    end,
})

AntiBadLuckToggle = RNGKillTab:CreateToggle({
    Name = "Anti-Bad Luck",
    CurrentValue = false,
    Flag = "AntiBadLuck",
    Callback = function(Value)
        antiBadLuck = Value
        if Value then
            antiBadLuck()
        end
    end,
})

-- Tab Shop
local ShopTab = Window:CreateTab("Shop", 4483362458)

local RodSection = ShopTab:CreateSection("Buy Rod")

local rods = getAvailableRods()
local selectedRod = rods[1] or "Starter Rod"

RodDropdown = ShopTab:CreateDropdown({
    Name = "Select Rod",
    Options = rods,
    CurrentOption = selectedRod,
    Flag = "SelectedRod",
    Callback = function(Option)
        selectedRod = Option
    end,
})

BuyRodButton = ShopTab:CreateButton({
    Name = "Buy Rod",
    Callback = function()
        buyRod(selectedRod)
    end,
})

local BoatSection = ShopTab:CreateSection("Buy Boat")

local boats = getAvailableBoats()
local selectedBoat = boats[1] or "Small Boat"

BoatDropdown = ShopTab:CreateDropdown({
    Name = "Select Boat",
    Options = boats,
    CurrentOption = selectedBoat,
    Flag = "SelectedBoat",
    Callback = function(Option)
        selectedBoat = Option
    end,
})

BuyBoatButton = ShopTab:CreateButton({
    Name = "Buy Boat",
    Callback = function()
        buyBoat(selectedBoat)
    end,
})

local BaitSection = ShopTab:CreateSection("Buy Bait")

local baits = getAvailableBaits()
local selectedBait = baits[1] or "Worm"

BaitDropdown = ShopTab:CreateDropdown({
    Name = "Select Bait",
    Options = baits,
    CurrentOption = selectedBait,
    Flag = "SelectedBait",
    Callback = function(Option)
        selectedBait = Option
    end,
})

BaitAmountSlider = ShopTab:CreateSlider({
    Name = "Bait Amount",
    Range = {1, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = 1,
    Flag = "BaitAmount",
    Callback = function(Value)
        -- Simpan jumlah bait
    end,
})

BuyBaitButton = ShopTab:CreateButton({
    Name = "Buy Bait",
    Callback = function()
        local baitAmount = Rayfield.Flags["BaitAmount"].Value
        buyBait(selectedBait, baitAmount)
    end,
})

-- Tab Settings
local SettingsTab = Window:CreateTab("Settings", 4483362458)

local ConfigSection = SettingsTab:CreateSection("Configuration")

SaveConfigButton = SettingsTab:CreateButton({
    Name = "Save Config",
    Callback = function()
        Rayfield:SaveConfiguration()
        Rayfield:Notify({
            Title = "Config Saved",
            Content = "Configuration has been saved!",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

LoadConfigButton = SettingsTab:CreateButton({
    Name = "Load Config",
    Callback = function()
        Rayfield:LoadConfiguration()
        Rayfield:Notify({
            Title = "Config Loaded",
            Content = "Configuration has been loaded!",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

ResetConfigButton = SettingsTab:CreateButton({
    Name = "Reset Config",
    Callback = function()
        Rayfield:ResetConfiguration()
        Rayfield:Notify({
            Title = "Config Reset",
            Content = "Configuration has been reset!",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

ExportConfigButton = SettingsTab:CreateButton({
    Name = "Export Config",
    Callback = function()
        Rayfield:ExportConfiguration()
        Rayfield:Notify({
            Title = "Config Exported",
            Content = "Configuration has been exported to clipboard!",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

ImportConfigButton = SettingsTab:CreateButton({
    Name = "Import Config",
    Callback = function()
        Rayfield:ImportConfiguration()
        Rayfield:Notify({
            Title = "Config Imported",
            Content = "Configuration has been imported!",
            Duration = 3,
            Image = 4483362458
        })
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
