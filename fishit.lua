local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/ohyesyoucan/Rayfield/main/Library.lua"))()

local window = Rayfield:CreateWindow({
    Name = "Fish It UI",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by YourName",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "FishIt_Config"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = false
    },
    KeySystem = false, -- Set to true if you want a key system
    KeySettings = {
        Title = "Key System",
        Subtitle = "Enter your key",
        Note = "You can set your key system if you want",
        FileName = "Rayfield_Key",
        SaveKey = true,
        GrabKeyFromWebsite = false
    }
})

local tab = window:CreateTab("Fitur", 4483362458) -- Tab with name "Fitur" and an icon ID

tab:CreateButton({
    Name = "Fitur 1",
    Callback = function()
        print("Fitur 1 activated!")
        -- Tambahkan fungsi untuk Fitur 1 di sini
    end
})

tab:CreateButton({
    Name = "Fitur 2",
    Callback = function()
        print("Fitur 2 activated!")
        -- Tambahkan fungsi untuk Fitur 2 di sini
    end
})

tab:CreateButton({
    Name = "Fitur 3",
    Callback = function()
        print("Fitur 3 activated!")
        -- Tambahkan fungsi untuk Fitur 3 di sini
    end
})

tab:CreateButton({
    Name = "Fitur 4",
    Callback = function()
        print("Fitur 4 activated!")
        -- Tambahkan fungsi untuk Fitur 4 di sini
    end
})

tab:CreateButton({
    Name = "Fitur 5",
    Callback = function()
        print("Fitur 5 activated!")
        -- Tambahkan fungsi untuk Fitur 5 di sini
    end
})

Rayfield:Load()
