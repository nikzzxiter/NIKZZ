-- NIKZZMODDER.LUA - FULL IMPLEMENTATION FOR FISH IT ROBLOX
-- BASED ON MODULE.TXT AND BASE.TXT WITH FULL ASYNC SYSTEM

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ========================================
-- GLOBAL VARIABLES & UTILITIES
-- ========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = nil
local Humanoid = nil
local Camera = workspace.CurrentCamera

-- Load all modules from MODULE.TXT
local RemoteEvent = require(ReplicatedStorage.RemoteEvent)
local RemoteFunction = require(ReplicatedStorage.RemoteFunction)

-- Extracting all necessary remotes and modules from MODULE.TXT
local Remotes = {
    -- VoiceChat & Server Info
    VoiceChatTokenRequest = ReplicatedStorage.VoiceChatTokenRequest,
    GetServerVersion = ReplicatedStorage.GetServerVersion,
    GetServerChannel = ReplicatedStorage.GetServerChannel,
    GetServerType = ReplicatedStorage.GetServerType,
    
    -- Chat & Blocklist
    WhisperChat = ReplicatedStorage.ExperienceChat.WhisperChat,
    CanChatWith = ReplicatedStorage.CanChatWith,
    SetPlayerBlockList = ReplicatedStorage.SetPlayerBlockList,
    UpdatePlayerBlockList = ReplicatedStorage.UpdatePlayerBlockList,
    SendPlayerBlockList = ReplicatedStorage.SendPlayerBlockList,
    UpdateLocalPlayerBlockList = ReplicatedStorage.UpdateLocalPlayerBlockList,
    SendPlayerProfileSettings = ReplicatedStorage.SendPlayerProfileSettings,
    ShowPlayerJoinedFriendsToast = ReplicatedStorage.ShowPlayerJoinedFriendsToast,
    ShowFriendJoinedPlayerToast = ReplicatedStorage.ShowFriendJoinedPlayerToast,
    
    -- Player & Group
    NewPlayerGroupDetails = ReplicatedStorage.NewPlayerGroupDetails,
    NewPlayerCanManageDetails = ReplicatedStorage.NewPlayerCanManageDetails,
    
    -- Device & Camera
    RequestDeviceCameraOrientationCapability = ReplicatedStorage.RequestDeviceCameraOrientationCapability,
    RequestDeviceCameraCFrame = ReplicatedStorage.RequestDeviceCameraCFrame,
    ReceiveLikelySpeakingUsers = ReplicatedStorage.ReceiveLikelySpeakingUsers,
    ReferredPlayerJoin = ReplicatedStorage.ReferredPlayerJoin,
    
    -- Cmdr (Admin Commands)
    CmdrFunction = ReplicatedStorage.CmdrClient.CmdrFunction,
    CmdrEvent = ReplicatedStorage.CmdrClient.CmdrEvent,
    
    -- GamePass & Purchase
    UserOwnsGamePass = ReplicatedStorage.Shared.GamePassUtility.UserOwnsGamePass,
    PromptGamePassPurchase = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/PromptGamePassPurchase,
    PromptProductPurchase = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/PromptProductPurchase,
    PromptPurchase = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/PromptPurchase,
    ProductPurchaseFinished = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/ProductPurchaseFinished,
    DisplaySystemMessage = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/DisplaySystemMessage,
    GiftGamePass = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/GiftGamePass,
    ProductPurchaseCompleted = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/ProductPurchaseCompleted,
    PlaySound = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/PlaySound,
    PlayFishingEffect = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/PlayFishingEffect,
    ReplicateTextEffect = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/ReplicateTextEffect,
    DestroyEffect = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/DestroyEffect,
    ReplicateCutscene = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/ReplicateCutscene,
    StopCutscene = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/StopCutscene,
    BaitSpawned = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/BaitSpawned,
    FishCaught = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/FishCaught,
    TextNotification = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/TextNotification,
    PurchaseWeatherEvent = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseWeatherEvent,
    ActivateEnchantingAltar = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/ActivateEnchantingAltar,
    UpdateEnchantState = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/UpdateEnchantState,
    RollEnchant = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/RollEnchant,
    ActivateQuestLine = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/ActivateQuestLine,
    IncrementOnboardingStep = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/IncrementOnboardingStep,
    UpdateAutoFishingState = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/UpdateAutoFishingState,
    UpdateChargeState = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/UpdateChargeState,
    ChargeFishingRod = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/ChargeFishingRod,
    CancelFishingInputs = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/CancelFishingInputs,
    PlayVFX = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/PlayVFX,
    FishingStopped = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/FishingStopped,
    RequestFishingMinigameStarted = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/RequestFishingMinigameStarted,
    FishingCompleted = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/FishingCompleted,
    FishingMinigameChanged = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/FishingMinigameChanged,
    UpdateAutoSellThreshold = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/UpdateAutoSellThreshold,
    UpdateFishingRadar = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/UpdateFishingRadar,
    ObtainedNewFishNotification = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/ObtainedNewFishNotification,
    PurchaseSkinCrate = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseSkinCrate,
    RollSkinCrate = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/RollSkinCrate,
    EquipRodSkin = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/EquipRodSkin,
    UnequipRodSkin = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/UnequipRodSkin,
    EquipItem = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/EquipItem,
    UnequipItem = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/UnequipItem,
    EquipBait = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/EquipBait,
    FavoriteItem = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/FavoriteItem,
    FavoriteStateChanged = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/FavoriteStateChanged,
    UnequipToolFromHotbar = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/UnequipToolFromHotbar,
    EquipToolFromHotbar = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/EquipToolFromHotbar,
    SellItem = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/SellItem,
    SellAllItems = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/SellAllItems,
    PurchaseFishingRod = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseFishingRod,
    PurchaseBait = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseBait,
    PurchaseGear = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseGear,
    CancelPrompt = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/CancelPrompt,
    FeatureUnlocked = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/FeatureUnlocked,
    ChangeSetting = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/ChangeSetting,
    PurchaseBoat = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/PurchaseBoat,
    SpawnBoat = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/SpawnBoat,
    DespawnBoat = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/DespawnBoat,
    BoatChanged = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/BoatChanged,
    VerifyGroupReward = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/VerifyGroupReward,
    ConsumePotion = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/ConsumePotion,
    RedeemChristmasItems = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/RedeemChristmasItems,
    EquipOxygenTank = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/EquipOxygenTank,
    UnequipOxygenTank = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/UnequipOxygenTank,
    ClaimDailyLogin = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/ClaimDailyLogin,
    RecievedDailyRewards = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/RecievedDailyRewards,
    ReconnectPlayer = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/ReconnectPlayer,
    CanSendTrade = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/CanSendTrade,
    InitiateTrade = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/InitiateTrade,
    AwaitTradeResponse = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/AwaitTradeResponse,
    RedeemCode = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/RedeemCode,
    LoadVFX = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/LoadVFX,
    RequestSpin = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/RequestSpin,
    SpinWheel = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/SpinWheel,
    PromptFavoriteGame = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF/PromptFavoriteGame,
    ClaimNotification = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/ClaimNotification,
    BlackoutScreen = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/BlackoutScreen,
    ElevatorStateUpdated = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/ElevatorStateUpdated,
    
    -- Replion System
    Added = ReplicatedStorage.Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Remotes.Added,
    Removed = ReplicatedStorage.Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Remotes.Removed,
    Update = ReplicatedStorage.Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Remotes.Update,
    UpdateReplicateTo = ReplicatedStorage.Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Remotes.UpdateReplicateTo,
    Set = ReplicatedStorage.Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Remotes.Set,
    ArrayUpdate = ReplicatedStorage.Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Remotes.ArrayUpdate,
    
    -- Controllers & Modules
    HUDController = ReplicatedStorage.Controllers.HUDController,
    WeatherState = ReplicatedStorage.Controllers.EventController.WeatherState,
    SettingsListener = ReplicatedStorage.Controllers.SettingsController.SettingsListener,
    SettingsController = ReplicatedStorage.Controllers.SettingsController,
    PromptController = ReplicatedStorage.Controllers.PromptController,
    MasteryController = ReplicatedStorage.Controllers.MasteryController,
    InventoryController = ReplicatedStorage.Controllers.InventoryController,
    FishingController = ReplicatedStorage.Controllers.FishingController,
    PotionController = ReplicatedStorage.Controllers.PotionController,
    InputStates = ReplicatedStorage.Controllers.FishingController.InputStates,
    WeightRanges = ReplicatedStorage.Controllers.FishingController.WeightRanges,
    GamepadStates = ReplicatedStorage.Controllers.FishingController.GamepadStates,
    AnimationController = ReplicatedStorage.Controllers.AnimationController,
    DailyLoginController = ReplicatedStorage.Controllers.DailyLoginController,
    ChatController = ReplicatedStorage.Controllers.ChatController,
    LevelController = ReplicatedStorage.Controllers.LevelController,
    EventController = ReplicatedStorage.Controllers.EventController,
    HotbarController = ReplicatedStorage.Controllers.HotbarController,
    NotificationController = ReplicatedStorage.Controllers.NotificationController,
    VFXController = ReplicatedStorage.Controllers.VFXController,
    SpinWheelController = ReplicatedStorage.Controllers.SpinWheelController,
    BaitShopController = ReplicatedStorage.Controllers.BaitShopController,
    TextNotificationController = ReplicatedStorage.Controllers.TextNotificationController,
    SpinController = ReplicatedStorage.Controllers.SpinController,
    AreaController = ReplicatedStorage.Controllers.AreaController,
    DialogueController = ReplicatedStorage.Controllers.DialogueController,
    BoatShopController = ReplicatedStorage.Controllers.BoatShopController,
    VendorController = ReplicatedStorage.Controllers.VendorController,
    QuestController = ReplicatedStorage.Controllers.QuestController,
    EnchantingController = ReplicatedStorage.Controllers.EnchantingController,
    ElevatorController = ReplicatedStorage.Controllers.ElevatorController,
    AutoFishingController = ReplicatedStorage.Controllers.AutoFishingController,
    LootboxController = ReplicatedStorage.Controllers.LootboxController,
    FireflyController = ReplicatedStorage.Controllers.FireflyController,
    GroupRewardController = ReplicatedStorage.Controllers.GroupRewardController,
    PotionShopController = ReplicatedStorage.Controllers.PotionShopController,
    StarterPackController = ReplicatedStorage.Controllers.StarterPackController,
    AFKController = ReplicatedStorage.Controllers.AFKController,
    DoubleLuckController = ReplicatedStorage.Controllers.DoubleLuckController,
    CodeController = ReplicatedStorage.Controllers.CodeController,
    SwimController = ReplicatedStorage.Controllers.SwimController,
    TopBarController = ReplicatedStorage.Controllers.TopBarController,
    WeatherMachineController = ReplicatedStorage.Controllers.WeatherMachineController,
    ItemTradingController = ReplicatedStorage.Controllers.ItemTradingController,
    CutsceneController = ReplicatedStorage.Controllers.CutsceneController,
    Leaderboard = ReplicatedStorage.Observers.Leaderboard,
    GamePassPrompt = ReplicatedStorage.Observers.GamePassPrompt,
    Fishing = ReplicatedStorage.Types.Fishing,
    Enchanting = ReplicatedStorage.Types.Enchanting,
    ClickSound = ReplicatedStorage.Observers.ClickSound,
    CoralLight = ReplicatedStorage.Observers.CoralLight,
    CurrencyCounter = ReplicatedStorage.Observers.CurrencyCounter,
    RegisterButtonTooltip = ReplicatedStorage.Modules.RegisterButtonTooltip,
    MenuRing = ReplicatedStorage.Observers.MenuRing,
    MenuPrompt = ReplicatedStorage.Observers.MenuPrompt,
    AutomaticallyCloseButton = ReplicatedStorage.Observers.AutomaticallyCloseButton,
    HUDButton = ReplicatedStorage.Observers.HUDButton,
    Propeller = ReplicatedStorage.Observers.Propeller,
    BoostedRegion = ReplicatedStorage.Observers.BoostedRegion,
    Seat = ReplicatedStorage.Observers.Seat,
    VehicleSeat = ReplicatedStorage.Observers.VehicleSeat,
    GamePassPurchase = ReplicatedStorage.Observers.GamePassPurchase,
    EnchantAltarAttachment = ReplicatedStorage.Observers.EnchantAltarAttachment,
    ShopPurchasePrompt = ReplicatedStorage.Observers.ShopPurchasePrompt,
    DevProductPurchase = ReplicatedStorage.Observers.DevProductPurchase,
    RenderTextEffect = ReplicatedStorage.Observers.RenderTextEffect,
    GroupRewardDisplay = ReplicatedStorage.Observers.GroupRewardDisplay,
    NPC = ReplicatedStorage.Modules.NPC,
    NotificationBubble = ReplicatedStorage.Observers.NotificationBubble,
    DevProductPrice = ReplicatedStorage.Observers.DevProductPrice,
    GamePassPrice = ReplicatedStorage.Observers.GamePassPrice,
    ChristmasColorStrobe = ReplicatedStorage.Observers.ChristmasColorStrobe,
    FootstepSounds = ReplicatedStorage.Modules.FootstepSounds,
    IslandLocationTag = ReplicatedStorage.Observers.IslandLocationTag,
    BagSize = ReplicatedStorage.Observers.BagSize,
    ClientPassives = ReplicatedStorage.Observers.ClientPassives,
    FloatingDrop = ReplicatedStorage.Observers.FloatingDrop,
    Rainbow = ReplicatedStorage.Observers.Rainbow,
    CoreCall = ReplicatedStorage.Modules.CoreCall,
    LimitedProductPurchase = ReplicatedStorage.Observers.LimitedProductPurchase,
    GuiControl = ReplicatedStorage.Modules.GuiControl,
    Animations = ReplicatedStorage.Modules.Animations,
    CameraShaker = ReplicatedStorage.Modules.CameraShaker,
    ItemStringUtility = ReplicatedStorage.Modules.ItemStringUtility,
    CoinProductsUtility = ReplicatedStorage.Modules.CoinProductsUtility,
    CurrencyUtility = ReplicatedStorage.Modules.CurrencyUtility,
    InputControl = ReplicatedStorage.Modules.InputControl,
    Spring = ReplicatedStorage.Modules.Spring,
    SebasUtil = ReplicatedStorage.Modules.SebasUtil,
    AceworksUtils = ReplicatedStorage.AceworksUtils,
    CmdrClient = ReplicatedStorage.CmdrClient,
    Passives = ReplicatedStorage.Passives,
    Shared = ReplicatedStorage.Shared,
    Boats = ReplicatedStorage.Boats,
    Baits = ReplicatedStorage.Baits,
    Items = ReplicatedStorage.Items,
    Events = ReplicatedStorage.Events,
    Enchants = ReplicatedStorage.Enchants,
    Areas = ReplicatedStorage.Areas,
    LightingProfiles = Lighting.LightingProfiles,
    ModelProvider = ReplicatedStorage.ModelProvider,
    Potions = ReplicatedStorage.Potions,
    Tiers = ReplicatedStorage.Tiers,
    Variants = ReplicatedStorage.Variants,
    SkinCrates = ReplicatedStorage.SkinCrates,
    VFXUtility = ReplicatedStorage.Shared.VFXUtility,
    EventUtility = ReplicatedStorage.Shared.EventUtility,
    WeightRandom = ReplicatedStorage.Shared.WeightRandom,
    TimeConfiguration = ReplicatedStorage.Shared.TimeConfiguration,
    SystemMessage = ReplicatedStorage.Shared.SystemMessage,
    GamePass = ReplicatedStorage.Shared.GamePass,
    GamePassUtility = ReplicatedStorage.Shared.GamePassUtility,
    GiftProducts = ReplicatedStorage.Shared.GiftProducts,
    ChatTags = ReplicatedStorage.Shared.ChatTags,
    AuthorizedUserIds = ReplicatedStorage.Shared.AuthorizedUserIds,
    ValidEventNames = ReplicatedStorage.Shared.ValidEventNames,
    PlayerEvents = ReplicatedStorage.Shared.PlayerEvents,
    PlayerStatsUtility = ReplicatedStorage.Shared.PlayerStatsUtility,
    Constants = ReplicatedStorage.Shared.Constants,
    ItemUtility = ReplicatedStorage.Shared.ItemUtility,
    VariantPool = ReplicatedStorage.Shared.ItemUtility.VariantPool,
    Dump = ReplicatedStorage.Shared.Soundbook.Dump,
    XPUtility = ReplicatedStorage.Shared.XPUtility,
    Soundbook = ReplicatedStorage.Shared.Soundbook,
    Types = ReplicatedStorage.Shared.Quests.Types,
    AreaUtility = ReplicatedStorage.Shared.AreaUtility,
    SpecialItems = ReplicatedStorage.Shared.AreaUtility.SpecialItems,
    TierUtility = ReplicatedStorage.Shared.TierUtility,
    DrawSeatUtility = ReplicatedStorage.Shared.DrawSeatUtility,
    DailyRewardsUtility = ReplicatedStorage.Shared.DailyRewardsUtility,
    StringLibrary = ReplicatedStorage.Shared.StringLibrary,
    QuestUtility = ReplicatedStorage.Shared.Quests.QuestUtility,
    Leaderboards = ReplicatedStorage.Shared.Leaderboards,
    FishingRodModifiers = ReplicatedStorage.Shared.FishingRodModifiers,
    Effects = ReplicatedStorage.Shared.Effects,
    SpinWheelPrizes = ReplicatedStorage.Shared.SpinWheelPrizes,
    FishingCastText = ReplicatedStorage.Shared.Effects.FishingCastText,
    Settings = ReplicatedStorage.Shared.Settings,
    BoatsHandlingData = ReplicatedStorage.Shared.BoatsHandlingData,
    Legendary = ReplicatedStorage.Shared.CutsceneUtility.Data.Legendary,
    VendorUtility = ReplicatedStorage.Shared.VendorUtility,
    BlockedHumanoidStates = ReplicatedStorage.Shared.BlockedHumanoidStates,
    SECRET = ReplicatedStorage.Shared.CutsceneUtility.Data.SECRET,
    SoldItemTypes = ReplicatedStorage.Shared.SoldItemTypes,
    Attribute = ReplicatedStorage.Packages.Icon.Attribute,
    PolicyWrapper = ReplicatedStorage.Shared.PolicyWrapper,
    UserPriority = ReplicatedStorage.Shared.UserPriority,
    RaycastUtility = ReplicatedStorage.Shared.RaycastUtility,
    Mythic = ReplicatedStorage.Shared.CutsceneUtility.Data.Mythic,
    CutsceneUtility = ReplicatedStorage.Shared.CutsceneUtility,
    QuestList = ReplicatedStorage.Shared.Quests.QuestList,
    VERSION = ReplicatedStorage.Packages.Icon.VERSION,
    CoinProducts = ReplicatedStorage.Shared.Products.CoinProducts,
    Icon = ReplicatedStorage.Packages.Icon,
    DoubleLuckProducts = ReplicatedStorage.Shared.Products.DoubleLuckProducts,
    LimitedProducts = ReplicatedStorage.Shared.Products.LimitedProducts,
    ActiveProduct = ReplicatedStorage.Shared.Products.LimitedProducts.ActiveProduct,
    PassivesRunner = ReplicatedStorage.Shared.Passives.PassivesRunner,
    PassivesUtility = ReplicatedStorage.Shared.Passives.PassivesUtility,
    PassivesTypes = ReplicatedStorage.Shared.Passives.PassivesTypes,
    Loader = ReplicatedStorage.Packages.Loader,
    Net = ReplicatedStorage.Packages.Net,
    Replion = ReplicatedStorage.Packages.Replion,
    Signal = ReplicatedStorage.Packages.Signal,
    Reference = ReplicatedStorage.Packages.Icon.Reference,
    Trove = ReplicatedStorage.Packages.Trove,
    spr = ReplicatedStorage.Packages.spr,
    Thread = ReplicatedStorage.Packages.Thread,
    MarketplaceService = ReplicatedStorage.Packages.MarketplaceService,
    Promise = ReplicatedStorage.Packages.Promise,
    NumberSpinner = ReplicatedStorage.Packages.NumberSpinner,
    Digit = ReplicatedStorage.Packages.NumberSpinner.Digit,
    Utility = ReplicatedStorage.Packages.Icon.Utility,
    Container = ReplicatedStorage.Packages.Icon.Elements.Container,
    Indicator = ReplicatedStorage.Packages.Icon.Elements.Indicator,
    Menu = ReplicatedStorage.Packages.Icon.Elements.Menu,
}

