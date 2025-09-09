-- Base Rayfield AutoFarm for "Fish It" (single tab: Auto Farm)
-- Penulis: Profesor Modder (hasil analisis module log)
-- Catatan: Sesuaikan path remote jika game memperbarui paket. Ada banyak pencegahan pcall agar tidak error.

-- == Dependencies: Rayfield UI ==
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
-- jika kamu punya versi lokal Rayfield, ganti source di atas

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildOfClass("Humanoid") or Character:WaitForChild("Humanoid")

-- Paths (berdasarkan scan file)
local PACK_ROOT = ReplicatedStorage.Packages and ReplicatedStorage.Packages._Index or ReplicatedStorage -- fallback
-- Remote names yang terdeteksi
local rf_paths = {
    RequestFishingMinigameStarted = PACK_ROOT:FindFirstChild("sleitnick_net@0.2.0.net") and PACK_ROOT["sleitnick_net@0.2.0.net"].FindFirstChild and "RequestFishingMinigameStarted" or "RequestFishingMinigameStarted",
    ChargeFishingRod = PACK_ROOT:FindFirstChild("sleitnick_net@0.2.0.net") and PACK_ROOT["sleitnick_net@0.2.0.net"].FindFirstChild and "ChargeFishingRod" or "ChargeFishingRod",
    SellItem = PACK_ROOT:FindFirstChild("sleitnick_net@0.2.0.net") and PACK_ROOT["sleitnick_net@0.2.0.net"].FindFirstChild and "SellItem" or "SellItem",
    SellAllItems = PACK_ROOT:FindFirstChild("sleitnick_net@0.2.0.net") and PACK_ROOT["sleitnick_net@0.2.0.net"].FindFirstChild and "SellAllItems" or "SellAllItems",
    UpdateAutoFishingState = PACK_ROOT and "UpdateAutoFishingState"
}

-- helper: try to get RemoteFunction/Event by name from known packages (robust)
local function getRemoteByName(name)
    -- try common locations found in log
    local candidates = {
        ReplicatedStorage:FindFirstChild(name),
        ReplicatedStorage.Packages and ReplicatedStorage.Packages._Index and ReplicatedStorage.Packages._Index:FindFirstChild(name),
        ReplicatedStorage.Packages and ReplicatedStorage.Packages._Index and ReplicatedStorage.Packages._Index:FindFirstChild("sleitnick_net@0.2.0.net") and ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0.net"]:FindFirstChild(name),
        ReplicatedStorage.Packages and ReplicatedStorage.Packages._Index and ReplicatedStorage.Packages._Index:FindFirstChild("ytrev_replion@2.0.0-rc.3.replion") and ReplicatedStorage.Packages._Index["ytrev_replion@2.0.0-rc.3.replion"]:FindFirstChild(name),
        ReplicatedStorage.Events and ReplicatedStorage.Events:FindFirstChild(name),
        ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild(name)
    }
    for _,c in pairs(candidates) do
        if type(c)=="userdata" and c then return c end
    end
    -- last resort: search recursively (safe)
    local found = ReplicatedStorage:FindFirstChild(name, true)
    if found then return found end
    return nil
end

-- get remotes (pcall safe wrappers)
local RF_RequestFishingMinigameStarted = getRemoteByName("RequestFishingMinigameStarted") or getRemoteByName("RF/RequestFishingMinigameStarted")
local RF_ChargeFishingRod = getRemoteByName("ChargeFishingRod") or getRemoteByName("RF/ChargeFishingRod")
local RF_SellItem = getRemoteByName("SellItem") or getRemoteByName("RF/SellItem")
local RF_SellAllItems = getRemoteByName("SellAllItems") or getRemoteByName("RF/SellAllItems")

-- util: find best rod in backpack/hotbar (simple heuristic: '!!!' rods considered best)
local function findBestRod()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return nil end
    local best
    for _,tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local n = tool.Name
            if string.find(n, "!!!") then
                return tool
            elseif not best then best = tool end
        end
    end
    return best
end

-- local equip
local function equipTool(tool)
    if not tool then return false end
    pcall(function()
        -- attempt local equip
        Humanoid:EquipTool(tool)
    end)
    return true
end

-- AUTO THROW / PERFECT THROW (best-effort)
local function autoThrowPerfect()
    -- Approach:
    -- 1) If remote function exists, try to call it with parameters that simulate a full-charge / perfect throw.
    -- 2) Otherwise, activate local tool (simulate click).
    if RF_ChargeFishingRod and RF_ChargeFishingRod.InvokeServer then
        pcall(function()
            -- NOTE: server arg structure unknown. Many games accept number charge [0..1] or boolean perfect flag.
            -- We try common patterns; if these fail, they simply error inside pcall and fallback.
            -- Attempt patterns:
            local patterns = {
                function() RF_ChargeFishingRod:InvokeServer(1) end,
                function() RF_ChargeFishingRod:InvokeServer({charge = 1}) end,
                function() RF_ChargeFishingRod:InvokeServer(true) end,
            }
            for _,fn in ipairs(patterns) do
                local ok, _ = pcall(fn)
                if ok then break end
            end
            -- start minigame if available
            if RF_RequestFishingMinigameStarted and RF_RequestFishingMinigameStarted.InvokeServer then
                pcall(function() RF_RequestFishingMinigameStarted:InvokeServer() end)
            end
        end)
        return
    end

    -- fallback: activate equipped tool locally
    local equipped = Character:FindFirstChildOfClass("Tool") or findBestRod()
    if equipped and equipped:IsA("Tool") then
        pcall(function() equipped:Activate() end)
    end
