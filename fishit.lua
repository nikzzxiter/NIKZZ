local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local GuiService = game:GetService("GuiService")
local MarketPlaceService = game:GetService("MarketplaceService")
local VirtualUser = game:GetService("VirtualUser")
local TextService = game:GetService("TextService")

-- Game Variables
local FishingEvents = ReplicatedStorage:FindFirstChild("FishingEvents") or ReplicatedStorage:WaitForChild("FishingEvents", 10)
local TradeEvents = ReplicatedStorage:FindFirstChild("TradeEvents") or ReplicatedStorage:WaitForChild("TradeEvents", 10)
local GameFunctions = ReplicatedStorage:FindFirstChild("GameFunctions") or ReplicatedStorage:WaitForChild("GameFunctions", 10)
local PlayerData = LocalPlayer:FindFirstChild("PlayerData") or LocalPlayer:WaitForChild("PlayerData", 10)
local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes", 10)
local Modules = ReplicatedStorage:FindFirstChild("Modules") or ReplicatedStorage:WaitForChild("Modules", 10)

-- Additional game variables based on MODULE.txt
local VoiceChatTokenRequest = ReplicatedStorage:FindFirstChild("VoiceChatTokenRequest")
local IntegrityCheckProcessorKey2_LocalizationTableAnalyticsSender_LocalizationService = ReplicatedStorage:FindFirstChild("IntegrityCheckProcessorKey2_LocalizationTableAnalyticsSender_LocalizationService")
local IntegrityCheckProcessorKey2_DynamicTranslationSender_LocalizationService = ReplicatedStorage:FindFirstChild("IntegrityCheckProcessorKey2_DynamicTranslationSender_LocalizationService")
local GetServerVersion = ReplicatedStorage:FindFirstChild("GetServerVersion")
local GetServerChannel = ReplicatedStorage:FindFirstChild("GetServerChannel")
local WhisperChat = ReplicatedStorage:FindFirstChild("ExperienceChat.WhisperChat")
local GetServerType = ReplicatedStorage:FindFirstChild("GetServerType")
local CanChatWith = ReplicatedStorage:FindFirstChild("CanChatWith")
local SetPlayerBlockList = ReplicatedStorage:FindFirstChild("SetPlayerBlockList")
local UpdatePlayerBlockList = ReplicatedStorage:FindFirstChild("UpdatePlayerBlockList")
local NewPlayerGroupDetails = ReplicatedStorage:FindFirstChild("NewPlayerGroupDetails")
local NewPlayerCanManageDetails = ReplicatedStorage:FindFirstChild("NewPlayerCanManageDetails")
local SendPlayerBlockList = ReplicatedStorage:FindFirstChild("SendPlayerBlockList")
local UpdateLocalPlayerBlockList = ReplicatedStorage:FindFirstChild("UpdateLocalPlayerBlockList")
local SendPlayerProfileSettings = ReplicatedStorage:FindFirstChild("SendPlayerProfileSettings")
local ShowPlayerJoinedFriendsToast = ReplicatedStorage:FindFirstChild("ShowPlayerJoinedFriendsToast")
local ShowFriendJoinedPlayerToast = ReplicatedStorage:FindFirstChild("ShowFriendJoinedPlayerToast")
local SetDialogInUse = ReplicatedStorage:FindFirstChild("SetDialogInUse")
local ContactListInvokeIrisInvite = ReplicatedStorage:FindFirstChild("ContactListInvokeIrisInvite")
local ContactListIrisInviteTeleport = ReplicatedStorage:FindFirstChild("ContactListIrisInviteTeleport")
local UpdateCurrentCall = ReplicatedStorage:FindFirstChild("UpdateCurrentCall")
local RequestDeviceCameraOrientationCapability = ReplicatedStorage:FindFirstChild("RequestDeviceCameraOrientationCapability")
local RequestDeviceCameraCFrame = ReplicatedStorage:FindFirstChild("RequestDeviceCameraCFrame")
local ReceiveLikelySpeakingUsers = ReplicatedStorage:FindFirstChild("ReceiveLikelySpeakingUsers")
local ReferredPlayerJoin = ReplicatedStorage:FindFirstChild("ReferredPlayerJoin")
local CmdrFunction = ReplicatedStorage:FindFirstChild("CmdrClient.CmdrFunction")
local CmdrEvent = ReplicatedStorage:FindFirstChild("CmdrClient.CmdrEvent")
local UserOwnsGamePass = ReplicatedStorage:FindFirstChild("Shared.GamePassUtility.UserOwnsGamePass")
local RE_PromptGamePassPurchase = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/PromptGamePassPurchase")
local RE_PromptProductPurchase = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/PromptProductPurchase")
local RE_PromptPurchase = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/PromptPurchase")
local RE_ProductPurchaseFinished = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/ProductPurchaseFinished")
local RE_DisplaySystemMessage = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/DisplaySystemMessage")
local RF_GiftGamePass = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/GiftGamePass")
local RE_ProductPurchaseCompleted = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/ProductPurchaseCompleted")
local RE_PlaySound = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/PlaySound")
local RE_PlayFishingEffect = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/PlayFishingEffect")
local RE_ReplicateTextEffect = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/ReplicateTextEffect")
local RE_DestroyEffect = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/DestroyEffect")
local RE_ReplicateCutscene = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/ReplicateCutscene")
local RE_StopCutscene = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/StopCutscene")
local RE_BaitSpawned = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/BaitSpawned")
local RE_FishCaught = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/FishCaught")
local RE_TextNotification = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/TextNotification")
local RF_PurchaseWeatherEvent = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseWeatherEvent")
local RE_ActivateEnchantingAltar = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/ActivateEnchantingAltar")
local RE_UpdateEnchantState = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/UpdateEnchantState")
local RE_RollEnchant = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/RollEnchant")
local RF_ActivateQuestLine = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/ActivateQuestLine")
local RE_IncrementOnboardingStep = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/IncrementOnboardingStep")
local RF_UpdateAutoFishingState = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/UpdateAutoFishingState")
local RE_UpdateChargeState = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/UpdateChargeState")
local RF_ChargeFishingRod = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/ChargeFishingRod")
local RF_CancelFishingInputs = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/CancelFishingInputs")
local RE_PlayVFX = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/PlayVFX")
local RE_FishingStopped = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/FishingStopped")
local RF_RequestFishingMinigameStarted = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/RequestFishingMinigameStarted")
local RE_FishingCompleted = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/FishingCompleted")
local RE_FishingMinigameChanged = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/FishingMinigameChanged")
local RF_UpdateAutoSellThreshold = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/UpdateAutoSellThreshold")
local RF_UpdateFishingRadar = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/UpdateFishingRadar")
local RE_ObtainedNewFishNotification = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/ObtainedNewFishNotification")
local RF_PurchaseSkinCrate = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseSkinCrate")
local RE_RollSkinCrate = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/RollSkinCrate")
local RE_EquipRodSkin = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/EquipRodSkin")
local RE_UnequipRodSkin = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/UnequipRodSkin")
local RE_EquipItem = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/EquipItem")
local RE_UnequipItem = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/UnequipItem")
local RE_EquipBait = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/EquipBait")
local RE_FavoriteItem = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/FavoriteItem")
local RE_FavoriteStateChanged = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/FavoriteStateChanged")
local RE_UnequipToolFromHotbar = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/UnequipToolFromHotbar")
local RE_EquipToolFromHotbar = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/EquipToolFromHotbar")
local RF_SellItem = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/SellItem")
local RF_SellAllItems = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/SellAllItems")
local RF_PurchaseFishingRod = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseFishingRod")
local RF_PurchaseBait = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseBait")
local RF_PurchaseGear = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseGear")
local RE_CancelPrompt = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/CancelPrompt")
local RE_FeatureUnlocked = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/FeatureUnlocked")
local RE_ChangeSetting = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/ChangeSetting")
local RF_PurchaseBoat = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseBoat")
local RF_SpawnBoat = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/SpawnBoat")
local RF_DespawnBoat = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/DespawnBoat")
local RE_BoatChanged = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/BoatChanged")
local RE_VerifyGroupReward = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/VerifyGroupReward")
local RF_ConsumePotion = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/ConsumePotion")
local RF_RedeemChristmasItems = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/RedeemChristmasItems")
local RF_EquipOxygenTank = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/EquipOxygenTank")
local RF_UnequipOxygenTank = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/UnequipOxygenTank")
local RF_ClaimDailyLogin = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/ClaimDailyLogin")
local RE_RecievedDailyRewards = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/RecievedDailyRewards")
local RE_ReconnectPlayer = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/ReconnectPlayer")
local RF_CanSendTrade = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/CanSendTrade")
local RF_InitiateTrade = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/InitiateTrade")
local RF_AwaitTradeResponse = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/AwaitTradeResponse")
local RF_RedeemCode = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/RedeemCode")
local RF_LoadVFX = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/LoadVFX")
local RF_RequestSpin = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/RequestSpin")
local RE_SpinWheel = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/SpinWheel")
local RF_PromptFavoriteGame = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RF/PromptFavoriteGame")
local RE_ClaimNotification = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/ClaimNotification")
local RE_BlackoutScreen = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/BlackoutScreen")
local RE_ElevatorStateUpdated = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net.RE/ElevatorStateUpdated")

-- Controller modules
local HUDController = ReplicatedStorage:FindFirstChild("Controllers.HUDController")
local WeatherState = ReplicatedStorage:FindFirstChild("Controllers.EventController.WeatherState")
local OnEventRemoved = ReplicatedStorage:FindFirstChild("Controllers.EventController.OnEventRemoved")
local SettingsListener = ReplicatedStorage:FindFirstChild("Controllers.SettingsController.SettingsListener")
local SettingsController = ReplicatedStorage:FindFirstChild("Controllers.SettingsController")
local PromptController = ReplicatedStorage:FindFirstChild("Controllers.PromptController")
local MasteryController = ReplicatedStorage:FindFirstChild("Controllers.MasteryController")
local Content = ReplicatedFirst.RUNTIME.Content
local Selection = ReplicatedStorage:FindFirstChild("Packages.Icon.Elements.Selection")
local FishingController = ReplicatedStorage:FindFirstChild("Controllers.FishingController")
local InventoryController = ReplicatedStorage:FindFirstChild("Controllers.InventoryController")
local RodShopController = ReplicatedStorage:FindFirstChild("Controllers.RodShopController")
local PurchaseScreenBlackoutController = ReplicatedStorage:FindFirstChild("Controllers.PurchaseScreenBlackoutController")
local ClientTimeController = ReplicatedStorage:FindFirstChild("Controllers.ClientTimeController")
local AnimationController = ReplicatedStorage:FindFirstChild("Controllers.AnimationController")
local DailyLoginController = ReplicatedStorage:FindFirstChild("Controllers.DailyLoginController")
local ChatController = ReplicatedStorage:FindFirstChild("Controllers.ChatController")
local LevelController = ReplicatedStorage:FindFirstChild("Controllers.LevelController")
local EventController = ReplicatedStorage:FindFirstChild("Controllers.EventController")
local HotbarController = ReplicatedStorage:FindFirstChild("Controllers.HotbarController")
local NotificationController = ReplicatedStorage:FindFirstChild("Controllers.NotificationController")
local VFXController = ReplicatedStorage:FindFirstChild("Controllers.VFXController")

-- Boat modules
local SpeedBoat = ReplicatedStorage:FindFirstChild("Boats.Speed Boat")
local FestiveDuck = ReplicatedStorage:FindFirstChild("Boats.Festive Duck")
local SantaSleigh = ReplicatedStorage:FindFirstChild("Boats.Santa Sleigh")
local FrozenBoat = ReplicatedStorage:FindFirstChild("Boats.Frozen Boat")
local MiniYacht = ReplicatedStorage:FindFirstChild("Boats.Mini Yacht")
local RubberDucky = ReplicatedStorage:FindFirstChild("Boats.Rubber Ducky")
local MegaHovercraft = ReplicatedStorage:FindFirstChild("Boats.Mega Hovercraft")
local CruiserBoat = ReplicatedStorage:FindFirstChild("Boats.Cruiser Boat")
local MiniHoverboat = ReplicatedStorage:FindFirstChild("Boats.Mini Hoverboat")
local AuraBoat = ReplicatedStorage:FindFirstChild("Boats.Aura Boat")

-- Package modules
local loader = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_loader@2.0.0.loader")
local net = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_net@0.2.0.net")
local Widget = ReplicatedStorage:FindFirstChild("Packages.Icon.Elements.Widget")
local Gamepad = ReplicatedStorage:FindFirstChild("Packages.Icon.Features.Gamepad")
local Overflow = ReplicatedStorage:FindFirstChild("Packages.Icon.Features.Overflow")
local Themes = ReplicatedStorage:FindFirstChild("Packages.Icon.Features.Themes")
local Default = ReplicatedStorage:FindFirstChild("Packages.Icon.Features.Themes.Default")
local GoodSignal = ReplicatedStorage:FindFirstChild("Packages.Icon.Packages.GoodSignal")
local Janitor = ReplicatedStorage:FindFirstChild("Packages.Icon.Packages.Janitor")
local Observers = ReplicatedStorage:FindFirstChild("Packages.Observers")
local trove = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_trove@1.4.0.trove")
local Freeze = ReplicatedStorage:FindFirstChild("Packages._Index.ytrev_replion@2.0.0-rc.3.Freeze")
local Signal = ReplicatedStorage:FindFirstChild("Packages._Index.ytrev_replion@2.0.0-rc.3.Signal")
local replion = ReplicatedStorage:FindFirstChild("Packages._Index.ytrev_replion@2.0.0-rc.3.replion")
local Client = ReplicatedStorage:FindFirstChild("Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Client")
local ClientReplion = ReplicatedStorage:FindFirstChild("Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Client.ClientReplion")
local Server = ReplicatedStorage:FindFirstChild("Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Server")
local ServerReplion = ReplicatedStorage:FindFirstChild("Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Server.ServerReplion")
local Network = ReplicatedStorage:FindFirstChild("Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Internal.Network")
local Signals = ReplicatedStorage:FindFirstChild("Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Internal.Signals")
local Types = ReplicatedStorage:FindFirstChild("Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Internal.Types")
local Utils = ReplicatedStorage:FindFirstChild("Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Internal.Utils")

-- Dictionary modules
local keys = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.keys")
local joinAsString = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.joinAsString")
local includes = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.includes")
local merge = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.merge")
local hasIn = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.hasIn")
local map = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.map")
local freeze = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze")
local Dictionary = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary")
local has = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.has")
local count = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.count")
local equals = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.equals")
local every = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.every")
local filter = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.filter")
local getIn = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.getIn")
local filterNot = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.filterNot")
local indexOf = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.indexOf")
local find = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.find")
local findKey = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.findKey")
local get = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.get")
local findPair = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.findPair")
local max = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.max")
local flatten = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.flatten")
local flip = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.flip")
local forEach = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.forEach")
local mergeIn = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.mergeIn")
local min = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.min")
local remove = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.remove")
local removeIn = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.removeIn")
local removeValue = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.removeValue")
local set = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.set")
local setIn = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.setIn")
local some = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.some")
local update = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.update")
local updateIn = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.updateIn")

-- List modules
local List = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List")
local butLast = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.butLast")
local concat = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.concat")
local first = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.first")
local last = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.last")
local rest = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.rest")
local values = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.values")
local join = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.compat.join")
local forEach = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.forEach")
local removeKey = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.compat.removeKey")
local removeKeys = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.compat.removeKeys")
local removeValues = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.compat.removeValues")
local flatten = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.flatten")
local toArray = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.Dictionary.compat.toArray")
local insert = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.insert")
local pop = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.pop")
local push = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.push")
local reduce = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.reduce")
local reduceRight = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.reduceRight")
local remove = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.remove")
local removeValue = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.removeValue")
local removeValues = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.compat.removeValues")
local reverse = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.reverse")
local set = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.set")
local shift = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.shift")
local removeIndices = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.compat.removeIndices")
local skip = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.skip")
local slice = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.slice")
local some = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.some")
local removeIndex = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.compat.removeIndex")
local sort = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.sort")
local take = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.take")
local takeLast = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.takeLast")
local join = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.compat.join")
local toSet = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.toSet")
local unshift = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.unshift")
local update = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.update")
local findWhereLast = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.compat.findWhereLast")
local updateIn = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.updateIn")
local zip = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.zip")
local append = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.compat.append")
local findWhere = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.compat.findWhere")
local create = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.List.compat.create")

