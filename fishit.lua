-- // Rayfield Loader
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Fish It | AutoFarm Hub",
    LoadingTitle = "Nikzz Hub",
    LoadingSubtitle = "AutoFarm Core",
    ConfigurationSaving = { Enabled = false }
})

-- // Vars
local rs = game:GetService("ReplicatedStorage")
local cast = rs.Remotes:FindFirstChild("CastLine")
local reel = rs.Remotes:FindFirstChild("ReelFish")
local sell = rs.Remotes:FindFirstChild("SellFish")
local upgrade = rs.Remotes:FindFirstChild("UpgradeRod")
local equip = rs.Remotes:FindFirstChild("EquipRod")

getgenv().AutoFish = false
getgenv().AutoEquip = false
getgenv().AutoSell = false
getgenv().AutoUpgrade = false

-- // Tabs
local MainTab = Window:CreateTab("AutoFarm", 4483362458)

-- Auto Fish Toggle
MainTab:CreateToggle({
    Name = "Auto Fish (Perfect)",
    CurrentValue = false,
    Flag = "AutoFish",
    Callback = function(state)
        getgenv().AutoFish = state
        print("AutoFish:", state)
    end,
})

-- Auto Equip Rod
MainTab:CreateToggle({
    Name = "Auto Equip Rod",
    CurrentValue = false,
    Flag = "AutoEquip",
    Callback = function(state)
        getgenv().AutoEquip = state
        print("AutoEquip:", state)
    end,
})

-- Auto Sell
MainTab:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(state)
        getgenv().AutoSell = state
        print("AutoSell:", state)
    end,
})

-- Auto Upgrade Rod
MainTab:CreateToggle({
    Name = "Auto Upgrade Rod",
    CurrentValue = false,
    Flag = "AutoUpgrade",
    Callback = function(state)
        getgenv().AutoUpgrade = state
        print("AutoUpgrade:", state)
    end,
})

-- // Auto Fish Loop
task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoFish then
            pcall(function()
                if cast then
                    cast:FireServer("Perfect") -- argumen Perfect
                    print("Casting Perfect...")
                end
            end)

            task.wait(4) -- tunggu ikan (atur sesuai delay game)

            pcall(function()
                if reel then
                    reel:FireServer(true)
                    print("Reeling fish...")
                end
            end)
        end
    end
end)

-- // Auto Equip Rod Loop
task.spawn(function()
    while task.wait(5) do
        if getgenv().AutoEquip and equip then
            pcall(function()
                equip:FireServer("BasicRod") -- ganti arg sesuai rod yang ada di log kamu
                print("Equipped Rod.")
            end)
        end
    end
end)

-- // Auto Sell Loop
task.spawn(function()
    while task.wait(10) do
        if getgenv().AutoSell and sell then
            pcall(function()
                sell:FireServer()
                print("Auto Sell executed.")
            end)
        end
    end
end)

-- // Auto Upgrade Loop
task.spawn(function()
    while task.wait(15) do
        if getgenv().AutoUpgrade and upgrade then
            pcall(function()
                upgrade:FireServer()
                print("Auto Upgrade tried.")
            end)
        end
    end
end)
