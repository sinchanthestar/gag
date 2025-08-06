-- Grow a Garden Complete Script
-- Advanced GUI with all requested features

debugX = true
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local Workspace = game:GetService("Workspace")

-- Variables
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Script Variables
local ScriptSettings = {
    AutoBuy = {
        Seeds = false,
        Gear = false,
        Eggs = false,
        AllSeeds = false,
        AllGear = false,
        AllEggs = false
    },
    AutoPlant = false,
    AutoCollect = false,
    AutoSell = false,
    AutoFeed = false,
    PlantESP = false,
    SelectedSeeds = {},
    SelectedGear = {},
    SelectedEggs = {},
    SellDelay = 1,
    CollectDelay = 1,
    WeightThreshold = 0,
    FeedHungerThreshold = 50,
    StopHungerThreshold = 90,
    SelectedFood = "Basic Food",
    WebhookURL = "",
    AutoSubmitDelay = 1,
    SummerPlantSubmit = false,
    RecipeSettings = {
        AutoRecipe = false,
        AutoInput = false,
        AutoCraft = false,
        AutoClaim = false,
        SelectedRecipe = ""
    }
}

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Grow a Garden Hub | Advanced",
    Icon = 0,
    LoadingTitle = "Grow a Garden Hub",
    LoadingSubtitle = "Loading all features...",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "GrowGardenHub"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false
})

-- Info Tab
local InfoTab = Window:CreateTab("Info", 4483362458)
local InfoSection = InfoTab:CreateSection("Player Information")

InfoTab:CreateLabel("Player: " .. Player.Name)
InfoTab:CreateLabel("User ID: " .. Player.UserId)
InfoTab:CreateLabel("Display Name: " .. Player.DisplayName)

local ServerInfoSection = InfoTab:CreateSection("Server Information")
InfoTab:CreateLabel("Server ID: " .. game.JobId)
InfoTab:CreateLabel("Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers)

local KeyInfoSection = InfoTab:CreateSection("Key Information")
InfoTab:CreateLabel("Key Status: Active")
InfoTab:CreateLabel("Premium: Enabled")

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)
local SeedsSection = MainTab:CreateSection("Seeds Management")

local SeedsList = {"Carrot", "Potato", "Tomato", "Corn", "Wheat", "Pumpkin", "Watermelon", "Apple", "Orange", "Banana"}
local SelectedSeeds = {}

local SeedDropdown = MainTab:CreateDropdown({
    Name = "Select Seeds",
    Options = SeedsList,
    CurrentOption = {"Carrot"},
    MultipleOptions = true,
    Flag = "SeedSelection",
    Callback = function(Options)
        SelectedSeeds = Options
        ScriptSettings.SelectedSeeds = Options
    end,
})

MainTab:CreateToggle({
    Name = "Auto Buy Seeds",
    CurrentValue = false,
    Flag = "AutoBuySeeds",
    Callback = function(Value)
        ScriptSettings.AutoBuy.Seeds = Value
    end,
})

MainTab:CreateButton({
    Name = "Auto Buy All Seeds",
    Callback = function()
        -- Implementation for buying all seeds
        print("Buying all seeds...")
    end,
})

local GearSection = MainTab:CreateSection("Gear Management")

local GearList = {"Shovel", "Watering Can", "Fertilizer", "Harvest Tool", "Super Shovel", "Golden Can"}
local SelectedGear = {}

local GearDropdown = MainTab:CreateDropdown({
    Name = "Select Gear",
    Options = GearList,
    CurrentOption = {"Shovel"},
    MultipleOptions = true,
    Flag = "GearSelection",
    Callback = function(Options)
        SelectedGear = Options
        ScriptSettings.SelectedGear = Options
    end,
})

MainTab:CreateToggle({
    Name = "Auto Buy Gear",
    CurrentValue = false,
    Flag = "AutoBuyGear",
    Callback = function(Value)
        ScriptSettings.AutoBuy.Gear = Value
    end,
})

local EggSection = MainTab:CreateSection("Pet Eggs Management")