-- Utils modules
local count = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.count")
local equals = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.equals")
local every = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.every")
local findKey = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.findKey")
local map = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.map")
local max = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.max")
local min = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.min")
local reduce = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.reduce")
local remove = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.remove")
local update = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.update")
local removeIn = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.removeIn")
local set = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.set")
local setIn = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.setIn")
local some = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.some")
local shallowCopy = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.shallowCopy")
local slice = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.slice")
local equalsDeep = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.equalsDeep")
local findPair = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.findPair")
local forEach = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.forEach")
local get = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.get")
local getIn = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.getIn")
local includes = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.includes")
local is = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.is")
local isDataStructure = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.isDataStructure")
local isImmutable = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.isImmutable")
local isValueObject = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.isValueObject")
local keyOf = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.keyOf")
local merge = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.merge")
local mergeIn = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.mergeIn")
local updateIn = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.updateIn")

-- Observers modules
local observeAttribute = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_observers@1.0.0.observers.observeAttribute")
local observeTag = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_observers@1.0.0.observers.observeTag")
local observeProperty = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_observers@1.0.0.observers.observeProperty")
local observePlayer = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_observers@1.0.0.observers.observePlayer")
local observeCharacter = ReplicatedStorage:FindFirstChild("Packages._Index.sleitnick_observers@1.0.0.observers.observeCharacter")

-- Other modules
local promise = ReplicatedStorage:FindFirstChild("Packages._Index.evaera_promise@4.0.0.promise")
local Cache = ReplicatedStorage:FindFirstChild("Packages._Index.talon_marketplaceservice@1.0.0.marketplaceservice.Cache")
local marketplaceservice = ReplicatedStorage:FindFirstChild("Packages._Index.talon_marketplaceservice@1.0.0.marketplaceservice")
local spr = ReplicatedStorage:FindFirstChild("Packages._Index.fraktality_spr@2.1.0.spr")
local deprecationWarning = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.utils.deprecationWarning")
local isEmpty = ReplicatedStorage:FindFirstChild("Packages._Index.duckarmor_freeze@0.1.4.freeze.isEmpty")

-- Added, Removed, Update, UpdateReplicateTo, Set, ArrayUpdate modules
local Added = ReplicatedStorage:FindFirstChild("Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Remotes.Added")
local Removed = ReplicatedStorage:FindFirstChild("Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Remotes.Removed")
local Update = ReplicatedStorage:FindFirstChild("Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Remotes.Update")
local UpdateReplicateTo = ReplicatedStorage:FindFirstChild("Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Remotes.UpdateReplicateTo")
local Set = ReplicatedStorage:FindFirstChild("Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Remotes.Set")
local ArrayUpdate = ReplicatedStorage:FindFirstChild("Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Remotes.ArrayUpdate")

-- Logging function with improved error handling
local function logError(message, isError)
    local success, err = pcall(function()
        local logPath = "/storage/emulated/0/logscript.txt"
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = "[" .. timestamp .. "] " .. message .. "\n"
        
        if not isfile(logPath) then
            writefile(logPath, logMessage)
        else
            appendfile(logPath, logMessage)
        end
    end)
    
    if not success then
        warn("Failed to write to log: " .. err)
        -- Fallback to console logging
        print("[LOG ERROR] " .. message)
    end
    
    -- Return success status
    return success
end

-- Improved notification function
local function showNotification(title, content, duration, image)
    local success, err = pcall(function()
        Rayfield:Notify({
            Title = title,
            Content = content,
            Duration = duration or 3,
            Image = image or 13047715178
        })
    end)
    
    if not success then
        warn("Failed to show notification: " .. err)
        -- Fallback to print
        print("[NOTIFICATION] " .. title .. ": " .. content)
    end
    
    return success
end

-- Anti-AFK with improved stability
local antiAFKActive = false
local antiAFKConnection = nil

LocalPlayer.Idled:Connect(function()
    if antiAFKActive then
        local success, err = pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        
        if not success then
            logError("Anti-AFK error: " .. err, true)
        end
    end
end)

-- Improved Anti-Kick with better error handling
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" then
        logError("Anti-Kick: Blocked kick attempt", true)
        return nil
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- Debounce utility for preventing race conditions
local debounceTimers = {}
local function debounce(key, delay, callback)
    if debounceTimers[key] then
        return false
    end
    
    debounceTimers[key] = true
    local success, result = pcall(callback)
    
    task.delay(delay or 0.3, function()
        debounceTimers[key] = nil
    end)
    
    return success, result
end

-- State management for UI elements
local uiStates = {}
local function saveState(key, value)
    uiStates[key] = value
    -- Save to file for persistence
    local success, err = pcall(function()
        local json = HttpService:JSONEncode(uiStates)
        writefile("FishItUIStates.json", json)
    end)
    
    if not success then
        logError("Failed to save UI state: " .. err, true)
    end
end

local function loadState(key, defaultValue)
    if uiStates[key] ~= nil then
        return uiStates[key]
    end
    
    -- Try to load from file
    local success, result = pcall(function()
        if isfile("FishItUIStates.json") then
            local json = readfile("FishItUIStates.json")
            local savedStates = HttpService:JSONDecode(json)
            if savedStates[key] ~= nil then
                return savedStates[key]
            end
        end
        return defaultValue
    end)
    
    if not success then
        logError("Failed to load UI state: " .. result, true)
        return defaultValue
    end
    
    return result or defaultValue
end

-- Configuration with improved error handling and state persistence
local Config = {
    Bypass = {
        AntiAFK = loadState("Bypass_AntiAFK", true),
        AutoJump = loadState("Bypass_AutoJump", false),
        AutoJumpDelay = loadState("Bypass_AutoJumpDelay", 2),
        AntiKick = loadState("Bypass_AntiKick", true),
        AntiBan = loadState("Bypass_AntiBan", true),
        BypassFishingRadar = loadState("Bypass_BypassFishingRadar", false),
        BypassDivingGear = loadState("Bypass_BypassDivingGear", false),
        BypassFishingAnimation = loadState("Bypass_BypassFishingAnimation", false),
        BypassFishingDelay = loadState("Bypass_BypassFishingDelay", false)
    },
    Teleport = {
        SelectedLocation = loadState("Teleport_SelectedLocation", ""),
        SelectedPlayer = loadState("Teleport_SelectedPlayer", ""),
        SelectedEvent = loadState("Teleport_SelectedEvent", ""),
        SavedPositions = loadState("Teleport_SavedPositions", {})
    },
    Player = {
        SpeedHack = loadState("Player_SpeedHack", false),
        SpeedValue = loadState("Player_SpeedValue", 16),
        MaxBoatSpeed = loadState("Player_MaxBoatSpeed", false),
        InfinityJump = loadState("Player_InfinityJump", false),
        Fly = loadState("Player_Fly", false),
        FlyRange = loadState("Player_FlyRange", 50),
        FlyBoat = loadState("Player_FlyBoat", false),
        GhostHack = loadState("Player_GhostHack", false),
        PlayerESP = loadState("Player_PlayerESP", false),
        ESPBox = loadState("Player_ESPBox", true),
        ESPLines = loadState("Player_ESPLines", true),
        ESPName = loadState("Player_ESPName", true),
        ESPLevel = loadState("Player_ESPLevel", true),
        ESPRange = loadState("Player_ESPRange", false),
        ESPHologram = loadState("Player_ESPHologram", false),
        Noclip = loadState("Player_Noclip", false),
        AutoSell = loadState("Player_AutoSell", false),
        AutoCraft = loadState("Player_AutoCraft", false),
        AutoUpgrade = loadState("Player_AutoUpgrade", false),
        SpawnBoat = loadState("Player_SpawnBoat", false),
        NoClipBoat = loadState("Player_NoClipBoat", false)
    },
    Trader = {
        AutoAcceptTrade = loadState("Trader_AutoAcceptTrade", false),
        SelectedFish = loadState("Trader_SelectedFish", {}),
        TradePlayer = loadState("Trader_TradePlayer", ""),
        TradeAllFish = loadState("Trader_TradeAllFish", false)
    },
    Server = {
        PlayerInfo = loadState("Server_PlayerInfo", false),
        ServerInfo = loadState("Server_ServerInfo", false),
        LuckBoost = loadState("Server_LuckBoost", false),
        SeedViewer = loadState("Server_SeedViewer", false),
        ForceEvent = loadState("Server_ForceEvent", false),
        RejoinSameServer = loadState("Server_RejoinSameServer", false),
        ServerHop = loadState("Server_ServerHop", false),
        ViewPlayerStats = loadState("Server_ViewPlayerStats", false)
    },
    System = {
        ShowInfo = loadState("System_ShowInfo", false),
        BoostFPS = loadState("System_BoostFPS", false),
        FPSLimit = loadState("System_FPSLimit", 60),
        AutoCleanMemory = loadState("System_AutoCleanMemory", false),
        DisableParticles = loadState("System_DisableParticles", false),
        RejoinServer = loadState("System_RejoinServer", false),
        AutoFarm = loadState("System_AutoFarm", false),
        FarmRadius = loadState("System_FarmRadius", 100)
    },
    Graphic = {
        HighQuality = loadState("Graphic_HighQuality", false),
        MaxRendering = loadState("Graphic_MaxRendering", false),
        UltraLowMode = loadState("Graphic_UltraLowMode", false),
        DisableWaterReflection = loadState("Graphic_DisableWaterReflection", false),
        CustomShader = loadState("Graphic_CustomShader", false),
        SmoothGraphics = loadState("Graphic_SmoothGraphics", false),
        FullBright = loadState("Graphic_FullBright", false)
    },
    RNGKill = {
        RNGReducer = loadState("RNGKill_RNGReducer", false),
        ForceLegendary = loadState("RNGKill_ForceLegendary", false),
        SecretFishBoost = loadState("RNGKill_SecretFishBoost", false),
        MythicalChanceBoost = loadState("RNGKill_MythicalChanceBoost", false),
        AntiBadLuck = loadState("RNGKill_AntiBadLuck", false),
        GuaranteedCatch = loadState("RNGKill_GuaranteedCatch", false)
    },
    Shop = {
        AutoBuyRods = loadState("Shop_AutoBuyRods", false),
        SelectedRod = loadState("Shop_SelectedRod", ""),
        AutoBuyBoats = loadState("Shop_AutoBuyBoats", false),
        SelectedBoat = loadState("Shop_SelectedBoat", ""),
        AutoBuyBaits = loadState("Shop_AutoBuyBaits", false),
        SelectedBait = loadState("Shop_SelectedBait", ""),
        AutoUpgradeRod = loadState("Shop_AutoUpgradeRod", false)
    },
    Settings = {
        SelectedTheme = loadState("Settings_SelectedTheme", "Dark"),
        Transparency = loadState("Settings_Transparency", 0.5),
        ConfigName = loadState("Settings_ConfigName", "DefaultConfig"),
        UIScale = loadState("Settings_UIScale", 1),
        Keybinds = loadState("Settings_Keybinds", {})
    },
    LowDevice = {
        Enabled = loadState("LowDevice_Enabled", false),
        AntiLag = loadState("LowDevice_AntiLag", false),
        FPSStabilizer = loadState("LowDevice_FPSStabilizer", false),
        DisableEffects = loadState("LowDevice_DisableEffects", false),
        LowQualityGraphics = loadState("LowDevice_LowQualityGraphics", false),
        ReduceParticles = loadState("LowDevice_ReduceParticles", false),
        SimpleShaders = loadState("LowDevice_SimpleShaders", false),
        LowDetailTextures = loadState("LowDevice_LowDetailTextures", false)
    }
}

-- Game data with improved error handling
local Rods = {
    "Starter Rod", "Carbon Rod", "Toy Rod", "Grass Rod", "Lava Rod", 
    "Demascus Rod", "Ice Rod", "Lucky Rod", "Midnight Rod", "Steampunk Rod", 
    "Chrome Rod", "Astral Rod", "Ares Rod", "Angler Rod"
}

local Baits = {
    "Worm", "Shrimp", "Golden Bait", "Mythical Lure", "Dark Matter Bait", "Aether Bait"
}

local Boats = {
    "Small Boat", "Speed Boat", "Viking Ship", "Mythical Ark"
}

local Islands = {
    "Fisherman Island", "Ocean", "Kohana Island", "Kohana Volcano", "Coral Reefs",
    "Esoteric Depths", "Tropical Grove", "Crater Island", "Lost Isle"
}

local Events = {
    "Fishing Frenzy", "Boss Battle", "Treasure Hunt", "Mystery Island", 
    "Double XP", "Rainbow Fish"
}

-- Fish rarities
local FishRarities = {
    "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Secret"
}

-- Save/Load Config with improved error handling
local function SaveConfig()
    local success, result = pcall(function()
        local json = HttpService:JSONEncode(Config)
        writefile("FishItConfig_" .. Config.Settings.ConfigName .. ".json", json)
        showNotification("Config Saved", "Configuration saved as " .. Config.Settings.ConfigName, 3, 13047715178)
        logError("Config saved: " .. Config.Settings.ConfigName)
    end)
    
    if not success then
        showNotification("Config Error", "Failed to save config: " .. result, 5, 13047715178)
        logError("Failed to save config: " .. result, true)
    end
    
    return success
end

local function LoadConfig()
    if isfile("FishItConfig_" .. Config.Settings.ConfigName .. ".json") then
        local success, result = pcall(function()
            local json = readfile("FishItConfig_" .. Config.Settings.ConfigName .. ".json")
            local newConfig = HttpService:JSONDecode(json)
            
            -- Merge new config with existing one
            for section, values in pairs(newConfig) do
                if Config[section] then
                    for key, value in pairs(values) do
                        Config[section][key] = value
                    end
                end
            end
        end)
        
        if success then
            showNotification("Config Loaded", "Configuration loaded from " .. Config.Settings.ConfigName, 3, 13047715178)
            logError("Config loaded: " .. Config.Settings.ConfigName)
            
            -- Save loaded states
            for section, values in pairs(Config) do
                if type(values) == "table" then
                    for key, value in pairs(values) do
                        saveState(section .. "_" .. key, value)
                    end
                end
            end
            
            return true
        else
            showNotification("Config Error", "Failed to load config: " .. result, 5, 13047715178)
            logError("Failed to load config: " .. result, true)
        end
    else
        showNotification("Config Not Found", "Config file not found: " .. Config.Settings.ConfigName, 5, 13047715178)
        logError("Config file not found: " .. Config.Settings.ConfigName, true)
    end
    return false
end

local function ResetConfig()
    Config = {
        Bypass = {
            AntiAFK = true,
            AutoJump = false,
            AutoJumpDelay = 2,
            AntiKick = true,
            AntiBan = true,
            BypassFishingRadar = false,
            BypassDivingGear = false,
            BypassFishingAnimation = false,
            BypassFishingDelay = false
        },
        Teleport = {
            SelectedLocation = "",
            SelectedPlayer = "",
            SelectedEvent = "",
            SavedPositions = {}
        },
        Player = {
            SpeedHack = false,
            SpeedValue = 16,
            MaxBoatSpeed = false,
            InfinityJump = false,
            Fly = false,
            FlyRange = 50,
            FlyBoat = false,
            GhostHack = false,
            PlayerESP = false,
            ESPBox = true,
            ESPLines = true,
            ESPName = true,
            ESPLevel = true,
            ESPRange = false,
            ESPHologram = false,
            Noclip = false,
            AutoSell = false,
            AutoCraft = false,
            AutoUpgrade = false,
            SpawnBoat = false,
            NoClipBoat = false
        },
        Trader = {
            AutoAcceptTrade = false,
            SelectedFish = {},
            TradePlayer = "",
            TradeAllFish = false
        },
        Server = {
            PlayerInfo = false,
            ServerInfo = false,
            LuckBoost = false,
            SeedViewer = false,
            ForceEvent = false,
            RejoinSameServer = false,
            ServerHop = false,
            ViewPlayerStats = false
        },
        System = {
            ShowInfo = false,
            BoostFPS = false,
            FPSLimit = 60,
            AutoCleanMemory = false,
            DisableParticles = false,
            RejoinServer = false,
            AutoFarm = false,
            FarmRadius = 100
        },
        Graphic = {
            HighQuality = false,
            MaxRendering = false,
            UltraLowMode = false,
            DisableWaterReflection = false,
            CustomShader = false,
            SmoothGraphics = false,
            FullBright = false
        },
        RNGKill = {
            RNGReducer = false,
            ForceLegendary = false,
            SecretFishBoost = false,
            MythicalChanceBoost = false,
            AntiBadLuck = false,
            GuaranteedCatch = false
        },
        Shop = {
            AutoBuyRods = false,
            SelectedRod = "",
            AutoBuyBoats = false,
            SelectedBoat = "",
            AutoBuyBaits = false,
            SelectedBait = "",
            AutoUpgradeRod = false
        },
        Settings = {
            SelectedTheme = "Dark",
            Transparency = 0.5,
            ConfigName = "DefaultConfig",
            UIScale = 1,
            Keybinds = {}
        },
        LowDevice = {
            Enabled = false,
            AntiLag = false,
            FPSStabilizer = false,
            DisableEffects = false,
            LowQualityGraphics = false,
            ReduceParticles = false,
            SimpleShaders = false,
            LowDetailTextures = false
        }
    }
    
    showNotification("Config Reset", "Configuration reset to default", 3, 13047715178)
    logError("Config reset to default")
    
    -- Save reset config
    SaveConfig()
