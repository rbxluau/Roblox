LP = game.Players.LocalPlayer
Locale = _G.Language[LP.LocaleId] or _G.Language["en-us"]
RS = game.ReplicatedStorage

Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/nahida-cn/Roblox/main/Library.lua"))()

Window = Library:Window("SH", Locale.RF)

Player = Window:Tab(Locale.Player)

Player:Slider(Locale.WS, 0, 200, LP.Character.Humanoid.WalkSpeed, function(Value)
    LP.Character.Humanoid.WalkSpeed = Value
end)

Player:Toggle(Locale.Noclip, false, function(Value)
    Noclip = Value
    if not Noclip then
        LP.Character.Humanoid:ChangeState("Jumping")
    end
end)

Player:Toggle(Locale.Invisible, false, function(Value)
    Invisible = Value
    if not Invisible then
        RS.communication.boxes.cl.BoxUpdated:FireServer("Unequip")
    end
end)

Fly = Window:Tab(Locale.Fly)

Fly:Slider(Locale.Speed, 0, 200, 1, function(Value)
    Speed = Value
end)

Fly:Toggle(Locale.Toggle, false, function(Value)
    Toggle = Value
end)

Auto = Window:Tab(Locale.Auto)

Auto:Toggle(Locale.Get, false, function(Value)
    Get = Value
end)

Auto:Toggle(Locale.Put, false, function(Value)
    Put = Value
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

ESP:Toggle(Locale.Other, false, function(Value)
    EO = Value
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
        LP.Character.HumanoidRootPart.CFrame = LP:GetMouse().Hit+Vector3.new(0, 2.5, 0)
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

About = Window:Tab(Locale.About)

About:Label(Locale.By)

About:Button(Locale.Copy, function()
    setclipboard(Locale.Link)
end)

game.RunService.Stepped:Connect(function()
    if Noclip then
        for i, v in pairs(LP.Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
    if Invisible then
        RS.communication.boxes.cl.BoxUpdated:FireServer("Equip")
    end
end)

game.RunService.Heartbeat:Connect(function()
    for i, v in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        LP.Character.Humanoid:SetStateEnabled(v, not Toggle)
    end
    if Toggle then
        LP.Character.Humanoid:ChangeState("Swimming")
        LP.Character:TranslateBy(LP.Character.Humanoid.MoveDirection*Speed)
        LP.Character.HumanoidRootPart.Velocity = Vector3.zero
    end
    if Get then
        Model = {
            "Block"..math.random(1, 24),
            "FoodOrange",
            "FoodPink",
            "FoodGreen",
            "Fuse"..math.random(1, 14),
            "Battery",
            "LightBulb",
            "GasCanister",
            "CakeMix"
        }
        for i, v in pairs(workspace:GetChildren()) do
            if table.find(Model, v.Name) then
                v.TouchTrigger.CFrame = LP.Character.HumanoidRootPart.CFrame
            end
        end
    end
    if Put then
        for i, v in pairs(workspace.GroupBuildStructures:GetChildren()) do
            v.Trigger.CFrame = LP.Character.HumanoidRootPart.CFrame
        end
    end
    for i, v in pairs(game.Players:GetPlayers()) do
        if LT and string.find(v[Type], Name) then
            LP.Character.Humanoid.Sit = false
            LP.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
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
        v.Character.BillboardGui.TextLabel.Text = v.Name.."\nHealth: "..math.round(v.Character.Humanoid.Health).."\nDistance: "..math.round((v.Character.HumanoidRootPart.Position-LP.Character.HumanoidRootPart.Position).Magnitude)
        v.Character.BillboardGui.TextLabel.TextColor = v.TeamColor
        v.Character.BillboardGui.Enabled = EP
        v.Character.Highlight.Enabled = EP
    end
    for i, v in pairs(workspace.ignore:GetChildren()) do
        if v.Name == "Looky" then
            v.Highlight.Enabled = EO
        end
    end
end)

game.Lighting.LightingChanged:Connect(function()
    if Light then
        game.Lighting.Ambient = Color3.new(1, 1, 1)
    end
end)