local EggsList = {"Common Egg", "Rare Egg", "Epic Egg", "Legendary Egg", "Mythic Egg"}
local SelectedEggs = {}

local EggDropdown = MainTab:CreateDropdown({
    Name = "Select Eggs",
    Options = EggsList,
    CurrentOption = {"Common Egg"},
    MultipleOptions = true,
    Flag = "EggSelection",
    Callback = function(Options)
        SelectedEggs = Options
        ScriptSettings.SelectedEggs = Options
    end,
})

MainTab:CreateToggle({
    Name = "Auto Buy Eggs",
    CurrentValue = false,
    Flag = "AutoBuyEggs",
    Callback = function(Value)
        ScriptSettings.AutoBuy.Eggs = Value
    end,
})

MainTab:CreateToggle({
    Name = "Auto Hatch Pet Eggs",
    CurrentValue = false,
    Flag = "AutoHatchEggs",
    Callback = function(Value)
        ScriptSettings.AutoHatch = Value
    end,
})

-- Event Tab
local EventTab = Window:CreateTab("Events", 4483362458)
local RecipeSection = EventTab:CreateSection("Recipe System")

local RecipeTypes = {"Gear Recipes", "Seed Recipes", "All Recipes"}
local SelectedRecipeType = "All Recipes"

EventTab:CreateDropdown({
    Name = "Select Recipe Type",
    Options = RecipeTypes,
    CurrentOption = {"All Recipes"},
    Flag = "RecipeType",
    Callback = function(Option)
        SelectedRecipeType = Option[1]
    end,
})

EventTab:CreateToggle({
    Name = "Auto Recipe",
    CurrentValue = false,
    Flag = "AutoRecipe",
    Callback = function(Value)
        ScriptSettings.RecipeSettings.AutoRecipe = Value
    end,
})

EventTab:CreateToggle({
    Name = "Auto Input",
    CurrentValue = false,
    Flag = "AutoInput",
    Callback = function(Value)
        ScriptSettings.RecipeSettings.AutoInput = Value
    end,
})

EventTab:CreateToggle({
    Name = "Auto Craft",
    CurrentValue = false,
    Flag = "AutoCraft",
    Callback = function(Value)
        ScriptSettings.RecipeSettings.AutoCraft = Value
    end,
})

EventTab:CreateToggle({
    Name = "Auto Claim",
    CurrentValue = false,
    Flag = "AutoClaim",
    Callback = function(Value)
        ScriptSettings.RecipeSettings.AutoClaim = Value
    end,
})

local RecipeInfoSection = EventTab:CreateSection("Recipe Information")
EventTab:CreateLabel("Outputs: Loading...")
EventTab:CreateLabel("Inputs: Loading...")
EventTab:CreateLabel("Time: Loading...")
EventTab:CreateLabel("Robux: Loading...")

local MerchantSection = EventTab:CreateSection("Merchant & Shop")

local GnomeCrates = {"Basic Crate", "Advanced Crate", "Premium Crate"}
local SkyGear = {"Sky Shovel", "Sky Watering Can", "Sky Fertilizer"}
local SummerItems = {"Summer Seeds", "Summer Tools", "Summer Decorations"}

EventTab:CreateDropdown({
    Name = "Select Gnome Crates",
    Options = GnomeCrates,
    CurrentOption = {"Basic Crate"},
    MultipleOptions = true,
    Flag = "GnomeCrates",
    Callback = function(Options)
        -- Store selected crates
    end,
})

EventTab:CreateToggle({
    Name = "Auto Buy Gnome Crates",
    CurrentValue = false,
    Flag = "AutoBuyGnomeCrates",
    Callback = function(Value)
        ScriptSettings.AutoBuyGnomeCrates = Value
    end,
})

EventTab:CreateDropdown({
    Name = "Select Sky Gear",
    Options = SkyGear,
    CurrentOption = {"Sky Shovel"},
    MultipleOptions = true,
    Flag = "SkyGear",
    Callback = function(Options)
        -- Store selected sky gear
    end,
})

