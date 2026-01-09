-- Đợi game load
repeat task.wait() until game:IsLoaded()
task.wait(6)

-- Services
local HttpService = game:GetService("HttpService")
local RbxAnalytics = game:GetService("RbxAnalyticsService")

-- ===== CẤU HÌNH =====
-- LINK RAW keys.json (ĐÃ KIỂM TRA)
local KEY_URL = "https://raw.githubusercontent.com/ken0946745792-web/Key-Nexon/main/keys.json"

-- CODE BẠN MUỐN BẢO VỆ
local PROTECTED_CODE = "https://api.junkie-development.de/api/v1/luascripts/public/263a72050e733e52da77bcc7f8a7542cb082be906feaf87557be0442b36e797b/download"
-- ====================

-- Lấy key user nhập
local USER_KEY = getgenv().USER_KEY
if not USER_KEY then
    warn("❌ Chưa nhập key")
    return
end

-- Lấy HWID
local HWID = RbxAnalytics:GetClientId()

-- Hàm chuyển ngày YYYY-MM-DD -> timestamp
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

-- Lấy dữ liệu key
local success, response = pcall(function()
    return game:HttpGet(KEY_URL)
end)

if not success then
    warn(
