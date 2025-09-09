-- Fish It AutoFarm (No Error Edition)
-- Profesor Modder

-- ========== Load Rayfield UI ==========
local Rayfield
local ok, err = pcall(function()
    Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()
end)
if not ok or not Rayfield then
    warn("Rayfield gagal dimuat: "..tostring(err))
    -- fallback UI dummy (biar nggak error)
    Rayfield = {
        CreateWindow = function() return {
            CreateTab = function() return {
                CreateSection=function()end,
                CreateToggle=function()end,
                CreateButton=function()end,
            } end
        } end
    }
end

-- ========== Service & Player ==========
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- ========== Helper: Cari Remote ==========
local function getRemote(name)
    local found = ReplicatedStorage:FindFirstChild(name, true)
    if not found then
        warn("Remote tidak ketemu:", name)
    end
    return found
end

local RF_RequestFishing = getRemote("RequestFishingMinigameStarted")
local RF_ChargeRod = getRemote("ChargeFishingRod")
local RF_SellItem = getRemote("SellItem")
local RF_SellAll = getRemote("SellAllItems")

-- ========== Fungsi Dasar ==========
local function findBestRod()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return end
    for _,tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            return tool
        end
    end
end

local function equipRod()
    local rod = findBestRod()
    if rod then pcall(function() Humanoid:EquipTool(rod) end) end
end

local function throwPerfect()
    if RF_ChargeRod and RF_ChargeRod.InvokeServer then
        pcall(function() RF_ChargeRod:InvokeServer(1) end)
    else
        local rod = Character:FindFirstChildOfClass("Tool")
        if rod then pcall(function() rod:Activate() end) end
    end
end

local function pullInstant()
    if RF_RequestFishing and RF_RequestFishing.InvokeServer then
        pcall(function() RF_RequestFishing:InvokeServer() end)
    end
end

local function sellFish()
    if RF_SellAll and RF_SellAll.InvokeServer then
        pcall(function() RF_SellAll:InvokeServer() end)
    elseif RF_SellItem and RF_SellItem.InvokeServer then
        pcall(function() RF_SellItem:InvokeServer("all_non_favorites") end)
    end
end

-- ========== Loop ==========
local autoFarm, autoSell, autoJump = false,false,false

task.spawn(function()
    while task.wait(0.6) do
        if autoFarm then
            equipRod()
            throwPerfect()
            task.wait(0.15)
            pullInstant()
            if autoSell then sellFish() end
        end
    end
end)

task.spawn(function()
    while task.wait(0.9) do
        if autoJump and Humanoid then
            pcall(function() Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
        end
    end
end)

-- ========== UI ==========
local Window = Rayfield:CreateWindow({
    Name = "Fish It AutoFarm",
    LoadingTitle = "Profesor Modder",
    LoadingSubtitle = "No Error",
})

local Tab = Window:CreateTab("Auto Farm", 4483362458)
Tab:CreateSection("Core")

Tab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Callback = function(v) autoFarm = v end
})

Tab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = false,
    Callback = function(v) autoSell = v end
})

Tab:CreateToggle({
    Name = "Auto Jump",
    CurrentValue = false,
    Callback = function(v) autoJump = v end
})

Tab:CreateButton({
    Name = "Force Sell Now",
    Callback = sellFish
})
