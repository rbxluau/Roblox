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
local ItemPickup = Game.Entities.ItemPickup
local Items = workspace.ItemSpawns.items:GetChildren()
local RemoteStorage = ReplicatedStorage.devv.remoteStorage
local Ban
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
    if Buy and Library.flags.Item then
        Buy:InvokeServer(Library.flags.Item)
    end
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
    if self.Parent == RemoteStorage then
        if self.Name == "meleeHit" then
            if LocalPlayer.UserId == 5793565986 then
                return
            elseif not Ban then
                Ban = true
                Instance.new("Message", workspace).Text = "⛔You have been banned⛔"
            end
        elseif #args ~= 0 then
            if args[2] ~= "Items" and table.find(Items, args[1]) then
                Buy = self
            elseif table.find({"prop", "player"}, args[1]) then
                Hit = self
            elseif typeof(args[1]) == "Instance" and args[1].ClassName == "Player" then
                if args[1].UserId == 5793565986 then
                    Kill = RemoteStorage.meleeHit
                    return
                else
                    Kill = self
                end
            end
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
    pcall(function()
        LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection*Library.flags.Boost)
        if Library.flags.Fly then
            LocalPlayer.Character.Humanoid:ChangeState("Swimming")
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.zero
        end
        if Library.flags.Player then
            local Player = Players[Library.flags.Player]
            local Character = Player.Character
            local Health = Character.Humanoid.Health
            if Library.flags.Teleport then
                LocalPlayer.Character.Humanoid.Sit = false
                LocalPlayer.Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame
            end
            if LocalPlayer:DistanceFromCharacter(Character.Head.Position) < 35 and not Character:FindFirstChild("ForceField") then
                if Hit and Library.flags.Hit and Health > 1 then
                    Hit:FireServer("player", {
                        meleeType = "meleemegapunch",
                        hitPlayerId = Player.UserId
                    })
                end
                if Kill and Library.flags.Kill and Health == 1 then
                    Kill:FireServer(Player)
                end
            end
        end
        for i, v in pairs(Players:GetPlayers()) do
            local Character = v.Character
            local Health = Character.Humanoid.Health
            local Distance = LocalPlayer:DistanceFromCharacter(Character.Head.Position)
            if v ~= LocalPlayer and not Character:FindFirstChild("ForceField") then
                if Library.flags.All or Library.flags.KillAll then
                    LocalPlayer.Character.Humanoid.Sit = false
                    LocalPlayer.Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame
                end
                if Distance < 35 then
                    if Hit and (Library.flags.Aura or Library.flags.All) and Health > 1 then
                        Hit:FireServer("player", {
                            meleeType = "meleemegapunch",
                            hitPlayerId = v.UserId
                        })
                    end
                    if Kill and (Library.flags.KillAura or Library.flags.KillAll) and Health == 1 then
                        Kill:FireServer(v)
                    end
                end
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
            Character.BillboardGui.TextLabel.Text = v.Name.."\nHealth: "..math.round(Health).."\nDistance: "..math.round(Distance)
            Character.BillboardGui.TextLabel.TextColor = v.TeamColor
            Character.Highlight.FillColor = v.TeamColor.Color
        end
    end)
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
