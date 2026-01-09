-- Đợi game load
repeat task.wait() until game:IsLoaded()
task.wait(2)

-- Services
local HttpService = game:GetService("HttpService")
local RbxAnalytics = game:GetService("RbxAnalyticsService")

-- ===== CẤU HÌNH =====
local KEY_URL = "https://raw.githubusercontent.com/ken0946745792-web/Key-Nexon/main/keys.json"

local PROTECTED_CODE = "https://api.junkie-development.de/api/v1/luascripts/public/263a72050e733e52da77bcc7f8a7542cb082be906feaf87557be0442b36e797b/download"
-- ====================

-- Check USER_KEY
local USER_KEY = getgenv().USER_KEY
if not USER_KEY or USER_KEY == "" then
    warn("❌ Chưa nhập key")
    return
end

-- Lấy HWID
local HWID = RbxAnalytics:GetClientId()

-- Chuyển YYYY-MM-DD -> time
local function toTime(dateStr)
    local y, m, d = dateStr:match("(%d+)%-(%d+)%-(%d+)")
    if not y then return 0 end
    return os.time({
        year = tonumber(y),
        month = tonumber(m),
        day = tonumber(d),
        hour = 23,
        min = 59,
        sec = 59
    })
end

-- Load keys.json (AN TOÀN)
local ok, response = pcall(function()
    return game:HttpGet(KEY_URL)
end)

if not ok or not response then
    warn("❌ Không tải được keys.json")
    return
end

local data
pcall(function()
    data = HttpService:JSONDecode(response)
end)

if not data or not data.keys then
    warn("❌ keys.json sai format")
    return
end

-- Check key
for _, v in ipairs(data.keys) do
    if v.key == USER_KEY then

        -- Check hạn
        if os.time() > toTime(v.expire) then
            warn("❌ Key đã hết hạn")
            return
        end

        -- Check HWID
        if v.hwid ~= HWID then
            warn("❌ Key đã bị khóa trên thiết bị khác")
            return
        end

        -- Load code gốc (KHÔNG CRASH)
        local ok2, src = pcall(function()
            return game:HttpGet(PROTECTED_CODE)
        end)

        if not ok2 or not src or src == "" then
            warn("❌ Không tải được code gốc")
            return
        end

        local fn = loadstring(src)
        if not fn then
            warn("❌ loadstring thất bại")
            return
        end

        fn()
        return
    end
end

warn("❌ Key không tồn tại")
