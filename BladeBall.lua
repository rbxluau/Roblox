local ProximityPromptService = game:GetService("ProximityPromptService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PreParry = time()
local Parry = 1
local Lock = true
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
    for _, v in pairs(Enum.HumanoidStateType:GetEnumItems()) do
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

Section = Tab:Section("Combo", true)

Section:Slider(Locale.Sensitivity, "Sensitivity", 1, 0.5, 1.5, true, function(value)
    Parry = value
end)

Section:Toggle(Locale.Toggle, "Combo")

Section = Window:Tab(Locale.Interact):Section("Main", true)

Section:Toggle(Locale.Fast, "Fast")

Section = Window:Tab(Locale.Loop):Section("Main", true)

local Player = Section:Dropdown(Locale.Player, "Player", (function()
    local PlayerList = Players:GetPlayers()
    for i, v in pairs(PlayerList) do
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

Section:Button(Locale.ClickTP, function()
    local Tool = Instance.new("Tool", LocalPlayer.Backpack)
    Tool.RequiresHandle = false
    Tool.Activated:Connect(function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer:GetMouse().Hit+Vector3.new(0, 2.5, 0)
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
    ForceField.Color = Color3.new(0, 1, 0)
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

local function Combo(distance, from)
    while task.wait() do
        local _, result = pcall(function()
            if not table.find({from, LocalPlayer.Name}, Ball:GetAttribute("from")) or LocalPlayer:DistanceFromCharacter(workspace.Alive[from].Head.Position) > distance then
                return true
            end
            keypress(0x46)
            keyrelease(0x46)
        end)
        if result then
            Parry = Library.flags.Sensitivity
            break
        end
    end
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
        for _, v in pairs(LocalPlayer.Character:GetChildren()) do
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
        local Position = Ball.Position + Ball.AssemblyLinearVelocity * (Library.flags.Time + LocalPlayer:GetNetworkPing())
        Part.Position = Position
        ForceField.Material = Enum.Material.ForceField
        ForceField.Position = LocalPlayer.Character.HumanoidRootPart.Position
        LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection*Library.flags.Boost)
        if Library.flags.Fly then
            LocalPlayer.Character.Humanoid:ChangeState("Swimming")
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.zero
        end
        if Library.flags.Player and Library.flags.Teleport then
            LocalPlayer.Character.Humanoid.Sit = false
            LocalPlayer.Character.HumanoidRootPart.CFrame = Players[Library.flags.Player].Character.HumanoidRootPart.CFrame
        end
        if Library.flags.Parry and Lock and Parry >= Library.flags.Sensitivity and Ball:GetAttribute("target") == LocalPlayer.Name then
            if LocalPlayer:DistanceFromCharacter(Position) < Library.flags.Area then
                keypress(0x46)
                keyrelease(0x46)
                Lock = false
                Ball:GetAttributeChangedSignal("target"):Once(function()
                    Lock = true
                end)
                if Library.flags.Combo then
                    Parry = time() - PreParry
                    PreParry = time()
                    print("Parry:", Parry)
                    if Parry < Library.flags.Sensitivity then
                        local From = Ball:GetAttribute("from")
                        print("Combo:", From)
                        Combo(LocalPlayer:DistanceFromCharacter(workspace.Alive[From].Head.Position) + 10, From)
                    end
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
