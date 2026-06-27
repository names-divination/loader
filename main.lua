-- ====================================================================
-- loader script　　これ見ても無駄じゃぼけ
-- ====================================================================
local rawHttpGet = game.HttpGet -- フック対策：本物のHttpGetを退避
local rawGetHwid = gethwid
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local GAS_URL = "https://script.google.com/macros/s/AKfycbxhGZa_ugpBhydg8yWlF-f4bs7GCJLfnaLsDFv7AKSJ0BqEDJ528NPjXUQ2cpYvGLHnbQ/exec?"

local robloxId = tostring(LocalPlayer.UserId)
local hwid = tostring(rawGetHwid())

local requestUrl = GAS_URL .. "robloxid=" .. robloxId .. "&hwid=" .. hwid
local success, result = pcall(function()
    return rawHttpGet(game, requestUrl)
end)

if not success or result == "false" or not result:find("http") then
    LocalPlayer:Kick("❌ 認証エラー: 権限がありません。")
    return
end

local mainScriptSuccess, mainScriptContent = pcall(function()
    return rawHttpGet(game, result)
