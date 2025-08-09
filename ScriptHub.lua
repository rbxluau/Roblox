local StarterGui = game:GetService("StarterGui")
local BindableFunction = Instance.new("BindableFunction", script)
local Source = game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/"..(({
    [4777817887] = "BladeBall",
    [2820580801] = "Ohio",
    [111958650] = "Arsenal",
    [2440500124] = "Doors",
    [3476371299] = "RaceClicker",
    [3085257211] = "RainbowFriends",
    [73885730] = "PrisonLife"
})[game.GameId] or "Universal")..".lua")

BindableFunction.OnInvoke = function(press)
    if press == "Yes" then
        queueonteleport(Source)
    end
end

StarterGui:SetCore("SendNotification", {
    Title = "Loading...",
    Text = "Do you want to enable queue_on_teleport?",
    Callback = BindableFunction,
    Button1 = "Yes",
    Button2 = "No"
})

loadstring(Source)()
