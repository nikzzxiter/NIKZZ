-- Rayfield AutoFish Helper (RemoteSpy + Logger + AutoFish template)
-- Untuk executor Android yang mendukung Rayfield & writefile/appendfile/isfile
-- 2025 - Template: gunakan untuk belajar / debugging / pribadi saja.

-- ======= CONFIG =======
local LOG_FILE = "NikzzLog.txt"         -- akan tersimpan di folder executor (use writefile/appendfile)
local AUTO_CAST_INTERVAL_DEFAULT = 4    -- detik antara cast jika auto-cast ON
local AUTO_WAIT_AFTER_CAST = 3          -- default tunggu after cast (bisa diubah di UI)
-- ======================

-- Utility safe write/append
local function safe_write(path, content)
    if writefile then
        writefile(path, content)
        return true
    elseif writefile_safe then
        writefile_safe(path, content)
        return true
    end
    return false
end
local function safe_append(path, content)
    if appendfile then
        appendfile(path, content)
        return true
    elseif writefile and isfile and isfile(path) then
        -- fallback: read + write
        local prev = readfile(path)
        writefile(path, prev .. content)
        return true
    end
    return false
end
local function safe_isfile(path)
    if isfile then return isfile(path) end
    return false
end

local function log(msg)
    local time = os.date("%Y-%m-%d %H:%M:%S")
    local line = string.format("[%s] %s\n", time, tostring(msg))
    if safe_isfile(LOG_FILE) then
        safe_append(LOG_FILE, line)
    else
        safe_write(LOG_FILE, line)
    end
    pcall(function() print(line) end)
end

-- ===== Remote Spy (namecall hook) =====
local detectedRemotes = {}   -- map fullName -> {instance=ref, calls = {{method,args}}}
local lastCall = nil         -- store last call info

local function registerRemoteCall(remoteInst, method, ...)
    local name = "Unknown"
    pcall(function() name = remoteInst:GetFullName() end)
    if not detectedRemotes[name] then
        detectedRemotes[name] = { instance = remoteInst, calls = {} }
    end
    local args = {...}
    table.insert(detectedRemotes[name].calls, { method = method, args = args, time = tick() })
    lastCall = { name = name, method = method, args = args, time = tick() }
    log(string.format("SPY: %s %s | args=%s", name, method, table.concat((function()
        local t = {}
        for i,v in ipairs(args) do t[i]=tostring(v) end
        return t
    end)(), ", ")))
end

-- Try to hook metatable (common on many executors)
local success_hook = pcall(function()
    local mt = getrawmetatable(game)
    local old__namecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" or method == "InvokeServer" then
            pcall(registerRemoteCall, self, method, ...)
        end
        return old__namecall(self, ...)
    end)
    setreadonly(mt, true)
end)

if success_hook then
    log("RemoteSpy hook installed.")
else
    log("Warning: failed to install namecall hook. RemoteSpy may not capture calls in this executor.")
end

-- ===== Scanner (find remotes in common locations) =====
local function enumRemotes()
    local results = {}
    local servicesToScan = {
        game:GetService("ReplicatedStorage"),
        game:GetService("Workspace"),
        game:GetService("Players"),
        game:GetService("StarterPlayer"),
        game:GetService("StarterGui")
    }
    for _, svc in ipairs(servicesToScan) do
        pcall(function()
            for _, v in ipairs(svc:GetDescendants()) do
                if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                    local full = v:GetFullName()
                    results[full] = v
                end
            end
        end)
    end
    return results
end

-- ===== Simple helper to fire remote safely (user-provided) =====
local function safeFire(remoteInstance, ...)
    if not remoteInstance then return false, "no remote" end
    local ok, err = pcall(function()
        if remoteInstance:IsA("RemoteEvent") then
            remoteInstance:FireServer(...)
        elseif remoteInstance:IsA("RemoteFunction") then
            remoteInstance:InvokeServer(...)
        else
            error("not a remote")
        end
    end)
    return ok, err
end

-- ===== Rayfield UI =====
-- Ensure Rayfield is available in executor. This is a minimal UI bootstrap; some executors auto-provide Rayfield.
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")) -- fallback harmless loader (if allowed)
-- Note: if your executor provides Rayfield differently, swap loader accordingly.
local Library
local ok_ui, ui_err = pcall(function()
    -- try to require Rayfield if present
    if _G.Rayfield then
        Library = _G.Rayfield:CreateWindow({
            Name = "AutoFish Helper",
            LoadingTitle = "Nikzz AutoFish Helper",
            LoadingSubtitle = "RemoteSpy + Logger",
            KeySystem = false
        })
    else
        -- minimal mock UI if Rayfield unavailable: skip UI creation
        Library = nil
    end
end)

-- Build UI only if Library exists
local selectedRemoteName = nil
local userCastArgsText = ""      -- comma-separated args
local userReelArgsText = ""      -- comma-separated args
local autoCastInterval = AUTO_CAST_INTERVAL_DEFAULT
local autoWaitAfterCast = AUTO_WAIT_AFTER_CAST
local autoFishEnabled = false
local autoCastEnabled = false

