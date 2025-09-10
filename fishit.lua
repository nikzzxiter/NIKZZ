-- Base UI Rayfield dengan Async
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Membuat window utama
local Window = Rayfield:CreateWindow({
    Name = "UI Responsif dengan Async",
    LoadingTitle = "Memuat UI...",
    LoadingSubtitle = "by Developer",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "RayfieldConfig",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Tab utama
local MainTab = Window:CreateTab("Utama", 4483362458)

-- Fungsi async untuk memuat data berat tanpa lag
local function loadHeavyDataAsync(callback)
    task.spawn(function()
        -- Simulasi proses berat yang memakan waktu
        local fakeData = {}
        for i = 1, 10000 do
            table.insert(fakeData, {id = i, value = "Data " .. i})
            
            -- Yield secara periodik agar UI tetap responsif
            if i % 100 == 0 then
                task.wait()
            end
        end
        
        -- Panggil callback dengan data yang sudah dimuat
        if callback then
            callback(fakeData)
        end
    end)
end

-- Section untuk demo async
local AsyncSection = MainTab:CreateSection("Demo Async")

-- Toggle untuk memuat data secara async
local AsyncToggle = MainTab:CreateToggle({
    Name = "Muat Data Berat (Async)",
    CurrentValue = false,
    Flag = "AsyncToggle",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Memuat Data",
                Content = "Memuat data secara async...",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Memuat data secara async tanpa membuat UI lag
            loadHeavyDataAsync(function(data)
                Rayfield:Notify({
                    Title = "Data Dimuat",
                    Content = "Berhasil memuat " .. #data .. " item tanpa lag!",
                    Duration = 6,
                    Image = 4483362458,
                })
                
                -- Matikan toggle setelah selesai
                AsyncToggle:Set(false)
            end)
        end
    end,
})

-- Button dengan proses async
local AsyncButton = MainTab:CreateButton({
    Name = "Proses Data Async",
    Callback = function()
        -- Menampilkan indikator loading
        Rayfield:Notify({
            Title = "Memproses",
            Content = "Memproses data secara async...",
            Duration = 3,
            Image = 4483362458,
        })
        
        -- Menjalankan proses berat di thread terpisah
        task.spawn(function()
            for i = 1, 10 do
                -- Simulasi pekerjaan berat
                for j = 1, 1000000 do end
                
                -- Update UI secara async
                task.defer(function()
                    Rayfield:Notify({
                        Title = "Progress",
                        Content = "Menyelesaikan langkah " .. i .. "/10",
                        Duration = 1,
                        Image = 4483362458,
                    })
                end)
                
                -- Yield untuk menjaga UI responsif
                task.wait(0.1)
            end
            
            -- Notifikasi selesai
            Rayfield:Notify({
                Title = "Selesai",
                Content = "Proses async selesai tanpa lag!",
                Duration = 6,
                Image = 4483362458,
            })
        end)
    end,
})

-- Input dengan validasi async
local AsyncInput = MainTab:CreateInput({
    Name = "Cari Data (Async)",
    PlaceholderText = "Ketik untuk mencari...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        -- Debounce untuk mencegah pemrosesan berlebihan
        if AsyncInput.Debounce then return end
        AsyncInput.Debounce = true
        
        task.spawn(function()
            -- Simulasi pencarian async
            task.wait(0.5) -- Simulasi waktu pencarian
            
            -- Tampilkan hasil
            Rayfield:Notify({
                Title = "Hasil Pencarian",
                Content = "Menampilkan hasil untuk: " .. Text,
                Duration = 3,
                Image = 4483362458,
            })
            
            AsyncInput.Debounce = false
        end)
    end,
})

-- Dropdown dengan loading async
local AsyncDropdown = MainTab:CreateDropdown({
    Name = "Pilihan Data (Async)",
    Options = {"Klik untuk memuat data..."},
    CurrentOption = "Klik untuk memuat data...",
    Flag = "AsyncDropdown",
    Callback = function(Option)
        if Option == "Klik untuk memuat data..." then
            -- Memuat data secara async saat pertama kali diklik
            Rayfield:Notify({
                Title = "Memuat Opsi",
                Content = "Memuat opsi dropdown...",
                Duration = 2,
                Image = 4483362458,
            })
            
            task.spawn(function()
                -- Simulasi pengambilan data dari sumber eksternal
                task.wait(1)
                
                local newOptions = {}
                for i = 1, 20 do
                    table.insert(newOptions, "Opsi " .. i)
                    
                    -- Yield secara periodik
                    if i % 5 == 0 then
                        task.wait()
                    end
                end
                
                -- Perbarui dropdown dengan opsi baru
                AsyncDropdown:Refresh(newOptions, true)
                
                Rayfield:Notify({
                    Title = "Opsi Dimuat",
                    Content = "Dropdown telah diperbarui dengan " .. #newOptions .. " opsi",
                    Duration = 3,
                    Image = 4483362458,
                })
            end)
        end
    end,
})

-- Slider dengan update async
local AsyncSlider = MainTab:CreateSlider({
    Name = "Nilai (Update Async)",
    Range = {0, 100},
    Increment = 1,
    Suffix = "units",
    CurrentValue = 0,
    Flag = "AsyncSlider",
    Callback = function(Value)
        -- Hindari update UI yang terlalu sering
        if AsyncSlider.Throttle then return end
        AsyncSlider.Throttle = true
        
        task.spawn(function()
            -- Simulasi proses berdasarkan nilai slider
            task.wait(0.1)
            
            -- Lakukan sesuatu dengan nilai
            Rayfield:Notify({
                Title = "Nilai Diubah",
                Content = "Memproses nilai: " .. Value,
                Duration = 1,
                Image = 4483362458,
            })
            
            AsyncSlider.Throttle = false
        end)
    end,
})

-- Section untuk informasi
local InfoSection = MainTab:CreateSection("Informasi")

-- Label informasi
MainTab:CreateLabel("UI ini menggunakan teknik async untuk memastikan:")
MainTab:CreateLabel("- Responsif bahkan saat memproses data berat")
MainTab:CreateLabel("- Tidak lag atau freeze")
MainTab:CreateLabel("- Update UI yang smooth")

-- Tips untuk performa optimal
local TipsParagraph = MainTab:CreateParagraph({
    Title = "Tips Performa",
    Content = "Gunakan task.spawn() untuk proses berat, task.defer() untuk update UI, dan tambahkan debounce/throttle pada event yang sering dipicu."
})

-- Load UI
Rayfield:LoadConfiguration()
