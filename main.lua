-- ====================================================================
-- loader script  解析しようとするんじゃねーよ
-- ====================================================================

local rawHttpGet = game.HttpGet
local rawGetHwid = gethwid
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GAS URL
local GAS_URL = "https://script.google.com/macros/s/AKfycbyt5DhkSFXUlxlSXl8Q3kqczX0JWfVI40XajsZ9PrjdGtDp4Ax_-XoRlxhrtl-w4CpY/exec?"

local robloxId = tostring(LocalPlayer.UserId)
local hwid = tostring(rawGetHwid())

-- ✨ 【修正】キャッシュ対策のランダム値を末尾に付与（これでGASに100%履歴が残る）
local cacheBuster = tostring(math.random(1, 100000))
local requestUrl = GAS_URL .. "robloxid=" .. robloxId .. "&hwid=" .. hwid .. "&nocache=" .. cacheBuster

-- 1. 認証通信
local success, result = pcall(function()
    return rawHttpGet(game, requestUrl)
end)

-- 通信失敗
if not success then
    local err = tostring(result)
    if err:find("DnsResolve") then
        LocalPlayer:Kick("❌ 通信失敗: DNSエラー")
    elseif err:find("Timeout") then
        LocalPlayer:Kick("❌ 通信失敗: タイムアウト")
    else
        LocalPlayer:Kick("❌ 通信失敗")
    end
    return
end

-- 2. GAS返答処理
if result == "NOT_FOUND" then
    LocalPlayer:Kick("❌ 未登録ユーザー")
    return
end

if result == "BANNED" then
    LocalPlayer:Kick("❌ アカウント停止")
    return
end

if result == "DENIED" then
    LocalPlayer:Kick("❌ アクセス拒否 (別の端末でロックされています)")
    return
end

-- URLが返ってない
if not result:find("http") then
    LocalPlayer:Kick("❌ 認証エラー")
    return
end

-- 3. 本体取得
local mainScriptSuccess, mainScriptContent = pcall(function()
    return rawHttpGet(game, result)
end)

if not mainScriptSuccess then
    LocalPlayer:Kick("❌ 通信失敗: 本体取得失敗")
    return
end

-- 4. 実行
local runScript = loadstring(mainScriptContent)

if runScript then
    runScript()
else
    LocalPlayer:Kick("❌ スクリプトエラー")
end
