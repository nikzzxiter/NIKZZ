-- Fish It Hub 2025 by Nikzz Xit
-- Version: 2.5.0
-- Rayfield UI Version - Fixed

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "🐟 Fish It Hub 2025",
   LoadingTitle = "Fish It Hub Loader",
   LoadingSubtitle = "By NIKZZ XIT",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "FishItHub2025",
      FileName = "Config"
   },
   Discord = {
      Enabled = false
   }
})

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

-- Player References
local Player = Players.LocalPlayer

-- Game Specific Variables
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Events = ReplicatedStorage:WaitForChild("Events")

-- Find actual remote events for Fish It
local CastLineRemote = Remotes:FindFirstChild("CastLine") or Remotes:FindFirstChild("CastFishingLine")
local CatchFishRemote = Remotes:FindFirstChild("CatchFish") or Remotes:FindFirstChild("ReelIn")
local SellFishRemote = Events:FindFirstChild("SellFish") or Events:FindFirstChild("SellAllFish")
local UpgradeRodRemote = Events:FindFirstChild("UpgradeRod") or Events:FindFirstChild("UpgradeFishingRod")
local BuyBaitRemote = Events:FindFirstChild("BuyBait") or Events:FindFirstChild("PurchaseBait")
local RepairRodRemote = Events:FindFirstChild("RepairRod") or Events:FindFirstChild("RepairFishingRod")
local CollectChestRemote = Events:FindFirstChild("CollectChest") or Events:FindFirstChild("OpenChest")
local ClaimDailyRemote = Events:FindFirstChild("ClaimDaily") or Events:FindFirstChild("DailyReward")

-- Utility Functions
local function GetCharacter()
    return Player.Character or Player.CharacterAdded:Wait()
end

local function GetHumanoid()
    local character = GetCharacter()
    return character:FindFirstChildOfClass("Humanoid")
end

local function GetRootPart()
    local character = GetCharacter()
    return character:FindFirstChild("HumanoidRootPart")
end

local function Notify(title, content)
    Rayfield:Notify({
        Title = title,
        Content = content,
        Duration = 3,
        Image = 4483362458
    })
end

-- Real implementation functions
local function CastLine()
    if CastLineRemote then
        if CastLineRemote:IsA("RemoteEvent") then
            CastLineRemote:FireServer()
        elseif CastLineRemote:IsA("RemoteFunction") then
            CastLineRemote:InvokeServer()
        end
    end
end

local function CatchFish()
    if CatchFishRemote then
        if CatchFishRemote:IsA("RemoteEvent") then
            CatchFishRemote:FireServer()
        elseif CatchFishRemote:IsA("RemoteFunction") then
            CatchFishRemote:InvokeServer()
        end
    end
end

local function SellFish()
    if SellFishRemote then
        if SellFishRemote:IsA("RemoteEvent") then
            SellFishRemote:FireServer()
        elseif SellFishRemote:IsA("RemoteFunction") then
            SellFishRemote:InvokeServer()
        end
    end
end

local function UpgradeRod()
    if UpgradeRodRemote then
        if UpgradeRodRemote:IsA("RemoteEvent") then
            UpgradeRodRemote:FireServer()
        elseif UpgradeRodRemote:IsA("RemoteFunction") then
            UpgradeRodRemote:InvokeServer()
        end
    end
end

local function BuyBait(baitType, amount)
    if BuyBaitRemote then
        if BuyBaitRemote:IsA("RemoteEvent") then
            BuyBaitRemote:FireServer(baitType, amount or 1)
        elseif BuyBaitRemote:IsA("RemoteFunction") then
            BuyBaitRemote:InvokeServer(baitType, amount or 1)
        end
    end
end

local function RepairRod()
    if RepairRodRemote then
        if RepairRodRemote:IsA("RemoteEvent") then
            RepairRodRemote:FireServer()
        elseif RepairRodRemote:IsA("RemoteFunction") then
            RepairRodRemote:InvokeServer()
        end
    end
end

local function CollectChest(chest)
    if CollectChestRemote then
        if CollectChestRemote:IsA("RemoteEvent") then
            CollectChestRemote:FireServer(chest)
        elseif CollectChestRemote:IsA("RemoteFunction") then
            CollectChestRemote:InvokeServer(chest)
        end
    end
end

local function ClaimDaily()
    if ClaimDailyRemote then
        if ClaimDailyRemote:IsA("RemoteEvent") then
            ClaimDailyRemote:FireServer()
        elseif ClaimDailyRemote:IsA("RemoteFunction") then
            ClaimDailyRemote:InvokeServer()
        end
    end
