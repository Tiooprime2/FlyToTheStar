-- ╔══════════════════════════════════════╗
-- ║        FLY GUI V3  •  BY XNEO        ║
-- ║    Fixed + Dark Green Style          ║
-- ╚══════════════════════════════════════╝
-- FIXES:
--   [x] No UIListLayout (manual absolute positioning)
--   [x] Mobile drag support (InputBegan/InputChanged)
--   [x] Correct window size & body visibility
--   [x] TiooMod-style dark + green theme

local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local StarterGui   = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")

local lp  = Players.LocalPlayer
local pg  = lp:WaitForChild("PlayerGui")

-- ┌──────────────────────────────────────┐
-- │             THEME                    │
-- └──────────────────────────────────────┘
local C = {
    BG          = Color3.fromRGB(15,  17,  20),
    BG2         = Color3.fromRGB(20,  23,  28),
    BG3         = Color3.fromRGB(26,  30,  36),
    BORDER      = Color3.fromRGB(40,  46,  54),
    GREEN       = Color3.fromRGB(34,  197, 94),
    GREEN_DIM   = Color3.fromRGB(22,  101, 52),
    GREEN_BG    = Color3.fromRGB(16,  40,  24),
    TEXT        = Color3.fromRGB(220, 230, 220),
    TEXT_MUTED  = Color3.fromRGB(100, 120, 105),
    TEXT_DIM    = Color3.fromRGB(50,  60,  55),
    RED         = Color3.fromRGB(220, 60,  80),
    YELLOW      = Color3.fromRGB(240, 185, 50),
    ON_ROW      = Color3.fromRGB(16,  40,  24),
    OFF_TOGGLE  = Color3.fromRGB(30,  35,  40),
    KNOB_OFF    = Color3.fromRGB(70,  80,  75),
    KNOB_ON     = Color3.fromRGB(220, 255, 230),
}