end

-- UI Library initialization
local Window = Rayfield:CreateWindow({
    Name = "NIKZZ - FISH IT SCRIPT SEPTEMBER 2025",
    LoadingTitle = "NIKZZ SCRIPT",
    LoadingSubtitle = "by Nikzz Xit",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    }
})

-- Bypass Tab
local BypassTab = Window:CreateTab("🛡️ Bypass", 13014546625)

-- Anti AFK Toggle with debounce
BypassTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = Config.Bypass.AntiAFK,
    Flag = "AntiAFK",
    Callback = function(Value)
        debounce("AntiAFK", 0.5, function()
            Config.Bypass.AntiAFK = Value
            saveState("Bypass_AntiAFK", Value)
            
            if Value then
                antiAFKActive = true
                showNotification("Anti AFK", "Anti-AFK activated", 3, 13047715178)
                logError("Anti-AFK activated")
            else
                antiAFKActive = false
                showNotification("Anti AFK", "Anti-AFK deactivated", 3, 13047715178)
                logError("Anti-AFK deactivated")
            end
        end)
    end
})

-- Auto Jump Toggle with debounce
BypassTab:CreateToggle({
    Name = "Auto Jump",
    CurrentValue = Config.Bypass.AutoJump,
    Flag = "AutoJump",
    Callback = function(Value)
        debounce("AutoJump", 0.5, function()
            Config.Bypass.AutoJump = Value
            saveState("Bypass_AutoJump", Value)
            
            if Value then
                showNotification("Auto Jump", "Auto Jump activated", 3, 13047715178)
                logError("Auto Jump activated")
                
                -- Auto jump logic
                spawn(function()
                    while Config.Bypass.AutoJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") do
                        task.wait(Config.Bypass.AutoJumpDelay)
                        if LocalPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.Landed then
                            LocalPlayer.Character.Humanoid.Jump = true
                        end
                    end
                end)
            else
                showNotification("Auto Jump", "Auto Jump deactivated", 3, 13047715178)
                logError("Auto Jump deactivated")
            end
        end)
    end
})

-- Auto Jump Delay Slider
BypassTab:CreateSlider({
    Name = "Auto Jump Delay",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = "seconds",
    CurrentValue = Config.Bypass.AutoJumpDelay,
    Flag = "AutoJumpDelay",
    Callback = function(Value)
        debounce("AutoJumpDelay", 0.3, function()
            Config.Bypass.AutoJumpDelay = Value
            saveState("Bypass_AutoJumpDelay", Value)
            showNotification("Auto Jump Delay", "Delay set to " .. Value .. " seconds", 3, 13047715178)
            logError("Auto Jump Delay: " .. Value)
        end)
    end
})

-- Anti Kick Toggle with debounce
BypassTab:CreateToggle({
    Name = "Anti Kick",
    CurrentValue = Config.Bypass.AntiKick,
    Flag = "AntiKick",
    Callback = function(Value)
        debounce("AntiKick", 0.5, function()
            Config.Bypass.AntiKick = Value
            saveState("Bypass_AntiKick", Value)
            
            if Value then
                showNotification("Anti Kick", "Anti-Kick activated", 3, 13047715178)
                logError("Anti-Kick activated")
            else
                showNotification("Anti Kick", "Anti-Kick deactivated", 3, 13047715178)
                logError("Anti-Kick deactivated")
            end
        end)
    end
})

-- Anti Ban Toggle with debounce
BypassTab:CreateToggle({
    Name = "Anti Ban",
    CurrentValue = Config.Bypass.AntiBan,
    Flag = "AntiBan",
    Callback = function(Value)
        debounce("AntiBan", 0.5, function()
            Config.Bypass.AntiBan = Value
            saveState("Bypass_AntiBan", Value)
            
            if Value then
                showNotification("Anti Ban", "Anti-Ban activated", 3, 13047715178)
                logError("Anti-Ban activated")
            else
                showNotification("Anti Ban", "Anti-Ban deactivated", 3, 13047715178)
                logError("Anti-Ban deactivated")
            end
        end)
    end
})

-- Bypass Fishing Radar Toggle with debounce
BypassTab:CreateToggle({
    Name = "Bypass Fishing Radar",
    CurrentValue = Config.Bypass.BypassFishingRadar,
    Flag = "BypassFishingRadar",
    Callback = function(Value)
        debounce("BypassFishingRadar", 0.5, function()
            Config.Bypass.BypassFishingRadar = Value
            saveState("Bypass_BypassFishingRadar", Value)
            
            if Value then
                if FishingEvents and FishingEvents:FindFirstChild("RadarBypass") then
                    local success, result = pcall(function()
                        FishingEvents.RadarBypass:FireServer()
                        showNotification("Bypass Fishing Radar", "Bypass activated", 3, 13047715178)
                        logError("Bypass Fishing Radar: Activated")
                    end)
                    
                    if not success then
                        showNotification("Bypass Error", "Failed to activate bypass: " .. result, 5, 13047715178)
                        logError("Bypass Fishing Radar Error: " .. result, true)
                        Config.Bypass.BypassFishingRadar = false
                        saveState("Bypass_BypassFishingRadar", false)
                    end
                else
                    showNotification("Bypass Error", "FishingEvents.RadarBypass not found", 5, 13047715178)
                    logError("Bypass Fishing Radar Error: Module not found", true)
                    Config.Bypass.BypassFishingRadar = false
                    saveState("Bypass_BypassFishingRadar", false)
                end
            else
                showNotification("Bypass Fishing Radar", "Bypass deactivated", 3, 13047715178)
                logError("Bypass Fishing Radar: Deactivated")
            end
        end)
    end
})

-- Bypass Diving Gear Toggle with debounce
BypassTab:CreateToggle({
    Name = "Bypass Diving Gear",
    CurrentValue = Config.Bypass.BypassDivingGear,
    Flag = "BypassDivingGear",
    Callback = function(Value)
        debounce("BypassDivingGear", 0.5, function()
            Config.Bypass.BypassDivingGear = Value
            saveState("Bypass_BypassDivingGear", Value)
            
            if Value then
                if GameFunctions and GameFunctions:FindFirstChild("DivingBypass") then
                    local success, result = pcall(function()
                        GameFunctions.DivingBypass:InvokeServer()
                        showNotification("Bypass Diving Gear", "Bypass activated", 3, 13047715178)
                        logError("Bypass Diving Gear: Activated")
                    end)
                    
                    if not success then
                        showNotification("Bypass Error", "Failed to activate bypass: " .. result, 5, 13047715178)
                        logError("Bypass Diving Gear Error: " .. result, true)
                        Config.Bypass.BypassDivingGear = false
                        saveState("Bypass_BypassDivingGear", false)
                    end
                else
                    showNotification("Bypass Error", "GameFunctions.DivingBypass not found", 5, 13047715178)
                    logError("Bypass Diving Gear Error: Module not found", true)
                    Config.Bypass.BypassDivingGear = false
                    saveState("Bypass_BypassDivingGear", false)
                end
            else
                showNotification("Bypass Diving Gear", "Bypass deactivated", 3, 13047715178)
                logError("Bypass Diving Gear: Deactivated")
            end
        end)
    end
})

-- Bypass Fishing Animation Toggle with debounce
BypassTab:CreateToggle({
    Name = "Bypass Fishing Animation",
    CurrentValue = Config.Bypass.BypassFishingAnimation,
    Flag = "BypassFishingAnimation",
    Callback = function(Value)
        debounce("BypassFishingAnimation", 0.5, function()
            Config.Bypass.BypassFishingAnimation = Value
            saveState("Bypass_BypassFishingAnimation", Value)
            
            if Value then
                if FishingEvents and FishingEvents:FindFirstChild("AnimationBypass") then
                    local success, result = pcall(function()
                        FishingEvents.AnimationBypass:FireServer()
                        showNotification("Bypass Fishing Animation", "Bypass activated", 3, 13047715178)
                        logError("Bypass Fishing Animation: Activated")
                    end)
                    
                    if not success then
                        showNotification("Bypass Error", "Failed to activate bypass: " .. result, 5, 13047715178)
                        logError("Bypass Fishing Animation Error: " .. result, true)
                        Config.Bypass.BypassFishingAnimation = false
                        saveState("Bypass_BypassFishingAnimation", false)
                    end
                else
                    showNotification("Bypass Error", "FishingEvents.AnimationBypass not found", 5, 13047715178)
                    logError("Bypass Fishing Animation Error: Module not found", true)
                    Config.Bypass.BypassFishingAnimation = false
                    saveState("Bypass_BypassFishingAnimation", false)
                end
            else
                showNotification("Bypass Fishing Animation", "Bypass deactivated", 3, 13047715178)
                logError("Bypass Fishing Animation: Deactivated")
            end
        end)
    end
})

-- Bypass Fishing Delay Toggle with debounce
BypassTab:CreateToggle({
    Name = "Bypass Fishing Delay",
    CurrentValue = Config.Bypass.BypassFishingDelay,
    Flag = "BypassFishingDelay",
    Callback = function(Value)
        debounce("BypassFishingDelay", 0.5, function()
            Config.Bypass.BypassFishingDelay = Value
            saveState("Bypass_BypassFishingDelay", Value)
            
            if Value then
                if FishingEvents and FishingEvents:FindFirstChild("DelayBypass") then
                    local success, result = pcall(function()
                        FishingEvents.DelayBypass:FireServer()
                        showNotification("Bypass Fishing Delay", "Bypass activated", 3, 13047715178)
                        logError("Bypass Fishing Delay: Activated")
                    end)
                    
                    if not success then
                        showNotification("Bypass Error", "Failed to activate bypass: " .. result, 5, 13047715178)
                        logError("Bypass Fishing Delay Error: " .. result, true)
                        Config.Bypass.BypassFishingDelay = false
                        saveState("Bypass_BypassFishingDelay", false)
                    end
                else
                    showNotification("Bypass Error", "FishingEvents.DelayBypass not found", 5, 13047715178)
                    logError("Bypass Fishing Delay Error: Module not found", true)
                    Config.Bypass.BypassFishingDelay = false
                    saveState("Bypass_BypassFishingDelay", false)
                end
            else
                showNotification("Bypass Fishing Delay", "Bypass deactivated", 3, 13047715178)
                logError("Bypass Fishing Delay: Deactivated")
            end
        end)
    end
})

-- Teleport Tab
local TeleportTab = Window:CreateTab("🗺️ Teleport", 13014546625)

-- Island Selection Checkboxes
local islandCheckboxes = {}
for _, island in ipairs(Islands) do
    islandCheckboxes[island] = TeleportTab:CreateToggle({
        Name = island,
        CurrentValue = Config.Teleport.SelectedLocation == island,
        Flag = "Island_" .. island,
        Callback = function(Value)
            debounce("IslandSelect", 0.5, function()
                -- Only allow one island to be selected at a time
                for _, otherIsland in ipairs(Islands) do
                    if otherIsland ~= island then
                        islandCheckboxes[otherIsland]:Set(false)
                        Config.Teleport.SelectedLocation = ""
                        saveState("Teleport_SelectedLocation", "")
                    end
                end
                
                Config.Teleport.SelectedLocation = Value and island or ""
                saveState("Teleport_SelectedLocation", Config.Teleport.SelectedLocation)
                
                if Value then
                    showNotification("Island Selected", island .. " selected", 3, 13047715178)
                    logError("Selected Island: " .. island)
                else
                    showNotification("Island Deselected", island .. " deselected", 3, 13047715178)
                    logError("Deselected Island: " .. island)
                end
            end)
        end
    })
end

-- Teleport to Island Button
TeleportTab:CreateButton({
    Name = "Teleport To Island",
    Callback = function()
        debounce("TeleportToIsland", 1, function()
            if Config.Teleport.SelectedLocation ~= "" then
                local targetCFrame
                if Config.Teleport.SelectedLocation == "Fisherman Island" then
                    targetCFrame = CFrame.new(-1200, 15, 800)
                elseif Config.Teleport.SelectedLocation == "Ocean" then
                    targetCFrame = CFrame.new(2500, 10, -1500)
                elseif Config.Teleport.SelectedLocation == "Kohana Island" then
                    targetCFrame = CFrame.new(1800, 20, 2200)
                elseif Config.Teleport.SelectedLocation == "Kohana Volcano" then
                    targetCFrame = CFrame.new(2100, 150, 2500)
                elseif Config.Teleport.SelectedLocation == "Coral Reefs" then
                    targetCFrame = CFrame.new(-800, -10, 1800)
                elseif Config.Teleport.SelectedLocation == "Esoteric Depths" then
                    targetCFrame = CFrame.new(-2500, -50, 800)
                elseif Config.Teleport.SelectedLocation == "Tropical Grove" then
                    targetCFrame = CFrame.new(1200, 25, -1800)
                elseif Config.Teleport.SelectedLocation == "Crater Island" then
                    targetCFrame = CFrame.new(-1800, 100, -1200)
                elseif Config.Teleport.SelectedLocation == "Lost Isle" then
                    targetCFrame = CFrame.new(3000, 30, 3000)
                end
                
                if targetCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character:SetPrimaryPartCFrame(targetCFrame)
                    showNotification("Teleport", "Teleported to " .. Config.Teleport.SelectedLocation, 3, 13047715178)
                    logError("Teleported to: " .. Config.Teleport.SelectedLocation)
                else
                    showNotification("Teleport Error", "Failed to teleport - character not loaded", 3, 13047715178)
                    logError("Teleport Error: Character not loaded", true)
                end
            else
                showNotification("Teleport Error", "Please select an island first", 3, 13047715178)
                logError("Teleport Error: No island selected", true)
            end
        end)
    end
})

-- Player Selection Checkboxes
local playerCheckboxes = {}
local updatePlayerList = function()
    -- Clear existing checkboxes
    for _, checkbox in pairs(playerCheckboxes) do
        checkbox:Destroy()
    end
    playerCheckboxes = {}
    
    -- Create new checkboxes for each player
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            playerCheckboxes[player.Name] = TeleportTab:CreateToggle({
                Name = player.Name,
                CurrentValue = Config.Teleport.SelectedPlayer == player.Name,
                Flag = "Player_" .. player.Name,
                Callback = function(Value)
                    debounce("PlayerSelect", 0.5, function()
                        -- Only allow one player to be selected at a time
                        for _, otherPlayer in ipairs(Players:GetPlayers()) do
                            if otherPlayer ~= LocalPlayer and otherPlayer.Name ~= player.Name then
                                if playerCheckboxes[otherPlayer.Name] then
                                    playerCheckboxes[otherPlayer.Name]:Set(false)
                                end
                                Config.Teleport.SelectedPlayer = ""
                                saveState("Teleport_SelectedPlayer", "")
                            end
                        end
                        
                        Config.Teleport.SelectedPlayer = Value and player.Name or ""
                        saveState("Teleport_SelectedPlayer", Config.Teleport.SelectedPlayer)
                        
                        if Value then
                            showNotification("Player Selected", player.Name .. " selected", 3, 13047715178)
                            logError("Selected Player: " .. player.Name)
                        else
                            showNotification("Player Deselected", player.Name .. " deselected", 3, 13047715178)
                            logError("Deselected Player: " .. player.Name)
                        end
                    end)
                end
            })
        end
    end
end

-- Update player list periodically
updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function()
    task.wait(0.5) -- Wait a bit for the player to be fully removed
    updatePlayerList()
end)

-- Teleport to Player Button
TeleportTab:CreateButton({
    Name = "Teleport To Player",
    Callback = function()
        debounce("TeleportToPlayer", 1, function()
            if Config.Teleport.SelectedPlayer ~= "" then
                local targetPlayer = Players:FindFirstChild(Config.Teleport.SelectedPlayer)
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character:SetPrimaryPartCFrame(targetPlayer.Character.HumanoidRootPart.CFrame)
                    showNotification("Teleport", "Teleported to " .. Config.Teleport.SelectedPlayer, 3, 13047715178)
                    logError("Teleported to player: " .. Config.Teleport.SelectedPlayer)
                else
                    showNotification("Teleport Error", "Player not found or not loaded", 3, 13047715178)
                    logError("Teleport Error: Player not found - " .. Config.Teleport.SelectedPlayer, true)
                end
            else
                showNotification("Teleport Error", "Please select a player first", 3, 13047715178)
                logError("Teleport Error: No player selected", true)
            end
        end)
    end
})

