local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Crates = workspace.Spawn.Crates
local Signal = getconnections(LocalPlayer.PlayerGui.Hotbar.Block.Activated)[2].Function
local Lock = true
local Parry = {
    Pre = time(),
    Now = 1
}
local Spam = {
    From = "",
    Distance = 0
}
local ForceField
local Part
local Ball

local Library, Locale = loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/Library.lua"))()

local Window = Library:Window(Locale.BladeBall)

local Section = Window:Tab(Locale.Player):Section("Main", true)

Section:Slider(Locale.Gravity, "Gravity", math.round(workspace.Gravity), 0, 200, false, function(value)
    workspace.Gravity = value
end)

Section:Slider(Locale.Boost, "Boost", 0, 0, 20, true)

Section:Toggle(Locale.Fly, "Fly", false, function(value)
    for _, v in Enum.HumanoidStateType:GetEnumItems() do
        LocalPlayer.Character.Humanoid:SetStateEnabled(v, not value)
    end
end)

Section:Toggle(Locale.InfJump, "InfJump")

Section:Toggle(Locale.Noclip, "Noclip", false, function(value)
    if not value then
        LocalPlayer.Character.Humanoid:ChangeState("Flying")
    end
end)

local Tab = Window:Tab(Locale.Auto)

Section = Tab:Section("Parry", true)

Section:Slider(Locale.Sensitivity, "Time", 0.2, 0, 1, true)

Section:Toggle(Locale.Visible, "TimeVisible", false, function(value)
    if Part then
        Part.Transparency = value and 0 or 1
    end
end)

Section:Slider(Locale.Area, "Area", 25, 10, 30, false, function(value)
    if ForceField then
        ForceField.Size = Vector3.one * value
    end
end)

Section:Toggle(Locale.Visible, "AreaVisible", false, function(value)
    if ForceField then
        ForceField.Transparency = value and 0 or 1
    end
end)

Section:Toggle(Locale.Toggle, "Parry")

Section = Tab:Section("Spam", true)

Section:Slider(Locale.Sensitivity, "Sensitivity", 1, 0.5, 1.5, true, function(value)
    Parry.Now = value
end)

Section:Toggle(Locale.Toggle, "Spam")

Section = Window:Tab(Locale.Ball):Section("Main", true)

Section:Toggle(Locale.Aimbot, "Aimbot")

Section:Toggle(Locale.Teleport, "Follow")

Section = Window:Tab(Locale.Interact):Section("Main", true)

Section:Toggle(Locale.Fast, "Fast")

Section = Window:Tab(Locale.Item):Section("Main", true)

Section:Dropdown(Locale.Toggle, "Toggle", {"PromptPurchaseCrate", "SpinWheel"})

Section:Dropdown(Locale.Item, "Item", (function()
    local CratesList = {}
    for _, v in Crates:GetChildren() do
        if v:IsA("Model") then
            table.insert(CratesList, v.Name)
        end
    end
    return CratesList
end)())

Section:Button(Locale.Buy, function()
    ReplicatedStorage.Remote.RemoteFunction:InvokeServer(Library.flags.Toggle, Crates[Library.flags.Item])
end)

Section = Window:Tab(Locale.Loop):Section("Main", true)

local Player = Section:Dropdown(Locale.Player, "Player", (function()
    local PlayerList = Players:GetPlayers()
    for i, v in PlayerList do
        PlayerList[i] = v.Name
    end
    return PlayerList
end)())

Section:Toggle(Locale.Teleport, "Teleport")

Section = Window:Tab(Locale.Other):Section("Main", true)

Section:Button(Locale.BTool, function()
    for i = 3, 4 do
        local HopperBin = Instance.new("HopperBin", LocalPlayer.Backpack)
        HopperBin.BinType = i
    end
end)

Section:Button(Locale.Click.." "..Locale.Teleport, function()
    local Tool = Instance.new("Tool", LocalPlayer.Backpack)
    Tool.RequiresHandle = false
    Tool.Activated:Connect(function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer:GetMouse().Hit + Vector3.new(0, 2.5, 0)
    end)
end)

Section:Dropdown(Locale.Camera, "Camera", {"Classic", "LockFirstPerson"}, function(value)
    LocalPlayer.CameraMode = value
end)