-- ┌──────────────────────────────────────┐
-- │            HELPERS                   │
-- └──────────────────────────────────────┘
local function corner(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = inst
end

local function stroke(inst, color, thick)
    local s = Instance.new("UIStroke")
    s.Color     = color or C.BORDER
    s.Thickness = thick or 1
    s.Parent    = inst
end

local function tw(inst, props, t, style)
    TweenService:Create(
        inst,
        TweenInfo.new(t or 0.18, style or Enum.EasingStyle.Quad),
        props
    ):Play()
end

local function mkFrame(parent, bg, size, pos, clips)
    local f = Instance.new("Frame")
    f.Parent             = parent
    f.BackgroundColor3   = bg
    f.Size               = size
    f.Position           = pos or UDim2.new(0,0,0,0)
    f.BorderSizePixel    = 0
    f.ClipsDescendants   = clips or false
    return f
end

local function mkLabel(parent, text, size, font, color, halign)
    local l = Instance.new("TextLabel")
    l.Parent                 = parent
    l.Text                   = text
    l.TextSize               = size or 13
    l.Font                   = font or Enum.Font.GothamBold
    l.TextColor3             = color or C.TEXT
    l.BackgroundTransparency = 1
    l.Size                   = UDim2.new(1,0,1,0)
    l.TextXAlignment         = halign or Enum.TextXAlignment.Left
    l.TextYAlignment         = Enum.TextYAlignment.Center
    return l
end

local function mkBtn(parent, text, size, pos, bg, tc, font, ts)
    local b = Instance.new("TextButton")
    b.Parent             = parent
    b.Text               = text
    b.Size               = size
    b.Position           = pos
    b.BackgroundColor3   = bg or C.BG3
    b.TextColor3         = tc or C.TEXT_MUTED
    b.Font               = font or Enum.Font.GothamBold
    b.TextSize           = ts or 11
    b.AutoButtonColor    = false
    b.BorderSizePixel    = 0
    return b
end

-- ┌──────────────────────────────────────┐
-- │          BUILD SCREEN GUI            │
-- └──────────────────────────────────────┘
local screen = Instance.new("ScreenGui")
screen.Name           = "FlyGuiV3"
screen.ResetOnSpawn   = false
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.Parent         = pg

-- WINDOW (fixed size, no auto-layout)
local WIN_W = 240
local WIN_H = 272

local win = mkFrame(screen, C.BG,
    UDim2.new(0, WIN_W, 0, WIN_H),
    UDim2.new(0, 20, 0.5, -WIN_H/2)
)
win.ClipsDescendants = false
corner(win, 12)
stroke(win, C.BORDER, 1)

-- Subtle top highlight line
local topLine = mkFrame(win, Color3.fromRGB(255,255,255),
    UDim2.new(0, WIN_W - 40, 0, 1),
    UDim2.new(0, 20, 0, 0)
)
topLine.BackgroundTransparency = 0.88
corner(topLine, 1)

-- ── TITLE BAR ──────────────────────────
local titleBar = mkFrame(win, C.BG2,
    UDim2.new(1, 0, 0, 38),
    UDim2.new(0, 0, 0, 0)
)
corner(titleBar, 12)
-- cover bottom corners of titlebar
local tbFix = mkFrame(titleBar, C.BG2,
    UDim2.new(1, 0, 0, 12),
    UDim2.new(0, 0, 1, -12)
)

-- Left accent bar on title
local titleAccent = mkFrame(titleBar, C.GREEN,
    UDim2.new(0, 3, 0, 18),
    UDim2.new(0, 10, 0.5, -9)
)
corner(titleAccent, 2)

-- Title text
local titleLbl = Instance.new("TextLabel")
titleLbl.Parent               = titleBar
titleLbl.Text                 = "FLY GUI"
titleLbl.Font                 = Enum.Font.GothamBold
titleLbl.TextSize             = 14
titleLbl.TextColor3           = C.TEXT
titleLbl.BackgroundTransparency = 1
titleLbl.Size                 = UDim2.new(0, 120, 1, 0)
titleLbl.Position             = UDim2.new(0, 22, 0, 0)
titleLbl.TextXAlignment       = Enum.TextXAlignment.Left

-- Subtitle
local subLbl = Instance.new("TextLabel")
subLbl.Parent               = titleBar
subLbl.Text                 = "by Tiooprime2"
subLbl.Font                 = Enum.Font.Gotham
subLbl.TextSize             = 9
subLbl.TextColor3           = C.TEXT_DIM
subLbl.BackgroundTransparency = 1
subLbl.Size                 = UDim2.new(0, 120, 0, 14)
subLbl.Position             = UDim2.new(0, 22, 0, 22)
subLbl.TextXAlignment       = Enum.TextXAlignment.Left

-- Version badge
local verBadge = mkBtn(titleBar, "V3", UDim2.new(0,30,0,16),
    UDim2.new(1,-80,0.5,-8), C.GREEN_BG, C.GREEN, Enum.Font.Code, 9)
corner(verBadge, 4)
stroke(verBadge, C.GREEN_DIM, 1)
verBadge.AutoButtonColor = false

-- Window control buttons
local function winDot(parent, color, xOffset)
    local d = Instance.new("TextButton")
    d.Parent            = parent
    d.BackgroundColor3  = color
    d.Size              = UDim2.new(0, 11, 0, 11)
    d.Position          = UDim2.new(1, xOffset, 0.5, -5)
    d.Text              = ""
    d.AutoButtonColor   = false
    d.BorderSizePixel   = 0
    corner(d, 10)
    d.MouseEnter:Connect(function() tw(d,{Size=UDim2.new(0,13,0,13),Position=UDim2.new(1,xOffset-1,0.5,-6)}) end)
    d.MouseLeave:Connect(function() tw(d,{Size=UDim2.new(0,11,0,11),Position=UDim2.new(1,xOffset,0.5,-5)}) end)
    return d
end

local closeBtn = winDot(titleBar, C.RED,    -16)
local miniBtn  = winDot(titleBar, C.YELLOW, -32)

-- ── BODY CONTENT (manual absolute positions) ──
-- Row height & gaps
local ROW_H  = 44
local ROW_Y  = 46   -- starts below titlebar
local GAP    = 6

-- helper: make a feature row
local function makeRow(yPos, icon, title, desc)
    local row = mkFrame(win, C.BG2,
        UDim2.new(1, -16, 0, ROW_H),
        UDim2.new(0, 8, 0, yPos)
    )
    corner(row, 8)
    stroke(row, C.BORDER, 1)

    -- left accent
    local acc = mkFrame(row, C.BORDER,
        UDim2.new(0, 2, 0, 22),
        UDim2.new(0, 0, 0.5, -11)
    )
    corner(acc, 2)

    -- icon
    local iconLbl = Instance.new("TextLabel")
    iconLbl.Parent               = row
    iconLbl.Text                 = icon
    iconLbl.TextSize             = 16
    iconLbl.Font                 = Enum.Font.GothamBold
    iconLbl.TextColor3           = C.TEXT_MUTED
    iconLbl.BackgroundTransparency = 1
    iconLbl.Size                 = UDim2.new(0, 28, 1, 0)
    iconLbl.Position             = UDim2.new(0, 8, 0, 0)
    iconLbl.TextXAlignment       = Enum.TextXAlignment.Center

    -- title text
    local titleT = Instance.new("TextLabel")
    titleT.Parent               = row
    titleT.Text                 = title
    titleT.Font                 = Enum.Font.GothamBold
    titleT.TextSize             = 12
    titleT.TextColor3           = C.TEXT
    titleT.BackgroundTransparency = 1
    titleT.Size                 = UDim2.new(0, 120, 0, 20)
    titleT.Position             = UDim2.new(0, 38, 0, 6)
    titleT.TextXAlignment       = Enum.TextXAlignment.Left

    -- desc text
    local descT = Instance.new("TextLabel")
    descT.Parent               = row
    descT.Text                 = desc
    descT.Font                 = Enum.Font.Gotham
    descT.TextSize             = 9
    descT.TextColor3           = C.TEXT_DIM
    descT.BackgroundTransparency = 1
    descT.Size                 = UDim2.new(0, 120, 0, 14)
    descT.Position             = UDim2.new(0, 38, 0, 24)
    descT.TextXAlignment       = Enum.TextXAlignment.Left

    return row, acc, iconLbl
end

-- ── ROW 1: FLIGHT ──────────────────────
local flyRow, flyAcc, flyIcon = makeRow(ROW_Y, "✦", "Flight", "Tap to activate")

-- Toggle pill for flight
local pill = mkFrame(flyRow, C.OFF_TOGGLE,
    UDim2.new(0, 44, 0, 22),
    UDim2.new(1, -52, 0.5, -11)
)
corner(pill, 11)
stroke(pill, C.BORDER, 1)

local knob = mkFrame(pill, C.KNOB_OFF,
    UDim2.new(0, 16, 0, 16),
    UDim2.new(0, 2, 0.5, -8)
)
corner(knob, 10)

local pillBtn = mkBtn(pill, "", UDim2.new(1,0,1,0), UDim2.new(0,0,0,0),
    Color3.fromRGB(0,0,0), C.TEXT)
pillBtn.BackgroundTransparency = 1
pillBtn.ZIndex = 4

local statusLbl = Instance.new("TextLabel")
statusLbl.Parent               = pill
statusLbl.Text                 = "OFF"
statusLbl.Font                 = Enum.Font.Code
statusLbl.TextSize             = 8
statusLbl.TextColor3           = C.TEXT_DIM
statusLbl.BackgroundTransparency = 1
statusLbl.Size                 = UDim2.new(1,0,1,0)
statusLbl.TextXAlignment       = Enum.TextXAlignment.Center
statusLbl.ZIndex               = 3

-- ── ROW 2: SPEED ───────────────────────
local speedRow, speedAcc, speedIcon = makeRow(ROW_Y + ROW_H + GAP, "⚡", "Speed", "Movement multiplier")

local speedCtrl = mkFrame(speedRow, C.BG3,
    UDim2.new(0, 80, 0, 26),
    UDim2.new(1, -88, 0.5, -13)
)
corner(speedCtrl, 7)
stroke(speedCtrl, C.BORDER, 1)

local minusB = mkBtn(speedCtrl, "−",
    UDim2.new(0,24,1,0), UDim2.new(0,0,0,0),
    Color3.new(0,0,0), C.TEXT_MUTED, Enum.Font.Code, 16)
minusB.BackgroundTransparency = 1

local divL = mkFrame(speedCtrl, C.BORDER, UDim2.new(0,1,1,0), UDim2.new(0,24,0,0))

local speedVal = Instance.new("TextLabel")
speedVal.Parent               = speedCtrl
speedVal.Text                 = "1"
speedVal.Font                 = Enum.Font.Code
speedVal.TextSize             = 13
speedVal.TextColor3           = C.GREEN
speedVal.BackgroundTransparency = 1
speedVal.Size                 = UDim2.new(0, 30, 1, 0)
speedVal.Position             = UDim2.new(0, 25, 0, 0)
speedVal.TextXAlignment       = Enum.TextXAlignment.Center

local divR = mkFrame(speedCtrl, C.BORDER, UDim2.new(0,1,1,0), UDim2.new(0,55,0,0))

local plusB = mkBtn(speedCtrl, "+",
    UDim2.new(0,24,1,0), UDim2.new(0,56,0,0),
    Color3.new(0,0,0), C.TEXT_MUTED, Enum.Font.Code, 16)
plusB.BackgroundTransparency = 1

-- ── ROW 3: ASCEND ──────────────────────
local upRow = mkFrame(win, C.BG2,
    UDim2.new(1,-16,0,34),
    UDim2.new(0, 8, 0, ROW_Y + (ROW_H+GAP)*2)
)
corner(upRow, 8)
stroke(upRow, C.BORDER, 1)

local upBtn = mkBtn(upRow, "▲  ASCEND",
    UDim2.new(1,0,1,0), UDim2.new(0,0,0,0),
    Color3.new(0,0,0), C.TEXT_MUTED, Enum.Font.GothamBold, 11)
upBtn.BackgroundTransparency = 1

-- ── ROW 4: DESCEND ─────────────────────
local downRow = mkFrame(win, C.BG2,
    UDim2.new(1,-16,0,34),
    UDim2.new(0, 8, 0, ROW_Y + (ROW_H+GAP)*2 + 34 + GAP)
)
corner(downRow, 8)
stroke(downRow, C.BORDER, 1)

local downBtn = mkBtn(downRow, "▼  DESCEND",
    UDim2.new(1,0,1,0), UDim2.new(0,0,0,0),
    Color3.new(0,0,0), C.TEXT_MUTED, Enum.Font.GothamBold, 11)
downBtn.BackgroundTransparency = 1

-- ── FOOTER ─────────────────────────────
local footerY = ROW_Y + (ROW_H+GAP)*2 + 34 + GAP + 34 + 8
local footer = mkFrame(win, Color3.new(0,0,0),
    UDim2.new(1,0,0,22),
    UDim2.new(0,0,0,footerY)
)
footer.BackgroundTransparency = 1

local creditLbl = Instance.new("TextLabel")
creditLbl.Parent               = footer
creditLbl.Text                 = "by Tiooprime2  •  V3"
creditLbl.Font                 = Enum.Font.Code
creditLbl.TextSize             = 8
creditLbl.TextColor3           = C.TEXT_DIM
creditLbl.BackgroundTransparency = 1
creditLbl.Size                 = UDim2.new(1,-12,1,0)
creditLbl.Position             = UDim2.new(0,12,0,0)
creditLbl.TextXAlignment       = Enum.TextXAlignment.Left

-- Adjust window height
WIN_H = footerY + 22 + 8
win.Size = UDim2.new(0, WIN_W, 0, WIN_H)

-- ── MINIMIZED BAR ──────────────────────
local miniBar = mkFrame(screen, C.BG2,
    UDim2.new(0, 180, 0, 30),
    win.Position
)
miniBar.Visible = false
corner(miniBar, 8)
stroke(miniBar, C.BORDER, 1)
miniBar.ClipsDescendants = false

local miniAcc = mkFrame(miniBar, C.GREEN, UDim2.new(0,3,0,16), UDim2.new(0,8,0.5,-8))
corner(miniAcc, 2)

local miniTitle = Instance.new("TextLabel")
miniTitle.Parent               = miniBar
miniTitle.Text                 = "FLY GUI  •  V3"
miniTitle.Font                 = Enum.Font.GothamBold
miniTitle.TextSize             = 11
miniTitle.TextColor3           = C.TEXT_MUTED
miniTitle.BackgroundTransparency = 1
miniTitle.Size                 = UDim2.new(1,-70,1,0)
miniTitle.Position             = UDim2.new(0,20,0,0)
miniTitle.TextXAlignment       = Enum.TextXAlignment.Left

local maxBtn = mkBtn(miniBar, "+",
    UDim2.new(0,22,0,18), UDim2.new(1,-48,0.5,-9),
    C.GREEN_BG, C.GREEN, Enum.Font.GothamBold, 14)
corner(maxBtn, 5)
stroke(maxBtn, C.GREEN_DIM, 1)

local mCloseBtn = mkBtn(miniBar, "",
    UDim2.new(0,18,0,18), UDim2.new(1,-24,0.5,-9),
    C.RED, C.TEXT, Enum.Font.GothamBold, 10)
corner(mCloseBtn, 9)

-- ┌──────────────────────────────────────┐
-- │        MOBILE DRAG SUPPORT           │
-- └──────────────────────────────────────┘
local function makeDraggable(frame)
    local dragging = false
    local dragStart, startPos

    local function updateDrag(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.Touch or
            input.UserInputType == Enum.UserInputType.MouseMovement
        ) then
            updateDrag(input)
        end
    end)