if Library then
    local mainTab = Library:CreateTab("Main", 4483362458)
    local spySection = mainTab:CreateSection("RemoteSpy & Scanner")
    local remotesDropdown = mainTab:CreateDropdown({
        Name = "Detected Remotes",
        Options = {"(scan/spy to populate)"},
        CurrentOption = "(scan/spy to populate)",
        Flag = "remotedrop",
        Callback = function(option) selectedRemoteName = option end
    })
    mainTab:CreateButton({ Name = "Scan Remotes (ReplicatedStorage/Workspace/Players)", Callback = function()
        local found = enumRemotes()
        local opts = {}
        for full, inst in pairs(found) do table.insert(opts, full) end
        if #opts == 0 then opts = {"(none found)"} end
        remotesDropdown:Refresh(opts, opts[1])
        log("Scan complete. Found "..tostring(#opts).." remotes.")
    end})
    mainTab:CreateButton({ Name = "Refresh Spy List (detected during gameplay)", Callback = function()
        local opts = {}
        for name,_ in pairs(detectedRemotes) do table.insert(opts, name) end
        if #opts == 0 then opts = {"(no spy calls yet)"} end
        remotesDropdown:Refresh(opts, opts[1])
        log("Spy refresh complete. Detected "..tostring(#opts).." unique remote names.")
    end})

    mainTab:CreateLabel("If Spy lists remote names, choose the one that corresponds to fishing actions.")

    local configSection = mainTab:CreateSection("AutoFish Config")
    local castBox = mainTab:CreateInput({
        Name = "Cast Args (comma separated)",
        PlaceholderText = "e.g. Cast",
        Value = "",
        Callback = function(val) userCastArgsText = val end
    })
    local reelBox = mainTab:CreateInput({
        Name = "Reel Args (comma separated)",
        PlaceholderText = "e.g. Reel",
        Value = "",
        Callback = function(val) userReelArgsText = val end
    })
    mainTab:CreateSlider({
        Name = "Auto-cast Interval (sec)",
        Range = {1, 20},
        Increment = 1,
        Suffix = "s",
        CurrentValue = autoCastInterval,
        Flag = "castint",
        Callback = function(v) autoCastInterval = v end
    })
    mainTab:CreateSlider({
        Name = "Default wait after cast (sec)",
        Range = {0, 10},
        Increment = 0.1,
        Suffix = "s",
        CurrentValue = autoWaitAfterCast,
        Flag = "waitcast",
        Callback = function(v) autoWaitAfterCast = v end
    })
    mainTab:CreateToggle({
        Name = "AutoCast (periodic cast)",
        CurrentValue = false,
        Flag = "autocast",
        Callback = function(v) autoCastEnabled = v end
    })
    mainTab:CreateToggle({
        Name = "AutoFish (listen for bite via Spy -> auto reel)",
        CurrentValue = false,
        Flag = "autofish",
        Callback = function(v) autoFishEnabled = v end
    })

    mainTab:CreateButton({ Name = "Open Log File (executor file browser)", Callback = function()
        log("Open your executor file browser and open: "..LOG_FILE)
    end })

    mainTab:CreateLabel("Important: After scanning/spy, pilih remote yang benar di dropdown lalu isi argumen yang sesuai.")
else
    -- if no Rayfield, still provide instructions in console
    log("Rayfield not detected. Script will run headless. Use console commands.")
end

-- ===== Background loops =====
spawn(function()
    while true do
        wait(0.1)
        -- Auto-cast loop
        if autoCastEnabled and selectedRemoteName and detectedRemotes[selectedRemoteName] then
            -- fire cast, then wait interval
            local remInst = detectedRemotes[selectedRemoteName].instance or (enumRemotes())[selectedRemoteName]
            if remInst then
                -- parse user args for cast (simple split by comma)
                local args = {}
                if userCastArgsText and #userCastArgsText>0 then
                    for s in string.gmatch(userCastArgsText, "([^,]+)") do
                        s = s:gsub("^%s+",""):gsub("%s+$","")
                        table.insert(args, s)
                    end
                end
                local ok,err = safeFire(remInst, unpack(args))
                log("AutoCast -> "..tostring(selectedRemoteName).." ok="..tostring(ok).." err="..tostring(err))
                wait(autoCastInterval)
            else
                -- attempt to re-resolve remote via enum
                local found = enumRemotes()
                if found[selectedRemoteName] then detectedRemotes[selectedRemoteName] = { instance = found[selectedRemoteName], calls = {} } end
                wait(1)
            end
        else
            wait(0.5)
        end
    end
end)

-- AutoFish reaction: when spy detects a call to the selected remote with certain pattern, auto reel
spawn(function()
    while true do
        wait(0.05)
        if autoFishEnabled and lastCall and selectedRemoteName and lastCall.name == selectedRemoteName then
            -- simple heuristic: any remote call to the selected remote while AutoFish ON triggers a reel after small delay
            -- better: you may inspect lastCall.args and match specific value like "Bite", "Hit", etc.
            log("AutoFish: Detected remote call to selected remote -> triggering reel sequence.")
            -- small configurable wait (perfect timing option could be determined by user observation)
            wait(0.09) -- small reaction time, tweak in UI above
            -- fire reel (use user provided reel args)
            local remInst = detectedRemotes[selectedRemoteName] and detectedRemotes[selectedRemoteName].instance or nil
            if remInst then
                local args = {}
                if userReelArgsText and #userReelArgsText>0 then
                    for s in string.gmatch(userReelArgsText, "([^,]+)") do
                        s = s:gsub("^%s+",""):gsub("%s+$","")
                        table.insert(args, s)
                    end
                end
                local ok, err = safeFire(remInst, unpack(args))
                log("AutoReel -> "..tostring(selectedRemoteName).." ok="..tostring(ok).." err="..tostring(err))
            end
            -- clear lastCall to avoid repeated triggers
            lastCall = nil
            wait(0.2)
        end
    end
end)

-- ===== Final note logger =====
log("AutoFish Helper loaded. LOG_FILE="..LOG_FILE)
log("Usage: scan with scanner, perform fishing actions manually once while Spy is enabled, refresh spy list, choose remote, configure args, then enable AutoFish or AutoCast.")

-- End of script