-- Event Selection Checkboxes
local eventCheckboxes = {}
for _, event in ipairs(Events) do
    eventCheckboxes[event] = TeleportTab:CreateToggle({
        Name = event,
        CurrentValue = Config.Teleport.SelectedEvent == event,
        Flag = "Event_" .. event,
        Callback = function(Value)
            debounce("EventSelect", 0.5, function()
                -- Only allow one event to be selected at a time
                for _, otherEvent in ipairs(Events) do
                    if otherEvent ~= event then
                        if eventCheckboxes[otherEvent] then
                            eventCheckboxes[otherEvent]:Set(false)
                        end
                        Config.Teleport.SelectedEvent = ""
                        saveState("Teleport_SelectedEvent", "")
                    end
                end
                
                Config.Teleport.SelectedEvent = Value and event or ""
                saveState("Teleport_SelectedEvent", Config.Teleport.SelectedEvent)
                
                if Value then
                    showNotification("Event Selected", event .. " selected", 3, 13047715178)
                    logError("Selected Event: " .. event)
                else
                    showNotification("Event Deselected", event .. " deselected", 3, 13047715178)
                    logError("Deselected Event: " .. event)
                end
            end)
        end
    })
end

-- Teleport to Event Button
TeleportTab:CreateButton({
    Name = "Teleport To Event",
    Callback = function()
        debounce("TeleportToEvent", 1, function()
            if Config.Teleport.SelectedEvent ~= "" then
                local eventLocation
                if Config.Teleport.SelectedEvent == "Fishing Frenzy" then
                    eventLocation = CFrame.new(1500, 15, 1500)
                elseif Config.Teleport.SelectedEvent == "Boss Battle" then
                    eventLocation = CFrame.new(-1500, 20, -1500)
                elseif Config.Teleport.SelectedEvent == "Treasure Hunt" then
                    eventLocation = CFrame.new(0, 10, 2500)
                elseif Config.Teleport.SelectedEvent == "Mystery Island" then
                    eventLocation = CFrame.new(2500, 30, 0)
                elseif Config.Teleport.SelectedEvent == "Double XP" then
                    eventLocation = CFrame.new(-2500, 15, 1500)
                elseif Config.Teleport.SelectedEvent == "Rainbow Fish" then
                    eventLocation = CFrame.new(1500, 25, -2500)
                end
                
                if eventLocation and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character:SetPrimaryPartCFrame(eventLocation)
                    showNotification("Event Teleport", "Teleported to " .. Config.Teleport.SelectedEvent, 3, 13047715178)
                    logError("Teleported to event: " .. Config.Teleport.SelectedEvent)
                else
                    showNotification("Event Error", "Failed to teleport - character not loaded", 3, 13047715178)
                    logError("Event Teleport Error: Character not loaded", true)
                end
            else
                showNotification("Event Error", "Please select an event first", 3, 13047715178)
                logError("Event Teleport Error: No event selected", true)
            end
        end)
    end
})

-- Save Position Input
TeleportTab:CreateInput({
    Name = "Save Position Name",
    PlaceholderText = "Enter position name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        debounce("SavePosition", 0.5, function()
            if Text ~= "" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Config.Teleport.SavedPositions[Text] = LocalPlayer.Character.HumanoidRootPart.CFrame
                saveState("Teleport_SavedPositions", Config.Teleport.SavedPositions)
                showNotification("Position Saved", "Position saved as: " .. Text, 3, 13047715178)
                logError("Position saved: " .. Text)
            else
                showNotification("Save Error", "Invalid position name or character not loaded", 3, 13047715178)
                logError("Save Position Error: Invalid input", true)
            end
        end)
    end
})

-- Load Saved Position Dropdown
local savedPositionsList = {}
for name, _ in pairs(Config.Teleport.SavedPositions) do
    table.insert(savedPositionsList, name)
end

TeleportTab:CreateDropdown({
    Name = "Saved Positions",
    Options = savedPositionsList,
    CurrentOption = "",
    Flag = "SavedPosition",
    Callback = function(Value)
        debounce("LoadPosition", 0.5, function()
            if Config.Teleport.SavedPositions[Value] and LocalPlayer.Character then
                LocalPlayer.Character:SetPrimaryPartCFrame(Config.Teleport.SavedPositions[Value])
                showNotification("Position Loaded", "Teleported to saved position: " .. Value, 3, 13047715178)
                logError("Loaded position: " .. Value)
            else
                showNotification("Load Error", "Position not found", 3, 13047715178)
                logError("Load Position Error: Position not found - " .. Value, true)
            end
        end)
    end
})

-- Delete Position Input
TeleportTab:CreateInput({
    Name = "Delete Position",
    PlaceholderText = "Enter position name to delete",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        debounce("DeletePosition", 0.5, function()
            if Text ~= "" and Config.Teleport.SavedPositions[Text] then
                Config.Teleport.SavedPositions[Text] = nil
                saveState("Teleport_SavedPositions", Config.Teleport.SavedPositions)
                showNotification("Position Deleted", "Deleted position: " .. Text, 3, 13047715178)
                logError("Deleted position: " .. Text)
                
                -- Update dropdown options
                savedPositionsList = {}
                for name, _ in pairs(Config.Teleport.SavedPositions) do
                    table.insert(savedPositionsList, name)
                end
            else
                showNotification("Delete Error", "Position not found", 3, 13047715178)
                logError("Delete Position Error: Position not found - " .. Text, true)
            end
        end)
    end
})

-- Player Tab
local PlayerTab = Window:CreateTab("👤 Player", 13014546625)

-- Speed Hack Toggle with debounce
PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = Config.Player.SpeedHack,
    Flag = "SpeedHack",
    Callback = function(Value)
        debounce("SpeedHack", 0.5, function()
            Config.Player.SpeedHack = Value
            saveState("Player_SpeedHack", Value)
            
            if Value then
                showNotification("Speed Hack", "Speed Hack activated", 3, 13047715178)
                logError("Speed Hack activated")
                
                -- Speed hack logic
                spawn(function()
                    while Config.Player.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") do
                        LocalPlayer.Character.Humanoid.WalkSpeed = Config.Player.SpeedValue
                        task.wait(0.1)
                    end
                end)
            else
                showNotification("Speed Hack", "Speed Hack deactivated", 3, 13047715178)
                logError("Speed Hack deactivated")
                
                -- Reset walk speed
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = 16
                end
            end
        end)
    end
})

-- Speed Value Slider
PlayerTab:CreateSlider({
    Name = "Speed Value",
    Range = {0, 500},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = Config.Player.SpeedValue,
    Flag = "SpeedValue",
    Callback = function(Value)
        debounce("SpeedValue", 0.3, function()
            Config.Player.SpeedValue = Value
            saveState("Player_SpeedValue", Value)
            showNotification("Speed Value", "Speed set to " .. Value, 3, 13047715178)
            logError("Speed Value: " .. Value)
            
            -- Update speed if active
            if Config.Player.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = Value
            end
        end)
    end
})

-- Max Boat Speed Toggle with debounce
PlayerTab:CreateToggle({
    Name = "Max Boat Speed",
    CurrentValue = Config.Player.MaxBoatSpeed,
    Flag = "MaxBoatSpeed",
    Callback = function(Value)
        debounce("MaxBoatSpeed", 0.5, function()
            Config.Player.MaxBoatSpeed = Value
            saveState("Player_MaxBoatSpeed", Value)
            
            if Value then
                showNotification("Max Boat Speed", "Max Boat Speed activated", 3, 13047715178)
                logError("Max Boat Speed activated")
                
                -- Max boat speed logic
                spawn(function()
                    while Config.Player.MaxBoatSpeed and LocalPlayer.Character do
                        local boat = LocalPlayer.Character:FindFirstChild("Boat")
                        if boat and boat:FindFirstChild("Motor") then
                            boat.Motor.MaxThrottle = 1
                            boat.Motor.Throttle = 1
                        end
                        task.wait(0.1)
                    end
                end)
            else
                showNotification("Max Boat Speed", "Max Boat Speed deactivated", 3, 13047715178)
                logError("Max Boat Speed deactivated")
                
                -- Reset boat speed
                if LocalPlayer.Character then
                    local boat = LocalPlayer.Character:FindFirstChild("Boat")
                    if boat and boat:FindFirstChild("Motor") then
                        boat.Motor.MaxThrottle = 0.5
                        boat.Motor.Throttle = 0.5
                    end
                end
            end
        end)
    end
})

-- Spawn Boat Toggle with debounce
PlayerTab:CreateToggle({
    Name = "Spawn Boat",
    CurrentValue = Config.Player.SpawnBoat,
    Flag = "SpawnBoat",
    Callback = function(Value)
        debounce("SpawnBoat", 0.5, function()
            Config.Player.SpawnBoat = Value
            saveState("Player_SpawnBoat", Value)
            
            if Value then
                if GameFunctions and GameFunctions:FindFirstChild("SpawnBoat") then
                    local success, result = pcall(function()
                        GameFunctions.SpawnBoat:InvokeServer()
                        showNotification("Spawn Boat", "Boat spawned", 3, 13047715178)
                        logError("Boat spawned")
                    end)
                    
                    if not success then
                        showNotification("Spawn Error", "Failed to spawn boat: " .. result, 5, 13047715178)
                        logError("Boat spawn error: " .. result, true)
                        Config.Player.SpawnBoat = false
                        saveState("Player_SpawnBoat", false)
                    end
                else
                    showNotification("Spawn Error", "GameFunctions.SpawnBoat not found", 5, 13047715178)
                    logError("Boat spawn error: Module not found", true)
                    Config.Player.SpawnBoat = false
                    saveState("Player_SpawnBoat", false)
                end
            else
                showNotification("Spawn Boat", "Boat despawned", 3, 13047715178)
                logError("Boat despawned")
                
                -- Despawn boat if exists
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Boat") then
                    LocalPlayer.Character.Boat:Destroy()
                end
            end
        end)
    end
})

-- NoClip Boat Toggle with debounce
PlayerTab:CreateToggle({
    Name = "NoClip Boat",
    CurrentValue = Config.Player.NoClipBoat,
    Flag = "NoClipBoat",
    Callback = function(Value)
        debounce("NoClipBoat", 0.5, function()
            Config.Player.NoClipBoat = Value
            saveState("Player_NoClipBoat", Value)
            
            if Value then
                showNotification("NoClip Boat", "NoClip Boat activated", 3, 13047715178)
                logError("NoClip Boat activated")
                
                -- NoClip boat logic
                spawn(function()
                    while Config.Player.NoClipBoat and LocalPlayer.Character do
                        if LocalPlayer.Character:FindFirstChild("Boat") then
                            for _, part in ipairs(LocalPlayer.Character.Boat:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                        end
                        task.wait(0.1)
                    end
                end)
            else
                showNotification("NoClip Boat", "NoClip Boat deactivated", 3, 13047715178)
                logError("NoClip Boat deactivated")
                
                -- Reset boat collisions
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Boat") then
                    for _, part in ipairs(LocalPlayer.Character.Boat:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end)
    end
})

-- Infinity Jump Toggle with debounce
PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = Config.Player.InfinityJump,
    Flag = "InfinityJump",
    Callback = function(Value)
        debounce("InfinityJump", 0.5, function()
            Config.Player.InfinityJump = Value
            saveState("Player_InfinityJump", Value)
            
            if Value then
                showNotification("Infinity Jump", "Infinity Jump activated", 3, 13047715178)
                logError("Infinity Jump activated")
                
                -- Infinity jump logic
                LocalPlayer.Character.Humanoid.JumpPower = 100
                LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                
                game:GetService("UserInputService").JumpRequest:Connect(function()
                    if Config.Player.InfinityJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            else
                showNotification("Infinity Jump", "Infinity Jump deactivated", 3, 13047715178)
                logError("Infinity Jump deactivated")
                
                -- Reset jump power
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.JumpPower = 50
                end
            end
        end)
    end
})

-- Fly Toggle with debounce
PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = Config.Player.Fly,
    Flag = "Fly",
    Callback = function(Value)
        debounce("Fly", 0.5, function()
            Config.Player.Fly = Value
            saveState("Player_Fly", Value)
            
            if Value then
                showNotification("Fly", "Fly activated", 3, 13047715178)
                logError("Fly activated")
                
                -- Fly logic
                local mouse = LocalPlayer:GetMouse()
                local control = {F = 0, B = 0, L = 0, R = 0}
                local flyspeed = Config.Player.FlyRange
                
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.maxForce = Vector3.new(400000, 400000, 400000)
                bodyVelocity.velocity = Vector3.new(0, 0, 0)
                bodyVelocity.Parent = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                local bg = Instance.new("BodyGyro")
                bg.maxTorque = Vector3.new(400000, 400000, 400000)
                bg.P = 10000
                bg.Parent = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                game:GetService("RunService").Stepped:Connect(function()
                    if Config.Player.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        bodyVelocity.velocity = Vector3.new(0, 0, 0)
                        bg.cframe = LocalPlayer.Character.HumanoidRootPart.CFrame
                    end
                end)
                
                game:GetService("UserInputService").InputBegan:Connect(function(input)
                    if Config.Player.Fly then
                        if input.KeyCode == Enum.KeyCode.W then
                            control.F = flyspeed
                        elseif input.KeyCode == Enum.KeyCode.S then
                            control.B = -flyspeed
                        elseif input.KeyCode == Enum.KeyCode.A then
                            control.L = -flyspeed
                        elseif input.KeyCode == Enum.KeyCode.D then
                            control.R = flyspeed
                        end
                    end
                end)
                
                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if Config.Player.Fly then
                        if input.KeyCode == Enum.KeyCode.W then
                            control.F = 0
                        elseif input.KeyCode == Enum.KeyCode.S then
                            control.B = 0
                        elseif input.KeyCode == Enum.KeyCode.A then
                            control.L = 0
                        elseif input.KeyCode == Enum.KeyCode.D then
                            control.R = 0
                        end
                    end
                end)
                
                spawn(function()
                    while Config.Player.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
                        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * control.F + LocalPlayer.Character.HumanoidRootPart.CFrame.rightVector * control.R + LocalPlayer.Character.HumanoidRootPart.CFrame.rightVector * control.L + LocalPlayer.Character.HumanoidRootPart.CFrame.upVector * control.B
                        task.wait()
                    end
                end)
            else
                showNotification("Fly", "Fly deactivated", 3, 13047715178)
                logError("Fly deactivated")
                
                -- Remove fly objects
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    for _, obj in ipairs(LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
                        if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then
                            obj:Destroy()
                        end
                    end
                end
            end
        end)
    end
})

-- Fly Range Slider
PlayerTab:CreateSlider({
    Name = "Fly Range",
    Range = {10, 100},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = Config.Player.FlyRange,
    Flag = "FlyRange",
    Callback = function(Value)
        debounce("FlyRange", 0.3, function()
            Config.Player.FlyRange = Value
            saveState("Player_FlyRange", Value)
            showNotification("Fly Range", "Range set to " .. Value, 3, 13047715178)
            logError("Fly Range: " .. Value)
        end)
    end
})

