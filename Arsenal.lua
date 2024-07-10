RunService = game:GetService("RunService")
Players = game:GetService("Players")
LocalPlayer = Players.LocalPlayer
HRP = "HumanoidRootPart"
Camera = workspace.CurrentCamera
Sort = {}
Head = {}

function GetPlayers()
    local Players = Players:GetPlayers()
    for i, v in pairs(Players) do
        Players[i] = v.Name
    end
    return Players
end

Library, Locale = loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/Library.lua"))()

Window = Library:Window(Locale.Arsenal)

Section = Window:Tab(Locale.Player):Section("Main", true)

Section:Slider(Locale.Boost, "Boost", 0, 0, 200)

Section:Toggle(Locale.Fly, "Fly", false, function(Value)
    for i, v in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        LocalPlayer.Character.Humanoid:SetStateEnabled(v, not Value)
    end
end)

Section:Toggle(Locale.Noclip, "Noclip", false, function(Value)
    if not Value then
        LocalPlayer.Character.Humanoid:ChangeState("Flying")
    end
end)

Section = Window:Tab(Locale.Aimbot):Section("Main", true)

Section:Toggle(Locale.Team, "Team")

Section:Toggle(Locale.Toggle, "Aimbot")

Section = Window:Tab(Locale.Loop):Section("Main", true)

Player = Section:Dropdown(Locale.Player, "Player", GetPlayers())

Section:Toggle(Locale.Teleport, "Teleport")

Section = Window:Tab(Locale.ESP):Section("Main", true)

Section:Toggle(Locale.Player, "ESP")

Section = Window:Tab(Locale.About):Section("Main", true)

Section:Label(Locale.By)

Section:Button(Locale.Copy, function()
    setclipboard(Locale.Link)
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

Players.PlayerAdded:Connect(function(v)
    Player:AddOption(v.Name)
end)

Players.PlayerRemoving:Connect(function(v)
    Player:RemoveOption(v.Name)
end)

RunService.Heartbeat:Connect(function()
    LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection*Library.flags.Boost)
    if Library.flags.Fly then
        LocalPlayer.Character.Humanoid:ChangeState("Swimming")
        LocalPlayer.Character[HRP].Velocity = Vector3.zero
    end
    if Library.flags.Teleport then
        LocalPlayer.Character.Humanoid.Sit = false
        LocalPlayer.Character[HRP].CFrame = Players[Library.flags.Player].Character[HRP].CFrame
    end
    for i, v in pairs(Players:GetPlayers()) do
        if (Library.flags.Team or v.Team ~= LocalPlayer.Team) and v.CanLoadCharacterAppearance and #Camera:GetPartsObscuringTarget({v.Character.Head.Position}, {LocalPlayer.Character, v.Character}) == 0 then
            Distance = math.round(LocalPlayer:DistanceFromCharacter(v.Character.Head.Position))
            table.insert(Sort, Distance)
            Head[Distance] = v.Character.Head
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
        v.Character.Highlight.FillColor = v.TeamColor.Color
        v.Character.BillboardGui.Enabled = Library.flags.ESP
        v.Character.Highlight.Enabled = Library.flags.ESP
    end
    if Library.flags.Aimbot and Sort[1] then
        table.sort(Sort)
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Head[Sort[1]].Position)
        Sort = {}
        Head = {}
    end
end)