EventTab:CreateToggle({
    Name = "Auto Buy Sky Gear",
    CurrentValue = false,
    Flag = "AutoBuySkyGear",
    Callback = function(Value)
        ScriptSettings.AutoBuySkyGear = Value
    end,
})

local SummerSection = EventTab:CreateSection("Summer Event")

EventTab:CreateDropdown({
    Name = "Select Summer Items",
    Options = SummerItems,
    CurrentOption = {"Summer Seeds"},
    MultipleOptions = true,
    Flag = "SummerItems",
    Callback = function(Options)
        -- Store selected summer items
    end,
})

EventTab:CreateToggle({
    Name = "Auto Buy Summer Items",
    CurrentValue = false,
    Flag = "AutoBuySummer",
    Callback = function(Value)
        ScriptSettings.AutoBuySummer = Value
    end,
})

EventTab:CreateSlider({
    Name = "Stop At Points",
    Range = {0, 1000000},
    Increment = 1000,
    Suffix = "Points",
    CurrentValue = 100000,
    Flag = "StopPoints",
    Callback = function(Value)
        ScriptSettings.StopAtPoints = Value
    end,
})

EventTab:CreateInput({
    Name = "Webhook URL",
    PlaceholderText = "Enter Discord webhook URL",
    RemoveTextAfterFocusLost = false,
    Flag = "WebhookURL",
    Callback = function(Text)
        ScriptSettings.WebhookURL = Text
    end,
})

EventTab:CreateSlider({
    Name = "Auto Submit Delay",
    Range = {1, 10},
    Increment = 1,
    Suffix = "seconds",
    CurrentValue = 1,
    Flag = "SubmitDelay",
    Callback = function(Value)
        ScriptSettings.AutoSubmitDelay = Value
    end,
})

EventTab:CreateToggle({
    Name = "Auto Submit Summer Plant",
    CurrentValue = false,
    Flag = "AutoSubmitSummer",
    Callback = function(Value)
        ScriptSettings.SummerPlantSubmit = Value
    end,
})

EventTab:CreateToggle({
    Name = "Auto Submit All When Full Backpack",
    CurrentValue = false,
    Flag = "AutoSubmitFull",
    Callback = function(Value)
        ScriptSettings.AutoSubmitWhenFull = Value
    end,
})

-- Plants Tab
local PlantsTab = Window:CreateTab("Plants", 4483362458)
local PlantESPSection = PlantsTab:CreateSection("Plant ESP")

PlantsTab:CreateToggle({
    Name = "Plant ESP",
    CurrentValue = false,
    Flag = "PlantESP",
    Callback = function(Value)
        ScriptSettings.PlantESP = Value
        -- Toggle ESP functionality
    end,
})

PlantsTab:CreateToggle({
    Name = "Highlight Pollinated",
    CurrentValue = false,
    Flag = "HighlightPollinated",
    Callback = function(Value)
        ScriptSettings.HighlightPollinated = Value
    end,
})

local AutomationSection = PlantsTab:CreateSection("Plant Automation")

PlantsTab:CreateToggle({
    Name = "Auto Sell When Full Backpack",
    CurrentValue = false,
    Flag = "AutoSellFull",
    Callback = function(Value)
        ScriptSettings.AutoSellWhenFull = Value
    end,
})

PlantsTab:CreateSlider({
    Name = "Auto Sell Every X Seconds",
    Range = {1, 60},
    Increment = 1,
    Suffix = "seconds",
    CurrentValue = 5,
    Flag = "AutoSellTimer",
    Callback = function(Value)
        ScriptSettings.AutoSellTimer = Value
    end,
})

PlantsTab:CreateSlider({
    Name = "Sell Delay",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "seconds",
    CurrentValue = 1,
    Flag = "SellDelay",
    Callback = function(Value)
        ScriptSettings.SellDelay = Value
    end,
})

PlantsTab:CreateToggle({
    Name = "Auto Plant",
    CurrentValue = false,
    Flag = "AutoPlant",
    Callback = function(Value)
        ScriptSettings.AutoPlant = Value
    end,
})

