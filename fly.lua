-- ╔══════════════════════════════════════╗
-- ║        FLY GUI V3 — fly.lua          ║
-- ║   Jalankan SETELAH ui.lua!           ║
-- ╚══════════════════════════════════════╝

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local lp = Players.LocalPlayer

-- Tunggu ui.lua selesai load
local timeout = 0
repeat
    wait(0.1)
    timeout = timeout + 0.1
until _G.FlyGUI or timeout >= 10

if not _G.FlyGUI then
    warn("[fly.lua] ERROR: ui.lua belum dijalankan! Load ui.lua dulu.")
    return
end

-- Ambil semua referensi dari ui.lua
local UI         = _G.FlyGUI
local pillBtn    = UI.pillBtn
local plusB      = UI.plusB
local minusB     = UI.minusB
local upBtn      = UI.upBtn
local downBtn    = UI.downBtn
local speedVal   = UI.speedVal
local upRow      = UI.upRow
local downRow    = UI.downRow
local setFlyVisual = UI.setFlyVisual
local C          = UI.C
local tw         = UI.tw

-- ┌──────────────────────────────────────┐
-- │              STATE                   │
-- └──────────────────────────────────────┘
local nowe      = false
local speeds    = 1
local tpwalking = false

-- ┌──────────────────────────────────────┐
-- │            HELPERS                   │
-- └──────────────────────────────────────┘
local function getChar()     return lp.Character end
local function getHum()      local c=getChar() return c and c:FindFirstChildWhichIsA("Humanoid") end
local function getRootPart() local c=getChar() return c and c:FindFirstChild("HumanoidRootPart") end