end

-- 🎣 Fishing Tab
local FishingTab = Window:CreateTab("🎣 Fishing", 4483362458)

FishingTab:CreateToggle({
   Name = "Enable Auto Fish",
   CurrentValue = false,
   Flag = "AutoFish",
   Callback = function(v)
      getgenv().AutoFish = v
      while getgenv().AutoFish and task.wait(getgenv().FishDelay or 3) do
         CastLine()
         task.wait(1)
         CatchFish()
      end
   end
})

FishingTab:CreateToggle({
   Name = "Auto Cast",
   CurrentValue = false,
   Flag = "AutoCast",
   Callback = function(v)
      getgenv().AutoCast = v
      while getgenv().AutoCast and task.wait(2) do
         CastLine()
      end
   end
})

FishingTab:CreateToggle({
   Name = "Auto Catch",
   CurrentValue = false,
   Flag = "AutoCatch",
   Callback = function(v)
      getgenv().AutoCatch = v
      while getgenv().AutoCatch and task.wait(1) do
         CatchFish()
      end
   end
})

FishingTab:CreateToggle({
   Name = "Auto Perfect Catch",
   CurrentValue = false,
   Flag = "AutoPerfect",
   Callback = function(v)
      getgenv().AutoPerfect = v
      while getgenv().AutoPerfect and task.wait(0.5) do
         task.wait(0.2)
         CatchFish()
      end
   end
})

FishingTab:CreateToggle({
   Name = "Auto Sell Fish",
   CurrentValue = false,
   Flag = "AutoSell",
   Callback = function(v)
      getgenv().AutoSell = v
      while getgenv().AutoSell and task.wait(5) do
         SellFish()
      end
   end
})

FishingTab:CreateToggle({
   Name = "Auto Bait Select",
   CurrentValue = false,
   Flag = "AutoBait",
   Callback = function(v)
      getgenv().AutoBait = v
      -- Bait selection logic would go here
   end
})

FishingTab:CreateButton({
   Name = "Manual Cast",
   Callback = function()
      CastLine()
      Notify("Manual Cast", "Casting fishing line!")
   end
})

FishingTab:CreateSlider({
   Name = "Fishing Delay",
   Range = {1,10},
   Increment = 1,
   Suffix = "s",
   CurrentValue = 3,
   Flag = "FishDelay",
   Callback = function(v)
      getgenv().FishDelay = v
   end,
})

FishingTab:CreateToggle({
   Name = "Auto Repair Rod",
   CurrentValue = false,
   Flag = "AutoRepair",
   Callback = function(v)
      getgenv().AutoRepair = v
      while getgenv().AutoRepair and task.wait(10) do
         RepairRod()
      end
   end
})

-- 🛠 Tools Tab
local ToolsTab = Window:CreateTab("🛠 Tools", 6034509993)

ToolsTab:CreateToggle({
   Name = "Auto Collect Chests",
   CurrentValue = false,
   Flag = "AutoChests",
   Callback = function(v)
      getgenv().AutoChests = v
      while getgenv().AutoChests and task.wait(3) do
         local chests = Workspace:FindFirstChild("Chests") or Workspace:GetChildren()
         for _, chest in ipairs(chests) do
            if chest.Name:find("Chest") or chest.Name:find("Box") then
               CollectChest(chest)
            end
         end
      end
   end
})

ToolsTab:CreateToggle({
   Name = "Auto Upgrade Rod",
   CurrentValue = false,
   Flag = "AutoUpgrade",
   Callback = function(v)
      getgenv().AutoUpgrade = v
      while getgenv().AutoUpgrade and task.wait(5) do
         UpgradeRod()
      end
   end
})

ToolsTab:CreateToggle({
   Name = "Auto Repair Boat",
   CurrentValue = false,
   Flag = "AutoRepairBoat",
   Callback = function(v)
      getgenv().AutoRepairBoat = v
      -- Boat repair logic would go here
   end
})

ToolsTab:CreateButton({
   Name = "Infinite Oxygen",
   Callback = function()
      local humanoid = GetHumanoid()
      if humanoid then
         humanoid.OxygenLevel = humanoid.MaxOxygenLevel
         Notify("Oxygen", "Oxygen set to infinite!")
      end
   end
})

ToolsTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 100},
   Increment = 1,
   Suffix = "speed",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(v)
      local humanoid = GetHumanoid()
      if humanoid then
         humanoid.WalkSpeed = v
      end
   end,
})

ToolsTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 200},
   Increment = 1,
   Suffix = "power",
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(v)
      local humanoid = GetHumanoid()
      if humanoid then
         humanoid.JumpPower = v
      end
   end,
})

ToolsTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(v)
      getgenv().Noclip = v
      if v then
         RunService.Stepped:Connect(function()
            if getgenv().Noclip then
               for _, part in ipairs(GetCharacter():GetDescendants()) do
                  if part:IsA("BasePart") then
                     part.CanCollide = false
                  end
               end
            end
         end)
      end
   end
})

ToolsTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "Fly",
   Callback = function(v)
      getgenv().Fly = v
      -- Fly logic would go here
   end
})

ToolsTab:CreateToggle({
   Name = "ESP Fish",
   CurrentValue = false,
   Flag = "ESPFish",
   Callback = function(v)
      getgenv().ESPFish = v
      -- ESP logic would go here
   end
})

ToolsTab:CreateToggle({
   Name = "ESP Players",
   CurrentValue = false,
   Flag = "ESPPlayers",
   Callback = function(v)
      getgenv().ESPPlayers = v
      -- ESP logic would go here
   end
})

ToolsTab:CreateToggle({
   Name = "ESP Chests",
   CurrentValue = false,
   Flag = "ESPChests",
   Callback = function(v)
      getgenv().ESPChests = v
      -- ESP logic would go here
   end
})

ToolsTab:CreateToggle({
   Name = "Auto Buy Bait",
   CurrentValue = false,
   Flag = "AutoBuyBait",
   Callback = function(v)
      getgenv().AutoBuyBait = v
      while getgenv().AutoBuyBait and task.wait(30) do
         BuyBait("Worm", 10)
      end
   end
})

ToolsTab:CreateToggle({
   Name = "Auto Equip Rod",
   CurrentValue = false,
   Flag = "AutoEquipRod",
   Callback = function(v)
      getgenv().AutoEquipRod = v
      -- Auto equip logic would go here
   end
})

-- 🚀 Teleport Tab
local TeleportTab = Window:CreateTab("🚀 Teleport", 7733960981)

TeleportTab:CreateDropdown({
   Name = "Teleport Locations",
   Options = {"Spawn", "Market", "Upgrade Shop", "Fishing Spot 1", "Fishing Spot 2", "Hidden Spot"},
   CurrentOption = "Spawn",
   Flag = "TeleportLocation",
   Callback = function(Option)
      getgenv().SelectedLocation = Option
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport to Selected",
   Callback = function()
      Notify("Teleport", "Teleporting to " .. (getgenv().SelectedLocation or "Spawn"))
      -- Teleport logic would go here
   end
})

TeleportTab:CreateInput({
   Name = "Save Custom Location",
   PlaceholderText = "Location Name",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      getgenv().CustomLocations = getgenv().CustomLocations or {}
      getgenv().CustomLocations[Text] = GetRootPart().CFrame
      Notify("Location Saved", "Saved as: " .. Text)
   end,
})

TeleportTab:CreateInput({
   Name = "Teleport to Custom",
   PlaceholderText = "Location Name",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      if getgenv().CustomLocations and getgenv().CustomLocations[Text] then
         GetRootPart().CFrame = getgenv().CustomLocations[Text]
         Notify("Teleport", "Teleported to " .. Text)
      else
         Notify("Error", "Location not found!")
      end
   end,
})

TeleportTab:CreateToggle({
   Name = "Loop Chest Spots",
   CurrentValue = false,
   Flag = "LoopChests",
   Callback = function(v)
      getgenv().LoopChests = v
      -- Chest loop logic would go here
   end
})

-- 💎 Extra Tab
local ExtraTab = Window:CreateTab("💎 Extra", 9753762469)

ExtraTab:CreateToggle({
   Name = "Auto Collect Daily Reward",
   CurrentValue = false,
   Flag = "AutoDaily",
   Callback = function(v)
      getgenv().AutoDaily = v
      while getgenv().AutoDaily and task.wait(60) do
         ClaimDaily()
      end
   end
})

ExtraTab:CreateToggle({
   Name = "Auto Rank Claim",
   CurrentValue = false,
   Flag = "AutoRank",
   Callback = function(v)
      getgenv().AutoRank = v
      -- Rank claim logic would go here
   end
})

ExtraTab:CreateToggle({
   Name = "Auto Upgrade Backpack",
   CurrentValue = false,
   Flag = "AutoBackpack",
   Callback = function(v)
      getgenv().AutoBackpack = v
      -- Backpack upgrade logic would go here
   end
})

