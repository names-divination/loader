-- ====================================================================
-- loader script  解析しようとするんじゃねーよ
-- ====================================================================
local rawHttpGet = game.HttpGet
local rawGetHwid = gethwid
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- あなたのGASのウェブアプリURL
local GAS_URL = "https://script.google.com/macros/s/AKfycbyVKql0Vm1oI1senjwWEIUZr4wf1vCR2qbGKolVMuieu8y9YFNLJC_LZVy0KEfCFEqtog/exec?"

local robloxId = tostring(LocalPlayer.UserId)
local hwid = tostring(rawGetHwid())

local requestUrl = GAS_URL .. "robloxid=" .. robloxId .. "&hwid=" .. hwid

-- 1. GASへ認証リクエスト（URLを受け取る）
local success, result = pcall(function()
    return rawHttpGet(game, requestUrl)
end)

-- 認証失敗、またはURLの形式（http）が含まれていない場合はキック
if not success or result == "false" or not result:find("http") then
    LocalPlayer:Kick("❌ 認証エラー: 権限がありません。")
    return
end

-- 2. GASから受け取ったURL（result）から本スクリプトを取得
local mainScriptSuccess, mainScriptContent = pcall(function()
    return rawHttpGet(game, result)
end)

-- 3. 本スクリプトの実行
if mainScriptSuccess and mainScriptContent and mainScriptContent ~= "" then
    local runScript = loadstring(mainScriptContent)
    if runScript then
        runScript()
    else
        LocalPlayer:Kick("❌ スクリプトの構文エラー（コンパイル失敗）")
    end
else
    LocalPlayer:Kick("❌ 本スクリプトの読み込みに失敗しました。")
end
