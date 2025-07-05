local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local TextLabel = Instance.new("TextLabel", Instance.new("ScreenGui", game.CoreGui))
TextLabel.BackgroundTransparency = 1
TextLabel.Size = UDim2.new(0, 100, 0, 50)
TextLabel.TextWrapped = true

local Library, Locale = loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/Library.lua"))()

local Window = Library:Window("开发工具")

local Section = Window:Tab(Locale.Player):Section("Main", true)

Section:Button("复制位置", function()
    setclipboard("LocalPlayer.Character:MoveTo(Vector3.new("..tostring(LocalPlayer.Character.HumanoidRootPart.Position).."))")
end)

Section = Window:Tab(Locale.Other):Section("Main", true)

Section:Button("Dex Explorer", function()
    loadstring(game:HttpGet("https://raw.github.com/infyiff/backup/main/dex.lua"))()
end)

Section:Button("Simple Spy", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/SimpleSpy.lua"))()
end)

Section:Button("获取全名", function()
    local Tool = Instance.new("Tool", LocalPlayer.Backpack)
    Tool.RequiresHandle = false
    Tool.Activated:Connect(function()
        setclipboard(LocalPlayer:GetMouse().Target:GetFullName())
    end)
end)

Section:Button("日志", function()
    keypress(0x78)
end)

Section:Dropdown("查看", "Type", {"Workspace", "Gui"})

game.UserInputService.TouchTap:Connect(function()
    if Library.flags.Type == "Workspace" then
        TextLabel.Text = LocalPlayer:GetMouse().Target:GetFullName()
    end
end)

function Object(v)
    if v:IsA("GuiObject") then
        v.TouchTap:Connect(function()
            if Library.flags.Type == "Gui" then
                TextLabel.Text = v:GetFullName()
            end
        end)
    end
end

function TouchTap(ui)
    for i, v in pairs(ui:GetDescendants()) do
        Object(v)
    end
    ui.DescendantAdded:Connect(function(v)
        Object(v)
    end)
end

TouchTap(LocalPlayer.PlayerGui)
TouchTap(game.CoreGui)
