-- // Rayfield UI Loader
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Fish It Scanner | Nikzz",
   LoadingTitle = "Fish It Dump Tool",
   LoadingSubtitle = "By Nikzz",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Scanner", 4483362458)

-- // Vars
local logFile = "NikzzLog.txt"
local scanEnabled = false
local spyEnabled = false

-- // Logging Function
local function log(msg)
   local time = os.date("%Y-%m-%d %H:%M:%S")
   local line = "["..time.."] "..tostring(msg).."\n"
   if isfile(logFile) then
      appendfile(logFile, line)
   else
      writefile(logFile, line)
   end
end

-- // Toggles
MainTab:CreateToggle({
   Name = "Scan Assets (Remotes + Modules + GC)",
   CurrentValue = false,
   Flag = "Scan",
   Callback = function(state)
      scanEnabled = state
      if state then
         log("==== SCAN DIMULAI ====")

         -- Remote Finder
         log("[RemoteEvent / RemoteFunction]")
         for _,v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
               log("Remote: "..v.Name.." | Path: "..v:GetFullName())
            end
         end

         -- Loaded Modules
         log("[Loaded Modules]")
         for _,v in pairs(getloadedmodules()) do
            pcall(function()
               log("Module: "..v.Name.." | Path: "..v:GetFullName())
            end)
         end

         -- GC Functions
         log("[getgc Dump]")
         for _,v in pairs(getgc(true)) do
            if type(v) == "function" and islclosure(v) then
               local info = debug.getinfo(v)
               if info and info.source then
                  log("Function @ "..info.source.." | "..(info.name or "anonymous"))
               end
            end
         end

         log("==== SCAN SELESAI ====")
      else
         log("SCAN dimatikan.")
      end
   end,
})

-- // Remote Spy Toggle
MainTab:CreateToggle({
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

   if spyEnabled and (method == "FireServer" or method == "InvokeServer") then
      local argStr = ""
      for i,v in ipairs(args) do
         argStr = argStr.."["..i.."]="..tostring(v).." "
      end
      log("Remote Called: "..self.Name.." | Method: "..method.." | Args: "..argStr)
   end

   return old(self, unpack(args))
end)