local function setAllStates(val)
    local hum = getHum()
    if not hum then return end
    for _, s in ipairs({
        Enum.HumanoidStateType.Climbing,
        Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Flying,
        Enum.HumanoidStateType.Freefall,
        Enum.HumanoidStateType.GettingUp,
        Enum.HumanoidStateType.Jumping,
        Enum.HumanoidStateType.Landed,
        Enum.HumanoidStateType.Physics,
        Enum.HumanoidStateType.PlatformStanding,
        Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.Running,
        Enum.HumanoidStateType.RunningNoPhysics,
        Enum.HumanoidStateType.Seated,
        Enum.HumanoidStateType.StrafingNoPhysics,
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

-- ┌──────────────────────────────────────┐
-- │            FLY LOOP                  │
-- └──────────────────────────────────────┘
local function flyLoop(torso, useRenderStepped)
    local ctrl     = {f=0,b=0,l=0,r=0}
    local lastctrl = {f=0,b=0,l=0,r=0}
    local maxspeed = 50
    local spd      = 0

    local bg = Instance.new("BodyGyro", torso)
    bg.P          = 9e4
    bg.maxTorque  = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe     = torso.CFrame

    local bv = Instance.new("BodyVelocity", torso)
    bv.velocity  = Vector3.new(0, 0.1, 0)
    bv.maxForce  = Vector3.new(9e9, 9e9, 9e9)

    local hum = getHum()
    if hum then hum.PlatformStand = true end

    while nowe do
        if useRenderStepped then
            RunService.RenderStepped:Wait()
        else
            wait()
        end

        if ctrl.l+ctrl.r ~= 0 or ctrl.f+ctrl.b ~= 0 then
            spd = math.min(spd + 0.5 + spd/maxspeed, maxspeed)
        elseif spd ~= 0 then
            spd = math.max(spd - 1, 0)
        end

        local cam = workspace.CurrentCamera.CoordinateFrame
        if (ctrl.l+ctrl.r) ~= 0 or (ctrl.f+ctrl.b) ~= 0 then
            bv.velocity = ((cam.lookVector*(ctrl.f+ctrl.b))
                + ((cam*CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - cam.p)) * spd
            lastctrl = {f=ctrl.f, b=ctrl.b, l=ctrl.l, r=ctrl.r}
        elseif spd ~= 0 then
            bv.velocity = ((cam.lookVector*(lastctrl.f+lastctrl.b))
                + ((cam*CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - cam.p)) * spd
        else
            bv.velocity = Vector3.new(0, 0, 0)
        end

        bg.cframe = cam * CFrame.Angles(
            -math.rad((ctrl.f+ctrl.b) * 50 * spd/maxspeed), 0, 0)
    end

    -- Cleanup
    bg:Destroy()
    bv:Destroy()
    local h = getHum()
    if h then h.PlatformStand = false end
    local c = getChar()
    if c then
        local anim = c:FindFirstChild("Animate")
        if anim then anim.Disabled = false end
    end
    tpwalking = false
end

-- ┌──────────────────────────────────────┐
-- │         FLY TOGGLE LOGIC             │
-- └──────────────────────────────────────┘
pillBtn.MouseButton1Click:Connect(function()
    nowe = not nowe
    setFlyVisual(nowe)

    if not nowe then
        -- OFF
        setAllStates(true)
        local h = getHum()
        if h then h:ChangeState(Enum.HumanoidStateType.RunningNoPhysics) end
    else
        -- ON
        spawnWalkers()
        local c = getChar()
        if c then
            local anim = c:FindFirstChild("Animate")
            if anim then anim.Disabled = true end
            local h = getHum()
            if h then
                for _, t in next, h:GetPlayingAnimationTracks() do
                    t:AdjustSpeed(0)
                end
            end
        end
        setAllStates(false)
        local h = getHum()
        if h then h:ChangeState(Enum.HumanoidStateType.Swimming) end

        local c2 = getChar()
        if c2 then
            local h2 = getHum()
            if h2 and h2.RigType == Enum.HumanoidRigType.R6 then
                spawn(function()
                    flyLoop(c2:FindFirstChild("Torso"), true)
                end)
            else
                spawn(function()
                    flyLoop(c2:FindFirstChild("UpperTorso"), false)
                end)
            end
        end
    end
end)

-- ┌──────────────────────────────────────┐
-- │        ASCEND / DESCEND              │
-- └──────────────────────────────────────┘
local movingUp = false
upBtn.MouseButton1Down:Connect(function()
    movingUp = true
    tw(upRow, {BackgroundColor3 = Color3.fromRGB(18,18,40)}, 0.1)
    upBtn.TextColor3 = Color3.fromRGB(147, 197, 253)
    spawn(function()
        while movingUp do
            wait()
            local rp = getRootPart()
            if rp then rp.CFrame = rp.CFrame * CFrame.new(0, 1, 0) end
        end
    end)
end)
local function upRelease()
    movingUp = false
    tw(upRow, {BackgroundColor3 = C.BG2}, 0.15)
    upBtn.TextColor3 = C.TEXT_MUTED
end
upBtn.MouseButton1Up:Connect(upRelease)
upBtn.MouseLeave:Connect(upRelease)

local movingDown = false
downBtn.MouseButton1Down:Connect(function()
    movingDown = true
    tw(downRow, {BackgroundColor3 = Color3.fromRGB(20,18,42)}, 0.1)
    downBtn.TextColor3 = Color3.fromRGB(165, 180, 252)
    spawn(function()
        while movingDown do
            wait()
            local rp = getRootPart()
            if rp then rp.CFrame = rp.CFrame * CFrame.new(0, -1, 0) end
        end
    end)
end)
local function downRelease()
    movingDown = false
    tw(downRow, {BackgroundColor3 = C.BG2}, 0.15)
    downBtn.TextColor3 = C.TEXT_MUTED
end
downBtn.MouseButton1Up:Connect(downRelease)
downBtn.MouseLeave:Connect(downRelease)

-- ┌──────────────────────────────────────┐
-- │            SPEED CONTROL             │
-- └──────────────────────────────────────┘
plusB.MouseButton1Click:Connect(function()
    speeds = speeds + 1
    speedVal.Text = tostring(speeds)
    if nowe then spawnWalkers() end
end)

minusB.MouseButton1Click:Connect(function()
    if speeds <= 1 then
        speedVal.Text = "MIN"
        wait(0.8)
        speedVal.Text = "1"
        return
    end
    speeds = speeds - 1
    speedVal.Text = tostring(speeds)
    if nowe then spawnWalkers() end
end)

-- ┌──────────────────────────────────────┐
-- │          RESPAWN HANDLER             │
-- └──────────────────────────────────────┘
lp.CharacterAdded:Connect(function()
    wait(0.7)
    local c = lp.Character
    if not c then return end
    local h = c:FindFirstChildWhichIsA("Humanoid")
    if h then h.PlatformStand = false end
    local a = c:FindFirstChild("Animate")
    if a then a.Disabled = false end
    if nowe then
        nowe = false
        setFlyVisual(false)
    end
end)

-- ┌──────────────────────────────────────┐
-- │           NOTIF & DONE               │
-- └──────────────────────────────────────┘
StarterGui:SetCore("SendNotification", {
    Title    = "FLY GUI V3",
    Text     = "Ready! by Tiooprime2",
    Duration = 4,
})

print("[fly.lua] Loaded OK — semua siap!")