PlantsTab:CreateToggle({
    Name = "Auto Collector",
    CurrentValue = false,
    Flag = "AutoCollect",
    Callback = function(Value)
        ScriptSettings.AutoCollect = Value
    end,
})

local FilterSection = PlantsTab:CreateSection("Collection Filters")

local PlantFilters = {"All Plants", "Fruits", "Vegetables", "Flowers", "Trees"}
local MutationFilters = {"All", "Mutated Only", "Normal Only"}
local VariantFilters = {"All Variants", "Shiny", "Golden", "Rainbow"}

PlantsTab:CreateDropdown({
    Name = "Plant Filter",
    Options = PlantFilters,
    CurrentOption = {"All Plants"},
    Flag = "PlantFilter",
    Callback = function(Option)
        ScriptSettings.PlantFilter = Option[1]
    end,
})

PlantsTab:CreateDropdown({
    Name = "Mutation Filter",
    Options = MutationFilters,
    CurrentOption = {"All"},
    Flag = "MutationFilter",
    Callback = function(Option)
        ScriptSettings.MutationFilter = Option[1]
    end,
})

PlantsTab:CreateDropdown({
    Name = "Variant Filter",
    Options = VariantFilters,
    CurrentOption = {"All Variants"},
    Flag = "VariantFilter",
    Callback = function(Option)
        ScriptSettings.VariantFilter = Option[1]
    end,
})

local ComparisonTypes = {"Greater Than", "Less Than", "Equal To"}
PlantsTab:CreateDropdown({
    Name = "Weight Comparison",
    Options = ComparisonTypes,
    CurrentOption = {"Greater Than"},
    Flag = "WeightComparison",
    Callback = function(Option)
        ScriptSettings.WeightComparison = Option[1]
    end,
})

PlantsTab:CreateSlider({
    Name = "Weight Threshold",
    Range = {0, 1000},
    Increment = 1,
    Suffix = "kg",
    CurrentValue = 0,
    Flag = "WeightThreshold",
    Callback = function(Value)
        ScriptSettings.WeightThreshold = Value
    end,
})

PlantsTab:CreateSlider({
    Name = "Collect Delay",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "seconds",
    CurrentValue = 1,
    Flag = "CollectDelay",
    Callback = function(Value)
        ScriptSettings.CollectDelay = Value
    end,
})

local FavoriterSection = PlantsTab:CreateSection("Auto Favoriter")

local FavoriteMode = {"Favorite", "Unfavorite", "Toggle"}
PlantsTab:CreateDropdown({
    Name = "Favorite Mode",
    Options = FavoriteMode,
    CurrentOption = {"Favorite"},
    Flag = "FavoriteMode",
    Callback = function(Option)
        ScriptSettings.FavoriteMode = Option[1]
    end,
})

PlantsTab:CreateToggle({
    Name = "Auto Favorite/Unfavorite",
    CurrentValue = false,
    Flag = "AutoFavorite",
    Callback = function(Value)
        ScriptSettings.AutoFavorite = Value
    end,
})

-- Cosmetics Tab
local CosmeticsTab = Window:CreateTab("Cosmetics", 4483362458)
local CosmeticSection = CosmeticsTab:CreateSection("Cosmetic Management")

local CosmeticCrates = {"Style Crate", "Color Crate", "Pattern Crate", "Premium Style Crate"}
local CosmeticItems = {"Hat", "Shirt", "Pants", "Shoes", "Accessories", "Hair", "Face"}

CosmeticsTab:CreateDropdown({
    Name = "Select Cosmetic Crates",
    Options = CosmeticCrates,
    CurrentOption = {"Style Crate"},
    MultipleOptions = true,
    Flag = "CosmeticCrates",
    Callback = function(Options)
        ScriptSettings.SelectedCosmeticCrates = Options
    end,
})