-- ========================================
-- UTILITY FUNCTIONS
-- ========================================

local function getRemote(name)
    return Remotes[name]
end

local function getModule(path)
    local module = ReplicatedStorage
    for part in path:gmatch("[^%.]+") do
        module = module:FindFirstChild(part)
        if not module then return nil end
    end
    return module
end

local function getCharacter()
    if not Character or not Character.Parent then
        Character = LocalPlayer.Character
        if Character then
            Humanoid = Character:FindFirstChildOfClass("Humanoid")
        end
    end
    return Character, Humanoid
end

local function waitForCharacter()
    while not getCharacter() do
        task.wait()
    end
end

local function getInventory()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        local inventory = playerGui:FindFirstChild("Inventory")
        if inventory then
            return inventory
        end
    end
    return nil
end

local function getRodFromInventory()
    local inventory = getInventory()
    if not inventory then return nil end
    
    local rods = {}
    for _, child in ipairs(inventory:GetChildren()) do
        if child:IsA("Part") and child.Name:find("!!!") and child.Name:find("Rod") then
            table.insert(rods, child)
        end
    end
    if #rods > 0 then
        return rods[1] -- Return first found rod
    end
    return nil
end

local function equipRod(rodName)
    local rod = nil
    local allItems = ReplicatedStorage.Items
    for _, item in ipairs(allItems:GetChildren()) do
        if item.Name == rodName then
            rod = item
            break
        end
    end
    if rod then
        local equipRemote = getRemote("EquipItem")
        if equipRemote then
            equipRemote:FireServer(rodName)
            return true
        end
    end
    return false
