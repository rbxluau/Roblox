ProximityPromptService = game:GetService("ProximityPromptService")
UserInputService = game:GetService("UserInputService")
RunService = game:GetService("RunService")
Players = game:GetService("Players")
LocalPlayer = Players.LocalPlayer
Locale = _G.Language[LocalPlayer.LocaleId] or _G.Language["en-us"]
HRP = "HumanoidRootPart"

Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/nahida-cn/Roblox/main/Library.lua"))()

Window = Library:Window("SH", Locale.BB)

Player = Window:Tab(Locale.Player)

Player:Slider(Locale.WS, 0, 200, LocalPlayer.Character.Humanoid.WalkSpeed, function(Value)
    LocalPlayer.Character.Humanoid.WalkSpeed = Value
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
        LocalPlayer.Character.Humanoid:ChangeState("Flying")
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
        LocalPlayer.Character.Humanoid:SetStateEnabled(v, not Toggle)
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
        HB = Instance.new("HopperBin", LocalPlayer.Backpack)
        HB.BinType = i
    end
end)

Other:Button(Locale.CT, function()
    Tool = Instance.new("Tool", LocalPlayer.Backpack)
    Tool.RequiresHandle = false
    Tool.Activated:Connect(function()
        LocalPlayer.Character[HRP].CFrame = LocalPlayer:GetMouse().Hit+Vector3.new(0, 2.5, 0)
    end)
end)

Other:Dropdown(Locale.Camera, LocalPlayer.CameraMode.Name, {"Classic", "LockFirstPerson"}, function(Value)
    LocalPlayer.CameraMode = Value
end)

About = Window:Tab(Locale.About)

About:Label(Locale.By)

About:Button(Locale.Copy, function()
    setclipboard(Locale.Link)
end)

UserInputService.JumpRequest:Connect(function()
    if Jump then
        LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

RunService.Stepped:Connect(function()
    if Noclip then
        for i, v in pairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

ProximityPromptService.PromptButtonHoldBegan:Connect(function(v)
    if Fast then
        v.HoldDuration = 0
    end
end)

RunService.Heartbeat:Connect(function()
    if Toggle then
        LocalPlayer.Character.Humanoid:ChangeState("Swimming")
        LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection*Speed)
        LocalPlayer.Character[HRP].Velocity = Vector3.zero
    end
    for i, v in pairs(Players:GetPlayers()) do
        if LT and string.find(v[Type], Name) then
            LocalPlayer.Character.Humanoid.Sit = false
            LocalPlayer.Character[HRP].CFrame = v.Character[HRP].CFrame
        end
    end
    for i, v in pairs(workspace.Balls:GetChildren()) do
        if v:GetAttribute("realBall") and LocalPlayer.Character:FindFirstChild("Highlight") then
            Velocity = (v.Velocity-LocalPlayer.Character[HRP].Velocity).Magnitude
            if Teleport and Velocity ~= 0 then
                LocalPlayer.Character[HRP].CFrame = v.CFrame
            end
            if Parry and LocalPlayer:DistanceFromCharacter(v.Position)/Velocity < 0.5 then
                keypress(0x46)
            end
        end
    end
end)
