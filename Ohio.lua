local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Game = workspace.Game
local Rubbish = Game.Local.Rubbish
local Items = workspace.ItemSpawns.items
local ItemPickup = Game.Entities.ItemPickup
local Buy
local Hit
local Kill

local Library, Locale = loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/Library.lua"))()

local Window = Library:Window(Locale.Ohio)

local Section = Window:Tab(Locale.Player):Section("Main", true)

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

Section = Window:Tab(Locale.Item):Section("Main", true)

Section:Dropdown(Locale.Item, "Item", (function()
    local Items = Items:GetChildren()
    for i, v in pairs(Items) do
        Items[i] = v.Name
    end
    return Items
end)())

Section:Toggle(Locale.Teleport, "ItemTP", false, function(Value)
    if Value then
        for i, v in pairs(ItemPickup:GetChildren()) do
            if v.PrimaryPart:FindFirstChildOfClass("ProximityPrompt").ObjectText == Library.flags.Item then
                LocalPlayer.Character.HumanoidRootPart.CFrame = v.PrimaryPart.CFrame
                break
            end
        end
    end
end)

Section:Toggle(Locale.Get, "Get")

Section:Button(Locale.Buy, function()
    Buy:InvokeServer(Library.flags.Item)
end)

Section = Window:Tab(Locale.Hit):Section("Main", true)

Section:Toggle(Locale.Aura, "Aura")

Section:Toggle(Locale.All, "All")

Section = Window:Tab(Locale.Kill):Section("Main", true)

Section:Toggle(Locale.Aura, "KillAura")

Section:Toggle(Locale.All, "KillAll")

Section = Window:Tab(Locale.Loop):Section("Main", true)

local Player = Section:Dropdown(Locale.Player, "Player", (function()
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
    if Value then
        for i, v in pairs(Rubbish:GetChildren()) do
            fireclickdetector(v.PrimaryPart.ClickDetector)
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
        if args[2] ~= "Items" and type(args[1]) == "string" and Items:FindFirstChild(args[1]) then
            Buy = self
        end
        if table.find({"prop", "player"}, args[1]) then
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

ProximityPromptService.PromptShown:Connect(function(v)
    if Library.flags.Get and v.ObjectText == Library.flags.Item then
        fireproximityprompt(v)
    end
end)

Players.PlayerAdded:Connect(function(v)
    Player:AddOption(v.Name)
end)

Players.PlayerRemoving:Connect(function(v)
    Player:RemoveOption(v.Name)
end)

ItemPickup.ChildAdded:Connect(function(v)
    if Library.flags.ItemTP and task.wait() and v.PrimaryPart:FindFirstChildOfClass("ProximityPrompt").ObjectText == Library.flags.Item then
        LocalPlayer.Character.HumanoidRootPart.CFrame = v.PrimaryPart.CFrame
    end
end)

Rubbish.ChildAdded:Connect(function(v)
    if Library.flags.Clean then
        task.wait()
        fireclickdetector(v.PrimaryPart.ClickDetector)
    end
end)

RunService.Heartbeat:Connect(function()
    LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection*Library.flags.Boost)
    if Library.flags.Fly then
        LocalPlayer.Character.Humanoid:ChangeState("Swimming")
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.zero
    end
    if Library.flags.Player then
        if Library.flags.Teleport or Library.flags.Hit or Library.flags.Kill then
            LocalPlayer.Character.Humanoid.Sit = false
            LocalPlayer.Character.HumanoidRootPart.CFrame = Players[Library.flags.Player].Character.HumanoidRootPart.CFrame
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
                LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
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
            local BillboardGui = Instance.new("BillboardGui", v.Character)
            local TextLabel = Instance.new("TextLabel", BillboardGui)
            BillboardGui.AlwaysOnTop = true
            BillboardGui.Size = UDim2.new(0, 100, 0, 50)
            BillboardGui.StudsOffset = Vector3.new(0, 4, 0)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Size = UDim2.new(0, 100, 0, 50)
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
