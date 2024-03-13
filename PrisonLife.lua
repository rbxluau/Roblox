LP = game.Players.LocalPlayer
Locale = _G.Language[LP.LocaleId] or _G.Language["en-us"]
HRP = "HumanoidRootPart"
RS = game.ReplicatedStorage

Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/nahida-cn/Roblox/main/Library.lua"))()

Window = Library:Window("SH", Locale.PL)

Player = Window:Tab(Locale.Player)

Player:Slider(Locale.WS, 0, 200, LP.Character.Humanoid.WalkSpeed, function(Value)
    LP.Character.Humanoid.WalkSpeed = Value
end)

Player:Slider(Locale.JP, 0, 200, LP.Character.Humanoid.JumpPower, function(Value)
    LP.Character.Humanoid.JumpPower = Value
end)

Player:Slider(Locale.Gravity, 0, 200, math.round(workspace.Gravity), function(Value)
    workspace.Gravity = Value
end)

Player:Toggle(Locale.IJ, false, function(Value)
    Jump = Value
end)

Player:Toggle(Locale.Noclip, false, function(Value)
    Noclip = Value
    if not Noclip then
        LP.Character.Humanoid:ChangeState("Jumping")
    end
end)

Teleport = Window:Tab(Locale.TP)

Teleport:Button(Locale.Armory, function()
    LP.Character:MoveTo(Vector3.new(835, 100, 2267))
end)

Teleport:Button(Locale.WH, function()
    LP.Character:MoveTo(Vector3.new(-943, 94, 2064))
end)

Teleport:Button(Locale.Prison, function()
    LP.Character:MoveTo(Vector3.new(919, 100, 2379))
end)

Teleport:Button(Locale.Yard, function()
    LP.Character:MoveTo(Vector3.new(780, 98, 2459))
end)

Teleport:Button(Locale.Roof, function()
    LP.Character:MoveTo(Vector3.new(907, 139, 2309))
end)

Team = Window:Tab(Locale.Team)

Team:Button(Locale.Guard, function()
    workspace.Remote.TeamEvent:FireServer("Bright blue")
end)

Team:Button(Locale.Inmate, function()
    workspace.Remote.TeamEvent:FireServer("Bright orange")
end)

Team:Button(Locale.Neutral, function()
    workspace.Remote.TeamEvent:FireServer("Medium stone grey")
end)

Fly = Window:Tab(Locale.Fly)

Fly:Slider(Locale.Speed, 0, 200, 1, function(Value)
    Speed = Value
end)

Fly:Toggle(Locale.Toggle, false, function(Value)
    Toggle = Value
end)

Kill = Window:Tab(Locale.Kill)

Kill:Toggle(Locale.Aura, false, function(Value)
    Aura = Value
end)

Kill:Toggle(Locale.All, false, function(Value)
    All = Value
end)

Loop = Window:Tab(Locale.Loop)

Loop:Dropdown(Locale.Type, "DisplayName", {"DisplayName", "Name"}, function(Value)
    Type = Value
end)

Loop:Textbox(Locale.Name, "", true, function(Value)
    Name = Value
end)

Loop:Toggle(Locale.TP, false, function(Value)
    LT = Value
end)

Loop:Toggle(Locale.Kill, false, function(Value)
    LK = Value
end)

Auto = Window:Tab(Locale.Auto)

Auto:Toggle(Locale.RB, false, function(Value)
    Rebirth = Value
end)

ESP = Window:Tab(Locale.ESP)

ESP:Toggle(Locale.Player, false, function(Value)
    EP = Value
end)

Other = Window:Tab(Locale.Other)

Other:Button(Locale.BT, function()
    for i = 3, 4 do
        HB = Instance.new("HopperBin", LP.Backpack)
        HB.BinType = i
    end
end)

Other:Button(Locale.CT, function()
    Tool = Instance.new("Tool", LP.Backpack)
    Tool.RequiresHandle = false
    Tool.Activated:Connect(function()
        LP.Character[HRP].CFrame = LP:GetMouse().Hit+Vector3.new(0, 2.5, 0)
    end)
end)

Other:Dropdown(Locale.Camera, LP.CameraMode.Name, {"Classic", "LockFirstPerson"}, function(Value)
    LP.CameraMode = Value
end)

Other:Toggle(Locale.FB, false, function(Value)
    Light = Value
    if Light then
        game.Lighting.Ambient = Color3.new(1, 1, 1)
    else
        game.Lighting.Ambient = Color3.new(0, 0, 0)
    end
end)

Other:Toggle(Locale.AFK, false, function(Value)
    AFK = Value
end)

About = Window:Tab(Locale.About)

About:Label(Locale.By)

About:Button(Locale.Copy, function()
    setclipboard(Locale.Link)
end)

game.UserInputService.JumpRequest:Connect(function()
    if Jump then
        LP.Character.Humanoid:ChangeState("Jumping")
    end
end)

game.RunService.Stepped:Connect(function()
    if Noclip then
        for i, v in pairs(LP.Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

LP.CharacterAppearanceLoaded:Connect(function(v)
    v.Humanoid.Died:Wait()
    if Rebirth then
        Position = LP.Character[HRP].CFrame
        if LP.Team.Name == "Criminals" then
            workspace.Remote.TeamEvent:FireServer("Bright orange")
        else
            workspace.Remote.TeamEvent:FireServer(LP.TeamColor.Name)
        end
        LP.CharacterAppearanceLoaded:Wait()
        LP.Character[HRP].CFrame = Position
    end
end)

game.RunService.Heartbeat:Connect(function()
    for i, v in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        LP.Character.Humanoid:SetStateEnabled(v, not Toggle)
    end
    if Toggle then
        LP.Character.Humanoid:ChangeState("Swimming")
        LP.Character:TranslateBy(LP.Character.Humanoid.MoveDirection*Speed)
        LP.Character[HRP].Velocity = Vector3.zero
    end
    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= LP and v.Character.Humanoid.Health ~= 0 and not v.Character:FindFirstChild("ForceField") then
            if All then
                LP.Character.Humanoid.Sit = false
                LP.Character[HRP].CFrame = v.Character[HRP].CFrame
            end
            if Aura or All then
                RS.meleeEvent:FireServer(v)
            end
        end
        if string.find(v[Type], Name) then
            if LT or LK then
                LP.Character.Humanoid.Sit = false
                LP.Character[HRP].CFrame = v.Character[HRP].CFrame
            end
            if LK then
                RS.meleeEvent:FireServer(v)
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
        v.Character.BillboardGui.TextLabel.Text = v.Name.."\nHealth: "..math.round(v.Character.Humanoid.Health).."\nDistance: "..math.round(LP:DistanceFromCharacter(v.Character.Head.Position))
        v.Character.BillboardGui.TextLabel.TextColor = v.TeamColor
        v.Character.BillboardGui.Enabled = EP
        v.Character.Highlight.Enabled = EP
    end
end)

game.Lighting.LightingChanged:Connect(function()
    if Light then
        game.Lighting.Ambient = Color3.new(1, 1, 1)
    end
end)

LP.Idled:Connect(function()
    if AFK then
        game.VirtualUser:MoveMouse(Vector2.new())
    end
end)