end

local function makeDraggableMini(frame)
    local dragging = false
    local dragStart, startPos

    miniBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    miniBar.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.Touch or
            input.UserInputType == Enum.UserInputType.MouseMovement
        ) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(win)
makeDraggableMini(miniBar)

-- ┌──────────────────────────────────────┐
-- │          FLY STATE & LOGIC           │
-- └──────────────────────────────────────┘
local nowe      = false
local speeds    = 1
local tpwalking = false

local function getChar()     return lp.Character end
local function getHum()      local c=getChar() return c and c:FindFirstChildWhichIsA("Humanoid") end
local function getRootPart() local c=getChar() return c and c:FindFirstChild("HumanoidRootPart") end

local function setFlyVisual(on)
    if on then
        tw(pill,  {BackgroundColor3 = C.GREEN_BG}, 0.2)
        tw(knob,  {Position = UDim2.new(0,26,0.5,-8), BackgroundColor3 = C.KNOB_ON}, 0.2)
        tw(flyRow,{BackgroundColor3 = C.ON_ROW}, 0.2)
        tw(flyAcc,{BackgroundColor3 = C.GREEN}, 0.2)
        statusLbl.Text       = "ON"
        statusLbl.TextColor3 = C.GREEN
        flyIcon.TextColor3   = C.GREEN
    else
        tw(pill,  {BackgroundColor3 = C.OFF_TOGGLE}, 0.2)
        tw(knob,  {Position = UDim2.new(0,2,0.5,-8), BackgroundColor3 = C.KNOB_OFF}, 0.2)
        tw(flyRow,{BackgroundColor3 = C.BG2}, 0.2)
        tw(flyAcc,{BackgroundColor3 = C.BORDER}, 0.2)
        statusLbl.Text       = "OFF"
        statusLbl.TextColor3 = C.TEXT_DIM
        flyIcon.TextColor3   = C.TEXT_MUTED
    end
