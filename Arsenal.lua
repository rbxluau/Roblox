RunService = game:GetService("RunService")
Players = game:GetService("Players")
LocalPlayer = Players.LocalPlayer
Locale = _G.Language[LocalPlayer.LocaleId] or _G.Language["en-us"]
HRP = "HumanoidRootPart"
Camera = workspace.CurrentCamera
Sort = {}
Head = {}

Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/nahida-cn/Roblox/main/Library.lua"))()

Window = Library:Window("SH", Locale.Arsenal)

Player = Window:Tab(Locale.Player)

Player:Toggle(Locale.Noclip, false, function(Value)
    Noclip = Value
    if not Noclip then
        LocalPlayer.Character.Humanoid:ChangeState("Flying")
    end
end)

Player:Toggle(Locale.Aimbot, false, function(Value)
    Aimbot = Value
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

ESP = Window:Tab(Locale.ESP)

ESP:Toggle(Locale.Player, false, function(Value)
    EP = Value
end)

About = Window:Tab(Locale.About)

About:Label(Locale.By)

About:Button(Locale.Copy, function()
    setclipboard(Locale.Link)
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

RunService.Heartbeat:Connect(function()
    if Toggle then
        LocalPlayer.Character.Humanoid:ChangeState("Swimming")
        LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection*Speed)
        LocalPlayer.Character[HRP].Velocity = Vector3.zero
    end
    for i, v in pairs(Players:GetPlayers()) do
        if Aimbot and v.Team ~= LocalPlayer.Team and v.CanLoadCharacterAppearance and #Camera:GetPartsObscuringTarget({v.Character.Head.Position}, {LocalPlayer.Character, v.Character}) == 0 then
            Distance = math.round(LocalPlayer:DistanceFromCharacter(v.Character.Head.Position))
            table.insert(Sort, Distance)
            Head[Distance] = v.Character.Head
        end
        if LT and string.find(v[Type], Name) then
            LocalPlayer.Character.Humanoid.Sit = false
            LocalPlayer.Character[HRP].CFrame = v.Character[HRP].CFrame
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
        v.Character.BillboardGui.Enabled = EP
        v.Character.Highlight.Enabled = EP
    end
    if Aimbot and Sort[1] then
        table.sort(Sort)
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Head[Sort[1]].Position)
        Sort = {}
        Head = {}
    end
end)
