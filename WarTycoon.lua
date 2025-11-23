local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LogoGui"
screenGui.Parent = game:GetService("CoreGui")

local container = Instance.new("Frame")
container.Size = UDim2.new(0, 200, 0, 80)
container.BackgroundTransparency = 1
container.Parent = screenGui

-- 检测设备类型并设置初始位置
local function isMobile()
    return game:GetService("UserInputService").TouchEnabled
end

if isMobile() then
    -- 手机端：放在左上角
    container.Position = UDim2.new(0, 10, 0, 10)
    container.AnchorPoint = Vector2.new(0, 0)
else
    -- PC端：放在右下角
    container.Position = UDim2.new(1, -210, 1, -90)
    container.AnchorPoint = Vector2.new(1, 1)
end

-- 其他代码保持不变...
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.Position = UDim2.new(0, 0, 0, 0)
background.BackgroundColor3 = Color3.new(0, 0, 0)
background.BackgroundTransparency = 0.5
background.Parent = container

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = background

local backgroundStroke = Instance.new("UIStroke")
backgroundStroke.Color = Color3.new(1, 1, 1)
backgroundStroke.Thickness = 2
backgroundStroke.Parent = background

-- 添加拖动区域
local dragHandle = Instance.new("TextButton")
dragHandle.Size = UDim2.new(1, 0, 0, 20)
dragHandle.Position = UDim2.new(0, 0, 0, 0)
dragHandle.BackgroundTransparency = 1
dragHandle.Text = "."
dragHandle.TextColor3 = Color3.new(1, 1, 1)
dragHandle.TextSize = 12
dragHandle.Font = Enum.Font.GothamBold
dragHandle.Parent = background

local innerContainer = Instance.new("Frame")
innerContainer.Size = UDim2.new(1, -20, 1, -20)
innerContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
innerContainer.AnchorPoint = Vector2.new(0.5, 0.5)
innerContainer.BackgroundTransparency = 1
innerContainer.Parent = container

local avatarImage = Instance.new("ImageLabel")
avatarImage.Size = UDim2.new(0, 40, 0, 40)
avatarImage.Position = UDim2.new(0, 0, 0.5, 0)
avatarImage.AnchorPoint = Vector2.new(0, 0.5)
avatarImage.BackgroundTransparency = 1
avatarImage.Parent = innerContainer

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, -50, 1, 0)
logoText.Position = UDim2.new(0, 50, 0.5, 0)
logoText.AnchorPoint = Vector2.new(0, 0.5)
logoText.BackgroundTransparency = 1
logoText.TextScaled = false
logoText.TextSize = 14
logoText.Font = Enum.Font.GothamBold
logoText.TextColor3 = Color3.new(1, 1, 1)
logoText.TextYAlignment = Enum.TextYAlignment.Center
logoText.TextXAlignment = Enum.TextXAlignment.Left
logoText.Parent = innerContainer

local stroke = Instance.new("UIStroke")
stroke.Thickness = 0
stroke.Color = Color3.new(0, 0, 0)
stroke.Parent = logoText

local gradient = Instance.new("UIGradient")
gradient.Parent = logoText

-- 拖动功能实现
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    container.Position = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X, 
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
    )
end

dragHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = container.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

dragHandle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        update(input)
    end
end)

local function updateGradient()
    local time = tick() * 1
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromHSV(time % 1, 1, 1)),
        ColorSequenceKeypoint.new(1/6, Color3.fromHSV((time + 1/6) % 1, 1, 1)),
        ColorSequenceKeypoint.new(2/6, Color3.fromHSV((time + 2/6) % 1, 1, 1)),
        ColorSequenceKeypoint.new(3/6, Color3.fromHSV((time + 3/6) % 1, 1, 1)),
        ColorSequenceKeypoint.new(4/6, Color3.fromHSV((time + 4/6) % 1, 1, 1)),
        ColorSequenceKeypoint.new(5/6, Color3.fromHSV((time + 5/6) % 1, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV((time + 6/6) % 1, 1, 1))
    }
