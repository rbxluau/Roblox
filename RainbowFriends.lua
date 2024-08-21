local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local BoxUpdated = ReplicatedStorage.communication.boxes.cl.BoxUpdated

local Library, Locale = loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/Library.lua"))()

local Window = Library:Window(Locale.RainbowFriends)

local Section = Window:Tab(Locale.Player):Section("Main", true)

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

Section:Toggle(Locale.Invisible, "Invisible", false, function(Value)
    if not Value then
        BoxUpdated:FireServer("Unequip")
    end
end)

Section = Window:Tab(Locale.Auto):Section("Main", true)

Section:Toggle(Locale.Get, "Get")

Section:Toggle(Locale.Put, "Put")

Section = Window:Tab(Locale.Loop):Section("Main", true)

local Player = Section:Dropdown(Locale.Player, "Player", (function()
    local Players = Players:GetPlayers()
    for i, v in pairs(Players) do
        Players[i] = v.Name
    end
    return Players
end)())

Section:Toggle(Locale.Teleport, "Teleport")

Section = Window:Tab(Locale.ESP):Section("Main", true)

Section:Toggle(Locale.Player, "ESP")

Section:Toggle(Locale.Other, "Other")

Section = Window:Tab(Locale.Other):Section("Main", true)

Section:Button(Locale.BTool, function()
    for i = 3, 4 do
        local HopperBin = Instance.new("HopperBin", LocalPlayer.Backpack)
        HopperBin.BinType = i
    end
end)

Section:Button(Locale.ClickTP, function()
    local Tool = Instance.new("Tool", LocalPlayer.Backpack)
    Tool.RequiresHandle = false
    Tool.Activated:Connect(function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer:GetMouse().Hit+Vector3.new(0, 2.5, 0)
    end)
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

Players.PlayerAdded:Connect(function(v)
    Player:AddOption(v.Name)
end)

Players.PlayerRemoving:Connect(function(v)
    Player:RemoveOption(v.Name)
end)

RunService.Heartbeat:Connect(function()
    for i, v in pairs(workspace.ignore:GetChildren()) do
        if v.Name == "Looky" then
            v.Highlight.Enabled = Library.flags.Other
        end
    end
    if Library.flags.Invisible then
        BoxUpdated:FireServer("Equip")
    end
    if Library.flags.Get then
        for i, v in pairs(workspace:GetChildren()) do
            if table.find({
                "Fuse1",
                "Fuse2",
                "Fuse3",
                "Fuse4",
                "Fuse5",
                "Fuse6",
                "Fuse7",
                "Fuse8",
                "Fuse9",
                "Fuse10",
                "Fuse11",
                "Fuse12",
                "Fuse13",
                "Fuse14",
                "Block1",
                "Block2",
                "Block3",
                "Block4",
                "Block5",
                "Block6",
                "Block7",
                "Block8",
                "Block9",
                "Block10",
                "Block11",
                "Block12",
                "Block13",
                "Block14",
                "Block15",
                "Block16",
                "Block17",
                "Block18",
                "Block19",
                "Block20",
                "Block21",
                "Block22",
                "Block23",
                "Block24",
                "Battery",
                "FoodPink",
                "FoodGreen",
                "FoodOrange",
                "CakeMix",
                "LightBulb",
                "GasCanister"
            }, v.Name) then
                v.TouchTrigger.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end
    if Library.flags.Put then
        for i, v in pairs(workspace.GroupBuildStructures:GetChildren()) do
            v.Trigger.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end
    LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection*Library.flags.Boost)
    if Library.flags.Fly then
        LocalPlayer.Character.Humanoid:ChangeState("Swimming")
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.zero
    end
    if Library.flags.Player and Library.flags.Teleport then
        LocalPlayer.Character.Humanoid.Sit = false
        LocalPlayer.Character.HumanoidRootPart.CFrame = Players[Library.flags.Player].Character.HumanoidRootPart.CFrame
    end
    for i, v in pairs(Players:GetPlayers()) do
        local Character = v.Character
        if not Character:FindFirstChild("Highlight") then
            Instance.new("Highlight", Character)
            local BillboardGui = Instance.new("BillboardGui", Character)
            local TextLabel = Instance.new("TextLabel", BillboardGui)
            BillboardGui.AlwaysOnTop = true
            BillboardGui.Size = UDim2.new(0, 100, 0, 50)
            BillboardGui.StudsOffset = Vector3.new(0, 4, 0)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Size = UDim2.new(0, 100, 0, 50)
        end
        Character.BillboardGui.Enabled = Library.flags.ESP
        Character.Highlight.Enabled = Library.flags.ESP
        Character.BillboardGui.TextLabel.Text = v.Name.."\nHealth: "..math.round(Character.Humanoid.Health).."\nDistance: "..math.round(LocalPlayer:DistanceFromCharacter(Character.Head.Position))
        Character.BillboardGui.TextLabel.TextColor = v.TeamColor
        Character.Highlight.FillColor = v.TeamColor.Color
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