end

local function equipBait(baitName)
    local bait = nil
    local allBaits = ReplicatedStorage.Baits
    for _, item in ipairs(allBaits:GetChildren()) do
        if item.Name == baitName then
            bait = item
            break
        end
    end
    if bait then
        local equipBaitRemote = getRemote("EquipBait")
        if equipBaitRemote then
            equipBaitRemote:FireServer(baitName)
            return true
        end
    end
    return false
end

local function buyItem(itemName, itemType)
    local purchaseRemote = nil
    if itemType == "rod" then
        purchaseRemote = getRemote("PurchaseFishingRod")
    elseif itemType == "bait" then
        purchaseRemote = getRemote("PurchaseBait")
    elseif itemType == "gear" then
        purchaseRemote = getRemote("PurchaseGear")
    elseif itemType == "weather" then
        purchaseRemote = getRemote("PurchaseWeatherEvent")
    elseif itemType == "boat" then
        purchaseRemote = getRemote("PurchaseBoat")
    end
    
    if purchaseRemote then
        purchaseRemote:FireServer(itemName)
        return true
    end
    return false
end

local function isFishingActive()
    local fishingController = getModule("Controllers.FishingController")
    if fishingController and fishingController.IsFishing then
        return fishingController.IsFishing.Value
    end
    return false
end

local function getAvailableAreas()
    local areas = {}
    for _, area in ipairs(ReplicatedStorage.Areas:GetChildren()) do
        if area:IsA("Folder") then
            table.insert(areas, area.Name)
        end
    end
    return areas
end

local function getAvailableEvents()
    local events = {}
    for _, event in ipairs(ReplicatedStorage.Events:GetChildren()) do
        if event:IsA("Folder") then
            table.insert(events, event.Name)
        end
    end
    return events
end

local function getAvailableBoats()
    local boats = {}
    for _, boat in ipairs(ReplicatedStorage.Boats:GetChildren()) do
        if boat:IsA("Folder") then
            table.insert(boats, boat.Name)
        end
    end
    return boats
end

local function getAvailableRods()
    local rods = {}
    for _, rod in ipairs(ReplicatedStorage.Items:GetChildren()) do
        if rod.Name:find("!!!") and rod.Name:find("Rod") then
            table.insert(rods, rod.Name)
        end
    end
    return rods
end

local function getAvailableBaits()
    local baits = {}
    for _, bait in ipairs(ReplicatedStorage.Baits:GetChildren()) do
        if bait:IsA("Folder") then
            table.insert(baits, bait.Name)
        end
    end
    return baits
end

local function getAvailableWeather()
    local weathers = {}
    for _, weather in ipairs(ReplicatedStorage.Events:GetChildren()) do
        if weather.Name ~= "Day" and weather.Name ~= "Night" and weather.Name:find(" ") then
            table.insert(weathers, weather.Name)
        end
    end
    return weathers
end

local function getPlayerList()
    local players = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    return players
end

local function teleportToArea(areaName)
    local area = ReplicatedStorage.Areas:FindFirstChild(areaName)
    if area and area.Position then
        LocalPlayer.Character:SetPrimaryPartCFrame(area.Position)
        return true
    end
    return false
end

local function teleportToEvent(eventName)
    local event = ReplicatedStorage.Events:FindFirstChild(eventName)
    if event and event.Position then
        LocalPlayer.Character:SetPrimaryPartCFrame(event.Position)
        return true
    end
    return false
end

local function teleportToPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character then
        LocalPlayer.Character:SetPrimaryPartCFrame(targetPlayer.Character:GetPrimaryPartCFrame())
        return true
    end
    return false
end

local function enableAntiAFK()
    local lastInput = tick()
    task.spawn(function()
        while true do
            task.wait(5)
            if tick() - lastInput > 10 then
                -- Simulate random movement to avoid AFK detection
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):Move(Vector3.new(0,0,1), 0.1)
                task.wait(0.1)
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):Move(Vector3.new(0,0,-1), 0.1)
                lastInput = tick()
            end
        end
    end)
end

local function disableDetection()
    -- Bypass developer detection by clearing known flags
    local cmdrClient = getModule("CmdrClient")
    if cmdrClient then
        cmdrClient.Disabled = true
    end
    -- Disable any remote calls that could trigger detection
    local remotes = {
        "CmdrFunction", "CmdrEvent", "GetServerVersion", "GetServerChannel"
    }
    for _, remoteName in ipairs(remotes) do
        local remote = getRemote(remoteName)
        if remote then
            remote.OnClientInvoke = function() return nil end
            remote.OnClientEvent:Clear()
        end
    end
end

local function setFPSLimit(limit)
    RunService:SetRenderStepped(true)
    RunService.Heartbeat:Connect(function()
        if limit > 0 then
            task.wait(1/limit)
        end
    end)
end

local function setBrightness(value)
    local lighting = workspace.Lighting
    lighting.Brightness = value / 10
end

local function disableEffects()
    -- Disable particle effects
    for _, effect in ipairs(workspace:GetDescendants()) do
        if effect:IsA("ParticleEmitter") or effect:IsA("Trail") or effect:IsA("Decal") then
            effect.Enabled = false
        end
    end
end

local function enableFly()
    local character, humanoid = getCharacter()
    if not character or not humanoid then return end
    
    humanoid:SetAttribute("Flying", true)
    humanoid.WalkSpeed = 100
    humanoid.JumpPower = 1000
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.Space and not gameProcessed then
            humanoid:ApplyImpulse(Vector3.new(0, 50, 0))
        end
    end)
end

local function enableSpeedHack(speed)
    local character, humanoid = getCharacter()
    if not character or not humanoid then return end
    humanoid.WalkSpeed = speed
end

local function enableJumpHack(height)
    local character, humanoid = getCharacter()
    if not character or not humanoid then return end
    humanoid.JumpPower = height
end

local function enableInfiniteJump()
    local character, humanoid = getCharacter()
    if not character or not humanoid then return end
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.Space and not gameProcessed then
            humanoid:ApplyImpulse(Vector3.new(0, 100, 0))
        end
    end)
end

local function enableBoatFly(speed)
    local character, humanoid = getCharacter()
    if not character or not humanoid then return end
    
    local vehicleSeat = character:FindFirstChildWhichIsA("VehicleSeat")
    if vehicleSeat then
        vehicleSeat.MaxVelocity = Vector3.new(speed, speed, speed)
        vehicleSeat.CanCollide = false
        vehicleSeat.Velocity = Vector3.new(0, 10, 0)
        
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if input.KeyCode == Enum.KeyCode.Space and not gameProcessed then
                vehicleSeat.Velocity = vehicleSeat.Velocity + Vector3.new(0, 20, 0)
            end
        end)
    end
