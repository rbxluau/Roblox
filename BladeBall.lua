LP = game.Players.LocalPlayer
Locale = _G.Language[LP.LocaleId] or _G.Language["en-us"]
HRP = "HumanoidRootPart"

Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/nahida-cn/Roblox/main/Library.lua"))()

Window = Library:Window("SH", Locale.BB)

Player = Window:Tab(Locale.Player)

Player:Slider(Locale.WS, 0, 200, LP.Character.Humanoid.WalkSpeed, function(Value)
    LP.Character.Humanoid.WalkSpeed = Value
end)

Player:Slider(Locale.Gravity, 0, 200, workspace.Gravity, function(Value)
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

Interact = Window:Tab(Locale.Interact)

Interact:Toggle(Locale.Fast, false, function(Value)
    Fast = Value
end)

Fly = Window:Tab(Locale.Fly)

Fly:Slider(Locale.Speed, 0, 200, 1, function(Value)
    Speed = Value
end)

Fly:Toggle(Locale.Toggle, false, function(Value)
    Toggle = Value
    for i, v in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        LP.Character.Humanoid:SetStateEnabled(v, not Toggle)
    end
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

Auto = Window:Tab(Locale.Auto)

Auto:Toggle(Locale.Parry, false, function(Value)
    Parry = Value
end)

Auto:Toggle(Locale.TP, false, function(Value)
    Teleport = Value
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

game.ProximityPromptService.PromptButtonHoldBegan:Connect(function(v)
    if Fast then
        v.HoldDuration = 0
    end
end)

game.RunService.Heartbeat:Connect(function()
    if Toggle then
        LP.Character.Humanoid:ChangeState("Swimming")
        LP.Character:TranslateBy(LP.Character.Humanoid.MoveDirection*Speed)
        LP.Character[HRP].Velocity = Vector3.zero
    end
    for i, v in pairs(game.Players:GetPlayers()) do
        if LT and string.find(v[Type], Name) then
            LP.Character.Humanoid.Sit = false
            LP.Character[HRP].CFrame = v.Character[HRP].CFrame
        end
    end
    for i, v in pairs(workspace.Balls:GetChildren()) do
        if Parry and v:GetAttribute("realBall") and LP.Character:FindFirstChild("Highlight") then
            Velocity = (v.Velocity-LP.Character[HRP].Velocity).Magnitude
            if Teleport and Velocity ~= 0 then
                LP.Character[HRP].CFrame = v.CFrame
            end
            if LP:DistanceFromCharacter(v.Position)/Velocity < 0.5 then
                game.VirtualInputManager:SendKeyEvent(true, "F", false, game)
            end
        end
    end
end)
