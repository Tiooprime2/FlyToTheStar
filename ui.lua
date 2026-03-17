-- ╔══════════════════════════════════════╗
-- ║         FLY GUI V3 — ui.lua          ║
-- ║     Dark Purple Theme by Tiooprime2  ║
-- ╚══════════════════════════════════════╝
-- Jalankan fly.lua setelah ui.lua!

local TweenService = game:GetService("TweenService")
local lp           = game:GetService("Players").LocalPlayer
local pg           = lp:WaitForChild("PlayerGui")

-- ┌──────────────────────────────────────┐
-- │              THEME                   │
-- └──────────────────────────────────────┘
local C = {
    BG          = Color3.fromRGB(13,  13,  18),
    BG2         = Color3.fromRGB(19,  19,  30),
    BG3         = Color3.fromRGB(26,  26,  40),
    BORDER      = Color3.fromRGB(42,  42,  58),
    ACCENT      = Color3.fromRGB(124, 58,  237),
    ACCENT_L    = Color3.fromRGB(167, 139, 250),
    ACCENT_BG   = Color3.fromRGB(28,  16,  56),
    ACCENT_DIM  = Color3.fromRGB(72,  40,  140),
    TEXT        = Color3.fromRGB(212, 200, 255),
    TEXT_MUTED  = Color3.fromRGB(100, 90,  140),
    TEXT_DIM    = Color3.fromRGB(50,  45,  75),
    RED         = Color3.fromRGB(220, 60,  80),
    YELLOW      = Color3.fromRGB(240, 185, 50),
    ON_ROW      = Color3.fromRGB(22,  14,  44),
    TOGGLE_OFF  = Color3.fromRGB(28,  28,  46),
    KNOB_OFF    = Color3.fromRGB(65,  60,  95),
    KNOB_ON     = Color3.fromRGB(220, 210, 255),
}

