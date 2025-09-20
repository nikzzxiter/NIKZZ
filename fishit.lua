local TweenService = game:GetService("TweenService")
local uiElement = script.Parent:FindFirstChild("YourUIElement")

-- Menyembunyikan UI dengan animasi
local hideTween = TweenService:Create(uiElement, TweenInfo.new(0.5), {Transparency = 1})
hideTween:Play()

-- Menampilkan UI kembali
local showTween = TweenService:Create(uiElement, TweenInfo.new(0.5), {Transparency = 0})
showTween:Play()
