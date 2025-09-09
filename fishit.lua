-- // Rayfield UI Loader
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Fish It Hub | Nikzz",
   LoadingTitle = "Fish It Logger",
   LoadingSubtitle = "By Nikzz",
   ConfigurationSaving = {
      Enabled = false
   }
})

-- // Vars
local logFile = "NikzzLog.txt"
local autoFishEnabled = false
local spyEnabled = false

-- // Logging System
local function log(msg)
   local time = os.date("%Y-%m-%d %H:%M:%S")
   local line = "["..time.."] "..tostring(msg).."\n"
   if isfile(logFile) then
      appendfile(logFile, line)
   else
      writefile(logFile, line)
   end
end

-- // Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local SpyTab  = Window:CreateTab("RemoteSpy", 4483362458)

-- // Auto Fish Toggle
MainTab:CreateToggle({
   Name = "Auto Fish",
   CurrentValue = false,
   Flag = "AutoFish",
   Callback = function(state)
      autoFishEnabled = state
      log("AutoFish set to: "..tostring(state))
   end,
})

-- // Remote Spy Toggle
SpyTab:CreateToggle({
   Name = "Enable Remote Spy",
   CurrentValue = false,
   Flag = "Spy",
   Callback = function(state)
      spyEnabled = state
      log("RemoteSpy set to: "..tostring(state))
   end,
})

-- // Remote Spy Hook
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
   local args = {...}
   local method = getnamecallmethod()

   if spyEnabled and method == "FireServer" then
      log("Remote Fired: "..self.Name.." | Args: "..table.concat(args, ", "))
   end

   return old(self, unpack(args))
end)

-- // AutoFish Core Loop
task.spawn(function()
   while task.wait(1) do
      if autoFishEnabled then
         local player = game.Players.LocalPlayer
         local rs = game:GetService("ReplicatedStorage")

         -- Cek remote casting
         local cast = rs:FindFirstChild("Cast")
         local reel = rs:FindFirstChild("Reel")

         if cast and reel then
            log("Casting line...")
            pcall(function() cast:FireServer() end)
            task.wait(3) -- tunggu ikan
            log("Reeling...")
            pcall(function() reel:FireServer() end)
         else
            log("Remote Cast/Reel tidak ditemukan!")
         end
      end
   end
end)
