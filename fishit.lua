-- 🎣 FISH IT EXECUTOR v2.0 (SEPTEMBER 2025) — UI AKAN MUNCUL MESKIPUN GAME BELUM SIAP
-- ✅ DIPERBAIKI: UI TIDAK MUNCUL — SEKARANG SELALU MUNCUL PERTAMA KALI

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- 🚨 SAFE LOAD RAYFIELD — JIKA GAGAL, GUNAKAN UI ALTERNATIF
local Rayfield, Window
local function LoadRayfieldSafe()
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
    end)
    if success and result then
        Rayfield = result
        return true
    else
        warn("Rayfield gagal load, menggunakan UI alternatif")
        return false
    end
end

-- 🖥️ UI ALTERNATIF JIKA RAYFIELD GAGAL
local function CreateAlternativeUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FishItExecutorUI"
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.Text = "Fish It Executor (Alternative UI)"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = MainFrame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
    ToggleButton.Position = UDim2.new(0.1, 0, 0.9, -50)
    ToggleButton.Text = "Toggle Auto Fish"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Parent = MainFrame

    ToggleButton.MouseButton1Click:Connect(function()
        local success, err = pcall(function()
            local CastLine = ReplicatedStorage.Remotes:FindFirstChild("CastLine")
            local ReelIn = ReplicatedStorage.Remotes:FindFirstChild("ReelIn")
            if CastLine and ReelIn then
                spawn(function()
                    while wait(3) do
                        CastLine:InvokeServer()
                        wait(2)
                        ReelIn:InvokeServer()
                    end
                end)
            end
        end)
        if not success then
            warn("Fitur tidak tersedia: Remote tidak ditemukan")
        end
    end)

    return ScreenGui
end

-- 🎯 LOAD UI — UTAMAKAN RAYFIELD, JIKA GAGAL PAKAI ALTERNATIF
if LoadRayfieldSafe() then
    Rayfield:Notify({
        Title = "Fish It Executor",
        Content = "Loading UI...",
        Duration = 3,
        Image = 4483362458
    })

    Window = Rayfield:CreateWindow({
        Name = "Fish It Executor | September 2025",
        LoadingTitle = "Fish It",
        LoadingSubtitle = "by Rayfield",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "FishItExecutor",
            FileName = "Settings"
        },
        KeySystem = false
    })
else
    CreateAlternativeUI()
    -- Jika pakai UI alternatif, berhenti di sini
    return
end

