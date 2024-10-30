local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Prompt = {
    "ActivateEventPrompt",
    "AwesomePrompt",
    "ModulePrompt",
    "UnlockPrompt",
    "LootPrompt"
}
local List = {}

local function Warn(v)
    StarterGui:SetCore("SendNotification", {
    Title = "Warning",
    Text = v
    })
end

local function ESP(i, v)
    Instance.new("Highlight", i)
    local BillboardGui = Instance.new("BillboardGui", i)
    local TextLabel = Instance.new("TextLabel", BillboardGui)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Size = UDim2.new(0, 100, 0, 50)
    BillboardGui.StudsOffset = Vector3.new(0, (v or 0), 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(0, 100, 0, 50)
    TextLabel.Text = i.Name
end

local Library, Locale = loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/Library.lua"))()

local Window = Library:Window("Doors")

local Section = Window:Tab(Locale.Player):Section("Main", true)

Section:Slider(Locale.Gravity, "Gravity", math.round(workspace.Gravity), 0, 200, false, function(Value)
    workspace.Gravity = Value
end)

Section:Slider(Locale.Boost, "Boost", 0, 0, 200)

Section:Toggle(Locale.Fly, "Fly", false, function(Value)
    for i, v in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        LocalPlayer.Character.Humanoid:SetStateEnabled(v, not Value)
    end
end)

Section:Toggle(Locale.Noclip, "Noclip", false, function(Value)
    if not Value then
        LocalPlayer.Character.Humanoid:ChangeState("Flying")
    end
end)

Section = Window:Tab(Locale.Auto):Section("Main", true)

Section:Toggle(Locale.Interact, "Interact")

Section = Window:Tab(Locale.ESP):Section("Main", true)

Section:Toggle(Locale.Door, "Door")

Section:Toggle(Locale.Player, "ESP")

Section:Toggle(Locale.Monster, "Monster")

Section:Toggle(Locale.Other, "Other")

Section = Window:Tab(Locale.Remove):Section("Main", true)

Section:Button("Screech", function()
    LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules.Screech:Destroy()
end)

Section:Toggle("Seek", "Seek")

Section = Window:Tab(Locale.Other):Section("Main", true)

Section:Button(Locale.Unlock, function()
    local Hint = {"x", "x", "x", "x", "x"}
    local Paper = LocalPlayer.Backpack:FindFirstChild("LibraryHintPaper") or LocalPlayer.Character:FindFirstChild("LibraryHintPaper")
    if Paper then
        for h = 1, 5 do
            for i, v in pairs(LocalPlayer.PlayerGui.PermUI.Hints:GetChildren()) do
                if v:IsA("ImageLabel") and v.ImageRectOffset == Paper.UI[h].ImageRectOffset then
                    Hint[h] = v.TextLabel.Text
                end
            end
        end
        Warn(table.concat(Hint))
        ReplicatedStorage.RemotesFolder.PL:FireServer(table.concat(Hint))
    else
        Warn("Hint Paper Not Find")
    end
end)

Section:Button(Locale.BTool, function()
    for i = 3, 4 do
        local HopperBin = Instance.new("HopperBin", LocalPlayer.Backpack)
        HopperBin.BinType = i
    end
end)

Section:Dropdown(Locale.Camera, "Camera", {"Classic", "LockFirstPerson"}, function(Value)
    LocalPlayer.CameraMode = Value
end)

Section:Toggle(Locale.FullBright, "Light", false, function(Value)
    if Value then
        Lighting.Ambient = Color3.new(1, 1, 1)
    else
        Lighting.Ambient = Color3.new(0, 0, 0)
    end
end)

Section:Toggle(Locale.AFK, "AFK")

Section = Window:Tab(Locale.About):Section("Main", true)

Section:Label(Locale.By)

Section:Button(Locale.Copy, function()
    setclipboard(Locale.Link)
end)

RunService.Stepped:Connect(function()
    if Library.flags.Noclip then
        for i, v in pairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

ProximityPromptService.PromptShown:Connect(function(v)
    if Library.flags.Interact and table.find(Prompt, v.Name) and not table.find(List, v) then
        fireproximityprompt(v)
        if v.Name == Prompt[1] then
            table.insert(List, v)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection*Library.flags.Boost)
        if Library.flags.Fly then
            LocalPlayer.Character.Humanoid:ChangeState("Swimming")
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.zero
        end
        for i, v in pairs(Players:GetPlayers()) do
            local Character = v.Character
            if not Character:FindFirstChild("Highlight") then
                ESP(Character, 4)
            end
            Character.BillboardGui.Enabled = Library.flags.ESP
            Character.Highlight.Enabled = Library.flags.ESP
            Character.BillboardGui.TextLabel.Text = v.Name.."\nHealth: "..math.round(Character.Humanoid.Health).."\nDistance: "..math.round(LocalPlayer:DistanceFromCharacter(Character.Head.Position))
            Character.BillboardGui.TextLabel.TextColor = v.TeamColor
            Character.Highlight.FillColor = v.TeamColor.Color
        end
    end)
end)

workspace.ChildAdded:Connect(function(v)
    if Library.flags.Monster and v:IsA("Model") then
        Warn(v.Name)
        ESP(v)
    end
end)

ReplicatedStorage.GameData.LatestRoom.Changed:Connect(function(r)
    local Room = workspace.CurrentRooms[r]
    local TriggerEventCollision = Room:FindFirstChild("TriggerEventCollision")
    if Library.flags.Door then
        ESP(Room.Door)
    end
    for i, v in pairs(Room.Assets:GetDescendants()) do
        if Library.flags.Other and v:IsA("ProximityPrompt") then
            ESP(v.Parent)
        end
        if Library.flags.Seek and table.find({"Seek_Arm", "ChandelierObstruction"}, v.Name) then
            v:Destroy()
        end
    end
    if Library.flags.Seek and TriggerEventCollision then
        TriggerEventCollision:Destroy()
    end
end)

Lighting.LightingChanged:Connect(function()
    if Library.flags.Light then
        Lighting.Ambient = Color3.new(1, 1, 1)
    end
end)

LocalPlayer.Idled:Connect(function()
    if Library.flags.AFK then
        VirtualUser:MoveMouse(Vector2.new())
    end
end)