-- ┌──────────────────────────────────────┐
-- │             HELPERS                  │
-- └──────────────────────────────────────┘
local function corner(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = inst
end

local function stroke(inst, color, thick)
    local s = Instance.new("UIStroke")
    s.Color = color or C.BORDER
    s.Thickness = thick or 1
    s.Parent = inst
end

local function tw(inst, props, t)
    TweenService:Create(inst, TweenInfo.new(t or 0.18, Enum.EasingStyle.Quad), props):Play()
end

local function mkFrame(parent, bg, size, pos)
    local f = Instance.new("Frame")
    f.Parent           = parent
    f.BackgroundColor3 = bg
    f.Size             = size
    f.Position         = pos or UDim2.new(0,0,0,0)
    f.BorderSizePixel  = 0
    return f
end

local function mkBtn(parent, text, size, pos, bg, tc, font, ts)
    local b = Instance.new("TextButton")
    b.Parent           = parent
    b.Text             = text
    b.Size             = size
    b.Position         = pos
    b.BackgroundColor3 = bg or C.BG3
    b.TextColor3       = tc or C.TEXT_MUTED
    b.Font             = font or Enum.Font.GothamBold
    b.TextSize         = ts or 11
    b.AutoButtonColor  = false
    b.BorderSizePixel  = 0
    return b
end

-- ┌──────────────────────────────────────┐
-- │          BUILD SCREEN GUI            │
-- └──────────────────────────────────────┘
local screen = Instance.new("ScreenGui")
screen.Name         = "FlyGuiV3"
screen.ResetOnSpawn = false
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.Parent       = pg

local WIN_W = 240
local win = mkFrame(screen, C.BG,
    UDim2.new(0, WIN_W, 0, 10),
    UDim2.new(0, 20, 0.5, -136)
)
win.ClipsDescendants = false
corner(win, 12)
stroke(win, C.BORDER, 1)

-- Top highlight
local topLine = mkFrame(win, Color3.fromRGB(255,255,255),
    UDim2.new(0, WIN_W-40, 0, 1), UDim2.new(0, 20, 0, 0))
topLine.BackgroundTransparency = 0.88
corner(topLine, 1)

-- ── TITLE BAR ──────────────────────────
local titleBar = mkFrame(win, C.BG2,
    UDim2.new(1,0,0,38), UDim2.new(0,0,0,0))
corner(titleBar, 12)
mkFrame(titleBar, C.BG2, UDim2.new(1,0,0,12), UDim2.new(0,0,1,-12)) -- fix bottom corners

-- Accent bar
local titleAcc = mkFrame(titleBar, C.ACCENT,
    UDim2.new(0,3,0,18), UDim2.new(0,10,0.5,-9))
corner(titleAcc, 2)

local titleLbl = Instance.new("TextLabel")
titleLbl.Parent = titleBar
titleLbl.Text   = "FLY GUI"
titleLbl.Font   = Enum.Font.GothamBold
titleLbl.TextSize = 14
titleLbl.TextColor3 = C.TEXT
titleLbl.BackgroundTransparency = 1
titleLbl.Size = UDim2.new(0,120,1,0)
titleLbl.Position = UDim2.new(0,22,0,0)
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

local subLbl = Instance.new("TextLabel")
subLbl.Parent = titleBar
subLbl.Text   = "by Tiooprime2"
subLbl.Font   = Enum.Font.Gotham
subLbl.TextSize = 9
subLbl.TextColor3 = C.TEXT_DIM
subLbl.BackgroundTransparency = 1
subLbl.Size = UDim2.new(0,120,0,14)
subLbl.Position = UDim2.new(0,22,0,22)
subLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Version badge
local verBadge = mkBtn(titleBar, "V3",
    UDim2.new(0,28,0,16), UDim2.new(1,-80,0.5,-8),
    C.ACCENT_BG, C.ACCENT_L, Enum.Font.Code, 9)
corner(verBadge, 4)
stroke(verBadge, C.ACCENT_DIM, 1)

-- Window dots
local function winDot(color, xOff)
    local d = mkBtn(titleBar, "",
        UDim2.new(0,11,0,11), UDim2.new(1,xOff,0.5,-5),
        color, color)
    corner(d, 10)
    d.MouseEnter:Connect(function() tw(d,{Size=UDim2.new(0,13,0,13)}) end)
    d.MouseLeave:Connect(function() tw(d,{Size=UDim2.new(0,11,0,11)}) end)
    return d
end
local closeBtn = winDot(C.RED,    -16)
local miniBtn  = winDot(C.YELLOW, -32)

-- ── ROWS ───────────────────────────────
local ROW_H = 44
local ROW_Y = 46
local GAP   = 6

local function makeRow(yPos, icon, title, desc)
    local row = mkFrame(win, C.BG2,
        UDim2.new(1,-16,0,ROW_H), UDim2.new(0,8,0,yPos))
    corner(row, 8)
    stroke(row, C.BORDER, 1)

    local acc = mkFrame(row, C.BORDER,
        UDim2.new(0,2,0,22), UDim2.new(0,0,0.5,-11))
    corner(acc, 2)

    local ic = Instance.new("TextLabel")
    ic.Parent = row; ic.Text = icon; ic.TextSize = 15
    ic.Font = Enum.Font.GothamBold; ic.TextColor3 = C.TEXT_MUTED
    ic.BackgroundTransparency = 1
    ic.Size = UDim2.new(0,28,1,0); ic.Position = UDim2.new(0,8,0,0)
    ic.TextXAlignment = Enum.TextXAlignment.Center

    local tl = Instance.new("TextLabel")
    tl.Parent = row; tl.Text = title; tl.Font = Enum.Font.GothamBold
    tl.TextSize = 12; tl.TextColor3 = C.TEXT
    tl.BackgroundTransparency = 1
    tl.Size = UDim2.new(0,120,0,20); tl.Position = UDim2.new(0,38,0,6)
    tl.TextXAlignment = Enum.TextXAlignment.Left

    local dl = Instance.new("TextLabel")
    dl.Parent = row; dl.Text = desc; dl.Font = Enum.Font.Gotham
    dl.TextSize = 9; dl.TextColor3 = C.TEXT_DIM
    dl.BackgroundTransparency = 1
    dl.Size = UDim2.new(0,120,0,14); dl.Position = UDim2.new(0,38,0,24)
    dl.TextXAlignment = Enum.TextXAlignment.Left

    return row, acc, ic
end

-- ROW 1: Flight
local flyRow, flyAcc, flyIcon = makeRow(ROW_Y, "✦", "Flight", "Tap to activate")

local pill = mkFrame(flyRow, C.TOGGLE_OFF,
    UDim2.new(0,44,0,22), UDim2.new(1,-52,0.5,-11))
corner(pill, 11); stroke(pill, C.BORDER, 1)

local knob = mkFrame(pill, C.KNOB_OFF,
    UDim2.new(0,16,0,16), UDim2.new(0,2,0.5,-8))
corner(knob, 10)

local pillBtn = mkBtn(pill, "",
    UDim2.new(1,0,1,0), UDim2.new(0,0,0,0),
    Color3.new(0,0,0), C.TEXT)
pillBtn.BackgroundTransparency = 1
pillBtn.ZIndex = 4

local statusLbl = Instance.new("TextLabel")
statusLbl.Parent = pill; statusLbl.Text = "OFF"
statusLbl.Font = Enum.Font.Code; statusLbl.TextSize = 8
statusLbl.TextColor3 = C.TEXT_DIM
statusLbl.BackgroundTransparency = 1
statusLbl.Size = UDim2.new(1,0,1,0)
statusLbl.TextXAlignment = Enum.TextXAlignment.Center
statusLbl.ZIndex = 3

-- ROW 2: Speed
local speedRow, speedAcc, speedIcon = makeRow(ROW_Y + ROW_H + GAP, "⚡", "Speed", "Movement multiplier")

local speedCtrl = mkFrame(speedRow, C.BG3,
    UDim2.new(0,80,0,26), UDim2.new(1,-88,0.5,-13))
corner(speedCtrl, 7); stroke(speedCtrl, C.BORDER, 1)

local minusB = mkBtn(speedCtrl, "−",
    UDim2.new(0,24,1,0), UDim2.new(0,0,0,0),
    Color3.new(0,0,0), C.TEXT_MUTED, Enum.Font.Code, 16)
minusB.BackgroundTransparency = 1

mkFrame(speedCtrl, C.BORDER, UDim2.new(0,1,1,0), UDim2.new(0,24,0,0))

local speedVal = Instance.new("TextLabel")
speedVal.Parent = speedCtrl; speedVal.Text = "1"
speedVal.Font = Enum.Font.Code; speedVal.TextSize = 13
speedVal.TextColor3 = C.ACCENT_L
speedVal.BackgroundTransparency = 1
speedVal.Size = UDim2.new(0,30,1,0); speedVal.Position = UDim2.new(0,25,0,0)
speedVal.TextXAlignment = Enum.TextXAlignment.Center

mkFrame(speedCtrl, C.BORDER, UDim2.new(0,1,1,0), UDim2.new(0,55,0,0))

local plusB = mkBtn(speedCtrl, "+",
    UDim2.new(0,24,1,0), UDim2.new(0,56,0,0),
    Color3.new(0,0,0), C.TEXT_MUTED, Enum.Font.Code, 16)
plusB.BackgroundTransparency = 1

-- ROW 3: Ascend
local upRow = mkFrame(win, C.BG2,
    UDim2.new(1,-16,0,34), UDim2.new(0,8,0, ROW_Y+(ROW_H+GAP)*2))
corner(upRow, 8); stroke(upRow, C.BORDER, 1)
local upBtn = mkBtn(upRow, "▲  ASCEND",
    UDim2.new(1,0,1,0), UDim2.new(0,0,0,0),
    Color3.new(0,0,0), C.TEXT_MUTED, Enum.Font.GothamBold, 11)
upBtn.BackgroundTransparency = 1

-- ROW 4: Descend
local Y4 = ROW_Y+(ROW_H+GAP)*2+34+GAP
local downRow = mkFrame(win, C.BG2,
    UDim2.new(1,-16,0,34), UDim2.new(0,8,0, Y4))
corner(downRow, 8); stroke(downRow, C.BORDER, 1)
local downBtn = mkBtn(downRow, "▼  DESCEND",
    UDim2.new(1,0,1,0), UDim2.new(0,0,0,0),
    Color3.new(0,0,0), C.TEXT_MUTED, Enum.Font.GothamBold, 11)
downBtn.BackgroundTransparency = 1

-- Footer
local footY = Y4+34+8
local footer = mkFrame(win, Color3.new(0,0,0),
    UDim2.new(1,0,0,20), UDim2.new(0,0,0,footY))
footer.BackgroundTransparency = 1
local credLbl = Instance.new("TextLabel")
credLbl.Parent = footer; credLbl.Text = "by Tiooprime2  •  V3"
credLbl.Font = Enum.Font.Code; credLbl.TextSize = 8
credLbl.TextColor3 = C.TEXT_DIM
credLbl.BackgroundTransparency = 1
credLbl.Size = UDim2.new(1,-12,1,0); credLbl.Position = UDim2.new(0,12,0,0)
credLbl.TextXAlignment = Enum.TextXAlignment.Left

win.Size = UDim2.new(0, WIN_W, 0, footY+20+8)

-- ── MINI BAR ───────────────────────────
local miniBar = mkFrame(screen, C.BG2,
    UDim2.new(0,180,0,30), win.Position)
miniBar.Visible = false
corner(miniBar, 8); stroke(miniBar, C.BORDER, 1)

mkFrame(miniBar, C.ACCENT, UDim2.new(0,3,0,16), UDim2.new(0,8,0.5,-8))

local miniTitle = Instance.new("TextLabel")
miniTitle.Parent = miniBar; miniTitle.Text = "FLY GUI  •  V3"
miniTitle.Font = Enum.Font.GothamBold; miniTitle.TextSize = 11
miniTitle.TextColor3 = C.TEXT_MUTED
miniTitle.BackgroundTransparency = 1
miniTitle.Size = UDim2.new(1,-70,1,0); miniTitle.Position = UDim2.new(0,20,0,0)
miniTitle.TextXAlignment = Enum.TextXAlignment.Left

local maxBtn = mkBtn(miniBar, "+",
    UDim2.new(0,22,0,18), UDim2.new(1,-48,0.5,-9),
    C.ACCENT_BG, C.ACCENT_L, Enum.Font.GothamBold, 14)
corner(maxBtn, 5); stroke(maxBtn, C.ACCENT_DIM, 1)

local mCloseBtn = mkBtn(miniBar, "",
    UDim2.new(0,18,0,18), UDim2.new(1,-24,0.5,-9),
    C.RED, C.TEXT, Enum.Font.GothamBold, 10)
corner(mCloseBtn, 9)

-- ┌──────────────────────────────────────┐
-- │         MOBILE DRAG                  │
-- └──────────────────────────────────────┘
local function makeDraggable(frame, handle)
    local dragging, dragStart, startPos = false, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement then
            local d = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

makeDraggable(win,     titleBar)
makeDraggable(miniBar, miniBar)

-- ┌──────────────────────────────────────┐
-- │         UI VISUAL FUNCTIONS          │
-- └──────────────────────────────────────┘
local GUI = {}

function GUI.setFlyVisual(on)
    if on then
        tw(pill,   {BackgroundColor3 = C.ACCENT_BG}, 0.2)
        tw(knob,   {Position = UDim2.new(0,26,0.5,-8), BackgroundColor3 = C.KNOB_ON}, 0.2)
        tw(flyRow, {BackgroundColor3 = C.ON_ROW}, 0.2)
        tw(flyAcc, {BackgroundColor3 = C.ACCENT}, 0.2)
        statusLbl.Text       = "ON"
        statusLbl.TextColor3 = C.ACCENT_L
        flyIcon.TextColor3   = C.ACCENT_L
    else
        tw(pill,   {BackgroundColor3 = C.TOGGLE_OFF}, 0.2)
        tw(knob,   {Position = UDim2.new(0,2,0.5,-8), BackgroundColor3 = C.KNOB_OFF}, 0.2)
        tw(flyRow, {BackgroundColor3 = C.BG2}, 0.2)
        tw(flyAcc, {BackgroundColor3 = C.BORDER}, 0.2)
        statusLbl.Text       = "OFF"
        statusLbl.TextColor3 = C.TEXT_DIM
        flyIcon.TextColor3   = C.TEXT_MUTED
    end
end

-- ┌──────────────────────────────────────┐
-- │         WINDOW CONTROLS              │
-- └──────────────────────────────────────┘
closeBtn.MouseButton1Click:Connect(function()
    tw(win, {Size=UDim2.new(0,WIN_W,0,0), BackgroundTransparency=1}, 0.2)
    wait(0.22); screen:Destroy()
end)
miniBtn.MouseButton1Click:Connect(function()
    miniBar.Position = win.Position
    win.Visible = false; miniBar.Visible = true
end)
maxBtn.MouseButton1Click:Connect(function()
    win.Position = miniBar.Position
    win.Visible = true; miniBar.Visible = false
end)
mCloseBtn.MouseButton1Click:Connect(function()
    screen:Destroy()
end)

-- Hover: up/down rows
upBtn.MouseEnter:Connect(function()
    tw(upRow,{BackgroundColor3=Color3.fromRGB(18,18,40)},0.12)
    upBtn.TextColor3 = Color3.fromRGB(147,197,253)
end)
upBtn.MouseLeave:Connect(function()
    tw(upRow,{BackgroundColor3=C.BG2},0.15)
    upBtn.TextColor3 = C.TEXT_MUTED
end)
downBtn.MouseEnter:Connect(function()
    tw(downRow,{BackgroundColor3=Color3.fromRGB(20,18,42)},0.12)
    downBtn.TextColor3 = Color3.fromRGB(165,180,252)
end)
downBtn.MouseLeave:Connect(function()
    tw(downRow,{BackgroundColor3=C.BG2},0.15)
    downBtn.TextColor3 = C.TEXT_MUTED
end)

-- Hover: speed
plusB.MouseEnter:Connect(function()  tw(plusB,{TextColor3=C.ACCENT_L},0.1) end)
plusB.MouseLeave:Connect(function()  tw(plusB,{TextColor3=C.TEXT_MUTED},0.1) end)
minusB.MouseEnter:Connect(function() tw(minusB,{TextColor3=C.ACCENT_L},0.1) end)
minusB.MouseLeave:Connect(function() tw(minusB,{TextColor3=C.TEXT_MUTED},0.1) end)

-- ┌──────────────────────────────────────┐
-- │         EXPOSE TO fly.lua            │
-- └──────────────────────────────────────┘
-- Simpan referensi ke _G biar fly.lua bisa akses
_G.FlyGUI = {
    pillBtn  = pillBtn,
    plusB    = plusB,
    minusB   = minusB,
    upBtn    = upBtn,
    downBtn  = downBtn,
    speedVal = speedVal,
    upRow    = upRow,
    downRow  = downRow,
    setFlyVisual = GUI.setFlyVisual,
    C        = C,
    tw       = tw,
}

print("[ui.lua] Loaded OK")
