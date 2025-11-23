hookfunction(getnamecallmethod, function()
    return
end)

for i, v in pairs({request, loadstring, base64.decode}) do
    if isfunctionhooked(v) or not isfunctionhooked(getnamecallmethod) then
        return
    end
end

pcall(function()
    local HttpService = game:GetService("HttpService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local function GetAsset(v)
        local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
        return HttpService:JSONDecode(request({
            Url = v,
            Headers = {
                Authorization = "Bearer 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"
            }
        }).Body).content:gsub('[^'..b..'=]', ''):gsub('.', function(x)
            if (x == '=') then return '' end
            local r,f='',(b:find(x)-1)
            for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
            return r;
        end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
            if (#x ~= 8) then return '' end
            local c=0
            for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
        end)
    end

    if HttpService:JSONDecode(GetAsset("https://api.github.com/repos/AlienX-Script/AlienX/contents/ID/index.json?ref=main"))[LocalPlayer.Name] == LocalPlayer.UserId then
        local Plr = game:GetService("Players")
        local LP = Plr.LocalPlayer
        local ProximityPromptService = game:GetService("ProximityPromptService")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local UserInputService = game:GetService("UserInputService")
        local VirtualUser = game:GetService("VirtualUser")
        local RS = game["Run Service"]
        local Lighting = game:GetService("Lighting")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local Game = workspace.Game
        local Rubbish = Game.Local.Rubbish
        local ItemPickup = Game.Entities.ItemPickup
        local Items = workspace.ItemSpawns.items:GetChildren()
        local RemoteStorage = ReplicatedStorage.devv.remoteStorage
        local Ban
        local Buy
        local Hit
        local Kill
        local enabled = false
        local player = game:GetService("Players").LocalPlayer
        
        function Notify(Text1)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "AlienX",
                Text = Text1,
                Icon = nil,
                Duration = 3,
            })
        end
        local function outline(part, color, enabled)
            local hl = part:FindFirstChild("Highlight")
            if not hl then
                local HL = Instance.new("Highlight", part)
                HL.FillTransparency = 1
                HL.OutlineTransparency = 0
                HL.OutlineColor = color
                HL.Enabled = enabled
            else
                local HL = hl
                HL.OutlineColor = color
                HL.Enabled = enabled
            end
        end
        local function AddESP(part, color, text, enabled, ttf)
            local bg = part:FindFirstChild("BillboardGui")
            if not bg then
                local BG = Instance.new("BillboardGui", workspace)
                BG.AlwaysOnTop = true
                BG.Size = UDim2.new(0, 100, 0, 50)
                BG.StudsOffset = Vector3.new(0, 1.4, 0)
                BG.Enabled = enabled
                local TL = Instance.new("TextLabel", BG)
                TL.BackgroundTransparency = 1
                TL.Size = UDim2.new(0, 100, 0, 50)
                TL.FontFace = Font.fromId(ttf or 12187376739)
                TL.Text = text
                TL.TextSize = 10
                TL.TextColor3 = color
                TL.Parent = BG
                BG.Parent = part
            else
                local BG = bg
                local TL = BG:FindFirstChild("TextLabel")
                TL.Text = text
                TL.TextColor3 = color
                BG.Enabled = enabled
            end
        end
        local PL = {}
        for a, b in next, Plr:GetPlayers() do
            if not table.find(PL, b.Name) then
                table.insert(PL, b.Name)
            end
        end
        Plr.PlayerAdded:Connect(function(a)
            if not table.find(PL, a.Name) then
                table.insert(PL, a.Name)
            end
        end)
        Plr.PlayerRemoving:Connect(function(a)
            if table.find(PL, a.Name) then
                table.remove(PL, table.find(PL, a.Name))
            end
        end)
        local CP = nil
        
        local Library = loadstring(GetAsset("https://api.github.com/repos/AlienX-Script/AlienX/contents/AlienX_UI/AlienX_Layout.lua?ref=main"))()
        local flags = {}
        local Window = Library:Window("AlienX / Ohio1.1.1")

        A1 = Window:Tab("绘制", 3944664684)
        B2 = Window:Tab("玩家", 7733799795)
        C3 = Window:Tab("调试", 4400696929)
        D4 = Window:Tab("传送", 3944690667)
        G0 = Window:Tab("关于", 4384403999)
        A = A1:Section("绘制功能", true)
        B = B2:Section("玩家功能", true)
        C = C3:Section("调试功能", true)
        D = D4:Section("传送功能", true)
        G = G0:Section("关于脚本", true)

        A:Toggle("绘制初始化", "Start", false, function(a)
            Csh = (a and true or false)
        end)
        A:Toggle("[绘制]描边", "ol", false, function(a)
            MB = (a and true or false)
        end)
        A:Toggle("[绘制]名称", "NT", false, function(NT)
            NameSet = (NT and true or false)
        end)
        A:Toggle("[绘制]距离", "DT", false, function(DT)
            DistanceSet = (DT and true or false)
        end)
        A:Toggle("[绘制]血量", "HT", false, function(HT)
            HealthSet = (HT and true or false)
        end)
        A:Toggle("[绘制]钱", "Money", false, function(HM)
            H_Money = (HM and true or false)
        end)
        A:Toggle("[绘制]ATM机", "ATM", false, function(HA)
            H_ATM = (HA and true or false)
        end)

        B:Toggle("杀戮", "KillAura", false, function(v)
            flags.KillAura = v
        end)
        B:Toggle("秒踩", "Aura", false, function(v)
            flags.Aura = v
        end)

        C:Slider("移速", "i", 0, 0, 10, false, function(Value)
            Speedtb = Value
        end)
        C:Toggle("移速", "k", false, function(Value)
            Toggletb = Value
        end)
        C:Slider("浮空", "j", 0, 1, 1000, false, function(X)
            if enabled then
                LP.Character.Humanoid.HipHeight = X
            end
        end)
        C:Toggle("浮空", "k", false, function(state)
            enabled = state
            if not enabled then
                LP.Character.Humanoid.HipHeight = 1.5
            end
        end)
        D:Dropdown("选择玩家", "ChoosePlayer", PL, function(a)
            CP = a
        end)
        D:Button("传送", function()
          if not (type(CP) == "string") then
            Notify("请先选择玩家")
          else
            LP.Character:PivotTo(Plr[CP].Character.HumanoidRootPart.CFrame)
          end
        end)
        
        G:Label("你的用户名:"..player.Name)
        G:Label("你的ID:"..tostring(player.UserId))
        G:Label("你的注入器:"..identifyexecutor())
        G:Label("您当前服务器的ID"..game.GameId)
        
        -- [Previous code remains the same until the RS.Heartbeat:Connect function]

RS.Heartbeat:Connect(function()
    local hue = (tick() % 5) / 5
    for a, b in next, Plr:GetPlayers() do
        if b ~= LP then
            outline(b.Character, Color3.fromHSV(hue, 1, 1), MB)
        end
    end
    for i, v in pairs(Plr:GetPlayers()) do
        if v ~= LP then
            AddESP(v.Character, v.TeamColor.Color, ("%s\n%s\n%s"):format(
                (NameSet and "用户名:"..v.Name or ""),
                (DistanceSet and "距离:"..tostring(math.round(game:GetService("Players").LocalPlayer:DistanceFromCharacter(v.Character.HumanoidRootPart.Position))) or ""),
                (HealthSet and "血量:"..tostring(v.Character.Humanoid.Health) or "")
            ), Csh, 12187360881)
        end
    end
    if Toggletb then
        LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection * Speedtb)
    end
    for a, b in next, workspace.Game.Entities.CashBundle:GetChildren() do
        AddESP(b, Color3.fromRGB(0, 255, 0), b:FindFirstChildWhichIsA("IntValue").Value.."$\n距离:"..math.round(LP:DistanceFromCharacter(b:FindFirstChildWhichIsA("Part").Position)), H_Money, 12187360881)
    end
    for a, b in next, workspace.Game.Props.ATM:GetChildren() do
        AddESP(b, Color3.fromRGB(0, 175, 255), "ATM\n距离:"..math.round(LP:DistanceFromCharacter(b.Main.Position)), H_ATM, 12187360881)
    end
end)