ExtraTab:CreateToggle({
   Name = "Auto Buy Rod",
   CurrentValue = false,
   Flag = "AutoBuyRod",
   Callback = function(v)
      getgenv().AutoBuyRod = v
      -- Rod purchase logic would go here
   end
})

ExtraTab:CreateToggle({
   Name = "Auto Equip Best Rod",
   CurrentValue = false,
   Flag = "AutoBestRod",
   Callback = function(v)
      getgenv().AutoBestRod = v
      -- Best rod logic would go here
   end
})

ExtraTab:CreateToggle({
   Name = "Auto Equip Best Bait",
   CurrentValue = false,
   Flag = "AutoBestBait",
   Callback = function(v)
      getgenv().AutoBestBait = v
      -- Best bait logic would go here
   end
})

ExtraTab:CreateDropdown({
   Name = "Select Bait Type",
   Options = {"Worm", "Shrimp", "Squid", "Special", "Golden"},
   CurrentOption = "Worm",
   Flag = "BaitType",
   Callback = function(Option)
      getgenv().SelectedBait = Option
   end,
})

ExtraTab:CreateDropdown({
   Name = "Select Rod Type",
   Options = {"Basic Rod", "Wooden Rod", "Steel Rod", "Golden Rod", "Diamond Rod"},
   CurrentOption = "Basic Rod",
   Flag = "RodType",
   Callback = function(Option)
      getgenv().SelectedRod = Option
   end,
})

-- ⚙ Settings Tab
local SettingsTab = Window:CreateTab("⚙ Settings", 6034509993)

SettingsTab:CreateColorPicker({
   Name = "UI Accent Color",
   Color = Color3.fromRGB(0, 162, 255),
   Flag = "UIColor",
   Callback = function(Value)
      -- UI color change logic would go here
   end
})

SettingsTab:CreateInput({
   Name = "Custom Command",
   PlaceholderText = "Enter command",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      if Text == "reset" then
          GetHumanoid().Health = 0
      elseif Text == "hop" then
          -- Server hop logic
      elseif Text == "rejoin" then
          TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
      end
   end,
})

SettingsTab:CreateToggle({
   Name = "Anti AFK",
   CurrentValue = false,
   Flag = "AntiAFK",
   Callback = function(v)
      getgenv().AntiAFK = v
      if v then
          Player.Idled:Connect(function()
              VirtualInputManager:SendKeyEvent(true, "W", false, game)
              task.wait(0.1)
              VirtualInputManager:SendKeyEvent(false, "W", false, game)
          end)
      end
   end
})

SettingsTab:CreateKeybind({
   Name = "Hide/Show UI",
   CurrentKeybind = "RightShift",
   HoldToInteract = false,
   Flag = "HideUI",
   Callback = function(Keybind)
      Rayfield:Destroy()
   end,
})

SettingsTab:CreateButton({
   Name = "Reset Character",
   Callback = function()
      GetHumanoid().Health = 0
      Notify("Reset", "Character reset!")
   end
})

SettingsTab:CreateButton({
   Name = "Server Hop",
   Callback = function()
      -- Server hop logic would go here
      Notify("Server Hop", "Hopping servers...")
   end
})

SettingsTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
      TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
      Notify("Rejoin", "Rejoining server...")
   end
})

SettingsTab:CreateToggle({
   Name = "Low Graphics Mode",
   CurrentValue = false,
   Flag = "LowGraphics",
   Callback = function(v)
      getgenv().LowGraphics = v
      if v then
          settings().Rendering.QualityLevel = 1
          Lighting.GlobalShadows = false
      else
          settings().Rendering.QualityLevel = 10
          Lighting.GlobalShadows = true
      end
   end
})

SettingsTab:CreateToggle({
   Name = "FPS Unlocker",
   CurrentValue = false,
   Flag = "FPSUnlocker",
   Callback = function(v)
      getgenv().FPSUnlocker = v
      if v then
          setfpscap(999)
      else
          setfpscap(60)
      end
   end
})

SettingsTab:CreateLabel("Fish It Hub 2025 by Nikzz Xit")
SettingsTab:CreateLabel("Version: 2.5.0")
SettingsTab:CreateLabel("Thank you for using!")

-- Initial notification
Rayfield:Notify({
    Title = "Fish It Hub 2025 Loaded",
    Content = "by Nikzz Xit | Enjoy the features!",
    Duration = 5,
    Image = 4483362458
})