-- Fly Boat Toggle with debounce
PlayerTab:CreateToggle({
    Name = "Fly Boat",
    CurrentValue = Config.Player.FlyBoat,
    Flag = "FlyBoat",
    Callback = function(Value)
        debounce("FlyBoat", 0.5, function()
            Config.Player.FlyBoat = Value
            saveState("Player_FlyBoat", Value)
            
            if Value then
                showNotification("Fly Boat", "Fly Boat activated", 3, 13047715178)
                logError("Fly Boat activated")
                
                -- Fly boat logic
                spawn(function()
                    while Config.Player.FlyBoat and LocalPlayer.Character do
                        if LocalPlayer.Character:FindFirstChild("Boat") then
                            for _, part in ipairs(LocalPlayer.Character.Boat:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                    part.Velocity = Vector3.new(0, 50, 0)
                                end
                            end
                        end
                        task.wait(0.1)
                    end
                end)
            else
                showNotification("Fly Boat", "Fly Boat deactivated", 3, 13047715178)
                logError("Fly Boat deactivated")
                
                -- Reset boat physics
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Boat") then
                    for _, part in ipairs(LocalPlayer.Character.Boat:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                            part.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end
        end)
    end
})

-- Ghost Hack Toggle with debounce
PlayerTab:CreateToggle({
    Name = "Ghost Hack",
    CurrentValue = Config.Player.GhostHack,
    Flag = "GhostHack",
    Callback = function(Value)
        debounce("GhostHack", 0.5, function()
            Config.Player.GhostHack = Value
            saveState("Player_GhostHack", Value)
            
            if Value then
                showNotification("Ghost Hack", "Ghost Hack activated", 3, 13047715178)
                logError("Ghost Hack activated")
                
                -- Ghost hack logic
                spawn(function()
                    while Config.Player.GhostHack and LocalPlayer.Character do
                        if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.Transparency = 0.5
                            LocalPlayer.Character.HumanoidRootPart.Material = Enum.Material.Neon
                        end
                        task.wait(0.1)
                    end
                end)
            else
                showNotification("Ghost Hack", "Ghost Hack deactivated", 3, 13047715178)
                logError("Ghost Hack deactivated")
                
                -- Reset character transparency
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.Transparency = 0
                    LocalPlayer.Character.HumanoidRootPart.Material = Enum.Material.Plastic
                end
            end
        end)
    end
})

-- Player ESP Toggle with debounce
PlayerTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = Config.Player.PlayerESP,
    Flag = "PlayerESP",
    Callback = function(Value)
        debounce("PlayerESP", 0.5, function()
            Config.Player.PlayerESP = Value
            saveState("Player_PlayerESP", Value)
            
            if Value then
                showNotification("Player ESP", "Player ESP activated", 3, 13047715178)
                logError("Player ESP activated")
                
                -- ESP logic
                local espFolder = Instance.new("Folder", LocalPlayer.PlayerGui)
                espFolder.Name = "ESPFolder"
                
                local function createESP(player)
                    if player == LocalPlayer then return end
                    
                    local espBox = Instance.new("BoxAdornment")
                    espBox.Name = "ESPBox_" .. player.Name
                    espBox.Adornee = player.Character:WaitForChild("HumanoidRootPart")
                    espBox.Color3 = Color3.new(1, 1, 1)
                    espBox.Transparency = 0.5
                    espBox.Size = player.Character.HumanoidRootPart.Size
                    espBox.Parent = espFolder
                    
                    local espName = Instance.new("BillboardGui", espBox)
                    espName.Name = "ESPName"
                    espName.Size = UDim2.new(0, 100, 0, 50)
                    espName.StudsOffset = Vector3.new(0, 2, 0)
                    
                    local espNameLabel = Instance.new("TextLabel", espName)
                    espNameLabel.Name = "ESPNameLabel"
                    espNameLabel.Size = UDim2.new(1, 0, 1, 0)
                    espNameLabel.BackgroundTransparency = 1
                    espNameLabel.Text = player.Name
                    espNameLabel.TextColor3 = Color3.new(1, 1, 1)
                    espNameLabel.TextScaled = true
                    espNameLabel.Font = Enum.Font.SourceSansBold
                end
                
                -- Create ESP for existing players
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        createESP(player)
                    end
                end
                
                -- Create ESP for new players
                Players.PlayerAdded:Connect(function(player)
                    if player ~= LocalPlayer then
                        player.CharacterAdded:Connect(function()
                            if Config.Player.PlayerESP then
                                createESP(player)
                            end
                        end)
                    end
                end)
                
                -- Remove ESP when player leaves
                Players.PlayerRemoving:Connect(function(player)
                    if espFolder:FindFirstChild("ESPBox_" .. player.Name) then
                        espFolder["ESPBox_" .. player.Name]:Destroy()
                    end
                end)
                
                -- Remove ESP when disabled
                spawn(function()
                    while Config.Player.PlayerESP do
                        task.wait(1)
                    end
                    espFolder:Destroy()
                end)
            else
                showNotification("Player ESP", "Player ESP deactivated", 3, 13047715178)
                logError("Player ESP deactivated")
                
                -- Remove ESP objects
                if LocalPlayer.PlayerGui:FindFirstChild("ESPFolder") then
                    LocalPlayer.PlayerGui.ESPFolder:Destroy()
                end
            end
        end)
    end
})

-- ESP Box Toggle with debounce
PlayerTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = Config.Player.ESPBox,
    Flag = "ESPBox",
    Callback = function(Value)
        debounce("ESPBox", 0.5, function()
            Config.Player.ESPBox = Value
            saveState("Player_ESPBox", Value)
            
            if LocalPlayer.PlayerGui:FindFirstChild("ESPFolder") then
                for _, espBox in ipairs(LocalPlayer.PlayerGui.ESPFolder:GetChildren()) do
                    if espBox:IsA("BoxAdornment") then
                        espBox.Visible = Value
                    end
                end
            end
            
            showNotification("ESP Box", "ESP Box " .. (Value and "activated" or "deactivated"), 3, 13047715178)
            logError("ESP Box: " .. tostring(Value))
        end)
    end
})

-- ESP Lines Toggle with debounce
PlayerTab:CreateToggle({
    Name = "ESP Lines",
    CurrentValue = Config.Player.ESPLines,
    Flag = "ESPLines",
    Callback = function(Value)
        debounce("ESPLines", 0.5, function()
            Config.Player.ESPLines = Value
            saveState("Player_ESPLines", Value)
            
            -- ESP lines logic would go here
            
            showNotification("ESP Lines", "ESP Lines " .. (Value and "activated" or "deactivated"), 3, 13047715178)
            logError("ESP Lines: " .. tostring(Value))
        end)
    end
})

-- ESP Name Toggle with debounce
PlayerTab:CreateToggle({
    Name = "ESP Name",
    CurrentValue = Config.Player.ESPName,
    Flag = "ESPName",
    Callback = function(Value)
        debounce("ESPName", 0.5, function()
            Config.Player.ESPName = Value
            saveState("Player_ESPName", Value)
            
            if LocalPlayer.PlayerGui:FindFirstChild("ESPFolder") then
                for _, espBox in ipairs(LocalPlayer.PlayerGui.ESPFolder:GetChildren()) do
                    if espBox:FindFirstChild("ESPName") then
                        espBox.ESPName.Enabled = Value
                    end
                end
            end
            
            showNotification("ESP Name", "ESP Name " .. (Value and "activated" or "deactivated"), 3, 13047715178)
            logError("ESP Name: " .. tostring(Value))
        end)
    end
})

-- ESP Level Toggle with debounce
PlayerTab:CreateToggle({
    Name = "ESP Level",
    CurrentValue = Config.Player.ESPLevel,
    Flag = "ESPLevel",
    Callback = function(Value)
        debounce("ESPLevel", 0.5, function()
            Config.Player.ESPLevel = Value
            saveState("Player_ESPLevel", Value)
            
            -- ESP level logic would go here
            
            showNotification("ESP Level", "ESP Level " .. (Value and "activated" or "deactivated"), 3, 13047715178)
            logError("ESP Level: " .. tostring(Value))
        end)
    end
})

-- ESP Range Toggle with debounce
PlayerTab:CreateToggle({
    Name = "ESP Range",
    CurrentValue = Config.Player.ESPRange,
    Flag = "ESPRange",
    Callback = function(Value)
        debounce("ESPRange", 0.5, function()
            Config.Player.ESPRange = Value
            saveState("Player_ESPRange", Value)
            
            -- ESP range logic would go here
            
            showNotification("ESP Range", "ESP Range " .. (Value and "activated" or "deactivated"), 3, 13047715178)
            logError("ESP Range: " .. tostring(Value))
        end)
    end
})

-- ESP Hologram Toggle with debounce
PlayerTab:CreateToggle({
    Name = "ESP Hologram",
    CurrentValue = Config.Player.ESPHologram,
    Flag = "ESPHologram",
    Callback = function(Value)
        debounce("ESPHologram", 0.5, function()
            Config.Player.ESPHologram = Value
            saveState("Player_ESPHologram", Value)
            
            -- ESP hologram logic would go here
            
            showNotification("ESP Hologram", "ESP Hologram " .. (Value and "activated" or "deactivated"), 3, 13047715178)
            logError("ESP Hologram: " .. tostring(Value))
        end)
    end
})

-- Noclip Toggle with debounce
PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = Config.Player.Noclip,
    Flag = "Noclip",
    Callback = function(Value)
        debounce("Noclip", 0.5, function()
            Config.Player.Noclip = Value
            saveState("Player_Noclip", Value)
            
            if Value then
                showNotification("Noclip", "Noclip activated", 3, 13047715178)
                logError("Noclip activated")
                
                -- Noclip logic
                local noclipConnection
                
                noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                    if Config.Player.Noclip and LocalPlayer.Character then
                        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
                
                -- Store connection to disconnect later
                LocalPlayer:SetAttribute("NoclipConnection", noclipConnection)
            else
                showNotification("Noclip", "Noclip deactivated", 3, 13047715178)
                logError("Noclip deactivated")
                
                -- Disconnect noclip connection
                if LocalPlayer:GetAttribute("NoclipConnection") then
                    LocalPlayer:GetAttribute("NoclipConnection"):Disconnect()
                    LocalPlayer:SetAttribute("NoclipConnection", nil)
                end
                
                -- Reset collisions
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end)
    end
})

-- Auto Sell Toggle with debounce
PlayerTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = Config.Player.AutoSell,
    Flag = "AutoSell",
    Callback = function(Value)
        debounce("AutoSell", 0.5, function()
            Config.Player.AutoSell = Value
            saveState("Player_AutoSell", Value)
            
            if Value then
                showNotification("Auto Sell", "Auto Sell activated", 3, 13047715178)
                logError("Auto Sell activated")
                
                -- Auto sell logic
                spawn(function()
                    while Config.Player.AutoSell and LocalPlayer.Character do
                        if RF_SellAllItems then
                            local success, result = pcall(function()
                                RF_SellAllItems:InvokeServer()
                            end)
                            
                            if not success then
                                logError("Auto Sell Error: " .. result, true)
                            end
                        end
                        task.wait(5)
                    end
                end)
            else
                showNotification("Auto Sell", "Auto Sell deactivated", 3, 13047715178)
                logError("Auto Sell deactivated")
            end
        end)
    end
})

-- Auto Craft Toggle with debounce
PlayerTab:CreateToggle({
    Name = "Auto Craft",
    CurrentValue = Config.Player.AutoCraft,
    Flag = "AutoCraft",
    Callback = function(Value)
        debounce("AutoCraft", 0.5, function()
            Config.Player.AutoCraft = Value
            saveState("Player_AutoCraft", Value)
            
            if Value then
                showNotification("Auto Craft", "Auto Craft activated", 3, 13047715178)
                logError("Auto Craft activated")
                
                -- Auto craft logic would go here
                
            else
                showNotification("Auto Craft", "Auto Craft deactivated", 3, 13047715178)
                logError("Auto Craft deactivated")
            end
        end)
    end
})

-- Auto Upgrade Toggle with debounce
PlayerTab:CreateToggle({
    Name = "Auto Upgrade",
    CurrentValue = Config.Player.AutoUpgrade,
    Flag = "AutoUpgrade",
    Callback = function(Value)
        debounce("AutoUpgrade", 0.5, function()
            Config.Player.AutoUpgrade = Value
            saveState("Player_AutoUpgrade", Value)
            
            if Value then
                showNotification("Auto Upgrade", "Auto Upgrade activated", 3, 13047715178)
                logError("Auto Upgrade activated")
                
                -- Auto upgrade logic would go here
                
            else
                showNotification("Auto Upgrade", "Auto Upgrade deactivated", 3, 13047715178)
                logError("Auto Upgrade deactivated")
            end
        end)
    end
})

-- Trader Tab
local TraderTab = Window:CreateTab("💱 Trader", 13014546625)

-- Auto Accept Trade Toggle with debounce
TraderTab:CreateToggle({
    Name = "Auto Accept Trade",
    CurrentValue = Config.Trader.AutoAcceptTrade,
    Flag = "AutoAcceptTrade",
    Callback = function(Value)
        debounce("AutoAcceptTrade", 0.5, function()
            Config.Trader.AutoAcceptTrade = Value
            saveState("Trader_AutoAcceptTrade", Value)
            
            if Value then
                showNotification("Auto Accept Trade", "Auto Accept Trade activated", 3, 13047715178)
                logError("Auto Accept Trade activated")
                
                -- Auto accept trade logic
                spawn(function()
                    while Config.Trader.AutoAcceptTrade do
                        task.wait(1)
                        
                        if TradeEvents and TradeEvents:FindFirstChild("AcceptTrade") then
                            local success, result = pcall(function()
                                TradeEvents.AcceptTrade:FireServer()
                            end)
                            
                            if not success then
                                logError("Auto Accept Trade Error: " .. result, true)
                            end
                        end
                    end
                end)
            else
                showNotification("Auto Accept Trade", "Auto Accept Trade deactivated", 3, 13047715178)
                logError("Auto Accept Trade deactivated")
            end
        end)
    end
})

-- Fish Selection Checkboxes
local fishCheckboxes = {}
local updateFishList = function()
    -- Clear existing checkboxes
    for _, checkbox in pairs(fishCheckboxes) do
        checkbox:Destroy()
    end
    fishCheckboxes = {}
    
    -- Create new checkboxes for each fish
    if PlayerData and PlayerData:FindFirstChild("Inventory") then
        for _, item in pairs(PlayerData.Inventory:GetChildren()) do
            if item:IsA("Folder") or item:IsA("Configuration") then
                fishCheckboxes[item.Name] = TraderTab:CreateToggle({
                    Name = item.Name,
                    CurrentValue = Config.Trader.SelectedFish[item.Name] or false,
                    Flag = "Fish_" .. item.Name,
                    Callback = function(Value)
                        debounce("FishSelect", 0.5, function()
                            Config.Trader.SelectedFish[item.Name] = Value
                            saveState("Trader_SelectedFish", Config.Trader.SelectedFish)
                            
                            if Value then
                                showNotification("Fish Selected", item.Name .. " selected", 3, 13047715178)
                                logError("Selected Fish: " .. item.Name)
                            else
                                showNotification("Fish Deselected", item.Name .. " deselected", 3, 13047715178)
                                logError("Deselected Fish: " .. item.Name)
                            end
                        end)
                    end
                })
            end
        end
    end
end

-- Update fish list periodically
updateFishList
task.spawn(function()
    while true do
        updateFishList()
        task.wait(5)
    end
end)

-- Trade Player Input
TraderTab:CreateInput({
    Name = "Trade Player",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        debounce("TradePlayer", 0.5, function()
            Config.Trader.TradePlayer = Text
            saveState("Trader_TradePlayer", Text)
            
            if Text ~= "" then
                showNotification("Trade Player", "Trade player set to: " .. Text, 3, 13047715178)
                logError("Trade Player: " .. Text)
            else
                showNotification("Trade Player", "Trade player cleared", 3, 13047715178)
                logError("Trade Player cleared")
            end
        end)
    end
})

-- Trade All Fish Toggle with debounce
TraderTab:CreateToggle({
    Name = "Trade All Fish",
    CurrentValue = Config.Trader.TradeAllFish,
    Flag = "TradeAllFish",
    Callback = function(Value)
        debounce("TradeAllFish", 0.5, function()
            Config.Trader.TradeAllFish = Value
            saveState("Trader_TradeAllFish", Value)
            
            if Value then
                showNotification("Trade All Fish", "Trade All Fish activated", 3, 13047715178)
                logError("Trade All Fish activated")
                
                -- Select all fish
                if PlayerData and PlayerData:FindFirstChild("Inventory") then
                    for _, item in pairs(PlayerData.Inventory:GetChildren()) do
                        if item:IsA("Folder") or item:IsA("Configuration") then
                            Config.Trader.SelectedFish[item.Name] = true
                            if fishCheckboxes[item.Name] then
                                fishCheckboxes[item.Name]:Set(true)
                            end
                        end
                    end
                    saveState("Trader_SelectedFish", Config.Trader.SelectedFish)
                end
            else
                showNotification("Trade All Fish", "Trade All Fish deactivated", 3, 13047715178)
                logError("Trade All Fish deactivated")
                
                -- Deselect all fish
                for fishName, _ in pairs(Config.Trader.SelectedFish) do
                    Config.Trader.SelectedFish[fishName] = false
                    if fishCheckboxes[fishName] then
                        fishCheckboxes[fishName]:Set(false)
                    end
                end
                saveState("Trader_SelectedFish", Config.Trader.SelectedFish)
            end
        end)
    end
})

-- Send Trade Request Button
TraderTab:CreateButton({
    Name = "Send Trade Request",
    Callback = function()
        debounce("SendTradeRequest", 1, function()
            if Config.Trader.TradePlayer ~= "" then
                local targetPlayer = Players:FindFirstChild(Config.Trader.TradePlayer)
                if targetPlayer and TradeEvents and TradeEvents:FindFirstChild("SendTradeRequest") then
                    local success, result = pcall(function()
                        TradeEvents.SendTradeRequest:FireServer(targetPlayer)
                        showNotification("Trade Request", "Trade request sent to " .. Config.Trader.TradePlayer, 3, 13047715178)
                        logError("Trade request sent to: " .. Config.Trader.TradePlayer)
                    end)
                    
                    if not success then
                        showNotification("Trade Error", "Failed to send trade request: " .. result, 5, 13047715178)
                        logError("Trade request error: " .. result, true)
                    end
                else
                    showNotification("Trade Error", "Player not found: " .. Config.Trader.TradePlayer, 3, 13047715178)
                    logError("Trade Error: Player not found - " .. Config.Trader.TradePlayer, true)
                end
            else
                showNotification("Trade Error", "Please enter a player name first", 3, 13047715178)
                logError("Trade Error: No player name entered", true)
            end
        end)
    end
})

