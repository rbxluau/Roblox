LP = game.Players.LocalPlayer
Locale = _G.Language[LP.LocaleId] or _G.Language["en-us"]
HRP = "HumanoidRootPart"
RS = game.ReplicatedStorage
Prompt = {
    "ActivateEventPrompt",
    "AwesomePrompt",
    "ModulePrompt",
    "UnlockPrompt",
    "LootPrompt"
}
List = {}

function Warn(v)
    game.StarterGui:SetCore("SendNotification", {
    Title = "Warning",
    Text = v
    })
end

Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/nahida-cn/Roblox/main/Library.lua"))()

Window = Library:Window("SH", "Doors")

Player = Window:Tab(Locale.Player)

Player:Slider(Locale.WS, 0, 200, LP.Character.Humanoid.WalkSpeed, function(Value)
    LP.Character.Humanoid.WalkSpeed = Value
end)

Player:Slider(Locale.Gravity, 0, 200, math.round(workspace.Gravity), function(Value)
    workspace.Gravity = Value
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
end)

Auto = Window:Tab(Locale.Auto)

Auto:Toggle(Locale.Interact, false, function(Value)
    AI = Value
end)

ESP = Window:Tab(Locale.ESP)

ESP:Toggle(Locale.Player, false, function(Value)
    EP = Value
end)

ESP:Toggle(Locale.Monster, false, function(Value)
    Monster = Value
end)

ESP:Toggle(Locale.Door, false, function(Value)
    Door = Value
end)

ESP:Toggle(Locale.Other, false, function(Value)
    EO = Value
end)

Remove = Window:Tab(Locale.Remove)

Remove:Button("Screech", function()
    RS.EntityInfo.Screech:Destroy()
end)

Remove:Toggle("Seek", false, function(Value)
    Seek = Value
end)

Other = Window:Tab(Locale.Other)

Other:Button(Locale.UD, function()
    Hint = {"x", "x", "x", "x", "x"}
    Paper = LP.Backpack:FindFirstChild("LibraryHintPaper") or LP.Character:FindFirstChild("LibraryHintPaper")
    if Paper then
        for h = 1, 5 do
            for i, v in pairs(LP.PlayerGui.PermUI.Hints:GetChildren()) do
                if v:IsA("ImageLabel") and v.ImageRectOffset == Paper.UI[h].ImageRectOffset then
                    Hint[h] = v.TextLabel.Text
                end
            end
        end
        RS.EntityInfo.PL:FireServer(table.concat(Hint))
        Warn(table.concat(Hint))
    else
        Warn("Hint Paper Not Find")
    end
end)

Other:Button(Locale.BT, function()
    for i = 3, 4 do
        HB = Instance.new("HopperBin", LP.Backpack)
        HB.BinType = i
    end
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

game.ProximityPromptService.PromptShown:Connect(function(v)
    if AI and table.find(Prompt, v.Name) and not table.find(List, v) then
        v:InputHoldBegin()
        if v.Name == Prompt[1] then
            table.insert(List, v)
        end
    end
end)

workspace.ChildAdded:Connect(function(v)
    if Monster and v:IsA("Model") and task.wait() and LP:DistanceFromCharacter(v:GetPivot().Position) < 1000 then
        Warn(v.Name)
    end
end)

RS.GameData.LatestRoom.Changed:Connect(function(r)
    Room = workspace.CurrentRooms[r]
    if Door then
        Instance.new("Highlight", Room.Door)
    end
    for i, v in pairs(Room.Assets:GetDescendants()) do
        if EO and v:IsA("ProximityPrompt") then
            Instance.new("Highlight", v.Parent)
        end
    end
    if Seek and Room:FindFirstChild("TriggerEventCollision") then
        Room.TriggerEventCollision:Destroy()
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