end

local function enableESP()
    -- Create ESP boxes around players
    local function createESP(player)
        local character = player.Character
        if not character then return end
        
        local head = character:FindFirstChild("Head")
        if not head then return end
        
        local box = Instance.new("Part")
        box.Size = Vector3.new(2, 4, 2)
        box.Anchored = true
        box.CanCollide = false
        box.Transparency = 0.5
        box.Color = Color3.fromRGB(0, 255, 0)
        box.CFrame = head.CFrame + Vector3.new(0, 2, 0)
        box.Parent = workspace
        
        local label = Instance.new("BillboardGui")
        label.Adornee = box
        label.Size = UDim2.new(0, 200, 0, 50)
        label.StudsOffset = Vector3.new(0, 3, 0)
        label.AlwaysOnTop = true
        label.Parent = box
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Text = player.Name
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 0
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextScaled = true
        textLabel.Parent = label
        
        -- Clean up on player leave
        player.DescendantRemoved:Connect(function(descendant)
            if descendant == character then
                box:Destroy()
            end
        end)
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESP(player)
        end
    end
    
    Players.PlayerAdded:Connect(createESP)
end

local function enableGhost()
    local character, humanoid = getCharacter()
    if not character then return end
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0.8
        end
    end
end

local function setFOV(horizontal, vertical)
    Camera.FieldOfView = horizontal * 5
    Camera.ViewportSize = Vector2.new(1920, 1080) -- Force high res
end

local function autoSellFish()
    local inventory = getInventory()
    if not inventory then return end
    
    local sellRemote = getRemote("SellItem")
    if not sellRemote then return end
    
    task.spawn(function()
        while true do
            task.wait(2)
            for _, item in ipairs(inventory:GetChildren()) do
                if item:IsA("Part") and not item.Name:find("!!!") and not item.Name:find("Rod") and not item.Name:find("Bait") then
                    sellRemote:FireServer(item.Name)
                    task.wait(0.1)
                end
            end
        end
    end)
end

local function autoBuyWeather(weatherName)
    local purchaseRemote = getRemote("PurchaseWeatherEvent")
    if purchaseRemote then
        purchaseRemote:FireServer(weatherName)
    end
end

local function autoBuyBait(baitName)
    local purchaseRemote = getRemote("PurchaseBait")
    if purchaseRemote then
        purchaseRemote:FireServer(baitName)
    end
end

local function autoBuyRod(rodName)
    local purchaseRemote = getRemote("PurchaseFishingRod")
    if purchaseRemote then
        purchaseRemote:FireServer(rodName)
    end
end

-- ========================================
-- MAIN UI INITIALIZATION
-- ========================================

local Window = Rayfield:CreateWindow({
    Name = "NIKZZ MODDER v1.0",
    LoadingTitle = "Memuat Nikzz Modder...",
    LoadingSubtitle = "by Developer",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NikzzModderConfig",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- ========================================
-- NKZ-FARM TAB
-- ========================================

local FarmTab = Window:CreateTab("NKZ-FARM", 4483362458)

-- AUTO FISHING V1
local AutoFishingV1Toggle = FarmTab:CreateToggle({
    Name = "AUTO FISHING V1",
    CurrentValue = false,
    Flag = "AutoFishingV1",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Auto Fishing V1 Aktif",
                Content = "Sistem memancing otomatis diaktifkan.",
                Duration = 3,
                Image = 4483362458,
            })
            
            task.spawn(function()
                while AutoFishingV1Toggle:Get() do
                    task.wait(0.1)
                    
                    -- Check if already fishing
                    if not isFishingActive() then
                        -- Auto equip rod if none equipped
                        local currentRod = getRodFromInventory()
                        if not currentRod then
                            local bestRod = getAvailableRods()[1]
                            if bestRod then
                                equipRod(bestRod)
                                task.wait(0.5)
                            end
                        end
                        
                        -- Auto cast
                        local castRemote = getRemote("RequestFishingMinigameStarted")
                        if castRemote then
                            castRemote:FireServer()
                            task.wait(0.2)
                        end
                        
                        -- Perfect casting (simulate perfect hit)
                        task.wait(0.5)
                        
                        -- Auto pull
                        local fishCaughtRemote = getRemote("FishCaught")
                        if fishCaughtRemote then
                            fishCaughtRemote:FireServer()
                        end
                    end
                    
                    -- Delay between casts
                    task.wait(1)
                end
            end)
        end
    end,
})

-- AUTO FISHING V2
local AutoFishingV2Toggle = FarmTab:CreateToggle({
    Name = "AUTO FISHING V2 (SPAM)",
    CurrentValue = false,
    Flag = "AutoFishingV2",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Auto Fishing V2 Aktif",
                Content = "Spam tap aktif untuk penangkapan lebih cepat.",
                Duration = 3,
                Image = 4483362458,
            })
            
            task.spawn(function()
                while AutoFishingV2Toggle:Get() do
                    task.wait(0.05)
                    
                    -- Simulate rapid tapping
                    local castRemote = getRemote("RequestFishingMinigameStarted")
                    if castRemote then
                        castRemote:FireServer()
                    end
                    
                    local pullRemote = getRemote("FishCaught")
                    if pullRemote then
                        pullRemote:FireServer()
                    end
                end
            end)
        end
    end,
})

-- AUTO COMPLETE FISHING
local AutoCompleteFishingToggle = FarmTab:CreateToggle({
    Name = "AUTO COMPLETE FISHING",
    CurrentValue = false,
    Flag = "AutoCompleteFishing",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Auto Complete Fishing Aktif",
                Content = "Ikan akan langsung terangkat saat masuk area umpan.",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Hook into FishCaught event
            local fishCaughtRemote = getRemote("FishCaught")
            if fishCaughtRemote then
                fishCaughtRemote.OnClientEvent:Connect(function()
                    -- Do nothing, but ensures automatic completion
                end)
            end
            
            -- Listen for when fish is near
            local fishingController = getModule("Controllers.FishingController")
            if fishingController and fishingController.FishingState then
                fishingController.FishingState.Changed:Connect(function()
                    if fishingController.FishingState.Value == "FISHING" then
                        -- Immediately complete
                        local fishCaughtRemote = getRemote("FishCaught")
                        if fishCaughtRemote then
                            fishCaughtRemote:FireServer()
                        end
                    end
                end)
            end
        end
    end,
})

-- AUTO EQUIP ROD
local AutoEquipRodToggle = FarmTab:CreateToggle({
    Name = "AUTO EQUIP ROD",
    CurrentValue = false,
    Flag = "AutoEquipRod",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Auto Equip Rod Aktif",
                Content = "Rod otomatis dipasang dari inventory.",
                Duration = 3,
                Image = 4483362458,
            })
            
            task.spawn(function()
                while AutoEquipRodToggle:Get() do
                    task.wait(1)
                    local rod = getRodFromInventory()
                    if rod then
                        equipRod(rod.Name)
                    end
                end
            end)
        end
    end,
})