end

local function setAllStates(val)
    local hum = getHum()
    if not hum then return end
    for _, s in ipairs({
        Enum.HumanoidStateType.Climbing, Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Flying,   Enum.HumanoidStateType.Freefall,
        Enum.HumanoidStateType.GettingUp,Enum.HumanoidStateType.Jumping,
        Enum.HumanoidStateType.Landed,   Enum.HumanoidStateType.Physics,
        Enum.HumanoidStateType.PlatformStanding, Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.Running,  Enum.HumanoidStateType.RunningNoPhysics,
        Enum.HumanoidStateType.Seated,   Enum.HumanoidStateType.StrafingNoPhysics,
        Enum.HumanoidStateType.Swimming,
    }) do hum:SetStateEnabled(s, val) end
end

local function spawnWalkers()
    tpwalking = false
    wait()
    tpwalking = true
    for _ = 1, speeds do
        spawn(function()
            local hb  = RunService.Heartbeat
            local chr, hum = getChar(), getHum()
            while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                if hum.MoveDirection.Magnitude > 0 then
                    chr:TranslateBy(hum.MoveDirection)
                end
            end
        end)
    end
end

local function flyLoop(torso, useRenderStepped)
    local ctrl      = {f=0,b=0,l=0,r=0}
    local lastctrl  = {f=0,b=0,l=0,r=0}
    local maxspeed  = 50
    local spd       = 0
    local bg = Instance.new("BodyGyro", torso)
    bg.P=9e4; bg.maxTorque=Vector3.new(9e9,9e9,9e9); bg.cframe=torso.CFrame
    local bv = Instance.new("BodyVelocity", torso)
    bv.velocity=Vector3.new(0,0.1,0); bv.maxForce=Vector3.new(9e9,9e9,9e9)
    getHum().PlatformStand = true
    while nowe do
        if useRenderStepped then RunService.RenderStepped:Wait() else wait() end
        if ctrl.l+ctrl.r~=0 or ctrl.f+ctrl.b~=0 then
            spd = math.min(spd+0.5+spd/maxspeed, maxspeed)
        elseif spd~=0 then spd = math.max(spd-1,0) end
        local cam = workspace.CurrentCamera.CoordinateFrame
        if (ctrl.l+ctrl.r)~=0 or (ctrl.f+ctrl.b)~=0 then
            bv.velocity=((cam.lookVector*(ctrl.f+ctrl.b))+((cam*CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p)-cam.p))*spd
            lastctrl={f=ctrl.f,b=ctrl.b,l=ctrl.l,r=ctrl.r}
        elseif spd~=0 then
            bv.velocity=((cam.lookVector*(lastctrl.f+lastctrl.b))+((cam*CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p)-cam.p))*spd
        else bv.velocity=Vector3.new(0,0,0) end
        bg.cframe=cam*CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*spd/maxspeed),0,0)
    end
    bg:Destroy(); bv:Destroy()
    local h=getHum() if h then h.PlatformStand=false end
    local c=getChar() if c and c:FindFirstChild("Animate") then c.Animate.Disabled=false end
    tpwalking=false
