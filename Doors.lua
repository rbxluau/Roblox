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

function GetPlayers()
    local Players = Players:GetPlayers()
    for i, v in pairs(Players) do
        Players[i] = v.Name
    end
    return Players
end

Library, Locale = loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/Library.lua"))()

Window = Library:Window("Doors")

Section = Window:Tab(Locale.Player):Section("Main", true)

Section:Slider(Locale.Gravity, "Gravity", math.round(workspace.Gravity), 0, 200, false, function(Value)
    workspace.Gravity = Value
end)

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

Section = Window:Tab(Locale.Auto):Section("Main", true)

Section:Toggle(Locale.Interact, "Interact")

Section = Window:Tab(Locale.ESP):Section("Main", true)

Section:Toggle(Locale.Player, "ESP")

Section:Toggle(Locale.Monster, "Monster")

Section:Toggle(Locale.Door, "Door")

Section:Toggle(Locale.Other, "Other")

Section = Window:Tab(Locale.Remove):Section("Main", true)

Remove:Button("Screech", function()
    LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules.Screech:Destroy()
end)

Remove:Toggle("Seek", "Seek")

Section = Window:Tab(Locale.Other):Section("Main", true)

Other:Button(Locale.Unlock, function()
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

Section:Button(Locale.BTool, function()
    for i = 3, 4 do
        HB = Instance.new("HopperBin", LocalPlayer.Backpack)
        HB.BinType = i
    end
end)

Section:Dropdown(Locale.Camera, "Camera", {"Classic", "LockFirstPerson"}, function(Value)
    LocalPlayer.CameraMode = Value
end)

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
    if Library.flags.Noclip then
        for i, v in pairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection*Library.flags.Boost)
    if Library.flags.Fly then
        LocalPlayer.Character.Humanoid:ChangeState("Swimming")
        LocalPlayer.Character[HRP].Velocity = Vector3.zero
    end
    for i, v in pairs(Players:GetPlayers()) do
        if not v.Character:FindFirstChild("Highlight") then
            esp(v.Character, 4)
        end
        v.Character.BillboardGui.TextLabel.Text = v.Name.."\nHealth: "..math.round(v.Character.Humanoid.Health).."\nDistance: "..math.round(LocalPlayer:DistanceFromCharacter(v.Character.Head.Position))
        v.Character.BillboardGui.TextLabel.TextColor = v.TeamColor
        v.Character.Highlight.FillColor = v.TeamColor.Color
        v.Character.BillboardGui.Enabled = Library.flags.ESP
        v.Character.Highlight.Enabled = Library.flags.ESP
    end
end)

ProximityPromptService.PromptShown:Connect(function(v)
    if Library.flags.Interact and table.find(Prompt, v.Name) and not table.find(List, v) then
        fireproximityprompt(v)
        if v.Name == Prompt[1] then
            table.insert(List, v)
        end
    end
end)

workspace.ChildAdded:Connect(function(v)
    if Library.flags.Monster and v:IsA("Model") and task.wait() and LocalPlayer:DistanceFromCharacter(v:GetPivot().Position) < 1000 then
        Warn(v.Name)
        esp(v)
    end
end)

ReplicatedStorage.GameData.LatestRoom.Changed:Connect(function(r)
    Room = workspace.CurrentRooms[r]
    TEC = Room:FindFirstChild("TriggerEventCollision")
    if Library.flags.Door then
        esp(Room.Door)
    end
    for i, v in pairs(Room.Assets:GetDescendants()) do
        if Library.flags.Other and v:IsA("ProximityPrompt") then
            esp(v.Parent)
        end
        if Library.flags.Seek and table.find({"Seek_Arm", "ChandelierObstruction"}, v.Name) then
            v:Destroy()
        end
    end
    if Library.flags.Seek and TEC then
        TEC:Destroy()
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