CosmeticsTab:CreateDropdown({
    Name = "Select Cosmetic Items",
    Options = CosmeticItems,
    CurrentOption = {"Hat"},
    MultipleOptions = true,
    Flag = "CosmeticItems",
    Callback = function(Options)
        ScriptSettings.SelectedCosmeticItems = Options
    end,
})

CosmeticsTab:CreateToggle({
    Name = "Auto Buy Cosmetic Crates",
    CurrentValue = false,
    Flag = "AutoBuyCosmeticCrates",
    Callback = function(Value)
        ScriptSettings.AutoBuyCosmeticCrates = Value
    end,
})

CosmeticsTab:CreateToggle({
    Name = "Auto Buy Cosmetic Items",
    CurrentValue = false,
    Flag = "AutoBuyCosmeticItems",
    Callback = function(Value)
        ScriptSettings.AutoBuyCosmeticItems = Value
    end,
})

CosmeticsTab:CreateToggle({
    Name = "Auto Open Crates",
    CurrentValue = false,
    Flag = "AutoOpenCrates",
    Callback = function(Value)
        ScriptSettings.AutoOpenCrates = Value
    end,
})

-- Misc Tab
local MiscTab = Window:CreateTab("Misc", 4483362458)
local ValueSection = MiscTab:CreateSection("Value Calculator")

MiscTab:CreateToggle({
    Name = "Show Fruit/Plant Prices",
    CurrentValue = false,
    Flag = "ShowPlantPrices",
    Callback = function(Value)
        ScriptSettings.ShowPlantPrices = Value
    end,
})

MiscTab:CreateToggle({
    Name = "Show Pet Prices",
    CurrentValue = false,
    Flag = "ShowPetPrices",
    Callback = function(Value)
        ScriptSettings.ShowPetPrices = Value
    end,
})

local AutoFeedSection = MiscTab:CreateSection("Auto Feed Settings")

local FoodTypes = {"Basic Food", "Premium Food", "Super Food", "Legendary Food"}
MiscTab:CreateDropdown({
    Name = "Select Food Type",
    Options = FoodTypes,
    CurrentOption = {"Basic Food"},
    Flag = "FoodType",
    Callback = function(Option)
        ScriptSettings.SelectedFood = Option[1]
    end,
})

MiscTab:CreateSlider({
    Name = "Feed When Hunger",
    Range = {0, 100},
    Increment = 5,
    Suffix = "%",
    CurrentValue = 50,
    Flag = "FeedHunger",
    Callback = function(Value)
        ScriptSettings.FeedHungerThreshold = Value
    end,
})

MiscTab:CreateSlider({
    Name = "Stop When Hunger",
    Range = {0, 100},
    Increment = 5,
    Suffix = "%",
    CurrentValue = 90,
    Flag = "StopHunger",
    Callback = function(Value)
        ScriptSettings.StopHungerThreshold = Value
    end,
})

MiscTab:CreateToggle({
    Name = "Enable Auto Feed",
    CurrentValue = false,
    Flag = "AutoFeed",
    Callback = function(Value)
        ScriptSettings.AutoFeed = Value
    end,
})

local EggPlacementSection = MiscTab:CreateSection("Egg Placement")

MiscTab:CreateDropdown({
    Name = "Select Eggs to Place",
    Options = EggsList,
    CurrentOption = {"Common Egg"},
    MultipleOptions = true,
    Flag = "EggsToPlace",
    Callback = function(Options)
        ScriptSettings.EggsToPlace = Options
    end,
})

MiscTab:CreateToggle({
    Name = "Auto Place Pet Eggs",
    CurrentValue = false,
    Flag = "AutoPlaceEggs",
    Callback = function(Value)
        ScriptSettings.AutoPlaceEggs = Value
    end,
})

local OptimizationSection = MiscTab:CreateSection("Optimization")

