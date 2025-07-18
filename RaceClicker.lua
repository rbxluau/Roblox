local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Track = workspace.LoadedWorld.Track
local Time = LocalPlayer.PlayerGui.TimerUI.RaceTimer
local Services = ReplicatedStorage.Packages.Knit.Services
local Tween = TweenService:Create(LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(), {
    CFrame = Track:GetChildren()[#Track:GetChildren()].Sign.CFrame-Vector3.yAxis*20
})

local Library, Locale = loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/Library.lua"))()

local function Play()
    if Library.flags.Race and Time.Visible then
        Tween:Play()
    end
end

local Window = Library:Window(Locale.RaceClicker)

local Section = Window:Tab(Locale.Player):Section("Main", true)

Section:Slider(Locale.Gravity, "Gravity", math.round(workspace.Gravity), 0, 200, false, function(value)
    workspace.Gravity = value
end)

Section:Slider(Locale.Boost, "Boost", 0, 0, 200)

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

Section = Window:Tab(Locale.Loop):Section("Main", true)

local Player = Section:Dropdown(Locale.Player, "Player", (function()
    local PlayerList = Players:GetPlayers()
    for i, v in pairs(PlayerList) do
        PlayerList[i] = v.Name
    end
    return PlayerList
end)())

Section:Toggle(Locale.Teleport, "Teleport")

Section = Window:Tab(Locale.Auto):Section("Main", true)

Section:Toggle(Locale.Rebirth, "Rebirth")

Section:Toggle(Locale.Click, "Click")

Section:Toggle(Locale.Race, "Race", false, Play)

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
        for _, v in pairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

LocalPlayer.leaderstats["🏁Wins"].Changed:Connect(function()
    if Library.flags.Rebirth then
        Services.RebirthService.RF.Rebirth:InvokeServer()
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
        if Library.flags.Player and Library.flags.Teleport then
            LocalPlayer.Character.Humanoid.Sit = false
            LocalPlayer.Character.HumanoidRootPart.CFrame = Players[Library.flags.Player].Character.HumanoidRootPart.CFrame
        end
        if Library.flags.Click and LocalPlayer.PlayerGui.ClicksUI.ClickHelper.Visible then
            Services.ClickService.RF.Click:InvokeServer()
        end
    end)
end)

Tween.Completed:Connect(Play)

Time:GetPropertyChangedSignal("Visible"):Connect(Play)