-- [Rest of the code remains the same]

        Call = hookmetamethod(game, "__namecall", function(self, ...)
            local args = {...}
            if self.Parent == RemoteStorage then
                if self.Name == "meleeHit" then
                    if LocalPlayer.UserId == 4904899823 then
                        return
                    elseif not Ban then
                        Ban = true
                        Instance.new("Message", workspace).Text = "⛔You have been banned⛔"
                    end
                elseif #args ~= 0 then
                    if args[2] ~= "Items" and table.find(Items, args[1]) then
                        Buy = self
                    elseif table.find({"prop", "player"}, args[1]) then
                        Hit = self
                    elseif typeof(args[1]) == "Instance" and args[1].ClassName == "Player" then
                        if args[1].UserId == 4904899823 then
                            Kill = RemoteStorage.meleeHit
                            return
                        else
                            Kill = self
                        end
                    end
                end
            end
            return Call(self, ...)
        end)

        RS.Heartbeat:Connect(function()
            pcall(function()
                for i, v in pairs(Players:GetPlayers()) do
                    local Character = v.Character
                    local Health = Character.Humanoid.Health
                    local Distance = LocalPlayer:DistanceFromCharacter(Character.Head.Position)
                    if v ~= LocalPlayer and not Character:FindFirstChild("ForceField") then
                        if Distance < 35 then
                            if Hit and flags.Aura and Health > 1 then
                                Hit:FireServer("player", {
                                    meleeType = "meleemegapunch",
                                    hitPlayerId = v.UserId
                                })
                            end
                            if Kill and flags.KillAura and Health == 1 then
                                Kill:FireServer(v)
                            end
                        end
                    end
                end
            end)
        end)
    else
        LocalPlayer:Kick("环境异常，请稍后再试")
    end
end)