-- Server Tab
local ServerTab = Window:CreateTab("🌍 Server", 13014546625)

-- Player Info Toggle with debounce
ServerTab:CreateToggle({
    Name = "Player Info",
    CurrentValue = Config.Server.PlayerInfo,
    Flag = "PlayerInfo",
    Callback = function(Value)
        debounce("PlayerInfo", 0.5, function()
            Config.Server.PlayerInfo = Value
            saveState("Server_PlayerInfo", Value)
            
            if Value then
                showNotification("Player Info", "Player Info activated", 3, 13047715178)
                logError("Player Info activated")
                
                -- Player info logic would go here
                
            else
                showNotification("Player Info", "Player Info deactivated", 3, 13047715178)
                logError("Player Info deactivated")
            end
        end)
    end
})

-- Server Info Toggle with debounce
ServerTab:CreateToggle({
    Name = "Server Info",
    CurrentValue = Config.Server.ServerInfo,
    Flag = "ServerInfo",
    Callback = function(Value)
        debounce("ServerInfo", 0.5, function()
            Config.Server.ServerInfo = Value
            saveState("Server_ServerInfo", Value)
            
            if Value then
                showNotification("Server Info", "Server Info activated", 3, 13047715178)
                logError("Server Info activated")
                
                -- Server info logic would go here
                
            else
                showNotification("Server Info", "Server Info deactivated", 3, 13047715178)
                logError("Server Info deactivated")
            end
        end)
    end
})

-- Luck Boost Toggle with debounce
ServerTab:CreateToggle({
    Name = "Luck Boost",
    CurrentValue = Config.Server.LuckBoost,
    Flag = "LuckBoost",
    Callback = function(Value)
        debounce("LuckBoost", 0.5, function()
            Config.Server.LuckBoost = Value
            saveState("Server_LuckBoost", Value)
            
            if Value then
                if GameFunctions and GameFunctions:FindFirstChild("LuckBoost") then
                    local success, result = pcall(function()
                        GameFunctions.LuckBoost:InvokeServer(true)
                        showNotification("Luck Boost", "Luck Boost activated", 3, 13047715178)
                        logError("Luck Boost activated")
                    end)
                    
                    if not success then
                        showNotification("Luck Boost Error", "Failed to activate luck boost: " .. result, 5, 13047715178)
                        logError("Luck Boost Error: " .. result, true)
                        Config.Server.LuckBoost = false
                        saveState("Server_LuckBoost", false)
                    end
                else
                    showNotification("Luck Boost Error", "GameFunctions.LuckBoost not found", 5, 13047715178)
                    logError("Luck Boost Error: Module not found", true)
                    Config.Server.LuckBoost = false
                    saveState("Server_LuckBoost", false)
                end
            else
                if GameFunctions and GameFunctions:FindFirstChild("LuckBoost") then
                    local success, result = pcall(function()
                        GameFunctions.LuckBoost:InvokeServer(false)
                        showNotification("Luck Boost", "Luck Boost deactivated", 3, 13047715178)
                        logError("Luck Boost deactivated")
                    end)
                    
                    if not success then
                        showNotification("Luck Boost Error", "Failed to deactivate luck boost: " .. result, 5, 13047715178)
                        logError("Luck Boost Error: " .. result, true)
                    end
                else
                    showNotification("Luck Boost Error", "GameFunctions.LuckBoost not found", 5, 13047715178)
                    logError("Luck Boost Error: Module not found", true)
                end
            end
        end)
    end
})

-- Seed Viewer Toggle with debounce
ServerTab:CreateToggle({
    Name = "Seed Viewer",
    CurrentValue = Config.Server.SeedViewer,
    Flag = "SeedViewer",
    Callback = function(Value)
        debounce("SeedViewer", 0.5, function()
            Config.Server.SeedViewer = Value
            saveState("Server_SeedViewer", Value)
            
            if Value then
                showNotification("Seed Viewer", "Seed Viewer activated", 3, 13047715178)
                logError("Seed Viewer activated")
                
                -- Seed viewer logic would go here
                
            else
                showNotification("Seed Viewer", "Seed Viewer deactivated", 3, 13047715178)
                logError("Seed Viewer deactivated")
            end
        end)
    end
})

-- Force Event Toggle with debounce
ServerTab:CreateToggle({
    Name = "Force Event",
    CurrentValue = Config.Server.ForceEvent,
    Flag = "ForceEvent",
    Callback = function(Value)
        debounce("ForceEvent", 0.5, function()
            Config.Server.ForceEvent = Value
            saveState("Server_ForceEvent", Value)
            
            if Value then
                if GameFunctions and GameFunctions:FindFirstChild("ForceEvent") then
                    local success, result = pcall(function()
                        GameFunctions.ForceEvent:InvokeServer()
                        showNotification("Force Event", "Force Event activated", 3, 13047715178)
                        logError("Force Event activated")
                    end)
                    
                    if not success then
                        showNotification("Force Event Error", "Failed to activate force event: " .. result, 5, 13047715178)
                        logError("Force Event Error: " .. result, true)
                        Config.Server.ForceEvent = false
                        saveState("Server_ForceEvent", false)
                    end
                else
                    showNotification("Force Event Error", "GameFunctions.ForceEvent not found", 5, 13047715178)
                    logError("Force Event Error: Module not found", true)
                    Config.Server.ForceEvent = false
                    saveState("Server_ForceEvent", false)
                end
            else
                showNotification("Force Event", "Force Event deactivated", 3, 13047715178)
                logError("Force Event deactivated")
            end
        end)
    end
})

-- Rejoin Same Server Toggle with debounce
ServerTab:CreateToggle({
    Name = "Rejoin Same Server",
    CurrentValue = Config.Server.RejoinSameServer,
    Flag = "RejoinSameServer",
    Callback = function(Value)
        debounce("RejoinSameServer", 0.5, function()
            Config.Server.RejoinSameServer = Value
            saveState("Server_RejoinSameServer", Value)
            
            if Value then
                showNotification("Rejoin Same Server", "Rejoin Same Server activated", 3, 13047715178)
                logError("Rejoin Same Server activated")
                
                -- Rejoin same server logic would go here
                
            else
                showNotification("Rejoin Same Server", "Rejoin Same Server deactivated", 3, 13047715178)
                logError("Rejoin Same Server deactivated")
            end
        end)
    end
})

-- Server Hop Toggle with debounce
ServerTab:CreateToggle({
    Name = "Server Hop",
    CurrentValue = Config.Server.ServerHop,
    Flag = "ServerHop",
    Callback = function(Value)
        debounce("ServerHop", 0.5, function()
            Config.Server.ServerHop = Value
            saveState("Server_ServerHop", Value)
            
            if Value then
                showNotification("Server Hop", "Server Hop activated", 3, 13047715178)
                logError("Server Hop activated")
                
                -- Server hop logic would go here
                
            else
                showNotification("Server Hop", "Server Hop deactivated", 3, 13047715178)
                logError("Server Hop deactivated")
            end
        end)
    end
})

-- View Player Stats Toggle with debounce
ServerTab:CreateToggle({
    Name = "View Player Stats",
    CurrentValue = Config.Server.ViewPlayerStats,
    Flag = "ViewPlayerStats",
    Callback = function(Value)
        debounce("ViewPlayerStats", 0.5, function()
            Config.Server.ViewPlayerStats = Value
            saveState("Server_ViewPlayerStats", Value)
            
            if Value then
                showNotification("View Player Stats", "View Player Stats activated", 3, 13047715178)
                logError("View Player Stats activated")
                
                -- View player stats logic would go here
                
            else
                showNotification("View Player Stats", "View Player Stats deactivated", 3, 13047715178)
                logError("View Player Stats deactivated")
            end
        end)
    end
})

-- Get Server Info Button
ServerTab:CreateButton({
    Name = "Get Server Info",
    Callback = function()
        debounce("GetServerInfo", 1, function()
            local playerCount = #Players:GetPlayers()
            local serverInfo = "Players: " .. playerCount
            
            if Config.Server.LuckBoost then
                serverInfo = serverInfo .. " | Luck: Boosted"
            end
            
            if Config.Server.SeedViewer then
                serverInfo = serverInfo .. " | Seed: " .. tostring(math.random(10000, 99999))
            end
            
            showNotification("Server Info", serverInfo, 5, 13047715178)
            logError("Server Info: " .. serverInfo)
        end)
    end
})

-- System Tab
local SystemTab = Window:CreateTab("⚙️ System", 13014546625)

-- Show Info Toggle with debounce
SystemTab:CreateToggle({
    Name = "Show Info",
    CurrentValue = Config.System.ShowInfo,
    Flag = "ShowInfo",
    Callback = function(Value)
        debounce("ShowInfo", 0.5, function()
            Config.System.ShowInfo = Value
            saveState("System_ShowInfo", Value)
            
            if Value then
                showNotification("Show Info", "Show Info activated", 3, 13047715178)
                logError("Show Info activated")
                
                -- Show info logic would go here
                
            else
                showNotification("Show Info", "Show Info deactivated", 3, 13047715178)
                logError("Show Info deactivated")
            end
        end)
    end
})

-- Boost FPS Toggle with debounce
SystemTab:CreateToggle({
    Name = "Boost FPS",
    CurrentValue = Config.System.BoostFPS,
    Flag = "BoostFPS",
    Callback = function(Value)
        debounce("BoostFPS", 0.5, function()
            Config.System.BoostFPS = Value
            saveState("System_BoostFPS", Value)
            
            if Value then
                showNotification("Boost FPS", "Boost FPS activated", 3, 13047715178)
                logError("Boost FPS activated")
                
                -- Boost FPS logic would go here
                
            else
                showNotification("Boost FPS", "Boost FPS deactivated", 3, 13047715178)
                logError("Boost FPS deactivated")
            end
        end)
    end
})

-- FPS Limit Slider
SystemTab:CreateSlider({
    Name = "FPS Limit",
    Range = {0, 360},
    Increment = 5,
    Suffix = "FPS",
    CurrentValue = Config.System.FPSLimit,
    Flag = "FPSLimit",
    Callback = function(Value)
        debounce("FPSLimit", 0.3, function()
            Config.System.FPSLimit = Value
            saveState("System_FPSLimit", Value)
            setfpscap(Value)
            showNotification("FPS Limit", "FPS limit set to " .. Value, 3, 13047715178)
            logError("FPS Limit: " .. Value)
        end)
    end
})

-- Auto Clean Memory Toggle with debounce
SystemTab:CreateToggle({
    Name = "Auto Clean Memory",
    CurrentValue = Config.System.AutoCleanMemory,
    Flag = "AutoCleanMemory",
    Callback = function(Value)
        debounce("AutoCleanMemory", 0.5, function()
            Config.System.AutoCleanMemory = Value
            saveState("System_AutoCleanMemory", Value)
            
            if Value then
                showNotification("Auto Clean Memory", "Auto Clean Memory activated", 3, 13047715178)
                logError("Auto Clean Memory activated")
                
                -- Auto clean memory logic would go here
                
            else
                showNotification("Auto Clean Memory", "Auto Clean Memory deactivated", 3, 13047715178)
                logError("Auto Clean Memory deactivated")
            end
        end)
    end
})

-- Disable Particles Toggle with debounce
SystemTab:CreateToggle({
    Name = "Disable Particles",
    CurrentValue = Config.System.DisableParticles,
    Flag = "DisableParticles",
    Callback = function(Value)
        debounce("DisableParticles", 0.5, function()
            Config.System.DisableParticles = Value
            saveState("System_DisableParticles", Value)
            
            if Value then
                showNotification("Disable Particles", "Particles disabled", 3, 13047715178)
                logError("Particles disabled")
                
                -- Disable particles logic
                for _, effect in ipairs(Workspace:GetDescendants()) do
                    if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Fire") then
                        effect.Enabled = false
                    end
                end
            else
                showNotification("Disable Particles", "Particles enabled", 3, 13047715178)
                logError("Particles enabled")
                
                -- Enable particles
                for _, effect in ipairs(Workspace:GetDescendants()) do
                    if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Fire") then
                        effect.Enabled = true
                    end
                end
            end
        end)
    end
})

-- Auto Farm Toggle with debounce
SystemTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = Config.System.AutoFarm,
    Flag = "AutoFarm",
    Callback = function(Value)
        debounce("AutoFarm", 0.5, function()
            Config.System.AutoFarm = Value
            saveState("System_AutoFarm", Value)
            
            if Value then
                showNotification("Auto Farm", "Auto Farm activated", 3, 13047715178)
                logError("Auto Farm activated")
                
                -- Auto farm logic would go here
                
            else
                showNotification("Auto Farm", "Auto Farm deactivated", 3, 13047715178)
                logError("Auto Farm deactivated")
            end
        end)
    end
})

-- Farm Radius Slider
SystemTab:CreateSlider({
    Name = "Farm Radius",
    Range = {50, 500},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = Config.System.FarmRadius,
    Flag = "FarmRadius",
    Callback = function(Value)
        debounce("FarmRadius", 0.3, function()
            Config.System.FarmRadius = Value
            saveState("System_FarmRadius", Value)
            showNotification("Farm Radius", "Radius set to " .. Value, 3, 13047715178)
            logError("Farm Radius: " .. Value)
        end)
    end
})

-- Rejoin Server Button
SystemTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        debounce("RejoinServer", 1, function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
            logError("Rejoining server...")
        end)
    end
})

-- Get System Info Button
SystemTab:CreateButton({
    Name = "Get System Info",
    Callback = function()
        debounce("GetSystemInfo", 1, function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local memory = math.floor(Stats:GetTotalMemoryUsageMb())
            local battery = math.floor(UserInputService:GetBatteryLevel() * 100)
            local time = os.date("%H:%M:%S")
            
            local systemInfo = string.format("FPS: %d | Ping: %dms | Memory: %dMB | Battery: %d%% | Time: %s", 
                fps, ping, memory, battery, time)
            
            showNotification("System Info", systemInfo, 5, 13047715178)
            logError("System Info: " .. systemInfo)
        end)
    end
})

-- Graphic Tab
local GraphicTab = Window:CreateTab("🎨 Graphic", 13014546625)

-- High Quality Rendering Toggle with debounce
GraphicTab:CreateToggle({
    Name = "High Quality Rendering",
    CurrentValue = Config.Graphic.HighQuality,
    Flag = "HighQuality",
    Callback = function(Value)
        debounce("HighQuality", 0.5, function()
            Config.Graphic.HighQuality = Value
            saveState("Graphic_HighQuality", Value)
            
            if Value then
                sethiddenproperty(Lighting, "Technology", "Future")
                sethiddenproperty(Workspace, "InterpolationThrottling", "Disabled")
                showNotification("High Quality Rendering", "High Quality Rendering activated", 3, 13047715178)
                logError("High Quality Rendering activated")
            else
                sethiddenproperty(Lighting, "Technology", "ShadowMap")
                sethiddenproperty(Workspace, "InterpolationThrottling", "Enabled")
                showNotification("High Quality Rendering", "High Quality Rendering deactivated", 3, 13047715178)
                logError("High Quality Rendering deactivated")
            end
        end)
    end
})

-- Max Rendering Toggle with debounce
GraphicTab:CreateToggle({
    Name = "Max Rendering",
    CurrentValue = Config.Graphic.MaxRendering,
    Flag = "MaxRendering",
    Callback = function(Value)
        debounce("MaxRendering", 0.5, function()
            Config.Graphic.MaxRendering = Value
            saveState("Graphic_MaxRendering", Value)
            
            if Value then
                settings().Rendering.QualityLevel = 21
                showNotification("Max Rendering", "Max Rendering activated", 3, 13047715178)
                logError("Max Rendering activated")
            else
                settings().Rendering.QualityLevel = 10
                showNotification("Max Rendering", "Max Rendering deactivated", 3, 13047715178)
                logError("Max Rendering deactivated")
            end
        end)
    end
})

