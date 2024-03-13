LP = game.Players.LocalPlayer
Locale = _G.Language[LP.LocaleId] or _G.Language["en-us"]
HRP = "HumanoidRootPart"
RS = game.ReplicatedStorage
Time = LP.PlayerGui.TimerUI.RaceTimer
Tween = game.TweenService:Create(LP.Character[HRP], TweenInfo.new(), {
    CFrame = workspace.LoadedWorld.Track:GetChildren()[#workspace.LoadedWorld.Track:GetChildren()].Sign.CFrame-Vector3.new(0, 20, 0)
})

Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/nahida-cn/Roblox/main/Library.lua"))()

Window = Library:Window("SH", Locale.RC)

Player = Window:Tab(Locale.Player)

Player:Slider(Locale.WS, 0, 200, LP.Character.Humanoid.WalkSpeed, function(Value)
    LP.Character.Humanoid.WalkSpeed = Value
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

Fly = Window:Tab(Locale.Fly)

Fly:Slider(Locale.Speed, 0, 200, 1, function(Value)
    Speed = Value
end)

Fly:Toggle(Locale.Toggle, false, function(Value)
    Toggle = Value
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

Auto:Toggle(Locale.RB, false, function(Value)
    Rebirth = Value
end)

Auto:Toggle(Locale.Click, false, function(Value)
    Click = Value
end)

Auto:Toggle(Locale.Race, false, function(Value)
    Race = Value
    Play()
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

function Play()
    if Race and Time.Visible then
        Tween:Play()
    end
end

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

LP.leaderstats["🏁Wins"].Changed:Connect(function()
    if Rebirth then
        RS.Packages.Knit.Services.RebirthService.RF.Rebirth:InvokeServer()
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
        if LT and string.find(v[Type], Name) then
            LP.Character.Humanoid.Sit = false
            LP.Character[HRP].CFrame = v.Character[HRP].CFrame
        end
    end
    if Click and LP.PlayerGui.ClicksUI.ClickHelper.Visible then
        RS.Packages.Knit.Services.ClickService.RF.Click:InvokeServer()
    end
end)

Tween.Completed:Connect(Play)

Time:GetPropertyChangedSignal("Visible"):Connect(Play)
