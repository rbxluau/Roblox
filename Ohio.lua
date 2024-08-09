ProximityPromptService = game:GetService("ProximityPromptService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
UserInputService = game:GetService("UserInputService")
VirtualUser = game:GetService("VirtualUser")
RunService = game:GetService("RunService")
Lighting = game:GetService("Lighting")
Players = game:GetService("Players")
LocalPlayer = Players.LocalPlayer
HRP = "HumanoidRootPart"

Library, Locale = loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/Library.lua"))()

Window = Library:Window(Locale.Ohio)

Section = Window:Tab(Locale.Player):Section("Main", true)

Section:Slider(Locale.Jump, "Jump", math.round(LocalPlayer.Character.Humanoid.JumpPower), 0, 200, false, function(Value)
    LocalPlayer.Character.Humanoid.JumpPower = Value
end)

Section:Slider(Locale.Gravity, "Gravity", math.round(workspace.Gravity), 0, 200, false, function(Value)
    workspace.Gravity = Value
end)

Section:Slider(Locale.Boost, "Boost", 0, 0, 200)

Section:Toggle(Locale.Fly, "Fly", false, function(Value)
    for i, v in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        LocalPlayer.Character.Humanoid:SetStateEnabled(v, not Value)
    end
end)

Section:Toggle(Locale.InfJump, "InfJump")

Section:Toggle(Locale.Noclip, "Noclip", false, function(Value)
    if not Value then
        LocalPlayer.Character.Humanoid:ChangeState("Flying")
    end
end)

Section = Window:Tab(Locale.Interact):Section("Main", true)

Section:Toggle(Locale.Fast, "Fast")

Section = Window:Tab(Locale.Hit):Section("Main", true)

Section:Toggle(Locale.Aura, "Aura")

Section:Toggle(Locale.All, "All")

Section = Window:Tab(Locale.Kill):Section("Main", true)

Section:Toggle(Locale.Aura, "KillAura")

Section:Toggle(Locale.All, "KillAll")

Section = Window:Tab(Locale.Loop):Section("Main", true)

Player = Section:Dropdown(Locale.Player, "Player", (function()
    local Players = Players:GetPlayers()
    for i, v in pairs(Players) do
        Players[i] = v.Name
    end
    return Players
end)())

Section:Toggle(Locale.Teleport, "Teleport")

Section:Toggle(Locale.Hit, "Hit")

Section:Toggle(Locale.Kill, "Kill")

Section = Window:Tab(Locale.Auto):Section("Main", true)

Section:Toggle(Locale.Clean, "Clean", false, function(Value)
    for i, v in pairs(workspace.Game.Local.Rubbish:GetChildren()) do
        if Value then
            fireclickdetector(v.PrimaryPart.ClickDetector)
        else
            break
        end
    end
end)

Section = Window:Tab(Locale.ESP):Section("Main", true)

Section:Toggle(Locale.Player, "ESP")

Section = Window:Tab(Locale.Other):Section("Main", true)

Section:Toggle(Locale.FullBright, "Light", false, function(Value)
    if Value then
        Lighting.Ambient = Color3.new(1, 1, 1)
    else
        Lighting.Ambient = Color3.new(0, 0, 0)
    end
end)

Section:Toggle(Locale.AFK, "AFK")

Section = Window:Tab(Locale.About):Section("Main", true)

Section:Label(Locale.By)

Section:Button(Locale.Copy, function()
    setclipboard(Locale.Link)
end)

Call = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    if self.Parent == ReplicatedStorage.devv.remoteStorage and #args ~= 0 then
        if args[1] == "player" then
            Hit = self
        end
        if typeof(args[1]) == "Instance" and args[1].ClassName == "Player" then
            Kill = self
        end
    end
    return Call(self, ...)
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
        fireproximityprompt(v)
    end
end)

Players.PlayerAdded:Connect(function(v)
    Player:AddOption(v.Name)
end)

Players.PlayerRemoving:Connect(function(v)
    Player:RemoveOption(v.Name)
end)

workspace.Game.Local.Rubbish.ChildAdded:Connect(function(v)
    if Library.flags.Clean then
        task.wait()
        fireclickdetector(v.PrimaryPart.ClickDetector)
    end
end)

RunService.Heartbeat:Connect(function()
    LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection*Library.flags.Boost)
    if Library.flags.Fly then
        LocalPlayer.Character.Humanoid:ChangeState("Swimming")
        LocalPlayer.Character[HRP].Velocity = Vector3.zero
    end
    if Library.flags.Player then
        if Library.flags.Teleport or Library.flags.Hit or Library.flags.Kill then
            LocalPlayer.Character.Humanoid.Sit = false
            LocalPlayer.Character[HRP].CFrame = Players[Library.flags.Player].Character[HRP].CFrame
        end
        if not Players[Library.flags.Player].Character:FindFirstChild("ForceField") then
            if Hit and Library.flags.Hit and Players[Library.flags.Player].Character.Humanoid.Health > 1 then
                Hit:FireServer("player", {
                    meleeType = "meleemegapunch",
                    hitPlayerId = Players[Library.flags.Player].UserId
                })
            end
            if Kill and Library.flags.Kill and Players[Library.flags.Player].Character.Humanoid.Health == 1 then
                Kill:FireServer(Players[Library.flags.Player])
            end
        end
    end
    for i, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and not v.Character:FindFirstChild("ForceField") then
            if Library.flags.All or Library.flags.KillAll then
                LocalPlayer.Character.Humanoid.Sit = false
                LocalPlayer.Character[HRP].CFrame = v.Character[HRP].CFrame
            end
            if LocalPlayer:DistanceFromCharacter(v.Character.Head.Position) < 35 then
                if Hit and (Library.flags.Aura or Library.flags.All) and v.Character.Humanoid.Health > 1 then
                    Hit:FireServer("player", {
                        meleeType = "meleemegapunch",
                        hitPlayerId = v.UserId
                    })
                end
                if Kill and (Library.flags.KillAura or Library.flags.KillAll) and v.Character.Humanoid.Health == 1 then
                    Kill:FireServer(v)
                end
            end
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
end)

Lighting.LightingChanged:Connect(function()
    if Library.flags.Light then
        Lighting.Ambient = Color3.new(1, 1, 1)
    end
end)

LocalPlayer.Idled:Connect(function()
    if Library.flags.AFK then
        VirtualUser:MoveMouse(Vector2.new())
    end
end)
