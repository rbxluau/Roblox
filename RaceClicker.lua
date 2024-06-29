ReplicatedStorage = game:GetService("ReplicatedStorage")
UserInputService = game:GetService("UserInputService")
TweenService = game:GetService("TweenService")
RunService = game:GetService("RunService")
Players = game:GetService("Players")
LocalPlayer = Players.LocalPlayer
HRP = "HumanoidRootPart"
Track = workspace.LoadedWorld.Track
Time = LocalPlayer.PlayerGui.TimerUI.RaceTimer
Tween = TweenService:Create(LocalPlayer.Character[HRP], TweenInfo.new(), {
    CFrame = Track:GetChildren()[#Track:GetChildren()].Sign.CFrame-Vector3.yAxis*20
})

Library, Locale = loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/Library.lua"))()

Window = Library:Window("SH", Locale.RC)

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

function Play()
    if Race and Time.Visible then
        Tween:Play()
    end
end

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

LocalPlayer.leaderstats["🏁Wins"].Changed:Connect(function()
    if Rebirth then
        ReplicatedStorage.Packages.Knit.Services.RebirthService.RF.Rebirth:InvokeServer()
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
    if Click and LocalPlayer.PlayerGui.ClicksUI.ClickHelper.Visible then
        ReplicatedStorage.Packages.Knit.Services.ClickService.RF.Click:InvokeServer()
    end
end)

Tween.Completed:Connect(Play)

Time:GetPropertyChangedSignal("Visible"):Connect(Play)