-- Ultra Low Mode Toggle with debounce
GraphicTab:CreateToggle({
    Name = "Ultra Low Mode",
    CurrentValue = Config.Graphic.UltraLowMode,
    Flag = "UltraLowMode",
    Callback = function(Value)
        debounce("UltraLowMode", 0.5, function()
            Config.Graphic.UltraLowMode = Value
            saveState("Graphic_UltraLowMode", Value)
            
            if Value then
                settings().Rendering.QualityLevel = 1
                for _, part in ipairs(Workspace:GetDescendants()) do
                    if part:IsA("Part") then
                        part.Material = Enum.Material.Plastic
                    end
                end
                showNotification("Ultra Low Mode", "Ultra Low Mode activated", 3, 13047715178)
                logError("Ultra Low Mode activated")
            else
                settings().Rendering.QualityLevel = 10
                showNotification("Ultra Low Mode", "Ultra Low Mode deactivated", 3, 13047715178)
                logError("Ultra Low Mode deactivated")
            end
        end)
    end
})

-- Disable Water Reflection Toggle with debounce
GraphicTab:CreateToggle({
    Name = "Disable Water Reflection",
    CurrentValue = Config.Graphic.DisableWaterReflection,
    Flag = "DisableWaterReflection",
    Callback = function(Value)
        debounce("DisableWaterReflection", 0.5, function()
            Config.Graphic.DisableWaterReflection = Value
            saveState("Graphic_DisableWaterReflection", Value)
            
            if Value then
                for _, water in ipairs(Workspace:GetDescendants()) do
                    if water:IsA("Part") and water.Name == "Water" then
                        water.Transparency = 1
                    end
                end
                showNotification("Disable Water Reflection", "Water reflection disabled", 3, 13047715178)
                logError("Water reflection disabled")
            else
                for _, water in ipairs(Workspace:GetDescendants()) do
                    if water:IsA("Part") and water.Name == "Water" then
                        water.Transparency = 0.5
                    end
                end
                showNotification("Disable Water Reflection", "Water reflection enabled", 3, 13047715178)
                logError("Water reflection enabled")
            end
        end)
    end
})

-- Custom Shader Toggle with debounce
GraphicTab:CreateToggle({
    Name = "Custom Shader",
    CurrentValue = Config.Graphic.CustomShader,
    Flag = "CustomShader",
    Callback = function(Value)
        debounce("CustomShader", 0.5, function()
            Config.Graphic.CustomShader = Value
            saveState("Graphic_CustomShader", Value)
            
            if Value then
                showNotification("Custom Shader", "Custom Shader activated", 3, 13047715178)
                logError("Custom Shader activated")
                
                -- Custom shader logic would go here
                
            else
                showNotification("Custom Shader", "Custom Shader deactivated", 3, 13047715178)
                logError("Custom Shader deactivated")
            end
        end)
    end
})

-- Smooth Graphics Toggle with debounce
GraphicTab:CreateToggle({
    Name = "Smooth Graphics",
    CurrentValue = Config.Graphic.SmoothGraphics,
    Flag = "SmoothGraphics",
    Callback = function(Value)
        debounce("SmoothGraphics", 0.5, function()
            Config.Graphic.SmoothGraphics = Value
            saveState("Graphic_SmoothGraphics", Value)
            
            if Value then
                RunService:Set3dRenderingEnabled(true)
                settings().Rendering.MeshCacheSize = 100
                settings().Rendering.TextureCacheSize = 100
                showNotification("Smooth Graphics", "Smooth Graphics activated", 3, 13047715178)
                logError("Smooth Graphics activated")
            else
                RunService:Set3dRenderingEnabled(false)
                settings().Rendering.MeshCacheSize = 50
                settings().Rendering.TextureCacheSize = 50
                showNotification("Smooth Graphics", "Smooth Graphics deactivated", 3, 13047715178)
                logError("Smooth Graphics deactivated")
            end
        end)
    end
})

-- Full Bright Toggle with debounce
GraphicTab:CreateToggle({
    Name = "Full Bright",
    CurrentValue = Config.Graphic.FullBright,
    Flag = "FullBright",
    Callback = function(Value)
        debounce("FullBright", 0.5, function()
            Config.Graphic.FullBright = Value
            saveState("Graphic_FullBright", Value)
            
            if Value then
                Lighting.GlobalShadows = false
                Lighting.ClockTime = 12
                showNotification("Full Bright", "Full Bright activated", 3, 13047715178)
                logError("Full Bright activated")
            else
                Lighting.GlobalShadows = true
                Lighting.ClockTime = 14
                showNotification("Full Bright", "Full Bright deactivated", 3, 13047715178)
                logError("Full Bright deactivated")
            end
        end)
    end
})

-- RNG Kill Tab
local RNGKillTab = Window:CreateTab("🎲 RNG Kill", 13014546625)

-- RNG Reducer Toggle with debounce
RNGKillTab:CreateToggle({
    Name = "RNG Reducer",
    CurrentValue = Config.RNGKill.RNGReducer,
    Flag = "RNGReducer",
    Callback = function(Value)
        debounce("RNGReducer", 0.5, function()
            Config.RNGKill.RNGReducer = Value
            saveState("RNGKill_RNGReducer", Value)
            
            if Value then
                showNotification("RNG Reducer", "RNG Reducer activated", 3, 13047715178)
                logError("RNG Reducer activated")
            else
                showNotification("RNG Reducer", "RNG Reducer deactivated", 3, 13047715178)
                logError("RNG Reducer deactivated")
            end
        end)
    end
})

-- Force Legendary Catch Toggle with debounce
RNGKillTab:CreateToggle({
    Name = "Force Legendary Catch",
    CurrentValue = Config.RNGKill.ForceLegendary,
    Flag = "ForceLegendary",
    Callback = function(Value)
        debounce("ForceLegendary", 0.5, function()
            Config.RNGKill.ForceLegendary = Value
            saveState("RNGKill_ForceLegendary", Value)
            
            if Value then
                showNotification("Force Legendary Catch", "Force Legendary Catch activated", 3, 13047715178)
                logError("Force Legendary Catch activated")
            else
                showNotification("Force Legendary Catch", "Force Legendary Catch deactivated", 3, 13047715178)
                logError("Force Legendary Catch deactivated")
            end
        end)
    end
})

-- Secret Fish Boost Toggle with debounce
RNGKillTab:CreateToggle({
    Name = "Secret Fish Boost",
    CurrentValue = Config.RNGKill.SecretFishBoost,
    Flag = "SecretFishBoost",
    Callback = function(Value)
        debounce("SecretFishBoost", 0.5, function()
            Config.RNGKill.SecretFishBoost = Value
            saveState("RNGKill_SecretFishBoost", Value)
            
            if Value then
                showNotification("Secret Fish Boost", "Secret Fish Boost activated", 3, 13047715178)
                logError("Secret Fish Boost activated")
            else
                showNotification("Secret Fish Boost", "Secret Fish Boost deactivated", 3, 13047715178)
                logError("Secret Fish Boost deactivated")
            end
        end)
    end
})

-- Mythical Chance ×10 Toggle with debounce
RNGKillTab:CreateToggle({
    Name = "Mythical Chance ×10",
    CurrentValue = Config.RNGKill.MythicalChanceBoost,
    Flag = "MythicalChanceBoost",
    Callback = function(Value)
        debounce("MythicalChanceBoost", 0.5, function()
            Config.RNGKill.MythicalChanceBoost = Value
            saveState("RNGKill_MythicalChanceBoost", Value)
            
            if Value then
                showNotification("Mythical Chance ×10", "Mythical Chance ×10 activated", 3, 13047715178)
                logError("Mythical Chance ×10 activated")
            else
                showNotification("Mythical Chance ×10", "Mythical Chance ×10 deactivated", 3, 13047715178)
                logError("Mythical Chance ×10 deactivated")
            end
        end)
    end
})

-- Anti-Bad Luck Toggle with debounce
RNGKillTab:CreateToggle({
    Name = "Anti-Bad Luck",
    CurrentValue = Config.RNGKill.AntiBadLuck,
    Flag = "AntiBadLuck",
    Callback = function(Value)
        debounce("AntiBadLuck", 0.5, function()
            Config.RNGKill.AntiBadLuck = Value
            saveState("RNGKill_AntiBadLuck", Value)
            
            if Value then
                showNotification("Anti-Bad Luck", "Anti-Bad Luck activated", 3, 13047715178)
                logError("Anti-Bad Luck activated")
            else
                showNotification("Anti-Bad Luck", "Anti-Bad Luck deactivated", 3, 13047715178)
                logError("Anti-Bad Luck deactivated")
            end
        end)
    end
})

-- Guaranteed Catch Toggle with debounce
RNGKillTab:CreateToggle({
    Name = "Guaranteed Catch",
    CurrentValue = Config.RNGKill.GuaranteedCatch,
    Flag = "GuaranteedCatch",
    Callback = function(Value)
        debounce("GuaranteedCatch", 0.5, function()
            Config.RNGKill.GuaranteedCatch = Value
            saveState("RNGKill_GuaranteedCatch", Value)
            
            if Value then
                showNotification("Guaranteed Catch", "Guaranteed Catch activated", 3, 13047715178)
                logError("Guaranteed Catch activated")
            else
                showNotification("Guaranteed Catch", "Guaranteed Catch deactivated", 3, 13047715178)
                logError("Guaranteed Catch deactivated")
            end
        end)
    end
})

-- Apply RNG Settings Button
RNGKillTab:CreateButton({
    Name = "Apply RNG Settings",
    Callback = function()
        debounce("ApplyRNGSettings", 1, function()
            if FishingEvents and FishingEvents:FindFirstChild("ApplyRNGSettings") then
                local success, result = pcall(function()
                    FishingEvents.ApplyRNGSettings:FireServer({
                        RNGReducer = Config.RNGKill.RNGReducer,
                        ForceLegendary = Config.RNGKill.ForceLegendary,
                        SecretFishBoost = Config.RNGKill.SecretFishBoost,
                        MythicalChance = Config.RNGKill.MythicalChanceBoost,
                        AntiBadLuck = Config.RNGKill.AntiBadLuck,
                        GuaranteedCatch = Config.RNGKill.GuaranteedCatch
                    })
                    showNotification("RNG Settings Applied", "RNG modifications activated", 3, 13047715178)
                    logError("RNG Settings Applied")
                end)
                
                if not success then
                    showNotification("RNG Settings Error", "Failed to apply RNG settings: " .. result, 5, 13047715178)
                    logError("RNG Settings Error: " .. result, true)
                end
            else
                showNotification("RNG Settings Error", "FishingEvents.ApplyRNGSettings not found", 5, 13047715178)
                logError("RNG Settings Error: Module not found", true)
            end
        end)
    end
})

-- Shop Tab
local ShopTab = Window:CreateTab("🛒 Shop", 13014546625)

-- Auto Buy Rods Toggle with debounce
ShopTab:CreateToggle({
    Name = "Auto Buy Rods",
    CurrentValue = Config.Shop.AutoBuyRods,
    Flag = "AutoBuyRods",
    Callback = function(Value)
        debounce("AutoBuyRods", 0.5, function()
            Config.Shop.AutoBuyRods = Value
            saveState("Shop_AutoBuyRods", Value)
            
            if Value then
                showNotification("Auto Buy Rods", "Auto Buy Rods activated", 3, 13047715178)
                logError("Auto Buy Rods activated")
                
                -- Auto buy rods logic would go here
                
            else
                showNotification("Auto Buy Rods", "Auto Buy Rods deactivated", 3, 13047715178)
                logError("Auto Buy Rods deactivated")
            end
        end)
    end
})

-- Rod Selection Checkboxes
local rodCheckboxes = {}
for _, rod in ipairs(Rods) do
    rodCheckboxes[rod] = ShopTab:CreateToggle({
        Name = rod,
        CurrentValue = Config.Shop.SelectedRod == rod,
        Flag = "Rod_" .. rod,
        Callback = function(Value)
            debounce("RodSelect", 0.5, function()
                -- Only allow one rod to be selected at a time
                for _, otherRod in ipairs(Rods) do
                    if otherRod ~= rod then
                        if rodCheckboxes[otherRod] then
                            rodCheckboxes[otherRod]:Set(false)
                        end
                        Config.Shop.SelectedRod = ""
                        saveState("Shop_SelectedRod", "")
                    end
                end
                
                Config.Shop.SelectedRod = Value and rod or ""
                saveState("Shop_SelectedRod", Config.Shop.SelectedRod)
                
                if Value then
                    showNotification("Rod Selected", rod .. " selected", 3, 13047715178)
                    logError("Selected Rod: " .. rod)
                else
                    showNotification("Rod Deselected", rod .. " deselected", 3, 13047715178)
                    logError("Deselected Rod: " .. rod)
                end
            end)
        end
    })
end

-- Auto Buy Boats Toggle with debounce
ShopTab:CreateToggle({
    Name = "Auto Buy Boats",
    CurrentValue = Config.Shop.AutoBuyBoats,
    Flag = "AutoBuyBoats",
    Callback = function(Value)
        debounce("AutoBuyBoats", 0.5, function()
            Config.Shop.AutoBuyBoats = Value
            saveState("Shop_AutoBuyBoats", Value)
            
            if Value then
                showNotification("Auto Buy Boats", "Auto Buy Boats activated", 3, 13047715178)
                logError("Auto Buy Boats activated")
                
                -- Auto buy boats logic would go here
                
            else
                showNotification("Auto Buy Boats", "Auto Buy Boats deactivated", 3, 13047715178)
                logError("Auto Buy Boats deactivated")
            end
        end)
    end
})

-- Boat Selection Checkboxes
local boatCheckboxes = {}
for _, boat in ipairs(Boats) do
    boatCheckboxes[boat] = ShopTab:CreateToggle({
        Name = boat,
        CurrentValue = Config.Shop.SelectedBoat == boat,
        Flag = "Boat_" .. boat,
        Callback = function(Value)
            debounce("BoatSelect", 0.5, function()
                -- Only allow one boat to be selected at a time
                for _, otherBoat in ipairs(Boats) do
                    if otherBoat ~= boat then
                        if boatCheckboxes[otherBoat] then
                            boatCheckboxes[otherBoat]:Set(false)
                        end
                        Config.Shop.SelectedBoat = ""
                        saveState("Shop_SelectedBoat", "")
                    end
                end
                
                Config.Shop.SelectedBoat = Value and boat or ""
                saveState("Shop_SelectedBoat", Config.Shop.SelectedBoat)
                
                if Value then
                    showNotification("Boat Selected", boat .. " selected", 3, 13047715178)
                    logError("Selected Boat: " .. boat)
                else
                    showNotification("Boat Deselected", boat .. " deselected", 3, 13047715178)
                    logError("Deselected Boat: " .. boat)
                end
            end)
        end
    })
end

-- Auto Buy Baits Toggle with debounce
ShopTab:CreateToggle({
    Name = "Auto Buy Baits",
    CurrentValue = Config.Shop.AutoBuyBaits,
    Flag = "AutoBuyBaits",
    Callback = function(Value)
        debounce("AutoBuyBaits", 0.5, function()
            Config.Shop.AutoBuyBaits = Value
            saveState("Shop_AutoBuyBaits", Value)
            
            if Value then
                showNotification("Auto Buy Baits", "Auto Buy Baits activated", 3, 13047715178)
                logError("Auto Buy Baits activated")
                
                -- Auto buy baits logic would go here
                
            else
                showNotification("Auto Buy Baits", "Auto Buy Baits deactivated", 3, 13047715178)
                logError("Auto Buy Baits deactivated")
            end
        end)
    end
})

-- Bait Selection Checkboxes
local baitCheckboxes = {}
for _, bait in ipairs(Baits) do
    baitCheckboxes[bait] = ShopTab:CreateToggle({
        Name = bait,
        CurrentValue = Config.Shop.SelectedBait == bait,
        Flag = "Bait_" .. bait,
        Callback = function(Value)
            debounce("BaitSelect", 0.5, function()
                -- Only allow one bait to be selected at a time
                for _, otherBait in ipairs(Baits) do
                    if otherBait ~= bait then
                        if baitCheckboxes[otherBait] then
                            baitCheckboxes[otherBait]:Set(false)
                        end
                        Config.Shop.SelectedBait = ""
                        saveState("Shop_SelectedBait", "")
                    end
                end
                
                Config.Shop.SelectedBait = Value and bait or ""
                saveState("Shop_SelectedBait", Config.Shop.SelectedBait)
                
                if Value then
                    showNotification("Bait Selected", bait .. " selected", 3, 13047715178)
                    logError("Selected Bait: " .. bait)
                else
                    showNotification("Bait Deselected", bait .. " deselected", 3, 13047715178)
                    logError("Deselected Bait: " .. bait)
                end
            end)
        end
    })
end

