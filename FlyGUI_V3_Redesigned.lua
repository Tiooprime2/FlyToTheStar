-- ╔═══════════════════════════════════════╗
-- ║          FLY GUI V3  •  BY XNEO       ║
-- ║         Redesigned UI by Claude       ║
-- ╚═══════════════════════════════════════╝

local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local StarterGui    = game:GetService("StarterGui")
local TweenService  = game:GetService("TweenService")

local lp   = Players.LocalPlayer
local pg   = lp:WaitForChild("PlayerGui")

-- ┌─────────────────────────────────────┐
-- │           THEME CONFIG              │
-- └─────────────────────────────────────┘
local THEME = {
    BG_DARK       = Color3.fromRGB(13,  13,  18),   -- main bg
    BG_MID        = Color3.fromRGB(19,  19,  30),   -- panel bg
    BG_TITLEBAR   = Color3.fromRGB(10,  10,  16),   -- titlebar
    ACCENT        = Color3.fromRGB(124, 58,  237),  -- purple accent
    ACCENT_LIGHT  = Color3.fromRGB(167, 139, 250),  -- lighter purple
    BTN_NORMAL    = Color3.fromRGB(20,  20,  35),   -- button rest
    BTN_HOVER     = Color3.fromRGB(30,  30,  50),   -- button hover
    BORDER        = Color3.fromRGB(42,  42,  58),   -- border
    TEXT_PRIMARY  = Color3.fromRGB(212, 197, 255),
    TEXT_MUTED    = Color3.fromRGB(100, 100, 154),
    TEXT_DIM      = Color3.fromRGB(50,  50,  80),
    RED           = Color3.fromRGB(231, 76,  106),
    YELLOW        = Color3.fromRGB(245, 197, 66),
    TOGGLE_OFF    = Color3.fromRGB(28,  28,  46),
    TOGGLE_ON     = Color3.fromRGB(91,  33,  182),
    KNOB_OFF      = Color3.fromRGB(58,  58,  90),
    KNOB_ON       = Color3.fromRGB(224, 212, 255),
    DOT_OFF       = Color3.fromRGB(42,  42,  69),
    DOT_ON        = Color3.fromRGB(124, 58,  237),
    UP_HOVER      = Color3.fromRGB(59,  130, 246),
    DOWN_HOVER    = Color3.fromRGB(99,  102, 241),
}

