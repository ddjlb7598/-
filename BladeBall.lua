local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Plr = game:GetService("Players")
local LP = Plr.LocalPlayer

local Part = Instance.new("Part", workspace)
Part.Material = Enum.Material.ForceField
Part.Anchored = true
Part.CanCollide = false
Part.CastShadow = false
Part.Shape = Enum.PartType.Ball
Part.Color = Color3.fromRGB(132, 0, 255)
Part.Transparency = 0.5

local BaseGui = Instance.new("ScreenGui", game.CoreGui)
BaseGui.Name = "BaseGui"

local TL = Instance.new("TextLabel", BaseGui)
TL.Name = "TL"
TL.Parent = BaseGui
TL.BackgroundColor3 = Color3.new(1, 1, 1)
TL.BackgroundTransparency = 1
TL.BorderColor3 = Color3.new(0, 0, 0)
TL.Position = UDim2.new(0.95, -300, 0.85, 0)
TL.Size = UDim2.new(0, 300, 0, 50)
TL.FontFace = Font.new("rbxassetid://12187370000", Enum.FontWeight.Bold)
TL.Text = ""
TL.TextColor3 = Color3.new(1, 1, 1)
TL.TextScaled = true
TL.TextSize = 14
TL.TextWrapped = true
TL.Visible = true
TL.RichText = true

local function rainbowColor(hue)
  return Color3.fromHSV(hue, 1, 1)
end

local function updateRainbowText(distance, ballSpeed, spamRadius, minDistance)
  local hue = (tick() * 0.1) % 1
  local color1 = rainbowColor(hue)
  local color2 = rainbowColor((hue + 0.3) % 1)
  local color3 = rainbowColor((hue + 0.6) % 1)
  local color4 = rainbowColor((hue + 0.9) % 1)

  TL.Text = string.format(
  "<font color='#%s'>distance: %s</font>\n"..
  "<font color='#%s'>ballSpeed: %s</font>\n"..
  "<font color='#%s'>spamRadius: %s</font>\n"..
  "<font color='#%s'>minDistance: %s</font>",
  color1:ToHex(), tostring(distance),
  color2:ToHex(), tostring(ballSpeed),
  color3:ToHex(), tostring(spamRadius),
  color4:ToHex(), tostring(minDistance)
  )
end

local last1, last2
local Cam = workspace.CurrentCamera

local function ZJ()
  local Nearest, Min = nil, math.huge
  for A, B in next, workspace.Alive:GetChildren() do
    if B.Name ~= LP.Name and B:FindFirstChild("HumanoidRootPart") then
      local distance = LP:DistanceFromCharacter(B:GetPivot().Position)
      if distance < Min then
        Min = distance
        Nearest = B
      end
    end
  end
  return Min
end

local function Parry()
  task.spawn(function() game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, nil, 0) end)
end

local function GetBall()
  for a, b in next, workspace.Balls:GetChildren() do
    if b:IsA("BasePart") and b:GetAttribute("realBall") then
      return b
    end
  end
end

local function IsTarget(a)
  return a:GetAttribute("target") == LP.Name
end

local function IsSpamming(a, b)
  if not type(last1) == "number" then return false end
  if not type(last2) == "number" then return false end
  if last1 - last2 > 0.8 then
    return false
  end
  if a > b then
    return false
  end
  if #workspace.Alive:GetChildren() <= 1 then
    return false
  end
  return true
end