end

-- ┌──────────────────────────────────────┐
-- │          BUTTON LOGIC                │
-- └──────────────────────────────────────┘

-- Flight toggle
pillBtn.MouseButton1Click:Connect(function()
    nowe = not nowe
    setFlyVisual(nowe)
    if not nowe then
        setAllStates(true)
        local h=getHum() if h then h:ChangeState(Enum.HumanoidStateType.RunningNoPhysics) end
    else
        spawnWalkers()
        local c=getChar()
        if c then
            local anim=c:FindFirstChild("Animate")
            if anim then anim.Disabled=true end
            local h=getHum()
            if h then for _,t in next,h:GetPlayingAnimationTracks() do t:AdjustSpeed(0) end end
        end
        setAllStates(false)
        local h=getHum() if h then h:ChangeState(Enum.HumanoidStateType.Swimming) end
        local c2=getChar()
        if c2 then
            local h2=getHum()
            if h2 and h2.RigType==Enum.HumanoidRigType.R6 then
                spawn(function() flyLoop(c2:FindFirstChild("Torso"), true) end)
            else
                spawn(function() flyLoop(c2:FindFirstChild("UpperTorso"), false) end)
            end
        end
    end
end)

-- UP
local movingUp = false
upBtn.MouseButton1Down:Connect(function()
    movingUp = true
    tw(upRow, {BackgroundColor3=Color3.fromRGB(16,30,50)}, 0.1)
    upBtn.TextColor3 = Color3.fromRGB(147,197,253)
    spawn(function()
        while movingUp do
            wait()
            local rp=getRootPart()
            if rp then rp.CFrame=rp.CFrame*CFrame.new(0,1,0) end
        end
    end)
end)
local function upRelease()
    movingUp = false
    tw(upRow,{BackgroundColor3=C.BG2},0.15)
    upBtn.TextColor3 = C.TEXT_MUTED