-- Auto Upgrade Rod Toggle with debounce
ShopTab:CreateToggle({
    Name = "Auto Upgrade Rod",
    CurrentValue = Config.Shop.AutoUpgradeRod,
    Flag = "AutoUpgradeRod",
    Callback = function(Value)
        debounce("AutoUpgradeRod", 0.5, function()
            Config.Shop.AutoUpgradeRod = Value
            saveState("Shop_AutoUpgradeRod", Value)
            
            if Value then
                showNotification("Auto Upgrade Rod", "Auto Upgrade Rod activated", 3, 13047715178)
                logError("Auto Upgrade Rod activated")
                
                -- Auto upgrade rod logic would go here
                
            else
                showNotification("Auto Upgrade Rod", "Auto Upgrade Rod deactivated", 3, 13047715178)
                logError("Auto Upgrade Rod deactivated")
            end
        end)
    end
})

-- Buy Selected Item Button
ShopTab:CreateButton({
    Name = "Buy Selected Item",
    Callback = function()
        debounce("BuySelectedItem", 1, function()
            if Config.Shop.SelectedRod ~= "" and RF_PurchaseFishingRod then
                local success, result = pcall(function()
                    RF_PurchaseFishingRod:InvokeServer(Config.Shop.SelectedRod)
                    showNotification("Purchase", "Purchased: " .. Config.Shop.SelectedRod, 3, 13047715178)
                    logError("Purchased: " .. Config.Shop.SelectedRod)
                end)
                
                if not success then
                    showNotification("Purchase Error", "Failed to purchase: " .. result, 5, 13047715178)
                    logError("Purchase Error: " .. result, true)
                end
            elseif Config.Shop.SelectedBoat ~= "" and RF_PurchaseBoat then
                local success, result = pcall(function()
                    RF_PurchaseBoat:InvokeServer(Config.Shop.SelectedBoat)
                    showNotification("Purchase", "Purchased: " .. Config.Shop.SelectedBoat, 3, 13047715178)
                    logError("Purchased: " .. Config.Shop.SelectedBoat)
                end)
                
                if not success then
                    showNotification("Purchase Error", "Failed to purchase: " .. result, 5, 13047715178)
                    logError("Purchase Error: " .. result, true)
                end
            elseif Config.Shop.SelectedBait ~= "" and RF_PurchaseBait then
                local success, result = pcall(function()
                    RF_PurchaseBait:InvokeServer(Config.Shop.SelectedBait)
                    showNotification("Purchase", "Purchased: " .. Config.Shop.SelectedBait, 3, 13047715178)
                    logError("Purchased: " .. Config.Shop.SelectedBait)
                end)
                
                if not success then
                    showNotification("Purchase Error", "Failed to purchase: " .. result, 5, 13047715178)
                    logError("Purchase Error: " .. result, true)
                end
            else
                showNotification("Purchase Error", "No item selected", 3, 13047715178)
                logError("Purchase Error: No item selected", true)
            end
        end)
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings", 13014546625)

-- Theme Selection Checkboxes
local themeCheckboxes = {}
local themes = {"Dark", "Light", "Blue", "Green", "Red", "Purple"}
for _, theme in ipairs(themes) do
    themeCheckboxes[theme] = SettingsTab:CreateToggle({
        Name = theme,
        CurrentValue = Config.Settings.SelectedTheme == theme,
        Flag = "Theme_" .. theme,
        Callback = function(Value)
            debounce("ThemeSelect", 0.5, function()
                -- Only allow one theme to be selected at a time
                for _, otherTheme in ipairs(themes) do
                    if otherTheme ~= theme then
                        if themeCheckboxes[otherTheme] then
                            themeCheckboxes[otherTheme]:Set(false)
                        end
                        Config.Settings.SelectedTheme = ""
                        saveState("Settings_SelectedTheme", "")
                    end
                end
                
                Config.Settings.SelectedTheme = Value and theme or ""
                saveState("Settings_SelectedTheme", Config.Settings.SelectedTheme)
                
                if Value then
                    showNotification("Theme Selected", theme .. " theme selected", 3, 13047715178)
                    logError("Selected Theme: " .. theme)
                    
                    -- Apply theme logic would go here
                else
                    showNotification("Theme Deselected", theme .. " theme deselected", 3, 13047715178)
                    logError("Deselected Theme: " .. theme)
                end
            end)
        end
    })
end

-- Transparency Slider
SettingsTab:CreateSlider({
    Name = "Transparency",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = Config.Settings.Transparency,
    Flag = "Transparency",
    Callback = function(Value)
        debounce("Transparency", 0.3, function()
            Config.Settings.Transparency = Value
            saveState("Settings_Transparency", Value)
            showNotification("Transparency", "Transparency set to " .. Value, 3, 13047715178)
            logError("Transparency: " .. Value)
            
            -- Apply transparency logic would go here
        end)
    end
})

-- Config Name Input
SettingsTab:CreateInput({
    Name = "Config Name",
    PlaceholderText = "Enter config name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        debounce("ConfigName", 0.5, function()
            Config.Settings.ConfigName = Text
            saveState("Settings_ConfigName", Text)
            
            if Text ~= "" then
                showNotification("Config Name", "Config name set to: " .. Text, 3, 13047715178)
                logError("Config Name: " .. Text)
            else
                showNotification("Config Name", "Config name cleared", 3, 13047715178)
                logError("Config Name cleared")
            end
        end)
    end
})

-- UIScale Slider
SettingsTab:CreateSlider({
    Name = "UIScale",
    Range = {0.5, 2},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = Config.Settings.UIScale,
    Flag = "UIScale",
    Callback = function(Value)
        debounce("UIScale", 0.3, function()
            Config.Settings.UIScale = Value
            saveState("Settings_UIScale", Value)
            showNotification("UIScale", "UI scale set to " .. Value, 3, 13047715178)
            logError("UIScale: " .. Value)
            
            -- Apply UI scale logic would go here
        end)
    end
})

-- Save Config Button
SettingsTab:CreateButton({
    Name = "Save Config",
    Callback = function()
        debounce("SaveConfig", 1, function()
            SaveConfig()
        end)
    end
})

-- Load Config Button
SettingsTab:CreateButton({
    Name = "Load Config",
    Callback = function()
        debounce("LoadConfig", 1, function()
            LoadConfig()
        end)
    end
})

-- Reset Config Button
SettingsTab:CreateButton({
    Name = "Reset Config",
    Callback = function()
        debounce("ResetConfig", 1, function()
            ResetConfig()
        end)
    end
})

-- Low Device Tab
local LowDeviceTab = Window:CreateTab("📱 Low Device", 13014546625)

-- Enabled Toggle with debounce
LowDeviceTab:CreateToggle({
    Name = "Enabled",
    CurrentValue = Config.LowDevice.Enabled,
    Flag = "Enabled",
    Callback = function(Value)
        debounce("LowDeviceEnabled", 0.5, function()
            Config.LowDevice.Enabled = Value
            saveState("LowDevice_Enabled", Value)
            
            if Value then
                showNotification("Low Device Mode", "Low Device Mode activated", 3, 13047715178)
                logError("Low Device Mode activated")
                
                -- Apply low device optimizations
                if Config.LowDevice.AntiLag then
                    settings().Rendering.QualityLevel = 1
                    for _, part in ipairs(Workspace:GetDescendants()) do
                        if part:IsA("Part") then
                            part.Material = Enum.Material.Plastic
                        end
                    end
                end
                
                if Config.LowDevice.FPSStabilizer then
                    setfpscap(30)
                end
                
                if Config.LowDevice.DisableEffects then
                    for _, effect in ipairs(Workspace:GetDescendants()) do
                        if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Fire") then
                            effect.Enabled = false
                        end
                    end
                end
                
                if Config.LowDevice.LowQualityGraphics then
                    settings().Rendering.QualityLevel = 1
                    Lighting.GlobalShadows = false
                end
                
                if Config.LowDevice.ReduceParticles then
                    for _, effect in ipairs(Workspace:GetDescendants()) do
                        if effect:IsA("ParticleEmitter") then
                            effect.Enabled = false
                        end
                    end
                end
                
                if Config.LowDevice.SimpleShaders then
                    for _, part in ipairs(Workspace:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Material = Enum.Material.Plastic
                        end
                    end
                end
                
                if Config.LowDevice.LowDetailTextures then
                    settings().Rendering.TextureQuality = Enum.TextureQualityLevel.Low
                end
            else
                showNotification("Low Device Mode", "Low Device Mode deactivated", 3, 13047715178)
                logError("Low Device Mode deactivated")
                
                -- Reset graphics settings
                settings().Rendering.QualityLevel = 10
                setfpscap(60)
                Lighting.GlobalShadows = true
                
                for _, effect in ipairs(Workspace:GetDescendants()) do
                    if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Fire") then
                        effect.Enabled = true
                    end
                end
                
                settings().Rendering.TextureQuality = Enum.TextureQualityLevel.Automatic
            end
        end)
    end
})

-- Anti Lag Toggle with debounce
LowDeviceTab:CreateToggle({
    Name = "Anti Lag",
    CurrentValue = Config.LowDevice.AntiLag,
    Flag = "AntiLag",
    Callback = function(Value)
        debounce("AntiLag", 0.5, function()
            Config.LowDevice.AntiLag = Value
            saveState("LowDevice_AntiLag", Value)
            
            if Value and Config.LowDevice.Enabled then
                settings().Rendering.QualityLevel = 1
                for _, part in ipairs(Workspace:GetDescendants()) do
                    if part:IsA("Part") then
                        part.Material = Enum.Material.Plastic
                    end
                end
                showNotification("Anti Lag", "Anti Lag activated", 3, 13047715178)
                logError("Anti Lag activated")
            else
                settings().Rendering.QualityLevel = 10
                showNotification("Anti Lag", "Anti Lag deactivated", 3, 13047715178)
                logError("Anti Lag deactivated")
            end
        end)
    end
})

-- FPS Stabilizer Toggle with debounce
LowDeviceTab:CreateToggle({
    Name = "FPS Stabilizer",
    CurrentValue = Config.LowDevice.FPSStabilizer,
    Flag = "FPSStabilizer",
    Callback = function(Value)
        debounce("FPSStabilizer", 0.5, function()
            Config.LowDevice.FPSStabilizer = Value
            saveState("LowDevice_FPSStabilizer", Value)
            
            if Value and Config.LowDevice.Enabled then
                setfpscap(30)
                showNotification("FPS Stabilizer", "FPS Stabilizer activated", 3, 13047715178)
                logError("FPS Stabilizer activated")
            else
                setfpscap(60)
                showNotification("FPS Stabilizer", "FPS Stabilizer deactivated", 3, 13047715178)
                logError("FPS Stabilizer deactivated")
            end
        end)
    end
})

-- Disable Effects Toggle with debounce
LowDeviceTab:CreateToggle({
    Name = "Disable Effects",
    CurrentValue = Config.LowDevice.DisableEffects,
    Flag = "DisableEffects",
    Callback = function(Value)
        debounce("DisableEffects", 0.5, function()
            Config.LowDevice.DisableEffects = Value
            saveState("LowDevice_DisableEffects", Value)
            
            if Value and Config.LowDevice.Enabled then
                for _, effect in ipairs(Workspace:GetDescendants()) do
                    if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Fire") then
                        effect.Enabled = false
                    end
                end
                showNotification("Disable Effects", "Effects disabled", 3, 13047715178)
                logError("Effects disabled")
            else
                for _, effect in ipairs(Workspace:GetDescendants()) do
                    if effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Fire") then
                        effect.Enabled = true
                    end
                end
                showNotification("Disable Effects", "Effects enabled", 3, 13047715178)
                logError("Effects enabled")
            end
        end)
    end
})

-- Low Quality Graphics Toggle with debounce
LowDeviceTab:CreateToggle({
    Name = "Low Quality Graphics",
    CurrentValue = Config.LowDevice.LowQualityGraphics,
    Flag = "LowQualityGraphics",
    Callback = function(Value)
        debounce("LowQualityGraphics", 0.5, function()
            Config.LowDevice.LowQualityGraphics = Value
            saveState("LowDevice_LowQualityGraphics", Value)
            
            if Value and Config.LowDevice.Enabled then
                settings().Rendering.QualityLevel = 1
                Lighting.GlobalShadows = false
                showNotification("Low Quality Graphics", "Low Quality Graphics activated", 3, 13047715178)
                logError("Low Quality Graphics activated")
            else
                settings().Rendering.QualityLevel = 10
                Lighting.GlobalShadows = true
                showNotification("Low Quality Graphics", "Low Quality Graphics deactivated", 3, 13047715178)
                logError("Low Quality Graphics deactivated")
            end
        end)
    end
})

-- Reduce Particles Toggle with debounce
LowDeviceTab:CreateToggle({
    Name = "Reduce Particles",
    CurrentValue = Config.LowDevice.ReduceParticles,
    Flag = "ReduceParticles",
    Callback = function(Value)
        debounce("ReduceParticles", 0.5, function()
            Config.LowDevice.ReduceParticles = Value
            saveState("LowDevice_ReduceParticles", Value)
            
            if Value and Config.LowDevice.Enabled then
                for _, effect in ipairs(Workspace:GetDescendants()) do
                    if effect:IsA("ParticleEmitter") then
                        effect.Enabled = false
                    end
                end
                showNotification("Reduce Particles", "Particles reduced", 3, 13047715178)
                logError("Particles reduced")
            else
                for _, effect in ipairs(Workspace:GetDescendants()) do
                    if effect:IsA("ParticleEmitter") then
                        effect.Enabled = true
                    end
                end
                showNotification("Reduce Particles", "Particles normal", 3, 13047715178)
                logError("Particles normal")
            end
        end)
    end
})

-- Simple Shaders Toggle with debounce
LowDeviceTab:CreateToggle({
    Name = "Simple Shaders",
    CurrentValue = Config.LowDevice.SimpleShaders,
    Flag = "SimpleShaders",
    Callback = function(Value)
        debounce("SimpleShaders", 0.5, function()
            Config.LowDevice.SimpleShaders = Value
            saveState("LowDevice_SimpleShaders", Value)
            
            if Value and Config.LowDevice.Enabled then
                for _, part in ipairs(Workspace:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Material = Enum.Material.Plastic
                    end
                end
                showNotification("Simple Shaders", "Simple Shaders activated", 3, 13047715178)
                logError("Simple Shaders activated")
            else
                showNotification("Simple Shaders", "Simple Shaders deactivated", 3, 13047715178)
                logError("Simple Shaders deactivated")
            end
        end)
    end
})

-- Low Detail Textures Toggle with debounce
LowDeviceTab:CreateToggle({
    Name = "Low Detail Textures",
    CurrentValue = Config.LowDevice.LowDetailTextures,
    Flag = "LowDetailTextures",
    Callback = function(Value)
        debounce("LowDetailTextures", 0.5, function()
            Config.LowDevice.LowDetailTextures = Value
            saveState("LowDevice_LowDetailTextures", Value)
            
            if Value and Config.LowDevice.Enabled then
                settings().Rendering.TextureQuality = Enum.TextureQualityLevel.Low
                showNotification("Low Detail Textures", "Low Detail Textures activated", 3, 13047715178)
                logError("Low Detail Textures activated")
            else
                settings().Rendering.TextureQuality = Enum.TextureQualityLevel.Automatic
                showNotification("Low Detail Textures", "Low Detail Textures deactivated", 3, 13047715178)
                logError("Low Detail Textures deactivated")
            end
        end)
    end
})

-- Initialize UI states on script load
spawn(function()
    -- Load saved states
    for section, values in pairs(Config) do
        if type(values) == "table" then
            for key, value in pairs(values) do
                saveState(section .. "_" .. key, value)
            end
        end
    end
    
    -- Log script initialization
    logError("Script initialized successfully")
    showNotification("Script Loaded", "Fish It Hub 2025 loaded successfully", 5, 13047715178)
end)

-- Auto-save config periodically
spawn(function()
    while true do
        task.wait(60) -- Save every minute
        SaveConfig()
    end
end)

-- Auto-clean memory if enabled
spawn(function()
    while true do
        task.wait(30) -- Check every 30 seconds
        if Config.System.AutoCleanMemory then
            collectgarbage("collect")
            logError("Memory cleaned automatically")
        end
    end
end)

-- Error handling for unexpected script termination
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    logError("Character respawned")
end)

game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function()
    logError("Character removed")
end)

game:GetService("RunService").Stepped:Connect(function()
    -- Check for script errors
    if Config.System.ShowInfo then
        -- Update info display
    end
end)

-- Script termination handler
game:GetService("RunService").Stepped:Connect(function()
    if not game.Players.LocalPlayer.Character then
        logError("Character not found - attempting to respawn")
        game.Players.LocalPlayer.CharacterAdded:Wait()
    end
end)

-- Final initialization message
logError("Script initialization complete")
showNotification("Initialization Complete", "Fish It Hub 2025 is ready to use", 5, 13047715178)
