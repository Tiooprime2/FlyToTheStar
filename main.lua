-- ╔══════════════════════════════════════╗
-- ║        FLY GUI V3 — main.lua         ║
-- ║          by Tiooprime2               ║
-- ╚══════════════════════════════════════╝

local BASE = "https://raw.githubusercontent.com/Tiooprime2/FlyToTheStar/main/"

loadstring(game:HttpGet(BASE .. "ui.lua"))()
wait(0.5)
loadstring(game:HttpGet(BASE .. "fly.lua"))()