end
upBtn.MouseButton1Up:Connect(upRelease)
upBtn.MouseLeave:Connect(upRelease)
upBtn.MouseEnter:Connect(function()
    tw(upRow,{BackgroundColor3=Color3.fromRGB(18,28,44)},0.12)
    upBtn.TextColor3 = Color3.fromRGB(147,197,253)
end)

-- DOWN
local movingDown = false
downBtn.MouseButton1Down:Connect(function()
    movingDown = true
    tw(downRow,{BackgroundColor3=Color3.fromRGB(20,20,50)},0.1)
    downBtn.TextColor3 = Color3.fromRGB(165,180,252)
    spawn(function()
        while movingDown do
            wait()
            local rp=getRootPart()
            if rp then rp.CFrame=rp.CFrame*CFrame.new(0,-1,0) end
        end
    end)
end)
local function downRelease()
    movingDown = false
    tw(downRow,{BackgroundColor3=C.BG2},0.15)
    downBtn.TextColor3 = C.TEXT_MUTED
end
downBtn.MouseButton1Up:Connect(downRelease)
downBtn.MouseLeave:Connect(downRelease)
downBtn.MouseEnter:Connect(function()
    tw(downRow,{BackgroundColor3=Color3.fromRGB(22,20,46)},0.12)
    downBtn.TextColor3 = Color3.fromRGB(165,180,252)
end)