-- ┌─────────────────────────────────────┐
-- │         HELPER FUNCTIONS            │
-- └─────────────────────────────────────┘
local function corner(inst, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = inst
    return c
end

local function stroke(inst, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or THEME.BORDER
    s.Thickness = thickness or 1
    s.Parent = inst
    return s
end

local function tween(inst, props, dur, style, dir)
    TweenService:Create(
        inst,
        TweenInfo.new(dur or 0.18, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props
    ):Play()
end

local function label(parent, text, size, font, color, ax, ay)
    local l = Instance.new("TextLabel")
    l.Parent          = parent
    l.Text            = text
    l.TextSize        = size or 13
    l.Font            = font or Enum.Font.GothamBold
    l.TextColor3      = color or THEME.TEXT_PRIMARY
    l.BackgroundTransparency = 1
    l.Size            = UDim2.new(1, 0, 1, 0)
    l.TextXAlignment  = ax or Enum.TextXAlignment.Center
    l.TextYAlignment  = ay or Enum.TextYAlignment.Center
    return l
end

local function button(parent, text, size, pos, bg, textColor, font, textSize)
    local f = Instance.new("TextButton")
    f.Parent          = parent
    f.Size            = size
    f.Position        = pos
    f.BackgroundColor3= bg or THEME.BTN_NORMAL
    f.Text            = text
    f.TextColor3      = textColor or THEME.TEXT_MUTED
    f.Font            = font or Enum.Font.GothamBold
    f.TextSize        = textSize or 11
    f.AutoButtonColor = false
    corner(f, 8)
    stroke(f, THEME.BORDER, 1)
    return f
end

-- ┌─────────────────────────────────────┐
-- │           BUILD THE GUI             │
-- └─────────────────────────────────────┘
local screen = Instance.new("ScreenGui")
screen.Name             = "FlyGuiV3"
screen.ResetOnSpawn     = false
screen.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
screen.Parent           = pg

-- Main window frame
local win = Instance.new("Frame")
win.Name              = "Window"
win.Parent            = screen
win.BackgroundColor3  = THEME.BG_DARK
win.Size              = UDim2.new(0, 220, 0, 0)  -- height will be set below
win.Position          = UDim2.new(0.5, -110, 0.5, -110)
win.ClipsDescendants  = false
corner(win, 14)
stroke(win, THEME.BORDER, 1)

-- Inner glow highlight at top
local topGlow = Instance.new("Frame")
topGlow.Parent            = win
topGlow.BackgroundColor3  = Color3.fromRGB(255, 255, 255)
topGlow.BackgroundTransparency = 0.94
topGlow.Size              = UDim2.new(1, -2, 0, 1)
topGlow.Position          = UDim2.new(0, 1, 0, 1)
topGlow.BorderSizePixel   = 0
corner(topGlow, 14)

-- Version badge (floating above)
local badge = Instance.new("TextLabel")
badge.Parent              = win
badge.Text                = "V3.0"
badge.Font                = Enum.Font.Code
badge.TextSize            = 9
badge.TextColor3          = THEME.ACCENT
badge.BackgroundColor3    = THEME.BG_DARK
badge.Size                = UDim2.new(0, 44, 0, 16)
badge.Position            = UDim2.new(0.5, -22, 0, -9)
badge.ZIndex              = 5
corner(badge, 8)
stroke(badge, THEME.BORDER, 1)

-- ── TITLE BAR ──────────────────────────
local titleBar = Instance.new("Frame")
titleBar.Name             = "TitleBar"
titleBar.Parent           = win
titleBar.BackgroundColor3 = THEME.BG_TITLEBAR
titleBar.Size             = UDim2.new(1, 0, 0, 36)
titleBar.Position         = UDim2.new(0, 0, 0, 0)
titleBar.ZIndex           = 2
corner(titleBar, 14)

-- Round bottom corners of titlebar back to 0
local titleBtmFix = Instance.new("Frame")
titleBtmFix.Parent            = titleBar
titleBtmFix.BackgroundColor3  = THEME.BG_TITLEBAR
titleBtmFix.Size              = UDim2.new(1, 0, 0, 14)
titleBtmFix.Position          = UDim2.new(0, 0, 1, -14)
titleBtmFix.BorderSizePixel   = 0
titleBtmFix.ZIndex            = 2

local titleText = Instance.new("TextLabel")
titleText.Parent              = titleBar
titleText.Text                = "FLY  GUI"
titleText.Font                = Enum.Font.GothamBold
titleText.TextSize            = 13
titleText.TextColor3          = THEME.ACCENT_LIGHT
titleText.BackgroundTransparency = 1
titleText.Size                = UDim2.new(1, 0, 1, 0)
titleText.TextXAlignment      = Enum.TextXAlignment.Center
titleText.LetterSpacing       = 4
titleText.ZIndex              = 3

-- Window buttons container
local winBtns = Instance.new("Frame")
winBtns.Parent              = titleBar
winBtns.BackgroundTransparency = 1
winBtns.Size                = UDim2.new(0, 44, 0, 20)
winBtns.Position            = UDim2.new(1, -52, 0.5, -10)
winBtns.ZIndex              = 4

local btnLayout = Instance.new("UIListLayout")
btnLayout.FillDirection     = Enum.FillDirection.Horizontal
btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
btnLayout.Padding           = UDim.new(0, 5)
btnLayout.SortOrder         = Enum.SortOrder.LayoutOrder
btnLayout.Parent            = winBtns

local function winDot(parent, color, order)
    local d = Instance.new("TextButton")
    d.Parent              = parent
    d.BackgroundColor3    = color
    d.Size                = UDim2.new(0, 10, 0, 10)
    d.Text                = ""
    d.AutoButtonColor     = false
    d.LayoutOrder         = order
    corner(d, 10)
    d.MouseEnter:Connect(function() tween(d, {Size=UDim2.new(0,12,0,12)}) end)
    d.MouseLeave:Connect(function() tween(d, {Size=UDim2.new(0,10,0,10)}) end)
    return d
end

local closeBtn = winDot(winBtns, THEME.RED, 2)
local miniBtn  = winDot(winBtns, THEME.YELLOW, 1)

-- Draggable title bar
titleBar.Active    = true
titleBar.Draggable = false
win.Active         = true
win.Draggable      = true

-- ── BODY ───────────────────────────────
local body = Instance.new("Frame")
body.Name             = "Body"
body.Parent           = win
body.BackgroundTransparency = 1
body.Size             = UDim2.new(1, 0, 0, 184)
body.Position         = UDim2.new(0, 0, 0, 38)

local bodyLayout = Instance.new("UIListLayout")
bodyLayout.Padding         = UDim.new(0, 8)
bodyLayout.SortOrder       = Enum.SortOrder.LayoutOrder
bodyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
bodyLayout.Parent          = body

local bodyPad = Instance.new("UIPadding")
bodyPad.PaddingLeft   = UDim.new(0, 10)
bodyPad.PaddingRight  = UDim.new(0, 10)
bodyPad.PaddingTop    = UDim.new(0, 10)
bodyPad.PaddingBottom = UDim.new(0, 10)
bodyPad.Parent        = body

-- ── FLIGHT TOGGLE CARD ─────────────────
local flyCard = Instance.new("Frame")
flyCard.Name              = "FlyCard"
flyCard.Parent            = body
flyCard.BackgroundColor3  = THEME.BG_MID
flyCard.Size              = UDim2.new(1, 0, 0, 50)
flyCard.LayoutOrder       = 1
corner(flyCard, 9)
stroke(flyCard, THEME.BORDER, 1)

local flyTitleLbl = Instance.new("TextLabel")
flyTitleLbl.Parent           = flyCard
flyTitleLbl.Text             = "FLIGHT"
flyTitleLbl.Font             = Enum.Font.GothamBold
flyTitleLbl.TextSize         = 11
flyTitleLbl.TextColor3       = THEME.TEXT_MUTED
flyTitleLbl.BackgroundTransparency = 1
flyTitleLbl.Size             = UDim2.new(0, 80, 0, 16)
flyTitleLbl.Position         = UDim2.new(0, 10, 0, 8)
flyTitleLbl.TextXAlignment   = Enum.TextXAlignment.Left

local flyStatusLbl = Instance.new("TextLabel")
flyStatusLbl.Parent          = flyCard
flyStatusLbl.Text            = "OFFLINE"
flyStatusLbl.Font            = Enum.Font.Code
flyStatusLbl.TextSize        = 9
flyStatusLbl.TextColor3      = THEME.TEXT_DIM
flyStatusLbl.BackgroundTransparency = 1
flyStatusLbl.Size            = UDim2.new(0, 80, 0, 14)
flyStatusLbl.Position        = UDim2.new(0, 10, 0, 28)
flyStatusLbl.TextXAlignment  = Enum.TextXAlignment.Left

-- Toggle pill
local pillOuter = Instance.new("Frame")
pillOuter.Parent           = flyCard
pillOuter.BackgroundColor3 = THEME.TOGGLE_OFF
pillOuter.Size             = UDim2.new(0, 40, 0, 20)
pillOuter.Position         = UDim2.new(1, -50, 0.5, -10)
corner(pillOuter, 10)
stroke(pillOuter, THEME.BORDER, 1)

local pillKnob = Instance.new("Frame")
pillKnob.Parent           = pillOuter
pillKnob.BackgroundColor3 = THEME.KNOB_OFF
pillKnob.Size             = UDim2.new(0, 14, 0, 14)
pillKnob.Position         = UDim2.new(0, 2, 0.5, -7)
corner(pillKnob, 10)

-- Clickable overlay on pill
local pillBtn = Instance.new("TextButton")
pillBtn.Parent              = pillOuter
pillBtn.Size                = UDim2.new(1, 0, 1, 0)
pillBtn.BackgroundTransparency = 1
pillBtn.Text                = ""
pillBtn.ZIndex              = 3

-- Status indicator dot
local statusDot = Instance.new("Frame")
statusDot.Parent           = flyCard
statusDot.BackgroundColor3 = THEME.DOT_OFF
statusDot.Size             = UDim2.new(0, 5, 0, 5)
statusDot.Position         = UDim2.new(1, -14, 0.5, -2)
corner(statusDot, 10)

-- ── DIVIDER ────────────────────────────
local div = Instance.new("Frame")
div.Parent            = body
div.BackgroundColor3  = THEME.BORDER
div.Size              = UDim2.new(1, 0, 0, 1)
div.LayoutOrder       = 2

-- ── SPEED CARD ─────────────────────────
local speedCard = Instance.new("Frame")
speedCard.Name             = "SpeedCard"
speedCard.Parent           = body
speedCard.BackgroundTransparency = 1
speedCard.Size             = UDim2.new(1, 0, 0, 30)
speedCard.LayoutOrder      = 3

local speedLbl = Instance.new("TextLabel")
speedLbl.Parent           = speedCard
speedLbl.Text             = "SPEED"
speedLbl.Font             = Enum.Font.GothamBold
speedLbl.TextSize         = 10
speedLbl.TextColor3       = THEME.TEXT_MUTED
speedLbl.BackgroundTransparency = 1
speedLbl.Size             = UDim2.new(0, 70, 1, 0)
speedLbl.Position         = UDim2.new(0, 0, 0, 0)
speedLbl.TextXAlignment   = Enum.TextXAlignment.Left

local speedCtrl = Instance.new("Frame")
speedCtrl.Parent           = speedCard
speedCtrl.BackgroundColor3 = THEME.BG_MID
speedCtrl.Size             = UDim2.new(0, 90, 1, 0)
speedCtrl.Position         = UDim2.new(1, -90, 0, 0)
corner(speedCtrl, 8)
stroke(speedCtrl, THEME.BORDER, 1)

local minusBtn = Instance.new("TextButton")
minusBtn.Parent           = speedCtrl
minusBtn.BackgroundTransparency = 1
minusBtn.Size             = UDim2.new(0, 26, 1, 0)
minusBtn.Position         = UDim2.new(0, 0, 0, 0)
minusBtn.Text             = "−"
minusBtn.Font             = Enum.Font.Code
minusBtn.TextSize         = 16
minusBtn.TextColor3       = THEME.TEXT_MUTED
minusBtn.AutoButtonColor  = false

local speedDivL = Instance.new("Frame")
speedDivL.Parent           = speedCtrl
speedDivL.BackgroundColor3 = THEME.BORDER
speedDivL.Size             = UDim2.new(0, 1, 1, 0)
speedDivL.Position         = UDim2.new(0, 26, 0, 0)

local speedValLbl = Instance.new("TextLabel")
speedValLbl.Parent          = speedCtrl
speedValLbl.Text            = "1"
speedValLbl.Font            = Enum.Font.Code
speedValLbl.TextSize        = 13
speedValLbl.TextColor3      = THEME.TEXT_PRIMARY
speedValLbl.BackgroundTransparency = 1
speedValLbl.Size            = UDim2.new(0, 36, 1, 0)
speedValLbl.Position        = UDim2.new(0, 27, 0, 0)
speedValLbl.TextXAlignment  = Enum.TextXAlignment.Center

local speedDivR = Instance.new("Frame")
speedDivR.Parent           = speedCtrl
speedDivR.BackgroundColor3 = THEME.BORDER
speedDivR.Size             = UDim2.new(0, 1, 1, 0)
speedDivR.Position         = UDim2.new(0, 63, 0, 0)

local plusBtn = Instance.new("TextButton")
plusBtn.Parent            = speedCtrl
plusBtn.BackgroundTransparency = 1
plusBtn.Size              = UDim2.new(0, 26, 1, 0)
plusBtn.Position          = UDim2.new(0, 64, 0, 0)
plusBtn.Text              = "+"
plusBtn.Font              = Enum.Font.Code
plusBtn.TextSize          = 16
plusBtn.TextColor3        = THEME.TEXT_MUTED
plusBtn.AutoButtonColor   = false

-- ── MOVE BUTTONS ───────────────────────
local upBtn = button(body,
    "▲  ASCEND",
    UDim2.new(1, 0, 0, 30),
    UDim2.new(0, 0, 0, 0),
    THEME.BTN_NORMAL,
    THEME.TEXT_MUTED
)
upBtn.LayoutOrder = 4

local downBtn = button(body,
    "▼  DESCEND",
    UDim2.new(1, 0, 0, 30),
    UDim2.new(0, 0, 0, 0),
    THEME.BTN_NORMAL,
    THEME.TEXT_MUTED
)
downBtn.LayoutOrder = 5

-- ── FOOTER ─────────────────────────────
local footer = Instance.new("Frame")
footer.Name              = "Footer"
footer.Parent            = win
footer.BackgroundTransparency = 1
footer.Size              = UDim2.new(1, 0, 0, 22)
footer.Position          = UDim2.new(0, 0, 0, 224)

local creditLbl = Instance.new("TextLabel")
creditLbl.Parent          = footer
creditLbl.Text            = "BY XNEO"
creditLbl.Font            = Enum.Font.Code
creditLbl.TextSize        = 8
creditLbl.TextColor3      = THEME.TEXT_DIM
creditLbl.BackgroundTransparency = 1
creditLbl.Size            = UDim2.new(0, 80, 1, 0)
creditLbl.Position        = UDim2.new(0, 12, 0, 0)
creditLbl.TextXAlignment  = Enum.TextXAlignment.Left

local footerDot = Instance.new("Frame")
footerDot.Parent           = footer
footerDot.BackgroundColor3 = THEME.DOT_OFF
footerDot.Size             = UDim2.new(0, 5, 0, 5)
footerDot.Position         = UDim2.new(1, -14, 0.5, -2)
corner(footerDot, 10)

win.Size = UDim2.new(0, 220, 0, 248)

-- ── MINIMIZED BAR ──────────────────────
local miniBar = Instance.new("Frame")
miniBar.Name              = "MiniBar"
miniBar.Parent            = screen
miniBar.BackgroundColor3  = THEME.BG_TITLEBAR
miniBar.Size              = UDim2.new(0, 220, 0, 30)
miniBar.Position          = win.Position
miniBar.Visible           = false
corner(miniBar, 10)
stroke(miniBar, THEME.BORDER, 1)
miniBar.Active    = true
miniBar.Draggable = true

local miniTitle = Instance.new("TextLabel")
miniTitle.Parent          = miniBar
miniTitle.Text            = "FLY GUI V3"
miniTitle.Font            = Enum.Font.GothamBold
miniTitle.TextSize        = 11
miniTitle.TextColor3      = THEME.ACCENT_LIGHT
miniTitle.BackgroundTransparency = 1
miniTitle.Size            = UDim2.new(1, -60, 1, 0)
miniTitle.Position        = UDim2.new(0, 12, 0, 0)
miniTitle.TextXAlignment  = Enum.TextXAlignment.Left

local maximizeBtn = Instance.new("TextButton")
maximizeBtn.Parent           = miniBar
maximizeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 48)
maximizeBtn.Size             = UDim2.new(0, 22, 0, 18)
maximizeBtn.Position         = UDim2.new(1, -54, 0.5, -9)
maximizeBtn.Text             = "+"
maximizeBtn.Font             = Enum.Font.GothamBold
maximizeBtn.TextSize         = 12
maximizeBtn.TextColor3       = THEME.ACCENT_LIGHT
maximizeBtn.AutoButtonColor  = false
corner(maximizeBtn, 5)
stroke(maximizeBtn, THEME.BORDER, 1)

local miniCloseBtn = Instance.new("TextButton")
miniCloseBtn.Parent           = miniBar
miniCloseBtn.BackgroundColor3 = THEME.RED
miniCloseBtn.Size             = UDim2.new(0, 18, 0, 18)
miniCloseBtn.Position         = UDim2.new(1, -26, 0.5, -9)
miniCloseBtn.Text             = ""
miniCloseBtn.AutoButtonColor  = false
corner(miniCloseBtn, 9)

-- ────────────────────────────────────────────────
--           STATE & LOGIC
-- ────────────────────────────────────────────────
local nowe      = false
local speeds    = 1
local tpwalking = false

local function getChar()  return lp.Character end
local function getHum()   return getChar() and getChar():FindFirstChildWhichIsA("Humanoid") end
local function getRootPart() return getChar() and getChar():FindFirstChild("HumanoidRootPart") end

-- Update toggle visuals
local function setFlyVisual(on)
    tween(pillOuter, {BackgroundColor3 = on and THEME.TOGGLE_ON or THEME.TOGGLE_OFF}, 0.22)
    tween(pillKnob,  {Position = on and UDim2.new(0,24,0.5,-7) or UDim2.new(0,2,0.5,-7), BackgroundColor3 = on and THEME.KNOB_ON or THEME.KNOB_OFF}, 0.22)
    tween(statusDot, {BackgroundColor3 = on and THEME.DOT_ON or THEME.DOT_OFF}, 0.22)
    tween(footerDot, {BackgroundColor3 = on and THEME.DOT_ON or THEME.DOT_OFF}, 0.22)
    flyStatusLbl.Text      = on and "ACTIVE" or "OFFLINE"
    flyStatusLbl.TextColor3 = on and THEME.ACCENT_LIGHT or THEME.TEXT_DIM
end

-- Set all humanoid states
local function setAllStates(value)
    local hum = getHum()
    if not hum then return end
    local states = {
        Enum.HumanoidStateType.Climbing, Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Flying,   Enum.HumanoidStateType.Freefall,
        Enum.HumanoidStateType.GettingUp, Enum.HumanoidStateType.Jumping,
        Enum.HumanoidStateType.Landed,   Enum.HumanoidStateType.Physics,
        Enum.HumanoidStateType.PlatformStanding, Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.Running,  Enum.HumanoidStateType.RunningNoPhysics,
        Enum.HumanoidStateType.Seated,   Enum.HumanoidStateType.StrafingNoPhysics,
        Enum.HumanoidStateType.Swimming,
    }
    for _, s in ipairs(states) do
        hum:SetStateEnabled(s, value)
    end
end

-- Spawn tp-walking coroutines
local function spawnWalkers()
    tpwalking = false
    wait()
    tpwalking = true
    for _ = 1, speeds do
        spawn(function()
            local hb  = RunService.Heartbeat
            local chr = getChar()
            local hum = getHum()
            while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                if hum.MoveDirection.Magnitude > 0 then
                    chr:TranslateBy(hum.MoveDirection)
                end
            end
        end)
    end
end

-- Fly loop for R6
local function flyR6()
    local char  = getChar()
    local torso = char and char:FindFirstChild("Torso")
    if not torso then return end

    local ctrl      = {f=0,b=0,l=0,r=0}
    local lastctrl  = {f=0,b=0,l=0,r=0}
    local maxspeed  = 50
    local spd       = 0

    local bg = Instance.new("BodyGyro", torso)
    bg.P = 9e4; bg.maxTorque = Vector3.new(9e9,9e9,9e9); bg.cframe = torso.CFrame
    local bv = Instance.new("BodyVelocity", torso)
    bv.velocity = Vector3.new(0,0.1,0); bv.maxForce = Vector3.new(9e9,9e9,9e9)
    getHum().PlatformStand = true

    while nowe do
        RunService.RenderStepped:Wait()
        if ctrl.l+ctrl.r ~= 0 or ctrl.f+ctrl.b ~= 0 then
            spd = math.min(spd + 0.5 + spd/maxspeed, maxspeed)
        elseif spd ~= 0 then
            spd = math.max(spd - 1, 0)
        end
        local cam = workspace.CurrentCamera.CoordinateFrame
        if (ctrl.l+ctrl.r) ~= 0 or (ctrl.f+ctrl.b) ~= 0 then
            bv.velocity = ((cam.lookVector*(ctrl.f+ctrl.b)) + ((cam*CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - cam.p))*spd
            lastctrl = {f=ctrl.f,b=ctrl.b,l=ctrl.l,r=ctrl.r}
        elseif spd ~= 0 then
            bv.velocity = ((cam.lookVector*(lastctrl.f+lastctrl.b)) + ((cam*CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - cam.p))*spd
        else
            bv.velocity = Vector3.new(0,0,0)
        end
        bg.cframe = cam * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*spd/maxspeed),0,0)
    end

    bg:Destroy(); bv:Destroy()
    getHum().PlatformStand = false
    lp.Character.Animate.Disabled = false
    tpwalking = false
end

-- Fly loop for R15
local function flyR15()
    local char       = getChar()
    local upperTorso = char and char:FindFirstChild("UpperTorso")
    if not upperTorso then return end

    local ctrl     = {f=0,b=0,l=0,r=0}
    local lastctrl = {f=0,b=0,l=0,r=0}
    local maxspeed = 50
    local spd      = 0

    local bg = Instance.new("BodyGyro", upperTorso)
    bg.P = 9e4; bg.maxTorque = Vector3.new(9e9,9e9,9e9); bg.cframe = upperTorso.CFrame
    local bv = Instance.new("BodyVelocity", upperTorso)
    bv.velocity = Vector3.new(0,0.1,0); bv.maxForce = Vector3.new(9e9,9e9,9e9)
    getHum().PlatformStand = true

    while nowe do
        wait()
        if ctrl.l+ctrl.r ~= 0 or ctrl.f+ctrl.b ~= 0 then
            spd = math.min(spd + 0.5 + spd/maxspeed, maxspeed)
        elseif spd ~= 0 then
            spd = math.max(spd - 1, 0)
        end
        local cam = workspace.CurrentCamera.CoordinateFrame
        if (ctrl.l+ctrl.r) ~= 0 or (ctrl.f+ctrl.b) ~= 0 then
            bv.velocity = ((cam.lookVector*(ctrl.f+ctrl.b)) + ((cam*CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - cam.p))*spd
            lastctrl = {f=ctrl.f,b=ctrl.b,l=ctrl.l,r=ctrl.r}
        elseif spd ~= 0 then
            bv.velocity = ((cam.lookVector*(lastctrl.f+lastctrl.b)) + ((cam*CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - cam.p))*spd
        else
            bv.velocity = Vector3.new(0,0,0)
        end
        bg.cframe = cam * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*spd/maxspeed),0,0)
    end

    bg:Destroy(); bv:Destroy()
    getHum().PlatformStand = false
    lp.Character.Animate.Disabled = false
    tpwalking = false
end

-- ────────────────────────────────────────────────
--           BUTTON INTERACTIONS
-- ────────────────────────────────────────────────

-- Fly toggle
pillBtn.MouseButton1Click:Connect(function()
    nowe = not nowe
    setFlyVisual(nowe)

    if not nowe then
        -- Turning off
        setAllStates(true)
        getHum():ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
    else
        -- Turning on
        spawnWalkers()
        local char = getChar()
        if char then
            char.Animate.Disabled = true
            local hum = getHum()
            if hum then
                for _, t in next, hum:GetPlayingAnimationTracks() do
                    t:AdjustSpeed(0)
                end
            end
        end
        setAllStates(false)
        getHum():ChangeState(Enum.HumanoidStateType.Swimming)

        local hum = getHum()
        if hum and hum.RigType == Enum.HumanoidRigType.R6 then
            spawn(flyR6)
        else
            spawn(flyR15)
        end
    end
end)

-- UP button
local movingUp = false
upBtn.MouseButton1Down:Connect(function()
    movingUp = true
    tween(upBtn, {BackgroundColor3 = Color3.fromRGB(20,40,80), TextColor3 = Color3.fromRGB(147,197,253)}, 0.12)
    spawn(function()
        while movingUp do
            wait()
            local rp = getRootPart()
            if rp then rp.CFrame = rp.CFrame * CFrame.new(0,1,0) end
        end
    end)
end)
upBtn.MouseButton1Up:Connect(function()
    movingUp = false
    tween(upBtn, {BackgroundColor3 = THEME.BTN_NORMAL, TextColor3 = THEME.TEXT_MUTED}, 0.15)
end)
upBtn.MouseLeave:Connect(function()
    movingUp = false
    tween(upBtn, {BackgroundColor3 = THEME.BTN_NORMAL, TextColor3 = THEME.TEXT_MUTED}, 0.15)
end)
upBtn.MouseEnter:Connect(function()
    tween(upBtn, {BackgroundColor3 = Color3.fromRGB(20,35,70), TextColor3 = Color3.fromRGB(147,197,253)}, 0.12)
end)

-- DOWN button
local movingDown = false
downBtn.MouseButton1Down:Connect(function()
    movingDown = true
    tween(downBtn, {BackgroundColor3 = Color3.fromRGB(28,28,70), TextColor3 = Color3.fromRGB(165,180,252)}, 0.12)
    spawn(function()
        while movingDown do
            wait()
            local rp = getRootPart()
            if rp then rp.CFrame = rp.CFrame * CFrame.new(0,-1,0) end
        end
    end)
end)
downBtn.MouseButton1Up:Connect(function()
    movingDown = false
    tween(downBtn, {BackgroundColor3 = THEME.BTN_NORMAL, TextColor3 = THEME.TEXT_MUTED}, 0.15)
end)
downBtn.MouseLeave:Connect(function()
    movingDown = false
    tween(downBtn, {BackgroundColor3 = THEME.BTN_NORMAL, TextColor3 = THEME.TEXT_MUTED}, 0.15)
end)
downBtn.MouseEnter:Connect(function()
    tween(downBtn, {BackgroundColor3 = Color3.fromRGB(24,24,58), TextColor3 = Color3.fromRGB(165,180,252)}, 0.12)
end)

-- Speed buttons
plusBtn.MouseButton1Click:Connect(function()
    speeds = speeds + 1
    speedValLbl.Text = tostring(speeds)
    if nowe then spawnWalkers() end
    tween(plusBtn, {TextColor3 = THEME.ACCENT_LIGHT}, 0.1)
    wait(0.15)
    tween(plusBtn, {TextColor3 = THEME.TEXT_MUTED}, 0.15)
end)

minusBtn.MouseButton1Click:Connect(function()
    if speeds <= 1 then
        speedValLbl.Text = "MIN"
        wait(1)
        speedValLbl.Text = "1"
        return
    end
    speeds = speeds - 1
    speedValLbl.Text = tostring(speeds)
    if nowe then spawnWalkers() end
    tween(minusBtn, {TextColor3 = THEME.ACCENT_LIGHT}, 0.1)
    wait(0.15)
    tween(minusBtn, {TextColor3 = THEME.TEXT_MUTED}, 0.15)
end)

-- Window controls
closeBtn.MouseButton1Click:Connect(function()
    tween(win, {BackgroundTransparency = 1, Size = UDim2.new(0,220,0,0)}, 0.2)
    wait(0.2)
    screen:Destroy()
end)

miniBtn.MouseButton1Click:Connect(function()
    miniBar.Position = win.Position
    win.Visible      = false
    miniBar.Visible  = true
end)

maximizeBtn.MouseButton1Click:Connect(function()
    win.Position = miniBar.Position
    miniBar.Visible = false
    win.Visible     = true
end)

miniCloseBtn.MouseButton1Click:Connect(function()
    screen:Destroy()
end)

-- Respawn handler
lp.CharacterAdded:Connect(function()
    wait(0.7)
    local c = lp.Character
    if c then
        local h = c:FindFirstChildWhichIsA("Humanoid")
        if h then
            h.PlatformStand = false
        end
        local anim = c:FindFirstChild("Animate")
        if anim then
            anim.Disabled = false
        end
    end
    if nowe then
        nowe = false
        setFlyVisual(false)
    end
end)

-- ── NOTIFICATION ──────────────────────
StarterGui:SetCore("SendNotification", {
    Title    = "FLY GUI V3",
    Text     = "Loaded! BY XNEO  •  Dark Edition",
    Duration = 5,
})

print("[FlyGUI V3] Loaded — Dark Edition")
