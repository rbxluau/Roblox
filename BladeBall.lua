ProximityPromptService = game:GetService("ProximityPromptService")
UserInputService = game:GetService("UserInputService")
RunService = game:GetService("RunService")
Players = game:GetService("Players")
LocalPlayer = Players.LocalPlayer
HRP = "HumanoidRootPart"

function GetPlayers()
    local Players = Players:GetPlayers()
    for i, v in pairs(Players) do
        Players[i] = v.Name
    end
    return Players
end

Library, Locale = loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/Library.lua"))()

Window = Library:Window(Locale.BladeBall)

Section = Window:Tab(Locale.Player):Section("Main", true)

Section:Slider(Locale.Gravity, "Gravity", math.round(workspace.Gravity), 0, 200, false, function(Value)
    workspace.Gravity = Value
end)

Section:Slider(Locale.Boost, "Boost", 0, 0, 200)

Section:Toggle(Locale.InfJump, "InfJump")

Section:Toggle(Locale.Noclip, "Noclip", false, function(Value)
    if not Value then
        LocalPlayer.Character.Humanoid:ChangeState("Flying")
    end
end)

Section = Window:Tab(Locale.Interact):Section("Main", true)

Section:Toggle(Locale.Fast, "Fast")

Section = Window:Tab(Locale.Loop):Section("Main", true)

Player = Section:Dropdown(Locale.Player, "Player", GetPlayers())

Section:Toggle(Locale.Teleport, "Teleport")

Section = Window:Tab(Locale.Auto):Section("Main", true)

Section:Toggle(Locale.Parry, "Parry")

Section:Toggle(Locale.Teleport, "AutoTP")

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

ProximityPromptService.PromptButtonHoldBegan:Connect(function(v)
    if Library.flags.Fast then
        v.HoldDuration = 0
    end
end)

RunService.Heartbeat:Connect(function()
    LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection*Library.flags.Boost)
    if Library.flags.Teleport then
        LocalPlayer.Character.Humanoid.Sit = false
        LocalPlayer.Character[HRP].CFrame = Players[Library.flags.Player].Character[HRP].CFrame
    end
    for i, v in pairs(workspace.Balls:GetChildren()) do
        if v:GetAttribute("realBall") and LocalPlayer.Character:FindFirstChild("Highlight") then
            Velocity = (v.Velocity-LocalPlayer.Character[HRP].Velocity).Magnitude
            if Library.flags.AutoTP and Velocity ~= 0 then
                LocalPlayer.Character[HRP].CFrame = v.CFrame
            end
            if Library.flags.Parry and LocalPlayer:DistanceFromCharacter(v.Position)/Velocity < 0.5 then
                keypress(0x46)
            end
        end
    end
end)
