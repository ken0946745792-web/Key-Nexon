repeat task.wait() until game:IsLoaded()
task.wait(2)

local HttpService = game:GetService("HttpService")
local RbxAnalytics = game:GetService("RbxAnalyticsService")

-- chống cache GitHub (RẤT QUAN TRỌNG)
local KEY_URL = "https://raw.githubusercontent.com/ken0946745792-web/Key-Nexon/main/keys.json?ts=" .. os.time()

-- code cần bảo vệ
local PROTECTED_CODE = "https://api.junkie-development.de/api/v1/luascripts/public/263a72050e733e52da77bcc7f8a7542cb082be906feaf87557be0442b36e797b/download"

-- lấy key người dùng nhập
local USER_KEY = getgenv().USER_KEY
if not USER_KEY then
    return warn("❌ Chưa nhập key")
end

-- lấy HWID
local HWID = RbxAnalytics:GetClientId()

-- chuyển ngày -> timestamp
local function toTime(date)
    local y,m,d = date:match("(%d+)%-(%d+)%-(%d+)")
    return os.time({
        year = tonumber(y),
        month = tonumber(m),
        day = tonumber(d),
        hour = 23,
        min = 59,
        sec = 59
    })
end

-- load key data
local success, response = pcall(function()
    return game:HttpGet(KEY_URL)
end)

if not success then
    return warn("❌ Không tải được key server")
end

local data = HttpService:JSONDecode(response)
if not data or not data.keys then
    return warn("❌ Dữ liệu key lỗi")
end

-- check key
for _, v in ipairs(data.keys) do
    if v.key == USER_KEY then

        -- check hạn
        if os.time() > toTime(v.expire) then
            return warn("❌ Key hết hạn")
        end

        -- check HWID
        if v.hwid ~= HWID then
            return warn("❌ Key đã bind thiết bị khác")
        end

        -- OK → chạy code gốc
        loadstring(game:HttpGet(PROTECTED_CODE))()
        return
    end
end

warn("❌ K
