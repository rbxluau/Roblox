ReplicatedStorage = game:GetService("ReplicatedStorage")
UserInputService = game:GetService("UserInputService")
VirtualUser = game:GetService("VirtualUser")
RunService = game:GetService("RunService")
Lighting = game:GetService("Lighting")
Players = game:GetService("Players")
Teams = game:GetService("Teams")
LocalPlayer = Players.LocalPlayer
HRP = "HumanoidRootPart"

Library, Locale = loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/Library.lua"))()

Window = Library:Window(Locale.PrisonLife)

Section = Window:Tab(Locale.Player):Section("Main", true)

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

Section = Window:Tab(Locale.Teleport):Section("Main", true)

Section:Button(Locale.Armory, function()
    LocalPlayer.Character:MoveTo(Vector3.new(835, 100, 2267))
end)

Section:Button(Locale.Warehouse, function()
    LocalPlayer.Character:MoveTo(Vector3.new(-943, 94, 2064))
end)

Section:Button(Locale.Prison, function()
    LocalPlayer.Character:MoveTo(Vector3.new(919, 100, 2379))
end)

Section:Button(Locale.Yard, function()
    LocalPlayer.Character:MoveTo(Vector3.new(780, 98, 2459))
end)

Section:Button(Locale.Roof, function()
    LocalPlayer.Character:MoveTo(Vector3.new(907, 139, 2309))
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

Player = Section:Dropdown(Locale.Player, "Player", (function()
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
        HB = Instance.new("HopperBin", LocalPlayer.Backpack)
        HB.BinType = i
    end
end)

Section:Button(Locale.ClickTP, function()
    Tool = Instance.new("Tool", LocalPlayer.Backpack)
    Tool.RequiresHandle = false
    Tool.Activated:Connect(function()
        LocalPlayer.Character[HRP].CFrame = LocalPlayer:GetMouse().Hit+Vector3.new(0, 2.5, 0)
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
        Position = LocalPlayer.Character[HRP].CFrame
        if LocalPlayer.Team == Teams.Criminals then
            workspace.Remote.TeamEvent:FireServer("Bright orange")
        else
            workspace.Remote.TeamEvent:FireServer(LocalPlayer.TeamColor.Name)
        end
        LocalPlayer.CharacterAppearanceLoaded:Wait()
        LocalPlayer.Character[HRP].CFrame = Position
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
        LocalPlayer.Character[HRP].Velocity = Vector3.zero
    end
    if Library.flags.Player and (Library.flags.Teleport or Library.flags.Kill) then
        LocalPlayer.Character.Humanoid.Sit = false
        LocalPlayer.Character[HRP].CFrame = Players[Library.flags.Player].Character[HRP].CFrame
    end
    if Library.flags.Player and Library.flags.Kill then
        ReplicatedStorage.meleeEvent:FireServer(Players[Library.flags.Player])
    end
    for i, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character.Humanoid.Health ~= 0 and not v.Character:FindFirstChild("ForceField") then
            if Library.flags.All then
                LocalPlayer.Character.Humanoid.Sit = false
                LocalPlayer.Character[HRP].CFrame = v.Character[HRP].CFrame
            end
            if Library.flags.Aura and LocalPlayer:DistanceFromCharacter(v.Character.Head.Position) < 15 or Library.flags.All then
                ReplicatedStorage.meleeEvent:FireServer(v)
            end
        end
        if not v.Character:FindFirstChild("Highlight") then
            Instance.new("Highlight", v.Character)
            BG = Instance.new("BillboardGui", v.Character)
            TL = Instance.new("TextLabel", BG)
            BG.AlwaysOnTop = true
            BG.Size = UDim2.new(0, 100, 0, 50)
            BG.StudsOffset = Vector3.new(0, 4, 0)
            TL.BackgroundTransparency = 1
            TL.Size = UDim2.new(0, 100, 0, 50)
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