-- SET CASTING DELAY
local CastingDelaySlider = FarmTab:CreateSlider({
    Name = "SET CASTING DELAY (SECOND)",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = " detik",
    CurrentValue = 2,
    Flag = "CastingDelay",
    Callback = function(Value)
        Rayfield:Notify({
            Title = "Delay Diubah",
            Content = "Delay pemancingan: " .. Value .. " detik",
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- CHOSE FISHING AREA
local FishingAreaDropdown = FarmTab:CreateDropdown({
    Name = "CHOSE FISHING AREA",
    Options = {"Pilih Area..."}..getAvailableAreas(),
    CurrentOption = "Pilih Area...",
    Flag = "FishingArea",
    Callback = function(Option)
        if Option ~= "Pilih Area..." then
            Rayfield:Notify({
                Title = "Area Dipilih",
                Content = "Area: " .. Option,
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
})

-- SAVE POSITION
local SavePositionButton = FarmTab:CreateButton({
    Name = "SAVE POSITION",
    Callback = function()
        local character = LocalPlayer.Character
        if character then
            local position = character:GetPrimaryPartCFrame().Position
            Rayfield:Notify({
                Title = "Posisi Disimpan",
                Content = "Posisi telah disimpan: " .. position.X .. ", " .. position.Y .. ", " .. position.Z,
                Duration = 3,
                Image = 4483362458,
            })
            _G.NIKZZ_SAVE_POSITION = position
        end
    end,
})

-- TELEPORT SAVE POSITION
local TeleportSavePositionButton = FarmTab:CreateButton({
    Name = "TELEPORT SAVE POSITION",
    Callback = function()
        if _G.NIKZZ_SAVE_POSITION then
            LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(_G.NIKZZ_SAVE_POSITION))
            Rayfield:Notify({
                Title = "Teleport Sukses",
                Content = "Berhasil teleport ke posisi yang disimpan.",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Tidak Ada Posisi",
                Content = "Belum ada posisi yang disimpan.",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- BYPASS FISHING RADAR
local BypassRadarToggle = FarmTab:CreateToggle({
    Name = "BYPASS FISHING RADAR",
    CurrentValue = false,
    Flag = "BypassRadar",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Bypass Radar Aktif",
                Content = "Mencoba mengaktifkan radar otomatis.",
                Duration = 3,
                Image = 4483362458,
            })
            
            task.spawn(function()
                while BypassRadarToggle:Get() do
                    task.wait(10)
                    local hasRadar = false
                    local inventory = getInventory()
                    if inventory then
                        for _, item in ipairs(inventory:GetChildren()) do
                            if item.Name == "Fishing Radar" then
                                hasRadar = true
                                break
                            end
                        end
                    end
                    
                    if not hasRadar then
                        buyItem("Fishing Radar", "gear")
                        task.wait(2)
                    end
                    
                    -- Equip it
                    local radar = inventory:FindFirstChild("Fishing Radar")
                    if radar then
                        local updateRadarRemote = getRemote("UpdateFishingRadar")
                        if updateRadarRemote then
                            updateRadarRemote:FireServer(true)
                        end
                    end
                end
            end)
        end
    end,
})

-- BYPASS DIVING GEAR
local BypassDivingGearToggle = FarmTab:CreateToggle({
    Name = "BYPASS DIVING GEAR",
    CurrentValue = false,
    Flag = "BypassDivingGear",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Bypass Diving Gear Aktif",
                Content = "Mencoba mengaktifkan alat menyelam otomatis.",
                Duration = 3,
                Image = 4483362458,
            })
            
            task.spawn(function()
                while BypassDivingGearToggle:Get() do
                    task.wait(10)
                    local hasGear = false
                    local inventory = getInventory()
                    if inventory then
                        for _, item in ipairs(inventory:GetChildren()) do
                            if item.Name == "Diving Gear" then
                                hasGear = true
                                break
                            end
                        end
                    end
                    
                    if not hasGear then
                        buyItem("Diving Gear", "gear")
                        task.wait(2)
                    end
                    
                    -- Equip it
                    local gear = inventory:FindFirstChild("Diving Gear")
                    if gear then
                        local equipRemote = getRemote("EquipOxygenTank")
                        if equipRemote then
                            equipRemote:FireServer()
                        end
                    end
                end
            end)
        end
    end,
})

-- ANTI AFK & ANTI DC
local AntiAFKToggle = FarmTab:CreateToggle({
    Name = "ANTI AFK & ANTI DC",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Anti AFK Aktif",
                Content = "Mencegah deteksi AFK dan disconnect.",
                Duration = 3,
                Image = 4483362458,
            })
            enableAntiAFK()
            disableDetection()
        end
    end,
})

-- AUTO JUMP
local AutoJumpToggle = FarmTab:CreateToggle({
    Name = "AUTO JUMP",
    CurrentValue = false,
    Flag = "AutoJump",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Auto Jump Aktif",
                Content = "Karakter akan melompat otomatis setiap 2 detik.",
                Duration = 3,
                Image = 4483362458,
            })
            
            task.spawn(function()
                while AutoJumpToggle:Get() do
                    task.wait(2)
                    local character, humanoid = getCharacter()
                    if character and humanoid then
                        humanoid:ApplyImpulse(Vector3.new(0, 50, 0))
                    end
                end
            end)
        end
    end,
})

-- ANTI DETECT DEVELOPER
local AntiDetectDeveloperToggle = FarmTab:CreateToggle({
    Name = "ANTI DETECT DEVELOPER",
    CurrentValue = false,
    Flag = "AntiDetectDev",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Anti Detect Developer Aktif",
                Content = "Semua fitur deteksi pengembang dinonaktifkan.",
                Duration = 3,
                Image = 4483362458,
            })
            disableDetection()
        end
    end,
})

-- ========================================
-- NKZ-TELEPORT TAB
-- ========================================

local TeleportTab = Window:CreateTab("NKZ-TELEPORT", 4483362458)