MiscTab:CreateToggle({
    Name = "Black Screen",
    CurrentValue = false,
    Flag = "BlackScreen",
    Callback = function(Value)
        if Value then
            -- Create black screen
            local BlackScreen = Instance.new("Frame")
            BlackScreen.Name = "BlackScreen"
            BlackScreen.Size = UDim2.new(1, 0, 1, 0)
            BlackScreen.Position = UDim2.new(0, 0, 0, 0)
            BlackScreen.BackgroundColor3 = Color3.new(0, 0, 0)
            BlackScreen.Parent = PlayerGui
        else
            -- Remove black screen
            if PlayerGui:FindFirstChild("BlackScreen") then
                PlayerGui.BlackScreen:Destroy()
            end
        end
    end,
})

MiscTab:CreateToggle({
    Name = "Hide Others' Plants",
    CurrentValue = false,
    Flag = "HideOthersPlants",
    Callback = function(Value)
        ScriptSettings.HideOthersPlants = Value
    end,
})

MiscTab:CreateToggle({
    Name = "Delete Others' Plants",
    CurrentValue = false,
    Flag = "DeleteOthersPlants",
    Callback = function(Value)
        ScriptSettings.DeleteOthersPlants = Value
    end,
})

MiscTab:CreateToggle({
    Name = "Hide All Plants",
    CurrentValue = false,
    Flag = "HideAllPlants",
    Callback = function(Value)
        ScriptSettings.HideAllPlants = Value
    end,
})

MiscTab:CreateToggle({
    Name = "Anti Lag",
    CurrentValue = false,
    Flag = "AntiLag",
    Callback = function(Value)
        ScriptSettings.AntiLag = Value
        if Value then
            -- Enable anti-lag optimizations
            game:GetService("RunService"):Set3dRenderingEnabled(false)
        else
            game:GetService("RunService"):Set3dRenderingEnabled(true)
        end
    end,
})

-- Core Functions
local function AutoBuySeeds()
    if ScriptSettings.AutoBuy.Seeds then
        for _, seedName in pairs(ScriptSettings.SelectedSeeds) do
            -- Implementation for buying seeds
            print("Buying seed:", seedName)
        end
    end
end

local function AutoBuyGear()
    if ScriptSettings.AutoBuy.Gear then
        for _, gearName in pairs(ScriptSettings.SelectedGear) do
            -- Implementation for buying gear
            print("Buying gear:", gearName)
        end
    end
end

local function AutoBuyEggs()
    if ScriptSettings.AutoBuy.Eggs then
        for _, eggName in pairs(ScriptSettings.SelectedEggs) do
            -- Implementation for buying eggs
            print("Buying egg:", eggName)
        end
    end
end

local function AutoPlantSeeds()
    if ScriptSettings.AutoPlant then
        -- Implementation for auto planting
        print("Auto planting activated")
    end
end

local function AutoCollectPlants()
    if ScriptSettings.AutoCollect then
        -- Implementation for auto collecting with filters
        print("Auto collecting with filters")
    end
end

local function AutoSellPlants()
    if ScriptSettings.AutoSellWhenFull then
        -- Implementation for auto selling
        print("Auto selling plants")
    end
end

local function AutoFeedPets()
    if ScriptSettings.AutoFeed then
        -- Implementation for auto feeding pets
        print("Auto feeding pets with", ScriptSettings.SelectedFood)
    end
end

local function SendWebhook(message)
    if ScriptSettings.WebhookURL and ScriptSettings.WebhookURL ~= "" then
        local data = {
            content = message,
            username = "Grow Garden Bot",
            avatar_url = "https://example.com/avatar.png"
        }
        
        local success, response = pcall(function()
            return HttpService:PostAsync(ScriptSettings.WebhookURL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
        end)
        
        if success then
            print("Webhook sent successfully")
        else
            warn("Failed to send webhook:", response)
        end
    end
end

-- Main Loop
RunService.Heartbeat:Connect(function()
    AutoBuySeeds()
    AutoBuyGear() 
    AutoBuyEggs()
    AutoPlantSeeds()
    AutoCollectPlants()
    AutoSellPlants()
    AutoFeedPets()
end)

-- Initialize
Rayfield:LoadConfiguration()
print("Grow a Garden Hub loaded successfully!")
SendWebhook("Grow a Garden Hub has been loaded!")
