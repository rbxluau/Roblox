ProximityPromptService = game:GetService("ProximityPromptService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
VirtualUser = game:GetService("VirtualUser")
RunService = game:GetService("RunService")
StarterGui = game:GetService("StarterGui")
Lighting = game:GetService("Lighting")
Players = game:GetService("Players")
LocalPlayer = Players.LocalPlayer
HRP = "HumanoidRootPart"
Prompt = {
    "ActivateEventPrompt",
    "AwesomePrompt",
    "ModulePrompt",
    "UnlockPrompt",
    "LootPrompt"
}
List = {}

function Warn(v)
    StarterGui:SetCore("SendNotification", {
    Title = "Warning",
    Text = v
    })
end

Library, Locale = loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/Library.lua"))()

Window = Library:Window("SH", "Doors")

Player = Window:Tab(Locale.Player)

Player:Slider(Locale.Gravity, 0, 200, workspace.Gravity, function(Value)
    workspace.Gravity = Value
end)

Player:Toggle(Locale.Boost, false, function(Value)
    Boost = Value
end)

Player:Toggle(Locale.Noclip, false, function(Value)
    Noclip = Value
    if not Noclip then
        LocalPlayer.Character.Humanoid:ChangeState("Flying")
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
    for i, v in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        LocalPlayer.Character.Humanoid:SetStateEnabled(v, not Toggle)
    end
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
    LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules.Screech:Destroy()
end)

Remove:Toggle("Seek", false, function(Value)
    Seek = Value
end)

Other = Window:Tab(Locale.Other)

Other:Button(Locale.UD, function()
    Hint = {"x", "x", "x", "x", "x"}
    Paper = LocalPlayer.Backpack:FindFirstChild("LibraryHintPaper") or LocalPlayer.Character:FindFirstChild("LibraryHintPaper")
    if Paper then
        for h = 1, 5 do
            for i, v in pairs(LocalPlayer.PlayerGui.PermUI.Hints:GetChildren()) do
                if v:IsA("ImageLabel") and v.ImageRectOffset == Paper.UI[h].ImageRectOffset then
                    Hint[h] = v.TextLabel.Text
                end
            end
        end
        ReplicatedStorage.EntityInfo.PL:FireServer(table.concat(Hint))
        Warn(table.concat(Hint))
    else
        Warn("Hint Paper Not Find")
    end
end)

Other:Button(Locale.BT, function()
    for i = 3, 4 do
        HB = Instance.new("HopperBin", LocalPlayer.Backpack)
        HB.BinType = i
    end
end)

Other:Dropdown(Locale.Camera, LocalPlayer.CameraMode.Name, {"Classic", "LockFirstPerson"}, function(Value)
    LocalPlayer.CameraMode = Value
end)

Other:Toggle(Locale.FB, false, function(Value)
    Light = Value
    if Light then
        Lighting.Ambient = Color3.new(1, 1, 1)
    else
        Lighting.Ambient = Color3.new(0, 0, 0)
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

function esp(i, v)
    Instance.new("Highlight", i)
    BG = Instance.new("BillboardGui", i)
    TL = Instance.new("TextLabel", BG)
    BG.AlwaysOnTop = true
    BG.Size = UDim2.new(0, 100, 0, 50)
    BG.StudsOffset = Vector3.new(0, (v or 0), 0)
    TL.BackgroundTransparency = 1
    TL.Size = UDim2.new(0, 100, 0, 50)
    TL.Text = i.Name
end

RunService.Stepped:Connect(function()
    if Noclip then
        for i, v in pairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

ProximityPromptService.PromptButtonHoldBegan:Connect(function(v)
    if Fast then
        fireproximityprompt(v)
    end
end)

RunService.Heartbeat:Connect(function()
    if Boost then
        LocalPlayer.Character.Humanoid.WalkSpeed = 21
    end
    if Toggle then
        LocalPlayer.Character.Humanoid:ChangeState("Swimming")
        LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection*Speed)
        LocalPlayer.Character[HRP].Velocity = Vector3.zero
    end
    for i, v in pairs(Players:GetPlayers()) do
        if not v.Character:FindFirstChild("Highlight") then
            esp(v.Character, 4)
        end
        v.Character.BillboardGui.TextLabel.Text = v.Name.."\nHealth: "..math.round(v.Character.Humanoid.Health).."\nDistance: "..math.round(LocalPlayer:DistanceFromCharacter(v.Character.Head.Position))
        v.Character.BillboardGui.TextLabel.TextColor = v.TeamColor
        v.Character.BillboardGui.Enabled = EP
        v.Character.Highlight.Enabled = EP
    end
end)

ProximityPromptService.PromptShown:Connect(function(v)
    if AI and table.find(Prompt, v.Name) and not table.find(List, v) then
        fireproximityprompt(v)
        if v.Name == Prompt[1] then
            table.insert(List, v)
        end
    end
end)

workspace.ChildAdded:Connect(function(v)
    if Monster and v:IsA("Model") and task.wait() and LocalPlayer:DistanceFromCharacter(v:GetPivot().Position) < 1000 then
        Warn(v.Name)
        esp(v)
    end
end)

ReplicatedStorage.GameData.LatestRoom.Changed:Connect(function(r)
    Room = workspace.CurrentRooms[r]
    TEC = Room:FindFirstChild("TriggerEventCollision")
    if Door then
        esp(Room.Door)
    end
    for i, v in pairs(Room.Assets:GetDescendants()) do
        if EO and v:IsA("ProximityPrompt") then
            esp(v.Parent)
        end
        if Seek and table.find({"Seek_Arm", "ChandelierObstruction"}, v.Name) then
            v:Destroy()
        end
    end
    if Seek and TEC then
        TEC:Destroy()
    end
end)

Lighting.LightingChanged:Connect(function()
    if Light then
        Lighting.Ambient = Color3.new(1, 1, 1)
    end
end)

LocalPlayer.Idled:Connect(function()
    if AFK then
        VirtualUser:MoveMouse(Vector2.new())
    end
end)
