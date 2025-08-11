local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Head

local Library, Locale = loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/Library.lua"))()

local Window = Library:Window(Locale.Arsenal)

local Section = Window:Tab(Locale.Player):Section("Main", true)

Section:Slider(Locale.Boost, "Boost", 0, 0, 20, true)

Section:Toggle(Locale.Fly, "Fly", false, function(value)
    for _, v in Enum.HumanoidStateType:GetEnumItems() do
        LocalPlayer.Character.Humanoid:SetStateEnabled(v, not value)
    end
end)

Section:Toggle(Locale.Noclip, "Noclip", false, function(value)
    if not value then
        LocalPlayer.Character.Humanoid:ChangeState("Flying")
    end
end)

Section = Window:Tab(Locale.Aimbot):Section("Main", true)

Section:Toggle(Locale.Team, "Team")

Section:Toggle(Locale.Toggle, "Aimbot")

local Shoot = Section:Toggle(Locale.Shoot, "Shoot")

Section:Keybind(Locale.Shoot, "Backquote", function()
    Shoot:SetState()
end)

Section = Window:Tab(Locale.Loop):Section("Main", true)

local Player = Section:Dropdown(Locale.Player, "Player", (function()
    local PlayerList = Players:GetPlayers()
    for i, v in PlayerList do
        PlayerList[i] = v.Name
    end
    return PlayerList
end)())

Section:Toggle(Locale.Teleport, "Teleport")

Section = Window:Tab(Locale.ESP):Section("Main", true)

Section:Toggle(Locale.Player, "ESP")

Section = Window:Tab(Locale.About):Section("Main", true)

Section:Label(Locale.By)

Section:Button(Locale.Copy, function()
    setclipboard(Locale.Link)
end)

RunService.PreSimulation:Connect(function()
    if Library.flags.Noclip then
        for _, v in LocalPlayer.Character:GetChildren() do
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
        for _, v in Players:GetPlayers() do
            local Character = v.Character
            local Distance = LocalPlayer:DistanceFromCharacter(Character.Head.Position)
            if v ~= LocalPlayer and (Library.flags.Team or v.Team ~= LocalPlayer.Team) and #Camera:GetPartsObscuringTarget(
                {Character.Head.Position},
                {LocalPlayer.Character, Character}
            ) == 0 and (not Head or Distance < LocalPlayer:DistanceFromCharacter(Head.Position)) then
                Head = Character.Head
            end
            if not Character:FindFirstChild("Highlight") then
                Instance.new("Highlight", Character)
                local BillboardGui = Instance.new("BillboardGui", Character)
                local TextLabel = Instance.new("TextLabel", BillboardGui)
                BillboardGui.AlwaysOnTop = true
                BillboardGui.Size = UDim2.new(0, 100, 0, 50)
                BillboardGui.StudsOffset = Vector3.new(0, 4, 0)
                TextLabel.BackgroundTransparency = 1
                TextLabel.Size = UDim2.new(0, 100, 0, 50)
            end
            Character.BillboardGui.Enabled = Library.flags.ESP
            Character.Highlight.Enabled = Library.flags.ESP
            Character.BillboardGui.TextLabel.Text = v.Name.."\nHealth: "..math.round(Character.Humanoid.Health).."\nDistance: "..math.round(Distance)
            Character.BillboardGui.TextLabel.TextColor = v.TeamColor
            Character.Highlight.FillColor = v.TeamColor.Color
        end
        if Library.flags.Aimbot then
            if Head then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Head.Position)
                if Library.flags.Shoot then
                    mouse1press()
                end
                Head = nil
            elseif Library.flags.Shoot then
                mouse1release()
            end
        end
    end)
end)