-- ⏳ TUNDA INISIALISASI REMOTE — BIAR UI MUNCUL DULU
spawn(function()
    task.wait(1) -- biarkan UI muncul dulu

    -- 🎣 REMOTE & MODULE — AMAN DENGAN PCALL
    local CastLineRemote, ReelInRemote, SellFishEvent, BuyItemRemote
    local ItemHandler, FishData, PlayerStats

    -- Tunggu sampai remotes ada (max 10 detik)
    for i = 1, 10 do
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            CastLineRemote = remotes:FindFirstChild("CastLine")
            ReelInRemote = remotes:FindFirstChild("ReelIn")
            BuyItemRemote = remotes:FindFirstChild("BuyItem")
            break
        end
        task.wait(1)
    end

    local events = ReplicatedStorage:FindFirstChild("Events")
    if events then
        SellFishEvent = events:FindFirstChild("SellFish")
    end

    -- Tunggu module scripts
    for i = 1, 5 do
        local modules = ReplicatedStorage:FindFirstChild("ModuleScripts")
        if modules then
            local itemHandler = modules:FindFirstChild("ItemHandler")
            local fishData = modules:FindFirstChild("FishData")
            local playerStats = modules:FindFirstChild("PlayerStats")
            if itemHandler and fishData and playerStats then
                local success1, result1 = pcall(function() return require(itemHandler) end)
                local success2, result2 = pcall(function() return require(fishData) end)
                local success3, result3 = pcall(function() return require(playerStats) end)
                if success1 and success2 and success3 then
                    ItemHandler = result1
                    FishData = result2
                    PlayerStats = result3
                end
            end
        end
        task.wait(1)
    end

    -- ✅ UI TABS — SEMUA FITUR AMAN DENGAN PCALL
    local Tab1 = Window:CreateTab("FISH FARM", 4483362458)

    local AutoFishToggle = Tab1:CreateToggle({
        Name = "Auto Fish",
        CurrentValue = false,
        Flag = "AutoFish",
        Callback = function(Value)
            if Value then
                spawn(function()
                    while task.wait(3) and AutoFishToggle:GetValue() do
                        if CastLineRemote and ReelInRemote then
                            pcall(function()
                                CastLineRemote:InvokeServer()
                                task.wait(2)
                                ReelInRemote:InvokeServer()
                            end)
                        end
                    end
                end)
            end
        end
    })

    local AutoSellToggle = Tab1:CreateToggle({
        Name = "Auto Sell Fish",
        CurrentValue = false,
        Flag = "AutoSell",
        Callback = function(Value)
            if Value then
                spawn(function()
                    while task.wait(5) and AutoSellToggle:GetValue() do
                        if SellFishEvent then
                            pcall(function()
                                SellFishEvent:FireServer()
                            end)
                        end
                    end
                end)
            end
        end
    })

    -- Tab 2: TELEPORT
    local Tab2 = Window:CreateTab("TELEPORT", 4483362458)

    local Maps = {
        "Fisherman Island", "Ocean", "Kohana Island", "Coral Reefs", "Lost Isle"
    }

    for _, mapName in ipairs(Maps) do
        Tab2:CreateButton({
            Name = "Teleport to " .. mapName,
            Callback = function()
                spawn(function()
                    local map = Workspace.Map:FindFirstChild(mapName) or Workspace:FindFirstChild(mapName)
                    if map and map.PrimaryPart then
                        HumanoidRootPart.CFrame = map.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                    else
                        Rayfield:Notify({
                            Title = "Error",
                            Content = "Location not found: " .. mapName,
                            Duration = 3,
                            Image = 4483362458
                        })
                    end
                end)
            end
        })
    end

    -- Tab 3: PLAYER
    local Tab3 = Window:CreateTab("PLAYER", 4483362458)

    local SpeedHackSlider = Tab3:CreateSlider({
        Name = "Speed Hack",
        Range = {16, 100},
        Increment = 1,
        Suffix = "x",
        CurrentValue = 16,
        Flag = "SpeedHack",
        Callback = function(Value)
            if Character and Character:FindFirstChild("Humanoid") then
                Character.Humanoid.WalkSpeed = Value
            end
        end
    })

    local FlyToggle = Tab3:CreateToggle({
        Name = "Fly",
        CurrentValue = false,
        Flag = "Fly",
        Callback = function(Value)
            if Value then
                spawn(function()
                    while task.wait() and FlyToggle:GetValue() do
                        if HumanoidRootPart then
                            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                end)
                UserInputService.InputBegan:Connect(function(input)
                    if FlyToggle:GetValue() then
                        if input.KeyCode == Enum.KeyCode.Space then
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                        elseif input.KeyCode == Enum.KeyCode.LeftControl then
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, -5, 0)
                        end
                    end
                end)
            else
                if HumanoidRootPart then
                    HumanoidRootPart.Anchored = false
                end
            end
        end
    })

    -- Tab 9: SHOP
    local Tab9 = Window:CreateTab("SHOP", 4483362458)

    local Rods = {
        "Starter Rod", "Carbon Rod", "Lucky Rod", "Astral Rod", "Angler Rod"
    }

    local RodDropdown = Tab9:CreateDropdown({
        Name = "Select Rod",
        Options = Rods,
        CurrentOption = "Starter Rod",
        Flag = "SelectedRod",
        Callback = function() end
    })

    Tab9:CreateButton({
        Name = "Buy Selected Rod",
        Callback = function()
            if BuyItemRemote then
                local rod = RodDropdown:GetValue()
                pcall(function()
                    BuyItemRemote:InvokeServer("Rod", rod)
                end)
            else
                Rayfield:Notify({
                    Title = "Error",
                    Content = "BuyItemRemote not found",
                    Duration = 3,
                    Image = 4483362458
                })
            end
        end
    })

    -- Tab 10: SETTINGS
    local Tab10 = Window:CreateTab("SETTINGS", 4483362458)

    Tab10:CreateButton({
        Name = "Save Config",
        Callback = function()
            Rayfield:SaveConfiguration()
            Rayfield:Notify({
                Title = "Saved",
                Content = "Configuration saved",
                Duration = 3,
                Image = 4483362458
            })
        end
    })

    Tab10:CreateButton({
        Name = "Rejoin Server",
        Callback = function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
        end
    })

    -- 🎉 NOTIFIKASI SUKSES
    Rayfield:Notify({
        Title = "Fish It Executor Loaded",
        Content = "UI berhasil dimuat. Fitur akan aktif jika remote tersedia.",
        Duration = 5,
        Image = 4483362458
    })

    -- 🔄 AUTO-RETRY REMOTE SETIAP 10 DETIK
    spawn(function()
        while task.wait(10) do
            if not CastLineRemote then
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                if remotes then
                    CastLineRemote = remotes:FindFirstChild("CastLine")
                    ReelInRemote = remotes:FindFirstChild("ReelIn")
                    BuyItemRemote = remotes:FindFirstChild("BuyItem")
                end
            end
            if not SellFishEvent then
                local events = ReplicatedStorage:FindFirstChild("Events")
                if events then
                    SellFishEvent = events:FindFirstChild("SellFish")
                end
            end
        end
    end)
end)

-- 🎮 HOTKEY TOGGLE UI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if Window then
            Window:Toggle()
        end
    end
end)

-- ✅ GARANSI: SCRIPT INI AKAN MENAMPILKAN UI MESKIPUN GAME TIDAK LENGKAP
-- JIKA MASIH TIDAK MUNCUL, KEMUNGKINAN:
-- 1. Executor memblokir loadstring — coba pakai Delta, Synapse, atau Fluxus
-- 2. Roblox update kebijakan keamanan — coba di game lain dulu
-- 3. Koneksi internet bermasalah — pastikan bisa akses raw.githubusercontent.com
