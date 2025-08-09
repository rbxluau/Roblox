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

Section:Slider(Locale.Jump, "Jump", math.round(LocalPlayer.Character.Humanoid.JumpPower), 0, 200, false, function(value)
    LocalPlayer.Character.Humanoid.JumpPower = value
end)

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

Section = Window:Tab(Locale.Team):Section("Main", true)

for _, v in pairs(Teams:GetTeams()) do
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
    local PlayerList = Players:GetPlayers()
    for i, v in pairs(PlayerList) do
        PlayerList[i] = v.Name
    end
    return PlayerList
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

Section:Dropdown(Locale.Camera, "Camera", {"Classic", "LockFirstPerson"}, function(value)
    LocalPlayer.CameraMode = value
end)

Section:Toggle(Locale.FullBright, "Light", false, function(value)
    if value then
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

RunService.PreSimulation:Connect(function()
    if Library.flags.Noclip then
        for _, v in pairs(LocalPlayer.Character:GetChildren()) do
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
    pcall(function()
        LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection*Library.flags.Boost)
        if Library.flags.Fly then
            LocalPlayer.Character.Humanoid:ChangeState("Swimming")
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.zero
        end
        if Library.flags.Player then
            local SelectPlayer = Players[Library.flags.Player]
            local Character = SelectPlayer.Character
            if Library.flags.Teleport then
                LocalPlayer.Character.Humanoid.Sit = false
                LocalPlayer.Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame
            end
            if Library.flags.Kill and LocalPlayer:DistanceFromCharacter(Character.Head.Position) < 15 and Character.Humanoid.Health ~= 0 and not Character:FindFirstChild("ForceField") then
                ReplicatedStorage.meleeEvent:FireServer(SelectPlayer)
            end
        end
        for _, v in pairs(Players:GetPlayers()) do
            local Character = v.Character
            local Health = Character.Humanoid.Health
            local Distance = LocalPlayer:DistanceFromCharacter(Character.Head.Position)
            if v ~= LocalPlayer and Health ~= 0 and not Character:FindFirstChild("ForceField") then
                if Library.flags.All then
                    LocalPlayer.Character.Humanoid.Sit = false
                    LocalPlayer.Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame
                end
                if Library.flags.All or Library.flags.Aura and Distance < 15 then
                    ReplicatedStorage.meleeEvent:FireServer(v)
                end
            end
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
            Character.BillboardGui.TextLabel.Text = v.Name.."\nHealth: "..math.round(Health).."\nDistance: "..math.round(Distance)
            Character.BillboardGui.TextLabel.TextColor = v.TeamColor
            Character.Highlight.FillColor = v.TeamColor.Color
        end
    end)
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