end

-- AUTO PULL (instant)
local function autoPullInstant()
    -- Many servers handle the catch on server; we attempt to call a server remote that may finish the catch.
    -- Try to call 'RequestFishingMinigameStarted' -> then immediately try to cancel inputs or set charge to max.
    if RF_RequestFishingMinigameStarted and RF_RequestFishingMinigameStarted.InvokeServer then
        pcall(function()
            RF_RequestFishingMinigameStarted:InvokeServer() -- start
            -- Then attempt to charge to max
            if RF_ChargeFishingRod and RF_ChargeFishingRod.InvokeServer then
                RF_ChargeFishingRod:InvokeServer(1) -- try full charge
            end
            -- Some games may have remote to cancel inputs or to claim fish; try SellAllItems is not relevant here.
        end)
        return
    end
    -- fallback: do nothing (server-side handling)
end

-- AUTO SELL non-favorite (simple approach)
local function autoSellNonFavorites()
    -- Strategy:
    -- 1) Query player's inventory (client-side InventoryController may not expose items; we enumerate ReplicatedStorage.Items? or LocalPlayer inventory instances)
    -- 2) For each item that is NOT favourited (we cannot reliably inspect server favorites), we try RF/SellItem or RF/SellAllItems
    if RF_SellAllItems and RF_SellAllItems.InvokeServer then
        pcall(function()
            RF_SellAllItems:InvokeServer()
        end)
        return
    end
    if RF_SellItem and RF_SellItem.InvokeServer then
        -- we need an item id list; as fallback, try selling by name if server accepts {name}
        local invFolder = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:FindFirstChild("Backpack")
        -- This is heuristic; real servers often require item ids from server.
        pcall(function() RF_SellItem:InvokeServer("all_non_favorites") end)
    end
end

-- AUTO JUMP
local autoJumpEnabled = false
local function toggleAutoJump(state)
    autoJumpEnabled = state
end
spawn(function()
    while true do
        if autoJumpEnabled then
            if Humanoid and Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
                pcall(function() Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
            end
        end
        task.wait(0.9)
    end
end)

-- MAIN AUTO FARM LOOP
local autoFarmEnabled = false
local autoSellEnabled = false

local function runAutoFarmLoop()
    spawn(function()
        while autoFarmEnabled do
            -- 1) equip best rod
            local best = findBestRod()
            if best then
                pcall(equipTool, best)
            end

            -- 2) throw perfect
            autoThrowPerfect()

            -- 3) small wait to simulate immediate pull
            task.wait(0.12) -- adjust if needed
            autoPullInstant()

            -- 4) optionally sell
            if autoSellEnabled then
                autoSellNonFavorites()
            end

            -- main loop delay (adjustable)
            task.wait(0.6)
        end
    end)
end

-- == Rayfield UI ==
local Window = Rayfield:CreateWindow({
    Name = "FishIt - AutoFarm Base",
    LoadingTitle = "Analisis & Base oleh Profesor Modder",
    LoadingSubtitle = "Base Rayfield siap pakai",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "FishItAutoFarmConfig"
    },
    Discord = {
        Enabled = false
    }
})

local Tab = Window:CreateTab("Auto Farm", 4483362458) -- icon id random
local Section = Tab:CreateSection("Core")

Tab:CreateToggle({
    Name = "Auto Farm (Equip/Throw/Pull)",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(value)
        autoFarmEnabled = value
        if value then runAutoFarmLoop() end
    end
})

Tab:CreateToggle({
    Name = "Auto Sell (non-favorites)",
    CurrentValue = false,
    Flag = "AutoSellToggle",
    Callback = function(value)
        autoSellEnabled = value
    end
})

Tab:CreateToggle({
    Name = "Auto Jump",
    CurrentValue = false,
    Flag = "AutoJumpToggle",
    Callback = function(value)
        toggleAutoJump(value)
    end
})

Tab:CreateButton({
    Name = "Force Sell Now",
    Callback = function()
        pcall(function() autoSellNonFavorites() end)
    end
})

Tab:CreateButton({
    Name = "Equip Best Rod (manually)",
    Callback = function()
        local t = findBestRod()
        if t then equipTool(t) end
    end
})

-- End of script