Section:Toggle(Locale.AFK, "AFK")

Section = Window:Tab(Locale.About):Section("Main", true)

Section:Label(Locale.By)

Section:Button(Locale.Copy, function()
    setclipboard(Locale.Link)
end)

local function NewForceField(v)
    ForceField = Instance.new("Part", v)
    ForceField.Shape = Enum.PartType.Ball
    ForceField.CanCollide = false
    ForceField.Color = Color3.new(0, 0, 1)
    ForceField.Material = Enum.Material.ForceField
    ForceField.Size = Vector3.one * Library.flags.Area
    ForceField.Transparency = Library.flags.AreaVisible and 0 or 1
end

local function NewPart(v)
    Part = Instance.new("Part", v)
    Part.Shape = Enum.PartType.Ball
    Part.CanCollide = false
    Part.Material = Enum.Material.Neon
    Part.Size = Vector3.new(3, 3, 3)
    Part.Transparency = Library.flags.TimeVisible and 0 or 1
end

NewForceField(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())

workspace.Balls.ChildAdded:Connect(function(v)
    task.wait()
    if v:GetAttribute("realBall") then
        Ball = v
        Lock = true
        NewPart(v)
    end
end)

LocalPlayer.CharacterAdded:Connect(NewForceField)

UserInputService.JumpRequest:Connect(function()
    if Library.flags.InfJump then
        LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

RunService.PreSimulation:Connect(function()
    if Library.flags.Noclip then
        for _, v in LocalPlayer.Character:GetChildren() do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

ProximityPromptService.PromptButtonHoldBegan:Connect(function(v)
    if Library.flags.Fast then
        fireproximityprompt(v)
    end
end)

Players.PlayerAdded:Connect(function(v)
    Player:AddOption(v.Name)
end)

Players.PlayerRemoving:Connect(function(v)
    Player:RemoveOption(v.Name)
end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        local PrePosition = Ball.AssemblyLinearVelocity * (Library.flags.Time + LocalPlayer:GetNetworkPing())
        local Position = Ball.Position + PrePosition
        Part.Position = Position
        ForceField.Material = Enum.Material.ForceField
        ForceField.Position = LocalPlayer.Character.HumanoidRootPart.Position
        LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection * Library.flags.Boost)
        if Library.flags.Fly then
            LocalPlayer.Character.Humanoid:ChangeState("Swimming")
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.zero
        end
        if Library.flags.Player and Library.flags.Teleport then
            LocalPlayer.Character.Humanoid.Sit = false
            LocalPlayer.Character.HumanoidRootPart.CFrame = Players[Library.flags.Player].Character.HumanoidRootPart.CFrame
        end
        if Library.flags.Aimbot then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Ball.Position)
        end
        if Library.flags.Follow then
            LocalPlayer.Character.HumanoidRootPart.CFrame = Ball.CFrame - PrePosition
        end
        if Parry.Now < Library.flags.Sensitivity and table.find({Spam.From, LocalPlayer.Name}, Ball:GetAttribute("from")) and LocalPlayer:DistanceFromCharacter(workspace.Alive[Spam.From].Head.Position) <= Spam.Distance then
            Signal()
        else
            Parry.Now = Library.flags.Sensitivity
        end
        if Library.flags.Parry and Lock and Parry.Now >= Library.flags.Sensitivity and Ball:GetAttribute("target") == LocalPlayer.Name and LocalPlayer:DistanceFromCharacter(Position) < Library.flags.Area then
            Signal()
            Lock = false
            Ball:GetAttributeChangedSignal("target"):Once(function()
                Lock = true
            end)
            if Library.flags.Spam then
                Parry.Now = time() - Parry.Pre
                Parry.Pre = time()
                if Parry.Now < Library.flags.Sensitivity then
                    Spam.From = Ball:GetAttribute("from")
                    Spam.Distance = LocalPlayer:DistanceFromCharacter(workspace.Alive[Spam.From].Head.Position) + 10
                end
            end
        end
    end)
end)

LocalPlayer.Idled:Connect(function()
    if Library.flags.AFK then
        VirtualUser:MoveMouse(Vector2.new())
    end
end)