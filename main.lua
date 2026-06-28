-- ====================================================================
-- loader script 　解析しようとするんじゃねーよ
-- ====================================================================
local rawHttpGet = game.HttpGet
local rawGetHwid = gethwid
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local GAS_URL = "https://script.google.com/macros/s/AKfycbzqOMV8dsue82XaWWMwXsgdTaHcA2Vzu88k9GnSYaJDcBzot4LGDTBy-S6_2qJWBySmZA/exec?"

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