-- Speed
plusB.MouseButton1Click:Connect(function()
    speeds = speeds + 1
    speedVal.Text = tostring(speeds)
    tw(speedVal,{TextColor3=C.TEXT},0.1)
    wait(0.2)
    tw(speedVal,{TextColor3=C.GREEN},0.15)
    if nowe then spawnWalkers() end
end)
minusB.MouseButton1Click:Connect(function()
    if speeds <= 1 then
        speedVal.Text="MIN" wait(0.8) speedVal.Text="1"
        return
    end
    speeds = speeds - 1
    speedVal.Text = tostring(speeds)
    if nowe then spawnWalkers() end
end)

-- Hover speed buttons
minusB.MouseEnter:Connect(function() tw(minusB,{TextColor3=C.GREEN},0.1) end)
minusB.MouseLeave:Connect(function() tw(minusB,{TextColor3=C.TEXT_MUTED},0.1) end)
plusB.MouseEnter:Connect(function() tw(plusB,{TextColor3=C.GREEN},0.1) end)
plusB.MouseLeave:Connect(function() tw(plusB,{TextColor3=C.TEXT_MUTED},0.1) end)

-- Window controls
closeBtn.MouseButton1Click:Connect(function()
    tw(win,{Size=UDim2.new(0,WIN_W,0,0),BackgroundTransparency=1},0.2)
    wait(0.22)
    screen:Destroy()
end)

miniBtn.MouseButton1Click:Connect(function()
    miniBar.Position = win.Position
    win.Visible      = false
    miniBar.Visible  = true
end)

maxBtn.MouseButton1Click:Connect(function()
    win.Position    = miniBar.Position
    win.Visible     = true
    miniBar.Visible = false
end)

mCloseBtn.MouseButton1Click:Connect(function()
    screen:Destroy()
end)

-- Respawn reset
lp.CharacterAdded:Connect(function()
    wait(0.7)
    local c=lp.Character
    if not c then return end
    local h=c:FindFirstChildWhichIsA("Humanoid")
    if h then h.PlatformStand=false end
    local a=c:FindFirstChild("Animate")
    if a then a.Disabled=false end
    if nowe then nowe=false setFlyVisual(false) end
end)

-- ── NOTIF ──────────────────────────────
StarterGui:SetCore("SendNotification",{
    Title    = "FLY GUI V3",
    Text     = "Loaded! by Tiooprime2",
    Duration = 4,
})

print("[FlyGUI V3] OK - Fixed Edition")
