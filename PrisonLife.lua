local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local LocalPlayer = Players.LocalPlayer

local Library, Locale = loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/Library.lua"))()

local Window = Library:Window(Locale.PrisonLife)

local Section = Window:Tab(Locale.Player):Section("Main", true)

Section:Slider(Locale.Jump, "Jump", math.round(LocalPlayer.Character.Humanoid.JumpPower), 0, 200, false, function(Value)
    LocalPlayer.Character.Humanoid.JumpPower = Value
end)

Section:Slider(Locale.Gravity, "Gravity", math.round(workspace.Gravity), 0, 200, false, function(Value)
    workspace.Gravity = Value
end)

Section:Slider(Locale.Boost, "Boost", 0, 0, 200)

Section:Toggle(Locale.Fly, "Fly", false, function(Value)
    for i, v in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        LocalPlayer.Character.Humanoid:SetStateEnabled(v, not Value)
    end
end)

Section:Toggle(Locale.InfJump, "InfJump")

Section:Toggle(Locale.Noclip, "Noclip", false, function(Value)
    if not Value then
        LocalPlayer.Character.Humanoid:ChangeState("Flying")
    end
end)

Section = Window:Tab(Locale.Team):Section("Main", true)

for i, v in pairs(Teams:GetTeams()) do
    if v ~= Teams.Criminals then
        Section:Button(v.Name, function()
            workspace.Remote.TeamEvent:FireServer(v.TeamColor.Name)
        end)
    end
end

Section = Window:Tab(Locale.Kill):Section("Main", true)

Section:Toggle(Locale.Aura, "Aura")

Section:Toggle(Locale.All, "All")

Section = Window:Tab(Locale.Loop):Section("Main", true)

local Player = Section:Dropdown(Locale.Player, "Player", (function()
    local Players = Players:GetPlayers()
    for i, v in pairs(Players) do
        Players[i] = v.Name
    end
    return Players
end)())

Section:Toggle(Locale.Teleport, "Teleport")

Section:Toggle(Locale.Kill, "Kill")

Section = Window:Tab(Locale.Auto):Section("Main", true)

Section:Toggle(Locale.Rebirth, "Rebirth")

Section = Window:Tab(Locale.ESP):Section("Main", true)

Section:Toggle(Locale.Player, "ESP")

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

UserInputService.JumpRequest:Connect(function()
    if Library.flags.InfJump then
        LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
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

LocalPlayer.CharacterAppearanceLoaded:Connect(function(v)
    v.Humanoid.Died:Wait()
    if Library.flags.Rebirth then
        local Position = LocalPlayer.Character.HumanoidRootPart.CFrame
        if LocalPlayer.Team == Teams.Criminals then
            workspace.Remote.TeamEvent:FireServer("Bright orange")
        else
            workspace.Remote.TeamEvent:FireServer(LocalPlayer.TeamColor.Name)
        end
        LocalPlayer.CharacterAppearanceLoaded:Wait()
        LocalPlayer.Character.HumanoidRootPart.CFrame = Position
    end
end)

Players.PlayerAdded:Connect(function(v)
    Player:AddOption(v.Name)
end)

Players.PlayerRemoving:Connect(function(v)
    Player:RemoveOption(v.Name)
end)

RunService.Heartbeat:Connect(function()
    LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection*Library.flags.Boost)
    if Library.flags.Fly then
        LocalPlayer.Character.Humanoid:ChangeState("Swimming")
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.zero
    end
    if Library.flags.Player then
        if Library.flags.Teleport then
            LocalPlayer.Character.Humanoid.Sit = false
            LocalPlayer.Character.HumanoidRootPart.CFrame = Players[Library.flags.Player].Character.HumanoidRootPart.CFrame
        end
        if Library.flags.Kill and Players[Library.flags.Player].Character.Humanoid.Health ~= 0 and not Players[Library.flags.Player].Character:FindFirstChild("ForceField") then
            ReplicatedStorage.meleeEvent:FireServer(Players[Library.flags.Player])
        end
    end
    for i, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character.Humanoid.Health ~= 0 and not v.Character:FindFirstChild("ForceField") then
            if Library.flags.All then
                LocalPlayer.Character.Humanoid.Sit = false
                LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
            end
            if Library.flags.Aura and LocalPlayer:DistanceFromCharacter(v.Character.Head.Position) < 15 or Library.flags.All then
                ReplicatedStorage.meleeEvent:FireServer(v)
            end
        end
        if not v.Character:FindFirstChild("Highlight") then
            Instance.new("Highlight", v.Character)
            local BillboardGui = Instance.new("BillboardGui", v.Character)
            local TextLabel = Instance.new("TextLabel", BillboardGui)
            BillboardGui.AlwaysOnTop = true
            BillboardGui.Size = UDim2.new(0, 100, 0, 50)
            BillboardGui.StudsOffset = Vector3.new(0, 4, 0)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Size = UDim2.new(0, 100, 0, 50)
        end
        v.Character.BillboardGui.TextLabel.Text = v.Name.."\nHealth: "..math.round(v.Character.Humanoid.Health).."\nDistance: "..math.round(LocalPlayer:DistanceFromCharacter(v.Character.Head.Position))
        v.Character.BillboardGui.TextLabel.TextColor = v.TeamColor
        v.Character.Highlight.FillColor = v.TeamColor.Color
        v.Character.BillboardGui.Enabled = Library.flags.ESP
        v.Character.Highlight.Enabled = Library.flags.ESP
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