local function addRainbowTitleToLocalPlayer(player, titleText)
    local function addTitleToCharacter(character)
        local head = character:FindFirstChild("Head") or character:WaitForChild("Head")
        local old = head:FindFirstChild("PlayerTitle")
        if old then old:Destroy() end
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "PlayerTitle"
        billboardGui.Adornee = head
        billboardGui.Size = UDim2.new(4, 0, 1, 0)
        billboardGui.StudsOffset = Vector3.new(0, 2, 0)
        billboardGui.AlwaysOnTop = true
        billboardGui.MaxDistance = 1000
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = titleText
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextWrapped = true
        textLabel.Parent = billboardGui
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1
        stroke.Color = Color3.new(1, 1, 1)
        stroke.Parent = textLabel
        local gradient = Instance.new("UIGradient")
        gradient.Rotation = 90
        gradient.Parent = textLabel
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            local time = tick() * 0.5
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHSV(time % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.2, Color3.fromHSV((time + 0.2) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.4, Color3.fromHSV((time + 0.4) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.6, Color3.fromHSV((time + 0.6) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.8, Color3.fromHSV((time + 0.8) % 1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV(time % 1, 1, 1))
            })
        end)
        billboardGui.AncestryChanged:Connect(function()
            if not billboardGui:IsDescendantOf(game) then
                if connection then connection:Disconnect() end
            end
        end)
        billboardGui.Parent = head
    end
    local character = player.Character or player.CharacterAdded:Wait()
    addTitleToCharacter(character)
    player.CharacterAdded:Connect(addTitleToCharacter)
end
addRainbowTitleToLocalPlayer(LP, "AlienX VIP")

local function spin(enabled)
    local root = LP.Character and (LP.Character:FindFirstChild("HumanoidRootPart") or LP.Character:FindFirstChild("UpperTorso"))
    if not root then return end
    for _, v in pairs(root:GetChildren()) do
        if v.Name == "Spinning" then v:Destroy() end
    end
    if enabled then
        local Spin = Instance.new("BodyAngularVelocity")
        Spin.Name = "Spinning"
        Spin.Parent = root
        Spin.MaxTorque = Vector3.new(0, math.huge, 0)
        Spin.AngularVelocity = Vector3.new(0, 50, 0)
    end
end

hookfunction(getnamecallmethod, function()
    return
end)

for i, v in pairs({request, loadstring, base64.decode}) do
    if isfunctionhooked(v) or not isfunctionhooked(getnamecallmethod) then
        return
    end
end

pcall(function()
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

    if HttpService:JSONDecode(GetAsset("https://api.github.com/repos/AlienX-Script/AlienX/contents/ID/index.json?ref=main"))[LP.Name] == LP.UserId then
  local PlayerList = {}
  for a, b in next, Plr:GetPlayers() do
    table.insert(PlayerList, b.Name)
  end
  Plr.PlayerAdded:Connect(function(a)
    if not table.find(PlayerList, a.Name) then
      table.insert(PlayerList, a.Name)
    end
  end)
  Plr.PlayerRemoving:Connect(function(a)
    if table.find(PlayerList, a.Name) then
      table.remove(PlayerList, table.find(PlayerList, a.Name))
    end
  end)
    local WindUI = loadstring(GetAsset("https://api.github.com/repos/AlienX-Script/AlienX/contents/AlienX_UI/Alienx_WindUI_3.0"))()

  WindUI:Notify({
    Title = "AlienX",
    Content = "刀刃球",
    Duration = 5,
  })

  local Window = WindUI:CreateWindow({
    Title = "AlienX / 刀刃球",
    Icon = "rbxassetid://129260712070622",
    IconThemed = true,
    Author = "感谢您的支持",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(580, 440),
    Transparent = true,
    Theme = "Dark",
    User = {
      Enabled = true,
      Callback = function() print("clicked") end,
      Anonymous = false
    },
    SideBarWidth = 200,
    -- HideSearchBar = true,
    ScrollBarEnabled = true,
    -- Background = "rbxassetid://13511292247", -- rbxassetid only
  })

 Window:EditOpenButton({
    Title = "打开UI",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),
        ColorSequenceKeypoint.new(0.16, Color3.fromHex("FF7F00")),
        ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")),
        ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),
        ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("9400D3"))
    }),
    Draggable = true,
})

  MainSection = Window:Section({
    Title = "主要功能",
    Opened = true,
  })
  function AddTab(a, b)
    return MainSection:Tab({Title = a, Icon = b})
  end
  function Btn(a, b, c)
    return a:Button({Title = b, Callback = c})
  end
  function Tg(a, b, c, d, e)
    return a:Toggle({Title = b, Desc = c, Image = "bird", Value = d, Callback = e})
  end

  A = AddTab("主要", "rbxassetid://3944664684")
  B = AddTab("抽奖", "rbxassetid://4370344279")


  Window:SelectTab(1)

  Tg(A, "自动击球", nil, false, function(t)
    AP = t
    end)

 Tg(A, "自动连击", nil, false, function(t)
    AS = t
    end)

  Tg(A, "自动闪避", nil, false, function(t)
    AT = t
    end)
  Tg(A, "显示范围", nil, false, function(t)
    Au = t
    if t then
        if not _G.RainbowRangeLoop then
            _G.RainbowRangeLoop = true
            task.spawn(function()
                while Au and _G.RainbowRangeLoop do
                    local hue = (tick() * 0.2) % 1
                    local color = Color3.fromHSV(hue, 1, 1)
                    Part.Color = color
                    task.wait(0.03)
                end
            end)
        end
    else
        _G.RainbowRangeLoop = false
    end
end)

