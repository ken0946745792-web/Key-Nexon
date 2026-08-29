repeat task.wait() until game:IsLoaded()
task.wait(1)

-- Chặn load lại trong cùng 1 lần vào game
if getgenv().__SCRIPT_LOADED then
    return warn("❌ Script đã được load")
end

local HttpService = game:GetService("HttpService")

-- Chống cache GitHub
local KEY_URL = "https://raw.githubusercontent.com/ken0946745792-web/Key-Nexon/main/keys.json?ts=" .. os.time()

-- Code gốc cần bảo vệ
"local PROTECTED_CODE = "getgenv().RuajadCoinFarm = {
    AutoSellEnabled       = true,                             -- Options: true / false (Auto-warps to Origins to sell items)
    Threshold             = 10000,                            -- Number only (e.g. 5000, 10000). Triggers sell when reaching this amount
    SellAmount            = 10000,                            -- Number only (e.g. 5000, 10000). Amount to sell per slot
    RequiredBatchCount    = 3,                                -- Number only (1 to 4). Number of different item types needed before selling
    FarmMode              = { "Resources" }, -- Must keep quotes! Examples: { "Food" } or { "Food", "Bones" } or { "Food", "Bones", "Resources" }
    AutoWarpWorldsEnabled = true,                             -- Options: true / false (Auto-warps to highest available farm world)
    WorldBlacklist        = {},                               -- Skip unwanted worlds. Example: { "Grasslands", "Jungle" } or {} for none
    AfkOverlayEnabled     = true,                            -- Options: true / false (Full-screen AFK status overlay with CPU saver)
}

-- [3] Coin Transfer Configuration (Market Stall Buyer)
-- Only configure this if you want the bot to automatically buy from your Main Account's market stall to transfer coins
getgenv().RuajadCoinTransfer = {
    Enabled         = false,                     -- Options: true / false (Enable coin transfer to Main Account)
    AutoEnabled     = true,                      -- Options: true / false (Background balance checker)
    MainUsername    = "MAIN_ACCOUNT",            -- Must keep quotes! Example: "Player123" (Exact Roblox username of your Main Account)
    CoinThreshold   = 100000,                    -- Number only (e.g. 50000, 100000). Warps to buy when holding this many coins
    WarpBackEnabled = true,                      -- Options: true / false (Auto-warps back to farm world after buying)
}

-- [4] Script Execution
loadstring(game:HttpGet("https://gist.githubusercontent.com/armkkk123/04b3a80254bfe4ad69564e98f9c37a1c/raw/TEST.lua"))()"

local USER_KEY = getgenv().USER_KEY
if not USER_KEY then
    return warn("❌ Chưa nhập key (Gán getgenv().USER_KEY trước khi chạy)")
end

local function toTime(dateStr)
    local y, m, d = dateStr:match("(%d+)%-(%d+)%-(%d+)")
    if not y then return 0 end
    return os.time({
        year = tonumber(y),
        month = tonumber(m),
        day = tonumber(d),
        hour = 23, min = 59, sec = 59
    })
end

local success, response = pcall(function()
    return game:HttpGet(KEY_URL)
end)

if not success then
    return warn("❌ Không thể kết nối tới server Key")
end

local data = HttpService:JSONDecode(response)
if not data or not data.keys then
    return warn("❌ Dữ liệu key lỗi hoặc không đúng định dạng JSON")
end

for _, v in ipairs(data.keys) do
    if v.key == USER_KEY then
        if os.time() > toTime(v.expire) then
            return warn("❌ Key của bạn đã hết hạn!")
        end

        getgenv().__SCRIPT_LOADED = true
        
        -- Thực thi script chính
        local mainScript, err = loadstring(game:HttpGet(PROTECTED_CODE))
        if mainScript then
            mainScript()
        else
            warn("❌ Lỗi khi tải script chính: " .. tostring(err))
        end
        return
    end
end

warn("❌ Key không tồn tại trong hệ thống")