end

game:GetService("RunService").RenderStepped:Connect(updateGradient)

local function updatePlayerInfo()
    local player = game.Players.LocalPlayer
    if player then
        logoText.Text = "尊贵的 AlienX 用户\n" .. player.DisplayName
        local userId = player.UserId
        local thumbUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(userId) .. "&width=48&height=48&format=png"
        avatarImage.Image = thumbUrl
    end
end

updatePlayerInfo()

getgenv().HttpService = game:GetService("HttpService")
getgenv().ReplicatedStorage = game:GetService("ReplicatedStorage")
getgenv().RocketSystem = ReplicatedStorage:WaitForChild("RocketSystem")
getgenv().Plr = game:GetService("Players")
getgenv().LP = Plr.LocalPlayer
getgenv().C_NPlayers = {}

local fov = 0
local maxDistance = 50
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Cam = workspace.CurrentCamera

local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 0.5
FOVring.Color = Color3.new(1, 1, 1)
FOVring.Filled = false
FOVring.Radius = fov
FOVring.Position = Cam.ViewportSize / 0.5

local autoAimEnabled = false
local fovVisible = false
local ignoreCover = false
local aimTarget = "敌对"
local aimPosition = "Head"
local fovColor = Color3.new(1, 1, 1)
local rainbowEnabled = false

local ToggleButton
local buttonPosition = UDim2.new(0, 10, 0, 10)
local function updateDrawings()
  FOVring.Position = Cam.ViewportSize / 2
end
local function onKeyDown(input)
  if input.KeyCode == Enum.KeyCode.Delete then
    RunService:UnbindFromRenderStep("FOVUpdate")
    FOVring:Remove()
  end
end
UserInputService.InputBegan:Connect(onKeyDown)
local function lookAt(target)
  local lookVector = (target - Cam.CFrame.Position).unit
  local newCFrame = CFrame.new(Cam.CFrame.Position, Cam.CFrame.Position + lookVector)
  Cam.CFrame = newCFrame
end
local function getClosestPlayerInFOV(trg_part)
  local nearest = nil
  local last = math.huge
  local playerMousePos = Cam.ViewportSize / 2
  for _, player in ipairs(Plr:GetPlayers()) do
    if player ~= LP and (aimTarget == "全部" or player.TeamColor ~= LP.TeamColor) then
      local character = player.Character
      local humanoid = character and character:FindFirstChildOfClass("Humanoid")
      local part = character and character:FindFirstChild(trg_part)
      if part and humanoid and humanoid.Health > 0 then
        local ePos, isVisible = Cam:WorldToViewportPoint(part.Position)
        local distance = (Vector2.new(ePos.x, ePos.y) - playerMousePos).Magnitude
        if distance < last and isVisible and distance < fov then
          if (part.Position - Cam.CFrame.Position).Magnitude <= tonumber(maxDistance) then
            if not ignoreCover or #Cam:GetPartsObscuringTarget({part.Position}, {character, LP.Character}) == 0 then
              last = distance
              nearest = player
            end
          end
        end
      end
    end
  end
  return nearest
end
local function updateToggleButtonImage()
  if autoAimEnabled then
    ToggleButton.Image = "rbxassetid://7733765307"
  else
    ToggleButton.Image = "rbxassetid://7733992469"
  end
end
local function createToggleButton()
  local ScreenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
  ToggleButton = Instance.new("ImageButton", ScreenGui)
  ToggleButton.Size = UDim2.new(0, 40, 0, 40)
  ToggleButton.Position = buttonPosition
  ToggleButton.BackgroundTransparency = 1
  ToggleButton.Image = "rbxassetid://7733992469"
  updateToggleButtonImage()
  ToggleButton.MouseButton1Click:Connect(function()
    autoAimEnabled = not autoAimEnabled
    updateToggleButtonImage()
  end)
  local dragging = false
  local dragInput
  local dragStart
  local startPos
  local function update(input)
    local delta = input.Position - dragStart
    ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    buttonPosition = ToggleButton.Position
  end
  ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragging = true
      dragStart = input.Position
      startPos = ToggleButton.Position
      input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
          dragging = false
        end
      end)
    end
  end)
  ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
      dragInput = input
    end
  end)
  UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
      update(input)
    end
  end)
