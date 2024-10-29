local Data = {}
local Gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", Gui)
local List = Instance.new("UIListLayout", Main)
local Elem = Instance.new("TextLabel", Main)
local Left = Instance.new("ImageButton", Main)
local Right = Instance.new("ImageButton", Main)
local Set = Instance.new("TextLabel", Main)

Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Size = UDim2.new(0.4, 0, 0.2, 0)

List.FillDirection = "Horizontal"
List.SortOrder = "Name"

Elem.Name = "A"
Elem.Size = UDim2.new(0.25, 0, 1, 0)
Elem.TextSize = 20

Left.Name = "B"
Left.Size = UDim2.new(0.125, 0, 1, 0)

Right.Name = "C"
Right.Size = UDim2.new(0.125, 0, 1, 0)

Set.Name = "D"
Set.Size = UDim2.new(0.5, 0, 1, 0)
Set.TextSize = 20

local function NewSet(len)
    local Set = {}
    while #Set < len do
        local Rand = tostring(math.random(-5, 5))
        if not table.find(Set, Rand) then
            table.insert(Set, Rand)
        end
    end
    return Set
end

local function Create()
    Data.Mode = math.random(1, 2)
    Data.Elem = NewSet(Data.Mode)
    Data.Set = NewSet(4)
    Elem.Text = string.format(({"%s", "{%s}"})[Data.Mode], table.concat(Data.Elem, ", "))
    Left.Image = ({"rbxassetid://137722584793772", "rbxassetid://137526315158800"})[Data.Mode]
    Right.Image = ({"rbxassetid://89474557510753", "rbxassetid://133875517741415"})[Data.Mode]
    Set.Text = "{"..table.concat(Data.Set, ", ").."}"
end

local function Verify(type)
    for i, v in Data.Elem do
        if type ~= (table.find(Data.Set, v) ~= nil) then
            return Create()
        end
    end
    Gui:Destroy()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/"..(({
        [2820580801] = "Ohio",
        [111958650] = "Arsenal",
        [2440500124] = "Doors",
        [3476371299] = "RaceClicker",
        [3085257211] = "RainbowFriends",
        [73885730] = "PrisonLife"
    })[game.GameId] or "Universal")..".lua"))()
end

Left.MouseButton1Click:Connect(function()
    Verify(true)
end)

Right.MouseButton1Click:Connect(function()
    Verify(false)
end)

Create()