--[以上改完了]

  Tg(A, "调试信息", "调试信息可拖动", false, function(t)
    IF = t
    if not DebugLocked then
        TL.Active = t
        TL.Draggable = t
    end
  end)

  local DebugLocked = false
  Tg(A, "锁定调试信息", nil, false, function(val)
    DebugLocked = val
    local function playTipSound()
        local s = Instance.new("Sound", workspace)
        s.SoundId = "rbxassetid://87437544236708"
        s.PlayOnRemove = true
        s:Destroy()
    end
    if DebugLocked then
        TL.Active = false
        TL.Draggable = false
        WindUI:Notify({Title = "提示", Content = "调试信息已锁定，无法拖动", Duration = 2})
        playTipSound()
    else
        TL.Active = IF
        TL.Draggable = IF
        WindUI:Notify({Title = "提示", Content = "调试信息已解锁，可以拖动", Duration = 2})
        playTipSound()
    end
  end)

  B:Dropdown({Title = "选择箱子", Values = {"宝剑箱", "爆炸箱"}, Value = "nil", Callback = function(d)
    if d == "宝剑箱" then
        Crate = workspace.Spawn.Crates.NormalSwordCrate
       elseif d == "爆炸箱" then
        Crate = workspace.Spawn.Crates.NormalExplosionCrate
      end
  end})

  local AutoDraw = false
  Tg(B, "自动抽奖", nil, false, function(val)
    AutoDraw = val
    if AutoDraw then
        task.spawn(function()
            while AutoDraw do
                ReplicatedStorage.Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", Crate)
                task.wait(0.5)
            end
        end)
    end
  end)
  Btn(B, "抽奖", function()
    ReplicatedStorage.Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", Crate)
  end)

  local Parried, Check = false, false
    game["Run Service"].Heartbeat:Connect(function()
      Part.CFrame = LP.Character.HumanoidRootPart.CFrame
      local ball = GetBall()
      if not ball then Part.Size = Vector3.zero return end
      local DY = ball.zoomies.VectorVelocity or ball.AssemblyLinearVelocity
      local BallSpeed = DY.Magnitude
      local LP_Position = LP.Character.PrimaryPart.Position
      local Distance = LP:DistanceFromCharacter(ball.Position) - 3
      local Radius = ball.Velocity.Magnitude / 2.2 + (LP:GetNetworkPing() * 20)

      if Au then
        Part.Size = Vector3.new(Radius, Radius, Radius)
       else
        Part.Size = Vector3.zero
      end

      local Min = ZJ()

      if ((LP_Position - ball.Position).Unit:Dot(DY.Unit) > 0) then
        if IsTarget(ball) then
          if AT then
            LP.Character.HumanoidRootPart.CFrame = ball.CFrame + Vector3.new(0.9*BallSpeed, -(0.9*BallSpeed), 0)
            pcall(Parry)
          end
          if not Parried and AP and Distance <= Radius then
            pcall(Parry)
            Parried = true
            last2 = last1 or 0
            last1 = tick()
          end
        end
       else
        Parried = false
      end

      SpamRadius = (0.01 * BallSpeed + 4) * 6
      Check = IsSpamming(Min, SpamRadius)

      task.spawn(function()
        if Check then
          task.wait(0.25)
          while AS and task.wait() do
            for i = 1, 9 do
              pcall(Parry)
              if not Check then break end
            end
            if not Check then break end
          end
        end
      end)
      if IF then
        updateRainbowText(Distance, BallSpeed, SpamRadius, Min)
       else
        TL.Text = ""
      end
    end)
 else
        LP:Kick("环境异常，请稍后再试")
    end
end)