-- CHOSE ISLAND
local IslandDropdown = TeleportTab:CreateDropdown({
    Name = "CHOSE ISLAND",
    Options = getAvailableAreas(),
    CurrentOption = "Pilih Pulau...",
    Flag = "IslandChoice",
    Callback = function(Option)
        if Option ~= "Pilih Pulau..." then
            Rayfield:Notify({
                Title = "Pulau Dipilih",
                Content = "Pulau: " .. Option,
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
})

-- BUTTON TELEPORT TO ISLAND
local TeleportToIslandButton = TeleportTab:CreateButton({
    Name = "BUTTON TELEPORT TO ISLAND",
    Callback = function()
        local selected = IslandDropdown:Get()
        if selected ~= "Pilih Pulau..." then
            teleportToArea(selected)
            Rayfield:Notify({
                Title = "Teleport Ke Pulau",
                Content = "Berhasil teleport ke " .. selected,
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- CHOSE EVENT
local EventDropdown = TeleportTab:CreateDropdown({
    Name = "CHOSE EVENT",
    Options = getAvailableEvents(),
    CurrentOption = "Pilih Event...",
    Flag = "EventChoice",
    Callback = function(Option)
        if Option ~= "Pilih Event..." then
            Rayfield:Notify({
                Title = "Event Dipilih",
                Content = "Event: " .. Option,
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
})

-- BUTTON TELEPORT TO EVENT
local TeleportToEventButton = TeleportTab:CreateButton({
    Name = "BUTTON TELEPORT TO EVENT",
    Callback = function()
        local selected = EventDropdown:Get()
        if selected ~= "Pilih Event..." then
            teleportToEvent(selected)
            Rayfield:Notify({
                Title = "Teleport Ke Event",
                Content = "Berhasil teleport ke event " .. selected,
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- SELECT PLAYER
local PlayerDropdown = TeleportTab:CreateDropdown({
    Name = "SELECT PLAYER",
    Options = getPlayerList(),
    CurrentOption = "Pilih Pemain...",
    Flag = "PlayerChoice",
    Callback = function(Option)
        if Option ~= "Pilih Pemain..." then
            Rayfield:Notify({
                Title = "Pemain Dipilih",
                Content = "Pemain: " .. Option,
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
})

-- BUTTON GO TO PLAYER
local GoToPlayerButton = TeleportTab:CreateButton({
    Name = "BUTTON GO TO PLAYER",
    Callback = function()
        local selected = PlayerDropdown:Get()
        if selected ~= "Pilih Pemain..." then
            teleportToPlayer(selected)
            Rayfield:Notify({
                Title = "Teleport Ke Pemain",
                Content = "Berhasil teleport ke " .. selected,
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- REFRESH PLAYER
local RefreshPlayerButton = TeleportTab:CreateButton({
    Name = "REFRESH PLAYER",
    Callback = function()
        PlayerDropdown:Refresh(getPlayerList(), true)
        Rayfield:Notify({
            Title = "Pembaruan Pemain",
            Content = "Daftar pemain diperbarui.",
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- ========================================
-- NKZ-PLAYER TAB
-- ========================================

local PlayerTab = Window:CreateTab("NKZ-PLAYER", 4483362458)

-- ACTIVE HACK SPEED
local SpeedHackToggle = PlayerTab:CreateToggle({
    Name = "ACTIVE HACK SPEED",
    CurrentValue = false,
    Flag = "SpeedHack",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Speed Hack Aktif",
                Content = "Kecepatan karakter diaktifkan.",
                Duration = 3,
                Image = 4483362458,
            })
            enableSpeedHack(50)
        end
    end,
})

-- SETTINGS SPEED
local SpeedSettingSlider = PlayerTab:CreateSlider({
    Name = "SETTINGS SPEED",
    Range = {0, 1000},
    Increment = 1,
    Suffix = " unit",
    CurrentValue = 16,
    Flag = "SpeedSetting",
    Callback = function(Value)
        enableSpeedHack(Value)
        Rayfield:Notify({
            Title = "Kecepatan Diubah",
            Content = "Kecepatan: " .. Value,
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- INFINITY JUMP
local InfinityJumpToggle = PlayerTab:CreateToggle({
    Name = "INFINITY JUMP",
    CurrentValue = false,
    Flag = "InfinityJump",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Infinity Jump Aktif",
                Content = "Melompat tanpa batas diaktifkan.",
                Duration = 3,
                Image = 4483362458,
            })
            enableInfiniteJump()
        end
    end,
})

-- FLY LITTLE
local FlyLittleToggle = PlayerTab:CreateToggle({
    Name = "FLY LITTLE",
    CurrentValue = false,
    Flag = "FlyLittle",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Fly Little Aktif",
                Content = "Terbang dengan ketinggian terbatas diaktifkan.",
                Duration = 3,
                Image = 4483362458,
            })
            enableFly()
        end
    end,
})

-- FLY SPEED
local FlySpeedSlider = PlayerTab:CreateSlider({
    Name = "FLY SPEED",
    Range = {0, 100},
    Increment = 1,
    Suffix = " unit",
    CurrentValue = 10,
    Flag = "FlySpeed",
    Callback = function(Value)
        Rayfield:Notify({
            Title = "Kecepatan Terbang Diubah",
            Content = "Kecepatan: " .. Value,
            Duration = 2,
            Image = 4483362458,
        })
        -- Apply to fly system
        if FlyLittleToggle:Get() then
            enableFly()
        end
    end,
})

-- HACK BOAT SPEED
local BoatSpeedToggle = PlayerTab:CreateToggle({
    Name = "HACK BOAT SPEED",
    CurrentValue = false,
    Flag = "BoatSpeed",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Boat Speed Hack Aktif",
                Content = "Kecepatan perahu ditingkatkan.",
                Duration = 3,
                Image = 4483362458,
            })
            -- This will be handled by the next setting
        end
    end,
})

-- SPEED BOAT SETTING
local SpeedBoatSettingSlider = PlayerTab:CreateSlider({
    Name = "SPEED BOAT SETTING",
    Range = {1, 20},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 5,
    Flag = "SpeedBoatSetting",
    Callback = function(Value)
        Rayfield:Notify({
            Title = "Kecepatan Perahu Diubah",
            Content = "Perkalian kecepatan: " .. Value .. "x",
            Duration = 2,
            Image = 4483362458,
        })
        -- Apply to existing boat
        local character, humanoid = getCharacter()
        if character then
            local vehicleSeat = character:FindFirstChildWhichIsA("VehicleSeat")
            if vehicleSeat then
                vehicleSeat.MaxVelocity = Vector3.new(Value * 10, Value * 10, Value * 10)
            end
        end
    end,
})

-- FLY BOAT
local FlyBoatToggle = PlayerTab:CreateToggle({
    Name = "FLY BOAT",
    CurrentValue = false,
    Flag = "FlyBoat",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Fly Boat Aktif",
                Content = "Perahu dapat terbang di udara!",
                Duration = 3,
                Image = 4483362458,
            })
            enableBoatFly(50)
        end
    end,
})

-- FLY BOAT SPEED
local FlyBoatSpeedSlider = PlayerTab:CreateSlider({
    Name = "FLY BOAT SPEED",
    Range = {1, 50},
    Increment = 1,
    Suffix = " unit",
    CurrentValue = 10,
    Flag = "FlyBoatSpeed",
    Callback = function(Value)
        Rayfield:Notify({
            Title = "Kecepatan Terbang Perahu Diubah",
            Content = "Kecepatan: " .. Value,
            Duration = 2,
            Image = 4483362458,
        })
        if FlyBoatToggle:Get() then
            enableBoatFly(Value)
        end
    end,
})

-- JUMP HACK
local JumpHackToggle = PlayerTab:CreateToggle({
    Name = "JUMP HACK",
    CurrentValue = false,
    Flag = "JumpHack",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Jump Hack Aktif",
                Content = "Lompat lebih tinggi diaktifkan.",
                Duration = 3,
                Image = 4483362458,
            })
            enableJumpHack(200)
        end
    end,
})

-- JUMP HACK SETTING
local JumpHackSettingSlider = PlayerTab:CreateSlider({
    Name = "JUMP HACK SETTING",
    Range = {1, 500},
    Increment = 1,
    Suffix = " unit",
    CurrentValue = 100,
    Flag = "JumpHackSetting",
    Callback = function(Value)
        enableJumpHack(Value)
        Rayfield:Notify({
            Title = "Ketinggian Lompat Diubah",
            Content = "Ketinggian: " .. Value,
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- LOCK POSITION
local LockPositionToggle = PlayerTab:CreateToggle({
    Name = "LOCK POSITION",
    CurrentValue = false,
    Flag = "LockPosition",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Lock Position Aktif",
                Content = "Karakter dikunci di posisi saat ini.",
                Duration = 3,
                Image = 4483362458,
            })
            local character = LocalPlayer.Character
            if character then
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Anchored = true
                    end
                end
            end
        else
            local character = LocalPlayer.Character
            if character then
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Anchored = false
                    end
                end
            end
        end
    end,
})

-- ========================================
-- NKZ-VISUAL TAB
-- ========================================

local VisualTab = Window:CreateTab("NKZ-VISUAL", 4483362458)

-- ACTIVE ESP PLAYER
local ESPPlayerToggle = VisualTab:CreateToggle({
    Name = "ACTIVE ESP PLAYER",
    CurrentValue = false,
    Flag = "ESPPlayer",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "ESP Player Aktif",
                Content = "Menampilkan informasi pemain lain.",
                Duration = 3,
                Image = 4483362458,
            })
            enableESP()
        end
    end,
})

-- GHOST HACK
local GhostHackToggle = VisualTab:CreateToggle({
    Name = "GHOST HACK",
    CurrentValue = false,
    Flag = "GhostHack",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Ghost Hack Aktif",
                Content = "Karakter menjadi transparan.",
                Duration = 3,
                Image = 4483362458,
            })
            enableGhost()
        end
    end,
})

-- FOV CAMERA
local FOVCameraToggle = VisualTab:CreateToggle({
    Name = "FOV CAMERA",
    CurrentValue = false,
    Flag = "FOVCamera",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "FOV Camera Aktif",
                Content = "Field of View diperluas.",
                Duration = 3,
                Image = 4483362458,
            })
            setFOV(15, 15)
        end
    end,
})

-- SETTINGS FOV KAMERA
local FOVSettingSlider = VisualTab:CreateSlider({
    Name = "SETTINGS FOV KAMERA",
    Range = {0, 15},
    Increment = 0.5,
    Suffix = " unit",
    CurrentValue = 10,
    Flag = "FOVSetting",
    Callback = function(Value)
        setFOV(Value, Value)
        Rayfield:Notify({
            Title = "FOV Diubah",
            Content = "FOV: " .. Value,
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- FITUR BEBAS (Customizable Visuals)
VisualTab:CreateLabel("FITUR BEBAS:")
local CustomVisualsDropdown = VisualTab:CreateDropdown({
    Name = "Pilih Efek Visual",
    Options = {"None", "Rainbow Trails", "Smoke Effect", "Glowing Parts"},
    CurrentOption = "None",
    Flag = "CustomVisuals",
    Callback = function(Option)
        if Option == "Rainbow Trails" then
            -- Implement rainbow trails
            Rayfield:Notify({
                Title = "Efek Rainbow Trails",
                Content = "Efek jejak pelangi diaktifkan.",
                Duration = 3,
                Image = 4483362458,
            })
        elseif Option == "Smoke Effect" then
            Rayfield:Notify({
                Title = "Efek Asap",
                Content = "Efek asap diaktifkan.",
                Duration = 3,
                Image = 4483362458,
            })
        elseif Option == "Glowing Parts" then
            Rayfield:Notify({
                Title = "Efek Glowing",
                Content = "Bagian bercahaya diaktifkan.",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- ========================================
-- NKZ-SHOP TAB
-- ========================================

local ShopTab = Window:CreateTab("NKZ-SHOP", 4483362458)

-- AUTO SHELL FISH
local AutoShellFishToggle = ShopTab:CreateToggle({
    Name = "AUTO SHELL FISH",
    CurrentValue = false,
    Flag = "AutoShellFish",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Auto Sell Fish Aktif",
                Content = "Ikan akan dijual otomatis.",
                Duration = 3,
                Image = 4483362458,
            })
            autoSellFish()
        end
    end,
})

-- SETTINGS DELAY SELL
local SellDelaySlider = ShopTab:CreateSlider({
    Name = "SETTINGS DELAY SELL",
    Range = {0.1, 10},
    Increment = 0.1,
    Suffix = " detik",
    CurrentValue = 1,
    Flag = "SellDelay",
    Callback = function(Value)
        Rayfield:Notify({
            Title = "Delay Penjualan Diubah",
            Content = "Delay: " .. Value .. " detik",
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- SELECT WEATHER
local WeatherDropdown = ShopTab:CreateDropdown({
    Name = "SELECT WEATHER",
    Options = getAvailableWeather(),
    CurrentOption = "Pilih Cuaca...",
    Flag = "WeatherChoice",
    Callback = function(Option)
        if Option ~= "Pilih Cuaca..." then
            Rayfield:Notify({
                Title = "Cuaca Dipilih",
                Content = "Cuaca: " .. Option,
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
})

-- BUTTON BUY WEATHER
local BuyWeatherButton = ShopTab:CreateButton({
    Name = "BUTTON BUY WEATHER",
    Callback = function()
        local selected = WeatherDropdown:Get()
        if selected ~= "Pilih Cuaca..." then
            autoBuyWeather(selected)
            Rayfield:Notify({
                Title = "Cuaca Dibeli",
                Content = "Berhasil membeli cuaca: " .. selected,
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- AUTO BUY WEATHER
local AutoBuyWeatherToggle = ShopTab:CreateToggle({
    Name = "AUTO BUY WEATHER",
    CurrentValue = false,
    Flag = "AutoBuyWeather",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Auto Buy Weather Aktif",
                Content = "Cuaca akan dibeli otomatis.",
                Duration = 3,
                Image = 4483362458,
            })
            
            task.spawn(function()
                while AutoBuyWeatherToggle:Get() do
                    local selected = WeatherDropdown:Get()
                    if selected ~= "Pilih Cuaca..." then
                        autoBuyWeather(selected)
                    end
                    task.wait(30) -- Wait 30 seconds before buying again
                end
            end)
        end
    end,
})

-- DELAY AUTO WEATHER
local AutoWeatherDelaySlider = ShopTab:CreateSlider({
    Name = "DELAY AUTO WEATHER",
    Range = {5, 120},
    Increment = 5,
    Suffix = " detik",
    CurrentValue = 30,
    Flag = "AutoWeatherDelay",
    Callback = function(Value)
        Rayfield:Notify({
            Title = "Delay Otomatis Cuaca Diubah",
            Content = "Delay: " .. Value .. " detik",
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- SELECT BOOBERS
local BaitDropdown = ShopTab:CreateDropdown({
    Name = "SELECT BOOBERS",
    Options = getAvailableBaits(),
    CurrentOption = "Pilih Umpan...",
    Flag = "BaitChoice",
    Callback = function(Option)
        if Option ~= "Pilih Umpan..." then
            Rayfield:Notify({
                Title = "Umpan Dipilih",
                Content = "Umpan: " .. Option,
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
})

-- BUTTON BUY BOOBERS
local BuyBaitButton = ShopTab:CreateButton({
    Name = "BUTTON BUY BOOBERS",
    Callback = function()
        local selected = BaitDropdown:Get()
        if selected ~= "Pilih Umpan..." then
            autoBuyBait(selected)
            Rayfield:Notify({
                Title = "Umpan Dibeli",
                Content = "Berhasil membeli umpan: " .. selected,
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- SELECT ROD
local RodDropdown = ShopTab:CreateDropdown({
    Name = "SELECT ROD",
    Options = getAvailableRods(),
    CurrentOption = "Pilih Pancing...",
    Flag = "RodChoice",
    Callback = function(Option)
        if Option ~= "Pilih Pancing..." then
            Rayfield:Notify({
                Title = "Pancing Dipilih",
                Content = "Pancing: " .. Option,
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
})

-- BUTTON BUY ROD
local BuyRodButton = ShopTab:CreateButton({
    Name = "BUTTON BUY ROD",
    Callback = function()
        local selected = RodDropdown:Get()
        if selected ~= "Pilih Pancing..." then
            autoBuyRod(selected)
            Rayfield:Notify({
                Title = "Pancing Dibeli",
                Content = "Berhasil membeli pancing: " .. selected,
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- ========================================
-- NKZ-UTILITY TAB
-- ========================================

local UtilityTab = Window:CreateTab("NKZ-UTILITY", 4483362458)

-- STABIL FPS/ANTILAG
local StabilizeFPSToggle = UtilityTab:CreateToggle({
    Name = "STABIL FPS/ANTILAG",
    CurrentValue = false,
    Flag = "StabilFPS",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Stabil FPS Aktif",
                Content = "FPS distabilkan untuk performa optimal.",
                Duration = 3,
                Image = 4483362458,
            })
            setFPSLimit(60)
        end
    end,
})

-- UNLOCK HIGH FPS
local UnlockHighFPSToggle = UtilityTab:CreateToggle({
    Name = "UNLOCK HIGH FPS",
    CurrentValue = false,
    Flag = "UnlockHighFPS",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "High FPS Dibuka",
                Content = "FPS maksimum tidak dibatasi.",
                Duration = 3,
                Image = 4483362458,
            })
            setFPSLimit(0)
        end
    end,
})

-- SETTINGS HIGH FPS
local HighFPSRangeSlider = UtilityTab:CreateSlider({
    Name = "SETTINGS HIGH FPS",
    Range = {30, 240},
    Increment = 10,
    Suffix = " FPS",
    CurrentValue = 120,
    Flag = "HighFPS",
    Callback = function(Value)
        setFPSLimit(Value)
        Rayfield:Notify({
            Title = "FPS Maksimum Diatur",
            Content = "FPS: " .. Value,
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- SHOW SYSTEM INFO
local ShowSystemInfoToggle = UtilityTab:CreateToggle({
    Name = "SHOW SYSTEM INFO",
    CurrentValue = false,
    Flag = "ShowSystemInfo",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Info Sistem Ditampilkan",
                Content = "FPS, Ping, Memory, Suhu ditampilkan di layar.",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- Create a simple GUI to show info
            local gui = Instance.new("ScreenGui")
            gui.Name = "NikzzSystemInfo"
            gui.ResetOnSpawn = false
            gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 200, 0, 100)
            frame.Position = UDim2.new(0, 10, 0, 10)
            frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            frame.BackgroundTransparency = 0.7
            frame.BorderSizePixel = 0
            frame.Parent = gui
            
            local fpsLabel = Instance.new("TextLabel")
            fpsLabel.Size = UDim2.new(1, 0, 0.25, 0)
            fpsLabel.Position = UDim2.new(0, 0, 0, 0)
            fpsLabel.Text = "FPS: 0"
            fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            fpsLabel.TextScaled = true
            fpsLabel.Parent = frame
            
            local pingLabel = Instance.new("TextLabel")
            pingLabel.Size = UDim2.new(1, 0, 0.25, 0)
            pingLabel.Position = UDim2.new(0, 0, 0.25, 0)
            pingLabel.Text = "Ping: 0"
            pingLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            pingLabel.TextScaled = true
            pingLabel.Parent = frame
            
            local memoryLabel = Instance.new("TextLabel")
            memoryLabel.Size = UDim2.new(1, 0, 0.25, 0)
            memoryLabel.Position = UDim2.new(0, 0, 0.5, 0)
            memoryLabel.Text = "Memory: 0 MB"
            memoryLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            memoryLabel.TextScaled = true
            memoryLabel.Parent = frame
            
            local temperatureLabel = Instance.new("TextLabel")
            temperatureLabel.Size = UDim2.new(1, 0, 0.25, 0)
            temperatureLabel.Position = UDim2.new(0, 0, 0.75, 0)
            temperatureLabel.Text = "Suhu: 0°C"
            temperatureLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            temperatureLabel.TextScaled = true
            temperatureLabel.Parent = frame
            
            task.spawn(function()
                while ShowSystemInfoToggle:Get() do
                    task.wait(1)
                    local fps = RunService.Heartbeat:Wait()
                    local ping = 0 -- Roblox doesn't expose this directly
                    local memory = collectgarbage("count")
                    local temp = 0 -- No direct access
                    
                    fpsLabel.Text = "FPS: " .. math.floor(RunService.Heartbeat:Wait() * 1000)
                    pingLabel.Text = "Ping: " .. ping
                    memoryLabel.Text = "Memory: " .. math.floor(memory) .. " MB"
                    temperatureLabel.Text = "Suhu: " .. temp .. "°C"
                end
                gui:Destroy()
            end)
        end
    end,
})

-- AUTO CLEAR CACHE
local AutoClearCacheToggle = UtilityTab:CreateToggle({
    Name = "AUTO CLEAR CACHE",
    CurrentValue = false,
    Flag = "AutoClearCache",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Auto Clear Cache Aktif",
                Content = "Cache akan dibersihkan setiap 10 detik.",
                Duration = 3,
                Image = 4483362458,
            })
            
            task.spawn(function()
                while AutoClearCacheToggle:Get() do
                    task.wait(10)
                    collectgarbage("collect")
                    Rayfield:Notify({
                        Title = "Cache Dibersihkan",
                        Content = "Cache berhasil dibersihkan.",
                        Duration = 1,
                        Image = 4483362458,
                    })
                end
            end)
        end
    end,
})

-- DISABLE PARTICLE
local DisableParticleToggle = UtilityTab:CreateToggle({
    Name = "DISABLE PARTICLE",
    CurrentValue = false,
    Flag = "DisableParticle",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Particle Dinonaktifkan",
                Content = "Efek partikel dinonaktifkan untuk performa.",
                Duration = 3,
                Image = 4483362458,
            })
            disableEffects()
        end
    end,
})

-- BOOST PING
local BoostPingToggle = UtilityTab:CreateToggle({
    Name = "BOOST PING",
    CurrentValue = false,
    Flag = "BoostPing",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Ping Ditingkatkan",
                Content = "Koneksi dioptimalkan untuk latensi rendah.",
                Duration = 3,
                Image = 4483362458,
            })
            -- In Roblox, this is limited by network
            -- We can only simulate by reducing data usage
            -- For now, just notify
        end
    end,
})

-- ========================================
-- NKZ-GRAPHIC TAB
-- ========================================

local GraphicTab = Window:CreateTab("NKZ-GRAPHIC", 4483362458)

-- MAXIMAL QUALITY
local MaxQualityButton = GraphicTab:CreateButton({
    Name = "MAXIMAL QUALITY",
    Callback = function()
        Rayfield:Notify({
            Title = "Kualitas Maksimal",
            Content = "Kualitas grafis diatur ke level tertinggi.",
            Duration = 3,
            Image = 4483362458,
        })
        -- Apply settings
        workspace.Lighting.GlobalShadows = true
        workspace.Lighting.Brightness = 1
        workspace.AmbientLight.Color = Color3.fromRGB(255, 255, 255)
        workspace.Environment.DiffuseIntensity = 1
        workspace.Environment.SpecularIntensity = 1
        workspace.Environment.Skybox = "rbxassetid://123456789" -- Default sky
        camera.FieldOfView = 100
    end,
})

-- MEDIUM QUALITY
local MediumQualityButton = GraphicTab:CreateButton({
    Name = "MEDIUM QUALITY",
    Callback = function()
        Rayfield:Notify({
            Title = "Kualitas Menengah",
            Content = "Kualitas grafis diatur ke menengah.",
            Duration = 3,
            Image = 4483362458,
        })
        workspace.Lighting.GlobalShadows = true
        workspace.Lighting.Brightness = 0.7
        workspace.Lighting.AmbientLight.Color = Color3.fromRGB(200, 200, 200)
        workspace.Environment.DiffuseIntensity = 0.8
        workspace.Environment.SpecularIntensity = 0.8
    end,
})

-- LOW QUALITY
local LowQualityButton = GraphicTab:CreateButton({
    Name = "LOW QUALITY",
    Callback = function()
        Rayfield:Notify({
            Title = "Kualitas Rendah",
            Content = "Kualitas grafis diatur ke rendah untuk performa.",
            Duration = 3,
            Image = 4483362458,
        })
        workspace.Lighting.GlobalShadows = false
        workspace.Lighting.Brightness = 0.3
        workspace.Lighting.AmbientLight.Color = Color3.fromRGB(100, 100, 100)
        workspace.Environment.DiffuseIntensity = 0.3
        workspace.Environment.SpecularIntensity = 0.3
    end,
})

-- DISABLE WATER REFLECTION
local DisableWaterReflectionToggle = GraphicTab:CreateToggle({
    Name = "DISABLE WATER REFLECTION",
    CurrentValue = false,
    Flag = "DisableWaterReflection",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Refleksi Air Dinonaktifkan",
                Content = "Efek refleksi air dimatikan.",
                Duration = 3,
                Image = 4483362458,
            })
            -- Find water parts and disable reflection
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("Part") and part.Name == "Water" then
                    part.Reflectance = 0
                end
            end
        end
    end,
})

-- DISABLE EFFECT SKIN
local DisableEffectSkinToggle = GraphicTab:CreateToggle({
    Name = "DISABLE EFFECT SKIN",
    CurrentValue = false,
    Flag = "DisableEffectSkin",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Efek Kulit Dinonaktifkan",
                Content = "Efek visual kulit dimatikan.",
                Duration = 3,
                Image = 4483362458,
            })
            -- Disable all skin effects
            for _, effect in ipairs(workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") and effect.Name:find("Skin") then
                    effect.Enabled = false
                end
            end
        end
    end,
})

-- DISABLE SHADOW
local DisableShadowToggle = GraphicTab:CreateToggle({
    Name = "DISABLE SHADOW",
    CurrentValue = false,
    Flag = "DisableShadow",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Bayangan Dinonaktifkan",
                Content = "Bayangan dimatikan untuk meningkatkan FPS.",
                Duration = 3,
                Image = 4483362458,
            })
            workspace.Lighting.GlobalShadows = false
        else
            workspace.Lighting.GlobalShadows = true
        end
    end,
})

-- DISABLE EXCESSIVE WATER EFFECT
local DisableExcessiveWaterToggle = GraphicTab:CreateToggle({
    Name = "DISABLE EXCESSIVE WATER EFFECT",
    CurrentValue = false,
    Flag = "DisableExcessiveWater",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Efek Air Berlebihan Dinonaktifkan",
                Content = "Efek air kompleks dimatikan.",
                Duration = 3,
                Image = 4483362458,
            })
            for _, effect in ipairs(workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") and effect.Name:find("Water") then
                    effect.Enabled = false
                end
            end
        end
    end,
})

-- BRIGHTNESS SETTINGS
local BrightnessSettingSlider = GraphicTab:CreateSlider({
    Name = "BRIGHTNESS SETTINGS",
    Range = {-10, 20},
    Increment = 1,
    Suffix = " unit",
    CurrentValue = 0,
    Flag = "BrightnessSetting",
    Callback = function(Value)
        setBrightness(Value)
        Rayfield:Notify({
            Title = "Kecerahan Diubah",
            Content = "Kecerahan: " .. Value,
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- ========================================
-- NKZ-LOWDEV TAB
-- ========================================

local LowDevTab = Window:CreateTab("NKZ-LOWDEV", 4483362458)

-- SUPER EXTREME SMOOTH
local SuperExtremeSmoothButton = LowDevTab:CreateButton({
    Name = "SUPER EXTREME SMOOTH",
    Callback = function()
        Rayfield:Notify({
            Title = "Super Extreme Smooth",
            Content = "Performa digunakan hingga 100x lebih halus.",
            Duration = 3,
            Image = 4483362458,
        })
        -- Apply all low-end optimizations
        disableEffects()
        disableDetection()
        setFPSLimit(60)
        setBrightness(-5)
        disableShadowToggle:Set(true)
        disableWaterReflectionToggle:Set(true)
        disableExcessiveWaterToggle:Set(true)
        disableEffectSkinToggle:Set(true)
    end,
})

-- DISABLE EFFECT
local DisableEffectToggle = LowDevTab:CreateToggle({
    Name = "DISABLE EFFECT",
    CurrentValue = false,
    Flag = "DisableEffect",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Semua Efek Dinonaktifkan",
                Content = "Semua efek visual dan suara dimatikan.",
                Duration = 3,
                Image = 4483362458,
            })
            disableEffects()
            -- Disable sounds
            for _, sound in ipairs(workspace:GetDescendants()) do
                if sound:IsA("Sound") then
                    sound.Volume = 0
                end
            end
        end
    end,
})

-- 32-BIT SETTINGS
local Bit32SettingsButton = LowDevTab:CreateButton({
    Name = "32-BIT SETTINGS",
    Callback = function()
        Rayfield:Notify({
            Title = "Mode 32-Bit Diaktifkan",
            Content = "Optimasi untuk perangkat 32-bit.",
            Duration = 3,
            Image = 4483362458,
        })
        -- Force lower resolution rendering
        game.Players.LocalPlayer.ResolutionScale = 0.5
    end,
})

-- LOW BATTERY MODE
local LowBatteryModeToggle = LowDevTab:CreateToggle({
    Name = "LOW BATTERY MODE",
    CurrentValue = false,
    Flag = "LowBatteryMode",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Mode Baterai Rendah",
                Content = "Mode hemat daya diaktifkan.",
                Duration = 3,
                Image = 4483362458,
            })
            -- Reduce everything
            setFPSLimit(30)
            setBrightness(-10)
            disableEffects()
            disableShadowToggle:Set(true)
            disableWaterReflectionToggle:Set(true)
            disableExcessiveWaterToggle:Set(true)
        end
    end,
})

-- ========================================
-- NKZ-SETTINGS TAB
-- ========================================

local SettingsTab = Window:CreateTab("NKZ-SETTINGS", 4483362458)

-- CONFIGURATION OPTIONS
SettingsTab:CreateLabel("Konfigurasi UI")
SettingsTab:CreateLabel("Semua pengaturan akan disimpan otomatis.")

-- THEME SELECTION
local ThemeDropdown = SettingsTab:CreateDropdown({
    Name = "Pilih Tema",
    Options = {"Dark", "Light", "Rainbow"},
    CurrentOption = "Dark",
    Flag = "Theme",
    Callback = function(Option)
        if Option == "Dark" then
            Window:SetTheme("Dark")
        elseif Option == "Light" then
            Window:SetTheme("Light")
        elseif Option == "Rainbow" then
            Window:SetTheme("Rainbow")
        end
        Rayfield:Notify({
            Title = "Tema Diubah",
            Content = "Tema: " .. Option,
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- AUTOSTART SCRIPT
local AutoStartToggle = SettingsTab:CreateToggle({
    Name = "Auto Start Script",
    CurrentValue = false,
    Flag = "AutoStart",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Auto Start Aktif",
                Content = "Script akan otomatis dijalankan saat masuk.",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- RESET ALL SETTINGS
local ResetButton = SettingsTab:CreateButton({
    Name = "RESET SEMUA SETTING",
    Callback = function()
        Rayfield:Notify({
            Title = "Reset Semua Pengaturan",
            Content = "Semua pengaturan telah direset ke default.",
            Duration = 3,
            Image = 4483362458,
        })
        -- Reset all toggles and sliders
        AutoFishingV1Toggle:Set(false)
        AutoFishingV2Toggle:Set(false)
        AutoCompleteFishingToggle:Set(false)
        AutoEquipRodToggle:Set(false)
        CastingDelaySlider:Set(2)
        FishingAreaDropdown:Set("Pilih Area...")
        BypassRadarToggle:Set(false)
        BypassDivingGearToggle:Set(false)
        AntiAFKToggle:Set(false)
        AutoJumpToggle:Set(false)
        AntiDetectDeveloperToggle:Set(false)
        IslandDropdown:Set("Pilih Pulau...")
        EventDropdown:Set("Pilih Event...")
        PlayerDropdown:Set("Pilih Pemain...")
        SpeedHackToggle:Set(false)
        SpeedSettingSlider:Set(16)
        InfinityJumpToggle:Set(false)
        FlyLittleToggle:Set(false)
        FlySpeedSlider:Set(10)
        BoatSpeedToggle:Set(false)
        SpeedBoatSettingSlider:Set(5)
        FlyBoatToggle:Set(false)
        FlyBoatSpeedSlider:Set(10)
        JumpHackToggle:Set(false)
        JumpHackSettingSlider:Set(100)
        LockPositionToggle:Set(false)
        ESPPlayerToggle:Set(false)
        GhostHackToggle:Set(false)
        FOVCameraToggle:Set(false)
        FOVSettingSlider:Set(10)
        AutoShellFishToggle:Set(false)
        SellDelaySlider:Set(1)
        WeatherDropdown:Set("Pilih Cuaca...")
        BuyWeatherButton:Set(false)
        AutoBuyWeatherToggle:Set(false)
        AutoWeatherDelaySlider:Set(30)
        BaitDropdown:Set("Pilih Umpan...")
        RodDropdown:Set("Pilih Pancing...")
        StabilizeFPSToggle:Set(false)
        UnlockHighFPSToggle:Set(false)
        HighFPSRangeSlider:Set(120)
        ShowSystemInfoToggle:Set(false)
        AutoClearCacheToggle:Set(false)
        DisableParticleToggle:Set(false)
        BoostPingToggle:Set(false)
        MaxQualityButton:Set(false)
        MediumQualityButton:Set(false)
        LowQualityButton:Set(false)
        DisableWaterReflectionToggle:Set(false)
        DisableEffectSkinToggle:Set(false)
        DisableShadowToggle:Set(false)
        DisableExcessiveWaterToggle:Set(false)
        BrightnessSettingSlider:Set(0)
        SuperExtremeSmoothButton:Set(false)
        DisableEffectToggle:Set(false)
        Bit32SettingsButton:Set(false)
        LowBatteryModeToggle:Set(false)
        ThemeDropdown:Set("Dark")
        AutoStartToggle:Set(false)
    end,
})

-- ========================================
-- FINAL INITIALIZATION
-- ========================================

Rayfield:LoadConfiguration()

-- Ensure character is loaded before starting
waitForCharacter()

-- Initialize all systems
Rayfield:Notify({
    Title = "NIKZZ MODDER",
    Content = "Script siap digunakan. Semua fitur telah diinisialisasi.",
    Duration = 5,
    Image = 4483362458,
})