end
createToggleButton()
RunService.RenderStepped:Connect(function()
  updateDrawings()
  if autoAimEnabled then
    local closestPlayer = getClosestPlayerInFOV(aimPosition)
    if closestPlayer and closestPlayer.Character:FindFirstChild(aimPosition) then
      lookAt(closestPlayer.Character[aimPosition].Position)
    end
  end
  if rainbowEnabled then
    local t = tick() * 2
    local r = math.abs(math.sin(t))
    local g = math.abs(math.sin(t + 2 * math.pi / 3))
    local b = math.abs(math.sin(t + 4 * math.pi / 3))
    FOVring.Color = Color3.new(r, g, b)
  end
end)
LP.CharacterAdded:Connect(function()
  if ToggleButton then
    buttonPosition = ToggleButton.Position
    ToggleButton:Destroy()
  end
  createToggleButton()
end)
hookfunction(getnamecallmethod, function()
  return
end)
for i, v in pairs({request, loadstring, base64.decode}) do
  if isfunctionhooked(v) or not isfunctionhooked(getnamecallmethod) then
    return
  end
end
return(function()
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
  if true then
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
      Content = "战争大亨",
      Duration = 5,
    })

    local Window = WindUI:CreateWindow({
      Title = "AlienX / 战争大亨",
      Icon = "rbxassetid://4483362748",
      IconThemed = true,
      Author = "AlienX",
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
      Title = "打开脚本",
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
    function Tg(a, b, c, d)
      return a:Toggle({Title = b, Image = "bird", Value = c, Callback = d})
    end
    function Sld(a, b, c, d, e, f)
      return a:Slider({Title = b, Step = 1, Value = {Min = c, Max = d, Default = e}, Callback = f})
    end
    A = AddTab("传送功能","rbxassetid://3944688398")
    B = AddTab("自动功能","rbxassetid://4450736564")
    C = AddTab("辅助功能","rbxassetid://4483362458")
    D = AddTab("自瞄功能","rbxassetid://4483345998")
    E = AddTab("攻击功能","rbxassetid://4384392464")

    MainSection = Window:Section({
      Title = "其他功能",
      Opened = true,
    })

    F = AddTab("调试功能","rbxassetid://3944677737")

    Window:SelectTab(1)

    local Spd, JP, HH, SB, NC, PartOfCharacter, Positions = LP.Character.Humanoid.WalkSpeed, LP.Character.Humanoid.JumpPower, LP.Character.Humanoid.HipHeight, 0, false, {}, {["Alpha"] = CFrame.new(-1197, 65, -4790), ["Bravo"] = CFrame.new(-220, 65, -4919), ["Charlie"] = CFrame.new(797, 65, -4740), ["Delta"] = CFrame.new(2044, 65, -3984), ["Echo"] = CFrame.new(2742, 65, -3031), ["Foxtrot"] = CFrame.new(3045, 65, -1788), ["Golf"] = CFrame.new(3376, 65, -562), ["Hotel"] = CFrame.new(3290, 65, 587), ["Juliet"] = CFrame.new(2955, 65, 1804), ["Kilo"] = CFrame.new(2569, 65, 2926), ["Lima"] = CFrame.new(989, 65, 3419), ["Omega"] = CFrame.new(-319, 65, 3932), ["Romeo"] = CFrame.new(-1479, 65, 3722), ["Sierra"] = CFrame.new(-2528, 65, 2549), ["Tango"] = CFrame.new(-3018, 65, 1503), ["Victor"] = CFrame.new(-3587, 65, 634), ["Yankee"] = CFrame.new(-3957, 65, -287), ["Zulu"] = CFrame.new(-4049, 65, -1334)}

    Btn(A, "当前玩家基地: " .. LP.Team.Name, function() end)
    A:Dropdown({Title = "传送基地", Values = {"Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "Juliet", "Kilo", "Lima", "Omega", "Romeo", "Sierra", "Tango", "Victor", "Yankee", "Zulu"}, Value = "Alpha", Callback = function(d) LP.Character:PivotTo(Positions[d]) end})

    local AutoXZ = false
    Tg(B, "自动箱子", false, function(t)
      AutoXZ = t
      local TweenService = game:GetService("TweenService")
      local Players = game:GetService("Players")
      local LocalPlayer = Players.LocalPlayer
      local Crate = workspace["Game Systems"]["Crate Workspace"]
      local Oil = workspace.Tycoon.Tycoons[LocalPlayer.Team.Name].Essentials["Oil Collector"]
      local Tween = TweenService:Create(LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(), {
        CFrame = Oil:WaitForChild("CratePromptPart").CFrame
      })
      while AutoXZ and task.wait() do
        for _, v in Crate:GetChildren() do
          if not AutoXZ then
            break
          end
          local StealPrompt = v:WaitForChild("StealPrompt")
          if StealPrompt.Enabled then
            StealPrompt.MaxActivationDistance = 10
            LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
            StealPrompt.PromptShown:Wait()
            task.wait(1)
            StealPrompt:InputHoldBegin()
            StealPrompt.Triggered:Wait()
            Tween:Play()
            Oil:WaitForChild("CratePromptPart"):WaitForChild("SellPrompt").PromptShown:Wait()
            task.wait(1)
            fireproximityprompt(Oil:WaitForChild("CratePromptPart"):WaitForChild("SellPrompt"))
          end
        end
      end
    end)

    B:Divider()

    B:Button({
      Title = "自动油桶",
      Desc = "正在开发中..",
      Locked = true,
    })

    B:Button({
      Title = "自动升级",
      Desc = "正在开发中..",
      Locked = true,
    })

    B:Button({
      Title = "自动重生",
      Desc = "正在开发中..",
      Locked = true,
    })

    B:Button({
      Title = "自动空投",
      Desc = "正在开发中..",
      Locked = true,
    })

    Btn(C, "删除摔落伤害", function()
      game:GetService("ReplicatedStorage").ACS_Engine.Events.FDMG:destroy()
    end)
    Btn(C, "删除所有门", function()
      local tycoons = workspace:FindFirstChild("Tycoon")
      if not tycoons then
        return
      end
      tycoons = tycoons:FindFirstChild("Tycoons")
      if not tycoons then
        return
      end
      for _, tycoon in ipairs(tycoons:GetChildren()) do
        local purchasedObjects = tycoon:FindFirstChild("PurchasedObjects")
        if purchasedObjects then
          for _, obj in ipairs(purchasedObjects:GetChildren()) do
            local lowerName = obj.Name:lower()
            if lowerName:match("door") or lowerName:match("gate") then
              obj:Destroy()
            end
          end
        end
      end
    end)
    Tg(C, "交互按钮无CD", false, function(t)
      if t then
        if not connection then
          connection = game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
            prompt.HoldDuration = 0
          end)
        end
      else
        if connection then
          connection:Disconnect()
        end
      end
    end)
    Tg(D, "玩家自瞄", false, function(t)
      autoAimEnabled = t
    end)
    Tg(D, "显示范围", false, function(t)
      fovVisible = t
      FOVring.Visible = fovVisible
    end)
    Tg(D, "掩体不瞄", false, function(t)
      ignoreCover = t
    end)
    Sld(D, "自瞄范围", 1, 200, fov, function(s)
      fov = tonumber(s)
      FOVring.Radius = fov
    end)
    Sld(D, "自瞄距离", 1, 1200, maxDistance, function(s)
      maxDistance = tonumber(s)
    end)
    Sld(D, "自瞄圈粗细", 1, 10, FOVring.Thickness, function(s)
      FOVring.Thickness = tonumber(s)
    end)
    D:Dropdown({Title = "选择自瞄目标", Values = {"敌对", "全部"}, Value = "敌对", Callback = function(d) aimTarget = d end})
    D:Dropdown({Title = "选择自瞄位置", Values = {"头部", "躯干"}, Value = "头部", Callback = function(d)
      if d == "头部" then
        aimPosition = "Head"
      elseif d == "躯干" then
        aimPosition = "Torso"
      end
    end})
    D:Dropdown({Title = "选择圈的颜色", Values = {"红", "黄", "蓝", "绿", "青", "紫", "彩虹"}, Value = "红", Callback = function(d)
      if d == "彩虹" then
        rainbowEnabled = true
      else
        rainbowEnabled = false
        local colors = {
          ["红"] = Color3.new(1, 0, 0),
          ["黄"] = Color3.new(1, 1, 0),
          ["蓝"] = Color3.new(0, 0, 1),
          ["绿"] = Color3.new(0, 1, 0),
          ["青"] = Color3.new(0, 1, 1),
          ["紫"] = Color3.new(1, 0, 1)
        }
        FOVring.Color = colors[d]
      end
    end})

    local excludeTargetsDropdown = E:Dropdown({Title = "不攻击的玩家(多选)", Values = PlayerList, Value = {}, Multi = true, AllowNone = true, Callback = function(d) getgenv().C_NPlayers = d or {} end})
    local excludeAttackActive = false
    Btn(E, "刷新玩家列表", function()
      excludeTargetsDropdown:Refresh(PlayerList)
    end)
    Btn(E, "获取RPG", function()
      local Players = game:GetService("Players")
      local localPlayer = Players.LocalPlayer
      local TycoonsFolder = workspace.Tycoon.Tycoons
      local savedPosition
      local function findNearestTeleportPosition()
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local playerPosition = humanoidRootPart.Position
        local closestDistance = math.huge
        local closestCFrame = nil
        for _, tycoonModel in ipairs(TycoonsFolder:GetChildren()) do
          if tycoonModel:IsA("Model") then
            local purchasedObjects = tycoonModel:FindFirstChild("PurchasedObjects")
            if purchasedObjects then
              local rpgGiver = purchasedObjects:FindFirstChild("RPG Giver")
              if rpgGiver then
                local prompt = rpgGiver:FindFirstChild("Prompt")
                if prompt and prompt:IsA("BasePart") then
                  local distance = (playerPosition - prompt.Position).Magnitude
                  if distance < closestDistance then
                    closestDistance = distance
                    closestCFrame = prompt.CFrame
                  end
                end
              end
            end
          end
        end
        return closestCFrame
      end
      local function teleportPlayer()
        local character = localPlayer.Character
        if not character then
          return
        end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
          savedPosition = humanoidRootPart.CFrame
        end
        local targetCFrame = findNearestTeleportPosition()
        if targetCFrame then
          humanoidRootPart.CFrame = targetCFrame
          spawn(function()
            while wait(0.5) do
              if not character.Parent then
                break
              end
              local backpack = localPlayer:FindFirstChild("Backpack")
              if backpack and backpack:FindFirstChild("RPG") then
                humanoidRootPart.CFrame = savedPosition
                break
              end
            end
          end)
        else
          WindUI:Notify({
            Title = "ERROR",
            Content = "未能找到附近的RPG",
            Duration = 4,
          })
        end
      end
      teleportPlayer()
    end)
    local loopActive = false
    local rpgAttackThread = nil
    Tg(E, "RPG轰炸", false, function(t)
      loopActive = t
      if t then
        if rpgAttackThread then
          coroutine.close(rpgAttackThread)
          rpgAttackThread = nil
        end
        rpgAttackThread = coroutine.create(function()
          local Players = game:GetService("Players")
          local LocalPlayer = Players.LocalPlayer
          local ReplicatedStorage = game:GetService("ReplicatedStorage")
          local RocketSystem = ReplicatedStorage:WaitForChild("RocketSystem")
          local FireRocket = RocketSystem.Events.FireRocket
          local RocketHit = RocketSystem.Events.RocketHit
          local attackPhase = "attack"
          local phaseStartTime = os.clock()
          while loopActive do
            local currentTime = os.clock()
            local elapsed = currentTime - phaseStartTime
            if not loopActive then break end
            if attackPhase == "attack" then
              if elapsed >= 3 then
                attackPhase = "pause"
                phaseStartTime = os.clock()
              else
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                  local attackPosition = character.HumanoidRootPart.Position + Vector3.new(0, 1000, 0)
                  local weapon = character:FindFirstChild("RPG")
                  if weapon then
                    for _, player in ipairs(Players:GetPlayers()) do
                      if player ~= LocalPlayer and player.Character and not table.find(C_NPlayers, player.Name) then
                        local target = player.Character:FindFirstChild("HumanoidRootPart")
                        if target then
                          FireRocket:InvokeServer(Vector3.new(), weapon, weapon, attackPosition)
                          RocketHit:FireServer(attackPosition, Vector3.new(), weapon, weapon, target, nil, "asdfghvcqawRocket4")
                          task.wait(0.3)
                        end
                      end
                    end
                  end
                end
              end
            elseif attackPhase == "pause" then
              if elapsed >= 2 then
                attackPhase = "attack"
                phaseStartTime = os.clock()
              end
            end
            task.wait(0.1)
          end
        end)
        coroutine.resume(rpgAttackThread)
      else
        if rpgAttackThread then
          coroutine.close(rpgAttackThread)
          rpgAttackThread = nil
        end
      end
    end)
    local shieldAttackActive = false
    local shieldAttackThread = nil
    Tg(E, "护盾攻击", false, function(t)
      shieldAttackActive = t
      if t then
        if shieldAttackThread then
          coroutine.close(shieldAttackThread)
          shieldAttackThread = nil
        end
        shieldAttackThread = coroutine.create(function()
          while shieldAttackActive do
            if not shieldAttackActive then break end
            local rpg = LP.Character:FindFirstChild("RPG")
            if not rpg then
              task.wait(1)
              continue
            end
            local attackPosition = LP.Character.HumanoidRootPart.Position + Vector3.new(0, 1000, 0)
            local tycoonFolder = workspace:WaitForChild("Tycoon"):WaitForChild("Tycoons")
            for _, tycoon in ipairs(tycoonFolder:GetChildren()) do
              if not shieldAttackActive then break end
              if tycoon.Owner.Value ~= LP then
                local shield = tycoon:FindFirstChild("PurchasedObjects", true)
                and tycoon.PurchasedObjects:FindFirstChild("Base Shield", true)
                and tycoon.PurchasedObjects["Base Shield"]:FindFirstChild("Shield", true)
                and tycoon.PurchasedObjects["Base Shield"].Shield:FindFirstChild("Shield4", true)
                if shield then
                  local fireArgs = { Vector3.new(0, 0, 0), rpg, rpg, attackPosition }
                  for _ = 1, 2 do
                    local hitArgs = {attackPosition, Vector3.new(0, -1, 0), rpg, rpg, shield, nil, string.format("%sRocket%d", string.char(math.random(65, 90)), math.random(1, 1000))}
                    RocketSystem.Events.RocketHit:FireServer(unpack(hitArgs))
                    RocketSystem.Events.FireRocket:InvokeServer(unpack(fireArgs))
                    task.wait(0.3)
                  end
                end
              end
            end
            task.wait(0.3)
          end
        end)
        coroutine.resume(shieldAttackThread)
      else
        if shieldAttackThread then
          coroutine.close(shieldAttackThread)
          shieldAttackThread = nil
        end
      end
    end)
  else
    LP:Kick("环境异常，请稍后再试")
  end
end)()
